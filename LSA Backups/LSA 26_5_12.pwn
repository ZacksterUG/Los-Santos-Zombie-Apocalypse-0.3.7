 //======================= Inventory system copied =============================
#include <a_samp>
#include <SII>
#include <zcmd>
#include <sscanf2>
#include <GetVehicleColor>
#include <j_inventory_v2>
#include <GetVehicleName>
#include <streamer>

#define Userfile 														"Admin/Users/%s.ini"
#define snowing                                                         true
#define Version                                                         "0.2"
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     11
#define CPTIME                                                          20000//Time between each checkpoint
#define CPVALUE                                                         10//CPValue, the value of, when it gets reached, it the cp gets cleared.
#define DIGTIME                                                         120000//Time of cooldown between digging.
#define VOMITTIME                                                       60000//Time of cooldown between vomitting.
//============================== [Dialogs] =====================================
#define Registerdialog                                                  1
#define Logindialog                                                     2
#define Humanperksdialog                                                3
#define Zombieperksdialog                                               4
#define Lessbitedialog                                                  5
#define Flashbangsdialog                                                45
#define Burstdialog                                                     6
#define Inventorydialog                                                 7
#define Extramedsdialog                                                 8
#define Extrafueldialog                                                 9
#define Extraoildialog                                                  10
#define Medicdialog                                                     11
#define Morestaminadialog                                               46
#define Zombiebaitdialog                                                12
#define Firemodedialog                                                  13
#define Mechanicdialog                                                  14
#define Extraammodialog                                                 15
#define Fielddoctordialog                                               16
#define Rocketbootsdialog                                               17
#define Homingbeacondialog                                              18
#define Mastermechanicdialog                                            19
#define Flameroundsdialog                                               20
#define Luckycharmdialog                                                21
#define Grenadesdialog                                                  22
#define Noperkdialog                                                    23

#define Nozombieperkdialog                                              25
#define Hardbitedialog                                                  26
#define Diggerdialog                                                    27
#define Refreshingbitedialog                                            28
#define Jumperdialog                                                    29
#define Deadsensedialog                                                 30
#define Hardpunchdialog                                                 31
#define Vomiterdialog                                                   32
#define Screamerdialog                                                  33
#define ZBurstrundialog                                                 34
#define Stingerbitedialog                                               35
#define Bigjumperdialog                                                 36
#define Stompdialog                                                     37
#define Refreshingbitedialog2                                           38
#define Goddigdialog                                                    39
#define Poppingtiresdialog                                              40
#define Higherjumperdialog                                              41
#define Repellentdialog                                                 42
#define Ravagingbitedialog                                              43
#define Superscreamdialog                                               44
//============================== [Dialogs] =====================================
//============================== [RRGGBB] ======================================
#define cwhite                                                          "{EEFFFF}"
#define cligreen                                                        "{44CC22}"
#define cred                                                            "{FF1111}"
#define cgreen                                                          "{05E200}"
#define cblue                                                           "{00B9FF}"
#define cjam                                                            "{E67EF8}"
#define corange                                                         "{FF9600}"
#define cgrey                                                           "{CCCCCC}"
#define cgold                                                           "{FFBB00}"
#define cplat                                                           "{666666}"
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
//============================== [Server config] ===============================
#define function%0(%1)     												forward%0(%1); public%0(%1)
#define HUMAN                                                           1
#define ZOMBIE                                                          2
#define PRESSED(%0)  													(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0)														((newkeys & (%0)) == (%0))
#define RELEASED(%0) 													(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define SendFMessage(%0,%1,%2,%3) 										do{new _str[150]; format(_str,150,%2,%3); SendClientMessage(%0,%1,_str);}while(FALSE)
#define SendFMessageToAll(%1,%2,%3) 									do{new _str[190]; format(_str,150,%2,%3); SendClientMessageToAll(%1,_str);}while(FALSE)
#define SetPlayerHoldingObject(%1,%2,%3,%4,%5,%6,%7,%8,%9) 				SetPlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1,%2,%3,%4,%5,%6,%7,%8,%9)
#define StopPlayerHoldingObject(%1) 									RemovePlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
#define WEAPON_TYPE_NONE 												(0)
#define WEAPON_TYPE_HEAVY   											(1)
#define WEAPON_TYPE_LIGHT   											(2)
#define WEAPON_TYPE_MELEE   											(3)
#define PlayAudioStream(%0,%1,%2)                               		PlayAudioStreamForPlayer(%0,%1); SetTimerEx("UnloadMusic",%2*1000,false,"i",%0);//By Firecat
#undef  MAX_VEHICLES
#define MAX_VEHICLES                                                    100
#define MAX_ITEMS 														20
#define MAX_ITEM_STACK 													99
#define MAX_ITEM_NAME 													24
#define isEven(%0) 														(!((%0) & 0b1))
#define isOdd(%0) 														!isEven((%0))
//============================== [Server config] ===============================
//============================== [Text Draw's] =================================
new Text:GainXPTD[MAX_PLAYERS];
new Text:Stats[MAX_PLAYERS];
new Text:XPStats[MAX_PLAYERS];
new Text:FuelTD[MAX_PLAYERS];
new Text:OilTD[MAX_PLAYERS];
new Text:XPBox;
new Text:Infection;
new Text:CPSCleared;
new Text:RoundStats;
new Text:Effect[9];
//============================== [Text Draw's] =================================
main(){}
native WP_Hash(buffer[], len, const str[]);
new FALSE = false;

new Float:Locations[6][6] =
{
    {1214.9613,-13.3497,1000.9219,2421.7861,-1225.6342,25.1479},//Pig Pen
	{502.3001,-14.7957,1000.6797,1833.2510,-1681.9969,13.4811},//Alhambra
	
	{212.5261,-107.4397,1005.1406,2241.1416,-1658.3157,15.2899},//Binco
	{175.3852,-83.6727,1001.8047,1458.4044,-1141.6309,24.0566},//Zip
	
	{169.1966,-1797.3027,4.1501,173.6723,-1798.2090,4.0596},//beach
	{2164.3032,-1989.0576,14.0276,2163.9861,-1987.4554,13.9685}//Waste industrial
};

new Float:Searchplaces[25][3] =
{
    {255.3864,76.7248,1003.6406},
    {235.4062,74.3358,1005.0391},
    {-20.2721,-52.8958,1003.5469},
    {-18.2101,-50.8218,1003.5469},
    {502.5851,-19.5065,1000.6797},
    {476.1003,-14.7468,1003.6953},
    {2285.4458,-1133.9231,1050.8984},
    {2279.3196,-1135.3746,1050.8984},
    {257.3222,-43.0028,1002.0234},
    {2500.0161,-1706.7634,1014.7422},
    {2500.0164,-1711.2230,1014.7422},
    {2495.2734,-1704.6929,1018.3438},
    {2493.8638,-1700.8329,1018.3438},
    {1210.5579,-15.5985,1000.9219},
    {1215.1836,-15.4792,1000.9219},
    {2342.0168,-1187.5696,1027.9766},
    {2322.7087,-1177.4677,1027.9834},
    {2322.2703,-1172.5985,1027.9766},
    {2348.7813,-1173.9921,1031.9766},
    {380.0800,-57.6338,1001.5078},
    {376.2350,-57.6464,1001.5078},
    {2368.3879,-1134.9847,1050.8750},
    {2361.1465,-1130.8175,1050.8750},
    {2366.8477,-1120.0946,1050.8750},
    {2374.3179,-1128.3701,1050.8750}
};

new Float:Randomspawns[9][4] =
{
    {1126.2839,-1489.7096,22.7690,227.3781},
    {814.6721,-1616.2850,13.6032,263.0842},
    {330.2045,-1516.2036,35.8672,219.0583},
    {2019.4609,-1436.4253,14.2981,71.6593},
    {2213.3916,-1178.8707,29.7971,4.1820},
    {2379.8376,-1290.6743,24.0000,91.6702},
    {2632.6743,-1751.6016,10.8983,266.9871},
    {1953.2102,-2031.8896,13.5469,266.9979},
    {803.6842,-1342.0836,-0.5078,137.2818}
};

new Float:RandomEnd[10][4] =
{
    {291.6124,-1870.9211,3.8332,2.6989},
    {286.9165,-1870.4952,3.8332,2.0723},
    {288.2404,-1872.1360,6.4023,3.8073},
    {290.3231,-1871.9995,6.4023,359.7339},
    {258.6598,-1871.1213,2.3684,20.9005},
    {266.5316,-1869.8938,2.5840,346.2722},
    {269.9425,-1876.8267,2.2457,355.9013},
    {244.6034,-1871.8011,5.8867,312.8547},
    {246.8585,-1871.6027,5.8867,319.3258},
    {249.5930,-1870.4410,2.3572,324.3268}
};

new Float:EndPos[30][4] =
{
    {280.71, -1862.43, 2.01},
	{280.63, -1857.70, 2.01},
	{280.69, -1853.22, 2.01},
	{280.80, -1849.07, 2.01},
	{276.92, -1849.00, 2.01},
	{273.09, -1848.90, 2.01},
	{257.49, -1862.52, 2.01},
	{260.81, -1862.47, 2.01},
	{254.05, -1862.55, 2.01},
	{264.31, -1862.34, 2.01},
	{264.44, -1859.11, 2.01},
	{264.36, -1855.83, 2.01},
	{260.60, -1855.80, 2.01},
	{257.36, -1855.83, 2.01},
	{254.24, -1855.91, 2.01},
	{254.14, -1852.33, 2.01},
	{254.00, -1848.95, 2.01},
	{257.20, -1848.89, 2.01},
	{260.68, -1849.03, 2.01},
	{264.22, -1848.99, 2.01},
	{245.54, -1848.97, 2.01},
	{244.39, -1853.32, 2.01},
	{243.30, -1857.74, 2.01},
	{241.77, -1862.37, 2.01},
	{239.72, -1857.76, 2.01},
	{238.45, -1853.31, 2.01},
	{236.86, -1848.81, 2.01},
	{242.75, -1853.38, 2.01},
	{241.25, -1853.40, 2.01},
	{239.63, -1853.40, 2.01}
};

new ZombieSkins[] =
{
	134,
	135,
	137,
	160,
	162,
	168,
	200,
	212,
	230,
	239
};

enum PlayerInfo
{
	Logged,
	Rank,
	XP,
	Level,
	Premium,
	Failedlogins,
	Kills,
	Infects,
	Deaths,
	Teamkills,
	Infected,//Dizzy
	CurrentXP,
	ShowingXP,
	SPerk,
	ZPerk,
	CanBite,
 	Dead,
 	JustInfected,
 	Bites,
 	CPCleared,
 	Assists,
 	Vomited,
 	XPToRankUp,
 	Text3D:Ranklabel,
 	Firsttimeincp,
 	CanBurst,
 	ClearBurst,
 	StartCar,
 	Firstspawn,
 	ZombieBait,
 	Float:ZX,
 	Float:ZY,
 	Float:ZZ,
	ZObject,
	ZCount,
	OnFire,
    FireMode,
    FireObject,
    TokeDizzy,
    CanJump,
    CanStomp,
    StompTimer,
    Jumps,
	Flare,
	Flamerounds,
	Searching,
	MolotovMission,
	DigTimer,
	CanDig,
	GodDig,
	Lastbite,
	CanRun,
	RunTimer,
	RunTimerActivated,
	Vomit,
	Float:Vomitx,
	Float:Vomity,
	Float:Vomitz,
	Allowedtovomit,
	Vomitmsg,
	Canscream,
	KillsRound,
	DeathsRound,
	InfectsRound,
	Lighton,
	NoPM,
	LastID,
	CanPop,
	LuckyCharm,
}

static Team[MAX_PLAYERS];
new PInfo[MAX_PLAYERS][PlayerInfo];
new Weather;
new CPValue;
new CPID;
new CPscleared;
new Fuel[MAX_VEHICLES];
new Oil[MAX_VEHICLES];
new VehicleStarted[MAX_VEHICLES];
new OldWeapon[MAX_PLAYERS];
new HoldingWeapon[MAX_PLAYERS];
new PlayersConnected;
new SnowObj[MAX_PLAYERS][2];
new SnowCreated[MAX_PLAYERS];
new Snow = 0;
new EndObjects[32];
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
public OnGameModeInit()
{
	SendRconCommand("hostname [iG] LS Zombie Apocalypse "Version"");
	SetGameModeText("LS Zombie Apocalypse");
	AddPlayerClass(122,0,0,0,0,0,0,0,0,0,0);
	AddPlayerClass(137,0,0,0,0,0,0,0,0,0,0);
	SetTimer("UpdateStats",2000,true);
	SetTimer("Marker",20000,true);
	SetTimer("Dizzy",60000,true);
	SetTimer("WeatherUpdate",180000,true);
	SetTimer("RandomCheckpoint",CPTIME,false);
	SetTimer("RandomSounds",120000,true);
	SetTimer("FiveSeconds",5000,true);
	WeatherUpdate();
	LoadStaticVehicles();
	LimitPlayerMarkerRadius(100.0);
	CPID = -1;
	CPscleared = 0;
	RoundEnded = 0;
	for(new i; i < MAX_PLAYERS;i++)
	{
		GainXPTD[i] = TextDrawCreate(286.000000, 148.000000, "+10 XP");
		TextDrawBackgroundColor(GainXPTD[i], 255);
		TextDrawFont(GainXPTD[i], 1);
		TextDrawLetterSize(GainXPTD[i], 0.610000, 2.600002);
		TextDrawColor(GainXPTD[i], -1);
		TextDrawSetOutline(GainXPTD[i], 1);
		TextDrawSetProportional(GainXPTD[i], 1);

        Stats[i] = TextDrawCreate(552.000000, 381.000000, " ");
		TextDrawBackgroundColor(Stats[i], 255);
		TextDrawFont(Stats[i], 1);
		TextDrawLetterSize(Stats[i], 0.260000, 1.200000);
		TextDrawColor(Stats[i], -1);
		TextDrawSetOutline(Stats[i], 0);
		TextDrawSetProportional(Stats[i], 1);
		TextDrawSetShadow(Stats[i], 1);
		TextDrawUseBox(Stats[i], 1);
		TextDrawBoxColor(Stats[i], 169);
		TextDrawTextSize(Stats[i], 650.000000, 0.000000);
		
		XPStats[i] = TextDrawCreate(277.000000, 437.000000, "XP: 500/600");
		TextDrawBackgroundColor(XPStats[i], 255);
		TextDrawFont(XPStats[i], 1);
		TextDrawLetterSize(XPStats[i], 0.450000, 1.200000);
		TextDrawColor(XPStats[i], -1);
		TextDrawSetOutline(XPStats[i], 1);
		TextDrawSetProportional(XPStats[i], 1);
		
		FuelTD[i] = TextDrawCreate(221.000000, 421.000000, "Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
		TextDrawBackgroundColor(FuelTD[i], -1499158273);
		TextDrawFont(FuelTD[i], 1);
		TextDrawLetterSize(FuelTD[i], 0.430000, 1.600000);
		TextDrawColor(FuelTD[i], 255);
		TextDrawSetOutline(FuelTD[i], 1);
		TextDrawSetProportional(FuelTD[i], 1);

		OilTD[i] = TextDrawCreate(327.000000, 421.000000, "Oil: ~r~ll~y~llllll~g~~h~ll");
		TextDrawBackgroundColor(OilTD[i], -1499158273);
		TextDrawFont(OilTD[i], 1);
		TextDrawLetterSize(OilTD[i], 0.430000, 1.600000);
		TextDrawColor(OilTD[i], 255);
		TextDrawSetOutline(OilTD[i], 1);
		TextDrawSetProportional(OilTD[i], 1);
	}
	for(new i; i < MAX_VEHICLES; i++)
	{
	    Fuel[i] = randomEx(10,90);
		Oil[i] = randomEx(10,90);
		StartVehicle(i,0);
		VehicleStarted[i] = 0;
	}
	
	CPSCleared = TextDrawCreate(498.000000, 97.000000, "CP's cleared: ~r~~h~0/8");
	TextDrawBackgroundColor(CPSCleared, 255);
	TextDrawFont(CPSCleared, 2);
	TextDrawLetterSize(CPSCleared, 0.290000, 1.700000);
	TextDrawColor(CPSCleared, -1);
	TextDrawSetOutline(CPSCleared, 0);
	TextDrawSetProportional(CPSCleared, 1);
	TextDrawSetShadow(CPSCleared, 1);

	Infection = TextDrawCreate(498.000000, 111.000000, "Infection: ~r~~h~0%");
	TextDrawBackgroundColor(Infection, 255);
	TextDrawFont(Infection, 2);
	TextDrawLetterSize(Infection, 0.290000, 1.700000);
	TextDrawColor(Infection, -1);
	TextDrawSetOutline(Infection, 0);
	TextDrawSetProportional(Infection, 1);
	TextDrawSetShadow(Infection, 1);
	
	XPBox = TextDrawCreate(193.000000, 437.000000, "_");
	TextDrawBackgroundColor(XPBox, 255);
	TextDrawFont(XPBox, 1);
	TextDrawLetterSize(XPBox, 0.500000, 1.000000);
	TextDrawColor(XPBox, -1);
	TextDrawSetOutline(XPBox, 0);
	TextDrawSetProportional(XPBox, 1);
	TextDrawSetShadow(XPBox, 1);
	TextDrawUseBox(XPBox, 1);
	TextDrawBoxColor(XPBox, 80);
	TextDrawTextSize(XPBox, 454.000000, 4.000000);
	
	RoundStats = TextDrawCreate(262.000000, 352.000000, "Most Kills: [Yak]Kyo_Masuyo ~n~Most Deaths: [Yak]Kyo_Masuyo ~n~Most Infects: [Yak]Kyo_Masuyo");
	TextDrawBackgroundColor(RoundStats, 255);
	TextDrawFont(RoundStats, 1);
	TextDrawLetterSize(RoundStats, 0.410000, 1.500000);
	TextDrawColor(RoundStats, -1);
	TextDrawSetOutline(RoundStats, 0);
	TextDrawSetProportional(RoundStats, 1);
	TextDrawSetShadow(RoundStats, 1);
	TextDrawUseBox(RoundStats, 1);
	TextDrawBoxColor(RoundStats, 80);
	TextDrawTextSize(RoundStats, 406.000000, 50.000000);

	Effect[0] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[0],1);
	TextDrawBoxColor(Effect[0],0xffffffff);
	TextDrawTextSize(Effect[0],950.000000,0.000000);
	TextDrawAlignment(Effect[0],0);
	TextDrawBackgroundColor(Effect[0],0x000000ff);
	TextDrawFont(Effect[0],3);
	TextDrawLetterSize(Effect[0],1.000000,70.000000);
	TextDrawColor(Effect[0],0xffffffff);
	TextDrawSetOutline(Effect[0],1);
	TextDrawSetProportional(Effect[0],1);
	TextDrawSetShadow(Effect[0],1);

	Effect[1] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[1],1);
	TextDrawBoxColor(Effect[1],0xffffffcc);
	TextDrawTextSize(Effect[1],950.000000,0.000000);
	TextDrawAlignment(Effect[1],0);
	TextDrawBackgroundColor(Effect[1],0x000000ff);
	TextDrawFont(Effect[1],3);
	TextDrawLetterSize(Effect[1],1.000000,70.000000);
	TextDrawColor(Effect[1],0xffffffff);
	TextDrawSetOutline(Effect[1],1);
	TextDrawSetProportional(Effect[1],1);
	TextDrawSetShadow(Effect[1],1);

	Effect[2] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[2],1);
	TextDrawBoxColor(Effect[2],0xffffff99);
	TextDrawTextSize(Effect[2],950.000000,0.000000);
	TextDrawAlignment(Effect[2],0);
	TextDrawBackgroundColor(Effect[2],0x000000ff);
	TextDrawFont(Effect[2],3);
	TextDrawLetterSize(Effect[2],1.000000,70.000000);
	TextDrawColor(Effect[2],0xffffffff);
	TextDrawSetOutline(Effect[2],1);
	TextDrawSetProportional(Effect[2],1);
	TextDrawSetShadow(Effect[2],1);

	Effect[3] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[3],1);
	TextDrawBoxColor(Effect[3],0xffffff66);
	TextDrawTextSize(Effect[3],950.000000,0.000000);
	TextDrawAlignment(Effect[3],0);
	TextDrawBackgroundColor(Effect[3],0x000000ff);
	TextDrawFont(Effect[3],3);
	TextDrawLetterSize(Effect[3],1.000000,70.000000);
	TextDrawColor(Effect[3],0xffffffff);
	TextDrawSetOutline(Effect[3],1);
	TextDrawSetProportional(Effect[3],1);
	TextDrawSetShadow(Effect[3],1);

	Effect[4] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[4],1);
	TextDrawBoxColor(Effect[4],0xffffff33);
	TextDrawTextSize(Effect[4],950.000000,0.000000);
	TextDrawAlignment(Effect[4],0);
	TextDrawBackgroundColor(Effect[4],0x000000ff);
	TextDrawFont(Effect[4],3);
	TextDrawLetterSize(Effect[4],1.000000,70.000000);
	TextDrawColor(Effect[4],0xffffffff);
	TextDrawSetOutline(Effect[4],1);
	TextDrawSetProportional(Effect[4],1);
	TextDrawSetShadow(Effect[4],1);

	Effect[5] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[5],1);
	TextDrawBoxColor(Effect[5],0xffffff22);
	TextDrawTextSize(Effect[5],950.000000,0.000000);
	TextDrawAlignment(Effect[5],0);
	TextDrawBackgroundColor(Effect[5],0x000000ff);
	TextDrawFont(Effect[5],3);
	TextDrawLetterSize(Effect[5],1.000000,70.000000);
	TextDrawColor(Effect[5],0xffffffff);
	TextDrawSetOutline(Effect[5],1);
	TextDrawSetProportional(Effect[5],1);
	TextDrawSetShadow(Effect[5],1);

	Effect[6] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[6],1);
	TextDrawBoxColor(Effect[6],0xffffff11);
	TextDrawTextSize(Effect[6],950.000000,0.000000);
	TextDrawAlignment(Effect[6],0);
	TextDrawBackgroundColor(Effect[6],0x000000ff);
	TextDrawFont(Effect[6],3);
	TextDrawLetterSize(Effect[6],1.000000,70.000000);
	TextDrawColor(Effect[6],0xffffffff);
	TextDrawSetOutline(Effect[6],1);
	TextDrawSetProportional(Effect[6],1);
	TextDrawSetShadow(Effect[6],1);

	Effect[7] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
	TextDrawUseBox(Effect[7],1);
	TextDrawBoxColor(Effect[7],0xffffff11);
	TextDrawTextSize(Effect[7],950.000000,0.000000);
	TextDrawAlignment(Effect[7],0);
	TextDrawBackgroundColor(Effect[7],0x000000ff);
	TextDrawFont(Effect[7],3);
	TextDrawLetterSize(Effect[7],1.000000,70.000000);
	TextDrawColor(Effect[7],0xffffffff);
	TextDrawSetOutline(Effect[7],1);
	TextDrawSetProportional(Effect[7],1);
	TextDrawSetShadow(Effect[7],1);
	return 1;
}

