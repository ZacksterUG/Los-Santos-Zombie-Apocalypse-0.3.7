// y_dialog - does stuff with dialogs.

#include <YSI\internal\y_version>

#include <YSI\y_master>
#include <YSI\y_bit>

#include <YSI\y_remote>

#include <YSI\y_inline>

#include <YSI\y_hooks>

#include <YSI\y_amx>

#if !defined MAX_DIALOGS
	#define MAX_DIALOGS (2000)
#endif

// This is actually QUITE A LOT of data, I should maybe sort that out.
static stock
	BitArray:YSI_g_sIDs<MAX_DIALOGS> = {Bit:-1, ...},
	BitArray:YSI_g_sFree<MAX_DIALOGS>,
	YSI_g_sPlayerDialog[MAX_PLAYERS] = {-1, ...},
	YSI_g_sDialogPlayers[MAX_DIALOGS],
	YSI_g_sDialogMasters[MAX_DIALOGS] = {-1, ...},
	YSI_g_sDialogInfo[MAX_DIALOGS][E_CALLBACK_DATA];

/*stock Dialog_ObtainID()
{
	new
		data = Dialog_DoObtainID();
	YSI_g_sDialogInfo[data][E_CALLBACK_POINTER] = 0;
	return data;
}*/

foreign Dialog_ObtainID();

global Dialog_ObtainID()
{
	static const
		scDeBruijn[] =
			{
				0,  1,  28, 2,  29, 14, 24, 3,  30, 22, 20, 15, 25, 17, 4,  8, 
				31, 27, 13, 23, 21, 19, 16, 7,  26, 12, 18, 6,  11, 5,  10, 9
			};
	for (new i = 0; i != sizeof (YSI_g_sIDs); ++i)
	{
		if (YSI_g_sIDs[i])
		{
			new
				Bit:b = (YSI_g_sIDs[i] & -YSI_g_sIDs[i]),
				data = scDeBruijn[(_:b * 0x077CB531) >>> 27];
			YSI_g_sIDs[i] &= ~b;
			data += (i * 32);
			YSI_g_sDialogPlayers[data] = 0;
			YSI_g_sDialogMasters[data] = -1;
			//YSI_g_sDialogInfo[data][E_CALLBACK_POINTER] = 0;
			return data;
		}
	}
	return -1;
	// http://supertech.csail.mit.edu/papers/debruijn.pdf
}

foreign Dialog_TryObtainID(id);

global Dialog_TryObtainID(id)
{
	if (Bit_Get(YSI_g_sIDs, id))
	{
		Bit_Vet(YSI_g_sIDs, id);
		YSI_g_sDialogPlayers[id] = 0;
		YSI_g_sDialogMasters[id] = -1;
		//YSI_g_sDialogInfo[data][E_CALLBACK_POINTER] = 0;
		return 1;
	}
	P:C(else P:E("Dialog ID %d already in use", id););
	return 0;
}

foreign Dialog_Get(playerid);

global Dialog_Get(playerid)
{
	return YSI_g_sPlayerDialog[playerid];
}

foreign Dialog_Garbage(dialogid);

global Dialog_Garbage(dialogid)
{
	Bit_Let(YSI_g_sFree, dialogid);
	return 1;
}

foreign Dialog_Set(playerid, dialogid);

global Dialog_Set(playerid, dialogid)
{
	new
		old = YSI_g_sPlayerDialog[playerid];
	if (dialogid != old)
	{
		if (old != -1)
		{
			if (--YSI_g_sDialogPlayers[old] == 0)
			{
				if (Bit_Get(YSI_g_sFree, old))
				{
					YSI_g_sDialogMasters[old] = -1;
					Bit_Vet(YSI_g_sFree, old);
					Bit_Let(YSI_g_sIDs, old);
					// "old" destroyed.
					return 0;
				}
			}
		}
	}
	if (dialogid != -1)
	{
		++YSI_g_sDialogPlayers[dialogid];
	}
	YSI_g_sPlayerDialog[playerid] = dialogid;
	// "old" still exists.
	return 1;
}

stock Dialog_ShowCallback(playerid, callback:callback, style, string:title[], string:caption[], string:button1[], string:button2[] = "", dialog = -1)
{
	new
		ret = Dialog_Show(playerid, style, title, caption, button1, button2, dialog),
		data[E_CALLBACK_DATA];
	Callback_Get(callback, data);
	Dialog_SetCallbackData(ret, data);
	return ret;
}

