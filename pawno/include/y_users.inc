// The new y_player library.

#if !defined MODE_NAME
	#error Please define "MODE_NAME" before including y_users.
#endif

#include <a_samp>

forward OnPlayerLogin(playerid, yid);

forward OnPlayerLogout(playerid, yid);

//#if !defined HAS_USER_CALLBACKS
//	#define HAS_USER_CALLBACKS
//#endif

#include <YSI\internal\y_version>

#include <YSI\y_text>

#include <YSI\y_remote>
#include <YSI\y_debug>
#include <YSI\y_ini>
#include <YSI\y_utils>
#include <YSI\y_timers>

#include <YSI\y_master>
#define MAX_INDEX_LENGTH                8

#include <YSI\y_hooks>

#if defined PP_ADLER32
#elseif defined PP_MD5 && defined MD5_Hash
	#define MAX_PASSWORD_LENGTH             32
#elseif defined PP_SHA1
	#error SHA1 unsupported.
#elseif defined PP_YSI
	#define MAX_PASSWORD_LENGTH             16
#elseif defined WP_Hash
	#define MAX_PASSWORD_LENGTH             128
#else
	#define PP_YSI
	#define MAX_PASSWORD_LENGTH             16
#endif

#define INDEX_DATA_LINE_LENGTH          (MAX_INDEX_LENGTH + 1 + MAX_PLAYER_NAME + 1 + MAX_PASSWORD_LENGTH + 3)

#if !defined USER_FILE_PATH
	#define USER_FILE_PATH                  "YSI/users/"
#endif

//#define PINI:%0[%1](%2) %0_%1@yU_(%2);public %0_%1@yU_(%2)

#define OnUserData[%0](%1) @yU_%0(%1)
#define PINI:%0(%1) forward OnUserData[%0](%1);public OnUserData[%0](%1)

text core[ysi_players];

static stock
	YSI_g_sPlayerIndexFile,
	INI:YSI_g_sPlayerWriteFile = INI_NO_FILE,
	YSI_g_sPlayerYID[MAX_PLAYERS] = {-2, ...};

//#define Player_GetIndexFile(%0,%1) ((YSI_g_sPlayerIndexFile=%1[0]),%0[sizeof(%0)-5]=(('a'<=(YSI_g_sPlayerIndexFile|0x20)<='z')?(YSI_g_sPlayerIndexFile|0x20):(('0'<=YSI_g_sPlayerIndexFile<='9')?('0'):('_'))))
#define Player_GetIndexFile(%0,%1) ((YSI_g_sPlayerIndexFile=%1[0]),%0[14]=(('a'<=(YSI_g_sPlayerIndexFile|0x20)<='z')?(YSI_g_sPlayerIndexFile|0x20):(('0'<=YSI_g_sPlayerIndexFile<='9')?('0'):('_'))))

foreign Player_DoLogout(playerid, yid);

foreign Player_TryRegister(playerid, string:password[]);

foreign Player_TryLogin(playerid, string:password[]);

foreign Player_TryGroup(playerid, string:other[], string:password[]);

foreign Player_GetYID(playerid);

foreign Player_ChangePassword(playerid, string:password[]);

hook OnScriptInit()
{
	switch (ftouch(USER_FILE_PATH "index.YSI"))
	{
		case -1:
		{
			P:E(USER_FILE_PATH "index.YSI does not exist and couldn't be created");
		}
		case 1:
		{
			if (!Player_CreateNewID())
			{
				P:E(USER_FILE_PATH "index.YSI does not exist and couldn't be created");
			}
		}
	}
}

/*hook OnScriptExit()
{
	_Player_CloseLogout();
}*/