public OnGameModeExit()
{
    RoundEnded = 0;
    for(new i; i < MAX_PLAYERS;i++)
	{
	   	DestroyDynamicObject(SnowObj[i][0]);
	   	DestroyDynamicObject(SnowObj[i][1]);
	}
	for( new i = 0; i < 2048; i++ )
	{
	   if(i != INVALID_TEXT_DRAW) continue;
	   TextDrawHideForAll(Text: i);
	   TextDrawDestroy(Text: i);
	}
	for(new i; i < sizeof(EndPos);i++)
	{
	    DestroyObject(EndObjects[i]);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
 	SetPlayerPos(playerid,1102.8529,-833.1390,113.7624);
	SetPlayerFacingAngle(playerid,197.1240);
	SetPlayerCameraPos(playerid,1105.1990,-835.8810,114.0693);
	SetPlayerCameraLookAt(playerid,1102.8529,-833.1390,113.7624);
	switch(classid)
	{
	    case 0: Team[playerid] = HUMAN,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~Survivor",3000,3);
	    case 1: Team[playerid] = ZOMBIE,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~p~Zombie",3000,3);
	}
	if(PInfo[playerid][Firstspawn] == 0)
	{
	    SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerTime(playerid,0,0);
    SetPlayerHealthRank(playerid);
	if(PInfo[playerid][Firstspawn] == 1)
	{
	    PInfo[playerid][Firstspawn] = 0;
	}
	if(Team[playerid] == HUMAN)
	{
	    ResetPlayerInventory(playerid);
		new rand = random(sizeof Randomspawns);
		SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
		SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
		SetCameraBehindPlayer(playerid);
		CheckRankup(playerid,1);
		SetPlayerColor(playerid,green);
		if(PInfo[playerid][Premium] == 0)
  		{
			AddItem(playerid,"Small Medical Kits",5);
		    AddItem(playerid,"Medium Medical Kits",4);
	        AddItem(playerid,"Large Medical Kits",3);
	        AddItem(playerid,"Fuel",3);
	        AddItem(playerid,"Oil",3);
	        AddItem(playerid,"Flashlight",3);
	    }
	    if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
		    AddItem(playerid,"Small Medical Kits",17);
	     	AddItem(playerid,"Medium Medical Kits",17);
		    AddItem(playerid,"Large Medical Kits",17);
		    AddItem(playerid,"Fuel",17);
		    AddItem(playerid,"Oil",17);
		    AddItem(playerid,"Flashlight",17);
		    AddItem(playerid,"Dizzy Pills",17);
			static file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
	    }
	    if(PInfo[playerid][Premium] == 2)
	    {
	        SetPlayerArmour(playerid,150);
		    AddItem(playerid,"Small Medical Kits",21);
	     	AddItem(playerid,"Medium Medical Kits",21);
		    AddItem(playerid,"Large Medical Kits",21);
		    AddItem(playerid,"Fuel",21);
		    AddItem(playerid,"Oil",21);
		    AddItem(playerid,"Flashlight",21);
		    AddItem(playerid,"Dizzy Pills",21);
		    AddItem(playerid,"Molotovs Guide",1);
		    static file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
	    }
	}
    if(Team[playerid] == ZOMBIE)
    {
        SetPlayerPos(playerid,1171.6742,-1084.2343,26.4909);
        SetPlayerFacingAngle(playerid,86.4572);
        if(PInfo[playerid][JustInfected] == 1)
	    {
	        SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
	        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
	        Team[playerid] = ZOMBIE;
			SetPlayerColor(playerid,purple);
			GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
	        PInfo[playerid][JustInfected] = 0;
	        SetPlayerHealth(playerid,100.0);
	        SpawnPlayer(playerid);
	    }
	    static file[80];
		format(file,sizeof file,Userfile,GetPName(playerid));
		INI_Open(file);
		if(INI_ReadInt("ZSkin") != 0) SetPlayerSkin(playerid,INI_ReadInt("ZSkin"));
		INI_Close();
	    SetPlayerColor(playerid,purple);
	    SetPlayerArmour(playerid,0);
	    SetPlayerHealth(playerid,200.0);
    }
	StopAudioStreamForPlayer(playerid);
	PInfo[playerid][Dead] = 0;
	SetPlayerCP(playerid);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
 	if(PInfo[playerid][Logged] == 0) return 0;
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
    PInfo[playerid][Dead] = 1;
    PInfo[playerid][DeathsRound]++;
	if(Mission[playerid] != 0)
	{
    	RemovePlayerMapIcon(playerid,1);
    	Mission[playerid] = 0;
    	SendClientMessage(playerid,red,"You have failed to make your molotov/betty's mission.");
 	}
    if(PInfo[playerid][Lighton] == 1)
	{
		RemovePlayerAttachedObject(playerid,3);
		RemovePlayerAttachedObject(playerid,4);
        PInfo[playerid][Lighton] = 0;
        RemoveItem(playerid,"Flashlight",1);
        static string[90];
 		format(string,sizeof string,""cjam"%s has dropped his flashlight.",GetPName(playerid));
		SendNearMessage(playerid,white,string,30);
	}
	if(Team[killerid] == HUMAN && Team[playerid] == HUMAN)
	{
	    if(PInfo[playerid][Infected] == 1)
	    {
	        PInfo[killerid][Kills]++;
	        GivePlayerXP(killerid);
			PInfo[playerid][JustInfected] = 1;
			PInfo[playerid][Deaths]++;
			Team[playerid] = ZOMBIE;
        	GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
        	SetPlayerColor(playerid,purple);
        	CheckRankup(killerid);
		}
	    else
	    {
        	PInfo[killerid][Teamkills]++;
        	SendClientMessage(killerid,white,"» "cred"Team killing is not allowed! "cwhite"«");
        	PInfo[playerid][Deaths]++;
        	CheckRankup(playerid);
    	}
	}
	if(Team[killerid] == HUMAN && Team[playerid] == ZOMBIE)
	{
	    PInfo[killerid][Kills]++;
	    PInfo[playerid][Deaths]++;
	    PInfo[killerid][KillsRound]++;
	    GivePlayerXP(killerid);
	    CheckRankup(killerid);
	}
	if(Team[killerid] == ZOMBIE && Team[playerid] == HUMAN)
	{
	    PInfo[killerid][Infects]++;
	    SetPlayerHealth(playerid,100);
	    static Float:x,Float:y,Float:z;
 		GetPlayerPos(playerid,x,y,z);
		SetPlayerPos(playerid,x,y,z+4);
		SpawnPlayer(playerid);
		PInfo[playerid][Deaths]++;
		PInfo[playerid][Dead] = 1;
        PInfo[playerid][JustInfected] = 1;
        Team[playerid] = ZOMBIE;
        GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
        SetPlayerColor(playerid,purple);
	    GivePlayerXP(killerid);
	    CheckRankup(killerid);
	}
	TextDrawHideForPlayer(playerid,FuelTD[playerid]);
	TextDrawHideForPlayer(playerid,OilTD[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	if(PInfo[playerid][Logged] == 1) SaveStats(playerid);
	static string[64];
	switch(reason)
    {
        case 0: format(string,sizeof string,"» "cred"%s has left the server. (Timed out)",GetPName(playerid));
        case 1: format(string,sizeof string,"» "cred"%s has left the server. (Leaving)",GetPName(playerid));
        case 2: format(string,sizeof string,"» "cred"%s has left the server. (Kicked/Banned)",GetPName(playerid));
    }
    PInfo[playerid][KillsRound] = 0;
    PInfo[playerid][InfectsRound] = 0;
    PInfo[playerid][DeathsRound] = 0;
    PInfo[playerid][RunTimerActivated] = 0;
    PlayersConnected--;
    SendAdminMessage(white,string);
    DestroyObject(PInfo[playerid][FireObject]);
    Delete3DTextLabel(PInfo[playerid][Ranklabel]);
    RemovePlayerMapIcon(playerid,0);
	DestroyObject(PInfo[playerid][Flare]);
	DestroyObject(PInfo[playerid][Vomit]);
	RemovePlayerAttachedObject(playerid,3);
	RemovePlayerAttachedObject(playerid,4);
	KillTimer(PInfo[playerid][StompTimer]);
	KillTimer(PInfo[playerid][RunTimer]);
	KillTimer(PInfo[playerid][DigTimer]);
    if(CPID != -1) DisablePlayerCheckpoint(playerid);
    if(PInfo[playerid][CanBurst] == 0) PInfo[playerid][CanBurst] = 1, KillTimer(PInfo[playerid][ClearBurst]);
    SnowCreated[playerid] = 0;
	for(new g = 0; g < 2; g++)
	{
       	DestroyDynamicObject(SnowObj[playerid][g]);
 	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	PlaySound(playerid,1077);
    PlayersConnected++;
    static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	if(INI_Exist(file))
	{
	    INI_Open(file);
	    if(INI_ReadInt("Banned") == 1)
	    {
	        SendFMessageToAll(red,"The noob player %s has tried to ban evade, therefor he has been re-banned.",GetPName(playerid));
			format(file,sizeof file,"%s has tried to ban evade.",GetPName(playerid));
			SaveIn("Banevadelog",file,1);
			SetTimerEx("BanPlayer",10,false,"i",playerid);
		}
		else
		{
     		ShowPlayerDialog(playerid,Logindialog,3,"Login",""cwhite"Welcome back! \nPlease type in your password to "cligreen"load "cwhite"your status \n","Login","Cancel");
		}
		INI_Close();
	}
	else
	{
		ShowPlayerDialog(playerid,Registerdialog,3,"Register",""cwhite"Welcome! \nIn order to play in our server, you must register! \nPlease type in the desired password to register this account \n","Register","Cancel");
	}
	PInfo[playerid][Logged] = 0;
	PInfo[playerid][Failedlogins] = 0;
	PInfo[playerid][CanBite] = 1;
	PInfo[playerid][JustInfected] = 0;
	PInfo[playerid][Infected] = 0;
	PInfo[playerid][Dead] = 1;
	PInfo[playerid][Firsttimeincp] = 1;
	PInfo[playerid][CanBurst] = 1;
	PInfo[playerid][Firstspawn] = 1;
 	PInfo[playerid][ZombieBait] = 0;
	PInfo[playerid][FireMode] = 0;
	PInfo[playerid][OnFire] = 0;
	PInfo[playerid][TokeDizzy] = 0;
	PInfo[playerid][CanJump] = 8000;
	PInfo[playerid][LuckyCharm] = 60000;
	PInfo[playerid][CanPop] = 1;
	PInfo[playerid][CanStomp] = 1;
	PInfo[playerid][CanRun] = 1;
    PInfo[playerid][Flamerounds] = 0;
    PInfo[playerid][MolotovMission] = 0;
    PInfo[playerid][CanDig] = 1;
    PInfo[playerid][GodDig] = 0;
    PInfo[playerid][Vomitmsg] = 1;
    PInfo[playerid][Lighton] = 0;
    PInfo[playerid][NoPM] = 0;
    PInfo[playerid][LastID] = -1;
    PInfo[playerid][Allowedtovomit] = VOMITTIME;
    Mission[playerid] = 0;
    MissionPlace[playerid][0] = 0;
    MissionPlace[playerid][1] = 0;
    RemovePlayerMapIcon(playerid,1);
	format(file,sizeof file,""cgreen"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
 	PInfo[playerid][Ranklabel] = Create3DTextLabel(file,0x008080AA,0,0,0,40.0,0);
	Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
	TextDrawShowForPlayer(playerid,CPSCleared);
	TextDrawShowForPlayer(playerid,Infection);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    SetPlayerMarkerForPlayer(i,playerid,0x969696FF);
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(PInfo[playerid][Firsttimeincp] == 1)
    {
        if(Team[playerid] == ZOMBIE) return 0;
		static Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
        for(new i; i < MAX_PLAYERS;i++)
        {
            if(!IsPlayerConnected(i)) continue;
            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
            SendFMessage(i,white,"*"cjam"%s has been assisted with military help.",GetPName(playerid));
        }
    	PInfo[playerid][Firsttimeincp] = 0;
        new weapons[13][2];
		for(new f = 0; f < 13; f++)
		{
		    GetPlayerWeaponData(playerid, f, weapons[f][0], weapons[f][1]);
		}
		if(PInfo[playerid][SPerk] == 17)
		{
			PInfo[playerid][Flamerounds] += 3;
			SendFMessage(playerid,white,"» "cblue"You have been given 3 flame bullets. "cgrey"(%i flame bullets)",PInfo[playerid][Flamerounds]);
		}
		if(PInfo[playerid][SPerk] == 4)
		{
		    GivePlayerWeapon(playerid,17,1);
		    if(PInfo[playerid][Premium] == 1)
		        GivePlayerWeapon(playerid,17,2);
            if(PInfo[playerid][Premium] == 2)
		        GivePlayerWeapon(playerid,17,4);
		}
		if(PInfo[playerid][SPerk] == 19) GivePlayerWeapon(playerid,16,3);
		if(weapons[2][0] == 22) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,22,20);}else{GivePlayerWeapon(playerid,22,50);}
		if(weapons[2][0] == 23) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,23,20);}else{GivePlayerWeapon(playerid,23,50);}
		if(weapons[2][0] == 24) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,24,20);}else{GivePlayerWeapon(playerid,24,50);}
		if(weapons[3][0] == 25) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,25,30);}else{GivePlayerWeapon(playerid,25,30);}
		if(weapons[3][0] == 26) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,26,30);}else{GivePlayerWeapon(playerid,26,30);}
		if(weapons[3][0] == 27) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,27,30);}else{GivePlayerWeapon(playerid,27,30);}
		if(weapons[4][0] == 28) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,28,120);}else{GivePlayerWeapon(playerid,28,120);}
		if(weapons[4][0] == 32) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,32,120);}else{GivePlayerWeapon(playerid,32,120);}
		if(weapons[6][0] == 33) if(PInfo[playerid][SPerk] == 12) {GivePlayerWeapon(playerid,33,30);}else{GivePlayerWeapon(playerid,33,30);}
        if(PInfo[playerid][Premium] == 2)
	    {
	        SetPlayerArmour(playerid,150);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s has been given a fresh new kevlar vest.",GetPName(playerid));
	        }
     	}
     	if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s has been given a fresh new kevlar vest.",GetPName(playerid));
	        }
     	}
  	}
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

CMD:me(playerid,params[])
{
	static msg[128],string[128];
	if(sscanf(params,"s[128]",msg)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/me <message>");
	format(string,sizeof(string),"» %s(ID:%d) %s",GetPName(playerid),playerid,msg);
	SendClientMessageToAll(0x9BFF00FF,string);
	return 1;
}

CMD:tpm(playerid,params[])
{
	new text[80],string[128];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/tpm <text>");
	format(string,sizeof string,"TPM from %s(%i): %s",GetPName(playerid),playerid,text);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(Team[i] == Team[playerid])
		{
		    SendClientMessage(i,0x00E1FFFF,string);
		}
	}
	return 1;
}

CMD:nopm(playerid,params[])
{
	#pragma unused params
	if(PInfo[playerid][NoPM] == 1)
	{
	    PInfo[playerid][NoPM] = 0;
	    SendClientMessage(playerid,white,"» "corange"You are now receiving all incoming PM's!");
 	}
 	else
 	{
 	    PInfo[playerid][NoPM] = 1;
	    SendClientMessage(playerid,white,"» "corange"You have blocked all incoming PM's!");
  	}
	return 1;
}

CMD:r(playerid,params[])
{
	new string[256],text[80];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/r <text>");
	if(PInfo[playerid][LastID] == -1) return SendClientMessage(playerid,white,"» "cred"No recent messages!");
	if(PInfo[PInfo[playerid][LastID]][NoPM] == 1) return SendClientMessage(playerid,white,"» "cred"That player does not want to be bother'd with PM's.");
	format(string,sizeof(string),"PM from %s(%i): %s",GetPName(playerid),playerid,text);
	SendClientMessage(PInfo[playerid][LastID],0xFFFF22AA,string);
	format(string,sizeof(string),"PM sent to %s(%i): %s",GetPName(PInfo[playerid][LastID]),PInfo[playerid][LastID],text);
	SendClientMessage(playerid,0xFFCC2299,string);
	return 1;
}

