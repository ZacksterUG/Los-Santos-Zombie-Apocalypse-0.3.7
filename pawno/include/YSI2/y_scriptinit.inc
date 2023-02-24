/*----------------------------------------------------------------------------*\
					=======================================
					 y_scriptinit - Two useful callbacks.
					=======================================
Description:
	This file provides "OnScriptInit" and "OnScriptExit" which are called at the
	start and end of the current script, regardless of what the type of the
	script is (note: doesn't support NPC modes).  It also provides
	"YSI_FILTERSCRIPT" as a (partial) replacement for "FILTERSCRIPT" which
	detects what the mode is at runtime for a more reliable system (but it is a
	run-time variable, not a compile-time constant).
Legal:
	Version: MPL 1.1
	
	The contents of this file are subject to the Mozilla Public License Version 
	1.1 (the "License"); you may not use this file except in compliance with 
	the License. You may obtain a copy of the License at 
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.
	
	The Original Code is the YSI scriptinit include.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.
	Portions created by the Initial Developer are Copyright (C) 2011
	the Initial Developer. All Rights Reserved.
	
	Contributors:
		ZeeX, koolk, JoeBullet/Google63, g_aSlice/Slice
	
	Thanks:
		JoeBullet/Google63 - Handy arbitrary ASM jump code using SCTRL.
		ZeeX - Very productive conversations.
		koolk - IsPlayerinAreaEx code.
		TheAlpha - Danish translation.
		breadfish - German translation.
		Fireburn - Dutch translation.
		yom - French translation.
		50p - Polish translation.
		Zamaroht - Spanish translation.
		Dracoblue, sintax, mabako, Xtreme, other coders - Producing other modes
			for me to strive to better.
		Pixels^ - Running XScripters where the idea was born.
		Matite - Pestering me to release it and using it.
	
	Very special thanks to:
		Thiadmer - PAWN, whose limits continue to amaze me!
		Kye/Kalcor - SA:MP.
		SA:MP Team past, present and future - SA:MP.
	
Version:
	1.0
Changelog:
	30/04/11:
		First version
\*----------------------------------------------------------------------------*/

#include <a_samp>

forward _ScriptInit_FixState();

#if defined FILTERSCRIPT
	#if !defined YSI_FILTERSCRIPT
		stock
			bool:YSI_FILTERSCRIPT = true;
	#endif
	
	public OnFilterScriptInit()
	{
		state _script_init_fix_state : true;
		CallLocalFunction("ScriptInit_OnScriptInit", "");
		//CallRemoteFunction("ScriptInit_OnAnyScriptInit", "");
		CallLocalFunction("ScriptInit_OnFilterScriptInit", "");
		//CallLocalFunction("ScriptInit_OnScriptInitLate", "");
		CallLocalFunction("Text_Special_OnScriptInit", "");
	}
	
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit ScriptInit_OnFilterScriptInit
	
	forward ScriptInit_OnFilterScriptInit();
#else
	// People can't be trusted to use "FILTERSCRIPT"...
	new
		#if !defined YSI_FILTERSCRIPT
			bool:YSI_FILTERSCRIPT = false,
		#endif
		bool:YSI_g_sScriptInitGM,
		bool:YSI_g_sScriptExitGM;
	
	public OnFilterScriptInit()
	{
		state _script_init_fix_state : true;
		//printf("OFSI");
		YSI_FILTERSCRIPT = true;
		YSI_g_sScriptInitGM = funcidx("ScriptInit_OnGameModeInit") != -1;
		YSI_g_sScriptExitGM = funcidx("ScriptInit_OnGameModeExit") != -1;
		CallLocalFunction("ScriptInit_OnScriptInit", "");
		//CallRemoteFunction("ScriptInit_OnAnyScriptInit", "");
		CallLocalFunction("ScriptInit_OnFilterScriptInit", "");
		//CallLocalFunction("ScriptInit_OnScriptInitLate", "");
		CallLocalFunction("Text_SpecialInit", "");
	}
	
	public OnGameModeInit()
	{
		if (YSI_FILTERSCRIPT)
		{
			state _script_init_fix_state : true;
			if (YSI_g_sScriptInitGM)
			{
				CallLocalFunction("ScriptInit_OnGameModeInit", "");
			}
		}
		else
		{
			state _script_init_fix_state : false;
			CallLocalFunction("ScriptInit_OnScriptInit", "");
			//CallRemoteFunction("ScriptInit_OnAnyScriptInit", "");
			CallLocalFunction("ScriptInit_OnGameModeInit", "");
			//CallLocalFunction("ScriptInit_OnScriptLate", "");
			CallLocalFunction("Text_SpecialInit", "");
		}
	}
	
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit ScriptInit_OnGameModeInit
	
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit ScriptInit_OnFilterScriptInit
	
	forward ScriptInit_OnFilterScriptInit();
	forward ScriptInit_OnGameModeInit();