hook OnPlayerConnect(playerid)
{
	// -2 means unknown.
	YSI_g_sPlayerYID[playerid] = -2;
	broadcast _Player_IsLoggedIn(playerid);
	if (existproperty(8, "SOME_TEMP_STRING_FOR_PLAYERS"))
	{
		new
			yid = getproperty(8, "SOME_TEMP_STRING_FOR_PLAYERS");
		if (yid != -1)
		{
			// This DOES NOT use "broadcast" as it's local only.
			Player_DoLogin(playerid, yid);
		}
		deleteproperty(8, "SOME_TEMP_STRING_FOR_PLAYERS");
	}
	else
	{
		// Can do checking in here to see if they just rejoined.
		YSI_g_sPlayerYID[playerid] = -1;
	}
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (YSI_g_sPlayerYID[playerid] != -1)
	{
		// DO NOT broadcast this in case it's just because of one script being
		// unloaded, not the player actually leaving (and thus do everything in
		// different scripts separately).
		Player_DoLogout(playerid, YSI_g_sPlayerYID[playerid]);
	}
	YSI_g_sPlayerYID[playerid] = -2;
}

static remote _Player_IsLoggedIn(playerid)
{
	if (YSI_g_sPlayerYID[playerid] != -2)
	{
		setproperty(8, "SOME_TEMP_STRING_FOR_PLAYERS", YSI_g_sPlayerYID[playerid]);
	}
}

stock bool:Player_IsLoggedIn(playerid)
{
	// -2 should never be an issue, but if it is...
	return YSI_g_sPlayerYID[playerid] >= 0;
}

global Player_GetYID(playerid)
{
	return YSI_g_sPlayerYID[playerid];
}

/*----------------------------------------------------------------------------*\
Function:
	Player_TryLogin
Params:
	playerid - Player who is logging in.
	password[] - Password they entered.
Return:
	-
Notes:
	Tries to log in a player - hashes and checks their password and if it's
	right calls the core login code.  It doesn't matter WHICH script does this
	as they ALL get called and ALL track the login status of a player.
\*----------------------------------------------------------------------------*/

global Player_TryLogin(playerid, string:password[])
{
	P:2("Player_TryLogin start");
	if (Player_IsLoggedIn(playerid))
	{
		// They are already logged in.
		Text_Send(playerid, $YSI_LOGIN_ALREADY);
		return 1;
	}
	// First, find the player's file.  This should be the ONLY place where the
	// password is to be loaded.
	//format(name, sizeof (name), "%" #MAX_PLAYER_NAME "s", name);
	new
		name[MAX_PLAYER_NAME + 1],
		namelen,
		filename[] = USER_FILE_PATH "ind_X.YSI",
		File:fIndex,
		hash[MAX_PASSWORD_LENGTH + 1];
	GetPlayerName(playerid, name, sizeof (name));
	//name = "Woop43";
	Player_HashPass(password, hash);
	namelen = strlen(name);
	Player_GetIndexFile(filename, name);
	fIndex = fopen(filename, io_read);
	//printf("filename = %s", filename);
	if (fIndex)
	{
		P:5("Player_Trylogin: fIndex OK");
		new
			line[INDEX_DATA_LINE_LENGTH];
		while (fread(fIndex, line))
		{
			P:6("Player_TryLogin: while");
			new
				len;
			len = strlen(line);
			// Check if the line is the right length (could be one of three
			// lengths depending on newlines).  Skip blanks.
			if (len < INDEX_DATA_LINE_LENGTH - 3)
			{
				continue;
			}
			P:6("Player_TryLogin: Not len");
			// Check the name on the line.
			if (!strcmp(line[MAX_INDEX_LENGTH + 1], name, false, namelen) && line[MAX_INDEX_LENGTH + 1 + namelen] == ' ')
			{
				P:6("Player_TryLogin: checked name");
				// Found the section on this one player.
				//new
				//	ret;
				P:6("Player_TryLogin: check pass: %s ?= %s", hash, line[MAX_INDEX_LENGTH + 1 + MAX_PLAYER_NAME + 1]);
				// Check that the hashed passwords are the same.
				if (!strcmp(line[MAX_INDEX_LENGTH + 1 + MAX_PLAYER_NAME + 1], hash, false, MAX_PASSWORD_LENGTH))
				{
					// Extract the yid and call in to the login code.
					line[MAX_INDEX_LENGTH] = '\0';
					broadcast Player_DoLogin(playerid, strval(line));
					Text_Send(playerid, $YSI_LOGIN_LOGIN);
				}
				else
				{
					Text_Send(playerid, $YSI_LOGIN_WRONG);
				}
				fclose(fIndex);
				return 1;
			}
		}
		Text_Send(playerid, $YSI_LOGIN_NOTF);
		fclose(fIndex);
	}
	else if (fexist(filename))
	{
		Text_Send(playerid, $YSI_LOGIN_INDERR);
	}
	else
	{
		Text_Send(playerid, $YSI_LOGIN_NOTF);
	}
	return 0;
}