CMD:pm(playerid,params[])
{
	new id,text[80],string[256];
	if(sscanf(params,"us[80]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/pm <id> <text>");
	if(PInfo[id][NoPM] == 1) return SendClientMessage(playerid,white,"» "cred"That player does not want to be bother'd with PM's.");
	format(string,sizeof(string),"PM from %s(%i): %s",GetPName(playerid),playerid,text);
	SendClientMessage(id,0xFFFF22AA,string);
	format(string,sizeof(string),"PM sent to %s(%i): %s",GetPName(id),id,text);
	SendClientMessage(playerid,0xFFCC2299,string);
	PInfo[id][LastID] = playerid;
	return 1;
}

CMD:admins(playerid,params[])
{
	new lvl[10],on;
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] > 0) on++;
 	}
	SendFMessage(playerid,green,"____ Admins Online: %i ____",on);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] == 0) continue;
	    if(PInfo[i][Level] == 1) lvl = "Trial";
	    else if(PInfo[i][Level] == 2) lvl = "General";
	    else if(PInfo[i][Level] == 3) lvl = "Senior";
	    else if(PInfo[i][Level] == 4) lvl = "Lead";
	    else if(PInfo[i][Level] == 5) lvl = "Head";
		if(IsPlayerAdmin(i)) lvl = "Owner";
		SendFMessage(playerid,green,"- %s(%i) %s administator.",GetPName(i),i,lvl);
	}
	SendFMessage(playerid,green,"___________________________",on);
	return 1;
}

CMD:setav(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	new Float:x,Float:y,Float:z;
	if(sscanf(params,"fff",x,y,z)) return SendClientMessage(playerid,orange,"USAGE: /setav <x> <y> <z>");
	SetVehicleAngularVelocity(GetPlayerVehicleID(playerid), x, y, z);
	return 1;
}

CMD:setzskin(playerid,params[])
{
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"You are not allowed to use this command!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setzskin <skinid>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"The skin id must be between 1 and 299");
	new valid = 0;
	for(new i = 0; i < sizeof(ZombieSkins); i++)
			if(skin == ZombieSkins[i]) valid = 1;
	if(valid == 0) return SendClientMessage(playerid,red,"That skin can't be used for zombies!");
	if(Team[playerid] == ZOMBIE) SetPlayerSkin(playerid,skin);
	SendClientMessage(playerid,orange,"You have successfully changed your zombie skin.");
	static file[80];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
	INI_WriteInt("ZSkin",skin);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:setsskin(playerid,params[])
{
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"You are not allowed to use this command!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsskin <skinid>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"The skin id must be between 1 and 299");
	SendClientMessage(playerid,orange,"You have successfully changed your survivor skin.");
	if(Team[playerid] == HUMAN) SetPlayerSkin(playerid,skin);
	static file[80];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
	INI_WriteInt("SSkin",skin);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:setperk(playerid,params[])
{
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"You are not allowed to use this command!");
	new perk,id;
	if(sscanf(params,"ii",id,perk)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsperk <team> <perkid> "cgrey"1 = Survivor | 2 = Zombie");
	if(id == 1) PInfo[playerid][SPerk] = perk-1;
	else if(id == 2) PInfo[playerid][ZPerk] = perk-1;
	SendClientMessage(playerid,orange,"You have successfully changed your perk.");
	return 1;
}


CMD:l(playerid,params[])
{
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/l <text>");
	static string[134];
 	format(string,sizeof string,"%s: %s",GetPName(playerid),text);
	SendNearMessage(playerid,white,string,30);
	return 1;
}

CMD:heal(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/heal <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
    static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has healed %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,100);
	return 1;
}

CMD:sethealth(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,health;
	if(sscanf(params,"ui",id,health)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/sethealth <id> <health>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
    static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has setted %s(%i) health to %i ||",GetPName(playerid),playerid,GetPName(id),id,health);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,health);
	return 1;
}

CMD:rape(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/rape <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	SetPlayerHealth(id,1);
	SetPlayerArmour(id,0);
    SetPlayerSkin(id,137);
    SetPlayerWeather(id,16);
    SetPlayerDrunkLevel(id,5000);
	ResetPlayerWeapons(id);
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has raped %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:bslap(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/bslap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+9);
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has bitched slapped %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:slap(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/slap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+6);
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has slapped %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:saveuser(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
    static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/saveuser <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static string[90];
	format(string,sizeof string,"|| Administrator %s(%i) has saved %s(%i) stats ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SaveStats(id);
	return 1;
}

CMD:goto(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/goto <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	if(IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid),x,y+3,z);
	}
	else SetPlayerPos(playerid,x,y+3,z);
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has teleported to %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	return 1;
}

CMD:kick(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/kick <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has kicked to %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	Kick(id);
	SendAdminMessage(red,string);
	SaveIn("Kicklog",string,1);
	return 1;
}

CMD:ban(playerid,params[])
{
    if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ban <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
    SendFMessageToAll(red,"|| Administrator %s(%i) has banned %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	static string[500],y,mm,d;
	getdate(y,mm,d);
	
	format(string,sizeof string,"Administrator %s has banned %s. Reason: %s",GetPName(playerid),GetPName(id),reason);
	SaveIn("Banlog",string,1);
	
	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: %s. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.infinite-network.net if you wish.",GetPName(playerid),GetPName(id),GetIP(id),reason,d,mm,y);
	ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");
	
	format(string,sizeof string, Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Banned",1);
	INI_Save();
	INI_Close();
	
	format(string,sizeof string,"%s has banned %s.",GetPName(playerid),GetPName(id));
	BanEx(id,string);
	return 1;
}

CMD:get(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/get <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"That player is not connected!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(IsPlayerInAnyVehicle(id))
	{
	    SetVehiclePos(GetPlayerVehicleID(id),x,y+3,z);
	}
	else SetPlayerPos(id,x,y+3,z);
	SetPlayerInterior(id,GetPlayerInterior(playerid));
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has teleported %s(%i) to his location ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	return 1;
}

CMD:savecar(playerid,params[])
{
    #pragma unused params
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"You must be in a vehicle!");
	new Float:x,Float:y,Float:z,Float:angle,vehicleid,string[164],c1,c2;
	vehicleid = GetPlayerVehicleID(playerid);
	GetVehicleZAngle(vehicleid,angle);
	GetVehicleColor(vehicleid,c1,c2);
	GetVehiclePos(vehicleid,x,y,z);
	new File:example = fopen("Admin/Allcars.txt", io_append);
	format(string,sizeof(string),"%i,%f,%f,%f,%f,%i,%i;\r\n",GetVehicleModel(vehicleid),x,y,z,angle,c1,c2);
	fwrite(example,string);
	fclose(example);
	format(string,sizeof(string),"» Vehicle: %i has been saved.",GetVehicleModel(vehicleid));
	SendClientMessage(playerid,green,string);
	return 1;
}

CMD:perks(playerid,params[])
{
	if(Team[playerid] == HUMAN)
	{
	    ShowPlayerHumanPerks(playerid);
	}
	if(Team[playerid] == ZOMBIE)
	{
	    ShowPlayerZombiePerks(playerid);
	}
	return 1;
}

CMD:setteam(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,team;
	if(sscanf(params,"ui",id,team)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setteam <id> <1 = Human | 2 = Zombie>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	if(team == ZOMBIE)
	{
	    SetSpawnInfo(id,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
	    SetPlayerSkin(id,ZombieSkins[random(sizeof(ZombieSkins))]);
	    SpawnPlayer(id);
	    Team[id] = ZOMBIE;
	    SpawnPlayer(id);
	    SetPlayerColor(id,purple);
	    SetPlayerHealth(id,100);
  	}
  	else if(team == HUMAN)
	{
	    Team[id] = HUMAN;
	    static sid;
		ChooseSkin: sid = random(299);
		sid = random(299);
		for(new i = 0; i < sizeof(ZombieSkins); i++)
			if(sid == ZombieSkins[i]) goto ChooseSkin;
    	SetSpawnInfo(id,0,sid,0,0,0,0,0,0,0,0,0,0);
	    SetPlayerSkin(id,sid);
	    PInfo[id][JustInfected] = 0;
	    PInfo[id][Infected] = 0;
		PInfo[id][Dead] = 0;
		PInfo[id][CanBite] = 1;
		SpawnPlayer(id);
		SetPlayerColor(id,green);
		SetPlayerHealth(id,100);
	}
	else return SendClientMessage(playerid,red,"Team not found!");
	return 1;
}

CMD:setlevel(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setlevel <id> <level>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	if(level > 5) return SendClientMessage(playerid,red,"Maximum admin level is 5!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) admin level to %i",GetPName(playerid),playerid,GetPName(id),id,level);
	if(level > PInfo[id][Level])
	    GameTextForPlayer(id,"~g~~h~Promoted!",4000,3);
	else
	    GameTextForPlayer(id,"~r~~h~Demoted!",4000,3);
	PInfo[id][Level] = level;
	SaveStats(id);
	return 1;
}

CMD:warn(playerid,params[])
{
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,warn[64],string[400],string2[128];
	if(sscanf(params,"us[64]",id,warn)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/warn <id> <warn>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	format(string,sizeof string,"» Administrator %s(%i) has warned %s(%i) [Reason: %s]",GetPName(playerid),playerid,GetPName(id),id,warn);
	SendAdminMessage(red,string);
	format(string,sizeof string,Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Warns",INI_ReadInt("Warns")+1);
	format(string,sizeof string,"Warn%i",INI_ReadInt("Warns"));
	SendFMessage(playerid,red,"» You have %i warnings.",INI_ReadInt("Warns"));
	INI_WriteString(string,warn);
	INI_Save();
	if(INI_ReadInt("Warns") >= 3)
	{
	    new warn1[64],warn2[64],warn3[64],d,mm,y;
	    getdate(y,mm,d);
	    INI_ReadString(warn1,"Warn1");
	    INI_ReadString(warn2,"Warn2");
	    INI_ReadString(warn3,"Warn3");
	    INI_WriteInt("Banned",1);
	    SendFMessageToAll(red,"|| Administrator %s(%i) has banned %s(%i) [Reason: 3 Warnings]",GetPName(playerid),playerid,GetPName(id),id);
		SendFMessageToAll(red,"||Warning 1: %s||",warn1);
		SendFMessageToAll(red,"||Warning 2: %s||",warn2);
		SendFMessageToAll(red,"||Warning 3: %s||",warn3);
		format(string2,sizeof string2,"%s has banned %s",GetPName(playerid),GetPName(id));
		format(string,sizeof(string),""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: 3 Warnings. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.infinite-network.net if you wish.",GetPName(playerid),GetPName(id),GetIP(id),d,mm,y);
		ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");
		BanEx(id,string);
		INI_Save();
	}
	INI_Close();
	return 1;
}

CMD:setprem(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,prem;
	if(sscanf(params,"ui",id,prem)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setprem <id> <premium> "cgrey"1 = Gold | 2 = Platinium");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	if(prem > 2 && prem < 0) return SendClientMessage(playerid,red,"Maximum admin level is 5!");
	ResetPlayerInventory(playerid);
	if(prem == 1)
	{
	    SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) premium to "cgold"Gold",GetPName(playerid),playerid,GetPName(id),id);
		if(Team[id] == HUMAN)
			SetPlayerArmour(id,100);
        AddItem(id,"Small Medical Kits",17);
     	AddItem(id,"Medium Medical Kits",17);
	    AddItem(id,"Large Medical Kits",17);
	    AddItem(id,"Fuel",17);
	    AddItem(id,"Oil",17);
	    AddItem(id,"Flashlight",17);
	    AddItem(id,"Dizzy Pills",17);
	}
	else if(prem == 2)
	{
	    SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) premium to "cplat"Platinium",GetPName(playerid),playerid,GetPName(id),id);
		if(Team[id] == HUMAN)
			SetPlayerArmour(id,150);
        AddItem(id,"Small Medical Kits",21);
     	AddItem(id,"Medium Medical Kits",21);
	    AddItem(id,"Large Medical Kits",21);
	    AddItem(id,"Fuel",21);
	    AddItem(id,"Oil",21);
	    AddItem(id,"Flashlight",21);
	    AddItem(id,"Dizzy Pills",21);
	}
	else
	{
	    SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) premium to None.",GetPName(playerid),playerid,GetPName(id),id);
		SetPlayerArmour(id,0);
		AddItem(id,"Small Medical Kits",5);
	    AddItem(id,"Medium Medical Kits",4);
        AddItem(id,"Large Medical Kits",3);
        AddItem(id,"Fuel",3);
        AddItem(id,"Oil",3);
        AddItem(id,"Flashlight",3);
	}
	PInfo[id][Premium] = prem;
	SaveStats(id);
	return 1;
}

CMD:setrank(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setrank <id> <rank>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) rank to %i",GetPName(playerid),playerid,GetPName(id),id,level);
	PInfo[id][Rank] = level;
	ResetPlayerWeapons(id);
	CheckRankup(id,1);
	return 1;
}

CMD:setxp(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setxp <id> <xp>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) XP to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][XP] = xp;
	CheckRankup(playerid);
	return 1;
}

CMD:setkills(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setkills <id> <kills>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) kills to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][Kills] = xp;
	return 1;
}

CMD:setdeaths(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setdeaths <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) deaths to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][Deaths] = xp;
	return 1;
}

