#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     50
#include <mxini>

main(){}
public OnGameModeInit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    SetPlayerHealth(playerid, 100);
	SpawnPlayer(playerid);
	SetPlayerHealth(playerid, 100);
	return 1;
}


public OnPlayerSpawn(playerid)
{
	new vehicle;
	SetPlayerPos(playerid,0,0,10);
	vehicle = CreateVehicle(404,0,0,50,0,0,0,-1);
	SetVehicleParamsEx(vehicle,1,0,0,1,0,0,0);
	return 1;
}
