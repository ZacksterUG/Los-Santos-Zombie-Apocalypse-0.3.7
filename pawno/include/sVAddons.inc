//-----------------------------------------------------------------------------------|
//                                    [svAddons]                                     |
//                                                                                   |
//                                                                                   |
//   - You may not remove these credits                                              |
//   - You may not claim this script as yours                                        |
//                                                                                   |
//                                                                                   |
//                                                                                   |
// [VERSION 1.4]                                               Created by SuperViper |
//-----------------------------------------------------------------------------------|

#include <a_samp>

// ==================================== SETTINGS ================================== //|
//                                                                                  //|
/* Comment if you would like to disable server stats from saving and loading */     //|
#define ENABLE_SERVERSTATSTOTAL                                                     //|
//                                                                                  //|
// ================================================================================ //|
//                         DO NOT TOUCH ANYTHING BELOW THIS                         //|
// ================================================================================ //|

#define SVCS_svAddons

// Vehicle Information
#define VEHICLE_INFO_ENGINE    	    (0)
#define VEHICLE_INFO_LIGHTS     	(1)
#define VEHICLE_INFO_ALARM      	(2)
#define VEHICLE_INFO_DOORS      	(3)
#define VEHICLE_INFO_BONNET     	(4)
#define VEHICLE_INFO_BOOT       	(5)
#define VEHICLE_INFO_OBJECTIVE  	(6)

// Object Editing Modes
#define OBJECT_EDITING_NONE     	(0)
#define OBJECT_EDITING_NORMAL   	(1)
#define OBJECT_EDITING_PLAYER   	(2)
#define OBJECT_EDITING_ATTACHED 	(3)

// Death Effects
#define DEATH_EFFECT_NONE       	(0)
#define DEATH_EFFECT_REDGAS     	(1)
#define DEATH_EFFECT_SMOKE      	(2)
#define DEATH_EFFECT_EXPLODE    	(3)
#define DEATH_EFFECT_MINEXPLODE 	(4)
#define DEATH_EFFECT_FIRE       	(5)

// Whitelist Modes
#define WHITELIST_MODE_NONE			(0)
#define WHITELIST_MODE_ALLOWPLAYER	(1)
#define WHITELIST_MODE_SPECIFICIP	(2)
#define WHITELIST_MODE_IP_FIND		(3)

// Skin Genders
#define SKIN_GENDER_NONE			(0)
#define SKIN_GENDER_MALE			(1)
#define SKIN_GENDER_FEMALE			(2)

// Server Stats
#define SERVER_STATS_UPTIME			(0)
#define SERVER_STATS_TOTAL			(1)

#define SERVER_STATS_CONNECTIONS	(0)
#define SERVER_STATS_KICKS			(1)
#define SERVER_STATS_VEHICLES		(2)
#define SERVER_STATS_OBJECTS		(3)
#define SERVER_STATS_PLAYERS		(4)
#define SERVER_STATS_TOTALVEHICLES	(5)
#define SERVER_STATS_TOTALOBJECTS	(6)
#define SERVER_STATS_KILLS			(7)
#define SERVER_STATS_DEATHS			(8)
#define SERVER_STATS_TOTALDAMAGE	(9)

// Maximum Values
#define MAX_INTEGER_LENGTH			(12)
#define MAX_IP_LENGTH				(17)
#define MAX_WEAPON_NAME 			(24)
#define MAX_CLIENT_MESSAGE			(128)
#define MAX_WEAPON_AMMO				(32767)
#define MAX_INTEGER_VALUE			(2147483647)

// Variable Declaration
#define S_IP[%0] new %0[MAX_IP_LENGTH]
#define S_Player[%0] new %0[MAX_PLAYER_NAME]
#define S_Weapon[%0] new %0[MAX_WEAPON_NAME]
#define S_Chat[%0] new %0[MAX_CLIENT_MESSAGE]

// ETC Defines
#define INVALID_VALUE				(65535)

forward OnVehicleCreate(vehicleid);
forward OnPlayerTouchTrigger(playerid, triggerid);
forward OnPlayerPausedUpdate(playerid, bool: paused);
forward OnPlayerWeaponUpdate(playerid, newgun, oldgun);
forward OnReceiveClientMessage(playerid, color, message[]);
forward OnPlayerWaterStatusUpdate(playerid, bool: inWater);
forward OnRconLoginBlocked(playerid, ip[], password[], success);
forward OnPlayerStreamedAudioChange(playerid, stopped, audiourl[]); // Currently disabled due to server crash when used in script
forward OnPlayerSpecialActionChange(playerid, oldaction, newaction);

enum e_svAddons_LocationTriggers
{
	bool: svtBeingUsed,
	svtPickupID,
	svtInterior,
}

new svAddons_oldURL[MAX_PLAYERS][256], svAddons_PlayerAudioLoops[MAX_PLAYERS], svAddons_PlayerLoopTime[MAX_PLAYERS];
new bool: svAddons_cVehiclePlate[MAX_VEHICLES], svAddons_VehiclePlate[MAX_VEHICLES][20];
new svAddons_EditingObjectState[MAX_PLAYERS], svAddons_EditingObject[MAX_PLAYERS];
new svAddons_PlayerTabbedUpdates[MAX_PLAYERS], bool: svAddons_PlayerTabbed[MAX_PLAYERS];
new bool: svAddons_BeingCrashed[MAX_PLAYERS], svAddons_CrashObject[MAX_PLAYERS];
new bool: svAddons_DisabledSprunk;
new svAddons_Whitelist, svAddons_WhitelistIP[17], bool: svAddons_Whitelisted[MAX_PLAYERS];
new svAddons_PlayerWeapon[MAX_PLAYERS];
new svAddons_DeathEffect[MAX_PLAYERS];
new svAddons_VehicleInterior[MAX_PLAYERS];
new bool: svAddons_Reconnecting[MAX_PLAYERS], svAddons_ReconnectingIP[MAX_PLAYERS][17];
new svAddons_VehicleTrailers[MAX_VEHICLES];
new bool: svAddons_InWater[MAX_PLAYERS];
new Float: svAddons_VehicleData[MAX_VEHICLES][4], svAddons_VehicleDataEx[MAX_VEHICLES][3];
new bool: svAddons_KickImmune[MAX_PLAYERS], bool: svAddons_BanImmune[MAX_PLAYERS];
new svAddons_LocationTriggers[200][e_svAddons_LocationTriggers], bool: svAddons_TriggerCreated;
new Float: svAddons_PickupPosition[MAX_PICKUPS][3], svAddons_PickupWorld[MAX_PICKUPS];
new bool: svAddons_PlayerWeaponSwitch[MAX_PLAYERS];
new bool: svAddons_LagShooting = true, svAddons_Team[MAX_PLAYERS], bool: svAddons_HasGodmode[MAX_PLAYERS];
new bool: svAddons_PlayerControllable[MAX_PLAYERS];
new svAddons_ServerStats[2][10];

new svAddons_WeaponData[47][2] = 
{
	{0, 0}, // Fist
	{0, 0}, // Brass Knuckles
	{0, 0}, // Golf Club
	{0, 0}, // Nightstick
	{0, 0}, // Knife
	{0, 0}, // Baseball Bat
	{0, 0}, // Shovel
	{0, 0}, // Pool Cue
	{0, 0}, // Katana
	{0, 0}, // Chainsaw
	{0, 0}, // Double-ended Dildo
	{0, 0}, // Dildo
	{0, 0}, // Vibrator
	{0, 0}, // Silver Vibrator
	{0, 0}, // Flowers
	{0, 0}, // Cane
	{0, 0}, // Grenade
	{0, 0}, // Teargas
	{0, 0}, // Molotov Cocktail
	{0, 0}, // None
	{0, 0}, // None
	{0, 0}, // None
	{0, 0}, // 9mm
	{0, 0}, // Silenced 9mm
	{0, 0}, // Desert Eagle
	{0, 0}, // Shotgun
	{0, 0}, // Sawnoff Shotgun
	{0, 0}, // Combat Shotgun
	{0, 0}, // Uzi
	{0, 0}, // MP5
	{0, 0}, // AK-47
	{0, 0}, // M4
	{0, 0}, // Tec-9
	{0, 0}, // Country Rifle
	{0, 0}, // Sniper Rifle
	{0, 0}, // RPG
	{0, 0}, // Heat-Seaking Rocket Launcher
	{0, 0}, // Flamethrower
	{0, 0}, // Minigun
	{0, 0}, // Satchel Charge
	{0, 0}, // Detonator
	{0, 0}, // Spraycan
	{0, 0}, // Fire Extinguisher
	{0, 0}, // Camera
	{0, 0}, // Nightvision Goggles
	{0, 0}, // Thermal Goggles
	{0, 0} // Parachute
};