CMD:setinfects(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You must be an administrator to use this command");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setinfects <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: That player isn't connected!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) infects to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][Infects] = xp;
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    PlaySound(issuerid,6401);
    if(Team[issuerid] == HUMAN)
    {
	    if(PInfo[issuerid][SPerk] == 10 && GetPlayerWeapon(issuerid) == 0)
	    {
	        if(PInfo[issuerid][FireMode] == 1) return 0;
	        if(Team[playerid] == HUMAN) return 0;
	        if(Team[issuerid] == ZOMBIE) return 0;
	        if(PInfo[playerid][OnFire] != 0) return 0;
			PInfo[playerid][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
			PInfo[playerid][OnFire] = 1;
			PInfo[issuerid][FireMode] = 1;
			AttachObjectToPlayer(PInfo[playerid][FireObject],playerid,0,0,-0.2,0,0,0);
			SetTimerEx("CanUseFiremode",20000,false,"i",issuerid);
			SetTimerEx("AffectFire",500,false,"ii",playerid,issuerid);
	    }
	    if(PInfo[issuerid][Flamerounds] != 0 && GetPlayerWeapon(issuerid) != 0)
	    {
	        if(Team[issuerid] == ZOMBIE) return 0;
	        if(Team[playerid] == HUMAN) return 0;
	        DestroyObject(PInfo[playerid][FireObject]);
	        PInfo[issuerid][Flamerounds]--;
	        PInfo[playerid][OnFire] = 1;
	        PInfo[playerid][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
	        AttachObjectToPlayer(PInfo[playerid][FireObject],playerid,0,0,-0.2,0,0,0);
	        SetTimerEx("AffectFire",500,false,"ii",playerid,issuerid);
		}
	}
	else if(Team[issuerid] == ZOMBIE)
	{
	    if(PInfo[issuerid][ZPerk] == 6 && GetPlayerWeapon(issuerid) == 0)
	    {
	        new Float:x,Float:y,Float:z,Float:a,Float:health;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(issuerid,a);
			GetPlayerHealth(playerid,health);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.2);
			if(health <= 10)
			    MakeProperDamage(playerid);
			else
   				SetPlayerHealth(playerid,health-5);
			GetPlayerHealth(playerid,health);
			MakeHealthEven(playerid,health);
			if(health <= 5)
			{
			    SetPlayerHealth(playerid,100);
		 		GetPlayerPos(playerid,x,y,z);
				SetPlayerPos(playerid,x,y,z+4);
				SpawnPlayer(playerid);
				PInfo[playerid][Deaths]++;
				PInfo[playerid][Dead] = 1;
		        PInfo[playerid][JustInfected] = 1;
		        Team[playerid] = ZOMBIE;
		        GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
		        SetPlayerColor(playerid,purple);
			    GivePlayerXP(issuerid);
			    CheckRankup(issuerid);
			}
	    }
	}
    return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER && Team[playerid] == ZOMBIE)
	{
	    RemovePlayerFromVehicle(playerid);
	    SendClientMessage(playerid,white,"* "cred"Zombies can't drive.");
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    TextDrawHideForPlayer(playerid,FuelTD[playerid]);
		TextDrawHideForPlayer(playerid,OilTD[playerid]);
	}
	else if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
	    TextDrawShowForPlayer(playerid,FuelTD[playerid]);
		TextDrawShowForPlayer(playerid,OilTD[playerid]);
		UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
		if(!IsVehicleStarted(GetPlayerVehicleID(playerid))) SendFMessage(playerid,white,"* "corange"This %s isn't started yet. You can press "cwhite"~k~~VEHICLE_FIREWEAPON~"corange" to start it "cwhite"*",GetVehicleName(GetPlayerVehicleID(playerid)));
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(oldkeys & KEY_FIRE)
    {
        if(Team[playerid] == HUMAN)
        {
            if(GetPlayerWeapon(playerid) == 17)
            {
	            new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
			 	for(new i=0; i < MAX_PLAYERS; i++)
	        	{
	        		if(IsPlayerInRangeOfPoint(i,30.0,x,y,z))
					{
	        			SetTimerEx("Flashbang",3000,0,"i",i);
					}
				}
			}
        }
    }
    if(PRESSED(KEY_JUMP))
    {
        if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][SPerk] != 14) return 0;
            if(GetTickCount() - PInfo[playerid][CanJump] < 8000) return 0;
            PInfo[playerid][CanJump] = GetTickCount();
            static Float:x,Float:y,Float:z;
            GetPlayerVelocity(playerid,x,y,z);
            SetPlayerVelocity(playerid,x,y,z+5);
            PInfo[playerid][CanJump] = GetTickCount();
			SetPlayerAttachedObject(playerid,1,18702,9,0.00,0.00,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Left foot
			SetPlayerAttachedObject(playerid,2,18702,10,0.00,-0.09,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Right foot
        }
        if(Team[playerid] == ZOMBIE)
        {
            if(PInfo[playerid][ZPerk] == 4)
            {
	            if(GetTickCount() - PInfo[playerid][CanJump] < 3500) return 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            PInfo[playerid][CanJump] = GetTickCount();
            }
            else if(PInfo[playerid][ZPerk] == 11)
            {
                if(GetTickCount() - PInfo[playerid][CanJump] < 3500 && PInfo[playerid][Jumps] >= 2) return 0;
                if(GetTickCount() - PInfo[playerid][CanJump] > 3500 && PInfo[playerid][Jumps] >= 2) PInfo[playerid][Jumps] = 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            PInfo[playerid][Jumps]++;
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            PInfo[playerid][CanJump] = GetTickCount();
            }
            else if(PInfo[playerid][ZPerk] == 16)
            {
                if(GetTickCount() - PInfo[playerid][CanJump] < 4300 && PInfo[playerid][Jumps] >= 4) return 0;
                if(GetTickCount() - PInfo[playerid][CanJump] > 4300 && PInfo[playerid][Jumps] >= 4) PInfo[playerid][Jumps] = 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            PInfo[playerid][Jumps]++;
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            PInfo[playerid][CanJump] = GetTickCount();
            }
        }
    }
	if(PRESSED(KEY_CROUCH))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return 0;
	    if(PInfo[playerid][SPerk] == 11)
	    {
	        if(Team[playerid] == ZOMBIE) return 0;
			new Float:x,Float:y,Float:z,id;
			id = -1;
   			for(new i; i < MAX_VEHICLES;i++)
			{
				GetVehiclePos(i,x,y,z);
				if(IsPlayerInRangeOfPoint(playerid,3.0,x,y,z))
				{
					id = i;
					break;
				}
				else continue;
			}
			if(id == -1) return 0;
			static Float:health;
			GetVehicleHealth(id,health);
			if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't need repairing!");
			TurnPlayerFaceToPos(playerid, x-270, y-270);
			ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 5000 , 1);
			static string[100];
		    format(string,sizeof string,""cjam"%s(%i) has tweaked his vehicle.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			SetVehicleHealth(id,health+250.0);
			SetTimerEx("ClearAnim",1500,false,"i",playerid);
		}
		if(PInfo[playerid][SPerk] == 16)
		{
		    if(Team[playerid] == ZOMBIE) return 0;
		    new Float:x,Float:y,Float:z,id;
			id = -1;
			for(new i; i < MAX_VEHICLES;i++)
			{
				GetVehiclePos(i,x,y,z);
				if(IsPlayerInRangeOfPoint(playerid,3.0,x,y,z))
				{
					id = i;
					break;
				}
				else continue;
			}
			if(id == -1) return 0;
			static Float:health;
			GetVehicleHealth(id,health);
			if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't need repairing!");
			TurnPlayerFaceToPos(playerid, x-270, y-270);
			ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 5000 , 1);
			static string[100];
		    format(string,sizeof string,""cjam"%s(%i) has fixed his vehicle.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			RepairVehicle(id);
			SetVehicleHealth(id,1000.0);
			SetTimerEx("ClearAnim",2000,false,"i",playerid);
  		}
		if(Team[playerid] == HUMAN)
  		{
  		    if(Mission[playerid] == 1)
			{
				if(MissionPlace[playerid][1] == 1) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 1)
				    {
				        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some cloth for your molotovs."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some cloth for your molotovs."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],62,0,MAPICON_GLOBAL);
							}
							ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				        }
				    }
				    else if(MissionPlace[playerid][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
				            	case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some cloth for your molotovs."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some cloth for your molotovs."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],62,0,MAPICON_GLOBAL);
				        	}
				        	ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
       					}
				    }
				}
				if(MissionPlace[playerid][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[2][0],Locations[2][1],Locations[2][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some inflamable liquid."), MissionPlace[playerid][0] = 5, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get some inflamable liquid."), MissionPlace[playerid][0] = 6, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],62,0,MAPICON_GLOBAL);
							}
							ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				        }
					}
					else if(MissionPlace[playerid][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some inflamable liquid."), MissionPlace[playerid][0] = 5, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get some inflamable liquid."), MissionPlace[playerid][0] = 6, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],62,0,MAPICON_GLOBAL);
							}
							ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				        }
					}
				}
				if(MissionPlace[playerid][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 molotovs. Use them wisely!");
				            GivePlayerWeapon(playerid,18,3);
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
				        }
					}
					else if(MissionPlace[playerid][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 molotovs. Use them wisely!");
				            GivePlayerWeapon(playerid,18,3);
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
				        }
					}
				}
			}
	  		new id;
	  		id = -1;
	  		for(new j; j < sizeof(Searchplaces);j++)
			{
			    if(GetTickCount() - PInfo[playerid][Searching] < 5000) return 0;
			    if(IsPlayerInRangeOfPoint(playerid,1.0,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2]))
				{
				    id = j;
				    break;
				}
			}
			if(id == -1) return 0;
			else
			{
				PInfo[playerid][Searching] = GetTickCount();
				ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,1,0,0,0,0);
				SetTimerEx("ClearAnim",1500,false,"i",playerid);
				static rand;
				rand = random(15);
				goto Random;
				Random:
				{
					switch(rand)
					{
					    case 0:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 1:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a large medical kit.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Large Medical Kits",1);
					    }
					    case 2:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 3:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a medium medical kit.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Medium Medical Kits",1);
					    }
					    case 4:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 5:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a medium medical kit.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Small Medical Kits",1);
					    }
					    case 6:
					    {
							if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 7:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a dizzy away pill.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Dizzy Pills",1);
					    }
					    case 8:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 9:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a flashlight.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Flashlight",1);
					    }
					    case 10:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 11:
					    {
					        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"You haven't found anything");
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a molotov mission guide.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							PInfo[playerid][MolotovMission] = 1;
					    }
					    case 12:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					    case 13:
					    {
							static rand2;
							rand2 = random(2);
							if(rand2 == 0) return SendClientMessage(playerid,white,"* "cred"You have found a broken dildo. (wortless)");
	                        static string[100];
							GivePlayerWeapon(playerid,10,1);
							format(string,sizeof string,""cjam"%s(%i) has found a purple dildo.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
					    }
					    case 14:
					    {
					        if(PInfo[playerid][SPerk] == 18)
							{
							    if(GetTickCount() - PInfo[playerid][LuckyCharm] < 60000)
							    {
									goto Random;
									PInfo[playerid][LuckyCharm] = GetTickCount();
								}
								else
								{
								    SendClientMessage(playerid,white,"* "cred"You haven't found anything");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"You haven't found anything");
					    }
					}
				}
			}
		}
		if(Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][ZPerk] == 2)
		    {
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are to tired to dig!");
          		new id = -1;
		        id = GetClosestPlayer(playerid,2000);
				if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"You are to close to another zombie!");
				if(id == -1) return SendClientMessage(playerid,red,"It seems like the server is empty o.o'");
				PInfo[playerid][CanDig] = 0;
				PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
		    }
		    if(PInfo[playerid][ZPerk] == 14)
		    {
		        if(PInfo[playerid][GodDig] == 1) return SendClientMessage(playerid,red,"You are to tired to dig!");
		        new id = -1,count = 0;
		        goto func;
		        func:
		        {
					new rand = random(PlayersConnected);
					if(Team[rand] == ZOMBIE)
					{
						if(count >= 1 || RoundEnded == 1 || PlayersConnected == 0) return SendClientMessage(playerid,white,"* "cred"Everyone is a zombie!");
						else
						{
						    count++;
							goto func;
						}
					}
					else id = rand;
		        }
				if(id == -1) return SendClientMessage(playerid,red,"It seems like the server is empty o.o'");
				PInfo[playerid][GodDig] = 1;
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
				static string[120];
			 	format(string,sizeof string,"%s(%i) has god digged. Keep an eye on him. || 1 GOD DIG PER ROUND!",GetPName(playerid),playerid);
				SendAdminMessage(red,string);
		    }
		    if(PInfo[playerid][ZPerk] == 7)
		    {
		        if((GetTickCount() - PInfo[playerid][Allowedtovomit]) < VOMITTIME) return SendClientMessage(playerid,red,"You don't have enough food in your stomach.");
                new Float:x,Float:y,Float:z;
		        GetPlayerPos(playerid,x,y,z);
		        PInfo[playerid][Vomitx] = x;
		        PInfo[playerid][Vomity] = y;
		        PInfo[playerid][Vomitz] = z;
		        ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
		        SetTimerEx("VomitPlayer",3000,false,"i",playerid);
			}
			if(PInfo[playerid][ZPerk] == 12)
			{
			    if(PInfo[playerid][CanStomp] == 0) return SendClientMessage(playerid,red,"You are tired to use so much force.");
				ApplyAnimation(playerid,"PED","FIGHTA_G",5.0,0,0,0,0,700,1);
				static Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				PInfo[playerid][CanStomp] = 0;
				PInfo[playerid][StompTimer] = SetTimerEx("AllowedToStomp",120000,false,"i",playerid);
				for(new i; i < MAX_PLAYERS;i++)
				{
					if(!IsPlayerConnected(i)) continue;
					if(Team[i] == ZOMBIE) continue;
					if(IsPlayerInRangeOfPoint(i,15,x,y,z))
					{
					    TogglePlayerControllable(i,0);
						SetTimerEx("RemoveStomp",1500,false,"i",i);
						static string[90];
				 		format(string,sizeof string,""cjam"%s has received a powerfull misterious energy that froze him.",GetPName(playerid));
						SendNearMessage(playerid,white,string,30);
					}
				}
			}
			if(PInfo[playerid][ZPerk] == 15)
			{
			    if(PInfo[playerid][CanPop] == 0) return SendClientMessage(playerid,red,"Please wait before you pop another set of tires.");
				new id = -1,Float:x,Float:y,Float:z;
				for(new i; i < MAX_VEHICLES;i++)
				{
				    GetVehiclePos(i,x,y,z);
				    if(IsPlayerInRangeOfPoint(playerid,3.0,x,y,z))
					{
						id = i;
						break;
					}
				}
				if(id == -1) return SendClientMessage(playerid,white,"** "cred"You are to far away from a car.");
				PInfo[playerid][CanPop] = 0;
				SetTimerEx("ClearAnim2",3000,false,"ii",playerid,id);
				SetTimerEx("PopAgain",120000,false,"i",playerid);
				ApplyAnimation(playerid,"RIFLE","RIFLE_crouchload",0.5,0,0,0,1,3000,1);
				new panels, doors, lights, tires;
				GetVehicleDamageStatus(id, panels, doors, lights, tires);
				UpdateVehicleDamageStatus(id, panels, doors, lights, 15);
				static string[90];
		 		format(string,sizeof string,""cjam"%s has chewed of the tires of a %s",GetPName(playerid),GetVehicleName(id));
				SendNearMessage(playerid,white,string,30);
			}
		}
	}
	if(HOLDING(KEY_WALK) && HOLDING(KEY_CROUCH) || PRESSED(KEY_WALK) && PRESSED(KEY_CROUCH) || HOLDING(KEY_CROUCH) && HOLDING(KEY_WALK) || PRESSED(KEY_CROUCH) && PRESSED(KEY_WALK))
	{
	    if(PInfo[playerid][SPerk] == 9)
	    {
		    if(Team[playerid] == ZOMBIE) return 0;
		    if(PInfo[playerid][ZombieBait] == 1) return 0;
		    static string[70];
		    PInfo[playerid][ZombieBait] = 1;
		    format(string,sizeof string,""cjam"%s(%i) has dropped some zombie bait",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			GetPlayerPos(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
			PInfo[playerid][ZObject] = CreateObject(2908,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]-1,0,0,0,90);
			SetTimerEx("StopBait",7000,false,"i",playerid);
		}
		else if(PInfo[playerid][SPerk] == 15)
		{
		    if(Team[playerid] == ZOMBIE) return 0;
		    static Float:x,Float:y,Float:z;
		    GetPlayerPos(playerid,x,y,z);
            RemovePlayerMapIcon(playerid,0);
            SetPlayerMapIcon(playerid,0,x,y,z,56,0,MAPICON_GLOBAL);
			DestroyObject(PInfo[playerid][Flare]);
			PInfo[playerid][Flare] = CreateObject(18728,x,y,z-1,0,0,0,200);
		}
	}
	if(HOLDING(KEY_SPRINT))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
            ApplyAnimation(playerid,"Muscular","MuscleSprint",4.1,1,1,1,1,1,1);
	    }
	    else if(Team[playerid] == HUMAN)
	    {
	        if(PInfo[playerid][SPerk] == 8)
	        {
	            if(PInfo[playerid][CanRun] == 0) return 0;
	            if(IsPlayerInAnyVehicle(playerid)) return 0;
	            ApplyAnimation(playerid,"Muscular","MuscleSprint",4.1,1,1,1,1,1,1);
				if(PInfo[playerid][RunTimerActivated] == 0) PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",120000,false,"ii",playerid,1),PInfo[playerid][RunTimerActivated] = 1;
	        }
	    }
	}
	if(RELEASED(KEY_SPRINT))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
	        ApplyAnimation(playerid,"PED","run_gang1",4.1,1,1,1,0,1,1);
	    }
	    else if(Team[playerid] == HUMAN)
	    {
	        if(PInfo[playerid][SPerk] == 8)
	        {
	            if(PInfo[playerid][CanRun] == 0) return 0;
	            if(IsPlayerInAnyVehicle(playerid)) return 0;
     			ApplyAnimation(playerid,"PED","run_stopr",10,1,1,1,0,1,1);
			}
	    }
	}
    if(HOLDING(KEY_WALK) && HOLDING(KEY_SPRINT) || PRESSED(KEY_WALK) && PRESSED(KEY_SPRINT))
    {
        if(Team[playerid] == ZOMBIE) return 0;
        ShowInventory(playerid);
    }
	if(PRESSED(KEY_FIRE))
	{
	    if(PInfo[playerid][StartCar] == 1) return 0;
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	    if(IsVehicleStarted(GetPlayerVehicleID(playerid))) return 0;
		if(Fuel[GetPlayerVehicleID(playerid)] <= 0) return SendClientMessage(playerid,white,"* "cred"This vehicle has no fuel!");
		if(Fuel[GetPlayerVehicleID(playerid)] <= 0) return SendClientMessage(playerid,white,"* "cred"This vehicle has no oil!");
		static Float:health;
		GetVehicleHealth(GetPlayerVehicleID(playerid),health);
		if(health <= 350) return SendClientMessage(playerid,white,"* "cred"This vehicle is to damaged to start!");
		SetTimerEx("Startvehicle",2300,false,"i",playerid);
		static string[64];
		format(string,sizeof string,""cjam"%s(%i) has tried to start his car...",GetPName(playerid),playerid);
		SendNearMessage(playerid,white,string,20);
		PInfo[playerid][StartCar] = 1;
	}
	if(HOLDING(KEY_CROUCH) && HOLDING(KEY_SPRINT) || PRESSED(KEY_CROUCH) && PRESSED(KEY_SPRINT) || HOLDING(KEY_SPRINT) && HOLDING(KEY_CROUCH) || PRESSED(KEY_SPRINT) && PRESSED(KEY_CROUCH))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return 0;
		if(PInfo[playerid][SPerk] == 6 && Team[playerid] == HUMAN)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"You are too tired to jump that far.");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			PInfo[playerid][CanBurst] = 0;
			PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[64];
			format(string,sizeof string,""cjam"%s(%i) has gotten a burst of energy.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
		}
		else if(PInfo[playerid][ZPerk] == 9 && Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"You are too tired to jump that far.");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			PInfo[playerid][CanBurst] = 0;
			PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[64];
			format(string,sizeof string,""cjam"%s(%i) has gotten a burst of energy.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
		}
	}
	if(PRESSED(KEY_HANDBRAKE))//Aim Key
	{
        if(!IsPlayerInAnyVehicle(playerid))
		{
		    if(Team[playerid] != ZOMBIE) return 0;
		    if(PInfo[playerid][CanBite] == 0) return 0;
            if(PInfo[playerid][ZPerk] == 8)
			{
			    if(GetTickCount() - PInfo[playerid][Canscream] < 4000) return 0;
			    for(new i, f = MAX_PLAYERS; i < f; i++)
			    {
	      		    if(i == playerid) continue;
				    if(PInfo[i][Dead] == 1) continue;
				    if(Team[i] == ZOMBIE) continue;
			        if(IsPlayerInAnyVehicle(i)) continue;
			        static Float:x,Float:y,Float:z;
			    	GetPlayerPos(playerid,x,y,z);
			        if(IsPlayerInRangeOfPoint(i,20,x,y,z))
			        {
			            if(IsPlayerFacingPlayer(playerid, i, 70))
			            {
			                new Float:a;
							GetPlayerVelocity(i,x,y,z);
							GetPlayerFacingAngle(playerid,a);
							x += ( 0.5 * floatsin( -a, degrees ) );
					      	y += ( 0.5 * floatcos( -a, degrees ) );
							SetPlayerVelocity(i,x,y,z+0.15);
			            }
			        }
			        static Float:Health;
		  			GetPlayerHealth(i,Health);
     				MakeHealthEven(i,Health);
					if(Health <= 10)
						MakeProperDamage(playerid);
					else
		  				SetPlayerHealth(i,Health-4);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
				 	if(Health <= 5)
				 	{
				 	    SetPlayerHealth(i,100);
				 		GetPlayerPos(i,x,y,z);
						SetPlayerPos(i,x,y,z+4);
						SpawnPlayer(i);
						PInfo[i][Deaths]++;
						PInfo[i][Dead] = 1;
				        PInfo[i][JustInfected] = 1;
				        Team[i] = ZOMBIE;
				        GameTextForPlayer(i,"~r~~h~Infected!",4000,3);
				        SetPlayerColor(i,purple);
					    GivePlayerXP(playerid);
					    CheckRankup(playerid);
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,1,1,1,1,1000,1);
                SetTimerEx("ClearAnim2",700,false,"i",playerid);
                PInfo[playerid][Canscream] = GetTickCount();
      		}
      		else if(PInfo[playerid][ZPerk] == 19)
			{
			    if(GetTickCount() - PInfo[playerid][Canscream] < 4000) return 0;
			    for(new i, f = MAX_PLAYERS; i < f; i++)
			    {
			        if(!IsPlayerConnected(i)) continue;
	      		    if(i == playerid) continue;
				    if(PInfo[i][Dead] == 1) continue;
				    if(Team[i] == ZOMBIE) continue;
           			static Float:x,Float:y,Float:z;
			    	GetPlayerPos(playerid,x,y,z);
			        if(IsPlayerInRangeOfPoint(i,27,x,y,z))
			        {
			            if(IsPlayerFacingPlayer(playerid, i, 70))
			            {
			                if(!IsPlayerInAnyVehicle(i))
			                {
				                new Float:a;
								GetPlayerVelocity(i,x,y,z);
								GetPlayerFacingAngle(playerid,a);
								x += ( 0.5 * floatsin( -a, degrees ) );
						      	y += ( 0.5 * floatcos( -a, degrees ) );
								SetPlayerVelocity(i,x,y,z+0.15);
							}
							else
							{
							    SetVehicleAngularVelocity(GetPlayerVehicleID(i), 0, 0, 0.5);
							}
			            }
			        }
			        static Float:Health;
		  			GetPlayerHealth(i,Health);
					MakeHealthEven(i,Health);
		  			if(Health <= 10)
						MakeProperDamage(playerid);
					else
		  				SetPlayerHealth(i,Health-4);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
				 	if(Health <= 5)
				 	{
				 	    SetPlayerHealth(i,100);
				 		GetPlayerPos(i,x,y,z);
						SetPlayerPos(i,x,y,z+4);
						SpawnPlayer(i);
						PInfo[i][Deaths]++;
						PInfo[i][Dead] = 1;
				        PInfo[i][JustInfected] = 1;
				        Team[i] = ZOMBIE;
				        GameTextForPlayer(i,"~r~~h~Infected!",4000,3);
				        SetPlayerColor(i,purple);
					    GivePlayerXP(playerid);
					    CheckRankup(playerid);
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,1,1,1,1,1000,1);
                SetTimerEx("ClearAnim2",700,false,"i",playerid);
                PInfo[playerid][Canscream] = GetTickCount();
      		}
      		else
      		{
      		    static Float:x,Float:y,Float:z;
			    GetPlayerPos(playerid,x,y,z);
			    new i;
			    i = -1;
			    for(new j, f = MAX_PLAYERS; j < f; j++)
			    {
			        if(j == playerid) continue;
			        if(PInfo[j][Dead] == 1) continue;
			        if(Team[j] == ZOMBIE) continue;
			        if(IsPlayerInAnyVehicle(j)) continue;
			        if(IsPlayerInRangeOfPoint(j,1.2,x,y,z))
			        {
			            i = j;
			            break;
			        }
      			}
      			static Float:Health;
                GetPlayerHealth(i,Health);
                MakeHealthEven(i,Health);
	  			DamagePlayer(playerid,i);
			 	if(PInfo[playerid][ZPerk] == 3)
				{
					GetPlayerHealth(playerid,Health);
					if(Health >= 100.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,Health+6);
				}
				else if(PInfo[playerid][ZPerk] == 13)
				{
					GetPlayerHealth(playerid,Health);
					if(Health >= 100.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,Health+10);
				}
				else
				{
					if(PInfo[playerid][ZPerk] != 18)
					{
						GetPlayerHealth(playerid,Health);
						SetPlayerHealth(playerid,Health+3);
					}
				}
			    GetPlayerHealth(i,Health);
			    MakeHealthEven(i,Health);
	            PlayNearSound(i,1136);
           		SetTimerEx("CantBite",500,0,"i",playerid);
           		PInfo[playerid][CanBite] = 0;
				PInfo[playerid][Bites]++;
				PInfo[i][Lastbite] = playerid;
				if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
				ApplyAnimation(playerid,"WAYFARER","WF_FWD",1,1,1,1,1,300,1);
				if(Health <= 6.0)
				{
				    GetPlayerPos(i,x,y,z);
				    SetPlayerPos(i,x,y,z+8);
				    PInfo[playerid][Infects]++;
				    PInfo[i][Deaths]++;
				    PInfo[i][Dead] = 1;
	       			PInfo[i][JustInfected] = 1;
	       			Team[i] = ZOMBIE;
	       			SpawnPlayer(i);
				    GivePlayerXP(playerid);
	                CheckRankup(playerid);
	                GameTextForPlayer(i,"~r~~h~Infected!",3000,3);
				}
				if(PInfo[playerid][ZPerk] == 10)
				{
					new rand = random(3);
					if(rand == 1)
						ApplyAnimation(i,"BEACH","SitnWait_loop_W",3,0,0,0,0,1500,1);
				}
      		}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    InventoryOnDialogResponse(playerid, dialogid, response, inputtext);
    if(dialogid == Nozombieperkdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 0;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Hardbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 1;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Diggerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 2;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Refreshingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 3;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Jumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 4;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Deadsensedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 5;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Hardpunchdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 6;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Vomiterdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 7;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Screamerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 8;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == ZBurstrundialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 9;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Stingerbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 10;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Bigjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 11;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Stompdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 12;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Refreshingbitedialog2)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 13;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Goddigdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 14;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Poppingtiresdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 15;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Higherjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 16;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Repellentdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 17;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Ravagingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 18;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
	if(dialogid == Superscreamdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 19;
		SendClientMessage(playerid,orange,"You have successfully changed your zombie perk.");
	}
    if(dialogid == Zombieperksdialog)
    {
        if(!response) return 0;
        if(listitem == 0)
        {
			ShowPlayerDialog(playerid,Nozombieperkdialog,0,"No zombie perk",""cwhite"This will set your zombie perk variable to none.","Set","Close");
        }
        if(listitem == 1)
        {
			ShowPlayerDialog(playerid,Hardbitedialog,0,"Hard Bite",""cwhite"With this perk, when you bite, you do more damage to humans.","Set","Close");
        }
        if(listitem == 2)
        {
			ShowPlayerDialog(playerid,Diggerdialog,0,"Digger",""cwhite"With this perk, you are allowed to dig to the closest human.","Set","Close");
        }
        if(listitem == 3)
        {
			ShowPlayerDialog(playerid,Refreshingbitedialog,0,"Refreshing Bite",""cwhite"With this perk, when you bite a human, you get +6HP.","Set","Close");
        }
        if(listitem == 4)
        {
			ShowPlayerDialog(playerid,Jumperdialog,0,"Jumper",""cwhite"With this perk, you are able to jump, higher than normal.","Set","Close");
        }
        if(listitem == 5)
        {
			ShowPlayerDialog(playerid,Deadsensedialog,0,"Dead Sense",""cwhite"With this perk, you are able to see other zombies on the map, so you can team up with them.","Set","Close");
        }
        if(listitem == 6)
        {
			ShowPlayerDialog(playerid,Hardpunchdialog,0,"Hard Punch",""cwhite"This perk is for, when you punch a human, he gets a critical hit.","Set","Close");
        }
        if(listitem == 7)
        {
			ShowPlayerDialog(playerid,Vomiterdialog,0,"Vomiter",""cwhite"With this perk, when you press -"cred"CROUCH"cwhite"- you vomit, and humans get health damage.","Set","Close");
        }
        if(listitem == 8)
        {
			ShowPlayerDialog(playerid,Screamerdialog,0,"Screamer",""cwhite"With this perk, when you press -"cred"RIGHT MOUSE BUTTON"cwhite"- you scream. So humans, and get affected by listening to it.","Set","Close");
        }
        if(listitem == 9)
        {
			ShowPlayerDialog(playerid,ZBurstrundialog,0,"Burst run",""cwhite"This perk, allows you to get a burst run of energy by pressing -"cred"SPRINT + CROUCH"cwhite"-","Set","Close");
        }
        if(listitem == 10)
        {
			ShowPlayerDialog(playerid,Stingerbitedialog,0,"Stinger bite",""cwhite"This perk, is to put a human down, when you bite him. "cgrey"You have 1 in 3 chances.","Set","Close");
        }
        if(listitem == 11)
        {
			ShowPlayerDialog(playerid,Bigjumperdialog,0,"Big jumper",""cwhite"With this perk, you are able to jump twice in a row.","Set","Close");
        }
        if(listitem == 12)
        {
			ShowPlayerDialog(playerid,Stompdialog,0,"Stomp",""cwhite"With this perk enabled, you are able to send a mini but powerfull earthquake. \nAny survivor around you will get affected with it. -"cred"CROUCH"cwhite"- \n"cred"Note: Cool down of 2 minutes.","Set","Close");
        }
        if(listitem == 13)
        {
			ShowPlayerDialog(playerid,Refreshingbitedialog2,0,"More Refreshing Bite",""cwhite"With this perk, when you bite a human, you get +10HP.","Set","Close");
        }
        if(listitem == 14)
        {
			ShowPlayerDialog(playerid,Goddigdialog,0,"God dig",""cwhite"With this perk, you are allowed to dig to the closest human, even tho you have a zombie in your way.","Set","Close");
        }
        if(listitem == 15)
        {
			ShowPlayerDialog(playerid,Poppingtiresdialog,0,"Popping Tires",""cwhite"With this perk, you are allowed to pop vehicle tires, by pressing -"cred"CROUCH"cwhite"-.","Set","Close");
        }
        if(listitem == 16)
        {
			ShowPlayerDialog(playerid,Higherjumperdialog,0,"Higher Jumper",""cwhite"With this perk, you are able to jumper higher than before. You can jump 4 times in mid air.","Set","Close");
        }
        if(listitem == 17)
        {
			ShowPlayerDialog(playerid,Repellentdialog,0,"Repellent",""cwhite"With this perk, you are imune to all zombie baits. (You don't get affected)","Set","Close");
        }
        if(listitem == 18)
        {
			ShowPlayerDialog(playerid,Ravagingbitedialog,0,"Ravaging Bite",""cwhite"Ravaging bite is the most powerfull zombie bite perk at the moment \nWhen you bite someone, you do the same damage with Hard Bite and you get healed the same amount as Refreshing bite. \n"cred"Note: -10HP of damage on a victim and +6HP to you.","Set","Close");
        }
        if(listitem == 19)
        {
			ShowPlayerDialog(playerid,Superscreamdialog,0,"Super Scream",""cwhite"With this perk, you are able to shout exactly as the perk Screamer, but with this one, vehicles get affected.","Set","Close");
        }
    }
    
    
    if(dialogid == Noperkdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 0;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
    if(dialogid == Extramedsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 1;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extrafueldialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 2;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extraoildialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 3;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Lessbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 5;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
    if(dialogid == Flashbangsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 4;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Burstdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 6;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Medicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 7;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Morestaminadialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 8;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Zombiebaitdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 9;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Firemodedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 10;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Mechanicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 11;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extraammodialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 12;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Fielddoctordialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 13;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Rocketbootsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 14;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Homingbeacondialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 15;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Mastermechanicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 16;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Flameroundsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 17;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Luckycharmdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 18;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Grenadesdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 19;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == Humanperksdialog)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
	        ShowPlayerDialog(playerid,Noperkdialog,0,"None",""cwhite"This is to set your perk variable to none.","Set","Cancel");
	    }
	    if(listitem == 1)
	    {
	        ShowPlayerDialog(playerid,Extramedsdialog,0,"Extra meds",""cwhite"This perk, is for, when you take medical kits, it gives you an extra 5HP.","Set","Cancel");
	    }
	    if(listitem == 2)
	    {
	        ShowPlayerDialog(playerid,Extrafueldialog,0,"Extra fuel",""cwhite"This perk, is for, when you add fuel to your vehicle, it automatically add's a bit more.","Set","Cancel");
	    }
	    if(listitem == 3)
	    {
	        ShowPlayerDialog(playerid,Extraoildialog,0,"Extra oil",""cwhite"This perk, is for, when you add oil to your vehicle, it automatically add's a bit more.","Set","Cancel");
	    }
	    if(listitem == 4)
	    {
	        ShowPlayerDialog(playerid,Flashbangsdialog,0,"Flashbangs",""cwhite"When you enter a checkpoint, you receive +1 flashbangs.","Set","Cancel");
	    }
	    if(listitem == 5)
	    {
	        ShowPlayerDialog(playerid,Lessbitedialog,0,"Less bite damage",""cwhite"This perk, is for, when a zombie bites you, it does less damage to you.","Set","Cancel");
	    }
	    if(listitem == 6)
	    {
	        ShowPlayerDialog(playerid,Burstdialog,0,"Burst Run",""cwhite"This perk, gives you more speed when you press -"cred"JUMP + CROUCH"cwhite"-","Set","Cancel");
	    }
	    if(listitem == 7)
	    {
	        ShowPlayerDialog(playerid,Medicdialog,0,"Medic",""cwhite"This perk allows you to assist other players with medical kits.","Set","Cancel");
	    }
	    if(listitem == 8)
	    {
	        ShowPlayerDialog(playerid,Morestaminadialog,0,"More Stamina",""cwhite"This perk allows you to run faster for 2 minutes.","Set","Cancel");
	    }
	    if(listitem == 9)
	    {
	        ShowPlayerDialog(playerid,Zombiebaitdialog,0,"Zombie bait",""cwhite"This perk allows you to throw a zombie bait, to attract zombies to a brain. -"cred"WALK + CROUCH"cwhite"-","Set","Cancel");
	    }
	    if(listitem == 10)
	    {
	        ShowPlayerDialog(playerid,Firemodedialog,0,"Fire punch",""cwhite"This perk allows you to set a zombie on fire, when you punch them.","Set","Cancel");
	    }
	    if(listitem == 11)
	    {
	        ShowPlayerDialog(playerid,Mechanicdialog,0,"Mechanic",""cwhite"This perk allows you to fix vehicles by pressing -"cred"CROUCH"cwhite"- while next to a car.","Set","Cancel");
	    }
	    if(listitem == 12)
	    {
	        ShowPlayerDialog(playerid,Extraammodialog,0,"More Ammo",""cwhite"This perk allows you to get more ammo, when you enter the checkpoint","Set","Cancel");
	    }
	    if(listitem == 13)
	    {
	        ShowPlayerDialog(playerid,Fielddoctordialog,0,"Field Doctor",""cwhite"This perk allows you to assist others with Health packs and Dizzy packs.","Set","Cancel");
	    }
	    if(listitem == 14)
	    {
	        ShowPlayerDialog(playerid,Rocketbootsdialog,0,"Rocket Boots",""cwhite"This perk allows you to jump higher, but you have a cool down between each jump of 8 seconds.","Set","Cancel");
	    }
	    if(listitem == 15)
	    {
	        ShowPlayerDialog(playerid,Homingbeacondialog,0,"Homing Beacon",""cwhite"This perk allows you to set a \"Signal Flare\" so you know your way to that point. -"cred"WALK + CROUCH"cwhite"-","Set","Cancel");
	    }
	    if(listitem == 16)
	    {
	        ShowPlayerDialog(playerid,Mastermechanicdialog,0,"Master Mechanic",""cwhite"This perk allows you to set fully fix a vehicle by pressing: -"cred"CROUCH"cwhite"-","Set","Cancel");
	    }
	    if(listitem == 17)
	    {
	        ShowPlayerDialog(playerid,Flameroundsdialog,0,"Flame rounds",""cwhite"This perk allows you to shoot a zombie and set him on fire. \n"cred"NOTE: To get flame rounds, go to the CP"cwhite".","Set","Cancel");
	    }
     	if(listitem == 18)
	    {
	        ShowPlayerDialog(playerid,Luckycharmdialog,0,"Lucky Charm",""cwhite"This perk is to make sure that, when you search for an item, you always get something. ","Set","Cancel");
	    }
	    if(listitem == 19)
	    {
	        ShowPlayerDialog(playerid,Grenadesdialog,0,"Grenades",""cwhite"This perk, is to, when you enter the checkpoint, you get grenades.","Set","Cancel");
	    }
	}
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
			LoadStats(playerid);
			PInfo[playerid][Logged] = 1;
			PInfo[playerid][Failedlogins] = 0;
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
        if(strlen(inputtext) < 3 && strlen(inputtext) > 22)
	    {
			SendClientMessage(playerid,white,"» "cred"The password must be between 3 and 22 characters!");
			Kick(playerid);
		}
	    if(!response) return Kick(playerid);
	    static buf[131];
    	WP_Hash(buf, sizeof (buf), inputtext);
    	RegisterPlayer(playerid,buf);
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
    if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
	{
		new weaponid=GetPlayerWeapon(playerid),oldweapontype=GetWeaponType(OldWeapon[playerid]);
		new weapontype=GetWeaponType(weaponid);
		if(HoldingWeapon[playerid]==weaponid)
		    StopPlayerHoldingObject(playerid);

		if(OldWeapon[playerid]!=weaponid)
		{
		    new modelid=GetWeaponModel(OldWeapon[playerid]);
		    if(modelid!=0 && oldweapontype!=WEAPON_TYPE_NONE && oldweapontype!=weapontype)
		    {
		        HoldingWeapon[playerid]=OldWeapon[playerid];
		        switch(oldweapontype)
		        {
		            case WEAPON_TYPE_LIGHT:
						SetPlayerHoldingObject(playerid, modelid, 8,0.0,-0.1,0.15, -100.0, 0.0, 0.0);

					case WEAPON_TYPE_MELEE:
					    SetPlayerHoldingObject(playerid, modelid, 7,0.0,0.0,-0.18, 100.0, 45.0, 0.0);

					case WEAPON_TYPE_HEAVY:
					    SetPlayerHoldingObject(playerid, modelid, 1, 0.2,-0.125,-0.1,0.0,25.0,180.0);
		        }
		    }
		}
		if(oldweapontype!=weapontype)
			OldWeapon[playerid]=weaponid;
	}/*
	new k, ud,lr;
 	GetPlayerKeys(playerid,k,ud,lr);
 	if(Team[playerid] == ZOMBIE)
 	{
  		new Float:v_x,Float:v_y,Float:v_z,
	    	Float:x,Float:y,Float:z;
	    if(ud < 0)
	    {
			GetPlayerCameraFrontVector(playerid,v_x,v_y,v_z);
    		GetPlayerCameraPos(playerid,x,y,z);
            SetPlayerLookAt(playerid,v_x*500.0+x,v_y*500.0+y);
	    }
    }*/
	return 1;
}

stock GetPName(playerid)
{
	new p_name[24];
	GetPlayerName(playerid,p_name,24);
	return p_name;
}

stock SendAdminMessage(color,text[])
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(PInfo[i][Level] > 0)
	    {
			SendClientMessage(i,color,text);
	    }
	}
	return 1;
}

function LoadStats(playerid)
{
    PlaySound(playerid,6401);
	static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
 	PInfo[playerid][Level] = INI_ReadInt("Level");
 	PInfo[playerid][Rank] = INI_ReadInt("Rank");
 	PInfo[playerid][XP] = INI_ReadInt("XP");
 	PInfo[playerid][Kills] = INI_ReadInt("Kills");
 	PInfo[playerid][Infects] = INI_ReadInt("Infects");
    PInfo[playerid][Deaths] = INI_ReadInt("Deaths");
    PInfo[playerid][Teamkills] = INI_ReadInt("Teamkills");
    PInfo[playerid][SPerk] = INI_ReadInt("SPerk");
    PInfo[playerid][ZPerk] = INI_ReadInt("ZPerk");
    PInfo[playerid][Bites] = INI_ReadInt("Bites");
    PInfo[playerid][CPCleared] = INI_ReadInt("CPCleared");
    PInfo[playerid][Assists] = INI_ReadInt("Assists");
    PInfo[playerid][Vomited] = INI_ReadInt("Vomited");
    PInfo[playerid][Premium] = INI_ReadInt("Premium");
 	INI_Close();
 	CheckRankup(playerid);
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
	return 1;
}

function RegisterPlayer(playerid,pass[])
{
    static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
	INI_WriteString("Password",pass);
	INI_WriteString("IP",GetIP(playerid));
 	INI_WriteInt("Level",0);
 	INI_WriteInt("Rank",1);
 	INI_WriteInt("XP",0);
 	INI_WriteInt("Kills",0);
    INI_WriteInt("Deaths",0);
    INI_WriteInt("Teamkills",0);
    INI_WriteInt("Infects",0);
    INI_WriteInt("SPerk",0);
    INI_WriteInt("ZPerk",0);
    INI_WriteInt("Bites",0);
    INI_WriteInt("CPCleared",0);
    INI_WriteInt("Vomited",0);
    INI_WriteInt("Assists",0);
    INI_WriteInt("Premium",0);
    INI_WriteInt("SSkin",0);
    INI_WriteInt("ZSkin",0);
    INI_WriteInt("Warns",0);
    INI_WriteInt("Banned",0);
    INI_WriteString("Warn1","None");
    INI_WriteString("Warn2","None");
    INI_WriteString("Warn3","None");
    INI_Save();
 	INI_Close();
 	LoadStats(playerid);
 	PInfo[playerid][Logged] = 1;
	GameTextForPlayer(playerid,"~g~~h~You have been successfully ~n~~y~~h~registered!",4000,3);
	return 1;
}

function SaveStats(playerid)
{
    static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
 	INI_WriteInt("Level",PInfo[playerid][Level]);
 	INI_WriteInt("Rank",PInfo[playerid][Rank]);
 	INI_WriteInt("XP",PInfo[playerid][XP]);
 	INI_WriteInt("Kills",PInfo[playerid][Kills]);
    INI_WriteInt("Deaths",PInfo[playerid][Deaths]);
    INI_WriteInt("Teamkills",PInfo[playerid][Teamkills]);
    INI_WriteInt("Infects",PInfo[playerid][Infects]);
    INI_WriteInt("SPerk",PInfo[playerid][SPerk]);
    INI_WriteInt("ZPerk",PInfo[playerid][ZPerk]);
    INI_WriteInt("Bites",PInfo[playerid][Bites]);
    INI_WriteInt("CPCleared",PInfo[playerid][CPCleared]);
    INI_WriteInt("Vomited",PInfo[playerid][Vomited]);
    INI_WriteInt("Assists",PInfo[playerid][Assists]);
    INI_WriteInt("Premium",PInfo[playerid][Premium]);
    INI_Save();
 	INI_Close();
	return 1;
}

function ShowXP(playerid)//Biggest
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
 	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawLetterSize(GainXPTD[playerid], 0.780000, 4.100000);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetOutline(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("HideXP",1000,0,"i",playerid);
	static string[7];
	format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	TextDrawSetString(GainXPTD[playerid],string);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	PlaySound(playerid,1057);
	return 1;
}

function ShowXP1(playerid)//Medium
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
 	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawLetterSize(GainXPTD[playerid], 0.659999, 3.200001);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetOutline(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("ShowXP",300,0,"i",playerid);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	PlaySound(playerid,1083);
	return 1;
}

function HideXP(playerid)
{
	TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawLetterSize(GainXPTD[playerid], 0.610000, 2.600002);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetOutline(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	PInfo[playerid][ShowingXP] = 0;
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
	for(new i; i < MAX_PLAYERS;i++)
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

function CantBite(playerid)
{
    PInfo[playerid][CanBite] = 1;
	return 1;
}

function UpdateStats()
{

	for(new i; i < MAX_PLAYERS;i++)
	{
		SetPlayerScore(i,PInfo[i][Rank]);
	    if(!IsPlayerConnected(i)) continue;
        if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == HUMAN)
	    {
		    static string[88];
		    format(string,sizeof string,"Rank: %i ~n~Kills: %i ~n~TeamKills: %i ~n~Deaths: %i ~n~Perk: %i ~n~CP Cleared: %i",
		    PInfo[i][Rank],PInfo[i][Kills],PInfo[i][Teamkills],PInfo[i][Deaths],PInfo[i][SPerk]+1,PInfo[i][CPCleared]);
		    TextDrawSetString(Stats[i],string);
		    TextDrawShowForPlayer(i,Stats[i]);
		    format(string,sizeof string,"XP: %i/%i",PInfo[i][XP],PInfo[i][XPToRankUp]);
	  		TextDrawSetString(XPStats[i],string);
			TextDrawShowForPlayer(i,XPStats[i]);
			TextDrawShowForPlayer(i,XPBox);
			if(PInfo[i][Premium] == 1)
				format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			else if(PInfo[i][Premium] == 2)
			    format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			else
			    format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			Update3DTextLabelText(PInfo[i][Ranklabel],green,string);
			static Float:health;
		    GetVehicleHealth(GetPlayerVehicleID(i),health);
			MakeHealthEven(i,health);
			if(Mission[i] == 1)
			{
				if(MissionPlace[i][1] == 1) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 1)
				    {
				        if(IsPlayerInRangeOfPoint(i,1.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for bottles.",3000,3);
				        }
				    }
				    if(MissionPlace[i][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(i,1.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for bottles.",3000,3);
				        }
				    }
				}
				if(MissionPlace[i][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[2][0],Locations[2][1],Locations[2][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some cloth.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some cloth.",3000,3);
				        }
					}
				}
				if(MissionPlace[i][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some glue.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some glue.",3000,3);
				        }
					}
				}
			}
    	}
    	else if(Team[i] == ZOMBIE)
    	{
    	    static string[88];
		    format(string,sizeof string,"Rank: %i ~n~Infects: %i ~n~Bites: %i ~n~Deaths: %i ~n~Assists: %i ~n~Vomited: %i",
		    PInfo[i][Rank],PInfo[i][Infects],PInfo[i][Bites],PInfo[i][Deaths],PInfo[i][Assists],PInfo[i][Vomited]);
		    TextDrawSetString(Stats[i],string);
		    TextDrawShowForPlayer(i,Stats[i]);
		    format(string,sizeof string,"XP: %i/%i",PInfo[i][XP],PInfo[i][XPToRankUp]);
	  		TextDrawSetString(XPStats[i],string);
			TextDrawShowForPlayer(i,XPStats[i]);
			TextDrawShowForPlayer(i,XPBox);
			format(string,sizeof string,"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			Update3DTextLabelText(PInfo[i][Ranklabel],purple,string);
			new Float:Health;
		    GetPlayerHealth(i,Health);
		    if(Health >= 5 && Health <= 10)
				SetPlayerHealth(i,5);
    	}
     	if(PInfo[i][XP] >= PInfo[i][XPToRankUp])
		{
		    GameTextForPlayer(i,"~g~~h~RANK UP!",5000,3);
		    PlaySound(i,1057);
		    PInfo[i][Rank]++;
		    PInfo[i][XP] = 0;
		    CheckRankup(i);
		    SetPlayerScore(i,PInfo[i][Rank]);
		}
		if(PInfo[i][ZX] != 0)
		{
		    for(new f; f < MAX_PLAYERS;f++)
		    {
		        if(!IsPlayerConnected(f)) continue;
	    		if(PInfo[f][Dead] == 1) continue;
	    		if(Team[f] == HUMAN) continue;
       			if(PInfo[f][ZPerk] == 17) continue;
	    		if(IsPlayerInRangeOfPoint(f,16.0,PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]))
	   			{
	   			    TurnPlayerFaceToPos(f,PInfo[i][ZX],PInfo[i][ZY]);
	    			ApplyAnimation(f, "PED" , "WALK_SHUFFLE" , 2.0 , 0 , 1 , 1 , 0 , 5000 , 1);
    			}
		    }
		}
		for(new j; j < sizeof(Searchplaces);j++)
		{
		    if(IsPlayerInRangeOfPoint(i,1.0,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2]))
			{
			    GameTextForPlayer(i,"~n~~n~~r~~h~Press ~w~~k~~PED_DUCK~~r~~h~ to search for items",3500,3);
			}
		}
		if(IsPlayerInAnyVehicle(i) && Team[i] == HUMAN)
		{
		    static Float:health;
		    GetVehicleHealth(GetPlayerVehicleID(i),health);
		    if(health <= 200) SetVehicleHealth(GetPlayerVehicleID(i),350);
		}
		if(Team[i] == ZOMBIE)
		{
		    static Float:health;
			if((GetTickCount() - PInfo[i][Allowedtovomit]) >= VOMITTIME && PInfo[i][Vomitmsg] == 0)
			    SendClientMessage(i,red,"You have your stomach full (vomit ready)"),PInfo[i][Vomitmsg] = 1;
			if((GetTickCount() - PInfo[i][CanJump] >= 3500)) PInfo[i][Jumps] = 0;
            for(new j; j < MAX_PLAYERS;j++)
		    {
		        if(Team[j] == ZOMBIE) continue;
		        if(!IsPlayerConnected(j)) continue;
		        if(PInfo[j][Dead] == 1) continue;
				if(IsPlayerInRangeOfPoint(j,4.0,PInfo[i][Vomitx],PInfo[i][Vomity],PInfo[i][Vomitz]))
				{
				    if(IsPlayerInAnyVehicle(j))
				    {
				        SetVehicleHealth(GetPlayerVehicleID(j),350.0);
				        StartVehicle(GetPlayerVehicleID(j),0);
						VehicleStarted[GetPlayerVehicleID(j)] = 0;
				    }
				    else
				    {
            			GetPlayerHealth(j,health);
						MakeHealthEven(j,health);
				        DamagePlayer(i,j);
      					if(health <= 6.0)
      					{
                            GivePlayerXP(i);
                            PInfo[i][Infects]++;
						    SetPlayerHealth(j,100);
						    static Float:x,Float:y,Float:z;
					 		GetPlayerPos(j,x,y,z);
							SetPlayerPos(j,x,y,z+4);
							SpawnPlayer(j);
							PInfo[j][Deaths]++;
							PInfo[j][Dead] = 1;
					        PInfo[j][JustInfected] = 1;
					        Team[j] = ZOMBIE;
					        GameTextForPlayer(j,"~r~~h~Infected!",4000,3);
					        SetPlayerColor(j,purple);
					        CheckRankup(i);
           				}
				    }
				}
			}
		}
    	SetPlayerTime(i,0,0);
	}
	return 1;
}

