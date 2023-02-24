#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS                                                     25
#define FIXES_ServerVarMsg 0
#include <fixes>
#include <sscanf2>
#include <foreach>
#include <streamer>
#include <colandreas>
#include <BossArena>
#include <FCNPC>
#include <projectile>

#define function%0(%1)     												forward%0(%1); public%0(%1)
#define PRESSED(%0)  													(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0)														((newkeys & (%0)) == (%0))
#define RELEASED(%0) 													(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

//============================== [RRGGBB] ======================================
#define cwhite															"{EEFFFF}"
#define cligreen                                                        "{44CC22}"
#define cred                                                            "{FF1111}"
#define dred                                                            "{490B0B}"
#define cgreen                                                          "{05E200}"
#define cblue                                                           "{00B9FF}"
#define cjam                                                            "{E67EF8}"
#define corange                                                         "{FF9600}"
#define cgrey                                                           "{CCCCCC}"
#define cgold                                                           "{FFBB00}"
#define cplat                                                           "{A8A8A8}"
#define cyellow            								    		    "{FFFF00}"
#define cpurple                                                         "{6E00FF}"
#define cpblue                                                          "{A3CAD9}"
#define cband                                                           "{8080FF}"
//============================== [RRGGBB] ======================================
//============================== [Colors] ======================================
#define red                                                           	0xFF0000FF
#define white                                                           0xFFFFFFFF
#define orange                                                          0xFFA000FF
#define purple                                                          0x6E00FFFF
#define green                                                           0x00FF0AFF
#define gold                                                            0xFFC800FF
#define plat                                                            0xAAAAAAFF
//============================== [Colors] ======================================

main(){}
new Text:HPTD[MAX_PLAYERS];
new Text:BossLabel1[MAX_PLAYERS];
new Text:BossLabel2[MAX_PLAYERS];
new Text:BossesName[MAX_PLAYERS];
new Text:LivesTD[MAX_PLAYERS];
new Text:LivesAmountTD[MAX_PLAYERS];

new Float:SpawnPoints[15][4] =
{
    {497.2278,4207.2827,109.7499,292.1647},
    {500.9014,4202.0664,109.7499,305.3876},
    {507.9875,4195.8794,109.7569,322.6212},
    {518.3000,4190.1782,109.7499,345.6201},
    {529.8633,4189.2632,109.7499,6.1749},
    {543.6801,4194.8774,109.7499,32.9337},
    {554.3683,4206.6284,109.7499,63.6406},
    {556.3343,4221.0659,109.7499,92.9688},
    {554.7473,4234.3809,109.7499,118.2864},
    {542.1805,4246.6245,109.7499,145.6719},
    {526.6498,4248.2871,109.7499,185.8415},
    {513.3536,4244.6206,109.7499,207.2109},
    {503.1571,4236.3164,109.7499,234.7846},
    {500.0037,4226.7261,109.7499,251.6422},
    {503.1130,4210.3218,109.7499,295.9480}
};

new Skins[7] = {163,164,165,166,285,286,287};

new BossHP = 1000;
new Lives[MAX_PLAYERS];
new bool:PlayerSpectate[MAX_PLAYERS];
new PlayerSpectatingID[MAX_PLAYERS];
new SecondsRemaining = 15;
new RoundStarted = 0;
new Iterator:PlayersAlive<MAX_PLAYERS>;