new svAddons_VehicleNames[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratium", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
    "Police Rancher", "Picador", "Splashy", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

new svAddons_WeaponNames[][] =
{
	"Fist", "Brass Knuckles", "Golf Club", "Nightstick", "Knife", "Baseball Bat", "Shovel", "Pool Cue", "Katana",
	"Chainsaw", "Double-ended Dildo", "Dildo", "Vibrator", "Silver Vibrator", "Flowers", "Cane", "Grenade", "Tear Gas",
	"Molotov Cocktail", "", "", "", "9mm", "Silenced 9mm", "Desert Eagle", "Shotgun", "Sawnoff Shotgun", "Combat Shotgun",
	"Uzi", "MP5", "AK-47", "M4", "Tec-9", "Country Rifle", "Sniper Rifle", "RPG", "HS Rocket", "Flamethrower", "Minigun",
	"Satchel Charge", "Detonator", "Spraycan", "Fire Extinguisher", "Camera", "Night Vision Goggles", "Thermal Goggles",
	"Parachute"
};

#define IsPlayerSwimming IsPlayerInWater

stock IsPlayerInWater(playerid)
{
	new animationIndex = GetPlayerAnimationIndex(playerid);
	return (animationIndex >= 1538 && animationIndex <= 1544 && animationIndex != 1542);
}

stock SetPlayerPosEx(playerid, Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0, Float: angle = 0.0)
{
	SetPlayerVirtualWorld(playerid, virtualworld);
	SetPlayerInterior(playerid, interior);
	SetPlayerPos(playerid, posX, posY, posZ);
	SetPlayerFacingAngle(playerid, angle);
	return 1;
}

stock GetPlayersName(playerid)
{
	new playersName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playersName, MAX_PLAYER_NAME);
	return playersName;
}

stock GetPlayersNameEx(playerid)
{
	new playersName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playersName, MAX_PLAYER_NAME);
	for(new i = 0; i < strlen(playersName); i++)
	{
	    if(playersName[i] == '_')
	    {
	        playersName[i] = ' ';
	    }
	}
	return playersName;
}

stock CrashPlayer(playerid)
{
	new Float: playersPos[3];
	svAddons_BeingCrashed[playerid] = true;
	GetPlayerPos(playerid, playersPos[0], playersPos[1], playersPos[2]);
	return svAddons_CrashObject[playerid] = CreatePlayerObject(playerid, 385, playersPos[0], playersPos[1], playersPos[2], 0.0, 0.0, 0.0);
}

stock GetPlayersIP(playerid)
{
	new playersIP[17];
	GetPlayerIp(playerid, playersIP, 17);
	return playersIP;
}

stock ExplodePlayer(playerid)
{
	new Float: playersPos[3];
	GetPlayerPos(playerid, playersPos[0], playersPos[1], playersPos[2]);
	return CreateExplosion(playersPos[0], playersPos[1], playersPos[2], 6, 10.0);
}

stock ExplodeVehicle(vehicleid)
{
	new Float: vehiclesPos[3];
	GetVehiclePos(vehicleid, vehiclesPos[0], vehiclesPos[1], vehiclesPos[2]);
	return CreateExplosion(vehiclesPos[0], vehiclesPos[1], vehiclesPos[2], 6, 10.0);
}

stock SetPlayerMoney(playerid, amount)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, amount);
}

stock GivePlayerJetpack(playerid)
{
	return SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
}

stock IsPlayerSpawned(playerid)
{
	new playerState = GetPlayerState(playerid);
    return ((playerState >= 1 && playerState <= 6) || playerState == 8);
}

stock GetVehicleInfo(vehicleid, infoType)
{
	new vInfo[7];
	GetVehicleParamsEx(vehicleid, vInfo[0], vInfo[1], vInfo[2], vInfo[3], vInfo[4], vInfo[5], vInfo[6]);
	return (infoType <= 6) ? vInfo[infoType] : -1;
}

stock SetVehicleInfo(vehicleid, infoType, value)
{
	new vInfo[7];
	GetVehicleParamsEx(vehicleid, vInfo[0], vInfo[1], vInfo[2], vInfo[3], vInfo[4], vInfo[5], vInfo[6]);
	if(infoType <= 6) vInfo[infoType] = value;
	return (infoType <= 6) ? SetVehicleParamsEx(vehicleid, vInfo[0], vInfo[1], vInfo[2], vInfo[3], vInfo[4], vInfo[5], vInfo[6]) : -1;
}

stock IsPlayerInVehicleFireMode(playerid)
{
	return (GetPlayerCameraMode(playerid) == 55);
}

stock GetVehicleDriver(vehicleid)
{
	new vehicleDriver = INVALID_PLAYER_ID;
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	        {
		        if(GetPlayerVehicleID(i) == vehicleid)
		        {
					vehicleDriver = i;
					break;
		        }
	        }
	    }
	}
	
	return vehicleDriver;
}

stock GetVehiclePassengers(vehicleid, &passengerOne = INVALID_PLAYER_ID, &passengerTwo = INVALID_PLAYER_ID, &passengerThree = INVALID_PLAYER_ID)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(GetPlayerState(i) == PLAYER_STATE_PASSENGER)
	        {
	            if(GetPlayerVehicleID(i) == vehicleid)
	            {
					switch(GetPlayerVehicleSeat(i))
					{
					    case 1: passengerOne = i;
					    case 2: passengerTwo = i;
					    case 3: passengerThree = i;
					}
	            }
	        }
	    }
	}
}

stock GetVehicleNumberPlate(vehicleid)
{
	return (svAddons_cVehiclePlate[vehicleid] == true) ? svAddons_VehiclePlate[vehicleid] : "XYZR 000";
}

stock IsPlayerSpectating(playerid)
{
	return (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING):
}

stock GetPlayerObjectEditingState(playerid)
{
	return svAddons_EditingObjectState[playerid];
}

stock GetPlayerEditingObject(playerid)
{
	return (svAddons_EditingObjectState[playerid] == OBJECT_EDITING_NONE) ? -1 : svAddons_EditingObject[playerid];
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	return SetPlayerAmmo(playerid, weaponid, 0);
}

stock ClosePlayerDialog(playerid)
{
	return ShowPlayerDialog(playerid, -1, 1, " ", " ", " ", "");
}

stock SetPlayerDeathEffect(playerid, deffid)
{
	return svAddons_DeathEffect[playerid] = deffid;
}

stock GetPlayerDeathEffect(playerid)
{
	return svAddons_DeathEffect[playerid];
}

stock DisableSprunkMachines()
{
	return svAddons_DisabledSprunk = true;
}

stock ChangeServerPassword(password[])
{
	new rconCMD[50];
	format(rconCMD, sizeof(rconCMD), "password %s", password);
	return SendRconCommand(rconCMD);
}

stock LoadFilterscript(scriptName[], bool: reload = false)
{
	new rconCMD[50], sof = sizeof(rconCMD);
	format(rconCMD, sof, "loadfs %s", scriptName);
	if(reload == true)
	{
	    format(rconCMD, sof, "re%s", rconCMD);
	}
	return SendRconCommand(rconCMD);
}

stock UnloadFilterscript(scriptName[])
{
	new rconCMD[50];
	format(rconCMD, sizeof(rconCMD), "unloadfs %s", scriptName);
	return SendRconCommand(rconCMD);
}

stock ChangeServerName(serverName[])
{
	new rconCMD[50];
	format(rconCMD, sizeof(rconCMD), "hostname %s", serverName);
	return SendRconCommand(rconCMD);
}

stock SendServerRCONMessage(message[])
{
	new rconCMD[120];
	format(rconCMD, sizeof(rconCMD), "say %s", message);
	return SendRconCommand(rconCMD);
}

stock SendMessageToRCONAdmins(color, message[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerAdmin(i))
	    {
	        SendClientMessage(i, color, message);
	    }
	}
}

stock ChangeServerWebsite(url[])
{
	new rconCMD[128];
	format(rconCMD, sizeof(rconCMD), "weburl %s", url);
	return SendRconCommand(rconCMD);
}

stock ChangeMapName(mName[])
{
	new rconCMD[60];
	format(rconCMD, sizeof(rconCMD), "mapname %s", mName);
	return SendRconCommand(rconCMD);
}

stock IsValidSkin(skinID)
{
	return (skinID != 74);
}

stock ClearPlayersChat(playerid, bool: includeScrollingChat = false)
{
	for(new i = 0; i < (includeScrollingChat == true) ? 100 : 25; i++)
	{
	    SendClientMessage(playerid, -1, "");
	}
}

stock ClearAllPlayersChat(bool: includeScrollingChat = false)
{
	for(new i = 0; i < (includeScrollingChat == true) ? 100 : 25; i++)
	{
	    SendClientMessageToAll(-1, "");
	}
}