function Dizzy()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Team[i] == ZOMBIE) continue;
		if(Team[i] == HUMAN && PInfo[i][Infected] == 0) continue;
		if(PInfo[i][TokeDizzy] == 0) SetPlayerDrunkLevel(i,6000);
		else SetPlayerDrunkLevel(i,3000);
		SetPlayerWeather(i,1591);
		if(PInfo[i][Lighton] == 1)
		{
            RemovePlayerAttachedObject(i,3);
            RemovePlayerAttachedObject(i,4);
            PInfo[i][Lighton] = 0;
            RemoveItem(i,"Flashlight",1);
            static string[90];
 			format(string,sizeof string,""cjam"%s flashlight has runned out of bateries.",GetPName(i));
			SendNearMessage(i,white,string,30);
		}
	}
	for(new i; i < MAX_VEHICLES;i++)
	{
		if(!IsVehicleOccupied(i)) continue;
		if(!IsVehicleStarted(i)) continue;
		Fuel[i]-=10;
		Oil[i]-=10;
		UpdateVehicleFuelAndOil(i);
	}
	SetTimer("Enddizzy",7000,false);
	return 1;
}

function Enddizzy()
{
    for(new i; i < MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(Team[i] == ZOMBIE) continue;
		if(Team[i] == HUMAN && PInfo[i][Infected] == 0) continue;
		SetPlayerDrunkLevel(i,0);
		SetPlayerWeather(i,Weather);
	}
	return 1;
}