stock Dialog_ShowCallbackData(playerid, callback[E_CALLBACK_DATA], style, string:title[], string:caption[], string:button1[], string:button2[] = "", dialog = -1)
{
	new
		ret = Dialog_Show(playerid, style, title, caption, button1, button2, dialog);
	Dialog_SetCallbackData(ret, callback);
	return ret;
}

stock Dialog_Show(playerid, style, string:title[], string:caption[], string:button1[], string:button2[] = "", dialog = -1)
{
	if (dialog == -1)
	{
		dialog = Dialog_ObtainID();
		Dialog_Garbage(dialog);
	}
	ShowPlayerDialog(playerid, dialog, style, title, caption, button1, button2);
	Dialog_Set(playerid, dialog);
	return dialog;
}

stock Dialog_Hide(playerid)
{
	// This almost looks like a Windows API function call!
	ShowPlayerDialog(playerid, -1, 0, NULL, NULL, NULL, NULL);
	return Dialog_Set(playerid, -1);
}

/*#define Dialog_SetCallback(%0) _Dialog_SetCallback(%0,Master_Caller())

foreign @Dialog_SetCallback(dialogid, a, b, c, d);

global @Dialog_SetCallback(dialogid, a, b, c, d)
{
	YSI_g_sDialogInfo[dialogid] = callback;
}

stock _Dialog_SetCallback(dialogid, callback[E_CALLBACK_DATA], master)
{
	@Dialog_SetCallback(dialogid
}*/

remote Dialog_SetMaster(dialogid, master)
{
	YSI_g_sDialogMasters[dialogid] = master;
	YSI_g_sDialogInfo[dialogid][E_CALLBACK_DATA_POINTER] = 0;
}

stock Dialog_GetMaster(dialogid)
{
	return YSI_g_sDialogMasters[dialogid];
}

stock Dialog_SetCallback(dialogid, callback:callback)
{
	new
		data[E_CALLBACK_DATA];
	Callback_Get(callback, data);
	Dialog_SetCallbackData(dialogid, data);
}

stock Dialog_SetCallbackData(dialogid, callback[E_CALLBACK_DATA])
{
	broadcast Dialog_SetMaster(dialogid, Master_Caller());
	YSI_g_sDialogInfo[dialogid] = callback;
}

// Need to somehow integrate this new dialogs library with the text library.

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	P:1("Dialog_OnDialogResponse called: %d %d %d %d %s", playerid, dialogid, response, listitem, inputtext);
	// Apparently there's a hack to alter this.
	dialogid = Dialog_Get(playerid);
	// Dialogs close automaticaly.
	Dialog_Set(playerid, -1);
	if (dialogid != -1 && YSI_g_sDialogMasters[dialogid] == _@ && YSI_g_sDialogInfo[dialogid][E_CALLBACK_DATA_POINTER])
	{
		Callback_Call(YSI_g_sDialogInfo[dialogid], playerid, dialogid, response, listitem, inputtext);
		if (Bit_Get(YSI_g_sIDs, dialogid))
		{
			// Callback no longer needed.
			Callback_Release(YSI_g_sDialogInfo[dialogid]);
		}
		return 1;
	}
	return 0;
}

stock _ShowPlayerDialog(playerid, dialog, style, string:title[], string:caption[], string:button1[], string:button2[])
{
	Dialog_TryObtainID(dialog);
	YSI_g_sDialogInfo[dialog][E_CALLBACK_POINTER] = 0;
	ShowPlayerDialog(playerid, dialog, style, title, caption, button1, button2);
	return 0;
}

#if defined _ALS_ShowPlayerDialog
	#undef ShowPlayerDialog
#else
	#define _ALS_ShowPlayerDialog
#endif
#define ShowPlayerDialog _ShowPlayerDialog

#define HidePlayerDialog Dialog_Hide

/*stock HidePlayerDialog(playerid)
{
	ShowPlayerDialog(playerid, -1, 0, NULL, NULL, NULL, NULL);
}*/

//#define YSI_SET_LAST_GROUP 19
#include <YSI\internal\y_grouprevert>