stock TeleportPlayerToPlayer(playerid, giveplayerid, Float: offsetX = 1.0, Float: offsetY = 0.0, Float: offsetZ = 0.0)
{
	new Float: playersPos[3];
	GetPlayerPos(giveplayerid, playersPos[0], playersPos[1], playersPos[2]);
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
	SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
	return SetPlayerPos(playerid, playersPos[0] + offsetX, playersPos[1] + offsetY, playersPos[2] + offsetZ);
}

stock StopVehicleMovement(vehicleid)
{
	return SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
}

stock GetVehicleSpeed(vehicleid)
{
    new Float: vehiclesVelocity[3];
	GetVehicleVelocity(vehicleid, vehiclesVelocity[0], vehiclesVelocity[1], vehiclesVelocity[2]);
	return floatround(floatsqroot((vehiclesVelocity[0]*vehiclesVelocity[0]+vehiclesVelocity[1]*vehiclesVelocity[1])) * 100.0 * 1.6);
}

stock GetVehicleModelName(modelID)
{
	new vehiclesName[25];
	if(modelID >= 400 && modelID <= 612)
	{
	    format(vehiclesName, sizeof(vehiclesName), "%s", svAddons_VehicleNames[modelID - 400]);
	}
	return vehiclesName;
}

stock GetVehicleIDFromName(string[], bool: useFind = false)
{

	if(string[0] >= '0' && string[0] <= '9')
	{
		new id = strval(string);
		if(id >= 400 && id <= 612)
		{
			return id;
		}
	}
	else
	{
		if(useFind == false)
		{
			for(new i = 0, sof = sizeof(svAddons_VehicleNames); i < sof; i++)
			{
				if(!strcmp(svAddons_VehicleNames[i], string, true))
				{
					return i + 400;
				}
			}
		}
		else if(useFind == true)
		{
			for(new i = 0, sof = sizeof(svAddons_VehicleNames); i < sof; i++)
			{
				if(strfind(svAddons_VehicleNames[i], string, true) != -1)
				{
					return i + 400;
				}
			}
		}
	}
	
	return 0;
}

stock GetWeaponID(weaponName[], bool: ignoreCase = true, bool: useFind = false)
{
	new weaponID = -1;
	if(useFind == false)
	{
		for(new i = 0, sof = sizeof(svAddons_WeaponNames); i < sof; i++)
		{
		    if(!strcmp(svAddons_WeaponNames[i], weaponName, ignoreCase))
		    {
		        weaponID = i;
		        break;
		    }
		}
	}
	else if(useFind == true)
	{
	    for(new i = 0, sof = sizeof(svAddons_WeaponNames); i < sof; i++)
		{
		    if(strfind(svAddons_WeaponNames[i], weaponName, ignorecase) > -1)
		    {
		        weaponID = i;
		        break;
		    }
		}
	}
	return weaponID;
}

stock GetPlayerIDFromIP(ip[], bool: useFind = false)
{
	new playerid = INVALID_PLAYER_ID, playersIP[17];
	if(useFind == false)
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
	    {
	        if(IsPlayerConnected(i))
	        {
	            GetPlayerIp(i, playersIP, 17);
	            if(!strcmp(playersIP, ip))
	            {
	                playerid = i;
	                break;
	            }
	        }
	    }
	}
	else if(useFind == true)
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
	    {
	        if(IsPlayerConnected(i))
	        {
	            GetPlayerIp(i, playersIP, 17);
	            if(strfind(playersIP, ip) > -1)
	            {
	                playerid = i;
	                break;
	            }
	        }
	    }
	}
	return playerid;
}

stock CountTotalPlayers()
{
	new count;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        count++;
	    }
	}
	return count;
}

stock CountTotalRCONAdmins()
{
    new count;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerAdmin(i))
	    {
	        count++;
	    }
	}
	return count;
}

stock CountTotalNPCs()
{
    new count;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerNPC(i))
	    {
	        count++;
	    }
	}
	return count;
}

stock CountTotalPausedPlayers()
{
    new count;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
			if(svAddons_PlayerTabbed[i] == true)
			{
	        	count++;
	        }
	    }
	}
	return count;
}

stock Float: GetVehiclesAngle(vehicleid)
{
	new Float: vehiclesAngle;
	GetVehicleZAngle(vehicleid, vehiclesAngle);
	return vehiclesAngle;
}

stock Float: GetVehiclesHealth(vehicleid)
{
	new Float: vehiclesHealth;
	GetVehicleHealth(vehicleid, vehiclesHealth);
	return vehiclesHealth;
}

stock Float: GetPlayersHealth(playerid)
{
	new Float: playersHealth;
	GetPlayerHealth(playerid, playersHealth);
	return playersHealth;
}

stock Float: GetPlayersArmour(playerid)
{
	new Float: playersArmor;
	GetPlayerArmour(playerid, playersArmor);
	return playersArmor);
}

stock EnableWhitelist(mode = WHITELIST_MODE_ALLOWPLAYER, ip[] = "")
{
	if(mode == WHITELIST_MODE_NONE)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			svAddons_Whitelisted[i] = false;
		}
	}
	else if(mode == WHITELIST_MODE_SPECIFICIP)
	{
		format(svAddons_WhitelistIP, 17, ip);
	}
		
	return svAddons_Whitelist = mode;
}

stock GetWhitelistMode()
{
	return svAddons_Whitelist;
}

stock AddPlayerToWhitelist(playerid)
{
	if(svAddons_Whitelist != WHITELIST_MODE_ALLOWPLAYER)
	{
		return printf("(svAddons) AddPlayerToWhitelist(playerid = %d) failed because whitelist mode is not WHITELIST_MODE_ALLOWPLAYER", playerid);
	}
	
	return svAddons_Whitelisted[playerid] = true;
}

stock IsPlayerWhitelisted(playerid)
{
	return svAddons_Whitelisted[playerid];
}

stock GetVehicleInterior(vehicleid)
{
	return svAddons_VehicleInterior[vehicleid];
}

stock IsPlayerBehindVehicle(playerid, vehicleid)
{
	new Float: vehicleInfo[3];
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_WHEELSREAR, vehicleInfo[0], vehicleInfo[1], vehicleInfo[2]);
	return (IsPlayerInAnyVehicle(playerid)) ? 0 : IsPlayerInRangeOfPoint(playerid, 2.0, vehicleInfo[0], vehicleInfo[1], vehicleInfo[2];
}

stock ReconnectPlayer(playerid)
{
	new rconCMD[50];
	svAddons_Reconnecting[playerid] = true;
	GetPlayerIp(playerid, svAddons_ReconnectingIP[playerid], 17);
	format(rconCMD, sizeof(rconCMD), "banip %s", svAddons_RconnectingIP[playerid]);
	return SendRconCommand(rconCMD);
}

stock GetVehicleTrailerCount(vehicleid)
{
	return svAddons_VehicleTrailers[vehicleid];
}

stock GetFreeVehicleSeat(vehicleid)
{
    new bool: vehicleSeatStatus[4];

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(GetPlayerVehicleID(i) == vehicleid)
        {
            vehicleSeatStatus[GetPlayerVehicleSeat(i)] = true;
        }
    }

    for(new i = 0; i < 4; i++)
    {
        if(vehicleSeatStatus[i] == true)
        {
            return i;
        }
    }

    return INVALID_VEHICLE_ID;
}

stock GetVehicleSpawnInfo(vehicleid, &Float: spawnX, &Float: spawnY, &Float: spawnZ, &Float: spawnR, &color1, &color2, &respawndelay)
{
	spawnX = svAddons_VehicleData[vehicleid][0];
	spawnY = svAddons_VehicleData[vehicleid][1];
	spawnZ = svAddons_VehicleData[vehicleid][2];
	spawnR = svAddons_VehicleData[vehicleid][3];
	color1 = svAddons_VehicleDataEx[vehicleid][0];
	color2 = svAddons_VehicleDataEx[vehicleid][1];
	respawndelay = svAddons_VehicleDataEx[vehicleid][2];
	return 1;
}

stock CapitalizePlayerName(playerid)
{
	new playersName[MAX_PLAYER_NAME], foundUnderscore, capitalizingCharacter;
	GetPlayerName(playerid, playersName, MAX_PLAYER_NAME);
	SetPlayerName(playerid, GetPlayerTemporaryName(playerid));
	playersName[0] = toupper(playersName[0]);
	foundUnderscore = strfind(playersName, "_");
	
	while(foundUnderscore > -1)
	{
		capitalizingCharacter = foundUnderscore + 1;
		playersName[capitalizingCharacter] = toupper(playersName[capitalizingCharacer]);
		foundUnderscore = strfind(playersName, "_");
	}
	
	return SetPlayerName(playerid, playersName);;
}

stock GetPlayerTemporaryName(playerid)
{
	new playersName[MAX_PLAYER_NAME];
	format(playersName, MAX_PLAYER_NAME, "SVANAME_temp_%d", playerid);
	return playersName;
}

