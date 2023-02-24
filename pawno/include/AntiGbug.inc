#include <YSI\y_hooks>

enum GBugVar
{
	Float:GbugPX,
	Float:GbugPY,
	Float:GbugPZ,
	Float:GbugVX,
	Float:GbugVY,
	Float:GbugVZ,
	EnteringVehicleID,
	bool:IsPlayerEntering
}

new GbugPInfo[MAX_PLAYERS][GBugVar];

#if defined _ALS_GetVehicleParamsEx
        #undef GetVehicleParamsEx
#else
        #define _ALS_GetVehicleParamsEx
#endif
#define GetVehicleParamsEx  GBug_GetVehicleParamsEx

Hook:GBug_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(ispassenger == 1)
	{
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(doors == 1) return 0;
		GetPlayerPos(playerid,GbugPInfo[playerid][GbugPX],GbugPInfo[playerid][GbugPY],GbugPInfo[playerid][GbugPZ]);
		GBugPInfo[playerid][IsPlayerEntering] = true;
		GetPlayerVehicleID(playerid,GBugPInfo[playerid][EnteringVehicleID])
	}
	else
	    GBugPInfo[playerid][IsPlayerEntering] = false;
	return 1;
}

Hook:GBug_OnPlayerStateChange(playerid,newstate,oldstate,)
{
	if(newstate == 3)
	{
	    if(GBugPInfo[playerid][IsPlayerEntering] == true)
	    {
			GetVehiclePos(GBugPInfo[playerid][EnteringVehicleID],GBugPInfo[playerid][GBugVX],GBugPInfo[playerid][GBugVY],GBugPInfo[playerid][GBugVZ]);
			if(!IsPlayerInRangeOfPoint(playerid,10,GBugPInfo[playerid][GBugVX],GBugPInfo[playerid][GBugVY],GBugPInfo[playerid][GBugVZ]))
			    SetPlayerPos(playerid,GbugPInfo[playerid][GbugPX],GbugPInfo[playerid][GbugPY],GbugPInfo[playerid][GbugPZ]);
		}
	}
	return 1;
}