#endif

#if defined FILTERSCRIPT
	public OnFilterScriptExit()
	{
		CallLocalFunction("ScriptInit_OnScriptExit", "");
		//CallRemoteFunction("ScriptInit_OnAnyScriptExit", "");
		CallLocalFunction("ScriptInit_OnFilterScriptExit", "");
		//CallLocalFunction("ScriptInit_OnScriptExitLate", "");
	}
	
	#if defined _ALS_OnFilterScriptExit
		#undef OnFilterScriptExit
	#else
		#define _ALS_OnFilterScriptExit
	#endif
	#define OnFilterScriptExit ScriptInit_OnFilterScriptExit
	
	forward ScriptInit_OnFilterScriptExit();
#else
	public OnFilterScriptExit()
	{
		if (YSI_FILTERSCRIPT)
		{
			CallLocalFunction("ScriptInit_OnScriptExit", "");
			//CallRemoteFunction("ScriptInit_OnAnyScriptExit", "");
			CallLocalFunction("ScriptInit_OnFilterScriptExit", "");
			//CallLocalFunction("ScriptInit_OnScriptExitLate", "");
		}
	}

	public OnGameModeExit()
	{
		if (YSI_FILTERSCRIPT)
		{
			if (YSI_g_sScriptExitGM)
			{
				CallLocalFunction("ScriptInit_OnGameModeExit", "");
			}
		}
		else
		{
			CallLocalFunction("ScriptInit_OnScriptExit", "");
			//CallRemoteFunction("ScriptInit_OnAnyScriptExit", "");
			CallLocalFunction("ScriptInit_OnGameModeExit", "");
			//CallLocalFunction("ScriptInit_OnScriptExitLate", "");
		}
	}
	
	#if defined _ALS_OnGameModeExit
		#undef OnGameModeExit
	#else
		#define _ALS_OnGameModeExit
	#endif
	#define OnGameModeExit ScriptInit_OnGameModeExit
	
	#if defined _ALS_OnFilterScriptExit
		#undef OnFilterScriptExit
	#else
		#define _ALS_OnFilterScriptExit
	#endif
	#define OnFilterScriptExit ScriptInit_OnFilterScriptExit
	
	forward ScriptInit_OnFilterScriptExit();
	forward ScriptInit_OnGameModeExit();
#endif

#define OnScriptInit ScriptInit_OnScriptInit
forward OnScriptInit();

#define OnScriptExit ScriptInit_OnScriptExit
forward OnScriptExit();

/*#define OnScriptInitLate ScriptInit_OnScriptInitLate
forward OnScriptInitLate();

#define OnScriptExitLate ScriptInit_OnScriptExitLate
forward OnScriptExitLate();

#define OnAnyScriptInit ScriptInit_OnAnyScriptInit
forward OnAnyScriptInit();

#define OnAnyScriptExit ScriptInit_OnAnyScriptExit
forward OnAnyScriptExit();*/

// I'm not quite sure what causes it, but there seems to be a bug in the
// compiler somewhere which messes up the "ysi_debug" automaton and the
// "YSI_FILTERSCRIPT" variable :(.
public _ScriptInit_FixState() <_script_init_fix_state : true>
{
}

public _ScriptInit_FixState() <_script_init_fix_state : false>
{
}