stock GetStringCharacterCount(string[], character)
{
	new characterCount;
	
	for(new i = 0, len = strlen(string); i < len; i++)
	{
		if(string[i] == character)
		{
			characterCount++;
		}
	}
	
	return characterCount;
}

stock SetVehiclePosEx(vehicleid, Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0, Float: angle = 0.0)
{
	SetVehicleVirtualWorld(vehicleid, virtualworld);
	LinkVehicleToInterior(vehicleid, interior);
	SetVehiclePos(vehicleid, posX, posY, posZ);
	SetVehicleZAngle(vehicleid, angle);
	svAddons_VehicleInterior[vehicleid] = interior;
	return 1;
}

stock SendNearbyClientMessage(color, message[], Float: distance = 30.0, Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInRangeOfPoint(i, distance, posX, posY, posZ) && GetPlayerInterior(i) == interior && GetPlayerVirtualWorld(i) == virtualworld)
			{
				SendClientMessage(i, color, message);
			}
		}
	}
	
	return 1;
}

stock GameTextForNearbyPlayers(text[], time, style, Float: distance = 30.0, Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInRangeOfPoint(i, distance, posX, posY, posZ) && GetPlayerInterior(i) == interior && GetPlayerVirtualWorld(i) == virtualworld)
			{
				GameTextForPlayer(i, text, time, style);
			}
		}
	}
	
	return 1;
}

stock ToggleNearbyPlayersControllable(bool: controllable, Float: distance = 30.0, Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerInRangeOfPoint(i, distance, posX, posY, posZ) && GetPlayerInterior(i) == interior && GetPlayerVirtualWorld(i) == virtualworld)
			{
				TogglePlayerControllable(i, controllable);
			}
		}
	}
	
	return 1;
}

stock TogglePlayerKickImmunity(playerid, bool: immune)
{
	return svAddons_KickImmune[playerid] = immune;
}

stock GetPlayerKickImmunity(playerid)
{
	return svAddons_KickImmune[playerid];
}

stock TogglePlayerBanImmunity(playerid, bool: immune)
{
	return svAddons_BanImmune[playerid] = immune;
}

stock GetPlayerBanImmunity(playerid)
{
	return svAddons_BanImmune[playerid];
}

stock ShakePlayerScreen(playerid, duration = 1250)
{
	SetTimerEx("svAddons_StopShaking", duration, 0, "i", playerid);
	return SetPlayerDrunkLevel(playerid, 5000);
}

stock PlayAudioStreamForPlayerEx(playerid, url[], audioLen = -1, loop = -1)
{
	if(audioLen > -1)
	{
	    if(loop > -1)
	    {
	        svAddons_PlayerAudioLoops[playerid] = loop;
	        svAddons_PlayerLoopTime[playerid] = audioLen;
	    }
	    
	    SetTimerEx("svAd_StopAudioStreamForPlayerEx", audioLen, 0, "i", playerid);
	}
	
	return PlayAudioStreamForPlayer(playerid, url, 0.0, 0.0, 0.0, 0.0, 0);
}

stock CreateTriggerPoint(Float: posX, Float: posY, Float: posZ, interior = 0, virtualworld = 0)
{	
	new i = 200;
	
	for(new fAvailable = 0; fAvailable < 200; fAvailable++)
	{
		if(svAddons_LocationTriggers[fAvailable][svtBeingUsed] == false)
		{
			i = fAvailable;
			break;
		}
	}
	
	if(i == 200)
	{
		return print("(svAddons) Could not create new trigger point due to limit reached.");
	}
	
	svAddons_TriggerCreated = true;
	svAddons_LocationTriggers[i][svtBeingUsed] = true;
	svAddons_LocationTriggers[i][svtInterior] = interior;
	svAddons_LocationTriggers[i][svtPickupID] = CreatePickup(19300, 23, posX, posY, posZ, virtualworld);
	return i;
}

stock StartCountdown(from = 3)
{
	new countdownMessage[10];
	format(countdownMessage, sizeof(countdownMessage), "%d", from);
	SendClientMessageToAll(-1, countdownMessage);
	return (from > 0) ? SetTimerEx("svAddons_ProcessCountdown", 1000, 0, "i", from - 1);
}

stock SendClientAudioMessage(playerid, message[], bool: withClientMessage = false, color = -1, language[] = "en")
{
	if(withClientMessage == true)
	{
		SendClientMessage(playerid, color, message);
	}
	
	new messageAudioURL[256];
	format(messageAudioURL, sizeof(messageAudioURL), "http://translate.google.com/translate_tts?tl=%s&q=%s", language, message);
	return PlayAudioStreamForPlayer(playerid, messageAudioURL);
}

stock DealPlayerDamage(playerid, damage)
{
	new Float: playersHealth, Float: playersArmor;
	GetPlayerHealth(playerid, playersHealth);
	GetPlayerArmour(playerid, playersArmor);
	
	if(playersHealth > 100)
	{
		return printf("(svAddons) Could not proceed with DealPlayerDamage because the player had more than 100 health - (playerid = %d, health = %.1f)", playerid, playersHealth);
	}
	
	if(playersArmor > 100)
	{
		return printf("(svAddons) Could not proceed with DealPlayerDamage because the player had more than 100 armor - (playerid = %d, armor = %.1f)", playerid, playersArmor);
	}
	
	if(!playersArmor)
	{
		SetPlayerHealth(playerid, playersHealth - damage);
	}
	else
	{
		if(playersArmor < damage)
		{
			SetPlayerHealth(playerid, playersHealth - (damage - playersArmor));
			SetPlayerArmour(playerid, 0);
		}
		else
		{
			SetPlayerArmour(playerid, playersArmor - damage);
		}
	}
	
	return 1;
}

stock TeleportPlayers(Float: posX, Float: posY, Float: posZ, interior, virtualworld, Float: angle, ...)
{
	new playerid;
	for(new i = 6, n = numargs(); i < n; i++)
	{
		playerid = getarg(i);
		SetPlayerVirtualWorld(playerid, virtualworld);
		SetPlayerInterior(playerid, interior);
		SetPlayerFacingAngle(playerid, angle);
		SetPlayerPos(playerid, posX, posY, posZ);
	}
	
	return 1;
}

stock CountTotalVehicles()
{
	new count;
	
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		if(GetVehicleModel(i) > 0)
		{
			count++;
		}
	}
	
	return count;
}

stock IsVehicleOccupied(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerVehicleID(i) == vehicleid)
		{
			return 1;
		}
	}
	
	return 0;
}

stock IsPlayerDrivingVehicle(playerid, vehicleid = INVALID_VEHICLE_ID)
{
	return (vehicleid == INVALID_VEHICLE_ID) ? (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) : (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid) == vehicleid);
}

stock TeleportPlayerToVehicle(playerid, vehicleid, Float: offsetX = 1.0, Float: offsetY = 0.0, Float: offsetZ = 0.0)
{
	new Float: vehiclePosition[3];
	GetVehiclePos(vehicleid, vehiclePosition[0], vehiclePosition[1], vehiclePosition[2]);
	SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(vehicleid));
	SetPlayerInterior(playerid, GetVehicleInterior(vehicleid));
	return SetPlayerPos(playerid, vehiclePosition[0] + offsetX, vehiclePosition[1] + offsetY, vehiclePosition[2] + offsetZ);
}

stock GetPickupPos(pickupid, &Float: X, &Float: Y, &Float: Z)
{
	return X = svAddons_PickupPosition[pickupid][0], Y = svAddons_PickupPosition[pickupid][1], Z = svAddons_PickupPosition[pickupid][2];
}

stock GetPickupVirtualWorld(pickupid)
{
	return svAddons_PickupWorld[pickupid];
}

stock HideAllTextDraws()
{
	for(new i = 0; i < MAX_TEXT_DRAWS; i++)
	{
		TextDrawHideForAll(_: i);
	}
	
	return 1;
}

stock HideAllTextDrawsForPlayer(playerid)
{
	for(new i = 0; i < MAX_TEXT_DRAWS; i++)
	{
		TextDrawHideForPlayer(playerid, _: i);
	}
	
	return 1;
}

stock GetSkinGender(skinid)
{
	switch(skinid)
	{
		case 74: return SKIN_GENDER_NONE;
		case 0..8, 14..30, 32..38, 42..52, 57..62, 66..68, 70..73, 78..84, 86, 94..128, 132..137, 142..144, 146, 147, 149, 153..156, 158..168, 170, 171, 173..177, 179..189, 200, 202..204, 206..210, 212, 213, 217, 220.223, 227..230, 234..236, 239..242, 247..250, 252..255, 258..262, 264..297, 299: return SKIN_GENDER_MALE;
		default: return SKIN_GENDER_FEMALE;
	}
}

stock TogglePlayerWeaponSwitch(playerid, bool: togws)
{
	return svAddons_PlayerWeaponSwitch[playeid] = togws;
}

