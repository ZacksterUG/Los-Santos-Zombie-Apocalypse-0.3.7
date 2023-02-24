#include <a_samp>
#include <crashdetect>
#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     1000
#define FIXES_ServerVarMsg 0
#include <fixes>
//#include <nex-ac>
#include <sscanf2>
#include <streamer>
#include <foreach>
#include <SII>
#include <colandreas>
#include <BossArena>
#include <FCNPC>
#include <projectile>

new TICKPASSED = 0;

forward SetPlayerPosAngle(playerid, Float:posX, Float:posY, Float:posZ, Float:angle);
forward unfreeze(playerid);
forward FreezePlayer(playerid, time);
forward UpdateServer();

enum playerInfo
{
	Spawned,
	Dead,
};

new PInfo[MAX_PLAYERS][playerInfo];

new Float:playerSpawns[15][4] =
{
	{553.9218,4199.4854,109.7900,53.3078},
	{557.9146,4210.0098,109.7900,74.1054},
	{557.7877,4224.5986,109.7499,103.1674},
	{552.2491,4236.9111,109.7499,131.2501},
	{544.7863,4245.5903,109.7499,151.6953},
	{531.5009,4250.2935,109.7499,172.6497},
	{513.2897,4248.5142,109.7499,206.7642},
	{500.1201,4234.9307,109.7499,240.6045},
	{496.4466,4218.6250,109.7499,267.0031},
	{501.5424,4203.7173,109.7569,301.5876},
	{515.7079,4193.2168,109.7569,338.0129},
	{535.0733,4193.2197,109.7499,18.2375},
	{548.2585,4200.2905,109.7499,45.9677},
	{553.4922,4213.1846,109.7499,79.3381},
	{555.9614,4227.3560,109.7499,101.0366}
};

new weatherID[5] = {7,9,16,19,22};

new gameStatus;

main(){}

public OnGameModeInit()
{
	SetTimer("UpdateServer",100,false);
	gameStatus = 0;
    LoadObj();
	for(new i = 280; i <= 288; i++) AddPlayerClass(i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PInfo[playerid][Spawned])
	{
	    SpawnPlayer(playerid);
		ToSpawn(playerid);
	}
	new Float:posX = 222.7381,Float:posY = 1822.6913,Float:posZ = 6.4141, Float:angle = 269.9055;
	new Float:camX, Float:camY, Float:camZ;
	SetPlayerPosAngle(playerid, posX, posY, posZ, angle);
	camX = posX + 5*floatsin(-angle,degrees);
	camY = posY + 5*floatcos(-angle,degrees);
	camZ = posZ + 0.5;
	SetPlayerCameraPos(playerid, camX, camY, camZ);
	SetPlayerCameraLookAt(playerid, posX, posY, posZ+0.5);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	PInfo[playerid][Spawned] = 0;
	PInfo[playerid][Dead] = 0;
	SetPlayerTime(playerid,23,0);
    ForceClassSelection(playerid);
    TogglePlayerSpectating(playerid, true);
    TogglePlayerSpectating(playerid, false);
    SetPlayerWeather(playerid,weatherID[random(sizeof(weatherID))]);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!PInfo[playerid][Spawned]) {ToSpawn(playerid), PInfo[playerid][Spawned] = 1;}
	if(PInfo[playerid][Dead]) {ToSpawn(playerid); PInfo[playerid][Dead] = 0;}
    GiveRandomWeapon(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	PInfo[playerid][Dead] = 1;
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public SetPlayerPosAngle(playerid, Float:posX, Float:posY, Float:posZ, Float:angle)
{
	if(!IsPlayerConnected(playerid)) return 0;
	SetPlayerPos(playerid, posX, posY, posZ);
	SetPlayerFacingAngle(playerid,angle);
	return 1;
}

public FreezePlayer(playerid, time)
{
	if(!IsPlayerConnected(playerid)) return 0;
	TogglePlayerControllable(playerid,0);
	SetTimerEx("unfreeze",time,false,"i",playerid);
	return 1;
}

public unfreeze(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	TogglePlayerControllable(playerid,1);
	return 1;
}

stock GiveRandomWeapon(playerid)
{
	if(!IsPlayerConnected(playerid)) return;
	GivePlayerWeapon(playerid,22+random(3),2000);
	GivePlayerWeapon(playerid,26+random(3),2000);
	GivePlayerWeapon(playerid,27+random(5),2000);
}

stock ToSpawn(playerid)
{
	new rand = random(15);
 	SetPlayerPosAngle(playerid,playerSpawns[rand][0],playerSpawns[rand][1],playerSpawns[rand][2],playerSpawns[rand][3]);
	FreezePlayer(playerid,1500);
	return 1;
}

public UpdateServer()
{
    TICKPASSED += 100;
	foreach(new i: Player)
	{
	    if(PInfo[i][Dead] == 1) continue;
	    if(PInfo[i][Spawned] == 0) continue;
		if(!IsPlayerInRangeOfPoint(i,45,526.5095,4219.8394,109.7499))
		{
		    PInfo[i][Dead] = 1;
		    SetPlayerHealth(i,0);
		}
	}
    SetTimer("UpdateServer",100,false);
}