public OnGameModeInit()
{
	//SetTimer("UpdateSpectatingPlayer",15000,false);
	SetTimer("UpdateStat",1000,false);
	LoadObj();
	for(new i; i < MAX_PLAYERS; i++)
	{
		HPTD[i] = TextDrawCreate(454.099914, 127.973541, "HP:");
		TextDrawLetterSize(HPTD[i], 0.313999, 1.884667);
		TextDrawAlignment(HPTD[i], 1);
		TextDrawColor(HPTD[i], -1);
		TextDrawSetShadow(HPTD[i], 0);
		TextDrawSetOutline(HPTD[i], 1);
		TextDrawBackgroundColor(HPTD[i], 51);
		TextDrawFont(HPTD[i], 2);
		TextDrawSetProportional(HPTD[i], 1);

		BossLabel1[i] = TextDrawCreate(477.753479, 131.973541, "LD_SPAC:white");
		TextDrawLetterSize(BossLabel1[i], 0.000000, 0.000000);
		TextDrawTextSize(BossLabel1[i], 160.849990, 11.759975);
		TextDrawAlignment(BossLabel1[i], 1);
		TextDrawColor(BossLabel1[i], -1);
		TextDrawSetShadow(BossLabel1[i], 0);
		TextDrawSetOutline(BossLabel1[i], 0);
		TextDrawFont(BossLabel1[i], 4);

		BossLabel2[i] = TextDrawCreate(477.753479, 131.973541, "LD_SPAC:white");
		TextDrawLetterSize(BossLabel2[i], 0.000000, 0.000000);
		TextDrawTextSize(BossLabel2[i], 0, 11.759975);
		TextDrawAlignment(BossLabel2[i], 1);
		TextDrawColor(BossLabel2[i], -1523963137);
		TextDrawSetShadow(BossLabel2[i], 0);
		TextDrawSetOutline(BossLabel2[i], 0);
		TextDrawFont(BossLabel2[i], 4);

		BossesName[i] = TextDrawCreate(537.000183, 132.953414, "BiBBA");
		TextDrawLetterSize(BossesName[i], 0.378999, 1.025999);
		TextDrawAlignment(BossesName[i], 1);
		TextDrawColor(BossesName[i], 255);
		TextDrawSetShadow(BossesName[i], 1);
		TextDrawSetOutline(BossesName[i], 0);
		TextDrawBackgroundColor(BossesName[i], 51);
		TextDrawFont(BossesName[i], 2);
		TextDrawSetProportional(BossesName[i], 1);

        LivesTD[i] = TextDrawCreate(51.099990, 305.339965, "Lives: x");
		TextDrawLetterSize(LivesTD[i], 0.434500, 2.374667);
		TextDrawAlignment(LivesTD[i], 1);
		TextDrawColor(LivesTD[i], 16777215);
		TextDrawSetShadow(LivesTD[i], 0);
		TextDrawSetOutline(LivesTD[i], 1);
		TextDrawBackgroundColor(LivesTD[i], 51);
		TextDrawFont(LivesTD[i], 2);
		TextDrawSetProportional(LivesTD[i], 1);

        LivesAmountTD[i] = TextDrawCreate(125.549995, 295.586700, "3");
		TextDrawLetterSize(LivesAmountTD[i], 1.319499, 4.395332);
		TextDrawAlignment(LivesAmountTD[i], 1);
		TextDrawColor(LivesAmountTD[i], -2147483393);
		TextDrawSetShadow(LivesAmountTD[i], 0);
		TextDrawSetOutline(LivesAmountTD[i], 1);
		TextDrawBackgroundColor(LivesAmountTD[i], 51);
		TextDrawFont(LivesAmountTD[i], 1);
		TextDrawSetProportional(LivesAmountTD[i], 1);
	}
	
	SetTimer("StartGame",1000,false);
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
    for(new s; s < 100; s++)
    {
        SendClientMessage(playerid,white,"");
        if(s == 99)
        {
            SendClientMessage(playerid,white,"========"cred"Ultimate-"cwhite"Gaming "cred"Presents..."cwhite"========");
			SendClientMessage(playerid,white,"    	                "cred"BOSS FIGHT");
			SendClientMessage(playerid,white,"======================================");
        }
    }
    Lives[playerid] = 2;
    if(RoundStarted == 0) PlayerSpectate[playerid] = false;
    else PlayerSpectate[playerid] = true;
    PlayerSpectatingID[playerid] = -1;
    SetTimerEx("RequestSpawn",3000,false,"i",playerid);
    return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(PlayerSpectate[playerid] == false) Iter_Remove(PlayersAlive,playerid);
	foreach(new i: Player)
	{
	    if(PlayerSpectate[i])
	    {
	        if(PlayerSpectatingID[i] == playerid) SetSpecMode(i);
	    }
	}
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(killerid == INVALID_PLAYER_ID) return 0;
	if(Lives[playerid] == 0)
	{
		SetSpecMode(playerid);
		Iter_Remove(PlayersAlive,playerid);
		TextDrawHideForPlayer(playerid,LivesTD[playerid]);
		TextDrawHideForPlayer(playerid,LivesAmountTD[playerid]);
		foreach(new i: Player)
		{
		    if(PlayerSpectate[i])
		    {
		        if(PlayerSpectatingID[i] == playerid) SetSpecMode(i);
		    }
		}
	}
	else
	{
	    Lives[playerid] --;
    	new string[2];
		format(string,sizeof string,"%i",Lives[playerid]);
		TextDrawSetString(LivesAmountTD[playerid],string);
	    new RandPos = random(sizeof(SpawnPoints));
	    SetSpawnInfo(playerid,1,GetPlayerSkin(playerid),SpawnPoints[RandPos][0],SpawnPoints[RandPos][1],SpawnPoints[RandPos][2],SpawnPoints[RandPos][3],0,0,0,0,0,0);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
	SetPlayerTeam(playerid,1);
	SetPlayerTime(playerid,0,0);
	SetPlayerWeather(playerid,365);
    SetCameraBehindPlayer(playerid);
   	TogglePlayerControllable(playerid, 0);
	SetTimerEx("UnFreezePlayer", 1500, false, "i", playerid);
	GivePlayerWeapon(playerid,24,5000);
	GivePlayerWeapon(playerid,25,5000);
	GivePlayerWeapon(playerid,32,5000);
	GivePlayerWeapon(playerid,31,5000);
	new string[2];
	format(string,sizeof string,"%i",Lives[playerid]);
	TextDrawSetString(LivesAmountTD[playerid],string);
	TextDrawShowForPlayer(playerid,LivesTD[playerid]);
	TextDrawShowForPlayer(playerid,LivesAmountTD[playerid]);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 0;
}

public OnPlayerRequestClass(playerid, classid)
{
	//printf("ID %i called \"OnPlayerRequestClass\" public",playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(PlayerSpectate[playerid] == true)
	{
	    new Found;
	    if(PRESSED(KEY_FIRE))
	    {
	        for(new i = PlayerSpectatingID[playerid]; i <= MAX_PLAYERS; i++)
	        {
				if(i == MAX_PLAYERS)
				{
				    for(new b; b <= MAX_PLAYERS; b++)
				    {
			            if(IsPlayerNPC(b)) continue;
			            if(!IsPlayerConnected(b)) continue;
			            if(PlayerSpectate[b] == true) continue;
			            if(b == PlayerSpectatingID[playerid]) continue;
			            if(b == MAX_PLAYERS)
						{
			 				PlayerSpectatePlayer(playerid, PlayerSpectatingID[playerid]);
						}
						else
			            {
							PlayerSpectatingID[playerid] = b;
				        	PlayerSpectatePlayer(playerid, b);
						}
						Found = 1;
				    }
				}
				if(Found == 1) break;
	            if(IsPlayerNPC(i)) continue;
	            if(!IsPlayerConnected(i)) continue;
	            if(i == PlayerSpectatingID[playerid]) continue;
	            if(PlayerSpectate[i] == true) continue;
				PlayerSpectatingID[playerid] = i;
		        PlayerSpectatePlayer(playerid, i);
	        }
		}
		if(PRESSED(KEY_HANDBRAKE))
		{
	        for(new i = PlayerSpectatingID[playerid]; i >= -1; i--)
	        {
				if(i == -1)
				{
				    for(new b = MAX_PLAYERS; b >= -1; b--)
				    {
			            if(IsPlayerNPC(b)) continue;
			            if(!IsPlayerConnected(b)) continue;
			            if(PlayerSpectate[b] == true) continue;
			            if(b == PlayerSpectatingID[playerid]) continue;
			            if(b == -1)
						{
							PlayerSpectatePlayer(playerid, PlayerSpectatingID[playerid]);
						}
			            else
			            {
							PlayerSpectatingID[playerid] = b;
				        	PlayerSpectatePlayer(playerid, b);
						}
						Found = 1;
				    }
				}
				if(Found == 1) break;
	            if(IsPlayerNPC(i)) continue;
	            if(!IsPlayerConnected(i)) continue;
	            if(i == PlayerSpectatingID[playerid]) continue;
	            if(PlayerSpectate[i] == true) continue;
				PlayerSpectatingID[playerid] = i;
		        PlayerSpectatePlayer(playerid, i);
			}
		}
	}
	return 1;
}


function UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
	return 1;
}