/*stock DisableLagShooting() -- Soon to come, need to gather damage data
{
	return svAddons_LagShooting = false;
}

stock TogglePlayerGodmode(playerid, bool: god) -- Part of DisableLagShooting
{
	return svAddons_HasGodmode = god;
}*/

stock IsMeleeWeapon(weaponid)
{
	return (weaponid < 16);
}

#define IsPlayerTabbed IsPlayerPaused

stock IsPlayerPaused(playerid)
{
	return svAddons_PlayerTabbed[playerid];
}

stock GetPlayerControllable(playerid)
{
	return svAddons_PlayerControllable[playerid];
}

stock divideRem(a, b, &answer, &remainder)
{
	answer = a / b;
	remainder = a % b;
	return 1;
}

stock CountTotalObjects()
{
	new objectCount;
	
	for(new objectid, Float: objectsPosition[3]; objectid < MAX_OBJECTS; objectid++)
	{
		GetObjectPos(objectid, objectsPosition[0], objectsPosition[1], objectsPosition[2]);
		if(objectsPosition[0] != 0.0 || objectsPosition[1] != 0.0 || objectsPosition[2] != 0.0)
		{
			objectCount++;
		}
	}
	
	return objectCount;
}

stock GetServerStats(&connections, &kicks, &vehicles, &objects, &players, &totalvehicles, &totalobjects, &kills, &deaths, &totaldamage, mode = SERVER_STATS_UPTIME, bool: errorContinue = true)
{
	if(mode == SERVER_STATS_TOTAL)
	{
		#if !defined ENABLE_SERVERSTATSTOTAL
		
			print("(svAddons) Attempted to execute GetServerStats with mode SERVER_STATS_TOTAL without being enabled, operation aborted.");
			
			if(errorContinue == false)
			{
				return 0;
			}
			else
			{
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES] = 0;
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS] = 0;
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS] = 0;
				
				for(new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++)
				{
					if(GetVehicleModel(vehicleid) > 0)
					{
						svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]++;
					}
				}
				
				for(new objectid, Float: objectsPosition[3]; objectid < MAX_OBJECTS; objectid++)
				{
					GetObjectPos(objectid, objectsPosition[0], objectsPosition[1], objectsPosition[2]);
					if(objectsPosition[0] != 0.0 || objectsPosition[1] != 0.0 || objectsPosition[2] != 0.0)
					{
						svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS]++;
					}
				}
				
				for(new playerid; playerid < MAX_PLAYERS; playerid++)
				{
					if(IsPlayerConnected(playerid))
					{
						svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS]++;
					}
				}
				
				connections = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_CONNECTIONS], kicks = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KICKS];
				vehicles = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES], objects = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS], players = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS];
				totalvehicles = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALVEHICLES], totalobjects = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALOBJECTS];
				kills = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KILLS], deaths = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_DEATHS], totaldamage = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALDAMAGE];
			}
			
		#endif
		
		connections = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_CONNECTIONS], kicks = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KICKS];
		vehicles = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES], objects = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_OBJECTS], players = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_PLAYERS];
		totalvehicles = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALVEHICLES], &totalobjects = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALOBJECTS];
		kills = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KILLS], &deaths = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_DEATHS], &totaldamage = svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALDAMAGE];
	}
	else
	{
		svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES] = 0;
		svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS] = 0;
		svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS] = 0;
		
		for(new vehicleid; vehicleid < MAX_VEHICLES; vehicleid++)
		{
			if(GetVehicleModel(vehicleid) > 0)
			{
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]++;
			}
		}
		
		for(new objectid, Float: objectsPosition[3]; objectid < MAX_OBJECTS; objectid++)
		{
			GetObjectPos(objectid, objectsPosition[0], objectsPosition[1], objectsPosition[2]);
			if(objectsPosition[0] != 0.0 || objectsPosition[1] != 0.0 || objectsPosition[2] != 0.0)
			{
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS]++;
			}
		}
		
		for(new playerid; playerid < MAX_PLAYERS; playerid++)
		{
			if(IsPlayerConnected(playerid))
			{
				svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS]++;
			}
		}
		
		connections = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_CONNECTIONS], kicks = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KICKS];
		vehicles = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES], objects = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS], players = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS];
		totalvehicles = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALVEHICLES], totalobjects = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALOBJECTS];
		kills = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KILLS], deaths = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_DEATHS], totaldamage = svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALDAMAGE];
	}
}


//  // ------------------------------------------------------------------------------------------------------------------------ ||
// ||														INTERNAL															||
//  \\ ------------------------------------------------------------------------------------------------------------------------ ||

forward svAddons_Detection();
forward svAddons_StopShaking(playerid);
forward svAddons_DeleteEffect(objectid);
forward svAddons_ProcessCountdown(from);
forward svAd_StopAudioStreamForPlayerEx(playerid);

Float: svA_GetDistanceBetweenPlayers(p1, p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

public svAddons_ProcessCountdown(from)
{	
	if(!from)
	{
		SendClientMessageToAll(-1, "Go!");
	}
	else
	{
		new countdownMessage[10];
		format(countdownMessage, sizeof(countdownMessage), "%d", from);
		SendClientMessageToAll(-1, countdownMessage);
		SetTimerEx("svAddons_ProcessCountdown", 1000, 0, "i", from - 1);
	}
}

public svAddons_DeleteEffect(objectid)
{
	return DestroyObject(objectid);
}

public svAddons_StopShaking(playerid)
{
	return SetPlayerDrunkLevel(playerid, 0);
}

public svAd_StopAudioStreamForPlayerEx(playerid)
{
	svAddons_PlayerAudioLoops[playerid]--;
	
	if(!svAddons_PlayerAudioLoops[playerid])
	{
	    svAddo_StopAudioStreamForPlayer(playerid);
	}
	else
	{
		PlayAudioStreamForPlayer(playerid, svAddons_oldURL[playerid]);
		SetTimerEx("svAd_StopAudioStreamForPlayerEx", svAddons_PlayerLoopTime[playerid], 0, "i", playerid);
	}
	
	return 1;
}

stock svAddo_PlayAudioStreamForPlayer(playerid, url[], Float: posX = 0.0, Float: posY = 0.0, Float: posZ = 0.0, Float: distance = 50.0, usepos = 0)
{
	new string[256];
    format(svAddons_oldURL[playerid], 256, url);
	format(string, sizeof(string), "Audio stream: %s", url);
    //CallLocalFunction("OnPlayerStreamedAudioChange", "dds", playerid, 0, url);
	CallLocalFunction("OnReceiveClientMessage", "dds", playerid, 0x33AA33AA, string);
	return PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

#if defined _ALS_PlayAudioStreamForPlayer
	#undef PlayAudioStreamForPlayer
#else
	#define _ALS_PlayAudioStreamForPlayer
#endif
#define PlayAudioStreamForPlayer svAddo_PlayAudioStreamForPlayer

stock svAddo_StopAudioStreamForPlayer(playerid)
{
	svAddons_PlayerAudioLoops[playerid] = 0;
	//CallLocalFunction("OnPlayerStreamedAudioChange", "dds", playerid, 1, svAddons_oldURL[playerid]);
	return StopAudioStreamForPlayer(playerid);
}

#if defined _ALS_StopAudioStreamForPlayer
	#undef StopAudioStreamForPlayer
#else
	#define _ALS_StopAudioStreamForPlayer
#endif
#define StopAudioStreamForPlayer svAddo_StopAudioStreamForPlayer

stock svAddon_SetPlayerSpecialAction(playerid, actionid)
{
	if(actionid == SPECIAL_ACTION_USECELLPHONE)
	{
	    SetPlayerAttachedObject(playerid, 9, 330, 6);
	}
	else if(actionid == SPECIAL_ACTION_STOPUSECELLPHONE)
	{
	    RemovePlayerAttachedObject(playerid, 9);
	}
	
	CallLocalFunction("OnPlayerSpecialActionChange", "ddd", playerid, GetPlayerSpecialAction(playerid), actionid);
	return SetPlayerSpecialAction(playerid, actionid);
}

#if defined _ALS_SetPlayerSpecialAction
	#undef SetPlayerSpecialAction
#else
	#define _ALS_SetPlayerSpecialAction
#endif
#define SetPlayerSpecialAction svAddon_SetPlayerSpecialAction

stock svAddons_ClearAnimations(playerid, forcesync = 0)
{
	CallLocalFunction("OnPlayerSpecialActionChange", "ddd", playerid, GetPlayerSpecialAction(playerid), SPECIAL_ACTION_NONE);
	return ClearAnimations(playerid, forcesync);
}

#if defined _ALS_ClearAnimations
	#undef ClearAnimations
#else
	#define _ALS_ClearAnimations
#endif
#define ClearAnimations svAddons_ClearAnimations

stock svAddons_CreateVehicle(vehicletype, Float: x, Float: y, Float: z, Float: rotation, color1, color2, respawn_delay)
{
	new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
	CallLocalFunction("OnVehicleCreate", "d", vehicleid);
	svAddons_cVehiclePlate[vehicleid] = false;
	svAddons_VehicleInterior[vehicleid] = 0;
	svAddons_VehicleTrailers[vehicleid] = 0;
	svAddons_VehicleData[vehicleid][0] = x, svAddons_VehicleData[vehicleid][1] = y, svAddons_VehicleData[vehicleid][2] = z, svAddons_VehicleData[vehicleid][3] = rotation;
	svAddons_VehicleDataEx[vehicleid][0] = color1, svAddons_VehicleDataEx[vehicleid][1] = color2, svAddons_VehicleDataEx[vehicleid][2] = respawn_delay;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALVEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALVEHICLES]++;
	return vehicleid;
}

#if defined _ALS_CreateVehicle
	#undef CreateVehicle
#else
	#define _ALS_CreateVehicle
#endif
#define CreateVehicle svAddons_CreateVehicle

stock svAddons_AddStaticVehicle(modelid, Float: spawn_x, Float: spawn_y, Float: spawn_z, Float: z_angle, color1, color2)
{
	new vehicleid = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2);
	CallLocalFunction("OnVehicleCreate", "d", vehicleid);
	svAddons_cVehiclePlate[vehicleid] = false;
	svAddons_VehicleInterior[vehicleid] = 0;
	svAddons_VehicleTrailers[vehicleid] = 0;
	svAddons_VehicleData[vehicleid][0] = spawn_x, svAddons_VehicleData[vehicleid][1] = spawn_y, svAddons_VehicleData[vehicleid][2] = spawn_z, svAddons_VehicleData[vehicleid][3] = z_angle;
	svAddons_VehicleDataEx[vehicleid][0] = color1, svAddons_VehicleDataEx[vehicleid][1] = color2, svAddons_VehicleDataEx[vehicleid][2] = -1;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALVEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALVEHICLES]++;
	return vehicleid;
}

