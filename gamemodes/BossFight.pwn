#include <a_samp>
#define FIXES_ServerVarMsg 0
#include <fixes>
#include <nex-ac>
#include <sscanf2>
#include <mxini>
#include <foreach>
#include <SII>
#include <streamer>
#include <colandreas>
#include <BossArena>
#include <FCNPC>
#include <projectile>
#include <callbacks>

#undef MAX_PLAYERS
#define MAX_PLAYERS                                                     50

#define function%0(%1)     												forward%0(%1); public%0(%1)

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
#define SendFMessage(%0,%1,%2,%3) 										do{new _str[150]; format(_str,150,%2,%3); SendClientMessage(%0,%1,_str);}while(FALSE)
#define SendFMessageToAll(%1,%2,%3) 									do{new _str[190]; format(_str,150,%2,%3); SendClientMessageToAll(%1,_str);}while(FALSE)

#define Userfile 														"Admin/Users/%s.ini"
#define Registerdialog                                                  1
#define Logindialog                                                     2

forward OnCheatDetected(playerid, ip_address[], type, code);
forward OnNOPWarning(playerid, nopid, count);

main(){}
native WP_Hash(buffer[], len, const str[]);

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

enum PlayerInfo
{
	Logged,
	Rank,
	AfterLifeInfected,
	XP,
	Level,
	EvoidingCP,
	EvoidingCPTimer,
	CanThrowFlashAgain,
	FlagsHPTimer,
	HighPingWarn,
	Premium,
    Poisoned,
    SeismicTimerPhase2,
    ClanID,
    ClanName[64],
    ZombieFighting,
    ClanLeader,
    ResetPingWarns,
    Text3D:LabelMeatForShare,
    SMeatBite,
    DeletedAcc,
    FlashBangThrowPhase,
    AllowToSpawn,
    Training,
    PoisonDizzy,
    Kicked,
    ResotoreHiveHP,
    SkipRequestClass,
    BeaconMarker,
    WhatThrow,
    GroupName[32],
    SureToLeave,
    SecondsBKick,
    AllowHACForFightTimer,
    CanHide,
    FlashBangTimerPhase2,
    FlashBangTimerPhase3,
    FlashBangTimerPhase4,
    FlashBangTimerPhase5,
    FlashBangTimerPhase6,
    TrainingPhase,
    PickLockStatus,
    Waswarnedbh,
    ChooseAfterTr,
    KillWarning,
    FoundBullets,
    CanKick,
    MaxGrenades,
    CanGrenadeAgain,
    VotedYes,
    Skin,
    AssaultGrenadeThrowed,
	Flashed,
    ACWarning,
    WarningAmmo,
    CanUseSeismicShock,
    FakePerk,
    CheckMuteTimer,
    CJRunWarning,
    SeismicPhase,
    EnabledAC,
    MeatSObject,
    ToxinTimer,
	TenHoursAch,
	FlashBangObject,
	ShareMeatVomited,
	Float:MeatSX,
	Float:MeatSY,
	Float:MeatSZ,
	ToxicBites,
	SpecID,
	NOPWarnings,
	VomitDamager,
	ChangingName,
	AssaultGrenades,
	Failedlogins,
	Kills,
	MeatForShare,
	CanBeBlinded,
	CanUseRage,
	Screameds,
	KillingMinute,
	Infects,
	Deaths,
	Teamkills,
	AllowedToTip,
	PressingKeyShift,
	DestroyRadar,
	Stomped,
	CanBeStompedTimer,
	CanPunch,
	ClanIDLeaderInvite,
	Baiting,
	UpdateStatsTimer,
	Infected,//Dizzy
	CurrentXP,
	SeatID,
	XPDTimer,
	ShowingXP,
	SPerk,
	CanPlaceFlag,
	CanBiteVomit,
	PlayedMinutes,
	Float:sX,
	Float:sY,
	Float:sZ,
	KillTimerBHOP,
	Float:BefHP,
	ZPerk,
	VehicleFire,
	RageMode,
	RageModeStatus,
	JumpsHops,
	VomitRandomMeat,
	HoursPlayed,
	CanBite,
	CanBeSpitted,
 	Dead,
 	CanFlare,
 	JustInfected,
 	Bites,
 	CPCleared,
 	Assists,
 	Jailed,
	HideInVehicle,
 	Vomited,
 	XPToRankUp,
 	ExtraXP,
 	Text3D:Ranklabel,
 	RankLabelText[128],
 	MasterRadared,
 	Firsttimeincp,
 	CanBurst,
 	Float:HideHP,
 	TeamKilling,
 	ClearBurst,
 	WarnJail,
 	Grenadeproj,
 	StartCar,
 	Spectating,
 	Firstspawn,
 	ZombieBait,
 	Float:ZX,
 	Float:ZY,
 	Float:ZZ,
 	Float:DX,
 	Float:DY,
 	Float:DZ,
	Float:FlagX,
	Float:FlagY,
	Float:FlagZ,
 	GodDigged,
	ZObject,
	Flag1,
	Flag2,
	OnFire,
	sAssists,
	zAssists,
    FireMode,
    FireObject,
    TokeDizzy,
	SkillPoints,
    CanJump,
    EatenMeat,
    CanStomp,
	AllowedToBait,
    StompTimer,
    Jumps,
	Flare,
	HalloweenHat,//halloween
	Flamerounds,
	Searching,
	MolotovMission,
	BettyMission,
	DigTimer,
	CanDig,
	GodDig,
	Lastbite,
	CanRun,
	InviteID,
	RunTimer,
	RunTimerActivated,
	Vomit,
	NOPSReset,
	Float:Vomitx,
	Float:Vomity,
	Float:Vomitz,
	Allowedtovomit,
	Vomitmsg,
	Canscream,
	CanHellScream,
	CanSpit,
	KillsRound,
	DeathsRound,
	InfectsRound,
	Lighton,
	NoPM,
	LastID,
	CanPop,
	LuckyCharm,
	PlantedBettys,
	BettyObj1,
	BettyObj2,
	BettyObj3,
	BettyActive1,
	BettyActive2,
	BettyActive3,
	Bettys,
	Swimming,
	CanPowerfulGloves,
	PowerfulGlovesTimer,
	CanZombieBaitTimer,
	CanStinger,
	Muted,
	ZMoney,
	CanUseWeapons,
	Warns,
	Hiden,
	ExtraXPYear,
	ExtraXPDay,
	ExtraXPMonth,
	PremiumYear,
	PremiumDay,
	PremiumMonth,
	EatenBait,
	GroupIN,
	IsBaitWithGr,
	Spawned,
	FlashBangObjectProj,
	GroupLeader,
	GroupPlayers,
	GroupWantJoin,
	SurvivorWantToJoin,
	FlashBangs,
	Grenades,
	MuteTimer,
	JailTimer,
	FlashLightTimerOn,
	Throwingstate,
	ThrowingTimer,
	ObjectProj,
	Float:ObjAngz,
	ToBaitTimer,
	Throwed
}
new PInfo[MAX_PLAYERS][PlayerInfo];
new LoginTimer[MAX_PLAYERS];
new AnticheatEnabled;
new Skins[7] = {163,164,165,166,285,286,287};