function WeatherUpdate()
{
    new Weathers[] =
	{
	    124,
	    2451,
	    1381,
	    1450,
	    1462,
	    1601
	};
	new id;
	id = Weathers[random(sizeof Weathers)];
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(Team[i] == ZOMBIE) SetPlayerWeather(i,2718);
	    SetPlayerWeather(i,id);
		Weather = id;
		#if snowing == true
		{
			if(Snow == 1)
		    {
				if(GetPlayerInterior(i) == 0)
				{
		  			new Float:Pos[3];
					GetPlayerPos(i,Pos[0],Pos[1],Pos[2]);
					Pos[2] = Pos[2]-4;
			     	for(new g = 0; g < 2; g++)
					{
						if(SnowCreated[i] == 0)SnowObj[i][g] = CreateDynamicObject(18864,Pos[0]+random(5),Pos[1],Pos[2],0,0,random(45), -1, -1, i,150.0),SnowCreated[i] = 1;
			     		SetDynamicObjectPos(SnowObj[i][g],Pos[0]+random(5),Pos[1],Pos[2]);
			        	SetDynamicObjectRot(SnowObj[i][g],0,0,random(45));
			        	SnowCreated[i] = 1;
			      	}
		    	}
			}
			else
			{
			    if(Snow == 0)
				{
				    if(SnowCreated[i] == 1)
			        {
				  		for(new g = 0; g < 2; g++)
						{
				   			DestroyDynamicObject(SnowObj[i][g]);
						}
						SnowCreated[i] = 0;
					}
					else continue;
				}
			}
		}
		#endif
	}
	return 1;
}

stock CheckRankup(playerid,gw=0)
{
	switch(PInfo[playerid][Rank])
	{
	    case 1:PInfo[playerid][XPToRankUp] = 50;
	    case 2: PInfo[playerid][XPToRankUp] = 100;
	    case 3: PInfo[playerid][XPToRankUp] = 200;
	    case 4: PInfo[playerid][XPToRankUp] = 400;
	    case 5: PInfo[playerid][XPToRankUp] = 600;
	    case 6: PInfo[playerid][XPToRankUp] = 800;
	    case 7: PInfo[playerid][XPToRankUp] = 1000;
	    case 8: PInfo[playerid][XPToRankUp] = 1250;
	    case 9: PInfo[playerid][XPToRankUp] = 1500;
	    case 10: PInfo[playerid][XPToRankUp] = 2000;
	    case 11: PInfo[playerid][XPToRankUp] = 2500;
	    case 12: PInfo[playerid][XPToRankUp] = 3000;
	    case 13: PInfo[playerid][XPToRankUp] = 3500;
	    case 14: PInfo[playerid][XPToRankUp] = 4000;
	    case 15: PInfo[playerid][XPToRankUp] = 5000;
	    case 16: PInfo[playerid][XPToRankUp] = 6000;
	    case 17: PInfo[playerid][XPToRankUp] = 7000;
	    case 18: PInfo[playerid][XPToRankUp] = 8000;
	    case 19: PInfo[playerid][XPToRankUp] = 9000;
	    case 20: PInfo[playerid][XPToRankUp] = 10000;
	    case 21: PInfo[playerid][XPToRankUp] = 12500;
	    case 22: PInfo[playerid][XPToRankUp] = 15000;
	    case 23: PInfo[playerid][XPToRankUp] = 17500;
	    case 24: PInfo[playerid][XPToRankUp] = 20000;
	    case 25: PInfo[playerid][XPToRankUp] = 22500;
	    case 26: PInfo[playerid][XPToRankUp] = 25000;
	    case 27: PInfo[playerid][XPToRankUp] = 27500;
	    case 28: PInfo[playerid][XPToRankUp] = 30000;
	    case 29: PInfo[playerid][XPToRankUp] = 32500;
	    case 30: PInfo[playerid][XPToRankUp] = 35000;
	    case 31: PInfo[playerid][XPToRankUp] = 40000;
	}
	if(gw == 1)
	{
	    if(Team[playerid] == ZOMBIE) return 0;
	    switch(PInfo[playerid][Rank])
		{
		    case 1: GivePlayerWeapon(playerid,23,90);
		    case 2: GivePlayerWeapon(playerid,23,110);
		    case 3: GivePlayerWeapon(playerid,23,160),GivePlayerWeapon(playerid,7,1);
		    case 4: GivePlayerWeapon(playerid,23,190),GivePlayerWeapon(playerid,7,1);
		    case 5: GivePlayerWeapon(playerid,22,100),GivePlayerWeapon(playerid,7,1);
		    case 6: GivePlayerWeapon(playerid,22,150),GivePlayerWeapon(playerid,7,1);
		    case 7: GivePlayerWeapon(playerid,22,200),GivePlayerWeapon(playerid,7,1);
		    case 8: GivePlayerWeapon(playerid,22,250),GivePlayerWeapon(playerid,7,1);
		    case 9: GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1);
		    case 10: GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,50);
		    case 11: GivePlayerWeapon(playerid,22,400),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,150);
		    case 12: GivePlayerWeapon(playerid,22,500),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,250);
		    case 13: GivePlayerWeapon(playerid,22,650),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,350);
		    case 14: GivePlayerWeapon(playerid,22,750),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,350);
		    case 15: GivePlayerWeapon(playerid,24,100),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,350);
		    case 16: GivePlayerWeapon(playerid,24,150),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,400);
		    case 17: GivePlayerWeapon(playerid,24,200),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,450);
		    case 18: GivePlayerWeapon(playerid,24,250),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,500);
		    case 19: GivePlayerWeapon(playerid,24,300),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,500);
		    case 20: GivePlayerWeapon(playerid,24,350),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,550),GivePlayerWeapon(playerid,28,120);
		    case 21: GivePlayerWeapon(playerid,24,400),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,600),GivePlayerWeapon(playerid,28,200);
		    case 22: GivePlayerWeapon(playerid,24,450),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,650),GivePlayerWeapon(playerid,28,250);
		    case 23: GivePlayerWeapon(playerid,24,500),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,700),GivePlayerWeapon(playerid,28,300);
		    case 24: GivePlayerWeapon(playerid,24,550),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,750),GivePlayerWeapon(playerid,28,350);
		    case 25: GivePlayerWeapon(playerid,24,600),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,150),GivePlayerWeapon(playerid,28,400);
		    case 26: GivePlayerWeapon(playerid,24,650),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,200),GivePlayerWeapon(playerid,28,450);
		    case 27: GivePlayerWeapon(playerid,24,700),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,250),GivePlayerWeapon(playerid,28,500);
		    case 28: GivePlayerWeapon(playerid,24,750),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,300),GivePlayerWeapon(playerid,28,550);
		    case 29: GivePlayerWeapon(playerid,24,800),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,400),GivePlayerWeapon(playerid,28,600);
		    case 30: GivePlayerWeapon(playerid,24,600),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,150),GivePlayerWeapon(playerid,32,100);
		}
	}
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
	return 1;
}

function RandomCheckpoint()
{
	new rand = random(9);
	CPID = rand;
	if(RoundEnded == 1) return 0;
	if(rand == 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,1423.8917,-1921.4729,14.9433,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Gate C!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 1)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,1773.7175,-1943.9563,13.5575,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Unity!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 2)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,1969.8950,-1198.7197,25.6510,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Glen Park!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 3)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,1156.2579,-851.7327,49.1676,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Vinewood burgershot!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 4)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,872.0963,-1223.6838,16.8897,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Movie studio!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 5)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
			SetPlayerCheckpoint(i,769.8062,-1350.9500,13.5307,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Inter Global!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 6)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
		    SetPlayerCheckpoint(i,532.4576,-1415.2734,15.9532,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Rodeo!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 7)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
		    SetPlayerCheckpoint(i,195.2865,-1797.4672,4.1415,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to The Beach!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	if(rand == 8)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
		    SetPlayerCheckpoint(i,2492.3152,-1668.8440,13.3438,20.0);
		    SendClientMessage(i,white,"** "cred"Radio interferance...");
		    SendClientMessage(i,white,"» Announcer: "cblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!");
		    SendClientMessage(i,white,"» Announcer: "cblue"If any survivors can hear me, head over to Grove Street!");
		    SendClientMessage(i,white,"» Announcer: "cblue"To get Health, Ammo, XP, Safety");
		    SendClientMessage(i,white,"** "cred"No battery left...");
		}
	}
	SetTimer("CheckCP",1000,false);
	return 1;
}

function CheckCP()
{
	if(CPValue >= CPVALUE)
	{
	    CPscleared++;
	    static string2[35];
   		format(string2,sizeof string2,"~w~CP's cleared: ~r~~h~%i/8",CPscleared);
   		TextDrawSetString(CPSCleared,string2);
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerConnected(i)) continue;
	        GameTextForPlayer(i,string2,4000,3);
	        if(Team[i] == ZOMBIE) continue;
        	PInfo[i][Firsttimeincp] = 1;
        	if(IsPlayerInCheckpoint(i) && Team[i] == HUMAN)
        	{
        		SendClientMessage(i,white,"** "cred"The military seems to be leaving, so should you.");
        		PInfo[i][XP] += 10;
        		PInfo[i][CurrentXP] = 10;
				static string[7];
				format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
				TextDrawSetString(GainXPTD[i],string);
				PInfo[i][ShowingXP] = 1;
				SetTimerEx("ShowXP1",300,0,"d",i);
				TextDrawShowForPlayer(i,GainXPTD[i]);
				PlaySound(i,1083);
				CheckRankup(i);
				PInfo[i][CPCleared]++;
       		}
       		DisablePlayerCheckpoint(i);
   		}
   		SetTimer("RandomCheckpoint",CPTIME,false);
   		CPID = -1;
   		CPValue = 0;
   		return 1;
	}
	else
	{
	    static Float:health;
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerConnected(i)) continue;
	        if(Team[i] == ZOMBIE) continue;
	        if(IsPlayerInCheckpoint(i))
	        {
	            CPValue++;
		        GetPlayerHealth(i,health);
		        if(health < 100)
		        {
		            SetPlayerHealth(i,health+3);
		            GetPlayerHealth(i,health);
		            if(health > 100.0) SetPlayerHealth(i,100.0);
		        }
	        }
	    }
	    if(CPValue >= CPVALUE)
		{
		    CPscleared++;
		    static string2[35];
	   		format(string2,sizeof string2,"~w~CP's cleared: ~r~~h~%i/8",CPscleared);
	   		TextDrawSetString(CPSCleared,string2);
		    for(new i; i < MAX_PLAYERS; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
		        GameTextForPlayer(i,string2,4000,3);
		        if(Team[i] == ZOMBIE) continue;
	        	PInfo[i][Firsttimeincp] = 1;
	        	if(IsPlayerInCheckpoint(i) && Team[i] == HUMAN)
	        	{
	        		SendClientMessage(i,white,"** "cred"The military seems to be leaving, so should you.");
	        		PInfo[i][XP] += 10;
	        		PInfo[i][CurrentXP] = 10;
					static string[7];
					format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					TextDrawSetString(GainXPTD[i],string);
					PInfo[i][ShowingXP] = 1;
					SetTimerEx("ShowXP1",300,0,"d",i);
					TextDrawShowForPlayer(i,GainXPTD[i]);
					PlaySound(i,1083);
					CheckRankup(i);
					PInfo[i][CPCleared]++;
	       		}
	       		DisablePlayerCheckpoint(i);
	   		}
	   		SetTimer("RandomCheckpoint",CPTIME,false);
	   		CPID = -1;
	   		CPValue = 0;
	   		return 1;
		}
	}
	return SetTimer("CheckCP",1000,false);
}