#if defined _ALS_AddStaticVehicle
	#undef AddStaticVehicle
#else
	#define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle svAddons_AddStaticVehicle

stock svAddons_AddStaticVehicleEx(modelid, Float: spawn_x, Float: spawn_y, Float: spawn_z, Float: z_angle, color1, color2, respawn_delay)
{
	new vehicleid = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, respawn_delay);
	CallLocalFunction("OnVehicleCreate", "d", vehicleid);
	svAddons_cVehiclePlate[vehicleid] = false;
	svAddons_VehicleInterior[vehicleid] = 0;
	svAddons_VehicleTrailers[vehicleid] = 0;
	svAddons_VehicleData[vehicleid][0] = spawn_x, svAddons_VehicleData[vehicleid][1] = spawn_y, svAddons_VehicleData[vehicleid][2] = spawn_z, svAddons_VehicleData[vehicleid][3] = z_angle;
	svAddons_VehicleDataEx[vehicleid][0] = color1, svAddons_VehicleDataEx[vehicleid][1] = color2, svAddons_VehicleDataEx[vehicleid][2] = respawn_delay;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALVEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALVEHICLES]++;
	return vehicleid;
}

#if defined _ALS_AddStaticVehicleEx
	#undef AddStaticVehicleEx
#else
	#define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx svAddons_AddStaticVehicleEx

stock svAddons_DestroyVehicle(vehicleid)
{
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_VEHICLES]--;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES]--;
	return DestroyVehicle(vehicleid);
}

#if defined _ALS_DestroyVehicle
	#undef DestroyVehicle
#else
	#define _ALS_DestroyVehicle
#endif
#define DestroyVehicle svAddons_DestroyVehicle

stock svAddons_CreateObject(modelid, Float: X, Float: Y, Float: Z, Float: rX, Float: rY, Float: rZ, Float: DrawDistance = 0.0)
{
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS]++;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALOBJECTS]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_OBJECTS]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALOBJECTS]++;
	return CreateObject(modelid, X, Y, Z, rX, rY, rZ, DrawDistance);
}

#if defined _ALS_CreateObject
	#undef CreateObject
#else
	#define _ALS_CreateObject
#endif
#define CreateObject svAddons_CreateObject

stock svAddons_DestroyObject(objectid)
{
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_OBJECTS]--;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_OBJECTS]--;
	return DestroyObject(objectid);
}

#if defined _ALS_DestroyObject
	#undef DestroyObject
#else
	#define _ALS_DestroyObject
#endif
#define DestroyObject svAddons_DestroyObject

stock svAddons_AddStaticPickup(model, type, Float: X, Float: Y, Float: Z, virtualworld = 0)
{
	new pickupid = AddStaticPickup(model, type, X, Y, Z, virtualworld);
	svAddons_PickupPosition[pickupid][0] = X, svAddons_PickupPosition[pickupid][1] = Y, svAddons_PickupPosition[pickupid][2] = Z;
	svAddons_PickupWorld[pickupid] = virtualworld;
	return pickupid;
}

#if defined _ALS_AddStaticPickup
	#undef AddStaticPickup
#else
	#define _ALS_AddStaticPickup
#endif
#define AddStaticPickup svAddons_AddStaticPickup

stock svAddons_CreatePickup(model, type, Float: X, Float: Y, Float: Z, virtualworld = 0)
{
	new pickupid = CreatePickup(model, type, X, Y, Z, virtualworld);
	svAddons_PickupPosition[pickupid][0] = X, svAddons_PickupPosition[pickupid][1] = Y, svAddons_PickupPosition[pickupid][2] = Z;
	svAddons_PickupWorld[pickupid] = virtualworld;
	return pickupid;
}

#if defined _ALS_CreatePickup
	#undef CreatePickup
#else
	#define _ALS_CreatePickup
#endif
#define CreatePickup svAddons_CreatePickup

stock svAddon_SetVehicleNumberPlate(vehicleid, numberplate[])
{
    svAddons_cVehiclePlate[vehicleid] = true;
    format(svAddons_VehiclePlate[vehicleid], 20, numberplate);
	CallLocalFunction("OnLicensePlateChange", "ds", vehicleid, numberplate);
	return SetVehicleNumberPlate(vehicleid, numberplate);
}

#if defined _ALS_SetVehicleNumberPlate
	#undef SetVehicleNumberPlate
#else
	#define _ALS_SetVehicleNumberPlate
#endif
#define SetVehicleNumberPlate svAddon_SetVehicleNumberPlate

stock svAddons_EditObject(playerid, objectid)
{
	svAddons_EditingObject[playerid] = objectid;
	svAddons_EditingObjectState[playerid] = OBJECT_EDITING_NORMAL;
	return EditObject(playerid, objectid);
}

#if defined _ALS_EditObject
	#undef EditObject
#else
	#define _ALS_EditObject
#endif
#define EditObject svAddons_EditObject

stock svAddons_EditPlayerObject(playerid, objectid)
{
	svAddons_EditingObject[playerid] = objectid;
	svAddons_EditingObjectState[playerid] = OBJECT_EDITING_PLAYER;
	return EditPlayerObject(playerid, objectid);
}

#if defined _ALS_EditPlayerObject
	#undef EditPlayerObject
#else
	#define _ALS_EditPlayerObject
#endif
#define EditPlayerObject svAddons_EditPlayerObject

stock svAddons_EditAttachedObject(playerid, index)
{
	svAddons_EditingObjectState[playerid] = OBJECT_EDITING_ATTACHED;
	svAddons_EditingObject[playerid] = index;
	return EditAttachedObject(playerid, index);
}

#if defined _ALS_EditAttachedObject
	#undef EditAttachedObject
#else
	#define _ALS_EditAttachedObject
#endif
#define EditAttachedObject svAddons_EditAttachedObject

stock svAddons_CancelEdit(playerid)
{
	svAddons_EditingObjectState[playerid] = OBJECT_EDITING_NONE;
	return CancelEdit(playerid);
}

#if defined _ALS_CancelEdit
	#undef CancelEdit
#else
	#define _ALS_CancelEdit
#endif
#define CancelEdit svAddons_CancelEdit

stock svAddons_SendClientMessage(playerid, color, message[])
{
	CallLocalFunction("OnReceiveClientMessage", "dds", playerid, color, message);
	return SendClientMessage(playerid, color, message);
}

#if defined _ALS_SendClientMessage
	#undef SendClientMessage
#else
	#define _ALS_SendClientMessage
#endif
#define SendClientMessage svAddons_SendClientMessage

stock svAddons_LinkVehicleToInterior(vehicleid, interiorid)
{
	svAddons_VehicleInterior[vehicleid] = interiorid;
	return LinkVehicleToInterior(vehicleid, interiorid);
}

#if defined _ALS_LinkVehicleToInterior
	#undef LinkVehicleToInterior
