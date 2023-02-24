/*         Sasi-Dialogs
 *
 *   Copyright 2011, [GF]Sasino97
 *
*/

#if defined _sasi_dialogs_included
	#endinput
#endif
#define _sasi_dialogs_included

#pragma library _sasi_dialogs

#define MAX_DIALOGS 1000
#define DIALOG_STYLE_QUESTION 3

enum dInfo
{
  Dexists,
  Dstyle,
  Dcaption[256],
  Dinfo[256],
  Dbutton1[11],
  Dbutton2[11]
}

new DialogInfo[MAX_DIALOGS][dInfo];
new count;

forward OnPlayerAcceptMessage(playerid, dialogid);
forward OnPlayerInput(playerid, dialogid, inputtext[]);
forward OnPlayerSelectListItem(playerid, dialogid, listitem);
forward OnPlayerAnswerQuestion(playerid, dialogid, response);

stock CreateDialog(style, caption[], info[], button1[], button2[])
{
  count ++;
  new dialogid = count;
  DialogInfo[dialogid][Dexists] = true;
  DialogInfo[dialogid][Dstyle] = style;
  format(DialogInfo[dialogid][Dcaption], 256, caption);
  format(DialogInfo[dialogid][Dinfo], 256, items);
  format(DialogInfo[dialogid][Dbutton1], 256, button1);
  format(DialogInfo[dialogid][Dbutton2], 256, button2);
  return dialogid;
}

stock CreateInputWindow(caption[], info[], button1[], button2[])
{
  count ++;
  new dialogid = count;
  DialogInfo[dialogid][Dexists] = true;
  DialogInfo[dialogid][Dstyle] = DIALOG_STYLE_INPUT;
  format(DialogInfo[dialogid][Dcaption], 256, caption);
  format(DialogInfo[dialogid][Dinfo], 256, info);
  format(DialogInfo[dialogid][Dbutton1], 256, button1);
  format(DialogInfo[dialogid][Dbutton2], 256, button2);
  return dialogid;
}

stock CreateQuestion(caption[], question[])
{
  count ++;
  new dialogid = count;
  DialogInfo[dialogid][Dexists] = true;
  DialogInfo[dialogid][Dstyle] = DIALOG_STYLE_QUESTION;
  format(DialogInfo[dialogid][Dcaption], 256, caption);
  format(DialogInfo[dialogid][Dinfo], 256, question);
  format(DialogInfo[dialogid][Dbutton1], 256, "Yes");
  format(DialogInfo[dialogid][Dbutton2], 256, "No");
  return dialogid;
}

stock CreateMessage(message[])
{
  count ++;
  new dialogid = count;
  DialogInfo[dialogid][Dexists] = true;
  DialogInfo[dialogid][Dstyle] = DIALOG_STYLE_MSGBOX;
  format(DialogInfo[dialogid][Dcaption], 256, "");
  format(DialogInfo[dialogid][Dinfo], 256, message);
  format(DialogInfo[dialogid][Dbutton1], 256, "OK");
  format(DialogInfo[dialogid][Dbutton2], 256, "");
  return dialogid;
}

stock CreateList(caption[], items[], button1[], button2[])
{
  count ++;
  new dialogid = count;
  DialogInfo[dialogid][Dexists] = true;
  DialogInfo[dialogid][Dstyle] = DIALOG_STYLE_LIST;
  format(DialogInfo[dialogid][Dcaption], 256, caption);
  format(DialogInfo[dialogid][Dinfo], 256, items);
  format(DialogInfo[dialogid][Dbutton1], 256, button1);
  format(DialogInfo[dialogid][Dbutton2], 256, button2);
  return dialogid;
}

stock DialogShowForPlayer(playerid, dialogid)
{
  if(DialogInfo[dialogid][Dstyle] == DIALOG_STYLE_QUESTION) return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, DialogInfo[dialogid][Dcaption], DialogInfo[dialogid][Dinfo], DialogInfo[dialogid][Dbutton1], DialogInfo[dialogid][Dbutton2]);
  ShowPlayerDialog(playerid, dialogid, DialogInfo[dialogid][Dstyle], DialogInfo[dialogid][Dcaption], DialogInfo[dialogid][Dinfo], DialogInfo[dialogid][Dbutton1], DialogInfo[dialogid][Dbutton2]);
  return 1;
}

stock DestroyDialog(dialogid)
{
  DialogInfo[dialogid][Dexists] = false;
  DialogInfo[dialogid][Dstyle] = 4;
  format(DialogInfo[dialogid][Dcaption], 256, "_");
  format(DialogInfo[dialogid][Dinfo], 256, "_");
  format(DialogInfo[dialogid][Dbutton1], 256, "_");
  format(DialogInfo[dialogid][Dbutton2], 256, "_");
  return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
  if(DialogInfo[dialogid][Dstyle] == DIALOG_STYLE_MSGBOX)
  {
	return CallLocalFunction("OnPlayerAcceptMessage", "ii", playerid, dialogid);
  }
  else if(DialogInfo[dialogid][Dstyle] == DIALOG_STYLE_INPUT)
  {
	return CallLocalFunction("OnPlayerInput", "iis", playerid, dialogid, inputtext);
  }
  else if(DialogInfo[dialogid][Dstyle] == DIALOG_STYLE_LIST)
  {
	return CallLocalFunction("OnPlayerSelectListItem", "iii", playerid, dialogid, listitem);
  }
  else if(DialogInfo[dialogid][Dstyle] == DIALOG_STYLE_QUESTION)
  {
	return CallLocalFunction("OnPlayerAnswerQuestion", "iii", playerid, dialogid, response);
  }
  return 0;
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse SD_OnDialogResponse

forward SD_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