function SetPlayerCP(playerid)
{
	if(CPID == -1) return 0;
	if(CPID == 0)
	{
 		SetPlayerCheckpoint(playerid,1423.8917,-1921.4729,14.9433,20.0);
	}
	if(CPID == 1)
	{
 		SetPlayerCheckpoint(playerid,1773.7175,-1943.9563,13.5575,20.0);
	}
    if(CPID == 2)
	{
 		SetPlayerCheckpoint(playerid,1969.8950,-1198.7197,25.6510,20.0);
	}
	if(CPID == 3)
	{
 		SetPlayerCheckpoint(playerid,1156.2579,-851.7327,49.1676,20.0);
	}
    if(CPID == 4)
	{
 		SetPlayerCheckpoint(playerid,872.0963,-1223.6838,16.8897,20.0);
	}
	if(CPID == 5)
	{
 		SetPlayerCheckpoint(playerid,769.8062,-1350.9500,13.5307,20.0);
	}
 	if(CPID == 6)
	{
 		SetPlayerCheckpoint(playerid,532.4576,-1415.2734,15.9532,20.0);
	}
	if(CPID == 7)
	{
 		SetPlayerCheckpoint(playerid,195.2865,-1797.4672,4.1415,20.0);
	}
	if(CPID == 8)
	{
 		SetPlayerCheckpoint(playerid,2492.3152,-1668.8440,13.3438,20.0);
	}
	return 1;
}

function ShowPlayerHumanPerks(playerid)
{
	if(PInfo[playerid][Rank] == 1) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone","Choose","Cancel");
	if(PInfo[playerid][Rank] == 2) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds","Choose","Cancel");
	if(PInfo[playerid][Rank] == 3) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel ","Choose","Cancel");
	if(PInfo[playerid][Rank] == 4) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil ","Choose","Cancel");
	if(PInfo[playerid][Rank] == 5) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades ","Choose","Cancel");
	if(PInfo[playerid][Rank] == 6) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage","Choose","Cancel");
	if(PInfo[playerid][Rank] == 7) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run","Choose","Cancel");
	if(PInfo[playerid][Rank] == 8) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 9) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina","Choose","Cancel");
	if(PInfo[playerid][Rank] == 10) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait","Choose","Cancel");
	if(PInfo[playerid][Rank] == 11) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch","Choose","Cancel");
	if(PInfo[playerid][Rank] == 12) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 13) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo","Choose","Cancel");
	if(PInfo[playerid][Rank] == 14) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor","Choose","Cancel");
 	if(PInfo[playerid][Rank] == 15) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots","Choose","Cancel");
	if(PInfo[playerid][Rank] == 16) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm","Choose","Cancel");
	if(PInfo[playerid][Rank] >= 20) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tMore ammo \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades","Choose","Cancel");
	return 1;
}

function ShowPlayerZombiePerks(playerid)
{
	if(PInfo[playerid][Rank] == 1) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone","Choose","Cancel");
	if(PInfo[playerid][Rank] == 2) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 3) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger","Choose","Cancel");
	if(PInfo[playerid][Rank] == 4) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 5) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper","Choose","Cancel");
	if(PInfo[playerid][Rank] == 6) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense","Choose","Cancel");
	if(PInfo[playerid][Rank] == 7) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch","Choose","Cancel");
	if(PInfo[playerid][Rank] == 8) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter","Choose","Cancel");
	if(PInfo[playerid][Rank] == 9) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer","Choose","Cancel");
	if(PInfo[playerid][Rank] == 10) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run","Choose","Cancel");
	if(PInfo[playerid][Rank] == 11) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 12) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper","Choose","Cancel");
	if(PInfo[playerid][Rank] == 13) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp","Choose","Cancel");
	if(PInfo[playerid][Rank] == 14) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 15) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig","Choose","Cancel");
	if(PInfo[playerid][Rank] == 16) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig\n16\tPopping Tires","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig\n16\tPopping Tires \n17\tHigher Jumper","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig\n16\tPopping Tires \n17\tHigher Jumper \n18\tRepellent","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig\n16\tPopping Tires \n17\tHigher Jumper \n18\tRepellent \n19\tRavaging Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] >= 20) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tMore Refreshing Bite \n15\tGod Dig\n16\tPopping Tires \n17\tHigher Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper scream","Choose","Cancel");
	return 1;
}

function ClearBurstTimer(playerid)
{
	PInfo[playerid][CanBurst] = 1;
	SendClientMessage(playerid,white,"* "cblue"You feel rested enough to burst run.");
	return 1;
}

stock SendNearMessage(playerid,color,text[],range)
{
    static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
    for(new i; i < MAX_PLAYERS;i++)
    {
    	if(!IsPlayerConnected(i)) continue;
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
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(Team[i] == ZOMBIE) continue;
    	if(IsPlayerInVehicle(i, vehicleid))
    	{
  			return 1;
		}
  	}
  	return 0;
}

stock IsVehicleStarted(vehicleid)
{
	if(VehicleStarted[vehicleid] == 1) return 1;
	else return 0;
}

stock StartVehicle(vehicleid,start=1)
{
    new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
	if(start == 1) SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_ON,lights,alarm,doors,bonnet,boot,objective),VehicleStarted[vehicleid] = 1;
	else if(start == 0) SetVehicleParamsEx(vehicleid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective),VehicleStarted[vehicleid] = 0;
	return 1;
}

UpdateVehicleFuelAndOil(vehicleid)
{
	if(Fuel[vehicleid] <= 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~EMPTY");
				GameTextForPlayer(i,"~n~~n~~r~~h~No fuel left!",4000,3);
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	if(Fuel[vehicleid] > 0 && Fuel[vehicleid] <= 10)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~l");
			}
		}
	}
	if(Fuel[vehicleid] > 10 && Fuel[vehicleid] <= 20)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll");
			}
		}
	}
	if(Fuel[vehicleid] > 20 && Fuel[vehicleid]<= 30)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~l");
			}
		}
	}
	if(Fuel[vehicleid] > 30 && Fuel[vehicleid] <= 40)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~ll");
			}
		}
	}
	if(Fuel[vehicleid] > 40 && Fuel[vehicleid] <= 50)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~lll");
			}
		}
	}
	if(Fuel[vehicleid] > 50 && Fuel[vehicleid] <= 60)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llll");
			}
		}
	}
	if(Fuel[vehicleid] > 60 && Fuel[vehicleid] <= 70)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~lllll");
			}
		}
	}
	if(Fuel[vehicleid] > 70 && Fuel[vehicleid] <= 80)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll");
			}
		}
	}
	if(Fuel[vehicleid] > 80 && Fuel[vehicleid] <= 90)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll~g~~h~l");
			}
		}
	}
	if(Fuel[vehicleid] > 90 && Fuel[vehicleid] <= 100)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
			}
		}
	}
	
	if(Oil[vehicleid] <= 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~EMPTY");
				GameTextForPlayer(i,"~n~~n~~r~~h~No oil left!",4000,3);
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	if(Oil[vehicleid] > 0 && Oil[vehicleid] <= 10)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~l");
			}
		}
	}
	if(Oil[vehicleid] > 10 && Oil[vehicleid] <= 20)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll");
			}
		}
	}
	if(Oil[vehicleid] > 20 && Oil[vehicleid] <= 30)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~l");
			}
		}
	}
	if(Oil[vehicleid] > 30 && Oil[vehicleid] <= 40)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~ll");
			}
		}
	}
	if(Oil[vehicleid] > 40 && Oil[vehicleid] <= 50)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~lll");
			}
		}
	}
	if(Oil[vehicleid] > 50 && Oil[vehicleid] <= 60)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llll");
			}
		}
	}
	if(Oil[vehicleid] > 60 && Oil[vehicleid] <= 70)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~lllll");
			}
		}
	}
	if(Oil[vehicleid] > 70 && Oil[vehicleid] <= 80)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llllll");
			}
		}
	}
	if(Oil[vehicleid] > 80 && Oil[vehicleid] <= 90)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llllll~g~~h~l");
			}
		}
	}
	if(Oil[vehicleid] > 90 && Oil[vehicleid] <= 100)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llllll~g~~h~ll");
			}
		}
	}
	return 1;
}