/*static*/ remote Player_DoLogin(playerid, yid)
{
	// Called when a player logs in - either locally (new script) or globally
	// (actually only just logged in).
	YSI_g_sPlayerYID[playerid] = yid;
	// Load any "uvar" variables.
	// Call the hooks version of this.
	new
		filename[64];
	format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
	// INI_ParseFile will ONLY load the data for THIS mode, as well as data
	// which is mode independent (though there should be none).
	INI_ParseFile(filename, "@yU_%s", .bExtra = true, .extra = playerid, .bLocal = true, .bFilter = false, .filter = #MODE_NAME);
	Hooks_OnPlayerLogin(playerid, yid);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_RemoveEntry
Params:
	name[] - Item to remove.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for removing data.
\*----------------------------------------------------------------------------*/

stock Player_RemoveEntry(name[])
{
	INI_RemoveEntry(YSI_g_sPlayerWriteFile, name);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteString
Params:
	name[] - Data name.
	data[] - Data.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for strings.
\*----------------------------------------------------------------------------*/

stock Player_WriteString(name[], data[])
{
	INI_WriteString(YSI_g_sPlayerWriteFile, name, data);
}

stock Player_WriteArray(const name[], data[], len)
{
	//printf("name = %s", name);
	//printf("data = %d, %d, %d", data[0], data[1], data[2]);
	//printf("len = %d", len);
	INI_WriteArray(YSI_g_sPlayerWriteFile, name, data, len);
	return 1;
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteInt
Params:
	name[] - Data name.
	data - Integer data.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for integers.
\*----------------------------------------------------------------------------*/

stock Player_WriteInt(name[], data)
{
	INI_WriteInt(YSI_g_sPlayerWriteFile, name, data);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteHex
Params:
	name[] - Data name.
	data - Hex data.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for integers to be written as hex values.
\*----------------------------------------------------------------------------*/

stock Player_WriteHex(name[], data)
{
	INI_WriteHex(YSI_g_sPlayerWriteFile, name, data);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteBin
Params:
	name[] - Data name.
	data - Binary data.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for integers to be written as binary values.
\*----------------------------------------------------------------------------*/

stock Player_WriteBin(name[], data)
{
	INI_WriteBin(YSI_g_sPlayerWriteFile, name, data);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteBool
Params:
	name[] - Data name.
	data - Boolean data.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for booleans.
\*----------------------------------------------------------------------------*/

stock Player_WriteBool(name[], bool:data)
{
	INI_WriteBool(YSI_g_sPlayerWriteFile, name, data);
}

/*----------------------------------------------------------------------------*\
Function:
	Player_WriteFloat
Params:
	name[] - Data name.
	Float:data - Float data.
	accuracy - number of decimal places to write.
Return:
	-
Notes:
	Wrapper for Player_AddToBuffer for floats.  Uses custom code instead of
	format() as it's actually faster for something simple like this.
\*----------------------------------------------------------------------------*/

stock Player_WriteFloat(name[], Float:data, accuracy = 6)
{
	INI_WriteFloat(YSI_g_sPlayerWriteFile, name, data, accuracy);
}

stock Player_SetTag(tag[])
{
	// Make sure we ALWAYS store mode tags with a special prefix.
	new
		tag2[MAX_INI_TAG] = "@@" #MODE_NAME "-";
	strcat(tag2, tag);
	//printf("tag = %s, %s", tag, tag2);
	INI_SetTag(YSI_g_sPlayerWriteFile, tag2);
}

stock Player_DeleteTag(tag[])
{
	INI_DeleteTag(YSI_g_sPlayerWriteFile, tag);
}

global Player_DoLogout(playerid, yid)
{
	/*INI:YSI_g_sOneLogoutFile = INI_NO_FILE
	YSI_g_sOneLogoutPerson = INVALID_PLAYER_ID*/
	new
		filename[64];
	format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
	YSI_g_sPlayerWriteFile = INI_Open(filename);
	if (YSI_g_sPlayerWriteFile != INI_NO_FILE)
	{
		Hooks_OnPlayerLogout(playerid, yid);
		call OnPlayerLogout(playerid, yid);
		INI_Close(YSI_g_sPlayerWriteFile);
	}
	// Do ALL the saving from ONE place.  Detect one or many scripts ending.
	/*if (YSI_g_sOneLogoutFile == INI_NO_FILE)
	{
		new
			filename[64];
		format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
		YSI_g_sOneLogoutFile = INI_Open(filename);
		YSI_g_sOneLogoutPerson = playerid;
	}
	else if (YSI_g_sOneLogoutPerson != playerid)
	{
		INI_Close(YSI_g_sOneLogoutFile);
	}
	// Will be called AFTER all "OnPlayerDisconnect" callbacks are called when
	// one player leaves, and if more leave it's still used for the last player
	// in the list.
	//defer _Player_CloseLogout();
	_Player_CloseLogout();
	// By now "YSI_g_sOneLogoutFile" contains a handle to the user's file,
	// either having just been opened, or invoked in a previous call to this
	// function from another script still running but loosing the player.
	// This could in theory be used from some force-logout script.
	YSI_g_sPlayerYID[playerid] = -1;*/
	return 1;
}

//static timer _Player_CloseLogout[0]()
/*static stock _Player_CloseLogout()
{
	if (YSI_g_sOneLogoutFile != INI_NO_FILE)
	{
		INI_Close(YSI_g_sOneLogoutFile);
		YSI_g_sOneLogoutFile = INI_NO_FILE;
		YSI_g_sOneLogoutPerson = INVALID_PLAYER_ID;
	}
}*/

/*----------------------------------------------------------------------------*\
Function:
	Player_HashPass
Params:
	pass[] - Data to hash.
Return:
	-
Notes:
	Based on my Dad's hash system but slightly modifed.  Updated for reverse
	compatability with other login systems.  Needs more code for Whirlpool.
\*----------------------------------------------------------------------------*/

static stock Player_HashPass(pass[], target[])
{
	#if defined PP_ADLER32
		new
			s1 = 1,
			s2 = 0,
			i,
			You_REALLY_shouldnt_use_Adler32;
		while (pass[i])
		{
			s1 = (s1 + pass[i++]) % 65521;
			s2 = (s2 + s1) % 65521;
		}
		//new
		//	target[MAX_PASSWORD_LENGTH + 1];
		format(target, sizeof (target), "%" #MAX_PASSWORD_LENGTH "d", (s2 << 16) + s1);
		//return target;
	#elseif defined PP_MD5 && defined MD5_Hash
		new
			You_REALLY_shouldnt_use_MD5;
		strcpy(target, MD5_Hash(pass, strlen(pass)));
	#elseif defined PP_SHA1
		#error SHA1 unsupported.
	#elseif defined PP_YSI
		static
			charset[] = "A,UbRgdnS#|rT_%5+ZvEK¬NF<9¦IH[(C)2O07 Y-Less]$Qw^?/om4;@'8k£Pp.c{&l\\3zay>DfxV:WXjuG6*!1\"i~=Mh`JB}qt",
			css = 99;
		new
			//target[MAX_PASSWORD_LENGTH + 1],
			j,
			sum = j,
			tmp = 0,
			i,
			mod;
		j = strlen(pass);
		for (i = 0; i < MAX_PASSWORD_LENGTH || i < j; i++)
		{
			mod = i % MAX_PASSWORD_LENGTH;
			tmp = (i >= j) ? charset[(7 * i) % css] : pass[i];
			sum = (sum + chrfind(tmp, charset) + 1) % css;
			target[mod] = charset[(sum + target[mod]) % css];
		}
		target[MAX_PASSWORD_LENGTH] = '\0';
		//return target;
	#elseif defined WP_Hash
		WP_Hash(target, MAX_PASSWORD_LENGTH + 1, pass);
	#else
		#error Whirlpool (or other) hash not found.
	#endif
}

// Hooray for bizare bugs!  I think this is because the function above is
// secretly a macro with "if/else" and a block statement, not a real function.

stock Player_SomeWeirdBugFix()
{
}

/*stock Anything0()
{
}*/

/*stock Anything1()
{
}

stock Anything2()
{
}

stock Anything3()
{
}*/

/*stock Anything4()
{
}

stock Anything5()
{
}

stock Anything6()
{
}

stock Anything7()
{
}*/

//#endinput
global Player_TryRegister(playerid, string:password[])
{
	P:2("Player_TryRegister called");
	if (Player_TryLogin(playerid, password))
	{
		// They are already registered and just typed the right password too.
		return 1;
	}
	new
		name[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, name, sizeof (name));
	//format(name, sizeof (name), "%" #MAX_PLAYER_NAME "s", name);
	new
		namelen,
		filename[64] = USER_FILE_PATH "ind_X.YSI",
		File:fIndex,
		hash[MAX_PASSWORD_LENGTH + 1];
	Player_HashPass(password, hash);
	namelen = strlen(name);
	Player_GetIndexFile(filename, name);
	fIndex = fopen(filename, io_read);
	P:5("Player_TryRegister: fIndex");
	new
		line[INDEX_DATA_LINE_LENGTH];
	if (fIndex)
	{
		while (fread(fIndex, line))
		{
			P:6("Player_TryRegister: while: %s %s", line[MAX_INDEX_LENGTH + 1], name);
			new
				len;
			len = strlen(line);
			// Check if the line is the right length (could be one of three
			// lengths depending on newlines).  Skip blanks.
			if (len < INDEX_DATA_LINE_LENGTH - 3)
			{
				continue;
			}
			// Check the name on the line.
			if (!strcmp(line[MAX_INDEX_LENGTH + 1], name, false, namelen) && line[MAX_INDEX_LENGTH + 1 + namelen] == ' ')
			{
				P:5("Player_TryRegister: Already Registered");
				// This name is already registered...
				Text_Send(playerid, $YSI_REG_TAKEN);
				fclose(fIndex);
				return 0;
			}
		}
		// Username not found.
		fclose(fIndex);
	}
	else if (ftouch(filename) != 1)
	{
		Text_Send(playerid, $YSI_ADDU_INDER1);
		return 0;
	}
	if ((fIndex = fopen(filename, io_append)))
	{
		P:5("Player_TryRegister: Write index.");
		// Write the new user to the index file.
		new
			yid = Player_GetNewID();
		if (yid == -1)
		{
			Text_Send(playerid, $YSI_LOGIN_INDERR);
			return 0;
		}
		format(line, sizeof (line), "%0" #MAX_INDEX_LENGTH "d %" #MAX_PLAYER_NAME "s %" #MAX_PASSWORD_LENGTH "s" INI_NEW_LINE, yid, name, hash);
		fwrite(fIndex, line);
		fclose(fIndex);
		format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
		new
			INI:x = INI_Open(filename);
		if (x == INI_NO_FILE)
		{
			Text_Send(playerid, $YSI_LOGIN_NOLOAD);
		}
		else
		{
			INI_SetTag(x, "ysi_names");
			INI_WriteString(x, name, "name");
			INI_Close(x);
		}
		// Call in all scripts.
		broadcast Player_DoLogin(playerid, yid);
		Text_Send(playerid, $YSI_LOGIN_LOGIN);
		return 1;
	}
	else
	{
		Text_Send(playerid, $YSI_ADDU_INDER2);
		return 0;
	}
}

global Player_ChangePassword(playerid, string:password[])
{
	#pragma unused password
	new
		yid = Player_GetYID(playerid);
	if (yid < 0)
	{
		return 0;
	}
	new
		filename[64];
	// Loop through all the names associated with this user.
	format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
	/*inline Func(string:name[], string:value[])
	{
	}
	INI_ParseFile(filename, using inline Func, .bPassTag = true, .singleTag = "ysi_name");*/
	return 1;
}

//#endinput
global Player_TryGroup(playerid, string:other[], string:password[])
{
	P:2("Player_TryGroup called");
	/*if (Player_TryLogin(playerid, password))
	{
		// They are already registered and just typed the right password too.
		return 1;
	}*/
	new
		name[MAX_PLAYER_NAME + 1];
	GetPlayerName(playerid, name, sizeof (name));
	//format(name, sizeof (name), "%" #MAX_PLAYER_NAME "s", name);
	new
		namelen,
		filename[64] = USER_FILE_PATH "ind_X.YSI",
		File:fIndex,
		yid,
		hash[MAX_PASSWORD_LENGTH + 1];
	Player_HashPass(password, hash);
	P:2("Player_TryGroup start");
	// First, find the player's file.  This should be the ONLY place where the
	// password is to be loaded.
	namelen = strlen(other);
	Player_GetIndexFile(filename, other);
	fIndex = fopen(filename, io_read);
	//printf("filename = %s", filename);
	new
		ret;
	if (fIndex)
	{
		P:5("Player_TryGroup: fIndex OK");
		new
			line[INDEX_DATA_LINE_LENGTH];
		while (fread(fIndex, line))
		{
			P:6("Player_TryGroup: while");
			new
				len;
			len = strlen(line);
			// Check if the line is the right length (could be one of three
			// lengths depending on newlines).  Skip blanks.
			if (len < INDEX_DATA_LINE_LENGTH - 3)
			{
				continue;
			}
			P:6("Player_TryGroup: Not len");
			// Check the name on the line.
			if (!strcmp(line[MAX_INDEX_LENGTH + 1], other, false, namelen) && line[MAX_INDEX_LENGTH + 1 + namelen] == ' ')
			{
				P:6("Player_TryGroup: checked name");
				// Found the section on this one player.
				//new
				//	ret;
				P:6("Player_TryGroup: check pass: %s ?= %s", hash, line[MAX_INDEX_LENGTH + 1 + MAX_PLAYER_NAME + 1]);
				// Check that the hashed passwords are the same.
				if (!strcmp(line[MAX_INDEX_LENGTH + 1 + MAX_PLAYER_NAME + 1], hash, false, MAX_PASSWORD_LENGTH))
				{
					// Extract the yid and call in to the login code.
					line[MAX_INDEX_LENGTH] = '\0';
					//broadcast Player_DoLogin(playerid, strval(line));
					yid = strval(line);
					//Text_Send(playerid, $YSI_LOGIN_LOGIN);
					goto Player_TryGroup_jump;
				}
				else
				{
					Text_Send(playerid, $YSI_LOGIN_WRONG);
				}
				fclose(fIndex);
				//return 1;
				goto Player_TryGroup_jump;
			}
		}
		Text_Send(playerid, $YSI_LOGIN_NOTF);
		fclose(fIndex);
	}
	else if (fexist(filename))
	{
		Text_Send(playerid, $YSI_LOGIN_INDERR);
	}
	else
	{
		Text_Send(playerid, $YSI_LOGIN_NOTF);
	}
	ret = 1;
Player_TryGroup_jump:
	if (ret)
	{
		return 0;
	}
	namelen = strlen(name);
	Player_GetIndexFile(filename, name);
	fIndex = fopen(filename, io_read);
	P:5("Player_TryGroup: fIndex");
	new
		line[INDEX_DATA_LINE_LENGTH];
	if (fIndex)
	{
		while (fread(fIndex, line))
		{
			P:6("Player_TryGroup: while");
			new
				len;
			len = strlen(line);
			// Check if the line is the right length (could be one of three
			// lengths depending on newlines).  Skip blanks.
			if (len < INDEX_DATA_LINE_LENGTH - 3)
			{
				continue;
			}
			// Check the name on the line.
			if (!strcmp(line[MAX_INDEX_LENGTH + 1], name, false, namelen) && line[MAX_INDEX_LENGTH + 1 + namelen] == ' ')
			{
				P:5("Player_TryGroup: Already Registered");
				// This name is already registered...
				Text_Send(playerid, $YSI_REG_TAKEN);
				fclose(fIndex);
				return 0;
			}
		}
		// Username not found.
		fclose(fIndex);
	}
	else if (ftouch(filename) != 1)
	{
		Text_Send(playerid, $YSI_ADDU_INDER1);
		return 0;
	}
	if ((fIndex = fopen(filename, io_append)))
	{
		P:5("Player_TryGroup: Write index.");
		/*// Write the new user to the index file.
		new
			yid = Player_GetNewID(),
			hash[MAX_PASSWORD_LENGTH + 1];
		if (yid == -1)
		{
			Text_Send(playerid, $YSI_LOGIN_INDERR);
			return 0;
		}
		Player_HashPass(password, hash);*/
		// Use the loaded ID.
		format(line, sizeof (line), "%0" #MAX_INDEX_LENGTH "d %" #MAX_PLAYER_NAME "s %" #MAX_PASSWORD_LENGTH "s" INI_NEW_LINE, yid, name, hash);
		fwrite(fIndex, line);
		fclose(fIndex);
		format(filename, sizeof (filename), USER_FILE_PATH "%0" #MAX_INDEX_LENGTH "d.INI", yid);
		new
			INI:x = INI_Open(filename);
		if (x == INI_NO_FILE)
		{
			Text_Send(playerid, $YSI_LOGIN_NOLOAD);
		}
		else
		{
			// Add this name to the list of known names.
			INI_SetTag(x, "ysi_names");
			INI_WriteString(x, name, "name");
			INI_Close(x);
		}
		// Call in all scripts.
		broadcast Player_DoLogin(playerid, yid);
		Text_Send(playerid, $YSI_LOGIN_LOGIN);
		return 1;
	}
	else
	{
		Text_Send(playerid, $YSI_ADDU_INDER2);
		return 0;
	}
}

static stock Player_GetNewID()
{
	new
		File:fHnd = fopen(USER_FILE_PATH "index.YSI", io_readwrite),
		num[MAX_INDEX_LENGTH + 1],
		yid = -1;
	if (fHnd)
	{
		fread(fHnd, num);
		yid = strval(num) + 1;
		valstr(num, yid);
		fseek(fHnd, 0, seek_start);
		fwrite(fHnd, num);
		fclose(fHnd);
	}
	return yid;
}

static stock Player_CreateNewID()
{
	new
		File:fHnd = fopen(USER_FILE_PATH "index.YSI", io_write);
	if (fHnd)
	{
		fwrite(fHnd, "-1");
		fclose(fHnd);
		return 1;
	}
	return 0;
}

#include <YSI\internal\y_grouprevert>