#else
	#define _ALS_LinkVehicleToInterior
#endif
#define LinkVehicleToInterior 

stock svAddons_AttachTrailerToVehicle(trailerid, vehicleid)
{
	svAddons_VehicleTrailers[vehicleid]++;
	return AttachTrailerToVehicle(trailerid, vehicleid);
}

#if defined _ALS_AttachTrailerToVehicle
	#undef AttachTrailerToVehicle
#else
	#define _ALS_AttachTrailerToVehicle
#endif
#define AttachTrailerToVehicle svAddons_AttachTrailerToVehicle

stock svAdd_DetachTrailerFromVehicle(vehicleid)
{
	svAddons_VehicleTrailers[vehicleid]--;
	return DetachTrailerFromVehicle(vehicleid);
}

#if defined _ALS_DetachTrailerFromVehicle
	#undef DetachTrailerFromVehicle
#else
	#define _ALS_DetachTrailerFromVehicle
#endif
#define DetachTrailerFromVehicle svAdd_DetachTrailerFromVehicle

stock svAddons_Kick(playerid)
{
	if(svAddons_KickImmune[playerid] == true)
	{
		new currentSecond, currentMinute, currentHour, currentDay, currentMonth, currentYear;
		getdate(currentYear, currentMonth, currentDay);
		gettime(currentHour, currentMinute, currentSecond);
		printf("(svAddons) Player ID %d was attempted to be kicked while kick immune. (%d/%d/%d - %d:%d:%d]", playerid, currentMonth, currentDay, currentYear, currentHour, currentMinute, currentSecond);
		return -1;
	}
	else
	{
		svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KICKS]++;
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KICKS]++;
		return Kick(playerid);
	}
}

#if defined _ALS_Kick
	#undef Kick
#else
	#define _ALS_Kick
#endif
#define Kick svAddons_Kick

stock svAddons_Ban(playerid)
{
	if(svAddons_BanImmune[playerid] == true)
	{
		new currentSecond, currentMinute, currentHour, currentDay, currentMonth, currentYear;
		getdate(currentYear, currentMonth, currentDay);
		gettime(currentHour, currentMinute, currentSecond);
		printf("(svAddons) Player ID %d was attempted to be banned while ban immune. (%d/%d/%d - %d:%d:%d]", playerid, currentMonth, currentDay, currentYear, currentHour, currentMinute, currentSecond);
		return -1;
	}
	else
	{
		return Ban(playerid);
	}
}

#if defined _ALS_Ban
	#undef Ban
#else
	#define _ALS_Ban
#endif
#define Ban svAddons_Ban

stock svAddons_BanEx(playerid, reason[])
{
	if(svAddons_BanImmune[playerid] == true)
	{
		new currentSecond, currentMinute, currentHour, currentDay, currentMonth, currentYear;
		getdate(currentYear, currentMonth, currentDay);
		gettime(currentHour, currentMinute, currentSecond);
		printf("(svAddons) Player ID %d was attempted to be banned while ban immune. (%d/%d/%d - %d:%d:%d]", playerid, currentMonth, currentDay, currentYear, currentHour, currentMinute, currentSecond);
		return -1;
	}
	else
	{
		return BanEx(playerid, reason);
	}
}

#if defined _ALS_BanEx
	#undef BanEx
#else
	#define _ALS_BanEx
#endif
#define BanEx svAddons_BanEx

stock svAd_TogglePlayerControllable(playerid, toggle)
{
	svAddons_PlayerControllable[playerid] = !!toggle;
	return TogglePlayerControllable(playerid, toggle);
}

#if defined _ALS_TogglePlayerControllable
	#undef TogglePlayerControllable
#else
	#define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable svAd_TogglePlayerControllable

forward svAddons_OnPlayerConnect(playerid);
public OnPlayerConnect(playerid)
{
	svAddons_PlayerAudioLoops[playerid] = 0;
	svAddons_EditingObjectState[playerid] = OBJECT_EDITING_NONE;
	svAddons_PlayerTabbedUpdates[playerid] = 0;
	svAddons_PlayerTabbed[playerid] = false;
	svAddons_BeingCrashed[playerid] = false;
	svAddons_Whitelisted[playerid] = false;
	svAddons_PlayerWeapon[playerid] = 0;
	svAddons_InWater[playerid] = false;
	svAddons_KickImmune[playerid] = false;
	svAddons_BanImmune[playerid] = false;
	svAddons_PlayerWeaponSwitch[playerid] = true;
	svAddons_HasGodmode[playerid] = false;
	svAddons_PlayerControllable[playerid] = true;
	
	if(svAddons_DisabledSprunk == true)
	{
	    RemoveBuildingForPlayer(playerid, 955, 0, 0, 0, 3000);
        RemoveBuildingForPlayer(playerid, 956, 0, 0, 0, 3000);
        RemoveBuildingForPlayer(playerid, 1209, 0, 0, 0, 3000);
        RemoveBuildingForPlayer(playerid, 1302, 0, 0, 0, 3000);
        RemoveBuildingForPlayer(playerid, 1775, 0, 0, 0, 3000);
        RemoveBuildingForPlayer(playerid, 1776, 0, 0, 0, 3000);
	}
	
	if(svAddons_LagShooting == false)
	{
		SetPlayerTeam(playerid, 1);
	}
	
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_CONNECTIONS]++;
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_CONNECTIONS]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_PLAYERS]++;
	return CallLocalFunction("svAddons_OnPlayerConnect", "d", playerid);
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect svAddons_OnPlayerConnect

stock svAddons_SetPlayerTeam(playerid, teamid)
{
	return svAddons_Team[playerid] = teamid;
}

#if defined _ALS_SetPlayerTeam
	#undef SetPlayerTeam
#else
	#define _ALS_SetPlayerTeam
#endif
#define SetPlayerTeam svAddons_SetPlayerTeam

stock svAddons_GetPlayerTeam(playerid)
{
	return svAddons_Team[playerid];
}

#if defined _ALS_GetPlayerTeam
	#undef GetPlayerTeam
#else
	#define _ALS_GetPlayerTeam
#endif
#define GetPlayerTeam svAddons_GetPlayerTeam

forward svAddons_OnPlayerDisconnect(playerid, reason);
public OnPlayerDisconnect(playerid, reason)
{
	if(svAddons_BeingCrashed[playerid] == true)
	{
	    DestroyPlayerObject(playerid, svAddons_CrashObject[playerid]);
	}
	
	if(svAddons_Reconnecting[playerid] == true)
	{
		new rconCMD[50];
		svAddons_Reconnecting[playerid] = false;
		format(rconCMD, sizeof(rconCMD), "unbanip %s", svAddons_ReconnectingIP[playerid]);
		SendRconCommand(rconCMD);
	}

	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_PLAYERS]--;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_PLAYERS]--;
	return CallLocalFunction("svAddons_OnPlayerDisconnect", "dd", playerid, reason);
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect svAddons_OnPlayerDisconnect

forward svAddons_OnPlayerUpdate(playerid);
public OnPlayerUpdate(playerid)
{
	svAddons_PlayerTabbedUpdates[playerid] = 0;
	
	if(svAddons_PlayerTabbed[playerid] == true)
	{
	    svAddons_PlayerTabbed[playerid] = false;
	    CallLocalFunction("OnPlayerPausedUpdate", "dd", playerid, svAddons_PlayerTabbed[playerid]);
	}
	
	new playersWeapon = GetPlayerWeapon(playerid);
	if(playersWeapon != svAddons_PlayerWeapon[playerid])
	{
		CallLocalFunction("OnPlayerWeaponUpdate", "ddd", playerid, playersWeapon, svAddons_PlayerWeapon[playerid]);
		svAddons_PlayerWeapon[playerid] = playersWeapon;
	}
	
	if(svAddons_PlayerWeaponSwitch[playerid] == false)
	{
		if(playersWeapon > 0)
		{
			SetPlayerArmedWeapon(playerid, 0);
		}
	}
	
	return CallLocalFunction("svAddons_OnPlayerUpdate", "d", playerid);
}

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate svAddons_OnPlayerUpdate

