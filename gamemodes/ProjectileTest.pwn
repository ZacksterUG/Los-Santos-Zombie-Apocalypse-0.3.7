// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <colandreas>
#include <projectile>

#define function%0(%1)     												forward%0(%1); public%0(%1)
#define HUMAN                                                           1
#define ZOMBIE                                                          2
#define PRESSED(%0)  													(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0)														((newkeys & (%0)) == (%0))
#define RELEASED(%0)													(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#undef PROJECTILE_TIMER_INTERVAL
#define PROJECTILE_TIMER_INTERVAL           							1

#undef MAX_PLAYERS
#define MAX_PLAYERS                                                     50

main(){}


enum PlayerInfo
{
	Throwingstate,
	ThrowingTimer,
	ObjectProj,
	Object,
	Float:ObjAngz,
	Throwed,
	CanThrow,
};

new PInfo[MAX_PLAYERS][PlayerInfo];

public OnGameModeInit()
{
	CA_Init();
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
    PInfo[playerid][CanThrow] = 1;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(HOLDING(KEY_WALK) && HOLDING(KEY_CROUCH))
	{
	    if(PInfo[playerid][CanThrow] == 1)
	    {
		    PInfo[playerid][Throwingstate] = 1;
		    ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",5,0,0,0,1,500,1);
		    SetPlayerAttachedObject(playerid,1,2908,6,0.15,0,0.08,-90,180,90);
		    PInfo[playerid][ThrowingTimer] = SetTimerEx("MaxThrow",100,false,"i",playerid);
		}
	}
	if((oldkeys & KEY_CROUCH) && (oldkeys & KEY_WALK))
	{
		if(PInfo[playerid][CanThrow] == 1)
	    {
		    PInfo[playerid][Throwed] = 1;
		    RemovePlayerAttachedObject(playerid, 1);
		    KillTimer(PInfo[playerid][ThrowingTimer]);
		    new Float:x,Float:y,Float:z,Float:ang;
		    GetPlayerFacingAngle(playerid,ang);
		    GetPlayerPos(playerid,x,y,z);
		    PInfo[playerid][CanThrow] = 0;
		    PInfo[playerid][ObjAngz] = ang + 90;
		    if(PInfo[playerid][Throwingstate] <= 6)
		    	ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
			else if(PInfo[playerid][Throwingstate] > 6)
			    ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
		    PInfo[playerid][ObjectProj] = CreateProjectile(x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z + 0.5,(PInfo[playerid][Throwingstate]*2) * floatsin(-ang, degrees), (PInfo[playerid][Throwingstate]*2) * floatcos(-ang, degrees), PInfo[playerid][Throwingstate] * 1.3, 0, 0, 0, 0.1, 0, 0, 0, 24, 0, true, 1.5);
			PInfo[playerid][Throwingstate] = 0;
		}
	}
	return 1;
}

function MaxThrow(playerid)
{
	if(PInfo[playerid][Throwed] == 0)
	{
	    PInfo[playerid][Throwingstate] ++;
	    if(PInfo[playerid][Throwingstate] < 10)
	    	SetTimerEx("MaxThrow",100,false,"i",playerid);
	}
    return 1;
}

public OnProjectileUpdate(projid)
{
	new Float:x,Float:y,Float:z;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(IsValidProjectile(PInfo[i][ObjectProj]))
	    {
	        //DestroyDynamicObject(PInfo[i][Object]);
	        DestroyObject(PInfo[i][Object]);
	        PInfo[i][Object] = CreateObject(2908,x,y,z,270, 180,PInfo[i][ObjAngz]);
	        GetProjectilePos(PInfo[i][ObjectProj],x,y,z);
			SetObjectPos(PInfo[i][Object],x,y,z);
	    }
	}
	return 1;
}

public OnProjectileCollide(projid, type, Float:x, Float:y, Float:z, extraid)
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(IsValidProjectile(PInfo[i][ObjectProj]))
	    {
	        new Float:vx,Float:vy,Float:vz;
			GetProjectileVel(PInfo[i][ObjectProj],vx,vy,vz);
  			UpdateProjectileVel(PInfo[i][ObjectProj],0,0,-5);
	    }
	}
	return 1;
}

public OnProjectileStop(projid)
{
    new Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(IsValidProjectile(PInfo[i][ObjectProj]))
	    {
	        GetProjectilePos(PInfo[i][ObjectProj],x,y,z);
	        GetProjectileRot(PInfo[i][ObjectProj],rx,ry,rz);
	        SetObjectPos(PInfo[i][Object],x,y,z);
	        DestroyProjectile(PInfo[i][ObjectProj]);
	        PInfo[i][Throwed] = 0;
	        PInfo[i][CanThrow] = 1;
	    }
	}
	return 1;
}