public OnGameModeInit()
{
	LoadObj();
	// Don't use these lines if it's a filterscript
	INI_Open("Admin/Config/ServerConfig.ini");
	AnticheatEnabled = INI_ReadInt("AnticheatEnable");
	INI_Close();
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PInfo[playerid][Logged] == 0) return 0;
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(AnticheatEnabled == 1)
	{
	    new IP1[16],IP2[16];
	    GetPlayerIp(playerid, IP1, sizeof(IP1));
	    for(new i=0; i<GetMaxPlayers(); i++)
	    {
	        if(playerid == i || !IsPlayerConnected(i)) continue;
	        GetPlayerIp(i, IP2, sizeof(IP2));
	        if(!strcmp(IP1, IP2, true))
	        {
				static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using SandBoxie",GetPName(playerid));
				SendClientMessageToAll(white,string);
				SetTimerEx("kicken",50,false,"i",playerid);
				return 1;
			}
	    }
	}
    for(new s; s < 100; s++)
    {
        SendClientMessage(playerid,white,"");
        if(s == 99)
        {
            SendClientMessage(playerid,white,"========"cred"Ultimate-"cwhite"Gaming "cred"Presents..."cwhite"========");
			SendClientMessage(playerid,white,"    "cred"BOSS ARENA");
			SendClientMessage(playerid,white,"======================================");
        }
    }
	new ip[MAX_PLAYERS], playerip[16];
	GetPlayerIp(playerid, playerip, sizeof(playerip));
	new ipfile = ini_openFile("Admin/BannedIPs.ini");
	ini_getInteger(ipfile, playerip,ip[playerid]);
	ini_closeFile(ipfile);
	if(ip[playerid] == 1)
	{
		SendClientMessage(playerid, white, "* "cred"Your IP-Adress is banned!");
		SetTimerEx("kicken",100,false,"i",playerid);
		return 1;
	}
	new file[80];
	format(file,sizeof file,Userfile,GetPName(playerid));
	if(INI_Exist(file))
	{
	    LoginTimer[playerid] = SetTimerEx("TimerLogin",120000,false,"i",playerid);
		SetTimerEx("CheckRegistration",1000,false,"i",playerid);
	}
	else
	{
	    new RandSkin = random(sizeof(Skins));
	    new RandPos = random(sizeof(SpawnPoints));
	    SetSpawnInfo(playerid,1,Skins[RandSkin],SpawnPoints[RandPos][0],SpawnPoints[RandPos][1],SpawnPoints[RandPos][2],SpawnPoints[RandPos][3],0,0,0,0,0,0);
		GivePlayerWeapon(playerid,24,5000);
		GivePlayerWeapon(playerid,25,5000);
		GivePlayerWeapon(playerid,32,5000);
		SpawnPlayer(playerid);
	}
	PInfo[playerid][Logged] = 0;
	PInfo[playerid][Failedlogins] = 0;
	PInfo[playerid][CanBite] = 1;
	PInfo[playerid][CanSpit] = 1;
	PInfo[playerid][JustInfected] = 0;
	PInfo[playerid][Infected] = 0;
	PInfo[playerid][Dead] = 1;
	PInfo[playerid][SureToLeave] = 0;
	PInfo[playerid][MaxGrenades] = 0;
	PInfo[playerid][Firsttimeincp] = 1;
	PInfo[playerid][CanBurst] = 1;
	PInfo[playerid][HighPingWarn] = 0;
	PInfo[playerid][ZombieFighting] = 0;
	PInfo[playerid][Firstspawn] = 1;
	PInfo[playerid][Flashed] = 0;
 	PInfo[playerid][ZombieBait] = 0;
 	PInfo[playerid][VotedYes] = 0;
 	PInfo[playerid][SMeatBite] = 0;
 	PInfo[playerid][Poisoned] = 0;
 	PInfo[playerid][CanKick] = 1;
 	PInfo[playerid][CanHide] = 1;
 	PInfo[playerid][SeismicPhase] = 1;
 	PInfo[playerid][WhatThrow] = 0;
 	PInfo[playerid][CanGrenadeAgain] = 1;
 	PInfo[playerid][DeletedAcc] = 0;
 	PInfo[playerid][ACWarning] = 0;
 	PInfo[playerid][Throwingstate] = 1;
 	PInfo[playerid][WarningAmmo] = 0;
 	PInfo[playerid][EnabledAC] = 1;
 	PInfo[playerid][Waswarnedbh] = 0;
 	PInfo[playerid][FoundBullets] = 0;
 	PInfo[playerid][CanUseSeismicShock] = 1;
 	PInfo[playerid][CanBiteVomit] = 1;
	PInfo[playerid][FireMode] = 0;
	PInfo[playerid][SecondsBKick] = 0;
	PInfo[playerid][PoisonDizzy] = 0;
	PInfo[playerid][IsBaitWithGr] = 0;
	PInfo[playerid][ChooseAfterTr] = 0;
	PInfo[playerid][CanUseRage] = 0;
	PInfo[playerid][OnFire] = 0;
	PInfo[playerid][ClanIDLeaderInvite] = -1;
	PInfo[playerid][FakePerk] = 0;
	PInfo[playerid][EvoidingCP] = 0;
	PInfo[playerid][TokeDizzy] = 0;
	PInfo[playerid][ShareMeatVomited] = 0;
	PInfo[playerid][CanJump] = 8000;
	PInfo[playerid][Spectating] = 0;
	PInfo[playerid][SkipRequestClass] = 0;
	PInfo[playerid][SpecID] = -1;
	PInfo[playerid][Kicked] = 0;
	PInfo[playerid][ChangingName] = 0;
	PInfo[playerid][CJRunWarning] = 0;
	PInfo[playerid][FlashBangThrowPhase] = 1;
	PInfo[playerid][CanThrowFlashAgain] = 1;
	PInfo[playerid][LuckyCharm] = 60000;
	PInfo[playerid][CanPop] = 1;
	PInfo[playerid][ToxicBites] = 0;
	PInfo[playerid][MeatForShare] = 0;
	PInfo[playerid][AllowToSpawn] = 0;
	PInfo[playerid][CanPlaceFlag] = 1;
	PInfo[playerid][NOPWarnings] = 0;
	PInfo[playerid][PressingKeyShift] = 0;
	PInfo[playerid][CanStomp] = 1;
	PInfo[playerid][Stomped] = 0;
	PInfo[playerid][CanRun] = 1;
	PInfo[playerid][RageMode] = 0;
	PInfo[playerid][CanPunch] = 1;
	PInfo[playerid][RageModeStatus] = 0;
    PInfo[playerid][Flamerounds] = 0;
    PInfo[playerid][AssaultGrenades] = 0;
    PInfo[playerid][MolotovMission] = 0;
    PInfo[playerid][BettyMission] = 0;
    PInfo[playerid][CanDig] = 1;
    PInfo[playerid][GodDig] = 0;
    PInfo[playerid][Vomitmsg] = 1;
    PInfo[playerid][Lighton] = 0;
    PInfo[playerid][WarnJail] = 0;
    PInfo[playerid][NoPM] = 0;
    PInfo[playerid][LastID] = -1;
    PInfo[playerid][Vomitx] = 0;
    PInfo[playerid][CanPowerfulGloves] = 1;
    PInfo[playerid][CanStinger] = 1;
    PInfo[playerid][Baiting] = 0;
    PInfo[playerid][InviteID] = 0;
    PInfo[playerid][CanBeBlinded] = 1;
   	PInfo[playerid][AllowedToBait] = 1;
    PInfo[playerid][Spawned] = 0;
    PInfo[playerid][CanFlare] = 1;
    PInfo[playerid][CanUseWeapons] = 1;
    PInfo[playerid][CanBeSpitted] = 1;
    PInfo[playerid][AfterLifeInfected] = 0;
    PInfo[playerid][Hiden] = 0;
    PInfo[playerid][MasterRadared] = 0;
    PInfo[playerid][EatenBait] = 0;
    PInfo[playerid][GroupIN] = 0;
    PInfo[playerid][GroupLeader] = 0;
    PInfo[playerid][GroupPlayers] = 0;
    PInfo[playerid][GroupWantJoin] = 0;
    PInfo[playerid][JumpsHops] = 0;
    PInfo[playerid][SurvivorWantToJoin] = -1;
    PInfo[playerid][FlashLightTimerOn] = 90;
    PInfo[playerid][FlashBangs] = 0;
    PInfo[playerid][Grenades] = 0;
    PInfo[playerid][EatenMeat] = 0;
    PInfo[playerid][PickLockStatus] = 3;
    PInfo[playerid][Throwed] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    KillTimer(LoginTimer[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
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
	return 1;
}

function UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
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

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
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

public OnPlayerRequestSpawn(playerid)
{
	if(PInfo[playerid][Logged] == 0) return 0;
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
	if(dialogid == Logindialog)
	{
	    if(!response) Kick(playerid);
	    static password[132],file[128],buf[149];
	    format(file,sizeof file, Userfile,GetPName(playerid));
    	WP_Hash(buf, sizeof (buf), inputtext);


	    INI_Open(file);
	    INI_ReadString(password,"Password");
	    INI_Close();
	    if(strcmp(buf,password) == 0)
	    {
			GameTextForPlayer(playerid,"~g~~h~You have successfully logged in!",4000,3);
			KillTimer(LoginTimer[playerid]);
			INI_Close();
			SendFMessage(playerid,white,"|| "cgreen"Welcome back, %s!",GetPName(playerid));
			PInfo[playerid][Logged] = 1;
			PInfo[playerid][Failedlogins] = 0;
			if(PInfo[playerid][Premium] == 1)
			    SendFMessage(playerid,white,"* "cgold"Thanks for supporting our community, Gold member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 2)
			    SendFMessage(playerid,white,"* "cplat"Thanks for supporting our community, Platinum member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 3)
				SendFMessage(playerid,white,"* "cblue"Thanks for supporting our community, Diamond member %s!",GetPName(playerid));
 	    	new RandSkin = random(sizeof(Skins));
		    new RandPos = random(sizeof(SpawnPoints));
		    SetSpawnInfo(playerid,1,Skins[RandSkin],SpawnPoints[RandPos][0],SpawnPoints[RandPos][1],SpawnPoints[RandPos][2],SpawnPoints[RandPos][3],0,0,0,0,0,0);
			SpawnPlayer(playerid);
		}
	    else
	    {
	        PInfo[playerid][Failedlogins]++;
	        if(PInfo[playerid][Failedlogins] == 3)
	        {
                format(buf,sizeof buf,"%s has been kicked for 3 failed attemps of logging in",GetPName(playerid));
                SendAdminMessage(red,buf);
                Kick(playerid);
	        }
			format(buf,sizeof buf,""cred"Attempts left: "cwhite"%d \n"cred"Attempts allowed: "cgreen"3 \n"cwhite"Please type in your password to "cligreen"load "cwhite"your status \n",3-PInfo[playerid][Failedlogins]);
            ShowPlayerDialog(playerid,Logindialog,3,"Login",buf,"Login","Cancel");
	    }
	}
	if(dialogid == Registerdialog)
	{
	    if(!response) return Kick(playerid);
        if(strlen(inputtext) < 3 || strlen(inputtext) > 22)
	    {
			new string[1024];
			format(string,sizeof string,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
			strcat(string,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.54");
			strcat(string,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
			strcat(string,""cwhite"\n Project Authors: "dred"Zackster, Grenade");
		 	strcat(string,""cwhite"\n Script Author: "dred"Zackster");
		 	strcat(string,""cwhite"\n Forum Supporter: "dred"freefaal");
            strcat(string,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy)");
            strcat(string,""cwhite"\n Addition Map: "dred"Zackster");
        	strcat(string,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n");
        	strcat(string,""cwhite"\n \t\t\t\t"cblue"Forum: "cred"ug-ultimategaming.proboards.com\n\n\n");
        	strcat(string,""cwhite"\t\t\t\t        You must to "cred"register "cwhite"to play on server!\n\t\t        Your password must have more than 3 and less than 22 characters!");
			ShowPlayerDialog(playerid,Registerdialog,3,""cred"Ultimate - "cwhite"Gaming",string,"Register","Quit");
		}
	    else
	    {
	        static buf[131];
    		WP_Hash(buf, sizeof (buf), inputtext);
    		RegisterPlayer(playerid,buf);
    		new playersregistered;
    		INI_Open("Admin/Config/ServerConfig.ini");
			playersregistered = INI_ReadInt("RegisteredUsers");
			INI_WriteInt("RegisteredUsers",playersregistered+1);
    		INI_Save();
    		INI_Close();
			PInfo[playerid][JustRegistered] = 1;
			SendClientMessage(playerid,red,"** "corange"You got "cred"2X XP Booster"corange" for registration! (1 week)");
            SaveStats(playerid);
			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules", "Choose", "Close");
    		//ShowPlayerDialog(playerid,999,DSM,"Training course",""cwhite"If you are new here we recommend you pass training course\nTo learn basis of the game and how everything works here\nAfter passing training course you will get 50 XP\n\nDo you want to pass training course on the server?", "Yes","No");
 			ForceClassSelection(playerid);
			TogglePlayerSpectating(playerid, true);
			TogglePlayerSpectating(playerid, false);
     		if(CPscleared >= 5)
			{
				Team[playerid] = ZOMBIE;
       	        new RandomGS = random(sizeof(gRandomSkin));
        		SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
        		PInfo[playerid][SkipRequestClass] = 1;
        		PInfo[playerid][Skin] = gRandomSkin[RandomGS];
			    SetSpawnInfo(playerid,1,RandomGS,0,0,0,0,0,0,0,0,0,0);
				SpawnPlayer(playerid);
				SendClientMessage(playerid,white,""cred"Survivors have cleared more than 5 checkpoints, help zombies, don't let humans clear all checkpoints!");
				SendClientMessage(playerid,white,"** "cred"Autobalance: "cwhite"Zombie's team was autobalanced!");
				return 1;
			}
		    if(RealInfection >= 70)
		    {
				Team[playerid] = ZOMBIE;
       	        new RandomGS = random(sizeof(gRandomSkin));
        		SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
        		PInfo[playerid][SkipRequestClass] = 1;
        		PInfo[playerid][Skin] = gRandomSkin[RandomGS];
			    SetSpawnInfo(playerid,1,GetPlayerSkin(playerid),0,0,0,0,0,0,0,0,0,0);
				SpawnPlayer(playerid);
				SendClientMessage(playerid,white,""cred"Zombie team has over 70% of the server infected, help them win, kill the last survivors!");
				SendClientMessage(playerid,white,"** "cred"Autobalance: "cwhite"Zombie's team was autobalanced!");
				return 1;
		    }
		}
		return 1;
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnCheatDetected(playerid, ip_address[], type, code)
{
	if(AnticheatEnabled == 1)
	{
	    if(PInfo[playerid][EnabledAC] == 1)
	    {
			if(!IsPlayerAdmin(playerid))
			{
			    if(PInfo[playerid][Kicked] == 1) return 0;
				switch(code)
				{
				    case 0..1:
				    {
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Airbreak",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 3:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked using Teleport Hacks (TP to Vehicle)",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
			 		case 4:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked using Teleport Hacks (TP between Vehicles)",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
			 		case 6:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked using Teleport Hacks (TP to pickup)",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
			    	case 9..10:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Speed Hack",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
			    	case 13:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Armour Hack",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 14:
					{
			        	//?????????? ?????? ?????
				        new a = AntiCheatGetMoney(playerid);
				        ResetPlayerMoney(playerid);
				        GivePlayerMoney(playerid, a);
				        return 1; //???? ????????? ????? ??? ?? ?????
					}
					case 15..16:
			    	{
			    	    new string[128];
			    	    if(PInfo[playerid][WarningAmmo] == 1)
			    	    {
      						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected hacks - %s Kicked for using Weapon/Ammo Hack",GetPName(playerid));
 							SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
                            PInfo[playerid][Kicked] = 1;
                            SendAdminMessage(white,string);
                            SetTimerEx("kicken",20,false,"i",playerid);
                            return 1;
						}
						PInfo[playerid][WarningAmmo]++;
				    	ResetPlayerWeapons(playerid);
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat warns - %s maybe using Weapon/Ammo Hack",GetPName(playerid));
						foreach(new i: Player)
						{
						    if(PInfo[i][Logged] == 0) continue;
							if(PInfo[i][Level] < 1) continue;
							SendClientMessage(i,white,string);
						}
						return 1;
					}
					case 21:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Invisible Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 22:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using lagcomp-spoof",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 23:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Tuning Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 24:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Parkour Mode",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 25:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Quick Turn Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 26:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Rapid Fire",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 29:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Aimbot",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 30:
			    	{
			    	    if(PInfo[playerid][CJRunWarning] == 0)
			    	    {
			    	    	SpawnPlayer(playerid);
			    	    	PInfo[playerid][CJRunWarning] = 1;
						}
						else if(PInfo[playerid][CJRunWarning] == 1)
						{
					    	static string[128];
					    	SendAdminMessage(white,string);
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for CJ Run",GetPName(playerid));
							SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
							PInfo[playerid][Kicked] = 1;
							SetTimerEx("kicken",20,false,"i",playerid);
						}
						return 1;
					}
					case 31:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Car Shot",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 32:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using CarJack Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 33:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Anti-Freeze Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 34:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using AFK Ghost",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 35:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Aim Bot (type 2)",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 36:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fake NPC",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 41:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Invalid version - %s kicked for wrong version of client",GetPName(playerid));
						SendAdminMessage(white,string);
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
					case 42:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected try for hacking rcon password - %s kicked for brutting",GetPName(playerid));
						foreach(new i: Player)
						{
						    if(PInfo[i][Level] >=1)
						    {
						    	SendClientMessage(i,white,string);
							}
						}
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						return 1;
					}
			  		case 43..46: //???????
			    	{

			        	Kick(playerid); //?????? ????????????? ?????? ??? ????????, ????? ??? ?????? ???????? ???????
			        	return 1;
			    	}
			    	case 50:
			    	{
			    	    PInfo[playerid][Kicked] = 1;
			    	    SetTimerEx("kicken",20,false,"i",playerid);
			    	}
				}
				if(GetPlayerPing(playerid) < 200)
				{
				    if(PInfo[playerid][ACWarning] == 1)
				    {
				    	CheckCode(playerid,code);
				    	return 0;
					}
					else
					{
					    KillTimer(PInfo[playerid][KillWarning]);
					    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
					}
				}
				else if(GetPlayerPing(playerid) >= 200)
				{
				    if(PInfo[playerid][ACWarning] == 2)
				    {
				    	CheckCode(playerid,code);
				    	return 0;
					}
					else
					{
					    KillTimer(PInfo[playerid][KillWarning]);
					    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
					}
				}
				PInfo[playerid][ACWarning] ++;
				switch(code)
				{
			    	case 2:
					{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1st Type)",GetPName(playerid));
						SendAdminMessage(white,string);
					}
					case 5: return 1;
			    	case 7..8:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
						SendAdminMessage(white,string);
					}
			    	case 11..12:
			    	{
			    	    if(PInfo[playerid][Hiden] == 1) return 0;
			    	    if(PInfo[playerid][ZombieFighting] == 1) return 0;
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
						SendAdminMessage(white,string);
					}
					case 17:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Infinite ammo Hack",GetPName(playerid));
						SendAdminMessage(white,string);
					}
					case 18:
			    	{
			    	    static string[128];
			    	    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
			    	    {
							SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
							PInfo[playerid][Kicked] = 1;
							SetTimerEx("kicken",20,false,"i",playerid);
							SendAdminMessage(white,string);
							return 1;
						}
						else
						{
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendAdminMessage(white,string);
						}
					}
					case 19..20:
			    	{
						if(PInfo[playerid][ZombieFighting] == 1) return 0;
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using GodMode Hack",GetPName(playerid));
						SendAdminMessage(white,string);
					}
  					case 27..28:
		    		{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using using Kill Flooding",GetPName(playerid));
						SendAdminMessage(white,string);
					}
				}
			}
		}
	}
	return 1;
}

public OnNOPWarning(playerid, nopid, count)
{
	if(!IsPlayerAdmin(playerid))
	{
	    if(PInfo[playerid][EnabledAC] == 1)
	    {
	        if(nopid == 13) return 1;
	        if(PInfo[playerid][Kicked] == 1) return 0;
		    if(PInfo[playerid][NOPWarnings] == 5)
		    {
				static string[256];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected that you were using cheat programms and kicked you");
				SendClientMessage(playerid,white,string);
				SetTimerEx("kicken",100,false,"i",playerid);
				PInfo[playerid][Kicked] = 1;
				foreach(new i: Player)
				{
				    if(PInfo[i][Level] < 1) continue;
				    static strang[256];
					format(strang,sizeof strang,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s was kicked for using anti-NOPs hacks",GetPName(playerid));
					SendClientMessage(i,white,string);
				}
			}
			else
			{
			    KillTimer(PInfo[playerid][NOPSReset]);
			    PInfo[playerid][NOPWarnings] ++;
			    SetTimerEx("ResetNOPsWarnings",60000,false,"i",playerid);
			    if(PInfo[playerid][NOPWarnings] == 1)
			    {
				    foreach(new i: Player)
				    {
					    if(PInfo[i][Level] < 1) continue;
					    static strang[256];
						format(strang,sizeof strang,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s maybe using anti-NOPs hacks",GetPName(playerid));
						SendClientMessage(i,white,strang);
					}
				}
			}
		}
	}
	return 1;
}

function kicken(playerid)
{
	Kick(playerid);
	return 1;
}

function ResetNOPsWarnings(playerid)
{
	PInfo[playerid][NOPWarnings] = 0;
	return 1;
}

function KillWarn(playerid)
{
    PInfo[playerid][ACWarning] = 0;
	return 1;
}

function CheckCode(playerid,code)
{
	switch(code)
	{
    	case 2:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Teleport Hacks (1st type)",GetPName(playerid));
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			SendAdminMessage(white,string);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
		case 5: return 1;
    	case 7..8:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fly Hacks",GetPName(playerid));
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			SendAdminMessage(white,string);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
    	case 11..12:
    	{
	    	static string[128];
			if(PInfo[playerid][Hiden] == 1) return 0;
    	    if(PInfo[playerid][ZombieFighting] == 1) return 0;
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Health Hack",GetPName(playerid));
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			SendAdminMessage(white,string);
    	    if(code == 11)
    	    {
            	PInfo[playerid][Kicked] = 1;
            	SetTimerEx("kicken",20,false,"i",playerid);
			}
			return 1;
		}
		case 16..17:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Ammo Hack",GetPName(playerid));
			SendAdminMessage(white,string);
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
		case 18:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Special Actions Hack",GetPName(playerid));
			SendAdminMessage(white,string);
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
		case 19..20:
    	{
			if(PInfo[playerid][ZombieFighting] == 1) return 0;
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using GodMode Hack",GetPName(playerid));
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			SendAdminMessage(white,string);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
		case 27..28:
		{
			static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using using Kill Flooding",GetPName(playerid));
            SendAdminMessage(white,string);
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
	}
	return 1;
}

function CheckRegistration(playerid)
{
	SetPlayerTime(playerid,23,0);
	SetPlayerWeather(playerid,5123524);
    SetPlayerVirtualWorld(playerid,0);
 	SetPlayerPos(playerid,1446.2224,-1303.2131,56.5103);
	SetPlayerCameraPos(playerid,1446.2224,-1303.2131,36.5103);
	SetPlayerCameraLookAt(playerid,1519.0198,-1303.6342,40.9884);
    new file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	if(INI_Exist(file))
	{
	    INI_Open(file);
	    if(INI_ReadInt("Banned") == 1)
	    {
			if(INI_ReadInt("BanTime") != -1)
			{
				new bantime = INI_ReadInt("BanTime");
				if(gettime() > bantime)
				{
				    SendClientMessage(playerid,white,"*** "cred"You were unbanned! Next ban can be permament!");
					INI_WriteInt("Banned",0);
					INI_Save();
					INI_Close();
					new strang[128];
					format(strang,sizeof strang,"** "cred"|%i| %s was unbanned!",playerid,GetPName(playerid));
					SendAdminMessage(white,strang);
				}
				else
				{
					new string[256],wbanned[22],reason[64],bdate[32];
					INI_ReadString(reason,"BanReason");
					INI_ReadString(bdate,"BanDate");
					new banstime = bantime - gettime();
					if(floatround(banstime/3600) > 0)
						format(string,sizeof string,"** "cred"You will be automatically unbanned in %i hour(s)",floatround(banstime/3600));
					else if(floatround(banstime/3600) <= 0)
						format(string,sizeof string,"** "cred"You will be automatically unbanned in %i minutes(s)",floatround(banstime/60));
					SendClientMessage(playerid,white,string);
					INI_ReadString(wbanned,"WhoBanned");
					format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason: %s \nDate: %s\n\n\n\t"cgreen"\nIf you think that you got ban for nothing\nTake a picture of this box and post an unban appeal at our forum.",wbanned,GetPName(playerid),GetHisIP(playerid),reason,bdate);
					ShowPlayerDialog(playerid,4533,0,""cred"You have been banned - read the following details!",string,"Close","");

					SetTimerEx("BanPlayer",10,false,"i",playerid);
					SetTimerEx("kicken",100,false,"i",playerid);
					return 0;
				}

			}
			else
			{
		        SendFMessageToAll(red,"%s has tried to ban evade. He was disconnected.",GetPName(playerid));
				format(file,sizeof file,"%s has tried to ban evade.",GetPName(playerid));
				SaveIn("Banevadelog",file,1);
				new string[256],wbanned[22],reason[64],bdate[32];
				INI_ReadString(reason,"BanReason");
				INI_ReadString(bdate,"BanDate");

				INI_ReadString(wbanned,"WhoBanned");
				format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason: %s \nDate: %s\n\n\n\t"cgreen"\nIf you think that you got ban for nothing\nTake a picture of this box and post an unban appeal at our forum.",wbanned,GetPName(playerid),GetHisIP(playerid),reason,bdate);
				ShowPlayerDialog(playerid,4533,0,""cred"You have been banned - read the following details!",string,"Close","");

				SetTimerEx("BanPlayer",10,false,"i",playerid);
				SetTimerEx("kicken",100,false,"i",playerid);
				return 0;
			}
		}
	    new string[79];
	    format(string,sizeof string,"\t"cred"Ultimate - "cwhite"Gaming");
		new strang[2048];
		format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
		strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.06.1");
		strcat(strang,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
		strcat(strang,""cwhite"\n Project Authors: "dred"Zackster, Grenade");
	 	strcat(strang,""cwhite"\n Script Author: "dred"Zackster");
	 	strcat(strang,""cwhite"\n Forum Supporter: "dred"freefaal");
        strcat(strang,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy)");
        strcat(strang,""cwhite"\n Addition Map: "dred"Zackster");
    	strcat(strang,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n");
    	strcat(strang,""cwhite"\n \t\t\t\t"cblue"Forum: "cred"ug-ultimategaming.proboards.com\n\n\n");
		strcat(strang,""cwhite"\t\t\t    Please, write your password below to "cred"Start Playing!");
 		ShowPlayerDialog(playerid,Logindialog,3,string,strang,"Login","Quit");
	}
	else
	{
	    if(!IsPlayerNPC(playerid))
	    {
			new strang[2048];
			format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
			strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.06.1");
			strcat(strang,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
			strcat(strang,""cwhite"\n Project Authors: "dred"Zackster, Grenade");
		 	strcat(strang,""cwhite"\n Script Author: "dred"Zackster");
		 	strcat(strang,""cwhite"\n Forum Supporter: "dred"freefaal");
	        strcat(strang,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy)");
	        strcat(strang,""cwhite"\n Addition Map: "dred"Zackster");
	    	strcat(strang,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n");
	    	strcat(strang,""cwhite"\n \t\t\t\t"cblue"Forum: "cred"ug-ultimategaming.proboards.com\n\n\n");
        	strcat(strang,""cwhite"\t\t\t\t        You must to "cred"register "cwhite"to play on server!\n\t\t\t\t        Create a password and enter it below!");
			ShowPlayerDialog(playerid,Registerdialog,3,""cred"Ultimate - "cwhite"Gaming",strang,"Register","Quit");
		}
	}
	return 1;
}

function TimerLogin(playerid)
{
	if(PInfo[playerid][Logged] == 0)
	{
		SendClientMessage(playerid,white,"** "cred"The time to login has ended, reconnect to the server to log in again!");
		SetTimerEx("kicken",300,false,"i",playerid);
	}
	return 1;
}
/*=======================================STOCKS START==================================*/

stock GetPName(playerid)
{
	new p_name[24];
	GetPlayerName(playerid,p_name,24);
	return p_name;
}

stock SendAdminMessage(color,text[])
{
	foreach(new i: Player)
	{
	    if(PInfo[i][Level] > 0)
	    {
			SendClientMessage(i,color,text);
	    }
	}
	return 1;
}

stock PlaySound(playerid,soundid)
{
	new Float:p[3];
	GetPlayerPos(playerid, p[0], p[1], p[2]);
	PlayerPlaySound(playerid, soundid, p[0], p[1], p[2]);
	return 1;
}

stock PlayNearSound(playerid,soundid)
{
	new Float:p[3];
	GetPlayerPos(playerid, p[0], p[1], p[2]);
	foreach(new i: Player)
	{
	    if(IsPlayerInRangeOfPoint(i,7.0,p[0], p[1], p[2]))
	        PlayerPlaySound(i, soundid, p[0], p[1], p[2]);
	}
	return 1;
}

stock PlaySoundForAll(soundid)
{
	new Float:p[3];
	foreach(Player,i)
	{
		GetPlayerPos(i, p[0], p[1], p[2]);
		PlayerPlaySound(i, soundid, p[0], p[1], p[2]);
	}
	return 1;
}

stock SendNearMessage(playerid,color,text[],range)
{
    static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
    foreach(new i: Player)
    {
        if(IsPlayerInRangeOfPoint(i,range,x,y,z))
        {
        	SendClientMessage(i,color,text);
   		}
    }
	return 1;
}

stock randomEx(minnum = cellmin,maxnum = cellmax) return random(maxnum - minnum + 1) + minnum;

stock IsVehicleOccupied(vehicleid)
{
	foreach(new i: Player)
	{
	    if(Team[i] == ZOMBIE) continue;
    	if(IsPlayerInVehicle(i, vehicleid))
    	{
  			return 1;
		}
  	}
  	return 0;
}

stock SaveIn(filename[],text[],displaydate)
{
	new File:Lfile;
	new filepath[256];
	new string[256];
	new year,month,day;
	new hour,minute,second;

	getdate(year,month,day);
	gettime(hour,minute,second);
	format(filepath,sizeof(filepath),"Admin/Logs/%s.txt",filename);
	if(!INI_Exist(filepath))
	{
	    INI_Open(filepath);
 	}
	Lfile = fopen(filepath,io_append);
	if(displaydate == 1)
	{
		format(string,sizeof(string),"[%02d/%02d/%02d | %02d:%02d:%02d] %s\r\n",day,month,year,hour,minute,second,text);
		fwrite(Lfile,string);
		fclose(Lfile);
	}
	else if(displaydate == 0)
	{
	    format(string,sizeof(string),"%s\r\n",text);
		fwrite(Lfile,string);
		fclose(Lfile);
	}
	return 1;
}

stock TurnPlayerFaceToPos(playerid, Float:x, Float:y)
{
    new Float:angle;
    new Float:misc = 5.0;
    new Float:ix, Float:iy, Float:iz;
    GetPlayerPos(playerid, ix, iy, iz);
    angle = 180.0-atan2(ix-x,iy-y);
    angle += misc;
    misc *= -1;
    SetPlayerFacingAngle(playerid, angle+misc);
}

stock SetPlayerPosAndAngle(playerid, Float:x, Float:y, Float:z, Float:ang)
{
	SetPlayerPos(playerid,x,y,z);
	SetPlayerFacingAngle(playerid,ang);
	return 0;
}

stock SetPlayerToFacePlayer(playerid, targetid)
{

	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
	GetPlayerPos(targetid, X, Y, Z);
	GetPlayerPos(playerid, pX, pY, pZ);
	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	SetPlayerFacingAngle(playerid, ang);
 	return 0;
}

stock IsPlayerFacingPlayer(playerid, targetid, Float:dOffset)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
	GetPlayerPos(targetid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(AngleInRangeOfAngle(-ang, pA, dOffset)) return true;
	return false;
}

stock IsPlayerFacingObject(playerid, objectid, Float:dOffset)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:pA,
		Float:X,
		Float:Y,
		Float:Z,
		Float:ang;
	if(!IsPlayerConnected(playerid)) return 0;
	GetObjectPos(objectid, pX, pY, pZ);
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, pA);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(AngleInRangeOfAngle(-ang, pA, dOffset)) return true;
	return false;
}

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{
	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;
	return false;
}

stock GetClosestPlayer(playerid,Float:limit)
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid,x1,y1,z1);
    new Float:Ranger = 999.9;
    new id = -1;
    foreach(new i: Player)
    {
        if(playerid != i)
        {
            GetPlayerPos(i,x2,y2,z2);
            new Float:Dist = GetDistanceBetweenPoints(x1,y1,z1,x2,y2,z2);
            if(PInfo[i][EvoidingCP] == 1)
           	{
                Ranger = Dist;
                id = i;
                break;
            }
            else if(floatcmp(Ranger,Dist) == 1 && floatcmp(limit,Ranger) == 1)
            {
                Ranger = Dist;
                id = i;
            }
        }
    }
    return id;
}

stock GetClosestVehicle(playerid,Float:range)
{
    new car, Float:ang;
    car = -1;
    ang = 9999.9999;

    for(new i = 0; i < MAX_PLAYERS; i++)
    for(new v = 0; v < MAX_VEHICLES; v++)
    {
        #define INVALID_ID (0xFFFF)
        if(!IsPlayerConnected(i) && v == INVALID_ID) continue;
        if(!IsPlayerInVehicle(i, v))
        {
            new Float:X, Float:Y, Float:Z;
            GetVehiclePos(v, X, Y, Z);

            if(ang > GetPlayerDistanceFromPoint(playerid, X, Y, Z))
            {
                if(IsPlayerInRangeOfPoint(i,range,X,Y,Z))
                {
                	ang = GetPlayerDistanceFromPoint(playerid, X, Y, Z);
                	car = v;
               	}
            }
        }
    }
    return car;
}

stock BanPlayer(playerid)
	return BanEx(playerid,"Ban evading");

stock IsPlayerInRangeOfObject(playerid, Float:range, objectid)
{
    new Float:pos[3];
    GetObjectPos(objectid, pos[0], pos[1], pos[2]);
    return IsPlayerInRangeOfPoint(playerid, range, pos[0], pos[1], pos[2]);
}

stock Difference(Float:Value1, Float:Value2)
{
        return floatround((Value1 > Value2) ? (Value1 - Value2) : (Value2 - Value1));
}

stock GetHisIP(playerid)
{
	new ip[16];
	GetPlayerIp(playerid,ip,16);
	return ip;
}

stock IsVehicleRangeOfPoint(vehicleid,Float:range,Float:x,Float:y,Float:z)
{
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    new Float:DistantaCar = GetVehicleDistanceFromPoint(vehicleid, x, y, z);
    if(DistantaCar <= range) return 1;
    return 0;
}

stock GetXYInFrontOfPoint(Float:x, Float:y, &Float:x2, &Float:y2, Float:A, Float:distance)
{
    x2 = x + (distance * floatsin(-A, degrees));
    y2 = y + (distance * floatcos(-A, degrees));
}
///=======================================STOCKS END==================================