forward svAddons_OnPlayerDeath(playerid, killerid, reason);
public OnPlayerDeath(playerid, killerid, reason)
{
	switch(svAddons_DeathEffect[playerid])
	{
	    case 1:
	    {
	        new objectid = CreateObject(18668, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0);
	        AttachObjectToPlayer(objectid, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	        SetTimerEx("svAddons_DeleteEffect", 2500, 0, "i", objectid);
	    }
	    
	    case 2:
	    {
         	new objectid = CreateObject(18731, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0);
	        AttachObjectToPlayer(objectid, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	        SetTimerEx("svAddons_DeleteEffect", 2500, 0, "i", objectid);
	    }
	    
	    case 3:
	    {
	        new Float: playersPos[3];
	        GetPlayerPos(playerid, playersPos[0], playersPos[1], playersPos[2]);
	        CreateExplosion(playersPos[0], playersPos[1], playersPos[2], 6, 10.0);
	    }
	    
	    case 4:
	    {
	        new Float: playersPos[3];
	        GetPlayerPos(playerid, playersPos[0], playersPos[1], playersPos[2]);
	        CreateExplosion(playersPos[0], playersPos[1], playersPos[2] - 4.5, 6, 10.0);
	    }
	    
	    case 5:
		{
		    new objectid = CreateObject(18688, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0);
	        AttachObjectToPlayer(objectid, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	        SetTimerEx("svAddons_DeleteEffect", 2500, 0, "i", objectid);
	    }
	}
	
	if(killerid != INVALID_PLAYER_ID)
	{
		svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_KILLS]++;
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KILLS]++;
	}
	
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_DEATHS]++;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_DEATHS]++;
	CallLocalFunction("OnPlayerSpecialActionChange", "ddd", playerid, SPECIAL_ACTION_NONE, SPECIAL_ACTION_NONE);
	return CallLocalFunction("svAddons_OnPlayerDeath", "ddd", playerid, killerid, reason);
}

#if defined _ALS_OnPlayerDeath
    #undef OnPlayerDeath
#else
    #define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath svAddons_OnPlayerDeath


forward svAddons_OnFilterScriptInit();
public OnFilterScriptInit()
{
	SetTimer("svAddons_Detection", 2000, 1);
	return CallLocalFunction("svAddons_OnFilterScriptInit", "");
}

#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit svAddons_OnFilterScriptInit

forward svAddons_OnGameModeInit();
public OnGameModeInit()
{
	SetTimer("svAddons_Detection", 2000, 1);
	
	#if defined ENABLE_SERVERSTATSTOTAL
	
	new File: serverStats, serverStatsData[120];
	
	if(!fexist(PATH_SERVERSTATS))
	{
		serverStats = fopen(PATH_SERVERSTATS, io_append);
		fwrite(serverStats, "0|0|0|0|0|0|0|0|0|0");
		fclose(serverStats);
	}
	
	serverStats = fopen(PATH_SERVERSTATS, io_read);
	fread(serverStats, serverStatsData);
	sscanf(serverStatsData, "p<|>dddddddddd",
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_CONNECTIONS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KICKS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_VEHICLES],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_OBJECTS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_PLAYERS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALVEHICLES],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALOBJECTS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_KLLS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_DEATHS],
		svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALDAMAGE]
	);
	
	fclose(serverStats);
	
	#endif
	
	return CallLocalFunction("svAddons_OnGameModeInit", "");
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit svAddons_OnGameModeInit

forward svAddons_OnRconLoginAttempt(ip[], password[], success);
public OnRconLoginAttempt(ip[], password[], success)
{
	if(svAddons_Whitelist != WHITELIST_MODE_NONE)
	{
		new playerid, playersIP[17];
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				GetPlayerIp(i, playersIP, 17);
				if(!strcmp(playersIP, ip))
				{
					playerid = i;
					break;
				}
			}
		}
		
		switch(svAddons_Whitelist)
		{
			case WHITELIST_MODE_ALLOWPLAYER:
			{
				if(svAddons_Whitelisted[playerid] == false)
				{
					CallLocalFunction("OnRconLoginBlocked", "dssd", playerid, ip, password, success);
				}
			}
			
			case WHITELIST_MODE_SPECIFICIP:
			{
				if(strcmp(ip, svAddons_WhitelistIP))
				{
					CallLocalFunction("OnRconLoginBlocked", "dssd", playerid, ip, password, success);
				}
			}
			
			case WHITELIST_MODE_IP_FIND:
			{
				if(strfind(ip, svAddons_WhitelistIP) == -1)
				{
					CallLocalFunction("OnRconLoginBlocked", "dssd", playerid, ip, password, success);
				}
			}
		}
	}
	
	return CallLocalFunction("svAddons_OnRconLoginAttempt", "ssd", ip, password, success);
}

#if defined _ALS_OnRconLoginAttempt
    #undef OnRconLoginAttempt
#else
    #define _ALS_OnRconLoginAttempt
#endif
#define OnRconLoginAttempt svAddons_OnRconLoginAttempt

forward svAddons_OnVehicleSpawn(vehicleid);
public OnVehicleSpawn(vehicleid)
{
	svAddons_VehicleInterior[vehicleid] = 0;
	svAddons_VehicleTrailers[vehicleid] = 0;
	return CallLocalFunction("svAddons_OnVehicleSpawn", "d", vehicleid);
}

#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn svAddons_OnVehicleSpawn

forward svAddons_OnPlayerPickUpPickup(playerid, pickupid);
public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(svAddons_TriggerCreated == true)
	{
		new playersInterior = GetPlayerInterior(playerid);
		for(new i = 0; i < 200; i++)
		{
			if(svAddons_LocationTriggers[i][svtBeingUsed] == true)
			{
				if(playersInterior == svAddons_LocationTriggers[i][svtInterior])
				{
					if(pickupid == svAddons_LocationTriggers[i][svtPickupID])
					{
						CallLocalFunction("OnPlayerTouchTrigger", "dd", playerid, i);
						break;
					}
				}
			}
		}
	}
	
	return CallLocalFunction("svAddons_OnPlayerPickUpPickup", "dd", playerid, pickupid);
}

#if defined _ALS_OnPlayerPickUpPickup
    #undef OnPlayerPickUpPickup
#else
    #define _ALS_OnPlayerPickUpPickup
#endif
#define OnPlayerPickUpPickup svAddons_OnPlayerPickUpPickup

forward svAddons_OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid);
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
	if(svAddons_LagShooting == false)
	{
		if(svAddons_Team[playerid] != svAddons_Team[damagedid] && svAddons_HasGodmode[damagedid] == false)
		{
			if(svAddons_WeaponData[weaponid][1])
			{
				new Float: distance = svA_GetDistanceBetweenPlayers(playerid, damagedid), damageToDeal = svAddons_WeaponData[weaponid][0];
				
				if(distance > 20 && distance < 40)
				{
					damageToDeal /= 2;
				}
				else if(distance > 40 && distance < 60)
				{
					damageToDeal /= 3;
				}
				else if(distance > 60)
				{
					damageToDeal /= 4;
				}

				DealPlayerDamage(damagedid, damageToDeal);
			}
			else
			{
				DealPlayerDamage(damagedid, svAddons_WeaponData[weaponid][0]);
			}
		}
	}
	
	return CallLocalFunction("svAddons_OnPlayerGiveDamage", "ddfd", playerid, damagedid, amount, weaponid);
}

#if defined _ALS_OnPlayerGiveDamage
    #undef OnPlayerGiveDamage
#else
    #define _ALS_OnPlayerGiveDamage
#endif
#define OnPlayerGiveDamage svAddons_OnPlayerGiveDamage

forward svAddons_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	svAddons_ServerStats[SERVER_STATS_UPTIME][SERVER_STATS_TOTALDAMAGE] += amount;
	svAddons_ServerStats[SERVER_STATS_TOTAL][SERVER_STATS_TOTALDAMAGE] += amount;
	return CallLocalFunction("svAddons_OnPlayerTakeDamage", "ddfd", playerid, issuerid, amount, weaponid);
}

#if defined _ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage svAddons_OnPlayerTakeDamage

public svAddons_Detection()
{
	new animationIndex;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(svAddons_PlayerTabbed[i] == false)
	    {
		    if(IsPlayerConnected(i))
		    {
		        #if defined SVCS_svCheats
			        if(svCheats_ReportedTabbed[i] == true)
			        {
			            svAddons_PlayerTabbed[i] = true;
			            CallLocalFunction("OnPlayerPausedUpdate", "dd", i, svAddons_PlayerTabbed[i]);
			            break;
			        }
			    #else
					svAddons_PlayerTabbedUpdates[i]++;
					if(svAddons_PlayerTabbedUpdates[i] > 1)
					{
					    svAddons_PlayerTabbedUpdates[i] = 0;
					    svAddons_PlayerTabbed[i] = true;
						CallLocalFunction("OnPlayerPausedUpdate", "dd", i, svAddons_PlayerTabbed[i]);
					}
				#endif
			}
		}
		
		animationIndex = GetPlayerAnimationIndex(i);
		if(svAddons_InWater[i] == false && animationIndex >= 1538 && animationIndex <= 1544 && animationIndex != 1542)
		{
			svAddons_InWater[i] = true;
		}
		else if(svAddons_InWater[i] == true && animationIndex < 1538 || animationIndex > 1544 || animationIndex == 1542)
		{
			svAddons_InWater[i] = false;
		}
		CallLocalFunction("OnPlayerWaterStatusUpdate", "dd", i, svAddons_InWater[i]);
	}
	return 1;
}