function Startvehicle(playerid)
{
	new rand = random(2);
	if(rand == 0) return SendClientMessage(playerid,white,"* "cred"The car has failed to start."),PInfo[playerid][StartCar] = 0;
	else
	{
	    if(Fuel[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,red,"There's no fuel in this car!"),PInfo[playerid][StartCar] = 0;
	    if(Oil[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,red,"There's no oil in this car!"),PInfo[playerid][StartCar] = 0;
	    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
	    StartVehicle(GetPlayerVehicleID(playerid),1);
	    PInfo[playerid][StartCar] = 0;
	    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
	}
	return 1;
}

stock LoadStaticVehicles()
{
	new File:file_ptr;
	new line[256];
	new var_from_line[64];
	new vehicletype;
	new Float:SpawnX;
	new Float:SpawnY;
	new Float:SpawnZ;
	new Float:SpawnRot;
    new Color1, Color2;
	new index;
	new vehicles_loaded;

	file_ptr = fopen("Admin/Allcars.txt",filemode:io_read);
	if(!file_ptr) return 0;

	vehicles_loaded = 0;

	while(fread(file_ptr,line,256) > 0)
	{
	    index = 0;

  		index = token_by_delim(line,var_from_line,',',index);
  		if(index == (-1)) continue;
  		vehicletype = strval(var_from_line);
   		if(vehicletype < 400 || vehicletype > 611) continue;

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnX = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnY = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnZ = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		SpawnRot = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		Color1 = strval(var_from_line);

  		index = token_by_delim(line,var_from_line,';',index+1);
  		if(index == (-1)) continue;
  		Color2 = strval(var_from_line);


  		AddStaticVehicle(vehicletype,SpawnX,SpawnY,SpawnZ+2,SpawnRot,Color1,Color2);
		vehicles_loaded++;
	}

	fclose(file_ptr);
	printf("Loaded %d vehicles",vehicles_loaded);
	return vehicles_loaded;
}

stock token_by_delim(const string[], return_str[], delim, start_index)
{
	new x=0;
	while(string[start_index] != EOS && string[start_index] != delim) {
	    return_str[x] = string[start_index];
	    x++;
	    start_index++;
	}
	return_str[x] = EOS;
	if(string[start_index] == EOS) start_index = (-1);
	return start_index;
}

public OnPlayerUseItem(playerid,ItemName[])
{
	static string[100];
  	if(!strcmp(ItemName,"Large Medical Kits",true))
  	{
  	    if(PInfo[playerid][SPerk] == 7 || PInfo[playerid][SPerk] == 13)
  	    {
  	        new id = -1;
  	        static Float:x,Float:y,Float:z;
			for(new i; i < MAX_PLAYERS;i++)
			{
			    if(!IsPlayerConnected(i)) continue;
			    if(Team[i] == ZOMBIE) continue;
				GetPlayerPos(playerid,x,y,z);
				if(!IsPlayerInRangeOfPoint(i,2.0,x,y,z)) continue;
				if(i == playerid) continue;
				id = i;
			}
			if(id == -1) return SendClientMessage(playerid,white,"» "cred"You aren't near a survivor!");
			new Float:health;
			GetPlayerHealth(id,health);
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player does not need medical atention.");
            SetPlayerHealth(id,health+50.0);
            format(string,sizeof string,""cjam"%s(%i) has assisted %s(%i) with a large medical kit.",GetPName(playerid),playerid,GetPName(id),id);
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 100.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        RemoveItem(playerid,"Large Medical Kits",1);
	        format(string,sizeof string,""cjam"%s(%i) has taken a large medical kit.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+50.0);
			else SetPlayerHealth(playerid,health+55.0);
		}
  	}
  	if(!strcmp(ItemName,"Medium Medical Kits",true))
  	{
  	    if(PInfo[playerid][SPerk] == 7 || PInfo[playerid][SPerk] == 13)
  	    {
  	        new id = -1;
  	        static Float:x,Float:y,Float:z;
			for(new i; i < MAX_PLAYERS;i++)
			{
			    if(!IsPlayerConnected(i)) continue;
			    if(Team[i] == ZOMBIE) continue;
				GetPlayerPos(playerid,x,y,z);
				if(!IsPlayerInRangeOfPoint(i,2.0,x,y,z)) continue;
				if(i == playerid) continue;
				id = i;
			}
			if(id == -1) return SendClientMessage(playerid,white,"» "cred"You aren't near a survivor!");
			new Float:health;
			GetPlayerHealth(id,health);
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player does not need medical atention.");
            SetPlayerHealth(id,health+20.0);
            format(string,sizeof string,""cjam"%s(%i) has assisted %s(%i) with a medium medical kit.",GetPName(playerid),playerid,GetPName(id),id);
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 100.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        RemoveItem(playerid,"Medium Medical Kits",1);
	        format(string,sizeof string,""cjam"%s(%i) has taken a medium medical kit.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+20.0);
			else SetPlayerHealth(playerid,health+25.0);
		}
  	}
  	if(!strcmp(ItemName,"Small Medical Kits",true))
  	{
  	    if(PInfo[playerid][SPerk] == 7 || PInfo[playerid][SPerk] == 13)
  	    {
  	        new id = -1;
  	        static Float:x,Float:y,Float:z;
			for(new i; i < MAX_PLAYERS;i++)
			{
			    if(!IsPlayerConnected(i)) continue;
			    if(Team[i] == ZOMBIE) continue;
				GetPlayerPos(playerid,x,y,z);
				if(!IsPlayerInRangeOfPoint(i,2.0,x,y,z)) continue;
				if(i == playerid) continue;
				id = i;
			}
			if(id == -1) return SendClientMessage(playerid,white,"» "cred"You aren't near a survivor!");
			new Float:health;
			GetPlayerHealth(id,health);
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player does not need medical atention."),SetPlayerHealth(id,100.0);
            SetPlayerHealth(id,health+8.0);
            format(string,sizeof string,""cjam"%s(%i) has assisted %s(%i) with a small medical kit.",GetPName(playerid),playerid,GetPName(id),id);
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 100.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        RemoveItem(playerid,"Small Medical Kits",1);
	        format(string,sizeof string,""cjam"%s(%i) has taken a small medical kit.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+3.0);
			else SetPlayerHealth(playerid,health+8.0);
		}
  	}
    if(!strcmp(ItemName,"Fuel",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(Fuel[vehid] >= 100) return SendClientMessage(playerid,white,"» "cred"This %s does not need anymore fuel."),GetVehicleName(vehid),Fuel[vehid] = 100;
        RemoveItem(playerid,"Fuel",1);
        format(string,sizeof string,""cjam"%s(%i) has added some fuel to his vehicle.",GetPName(playerid),playerid);
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 2) Fuel[vehid]+=12;
		else Fuel[vehid]+=7;
		if(Fuel[vehid] > 100) Fuel[vehid] = 100;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Oil",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(Oil[vehid] >= 100) return SendClientMessage(playerid,white,"» "cred"This %s does not need anymore oil."),GetVehicleName(vehid),Oil[vehid] = 100;
        RemoveItem(playerid,"Oil",1);
        format(string,sizeof string,""cjam"%s(%i) has added some oil to his vehicle.",GetPName(playerid),playerid);
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 3) Oil[vehid]+=12;
		else Oil[vehid]+=7;
		if(Oil[vehid] > 100) Oil[vehid] = 100;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Dizzy Pills",true))
    {
        if(PInfo[playerid][SPerk] != 13)
        {
        	PInfo[playerid][TokeDizzy] = 1;
        	RemoveItem(playerid,"Dizzy Pills",1);
        	format(string,sizeof string,""cjam"%s(%i) has taken some dizzy away pills.",GetPName(playerid),playerid);
        	SendNearMessage(playerid,white,string,20);
        	SetPlayerDrunkLevel(playerid,0);
  		}
  		else
  		{
  		    new id = -1;
  		    static Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			for(new i; i < MAX_PLAYERS;i++)
			{
			    if(i == playerid) continue;
			    if(!IsPlayerConnected(i)) continue;
			    if(Team[i] == ZOMBIE) continue;
			    if(IsPlayerInRangeOfPoint(i,2.0,x,y,z)) id = i;
			    else continue;
			}
			if(id == -1) return SendClientMessage(playerid,red,"You aren't near a survivor to assist!");
			PInfo[id][TokeDizzy] = 1;
        	format(string,sizeof string,""cjam"%s(%i) has assisted %s(%i) some dizzy away pills.",GetPName(playerid),playerid,GetPName(id),id);
        	SendNearMessage(playerid,white,string,20);
  		}
    }
    if(!strcmp(ItemName,"Flashlight",true))
    {
        if(PInfo[playerid][Lighton] == 1)
        {
        	RemovePlayerAttachedObject(playerid,3);
        	RemovePlayerAttachedObject(playerid,4);
        	PInfo[playerid][Lighton] = 0;
 			format(string,sizeof string,""cjam"%s has turned off his flashlight.",GetPName(playerid));
			SendNearMessage(playerid,white,string,30);
        }
        else
        {
        	SetPlayerAttachedObject(playerid, 3,18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
        	SetPlayerAttachedObject(playerid, 4,354,5,0.10,0.03,-0.12,0.0,451.0,-190.0,0.00,0.92,1.00);
        	PInfo[playerid][Lighton] = 1;
 			format(string,sizeof string,""cjam"%s has turned on his flashlight.",GetPName(playerid));
			SendNearMessage(playerid,white,string,30);
       	}
    }
	if(!strcmp(ItemName,"Molotovs Guide"))
	{
	    RemoveItem(playerid,"Molotovs Guide",1);
	    new rand = random(2);
		switch(rand)
		{
		    case 0: SendClientMessage(playerid,white,"* "corange"Head over to Pig Pen to get some alcohol"),Mission[playerid] = 1, MissionPlace[playerid][0] = 1, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[0][3],Locations[0][4],Locations[0][5],62,0,MAPICON_GLOBAL);
			case 1: SendClientMessage(playerid,white,"* "corange"Head over to Alhambra to get some alcohol"),Mission[playerid] = 1, MissionPlace[playerid][0] = 2, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[1][3],Locations[1][4],Locations[1][5],62,0,MAPICON_GLOBAL);
		}
	}
  	return 0;
}

function StopBait(playerid)
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
   		if(PInfo[i][Dead] == 1) continue;
	    if(Team[i] == HUMAN) continue;
		if(IsPlayerInRangeOfPoint(i,15.0,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
		{
		    ClearAnimations(i,1);
		}
	}
	PInfo[playerid][ZX] = 0.0;
	DestroyObject(PInfo[playerid][ZObject]);
	PInfo[playerid][ZombieBait] = 0;
	return 1;
}

function CanUseFiremode(playerid)
{
	PInfo[playerid][FireMode] = 0;
	return 1;
}

function AffectFire(playerid,id)
{
	if(PInfo[playerid][OnFire] == 5)
	{
		PInfo[playerid][OnFire] = 0;
		DestroyObject(PInfo[playerid][FireObject]);
	}
	else
	{
	    SetTimerEx("AffectFire",500,false,"ii",playerid,id);
        static Float:health;
		GetPlayerHealth(playerid,health);
		SetPlayerHealth(playerid,health-4);
		GetPlayerHealth(playerid,health);
		PInfo[playerid][OnFire]++;
	}
	return 1;
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

GetWeaponType(weaponid)
{
	switch(weaponid)
	{
	    case 22,23,24,26,28,32:
	        return WEAPON_TYPE_LIGHT;

		case 3,4,16,17,18,39,10,11,12,13,14,40,41:
		    return WEAPON_TYPE_MELEE;

		case 2,5,6,7,8,9,25,27,29,30,31,33,34,35,36,37,38:
		    return WEAPON_TYPE_HEAVY;
	}
	return WEAPON_TYPE_NONE;
}

stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}

function UnloadMusic(playerid)
{
    StopAudioStreamForPlayer(playerid);
    return 1;
}

function RandomSounds()
{
    for(new i; i < MAX_PLAYERS;i++)
	{
        if(!IsPlayerConnected(i)) continue;
	    new rand2 = random(5);
		if(rand2 == 1){ PlayAudioStream(i,"http://k004.kiwi6.com/hotlink/oy385dubfq/1.mp3",4)}
		else if(rand2 == 2){ PlayAudioStream(i,"http://k004.kiwi6.com/hotlink/qzgzjb4lqa/2.mp3",4)}
		else if(rand2 == 3){ PlayAudioStream(i,"http://k004.kiwi6.com/hotlink/oy385dubfq/1.mp3",4)}
		else if(rand2 == 4){ PlayAudioStream(i,"http://k004.kiwi6.com/hotlink/qzgzjb4lqa/2.mp3",4)}
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

stock IsPlayerBehindPlayer(playerid, targetid, Float:dOffset)
{

	new
	    Float:pa,
	    Float:ta;

	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;

	GetPlayerFacingAngle(playerid, pa);
	GetPlayerFacingAngle(targetid, ta);

	if(AngleInRangeOfAngle(pa, ta, dOffset) && IsPlayerFacingPlayer(playerid, targetid, dOffset)) return true;

	return false;

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

stock AngleInRangeOfAngle(Float:a1, Float:a2, Float:range)
{
	a1 -= a2;
	if((a1 < range) && (a1 > -range)) return true;
	return false;
}

function ClearAnim(playerid)
{
	ClearAnimations(playerid,1);
	return 1;
}

function ClearAnim2(playerid)
{
	ClearAnimations(playerid,1);
	TogglePlayerControllable(playerid,1);
	return 1;
}

function RemoveStomp(playerid)
{
	TogglePlayerControllable(playerid,1);
	return 1;
}


function DigToPlayer(playerid,id)
{
	ClearAnimations(playerid);
	new Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(playerid,x,y+2,z+2);
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	return 1;
}

function Marker()
{
	static rand,Float:x,Float:y,Float:z;
	for(new i; i < MAX_PLAYERS;i++)
	{
	    GetPlayerPos(i,x,y,z);
	    if(Team[i] == ZOMBIE)
	    {
		    for(new f; f < MAX_PLAYERS;f++)
		    {
		        if(Team[f] == ZOMBIE)
		        {
		            rand = random(3);
			        if(rand == 1)
			        {
				        SetPlayerMarkerForPlayer(f,i,purple);
			        }
			        if(PInfo[f][ZPerk] == 5)
			        {
			            if(Team[i] == ZOMBIE)
			            {
			            	SetPlayerMarkerForPlayer(f,i,purple);
		            	}
			        }
		        }
		    }
	    }
	    if(Team[i] == HUMAN)
	    {
	        GetPlayerPos(i,x,y,z);
	        for(new f; f < MAX_PLAYERS;f++)
		    {
		        if(Team[f] == ZOMBIE)
		        {
		            if(!IsPlayerInRangeOfPoint(f,100,x,y,z)) continue;
			        rand = random(3);
			        if(rand == 1)
			        {
				        SetPlayerMarkerForPlayer(f,i,green);
			        }
		        }
		    }
	    }
	}
	return 1;
}

function VomitPlayer(playerid)
{
	DestroyObject(PInfo[playerid][Vomit]);
    PInfo[playerid][Vomit] = CreateObject(2905,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-1.0,0,0,0,200);
    PInfo[playerid][Allowedtovomit] = GetTickCount();
	PInfo[playerid][Vomitmsg] = 0;
	return 1;
}

function MakeHealthEven(playerid,Float:health)
{
	if(health == 1) return SetPlayerHealth(playerid,2);
	if(health == 3) return SetPlayerHealth(playerid,4);
	if(health == 5) return SetPlayerHealth(playerid,6);
	if(health == 7) return SetPlayerHealth(playerid,8);
	if(health == 9) return SetPlayerHealth(playerid,10);
	if(health == 11) return SetPlayerHealth(playerid,12);
	if(health == 13) return SetPlayerHealth(playerid,14);
	if(health == 15) return SetPlayerHealth(playerid,16);
	if(health == 17) return SetPlayerHealth(playerid,18);
	if(health == 19) return SetPlayerHealth(playerid,20);
	if(health == 21) return SetPlayerHealth(playerid,22);
	if(health == 23) return SetPlayerHealth(playerid,24);
	if(health == 25) return SetPlayerHealth(playerid,26);
	if(health == 27) return SetPlayerHealth(playerid,28);
	if(health == 29) return SetPlayerHealth(playerid,30);
	if(health == 31) return SetPlayerHealth(playerid,32);
	if(health == 33) return SetPlayerHealth(playerid,34);
	if(health == 35) return SetPlayerHealth(playerid,36);
	if(health == 37) return SetPlayerHealth(playerid,38);
	if(health == 39) return SetPlayerHealth(playerid,40);
	if(health == 41) return SetPlayerHealth(playerid,42);
	if(health == 43) return SetPlayerHealth(playerid,44);
	if(health == 45) return SetPlayerHealth(playerid,46);
	if(health == 47) return SetPlayerHealth(playerid,48);
	if(health == 49) return SetPlayerHealth(playerid,50);
	return 1;
}

function FiveSeconds()
{
	new infects;
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	if(infects > 0)
	{
		static string2[24];
		format(string2,sizeof string2,"Infection: ~r~~h~%i%%", floatround(100.0 * floatdiv(infects, PlayersConnected)));
		TextDrawSetString(Infection,string2);
		if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 100)
		{
		    if(RoundEnded == 0)
		    {
				//SetTimerEx("EndRound",3000,false,"i",1);
				GameTextForAll("~w~The round has ended.",3000,3);
				RoundEnded = 1;
			}
		}
		infects = 0;
	}
	else TextDrawSetString(Infection,"Infection: ~r~~h~0%");
	if(CPscleared >= 8)
	{
	    if(RoundEnded == 0)
	    {
	    	SetTimerEx("EndRound",3000,false,"i",2);
			GameTextForAll("~w~The round has ended.",3000,3);
			RoundEnded = 1;
		}
	}
	return 1;
}

function EndRound(win)
{
 	new number,there,idk,idd,idi,maxk,maxd,maxi,string[160];
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][KillsRound] > maxk) idk = i, maxk = PInfo[i][KillsRound];
	    if(PInfo[i][DeathsRound] > maxd) idd = i, maxd = PInfo[i][DeathsRound];
	    if(PInfo[i][InfectsRound] > maxi) idi = i, maxi = PInfo[i][InfectsRound];
	    if(number >= 30)
	    {
	        SetPlayerPos(i,RandomEnd[random(sizeof(RandomEnd))][0],EndPos[random(sizeof(RandomEnd))][1],EndPos[random(sizeof(RandomEnd))][2]);
            SetPlayerFacingAngle(i,352.1313);
		}
        for(new j; j < MAX_PLAYERS;j++)
		{
			if(IsPlayerInRangeOfPoint(j,0.1,EndPos[number][0],EndPos[number][1],EndPos[number][2]))
				there = 1;
		}
		if(there == 0) SetPlayerPos(i,EndPos[number][0],EndPos[number][1],EndPos[number][2]+1),number++,there = 0;
		TogglePlayerControllable(i,0);
		SetPlayerCameraPos(i,258.6558,-1815.2397,42.8338);
		SetPlayerCameraLookAt(i,258.1187,-1855.8759,3.0612);
		SetPlayerFacingAngle(i,352.1313);
		SetPlayerWeather(i,1);
		PlaySound(i,1076);
	}
	number = 0;
	format(string,sizeof string,"~g~~h~Most Kills: ~w~%s ~n~~g~~h~Most Deaths: ~w~%s ~n~~g~~h~Most Infects: ~w~%s",
	    GetPName(idk),GetPName(idd),GetPName(idi));
	TextDrawSetString(RoundStats,string);
	TextDrawShowForAll(RoundStats);
	for(new f; f < sizeof(EndPos);f++)
	{
	    for(new i; i < MAX_PLAYERS;i++)
		{
	    	if(IsPlayerInRangeOfPoint(i,0.1,EndPos[f][0],EndPos[f][1],EndPos[f][2]))
	    	continue;
 		}
	    EndObjects[f] = CreateObject(3461,EndPos[f][0],EndPos[f][1],EndPos[f][2]-0.5,0,0,0,300);
	}
	if(win == 1) GameTextForAll("~r~~h~100% of zombie infection!",4500,3);
	else GameTextForAll("~g~~h~Humans have cleared all the ~n~~r~~h~checkpoints~g~~h~!",3000,3);
	SetTimer("EndRound2",3500,false);
	return 1;
}

function EndRound2()
{
    SetTimer("EndRoundFinal",5000,false);
    GameTextForAll("~b~~h~Thanks for playing",4500,3);
	return 1;
}

function EndRoundFinal()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		GameTextForPlayer(i,"~y~Please wait, you are being ~n~~g~~h~reconnected!",6000,3);
	}
	SendRconCommand("gmx");
	return 1;
}

function AllowedToStomp(playerid)
{
	SendClientMessage(playerid,red,"» You feel rested to send a mini earthquake (stomp ready)");
	PInfo[playerid][CanStomp] = 1;
	return 1;
}

function PopAgain(playerid)
{
	PInfo[playerid][CanPop] = 1;
	return 1;
}

function Float:GetDistanceBetweenPoints(Float:rx1,Float:ry1,Float:rz1,Float:rx2,Float:ry2,Float:rz2)
{
    return floatadd(floatadd(floatsqroot(floatpower(floatsub(rx1,rx2),2)),floatsqroot(floatpower(floatsub(ry1,ry2),2))),floatsqroot(floatpower(floatsub(rz1,rz2),2)));
}

stock GetClosestPlayer(playerid,Float:limit)
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid,x1,y1,z1);
    new Float:Range = 999.9;
    new id = -1;
    for(new i; i < MAX_PLAYERS;i++)
    {
        if(playerid != i)
        {
            GetPlayerPos(i,x2,y2,z2);
            new Float:Dist = GetDistanceBetweenPoints(x1,y1,z1,x2,y2,z2);
            if(floatcmp(Range,Dist) == 1 && floatcmp(limit,Range) == 1)
            {
                Range = Dist;
                id = i;
            }
        }
    }
    return id;
}

function Flashbang(playerid)
{
	TextDrawShowForPlayer(playerid,Effect[0]);
	SetTimerEx("Flashbang2", 3500, false, "i", playerid);
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	PlayerPlaySound(playerid,1159,X,Y,Z);
	return 1;
}

function Flashbang2(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[0]);
	TextDrawShowForPlayer(playerid,Effect[1]);
	SetTimerEx("Flashbang3", 2000, false, "i", playerid);
	return 1;
}
function Flashbang3(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[1]);
	TextDrawShowForPlayer(playerid,Effect[2]);
	SetTimerEx("Flashbang4", 600, false, "i", playerid);
	return 1;
}

function Flashbang4(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[2]);
	TextDrawShowForPlayer(playerid,Effect[3]);
	SetTimerEx("Flashbang5", 600, false, "i", playerid);
	return 1;
}

function Flashbang5(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[3]);
	TextDrawShowForPlayer(playerid,Effect[4]);
	SetTimerEx("Flashbang6", 600, false, "i", playerid);
	return 1;
}

function Flashbang6(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[4]);
	TextDrawShowForPlayer(playerid,Effect[5]);
	SetTimerEx("Flashbang7", 600, false, "i", playerid);
	return 1;
}

function Flashbang7(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[6]);
	TextDrawShowForPlayer(playerid,Effect[7]);
	SetTimerEx("Flashbang8", 600, false, "i", playerid);
	return 1;
}

function Flashbang8(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[7]);
	TextDrawShowForPlayer(playerid,Effect[8]);
	SetTimerEx("Flashbang9", 600, false, "i", playerid);
	return 1;
}

function Flashbang9(playerid)
{
	for(new i; i < 8; i++)
		TextDrawHideForPlayer(playerid,Effect[i]);
	return 1;
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

function GivePlayerXP(playerid)
{
	if(Team[playerid] == ZOMBIE)
	{
     	if(PInfo[playerid][ShowingXP] == 0)
	    {
			static string[7];
		 	if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 22;PInfo[playerid][CurrentXP] = 22;}
			else {PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			TextDrawSetString(GainXPTD[playerid],string);
			PInfo[playerid][ShowingXP] = 1;
			SetTimerEx("ShowXP1",300,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
		    PlaySound(playerid,1083);
		}
		else
		{
		    static string[7];
			if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 22;PInfo[playerid][CurrentXP] = 22;}
			else {PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
		    TextDrawSetString(GainXPTD[playerid],string);
		    PlaySound(playerid,1083);
		}
	}
	else
	{
	    if(PInfo[playerid][ShowingXP] == 0)
  		{
			static string[7];
			if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 22;PInfo[playerid][CurrentXP] = 22;}
			else {PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			TextDrawSetString(GainXPTD[playerid],string);
			PInfo[playerid][ShowingXP] = 1;
		    SetTimerEx("ShowXP1",300,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
		    PlaySound(playerid,1083);
		}
		else
		{
	        static string[7];
            if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 22;PInfo[playerid][CurrentXP] = 22;}
			else {PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			PInfo[playerid][InfectsRound]++;
	        format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	        TextDrawSetString(GainXPTD[playerid],string);
	        PlaySound(playerid,1083);

		}
	}
	return 1;
}

function DamagePlayer(playerid,i)
{
	new Float:Health;
    GetPlayerHealth(i,Health);
    if(Health >= 1 && Health <= 10)
		SetPlayerHealth(i,5);
    if(PInfo[playerid][ZPerk] == 18)
	{
	    if(PInfo[i][SPerk] != 5)
		{
		    if(Health <= 10 && Health > 0)
		    	MakeProperDamage(i);
			else
			    MakeProperDamage(i);
		}
		else
		{
		    if(Health <= 8 && Health > 0)
		    	MakeProperDamage(i);
			else
			    MakeProperDamage(i);
		}
		GetPlayerHealth(playerid,Health);
		if(Health >= 100.0) SetPlayerHealth(playerid,100.0);
		else SetPlayerHealth(playerid,Health+6);
	}
	else if(PInfo[i][SPerk] == 5)
	{
		GetPlayerHealth(i,Health);
		if(PInfo[playerid][ZPerk] == 1)
		{
			if(Health <= 10 && Health > 0)
		    	MakeProperDamage(i);
			else
			    MakeProperDamage(i);
		}
		else SetPlayerHealth(i,Health-4);
	}
    else
	{
		GetPlayerHealth(i,Health);
    	if(PInfo[playerid][ZPerk] == 1)
		{
      		SetPlayerHealth(i,Health-12);
		}
		else if(PInfo[playerid][ZPerk] != 18)
		{
   			SetPlayerHealth(i,Health-8);
		}
	}
 	GetPlayerHealth(i,Health);
	if(Health <= 5)
	{
	    PInfo[playerid][Kills]++;
	    GivePlayerXP(playerid);
		PInfo[playerid][JustInfected] = 1;
		PInfo[playerid][Deaths]++;
		Team[playerid] = ZOMBIE;
        GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
  		SetPlayerColor(playerid,purple);
	}
	return 1;
}

function MakeProperDamage(playerid)
{
	new Float:Health;
	GetPlayerHealth(playerid,Health);
	if(Health <= 10 && Health >= 5)
	    SetPlayerHealth(playerid,4);
	else if(Health <= 5 && Health > 0)
	    SetPlayerHealth(playerid,1);
	return 1;
}

function ResetRunVar(playerid,var)
{
	if(var == 1)
	{
	    if(Team[playerid] == HUMAN)
	    {
     		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PED","run_stopr",10,1,1,1,0,1,1);
     		PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",120000,false,"ii",playerid,2);
     		PInfo[playerid][CanRun] = 0;
	    }
	}
	if(var == 2)
	{
	    if(Team[playerid] == HUMAN)
	    {
	        SendClientMessage(playerid,white,"*"cred"You feel rested enough to run faster (more stamina ready)");
	        PInfo[playerid][CanRun] = 1;
	        PInfo[playerid][RunTimerActivated] = 0;
	    }
	}
	return 1;
}

stock BanPlayer(playerid)
	return BanEx(playerid,"Ban evading");

function ResetDigVar(playerid)
	return PInfo[playerid][CanDig] = 1, SendClientMessage(playerid,red,"You have enough energy to dig again. (digger ready)");

stock GetIP(playerid)
{
	new ip[16];
	GetPlayerIp(playerid,ip,16);
	return ip;
}

function SetPlayerHealthRank(playerid)
{
	if(PInfo[playerid][Rank] == 1) SetPlayerHealth(playerid,10);
	if(PInfo[playerid][Rank] == 2) SetPlayerHealth(playerid,15);
	if(PInfo[playerid][Rank] == 3) SetPlayerHealth(playerid,20);
	if(PInfo[playerid][Rank] == 4) SetPlayerHealth(playerid,25);
	if(PInfo[playerid][Rank] == 5) SetPlayerHealth(playerid,30);
	if(PInfo[playerid][Rank] == 6) SetPlayerHealth(playerid,35);
	if(PInfo[playerid][Rank] == 7) SetPlayerHealth(playerid,40);
	if(PInfo[playerid][Rank] == 8) SetPlayerHealth(playerid,50);
	if(PInfo[playerid][Rank] == 9) SetPlayerHealth(playerid,60);
	if(PInfo[playerid][Rank] == 10) SetPlayerHealth(playerid,70);
	if(PInfo[playerid][Rank] == 11) SetPlayerHealth(playerid,80);
	if(PInfo[playerid][Rank] == 12) SetPlayerHealth(playerid,85);
	if(PInfo[playerid][Rank] == 13) SetPlayerHealth(playerid,90);
	if(PInfo[playerid][Rank] == 14) SetPlayerHealth(playerid,95);
    if(PInfo[playerid][Rank] >= 15) SetPlayerHealth(playerid,100);
	return 1;
}
