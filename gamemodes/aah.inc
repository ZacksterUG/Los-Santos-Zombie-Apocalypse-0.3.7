#if defined ACWEAPS_Included
    #endinput
#endif

#define ACWEAPS_Included
#include <a_samp>

#if !defined FILTERSCRIPT
/*
Only one function:
- OnPlayerWeaponsHack(playerid, weaponid, ammo, type)

Types:

1 - Weapons Hack
2 - Ammo Hack
3 - Desynced
4 - Ammo freeze aka no reload aka infinite ammo
*/

#define AWH_IsPlayerPaused(%1) GetTickCount() > (AWH_WeaponsInfo[%1][AWH_Tick]+2000)

enum awhInfo
{
    AWH_Weapons[53],
    AWH_Slot[13],
    AWH_Ammo[53],
    bool:AWH_Immune,
    AWH_Tick,
    AWH_AmmoTick,
    AWH_LastAmmo[53],
    AWH_LastWeapon,
    bool:AWH_Spawned,
    AWH_Timer
};

static AWH_WeaponsInfo[MAX_PLAYERS][awhInfo];

#if defined OnPlayerConnectWeapons
forward OnPlayerConnectWeapons(playerid);
#endif

#if defined OnPlayerDeathWeapons
forward OnPlayerDeathWeapons(playerid, killerid, reason);
#endif

#if defined OnPlayerDisconnectWeapons
forward OnPlayerDisconnectWeapons(playerid, reason);
#endif

#if defined OnPlayerWeaponsHack
forward OnPlayerWeaponsHack(playerid, weaponid, ammo, type);
#endif

#if defined OnPlayerUpdateWeapons
forward OnPlayerUpdateWeapons(playerid);
#endif

#if defined OnPlayerSpawnWeapons
forward OnPlayerSpawnWeapons(playerid);
#endif

