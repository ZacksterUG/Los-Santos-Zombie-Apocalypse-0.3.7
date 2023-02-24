/*----------------------------------------------------------------------------*\
					=======================================
					 y_groups - Player group abstractions! 
					=======================================
Description:
	Admin levels, gangs, teams etc - they're all "groups" of people, this
	provides an abstraction for all of these collections.
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
	
	The Original Code is the YSI group include.
	
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
	29/11/10:
		First version
\*----------------------------------------------------------------------------*/

#undef _inc_y_grouprevert

/*#if defined _YSIM_MANUAL_SET
	#if defined YSI_GROUPS_LAST
		#undef YSI_GROUPS_LAST
	#endif
	#if defined YSI_SET_LAST_GROUP
		#if YSI_SET_LAST_GROUP == 0
			#define YSI_GROUPS_LAST                      0
		#elseif YSI_SET_LAST_GROUP == 1
			#define YSI_GROUPS_LAST                      1
		#elseif YSI_SET_LAST_GROUP == 2
			#define YSI_GROUPS_LAST                      2
		#elseif YSI_SET_LAST_GROUP == 3
			#define YSI_GROUPS_LAST                      3
		#elseif YSI_SET_LAST_GROUP == 4
			#define YSI_GROUPS_LAST                      4
		#elseif YSI_SET_LAST_GROUP == 5
			#define YSI_GROUPS_LAST                      5
		#elseif YSI_SET_LAST_GROUP == 6
			#define YSI_GROUPS_LAST                      6
		#elseif YSI_SET_LAST_GROUP == 7
			#define YSI_GROUPS_LAST                      7
		#elseif YSI_SET_LAST_GROUP == 8
			#define YSI_GROUPS_LAST                      8
		#elseif YSI_SET_LAST_GROUP == 9
			#define YSI_GROUPS_LAST                      9
		#elseif YSI_SET_LAST_GROUP == 10
			#define YSI_GROUPS_LAST                      10
		#elseif YSI_SET_LAST_GROUP == 11
			#define YSI_GROUPS_LAST                      11
		#elseif YSI_SET_LAST_GROUP == 12
			#define YSI_GROUPS_LAST                      12
		#elseif YSI_SET_LAST_GROUP == 13
			#define YSI_GROUPS_LAST                      13
		#elseif YSI_SET_LAST_GROUP == 14
			#define YSI_GROUPS_LAST                      14
		#elseif YSI_SET_LAST_GROUP == 15
			#define YSI_GROUPS_LAST                      15
		#elseif YSI_SET_LAST_GROUP == 16
			#define YSI_GROUPS_LAST                      16
		#elseif YSI_SET_LAST_GROUP == 17
			#define YSI_GROUPS_LAST                      17
		#elseif YSI_SET_LAST_GROUP == 18
			#define YSI_GROUPS_LAST                      18
		#elseif YSI_SET_LAST_GROUP == 19
			#define YSI_GROUPS_LAST                      19
		#elseif YSI_SET_LAST_GROUP == 20
			#define YSI_GROUPS_LAST                      20
		#elseif YSI_SET_LAST_GROUP == 21
			#define YSI_GROUPS_LAST                      21
		#elseif YSI_SET_LAST_GROUP == 22
			#define YSI_GROUPS_LAST                      22
		#elseif YSI_SET_LAST_GROUP == 23
			#define YSI_GROUPS_LAST                      23
		#elseif YSI_SET_LAST_GROUP == 24
			#define YSI_GROUPS_LAST                      24
		#elseif YSI_SET_LAST_GROUP == 25
			#define YSI_GROUPS_LAST                      25
		#endif
		
		#define _YSIM_RESET_USER
		#include <YSI\y_master>
		
		#undef YSI_SET_LAST_GROUP
	#endif
	
#else
	#if defined YSI_SET_LAST_GROUP
		#undef YSI_SET_LAST_GROUP
	#endif*/

#if defined _YSIM_LAST_MANUAL
	#define _YSIM_RESET_USER
#else
	#define MASTER 23
	//GAAA
#endif
#include <YSI\y_master>

#if defined GROUP_LIBRARY_NAME && defined GROUP_LIBRARY_SIZE
//	#include <YSI\internal\y_groupsingle>
	#undef _GROUP_MAKE_NAME
	#undef _GROUP_MAKE_LIMIT
	#define _GROUP_MAKE_NAME        GROUP_LIBRARY_NAME
	#define _GROUP_MAKE_LIMIT       GROUP_LIBRARY_SIZE
#endif
//#endif