function StartGame()
{
	new Count;
	foreach(new i: PlayersAlive) Count++;
	if(Count == 0) return SetTimer("StartGame",1000,false);
	if(SecondsRemaining != 0)
	{
		new string[128];
		format(string,sizeof string,"~r~~h~Round starts in %i...",SecondsRemaining);
		foreach(new i: Player) GameTextForPlayer(i,string,1000,3);
        SecondsRemaining --;
        SetTimer("StartGame",1000,false);
	}
	else
	{
	    RoundStarted = 1;
		new Float:hp;
		hp = (BossHP/1000)*100;
	    foreach(new i: Player)
	    {
	        TextDrawTextSize(BossLabel2[i], hp*1.68499, 11.759975);
			TextDrawShowForPlayer(i,HPTD[i]);
			TextDrawShowForPlayer(i,BossLabel1[i]);
			TextDrawShowForPlayer(i,BossLabel2[i]);
			TextDrawShowForPlayer(i,BossesName[i]);
		}
	}
	return 1;
}

function RequestSpawn(playerid)
{
    if(RoundStarted == 0)
    {
		new RandSkin = random(sizeof(Skins));
	    new RandPos = random(sizeof(SpawnPoints));
	    SetSpawnInfo(playerid,1,Skins[RandSkin],SpawnPoints[RandPos][0],SpawnPoints[RandPos][1],SpawnPoints[RandPos][2],SpawnPoints[RandPos][3],0,0,0,0,0,0);
		SpawnPlayer(playerid);
		Iter_Add(PlayersAlive,playerid);
	}
	else
	{
	    new id;
	    foreach(new i: PlayersAlive)
	    {
	        id = i;
	        break;
	    }
		SetPlayerTime(playerid,0,0);
		SetPlayerWeather(playerid,365);
	    PlayerSpectate[playerid] = true;
 		TogglePlayerSpectating(playerid, 1);
 		PlayerSpectatingID[playerid] = id;
        PlayerSpectatePlayer(playerid, id);
 		new Float:hp;
		hp = (BossHP/1000)*100;
        TextDrawTextSize(BossLabel2[playerid], hp*1.68499, 11.759975);
		TextDrawShowForPlayer(playerid,HPTD[playerid]);
		TextDrawShowForPlayer(playerid,BossLabel1[playerid]);
		TextDrawShowForPlayer(playerid,BossLabel2[playerid]);
		TextDrawShowForPlayer(playerid,BossesName[playerid]);
		new string[128];
		format(string,sizeof string,"~n~~n~~n~~n~~r~~h~Round is already started!~n~~r~~h~Please wait!",SecondsRemaining);
		GameTextForPlayer(playerid,string,5000,3);
	}
	return 1;
}

function UpdateSpectatingPlayer()
{
	foreach(new i: Player) if(PlayerSpectate[i] == true) SetSpecMode(i);
	SetTimer("UpdateSpectatingPlayer",15000,false);
}

function UpdateStat()
{
	return 1;
}

stock SetSpecMode(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	PlayerSpectate[playerid] = true;
    new id = Iter_Random(PlayersAlive);
    if(id == PlayerSpectatingID[playerid]) id = Iter_Random(PlayersAlive);
    if(id == PlayerSpectatingID[playerid])
	{
		id = Iter_Random(PlayersAlive);
		if(id == PlayerSpectatingID[playerid]) return 1;
	}
	PlayerSpectatingID[playerid] = id;
    PlayerSpectatePlayer(playerid, id);
    return 1;
}