#if defined OnPlayerWeaponShotWeapons
forward OnPlayerWeaponShotWeapons(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

#if defined OnPlayerEnterVehicleWeapons
forward OnPlayerEnterVehicleWeapons(playerid, vehicleid, ispassenger);
#endif

#if defined OnPlayerExitVehicleWeapons
forward OnPlayerExitVehicleWeapons(playerid, vehicleid);
#endif

forward AWH_ResetImmune(playerid);
public AWH_ResetImmune(playerid)
{
    AWH_WeaponsInfo[playerid][AWH_Immune] = false;
    return 1;
}

forward CheckWeapons(playerid);
public CheckWeapons(playerid)
{
    if(AWH_IsPlayerPaused(playerid) || !AWH_WeaponsInfo[playerid][AWH_Spawned] || GetPlayerState(playerid) != 1) return 1;
    if(!AWH_WeaponsInfo[playerid][AWH_Immune])
    {
        new awh_id = GetPlayerWeapon(playerid);
        switch(awh_id)
        {
            case 46, 40, 0: return 0;
        }

        new awh_slot = GetWeaponSlot(awh_id);
        new awh_ammo = GetPlayerAmmo(playerid);

        if(AWH_WeaponsInfo[playerid][AWH_Weapons][awh_id] == 0)
        {
            #if defined OnPlayerWeaponsHack
            OnPlayerWeaponsHack(playerid, awh_id, awh_ammo, 1);
            #endif
        }
        else if((AWH_WeaponsInfo[playerid][AWH_Ammo][awh_id]-awh_ammo) > 50)
        {
            #if defined OnPlayerWeaponsHack
            OnPlayerWeaponsHack(playerid, awh_id, awh_ammo, 2);
            #endif
        }
        else if((AWH_WeaponsInfo[playerid][AWH_Ammo][awh_id]-awh_ammo) < 50)
        {
            AWH_WeaponsInfo[playerid][AWH_Ammo][awh_id] = awh_ammo;
        }
        else if(AWH_WeaponsInfo[playerid][AWH_Slot][awh_slot] != awh_id)
        {
            #if defined OnPlayerWeaponsHack
            OnPlayerWeaponsHack(playerid, awh_id, awh_ammo, 3);
            #endif
        }
    }
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(AWH_WeaponsInfo[playerid][AWH_AmmoTick] < gettime())
    {
        AWH_WeaponsInfo[playerid][AWH_AmmoTick] = gettime()+5;

        if(AWH_WeaponsInfo[playerid][AWH_LastWeapon] == weaponid && AWH_WeaponsInfo[playerid][AWH_LastAmmo][weaponid] != 0 && AWH_WeaponsInfo[playerid][AWH_LastAmmo][weaponid] == GetPlayerAmmo(playerid))
        {
            #if defined OnPlayerWeaponsHack
            OnPlayerWeaponsHack(playerid, weaponid, GetPlayerAmmo(playerid), 4);
            #endif
        }
        AWH_WeaponsInfo[playerid][AWH_LastWeapon] = weaponid;
        AWH_WeaponsInfo[playerid][AWH_LastAmmo][weaponid] = GetPlayerAmmo(playerid);
    }
    if(AWH_WeaponsInfo[playerid][AWH_Ammo][weaponid] <= 0)
    {
        AWH_WeaponsInfo[playerid][AWH_Ammo][weaponid] = 0;
        AWH_WeaponsInfo[playerid][AWH_Slot][GetWeaponSlot(weaponid)] = 0;
        AWH_WeaponsInfo[playerid][AWH_Weapons][weaponid] = 0;
    }
    else AWH_WeaponsInfo[playerid][AWH_Ammo][weaponid]--;
    #if defined OnPlayerWeaponShotWeapons
        return OnPlayerWeaponShotWeapons(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
    #else
        return 1;
    #endif
}

public OnPlayerDisconnect(playerid, reason)
{
    KillTimer(AWH_WeaponsInfo[playerid][AWH_Timer]);
    #if defined OnPlayerDisconnectWeapons
        return OnPlayerDisconnectWeapons(playerid, reason);
    #else
        return 1;
    #endif
}

public OnPlayerUpdate(playerid)
{
    AWH_WeaponsInfo[playerid][AWH_Tick] = GetTickCount();
    #if defined OnPlayerUpdateWeapons
        return OnPlayerUpdateWeapons(playerid);
    #else
        return 1;
    #endif
}

public OnPlayerDeath(playerid, killerid, reason)
{
    AWH_ResetVariables(playerid);
    #if defined OnPlayerDeathWeapons
        return OnPlayerDeathWeapons(playerid, killerid, reason);
    #else
        return 1;
    #endif
}

public OnPlayerConnect(playerid)
{
    AWH_ResetVariables(playerid);
    AWH_WeaponsInfo[playerid][AWH_Timer] = SetTimerEx("CheckWeapons", 1000, true, "i", playerid);
    #if defined OnPlayerConnectWeapons
        return OnPlayerConnectWeapons(playerid);
    #else
        return 1;
    #endif
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!AWH_WeaponsInfo[playerid][AWH_Immune]) SetTimerEx("AWH_ResetImmune", 3000, false, "i", playerid);
    AWH_WeaponsInfo[playerid][AWH_Immune] = true;
    #if defined OnPlayerEnterVehicleWeapons
        return OnPlayerEnterVehicleWeapons(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(!AWH_WeaponsInfo[playerid][AWH_Immune]) SetTimerEx("AWH_ResetImmune", 3000, false, "i", playerid);
    AWH_WeaponsInfo[playerid][AWH_Immune] = true;
    #if defined OnPlayerExitVehicleWeapons
        return OnPlayerExitVehicleWeapons(playerid, vehicleid);
    #else
        return 1;
    #endif
}

public OnPlayerSpawn(playerid)
{
    AWH_WeaponsInfo[playerid][AWH_Spawned] = true;
    AWH_WeaponsInfo[playerid][AWH_AmmoTick] = GetTickCount();
    #if defined OnPlayerSpawnWeapons
        return OnPlayerSpawnWeapons(playerid);
    #else
        return 1;
    #endif
}

static AWH_ResetVariables(playerid)
{
    for(new i = 0; i < 13; i++) AWH_WeaponsInfo[playerid][AWH_Ammo][i] = AWH_WeaponsInfo[playerid][AWH_Slot][i] = AWH_WeaponsInfo[playerid][AWH_LastAmmo][i] = 0;
    for(new i = 0; i < 53; i++) AWH_WeaponsInfo[playerid][AWH_Weapons][i] = 0;
    AWH_WeaponsInfo[playerid][AWH_LastWeapon] = 0;
    AWH_WeaponsInfo[playerid][AWH_Immune] = AWH_WeaponsInfo[playerid][AWH_Spawned] = false;
}

stock AWH_GivePlayerWeapon(playerid, weapon, ammo)
{
    AWH_WeaponsInfo[playerid][AWH_Weapons][weapon] = 1;
    AWH_WeaponsInfo[playerid][AWH_Slot][GetWeaponSlot(weapon)] = weapon;
    AWH_WeaponsInfo[playerid][AWH_Ammo][weapon] = ammo;
    if(!AWH_WeaponsInfo[playerid][AWH_Immune]) SetTimerEx("AWH_ResetImmune", 3000, false, "i", playerid);
    AWH_WeaponsInfo[playerid][AWH_Immune] = true;
    AWH_WeaponsInfo[playerid][AWH_LastAmmo][weapon] = ammo;
    return GivePlayerWeapon(playerid, weapon, ammo);
}

stock AWH_ResetPlayerWeapons(playerid)
{
    for(new i = 0; i < 53; i++)
    {
        AWH_WeaponsInfo[playerid][AWH_Weapons][i] = AWH_WeaponsInfo[playerid][AWH_Ammo][i] = AWH_WeaponsInfo[playerid][AWH_LastAmmo][i] = 0;
        if( i < 13) AWH_WeaponsInfo[playerid][AWH_Slot][i] = 0;
    }
    if(!AWH_WeaponsInfo[playerid][AWH_Immune]) SetTimerEx("AWH_ResetImmune", 3000, false, "i", playerid);
    AWH_WeaponsInfo[playerid][AWH_Immune] = true;

    return ResetPlayerWeapons(playerid);
}

static GetWeaponSlot(weaponid)
{
    switch(weaponid)
    {
        case 0..1:   return 0;
        case 2..9:   return 1;
        case 22..24: return 2;
        case 25..27: return 3;
        case 28..29: return 4;
        case 32:     return 4;
        case 30..31: return 5;
        case 33..34: return 6;
        case 35..38: return 7;
        case 16..18: return 8;
        case 39:     return 8;
        case 41..43: return 9;
        case 10..15: return 10;
        case 44..46: return 11;
        case 40:     return 12;
    }
    return 0; //if its a wrong weapon still return 0 to avoid crashes (if wrong slot ids crash JUST in case).
}

stock AWH_SetPlayerAmmo(playerid, weapon, ammo)
{
    AWH_WeaponsInfo[playerid][AWH_Ammo][weapon] = ammo;
    if(!AWH_WeaponsInfo[playerid][AWH_Immune]) SetTimerEx("AWH_ResetImmune", 3000, false, "i", playerid);
    AWH_WeaponsInfo[playerid][AWH_Immune] = true;
    return SetPlayerAmmo(playerid, weapon, ammo);
}

stock AWH_SetSpawnInfo(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
    AWH_WeaponsInfo[playerid][AWH_Weapons][weapon1] = 1;
    AWH_WeaponsInfo[playerid][AWH_Weapons][weapon2] = 1;
    AWH_WeaponsInfo[playerid][AWH_Weapons][weapon3] = 1;

    AWH_WeaponsInfo[playerid][AWH_Slot][GetWeaponSlot(weapon1)] = weapon1;
    AWH_WeaponsInfo[playerid][AWH_Slot][GetWeaponSlot(weapon2)] = weapon2;
    AWH_WeaponsInfo[playerid][AWH_Slot][GetWeaponSlot(weapon3)] = weapon3;

    AWH_WeaponsInfo[playerid][AWH_Ammo][weapon1] = weapon1_ammo;
    AWH_WeaponsInfo[playerid][AWH_Ammo][weapon2] = weapon2_ammo;
    AWH_WeaponsInfo[playerid][AWH_Ammo][weapon3] = weapon3_ammo;

    return SetSpawnInfo(playerid, team, skin, x, y, z, rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
}

#if defined _ALS_OnPlayerExitVehicle
    #undef OnPlayerExitVehicle
#else
    #define _ALS_OnPlayerExitVehicle
#endif

#define OnPlayerExitVehicle OnPlayerExitVehicleWeapons

#if defined _ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif

#define OnPlayerEnterVehicle OnPlayerEnterVehicleWeapons

#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif

#define OnPlayerWeaponShot OnPlayerWeaponShotWeapons

#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif

#define OnPlayerSpawn OnPlayerSpawnWeapons

#if defined _ALS_OnPlayerUpdate
  #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif

#define OnPlayerUpdate OnPlayerUpdateWeapons

#if defined _ALS_SetPlayerAmmo
    #undef SetPlayerAmmo
#else
    #define _ALS_SetPlayerAmmo
#endif

#define SetPlayerAmmo    AWH_SetPlayerAmmo

#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif

#define ResetPlayerWeapons AWH_ResetPlayerWeapons

#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon    AWH_GivePlayerWeapon

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect OnPlayerConnectWeapons

#if defined _ALS_OnPlayerDeath
  #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath OnPlayerDeathWeapons

#if defined _ALS_OnPlayerDisconnect
  #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect OnPlayerDisconnectWeapons

#if defined _ALS_SetSpawnInfo
    #undef SetSpawnInfo
#else
    #define _ALS_SetSpawnInfo
#endif
#define SetSpawnInfo    AWH_SetSpawnInfo

#else

stock AWH_ResetPlayerWeaponsFS(playerid)
    return CallLocalFunction("AWH_ResetPlayerWeapons", "i", playerid);

stock AWH_GivePlayerWeaponFS(playerid, weapon, ammo)
    return CallLocalFunction("AWH_GivePlayerWeapon","iii", playerid, weapon, ammo);

stock AWH_SetPlayerAmmoFS(playerid, weapon, ammo)
    return CallLocalFunction("AWH_SetPlayerAmmo", "iii", playerid, weapon, ammo);

stock AWH_SetSpawnInfoFS(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
    return CallLocalFunction("AWH_SetSpawnInfo", "iiiffffiiiiii", playerid, team, skin, x, y, z, rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);

#if defined _ALS_SetPlayerAmmo
    #undef SetPlayerAmmo
#else
    #define _ALS_SetPlayerAmmo
#endif

#define SetPlayerAmmo    AWH_SetPlayerAmmoFS

#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif

#define ResetPlayerWeapons AWH_ResetPlayerWeaponsFS

#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon    AWH_GivePlayerWeaponFS

#if defined _ALS_SetSpawnInfo
    #undef SetSpawnInfo
#else
    #define _ALS_SetSpawnInfo
#endif
#define SetSpawnInfo    AWH_SetSpawnInfoFS

#endif
