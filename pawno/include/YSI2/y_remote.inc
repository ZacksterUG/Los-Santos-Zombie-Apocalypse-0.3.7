/*----------------------------------------------------------------------------*\
								  ==========
								   y_remote
								  ==========
Description:
	Wrapper for "CallRemoteFunction".  Enforces some features like no returns
	and arrays being followed by their length.
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
	
	The Original Code is the YSI master systems include.
	
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
	-
Functions:
	Public:
		-
	Core:
		-
	Stock:
		-
	Static:
		-
	Inline:
		-
	API:
		-
	Hooks:
		-
Callbacks:
	-
Definitions:
	-
Enums:
	-
Macros:
	remote - Define a function to be called remotely (use like "stock").
	broadcast - Call the function, but in all scripts.
	local - Call the function by name, not address, in the current script.
Tags:
	-
Variables:
	Global:
		-
	Static:
		-
Commands:
	-
Compile options:
	-
Operators:
	-
Natives:
	-
\*----------------------------------------------------------------------------*/

#include <YSI\internal\y_version>

#include <YSI\internal\y_shortfunc>

#include <YSI\y_utils>

// IMPORTANT NOTE!  To avoid polluting the global name space (any more that is),
// "y_inline" uses @Ru, @Rv, @Rw, @Rx and @Ry, as both files are low usage.
// "y_testing" uses @Rf-@Ro.

#define remote%0(%1) stock%0@(%1)if(J@)W@(_:@Rz:#%0##,_YM@CR:%1,,);else P@(_:@Rz:#%0##,_YM@CR:%1,,);%0(%1);public%0(%1)//if(FALSE){}else

#define _YM@CR:%0,%1) @Ra:@Rb:@Rc:##|||%0|||%1)

#define @Ra:@Rb:@Rc:#%0#%1|||%3[%4]|||%5,%6) @Rd:@Re:#%0#%1|||%3|||%5,%6)

#define @Rd:@Re:#%0#%1|||%2string:%3|||%5,%6) @Ra:@Rb:@Rc:#%0s#%1,%3|||%5|||%6)
#define @Re:#%0#%1|||%3|||%5,%6,%7) @Ra:@Rb:@Rc:#%0a#%1,%3|||%5|||%6,%7)

#define @Rb:@Rc:#%0#%1|||%3|||%5,%6) @Ra:@Rb:@Rc:#%0i#%1,%3|||%5|||%6)

#define @Rc:%0||||||) %0)

#define @Rz:#%0##,_YM@CR:,,) #%0##,#)

#define local%0(%1) (J@=0,%0@(%1))
#define broadcast%0(%1) (J@=1,%0@(%1))
