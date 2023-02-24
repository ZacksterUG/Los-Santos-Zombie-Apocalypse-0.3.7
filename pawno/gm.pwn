 //======================= Inventory system copied =============================
#include <a_samp>
#include <SII>
#include <zcmd>
#include <sscanf2>
#include <GetVehicleColor>
#include <j_inventory_v2>
#include <GetVehicleName>
#include <streamer>
#include <a_npc>
#include <Offsets>
#include <F_AntiCheat>
#include <a_objects>
#include <colors>
#include <streamer>

#define Userfile 														"Admin/Users/%s.ini"
#define snowing                                                         true
#define Version                                                         "0.2"
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     50
#define CPTIME                                                          300000//Time between each checkpoint
#define CPVALUE                                                         250//CPValue, the value of, when it gets reached, it the cp gets cleared.
#define DIGTIME                                                         120000//Time of cooldown between digging.
#define VOMITTIME                                                       90000//Time of cooldown between vomitting.
#define eGivePlayerMoney(%0,%1); SetPVarInt(%0,"Cash",GetPVarInt(%0,"Cash")+%1); ResetPlayerMoney(%0); GivePlayerMoney(%0,GetPVarInt(%0,"Cash"));
#define eGetPlayerMoney(%0) GetPVarInt(%0,"Cash")
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
#define Help                                                            1000
#define HelpMode                                                        1001
#define HelpHuman                                                       1002
#define HelpZombie                                                      1003
#define HelpRule                                                        1004
#define HiveTP                                                          1100
forward AnticheatSH();
forward OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
forward pingchecktimer(playerid);
//============================== [Dialogs] =====================================
//============================== [RRGGBB] ======================================
#define cwhite															"{EEFFFF}"
#define cligreen                                                        "{44CC22}"
#define cred                                                            "{FF1111}"
#define cgreen                                                          "{05E200}"
#define cblue                                                           "{00B9FF}"
#define cjam                                                            "{E67EF8}"
#define corange                                                         "{FF9600}"
#define cgrey                                                           "{CCCCCC}"
#define cgold                                                           "{FFBB00}"
#define cplat                                                           "{666666}"
#define cyellow            								    		    "{FFFF00}"
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
#define DSL 															DIALOG_STYLE_LIST
#define DSI 															DIALOG_STYLE_INPUT
#define DSM 															DIALOG_STYLE_MSGBOX
#define DSP 															DIALOG_STYLE_PASSWORD
//============================== [Server config] ===============================
//============================== [Text Draw's] =================================
forward UnFreezePlayer(playerid);
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
new PlayerText:XPtextdraw[MAX_PLAYERS][5];
//============================== [Text Draw's] =================================
new TT;
new TT1;
new TT2;
new TT3;
new TT4;
new TT5;
new TT6;
new TT7;
new TT8;
new TT9;                                                                	 
new TTT6;
new TTT7;
new TTT8;
new TTT9;
new TTT10;
new TTT11;
new TTT12;
new TTT13;
new TTT14;
new TTT15;
new TTT16;
new TTT17;
new TTT18;
new TTT19;
new TTT20;
new TTT21;
new TTT22;
new TTT23;
new TTT24;
new TTT25;
new TTT26;
new TTT27;
new TTT28;
new TTT29;
new TTT30;
new TTT31;
new TTT32;
new TTT33;
new TTT34;
new
    Float:g_Pos[MAX_PLAYERS][3],
    bool:g_EnterAnim[MAX_PLAYERS char]
;
new NoReloading[MAX_PLAYERS];
new CurrentWeapon[MAX_PLAYERS];
new CurrentAmmo[MAX_PLAYERS];
new Float:VehPos[MAX_VEHICLES][4];
new bool: BanCar[MAX_VEHICLES];
new TimeUpdate[MAX_PLAYERS];
forward UpdateVehiclePos(vehicleid, type);
bool: UseCar(carid);
//bool: StopCar(carid);
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

new Float:Randomspawns[11][4] =
{
    {1037.6025,-1338.8661,13.7266,350.6576},
    {1135.9752,-1078.2261,29.3813,267.7698},
    {2219.8853,-1179.1018,29.7971,359.8046},
    {2386.7600,-1278.3578,24.5882,84.2302},
    {1845.4375,-1605.4202,13.5469,178.9726},
    {1552.2366,-1675.5055,16.1953,84.7522},
    {1568.4967,-1691.3040,5.8906,177.4267},
    {823.9662,-1612.5967,13.5469,297.7924},
    {1447.5587,-2286.4753,13.5469,90.1755},
	{2026.0203,-1422.5536,16.9922,134.0924},
    {2749.2595,-1205.5306,67.4844,85.0762}
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

new Float:Platspawns[4][4] =
{
    {2653.0486,-1387.5162,30.4438,91.7624},
    {2773.9868,-1834.6229,10.3125,199.9468},
    {970.7773,-1829.5486,12.6970,166.8507},
    {348.7736,-1347.1180,14.5078,115.5182}
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

enum
{
	CommonRed = 19006,
	CommonOrange,
	CommonGreen,
	CommonBlue,
	CommonPurple,
	CommonEspiral,
	CommonBlack,
	CommonEyes,
	CommonXadrex,
	CommonTransparent,
	CommonXRayVision,
	SquareFormatYellow,
	SquareFormatOrange,
	SquareFormatRed,
	SquareFormatBlue,
	SquareFormatGreen,
	RayBanGray,
	RayBanBlue,
	RayBanPurple,
	RayBanPink,
	RayBanRed,
	RayBanOrange,
	RayBanYellow,
	RayBanGreen,
	CircularNormal,
	CircularYellow,
	CircularRed,
	CircularBlack,
	CircularXadrex,
	CircularThunders,
	CopGlassesBlack = 19138,
	CopGlassesRed = 19139,
	CopGlassesBlue = 19140,
};

static invalidskins[] =
{1,2,3,4,5,7,12,15,17,18,21,23,26,27,30,32,33,34,40,41,50,51,60,64,73,76,85,98,103,106,114,118,136,142,148,152,154,157,160,166,172,197,204,207,214,241,245,248,252,254,259,268,269,272,276,277,278,282,283,284,286,287,288,292};

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
	BettyMission,
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
	PlantedBettys,
	BettyObj1,
	BettyObj2,
	BettyObj3,
	BettyActive1,
	BettyActive2,
	BettyActive3,
	Bettys,
	oslotglasses,
	oslothat,
	Swimming,
}

static Team[MAX_PLAYERS];
new PInfo[MAX_PLAYERS][PlayerInfo];
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
new MyFirstNPCVehicle; //Global variable!
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
new NZGate;
new NZGateOpened;
new gRandomSkin[] = {134,135,137,160,162,168,200,212,230,239,74};
new bRandomSkin[] = {1,2,3,4,5,6,7,8,9,10,279,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,92,93,94,95,96,97,98,99,100,101,128,129,130,131,132,133,136,138,139,140,141,142,143,144,145,146,147,
148,149,150,151,152,153,154,155,156,157,158,159,161,163,164,165,166,167,170,171,172,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,196,197,198,199,201,202,203,204,205,206,207,208,209,210,211,213,215,216,217,218,219,220,221,222,223,225,226,227,228,229,231,232,233,234,235,236,237,238,240,241,242,243,244,245,247,248,249,250,251,252,253,254,255,267,268,
289,290,291,293,295,296,297,298,299};

public OnGameModeInit()
{
	SendRconCommand("hostname [iG] LS Zombie Apocalypse "Version"");
	SetGameModeText("LS Zombie Apocalypse");
	AddPlayerClass(1,0,0,0,0,0,0,0,0,0,0);
	AddPlayerClass(135,0,0,0,0,0,0,0,0,0,0);
	SetTimer("UpdateStats",2000,true);
	SetTimer("Marker",20000,true);
	SetTimer("Dizzy",60000,true);
	SetTimer("WeatherUpdate",53213561328321132132236535631265312658863528213,false);
	SetTimer("RandomCheckpoint",CPTIME,false);
	SetTimer("RandomSounds",120000,true);
	SetTimer("FiveSeconds",5000,true);
    ConnectNPC("sgt_soup","sgt_soup");
    MyFirstNPCVehicle = CreateVehicle(425, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	WeatherUpdate();
	LoadStaticVehicles();
	LimitPlayerMarkerRadius(100.0);
	CPID = -1;
	CPscleared = 0;
	RoundEnded = 0;
	NZGateOpened = 0;
	SetTimer("Anticheat",2000,1);
	EnableStuntBonusForAll(0);
	TT = CreatePickup(1559,2,1458.7074,-1430.6497,1720.4985);
	TT1 = CreatePickup(1559,2,1462.4375,-1467.2135,1721.5599);
	TT2 = CreatePickup(1559,2,1450.9314,-1488.1682,1721.1958);
	TT3 = CreatePickup(1559,2,1399.7649,-1506.8932,1721.1958);
	TT4 = CreatePickup(1559,2,1372.6307,-1512.8657,1721.3232);
	TT5 = CreatePickup(1559,2,1339.1144,-1484.4552,1720.9534);
	TT6 = CreatePickup(1559,2,1327.7731,-1452.2084,1721.5234);
	TT7 = CreatePickup(1559,2,1360.9810,-1405.4237,1722.0536);
	TT8 = CreatePickup(1559,2,1403.0552,-1403.0778,1721.1477);
	TT9 = CreatePickup(1559,2,1438.5690,-1404.2256,1721.1519);
	TTT6 = CreatePickup(1559,2,2621.2690,-1467.5936,18.6715);
	TTT7 = CreatePickup(1559,2,2605.9441,-1470.8939,18.6715);
	TTT8 = CreatePickup(1559,2,2592.4014,-1470.0280,20.5750);
	TTT10 = CreatePickup(1559,2,1893.3740,-1821.3843,8.0461);
	TTT11 = CreatePickup(1559,2,1874.1486,-1817.0303,7.8414);
	TTT12 = CreatePickup(1559,2,1113.4614,-1888.0632,14.5664);
	TTT13 = CreatePickup(1559,2,1103.2953,-1887.3031,14.5664);
	TTT14 = CreatePickup(1559,2,1096.5768,-1875.5582,13.5469);
	TTT15 = CreatePickup(1559,2,1084.3021,-1883.8961,13.9107);
	TTT16 = CreatePickup(1559,2,871.0971,-1363.0703,14.2783);
	TTT17 = CreatePickup(1559,2,865.1115,-1367.5701,14.2783);
	TTT18 = CreatePickup(1559,2,848.9769,-1360.8656,14.2783);
	TTT19 = CreatePickup(1559,2,876.1503,-1353.3390,14.2783);
	TTT20 = CreatePickup(1559,2,759.7245,-1028.0769,26.2289);
 	TTT21 = CreatePickup(1559,2,760.2957,-1022.6163,26.2289);
	TTT22 = CreatePickup(1559,2,764.3557,-1013.0557,26.2289);
	TTT23 = CreatePickup(1559,2,1875.9561,-965.1071,48.7348);
	TTT24 = CreatePickup(1559,2,1884.6813,-973.9438,47.5915);
	TTT25 = CreatePickup(1559,2,1884.3492,-961.9864,52.1129);
	TTT26 = CreatePickup(1559,2,1415.2230,-1318.9822,10.3281);
	TTT27 = CreatePickup(1559,2,1406.2980,-1315.1071,10.3281);
	TTT28 = CreatePickup(1559,2,1995.7878,-2032.9592,14.0830);
	TTT29 = CreatePickup(1559,2,1993.7446,-2017.1989,14.0830);
	TTT30 = CreatePickup(1559,2,2007.4463,-2044.3336,14.0830);
	TTT31 = CreatePickup(1559,2,359.2330,-1744.2981,6.9101);
	TTT32 = CreatePickup(1559,2,359.7314,-1748.2804,6.9101);
	TTT33 = CreatePickup(1559,2,359.1427,-1736.2842,6.9101);
	TTT34 = CreatePickup(1559,2,370.9857,-1725.7712,8.0016);
		//PIPES TP Hive
    CreateDynamicObject(3865,1884.3270300,-1816.4749800,8.7680000,22.0000000,0.0000000,0.0000000); //object(concpipe_sfxrf) (1)
	CreateDynamicObject(3865,1894.1660200,-1818.9100300,9.1680000,21.9950000,0.0000000,343.2480000); //object(concpipe_sfxrf) (2)
	CreateDynamicObject(3865,1874.6120600,-1814.0460200,8.9430000,21.9950000,0.0000000,355.2460000); //object(concpipe_sfxrf) (3)
	CreateDynamicObject(3865,1901.6009500,-1840.0579800,9.1930000,19.4950000,0.0000000,167.9930000); //object(concpipe_sfxrf) (4)
	CreateDynamicObject(3865,1911.3570600,-1842.2550000,9.2680000,18.9950000,0.0000000,167.9920000); //object(concpipe_sfxrf) (5)
	CreateDynamicObject(3865,1921.1120600,-1844.4520300,9.2430000,17.7120000,10.5030000,170.0140000); //object(concpipe_sfxrf) (6)
	CreateDynamicObject(14578,1889.1419700,-1827.3029800,3.8930000,0.0000000,0.0000000,346.0000000); //object(mafcaspipes01) (1)
	CreateDynamicObject(14578,1897.2530500,-1826.2159400,3.8930000,0.0000000,0.0000000,165.9980000); //object(mafcaspipes01) (2)
	CreateDynamicObject(14578,1907.9520300,-1832.6829800,3.8930000,0.0000000,0.0000000,165.9980000); //object(mafcaspipes01) (3)
	CreateDynamicObject(14578,1873.5389400,-1823.7619600,3.4680000,0.0000000,182.0000000,348.4980000); //object(mafcaspipes01) (4)
	CreateDynamicObject(14578,1861.1290300,-1825.0000000,3.6180000,0.0000000,180.2500000,348.4970000); //object(mafcaspipes01) (5)
	CreateDynamicObject(14578,1854.2580600,-1820.5109900,3.6180000,0.0000000,180.2470000,167.9920000); //object(mafcaspipes01) (6)
	CreateDynamicObject(14578,1909.6450200,-1825.7919900,4.2180000,2.0000000,180.0000000,345.9980000); //object(mafcaspipes01) (7)
	CreateDynamicObject(18739,1905.4520300,-1837.3360600,3.0410000,0.0000000,0.0000000,0.0000000); //object(water_fountain) (1)
	CreateDynamicObject(18739,1894.7440200,-1830.9709500,4.0160000,0.0000000,0.0000000,0.0000000); //object(water_fountain) (2)
	CreateDynamicObject(18739,1891.6209700,-1822.6209700,4.0160000,0.0000000,0.0000000,0.0000000); //object(water_fountain) (3)
	CreateDynamicObject(18739,1853.2049600,-1821.8709700,4.0160000,0.0000000,0.0000000,350.0000000); //object(water_fountain) (4)
	CreateDynamicObject(4206,1874.1679700,-1824.8740200,3.0570000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (1)
	CreateDynamicObject(4206,1893.3499800,-1825.6810300,3.0320000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (2)
	CreateDynamicObject(4206,1908.8179900,-1829.7740500,3.0070000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (3)
	CreateDynamicObject(4206,1854.9649700,-1818.6679700,3.1070000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (4)
	CreateDynamicObject(4206,1926.3590100,-1835.6469700,3.0070000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (5)
	CreateDynamicObject(854,1884.5730000,-1815.8960000,9.0770000,63.5020000,351.5710000,357.8050000); //object(cj_urb_rub_3b) (1)
	CreateDynamicObject(854,1883.7950400,-1815.4520300,9.6020000,5.1160000,65.7520000,259.3470000); //object(cj_urb_rub_3b) (2)
	CreateDynamicObject(854,1885.0880100,-1815.6460000,9.6020000,5.1140000,65.7480000,259.3430000); //object(cj_urb_rub_3b) (3)
	CreateDynamicObject(854,1884.6650400,-1815.5730000,9.8520000,5.1140000,65.7480000,259.3430000); //object(cj_urb_rub_3b) (4)
	CreateDynamicObject(854,1884.5760500,-1816.4179700,8.1020000,5.1140000,65.7480000,259.3430000); //object(cj_urb_rub_3b) (5)
	CreateDynamicObject(854,1884.9000200,-1816.2380400,8.7270000,5.1140000,65.7480000,262.3430000); //object(cj_urb_rub_3b) (6)
	CreateDynamicObject(854,1883.9950000,-1816.1510000,8.5020000,5.1140000,65.7420000,262.3430000); //object(cj_urb_rub_3b) (7)
	CreateDynamicObject(854,1883.3139600,-1815.5820300,9.2270000,5.1140000,65.7420000,253.8430000); //object(cj_urb_rub_3b) (8)
	CreateDynamicObject(854,1883.5429700,-1815.1440400,9.9270000,5.8780000,61.7980000,262.4670000); //object(cj_urb_rub_3b) (9)
	CreateDynamicObject(854,1884.2889400,-1814.9150400,10.6020000,4.4260000,69.1810000,261.7990000); //object(cj_urb_rub_3b) (10)
	CreateDynamicObject(854,1883.7149700,-1815.1070600,10.4020000,6.5170000,58.3320000,258.5860000); //object(cj_urb_rub_3b) (11)
	CreateDynamicObject(854,1874.4580100,-1813.2650100,9.2650000,66.4200000,354.9950000,354.5890000); //object(cj_urb_rub_3b) (12)
	CreateDynamicObject(854,1875.2659900,-1813.5460200,9.2650000,66.4180000,354.9900000,354.5840000); //object(cj_urb_rub_3b) (13)
	CreateDynamicObject(854,1874.3700000,-1813.6639400,8.6150000,65.4220000,4.8080000,345.6160000); //object(cj_urb_rub_3b) (14)
	CreateDynamicObject(854,1874.3740200,-1813.8630400,8.3900000,65.4180000,4.8070000,345.6130000); //object(cj_urb_rub_3b) (15)
	CreateDynamicObject(854,1874.7070300,-1813.8630400,8.5650000,64.1520000,24.7010000,321.4990000); //object(cj_urb_rub_3b) (16)
	CreateDynamicObject(854,1874.5810500,-1812.7889400,10.3900000,67.5050000,28.4360000,317.4030000); //object(cj_urb_rub_3b) (17)
	CreateDynamicObject(854,1874.1870100,-1813.2679400,9.4400000,305.9620000,46.0300000,229.4740000); //object(cj_urb_rub_3b) (18)
	CreateDynamicObject(854,1874.4449500,-1813.0140400,10.0650000,315.0090000,36.6930000,224.0070000); //object(cj_urb_rub_3b) (19)
	CreateDynamicObject(854,1875.7139900,-1813.1009500,10.0650000,315.0050000,36.6890000,224.0060000); //object(cj_urb_rub_3b) (20)
	CreateDynamicObject(854,1875.5050000,-1812.8609600,10.4650000,315.0050000,36.6890000,224.0060000); //object(cj_urb_rub_3b) (21)
	CreateDynamicObject(853,1894.1700400,-1818.1529500,9.6860000,63.4960000,1.1200000,343.9970000); //object(cj_urb_rub_5) (1)
	CreateDynamicObject(852,1893.8220200,-1818.3380100,8.4850000,0.0000000,292.0000000,74.0000000); //object(cj_urb_rub_4) (1)
	CreateDynamicObject(854,1894.5369900,-1818.3230000,8.8620000,0.0000000,306.0000000,69.7500000); //object(cj_urb_rub_3b) (22)
	CreateDynamicObject(854,1894.9599600,-1818.3640100,9.4620000,0.0000000,298.2470000,84.7470000); //object(cj_urb_rub_3b) (23)
	CreateDynamicObject(854,1895.3070100,-1818.0899700,9.8870000,0.0000000,298.2460000,84.7430000); //object(cj_urb_rub_3b) (24)
	CreateDynamicObject(854,1893.6720000,-1818.0340600,9.5870000,0.0000000,298.2460000,71.7430000); //object(cj_urb_rub_3b) (25)
	CreateDynamicObject(854,1894.4129600,-1817.8220200,10.2870000,0.0000000,298.2460000,73.7410000); //object(cj_urb_rub_3b) (26)
	CreateDynamicObject(854,1894.4200400,-1817.7719700,10.4870000,0.0000000,298.2460000,73.7400000); //object(cj_urb_rub_3b) (27)
	CreateDynamicObject(854,1894.6810300,-1817.8630400,10.5370000,0.0000000,298.2460000,73.7400000); //object(cj_urb_rub_3b) (28)
	CreateDynamicObject(854,1893.9029500,-1817.6669900,10.3870000,0.0000000,302.9960000,73.7400000); //object(cj_urb_rub_3b) (29)
	CreateDynamicObject(9831,1912.2750200,-1840.8709700,7.7390000,2.7490000,358.4980000,357.5720000); //object(sfw_waterfall) (1)
	CreateDynamicObject(9831,1922.3490000,-1840.8339800,5.9890000,2.7470000,358.4950000,357.5720000); //object(sfw_waterfall) (2)
	CreateDynamicObject(3865,2744.2939500,-1423.3540000,17.1840000,0.0000000,0.0000000,89.0000000); //object(concpipe_sfxrf) (7)
	CreateDynamicObject(3865,2735.5481000,-1423.0699500,17.1840000,0.0000000,0.0000000,88.9950000); //object(concpipe_sfxrf) (8)
	CreateDynamicObject(3865,2751.9050300,-1423.5930200,17.4090000,356.0000000,0.0000000,88.9950000); //object(concpipe_sfxrf) (9)
	CreateDynamicObject(3865,2727.2160600,-1422.7970000,17.1840000,0.0000000,0.0000000,88.9950000); //object(concpipe_sfxrf) (10)
	CreateDynamicObject(10984,2719.1069300,-1423.0610400,15.0840000,0.0000000,0.0000000,0.0000000); //object(rubbled01_sfs) (1)
	CreateDynamicObject(10984,2719.1069300,-1423.0610400,22.4840000,0.0000000,20.0000000,0.0000000); //object(rubbled01_sfs) (2)
	CreateDynamicObject(10984,2719.8549800,-1433.1629600,22.0590000,0.0000000,19.9950000,0.0000000); //object(rubbled01_sfs) (3)
	CreateDynamicObject(10984,2722.7749000,-1434.7769800,20.8590000,0.0000000,19.9950000,0.0000000); //object(rubbled01_sfs) (4)
	CreateDynamicObject(10984,2727.0210000,-1434.9549600,19.0340000,0.0000000,19.9950000,0.0000000); //object(rubbled01_sfs) (5)
	CreateDynamicObject(10984,2734.0471200,-1434.3020000,16.7840000,0.0000000,19.9950000,4.5000000); //object(rubbled01_sfs) (6)
	CreateDynamicObject(10984,2727.3039600,-1411.6259800,19.3590000,0.0000000,19.9950000,0.0000000); //object(rubbled01_sfs) (8)
	CreateDynamicObject(10984,2730.8830600,-1411.4470200,17.8590000,0.0000000,19.9950000,0.0000000); //object(rubbled01_sfs) (9)
	CreateDynamicObject(10984,2741.6059600,-1415.7659900,14.1090000,0.0000000,18.7450000,337.2500000); //object(rubbled01_sfs) (10)
	CreateDynamicObject(10984,2743.2580600,-1415.2440200,14.6090000,0.0000000,18.7430000,337.2470000); //object(rubbled01_sfs) (11)
	CreateDynamicObject(10984,2741.5371100,-1417.0959500,14.1840000,358.5660000,16.9980000,350.6860000); //object(rubbled01_sfs) (12)
	CreateDynamicObject(3865,2719.3720700,-1422.5749500,17.1840000,0.0000000,0.0000000,88.9950000); //object(concpipe_sfxrf) (11)
	CreateDynamicObject(3865,2710.2338900,-1423.3929400,17.1590000,0.0000000,0.0000000,101.4950000); //object(concpipe_sfxrf) (12)
	CreateDynamicObject(3865,2702.2871100,-1425.1729700,17.1590000,0.0000000,0.0000000,105.7420000); //object(concpipe_sfxrf) (13)
	CreateDynamicObject(3865,2693.2050800,-1427.6159700,17.1090000,0.0000000,0.0000000,105.7380000); //object(concpipe_sfxrf) (14)
	CreateDynamicObject(3865,2684.5820300,-1429.9699700,17.2090000,1.7500000,359.5000000,105.7530000); //object(concpipe_sfxrf) (15)
	CreateDynamicObject(3865,2675.9760700,-1432.6639400,17.4590000,1.7470000,359.4950000,109.7490000); //object(concpipe_sfxrf) (16)
	CreateDynamicObject(3865,2667.8920900,-1436.5970500,17.4590000,1.7470000,359.4890000,121.4980000); //object(concpipe_sfxrf) (17)
	CreateDynamicObject(3865,2661.7519500,-1441.3339800,17.4590000,0.2470000,359.4890000,132.9840000); //object(concpipe_sfxrf) (18)
	CreateDynamicObject(10984,2724.7099600,-1411.9229700,20.2090000,0.0000000,19.9950000,2.2500000); //object(rubbled01_sfs) (13)
	CreateDynamicObject(3865,2655.3369100,-1447.8900100,17.4590000,0.2420000,359.4890000,138.9840000); //object(concpipe_sfxrf) (19)
	CreateDynamicObject(3865,2649.4550800,-1454.6020500,17.5090000,0.2420000,359.4890000,138.9830000); //object(concpipe_sfxrf) (20)
	CreateDynamicObject(3865,2627.8100600,-1491.5880100,17.0340000,1.9850000,4.7420000,331.5660000); //object(concpipe_sfxrf) (21)
	CreateDynamicObject(3865,2631.7299800,-1484.6460000,17.3090000,1.9830000,4.7410000,331.0620000); //object(concpipe_sfxrf) (22)
	CreateDynamicObject(3865,2636.2319300,-1476.6639400,17.6340000,1.9780000,4.7350000,332.3070000); //object(concpipe_sfxrf) (23)
	CreateDynamicObject(3865,2644.2028800,-1461.2199700,17.6340000,1.9720000,4.7300000,322.3030000); //object(concpipe_sfxrf) (24)
	CreateDynamicObject(3865,2640.0949700,-1468.4069800,17.6090000,1.9670000,4.7240000,336.3000000); //object(concpipe_sfxrf) (25)
	CreateDynamicObject(906,2630.3588900,-1475.5830100,17.7620000,0.0000000,0.0000000,0.0000000); //object(p_rubblebig) (1)
	CreateDynamicObject(906,2633.2260700,-1476.1510000,20.6120000,0.0000000,336.0000000,0.0000000); //object(p_rubblebig) (2)
	CreateDynamicObject(906,2637.7758800,-1477.6409900,20.5620000,0.0000000,325.9950000,0.0000000); //object(p_rubblebig) (3)
	CreateDynamicObject(10985,2761.9331100,-1424.3620600,13.9930000,0.7410000,351.2490000,1.1140000); //object(rubbled02_sfs) (1)
	CreateDynamicObject(7344,1876.2900400,-1820.1479500,-31.9330000,0.2500000,0.0000000,359.7500000); //object(vgsn_pipeworks) (1)
	CreateDynamicObject(16533,1880.5699500,-1821.6219500,6.0170000,0.0000000,0.5000000,166.0000000); //object(des_oilpipe_06) (2)
	CreateDynamicObject(3865,2592.4660600,-1452.8490000,28.8290000,38.0000000,0.0000000,0.0000000); //object(concpipe_sfxrf) (26)
	CreateDynamicObject(3865,2592.3510700,-1459.9139400,24.0790000,25.2460000,0.0000000,0.0000000); //object(concpipe_sfxrf) (27)
	CreateDynamicObject(3865,2592.4489700,-1467.3139600,21.1790000,15.2320000,2.0730000,359.4550000); //object(concpipe_sfxrf) (28)
	CreateDynamicObject(3865,2606.3850100,-1459.4720500,23.1040000,25.2410000,0.0000000,0.0000000); //object(concpipe_sfxrf) (29)
	CreateDynamicObject(3865,2606.2180200,-1452.5329600,27.6040000,37.9960000,0.0000000,2.5000000); //object(concpipe_sfxrf) (30)
	CreateDynamicObject(3865,2606.2890600,-1468.0860600,19.7040000,15.2270000,2.0710000,359.4510000); //object(concpipe_sfxrf) (31)
	CreateDynamicObject(3865,2621.2199700,-1464.7259500,19.3540000,12.2410000,0.0000000,0.0000000); //object(concpipe_sfxrf) (32)
	CreateDynamicObject(3865,2621.3059100,-1456.8070100,22.8290000,32.9890000,0.0000000,0.0000000); //object(concpipe_sfxrf) (33)
	CreateDynamicObject(3865,2621.6120600,-1449.2600100,27.0040000,22.9200000,4.6150000,358.1990000); //object(concpipe_sfxrf) (34)
	CreateDynamicObject(3865,2628.2829600,-1511.2409700,22.4690000,0.0000000,0.0000000,259.2500000); //object(concpipe_sfxrf) (35)
	CreateDynamicObject(3865,2763.4331100,-1423.7240000,11.3090000,271.9950000,0.0000000,88.9890000); //object(concpipe_sfxrf) (36)
	CreateDynamicObject(3865,764.5579800,-1010.4489700,26.2250000,0.0000000,0.0000000,356.0000000); //object(concpipe_sfxrf) (37)
	CreateDynamicObject(3865,757.5529800,-1021.9169900,26.2250000,0.0000000,0.0000000,75.9950000); //object(concpipe_sfxrf) (38)
	CreateDynamicObject(3865,756.7680100,-1027.1080300,26.2250000,0.0000000,0.0000000,75.9920000); //object(concpipe_sfxrf) (39)
	CreateDynamicObject(3865,1877.6960400,-961.7379800,47.8990000,340.0000000,0.0000000,338.0000000); //object(concpipe_sfxrf) (41)
	CreateDynamicObject(3865,1887.1369600,-972.4110100,46.6490000,339.9990000,0.0000000,304.0000000); //object(concpipe_sfxrf) (42)
	CreateDynamicObject(3865,1885.7180200,-959.8350200,51.1990000,5.9960000,2.0110000,329.7870000); //object(concpipe_sfxrf) (43)
	CreateDynamicObject(3865,849.0390000,-1361.0100100,8.9060000,271.9040000,66.8100000,81.5480000); //object(concpipe_sfxrf) (44)
	CreateDynamicObject(3865,865.1669900,-1367.6669900,8.8560000,273.0090000,131.6720000,146.4600000); //object(concpipe_sfxrf) (45)
	CreateDynamicObject(3865,871.1900000,-1362.9200400,8.6810000,270.7900000,341.3220000,356.0730000); //object(concpipe_sfxrf) (46)
	CreateDynamicObject(3865,876.1920200,-1352.9689900,8.8810000,271.9010000,66.8080000,81.5460000); //object(concpipe_sfxrf) (47)
	CreateDynamicObject(854,864.8900100,-1367.7070300,12.6290000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (30)
	CreateDynamicObject(854,865.5380200,-1368.1750500,12.6290000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (31)
	CreateDynamicObject(854,865.9569700,-1367.6770000,12.6290000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (32)
	CreateDynamicObject(854,864.7390100,-1366.8010300,12.6290000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (33)
	CreateDynamicObject(854,864.3270300,-1367.2800300,12.6290000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (34)
	CreateDynamicObject(854,864.3220200,-1367.8179900,12.6290000,0.0000000,359.2500000,0.0000000); //object(cj_urb_rub_3b) (35)
	CreateDynamicObject(854,864.7630000,-1368.3490000,12.6290000,0.0000000,359.2470000,0.0000000); //object(cj_urb_rub_3b) (36)
	CreateDynamicObject(854,865.2500000,-1368.4029500,12.5790000,0.0000000,359.2470000,0.0000000); //object(cj_urb_rub_3b) (37)
	CreateDynamicObject(854,865.3620000,-1367.0980200,12.7290000,0.0000000,359.2470000,0.0000000); //object(cj_urb_rub_3b) (38)
	CreateDynamicObject(854,865.0390000,-1366.3630400,12.4540000,0.0000000,359.2470000,0.0000000); //object(cj_urb_rub_3b) (39)
	CreateDynamicObject(853,871.0330200,-1363.0999800,12.8730000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_5) (2)
	CreateDynamicObject(852,870.2750200,-1362.6390400,12.4720000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (2)
	CreateDynamicObject(852,870.7100200,-1362.5360100,12.4720000,0.0000000,0.0000000,116.0000000); //object(cj_urb_rub_4) (3)
	CreateDynamicObject(852,871.1920200,-1362.4420200,12.4720000,0.0000000,0.0000000,353.9990000); //object(cj_urb_rub_4) (4)
	CreateDynamicObject(852,871.5510300,-1363.4000200,12.4720000,0.0000000,0.0000000,237.9960000); //object(cj_urb_rub_4) (5)
	CreateDynamicObject(854,870.7689800,-1363.8089600,12.6540000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (40)
	CreateDynamicObject(854,870.2349900,-1363.3969700,12.5540000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (41)
	CreateDynamicObject(854,872.1460000,-1363.2960200,12.5790000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (42)
	CreateDynamicObject(854,871.8200100,-1362.8769500,12.5790000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (43)
	CreateDynamicObject(854,871.1049800,-1361.9790000,12.4790000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (44)
	CreateDynamicObject(854,871.5040300,-1362.0860600,12.4790000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (45)
	CreateDynamicObject(851,876.1610100,-1352.7259500,13.0320000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_2) (1)
	CreateDynamicObject(850,875.1959800,-1357.8280000,12.6580000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_1) (1)
	CreateDynamicObject(849,876.0289900,-1353.2600100,12.9840000,0.0000000,0.0000000,286.0000000); //object(cj_urb_rub_3) (1)
	CreateDynamicObject(854,875.9650300,-1352.2659900,12.9770000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (46)
	CreateDynamicObject(854,875.2529900,-1352.8909900,12.7270000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (47)
	CreateDynamicObject(854,875.5000000,-1353.5760500,12.7770000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (48)
	CreateDynamicObject(854,877.1939700,-1352.7340100,12.8020000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (49)
	CreateDynamicObject(854,876.7960200,-1353.3149400,12.8020000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (50)
	CreateDynamicObject(854,849.0889900,-1361.0550500,12.6790000,359.7500000,0.5000000,0.0020000); //object(cj_urb_rub_3b) (51)
	CreateDynamicObject(854,848.9010000,-1360.2359600,12.6790000,359.7470000,0.5000000,0.0000000); //object(cj_urb_rub_3b) (52)
	CreateDynamicObject(854,849.4130200,-1360.4429900,12.6790000,359.7470000,0.5000000,0.0000000); //object(cj_urb_rub_3b) (53)
	CreateDynamicObject(854,849.6240200,-1361.2099600,12.6790000,359.7470000,0.5000000,12.0000000); //object(cj_urb_rub_3b) (54)
	CreateDynamicObject(854,849.5399800,-1360.8439900,12.6790000,359.7470000,0.5000000,11.9970000); //object(cj_urb_rub_3b) (55)
	CreateDynamicObject(854,848.6740100,-1360.4260300,12.6790000,359.7470000,0.5000000,356.9970000); //object(cj_urb_rub_3b) (56)
	CreateDynamicObject(854,848.2410300,-1360.8859900,12.6790000,359.7470000,0.5000000,356.9950000); //object(cj_urb_rub_3b) (57)
	CreateDynamicObject(854,848.3640100,-1361.4229700,12.6790000,359.7470000,0.5000000,356.9950000); //object(cj_urb_rub_3b) (58)
	CreateDynamicObject(854,848.7210100,-1361.7519500,12.6790000,359.7470000,0.5000000,356.9950000); //object(cj_urb_rub_3b) (59)
	CreateDynamicObject(854,849.3330100,-1361.7390100,12.6790000,359.7470000,0.5000000,356.9950000); //object(cj_urb_rub_3b) (60)
	CreateDynamicObject(850,875.2639800,-1348.6090100,12.9330000,0.0000000,0.0000000,72.0000000); //object(cj_urb_rub_1) (2)

	//HotelMax
	CreateDynamicObject(987,465.0100100,-1463.9530000,26.3560000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(8209,356.3729900,-1460.2580600,35.8930000,0.0000000,0.0000000,222.7500000); //object(vgsselecfence11) (1)
	CreateDynamicObject(8209,410.3960000,-1428.6839600,34.8430000,0.0000000,0.0000000,220.4980000); //object(vgsselecfence11) (2)
	CreateDynamicObject(3578,401.4277300,-1413.0546900,33.8100000,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(3578,391.8857400,-1420.8525400,33.8100000,0.0000000,0.0000000,99.9980000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3399,282.9880100,-1580.5990000,34.2510000,0.0000000,0.0000000,351.9960000); //object(cxrf_a51_stairs) (2)
	CreateDynamicObject(3399,283.2580000,-1578.5169700,34.2760000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (3)
	CreateDynamicObject(3399,283.5730000,-1576.4649700,34.2510000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (4)
	CreateDynamicObject(3399,283.8770100,-1574.4200400,34.2510000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (5)
	CreateDynamicObject(3399,284.1839900,-1572.3570600,34.2510000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (6)
	CreateDynamicObject(3399,284.4880100,-1570.2889400,34.2510000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (7)
	CreateDynamicObject(3399,284.7829900,-1568.2130100,34.2510000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (8)
	CreateDynamicObject(3399,282.7030000,-1582.6610100,34.2260000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (9)
	CreateDynamicObject(3399,282.4230000,-1584.7419400,34.2260000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (10)
	CreateDynamicObject(3399,282.1000100,-1586.8079800,34.2010000,0.0000000,0.0000000,351.9910000); //object(cxrf_a51_stairs) (11)
	CreateDynamicObject(10841,292.8169900,-1557.2459700,34.7670000,0.0000000,0.0000000,260.4980000); //object(drydock1_sfse01) (2)
	CreateDynamicObject(10841,286.0920100,-1600.0269800,34.7420000,0.0000000,0.0000000,261.4980000); //object(drydock1_sfse01) (4)
	CreateDynamicObject(19457,290.9890100,-1585.2409700,36.3620000,0.0000000,90.0000000,351.5000000); //object(wall097) (1)
	CreateDynamicObject(19457,292.3960000,-1575.7860100,36.3620000,0.0000000,90.0000000,351.4970000); //object(wall097) (2)
	CreateDynamicObject(19457,289.5589900,-1594.7320600,36.3620000,0.0000000,90.0000000,351.4970000); //object(wall097) (3)
	CreateDynamicObject(19457,288.1300000,-1604.2070300,36.3620000,0.0000000,90.0000000,351.4970000); //object(wall097) (4)
	CreateDynamicObject(19457,293.8150000,-1566.2399900,36.3870000,0.0000000,90.0000000,351.4970000); //object(wall097) (5)
	CreateDynamicObject(19457,295.2529900,-1556.6750500,36.3620000,0.0000000,90.0000000,351.4970000); //object(wall097) (6)
	CreateDynamicObject(18773,393.6489900,-1434.5880100,36.0950000,0.0000000,5.5000000,307.9960000); //object(tunneljoinsection1) (2)
	CreateDynamicObject(18773,395.7080100,-1432.9780300,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (3)
	CreateDynamicObject(18773,392.0360100,-1435.8709700,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (4)
	CreateDynamicObject(18773,390.6130100,-1436.9749800,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (5)
	CreateDynamicObject(18773,388.5660100,-1438.5810500,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (6)
	CreateDynamicObject(18773,386.4200100,-1440.2609900,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (7)
	CreateDynamicObject(18773,384.3340100,-1441.8960000,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (8)
	CreateDynamicObject(18773,382.3210100,-1443.4870600,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (9)
	CreateDynamicObject(18773,380.3089900,-1445.0550500,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (10)
	CreateDynamicObject(18773,378.3720100,-1446.5959500,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (11)
	CreateDynamicObject(18773,376.5369900,-1448.0250200,36.0950000,0.0000000,5.4990000,307.9910000); //object(tunneljoinsection1) (12)
	CreateDynamicObject(18773,398.3590100,-1430.8289800,35.5950000,342.0860000,5.7800000,309.7740000); //object(tunneljoinsection1) (13)
	CreateDynamicObject(18773,400.2510100,-1429.1860400,34.7950000,342.0810000,5.7790000,309.7710000); //object(tunneljoinsection1) (14)
	CreateDynamicObject(987,367.4140000,-1465.6450200,35.0330000,0.0000000,0.0000000,129.7500000); //object(elecfence_bar) (6)
	CreateDynamicObject(987,375.0509900,-1474.8430200,35.0580000,0.0000000,0.0000000,129.7490000); //object(elecfence_bar) (7)
	CreateDynamicObject(987,375.0509900,-1474.8430200,30.0580000,0.0000000,0.0000000,129.7490000); //object(elecfence_bar) (8)
	CreateDynamicObject(987,372.5040000,-1460.8449700,30.0580000,0.0000000,0.0000000,311.7490000); //object(elecfence_bar) (9)
	CreateDynamicObject(987,372.5040000,-1460.8449700,34.8580000,0.0000000,0.0000000,311.7480000); //object(elecfence_bar) (10)
	CreateDynamicObject(991,281.0400100,-1587.9239500,32.8980000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (1)
	CreateDynamicObject(991,281.0390000,-1587.9239500,35.2980000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (6)
	CreateDynamicObject(991,287.6279900,-1588.9969500,35.2980000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (7)
	CreateDynamicObject(991,287.6279900,-1588.9959700,32.9230000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (8)
	CreateDynamicObject(1282,397.3810100,-1410.2629400,33.7210000,0.0000000,0.0000000,280.0000000); //object(barrierm) (1)
	CreateDynamicObject(1282,389.4070100,-1414.5620100,33.7210000,0.0000000,0.0000000,353.9980000); //object(barrierm) (2)
	CreateDynamicObject(991,284.3660000,-1567.1149900,32.8980000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (9)
	CreateDynamicObject(991,284.3540000,-1567.1269500,35.2730000,0.0000000,0.0000000,350.7500000); //object(bar_barriergate1) (10)
	CreateDynamicObject(991,290.9270000,-1568.0789800,32.8730000,0.0000000,0.0000000,353.0000000); //object(bar_barriergate1) (11)
	CreateDynamicObject(991,290.8830000,-1568.1529500,35.2730000,0.0000000,0.0000000,352.2500000); //object(bar_barriergate1) (12)
	CreateDynamicObject(1411,362.3410000,-1472.3129900,31.9690000,0.0000000,0.0000000,46.0000000); //object(dyn_mesh_1) (1)
	CreateDynamicObject(1411,366.0220000,-1468.5629900,31.9940000,0.0000000,0.0000000,46.0000000); //object(dyn_mesh_1) (2)
	CreateDynamicObject(993,297.4920000,-1568.0419900,29.2480000,0.0000000,0.0000000,96.0000000); //object(bar_barrier10) (1)
	CreateDynamicObject(993,297.4910000,-1568.0419900,31.6480000,0.0000000,0.0000000,95.9990000); //object(bar_barrier10) (2)
	CreateDynamicObject(10841,303.5270100,-1613.7060500,47.8170000,0.0000000,0.0000000,178.9950000); //object(drydock1_sfse01) (7)
	CreateDynamicObject(10841,326.2260100,-1613.9160200,47.8420000,0.0000000,0.0000000,179.9950000); //object(drydock1_sfse01) (9)
	CreateDynamicObject(10841,349.0190100,-1614.2280300,47.8420000,0.0000000,0.0000000,178.4950000); //object(drydock1_sfse01) (11)
	CreateDynamicObject(10841,303.5260000,-1613.7060500,38.4920000,0.0000000,0.0000000,178.9950000); //object(drydock1_sfse01) (13)
	CreateDynamicObject(10841,326.2260100,-1613.9160200,38.4920000,0.0000000,0.0000000,179.9950000); //object(drydock1_sfse01) (14)
	CreateDynamicObject(10841,349.0190100,-1614.2280300,38.4670000,0.0000000,0.0000000,178.4950000); //object(drydock1_sfse01) (15)
	CreateDynamicObject(993,297.3250100,-1566.3000500,31.8730000,0.0000000,0.0000000,95.9990000); //object(bar_barrier10) (3)
	CreateDynamicObject(10008,337.4610000,-1620.1460000,47.8290000,0.0000000,0.0000000,96.0000000); //object(fer_cars2_sfe) (1)
	CreateDynamicObject(10008,337.4610000,-1620.1460000,41.6040000,0.0000000,0.0000000,95.9990000); //object(fer_cars2_sfe) (2)
	CreateDynamicObject(10008,337.4610000,-1620.1460000,35.3540000,0.0000000,0.0000000,95.9990000); //object(fer_cars2_sfe) (3)
	CreateDynamicObject(18260,329.9460100,-1606.0400400,33.7530000,0.0000000,0.0000000,50.0000000); //object(crates01) (1)
	CreateDynamicObject(2935,321.9530000,-1603.0760500,33.6060000,0.0000000,0.0000000,28.0000000); //object(kmb_container_yel) (1)
	CreateDynamicObject(2935,318.7370000,-1603.8120100,35.8810000,322.4630000,341.5940000,108.5370000); //object(kmb_container_yel) (2)
	CreateDynamicObject(2973,317.6780100,-1600.8509500,32.0390000,0.0000000,0.0000000,0.0000000); //object(k_cargo2) (1)
	CreateDynamicObject(3279,359.7240000,-1465.5899700,34.9330000,0.0000000,0.0000000,306.0000000); //object(a51_spottower) (1)
	CreateDynamicObject(3279,424.8479900,-1504.8540000,30.1740000,0.0000000,0.0000000,301.7500000); //object(a51_spottower) (2)
	CreateDynamicObject(3279,443.9140000,-1553.3110400,26.0560000,0.0000000,0.0000000,243.9950000); //object(a51_spottower) (3)
	CreateDynamicObject(2669,414.1709900,-1606.4849900,34.5120000,0.0000000,0.0000000,306.0000000); //object(cj_chris_crate) (1)
	CreateDynamicObject(1348,331.0520000,-1606.1020500,34.8320000,0.0000000,0.0000000,0.0000000); //object(cj_o2tanks) (1)
	CreateDynamicObject(2038,344.4989900,-1617.9709500,43.8030000,0.0000000,0.0000000,0.0000000); //object(ammo_box_s2) (1)
	CreateDynamicObject(1685,348.2489900,-1607.0730000,49.9610000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (1)
	CreateDynamicObject(1685,348.2659900,-1607.0419900,51.4360000,0.0000000,0.0000000,90.2500000); //object(blockpallet) (2)
	CreateDynamicObject(1685,346.6120000,-1608.5169700,49.9110000,0.0000000,0.0000000,294.2470000); //object(blockpallet) (3)
	CreateDynamicObject(1685,350.2000100,-1607.0240500,50.4360000,296.0000000,0.0000000,268.2470000); //object(blockpallet) (4)
	CreateDynamicObject(1685,350.6720000,-1608.7390100,49.9610000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (5)
	CreateDynamicObject(19909,398.6191400,-1533.4345700,31.4410000,0.0000000,0.0000000,43.9950000); //object(a51building3) (1)
	CreateDynamicObject(19910,378.8920000,-1471.0450400,39.0460000,0.0000000,0.0000000,43.4970000); //object(a51building3grgdoor) (2)
	CreateDynamicObject(19910,376.1659900,-1473.6130400,39.0460000,0.0000000,0.0000000,43.4950000); //object(a51building3grgdoor) (3)
	CreateDynamicObject(19943,415.1300000,-1555.7450000,26.5780000,0.0000000,0.0000000,0.0000000); //object(stonepillar1) (1)
	CreateDynamicObject(19943,421.4630100,-1549.3449700,26.5780000,0.0000000,0.0000000,0.0000000); //object(stonepillar1) (2)
	CreateDynamicObject(16322,419.2380100,-1553.5419900,30.6340000,0.0000000,0.0000000,45.0000000); //object(a51_plat) (1)
	CreateDynamicObject(16095,308.1860000,-1598.7180200,32.1530000,0.0000000,0.0000000,352.0000000); //object(des_a51guardbox02) (1)
	CreateDynamicObject(16095,412.2479900,-1439.2769800,30.6940000,4.4980000,1.5050000,37.8780000); //object(des_a51guardbox02) (2)
	CreateDynamicObject(987,465.0100100,-1463.9520300,31.1810000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,458.2349900,-1454.0799600,31.2060000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,451.5929900,-1444.2070300,31.2060000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,451.5929900,-1444.2070300,26.3060000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,445.0329900,-1434.0400400,26.3060000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,445.0320100,-1434.0400400,31.2060000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(16359,338.5939900,-1526.3160400,32.0020000,0.0000000,0.0000000,144.0000000); //object(des_shed3_01) (1)
	CreateDynamicObject(16641,335.1120000,-1546.1429400,33.7100000,359.7500000,359.7500000,63.9990000); //object(des_a51warheads) (1)
	CreateDynamicObject(16641,343.1900000,-1547.8909900,33.6350000,359.7470000,0.9970000,246.0010000); //object(des_a51warheads) (2)
	CreateDynamicObject(16644,327.9910000,-1613.0780000,48.9570000,0.0930000,68.2500000,87.7680000); //object(a51_ventsouth) (1)
	CreateDynamicObject(8210,358.6520100,-1550.1879900,32.8410000,0.0000000,0.0000000,234.0000000); //object(vgsselecfence12) (1)
	CreateDynamicObject(8210,358.6513700,-1550.1875000,32.8410000,0.0000000,0.0000000,233.9980000); //object(vgsselecfence12) (2)
	CreateDynamicObject(8210,358.6510000,-1550.1879900,39.9410000,0.0000000,0.0000000,233.9980000); //object(vgsselecfence12) (3)
	CreateDynamicObject(8210,395.9780000,-1510.0670200,39.9410000,0.0000000,0.0000000,220.2480000); //object(vgsselecfence12) (4)
	CreateDynamicObject(8210,395.9800100,-1510.0090300,32.7910000,0.0000000,0.0000000,220.2430000); //object(vgsselecfence12) (5)
	CreateDynamicObject(8210,369.9129900,-1574.0579800,39.9410000,0.0000000,0.0000000,355.9980000); //object(vgsselecfence12) (6)
	CreateDynamicObject(8210,369.9119900,-1574.0579800,33.0160000,0.0000000,0.0000000,355.9950000); //object(vgsselecfence12) (7)
	CreateDynamicObject(8210,369.9110100,-1574.0579800,25.9160000,0.0000000,0.0000000,355.9950000); //object(vgsselecfence12) (8)
	CreateDynamicObject(8041,421.6929900,-1560.9950000,32.1150000,0.0000000,0.0000000,312.0000000); //object(apbarriergate06_lvs) (2)
	CreateDynamicObject(987,397.6820100,-1576.2409700,27.2390000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (18)
	CreateDynamicObject(987,404.5170000,-1573.1450200,27.2390000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (19)
	CreateDynamicObject(987,404.5170000,-1573.1450200,22.2890000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (20)
	CreateDynamicObject(987,429.7879900,-1555.3389900,26.3630000,0.0000000,0.0000000,79.5000000); //object(elecfence_bar) (21)
	CreateDynamicObject(987,397.6820100,-1576.2399900,22.2890000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (22)
	CreateDynamicObject(987,397.6820100,-1576.2390100,32.0890000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (23)
	CreateDynamicObject(987,461.6270100,-1459.0579800,26.3560000,0.0000000,0.0000000,124.2500000); //object(elecfence_bar) (1)
	CreateDynamicObject(988,455.8380100,-1450.0030500,27.1240000,0.0000000,0.0000000,121.7450000); //object(ws_apgate) (2)
	CreateDynamicObject(8651,292.5669900,-1588.7519500,35.4490000,0.0000000,0.0000000,351.7500000); //object(shbbyhswall07_lvs) (1)
	CreateDynamicObject(8651,292.5660100,-1588.7519500,33.4740000,0.0000000,0.0000000,351.7490000); //object(shbbyhswall07_lvs) (2)
	CreateDynamicObject(8651,292.5650000,-1588.7519500,31.4740000,0.0000000,0.0000000,351.7490000); //object(shbbyhswall07_lvs) (3)
	CreateDynamicObject(8651,297.1940000,-1559.2889400,35.4490000,0.0000000,0.0000000,350.9990000); //object(shbbyhswall07_lvs) (4)
	CreateDynamicObject(8651,297.1929900,-1559.2879600,33.4490000,0.0000000,0.0000000,350.9970000); //object(shbbyhswall07_lvs) (5)
	CreateDynamicObject(8229,321.4190100,-1614.6159700,36.0300000,0.0000000,0.0000000,179.7500000); //object(vgsbikeschl02) (1)
	CreateDynamicObject(8210,407.9630100,-1499.9150400,32.7910000,0.0000000,0.0000000,220.2430000); //object(vgsselecfence12) (9)
	CreateDynamicObject(8210,407.9630100,-1499.9150400,39.8410000,0.0000000,0.0000000,220.2430000); //object(vgsselecfence12) (10)
	CreateDynamicObject(8210,430.7439900,-1509.6500200,32.7660000,0.0000000,0.0000000,94.2430000); //object(vgsselecfence12) (11)
	CreateDynamicObject(8210,430.7430100,-1509.6490500,25.6910000,0.0000000,0.0000000,94.2410000); //object(vgsselecfence12) (12)
	CreateDynamicObject(8210,430.7420000,-1509.6479500,39.8910000,0.0000000,0.0000000,94.2410000); //object(vgsselecfence12) (13)
	CreateDynamicObject(987,404.5166000,-1573.1445300,32.1890000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (25)
	CreateDynamicObject(987,430.9970100,-1548.5629900,26.3630000,0.0000000,0.0000000,79.4970000); //object(elecfence_bar) (26)
	CreateDynamicObject(987,430.9960000,-1548.5629900,31.2130000,0.0000000,0.0000000,79.4970000); //object(elecfence_bar) (27)
	CreateDynamicObject(987,429.7869900,-1555.3389900,31.0630000,0.0000000,0.0000000,79.4970000); //object(elecfence_bar) (28)
	CreateDynamicObject(987,397.6820100,-1576.2380400,36.9640000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (29)
	CreateDynamicObject(987,404.5170000,-1573.1450200,37.1390000,0.0000000,0.0000000,23.5000000); //object(elecfence_bar) (30)
	CreateDynamicObject(987,429.7860100,-1555.3389900,36.0380000,0.0000000,0.0000000,79.4970000); //object(elecfence_bar) (31)
	CreateDynamicObject(987,430.9950000,-1548.5629900,36.1630000,0.0000000,0.0000000,79.4970000); //object(elecfence_bar) (32)
	CreateDynamicObject(987,415.5020100,-1568.2089800,35.1640000,0.0000000,0.0000000,42.2500000); //object(elecfence_bar) (33)
	CreateDynamicObject(987,420.6680000,-1563.2509800,35.1640000,0.0000000,0.0000000,42.2480000); //object(elecfence_bar) (34)
	CreateDynamicObject(8311,423.8640100,-1620.3490000,25.0320000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence15) (1)
	CreateDynamicObject(8311,472.7800000,-1613.4560500,25.0320000,0.0000000,0.0000000,182.0000000); //object(vgsselecfence15) (2)
	CreateDynamicObject(3279,411.4785200,-1582.0459000,25.1310000,0.0000000,0.0000000,335.9950000); //object(a51_spottower) (4)
	CreateDynamicObject(3279,355.3476600,-1563.8877000,31.6400000,0.0000000,0.0000000,327.7500000); //object(a51_spottower) (5)
	CreateDynamicObject(3117,331.2439900,-1613.7950400,50.4350000,0.0000000,30.0000000,0.0000000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(9238,427.6359900,-1456.6619900,31.0910000,0.0000000,0.0000000,0.0000000); //object(moresfnshit28) (1)
	CreateDynamicObject(9238,441.1440100,-1472.1810300,31.1410000,0.0000000,0.0000000,106.0000000); //object(moresfnshit28) (2)
	CreateDynamicObject(3578,438.9890100,-1627.8730500,25.7020000,0.0000000,0.0000000,175.9980000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,457.8680100,-1627.9770500,25.7020000,0.0000000,0.0000000,179.9950000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,452.9890100,-1636.5200200,25.7020000,0.0000000,0.0000000,179.2450000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,436.9930100,-1636.0660400,25.7020000,0.0000000,0.0000000,177.4940000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,442.8859900,-1644.3320300,25.7020000,0.0000000,0.0000000,169.4900000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,456.9490100,-1643.1989700,25.7020000,0.0000000,0.0000000,181.4890000); //object(dockbarr1_la) (2)
	CreateDynamicObject(4100,414.0530100,-1561.9780300,28.2800000,0.0000000,0.0000000,46.5000000); //object(meshfence1_lan) (1)
	CreateDynamicObject(4100,426.6789900,-1544.9489700,28.2800000,0.0000000,0.0000000,177.5000000); //object(meshfence1_lan) (2)
	CreateDynamicObject(974,303.2030000,-1531.3149400,26.6500000,0.0000000,0.0000000,321.2500000); //object(tall_fence) (1)
	CreateDynamicObject(974,298.0610000,-1527.1359900,26.6500000,0.0000000,0.0000000,321.2460000); //object(tall_fence) (2)
	CreateDynamicObject(974,298.0610000,-1527.1359900,21.1500000,0.0000000,0.0000000,321.2460000); //object(tall_fence) (3)
	CreateDynamicObject(974,292.8380100,-1523.1820100,26.6500000,0.0000000,0.0000000,324.9960000); //object(tall_fence) (4)
	CreateDynamicObject(974,292.8380100,-1523.1820100,21.1750000,0.0000000,0.0000000,324.9920000); //object(tall_fence) (5)
	CreateDynamicObject(974,287.4060100,-1519.4010000,26.6500000,0.0000000,0.0000000,324.9920000); //object(tall_fence) (6)
	CreateDynamicObject(974,287.4050000,-1519.4000200,21.1750000,0.0000000,0.0000000,324.9920000); //object(tall_fence) (7)
	CreateDynamicObject(974,281.9200100,-1515.6169400,26.6500000,0.0000000,0.0000000,325.4920000); //object(tall_fence) (8)
	CreateDynamicObject(3578,421.4370100,-1567.4649700,27.3500000,0.0000000,0.0000000,4.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(3578,428.2290000,-1559.9570300,27.3500000,0.0000000,0.0000000,85.9990000); //object(dockbarr1_la) (1)
	CreateDynamicObject(1437,295.5379900,-1576.5949700,32.2830000,0.0000000,0.0000000,84.0000000); //object(dyn_ladder_2) (1)
	CreateDynamicObject(1437,297.7059900,-1580.8370400,32.2580000,323.7500000,0.0000000,83.9960000); //object(dyn_ladder_2) (2)
	CreateDynamicObject(1437,295.5320100,-1593.4470200,33.0580000,325.7450000,0.0000000,83.9900000); //object(dyn_ladder_2) (3)
	CreateDynamicObject(1437,302.0620100,-1585.2199700,31.9580000,277.5000000,0.0000000,83.9850000); //object(dyn_ladder_2) (4)
	CreateDynamicObject(3593,296.7009900,-1496.6469700,24.3570000,0.0000000,0.0000000,178.0000000); //object(la_fuckcar2) (1)
	CreateDynamicObject(3594,322.5459000,-1492.9707000,24.3500000,353.7490000,0.7530000,56.0800000); //object(la_fuckcar1) (1)
	CreateDynamicObject(3066,415.5939900,-1522.4599600,30.9820000,2.7500000,0.5010000,359.9760000); //object(ammotrn_obj) (1)
	CreateDynamicObject(3066,427.1210000,-1531.9709500,29.7320000,7.9720000,4.5430000,340.8650000); //object(ammotrn_obj) (2)
	CreateDynamicObject(3066,294.3500100,-1518.4320100,24.5480000,0.0000000,0.0000000,54.0000000); //object(ammotrn_obj) (3)
	CreateDynamicObject(3066,297.5660100,-1512.6049800,24.5480000,0.0000000,0.0000000,52.4980000); //object(ammotrn_obj) (4)
	CreateDynamicObject(3567,368.0369900,-1511.3170200,32.5720000,359.5000000,2.5000000,0.0220000); //object(lasnfltrail) (1)
	CreateDynamicObject(3567,368.0360100,-1511.3160400,34.2220000,359.5000000,2.4990000,0.0160000); //object(lasnfltrail) (2)
	CreateDynamicObject(3567,368.0350000,-1511.3149400,35.8720000,359.5000000,2.4990000,0.0160000); //object(lasnfltrail) (3)
	CreateDynamicObject(16349,399.7370000,-1534.1300000,39.6140000,0.0000000,0.0000000,0.0000000); //object(dam_genturbine01) (1)
	CreateDynamicObject(939,311.6130100,-1514.9169900,26.3650000,0.0000000,0.0000000,36.0000000); //object(cj_df_unit) (1)
	CreateDynamicObject(922,304.2319900,-1513.7209500,24.4790000,0.0000000,0.0000000,92.0000000); //object(packing_carates1) (1)
	CreateDynamicObject(2973,283.6610100,-1513.6679700,23.9220000,0.0000000,0.0000000,324.0000000); //object(k_cargo2) (2)
	CreateDynamicObject(2973,285.8940100,-1515.5400400,23.9220000,0.0000000,0.0000000,323.9980000); //object(k_cargo2) (3)
	CreateDynamicObject(2973,286.9230000,-1512.0710400,23.9220000,0.0000000,0.0000000,323.9980000); //object(k_cargo2) (4)
	CreateDynamicObject(2934,303.5820000,-1482.3709700,25.0460000,0.0000000,0.0000000,323.5000000); //object(kmb_container_red) (1)
	CreateDynamicObject(2985,316.0090000,-1488.1879900,23.4950000,0.0000000,0.0000000,15.2500000); //object(minigun_base) (1)
	CreateDynamicObject(2985,320.0710100,-1492.8800000,23.4950000,0.0000000,0.0000000,69.2490000); //object(minigun_base) (2)
	CreateDynamicObject(2977,301.9580100,-1487.5959500,23.5190000,0.0000000,0.0000000,0.0000000); //object(kmilitary_crate) (1)
	CreateDynamicObject(2977,303.0069900,-1487.5909400,23.5190000,0.0000000,0.0000000,0.0000000); //object(kmilitary_crate) (2)
	CreateDynamicObject(2921,363.8210100,-1473.2049600,33.8050000,0.0000000,0.0000000,192.0000000); //object(kmb_cam) (1)
	CreateDynamicObject(2892,321.6000100,-1487.5999800,23.6800000,359.4680000,355.2980000,57.2420000); //object(temp_stinger) (1)
	CreateDynamicObject(3884,307.5549900,-1506.7960200,23.1000000,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	CreateDynamicObject(3864,410.0000000,-1560.4000200,32.7000000,0.0000000,0.0000000,164.3140000); //object(ws_floodlight) (1)
	CreateDynamicObject(3864,423.0000000,-1544.0999800,32.7000000,0.0000000,0.0000000,98.9400000); //object(ws_floodlight) (2)
	CreateDynamicObject(11738,284.0000000,-1513.4000200,26.5000000,0.0000000,0.0000000,0.0000000); //object(mediccase1) (1)
	CreateDynamicObject(2068,289.2000100,-1520.0000000,26.6000000,0.0000000,269.0000000,54.0000000); //object(cj_cammo_net) (1)
	CreateDynamicObject(2068,296.0000000,-1524.8000500,26.6000000,0.0000000,268.9950000,53.9980000); //object(cj_cammo_net) (2)
	CreateDynamicObject(2068,302.7999900,-1529.5000000,26.6000000,0.0000000,268.9950000,56.2480000); //object(cj_cammo_net) (3)
	CreateDynamicObject(2068,282.6000100,-1515.1999500,26.6000000,0.0000000,268.9950000,53.9980000); //object(cj_cammo_net) (4)
	CreateDynamicObject(2064,308.5000000,-1488.1999500,24.2000000,0.0000000,0.0000000,174.0000000); //object(cj_feildgun) (1)
	CreateDynamicObject(2060,317.2000100,-1487.8000500,23.7000000,0.0000000,3.2500000,96.2500000); //object(cj_sandbag) (1)
	CreateDynamicObject(2060,317.2000100,-1487.8000500,23.9000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (2)
	CreateDynamicObject(2060,317.2000100,-1487.8000500,24.1000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (3)
	CreateDynamicObject(2060,317.2000100,-1487.8000500,24.3000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (4)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,24.3000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (5)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,24.1000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (6)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,24.0000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (7)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,23.9000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (8)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,23.8000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (9)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,23.7000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (10)
	CreateDynamicObject(2060,317.1000100,-1487.8000500,23.7000000,0.0000000,359.7460000,96.2460000); //object(cj_sandbag) (11)
	CreateDynamicObject(2060,316.3999900,-1487.3000500,23.7000000,0.0000000,359.7420000,158.2400000); //object(cj_sandbag) (12)
	CreateDynamicObject(2060,316.3999900,-1487.3000500,23.9000000,0.0000000,359.7360000,158.2360000); //object(cj_sandbag) (13)
	CreateDynamicObject(2060,316.3999900,-1487.3000500,24.1000000,0.0000000,359.7360000,158.2360000); //object(cj_sandbag) (14)
	CreateDynamicObject(2060,316.3999900,-1487.3000500,24.3000000,0.0000000,359.7360000,158.2360000); //object(cj_sandbag) (15)
	CreateDynamicObject(2060,316.3999900,-1487.3000500,24.5000000,0.0000000,359.7360000,158.2360000); //object(cj_sandbag) (16)
	CreateDynamicObject(2060,317.1000100,-1488.6999500,24.5000000,0.0000000,3.2460000,96.2460000); //object(cj_sandbag) (17)
	CreateDynamicObject(2061,302.5000000,-1487.5999800,24.9000000,0.0000000,0.0000000,0.0000000); //object(cj_shells1) (1)
	CreateDynamicObject(1242,298.0000000,-1520.6999500,24.8000000,0.0000000,0.0000000,57.7500000); //object(bodyarmour) (1)
	CreateDynamicObject(1411,354.7999900,-1462.9000200,29.7000000,0.0000000,0.0000000,100.0000000); //object(dyn_mesh_1) (3)
	CreateDynamicObject(1411,355.7999900,-1468.0999800,29.7000000,0.0000000,0.0000000,99.9980000); //object(dyn_mesh_1) (4)
	CreateDynamicObject(1411,339.6000100,-1465.9000200,27.8000000,0.0000000,0.0000000,127.9980000); //object(dyn_mesh_1) (5)
	CreateDynamicObject(1411,342.7999900,-1470.0000000,27.8000000,0.0000000,0.0000000,127.9960000); //object(dyn_mesh_1) (6)
	CreateDynamicObject(1411,324.3999900,-1481.0000000,25.8000000,0.0000000,0.0000000,147.9960000); //object(dyn_mesh_1) (7)
	CreateDynamicObject(1411,328.8999900,-1483.8000500,25.8000000,0.0000000,0.0000000,147.9910000); //object(dyn_mesh_1) (8)
	CreateDynamicObject(1411,334.5000000,-1473.0000000,26.9000000,0.0000000,0.0000000,137.2410000); //object(dyn_mesh_1) (9)
	CreateDynamicObject(1411,330.7000100,-1469.5000000,26.9000000,0.0000000,0.0000000,137.2410000); //object(dyn_mesh_1) (10)
	CreateDynamicObject(1411,346.7000100,-1465.5999800,28.6000000,0.0000000,0.0000000,105.9960000); //object(dyn_mesh_1) (11)
	CreateDynamicObject(1411,345.1000100,-1460.5999800,28.6000000,0.0000000,0.0000000,105.9960000); //object(dyn_mesh_1) (12)
	CreateDynamicObject(1411,359.7999900,-1466.4000200,30.7000000,0.0000000,0.0000000,55.9980000); //object(dyn_mesh_1) (13)
	CreateDynamicObject(1411,362.7000100,-1462.0000000,30.7000000,0.0000000,0.0000000,55.9970000); //object(dyn_mesh_1) (14)
	CreateDynamicObject(1411,328.8999900,-1477.1999500,26.2000000,0.0000000,0.0000000,137.2410000); //object(dyn_mesh_1) (15)
	CreateDynamicObject(1411,325.0000000,-1473.6999500,26.2000000,0.0000000,0.0000000,137.2410000); //object(dyn_mesh_1) (16)
	CreateDynamicObject(1411,322.6000100,-1487.6999500,25.1000000,0.0000000,0.0000000,147.9910000); //object(dyn_mesh_1) (17)
	CreateDynamicObject(1411,318.0000000,-1485.0000000,25.1000000,0.0000000,0.0000000,147.9910000); //object(dyn_mesh_1) (18)
	CreateDynamicObject(1411,338.0000000,-1469.5000000,27.4000000,0.0000000,0.0000000,127.9960000); //object(dyn_mesh_1) (19)
	CreateDynamicObject(1411,334.7999900,-1465.4000200,27.4000000,0.0000000,0.0000000,127.9960000); //object(dyn_mesh_1) (20)
	CreateDynamicObject(1411,350.2999900,-1464.9000200,28.6000000,0.0000000,0.0000000,100.9960000); //object(dyn_mesh_1) (21)
	CreateDynamicObject(1411,349.2999900,-1459.6999500,28.6000000,0.0000000,0.0000000,100.9920000); //object(dyn_mesh_1) (22)
	CreateDynamicObject(1411,362.5000000,-1467.5999800,31.3000000,0.0000000,0.0000000,55.9970000); //object(dyn_mesh_1) (23)
	CreateDynamicObject(1411,365.3999900,-1463.1999500,31.3000000,0.0000000,0.0000000,55.9970000); //object(dyn_mesh_1) (24)
	CreateDynamicObject(8302,310.4090000,-1508.3709700,24.8760000,0.0000000,0.0000000,350.0000000); //object(jumpbox01_lvs01) (1)
	CreateDynamicObject(2991,308.7189900,-1492.7149700,24.2210000,0.0000000,0.0000000,30.0000000); //object(imy_bbox) (1)
	CreateDynamicObject(3015,303.8360000,-1486.6600300,23.8190000,0.0000000,0.0000000,48.0000000); //object(cr_cratestack) (1)
	CreateDynamicObject(3015,302.9423800,-1487.5136700,24.6820000,0.0000000,0.0000000,0.0000000); //object(cr_cratestack) (2)
	CreateDynamicObject(930,314.0880100,-1496.4659400,24.0700000,0.0000000,0.0000000,0.0000000); //object(o2_bottles) (1)
	CreateDynamicObject(925,328.8790000,-1495.5150100,24.9840000,0.0000000,0.0000000,235.5000000); //object(rack2) (1)
	CreateDynamicObject(931,327.3840000,-1497.4670400,24.9840000,0.0000000,0.0000000,234.0000000); //object(rack3) (1)
	CreateDynamicObject(931,327.3840000,-1497.4670400,27.0840000,0.0000000,0.0000000,233.9980000); //object(rack3) (2)
	CreateDynamicObject(964,327.4370100,-1497.3769500,26.1300000,0.0000000,0.0000000,233.5000000); //object(cj_metal_crate) (1)
	CreateDynamicObject(1685,302.0419900,-1517.3990500,24.3510000,0.0000000,0.0000000,16.0000000); //object(blockpallet) (6)
	CreateDynamicObject(1685,296.6850000,-1523.6519800,24.3510000,0.0000000,0.0000000,59.9960000); //object(blockpallet) (7)
	CreateDynamicObject(1685,296.6850000,-1523.6510000,25.8260000,0.0000000,0.0000000,127.4910000); //object(blockpallet) (8)
	CreateDynamicObject(2567,302.8030100,-1527.7309600,25.8490000,0.0000000,0.0000000,326.0000000); //object(ab_warehouseshelf) (1)
	CreateDynamicObject(3577,292.6680000,-1498.2829600,24.7110000,0.0000000,0.0000000,292.0000000); //object(dockcrates1_la) (1)
	CreateDynamicObject(3633,327.3999900,-1497.3310500,24.4740000,0.5000000,0.0000000,61.5000000); //object(imoildrum4_las) (1)
	CreateDynamicObject(2359,327.1770000,-1497.0959500,27.4630000,0.0000000,0.0000000,83.2500000); //object(ammo_box_c5) (1)
	CreateDynamicObject(2866,307.8909900,-1493.6469700,24.8510000,0.0000000,0.0000000,0.0000000); //object(gb_foodwrap04) (1)
	CreateDynamicObject(2867,304.1839900,-1513.5760500,24.5340000,0.0000000,0.0000000,0.0000000); //object(gb_foodwrap05) (1)
	CreateDynamicObject(960,303.3640100,-1496.6939700,23.9820000,0.0000000,0.0000000,0.0000000); //object(cj_arm_crate) (1)
	CreateDynamicObject(2859,303.3219900,-1496.6219500,23.6960000,0.0000000,0.0000000,0.0000000); //object(gb_kitchtakeway04) (1)
	CreateDynamicObject(3860,298.5090000,-1489.0539600,24.7660000,0.0000000,0.0000000,50.0000000); //object(marketstall04_sfxrf) (1)
	CreateDynamicObject(2926,298.5390000,-1490.0579800,24.4120000,0.0000000,0.0000000,0.0000000); //object(dyno_box_a) (1)
	CreateDynamicObject(2057,299.9979900,-1485.7399900,23.7640000,0.0000000,0.0000000,0.0000000); //object(flame_tins) (1)
	CreateDynamicObject(3787,314.8259900,-1498.2860100,24.1600000,0.0000000,0.0000000,0.0000000); //object(missile_02_sfxr) (1)
	CreateDynamicObject(3796,289.6470000,-1508.5119600,23.9220000,0.0000000,0.0000000,94.0000000); //object(acbox1_sfs) (1)
	CreateDynamicObject(3800,302.7940100,-1519.0810500,23.5940000,0.0000000,0.0000000,304.0000000); //object(acbox4_sfs) (1)
	CreateDynamicObject(3800,303.3859900,-1520.6820100,23.5940000,0.0000000,0.0000000,349.9970000); //object(acbox4_sfs) (2)
	CreateDynamicObject(3800,303.3859900,-1520.6820100,24.6690000,0.0000000,0.0000000,349.9970000); //object(acbox4_sfs) (3)
	CreateDynamicObject(3800,302.8760100,-1519.3630400,24.6690000,0.0000000,0.0000000,333.9970000); //object(acbox4_sfs) (4)
	CreateDynamicObject(3749,469.2600100,-1588.2209500,34.0530000,0.0000000,359.5000000,92.0000000); //object(clubgate01_lax) (1)
	CreateDynamicObject(3749,469.2070000,-1588.1479500,22.9030000,359.7500000,180.2500000,272.0010000); //object(clubgate01_lax) (2)
	CreateDynamicObject(3049,470.9639900,-1578.2989500,26.1140000,0.0000000,0.0000000,271.0000000); //object(des_quarrygate) (1)
	CreateDynamicObject(3049,470.8949900,-1573.8100600,26.1140000,0.0000000,0.0000000,271.0000000); //object(des_quarrygate) (2)
	CreateDynamicObject(3049,471.6239900,-1602.3210400,25.9390000,0.0000000,0.0000000,271.0000000); //object(des_quarrygate) (3)
	CreateDynamicObject(3049,471.7009900,-1606.8179900,25.9390000,0.0000000,0.0000000,271.0000000); //object(des_quarrygate) (4)
	CreateDynamicObject(3049,469.7670000,-1610.8819600,25.8640000,0.0000000,0.0000000,246.2500000); //object(des_quarrygate) (5)
	CreateDynamicObject(3036,466.7650100,-1584.8530300,26.0750000,0.0000000,0.0000000,89.2500000); //object(ct_gatexr) (1)
	CreateDynamicObject(3036,467.2739900,-1597.4770500,26.0750000,0.0000000,0.0000000,90.7470000); //object(ct_gatexr) (2)
	CreateDynamicObject(2947,466.6099900,-1579.7039800,33.8380000,0.0000000,0.0000000,1.7500000); //object(cr_door_01) (1)
	CreateDynamicObject(1437,466.4800100,-1580.4150400,28.9540000,9.5000000,0.0000000,269.5000000); //object(dyn_ladder_2) (5)
	CreateDynamicObject(1437,466.5710100,-1580.4260300,23.4290000,9.4980000,0.0000000,269.4950000); //object(dyn_ladder_2) (6)
	CreateDynamicObject(9819,400.6359900,-1528.4220000,32.0690000,0.0000000,0.0000000,45.7500000); //object(shpbridge_sfw02) (1)
	CreateDynamicObject(9818,319.5539900,-1506.6899400,25.5050000,0.0000000,0.0000000,325.2500000); //object(shpbridge_sfw01) (1)
	CreateDynamicObject(19903,398.5440100,-1540.8540000,31.4410000,0.0000000,0.0000000,45.0000000); //object(mechaniccomputer1) (1)
	//Decor
	CreateDynamicObject(16082,519.9000200,-1423.3000000,18.7000000,0.0000000,359.5000000,15.7500000); //object(des_quarryplatform) (1)
	CreateDynamicObject(3066,532.5000000,-1408.4000000,16.0000000,0.0000000,0.0000000,14.2500000); //object(ammotrn_obj) (1)
	CreateDynamicObject(3066,527.4000200,-1409.4000000,16.0000000,0.0000000,0.0000000,14.2490000); //object(ammotrn_obj) (2)
	CreateDynamicObject(3066,521.7999900,-1410.9000000,16.0000000,0.0000000,0.0000000,14.2490000); //object(ammotrn_obj) (3)
	CreateDynamicObject(987,1577.5996000,-1647.2002000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (1)
	CreateDynamicObject(987,1577.6000000,-1659.1000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (2)
	CreateDynamicObject(987,1577.6000000,-1671.1000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (3)
	CreateDynamicObject(987,1577.6000000,-1682.6000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (4)
	CreateDynamicObject(987,1577.6000000,-1694.6000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (5)
	CreateDynamicObject(987,1577.6000000,-1706.6000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (6)
	CreateDynamicObject(987,1577.6000000,-1714.5000000,27.2000000,0.0000000,0.0000000,90.0000000); //object(elecfence_bar) (7)
	CreateDynamicObject(987,1565.7000000,-1714.4000000,27.2000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (8)
	CreateDynamicObject(987,1553.7000000,-1714.4000000,27.2000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (9)
	CreateDynamicObject(987,1542.6000000,-1714.4000000,27.2000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (10)
	CreateDynamicObject(987,1542.7000000,-1702.5000000,27.2000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (11)
	CreateDynamicObject(987,1542.8000000,-1700.6000000,27.2000000,0.0000000,0.0000000,270.0000000); //object(elecfence_bar) (12)
	CreateDynamicObject(987,1554.7000000,-1700.8000000,27.2000000,0.0000000,0.0000000,179.5000000); //object(elecfence_bar) (13)
	CreateDynamicObject(987,1554.5000000,-1688.8000000,27.2000000,0.0000000,0.0000000,270.9950000); //object(elecfence_bar) (14)
	CreateDynamicObject(987,1554.8000000,-1676.8000000,27.2000000,0.0000000,0.0000000,268.7440000); //object(elecfence_bar) (15)
	CreateDynamicObject(987,1555.2000000,-1664.8000000,27.2000000,0.0000000,0.0000000,268.2420000); //object(elecfence_bar) (16)
	CreateDynamicObject(987,1542.6000000,-1637.2000000,27.2000000,0.0000000,0.0000000,269.7390000); //object(elecfence_bar) (17)
	CreateDynamicObject(987,1554.9000000,-1652.8000000,27.2000000,0.0000000,0.0000000,271.9920000); //object(elecfence_bar) (18)
	CreateDynamicObject(987,1554.3000000,-1648.7000000,27.2000000,0.0000000,0.0000000,274.4920000); //object(elecfence_bar) (19)
	CreateDynamicObject(987,1542.4000000,-1648.5000000,27.2000000,0.0000000,0.0000000,358.2380000); //object(elecfence_bar) (20)
	CreateDynamicObject(987,1554.5000000,-1637.6000000,27.2000000,0.0000000,0.0000000,178.4890000); //object(elecfence_bar) (21)
	CreateDynamicObject(987,1566.5000000,-1637.9000200,27.2000000,0.0000000,0.0000000,178.4840000); //object(elecfence_bar) (22)
	CreateDynamicObject(987,1573.7998000,-1638.0996000,27.2000000,0.0000000,0.0000000,178.4840000); //object(elecfence_bar) (23)
	CreateDynamicObject(980,1569.2998000,-1638.5000000,30.2000000,0.0000000,0.0000000,358.4950000); //object(airportgate) (1)
	CreateDynamicObject(3864,1565.0000000,-1641.8000000,33.5000000,0.0000000,0.0000000,206.0000000); //object(ws_floodlight) (1)
	CreateDynamicObject(1465,1575.1000000,-1712.2000000,28.6000000,0.0000000,0.0000000,180.0000000); //object(dyn_scaffold_4) (1)
	CreateDynamicObject(1465,1572.1000000,-1712.3000000,28.6000000,0.0000000,0.0000000,179.9950000); //object(dyn_scaffold_4) (2)
	CreateDynamicObject(1465,1569.1000000,-1712.2000000,28.6000000,0.0000000,0.0000000,179.9950000); //object(dyn_scaffold_4) (3)
	CreateDynamicObject(2677,1567.3000000,-1640.2000000,27.7000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_7) (1)
	CreateDynamicObject(2677,1561.4000000,-1642.8000000,27.7000000,0.0000000,0.0000000,60.0000000); //object(proc_rubbish_7) (2)
	CreateDynamicObject(2677,1564.6000000,-1645.2000000,27.7000000,0.0000000,0.0000000,335.9960000); //object(proc_rubbish_7) (3)
	CreateDynamicObject(2677,1566.9000000,-1644.2000000,27.7000000,0.0000000,0.0000000,47.9950000); //object(proc_rubbish_7) (4)
	CreateDynamicObject(16093,1550.7000000,-1643.4000000,27.3000000,0.0000000,0.0000000,177.9900000); //object(a51_gatecontrol) (2)
	CreateDynamicObject(16095,1565.2000000,-1664.0000000,27.4000000,0.0000000,0.0000000,0.0000000); //object(des_a51guardbox02) (1)
	CreateDynamicObject(16287,1552.2002000,-1706.4004000,27.4000000,0.0000000,0.0000000,90.0000000); //object(des_fshed1_) (1)
	CreateDynamicObject(16322,1572.5000000,-1639.5000000,31.5000000,0.0000000,0.0000000,0.0000000); //object(a51_plat) (1)
	CreateDynamicObject(9819,1555.4004000,-1709.0303000,28.0000000,0.0000000,0.0000000,269.9730000); //object(shpbridge_sfw02) (1)
	CreateDynamicObject(3385,1552.0000000,-1709.0000000,27.4000000,0.0000000,0.0000000,0.0000000); //object(a51_light1_) (1)
	CreateDynamicObject(2922,1544.9000000,-1705.4000000,29.2000000,0.0000000,0.0000000,268.0000000); //object(kmb_keypad) (1)
	CreateDynamicObject(2921,1577.5000000,-1638.2000000,31.9000000,0.0000000,0.0000000,0.0000000); //object(kmb_cam) (1)
	CreateDynamicObject(2985,1575.6000000,-1639.7000000,30.7000000,0.0000000,38.0000000,80.0000000); //object(minigun_base) (1)
	CreateDynamicObject(3386,1545.3000000,-1709.4000000,27.4000000,0.0000000,0.0000000,0.0000000); //object(a51_srack2_) (1)
	CreateDynamicObject(3386,1545.4000000,-1703.3000000,27.4000000,0.0000000,0.0000000,0.0000000); //object(a51_srack2_) (2)
	CreateDynamicObject(3395,1549.4004000,-1709.7200000,27.4000000,0.0000000,0.0000000,270.0000000); //object(a51_sdsk_3_) (1)
	CreateDynamicObject(3794,1573.8000000,-1712.2000000,28.0000000,0.0000000,0.0000000,0.0000000); //object(missile_07_sfxr) (1)
	CreateDynamicObject(3383,1553.8000000,-1706.2000000,27.4000000,0.0000000,0.0000000,0.0000000); //object(a51_labtable1_) (1)
	CreateDynamicObject(2905,1552.7000000,-1706.3000000,28.9000000,270.0000000,2.0000000,100.0000000); //object(kmb_deadleg) (1)
	CreateDynamicObject(2906,1555.3000000,-1706.7000000,28.5000000,0.0000000,184.0000000,58.0000000); //object(kmb_deadarm) (1)
	CreateDynamicObject(2907,1554.1000000,-1706.2000000,28.6000000,0.0000000,0.0000000,274.0000000); //object(kmb_deadtorso) (1)
	CreateDynamicObject(2908,1553.5701000,-1706.2700000,28.6440000,0.0000000,92.0000000,272.0000000); //object(kmb_deadhead) (1)
	CreateDynamicObject(2905,1553.4000000,-1706.3000000,28.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (2)
	CreateDynamicObject(2906,1552.0000000,-1706.1000000,28.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (2)
	CreateDynamicObject(974,1544.8000000,-1706.9000000,27.5000000,0.0000000,0.0000000,271.0000000); //object(tall_fence) (2)
	CreateDynamicObject(3394,1557.8000000,-1703.1000000,27.4000000,0.0000000,0.0000000,92.0000000); //object(a51_sdsk_2_) (1)
	CreateDynamicObject(3260,2469.3999000,-1646.0000000,13.4000000,0.0000000,0.0000000,0.0000000); //object(oldwoodpanel) (1)
	CreateDynamicObject(3260,2486.5000000,-1644.2000000,14.1000000,0.0000000,0.0000000,182.0000000); //object(oldwoodpanel) (2)
	CreateDynamicObject(3260,2498.6001000,-1642.5000000,13.8000000,14.9960000,357.9950000,180.7500000); //object(oldwoodpanel) (3)
	CreateDynamicObject(1448,2495.7000000,-1641.7000000,15.0000000,0.0000000,90.2500000,271.7500000); //object(dyn_crate_1) (1)
	CreateDynamicObject(1448,2501.0000000,-1641.6000000,14.9000000,0.0000000,268.0000000,266.7500000); //object(dyn_crate_1) (2)
	CreateDynamicObject(1219,2496.7000000,-1690.0000000,18.3000000,0.0000000,89.0000000,90.0000000); //object(palette) (1)
	CreateDynamicObject(1219,2491.3999000,-1690.0000000,18.3000000,0.0000000,90.2450000,90.0000000); //object(palette) (2)
	CreateDynamicObject(1219,2492.0000000,-1693.8000000,15.6000000,0.0000000,269.2470000,89.2490000); //object(palette) (3)
	CreateDynamicObject(1219,2493.5000000,-1691.0000000,15.1000000,0.0000000,254.7470000,89.9990000); //object(palette) (4)
	CreateDynamicObject(17969,2469.4490000,-1702.6000000,13.8000000,0.0000000,0.0000000,180.0000000); //object(hub_graffitti) (1)
	CreateDynamicObject(17969,2592.2000000,-1615.5000000,16.4000000,0.0000000,269.7500000,0.0000000); //object(hub_graffitti) (2)
	CreateDynamicObject(1946,2531.2000000,-1665.0000000,14.4000000,0.0000000,0.0000000,0.0000000); //object(baskt_ball_hi) (1)
	CreateDynamicObject(1219,2517.8000000,-1688.0000000,14.6000000,0.0000000,270.0000000,330.0000000); //object(palette) (5)
	CreateDynamicObject(1219,2513.3999000,-1693.4000000,14.6000000,0.0000000,270.0000000,321.9960000); //object(palette) (6)
	CreateDynamicObject(1219,2523.7000000,-1679.5000000,15.8000000,0.0000000,90.0000000,358.7500000); //object(palette) (7)
	CreateDynamicObject(1219,2525.1001000,-1658.8000000,16.1000000,0.0000000,274.5000000,0.0000000); //object(palette) (8)
	CreateDynamicObject(1219,2525.3999000,-1660.8000000,16.1000000,0.0000000,274.4990000,0.0000000); //object(palette) (9)
	CreateDynamicObject(1219,2525.3999000,-1655.2000000,16.1000000,0.0000000,274.4990000,0.0000000); //object(palette) (10)
	CreateDynamicObject(1219,2514.0000000,-1649.7000000,14.4000000,0.0000000,89.7500000,224.2500000); //object(palette) (11)
	CreateDynamicObject(1219,2489.3000000,-1644.3000000,14.8000000,0.0000000,271.0000000,90.5000000); //object(palette) (13)
	CreateDynamicObject(1219,2451.8999000,-1640.9000000,14.4000000,0.0000000,269.0000000,90.0000000); //object(palette) (14)
	CreateDynamicObject(1448,2454.3999000,-1640.8000000,15.0000000,0.0000000,88.0000000,269.7500000); //object(dyn_crate_1) (3)
	CreateDynamicObject(1448,2449.2000000,-1640.7000000,15.0000000,0.0000000,88.7450000,269.7470000); //object(dyn_crate_1) (4)
	CreateDynamicObject(2845,2397.3000000,-1722.0000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes04) (1)
	CreateDynamicObject(14863,2396.1001000,-1716.8000000,13.2000000,0.0000000,0.0000000,34.0000000); //object(clothes) (1)
	CreateDynamicObject(14890,2400.1001000,-1705.3000000,12.8000000,0.0000000,0.0000000,17.0000000); //object(millie-vibrators) (1)
	CreateDynamicObject(3594,2394.1006000,-1719.0996000,13.6000000,0.0000000,35.4970000,3.9940000); //object(la_fuckcar1) (1)
	CreateDynamicObject(3593,2406.8000000,-1718.9000000,15.0000000,45.0000000,180.0000000,6.0000000); //object(la_fuckcar2) (1)
	CreateDynamicObject(6965,2492.2998000,-1711.5000000,1007.5000000,0.0000000,0.0000000,0.0000000); //object(venefountain02) (2)
	CreateDynamicObject(6965,2490.8999000,-1694.3000000,1008.9000000,0.0000000,0.0000000,0.0000000); //object(venefountain02) (3)
	CreateDynamicObject(4206,2482.6006000,-1692.7998000,1013.7922000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (2)
	CreateDynamicObject(4206,2490.9004000,-1717.5000000,1013.7490000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (3)
	CreateDynamicObject(2908,2493.3999000,-1697.9000000,1014.4000000,0.0000000,0.0000000,250.0000000); //object(kmb_deadhead) (2)
	CreateDynamicObject(2907,2492.8999000,-1695.2000000,1013.9000000,0.0000000,0.0000000,238.0000000); //object(kmb_deadtorso) (2)
	CreateDynamicObject(2905,2490.8000000,-1695.6000000,1013.8000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (3)
	CreateDynamicObject(2045,2493.5000000,-1697.6000000,1014.4002000,9.0000000,45.2500000,170.5000000); //object(cj_bbat_nails) (1)
	CreateDynamicObject(2044,2493.2998000,-1702.5996000,1014.6000000,0.0000000,0.0000000,0.0000000); //object(cj_mp5k) (1)
	CreateDynamicObject(1582,2492.8999000,-1703.3000000,1014.5699000,0.0000000,0.0000000,0.0000000); //object(pizzabox) (1)
	CreateDynamicObject(2702,2493.5000000,-1703.3000000,1014.5800000,0.0000000,268.2500000,244.7500000); //object(cj_pizza_1) (1)
	CreateDynamicObject(2289,2492.0000000,-1699.8500000,1019.5000000,0.0000000,0.0000000,0.0000000); //object(frame_2) (1)
	CreateDynamicObject(2319,2499.6001000,-1703.5000000,1015.6000000,0.0000000,324.0000000,272.0000000); //object(cj_tv_table5) (1)
	CreateDynamicObject(2321,2498.8000000,-1701.5000000,1014.7000000,0.0000000,316.5000000,283.2500000); //object(cj_tv_table6) (1)
	CreateDynamicObject(3016,2493.5000000,-1708.2000000,1014.8000000,0.0000000,0.0000000,0.0000000); //object(cr_ammobox_nonbrk) (1)
	CreateDynamicObject(3014,2493.7000000,-1710.3000000,1014.0000000,0.0000000,0.0000000,0.0000000); //object(cr_guncrate) (1)
	CreateDynamicObject(3052,2493.7000000,-1709.8000000,1013.9000000,0.0000000,0.0000000,0.0000000); //object(db_ammo) (1)
	CreateDynamicObject(3052,2493.2000000,-1708.3000000,1013.9000000,0.0000000,0.0000000,0.0000000); //object(db_ammo) (2)
	CreateDynamicObject(2907,2495.5000000,-1702.4000000,1018.0500000,0.0000000,0.2500000,93.2500000); //object(kmb_deadtorso) (3)
	CreateDynamicObject(2906,2493.2000000,-1706.6000000,1017.4000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (3)
	CreateDynamicObject(2905,2493.7000000,-1700.6000000,1017.4000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (4)
	CreateDynamicObject(2905,2490.7000000,-1702.8000000,1017.5800000,65.0000000,0.0000000,96.0000000); //object(kmb_deadleg) (5)
	CreateDynamicObject(2906,2495.8999000,-1700.7000000,1017.4000000,10.0000000,262.0000000,94.0000000); //object(kmb_deadarm) (4)
	CreateDynamicObject(2906,2496.7000000,-1703.2000000,1017.4000000,0.0000000,155.9950000,181.9990000); //object(kmb_deadarm) (5)
	CreateDynamicObject(2908,2496.6001000,-1705.6000000,1017.4000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (3)
	CreateDynamicObject(2672,2400.8000000,-1717.6000000,12.9000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_4) (1)
	CreateDynamicObject(2676,2402.6001000,-1719.3000000,12.7000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_8) (1)
	CreateDynamicObject(2677,2401.6001000,-1721.1000000,12.9000000,0.0000000,0.0000000,40.0000000); //object(proc_rubbish_7) (5)
	CreateDynamicObject(3029,2403.9004000,-1718.2998000,12.6000000,0.0000000,77.9970000,89.7470000); //object(cr1_door) (1)
	CreateDynamicObject(3675,2491.6001000,-1708.9000000,1012.6000000,90.0000000,354.0480000,19.9520000); //object(laxrf_refinerypipe) (1)
	CreateDynamicObject(16322,1545.1000000,-1361.8000000,332.5000000,0.0000000,0.0000000,0.0000000); //object(a51_plat) (2)
	CreateDynamicObject(3095,1563.1000000,-1365.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (1)
	CreateDynamicObject(3095,1563.0996000,-1356.0996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (2)
	CreateDynamicObject(3095,1563.1000000,-1347.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (3)
	CreateDynamicObject(3095,1563.3000000,-1374.0000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (4)
	CreateDynamicObject(3095,1554.3000000,-1374.0000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (11)
	CreateDynamicObject(3095,1545.4000000,-1374.0000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (12)
	CreateDynamicObject(3095,1563.1000000,-1338.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (13)
	CreateDynamicObject(3095,1554.4000000,-1338.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (15)
	CreateDynamicObject(3095,1545.4000000,-1338.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (16)
	CreateDynamicObject(3095,1536.4000000,-1338.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (17)
	CreateDynamicObject(3095,1527.5996000,-1338.0996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (18)
	CreateDynamicObject(3095,1527.6000000,-1347.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (19)
	CreateDynamicObject(3095,1527.5000000,-1355.6000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (20)
	CreateDynamicObject(3095,1527.5000000,-1364.5999800,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (21)
	CreateDynamicObject(3095,1527.5000000,-1373.5996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (22)
	CreateDynamicObject(3095,1536.5000000,-1373.7998000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (23)
	CreateDynamicObject(3095,1554.0996000,-1347.0996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (24)
	CreateDynamicObject(3095,1545.1000000,-1347.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (25)
	CreateDynamicObject(3095,1536.3000000,-1347.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (26)
	CreateDynamicObject(3095,1536.4004000,-1356.0996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (27)
	CreateDynamicObject(3095,1545.3000000,-1356.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (28)
	CreateDynamicObject(3095,1554.2002000,-1356.0996000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (29)
	CreateDynamicObject(3095,1555.6000000,-1365.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (30)
	CreateDynamicObject(3095,1535.9000000,-1365.1000000,328.1000100,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (31)
	CreateDynamicObject(987,1523.6000000,-1377.9000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (24)
	CreateDynamicObject(987,1535.6000000,-1377.8000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (25)
	CreateDynamicObject(987,1547.6000000,-1377.8000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (26)
	CreateDynamicObject(987,1555.5000000,-1377.8000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (27)
	CreateDynamicObject(987,1567.2000000,-1377.9000000,328.7000100,0.0000000,0.0000000,90.5000000); //object(elecfence_bar) (28)
	CreateDynamicObject(987,1567.0996000,-1365.9004000,328.7000100,0.0000000,0.0000000,90.5000000); //object(elecfence_bar) (29)
	CreateDynamicObject(987,1567.0000000,-1353.9000000,328.7000100,0.0000000,0.0000000,90.5000000); //object(elecfence_bar) (30)
	CreateDynamicObject(987,1566.9000000,-1345.6000000,328.7000100,0.0000000,0.0000000,90.5000000); //object(elecfence_bar) (31)
	CreateDynamicObject(987,1566.8000500,-1333.6999500,328.7000100,0.0000000,0.0000000,180.2500000); //object(elecfence_bar) (32)
	CreateDynamicObject(987,1554.7998000,-1333.7998000,328.7000100,0.0000000,0.0000000,180.9940000); //object(elecfence_bar) (33)
	CreateDynamicObject(987,1542.8000000,-1334.0000000,328.7000100,0.0000000,0.0000000,180.9940000); //object(elecfence_bar) (34)
	CreateDynamicObject(987,1535.3000000,-1334.3000000,328.7000100,0.0000000,0.0000000,179.4940000); //object(elecfence_bar) (35)
	CreateDynamicObject(987,1523.7002000,-1334.2002000,328.7000100,0.0000000,0.0000000,269.4840000); //object(elecfence_bar) (36)
	CreateDynamicObject(987,1523.6000000,-1346.2000000,328.7000100,0.0000000,0.0000000,269.4840000); //object(elecfence_bar) (37)
	CreateDynamicObject(987,1523.4000000,-1358.2000000,328.7000100,0.0000000,0.0000000,269.4840000); //object(elecfence_bar) (38)
	CreateDynamicObject(987,1523.4000000,-1366.0000000,328.7000100,0.0000000,0.0000000,270.9840000); //object(elecfence_bar) (39)
	CreateDynamicObject(2928,1528.1000000,-1377.8000000,329.8999900,0.0000000,0.0000000,0.0000000); //object(a51_intdoor) (1)
	CreateDynamicObject(3279,1529.1000000,-1339.5000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (1)
	CreateDynamicObject(3279,1562.1000000,-1373.2000000,328.7000100,0.0000000,0.0000000,182.0000000); //object(a51_spottower) (2)
	CreateDynamicObject(3794,1532.1000000,-1376.0000000,329.2999900,0.0000000,0.0000000,0.0000000); //object(missile_07_sfxr) (2)
	CreateDynamicObject(3791,1532.0996000,-1374.5996000,329.1000100,0.0000000,0.0000000,0.0000000); //object(missile_10_sfxr) (1)
	CreateDynamicObject(3789,1535.3000000,-1376.2000000,329.0000000,0.0000000,0.0000000,0.0000000); //object(missile_09_sfxr) (1)
	CreateDynamicObject(3787,1535.4000000,-1373.7000000,329.2000100,0.0000000,0.0000000,32.0000000); //object(missile_02_sfxr) (1)
	CreateDynamicObject(16782,1528.0000000,-1377.7000000,329.7999900,0.0000000,0.0000000,91.2500000); //object(a51_radar_scan) (1)
	CreateDynamicObject(3877,1522.4000000,-1378.4000000,329.7000700,0.0000000,324.0000000,30.5000000); //object(sf_rooflite) (1)
	CreateDynamicObject(2774,1532.1000000,-1342.0000000,315.3999900,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (2)
	CreateDynamicObject(2774,1526.7000000,-1352.8000000,315.3999900,0.0000000,0.0000000,0.0000000); //object(cj_airp_pillars) (3)
	CreateDynamicObject(2774,1528.5000000,-1364.1000000,315.3999900,0.0000000,0.0000000,28.0000000); //object(cj_airp_pillars) (4)
	CreateDynamicObject(2774,1538.9000000,-1371.3000000,315.3999900,0.0000000,0.0000000,341.9990000); //object(cj_airp_pillars) (5)
	CreateDynamicObject(2774,1550.8000000,-1371.8000000,315.3999900,0.0000000,0.0000000,19.2430000); //object(cj_airp_pillars) (6)
	CreateDynamicObject(2774,1560.9000000,-1364.6000000,315.3999900,0.0000000,0.5000000,69.2430000); //object(cj_airp_pillars) (7)
	CreateDynamicObject(2774,1563.0000000,-1352.9000000,315.3999900,0.0000000,0.0000000,11.2430000); //object(cj_airp_pillars) (8)
	CreateDynamicObject(2774,1556.5000000,-1342.6000000,315.3999900,0.0000000,0.0000000,54.7390000); //object(cj_airp_pillars) (9)
	CreateDynamicObject(2774,1544.6000000,-1338.8000000,315.3999900,0.0000000,0.0000000,86.9840000); //object(cj_airp_pillars) (10)
	CreateDynamicObject(3877,1522.7000000,-1333.2000000,329.7000100,0.0000000,323.9980000,317.4980000); //object(sf_rooflite) (2)
	CreateDynamicObject(3877,1568.0000000,-1333.5000000,329.7000100,0.0000000,323.9980000,215.4940000); //object(sf_rooflite) (3)
	CreateDynamicObject(3877,1568.2000000,-1378.9000000,329.7000100,0.0000000,323.9980000,140.7410000); //object(sf_rooflite) (4)
	CreateDynamicObject(16287,1552.0000000,-1350.2000000,328.7000100,0.0000000,0.0000000,270.0000000); //object(des_fshed1_) (2)
	CreateDynamicObject(2951,1559.3000000,-1349.6000000,328.7000100,0.0000000,0.0000000,270.0000000); //object(a51_labdoor) (5)
	CreateDynamicObject(3884,1562.4004000,-1371.7998000,344.2999900,0.0000000,0.0000000,0.0000000); //object(samsite_sfxrf) (1)
	CreateDynamicObject(3884,1529.4004000,-1340.0996000,344.2999900,0.0000000,0.0000000,63.9950000); //object(samsite_sfxrf) (2)
	CreateDynamicObject(3384,1558.7000000,-1353.1000000,330.1000100,0.0000000,0.0000000,0.0000000); //object(a51_halbox_) (1)
	CreateDynamicObject(3383,1550.0000000,-1353.0000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(a51_labtable1_) (2)
	CreateDynamicObject(3383,1554.2000000,-1353.0000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(a51_labtable1_) (3)
	CreateDynamicObject(16096,1526.8000000,-1366.5000000,330.6000100,0.0000000,0.0000000,274.5000000); //object(des_a51guardbox04) (1)
	CreateDynamicObject(3388,1545.2000000,-1347.7000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(a51_srack4_) (1)
	CreateDynamicObject(3388,1545.2000000,-1352.9000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(a51_srack4_) (2)
	CreateDynamicObject(4100,1560.1000000,-1354.2000000,330.3999900,0.0000000,0.0000000,319.0000000); //object(meshfence1_lan) (1)
	CreateDynamicObject(4100,1560.3000000,-1346.3000000,330.3999900,0.0000000,0.0000000,319.9990000); //object(meshfence1_lan) (2)
	CreateDynamicObject(3396,1549.3000000,-1347.0000000,328.7000100,0.0000000,0.0000000,90.2500000); //object(a51_sdsk_4_) (1)
	CreateDynamicObject(3397,1552.8000000,-1347.0000000,328.7000100,0.0000000,0.0000000,91.0000000); //object(a51_sdsk_1_) (1)
	CreateDynamicObject(1714,1550.0996000,-1348.9004000,328.7000100,0.0000000,0.0000000,205.9990000); //object(kb_swivelchair1) (1)
	CreateDynamicObject(1714,1552.4000000,-1348.3000000,328.7000100,0.0000000,0.0000000,161.9990000); //object(kb_swivelchair1) (2)
	CreateDynamicObject(2907,1563.8000000,-1349.9000000,328.7999900,0.0000000,0.0000000,316.0000000); //object(kmb_deadtorso) (4)
	CreateDynamicObject(2907,1560.5000000,-1347.5000000,328.7999900,0.0000000,0.0000000,134.0000000); //object(kmb_deadtorso) (5)
	CreateDynamicObject(2907,1565.4000000,-1353.8000000,328.7999900,0.0000000,0.0000000,281.9950000); //object(kmb_deadtorso) (6)
	CreateDynamicObject(2905,1561.1000000,-1350.5000000,329.1000100,0.0000000,0.0000000,330.0000000); //object(kmb_deadleg) (6)
	CreateDynamicObject(2905,1562.7000000,-1350.9000000,328.7000100,0.0000000,0.0000000,52.0000000); //object(kmb_deadleg) (7)
	CreateDynamicObject(2905,1563.4000000,-1348.8000000,328.7000100,0.0000000,0.0000000,319.9980000); //object(kmb_deadleg) (8)
	CreateDynamicObject(2905,1565.3000000,-1352.1000000,328.7000100,0.0000000,0.0000000,319.9930000); //object(kmb_deadleg) (9)
	CreateDynamicObject(2905,1566.3000000,-1352.2000000,328.7000100,0.0000000,0.0000000,181.9930000); //object(kmb_deadleg) (10)
	CreateDynamicObject(2905,1560.0000000,-1348.5000000,328.7000100,0.0000000,0.0000000,181.9890000); //object(kmb_deadleg) (11)
	CreateDynamicObject(2906,1560.9000000,-1348.6000000,328.7000100,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (6)
	CreateDynamicObject(2906,1559.9000000,-1346.8000000,328.7000100,0.0000000,182.0000000,44.0000000); //object(kmb_deadarm) (7)
	CreateDynamicObject(2906,1562.6000000,-1349.8000000,328.7000100,0.0000000,182.0000000,177.9950000); //object(kmb_deadarm) (8)
	CreateDynamicObject(2906,1564.2000000,-1350.2000000,328.7000100,0.0000000,270.0000000,305.9900000); //object(kmb_deadarm) (9)
	CreateDynamicObject(2906,1563.5000000,-1352.5000000,328.7000100,0.0000000,269.9950000,35.9860000); //object(kmb_deadarm) (10)
	CreateDynamicObject(2906,1566.0000000,-1351.2000000,328.7000100,0.0000000,71.9950000,265.9860000); //object(kmb_deadarm) (11)
	CreateDynamicObject(2908,1554.7000000,-1352.6000000,329.7999900,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (4)
	CreateDynamicObject(2908,1554.7000000,-1353.6000000,329.7999900,0.0000000,0.0000000,102.0000000); //object(kmb_deadhead) (5)
	CreateDynamicObject(2908,1553.2000000,-1353.1000000,329.7999900,0.0000000,180.0000000,237.9970000); //object(kmb_deadhead) (6)
	CreateDynamicObject(3385,1551.4000000,-1352.8000000,329.7999900,0.0000000,0.0000000,0.0000000); //object(a51_light1_) (2)
	CreateDynamicObject(2976,1550.3000000,-1352.8000000,329.8999900,41.7500000,270.0000000,103.5000000); //object(green_gloop) (1)
	CreateDynamicObject(2976,1549.8000000,-1352.1000000,329.8999900,41.7480000,270.0000000,69.4970000); //object(green_gloop) (2)
	CreateDynamicObject(2976,1548.6000000,-1352.7000000,329.8999900,41.7480000,270.0000000,107.4940000); //object(green_gloop) (3)
	CreateDynamicObject(2346,1525.8000000,-1367.9000000,332.5000000,0.0000000,0.0000000,0.0000000); //object(cj_hifi_table) (1)
	CreateDynamicObject(2316,1525.2000000,-1365.4000000,332.8999900,0.0000000,0.0000000,64.0000000); //object(cj_tele_4) (1)
	CreateDynamicObject(2232,1528.2000000,-1368.0000000,333.1000100,0.0000000,0.0000000,96.0000000); //object(med_speaker_4) (1)
	CreateDynamicObject(2225,1526.5000000,-1368.1000000,333.0000000,0.0000000,0.0000000,179.5000000); //object(swank_hi_fi_2) (1)
	CreateDynamicObject(2985,1542.0000000,-1362.0000000,331.7200000,0.0000000,37.0000000,272.0000000); //object(minigun_base) (2)
	CreateDynamicObject(2985,1545.1000000,-1361.6000000,331.7200000,0.0000000,38.7490000,262.2500000); //object(minigun_base) (3)
	CreateDynamicObject(2985,1547.8000000,-1361.9000000,331.6200000,0.0000000,15.4940000,301.9970000); //object(minigun_base) (4)
	CreateDynamicObject(1428,1547.8000000,-1361.2000000,330.2000100,14.0120000,359.0570000,177.8430000); //object(dyn_ladder) (1)
	CreateDynamicObject(2035,1528.6000000,-1366.2000000,332.6000100,0.0000000,0.0000000,48.0000000); //object(cj_m16) (1)
	CreateDynamicObject(16731,1559.7000000,-1636.9000000,20.0099600,0.0000000,0.0000000,359.2420000); //object(cxrf_a51_stairs08) (3)
	CreateDynamicObject(7997,1347.3750000,1564.6563000,7.8515600,0.0000000,0.0000000,0.0000000); //object(vgssairportland02) (1)
	CreateDynamicObject(3763,1566.6000000,-1688.3000000,60.6000000,0.0000000,0.0000000,0.0000000); //object(ce_radarmast3) (1)
	CreateDynamicObject(3399,1571.2000000,-1637.0100000,24.8000000,0.0000000,358.7500000,0.0000000); //object(cxrf_a51_stairs) (2)
	CreateDynamicObject(12985,1550.3000000,-1633.3000000,15.0500000,0.0000000,0.0000000,0.0000000); //object(cos_sbanksteps05) (1)
	CreateDynamicObject(2057,2277.6001000,-929.5000000,27.2000000,0.0000000,0.0000000,74.0000000); //object(flame_tins) (1)
	CreateDynamicObject(2057,2279.8000000,-935.0999800,26.3000000,0.0000000,0.0000000,73.9980000); //object(flame_tins) (2)
	CreateDynamicObject(2057,2278.1001000,-934.7999900,26.3000000,0.0000000,0.0000000,127.9980000); //object(flame_tins) (3)
	CreateDynamicObject(1337,1835.8000000,-1676.7000000,13.0000000,0.0000000,0.0000000,272.0000000); //object(binnt07_la) (1)
	CreateDynamicObject(997,1833.4000000,-1669.4000000,12.5000000,0.0000000,0.0000000,356.0000000); //object(lhouse_barrier3) (1)
	CreateDynamicObject(997,1833.6000000,-1695.5000000,12.5000000,0.0000000,0.0000000,355.9950000); //object(lhouse_barrier3) (2)
	CreateDynamicObject(2672,1833.2260000,-1679.9050000,12.8250000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_4) (2)
	CreateDynamicObject(2675,1834.9520000,-1686.1021000,12.5000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_6) (1)
	CreateDynamicObject(2670,1832.5000000,-1674.4000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_1) (1)
	CreateDynamicObject(1329,1810.4000000,-1649.0000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(binnt13_la) (1)
	CreateDynamicObject(12934,1816.7998000,-1580.7998000,14.2100000,271.0000000,270.0000000,133.9950000); //object(sw_trailer03) (1)
	CreateDynamicObject(2907,487.2999900,-0.4000000,1001.8000000,270.0000000,180.0000000,10.5000000); //object(kmb_deadtorso) (7)
	CreateDynamicObject(2908,487.2699900,-0.4000000,1002.3290000,270.0000000,180.0000000,272.2500000); //object(kmb_deadhead) (7)
	CreateDynamicObject(2906,486.6000100,-1.5000000,1001.4800000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (12)
	CreateDynamicObject(2905,487.2000100,-0.7000000,1001.5000000,0.0000000,85.0000000,184.5000000); //object(kmb_deadleg) (12)
	CreateDynamicObject(2905,487.3999900,-0.7000000,1001.5000000,0.0000000,84.9960000,184.4990000); //object(kmb_deadleg) (13)
	CreateDynamicObject(2906,487.0190100,-0.4420000,1001.8900000,299.9190000,287.8320000,105.0810000); //object(kmb_deadarm) (13)
	CreateDynamicObject(1484,496.8999900,-10.7000000,1000.2800000,0.0000000,114.2500000,40.0000000); //object(cj_bear_bottle) (1)
	CreateDynamicObject(2908,476.5000000,-14.4000000,1002.8000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadhead) (8)
	CreateDynamicObject(2906,473.7999900,-10.8000000,1002.7200000,0.0000000,222.0000000,48.0000000); //object(kmb_deadarm) (14)
	CreateDynamicObject(2672,496.5000000,-22.4000000,1000.0000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_4) (3)
	CreateDynamicObject(2675,492.1000100,-23.3000000,999.7000100,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_6) (2)
	CreateDynamicObject(2676,481.0000000,-17.5000000,999.7999900,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_8) (2)
	CreateDynamicObject(1544,486.5700100,-1.3000000,1001.4000000,0.0000000,0.0000000,0.0000000); //object(cj_beer_b_1) (1)
	CreateDynamicObject(2907,502.3999900,-6.5000000,999.7999900,0.0000000,182.0000000,0.0000000); //object(kmb_deadtorso) (8)
	CreateDynamicObject(2908,503.0000000,-7.6000000,999.7999900,0.0000000,0.0000000,106.0000000); //object(kmb_deadhead) (9)
	CreateDynamicObject(2906,502.3999900,-7.2000000,1000.6000000,0.0000000,0.0000000,268.0000000); //object(kmb_deadarm) (15)
	CreateDynamicObject(1668,482.8999900,-24.6000000,1002.7000000,0.0000000,0.0000000,0.0000000); //object(propvodkabotl1) (1)
	CreateDynamicObject(1668,482.6000100,-24.7000000,1002.7000000,0.0000000,0.0000000,0.0000000); //object(propvodkabotl1) (2)
	CreateDynamicObject(1668,482.3999900,-24.3000000,1002.7000000,0.0000000,0.0000000,58.0000000); //object(propvodkabotl1) (3)
	CreateDynamicObject(1668,482.3999900,-24.8000000,1002.7000000,0.0000000,0.0000000,57.9970000); //object(propvodkabotl1) (4)
	CreateDynamicObject(1775,489.6000100,-24.6000000,1000.4000000,0.0000000,0.0000000,0.0000000); //object(cj_sprunk1) (1)
	CreateDynamicObject(2036,500.9003900,-22.7001900,1000.7500000,0.0000000,0.0000000,299.9980000); //object(cj_psg1) (1)
	CreateDynamicObject(2905,477.6000100,-7.0000000,999.7999900,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (14)
	CreateDynamicObject(2908,479.6000100,-4.0000000,1002.9300000,0.0000000,0.0000000,36.0000000); //object(kmb_deadhead) (10)
	CreateDynamicObject(2204,2029.8000000,-1401.5000000,16.3000000,0.0000000,1.0000000,3.7500000); //object(med_office8_cabinet) (1)
	CreateDynamicObject(1766,2015.3000000,-1414.5000000,16.0000000,0.0000000,0.0000000,0.0000000); //object(med_couch_1) (1)
	CreateDynamicObject(1737,2037.7000000,-1418.4000000,16.8200000,0.0000000,178.0000000,5.0000000); //object(med_dinning_5) (1)
	CreateDynamicObject(1715,2025.7000000,-1413.6000000,16.0000000,0.0000000,0.0000000,274.0000000); //object(kb_swivelchair2) (1)
	CreateDynamicObject(1812,2037.0000000,-1409.1000000,16.2000000,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (1)
	CreateDynamicObject(1812,2031.0000000,-1422.4000000,16.0000000,0.0000000,0.0000000,82.0000000); //object(low_bed_5) (2)
	CreateDynamicObject(2671,2030.1000000,-1411.5000000,16.0000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_3) (1)
	CreateDynamicObject(2673,2033.9000000,-1416.5000000,16.1000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_5) (1)
	CreateDynamicObject(2674,2029.9000000,-1403.2000000,16.3000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_2) (1)
	CreateDynamicObject(1369,2034.6000000,-1422.4000000,16.6000000,0.0000000,0.0000000,0.0000000); //object(cj_wheelchair1) (1)
	CreateDynamicObject(1685,1477.1000000,-1649.4000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (1)
	CreateDynamicObject(2040,2372.3000000,-1123.8000000,1050.5000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_m1) (1)
	CreateDynamicObject(2042,2372.8999000,-1123.7000000,1050.4200000,0.0000000,0.0000000,350.0000000); //object(ammo_box_m3) (1)
	CreateDynamicObject(2358,2362.0000000,-1123.0000000,1050.0000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_c2) (1)
	CreateDynamicObject(2359,2362.8000000,-1135.1000000,1050.1000000,0.0000000,0.0000000,46.7500000); //object(ammo_box_c5) (1)
	CreateDynamicObject(3800,2360.3999000,-1135.4000000,1049.9000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (1)
	CreateDynamicObject(2035,2360.3999000,-1135.4000000,1051.0000000,0.0000000,0.0000000,252.0000000); //object(cj_m16) (2)
	CreateDynamicObject(1672,2367.6001000,-1134.5000000,1051.0300000,0.0000000,0.0000000,0.0000000); //object(gasgrenade) (1)
	CreateDynamicObject(912,2366.6001000,-1130.2000000,1050.4000000,0.0000000,359.7500000,267.5000000); //object(bust_cabinet_2) (1)
	CreateDynamicObject(2971,2364.8000000,-1123.5000000,1049.9000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (1)
	CreateDynamicObject(2677,2372.7000000,-1132.2000000,1050.1500000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_7) (6)
	CreateDynamicObject(3799,217.6000100,78.1000000,1004.0000000,0.0000000,0.0000000,0.0000000); //object(acbox2_sfs) (2)
	CreateDynamicObject(2971,246.3999900,73.9000000,1002.6000000,0.0000000,0.0000000,0.0000000); //object(k_smashboxes) (2)
	CreateDynamicObject(2674,239.8999900,75.3000000,1004.1000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_2) (2)
	CreateDynamicObject(2674,237.7000000,78.0000000,1004.1000000,0.0000000,0.0000000,56.0000000); //object(proc_rubbish_2) (3)
	CreateDynamicObject(2674,239.2000000,77.1000000,1004.1000000,0.0000000,0.0000000,345.9970000); //object(proc_rubbish_2) (4)
	CreateDynamicObject(2674,237.1000100,75.0000000,1004.1000000,0.0000000,0.0000000,47.9920000); //object(proc_rubbish_2) (5)
	CreateDynamicObject(2674,238.2000000,73.2000000,1004.1000000,0.0000000,0.0000000,101.9880000); //object(proc_rubbish_2) (6)
	CreateDynamicObject(2674,234.2000000,72.6000000,1004.1000000,0.0000000,0.0000000,17.9860000); //object(proc_rubbish_2) (7)
	CreateDynamicObject(2674,231.3999900,74.2000000,1004.1000000,0.0000000,0.0000000,277.9850000); //object(proc_rubbish_2) (8)
	CreateDynamicObject(2908,262.7999900,75.8000000,1000.1000000,0.0000000,0.0000000,282.0000000); //object(kmb_deadhead) (11)
	CreateDynamicObject(2908,263.5000000,78.5000000,1000.1000000,0.0000000,0.0000000,193.9970000); //object(kmb_deadhead) (12)
	CreateDynamicObject(2908,264.2999900,79.0000000,1000.1000000,0.0000000,164.0000000,253.9970000); //object(kmb_deadhead) (13)
	CreateDynamicObject(2908,265.2999900,77.7000000,1000.1000000,0.0000000,177.9980000,321.9930000); //object(kmb_deadhead) (14)
	CreateDynamicObject(2908,265.6000100,75.9000000,1000.1000000,0.0000000,177.9950000,75.9930000); //object(kmb_deadhead) (15)
	CreateDynamicObject(2907,263.7000100,76.6000000,1000.2000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (9)
	CreateDynamicObject(2907,263.1000100,79.0000000,1000.2000000,0.0000000,186.0000000,262.0000000); //object(kmb_deadtorso) (10)
	CreateDynamicObject(2907,265.6000100,78.9000000,1000.2000000,0.0000000,181.7490000,151.9960000); //object(kmb_deadtorso) (11)
	CreateDynamicObject(2907,265.6000100,76.9000000,1000.2000000,0.0000000,181.7470000,263.9960000); //object(kmb_deadtorso) (12)
	CreateDynamicObject(2907,264.3999900,77.8000000,1000.2000000,0.0000000,349.7470000,271.9900000); //object(kmb_deadtorso) (13)
	CreateDynamicObject(2906,264.7999900,78.8000000,1000.1000000,0.0000000,0.0000000,76.0000000); //object(kmb_deadarm) (16)
	CreateDynamicObject(2906,262.8999900,78.4000000,1000.1000000,0.0000000,0.0000000,330.0000000); //object(kmb_deadarm) (17)
	CreateDynamicObject(2906,264.8999900,78.4000000,1000.1000000,0.0000000,184.0000000,71.9980000); //object(kmb_deadarm) (18)
	CreateDynamicObject(2906,264.8999900,76.7000000,1000.1000000,0.0000000,183.9990000,39.9930000); //object(kmb_deadarm) (19)
	CreateDynamicObject(2906,264.8999900,77.2000000,1000.1000000,0.0000000,31.9990000,39.9900000); //object(kmb_deadarm) (20)
	CreateDynamicObject(2906,263.2999900,78.0000000,1000.1000000,0.0000000,168.0000000,11.9960000); //object(kmb_deadarm) (21)
	CreateDynamicObject(2906,265.2000100,75.9000000,1000.1000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (22)
	CreateDynamicObject(2906,264.6000100,75.9000000,1000.1000000,0.0000000,78.0000000,58.0000000); //object(kmb_deadarm) (23)
	CreateDynamicObject(2906,262.8999900,77.3000000,1000.1000000,0.0000000,0.0000000,130.0000000); //object(kmb_deadarm) (24)
	CreateDynamicObject(2906,263.1000100,76.6000000,1000.1000000,0.0000000,148.0000000,71.9960000); //object(kmb_deadarm) (25)
	CreateDynamicObject(2905,263.7999900,78.6000000,1000.1000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (15)
	CreateDynamicObject(2905,264.0000000,79.4000000,1000.1000000,0.0000000,0.0000000,88.0000000); //object(kmb_deadleg) (16)
	CreateDynamicObject(2905,265.0000000,79.2000000,1000.1000000,0.0000000,183.2500000,58.2450000); //object(kmb_deadleg) (17)
	CreateDynamicObject(2905,265.7999900,78.1000000,1000.1000000,0.0000000,183.2460000,90.2440000); //object(kmb_deadleg) (18)
	CreateDynamicObject(2905,263.6000100,77.6000000,1000.1000000,0.0000000,183.2460000,70.2420000); //object(kmb_deadleg) (19)
	CreateDynamicObject(2905,262.7000100,77.7000000,1000.1000000,0.0000000,183.2460000,357.4910000); //object(kmb_deadleg) (20)
	CreateDynamicObject(2905,263.8999900,75.9000000,1000.1000000,0.0000000,183.2460000,301.4900000); //object(kmb_deadleg) (21)
	CreateDynamicObject(2905,262.8999900,76.2000000,1000.1000000,0.0000000,183.2460000,241.4870000); //object(kmb_deadleg) (22)
	CreateDynamicObject(2905,265.7999900,76.2000000,1000.1000000,0.0000000,183.2460000,241.4850000); //object(kmb_deadleg) (23)
	CreateDynamicObject(2905,264.7000100,76.6000000,1000.1000000,0.0000000,183.2460000,37.4850000); //object(kmb_deadleg) (24)
	CreateDynamicObject(1462,267.7999900,92.3000000,1000.0000000,0.0000000,0.0000000,0.0000000); //object(dyn_woodpile) (1)
	CreateDynamicObject(3092,264.1000100,80.2000000,1001.0000000,0.0000000,0.0000000,0.0000000); //object(dead_tied_cop) (1)
	CreateDynamicObject(3008,257.6000100,88.6000000,1001.4000000,0.0000000,0.0000000,0.0000000); //object(chopcop_armr) (1)
	CreateDynamicObject(3009,253.6000100,88.6000000,1001.4500000,90.0000000,358.0000000,0.0000000); //object(chopcop_arml) (1)
	CreateDynamicObject(3012,254.4239700,84.1839700,1000.8981000,0.0000000,0.0000000,0.0000000); //object(chopcop_head) (1)
	CreateDynamicObject(3007,257.7627300,83.4791700,1001.5117000,300.0000000,160.2500000,54.0000000); //object(chopcop_torso) (1)
	CreateDynamicObject(2780,262.6000100,73.7000000,1001.4770000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (1)
	CreateDynamicObject(9833,263.6000100,71.7000000,998.4000200,0.0000000,0.0000000,0.0000000); //object(fountain_sfw) (1)
	CreateDynamicObject(3627,1259.9000000,-2069.3999000,62.0000000,2.0000000,358.7480000,91.4890000); //object(dckcanpy) (1)
	CreateDynamicObject(1369,1183.9000000,-1328.7000000,13.2000000,0.0000000,0.0000000,46.0000000); //object(cj_wheelchair1) (2)
	CreateDynamicObject(3098,1175.5000000,-1326.8000000,15.4000000,0.0000000,0.0000000,0.0000000); //object(break_wall_1b) (1)
	CreateDynamicObject(3099,1176.3000000,-1324.4000000,13.0000000,0.0000000,0.0000000,312.2500000); //object(break_wall_3b) (1)
	CreateDynamicObject(2905,1176.8000000,-1324.4000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (25)
	CreateDynamicObject(2906,1184.0000000,-1328.8000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadarm) (26)
	CreateDynamicObject(12957,1418.9000000,-1255.2000000,14.3000000,332.0000000,0.0000000,44.2430000); //object(sw_pickupwreck01) (1)
	CreateDynamicObject(967,1572.7998000,-1642.2002000,27.4000000,0.0000000,0.0000000,226.0000000); //object(bar_gatebox01) (1)
	CreateDynamicObject(3873,-70.6000000,-1573.6989700,18.8250000,0.0000000,358.9950000,0.0000000); //object(silicon04_sfs) (1)
	CreateDynamicObject(8151,-81.7000000,-1566.1000000,6.0000000,0.0000000,0.0000000,130.7500000); //object(vgsselecfence05) (1)
	CreateDynamicObject(8151,-83.9000000,-1576.0000000,6.0000000,0.0000000,0.0000000,220.4980000); //object(vgsselecfence05) (2)
	CreateDynamicObject(3593,730.9000200,-1662.0000000,8.7000000,325.0000000,358.0000000,0.0000000); //object(la_fuckcar2) (2)
	CreateDynamicObject(1558,656.4000200,-1692.6000000,18.9000000,0.0000000,0.0000000,0.0000000); //object(cj_cardbrd_pickup) (1)
	CreateDynamicObject(1558,656.4000200,-1693.6000000,18.9000000,0.0000000,0.0000000,0.0000000); //object(cj_cardbrd_pickup) (2)
	CreateDynamicObject(1558,656.5000000,-1691.2000000,18.9000000,0.0000000,0.0000000,318.0000000); //object(cj_cardbrd_pickup) (3)
	CreateDynamicObject(9766,1113.6000000,-1576.6000000,27.9999400,4.8000000,40.0000000,0.0000000); //object(scaff3_sfw) (1)
	CreateDynamicObject(3097,1105.0000000,-1615.3000000,19.5000000,0.0000000,329.2500000,0.0000000); //object(break_wall_2b) (1)
	CreateDynamicObject(1418,1443.3000000,-1756.4000000,20.2000000,0.0000000,0.0000000,178.5000000); //object(dyn_f_wood_3) (1)
	CreateDynamicObject(1418,1433.6000000,-1756.4000000,20.2000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_wood_3) (2)
	CreateDynamicObject(1418,1423.2000000,-1756.4000000,20.2000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_wood_3) (3)
	CreateDynamicObject(1418,1453.6000000,-1756.4000000,20.2000000,0.0000000,0.0000000,179.9950000); //object(dyn_f_wood_3) (4)
	CreateDynamicObject(11439,1651.4000200,-990.2000100,25.6000000,46.0000000,336.0000000,0.0000000); //object(des_woodbr_) (1)
	CreateDynamicObject(854,1642.9000000,-977.7000100,49.1000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (1)
	CreateDynamicObject(854,1643.6000000,-975.5999800,49.2000000,0.0000000,354.2500000,0.0000000); //object(cj_urb_rub_3b) (2)
	CreateDynamicObject(10984,1654.9004000,-978.4003900,37.5999200,0.0000000,0.0000000,304.4920000); //object(rubbled01_sfs) (1)
	CreateDynamicObject(10984,1654.0000000,-1012.1000000,24.2000000,0.0000000,0.0000000,304.4970000); //object(rubbled01_sfs) (2)
	CreateDynamicObject(10984,1644.7000000,-1005.8000000,24.2000000,0.0000000,0.0000000,214.4970000); //object(rubbled01_sfs) (3)
	CreateDynamicObject(853,1650.3000000,-990.2999900,49.7000000,0.0000000,0.0000000,147.5000000); //object(cj_urb_rub_5) (1)
	CreateDynamicObject(852,1650.2000000,-988.5000000,49.2000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (1)
	CreateDynamicObject(851,1654.4000000,-981.7999900,49.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_2) (1)
	CreateDynamicObject(851,1653.0000000,-983.2000100,49.5000000,0.0000000,0.0000000,72.0000000); //object(cj_urb_rub_2) (2)
	CreateDynamicObject(849,1650.5000000,-1007.2000000,32.0000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3) (1)
	CreateDynamicObject(849,1651.0000000,-1004.4000000,32.0000000,0.0000000,0.0000000,58.0000000); //object(cj_urb_rub_3) (2)
	CreateDynamicObject(854,1653.8000000,-1000.0000000,31.3000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (3)
	CreateDynamicObject(854,1654.3000000,-1000.9000000,31.3000000,0.0000000,0.0000000,68.0000000); //object(cj_urb_rub_3b) (4)
	CreateDynamicObject(854,1653.4000000,-1000.9000000,31.3000000,0.0000000,0.0000000,68.0000000); //object(cj_urb_rub_3b) (5)
	CreateDynamicObject(854,1652.9000000,-999.0999800,31.1000000,0.0000000,3.7500000,69.2500000); //object(cj_urb_rub_3b) (6)
	CreateDynamicObject(852,1642.8000000,-996.5999800,30.0000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (2)
	CreateDynamicObject(828,1643.7000000,-994.0000000,30.2000000,0.0000000,0.0000000,0.0000000); //object(p_rubble2) (1)
	CreateDynamicObject(818,776.2999900,-1329.8000000,13.3000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (1)
	CreateDynamicObject(818,779.4000200,-1329.7000000,13.3000000,0.0000000,0.0000000,56.0000000); //object(genveg_tallgrass02) (2)
	CreateDynamicObject(1391,2430.7002000,-1669.5996000,8.7000000,0.0000000,0.0000000,0.0000000); //object(twrcrane_s_03) (1)
	CreateDynamicObject(1391,2430.8000000,-1583.6000000,8.7000000,0.0000000,0.0000000,0.0000000); //object(twrcrane_s_03) (2)
	CreateDynamicObject(8150,1935.7000000,-2226.8999000,15.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (3)
	CreateDynamicObject(8150,2007.5000000,-2240.6001000,15.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (4)
	CreateDynamicObject(8150,2007.5000000,-2361.0000000,15.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (5)
	CreateDynamicObject(8150,1935.7002000,-2226.8994000,22.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (6)
	CreateDynamicObject(8150,2007.5000000,-2240.5996000,22.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (7)
	CreateDynamicObject(8150,2007.5000000,-2360.3999000,36.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (8)
	CreateDynamicObject(8150,1935.7002000,-2226.8994000,29.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (9)
	CreateDynamicObject(8150,1935.7002000,-2226.8994000,36.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (10)
	CreateDynamicObject(8150,2007.5000000,-2240.3999000,22.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (11)
	CreateDynamicObject(8150,2007.5000000,-2240.5996000,36.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (12)
	CreateDynamicObject(8150,2007.5000000,-2240.5996000,29.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (13)
	CreateDynamicObject(8150,2007.5000000,-2360.5000000,22.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (14)
	CreateDynamicObject(8150,2007.6000000,-2360.5000000,29.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (15)
	CreateDynamicObject(8150,1944.3000000,-2226.8000000,29.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (16)
	CreateDynamicObject(8150,1944.4000000,-2227.1001000,22.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (17)
	CreateDynamicObject(8150,1944.2998000,-2226.7998000,36.6000000,0.0000000,0.0000000,0.0000000); //object(vgsselecfence04) (18)
	CreateDynamicObject(14553,1527.6000000,-2555.2000000,16.2000000,13.0080000,359.9180000,87.1880000); //object(androm_des_obj) (1)
	CreateDynamicObject(10757,1875.2000000,-2493.0000000,14.7000000,10.0000000,9.0000000,270.0000000); //object(airport_04_sfse) (1)
	CreateDynamicObject(10757,1872.1000000,-2592.0000000,14.7000000,9.9980000,8.9980000,267.5000000); //object(airport_04_sfse) (2)
	CreateDynamicObject(16082,2001.0000000,-2237.1001000,19.0000000,0.0000000,0.0000000,270.0000000); //object(des_quarryplatform) (2)
	CreateDynamicObject(10763,1917.6000000,-2297.3000000,45.3000000,0.0000000,0.0000000,42.5000000); //object(controltower_sfse) (1)
	CreateDynamicObject(14578,2009.1000000,-2020.7000000,13.1000000,0.0000000,0.0000000,0.0000000); //object(mafcaspipes01) (1)
	CreateDynamicObject(14578,2007.5000000,-2021.0000000,13.1000000,0.0000000,0.0000000,90.0000000); //object(mafcaspipes01) (2)
	CreateDynamicObject(4206,2001.9000000,-2024.8000000,12.5510000,0.0000000,0.0000000,0.0000000); //object(pershingpool_lan) (1)
	CreateDynamicObject(3865,1996.2000000,-2032.4000000,13.0000000,325.0000000,338.5000000,330.0000000); //object(concpipe_sfxrf) (1)
	CreateDynamicObject(3865,2008.7000000,-2043.7000000,13.0000000,324.9980000,338.5000000,291.9960000); //object(concpipe_sfxrf) (2)
	CreateDynamicObject(3865,1992.1000000,-2015.4000000,12.0000000,324.9980000,338.4940000,51.9950000); //object(concpipe_sfxrf) (3)
	CreateDynamicObject(6965,2002.3000000,-2019.8000000,8.2000000,0.0000000,0.0000000,0.0000000); //object(venefountain02) (1)
	CreateDynamicObject(6965,2002.2000000,-2019.8000000,8.2000000,0.0000000,0.0000000,0.0000000); //object(venefountain02) (4)
	CreateDynamicObject(2780,2004.3000000,-2019.8000000,11.7000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (2)
	CreateDynamicObject(2780,2011.6000000,-2023.3000000,11.7000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach) (3)
	CreateDynamicObject(3515,2005.5000000,-2024.2000000,11.4000000,0.0000000,0.0000000,0.0000000); //object(vgsfountain) (1)
	CreateDynamicObject(3515,2009.4000000,-2024.1000000,11.4000000,0.0000000,0.0000000,0.0000000); //object(vgsfountain) (2)
	CreateDynamicObject(3515,2011.0000000,-2020.7000000,11.4000000,0.0000000,0.0000000,0.0000000); //object(vgsfountain) (3)
	CreateDynamicObject(854,1995.7000000,-2033.1000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (7)
	CreateDynamicObject(854,1995.7000000,-2032.0000000,12.8000000,0.0000000,0.0000000,30.0000000); //object(cj_urb_rub_3b) (8)
	CreateDynamicObject(854,1996.6000000,-2032.4000000,12.8000000,0.0000000,0.0000000,29.9980000); //object(cj_urb_rub_3b) (9)
	CreateDynamicObject(854,1997.0000000,-2030.7000000,12.8000000,0.0000000,0.0000000,29.9980000); //object(cj_urb_rub_3b) (10)
	CreateDynamicObject(854,1997.0000000,-2031.6000000,12.8000000,0.0000000,0.0000000,29.9980000); //object(cj_urb_rub_3b) (11)
	CreateDynamicObject(854,1996.4000000,-2031.0000000,12.8000000,0.0000000,0.0000000,29.9980000); //object(cj_urb_rub_3b) (12)
	CreateDynamicObject(854,2007.8000000,-2043.9000000,12.8000000,0.0000000,0.0000000,15.7480000); //object(cj_urb_rub_3b) (13)
	CreateDynamicObject(854,2008.1000000,-2043.2000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (14)
	CreateDynamicObject(854,2009.7000000,-2042.7000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (15)
	CreateDynamicObject(854,2009.3000000,-2042.8000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (16)
	CreateDynamicObject(854,2009.4000000,-2043.9000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (17)
	CreateDynamicObject(854,2008.8000000,-2044.1000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (18)
	CreateDynamicObject(854,2010.5000000,-2043.0000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (19)
	CreateDynamicObject(854,2009.9000000,-2043.4000000,12.8000000,0.0000000,0.0000000,15.7430000); //object(cj_urb_rub_3b) (20)
	CreateDynamicObject(854,1993.8000000,-2017.1000000,12.8000000,0.0000000,0.0000000,20.9930000); //object(cj_urb_rub_3b) (21)
	CreateDynamicObject(854,1992.6000000,-2016.6000000,12.8000000,0.0000000,0.0000000,119.2390000); //object(cj_urb_rub_3b) (22)
	CreateDynamicObject(854,1993.4000000,-2015.9000000,12.8000000,0.0000000,0.0000000,123.2350000); //object(cj_urb_rub_3b) (23)
	CreateDynamicObject(854,1992.2000000,-2015.1000000,12.8000000,0.0000000,0.0000000,144.9840000); //object(cj_urb_rub_3b) (24)
	CreateDynamicObject(854,1991.7000000,-2015.7000000,12.8000000,0.0000000,0.0000000,94.4810000); //object(cj_urb_rub_3b) (25)
	CreateDynamicObject(854,1991.6000000,-2015.3000000,12.8000000,0.0000000,0.0000000,94.4770000); //object(cj_urb_rub_3b) (26)
	CreateDynamicObject(1306,2008.4000000,-2037.4000000,17.0000000,45.0000000,0.0000000,89.9950000); //object(tlgraphpolegen) (1)
	CreateDynamicObject(8150,1873.0000000,-2289.6001000,29.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (19)
	CreateDynamicObject(8150,1873.0000000,-2356.0000000,22.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (20)
	CreateDynamicObject(8150,1873.0000000,-2289.5996000,15.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (23)
	CreateDynamicObject(8150,1873.0000000,-2356.0000000,29.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (24)
	CreateDynamicObject(8150,1873.0000000,-2289.5996000,22.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (32)
	CreateDynamicObject(8150,1873.0000000,-2289.5996000,36.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (33)
	CreateDynamicObject(8150,1872.8994100,-2355.8994100,15.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (34)
	CreateDynamicObject(8150,1873.0000000,-2356.0000000,36.6000000,0.0000000,0.0000000,90.0000000); //object(vgsselecfence04) (35)
	CreateDynamicObject(8150,1944.1120600,-2421.6440400,15.6000000,0.0000000,0.0000000,357.9950000); //object(vgsselecfence04) (36)
	CreateDynamicObject(8150,1944.0996100,-2421.5996100,21.6000000,0.0000000,0.0000000,357.9900000); //object(vgsselecfence04) (37)
	CreateDynamicObject(8150,1944.0996000,-2421.5996000,15.6000000,0.0000000,0.0000000,357.9950000); //object(vgsselecfence04) (38)
	CreateDynamicObject(8150,1935.0000000,-2421.2998000,28.6000000,0.0000000,0.0000000,357.9900000); //object(vgsselecfence04) (39)
	CreateDynamicObject(8150,1935.0000000,-2421.2998000,21.6000000,0.0000000,0.0000000,357.9950000); //object(vgsselecfence04) (40)
	CreateDynamicObject(8150,1944.2998000,-2421.5996100,28.6000000,0.0000000,0.0000000,357.9900000); //object(vgsselecfence04) (41)
	CreateDynamicObject(8150,1944.2998000,-2421.5996000,35.6000000,0.0000000,0.0000000,357.9950000); //object(vgsselecfence04) (42)
	CreateDynamicObject(8150,1935.2998000,-2421.2998000,35.6000000,0.0000000,0.0000000,357.9900000); //object(vgsselecfence04) (43)
	CreateDynamicObject(3816,1941.0000000,-2392.7002000,21.1000000,0.0000000,0.0000000,177.9900000); //object(bighangar1_sfx) (1)
	CreateDynamicObject(10763,1981.2998000,-2316.0996000,45.3000000,0.0000000,0.0000000,225.4890000); //object(controltower_sfse) (2)
	CreateDynamicObject(987,1942.5996000,-2315.8994000,20.5000000,0.0000000,0.0000000,0.0000000); //object(elecfence_bar) (40)
	CreateDynamicObject(987,1954.7998000,-2298.7002000,20.5000000,0.0000000,0.0000000,179.7420000); //object(elecfence_bar) (41)
	CreateDynamicObject(2047,2001.7000000,-2231.1001000,18.2000000,0.0000000,0.0000000,181.5000000); //object(cj_flag1) (1)
	CreateDynamicObject(2789,1990.9000000,-2226.6001000,24.3000000,0.0000000,0.0000000,179.2500000); //object(cj_depart_board) (1)
	CreateDynamicObject(3335,1971.8000000,-2174.0000000,12.4000000,0.0000000,0.0000000,274.0000000); //object(ce_roadsign1) (1)
	CreateDynamicObject(3514,1975.2000000,-2169.2000000,15.3000000,42.0000000,337.0000000,120.0000000); //object(vgs_roadsign02) (1)
	CreateDynamicObject(852,1973.2000000,-2169.8000000,12.4000000,0.0000000,0.0000000,272.2500000); //object(cj_urb_rub_4) (3)
	CreateDynamicObject(8556,1994.2000000,-2216.8000000,17.1000000,0.0000000,0.0000000,0.0000000); //object(vgshsegate04) (1)
	CreateDynamicObject(3117,2001.8994100,-2225.1992200,13.6000000,0.0000000,327.4970000,269.2470000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(3049,2004.8000000,-2293.8999000,14.8000000,0.0000000,0.0000000,13.0000000); //object(des_quarrygate) (1)
	CreateDynamicObject(3049,2000.5000000,-2294.8999000,14.8000000,0.0000000,0.0000000,12.9970000); //object(des_quarrygate) (2)
	CreateDynamicObject(3049,1996.2000000,-2295.8999000,14.8000000,0.0000000,0.0000000,11.7470000); //object(des_quarrygate) (3)
	CreateDynamicObject(3049,1991.8000000,-2296.8000000,14.8000000,0.0000000,0.0000000,11.7440000); //object(des_quarrygate) (4)
	CreateDynamicObject(3036,1992.4000000,-2210.1001000,14.3000000,0.0000000,0.0000000,180.7500000); //object(ct_gatexr) (1)
	CreateDynamicObject(3049,1987.6000000,-2210.0000000,14.8000000,0.0000000,0.0000000,0.0000000); //object(des_quarrygate) (5)
	CreateDynamicObject(3049,1986.7000000,-2210.1001000,14.8000000,0.0000000,0.0000000,0.0000000); //object(des_quarrygate) (6)
	CreateDynamicObject(3037,1982.0000000,-2216.3999000,14.7000000,0.0000000,0.0000000,0.0000000); //object(warehouse_door2b) (2)
	CreateDynamicObject(3037,1981.9000000,-2217.6001000,14.7000000,0.0000000,0.0000000,358.2500000); //object(warehouse_door2b) (3)
	CreateDynamicObject(983,1981.7999000,-2223.3999000,13.2000000,0.0000000,0.0000000,358.5000000); //object(fenceshit3) (1)
	CreateDynamicObject(979,1943.4000000,-2181.3000000,13.4000000,0.0000000,0.0000000,270.0000000); //object(sub_roadleft) (2)
	CreateDynamicObject(3578,1966.8000000,-2177.8999000,13.3000000,0.0000000,0.0000000,8.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(3578,1952.5000000,-2176.8000000,13.3000000,0.0000000,0.0000000,339.9980000); //object(dockbarr1_la) (2)
	CreateDynamicObject(1250,1966.2000000,-2190.0000000,13.6000000,0.0000000,0.0000000,270.0000000); //object(smashbarpost) (1)
	CreateDynamicObject(1251,1963.2000000,-2189.8000000,13.7000000,0.0000000,0.0000000,89.7500000); //object(smashbar) (1)
	CreateDynamicObject(1251,1959.7000000,-2189.8000000,13.7000000,0.0000000,0.0000000,89.7470000); //object(smashbar) (2)
	CreateDynamicObject(992,2003.9900000,-2210.2200000,14.1000000,0.0000000,0.0000000,0.0000000); //object(bar_barrier10b) (1)
	CreateDynamicObject(991,1999.0000000,-2209.9602000,13.8000000,0.0000000,0.0000000,0.0000000); //object(bar_barriergate1) (1)
	CreateDynamicObject(3268,1914.4004000,-2262.2998000,12.5000000,0.0000000,0.0000000,177.2480000); //object(mil_hangar1_) (1)
	CreateDynamicObject(3279,1930.9000000,-2284.3999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(a51_spottower) (3)
	CreateDynamicObject(3279,1982.9000000,-2326.8999000,18.4000000,0.0000000,0.0000000,184.0000000); //object(a51_spottower) (4)
	CreateDynamicObject(7096,1973.5000000,-2325.7998000,16.5300000,0.0000000,359.7420000,0.0000000); //object(vrockstairs) (2)
	CreateDynamicObject(18248,1878.5000000,-2394.5000000,20.6000000,0.0000000,0.0000000,352.7490000); //object(cuntwjunk01) (1)
	CreateDynamicObject(3867,2005.3000000,-2279.1001000,27.5000000,0.0000000,0.0000000,270.0000000); //object(ws_scaffolding_sfx) (1)
	CreateDynamicObject(2907,1574.3000000,-1621.7000000,12.7000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (14)
	CreateDynamicObject(3012,1563.5000000,-1622.7000000,12.0000000,0.0000000,0.0000000,0.0000000); //object(chopcop_head) (2)
	CreateDynamicObject(2905,1559.3000000,-1625.8000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (26)
	CreateDynamicObject(3010,1554.4000000,-1624.6000000,12.4000000,0.0000000,72.7500000,0.0000000); //object(chopcop_legr) (1)
	CreateDynamicObject(3008,1560.7000000,-1631.2000000,12.2000000,0.0000000,0.0000000,0.0000000); //object(chopcop_armr) (2)
	CreateDynamicObject(2906,1557.1000000,-1621.5000000,12.6000000,0.0000000,0.0000000,68.0000000); //object(kmb_deadarm) (27)
	CreateDynamicObject(1219,1418.6000000,-1642.8000000,14.2000000,0.0000000,271.2500000,178.7500000); //object(palette) (12)
	CreateDynamicObject(1219,1418.6000000,-1640.2000000,14.2000000,0.0000000,271.2470000,178.7480000); //object(palette) (15)
	CreateDynamicObject(1219,1418.5000000,-1637.7000000,14.2000000,0.0000000,269.9970000,179.2480000); //object(palette) (16)
	CreateDynamicObject(1219,1418.5000000,-1634.5000000,14.2000000,0.0000000,269.9950000,179.2470000); //object(palette) (17)
	CreateDynamicObject(1219,1418.5000000,-1632.3000000,14.2000000,0.0000000,269.9950000,179.2470000); //object(palette) (18)
	CreateDynamicObject(1219,1418.5000000,-1629.5000000,14.2000000,0.0000000,269.9950000,179.2470000); //object(palette) (19)
	CreateDynamicObject(1219,1418.5000000,-1626.2000000,14.2000000,0.0000000,269.9950000,179.2470000); //object(palette) (20)
	CreateDynamicObject(1219,1418.5000000,-1623.8000000,14.2000000,0.0000000,269.9950000,358.7470000); //object(palette) (21)
	CreateDynamicObject(1219,1418.5000000,-1621.3000000,14.2000000,0.0000000,269.9950000,180.7420000); //object(palette) (22)
	CreateDynamicObject(1219,1418.5000000,-1618.0000000,14.2000000,0.0000000,269.9950000,180.7420000); //object(palette) (23)
	CreateDynamicObject(1219,1418.5000000,-1615.7000000,14.2000000,0.0000000,269.9950000,179.9920000); //object(palette) (24)
	CreateDynamicObject(1219,1418.5000000,-1612.9000000,14.2000000,0.0000000,269.9950000,179.9890000); //object(palette) (25)
	CreateDynamicObject(1219,1418.5000000,-1609.9000000,14.2000000,0.0000000,269.9950000,179.9890000); //object(palette) (26)
	CreateDynamicObject(1219,1418.5000000,-1607.4000000,14.2000000,0.0000000,269.9950000,1.9890000); //object(palette) (27)
	CreateDynamicObject(1219,1418.5000000,-1604.8000000,14.2000000,0.0000000,269.9950000,180.7390000); //object(palette) (28)
	CreateDynamicObject(1219,1362.6000000,-1759.6000000,14.1000000,0.0000000,273.0000000,91.2500000); //object(palette) (29)
	CreateDynamicObject(1219,1360.1000000,-1759.7000000,14.1000000,0.0000000,270.2490000,270.2470000); //object(palette) (30)
	CreateDynamicObject(1219,1357.6000000,-1759.7000000,14.1000000,0.0000000,270.2470000,270.7420000); //object(palette) (31)
	CreateDynamicObject(1219,1348.8000000,-1759.5000000,14.1000000,0.0000000,270.2470000,270.7420000); //object(palette) (32)
	CreateDynamicObject(1219,1346.0000000,-1759.7000000,14.1000000,0.0000000,270.2470000,270.7420000); //object(palette) (33)
	CreateDynamicObject(1219,1343.6000000,-1759.7000000,14.1000000,0.0000000,270.2470000,270.7420000); //object(palette) (34)
	CreateDynamicObject(1327,1505.3000000,-1672.1000000,14.0000000,0.0000000,0.0000000,6.0000000); //object(junk_tyre) (1)
	CreateDynamicObject(12957,1486.1000000,-1759.7000000,17.7000000,344.0130000,1.7930000,357.7500000); //object(sw_pickupwreck01) (2)
	CreateDynamicObject(3260,1490.9000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7500000); //object(oldwoodpanel) (4)
	CreateDynamicObject(3260,1488.9000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (5)
	CreateDynamicObject(3260,1486.8000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (6)
	CreateDynamicObject(3260,1483.3000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (7)
	CreateDynamicObject(3260,1481.3000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (8)
	CreateDynamicObject(3260,1479.2000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (9)
	CreateDynamicObject(3260,1475.7000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (10)
	CreateDynamicObject(3260,1473.5000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (11)
	CreateDynamicObject(3260,1471.4000000,-1772.7000000,18.5000000,0.0000000,0.0000000,179.7470000); //object(oldwoodpanel) (12)
	CreateDynamicObject(11245,1488.8000000,-1742.8000000,12.6000000,90.0000000,195.7500000,0.0000000); //object(sfsefirehseflag) (1)
	CreateDynamicObject(9766,1993.7002000,-2278.3994000,28.3000000,346.2070000,359.7310000,343.4110000); //object(scaff3_sfw) (2)
	CreateDynamicObject(2928,1981.2002000,-2310.5000000,31.2000000,88.9950000,87.9950000,2.2470000); //object(a51_intdoor) (2)
	CreateDynamicObject(2928,1981.2002000,-2307.8994000,31.2000000,89.0040000,272.0290000,178.2060000); //object(a51_intdoor) (3)
	CreateDynamicObject(2928,1981.2000000,-2305.3000000,31.2000000,88.9950000,87.9950000,2.2470000); //object(a51_intdoor) (4)
	CreateDynamicObject(2928,1981.2002000,-2302.7002000,31.2000000,89.0040000,272.0290000,178.2060000); //object(a51_intdoor) (5)
	CreateDynamicObject(3095,1975.6000000,-2302.6001000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (5)
	CreateDynamicObject(3095,1975.6000000,-2310.8000000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (6)
	CreateDynamicObject(3095,1966.6000000,-2310.5000000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (7)
	CreateDynamicObject(3095,1966.6000000,-2302.7000000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (8)
	CreateDynamicObject(3095,1951.9000000,-2307.1001000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (9)
	CreateDynamicObject(3095,1942.9000000,-2307.1001000,30.6000000,0.0000000,0.0000000,0.0000000); //object(a51_jetdoor) (10)
	CreateDynamicObject(2899,1959.3000000,-2179.6001000,12.7000000,0.0000000,0.0000000,274.0000000); //object(temp_stinger2) (1)
	CreateDynamicObject(1215,1995.8000000,-2209.6001000,13.1000000,0.0000000,0.0000000,0.0000000); //object(bollardlight) (1)
	CreateDynamicObject(1215,1992.6000000,-2209.5000000,13.1000000,0.0000000,0.0000000,0.0000000); //object(bollardlight) (2)
	CreateDynamicObject(9238,1995.9000000,-2384.3999000,14.3000000,0.0000000,0.0000000,0.0000000); //object(moresfnshit28) (1)
	CreateDynamicObject(9238,1985.3994100,-2399.0000000,14.3000000,0.0000000,0.0000000,37.9960000); //object(moresfnshit28) (2)
	CreateDynamicObject(9238,1987.2000000,-2367.3999000,14.3000000,0.0000000,0.0000000,313.9960000); //object(moresfnshit28) (3)
	CreateDynamicObject(3095,1934.2000000,-2311.6001000,30.6000000,0.0000000,0.2500000,357.7500000); //object(a51_jetdoor) (14)
	CreateDynamicObject(3095,1926.0000000,-2303.1001000,30.6000000,0.0000000,0.0000000,356.2480000); //object(a51_jetdoor) (32)
	CreateDynamicObject(3095,1935.0000000,-2303.2000000,30.6000000,0.0000000,0.2470000,355.7480000); //object(a51_jetdoor) (33)
	CreateDynamicObject(3095,1925.5000000,-2311.2000000,30.6000000,0.0000000,0.0000000,356.2430000); //object(a51_jetdoor) (34)
	CreateDynamicObject(3095,1916.6000000,-2310.8000000,30.6000000,0.0000000,0.0000000,356.2430000); //object(a51_jetdoor) (35)
	CreateDynamicObject(3095,1917.1000000,-2302.7000000,30.6000000,0.0000000,0.0000000,357.7430000); //object(a51_jetdoor) (36)
	CreateDynamicObject(984,1949.5000000,-2311.5000000,31.8000000,0.0000000,0.0000000,88.2500000); //object(fenceshit2) (1)
	CreateDynamicObject(984,1949.5000000,-2302.8000000,31.8000000,0.0000000,0.0000000,89.2480000); //object(fenceshit2) (2)
	CreateDynamicObject(995,1987.8000000,-2314.8000000,31.3000000,0.0000000,0.0000000,180.0000000); //object(bar_barrier16) (1)
	CreateDynamicObject(994,1976.7000000,-2314.8999000,31.3000000,0.0000000,0.0000000,1.0000000); //object(lhouse_barrier2) (2)
	CreateDynamicObject(994,1970.3000000,-2315.0000000,31.3000000,0.0000000,0.0000000,0.5000000); //object(lhouse_barrier2) (3)
	CreateDynamicObject(994,1964.0000000,-2315.1001000,31.3000000,0.0000000,0.0000000,0.4940000); //object(lhouse_barrier2) (4)
	CreateDynamicObject(994,1957.7000000,-2315.2000000,31.3000000,0.0000000,0.0000000,0.4940000); //object(lhouse_barrier2) (5)
	CreateDynamicObject(994,1955.9000000,-2309.3000000,31.3000000,0.0000000,0.0000000,284.4940000); //object(lhouse_barrier2) (6)
	CreateDynamicObject(994,1958.9000000,-2298.6001000,31.3000000,0.0000000,0.0000000,238.4910000); //object(lhouse_barrier2) (7)
	CreateDynamicObject(994,1965.4000000,-2298.5000000,31.3000000,0.0000000,0.0000000,180.9860000); //object(lhouse_barrier2) (8)
	CreateDynamicObject(994,1971.8000000,-2298.3000000,31.3000000,0.0000000,0.0000000,181.2330000); //object(lhouse_barrier2) (9)
	CreateDynamicObject(994,1978.2000000,-2298.3000000,31.3000000,0.0000000,0.0000000,180.7300000); //object(lhouse_barrier2) (10)
	CreateDynamicObject(995,1979.7000000,-2298.6001000,31.3000000,0.0000000,359.7500000,1.9950000); //object(bar_barrier16) (2)
	CreateDynamicObject(995,1984.7000000,-2300.3000000,31.3000000,0.0000000,359.7470000,317.9940000); //object(bar_barrier16) (3)
	CreateDynamicObject(995,1983.5000000,-2306.7000000,31.3000000,0.0000000,358.2420000,27.9940000); //object(bar_barrier16) (4)
	CreateDynamicObject(995,1988.1000000,-2307.7000000,31.3000000,0.0000000,358.2370000,269.9930000); //object(bar_barrier16) (5)
	CreateDynamicObject(996,1932.1000000,-2299.6001000,32.0000000,0.0000000,0.0000000,358.2500000); //object(lhouse_barrier1) (1)
	CreateDynamicObject(994,1944.4000000,-2304.0000000,31.3000000,0.0000000,0.0000000,139.7360000); //object(lhouse_barrier2) (11)
	CreateDynamicObject(996,1923.9000000,-2299.3000000,32.0000000,0.0000000,0.0000000,358.2480000); //object(lhouse_barrier1) (2)
	CreateDynamicObject(996,1915.6000000,-2299.1001000,32.0000000,0.0000000,0.0000000,358.2480000); //object(lhouse_barrier1) (3)
	CreateDynamicObject(996,1911.5000000,-2299.8000000,32.0000000,0.0000000,0.0000000,266.7480000); //object(lhouse_barrier1) (4)
	CreateDynamicObject(997,1911.6000000,-2299.0000000,31.3000000,0.0000000,0.0000000,357.2500000); //object(lhouse_barrier3) (3)
	CreateDynamicObject(996,1911.4000000,-2307.8999000,32.0000000,0.0000000,0.0000000,283.7430000); //object(lhouse_barrier1) (5)
	CreateDynamicObject(996,1920.8000000,-2315.3000000,32.0000000,0.0000000,0.7500000,178.4880000); //object(lhouse_barrier1) (6)
	CreateDynamicObject(996,1929.0000000,-2315.7000000,32.0000000,0.0000000,0.7470000,177.2340000); //object(lhouse_barrier1) (7)
	CreateDynamicObject(996,1937.2000000,-2316.1001000,32.0000000,0.0000000,0.7420000,176.7310000); //object(lhouse_barrier1) (8)
	CreateDynamicObject(996,1943.1000000,-2311.1001000,32.0000000,0.0000000,0.7360000,220.7260000); //object(lhouse_barrier1) (9)
	CreateDynamicObject(3268,1989.7998000,-2411.3994100,12.5000000,0.0000000,0.0000000,267.9950000); //object(mil_hangar1_) (2)
	CreateDynamicObject(1362,1999.2000000,-2399.6001000,13.1000000,0.0000000,0.0000000,0.0000000); //object(cj_firebin) (1)
	CreateDynamicObject(931,1976.5000000,-2401.8999000,13.6000000,0.0000000,0.0000000,0.0000000); //object(rack3) (1)
	CreateDynamicObject(925,1978.9000000,-2402.0000000,13.6000000,0.0000000,0.0000000,0.0000000); //object(rack2) (1)
	CreateDynamicObject(930,1975.6000000,-2420.3999000,13.0000000,0.0000000,0.0000000,0.0000000); //object(o2_bottles) (1)
	CreateDynamicObject(2040,1977.3000000,-2402.1001000,14.8000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_m1) (2)
	CreateDynamicObject(2040,1976.6000000,-2402.0000000,14.8000000,0.0000000,0.0000000,52.0000000); //object(ammo_box_m1) (3)
	CreateDynamicObject(2669,1932.4000000,-2246.3999000,13.9000000,0.0000000,0.0000000,9.0000000); //object(cj_chris_crate) (1)
	CreateDynamicObject(1516,2003.0000000,-2420.7000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_table_03) (1)
	CreateDynamicObject(1562,1933.0000000,-2244.3999000,13.3000000,0.0000000,0.0000000,326.0000000); //object(ab_jetseat) (1)
	CreateDynamicObject(2321,1999.8000000,-2402.3999000,12.5000000,0.0000000,0.0000000,353.0000000); //object(cj_tv_table6) (2)
	CreateDynamicObject(2315,2002.6000000,-2402.7000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_tv_table4) (1)
	CreateDynamicObject(2121,2001.6000000,-2398.7000000,13.1000000,0.0000000,0.0000000,238.0000000); //object(low_din_chair_2) (1)
	CreateDynamicObject(967,2001.4000000,-2398.3999000,12.5000000,0.0000000,359.5000000,150.5000000); //object(bar_gatebox01) (2)
	CreateDynamicObject(2169,2004.3000000,-2406.2000000,12.5000000,0.0000000,0.0000000,269.7500000); //object(med_office3_desk_1) (1)
	CreateDynamicObject(16662,1959.9000000,-2417.8999000,13.6500000,0.0000000,0.0000000,179.9950000); //object(a51_radar_stuff) (1)
	CreateDynamicObject(3794,1995.7000000,-2420.6001000,13.1000000,0.0000000,0.0000000,358.0000000); //object(missile_07_sfxr) (3)
	CreateDynamicObject(3794,1992.2000000,-2420.5000000,13.1000000,0.0000000,0.0000000,357.9950000); //object(missile_07_sfxr) (4)
	CreateDynamicObject(3797,1980.0000000,-2412.8000000,17.9000000,0.0000000,0.0000000,0.0000000); //object(missile_11_sfxr) (1)
	CreateDynamicObject(2592,2004.2998000,-2413.0000000,13.4600000,0.0000000,0.0000000,269.2470000); //object(ab_slottable) (1)
	CreateDynamicObject(9831,1407.5000000,-1305.1000000,8.5000000,6.0000000,1.5000000,188.0000000); //object(sfw_waterfall) (1)
	CreateDynamicObject(9831,1412.2000000,-1305.2000000,8.5000000,5.9990000,1.5000000,187.9980000); //object(sfw_waterfall) (2)
	CreateDynamicObject(854,1412.7000000,-1302.1000000,9.0000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (27)
	CreateDynamicObject(854,1407.7000000,-1302.3000000,9.0000000,0.0000000,0.0000000,135.0000000); //object(cj_urb_rub_3b) (28)
	CreateDynamicObject(3798,1414.6000000,-1370.4000000,7.2000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (1)
	CreateDynamicObject(3798,1412.6000000,-1371.6000000,7.2000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,1410.6000000,-1371.9000000,7.2000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (3)
	CreateDynamicObject(3798,1408.6000000,-1372.2000000,7.2000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (4)
	CreateDynamicObject(3799,1406.2000000,-1370.7000000,7.6000000,0.0000000,0.0000000,0.0000000); //object(acbox2_sfs) (1)
	CreateDynamicObject(854,1410.6000000,-1373.4000000,7.8000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (29)
	CreateDynamicObject(854,1408.6000000,-1373.1000000,7.8000000,0.0000000,0.0000000,54.5000000); //object(cj_urb_rub_3b) (30)
	CreateDynamicObject(854,1407.0000000,-1372.7000000,7.8000000,0.0000000,0.0000000,328.4980000); //object(cj_urb_rub_3b) (31)
	CreateDynamicObject(854,1406.0000000,-1372.6000000,7.8000000,0.0000000,0.0000000,46.4970000); //object(cj_urb_rub_3b) (32)
	CreateDynamicObject(854,1407.4000000,-1373.7000000,7.8000000,0.0000000,0.0000000,46.4940000); //object(cj_urb_rub_3b) (33)
	CreateDynamicObject(854,1409.1000000,-1374.3000000,7.8000000,0.0000000,0.0000000,46.4940000); //object(cj_urb_rub_3b) (34)
	CreateDynamicObject(854,1410.7000000,-1374.4000000,7.8000000,0.0000000,0.0000000,46.4940000); //object(cj_urb_rub_3b) (35)
	CreateDynamicObject(854,1412.6000000,-1372.4000000,7.8000000,0.0000000,0.0000000,46.4940000); //object(cj_urb_rub_3b) (36)
	CreateDynamicObject(854,1414.6000000,-1372.0000000,7.8000000,0.0000000,0.0000000,46.4940000); //object(cj_urb_rub_3b) (37)
	CreateDynamicObject(854,1413.5000000,-1373.0000000,7.8000000,0.0000000,0.0000000,86.4940000); //object(cj_urb_rub_3b) (38)
	CreateDynamicObject(854,1412.2000000,-1373.6000000,7.8000000,0.0000000,352.0000000,86.4900000); //object(cj_urb_rub_3b) (39)
	CreateDynamicObject(854,1410.7000000,-1375.3000000,7.8000000,0.0000000,351.9960000,86.4840000); //object(cj_urb_rub_3b) (40)
	CreateDynamicObject(854,1412.3000000,-1375.0000000,7.8000000,0.0000000,351.9960000,86.4840000); //object(cj_urb_rub_3b) (41)
	CreateDynamicObject(854,1413.2000000,-1374.7000000,7.8000000,0.0000000,7.9960000,264.4840000); //object(cj_urb_rub_3b) (42)
	CreateDynamicObject(854,1414.3000000,-1374.7000000,7.8000000,0.0000000,8.2430000,274.4790000); //object(cj_urb_rub_3b) (43)
	CreateDynamicObject(854,1415.0000000,-1373.4000000,7.8000000,0.0000000,8.2400000,320.4770000); //object(cj_urb_rub_3b) (44)
	CreateDynamicObject(854,1409.9000000,-1375.1000000,7.8000000,0.0000000,9.2400000,275.9770000); //object(cj_urb_rub_3b) (45)
	CreateDynamicObject(854,1408.6000000,-1374.9000000,7.8000000,0.0000000,351.2400000,75.2270000); //object(cj_urb_rub_3b) (46)
	CreateDynamicObject(854,1407.2000000,-1374.7000000,7.8000000,0.0000000,9.7380000,253.2230000); //object(cj_urb_rub_3b) (47)
	CreateDynamicObject(854,1405.9000000,-1374.4000000,7.8000000,0.0000000,10.7340000,290.9680000); //object(cj_urb_rub_3b) (48)
	CreateDynamicObject(854,1405.0000000,-1373.0000000,7.8000000,0.0000000,354.9840000,327.2170000); //object(cj_urb_rub_3b) (49)
	CreateDynamicObject(854,1405.7000000,-1372.4000000,7.8000000,0.0000000,10.7340000,290.9670000); //object(cj_urb_rub_3b) (50)
	CreateDynamicObject(2929,2360.8000000,-1273.4000000,24.7000000,0.0000000,0.0000000,90.5000000); //object(a51_blastdoorl) (1)
	CreateDynamicObject(2929,2360.7000000,-1269.4000000,24.7000000,0.0000000,0.5000000,90.7500000); //object(a51_blastdoorl) (2)
	CreateDynamicObject(2985,2326.3000000,-1222.7000000,21.6000000,0.0000000,0.0000000,136.0000000); //object(minigun_base) (5)
	CreateDynamicObject(2985,2327.1001000,-1215.7000000,21.6000000,0.0000000,0.0000000,201.7500000); //object(minigun_base) (6)
	CreateDynamicObject(2985,2331.3999000,-1219.2000000,21.6000000,0.0000000,0.0000000,169.7470000); //object(minigun_base) (7)
	CreateDynamicObject(3785,2322.3999000,-1222.8000000,24.0000000,0.0000000,0.0000000,0.0000000); //object(bulkheadlight) (1)
	CreateDynamicObject(3785,2324.5000000,-1214.5000000,24.1000000,0.0000000,0.0000000,290.0000000); //object(bulkheadlight) (2)
	CreateDynamicObject(3800,2323.0000000,-1274.9000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (2)
	CreateDynamicObject(3800,2323.0000000,-1273.8000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (3)
	CreateDynamicObject(3800,2324.1001000,-1274.9000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (4)
	CreateDynamicObject(3800,2324.1001000,-1273.8000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (5)
	CreateDynamicObject(3800,2323.0000000,-1274.9004000,22.5800000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (6)
	CreateDynamicObject(2907,2326.8999000,-1223.8000000,21.7000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadtorso) (15)
	CreateDynamicObject(2907,2327.8999000,-1215.3000000,21.7000000,0.0000000,0.0000000,126.0000000); //object(kmb_deadtorso) (16)
	CreateDynamicObject(2905,2326.8000000,-1223.0000000,21.7000000,0.0000000,0.0000000,0.0000000); //object(kmb_deadleg) (27)
	CreateDynamicObject(2905,2327.1001000,-1223.1000000,21.7000000,0.0000000,188.0000000,0.0000000); //object(kmb_deadleg) (28)
	CreateDynamicObject(2908,2328.3000000,-1214.9980000,21.6920000,355.7000000,0.0000000,133.3000000); //object(kmb_deadhead) (16)
	CreateDynamicObject(2358,2328.8999000,-1239.3000000,21.6000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_c2) (2)
	CreateDynamicObject(2358,2329.6001000,-1239.3000000,21.6000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_c2) (3)
	CreateDynamicObject(2358,2328.8000000,-1238.5000000,21.6000000,0.0000000,0.0000000,44.0000000); //object(ammo_box_c2) (4)
	CreateDynamicObject(2043,2329.8999000,-1238.4000000,21.6000000,0.0000000,0.0000000,30.0000000); //object(ammo_box_m4) (1)
	CreateDynamicObject(1685,2337.8000000,-1228.3000000,22.3000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (2)
	CreateDynamicObject(1685,2340.7000000,-1229.1000000,22.3000000,0.0000000,0.0000000,62.0000000); //object(blockpallet) (3)
	CreateDynamicObject(1388,1843.6000000,-1340.7000000,22.4000000,38.7610000,270.9270000,293.8290000); //object(twrcrane_s_04) (1)
	CreateDynamicObject(10984,1828.6000000,-1342.6000000,12.9000000,0.0000000,357.0000000,0.0000000); //object(rubbled01_sfs) (4)
	CreateDynamicObject(852,1869.6000000,-1323.9000000,43.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (4)
	CreateDynamicObject(854,1870.0000000,-1324.5000000,48.6000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (51)
	CreateDynamicObject(854,1869.6000000,-1323.7000000,48.6000000,0.0000000,0.0000000,82.0000000); //object(cj_urb_rub_3b) (52)
	CreateDynamicObject(854,1869.7000000,-1325.2000000,48.6000000,0.0000000,0.0000000,49.9960000); //object(cj_urb_rub_3b) (53)
	CreateDynamicObject(852,1870.1000000,-1322.8000000,43.5000000,0.0000000,0.0000000,146.0000000); //object(cj_urb_rub_4) (5)
	CreateDynamicObject(852,1871.6000000,-1323.6000000,43.5000000,0.0000000,0.0000000,64.9970000); //object(cj_urb_rub_4) (6)
	CreateDynamicObject(12957,1843.1000000,-1359.0000000,13.3000000,0.0000000,0.0000000,48.0000000); //object(sw_pickupwreck01) (3)
	CreateDynamicObject(3594,1839.6000000,-1372.5000000,13.2000000,0.0000000,0.0000000,330.0000000); //object(la_fuckcar1) (2)
	CreateDynamicObject(3594,1857.0000000,-1385.2000000,13.2000000,0.0000000,0.0000000,201.9960000); //object(la_fuckcar1) (3)
	CreateDynamicObject(3594,1856.9000000,-1410.1000000,13.2000000,0.0000000,0.0000000,139.9950000); //object(la_fuckcar1) (4)
	CreateDynamicObject(3594,1845.8000000,-1418.0000000,13.2000000,0.0000000,0.0000000,181.2430000); //object(la_fuckcar1) (5)
	CreateDynamicObject(3594,1849.8000000,-1355.7000000,13.2000000,0.0000000,0.0000000,239.2410000); //object(la_fuckcar1) (6)
	CreateDynamicObject(2927,2313.1001000,-1219.6000000,24.7000000,0.0000000,0.2500000,281.0000000); //object(a51_blastdoorr) (1)
	CreateDynamicObject(2927,2312.0000000,-1215.9000000,24.7000000,0.0000000,0.2470000,226.9970000); //object(a51_blastdoorr) (2)
	CreateDynamicObject(1742,2510.1001000,-1695.8000000,12.5000000,315.0000000,3.5000000,285.2500000); //object(med_bookshelf) (1)
	CreateDynamicObject(1743,2509.7000000,-1697.8000000,12.4000000,0.0000000,0.0000000,0.0000000); //object(med_cabinet_3) (1)
	CreateDynamicObject(1759,2521.2000000,-1687.0000000,12.6000000,0.0000000,0.0000000,24.0000000); //object(low_single_1) (1)
	CreateDynamicObject(1759,2522.6001000,-1688.8000000,12.6000000,0.0000000,0.0000000,102.0000000); //object(low_single_1) (2)
	CreateDynamicObject(3593,2575.7039000,-1618.8899000,18.5624300,0.0000000,0.0000000,84.5000000); //object(la_fuckcar2) (3)
	CreateDynamicObject(3593,2600.5000000,-1609.9000000,19.2000000,0.0000000,0.0000000,24.0000000); //object(la_fuckcar2) (4)
	CreateDynamicObject(3593,2600.2000000,-1629.2000000,19.2000000,0.0000000,2.0000000,24.0000000); //object(la_fuckcar2) (5)
	CreateDynamicObject(3594,2563.5000000,-1602.2000000,18.1000000,0.0000000,0.0000000,74.0000000); //object(la_fuckcar1) (7)
	CreateDynamicObject(3594,2596.7002000,-1599.4004000,19.1000000,0.0000000,0.0000000,35.9970000); //object(la_fuckcar1) (8)
	CreateDynamicObject(3594,2576.5000000,-1606.3000000,18.5000000,0.0000000,0.0000000,131.9980000); //object(la_fuckcar1) (9)
	CreateDynamicObject(3593,2600.2002000,-1618.0996000,19.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar2) (6)
	CreateDynamicObject(3594,2554.8999000,-1620.0000000,17.9000000,0.0000000,0.0000000,120.0000000); //object(la_fuckcar1) (10)
	CreateDynamicObject(3594,2539.6001000,-1601.3000000,17.5000000,0.0000000,0.0000000,60.0000000); //object(la_fuckcar1) (11)
	CreateDynamicObject(2676,2497.4004000,-1681.5996000,12.5000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_8) (3)
	CreateDynamicObject(3593,2669.0000000,-1423.0000000,30.2000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar2) (7)
	CreateDynamicObject(3594,2677.1001000,-1445.7000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (12)
	CreateDynamicObject(3593,2682.2000000,-1429.1000000,30.1000000,0.0000000,0.0000000,34.0000000); //object(la_fuckcar2) (8)
	CreateDynamicObject(3593,2660.3999000,-1429.2000000,30.2000000,0.0000000,0.0000000,33.9970000); //object(la_fuckcar2) (9)
	CreateDynamicObject(3593,2675.6001000,-1460.3000000,30.1000000,0.0000000,0.0000000,299.9970000); //object(la_fuckcar2) (10)
	CreateDynamicObject(9838,1915.9000000,-2433.7000000,45.4000000,0.0000000,0.0000000,359.2500000); //object(gg_split1_sfw) (1)
	CreateDynamicObject(9838,1915.8000000,-2433.7000000,45.4000000,0.0000000,0.0000000,176.4970000); //object(gg_split1_sfw) (2)
	CreateDynamicObject(9838,1977.5000000,-2435.1001000,45.4000000,0.0000000,0.0000000,178.7450000); //object(gg_split1_sfw) (3)
	CreateDynamicObject(9838,1977.6000000,-2435.2000000,45.4000000,0.0000000,0.0000000,358.2420000); //object(gg_split1_sfw) (4)
	CreateDynamicObject(3763,1996.5000000,-2435.2000000,182.8000000,0.0000000,0.2500000,267.9920000); //object(ce_radarmast3) (2)
	CreateDynamicObject(3763,1958.9000000,-2434.5000000,182.8000000,0.0000000,0.2470000,267.9900000); //object(ce_radarmast3) (3)
	CreateDynamicObject(3763,1934.8000000,-2434.3999000,182.8000000,0.0000000,0.2470000,267.9900000); //object(ce_radarmast3) (4)
	CreateDynamicObject(3763,1897.0000000,-2433.2000000,182.8000000,0.0000000,0.2470000,267.9900000); //object(ce_radarmast3) (5)
	CreateDynamicObject(9241,1747.6000000,-1991.3000000,14.0000000,0.0000000,0.0000000,0.0000000); //object(copbits_sfn) (1)
	CreateDynamicObject(3594,1664.3000000,-2113.7000000,13.2000000,0.0000000,0.0000000,52.0000000); //object(la_fuckcar1) (13)
	CreateDynamicObject(1219,1676.3000000,-2125.8000000,14.8000000,0.0000000,90.5000000,44.5000000); //object(palette) (35)
	CreateDynamicObject(1219,1673.1000000,-2122.8999000,14.8000000,0.0000000,90.5000000,223.2450000); //object(palette) (36)
	CreateDynamicObject(1219,1670.3000000,-2120.0000000,14.8000000,0.0000000,90.4940000,225.2420000); //object(palette) (37)
	CreateDynamicObject(1219,1673.2000000,-2106.2000000,14.8000000,0.0000000,90.4940000,270.7420000); //object(palette) (38)
	CreateDynamicObject(1219,1669.5000000,-2106.3000000,14.8000000,0.0000000,90.4940000,270.7420000); //object(palette) (39)
	CreateDynamicObject(1219,1667.2000000,-2106.3000000,14.8000000,0.0000000,89.2440000,270.7420000); //object(palette) (40)
	CreateDynamicObject(1219,1664.0000000,-2106.3000000,14.8000000,0.0000000,89.2420000,91.4860000); //object(palette) (41)
	CreateDynamicObject(1219,1686.8000000,-2097.3999000,14.1000000,0.0000000,88.5000000,94.0000000); //object(palette) (42)
	CreateDynamicObject(1219,1690.3000000,-2097.3999000,14.1000000,0.0000000,87.9950000,268.4990000); //object(palette) (43)
	CreateDynamicObject(1219,1684.8000000,-2097.7000000,14.1000000,0.0000000,89.9900000,269.2450000); //object(palette) (44)
	CreateDynamicObject(1219,1681.7000000,-2097.5000000,14.1000000,0.0000000,89.9890000,269.9920000); //object(palette) (45)
	CreateDynamicObject(1219,1681.7002000,-2097.5000000,14.1000000,0.0000000,89.9890000,269.9890000); //object(palette) (46)
	CreateDynamicObject(3276,1673.7000000,-2095.7000000,13.4000000,0.0000000,0.0000000,356.2500000); //object(cxreffencesld) (1)
	CreateDynamicObject(3276,1679.1000000,-2083.3000000,13.4000000,0.0000000,0.0000000,268.7480000); //object(cxreffencesld) (2)
	CreateDynamicObject(983,1662.1000000,-2100.6001000,13.2000000,0.0000000,0.0000000,88.5000000); //object(fenceshit3) (2)
	CreateDynamicObject(1219,1691.2000000,-2126.5000000,14.3000000,0.0000000,89.7500000,91.5000000); //object(palette) (47)
	CreateDynamicObject(1219,1694.9000000,-2126.7000000,14.3000000,0.0000000,89.7470000,91.5000000); //object(palette) (48)
	CreateDynamicObject(1219,1699.5000000,-2126.6001000,14.3000000,0.0000000,89.7470000,272.0000000); //object(palette) (49)
	CreateDynamicObject(1219,1709.4000000,-2126.2000000,14.3000000,0.0000000,272.4970000,270.7500000); //object(palette) (50)
	CreateDynamicObject(1219,1712.8000000,-2126.1001000,14.3000000,0.0000000,270.2440000,270.7470000); //object(palette) (51)
	CreateDynamicObject(1219,1714.8000000,-2126.3000000,14.3000000,0.0000000,270.2420000,270.7470000); //object(palette) (52)
	CreateDynamicObject(1219,1718.4000000,-2126.2000000,14.3000000,0.0000000,270.2420000,90.7470000); //object(palette) (53)
	CreateDynamicObject(1219,1715.8000000,-2100.6001000,14.4000000,0.0000000,90.0000000,270.0000000); //object(palette) (54)
	CreateDynamicObject(1219,1712.3000000,-2100.3999000,14.4000000,0.0000000,90.0000000,270.0000000); //object(palette) (55)
	CreateDynamicObject(1219,1707.5000000,-2100.5000000,14.4000000,0.0000000,90.0000000,270.0000000); //object(palette) (56)
	CreateDynamicObject(3594,1963.3000000,-2150.7000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (14)
	CreateDynamicObject(3594,1958.1000000,-2151.5000000,13.0000000,0.0000000,0.0000000,44.0000000); //object(la_fuckcar1) (15)
	CreateDynamicObject(3594,1962.1000000,-2124.6001000,13.0000000,0.0000000,0.0000000,43.9950000); //object(la_fuckcar1) (16)
	CreateDynamicObject(3594,1960.3000000,-2134.2000000,13.0000000,0.0000000,0.0000000,333.9950000); //object(la_fuckcar1) (17)
	CreateDynamicObject(3594,1973.7000000,-2166.2000000,13.0000000,0.0000000,0.0000000,333.9900000); //object(la_fuckcar1) (18)
	CreateDynamicObject(3594,1949.7000000,-2168.0000000,13.0000000,0.0000000,0.0000000,47.9900000); //object(la_fuckcar1) (19)
	CreateDynamicObject(3594,1948.7000000,-2161.6001000,13.0000000,0.0000000,0.0000000,113.9880000); //object(la_fuckcar1) (20)
	CreateDynamicObject(3594,1945.3000000,-2139.2000000,13.0000000,0.0000000,0.0000000,113.9830000); //object(la_fuckcar1) (21)
	CreateDynamicObject(3594,1972.2000000,-2113.1001000,13.0000000,0.0000000,0.0000000,113.9830000); //object(la_fuckcar1) (22)
	CreateDynamicObject(3594,1981.1000000,-2111.8000000,13.0000000,0.0000000,0.0000000,203.9830000); //object(la_fuckcar1) (23)
	CreateDynamicObject(3594,1950.5000000,-2126.0000000,13.0000000,0.0000000,0.0000000,129.9780000); //object(la_fuckcar1) (24)
	CreateDynamicObject(3594,1965.0000000,-2115.6001000,13.0000000,0.0000000,0.0000000,161.9740000); //object(la_fuckcar1) (25)
	CreateDynamicObject(3594,1960.0000000,-2099.8999000,13.0000000,0.0000000,0.0000000,345.9710000); //object(la_fuckcar1) (26)
	CreateDynamicObject(3594,1965.8000000,-2098.6001000,13.0000000,0.0000000,0.0000000,23.9700000); //object(la_fuckcar1) (27)
	CreateDynamicObject(3594,1989.2000000,-2110.5000000,13.0000000,0.0000000,0.0000000,23.9670000); //object(la_fuckcar1) (28)
	CreateDynamicObject(3594,1995.9004000,-2167.8994000,13.0000000,0.0000000,0.0000000,23.9670000); //object(la_fuckcar1) (29)
	CreateDynamicObject(3594,2006.4000000,-2165.5000000,13.0000000,0.0000000,0.0000000,83.9670000); //object(la_fuckcar1) (30)
	CreateDynamicObject(3594,1956.3000000,-2197.7000000,13.0000000,0.0000000,0.0000000,49.9630000); //object(la_fuckcar1) (31)
	CreateDynamicObject(3594,1931.4000000,-2162.8999000,13.0000000,0.0000000,0.0000000,113.9600000); //object(la_fuckcar1) (32)
	CreateDynamicObject(3594,1926.8000000,-2169.6001000,13.0000000,0.0000000,0.0000000,67.9560000); //object(la_fuckcar1) (33)
	CreateDynamicObject(3594,1907.7000000,-2151.8000000,13.0000000,0.0000000,0.0000000,55.9500000); //object(la_fuckcar1) (34)
	CreateDynamicObject(3594,1907.6000000,-2158.3000000,13.0000000,0.0000000,0.0000000,83.9480000); //object(la_fuckcar1) (35)
	CreateDynamicObject(3594,1907.5000000,-2169.0000000,13.0000000,0.0000000,0.0000000,125.9470000); //object(la_fuckcar1) (36)
	CreateDynamicObject(3594,1916.6000000,-2162.8000000,13.0000000,0.0000000,0.0000000,83.9420000); //object(la_fuckcar1) (37)
	CreateDynamicObject(3594,1894.6000000,-2164.1001000,13.0000000,0.0000000,0.0000000,89.9410000); //object(la_fuckcar1) (38)
	CreateDynamicObject(3594,1885.6000000,-2164.0000000,13.0000000,0.0000000,0.0000000,97.9400000); //object(la_fuckcar1) (39)
	CreateDynamicObject(3594,1876.9000000,-2163.8999000,13.0000000,0.0000000,0.0000000,85.9380000); //object(la_fuckcar1) (40)
	CreateDynamicObject(3594,1891.3000000,-2169.1001000,13.0000000,0.0000000,0.0000000,143.9350000); //object(la_fuckcar1) (41)
	CreateDynamicObject(3594,1886.1000000,-2169.0000000,13.0000000,0.0000000,0.0000000,51.9320000); //object(la_fuckcar1) (42)
	CreateDynamicObject(3594,1872.6000000,-2168.8999000,13.0000000,0.0000000,0.0000000,51.9270000); //object(la_fuckcar1) (43)
	CreateDynamicObject(3594,1859.9000000,-2166.7000000,13.0000000,0.0000000,4.0000000,127.9270000); //object(la_fuckcar1) (44)
	CreateDynamicObject(3594,1837.9000000,-2168.0000000,13.0000000,0.0000000,3.9990000,127.9250000); //object(la_fuckcar1) (45)
	CreateDynamicObject(3594,1848.1000000,-2167.3999000,13.0000000,0.0000000,3.9990000,67.9250000); //object(la_fuckcar1) (46)
	CreateDynamicObject(3594,1862.2000000,-2155.8000000,13.0000000,0.0000000,3.9940000,67.9230000); //object(la_fuckcar1) (47)
	CreateDynamicObject(3594,1875.5996000,-2155.7002000,13.0000000,0.0000000,3.9940000,13.9200000); //object(la_fuckcar1) (48)
	CreateDynamicObject(3594,1878.2000000,-2173.3999000,13.0000000,0.0000000,3.9880000,13.9200000); //object(la_fuckcar1) (49)
	CreateDynamicObject(3594,1858.5000000,-2146.0000000,13.0000000,0.0000000,3.9880000,57.9200000); //object(la_fuckcar1) (50)
	CreateDynamicObject(3594,1843.7000000,-2153.2000000,13.0000000,0.0000000,3.9880000,57.9140000); //object(la_fuckcar1) (51)
	CreateDynamicObject(3594,1818.4000000,-2143.8000000,13.0000000,0.0000000,3.9880000,123.9140000); //object(la_fuckcar1) (52)
	CreateDynamicObject(3594,1821.2000000,-2173.0000000,13.0000000,0.0000000,3.9880000,123.9090000); //object(la_fuckcar1) (53)
	CreateDynamicObject(3594,1821.4000000,-2161.8000000,13.0000000,0.0000000,3.9880000,147.9090000); //object(la_fuckcar1) (54)
	CreateDynamicObject(3594,1825.1000000,-2141.1001000,13.0000000,0.0000000,3.9880000,181.9090000); //object(la_fuckcar1) (55)
	CreateDynamicObject(3594,1812.1000000,-2161.2000000,13.0000000,0.0000000,3.9880000,181.9060000); //object(la_fuckcar1) (56)
	CreateDynamicObject(3594,1809.8000000,-2167.7000000,13.0000000,0.0000000,3.9880000,233.9060000); //object(la_fuckcar1) (57)
	CreateDynamicObject(3594,1820.1000000,-2150.8999000,13.0000000,0.0000000,3.9880000,233.9040000); //object(la_fuckcar1) (58)
	CreateDynamicObject(3594,1796.6000000,-2173.2000000,13.0000000,0.0000000,3.9880000,279.9040000); //object(la_fuckcar1) (59)
	CreateDynamicObject(3594,1790.0000000,-2164.1001000,13.0000000,0.0000000,3.9880000,279.9040000); //object(la_fuckcar1) (60)
	CreateDynamicObject(3594,1790.0000000,-2164.0996000,13.0000000,0.0000000,3.9880000,279.9040000); //object(la_fuckcar1) (61)
	CreateDynamicObject(3594,1779.9000000,-2183.8999000,13.0000000,0.0000000,3.9880000,329.9040000); //object(la_fuckcar1) (62)
	CreateDynamicObject(3594,1769.5000000,-2169.8999000,13.0000000,0.0000000,3.9880000,71.9030000); //object(la_fuckcar1) (63)
	CreateDynamicObject(3594,1770.2000000,-2161.3000000,13.0000000,0.0000000,3.9880000,107.9000000); //object(la_fuckcar1) (64)
	CreateDynamicObject(3594,1777.5000000,-2167.2000000,13.0000000,0.0000000,3.9880000,107.8970000); //object(la_fuckcar1) (65)
	CreateDynamicObject(3594,1756.1000000,-2185.3999000,13.0000000,0.0000000,3.9880000,53.8970000); //object(la_fuckcar1) (66)
	CreateDynamicObject(3594,1758.2000000,-2166.1001000,13.0000000,0.0000000,3.9880000,53.8930000); //object(la_fuckcar1) (67)
	CreateDynamicObject(3594,1761.5000000,-2172.1001000,13.0000000,0.0000000,3.9880000,137.8930000); //object(la_fuckcar1) (68)
	CreateDynamicObject(3594,1750.2000000,-2163.2000000,13.0000000,0.0000000,3.9880000,163.8890000); //object(la_fuckcar1) (69)
	CreateDynamicObject(3594,1750.4000000,-2172.3999000,13.0000000,0.0000000,189.9880000,163.8890000); //object(la_fuckcar1) (70)
	CreateDynamicObject(3594,1782.1000000,-2172.3000000,13.0000000,0.0000000,178.2370000,271.8890000); //object(la_fuckcar1) (71)
	CreateDynamicObject(3594,1712.8000000,-2167.8999000,14.4000000,0.0000000,358.7380000,73.8890000); //object(la_fuckcar1) (72)
	CreateDynamicObject(3594,1696.4000000,-2171.7000000,15.9000000,0.0000000,1.2350000,71.8860000); //object(la_fuckcar1) (73)
	CreateDynamicObject(3594,1711.8633000,-2161.5996000,14.5607800,0.0000000,353.9850000,127.8860000); //object(la_fuckcar1) (74)
	CreateDynamicObject(3594,1695.2000000,-2161.8999000,15.9000000,0.0000000,354.7350000,73.8830000); //object(la_fuckcar1) (75)
	CreateDynamicObject(3594,1825.5000000,-2113.8999000,13.0000000,0.0000000,1.7380000,181.9060000); //object(la_fuckcar1) (76)
	CreateDynamicObject(3594,1821.5000000,-2111.6001000,13.0000000,0.0000000,1.7360000,217.9010000); //object(la_fuckcar1) (77)
	CreateDynamicObject(3594,1827.4000000,-2101.3999000,13.0000000,0.0000000,1.7360000,217.8970000); //object(la_fuckcar1) (78)
	CreateDynamicObject(3594,1822.8000000,-2089.8000000,13.0000000,0.0000000,1.7360000,167.8970000); //object(la_fuckcar1) (79)
	CreateDynamicObject(3594,1829.9000000,-2077.0000000,13.0000000,0.0000000,1.7360000,167.8930000); //object(la_fuckcar1) (80)
	CreateDynamicObject(3594,1821.2000000,-2076.8999000,13.0000000,0.0000000,1.7360000,213.8930000); //object(la_fuckcar1) (81)
	CreateDynamicObject(3594,1812.6000000,-2074.2000000,13.0000000,0.0000000,1.7360000,285.8930000); //object(la_fuckcar1) (82)
	CreateDynamicObject(3594,1808.5000000,-2111.3999000,13.0000000,0.0000000,1.7360000,301.8920000); //object(la_fuckcar1) (83)
	CreateDynamicObject(3594,1800.7000000,-2118.1001000,13.0000000,0.0000000,1.7360000,353.8880000); //object(la_fuckcar1) (84)
	CreateDynamicObject(3594,1792.6000000,-2109.8999000,13.0000000,0.0000000,1.7360000,45.8860000); //object(la_fuckcar1) (85)
	CreateDynamicObject(3594,1776.8000000,-2118.7000000,13.0000000,0.0000000,1.7360000,45.8840000); //object(la_fuckcar1) (86)
	CreateDynamicObject(3594,1757.7000000,-2110.2000000,13.0000000,0.0000000,1.7360000,45.8840000); //object(la_fuckcar1) (87)
	CreateDynamicObject(3594,1772.4000000,-2111.6001000,13.0000000,0.0000000,7.7360000,333.8840000); //object(la_fuckcar1) (88)
	CreateDynamicObject(3594,1755.1000000,-2117.5000000,13.0000000,0.0000000,7.7340000,51.8800000); //object(la_fuckcar1) (89)
	CreateDynamicObject(3594,1745.5000000,-2110.8999000,13.0000000,0.0000000,7.7290000,355.8770000); //object(la_fuckcar1) (90)
	CreateDynamicObject(3594,1733.0000000,-2118.0000000,13.2000000,0.0000000,1.2230000,165.8750000); //object(la_fuckcar1) (91)
	CreateDynamicObject(3594,1733.3000000,-2109.8000000,13.2000000,0.0000000,1.2190000,119.8720000); //object(la_fuckcar1) (92)
	CreateDynamicObject(3594,1720.3000000,-2116.8000000,13.2000000,0.0000000,1.2190000,207.8660000); //object(la_fuckcar1) (93)
	CreateDynamicObject(3594,1959.4000000,-2067.5000000,13.0000000,0.0000000,0.0000000,33.9700000); //object(la_fuckcar1) (94)
	CreateDynamicObject(3594,1966.2000000,-2067.5000000,13.0000000,0.0000000,0.0000000,341.9700000); //object(la_fuckcar1) (95)
	CreateDynamicObject(3594,1963.2000000,-2080.8000000,13.0000000,0.0000000,0.0000000,3.9660000); //object(la_fuckcar1) (96)
	CreateDynamicObject(3594,1958.2000000,-2081.8000000,13.0000000,0.0000000,0.0000000,27.9610000); //object(la_fuckcar1) (97)
	CreateDynamicObject(3594,1938.7000000,-2090.1001000,13.0000000,0.0000000,0.0000000,91.9600000); //object(la_fuckcar1) (98)
	CreateDynamicObject(3594,1948.3000000,-2111.3000000,13.0000000,0.0000000,0.0000000,91.9560000); //object(la_fuckcar1) (99)
	CreateDynamicObject(3594,1948.3000000,-2119.5000000,13.0000000,0.0000000,0.0000000,287.9560000); //object(la_fuckcar1) (100)
	CreateDynamicObject(3594,1966.9000000,-2186.3000000,13.0000000,0.0000000,0.0000000,61.9880000); //object(la_fuckcar1) (101)
	CreateDynamicObject(3594,1964.7000000,-2165.7000000,13.0000000,0.0000000,0.0000000,319.9850000); //object(la_fuckcar1) (102)
	CreateDynamicObject(3594,1960.7000000,-2159.5000000,13.0000000,0.0000000,0.0000000,355.9820000); //object(la_fuckcar1) (103)
	CreateDynamicObject(3594,1967.2000000,-2159.6001000,13.0000000,0.0000000,0.0000000,273.9790000); //object(la_fuckcar1) (104)
	CreateDynamicObject(3594,2013.9000000,-2160.6001000,13.0000000,0.0000000,0.0000000,117.9630000); //object(la_fuckcar1) (105)
	CreateDynamicObject(3594,2021.1000000,-2168.2000000,13.0000000,0.0000000,0.0000000,59.9600000); //object(la_fuckcar1) (106)
	CreateDynamicObject(3594,2031.2000000,-2165.6001000,13.0000000,0.0000000,0.0000000,105.9580000); //object(la_fuckcar1) (107)
	CreateDynamicObject(3594,2032.2000000,-2160.3999000,13.0000000,0.0000000,0.0000000,129.9580000); //object(la_fuckcar1) (108)
	CreateDynamicObject(3594,2031.7000000,-2172.8999000,13.0000000,0.0000000,0.0000000,169.9570000); //object(la_fuckcar1) (109)
	CreateDynamicObject(3594,2049.8999000,-2173.7000000,13.0000000,0.0000000,0.0000000,169.9530000); //object(la_fuckcar1) (110)
	CreateDynamicObject(3594,2050.3000000,-2165.5000000,13.0000000,0.0000000,0.0000000,207.9530000); //object(la_fuckcar1) (111)
	CreateDynamicObject(3594,2052.1001000,-2159.3000000,13.0000000,0.0000000,0.0000000,297.9490000); //object(la_fuckcar1) (112)
	CreateDynamicObject(3594,2045.5000000,-2156.2000000,13.0000000,0.0000000,0.0000000,269.9440000); //object(la_fuckcar1) (113)
	CreateDynamicObject(3594,2065.3999000,-2169.3999000,13.0000000,0.0000000,0.0000000,299.9400000); //object(la_fuckcar1) (114)
	CreateDynamicObject(3594,2064.2000000,-2158.8999000,13.0000000,0.0000000,0.0000000,251.9380000); //object(la_fuckcar1) (115)
	CreateDynamicObject(3594,2067.3999000,-2177.1001000,13.0000000,0.0000000,0.0000000,251.9330000); //object(la_fuckcar1) (116)
	CreateDynamicObject(3594,2087.3999000,-2166.2000000,13.0000000,0.0000000,0.0000000,285.9330000); //object(la_fuckcar1) (117)
	CreateDynamicObject(3594,2087.7000000,-2173.7000000,13.0000000,0.0000000,0.0000000,285.9300000); //object(la_fuckcar1) (118)
	CreateDynamicObject(3594,2079.5000000,-2169.3999000,13.0000000,0.0000000,0.0000000,3.9300000); //object(la_fuckcar1) (119)
	CreateDynamicObject(3594,2087.6001000,-2182.3999000,13.0000000,0.0000000,0.0000000,33.9280000); //object(la_fuckcar1) (120)
	CreateDynamicObject(3594,2102.3000000,-2186.6001000,13.0000000,0.0000000,2.2500000,87.9260000); //object(la_fuckcar1) (121)
	CreateDynamicObject(3594,2112.7000000,-2200.7000000,13.0000000,0.0000000,2.2470000,137.9240000); //object(la_fuckcar1) (122)
	CreateDynamicObject(3594,2108.1001000,-2195.3999000,13.0000000,0.0000000,2.2410000,179.9220000); //object(la_fuckcar1) (123)
	CreateDynamicObject(3594,2134.1001000,-2206.3000000,13.0000000,0.0000000,2.2360000,179.9180000); //object(la_fuckcar1) (124)
	CreateDynamicObject(3594,2131.5000000,-2212.8000000,13.0000000,0.0000000,2.2360000,235.9180000); //object(la_fuckcar1) (125)
	CreateDynamicObject(3594,2129.1001000,-2217.7000000,13.0000000,0.0000000,2.2300000,249.9150000); //object(la_fuckcar1) (126)
	CreateDynamicObject(3594,1704.6000000,-2107.7000000,13.2000000,0.0000000,1.2190000,153.8610000); //object(la_fuckcar1) (127)
	CreateDynamicObject(3594,1704.5000000,-2117.2000000,13.2000000,0.0000000,1.2190000,153.8580000); //object(la_fuckcar1) (128)
	CreateDynamicObject(3594,1710.7000000,-2113.3999000,13.2000000,0.0000000,1.2190000,199.8580000); //object(la_fuckcar1) (129)
	CreateDynamicObject(3594,1696.3000000,-2104.6001000,13.2000000,0.0000000,1.2190000,199.8580000); //object(la_fuckcar1) (130)
	CreateDynamicObject(3594,1694.9000000,-2113.8999000,13.2000000,0.0000000,1.2190000,259.8580000); //object(la_fuckcar1) (131)
	CreateDynamicObject(3594,1681.6000000,-2113.2000000,13.2000000,0.0000000,1.2190000,199.8540000); //object(la_fuckcar1) (132)
	CreateDynamicObject(3818,85.7000000,-1536.2000000,5.9900000,87.6750000,33.9340000,48.0490000); //object(sf_frwaysig) (1)
	CreateDynamicObject(1259,2011.4000000,-2251.3999000,7.5010000,0.0000000,189.0000000,77.0000000); //object(billbd1) (1)
	CreateDynamicObject(852,2002.0000000,-2250.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (7)
	CreateDynamicObject(852,2000.8000000,-2250.8999000,12.5000000,0.0000000,0.0000000,106.0000000); //object(cj_urb_rub_4) (8)
	CreateDynamicObject(852,2000.8000000,-2249.6001000,12.5000000,0.0000000,0.0000000,49.9960000); //object(cj_urb_rub_4) (9)
	CreateDynamicObject(852,2002.4000000,-2249.6001000,12.5000000,0.0000000,0.0000000,49.9930000); //object(cj_urb_rub_4) (10)
	CreateDynamicObject(852,2002.0000000,-2251.8999000,12.5000000,0.0000000,0.0000000,49.9930000); //object(cj_urb_rub_4) (11)
	CreateDynamicObject(852,2003.1000000,-2250.1001000,12.5000000,0.0000000,0.0000000,49.9930000); //object(cj_urb_rub_4) (12)
	CreateDynamicObject(16665,1957.3000000,-2408.3000000,12.6000000,0.0000000,0.0000000,88.4950000); //object(a51_radarroom) (1)
	CreateDynamicObject(2951,1964.9000000,-2404.2000000,15.9900000,0.0000000,0.0000000,337.0000000); //object(a51_labdoor) (1)
	CreateDynamicObject(2951,1959.6000000,-2402.3999000,12.6000000,0.0000000,0.0000000,345.2460000); //object(a51_labdoor) (2)
	CreateDynamicObject(2951,1967.9000000,-2408.0000000,12.6000000,0.0000000,359.5000000,279.9950000); //object(a51_labdoor) (3)
	CreateDynamicObject(2951,1952.6000000,-2403.3000000,12.6000000,0.0000000,0.0000000,16.7450000); //object(a51_labdoor) (4)
	CreateDynamicObject(2951,1947.9000000,-2405.8000000,12.6000000,0.0000000,0.0000000,38.2430000); //object(a51_labdoor) (6)
	CreateDynamicObject(2951,1944.3000000,-2409.8999000,12.6000000,0.0000000,0.0000000,58.9880000); //object(a51_labdoor) (7)
	CreateDynamicObject(2951,1943.4000000,-2414.8999000,16.0000000,0.0000000,0.0000000,98.9860000); //object(a51_labdoor) (8)
	CreateDynamicObject(2951,1946.1000000,-2419.1001000,16.0000000,0.0000000,0.2360000,145.4810000); //object(a51_labdoor) (9)
	CreateDynamicObject(3864,1983.7002000,-2238.5000000,18.6000000,0.0000000,0.0000000,205.9990000); //object(ws_floodlight) (2)
	CreateDynamicObject(3864,1993.5000000,-2242.8000000,18.6000000,0.0000000,0.0000000,235.9990000); //object(ws_floodlight) (3)
	CreateDynamicObject(3864,1927.1000000,-2273.1001000,18.6000000,0.0000000,0.0000000,231.9970000); //object(ws_floodlight) (4)
	CreateDynamicObject(3864,1925.9000000,-2242.8999000,18.6000000,0.0000000,0.0000000,117.9930000); //object(ws_floodlight) (5)
	CreateDynamicObject(3864,1977.9000000,-2397.8000000,18.6000000,0.0000000,0.0000000,249.9880000); //object(ws_floodlight) (6)
	CreateDynamicObject(3864,2003.3000000,-2394.7000000,18.6000000,0.0000000,0.0000000,1.4830000); //object(ws_floodlight) (7)
	CreateDynamicObject(2951,1964.9004000,-2404.2002000,12.6000000,0.0000000,0.0000000,337.0000000); //object(a51_labdoor) (10)
	CreateDynamicObject(2951,1959.5996000,-2402.3994000,16.0000000,0.0000000,0.0000000,345.2450000); //object(a51_labdoor) (13)
	CreateDynamicObject(2951,1967.9004000,-2408.0000000,16.0000000,0.0000000,359.4950000,279.9920000); //object(a51_labdoor) (14)
	CreateDynamicObject(2951,1952.5996000,-2403.2998000,16.0000000,0.0000000,0.0000000,16.7430000); //object(a51_labdoor) (15)
	CreateDynamicObject(2951,1947.9004000,-2405.7998000,16.0000000,0.0000000,0.0000000,38.2380000); //object(a51_labdoor) (16)
	CreateDynamicObject(2951,1944.2998000,-2409.8994000,16.0000000,0.0000000,0.0000000,58.9860000); //object(a51_labdoor) (17)
	CreateDynamicObject(2951,1943.4004000,-2414.8994000,12.6000000,0.0000000,0.2360000,98.9810000); //object(a51_labdoor) (18)
	CreateDynamicObject(2951,1954.4000000,-2402.8000000,16.0000000,0.0000000,0.0000000,24.2430000); //object(a51_labdoor) (19)
	CreateDynamicObject(2951,1959.2000000,-2402.6001000,15.0000000,0.0000000,0.0000000,346.9920000); //object(a51_labdoor) (20)
	CreateDynamicObject(2951,1959.2002000,-2402.5996000,16.0000000,0.0000000,0.0000000,346.9920000); //object(a51_labdoor) (21)
	CreateDynamicObject(2951,1953.9004000,-2403.0000000,15.0000000,0.0000000,0.0000000,20.2420000); //object(a51_labdoor) (22)
	CreateDynamicObject(2927,1958.8000000,-2402.2000000,14.4000000,0.0000000,0.2500000,345.2500000); //object(a51_blastdoorr) (4)
	CreateDynamicObject(2927,1953.7000000,-2403.0000000,14.4000000,0.0000000,0.2470000,17.7450000); //object(a51_blastdoorr) (5)
	CreateDynamicObject(2951,1946.0996000,-2419.0996000,12.6000000,0.0000000,0.2360000,145.4810000); //object(a51_labdoor) (23)
	CreateDynamicObject(3095,1964.7000000,-2404.0000000,19.6000000,0.0000000,0.0000000,355.5000000); //object(a51_jetdoor) (50)
	CreateDynamicObject(3095,1955.8000000,-2403.3000000,19.6000000,0.0000000,0.0000000,355.4960000); //object(a51_jetdoor) (51)
	CreateDynamicObject(3095,1946.9000000,-2402.6001000,19.6000000,0.0000000,0.0000000,355.4960000); //object(a51_jetdoor) (52)
	CreateDynamicObject(3095,1946.2000000,-2411.5000000,19.6000000,0.0000000,0.0000000,355.4960000); //object(a51_jetdoor) (53)
	CreateDynamicObject(3095,1955.1000000,-2412.2000000,19.6000000,0.0000000,0.0000000,355.4960000); //object(a51_jetdoor) (54)
	CreateDynamicObject(3095,1964.0000000,-2412.8999000,19.6000000,0.0000000,0.0000000,355.4960000); //object(a51_jetdoor) (55)
	CreateDynamicObject(3095,1946.0000000,-2416.3000000,19.6000000,0.0000000,359.7500000,358.2460000); //object(a51_jetdoor) (56)
	CreateDynamicObject(3095,1954.9000000,-2417.2000000,19.6000000,0.0000000,0.0000000,355.9900000); //object(a51_jetdoor) (57)
	CreateDynamicObject(3095,1963.9000000,-2417.3999000,19.6000000,0.0000000,0.0000000,355.9950000); //object(a51_jetdoor) (58)
	CreateDynamicObject(11631,1967.8000000,-2396.8000000,13.8000000,0.0000000,0.0000000,268.0000000); //object(ranch_desk) (1)
	CreateDynamicObject(16641,1922.5000000,-2410.5000000,14.1000000,0.0000000,0.0000000,176.7500000); //object(des_a51warheads) (1)
	CreateDynamicObject(2922,1957.4000000,-2401.6001000,14.0000000,0.0000000,0.0000000,351.0000000); //object(kmb_keypad) (2)
	CreateDynamicObject(2207,1960.0000000,-2418.8999000,12.6000000,0.0000000,0.0000000,24.0000000); //object(med_office7_desk_1) (4)
	CreateDynamicObject(2207,1954.2000000,-2419.1001000,12.6000000,0.0000000,0.0000000,354.0000000); //object(med_office7_desk_1) (5)
	CreateDynamicObject(2207,1957.0000000,-2419.3999000,12.6000000,0.0000000,0.0000000,353.9960000); //object(med_office7_desk_1) (6)
	CreateDynamicObject(2207,1962.9000000,-2416.8999000,12.6000000,0.0000000,0.0000000,51.7500000); //object(med_office7_desk_1) (7)
	CreateDynamicObject(2207,1964.6000000,-2414.5000000,12.6000000,0.0000000,0.0000000,58.7460000); //object(med_office7_desk_1) (8)
	CreateDynamicObject(1682,1973.0000000,-2378.3000000,30.2000000,0.0000000,0.0000000,0.0000000); //object(ap_radar1_01) (1)
	CreateDynamicObject(1682,1974.3000000,-2407.2000000,30.2000000,0.0000000,0.0000000,300.0000000); //object(ap_radar1_01) (2)
	CreateDynamicObject(1682,1909.2000000,-2398.8999000,30.2000000,0.0000000,0.0000000,13.9980000); //object(ap_radar1_01) (3)
	CreateDynamicObject(1682,1910.7000000,-2380.6001000,30.2000000,0.0000000,0.0000000,194.4970000); //object(ap_radar1_01) (4)
	CreateDynamicObject(1681,1917.4339600,-2498.9399400,15.0000000,0.0000000,0.0000000,125.9970000); //object(ap_learjet1_01) (1)
	CreateDynamicObject(1683,1980.8000000,-2489.6001000,18.4000000,0.0000000,0.0000000,0.0000000); //object(ap_jumbo_01) (1)
	CreateDynamicObject(3269,2020.0000000,-2442.3999000,12.5000000,0.0000000,0.0000000,0.0000000); //object(bonyrd_block1_) (1)
	CreateDynamicObject(3665,1941.7000000,-2384.0000000,13.3000000,0.0000000,0.0000000,0.0000000); //object(airyelrm_las) (1)
	CreateDynamicObject(9819,1968.2002000,-2370.0000000,13.4000000,0.0000000,0.0000000,356.9680000); //object(shpbridge_sfw02) (2)
	CreateDynamicObject(9819,1918.3000000,-2365.3999000,13.4000000,0.0000000,0.0000000,87.2180000); //object(shpbridge_sfw02) (3)
	CreateDynamicObject(3384,1968.6000000,-2374.8000000,14.0000000,0.0000000,0.0000000,357.7500000); //object(a51_halbox_) (2)
	CreateDynamicObject(3384,1968.5000000,-2376.0000000,14.0000000,0.0000000,0.0000000,357.7480000); //object(a51_halbox_) (3)
	CreateDynamicObject(3384,1968.4000000,-2377.2000000,14.0000000,0.0000000,0.0000000,357.7480000); //object(a51_halbox_) (4)
	CreateDynamicObject(3384,1968.3000000,-2378.3999000,14.0000000,0.0000000,0.0000000,357.7480000); //object(a51_halbox_) (5)
	CreateDynamicObject(3384,1968.2000000,-2379.7000000,14.0000000,0.0000000,0.0000000,357.7480000); //object(a51_halbox_) (6)
	CreateDynamicObject(3273,1916.1000000,-2415.3000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(substa_transf2_) (1)
	CreateDynamicObject(3273,1930.7002000,-2415.2002000,12.6000000,0.0000000,0.0000000,0.0000000); //object(substa_transf2_) (2)
	CreateDynamicObject(3638,1920.2000000,-2397.3999000,15.9000000,0.0000000,0.0000000,0.0000000); //object(elecstionv_las) (1)
	CreateDynamicObject(3643,1912.4000000,-2239.1001000,18.5000000,0.0000000,0.0000000,0.0000000); //object(la_chem_piping) (1)
	CreateDynamicObject(12986,1879.1000000,-2304.8999000,14.1000000,0.0000000,0.0000000,358.0000000); //object(sw_well1) (3)
	CreateDynamicObject(2673,1883.5000000,-2305.8000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_5) (2)
	CreateDynamicObject(2673,1883.6000000,-2308.0000000,12.6000000,0.0000000,0.0000000,34.0000000); //object(proc_rubbish_5) (3)
	CreateDynamicObject(2673,1881.0000000,-2311.1001000,12.6000000,0.0000000,0.0000000,347.9970000); //object(proc_rubbish_5) (4)
	CreateDynamicObject(2673,1883.2000000,-2311.0000000,12.6000000,0.0000000,0.0000000,41.9920000); //object(proc_rubbish_5) (5)
	CreateDynamicObject(2675,1882.9000000,-2304.1001000,12.6000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_6) (3)
	CreateDynamicObject(2675,1883.7000000,-2308.5000000,12.6000000,0.0000000,0.0000000,36.0000000); //object(proc_rubbish_6) (4)
	CreateDynamicObject(2675,1882.1000000,-2310.8000000,12.6000000,0.0000000,0.0000000,67.9970000); //object(proc_rubbish_6) (5)
	CreateDynamicObject(2675,1879.3000000,-2310.5000000,12.6000000,0.0000000,0.0000000,93.9940000); //object(proc_rubbish_6) (6)
	CreateDynamicObject(2675,1881.0000000,-2298.8000000,12.6000000,0.0000000,0.0000000,55.9940000); //object(proc_rubbish_6) (7)
	CreateDynamicObject(2675,1884.0000000,-2301.3000000,12.6000000,0.0000000,0.0000000,55.9920000); //object(proc_rubbish_6) (8)
	CreateDynamicObject(2675,1878.0000000,-2297.5000000,12.6000000,0.0000000,0.0000000,119.9920000); //object(proc_rubbish_6) (9)
	CreateDynamicObject(2675,1878.2000000,-2298.7000000,12.6000000,0.0000000,0.0000000,93.9870000); //object(proc_rubbish_6) (10)
	CreateDynamicObject(2675,1876.0000000,-2299.1001000,12.6000000,0.0000000,0.0000000,53.9830000); //object(proc_rubbish_6) (11)
	CreateDynamicObject(1328,1882.3000000,-2304.2000000,13.1000000,0.0000000,0.0000000,0.0000000); //object(binnt10_la) (1)
	CreateDynamicObject(1328,1882.2998000,-2306.5996000,13.1000000,0.0000000,0.0000000,0.0000000); //object(binnt10_la) (2)
	CreateDynamicObject(1333,1881.8000000,-2310.3999000,13.5000000,0.0000000,0.0000000,0.0000000); //object(binnt03_la) (1)
	CreateDynamicObject(1333,1878.0000000,-2307.8000000,13.5000000,0.0000000,0.0000000,356.0000000); //object(binnt03_la) (2)
	CreateDynamicObject(1336,1875.9000000,-2299.1001000,13.6000000,0.0000000,0.0000000,180.0000000); //object(binnt06_la) (1)
	CreateDynamicObject(1227,1882.3000000,-2295.1001000,13.4000000,0.0000000,0.0000000,68.0000000); //object(dump1) (1)
	CreateDynamicObject(1230,1880.5000000,-2300.1001000,13.0000000,0.0000000,0.0000000,30.0000000); //object(cardboardbox) (2)
	CreateDynamicObject(1230,1879.4000000,-2300.8000000,13.0000000,0.0000000,0.0000000,351.9980000); //object(cardboardbox) (3)
	CreateDynamicObject(1230,1878.3000000,-2299.1001000,13.0000000,0.0000000,0.0000000,33.9960000); //object(cardboardbox) (4)
	CreateDynamicObject(1230,1878.1000000,-2300.1001000,13.0000000,0.0000000,0.0000000,73.9920000); //object(cardboardbox) (5)
	CreateDynamicObject(1230,1880.2000000,-2298.8000000,13.0000000,0.0000000,0.0000000,131.9870000); //object(cardboardbox) (6)
	CreateDynamicObject(1264,1876.3000000,-2303.8999000,13.0000000,0.0000000,0.0000000,0.0000000); //object(blackbag1) (1)
	CreateDynamicObject(1264,1877.5000000,-2303.0000000,13.0000000,0.0000000,0.0000000,324.0000000); //object(blackbag1) (2)
	CreateDynamicObject(1264,1876.0000000,-2303.1001000,13.0000000,0.0000000,0.0000000,323.9980000); //object(blackbag1) (3)
	CreateDynamicObject(1264,1876.6000000,-2302.6001000,13.0000000,0.0000000,0.0000000,7.9980000); //object(blackbag1) (4)
	CreateDynamicObject(1369,1878.4000000,-2305.1001000,14.3000000,0.0000000,0.0000000,0.0000000); //object(cj_wheelchair1) (3)
	CreateDynamicObject(1337,1885.0000000,-2312.1001000,13.2000000,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (11)
	CreateDynamicObject(2676,2499.8000000,-1679.5000000,12.5000000,0.0000000,0.0000000,64.0000000); //object(proc_rubbish_8) (4)
	CreateDynamicObject(2676,2493.8999000,-1678.5000000,12.5000000,0.0000000,0.0000000,123.9950000); //object(proc_rubbish_8) (5)
	CreateDynamicObject(2676,2496.6001000,-1678.9000000,12.5000000,0.0000000,0.0000000,101.9920000); //object(proc_rubbish_8) (6)
	CreateDynamicObject(4100,1907.5000000,-2276.8999000,14.2000000,0.0000000,0.0000000,317.2500000); //object(meshfence1_lan) (3)
	CreateDynamicObject(4100,1893.7998000,-2276.1992200,14.2000000,0.0000000,0.0000000,317.2470000); //object(meshfence1_lan) (4)
	CreateDynamicObject(4100,1880.1000000,-2275.5000000,14.2000000,0.0000000,0.0000000,317.2470000); //object(meshfence1_lan) (5)
	CreateDynamicObject(4100,1905.8000000,-2246.8999000,14.2000000,0.0000000,0.0000000,317.4970000); //object(meshfence1_lan) (6)
	CreateDynamicObject(4100,1892.1000000,-2246.3000000,14.2000000,0.0000000,0.0000000,317.7470000); //object(meshfence1_lan) (7)
	CreateDynamicObject(11455,1966.5000000,-2177.7000000,27.7000000,0.0000000,0.0000000,0.0000000); //object(des_medcensgn01) (1)
	CreateDynamicObject(2204,1918.5000000,-2247.6001000,12.5000000,0.0000000,0.0000000,356.5000000); //object(med_office8_cabinet) (2)
	CreateDynamicObject(1760,1924.4000000,-2248.3999000,12.5000000,0.0000000,0.0000000,269.0000000); //object(med_couch_2) (1)
	CreateDynamicObject(16155,1968.2998000,-2366.3501000,14.5000000,0.0000000,0.0000000,283.2500000); //object(ufo_backrmstuff) (1)
	CreateDynamicObject(1812,1877.0000000,-2273.2000000,12.5000000,0.0000000,0.0000000,92.0000000); //object(low_bed_5) (3)
	CreateDynamicObject(2233,2004.7000000,-2227.7000000,17.3000000,0.0000000,24.2500000,179.2500000); //object(swank_speaker_4) (1)
	CreateDynamicObject(2233,1955.1000000,-2181.6001000,15.9800000,0.0000000,0.2470000,179.2470000); //object(swank_speaker_4) (2)
	CreateDynamicObject(1801,1909.5000000,-2272.8000000,12.5000000,0.0000000,0.0000000,178.0000000); //object(swank_bed_4) (1)
	CreateDynamicObject(1801,1913.5000000,-2273.1001000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (2)
	CreateDynamicObject(1801,1917.5000000,-2273.2000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (3)
	CreateDynamicObject(1801,1921.7000000,-2273.3999000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (4)
	CreateDynamicObject(1801,1921.8000000,-2265.8999000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (5)
	CreateDynamicObject(1801,1917.6000000,-2265.8999000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (6)
	CreateDynamicObject(1801,1913.6000000,-2265.8999000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (7)
	CreateDynamicObject(1801,1909.8000000,-2265.7000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (8)
	CreateDynamicObject(1801,1910.0000000,-2260.6001000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (9)
	CreateDynamicObject(1801,1913.8000000,-2260.6001000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (10)
	CreateDynamicObject(1801,1917.8000000,-2260.6001000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (11)
	CreateDynamicObject(1801,1921.9000000,-2260.6001000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (12)
	CreateDynamicObject(1801,1922.1000000,-2255.2000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (13)
	CreateDynamicObject(1801,1917.9000000,-2255.2000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (14)
	CreateDynamicObject(1801,1914.0000000,-2255.2000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (15)
	CreateDynamicObject(1801,1910.2000000,-2255.2000000,12.5000000,0.0000000,0.0000000,177.9950000); //object(swank_bed_4) (16)
	CreateDynamicObject(1789,1915.9000000,-2249.2000000,13.1000000,0.0000000,0.0000000,50.0000000); //object(cj_chambermaid) (1)
	CreateDynamicObject(1808,1917.7000000,-2247.8000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_watercooler2) (1)
	CreateDynamicObject(1808,1917.2000000,-2247.8000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_watercooler2) (2)
	CreateDynamicObject(1808,1916.7000000,-2247.8000000,12.5000000,0.0000000,0.0000000,357.7500000); //object(cj_watercooler2) (3)
	CreateDynamicObject(1808,1916.2000000,-2247.8000000,12.5000000,0.0000000,0.0000000,357.7480000); //object(cj_watercooler2) (4)
	CreateDynamicObject(1808,1915.7000000,-2247.8000000,12.5000000,0.0000000,0.0000000,357.7480000); //object(cj_watercooler2) (5)
	CreateDynamicObject(2131,1913.9000000,-2247.8000000,12.5000000,0.0000000,0.0000000,358.2500000); //object(cj_kitch2_fridge) (1)
	CreateDynamicObject(2647,1918.4000000,-2247.8000000,14.4000000,0.0000000,0.0000000,80.0000000); //object(cj_bs_cup) (1)
	CreateDynamicObject(2647,1918.9000000,-2247.8999000,14.4000000,0.0000000,0.0000000,79.9970000); //object(cj_bs_cup) (2)
	CreateDynamicObject(2647,1919.8000000,-2248.0000000,14.4000000,0.0000000,0.0000000,41.4970000); //object(cj_bs_cup) (3)
	CreateDynamicObject(1740,1907.4000000,-2274.6001000,12.7000000,0.0000000,0.0000000,180.0000000); //object(low_cabinet_3) (1)
	CreateDynamicObject(1740,1911.6000000,-2274.7000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (2)
	CreateDynamicObject(1740,1915.5000000,-2274.8000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (3)
	CreateDynamicObject(1740,1919.8000000,-2274.8999000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (4)
	CreateDynamicObject(1740,1919.9000000,-2267.8000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (5)
	CreateDynamicObject(1740,1915.7000000,-2267.3000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (6)
	CreateDynamicObject(1740,1911.7000000,-2267.7000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (7)
	CreateDynamicObject(1740,1907.9000000,-2267.3999000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (8)
	CreateDynamicObject(1740,1908.1000000,-2262.6001000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (9)
	CreateDynamicObject(1740,1912.0000000,-2262.2000000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (10)
	CreateDynamicObject(1740,1916.0000000,-2262.3999000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (11)
	CreateDynamicObject(1740,1920.0000000,-2262.3999000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (12)
	CreateDynamicObject(1740,1920.2000000,-2257.1001000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (13)
	CreateDynamicObject(1740,1916.1000000,-2257.1001000,12.7000000,0.0000000,0.0000000,179.9950000); //object(low_cabinet_3) (14)
	CreateDynamicObject(1740,1912.1000000,-2257.1001000,12.7000000,0.0000000,0.0000000,178.9950000); //object(low_cabinet_3) (15)
	CreateDynamicObject(1740,1908.4000000,-2257.1001000,12.7000000,0.0000000,0.0000000,178.9890000); //object(low_cabinet_3) (16)
	CreateDynamicObject(2903,1975.5000000,-2308.3999000,38.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_parachute) (1)
	CreateDynamicObject(2903,1921.9000000,-2307.3000000,38.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_parachute) (2)
	CreateDynamicObject(2902,1915.6000000,-2249.3000000,13.3000000,0.0000000,0.0000000,44.5000000); //object(kmb_smokecan) (1)
	CreateDynamicObject(1789,1915.0000000,-2250.0000000,13.1000000,0.0000000,0.0000000,139.9990000); //object(cj_chambermaid) (2)
	CreateDynamicObject(1812,1876.9000000,-2270.5000000,12.5000000,0.0000000,0.0000000,92.0000000); //object(low_bed_5) (4)
	CreateDynamicObject(1812,1876.8000000,-2268.0000000,12.5000000,0.0000000,0.0000000,88.2500000); //object(low_bed_5) (5)
	CreateDynamicObject(1812,1876.7000000,-2264.3000000,12.5000000,0.0000000,0.0000000,94.4980000); //object(low_bed_5) (6)
	CreateDynamicObject(1812,1883.7000000,-2271.3000000,12.5000000,0.0000000,0.0000000,138.4930000); //object(low_bed_5) (7)
	CreateDynamicObject(1812,1883.5000000,-2264.1001000,12.5000000,0.0000000,0.0000000,74.4880000); //object(low_bed_5) (8)
	CreateDynamicObject(1812,1898.3000000,-2252.5000000,12.5000000,0.0000000,0.0000000,74.4870000); //object(low_bed_5) (9)
	CreateDynamicObject(1812,1892.4000000,-2257.2000000,12.5000000,0.0000000,2.0000000,120.4870000); //object(low_bed_5) (10)
	CreateDynamicObject(1812,1894.4000000,-2266.0000000,12.5000000,0.0000000,2.0000000,72.4870000); //object(low_bed_5) (11)
	CreateDynamicObject(1812,1900.4000000,-2270.8000000,12.5000000,0.0000000,2.0000000,130.4820000); //object(low_bed_5) (12)
	CreateDynamicObject(1502,1905.0601000,-2249.4902000,12.5000000,0.0000000,0.0000000,87.2500000); //object(gen_doorint04) (1)
	CreateDynamicObject(1502,1903.8000000,-2275.7991000,12.5000000,0.0000000,0.0000000,86.4980000); //object(gen_doorint04) (2)
	CreateDynamicObject(2035,2004.3000000,-2411.8000000,13.4000000,0.0000000,0.0000000,281.5000000); //object(cj_m16) (3)
	CreateDynamicObject(2036,2004.4000000,-2413.5000000,13.4000000,0.0000000,0.0000000,97.7500000); //object(cj_psg1) (2)
	CreateDynamicObject(2044,2003.0000000,-2421.0000000,13.1000000,0.0000000,0.0000000,0.0000000); //object(cj_mp5k) (2)
	CreateDynamicObject(2061,1976.4000000,-2402.0000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(cj_shells1) (2)
	CreateDynamicObject(2061,1975.6000000,-2402.0000000,13.0000000,0.0000000,0.0000000,36.0000000); //object(cj_shells1) (3)
	CreateDynamicObject(2061,1977.0000000,-2402.0000000,13.0000000,0.0000000,0.0000000,324.7470000); //object(cj_shells1) (4)
	CreateDynamicObject(2064,1983.1000000,-2416.2000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(cj_feildgun) (1)
	CreateDynamicObject(2064,1980.4000000,-2416.3000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(cj_feildgun) (2)
	CreateDynamicObject(2064,1985.9000000,-2416.0000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(cj_feildgun) (3)
	CreateDynamicObject(2064,1988.4000000,-2415.8999000,13.2000000,0.0000000,0.0000000,0.0000000); //object(cj_feildgun) (4)
	CreateDynamicObject(2709,1920.3000000,-2248.0000000,14.4000000,0.0000000,0.0000000,0.0000000); //object(pain_killer) (1)
	CreateDynamicObject(2057,1978.5000000,-2402.2000000,14.8000000,0.0000000,0.0000000,0.0000000); //object(flame_tins) (4)
	CreateDynamicObject(1550,1975.2000000,-2419.2000000,12.9000000,0.0000000,0.0000000,0.0000000); //object(cj_money_bag) (1)
	CreateDynamicObject(1252,2004.4000000,-2406.7000000,13.3191000,90.0000000,271.0000000,90.0000000); //object(barrelexpos) (1)
	CreateDynamicObject(1672,2002.9000000,-2402.8000000,13.1000000,0.0000000,0.0000000,0.0000000); //object(gasgrenade) (2)
	CreateDynamicObject(1654,1976.4000000,-2402.3999000,13.8000000,337.0000000,270.0000000,0.0000000); //object(dynamite) (1)
	CreateDynamicObject(18257,1996.3000000,-2416.1001000,12.5000000,0.0000000,0.0000000,177.7500000); //object(crates) (1)
	CreateDynamicObject(2912,1975.6000000,-2403.2000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(temp_crate1) (1)
	CreateDynamicObject(964,1995.3000000,-2418.3999000,14.5000000,0.0000000,0.0000000,212.0000000); //object(cj_metal_crate) (1)
	CreateDynamicObject(964,1996.1000000,-2415.2000000,12.5000000,0.0000000,0.0000000,189.9980000); //object(cj_metal_crate) (2)
	CreateDynamicObject(16096,1975.5000000,-2241.3994100,14.5000000,0.0000000,0.0000000,272.0000000); //object(des_a51guardbox04) (2)
	CreateDynamicObject(16096,1975.2000000,-2235.5000000,14.5000000,0.0000000,0.0000000,273.0000000); //object(des_a51guardbox04) (3)
	CreateDynamicObject(3098,1727.2000000,-1637.2000000,21.5000000,0.0000000,0.0000000,0.0000000); //object(break_wall_1b) (2)
	CreateDynamicObject(3098,1729.0000000,-1638.6000000,21.5000000,0.0000000,0.0000000,16.2500000); //object(break_wall_1b) (3)
	CreateDynamicObject(3098,1724.5000000,-1637.8000000,21.5000000,0.0000000,0.0000000,344.2490000); //object(break_wall_1b) (4)
	CreateDynamicObject(3097,1697.5996100,-1664.0996100,19.2000000,0.0000000,163.9930000,356.9900000); //object(break_wall_2b) (2)
	CreateDynamicObject(3593,1481.1000000,-1639.5000000,13.9000000,0.0000000,0.0000000,254.0000000); //object(la_fuckcar2) (11)
	CreateDynamicObject(3761,823.2000100,-1589.4000000,14.6700000,0.0000000,19.7500000,52.0000000); //object(industshelves) (1)
	CreateDynamicObject(3569,2421.9490000,-1504.1400000,25.3000000,0.0000000,0.0000000,7.0000000); //object(lasntrk3) (1)
	CreateDynamicObject(3572,1199.1620000,-921.0720200,43.5000000,0.0000000,0.0000000,7.2460000); //object(lasdkrt4) (1)
	CreateDynamicObject(1219,1185.6000000,-914.0999800,43.8000000,0.0000000,86.0000000,11.5000000); //object(palette) (57)
	CreateDynamicObject(1219,1185.8000000,-915.7000100,43.8000000,0.0000000,85.7490000,6.7470000); //object(palette) (58)
	CreateDynamicObject(1219,1187.1000000,-911.2000100,43.8000000,0.0000000,89.2450000,186.7470000); //object(palette) (59)
	CreateDynamicObject(1219,1186.8000000,-909.0999800,43.8000000,0.0000000,90.2420000,8.4960000); //object(palette) (60)
	CreateDynamicObject(1219,1187.3000000,-916.7999900,43.8000000,0.0000000,90.2420000,97.4920000); //object(palette) (61)
	CreateDynamicObject(1219,1190.1000000,-916.4000200,43.8000000,0.0000000,89.4860000,276.7370000); //object(palette) (62)
	CreateDynamicObject(1219,1202.4000000,-919.0000000,43.8000000,0.0000000,89.4840000,274.9850000); //object(palette) (63)
	CreateDynamicObject(1219,1203.9000000,-918.7999900,43.8000000,0.0000000,89.2340000,97.7320000); //object(palette) (64)
	CreateDynamicObject(1219,1206.8000000,-892.5999800,43.8000000,0.0000000,89.2310000,7.4790000); //object(palette) (65)
	CreateDynamicObject(1219,1207.2000000,-895.0999800,43.8000000,0.0000000,89.2250000,8.2260000); //object(palette) (66)
	CreateDynamicObject(1219,1207.5000000,-897.5000000,43.8000000,0.0000000,89.2250000,8.2230000); //object(palette) (67)
	CreateDynamicObject(1219,1207.8000000,-899.7999900,43.8000000,0.0000000,89.2250000,187.7230000); //object(palette) (68)
	CreateDynamicObject(1219,1205.5000000,-891.7000100,43.8000000,0.0000000,89.9750000,276.9680000); //object(palette) (69)
	CreateDynamicObject(1219,1203.0000000,-892.0000000,43.8000000,0.0000000,89.9730000,276.9650000); //object(palette) (70)
	CreateDynamicObject(1219,1200.6000000,-892.2999900,43.8000000,0.0000000,89.9730000,96.7150000); //object(palette) (71)
	CreateDynamicObject(1219,1198.0000000,-892.5999800,43.8000000,0.0000000,89.9670000,96.7130000); //object(palette) (72)
	CreateDynamicObject(1219,1195.1000000,-893.0000000,43.8000000,0.0000000,89.9670000,277.4630000); //object(palette) (73)
	CreateDynamicObject(1219,1192.0000000,-893.4000200,43.8000000,0.0000000,89.9620000,96.9600000); //object(palette) (74)
	CreateDynamicObject(1219,1189.3000000,-893.7000100,43.8000000,0.0000000,89.9560000,96.9540000); //object(palette) (75)
	CreateDynamicObject(1219,1186.1000000,-894.2000100,43.8000000,0.0000000,89.9560000,277.7040000); //object(palette) (76)
	CreateDynamicObject(1219,1185.1000000,-895.7999900,43.8000000,0.0000000,89.9510000,7.7010000); //object(palette) (77)
	CreateDynamicObject(1219,1185.5000000,-899.0000000,43.8000000,0.0000000,89.9450000,185.9510000); //object(palette) (78)
	CreateDynamicObject(1219,1185.9000000,-901.7000100,43.8000000,0.0000000,89.9400000,187.6990000); //object(palette) (79)
	CreateDynamicObject(18257,996.0770300,-916.7979700,41.2000000,0.0000000,0.0000000,118.9980000); //object(crates) (2)
	CreateDynamicObject(3569,1364.9960000,-1283.8800000,15.0000000,0.0000000,0.0000000,2.0000000); //object(lasntrk3) (2)
	CreateDynamicObject(3577,1421.0000000,-1321.4000000,13.3000000,0.0000000,0.0000000,0.0000000); //object(dockcrates1_la) (1)
	CreateDynamicObject(3796,1424.4000000,-1354.1000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(acbox1_sfs) (1)
	CreateDynamicObject(3566,1446.5000000,-1328.5999800,14.9250000,0.0000000,0.0000000,0.0000000); //object(lasntrk1) (1)
	CreateDynamicObject(3800,1423.4000000,-1322.5000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (7)
	CreateDynamicObject(1437,1441.6980000,-1328.2779500,13.5000000,330.2440000,0.0000000,271.7470000); //object(dyn_ladder_2) (1)
	CreateDynamicObject(853,1406.9000000,-1369.1000000,8.0000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_5) (2)
	CreateDynamicObject(853,1407.9000000,-1370.3000000,7.8900000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_5) (3)
	CreateDynamicObject(853,1407.6000000,-1371.5000000,7.9000000,0.0000000,0.0000000,124.0000000); //object(cj_urb_rub_5) (4)
	CreateDynamicObject(853,1407.4000000,-1368.5000000,7.9000000,0.0000000,0.0000000,123.9970000); //object(cj_urb_rub_5) (5)
	CreateDynamicObject(854,1405.7000000,-1369.3000000,7.7000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (54)
	CreateDynamicObject(854,1407.4000000,-1368.0000000,7.7000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_3b) (55)
	CreateDynamicObject(854,1406.0000000,-1367.6000000,7.7000000,0.0000000,0.0000000,42.0000000); //object(cj_urb_rub_3b) (56)
	CreateDynamicObject(854,1409.1000000,-1368.8000000,7.7000000,0.0000000,0.0000000,167.9950000); //object(cj_urb_rub_3b) (57)
	CreateDynamicObject(854,1409.1000000,-1370.5000000,7.7000000,0.0000000,0.0000000,293.9920000); //object(cj_urb_rub_3b) (58)
	CreateDynamicObject(952,1425.2000000,-1293.5000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(generator_big_d) (1)
	CreateDynamicObject(2932,460.2000100,-1500.8000000,31.5000000,0.0000000,0.0000000,8.2500000); //object(kmb_container_blue) (1)
	CreateDynamicObject(3577,453.1000100,-1478.3000000,30.6000000,0.0000000,0.0000000,22.2500000); //object(dockcrates1_la) (2)
	CreateDynamicObject(3577,453.0996100,-1478.2998000,32.0000000,0.0000000,0.0000000,22.2470000); //object(dockcrates1_la) (3)
	CreateDynamicObject(5259,1894.2000000,-2403.5000000,14.2500000,0.0000000,0.0000000,0.0000000); //object(las2dkwar01) (1)
	CreateDynamicObject(3566,2103.0149000,-1802.6130000,14.9000000,0.0000000,0.0000000,0.2500000); //object(lasntrk1) (2)
	CreateDynamicObject(2567,2228.4431000,-1722.6570000,15.1500000,23.7660000,86.7720000,136.7370000); //object(ab_warehouseshelf) (1)
	CreateDynamicObject(3565,2396.1001000,-1898.2000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(lasdkrt1_la01) (1)
	CreateDynamicObject(3594,1402.1000000,-1448.0000000,13.2000000,0.0000000,0.0000000,50.0000000); //object(la_fuckcar1) (133)
	CreateDynamicObject(12957,1410.8000000,-1422.3000000,14.1000000,0.0000000,0.0000000,32.0000000); //object(sw_pickupwreck01) (4)
	CreateDynamicObject(12957,1410.8000000,-1422.3000000,14.1000000,0.0000000,0.0000000,32.0000000); //object(sw_pickupwreck01) (5)
	CreateDynamicObject(1331,2006.7000000,-2005.4000000,13.5000000,0.0000000,0.0000000,0.0000000); //object(binnt01_la) (1)
	CreateDynamicObject(2676,2010.3000000,-2004.6000000,12.7000000,0.0000000,0.0000000,78.0000000); //object(proc_rubbish_8) (7)
	CreateDynamicObject(2676,2007.5996000,-2008.0996000,12.7000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_8) (8)
	CreateDynamicObject(2676,2007.9000000,-2005.7000000,12.7000000,0.0000000,0.0000000,141.9970000); //object(proc_rubbish_8) (9)
	CreateDynamicObject(3593,1990.7000000,-2050.2000000,13.0000000,0.0000000,0.0000000,307.7500000); //object(la_fuckcar2) (12)
	CreateDynamicObject(3594,1989.4000000,-2168.5000000,13.0000000,0.0000000,0.0000000,97.9670000); //object(la_fuckcar1) (134)
	CreateDynamicObject(3594,1982.9000000,-2171.3999000,13.0000000,0.0000000,0.0000000,263.9650000); //object(la_fuckcar1) (135)
	CreateDynamicObject(3594,1992.7000000,-2160.5000000,13.0000000,0.0000000,0.0000000,309.9630000); //object(la_fuckcar1) (136)
	CreateDynamicObject(3594,2004.4000000,-2173.2000000,13.0000000,0.0000000,0.0000000,3.9630000); //object(la_fuckcar1) (137)
	CreateDynamicObject(3594,1950.6000000,-2148.8999000,13.0000000,0.0000000,0.0000000,309.9610000); //object(la_fuckcar1) (138)
	CreateDynamicObject(3594,1931.3000000,-2141.5000000,13.0000000,0.0000000,0.0000000,2.9570000); //object(la_fuckcar1) (139)
	CreateDynamicObject(3594,1926.4000000,-2145.2000000,13.0000000,0.0000000,180.7500000,18.9550000); //object(la_fuckcar1) (140)
	CreateDynamicObject(3594,1917.5000000,-2136.6001000,13.0000000,0.0000000,180.7470000,86.9510000); //object(la_fuckcar1) (141)
	CreateDynamicObject(3594,1896.1000000,-2149.8000000,13.0000000,0.0000000,180.7420000,346.9510000); //object(la_fuckcar1) (142)
	CreateDynamicObject(3594,1871.5000000,-2148.2000000,13.0000000,0.0000000,3.9940000,139.9200000); //object(la_fuckcar1) (143)
	CreateDynamicObject(3594,1886.4000000,-2157.7000000,13.0000000,0.0000000,1.2380000,185.9160000); //object(la_fuckcar1) (144)
	CreateDynamicObject(1308,1958.6000000,-2140.1001000,12.4000000,0.0000000,80.5000000,270.0000000); //object(telgrphpole02) (1)
	CreateDynamicObject(1308,1955.6000000,-2061.7000000,12.4000000,0.0000000,80.4970000,338.0000000); //object(telgrphpole02) (2)
	CreateDynamicObject(3585,1999.2000000,-1953.8000000,14.2000000,0.0000000,0.0000000,1.2450000); //object(lastran1_la02) (1)
	CreateDynamicObject(3585,1983.0000000,-1958.3000000,14.2000000,0.0000000,0.0000000,1.2410000); //object(lastran1_la02) (2)
	CreateDynamicObject(3585,1943.1000000,-1954.1000000,14.2000000,0.0000000,0.0000000,1.2410000); //object(lastran1_la02) (3)
	CreateDynamicObject(3585,1925.6000000,-1954.0000000,14.2000000,0.0000000,0.0000000,1.2410000); //object(lastran1_la02) (4)
	CreateDynamicObject(3585,1925.8990500,-1967.6989700,14.1750000,0.0000000,179.9950000,37.2380000); //object(lastran1_la02) (5)
	CreateDynamicObject(3585,1935.8000500,-1947.5000000,14.1750000,0.0000000,179.9950000,293.2360000); //object(lastran1_la02) (6)
	CreateDynamicObject(3585,1958.9399400,-1966.0699500,14.2000000,0.2500000,181.7450000,293.2230000); //object(lastran1_la02) (7)
	CreateDynamicObject(3585,1927.9000000,-1959.9000000,14.2000000,0.0000000,0.0000000,35.2410000); //object(lastran1_la02) (8)
	CreateDynamicObject(10838,1956.4000000,-2178.0000000,30.1000000,0.0000000,0.0000000,271.7500000); //object(airwelcomesign_sfse) (1)
	CreateDynamicObject(7666,1974.7000000,-2176.5000000,14.8000000,0.0000000,359.7500000,300.5000000); //object(vgswlcmsign2) (1)
	CreateDynamicObject(7666,1946.4000000,-2176.5000000,14.8000000,0.0000000,359.7470000,299.4980000); //object(vgswlcmsign2) (2)
	CreateDynamicObject(2729,2250.6001000,-1659.2000000,14.2670000,90.0000000,272.0000000,52.0000000); //object(cj_binc_post3) (1)
	CreateDynamicObject(2843,2249.3999000,-1664.7000000,14.5000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes02) (1)
	CreateDynamicObject(2843,2245.8000000,-1663.7000000,14.5000000,0.0000000,0.0000000,64.0000000); //object(gb_bedclothes02) (2)
	CreateDynamicObject(2843,2247.5000000,-1664.2000000,14.5000000,0.0000000,0.0000000,147.9950000); //object(gb_bedclothes02) (3)
	CreateDynamicObject(2704,2248.3999000,-1662.9000000,14.5000000,90.0000000,0.0000000,104.0000000); //object(cj_hoodie_3) (1)
	CreateDynamicObject(2704,2248.8000000,-1665.5000000,14.5000000,90.0000000,0.0000000,209.9970000); //object(cj_hoodie_3) (2)
	CreateDynamicObject(2844,2241.3999000,-1663.8000000,14.5000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes03) (1)
	CreateDynamicObject(2844,2248.0000000,-1659.9000000,14.3000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes03) (2)
	CreateDynamicObject(14863,2254.0559000,-1659.0580000,14.9000000,0.0000000,0.0000000,266.4960000); //object(clothes) (2)
	CreateDynamicObject(18070,2252.9004000,-1663.5996000,14.9500000,0.0000000,0.0000000,172.7490000); //object(gap_counter) (1)
	CreateDynamicObject(2622,2243.0000000,-1661.5000000,15.3000000,0.0000000,0.0000000,0.0000000); //object(cj_trainer_pro) (1)
	CreateDynamicObject(2622,2241.1006000,-1657.2002000,15.1000000,0.0000000,0.0000000,109.9950000); //object(cj_trainer_pro) (2)
	CreateDynamicObject(2652,2252.3000000,-1651.2000000,15.0000000,0.0000000,0.0000000,0.0000000); //object(cj_skate_cubes) (1)
	CreateDynamicObject(2753,2243.8999000,-1656.4000000,14.5000000,0.0000000,0.0000000,312.0000000); //object(cj_ff_till_que) (1)
	CreateDynamicObject(3798,2071.5610000,-1795.0300000,12.6000000,0.0000000,1.5000000,344.0000000); //object(acbox3_sfs) (5)
	CreateDynamicObject(1219,2071.3000000,-1799.9000000,14.0000000,0.0000000,273.2500000,359.0000000); //object(palette) (80)
	CreateDynamicObject(1219,2070.0000000,-1796.6000000,14.0000000,0.0000000,270.7460000,359.2450000); //object(palette) (81)
	CreateDynamicObject(1219,2071.3000000,-1790.2000000,14.0000000,0.0000000,270.7420000,180.2420000); //object(palette) (82)
	CreateDynamicObject(1219,2069.8000000,-1785.4000000,14.0000000,0.0000000,270.7360000,216.2420000); //object(palette) (83)
	CreateDynamicObject(1219,2068.2000000,-1776.5000000,14.0000000,0.0000000,269.7360000,359.7380000); //object(palette) (84)
	CreateDynamicObject(1219,2068.2000000,-1773.1000000,14.0000000,0.0000000,269.7310000,180.7360000); //object(palette) (85)
	CreateDynamicObject(1219,2068.2000000,-1770.4000000,14.0000000,0.0000000,269.7310000,357.4860000); //object(palette) (86)
	CreateDynamicObject(1219,2067.3999000,-1764.7000000,14.0000000,0.0000000,269.7310000,36.2340000); //object(palette) (87)
	CreateDynamicObject(1219,2066.5000000,-1763.5000000,14.0000000,0.0000000,269.7310000,36.2330000); //object(palette) (88)
	CreateDynamicObject(1219,2063.5000000,-1762.5000000,14.0000000,0.0000000,269.7310000,270.2330000); //object(palette) (89)
	CreateDynamicObject(1345,2070.7461000,-1780.1071000,13.3000000,0.0000000,0.0000000,0.0000000); //object(cj_dumpster) (1)
	CreateDynamicObject(1345,2069.7000000,-1781.5000000,13.3000000,0.0000000,0.0000000,12.0000000); //object(cj_dumpster) (2)
	CreateDynamicObject(1345,2069.3999000,-1778.6000000,13.3000000,0.0000000,0.0000000,351.9970000); //object(cj_dumpster) (3)
	CreateDynamicObject(1344,2069.7271000,-1780.0940000,14.7000000,0.0000000,1.2450000,88.9950000); //object(cj_dumpster2) (1)
	CreateDynamicObject(852,1958.5999800,-2140.0000000,12.3000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_4) (13)
	CreateDynamicObject(852,1955.6000000,-2062.3999000,12.5000000,0.0000000,0.0000000,98.0000000); //object(cj_urb_rub_4) (14)
	CreateDynamicObject(2355,2102.1001000,-1793.3000000,13.3500000,336.0000000,26.0000000,332.0000000); //object(pizza_healthy) (1)
	CreateDynamicObject(7390,1951.4000000,-1769.1000000,17.1000000,0.0000000,330.7500000,0.0000000); //object(vgngassign96) (1)
	CreateDynamicObject(10984,1953.2998000,-1769.7002000,12.5000000,0.0000000,0.0000000,274.4880000); //object(rubbled01_sfs) (5)
	CreateDynamicObject(14863,202.6000100,-97.5000000,1004.9000000,0.0000000,0.0000000,0.0000000); //object(clothes) (3)
	CreateDynamicObject(15028,209.3999900,-102.3000000,1004.4000000,0.0000000,0.0000000,0.0000000); //object(genmotel2sh_sv) (1)
	CreateDynamicObject(2411,207.8000000,-105.7000000,1004.2300000,89.0000000,270.0000000,269.0000000); //object(cj_f_torso_1) (1)
	CreateDynamicObject(2843,207.8000000,-105.3000000,1004.2000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes02) (4)
	CreateDynamicObject(2843,205.6000100,-107.0000000,1004.2000000,0.0000000,0.0000000,58.0000000); //object(gb_bedclothes02) (5)
	CreateDynamicObject(2843,208.1000100,-108.3000000,1004.2000000,0.0000000,0.0000000,95.9970000); //object(gb_bedclothes02) (6)
	CreateDynamicObject(2843,205.5000000,-105.5000000,1004.2000000,0.0000000,0.0000000,95.9930000); //object(gb_bedclothes02) (7)
	CreateDynamicObject(2843,204.8000000,-109.2000000,1004.2000000,0.0000000,0.0000000,107.9930000); //object(gb_bedclothes02) (8)
	CreateDynamicObject(2845,206.8999900,-104.3000000,1004.3000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes04) (2)
	CreateDynamicObject(2845,206.3999900,-98.9000000,1004.3000000,0.0000000,0.0000000,56.0000000); //object(gb_bedclothes04) (3)
	CreateDynamicObject(2845,204.1000100,-103.3000000,1004.3000000,0.0000000,0.0000000,139.9970000); //object(gb_bedclothes04) (4)
	CreateDynamicObject(2846,205.8000000,-104.5000000,1004.3000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes05) (1)
	CreateDynamicObject(2846,210.2000000,-102.5000000,1004.3000000,0.0000000,0.0000000,38.0000000); //object(gb_bedclothes05) (2)
	CreateDynamicObject(2846,217.1000100,-97.2000000,1004.3000000,0.0000000,0.0000000,37.9960000); //object(gb_bedclothes05) (3)
	CreateDynamicObject(2846,218.8999900,-98.5000000,1004.3000000,0.0000000,0.0000000,107.9960000); //object(gb_bedclothes05) (4)
	CreateDynamicObject(2675,211.7000000,-109.6000000,1004.2000000,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_6) (12)
	CreateDynamicObject(2675,213.7000000,-109.7000000,1004.2000000,0.0000000,0.0000000,66.0000000); //object(proc_rubbish_6) (13)
	CreateDynamicObject(2675,208.2000000,-109.3000000,1004.2000000,0.0000000,0.0000000,91.9950000); //object(proc_rubbish_6) (14)
	CreateDynamicObject(2675,203.0000000,-108.9000000,1004.2000000,0.0000000,0.0000000,137.9940000); //object(proc_rubbish_6) (15)
	CreateDynamicObject(2877,215.3000000,-98.9000000,1004.3000000,90.0000000,0.0000000,300.0000000); //object(cj_binco_door) (1)
	CreateDynamicObject(2384,208.5000000,-107.3000000,1004.2000000,0.0000000,0.0000000,0.0000000); //object(cj_8_jeans_dark) (1)
	CreateDynamicObject(2390,206.8000000,-107.0000000,1004.4000000,0.0000000,90.0000000,0.0000000); //object(cj_4way_clothes) (1)
	CreateDynamicObject(2371,208.8000000,-104.5000000,1004.7000000,0.0000000,92.0000000,227.9940000); //object(clothes_rail) (1)
	CreateDynamicObject(14809,2417.7000000,-1228.0000000,25.1000000,5.0000000,356.5000000,0.0000000); //object(strip2_platforms) (1)
	CreateDynamicObject(14836,2400.3000000,-1245.1000000,24.5000000,0.0000000,0.0000000,32.0000000); //object(lm_strippoles) (1)
	CreateDynamicObject(2725,2423.0000000,-1231.1000000,24.2000000,0.0000000,0.0000000,0.0000000); //object(lm_striptable) (1)
	CreateDynamicObject(5152,2075.5000000,-2267.2000000,13.6000000,0.0000000,344.0000000,0.0000000); //object(stuntramp1_las2) (1)
	CreateDynamicObject(13590,2154.8000000,-1178.7000000,24.1000000,0.0000000,357.7500000,3.0000000); //object(kickbus04) (1)
	CreateDynamicObject(16303,2060.1001000,-2282.2000000,9.0000000,0.0000000,0.0000000,10.2500000); //object(des_quarryramp01) (1)
	CreateDynamicObject(3594,1008.1000000,-1355.9000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (145)
	CreateDynamicObject(3594,1000.3000000,-1353.3000000,13.0000000,0.0000000,0.0000000,58.0000000); //object(la_fuckcar1) (146)
	CreateDynamicObject(3594,994.7000100,-1371.7000000,13.0000000,0.0000000,0.0000000,105.9970000); //object(la_fuckcar1) (147)
	CreateDynamicObject(3594,1022.5000000,-1352.9000000,13.0000000,0.0000000,0.0000000,105.9960000); //object(la_fuckcar1) (148)
	CreateDynamicObject(3594,998.5999800,-1320.6000000,13.0000000,0.0000000,0.0000000,135.9960000); //object(la_fuckcar1) (149)
	CreateDynamicObject(3594,1027.8000000,-1326.6000000,13.0000000,0.0000000,0.0000000,261.9940000); //object(la_fuckcar1) (150)
	CreateDynamicObject(3594,1056.8000000,-1328.1000000,13.0000000,0.0000000,0.0000000,261.9910000); //object(la_fuckcar1) (151)
	CreateDynamicObject(3594,1008.2000000,-1302.9000000,13.0000000,0.0000000,0.0000000,261.9910000); //object(la_fuckcar1) (152)
	CreateDynamicObject(3594,1009.3000000,-1310.7000000,13.0000000,0.0000000,22.0000000,349.4910000); //object(la_fuckcar1) (153)
	CreateDynamicObject(3594,953.9000200,-1321.3000000,13.0000000,0.0000000,0.0000000,45.9940000); //object(la_fuckcar1) (154)
	CreateDynamicObject(3594,933.4000200,-1317.4000000,13.0000000,0.0000000,354.0000000,325.9890000); //object(la_fuckcar1) (155)
	CreateDynamicObject(3594,915.7999900,-1342.1000000,13.0000000,0.0000000,353.9960000,325.9860000); //object(la_fuckcar1) (156)
	CreateDynamicObject(3594,915.5000000,-1321.5000000,13.0000000,0.0000000,359.2460000,233.9860000); //object(la_fuckcar1) (157)
	CreateDynamicObject(3594,941.0999800,-1308.5000000,13.0000000,0.0000000,2.2460000,295.9810000); //object(la_fuckcar1) (158)
	CreateDynamicObject(3594,908.7000100,-1323.9000000,13.0000000,0.0000000,183.2420000,245.9810000); //object(la_fuckcar1) (159)
	CreateDynamicObject(3594,880.5000000,-1332.9000000,13.0000000,0.0000000,359.2420000,357.9810000); //object(la_fuckcar1) (160)
	CreateDynamicObject(16002,1814.2000000,-1021.5000000,31.8000000,318.0000000,35.0000000,314.0000000); //object(drvin_sign) (1)
	CreateDynamicObject(898,1817.6000000,-1022.1000000,22.9000000,0.0000000,0.0000000,0.0000000); //object(searock02) (1)
	CreateDynamicObject(898,1812.8000000,-1020.3000000,24.5000000,0.0000000,0.0000000,88.0000000); //object(searock02) (2)
	CreateDynamicObject(898,1808.5000000,-1020.8000000,20.5000000,0.0000000,0.0000000,135.9950000); //object(searock02) (3)
	CreateDynamicObject(898,1811.1000000,-1012.6000000,20.5000000,0.0000000,0.0000000,135.9940000); //object(searock02) (4)
	CreateDynamicObject(898,1812.1000000,-1031.2000000,20.5000000,0.0000000,0.0000000,135.9940000); //object(searock02) (5)
	CreateDynamicObject(8558,1257.0000000,-2067.7000000,57.4000000,0.0000000,1.5000000,358.7500000); //object(vgshseing28) (1)
	CreateDynamicObject(8558,1256.9000000,-2072.8000000,57.4000000,0.0000000,1.5000000,358.7480000); //object(vgshseing28) (2)
	CreateDynamicObject(8558,1256.8000000,-2077.8999000,57.4000000,0.0000000,1.5000000,358.7480000); //object(vgshseing28) (3)
	CreateDynamicObject(900,1277.3000000,-2071.6001000,54.0000000,0.0000000,0.0000000,282.0000000); //object(searock04) (1)
	CreateDynamicObject(900,1278.0000000,-2080.8000000,54.0000000,0.0000000,0.0000000,281.9970000); //object(searock04) (2)
	CreateDynamicObject(900,1269.3000000,-2079.6001000,54.0000000,0.0000000,0.0000000,175.9970000); //object(searock04) (3)
	CreateDynamicObject(900,1258.9000000,-2078.6001000,54.0000000,0.0000000,0.0000000,175.9950000); //object(searock04) (4)
	CreateDynamicObject(900,1252.5000000,-2076.8999000,54.0000000,0.0000000,0.0000000,175.9950000); //object(searock04) (5)
	CreateDynamicObject(900,1248.7000000,-2077.0000000,54.2000000,0.0000000,0.0000000,175.9950000); //object(searock04) (6)
	CreateDynamicObject(900,1243.7000000,-2078.0000000,54.2000000,0.0000000,0.0000000,175.9950000); //object(searock04) (7)
	CreateDynamicObject(900,1238.0000000,-2078.6001000,54.6000000,0.0000000,0.0000000,175.9950000); //object(searock04) (8)
	CreateDynamicObject(900,1234.6000000,-2077.8000000,54.6000000,0.0000000,0.0000000,175.9950000); //object(searock04) (9)
	CreateDynamicObject(900,1233.7000000,-2077.0000000,54.6000000,0.0000000,0.0000000,231.9950000); //object(searock04) (10)
	CreateDynamicObject(900,1233.6000000,-2073.3000000,54.6000000,0.0000000,0.0000000,231.9930000); //object(searock04) (11)
	CreateDynamicObject(900,1233.6000000,-2075.0000000,54.6000000,0.0000000,0.0000000,231.9930000); //object(searock04) (12)
	CreateDynamicObject(900,1233.7000000,-2069.0000000,54.6000000,0.0000000,0.0000000,231.9930000); //object(searock04) (13)
	CreateDynamicObject(900,1236.1000000,-2067.3999000,54.5000000,0.0000000,0.0000000,231.9930000); //object(searock04) (14)
	CreateDynamicObject(12957,1929.6000000,-1775.8000000,13.9000000,345.0000000,13.5000000,270.0000000); //object(sw_pickupwreck01) (6)
	CreateDynamicObject(10984,1929.2000000,-1776.5000000,6.1000000,89.7500000,90.0000000,359.9880000); //object(rubbled01_sfs) (6)
	CreateDynamicObject(12957,1926.6000000,-1771.3000000,13.9000000,15.2890000,187.2880000,122.5130000); //object(sw_pickupwreck01) (7)
	CreateDynamicObject(17017,1490.2002000,-1295.2002000,48.5000000,0.0000000,291.9950000,71.9990000); //object(cuntwplant10) (1)
	CreateDynamicObject(9900,1447.7000000,-1289.4000000,74.5000000,0.0000000,300.0000000,116.7500000); //object(landshit_09_sfe) (1)
	CreateDynamicObject(10985,1382.7000000,-1230.5000000,13.5999800,0.0000000,0.0000000,0.0000000); //object(rubbled02_sfs) (1)
	CreateDynamicObject(10985,1387.0000000,-1240.8994100,13.6000000,0.0000000,0.0000000,41.9950000); //object(rubbled02_sfs) (2)
	CreateDynamicObject(10985,1398.4000000,-1230.8000000,13.6000000,0.0000000,0.0000000,41.9950000); //object(rubbled02_sfs) (3)
	CreateDynamicObject(10985,1401.6000000,-1245.8000000,13.6000000,0.0000000,0.0000000,87.9950000); //object(rubbled02_sfs) (4)
	CreateDynamicObject(10984,1374.1000000,-1243.4000000,13.7000000,0.0000000,0.5000000,190.0000000); //object(rubbled01_sfs) (7)
	CreateDynamicObject(10984,1374.3000000,-1230.9000000,13.4000000,0.0000000,0.0000000,189.9980000); //object(rubbled01_sfs) (8)
	CreateDynamicObject(10984,1462.9000000,-1342.9000000,100.8000000,0.0000000,91.2470000,176.7430000); //object(rubbled01_sfs) (13)
	CreateDynamicObject(10985,1487.5000000,-1360.2998000,121.9000000,0.0000000,270.2470000,182.9990000); //object(rubbled02_sfs) (5)
	CreateDynamicObject(10985,1475.2998000,-1380.7002000,62.1000000,0.0000000,0.0000000,0.0000000); //object(rubbled02_sfs) (6)
	CreateDynamicObject(10985,1391.4000000,-1231.3000000,18.2000000,0.0000000,91.5000000,268.0000000); //object(rubbled02_sfs) (7)
	CreateDynamicObject(10985,1387.1000000,-1237.4000000,18.2000000,0.0000000,83.7500000,260.9950000); //object(rubbled02_sfs) (8)
	CreateDynamicObject(10985,1376.5000000,-1232.1000000,18.2000000,0.0000000,91.5000000,232.9920000); //object(rubbled02_sfs) (9)
	CreateDynamicObject(10985,1403.5000000,-1237.6000000,18.2000000,0.0000000,91.5000000,287.2410000); //object(rubbled02_sfs) (10)
	CreateDynamicObject(10985,1415.9000000,-1231.5000000,18.2000000,0.0000000,91.5000000,305.2380000); //object(rubbled02_sfs) (11)
	CreateDynamicObject(10985,1395.2000000,-1250.7000000,13.6000000,0.0000000,0.0000000,87.9950000); //object(rubbled02_sfs) (12)
	CreateDynamicObject(10985,1410.4000000,-1249.7000000,13.6000000,0.0000000,0.0000000,87.9950000); //object(rubbled02_sfs) (13)
	CreateDynamicObject(10985,1409.7000000,-1238.5000000,13.6000000,0.0000000,0.0000000,153.9950000); //object(rubbled02_sfs) (14)
	CreateDynamicObject(10985,1423.5000000,-1231.5000000,13.6000000,0.0000000,0.0000000,153.9900000); //object(rubbled02_sfs) (15)
	CreateDynamicObject(10985,1424.4000000,-1245.0000000,13.6000000,0.0000000,0.0000000,153.9900000); //object(rubbled02_sfs) (16)
	CreateDynamicObject(10985,1434.6000000,-1235.2000000,13.6000000,0.0000000,0.0000000,153.9900000); //object(rubbled02_sfs) (17)
	CreateDynamicObject(10985,1439.6000000,-1248.4000000,13.6000000,0.0000000,355.7500000,154.9900000); //object(rubbled02_sfs) (18)
	CreateDynamicObject(10985,1439.2000000,-1241.2000000,13.6000000,0.0000000,352.4980000,224.9900000); //object(rubbled02_sfs) (19)
	CreateDynamicObject(10985,1442.4000000,-1230.3000000,13.6000000,0.0000000,357.4960000,222.2390000); //object(rubbled02_sfs) (20)
	CreateDynamicObject(10985,1375.0000000,-1231.8000000,29.2000000,0.0000000,90.0000000,239.2370000); //object(rubbled02_sfs) (21)
	CreateDynamicObject(10985,1381.0996100,-1233.7998000,29.2000000,0.0000000,81.7440000,254.2290000); //object(rubbled02_sfs) (22)
	CreateDynamicObject(10985,1391.2000000,-1236.2000000,29.2000000,0.0000000,81.7440000,258.2290000); //object(rubbled02_sfs) (23)
	CreateDynamicObject(10985,1390.8000000,-1236.5000000,41.2000000,0.0000000,76.7440000,258.2280000); //object(rubbled02_sfs) (24)
	CreateDynamicObject(10985,1390.5920400,-1238.7500000,29.2000000,0.0000000,89.7420000,253.7230000); //object(rubbled02_sfs) (25)
	CreateDynamicObject(10985,1384.2000000,-1232.8000000,51.2000000,0.0000000,89.2400000,268.2280000); //object(rubbled02_sfs) (26)
	CreateDynamicObject(10985,1379.4000000,-1230.7000000,41.2000000,0.0000000,76.7340000,224.9750000); //object(rubbled02_sfs) (27)
	CreateDynamicObject(10985,1383.0996000,-1235.2998000,41.2000000,0.0000000,76.7340000,249.2250000); //object(rubbled02_sfs) (28)
	CreateDynamicObject(10985,1379.3000000,-1232.9000000,51.2000000,0.0000000,89.2360000,268.2260000); //object(rubbled02_sfs) (29)
	CreateDynamicObject(10985,1395.0000000,-1233.3000000,51.2000000,0.0000000,89.2360000,268.2260000); //object(rubbled02_sfs) (30)
	CreateDynamicObject(10985,1431.6000000,-1232.1000000,21.2000000,0.0000000,89.2360000,268.2260000); //object(rubbled02_sfs) (31)
	CreateDynamicObject(10985,1431.5996000,-1232.0996000,51.2000000,0.0000000,89.2360000,268.2260000); //object(rubbled02_sfs) (32)
	CreateDynamicObject(10985,1433.4000000,-1232.7000000,41.2000000,0.0000000,89.2310000,279.4760000); //object(rubbled02_sfs) (33)
	CreateDynamicObject(10985,1431.5996000,-1232.0996000,31.2000000,0.0000000,89.2360000,268.2260000); //object(rubbled02_sfs) (34)
	CreateDynamicObject(10985,1425.1000000,-1230.5000000,21.2000000,0.0000000,89.2360000,262.4760000); //object(rubbled02_sfs) (36)
	CreateDynamicObject(10985,1424.2000000,-1230.2000000,21.2000000,0.0000000,89.2310000,286.4740000); //object(rubbled02_sfs) (37)
	CreateDynamicObject(901,1439.2000000,-1224.2000000,17.3000000,0.0000000,0.0000000,66.0000000); //object(searock05) (1)
	CreateDynamicObject(897,1441.5000000,-1228.5000000,28.0000000,41.3950000,28.1820000,66.9910000); //object(searock01) (1)
	CreateDynamicObject(3799,1419.7000000,-1258.1000000,12.1000000,0.0000000,0.0000000,43.7500000); //object(acbox2_sfs) (3)
	CreateDynamicObject(3761,1432.6000000,-1334.0000000,14.6000000,0.0000000,0.0000000,270.0000000); //object(industshelves) (2)
	CreateDynamicObject(5154,890.4000200,-1285.7000000,20.8000000,0.0000000,0.0000000,2.2500000); //object(dk_cargoshp03d) (1)
	CreateDynamicObject(897,1440.2002000,-1227.5996000,24.0000000,0.0000000,0.0000000,86.4950000); //object(searock01) (2)
	CreateDynamicObject(10985,1405.2000000,-1232.6000000,51.2000000,0.0000000,92.4860000,266.2260000); //object(rubbled02_sfs) (38)
	CreateDynamicObject(10985,1414.7000000,-1233.0000000,51.2000000,0.0000000,92.4830000,266.2210000); //object(rubbled02_sfs) (39)
	CreateDynamicObject(10985,1420.5000000,-1232.9000000,51.2000000,0.0000000,92.7330000,265.4710000); //object(rubbled02_sfs) (40)
	CreateDynamicObject(10985,1429.8000000,-1232.7000000,51.2000000,0.0000000,92.7300000,265.4680000); //object(rubbled02_sfs) (41)
	CreateDynamicObject(10985,1443.4000000,-1259.9000000,13.6000000,0.0000000,355.7480000,228.9900000); //object(rubbled02_sfs) (42)
	CreateDynamicObject(10985,1447.5000000,-1263.4004000,13.6000000,0.0000000,355.7430000,194.9830000); //object(rubbled02_sfs) (43)
	CreateDynamicObject(10985,1446.5000000,-1256.0000000,13.6000000,0.0000000,0.7440000,266.9830000); //object(rubbled02_sfs) (44)
	CreateDynamicObject(18257,1430.5000000,-1313.9000000,12.6000000,0.0000000,0.0000000,0.0000000); //object(crates) (3)
	CreateDynamicObject(2933,1404.5000000,-1447.4000000,9.4000000,0.0000000,0.0000000,311.7500000); //object(pol_comp_gate) (1)
	CreateDynamicObject(10984,1463.1000000,-1341.5000000,100.8000000,0.0000000,91.2470000,179.4930000); //object(rubbled01_sfs) (16)
	CreateDynamicObject(10984,1462.5000000,-1340.0000000,90.8000000,0.0000000,91.2470000,179.4840000); //object(rubbled01_sfs) (19)
	CreateDynamicObject(10984,1473.7000000,-1330.3000000,87.8000000,0.0000000,89.4970000,91.4890000); //object(rubbled01_sfs) (22)
	CreateDynamicObject(10984,1473.7002000,-1330.2998000,96.8000000,0.0000000,89.4950000,91.4890000); //object(rubbled01_sfs) (23)
	CreateDynamicObject(10984,1474.4000000,-1330.5000000,103.8000000,0.0000000,88.2450000,86.7390000); //object(rubbled01_sfs) (24)
	CreateDynamicObject(10984,1474.4000000,-1330.7000000,103.8000000,0.0000000,89.4950000,90.7390000); //object(rubbled01_sfs) (25)
	CreateDynamicObject(10986,1471.9000000,-1330.0000000,110.6000000,0.0000000,270.0000000,268.2500000); //object(rubbled03_sfs) (1)
	CreateDynamicObject(10986,1470.4000000,-1330.4000000,110.6000000,9.0000000,269.7500000,264.9980000); //object(rubbled03_sfs) (2)
	CreateDynamicObject(10984,1462.9000000,-1341.6000000,112.8000000,0.0000000,91.2470000,176.7430000); //object(rubbled01_sfs) (26)
	CreateDynamicObject(10984,1462.5000000,-1341.5000000,116.8000000,0.0000000,88.0000000,182.0000000); //object(rubbled01_sfs) (27)
	CreateDynamicObject(10984,1461.7998000,-1342.4004000,112.8000000,0.0000000,269.9950000,356.7430000); //object(rubbled01_sfs) (28)
	CreateDynamicObject(10984,1462.6000000,-1340.3000000,105.9000000,3.2010000,274.5820000,355.3280000); //object(rubbled01_sfs) (29)
	CreateDynamicObject(10984,1462.6000000,-1340.8000000,105.9000000,359.0900000,91.2990000,180.4720000); //object(rubbled01_sfs) (30)
	CreateDynamicObject(10984,1467.8000000,-1337.4000000,105.9000000,357.9440000,92.9390000,150.7600000); //object(rubbled01_sfs) (31)
	CreateDynamicObject(896,1404.4000000,-1177.9000000,30.0000000,0.0000000,0.0000000,0.0000000); //object(searock06) (1)
	CreateDynamicObject(896,1408.2000000,-1178.8000000,30.0000000,0.0000000,325.0000000,34.0000000); //object(searock06) (2)
	CreateDynamicObject(896,1406.8000000,-1170.5000000,30.0000000,0.0000000,254.2480000,342.4970000); //object(searock06) (3)
	CreateDynamicObject(896,1411.2000000,-1172.2000000,30.0000000,0.0000000,254.2460000,264.4930000); //object(searock06) (4)
	CreateDynamicObject(10984,1474.0000000,-1331.3000000,64.5000000,0.0000000,272.5000000,275.7500000); //object(rubbled01_sfs) (32)
	CreateDynamicObject(10984,1491.5996000,-1286.2998000,45.6000000,0.0000000,273.9990000,90.2470000); //object(rubbled01_sfs) (33)
	CreateDynamicObject(10984,1491.1000000,-1365.9000000,23.8800000,0.0000000,0.0000000,0.0000000); //object(rubbled01_sfs) (34)
	CreateDynamicObject(10985,1487.5000000,-1351.2000000,121.9000000,0.0000000,270.7470000,185.2490000); //object(rubbled02_sfs) (45)
	CreateDynamicObject(944,2342.6001000,-1241.8000000,22.4000000,0.0000000,0.0000000,76.0000000); //object(packing_carates04) (1)
	CreateDynamicObject(942,2345.7000000,-1269.9000000,22.7000000,90.0000000,359.2570000,207.9930000); //object(cj_df_unit_2) (1)
	CreateDynamicObject(16446,1092.6000000,-1763.7000000,25.6000000,0.0000000,0.0000000,4.2500000); //object(quarry_weecrushr) (2)
	CreateDynamicObject(16446,1092.5996000,-1763.7002000,16.1000000,0.0000000,179.5000000,1.0000000); //object(quarry_weecrushr) (3)
	CreateDynamicObject(3865,1408.1000000,-1303.4000000,10.3000000,0.0000000,0.0000000,0.0000000); //object(concpipe_sfxrf) (4)
	CreateDynamicObject(3865,1412.7000000,-1303.7000000,10.3000000,0.0000000,0.0000000,0.0000000); //object(concpipe_sfxrf) (5)
	CreateDynamicObject(3865,1418.4000000,-1318.9000000,10.2000000,0.0000000,0.0000000,272.2500000); //object(concpipe_sfxrf) (6)
	CreateDynamicObject(3865,1402.4510000,-1315.0240000,10.2000000,0.0000000,251.9990000,88.2420000); //object(concpipe_sfxrf) (7)
	CreateDynamicObject(10985,1475.3000000,-1371.4000000,124.7000000,0.0000000,274.0000000,87.0000000); //object(rubbled02_sfs) (35)
	CreateDynamicObject(10985,1475.2998000,-1371.4004000,132.7000000,0.0000000,273.9940000,86.9900000); //object(rubbled02_sfs) (46)
	CreateDynamicObject(10985,1487.3000000,-1361.6000000,121.9000000,0.0000000,268.7470000,181.2490000); //object(rubbled02_sfs) (47)
	CreateDynamicObject(16349,1422.1000000,-1340.6000000,15.8000000,0.0000000,0.0000000,0.0000000); //object(dam_genturbine01) (1)
	CreateDynamicObject(854,1415.3000000,-1318.3000000,8.9000000,0.0000000,295.2500000,0.0000000); //object(cj_urb_rub_3b) (59)
	CreateDynamicObject(854,1415.9000000,-1319.8000000,10.7000000,0.0000000,299.7470000,1.2500000); //object(cj_urb_rub_3b) (60)
	CreateDynamicObject(854,1415.8000000,-1317.8000000,10.1000000,0.0000000,295.2470000,355.7470000); //object(cj_urb_rub_3b) (61)
	CreateDynamicObject(854,1415.7998000,-1317.7998000,10.1000000,0.0000000,295.2470000,355.7430000); //object(cj_urb_rub_3b) (62)
	CreateDynamicObject(854,1415.7002000,-1318.5996000,10.1000000,0.0000000,295.2470000,0.0000000); //object(cj_urb_rub_3b) (63)
	CreateDynamicObject(854,1415.3000000,-1319.3000000,8.9000000,0.0000000,295.2470000,0.0000000); //object(cj_urb_rub_3b) (64)
	CreateDynamicObject(854,1415.4000000,-1319.9000000,8.9000000,0.0000000,295.2470000,0.0000000); //object(cj_urb_rub_3b) (65)
	CreateDynamicObject(854,1415.7002000,-1319.7998000,10.1000000,0.0000000,295.2470000,1.2470000); //object(cj_urb_rub_3b) (66)
	CreateDynamicObject(854,1415.9000000,-1318.4000000,10.7000000,0.0000000,295.2470000,1.2470000); //object(cj_urb_rub_3b) (67)
	CreateDynamicObject(854,1415.9000000,-1319.4000000,10.7000000,0.0000000,299.7450000,1.2470000); //object(cj_urb_rub_3b) (68)
	CreateDynamicObject(854,1415.9000000,-1318.8000000,10.7000000,0.0000000,295.2470000,1.2470000); //object(cj_urb_rub_3b) (69)
	CreateDynamicObject(851,1404.7000000,-1315.1000000,9.7000000,0.0000000,63.2500000,356.2500000); //object(cj_urb_rub_2) (3)
	CreateDynamicObject(849,1404.2000000,-1314.6000000,10.6000000,0.0000000,66.0000000,0.0000000); //object(cj_urb_rub_3) (3)
	CreateDynamicObject(854,1404.2000000,-1315.5000000,10.5000000,0.0000000,60.0000000,0.0000000); //object(cj_urb_rub_3b) (70)
	CreateDynamicObject(854,1404.6000000,-1315.0000000,9.8000000,0.0000000,59.9960000,0.7500000); //object(cj_urb_rub_3b) (71)
	CreateDynamicObject(854,1404.2000000,-1314.4000000,10.3000000,0.0000000,55.9960000,358.4970000); //object(cj_urb_rub_3b) (72)
	CreateDynamicObject(854,1404.5000000,-1315.4000000,9.7000000,0.0000000,59.9960000,8.0000000); //object(cj_urb_rub_3b) (73)
	CreateDynamicObject(854,1404.0000000,-1314.0000000,10.7000000,0.0000000,59.9960000,7.9980000); //object(cj_urb_rub_3b) (74)
	CreateDynamicObject(854,1404.0000000,-1315.5000000,10.8000000,2.3360000,74.1630000,359.0730000); //object(cj_urb_rub_3b) (75)
	CreateDynamicObject(854,1403.8000000,-1314.8000000,11.0000000,0.8850000,84.0620000,358.7930000); //object(cj_urb_rub_3b) (76)
	CreateDynamicObject(3015,221.5000000,72.5000000,1004.1000000,0.0000000,0.0000000,0.0000000); //object(cr_cratestack) (1)
	CreateDynamicObject(942,267.2999900,91.0000000,1002.5000000,0.0000000,0.0000000,343.0000000); //object(cj_df_unit_2) (2)
	CreateDynamicObject(2846,255.0000000,74.2000000,1002.6000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes05) (5)
	CreateDynamicObject(2846,254.7000000,75.1000000,1002.6000000,0.9980000,355.9990000,52.8200000); //object(gb_bedclothes05) (6)
	CreateDynamicObject(2846,257.0000000,79.5000000,1002.6000000,0.9940000,355.9950000,52.8170000); //object(gb_bedclothes05) (7)
	CreateDynamicObject(1509,254.3000000,73.1000000,1003.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_3) (1)
	CreateDynamicObject(1518,235.6000100,80.5000000,1005.2000000,0.0000000,0.0000000,0.0000000); //object(dyn_tv_2) (1)
	CreateDynamicObject(931,218.1000100,66.7000000,1005.1000000,0.0000000,0.0000000,179.0000000); //object(rack3) (2)
	CreateDynamicObject(931,220.7000000,66.7000000,1005.1000000,0.0000000,0.0000000,179.0000000); //object(rack3) (3)
	CreateDynamicObject(3014,220.6000100,66.9000000,1004.3000000,0.0000000,0.0000000,0.0000000); //object(cr_guncrate) (2)
	CreateDynamicObject(2973,216.1000100,81.2000000,1004.1000000,0.0000000,1.0000000,38.0000000); //object(k_cargo2) (1)
	CreateDynamicObject(925,217.8999900,75.5000000,1005.1000000,0.0000000,0.0000000,140.2500000); //object(rack2) (2)
	CreateDynamicObject(964,217.7000000,72.1000000,1004.0000000,0.0000000,0.0000000,0.0000000); //object(cj_metal_crate) (3)
	CreateDynamicObject(964,219.2000000,72.0000000,1004.0000000,0.0000000,0.0000000,0.0000000); //object(cj_metal_crate) (4)
	CreateDynamicObject(964,220.8000000,71.0000000,1004.0000000,0.0000000,0.0000000,330.0000000); //object(cj_metal_crate) (5)
	CreateDynamicObject(2041,220.5000000,70.9000000,1005.2000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_m2) (1)
	CreateDynamicObject(2041,219.6000100,71.6000000,1005.2000000,0.0000000,0.0000000,310.0000000); //object(ammo_box_m2) (2)
	CreateDynamicObject(2041,217.8999900,71.9000000,1005.2000000,0.0000000,0.0000000,11.9960000); //object(ammo_box_m2) (3)
	CreateDynamicObject(2359,219.3999900,71.1000000,1004.2000000,0.0000000,0.0000000,0.0000000); //object(ammo_box_c5) (2)
	CreateDynamicObject(2359,217.3999900,69.5000000,1004.2000000,0.0000000,0.0000000,128.0000000); //object(ammo_box_c5) (3)
	CreateDynamicObject(1219,250.7000000,67.7000000,1004.4000000,0.0000000,270.0000000,0.7500000); //object(palette) (90)
	CreateDynamicObject(1219,250.8000000,70.1000000,1004.4000000,0.0000000,270.0000000,179.2470000); //object(palette) (91)
	CreateDynamicObject(1448,250.6000100,65.9000000,1004.4000000,88.6970000,0.0000000,268.3030000); //object(dyn_crate_1) (5)
	CreateDynamicObject(3260,250.5000000,63.3000000,1003.5000000,0.0000000,0.0000000,90.7500000); //object(oldwoodpanel) (13)
	CreateDynamicObject(2375,159.1000100,-82.7000000,1001.4000000,88.8820000,153.4330000,208.0620000); //object(shop_set_2_unit1) (1)
	CreateDynamicObject(1514,165.7000000,-86.6000000,1001.1000000,0.0000000,0.0000000,42.0000000); //object(dyn_ff_till) (1)
	CreateDynamicObject(1550,163.2000000,-80.9000000,1001.2000000,0.0000000,0.0000000,0.0000000); //object(cj_money_bag) (2)
	CreateDynamicObject(1550,161.8999900,-80.3000000,1001.2000000,0.0000000,0.0000000,60.0000000); //object(cj_money_bag) (3)
	CreateDynamicObject(1550,162.8999900,-79.6000000,1001.2000000,0.0000000,0.0000000,137.9960000); //object(cj_money_bag) (4)
	CreateDynamicObject(1550,160.2000000,-80.9000000,1001.2000000,0.0000000,0.0000000,137.9940000); //object(cj_money_bag) (5)
	CreateDynamicObject(1514,160.8000000,-84.6000000,1001.4000000,0.0000000,0.0000000,41.9950000); //object(dyn_ff_till) (2)
	CreateDynamicObject(2379,168.7000000,-82.2000000,1002.3000000,271.3460000,21.8030000,69.7980000); //object(shop_set_2_unit3) (1)
	CreateDynamicObject(1219,2376.2000000,-1125.5000000,1052.0000000,0.0000000,90.0000000,180.7500000); //object(palette) (93)
	CreateDynamicObject(1219,2373.0000000,-1120.5000000,1052.0000000,0.0000000,90.0000000,266.7430000); //object(palette) (95)
	CreateDynamicObject(1448,2375.2000000,-1132.7000000,1052.2000000,0.0000000,91.5000000,0.0000000); //object(dyn_crate_1) (6)
	CreateDynamicObject(1448,2375.2000000,-1133.7000000,1052.2000000,0.0000000,91.5000000,0.0000000); //object(dyn_crate_1) (7)
	CreateDynamicObject(1448,2375.2000000,-1133.7000000,1051.1000000,0.0000000,91.5000000,0.0000000); //object(dyn_crate_1) (8)
	CreateDynamicObject(1448,2375.2000000,-1132.7000000,1051.1000000,0.0000000,91.5000000,0.0000000); //object(dyn_crate_1) (9)
	CreateDynamicObject(1448,2363.7000000,-1119.2000000,1051.7000000,0.0000000,269.7500000,272.0000000); //object(dyn_crate_1) (10)
	CreateDynamicObject(1448,2364.8000000,-1119.2000000,1051.7000000,0.0000000,269.4970000,268.4980000); //object(dyn_crate_1) (11)
	CreateDynamicObject(2926,479.7000100,-9.0000000,1001.5000000,0.0000000,0.0000000,62.0000000); //object(dyno_box_a) (1)
	CreateDynamicObject(2925,482.2999900,-12.6000000,1000.3000000,0.0000000,180.0000000,326.7500000); //object(dyno_box_b) (1)
	CreateDynamicObject(5299,1594.3000000,-2338.2000000,22.7000000,0.0000000,0.0000000,0.0000000); //object(las2_brigtower) (1)
	CreateDynamicObject(3594,1486.1000000,-2378.8000000,13.0000000,0.0000000,0.0000000,50.0000000); //object(la_fuckcar1) (161)
	CreateDynamicObject(3594,1475.6000000,-2358.5000000,13.0000000,0.0000000,0.0000000,141.9990000); //object(la_fuckcar1) (162)
	CreateDynamicObject(3594,1470.5000000,-2333.1001000,13.0000000,0.0000000,0.0000000,117.9980000); //object(la_fuckcar1) (163)
	CreateDynamicObject(3594,1501.5000000,-2328.8000000,13.0000000,0.0000000,0.0000000,161.9930000); //object(la_fuckcar1) (164)
	CreateDynamicObject(3594,1495.5000000,-2313.6001000,13.0000000,0.0000000,0.0000000,161.9880000); //object(la_fuckcar1) (165)
	CreateDynamicObject(3594,1428.8000000,-2318.3000000,13.0000000,0.0000000,0.0000000,161.9880000); //object(la_fuckcar1) (166)
	CreateDynamicObject(3594,1453.3000000,-2331.2000000,13.0000000,0.0000000,0.0000000,161.9880000); //object(la_fuckcar1) (167)
	CreateDynamicObject(3594,1461.6000000,-2380.3999000,13.0000000,0.0000000,0.0000000,235.9880000); //object(la_fuckcar1) (168)
	CreateDynamicObject(3594,1512.4000000,-2364.5000000,13.0000000,0.0000000,0.0000000,235.9860000); //object(la_fuckcar1) (169)
	CreateDynamicObject(3594,1534.0000000,-2322.8999000,13.0000000,0.0000000,0.0000000,235.9860000); //object(la_fuckcar1) (170)
	CreateDynamicObject(3594,1532.5000000,-2288.7000000,13.0000000,0.0000000,0.0000000,235.9860000); //object(la_fuckcar1) (171)
	CreateDynamicObject(3594,1522.1000000,-2281.5000000,13.0000000,0.0000000,0.0000000,235.9860000); //object(la_fuckcar1) (172)
	CreateDynamicObject(3594,1515.7000000,-2307.7000000,13.0000000,0.0000000,2.0000000,161.9860000); //object(la_fuckcar1) (173)
	CreateDynamicObject(3594,1481.8000000,-2333.0000000,13.0000000,0.0000000,2.0000000,161.9820000); //object(la_fuckcar1) (174)
	CreateDynamicObject(3594,1461.7000000,-2331.2000000,13.0000000,0.0000000,358.5000000,95.9820000); //object(la_fuckcar1) (175)
	CreateDynamicObject(3594,1475.4000000,-2350.0000000,13.0000000,0.0000000,358.4950000,151.9820000); //object(la_fuckcar1) (176)
	CreateDynamicObject(3594,1474.2000000,-2340.7000000,13.0000000,0.0000000,358.4950000,113.9790000); //object(la_fuckcar1) (177)
	CreateDynamicObject(3594,1448.9000000,-2359.1001000,13.0000000,0.0000000,358.4950000,113.9780000); //object(la_fuckcar1) (178)
	CreateDynamicObject(3594,1468.4000000,-2377.5000000,13.0000000,0.0000000,358.4950000,151.9780000); //object(la_fuckcar1) (179)
	CreateDynamicObject(3594,1466.5000000,-2368.1001000,13.0000000,0.0000000,358.4950000,95.9740000); //object(la_fuckcar1) (180)
	CreateDynamicObject(3594,1499.5000000,-2344.1001000,13.0000000,0.0000000,358.4950000,123.9710000); //object(la_fuckcar1) (181)
	CreateDynamicObject(3594,1526.7000000,-2381.5000000,13.0000000,0.0000000,358.4950000,123.9700000); //object(la_fuckcar1) (182)
	CreateDynamicObject(3594,1517.7000000,-2381.8999000,13.0000000,0.0000000,0.4950000,59.9700000); //object(la_fuckcar1) (183)
	CreateDynamicObject(3594,1503.8000000,-2373.3000000,13.0000000,0.0000000,0.4940000,357.9690000); //object(la_fuckcar1) (184)
	CreateDynamicObject(3594,1427.2000000,-2299.8000000,13.0000000,0.0000000,0.4940000,35.9680000); //object(la_fuckcar1) (185)
	CreateDynamicObject(3594,1409.9000000,-2275.8999000,13.0000000,0.0000000,0.4940000,35.9640000); //object(la_fuckcar1) (186)
	CreateDynamicObject(3594,1436.6000000,-2256.5000000,13.0000000,0.0000000,0.4940000,95.9640000); //object(la_fuckcar1) (187)
	CreateDynamicObject(3594,1413.9000000,-2295.3000000,13.0000000,0.0000000,0.4940000,149.9600000); //object(la_fuckcar1) (188)
	CreateDynamicObject(3594,1429.1000000,-2284.2000000,13.0000000,0.0000000,0.4940000,213.9580000); //object(la_fuckcar1) (189)
	CreateDynamicObject(3594,1454.8000000,-2239.5000000,13.0000000,0.0000000,0.4940000,247.9530000); //object(la_fuckcar1) (190)
	CreateDynamicObject(3594,1474.2000000,-2233.3999000,13.0000000,0.0000000,0.4940000,203.9500000); //object(la_fuckcar1) (191)
	CreateDynamicObject(3594,1465.5000000,-2239.7000000,13.0000000,0.0000000,0.4940000,125.9500000); //object(la_fuckcar1) (192)
	CreateDynamicObject(3594,1488.6000000,-2222.8999000,13.0000000,0.0000000,0.4940000,125.9470000); //object(la_fuckcar1) (193)
	CreateDynamicObject(3594,1515.2000000,-2254.8999000,13.0000000,0.0000000,0.4940000,67.9470000); //object(la_fuckcar1) (194)
	CreateDynamicObject(3594,1517.0000000,-2270.1001000,13.0000000,0.0000000,0.4940000,23.9450000); //object(la_fuckcar1) (195)
	CreateDynamicObject(3594,1498.9000000,-2245.3999000,13.0000000,0.0000000,0.4940000,61.9450000); //object(la_fuckcar1) (196)
	CreateDynamicObject(3594,1552.7000000,-2283.7000000,13.0000000,0.0000000,0.4940000,7.9410000); //object(la_fuckcar1) (197)
	CreateDynamicObject(3594,1573.7000000,-2307.1001000,13.0000000,0.0000000,0.4940000,7.9380000); //object(la_fuckcar1) (198)
	CreateDynamicObject(3594,1584.1000000,-2310.1001000,13.0000000,0.0000000,0.4940000,87.9380000); //object(la_fuckcar1) (199)
	CreateDynamicObject(3594,1556.2000000,-2290.1001000,13.0000000,0.0000000,0.4940000,135.9350000); //object(la_fuckcar1) (200)
	CreateDynamicObject(3594,1535.4000000,-2305.0000000,13.0000000,0.0000000,0.4940000,103.9340000); //object(la_fuckcar1) (201)
	CreateDynamicObject(3594,1585.0000000,-2255.8999000,13.0000000,0.0000000,358.4940000,121.9310000); //object(la_fuckcar1) (202)
	CreateDynamicObject(3594,1554.3000000,-2250.8000000,13.0000000,0.0000000,358.4890000,121.9260000); //object(la_fuckcar1) (203)
	CreateDynamicObject(3594,1538.0000000,-2263.1001000,13.0000000,0.0000000,4.9890000,177.9260000); //object(la_fuckcar1) (204)
	CreateDynamicObject(3594,1569.6000000,-2197.5000000,13.0000000,0.0000000,1.9880000,117.9240000); //object(la_fuckcar1) (205)
	CreateDynamicObject(3594,1517.9000000,-2191.3000000,13.0000000,0.0000000,358.2330000,107.9220000); //object(la_fuckcar1) (206)
	CreateDynamicObject(3798,2072.6130000,-1792.9170000,12.6000000,0.0000000,1.5000000,3.9980000); //object(acbox3_sfs) (6)
	CreateDynamicObject(3578,2109.8611000,-1809.8550000,13.3330000,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (3)
	CreateDynamicObject(3578,2109.8611000,-1809.8540000,14.8580000,0.0000000,180.0000000,0.0000000); //object(dockbarr1_la) (4)
	CreateDynamicObject(1421,1366.7480000,-1275.0190000,13.3090000,0.0000000,0.0000000,0.0000000); //object(dyn_boxes) (1)
	CreateDynamicObject(1817,1367.8280000,-1274.6290000,14.8110000,359.2340000,40.0040000,173.8930000); //object(coffee_med_2) (1)
	CreateDynamicObject(3572,1193.4740000,-919.7840000,43.5000000,0.0000000,0.0000000,277.4950000); //object(lasdkrt4) (2)
	CreateDynamicObject(3577,998.5739700,-916.5700100,41.9620000,0.0000000,0.0000000,0.0000000); //object(dockcrates1_la) (4)
	CreateDynamicObject(3577,998.5739700,-916.5700100,43.4370000,0.2500000,0.0000000,0.0000000); //object(dockcrates1_la) (5)
	CreateDynamicObject(3800,997.6359900,-918.7789900,43.2000000,0.0000000,0.0000000,0.0000000); //object(acbox4_sfs) (8)
	CreateDynamicObject(3800,998.7780200,-919.4940200,43.9250000,26.0000000,0.0000000,254.2500000); //object(acbox4_sfs) (9)
	CreateDynamicObject(1271,998.6749900,-918.4439700,44.3970000,355.4430000,34.1230000,315.8320000); //object(gunbox) (1)
	CreateDynamicObject(1437,1441.6789600,-1331.8549800,13.5000000,330.2440000,0.0000000,271.7470000); //object(dyn_ladder_2) (2)
	CreateDynamicObject(1437,1441.3929400,-1323.7130100,14.6750000,319.2630000,7.9270000,274.9380000); //object(dyn_ladder_2) (3)
	CreateDynamicObject(3798,2420.2271000,-1512.3110000,23.0000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (7)
	CreateDynamicObject(3798,2420.2280000,-1512.3110000,25.0000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (8)
	CreateDynamicObject(3799,2420.5920000,-1511.0780000,26.8870000,0.0000000,0.0000000,0.0000000); //object(acbox2_sfs) (4)
	CreateDynamicObject(4206,1415.5159900,-1333.7249800,8.4190000,1.2500000,0.0000000,348.0000000); //object(pershingpool_lan) (4)
	CreateDynamicObject(18739,1403.3299600,-1330.1999500,5.4730000,7.0000000,0.0000000,76.2500000); //object(water_fountain) (1)
	CreateDynamicObject(18720,1403.9129600,-1342.2829600,9.5190000,0.0000000,12.0000000,1.5000000); //object(prt_watersplash) (1)
	CreateDynamicObject(18720,1404.0600600,-1354.2939500,9.5190000,0.0000000,11.9970000,1.5000000); //object(prt_watersplash) (2)
	CreateDynamicObject(18727,1382.9820600,-1280.8430200,32.5530000,0.0000000,0.0000000,0.0000000); //object(smoke50lit) (2)
	CreateDynamicObject(18691,2491.8181200,-1649.6660200,21.9990000,0.0000000,0.0000000,0.0000000); //object(fire_large) (1)
	CreateDynamicObject(18739,2495.2609900,-1653.6929900,11.8950000,0.0000000,0.0000000,0.0000000); //object(water_fountain) (2)
	CreateDynamicObject(4206,2494.6835900,-1654.5234400,12.4300000,1.2470000,0.0000000,0.0000000); //object(pershingpool_lan) (5)
	CreateDynamicObject(18690,2486.5559100,-1644.5699500,16.5120000,0.0000000,0.0000000,0.0000000); //object(fire_car) (1)
	CreateDynamicObject(18690,2489.0939900,-1644.4899900,16.5120000,0.0000000,0.0000000,0.0000000); //object(fire_car) (2)
	CreateDynamicObject(18690,2482.3549800,-1646.1720000,16.9120000,0.0000000,0.0000000,0.0000000); //object(fire_car) (3)
	CreateDynamicObject(18691,2467.5581100,-1691.6280500,12.0120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (2)
	CreateDynamicObject(18691,2465.6130400,-1691.3819600,12.0120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (3)
	CreateDynamicObject(18691,2463.4829100,-1691.6829800,12.0120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (4)
	CreateDynamicObject(18691,2459.5310100,-1692.0899700,11.4120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (5)
	CreateDynamicObject(18691,2453.5690900,-1691.2719700,12.1620000,0.0000000,0.0000000,0.0000000); //object(fire_large) (6)
	CreateDynamicObject(18691,2455.7480500,-1691.8020000,12.1620000,0.0000000,0.0000000,0.0000000); //object(fire_large) (7)
	CreateDynamicObject(18691,2451.9470200,-1691.7099600,12.1620000,0.0000000,0.0000000,0.0000000); //object(fire_large) (8)
	CreateDynamicObject(18691,2449.6731000,-1696.2139900,11.9120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (9)
	CreateDynamicObject(18691,2449.2758800,-1705.9260300,9.0870000,0.0000000,0.0000000,0.0000000); //object(fire_large) (10)
	CreateDynamicObject(18691,2454.8300800,-1707.5059800,11.3620000,0.0000000,0.0000000,0.0000000); //object(fire_large) (11)
	CreateDynamicObject(18691,2458.3701200,-1707.7419400,10.6870000,0.0000000,0.0000000,0.0000000); //object(fire_large) (12)
	CreateDynamicObject(18691,2465.6889600,-1707.6510000,12.1120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (13)
	CreateDynamicObject(18691,2463.5029300,-1707.7170400,12.1120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (14)
	CreateDynamicObject(18691,2469.6809100,-1705.8330100,9.9870000,0.0000000,0.0000000,0.0000000); //object(fire_large) (15)
	CreateDynamicObject(18691,2469.5258800,-1698.7819800,11.1120000,0.0000000,0.0000000,0.0000000); //object(fire_large) (16)
	CreateDynamicObject(658,2016.6870100,-1244.3050500,22.2060000,0.0000000,0.0000000,0.0000000); //object(pinetree04) (1)
	CreateDynamicObject(658,2034.1030300,-1235.1149900,21.3310000,0.0000000,0.0000000,0.0000000); //object(pinetree04) (2)
	CreateDynamicObject(660,2042.8609600,-1228.2810100,22.0130000,0.0000000,0.0000000,0.0000000); //object(pinetree03) (1)
	CreateDynamicObject(688,2048.6010700,-1218.9639900,22.3760000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg) (1)
	CreateDynamicObject(688,2037.1400100,-1192.6369600,21.3760000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg) (2)
	CreateDynamicObject(688,2008.3459500,-1171.4489700,19.3760000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg) (3)
	CreateDynamicObject(688,2019.9069800,-1189.7180200,19.1010000,0.0000000,0.0000000,82.0000000); //object(sm_fir_scabg) (4)
	CreateDynamicObject(688,2029.1720000,-1152.8050500,21.3010000,0.0000000,0.0000000,11.9960000); //object(sm_fir_scabg) (5)
	CreateDynamicObject(659,1932.3559600,-1225.2270500,19.1930000,0.0000000,0.0000000,0.0000000); //object(pinetree01) (1)
	CreateDynamicObject(686,1917.4050300,-1231.3280000,16.2400000,0.0000000,0.0000000,0.0000000); //object(sm_fir_dead) (1)
	CreateDynamicObject(686,1895.4279800,-1219.5109900,16.2400000,0.0000000,0.0000000,72.0000000); //object(sm_fir_dead) (2)
	CreateDynamicObject(686,1876.6929900,-1209.4370100,17.9900000,0.0000000,0.0000000,81.9990000); //object(sm_fir_dead) (3)
	CreateDynamicObject(730,1897.6090100,-1188.7110600,21.5860000,0.0000000,0.0000000,94.0000000); //object(tree_hipoly08) (1)
	CreateDynamicObject(730,1885.5319800,-1170.0610400,22.8110000,0.0000000,0.0000000,93.9990000); //object(tree_hipoly08) (2)
	CreateDynamicObject(730,1913.5520000,-1156.6049800,22.0860000,0.0000000,0.0000000,93.9990000); //object(tree_hipoly08) (3)
	CreateDynamicObject(791,1905.5820300,-1178.0341800,18.4130000,0.0000000,0.0000000,173.3150000); //object(vbg_fir_copse) (1)
	CreateDynamicObject(791,1883.4950000,-1233.8449700,11.9130000,0.0000000,0.0000000,173.3200000); //object(vbg_fir_copse) (2)
	CreateDynamicObject(791,2018.3046900,-1224.5752000,11.6130000,0.0000000,0.0000000,246.3190000); //object(vbg_fir_copse) (3)
	CreateDynamicObject(706,2049.9980500,-1174.9470200,21.9000000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbig) (1)
	CreateDynamicObject(706,2038.4940200,-1182.9880400,21.1500000,0.0000000,0.0000000,0.0000000); //object(sm_vegvbbig) (2)
	CreateDynamicObject(706,1997.7790500,-1148.7690400,21.1500000,0.0000000,0.0000000,4.5000000); //object(sm_vegvbbig) (3)
	CreateDynamicObject(706,1951.9300500,-1170.6800500,18.4000000,0.0000000,0.0000000,80.4970000); //object(sm_vegvbbig) (4)
	CreateDynamicObject(654,1944.5810500,-1232.7550000,18.3960000,0.0000000,0.0000000,0.0000000); //object(pinetree08) (1)
	CreateDynamicObject(654,1955.5739700,-1245.6770000,18.7810000,0.0000000,0.0000000,0.0000000); //object(pinetree08) (2)
	CreateDynamicObject(654,2000.6200000,-1237.3740200,18.7710000,0.0000000,296.7500000,90.0000000); //object(pinetree08) (3)
	CreateDynamicObject(818,1995.7419400,-1174.4510500,23.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (3)
	CreateDynamicObject(827,1989.5059800,-1175.2340100,22.9170000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11) (1)
	CreateDynamicObject(827,1990.4620400,-1164.0219700,23.2670000,0.0000000,0.0000000,358.0000000); //object(genveg_tallgrass11) (2)
	CreateDynamicObject(827,2004.5078100,-1163.9619100,23.2670000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2005.3994100,-1153.4980500,23.5170000,0.0000000,0.0000000,35.9860000); //object(genveg_tallgrass11) (4)
	CreateDynamicObject(827,2012.4950000,-1160.0820300,23.5170000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (5)
	CreateDynamicObject(827,2002.1020500,-1157.1899400,23.5170000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (6)
	CreateDynamicObject(827,1991.4460400,-1158.5400400,23.5170000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (7)
	CreateDynamicObject(827,1983.1630900,-1167.3691400,22.0170000,0.0000000,0.0000000,35.9860000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(818,1998.9541000,-1180.9668000,23.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2004.4433600,-1183.3017600,22.7600000,0.0000000,0.0000000,13.9970000); //object(genveg_tallgrass02) (7)
	CreateDynamicObject(818,2011.8110400,-1181.4220000,22.7600000,0.0000000,0.0000000,13.9970000); //object(genveg_tallgrass02) (8)
	CreateDynamicObject(827,2014.6080300,-1167.0369900,22.0170000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (9)
	CreateDynamicObject(827,2011.3769500,-1188.0489500,22.2670000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (10)
	CreateDynamicObject(827,2007.2490200,-1186.6240200,22.2670000,0.0000000,0.0000000,69.9910000); //object(genveg_tallgrass11) (11)
	CreateDynamicObject(827,2015.5185500,-1191.8466800,22.2670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2019.7919900,-1185.0810500,23.2670000,0.0000000,0.0000000,93.9880000); //object(genveg_tallgrass11) (13)
	CreateDynamicObject(827,2019.8700000,-1179.8060300,24.0170000,0.0000000,0.0000000,93.9880000); //object(genveg_tallgrass11) (14)
	CreateDynamicObject(827,2020.6369600,-1174.3750000,24.0170000,0.0000000,0.0000000,93.9880000); //object(genveg_tallgrass11) (15)
	CreateDynamicObject(827,2018.0959500,-1158.8509500,25.0170000,0.0000000,0.0000000,93.9880000); //object(genveg_tallgrass11) (16)
	CreateDynamicObject(827,2021.0830100,-1165.0322300,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,1975.7869900,-1156.1679700,20.4170000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (18)
	CreateDynamicObject(827,1983.7860100,-1156.3010300,20.4170000,0.0000000,0.0000000,85.9910000); //object(genveg_tallgrass11) (19)
	CreateDynamicObject(827,1983.9179700,-1148.3010300,20.4170000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (20)
	CreateDynamicObject(827,1983.8430200,-1152.8010300,22.4170000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (21)
	CreateDynamicObject(827,1969.6910400,-1156.4279800,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (22)
	CreateDynamicObject(827,1966.2950400,-1158.1519800,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (23)
	CreateDynamicObject(827,1963.8869600,-1155.8020000,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (24)
	CreateDynamicObject(827,1962.5679900,-1158.6440400,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (25)
	CreateDynamicObject(827,1960.3769500,-1155.7790500,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (26)
	CreateDynamicObject(827,1959.3239700,-1158.8540000,21.1670000,0.0000000,0.0000000,85.9900000); //object(genveg_tallgrass11) (27)
	CreateDynamicObject(18720,2491.8210400,-1649.4189500,22.9570000,0.0000000,0.0000000,0.0000000); //object(prt_watersplash) (3)
	CreateDynamicObject(18691,2402.5009800,-1714.6280500,11.2080000,0.0000000,0.0000000,0.0000000); //object(fire_large) (17)
	CreateDynamicObject(18689,2404.5810500,-1715.0279500,12.5500000,0.0000000,0.0000000,0.0000000); //object(fire_bike) (1)
	CreateDynamicObject(18689,2397.6279300,-1714.8089600,12.5500000,0.0000000,0.0000000,0.0000000); //object(fire_bike) (2)
	CreateDynamicObject(2907,1853.5749500,-1864.4449500,12.7380000,0.0000000,0.0000000,228.7500000); //object(kmb_deadtorso) (17)
	CreateDynamicObject(2908,1853.1619900,-1864.1200000,12.7560000,2.1180000,93.3940000,221.9370000); //object(kmb_deadhead) (17)
	CreateDynamicObject(2906,1853.2500000,-1862.8249500,12.6520000,0.0000000,0.0000000,82.0000000); //object(kmb_deadarm) (28)
	CreateDynamicObject(2906,1852.8349600,-1865.4840100,12.6520000,0.0000000,0.0000000,133.9960000); //object(kmb_deadarm) (29)
	CreateDynamicObject(2907,1848.7889400,-1861.7469500,12.7450000,0.0000000,0.0000000,72.0000000); //object(kmb_deadtorso) (18)
	CreateDynamicObject(2908,1849.2700200,-1861.9079600,12.7810000,2.1150000,93.3890000,59.9360000); //object(kmb_deadhead) (18)
	CreateDynamicObject(2905,1854.3389900,-1863.4480000,12.7200000,0.0000000,86.0000000,48.0000000); //object(kmb_deadleg) (29)
	CreateDynamicObject(2905,1854.9229700,-1865.0970500,12.7200000,0.0000000,168.0000000,245.9990000); //object(kmb_deadleg) (30)
	CreateDynamicObject(2905,1846.4410400,-1862.2130100,12.6700000,0.0000000,0.0000000,72.0000000); //object(kmb_deadleg) (31)
	CreateDynamicObject(2890,1859.2629400,-1862.3330100,12.5760000,0.0000000,0.0000000,184.0000000); //object(kmb_skip) (1)
	CreateDynamicObject(2971,1842.4499500,-1866.1829800,12.3900000,0.0000000,0.0000000,48.0000000); //object(k_smashboxes) (3)
	CreateDynamicObject(19836,1848.8620600,-1861.6889600,12.5850000,0.0000000,0.0000000,108.0000000); //object(bloodpool1) (1)
	CreateDynamicObject(19836,1853.5279500,-1864.2209500,12.5850000,0.0000000,0.0000000,130.9960000); //object(bloodpool1) (2)
	CreateDynamicObject(3594,1838.3370400,-1870.2299800,13.0210000,0.0000000,0.0000000,0.0000000); //object(la_fuckcar1) (207)
	CreateDynamicObject(3594,1829.4480000,-1865.0699500,13.0210000,0.0000000,0.0000000,60.0000000); //object(la_fuckcar1) (208)
	CreateDynamicObject(791,1880.9870600,-1204.3790300,14.9130000,0.0000000,0.0000000,164.5650000); //object(vbg_fir_copse) (1)
	CreateDynamicObject(791,1914.8349600,-1235.3230000,12.0630000,0.0000000,0.0000000,164.5640000); //object(vbg_fir_copse) (1)
	CreateDynamicObject(843,1927.8110400,-1181.3499800,20.4660000,359.7520000,7.2500000,0.0320000); //object(dead_tree_15) (1)
	CreateDynamicObject(615,1951.8780500,-1151.9510500,20.3060000,0.0000000,0.0000000,0.0000000); //object(veg_tree3) (1)
	CreateDynamicObject(615,1935.9169900,-1150.7939500,20.3060000,0.0000000,4.0000000,158.0000000); //object(veg_tree3) (2)
	CreateDynamicObject(615,1950.5290500,-1162.1379400,20.0560000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (3)
	CreateDynamicObject(615,1925.6850600,-1163.5050000,20.0560000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (4)
	CreateDynamicObject(615,1926.9420200,-1148.2650100,20.9060000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (5)
	CreateDynamicObject(615,1898.5329600,-1156.7249800,22.8810000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (6)
	CreateDynamicObject(615,1880.6980000,-1159.8320300,22.5810000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (7)
	CreateDynamicObject(615,1882.2099600,-1176.0639600,21.6310000,0.0000000,3.9990000,158.0000000); //object(veg_tree3) (8)
	CreateDynamicObject(982,2056.3889200,-1159.9639900,23.5060000,0.0000000,0.0000000,0.9950000); //object(fenceshit) (2)
	CreateDynamicObject(982,2056.7590300,-1185.5920400,23.5060000,0.0000000,0.0000000,0.7440000); //object(fenceshit) (3)
	CreateDynamicObject(982,2057.0979000,-1211.1820100,23.5060000,0.0000000,0.0000000,0.7420000); //object(fenceshit) (4)
	CreateDynamicObject(982,2057.2429200,-1236.7869900,23.5060000,0.0000000,0.0000000,359.9920000); //object(fenceshit) (5)
	CreateDynamicObject(818,1999.9499500,-1182.0880100,27.3850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,1994.2609900,-1182.4599600,27.3850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,1990.4919400,-1178.1510000,27.3850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,1993.7259500,-1174.5860600,27.3850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2003.7309600,-1183.9339600,27.3850000,0.0000000,0.0000000,338.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2010.7540300,-1184.4360400,27.6350000,0.0000000,0.0000000,338.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(827,2021.0830100,-1165.0319800,30.2670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,2018.5429700,-1160.5739700,28.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,2014.3780500,-1167.2939500,26.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,2003.7380400,-1154.3050500,28.2670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,2003.5600600,-1164.7650100,27.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,2011.7889400,-1159.9780300,29.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (17)
	CreateDynamicObject(827,1983.1629600,-1167.3690200,26.7670000,0.0000000,0.0000000,35.9860000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1985.8459500,-1162.3260500,22.0170000,0.0000000,0.0000000,35.9860000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1989.3599900,-1156.3490000,22.0170000,0.0000000,0.0000000,37.9860000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1982.6330600,-1155.7819800,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1982.1710200,-1161.2629400,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1993.4300500,-1155.6879900,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1986.4350600,-1152.3380100,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1992.8100600,-1151.1190200,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1998.1379400,-1159.3459500,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1995.8089600,-1163.1639400,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1997.5889900,-1168.8330100,22.0170000,0.0000000,0.0000000,37.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,2002.7609900,-1167.0109900,22.0170000,0.0000000,2.0000000,35.9850000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,2002.9919400,-1164.2700200,22.0170000,0.0000000,12.0000000,43.9800000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,1999.0050000,-1163.9339600,22.0170000,0.0000000,357.9970000,43.9780000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,2006.6610100,-1147.5169700,27.7670000,0.0000000,357.9950000,43.9780000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,2012.0570100,-1148.9749800,25.7670000,0.0000000,357.9950000,43.9780000); //object(genveg_tallgrass11) (8)
	CreateDynamicObject(827,2006.8220200,-1156.9100300,23.2670000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2012.5419900,-1154.8230000,23.2670000,0.0000000,0.0000000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2008.6679700,-1157.9840100,23.2670000,0.0000000,356.0000000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2015.6729700,-1155.4940200,23.2670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2010.3659700,-1164.0190400,23.2670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2013.4489700,-1159.8879400,23.2670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2014.3859900,-1155.8950200,23.2670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2031.6889600,-1164.4830300,24.2670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2026.5429700,-1164.6400100,23.7670000,0.0000000,355.9950000,35.9910000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2021.0169700,-1162.6949500,23.3920000,358.0050000,355.9930000,35.8510000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2018.0179400,-1161.5720200,23.3920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2022.4300500,-1147.0050000,26.1420000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2014.8020000,-1145.4410400,24.8920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2022.0300300,-1152.1910400,23.3920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2022.3530300,-1159.5660400,22.1420000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2025.3470500,-1162.1460000,22.3920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2025.3189700,-1168.0730000,23.8920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2018.5980200,-1168.4730200,23.9920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2026.0059800,-1172.1149900,23.9920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2030.2349900,-1158.7919900,22.9920000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2033.3659700,-1163.5639600,23.7420000,358.0000000,355.9900000,35.8480000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2031.2049600,-1151.6300000,23.7420000,358.9960000,0.2420000,40.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2037.4200400,-1148.8129900,25.9920000,358.9950000,0.2420000,40.2370000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2032.9310300,-1148.4940200,25.9920000,358.9950000,0.2420000,40.2370000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2037.7249800,-1155.0999800,23.4920000,358.9950000,0.2420000,40.2370000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2043.0129400,-1151.2139900,26.2420000,358.9950000,0.2420000,40.2370000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2046.9320100,-1152.4950000,25.5170000,356.9950000,0.2420000,40.2460000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2048.9619100,-1148.6280500,26.2670000,356.9900000,0.2420000,40.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2053.1101100,-1150.1760300,26.2670000,356.9900000,0.2420000,100.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2042.5649400,-1146.9210200,26.2670000,356.9840000,0.2420000,100.2390000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2039.2159400,-1148.1870100,26.2670000,356.9840000,0.2420000,100.2390000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2028.9909700,-1147.4610600,25.0170000,356.9840000,0.2420000,100.2390000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2018.0169700,-1146.6820100,24.7670000,356.9840000,0.2420000,100.2390000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(818,2009.8570600,-1189.1009500,21.8350000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2014.5999800,-1189.6590600,21.8350000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2023.7030000,-1181.2679400,21.8350000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2029.7729500,-1170.2070300,23.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2035.3960000,-1168.6450200,23.8350000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2033.9480000,-1172.6639400,23.8350000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2031.2600100,-1177.4489700,25.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2027.4880400,-1179.1529500,25.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2039.7860100,-1175.3020000,25.0850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2043.6970200,-1167.5240500,25.5850000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2041.7280300,-1171.6920200,25.5850000,0.0000000,0.0000000,2.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2045.8339800,-1169.8520500,25.5850000,0.0000000,0.0000000,8.0000000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2049.9418900,-1168.0129400,25.5850000,0.0000000,0.0000000,15.9980000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2053.3659700,-1166.4799800,25.5850000,0.0000000,0.0000000,21.9960000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2054.7241200,-1160.9420200,25.5850000,0.0000000,352.0000000,27.9950000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2053.1931200,-1157.5190400,25.5850000,0.0000000,341.9960000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2052.3410600,-1151.3280000,25.0850000,2.0000000,359.9930000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2051.6960400,-1158.4610600,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2051.9641100,-1165.1860400,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2049.8181200,-1170.8010300,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2054.5200200,-1173.3509500,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2054.7829600,-1177.6140100,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2051.2429200,-1184.4000200,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2055.1579600,-1187.0279500,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2052.6059600,-1181.3239700,25.0850000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2041.9329800,-1177.0639600,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2045.2120400,-1178.8819600,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2046.7240000,-1174.9179700,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2042.8349600,-1182.1379400,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2047.2550000,-1183.4449500,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2046.6080300,-1188.1169400,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2049.5090300,-1190.9250500,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2053.1420900,-1192.3110400,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2054.6079100,-1189.4639900,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2052.2419400,-1187.2370600,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2049.5991200,-1186.2290000,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2043.1319600,-1188.3029800,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2041.1090100,-1191.1259800,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2044.4899900,-1193.1720000,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2048.1230500,-1194.5579800,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2051.7570800,-1195.9429900,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2053.5830100,-1195.1250000,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2055.8898900,-1193.5450400,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(818,2055.8896500,-1193.5449200,23.8350000,2.0000000,359.9890000,27.9930000); //object(genveg_tallgrass02) (4)
	CreateDynamicObject(827,2035.2139900,-1178.6850600,24.7670000,356.9900000,0.2420000,40.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2033.0200200,-1183.4010000,24.7670000,356.9900000,0.2420000,40.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2033.2419400,-1184.6300000,24.7670000,356.9900000,0.2420000,40.2430000); //object(genveg_tallgrass11) (3)
	CreateDynamicObject(827,2053.8579100,-1200.4980500,25.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2048.2500000,-1201.5479700,25.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2044.3940400,-1199.2170400,25.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2040.6820100,-1199.0310100,23.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2036.8330100,-1200.2519500,23.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2032.9770500,-1197.9210200,23.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2028.4029500,-1197.4730200,23.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2023.1250000,-1196.9560500,23.7670000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2019.2900400,-1196.2259500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2015.4200400,-1195.8470500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2012.7359600,-1190.6120600,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2012.3759800,-1187.0240500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2009.5620100,-1186.7480500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2007.4429900,-1182.9890100,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2021.5970500,-1181.7099600,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2026.4940200,-1185.6460000,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2029.1629600,-1186.3050500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2036.2480500,-1183.6779800,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2030.6669900,-1182.2989500,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2027.9980500,-1181.6400100,22.5170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2027.7790500,-1189.8249500,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2031.6579600,-1189.7530500,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2034.5689700,-1190.4720500,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2041.5019500,-1203.2679400,25.9840000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2030.1540500,-1194.7889400,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2033.3590100,-1192.2330300,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2033.3584000,-1192.2324200,25.0170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2048.6560100,-1207.1300000,26.1470000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2054.2360800,-1205.1209700,26.5740000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2043.3950200,-1207.4890100,26.1660000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2048.7009300,-1204.1200000,26.2170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2054.3159200,-1203.2600100,26.5660000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2039.1080300,-1206.6049800,25.7250000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2032.8879400,-1203.6020500,24.9340000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2025.9189500,-1200.1490500,24.0240000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2016.2189900,-1200.2750200,22.8340000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2024.5990000,-1204.5250200,23.9560000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2029.6440400,-1201.3050500,24.5080000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2024.7099600,-1192.0279500,24.0580000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2014.3570600,-1204.6130400,22.8140000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2013.0329600,-1209.0100100,22.8520000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2037.2729500,-1210.3969700,25.5530000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2031.8890400,-1210.7240000,24.9290000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2031.2530500,-1208.4050300,24.8120000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2029.0990000,-1208.7089800,24.8810000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2023.6899400,-1236.6800500,25.1010000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2030.7960200,-1243.3759800,25.8880000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2036.7249800,-1237.4919400,25.5210000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2043.7939500,-1231.9720500,25.8800000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2037.2580600,-1225.0460200,25.4410000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2039.6090100,-1218.0810500,25.6170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2029.6660200,-1224.8330100,25.0600000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2033.8210400,-1230.7149700,25.2830000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2031.7469500,-1222.0190400,25.2410000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2041.5460200,-1237.5059800,25.7810000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2044.1600300,-1244.2609900,26.0060000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2056.4240700,-1251.1409900,26.7750000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2049.0810500,-1236.6009500,26.2300000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2051.4550800,-1245.3260500,26.4130000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2046.0780000,-1249.5749500,26.6170000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2035.0670200,-1250.9200400,26.7750000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2013.1080300,-1249.3719500,26.5930000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2054.0339400,-1229.3759800,26.5690000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2053.1579600,-1218.8079800,26.5040000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2013.4050300,-1228.7170400,24.2690000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2014.1440400,-1235.8320300,24.8500000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2012.3100600,-1241.9539800,25.5600000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2005.2629400,-1243.5820300,25.2770000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1991.0980200,-1236.9189500,23.1330000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1997.3990500,-1238.7060500,23.8400000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2000.6379400,-1220.8640100,24.5500000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1996.9530000,-1225.5229500,23.2220000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1991.3210400,-1224.3730500,22.9910000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1987.0639600,-1224.6550300,22.9160000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1990.7380400,-1220.9530000,22.8140000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2007.7330300,-1219.3089600,23.2970000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2016.0290500,-1216.6090100,23.6900000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2021.3100600,-1230.3100600,24.5960000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2000.8830600,-1235.3160400,23.8060000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2009.0109900,-1230.1910400,24.0370000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2008.6999500,-1226.7220500,24.0510000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2003.7850300,-1225.6629600,23.6520000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1994.6340300,-1230.4029500,23.3850000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1986.8649900,-1232.3380100,22.9660000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1988.8680400,-1244.0629900,23.0410000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1992.4050300,-1247.2309600,23.6270000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1994.7860100,-1243.1300000,23.7260000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1987.2919900,-1227.8199500,23.0420000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1995.2290000,-1235.8559600,23.3370000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1987.3039600,-1243.8330100,22.9740000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1987.2950400,-1238.0319800,22.9700000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2024.1450200,-1247.3199500,26.3510000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2020.0389400,-1250.4360400,26.7180000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2030.2330300,-1250.9820600,26.7750000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2038.2619600,-1245.1949500,26.1020000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2051.9079600,-1233.8750000,26.4120000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2053.3210400,-1209.4680200,26.5070000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2044.7669700,-1210.2590300,26.0280000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2041.6899400,-1213.9360400,25.8500000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2027.4050300,-1219.7170400,24.9680000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2018.2700200,-1218.6070600,24.0450000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2006.8900100,-1169.2889400,23.6760000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2001.1009500,-1215.8599900,22.8210000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2008.8079800,-1215.2710000,23.0130000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2008.9449500,-1210.9720500,22.8140000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2004.2960200,-1231.6910400,23.7890000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2021.8640100,-1226.2939500,24.7090000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2022.3220200,-1241.5429700,25.6720000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,2045.8609600,-1240.7609900,26.0550000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1980.1379400,-1233.2340100,19.5880000,0.0000000,0.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1972.9410400,-1234.1149900,19.5880000,0.0000000,358.0000000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1967.7850300,-1237.2650100,19.5880000,0.0000000,357.9950000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1967.0749500,-1235.5880100,19.5880000,0.0000000,357.9950000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1964.3439900,-1235.9220000,19.5880000,0.0000000,357.9950000,93.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1959.8270300,-1238.7889400,22.7270000,0.0000000,1.9950000,133.9830000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1965.3010300,-1237.5679900,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1970.4520300,-1236.4329800,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1972.6850600,-1236.1590600,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1973.9250500,-1236.0059800,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1975.9100300,-1235.7629400,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1976.1269500,-1235.4840100,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1977.6510000,-1233.5340600,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1980.6280500,-1233.1689500,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1980.6279300,-1233.1689500,19.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1955.2480500,-1238.6330600,22.5520000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1948.3339800,-1240.2559800,22.0820000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1949.2580600,-1243.0439500,22.2490000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.9909700,-1246.4740000,22.1120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1940.5119600,-1245.6200000,21.5720000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1933.0129400,-1244.7580600,20.8710000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1936.0699500,-1247.7929700,21.1670000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1937.3709700,-1238.8830600,21.1800000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1934.4599600,-1241.4229700,20.9670000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.1009500,-1239.3719500,20.7180000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.6429400,-1241.8649900,21.3320000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1943.5990000,-1238.6569800,21.6930000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1951.4270000,-1230.5870400,22.5410000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1949.5899700,-1233.3189700,22.4030000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.3330100,-1234.9489700,21.4670000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1934.3960000,-1229.5329600,22.3660000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.7810100,-1232.6600300,21.5090000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.3470500,-1234.2320600,21.6110000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1943.3909900,-1235.2340100,21.7250000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1954.2679400,-1246.3020000,22.5280000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1960.2629400,-1246.7270500,22.7280000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1959.6989700,-1244.3919700,22.7130000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1957.6340300,-1232.6500200,22.5970000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1958.2530500,-1227.8299600,22.7330000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1958.8100600,-1221.9279800,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1949.4820600,-1222.2349900,22.8070000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1954.6650400,-1225.6739500,22.7540000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1949.9129600,-1226.2889400,22.6760000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1942.6369600,-1229.8840300,22.4660000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.7099600,-1230.7039800,22.5000000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.0909400,-1220.9530000,22.8030000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1944.7380400,-1228.1030300,22.6090000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1940.3709700,-1220.3790300,22.8410000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.0849600,-1215.2500000,22.8220000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1939.4520300,-1224.2719700,22.7740000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.2299800,-1220.7430400,22.9300000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1926.3270300,-1217.2900400,22.5270000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1924.9470200,-1213.5419900,22.6200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1933.9670400,-1217.6850600,22.8500000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.1999500,-1209.2550000,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1927.4169900,-1207.8110400,22.8050000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1924.2480500,-1198.1590600,22.8700000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1925.9599600,-1198.2750200,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1927.8599900,-1200.1340300,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1920.7380400,-1211.6300000,22.5930000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1923.0860600,-1204.2270500,22.7400000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1911.5990000,-1208.7170400,22.4120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1916.1579600,-1210.7800300,22.4190000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1916.9689900,-1202.7249800,22.7240000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1917.5639600,-1194.0889900,23.5430000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1920.4870600,-1197.5909400,23.0270000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1921.0679900,-1202.1939700,22.6970000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1918.9560500,-1207.0369900,22.6770000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1920.9870600,-1190.4799800,23.6400000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1927.8339800,-1192.8909900,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1937.1280500,-1184.3669400,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1927.8399700,-1191.5019500,32.6020000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1931.1009500,-1184.0080600,23.0740000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.2380400,-1187.8669400,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.9239500,-1180.6619900,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1948.9129600,-1180.8759800,22.8140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1954.0340600,-1156.7650100,23.8130000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1954.1729700,-1152.8640100,24.1660000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1952.3260500,-1149.1240200,24.7200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1956.2030000,-1148.9530000,24.4530000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1948.9940200,-1149.7120400,24.7340000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1948.8339800,-1157.0379600,23.8880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1948.8239700,-1153.6330600,24.1610000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.4510500,-1161.8549800,23.7900000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1946.8709700,-1173.5529800,23.0540000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1957.1569800,-1162.3339800,23.5900000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1956.7819800,-1167.7180200,23.2710000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1952.5560300,-1164.2240000,23.5630000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1953.3399700,-1175.6650400,22.8540000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1957.3669400,-1170.6259800,23.0860000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1949.0570100,-1176.1760300,22.9000000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1945.3490000,-1174.9339600,23.0200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1943.0529800,-1179.2199700,22.8640000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1939.1440400,-1176.7099600,23.1270000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.1440400,-1170.0649400,23.6860000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.1739500,-1161.3189700,24.1720000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1943.7540300,-1152.8459500,24.6840000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1938.0090300,-1151.7370600,25.8120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1932.7039800,-1151.8320300,26.1060000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1926.7590300,-1159.9510500,24.9940000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1929.4539800,-1179.3850100,23.5860000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1923.5889900,-1178.7550000,24.4500000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1915.3399700,-1180.3280000,25.1350000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1922.0930200,-1183.0329600,24.2180000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1925.9820600,-1187.0689700,23.4410000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1925.1159700,-1233.8520500,20.7080000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1922.6920200,-1222.2330300,22.3440000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1915.9449500,-1226.8430200,20.7910000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1918.0920400,-1222.2889400,21.7970000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1921.2430400,-1217.4460400,22.3310000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1909.4759500,-1218.8470500,21.0360000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1910.1669900,-1215.1280500,21.5880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1905.2130100,-1214.2929700,21.3120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1899.0269800,-1212.9220000,21.3490000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1893.7569600,-1208.6460000,21.5440000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1885.5369900,-1206.9730200,21.9340000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1886.0959500,-1222.3549800,19.0590000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.0290500,-1217.7070300,19.9190000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1888.8010300,-1211.7130100,21.0080000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.0009800,-1201.7500000,23.0140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1892.1350100,-1205.3549800,22.2600000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1899.2950400,-1203.8420400,22.4270000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1900.2600100,-1197.6870100,24.0210000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1894.8540000,-1190.3649900,25.2040000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1892.2039800,-1181.7559800,26.2200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1902.7099600,-1170.0240500,27.0550000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1898.4549600,-1179.8690200,26.5900000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.1660200,-1190.0839800,25.0070000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1879.4279800,-1181.0109900,26.2930000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1870.3900100,-1190.0090300,26.0780000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1879.0520000,-1192.9730200,24.6880000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1874.7099600,-1199.9499500,24.0840000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1863.5389400,-1212.8280000,22.7920000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1865.1929900,-1218.5500500,21.7070000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1864.7070300,-1229.9940200,19.6850000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1877.3780500,-1236.5340600,17.7410000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1888.7170400,-1243.4799800,17.1400000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1885.3819600,-1237.4849900,17.6950000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1883.3620600,-1244.0090300,16.9310000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1869.0520000,-1238.8249500,17.5580000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1864.7130100,-1247.2710000,16.6450000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1863.7790500,-1197.5340600,25.5240000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1863.6929900,-1193.0730000,26.2980000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1871.1610100,-1198.6710200,24.6410000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1863.3780500,-1202.2490200,24.7110000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1870.3960000,-1205.7469500,23.7230000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1865.4580100,-1207.5749500,23.5590000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1876.0529800,-1206.9399400,22.6160000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1920.1140100,-1231.8769500,20.5790000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1914.9770500,-1248.0240500,18.2110000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1921.0860600,-1246.7020300,19.5220000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1917.8960000,-1238.1999500,19.4660000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1911.4169900,-1234.4050300,19.1670000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1911.8490000,-1239.0050000,19.0150000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1901.2960200,-1243.1540500,17.7650000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1893.9859600,-1247.2080100,17.0160000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1902.3499800,-1248.1660200,16.8390000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1906.7099600,-1230.7180200,19.2210000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1906.5200200,-1236.2769800,18.5730000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1899.8449700,-1232.3430200,18.4430000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1901.4680200,-1239.1650400,18.3450000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1909.6560100,-1222.9919400,20.5070000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1907.6099900,-1226.9570300,19.7980000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1911.7130100,-1229.1949500,19.8790000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1891.2130100,-1152.5610400,27.0290000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1898.3100600,-1147.4549600,27.2210000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.5749500,-1151.7919900,26.9400000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1881.4610600,-1148.3769500,26.7950000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1891.5999800,-1146.7719700,27.0540000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.7189900,-1147.6159700,26.9540000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1886.3230000,-1164.8459500,26.8040000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1884.0460200,-1159.8719500,26.8290000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1921.0689700,-1149.2860100,27.1120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1913.5410200,-1151.8979500,26.4140000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1917.5250200,-1148.5080600,27.1750000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1920.1529500,-1161.3540000,25.5710000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1927.7130100,-1159.2800300,24.9200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1915.3210400,-1168.8599900,25.9910000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1908.5080600,-1166.5080600,26.7710000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1910.6350100,-1172.2590300,26.3120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1911.3750000,-1160.9740000,26.4200000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1914.3549800,-1163.9119900,26.1760000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1870.2929700,-1230.5639600,19.2080000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1879.2070300,-1225.2230200,19.2080000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1877.6839600,-1229.0050000,18.8390000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1883.6910400,-1214.2159400,20.5530000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1889.2270500,-1225.2130100,18.6450000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1887.5679900,-1230.2659900,18.2750000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1891.3210400,-1233.3010300,18.0120000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(827,1894.3790300,-1224.1600300,19.1710000,0.0000000,1.9940000,133.9780000); //object(genveg_tallgrass11) (12)
	CreateDynamicObject(9958,-33.2960000,-1612.0909400,4.8750000,0.0000000,0.0000000,318.2500000); //object(submarr_sfe) (1)
	CreateDynamicObject(3117,1996.5898400,-2228.6503900,13.8250000,359.4070000,322.2340000,1.2800000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(3117,1993.7819800,-2228.7399900,11.6500000,359.4070000,322.2400000,1.2850000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(3578,1881.3120100,-2424.0878900,13.3330000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (5)
	CreateDynamicObject(3578,1881.3189700,-2434.2810100,13.3330000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (6)
	CreateDynamicObject(3578,1881.3139600,-2444.2919900,13.3330000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la) (7)
	CreateDynamicObject(3578,1872.4814500,-2424.1103500,12.6080000,51.9980000,0.0000000,90.0000000); //object(dockbarr1_la) (8)
	CreateDynamicObject(3578,1870.2860100,-2434.5459000,13.3330000,0.0000000,0.0000000,70.0000000); //object(dockbarr1_la) (10)
	CreateDynamicObject(3578,1876.2419400,-2449.2629400,13.3330000,0.0000000,0.0000000,5.7500000); //object(dockbarr1_la) (11)
	CreateDynamicObject(3578,1863.6600300,-2440.1779800,13.3330000,0.0000000,0.0000000,11.7460000); //object(dockbarr1_la) (12)
	CreateDynamicObject(3578,1867.7099600,-2449.8979500,13.3330000,0.0000000,0.0000000,4.2440000); //object(dockbarr1_la) (13)
	CreateDynamicObject(3620,1855.4365200,-2430.2529300,25.6500000,0.0000000,0.0000000,55.9970000); //object(redockrane_las) (1)
	CreateDynamicObject(973,1881.6190200,-2400.6721200,13.3950000,0.0000000,0.0000000,36.0000000); //object(sub_roadbarrier) (1)
	CreateDynamicObject(973,1881.6750500,-2413.5590800,13.3950000,0.0000000,0.0000000,88.5000000); //object(sub_roadbarrier) (2)
	CreateDynamicObject(973,1885.1839600,-2405.6879900,13.3950000,0.0000000,0.0000000,44.4950000); //object(sub_roadbarrier) (3)
	CreateDynamicObject(973,1875.2290000,-2407.3291000,13.3950000,0.0000000,0.0000000,57.7470000); //object(sub_roadbarrier) (4)
	CreateDynamicObject(980,1884.3079800,-2418.8068800,15.3280000,0.0000000,0.0000000,179.5000000); //object(airportgate) (2)
	CreateDynamicObject(1250,1871.8039600,-2419.3950200,13.3750000,0.0000000,0.0000000,92.2500000); //object(smashbarpost) (2)
	CreateDynamicObject(1251,1875.8199500,-2419.7451200,13.6090000,0.0000000,0.0000000,87.2500000); //object(smashbar) (3)
	CreateDynamicObject(1425,1859.1269500,-2441.1450200,14.5320000,0.0000000,0.0000000,282.0000000); //object(dyn_roadbarrier_3) (1)
	CreateDynamicObject(6295,1862.3144500,-2455.6220700,36.4870000,0.0000000,0.0000000,257.9970000); //object(sanpedlithus_law2) (1)
	CreateDynamicObject(3214,1882.1219500,-2366.3620600,20.8690000,0.0000000,0.0000000,0.0000000); //object(quarry_crusher) (1)
	CreateDynamicObject(18771,1867.0949700,-2455.7009300,7.7350000,0.0000000,0.0000000,95.7500000); //object(spiralstair1) (1)
	CreateDynamicObject(1219,1865.2480500,-2456.4350600,15.7920000,0.0660000,87.0010000,348.0020000); //object(palette) (92)
	CreateDynamicObject(3117,1865.2500000,-2454.5610400,57.8480000,359.0460000,17.4950000,5.7960000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(19815,1969.0600600,-2381.7609900,13.3270000,0.0000000,0.0000000,268.0000000); //object(toolboard1) (2)
	CreateDynamicObject(18885,1975.3570600,-2411.4099100,13.5210000,0.0000000,0.0000000,90.5000000); //object(gunvendingmachine1) (1)
	CreateDynamicObject(1583,1979.6369600,-2400.9709500,16.5470000,0.0000000,0.0000000,0.0000000); //object(tar_gun2) (1)
	CreateDynamicObject(18047,1979.7679400,-2406.1650400,13.1020000,0.0000000,0.0000000,0.0000000); //object(mpgun_counter06) (2)
	CreateDynamicObject(3066,1896.9470200,-2348.9150400,13.6010000,0.0000000,0.0000000,0.0000000); //object(ammotrn_obj) (4)
	CreateDynamicObject(3066,1901.6169400,-2347.6960400,13.6010000,0.0000000,0.0000000,178.5000000); //object(ammotrn_obj) (5)
	CreateDynamicObject(3066,1892.2790500,-2346.1669900,13.6010000,0.0000000,0.0000000,178.4950000); //object(ammotrn_obj) (6)
	CreateDynamicObject(3066,1885.1519800,-2348.7829600,13.6010000,0.0000000,0.0000000,224.4950000); //object(ammotrn_obj) (7)
	CreateDynamicObject(3066,1894.3680400,-2362.8369100,13.6010000,0.0000000,0.0000000,302.4950000); //object(ammotrn_obj) (8)
	CreateDynamicObject(3378,1895.8800000,-2327.8649900,13.6220000,0.0000000,0.0000000,358.0000000); //object(ce_beerpile01) (2)
	CreateDynamicObject(939,1877.3599900,-2349.1340300,14.9900000,0.0000000,0.0000000,0.0000000); //object(cj_df_unit) (1)
	CreateDynamicObject(3585,1909.4179700,-2333.1440400,15.1520000,0.0000000,56.0000000,0.0000000); //object(lastran1_la02) (9)
	CreateDynamicObject(10985,1910.3929400,-2332.5878900,13.1510000,0.0000000,357.5000000,0.0000000); //object(rubbled02_sfs) (48)
	CreateDynamicObject(3585,1915.2889400,-2330.4709500,14.4520000,8.0830000,11.6170000,358.3440000); //object(lastran1_la02) (10)
	CreateDynamicObject(828,1917.7030000,-2338.6579600,12.7470000,6.0000000,0.0000000,32.0000000); //object(p_rubble2) (3)
	CreateDynamicObject(828,1918.5059800,-2338.3789100,12.7470000,5.9990000,0.0000000,117.9980000); //object(p_rubble2) (4)
	CreateDynamicObject(939,1877.0927700,-2354.7168000,14.9900000,0.0000000,0.0000000,125.9970000); //object(cj_df_unit) (2)
	CreateDynamicObject(18862,1877.8850100,-2305.1398900,13.4020000,0.0000000,0.0000000,0.0000000); //object(garbagepileramp1) (1)
	CreateDynamicObject(16096,1903.9940200,-2362.8210400,14.4560000,0.0000000,0.0000000,192.0000000); //object(des_a51guardbox04) (2)
	CreateDynamicObject(18653,1883.3020000,-2415.0239300,12.5550000,0.0000000,0.0000000,40.0000000); //object(discolightred) (1)
	CreateDynamicObject(19075,1887.4129600,-2267.7900400,14.0470000,0.0000000,0.0000000,269.2500000); //object(cage5mx5mx3mv2) (1)
	CreateDynamicObject(3578,1892.6030300,-2366.4431200,13.2750000,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (9)
	CreateDynamicObject(973,1875.8199500,-2365.1460000,13.3200000,0.0000000,0.0000000,123.5000000); //object(sub_roadbarrier) (6)
	CreateDynamicObject(19589,1880.7459700,-2361.5820300,12.5540000,0.0000000,0.0000000,42.0000000); //object(rubbishskipempty1) (1)
	CreateDynamicObject(16090,1876.8070100,-2422.6879900,12.5550000,0.0000000,0.0000000,86.0000000); //object(des_pipestrut03) (1)
	CreateDynamicObject(3287,1962.1219500,-2348.5949700,17.2860000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (1)
	CreateDynamicObject(3287,1955.3690200,-2348.5080600,17.2860000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (2)
	CreateDynamicObject(3287,1969.5050000,-2348.6450200,17.2860000,0.0000000,0.0000000,0.0000000); //object(cxrf_oiltank) (3)
	CreateDynamicObject(3097,1883.1560100,-2364.8059100,15.1850000,68.1980000,47.9440000,41.6670000); //object(break_wall_2b) (2)
	CreateDynamicObject(3279,1961.9289600,-2214.9069800,14.7750000,359.7500000,0.5000000,89.7520000); //object(a51_spottower) (5)
	CreateDynamicObject(3279,1995.8879400,-2187.9729000,12.5470000,0.0000000,0.0000000,91.5000000); //object(a51_spottower) (6)
	CreateDynamicObject(18850,1954.5679900,-2272.1521000,24.7970000,0.0000000,0.0000000,0.0000000); //object(helipad1) (1)
	CreateDynamicObject(8613,1941.7130100,-2261.0410200,16.9180000,0.0000000,0.0000000,0.0000000); //object(vgssstairs03_lvs) (2)
	CreateDynamicObject(8613,1950.1920200,-2253.3879400,24.5430000,0.0000000,0.0000000,355.0000000); //object(vgssstairs03_lvs) (3)
	CreateDynamicObject(8615,1916.3940400,-2231.6130400,12.5470000,0.0000000,0.0000000,0.0000000); //object(vgssstairs04_lvs) (1)
	CreateDynamicObject(8615,1958.0290500,-2250.6269500,30.6180000,0.0000000,0.0000000,356.7480000); //object(vgssstairs04_lvs) (3)
	CreateDynamicObject(8613,1959.6939700,-2254.8139600,33.7180000,0.0000000,0.0000000,266.4960000); //object(vgssstairs03_lvs) (5)
	CreateDynamicObject(18762,1945.6040000,-2250.5258800,21.8970000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (2)
	CreateDynamicObject(18762,1944.1120600,-2258.7829600,12.9220000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (3)
	CreateDynamicObject(18762,1937.1889600,-2258.9729000,13.8720000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (4)
	CreateDynamicObject(18762,1946.5119600,-2258.9179700,13.8720000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (5)
	CreateDynamicObject(18762,1946.5119600,-2258.9179700,17.6720000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (6)
	CreateDynamicObject(939,1890.6500200,-2357.6389200,13.6400000,90.0000000,180.0000000,13.9970000); //object(cj_df_unit) (2)
	CreateDynamicObject(18762,1945.6040000,-2250.5258800,17.3720000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (7)
	CreateDynamicObject(18762,1945.6040000,-2250.5258800,12.6220000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (8)
	CreateDynamicObject(18762,1952.6800500,-2251.0148900,24.9970000,0.0000000,0.0000000,358.0000000); //object(concrete1mx1mx5m) (9)
	CreateDynamicObject(18762,1952.6800500,-2251.0148900,20.0720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (10)
	CreateDynamicObject(18762,1952.6800500,-2251.0148900,15.2970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (11)
	CreateDynamicObject(18762,1944.1109600,-2258.7819800,17.6470000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (12)
	CreateDynamicObject(18762,1954.9649700,-2250.9939000,25.1720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (13)
	CreateDynamicObject(18762,1954.9649700,-2250.9929200,20.2720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (14)
	CreateDynamicObject(18762,1954.9649700,-2250.9919400,15.4470000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (15)
	CreateDynamicObject(18762,1960.3649900,-2251.5080600,29.6720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (16)
	CreateDynamicObject(18762,1960.3640100,-2251.5080600,24.8970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (17)
	CreateDynamicObject(18762,1960.3630400,-2251.5080600,20.0470000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (18)
	CreateDynamicObject(18762,1960.3620600,-2251.5080600,15.6970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (19)
	CreateDynamicObject(18762,1960.3609600,-2251.5080600,11.9970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (20)
	CreateDynamicObject(18762,1961.7829600,-2251.3710900,29.6720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (21)
	CreateDynamicObject(18762,1961.7819800,-2251.3710900,24.9220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (22)
	CreateDynamicObject(18762,1961.7810100,-2251.3710900,20.2970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (23)
	CreateDynamicObject(18762,1961.7800300,-2251.3710900,15.4720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (24)
	CreateDynamicObject(18762,1961.7790500,-2251.3710900,10.7220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (25)
	CreateDynamicObject(18762,1962.0799600,-2250.1469700,29.6720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (26)
	CreateDynamicObject(18762,1962.0789800,-2250.1469700,24.8470000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (27)
	CreateDynamicObject(18762,1962.0780000,-2250.1469700,20.0720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (28)
	CreateDynamicObject(18762,1962.0770300,-2250.1469700,15.8220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (29)
	CreateDynamicObject(18762,1962.0760500,-2250.1469700,10.9470000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (30)
	CreateDynamicObject(18762,1961.9539800,-2259.8100600,33.9220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (31)
	CreateDynamicObject(18762,1962.1169400,-2257.1999500,29.2220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (32)
	CreateDynamicObject(18762,1962.1159700,-2257.1989700,24.2970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (33)
	CreateDynamicObject(18762,1962.1149900,-2257.1980000,19.6970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (34)
	CreateDynamicObject(18762,1962.1140100,-2257.1970200,14.8720000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (35)
	CreateDynamicObject(18762,1961.9530000,-2259.8100600,29.0970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (37)
	CreateDynamicObject(18762,1961.9520300,-2259.8100600,24.3220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (38)
	CreateDynamicObject(18762,1961.9510500,-2259.8100600,19.5970000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (39)
	CreateDynamicObject(18762,1961.9499500,-2259.8100600,14.8220000,0.0000000,0.0000000,357.9950000); //object(concrete1mx1mx5m) (40)
	CreateDynamicObject(3117,1965.3029800,-2259.1870100,36.9680000,0.2500000,180.0130000,176.4900000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(3117,1965.4449500,-2257.0720200,36.9680000,0.2470000,180.0110000,176.4850000); //object(a51_ventcoverb) (1)
	CreateDynamicObject(819,1971.8170200,-2063.8740200,13.0240000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass03) (1)
	CreateDynamicObject(820,1968.3990500,-2069.6049800,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (1)
	CreateDynamicObject(819,1967.4580100,-2062.8679200,13.0240000,0.0000000,0.0000000,40.0000000); //object(genveg_tallgrass03) (2)
	CreateDynamicObject(819,1964.3909900,-2067.2060500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (3)
	CreateDynamicObject(819,1954.4260300,-2069.6079100,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (4)
	CreateDynamicObject(819,1960.3520500,-2071.7780800,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (5)
	CreateDynamicObject(819,1967.2580600,-2072.6831100,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (6)
	CreateDynamicObject(819,1956.0780000,-2075.3779300,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (7)
	CreateDynamicObject(819,1960.6619900,-2078.3859900,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (8)
	CreateDynamicObject(819,1957.7840600,-2066.4829100,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (9)
	CreateDynamicObject(819,1964.8669400,-2075.5720200,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (10)
	CreateDynamicObject(819,1964.8662100,-2075.5712900,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (11)
	CreateDynamicObject(819,1968.0500500,-2079.7099600,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (12)
	CreateDynamicObject(819,1962.4759500,-2082.6389200,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (13)
	CreateDynamicObject(819,1952.9610600,-2082.2529300,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (14)
	CreateDynamicObject(819,1951.7010500,-2076.8459500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (15)
	CreateDynamicObject(819,1946.6710200,-2077.6931200,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (16)
	CreateDynamicObject(819,1946.7619600,-2083.5449200,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (17)
	CreateDynamicObject(819,1949.3199500,-2080.4279800,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (18)
	CreateDynamicObject(819,1956.5529800,-2081.1479500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (19)
	CreateDynamicObject(819,1940.7719700,-2074.8559600,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (20)
	CreateDynamicObject(819,1938.9940200,-2081.4209000,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (21)
	CreateDynamicObject(819,1943.1989700,-2079.8168900,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (22)
	CreateDynamicObject(819,1937.2320600,-2075.4008800,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (23)
	CreateDynamicObject(819,1937.6140100,-2086.2270500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (24)
	CreateDynamicObject(819,1945.0699500,-2090.3410600,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (25)
	CreateDynamicObject(819,1954.1619900,-2093.8310500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (26)
	CreateDynamicObject(819,1954.1611300,-2093.8310500,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (27)
	CreateDynamicObject(820,1964.6309800,-2081.4790000,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (2)
	CreateDynamicObject(820,1961.2729500,-2088.1120600,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (3)
	CreateDynamicObject(820,1954.4730200,-2086.4231000,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (4)
	CreateDynamicObject(820,1950.3900100,-2089.0510300,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (5)
	CreateDynamicObject(820,1957.8680400,-2091.8190900,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (6)
	CreateDynamicObject(820,1969.4849900,-2102.6840800,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (7)
	CreateDynamicObject(820,1968.9189500,-2093.2009300,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (8)
	CreateDynamicObject(820,1962.5629900,-2097.6621100,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (9)
	CreateDynamicObject(820,1963.1300000,-2092.1430700,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (10)
	CreateDynamicObject(820,1966.7039800,-2086.7729500,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (11)
	CreateDynamicObject(819,1968.9329800,-2085.4008800,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (28)
	CreateDynamicObject(819,1942.2249800,-2084.9460400,13.0240000,0.0000000,0.0000000,39.9960000); //object(genveg_tallgrass03) (29)
	CreateDynamicObject(820,1938.6960400,-2094.3889200,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (12)
	CreateDynamicObject(820,1949.3230000,-2097.1721200,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (13)
	CreateDynamicObject(820,1952.0629900,-2103.4680200,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (14)
	CreateDynamicObject(820,1944.8909900,-2098.6540500,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (15)
	CreateDynamicObject(820,1944.8906300,-2098.6533200,11.4970000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass04) (16)
 //Santa_maria
 	CreateDynamicObject(971,945.9600220,-1103.3599850,26.7300000,0.0000000,0.0000000,270.6799930); //
	CreateDynamicObject(6300,331.2999880,-2029.4000240,-1.2000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3287,235.8000030,-1823.6999510,7.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,208.1999970,-1819.5000000,9.6000000,8.9980000,0.0000000,90.4940030); //
	CreateDynamicObject(3565,197.1999970,-1781.4000240,4.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8209,212.8999940,-1831.5999760,6.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18260,256.0000000,-1826.6999510,4.4000000,0.0000000,0.0000000,91.0000000); //
	CreateDynamicObject(8874,211.6999970,-1787.6999510,9.8000000,0.0000000,0.0000000,1.9950000); //
	CreateDynamicObject(8873,207.8000030,-1782.6999510,9.0000000,0.0000000,0.0000000,1.7500000); //
	CreateDynamicObject(3268,193.5996090,-1816.7998050,3.1000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(987,263.2001950,-1796.7001950,3.2000000,0.0000000,0.0000000,89.9950030); //
	CreateDynamicObject(987,250.8000030,-1823.4000240,3.2000000,0.0000000,0.0000000,2.9860000); //
	CreateDynamicObject(3397,198.5000000,-1825.9000240,3.1000000,0.0000000,0.0000000,269.7500000); //
	CreateDynamicObject(1348,166.8000030,-1784.1999510,3.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(12986,167.1999970,-1779.5999760,4.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,184.1000060,-1826.0999760,3.2000000,0.0000000,0.0000000,86.0000000); //
	CreateDynamicObject(3387,190.0000000,-1816.5000000,3.3000000,0.0000000,0.0000000,89.4950030); //
	CreateDynamicObject(3384,182.8000030,-1825.6999510,4.6000000,0.0000000,0.0000000,265.9949950); //
	CreateDynamicObject(964,167.5000000,-1785.5000000,3.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3384,181.8000030,-1825.6999510,4.6000000,0.0000000,0.0000000,266.0000000); //
	CreateDynamicObject(3388,183.1000060,-1807.8000490,3.4000000,0.0000000,0.0000000,267.9949950); //
	CreateDynamicObject(934,164.0000000,-1779.9000240,4.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8210,163.3000030,-1804.0000000,5.9000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(1348,168.5000000,-1784.2001950,3.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3388,180.6999970,-1807.6999510,3.4000000,0.0000000,0.0000000,268.0000000); //
	CreateDynamicObject(3388,181.8999940,-1807.8000490,3.4000000,0.0000000,0.0000000,267.9949950); //
	CreateDynamicObject(1278,210.6999970,-1792.0999760,17.6000000,0.0000000,0.0000000,260.0000000); //
	CreateDynamicObject(3387,187.1999970,-1816.5000000,3.3000000,0.0000000,0.0000000,89.4950030); //
	CreateDynamicObject(3397,197.3999940,-1827.6999510,3.0000000,0.0000000,0.0000000,87.7470020); //
	CreateDynamicObject(3287,231.1999970,-1823.5999760,7.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3638,170.6999970,-1814.6999510,6.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1492,206.1000060,-1826.8000490,3.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,194.8000030,-1825.3000490,3.1000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(931,164.8999940,-1784.5000000,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3273,227.1999970,-1825.3000490,3.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1461,367.3999940,-1892.5999760,7.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2228,262.8999940,-1796.4000240,4.0000000,5.7500000,0.0000000,0.0000000); //
	CreateDynamicObject(2991,251.3000030,-1829.6999510,4.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(928,377.8999940,-1719.1999510,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(928,376.0000000,-1716.9000240,6.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,373.7999880,-1880.8000490,7.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3279,258.2001950,-1813.7998050,3.2000000,0.0000000,359.7420040,273.7460020); //
	CreateDynamicObject(987,262.6000060,-1820.0000000,3.2000000,0.0000000,0.0000000,89.9950030); //
	CreateDynamicObject(1492,179.7001950,-1826.7001950,3.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(926,372.7000120,-1718.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.7000120,-1807.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18257,261.0000000,-1823.0000000,2.8000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(926,372.5000000,-1713.8000490,6.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,381.8999940,-1796.6999510,10.1000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,381.8999940,-1796.6999510,8.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,382.1817630,-1796.8869630,7.4438100,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,382.5000000,-1797.3000490,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1338,381.3999940,-1798.5000000,7.5000000,0.0000000,0.0000000,310.0000000); //
	CreateDynamicObject(2672,367.8999940,-1810.0999760,7.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.6000060,-1806.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,383.6000060,-1797.5999760,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1349,381.0000000,-1800.4000240,7.4000000,0.0000000,0.0000000,265.9899900); //
	CreateDynamicObject(2673,371.1000060,-1809.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,383.7999880,-1797.9000240,11.2000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(854,371.8999940,-1726.3000490,6.5000000,0.0000000,0.0000000,260.0000000); //
	CreateDynamicObject(1224,384.1000060,-1797.8000490,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(928,371.8999940,-1715.5999760,6.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,382.8999940,-1799.1999510,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,382.9003910,-1799.2001950,11.1000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(854,371.5000000,-1726.6999510,6.8000000,0.3630000,283.9949950,269.4519960); //
	CreateDynamicObject(854,371.2999880,-1726.8000490,7.3000000,0.3630000,283.9909970,269.4509890); //
	CreateDynamicObject(854,371.2999880,-1725.5999760,6.5000000,0.0000000,0.0000000,259.9970090); //
	CreateDynamicObject(1224,382.8999940,-1799.1999510,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,382.8999940,-1799.1999510,12.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(3502,371.3999940,-1728.1999510,3.9000000,306.7630000,179.1810000,185.3260040); //
	CreateDynamicObject(1224,382.8999940,-1799.1999510,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,384.3999940,-1798.0000000,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,384.6000060,-1798.0999760,12.5000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,384.8999940,-1798.3000490,9.9000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(854,370.8999940,-1726.9000240,6.8000000,0.3630000,283.9909970,269.4509890); //
	CreateDynamicObject(926,371.3999940,-1706.1999510,6.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1349,382.1000060,-1801.0000000,7.4000000,0.0000000,0.0000000,289.9909970); //
	CreateDynamicObject(2673,369.3999940,-1811.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,370.7000120,-1726.0000000,6.5000000,0.0000000,0.0000000,259.9970090); //
	CreateDynamicObject(1224,384.8999940,-1798.5000000,13.7000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,385.2000120,-1798.5999760,11.1000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1431,381.2999880,-1802.4000240,7.4000000,0.0000000,0.0000000,328.0000000); //
	CreateDynamicObject(1224,384.3999940,-1799.5999760,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(928,370.3999940,-1720.0999760,6.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,386.8999940,-1797.5000000,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,385.7000120,-1798.8000490,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,385.7000120,-1798.8000490,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(2672,372.1000060,-1810.8000490,7.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,384.5000000,-1800.0000000,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,385.7000120,-1799.0999760,12.3000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1349,383.7000120,-1801.3000490,7.5000000,0.0000000,284.0000000,327.9849850); //
	CreateDynamicObject(1224,386.1000060,-1799.1999510,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,381.2000120,-1803.9000240,7.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(928,370.1000060,-1703.8000490,6.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(926,369.2000120,-1715.5000000,6.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(926,369.0000000,-1702.3000490,6.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(926,368.3999940,-1705.8000490,6.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(926,367.7999880,-1718.5999760,6.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,386.1000060,-1799.3000490,13.5000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1349,383.3999940,-1802.3000490,7.4000000,0.0000000,0.0000000,327.9909970); //
	CreateDynamicObject(1224,386.3999940,-1799.5000000,11.1000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(2673,367.7000120,-1815.6999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,386.6000060,-1799.9000240,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,386.7000120,-1799.8000490,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(2673,371.7000120,-1813.0999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,379.1000060,-1807.1999510,7.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1441,366.8999940,-1710.8000490,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1431,382.6000060,-1804.1999510,7.4000000,0.0000000,0.0000000,285.9970090); //
	CreateDynamicObject(1224,387.0000000,-1800.0999760,12.3000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.0000000,-1800.4000240,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1773,372.0000000,-1765.0000000,5.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,8.4000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(928,366.6000060,-1703.9000240,6.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.0000000,-1815.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(928,366.6000060,-1701.8000490,6.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1349,385.5000000,-1802.4000240,7.6000000,311.3970030,297.2789920,180.4859920); //
	CreateDynamicObject(1224,387.5000000,-1800.5999760,11.0000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.3999940,-1800.8000490,13.5000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.6000060,-1800.9000240,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,388.5000000,-1800.1999510,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.2000120,-1801.5000000,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.8999940,-1801.4000240,12.2000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,388.1000060,-1801.5000000,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1358,385.6000060,-1804.4000240,8.0000000,0.0000000,0.0000000,334.0000000); //
	CreateDynamicObject(1431,384.2000120,-1805.8000490,7.4000000,0.0000000,0.0000000,329.9960020); //
	CreateDynamicObject(928,366.1000060,-1700.3000490,6.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,388.2999880,-1802.0000000,11.0000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,387.5000000,-1802.8000490,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,388.6000060,-1801.9000240,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(928,364.2999880,-1718.0000000,6.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(928,364.2000120,-1714.4000240,6.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,388.7999880,-1801.6999510,13.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,388.2999880,-1803.3000490,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(2673,368.6000060,-1819.9000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,389.2999880,-1802.5999760,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,389.3999940,-1802.5000000,12.2000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,390.0000000,-1802.1999510,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,389.7000120,-1802.6999510,11.0000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1733,368.0000000,-1769.0000000,5.0000000,0.0000000,0.0000000,80.0000000); //
	CreateDynamicObject(1224,389.7999880,-1803.0000000,13.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1439,361.2999880,-1739.9000240,5.4000000,0.0000000,0.0000000,266.0000000); //
	CreateDynamicObject(854,360.0000000,-1735.8000490,5.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,360.7000120,-1743.6999510,5.2000000,0.0000000,0.0000000,290.7500000); //
	CreateDynamicObject(854,360.6000060,-1744.6999510,5.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,359.7000120,-1736.6999510,5.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3502,359.6000060,-1736.4000240,1.4000000,272.0520020,13.8530000,257.8269960); //
	CreateDynamicObject(854,359.2999880,-1735.9000240,5.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,389.7999880,-1803.4000240,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(854,360.0000000,-1743.4000240,5.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(852,360.7000120,-1748.5000000,5.0000000,0.0000000,0.0000000,235.9949950); //
	CreateDynamicObject(1431,386.2000120,-1806.8000490,7.4000000,0.0000000,0.0000000,338.2409970); //
	CreateDynamicObject(854,360.2000120,-1745.3000490,5.2000000,0.0000000,0.0000000,302.7449950); //
	CreateDynamicObject(854,359.2000120,-1736.4000240,5.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,360.0000000,-1744.3000490,5.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,360.0000000,-1745.0000000,5.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(849,359.7999880,-1744.5000000,5.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(854,359.6000060,-1743.5000000,5.1000000,0.0000000,0.0000000,302.7479860); //
	CreateDynamicObject(852,360.0000000,-1747.6999510,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3502,359.7998050,-1744.5996090,1.0000000,272.8290100,314.7470090,198.7649990); //
	CreateDynamicObject(854,359.5000000,-1744.8000490,5.2000000,0.0000000,0.0000000,302.7449950); //
	CreateDynamicObject(854,359.3999940,-1744.1999510,5.2000000,0.0000000,0.0000000,302.7449950); //
	CreateDynamicObject(3502,360.1000060,-1748.5999760,1.0000000,272.8290100,314.7470090,198.7649990); //
	CreateDynamicObject(852,359.3999940,-1748.5000000,5.0000000,0.0000000,0.0000000,86.0000000); //
	CreateDynamicObject(853,356.7999880,-1732.1999510,5.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2926,360.8999940,-1769.5999760,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,385.4003910,-1808.0996090,7.4000000,0.0000000,0.0000000,339.9989930); //
	CreateDynamicObject(3302,362.7000120,-1783.9000240,4.5000000,0.0000000,0.0000000,78.0000000); //
	CreateDynamicObject(1338,388.6000060,-1805.1999510,7.5000000,0.0000000,0.0000000,329.9960020); //
	CreateDynamicObject(1224,390.2999880,-1803.8000490,12.2000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,390.1000060,-1804.1999510,9.8000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1343,388.0000000,-1806.1999510,7.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1224,390.2999880,-1804.3000490,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,390.5000000,-1804.3000490,11.0000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,390.3999940,-1804.9000240,8.6000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,382.0000000,-1813.0000000,7.4000000,0.0000000,0.0000000,316.0000000); //
	CreateDynamicObject(1224,391.7999880,-1805.3000490,7.4000000,0.0000000,0.0000000,306.0000000); //
	CreateDynamicObject(2673,368.2000120,-1825.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.6000060,-1823.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(851,384.8999940,-1814.1999510,7.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,367.7999880,-1828.9000240,7.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.8999940,-1827.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.5000000,-1834.1999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.7999880,-1843.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.0000000,-1842.1999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,369.7000120,-1844.6999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.2000120,-1844.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,367.0000000,-1850.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.2999880,-1839.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.2000120,-1837.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.3999940,-1834.0999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.2000120,-1837.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.3999940,-1840.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.2999880,-1840.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,367.6000060,-1842.5999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1349,353.5000000,-1776.3000490,4.6000000,0.0000000,0.0000000,19.9979990); //
	CreateDynamicObject(850,352.5000000,-1774.5000000,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(851,353.5000000,-1779.8000490,4.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,369.5000000,-1842.5999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,372.6000060,-1840.6999510,7.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1349,350.0000000,-1779.0000000,4.8000000,0.0000000,0.0000000,327.9949950); //
	CreateDynamicObject(2673,369.7000120,-1842.9000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.2999880,-1846.6999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(849,343.5000000,-1770.0999760,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(981,347.0996090,-1781.5000000,5.1000000,0.0000000,0.5000000,149.9960020); //
	CreateDynamicObject(1349,344.2000120,-1772.6999510,4.6000000,0.0000000,0.0000000,54.0000000); //
	CreateDynamicObject(1411,297.2999880,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,281.0000000,-1808.5000000,5.0000000,0.0000000,0.0000000,179.2469940); //
	CreateDynamicObject(1448,342.2999880,-1775.4000240,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(853,310.7999880,-1803.1999510,3.9000000,0.0000000,0.0000000,72.0000000); //
	CreateDynamicObject(1349,339.7999880,-1774.1999510,4.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3643,357.1000060,-1856.5999760,7.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(851,371.3999940,-1846.4000240,7.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,367.7000120,-1852.9000240,7.0000000,0.0000000,0.0000000,292.0000000); //
	CreateDynamicObject(2672,371.8999940,-1853.1999510,7.0000000,0.0000000,0.0000000,359.9949950); //
	CreateDynamicObject(2971,331.2999880,-1771.0000000,3.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3005,331.7999880,-1774.4000240,4.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,270.6000060,-1808.1999510,5.0000000,0.0000000,0.0000000,179.2469940); //
	CreateDynamicObject(2060,262.5000000,-1796.0999760,3.6000000,0.0000000,0.0000000,8.9960000); //
	CreateDynamicObject(2673,373.1000060,-1846.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.5000000,-1849.1999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.0000000,-1850.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,367.2999880,-1861.3000490,7.0000000,0.0000000,0.0000000,59.9910010); //
	CreateDynamicObject(852,325.2999880,-1806.1999510,3.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3097,320.7999880,-1759.3000490,6.7000000,0.0000000,0.0000000,359.0000000); //
	CreateDynamicObject(3097,322.7000120,-1768.5000000,6.7000000,0.0000000,0.0000000,180.9940030); //
	CreateDynamicObject(3097,321.9003910,-1768.2001950,6.7000000,0.0000000,0.0000000,180.9940030); //
	CreateDynamicObject(2672,371.5000000,-1858.4000240,7.0000000,0.0000000,0.0000000,59.9949990); //
	CreateDynamicObject(3097,320.7000120,-1768.1999510,6.7000000,0.0000000,0.0000000,180.9940030); //
	CreateDynamicObject(911,318.0000000,-1770.4000240,4.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2991,251.3000030,-1829.6999510,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,316.5000000,-1796.0000000,4.3000000,0.0000000,0.0000000,28.0000000); //
	CreateDynamicObject(2673,370.7000120,-1861.5999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(987,240.5000000,-1817.4000240,3.2000000,0.0000000,359.7500000,330.2300110); //
	CreateDynamicObject(2673,368.7000120,-1864.5000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.5000000,-1864.0999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,369.8999940,-1867.5999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,361.2999880,-1873.0999760,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,363.6000060,-1872.3000490,7.2000000,0.0000000,0.0000000,37.9900020); //
	CreateDynamicObject(2672,368.2999880,-1869.9000240,7.1000000,357.9899900,0.0000000,17.9610000); //
	CreateDynamicObject(2672,371.3999940,-1869.4000240,7.0000000,0.0000000,0.0000000,109.9909970); //
	CreateDynamicObject(2673,369.6000060,-1871.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.3999940,-1872.9000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.2000120,-1871.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,367.2000120,-1874.5000000,7.1000000,357.9899900,0.0000000,23.9610000); //
	CreateDynamicObject(2674,369.3999940,-1873.1999510,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.8999940,-1871.1999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.0000000,-1874.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,363.5000000,-1877.9000240,7.2000000,0.0000000,0.0000000,81.9850010); //
	CreateDynamicObject(943,362.0000000,-1879.0000000,7.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.7000120,-1873.3000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,369.8999940,-1875.4000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(16088,370.1000060,-1876.1999510,6.2000000,0.0000000,0.0000000,89.2500000); //
	CreateDynamicObject(1411,292.1000060,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2674,367.7999880,-1877.5000000,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.8999940,-1874.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2674,366.7999880,-1878.4000240,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,364.1000060,-1880.3000490,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,362.7999880,-1881.0999760,7.2000000,0.0000000,0.0000000,21.9800000); //
	CreateDynamicObject(2673,371.2999880,-1876.6999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,373.2999880,-1875.9000240,7.1000000,357.9949950,0.0000000,23.9629990); //
	CreateDynamicObject(8875,363.2999880,-1881.3000490,12.9000000,0.0000000,0.0000000,236.0000000); //
	CreateDynamicObject(2673,369.2999880,-1878.6999510,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2674,369.3999940,-1878.9000240,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,371.2999880,-1878.0999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,367.5000000,-1880.3000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,296.6000060,-1808.8000490,5.0000000,0.0000000,0.0000000,179.2420040); //
	CreateDynamicObject(2673,363.2999880,-1882.8000490,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,193.8000030,-1825.1999510,3.1000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(2673,370.6000060,-1879.0999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,361.7000120,-1884.3000490,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,286.9003910,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,291.3999940,-1808.6999510,5.0000000,0.0000000,0.0000000,179.2420040); //
	CreateDynamicObject(1411,281.7000120,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3864,278.8999940,-1793.3000490,9.4000000,0.0000000,0.0000000,145.9870000); //
	CreateDynamicObject(2673,369.2999880,-1880.5999760,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,372.6000060,-1879.0999760,7.1000000,358.0000000,0.0000000,329.9689940); //
	CreateDynamicObject(2673,370.7000120,-1880.3000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,368.2000120,-1881.9000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,286.2001950,-1808.5996090,5.0000000,0.0000000,0.0000000,179.2420040); //
	CreateDynamicObject(2673,372.2000120,-1879.8000490,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,364.2000120,-1884.4000240,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(933,366.2000120,-1883.4000240,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,370.2999880,-1882.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,372.3999940,-1880.9000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,367.2999880,-1884.0000000,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,276.5000000,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(933,368.1000060,-1883.8000490,7.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(987,250.3999940,-1810.5999760,3.2000000,0.0000000,0.0000000,214.9859920); //
	CreateDynamicObject(933,368.1000060,-1883.9000240,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,362.2000120,-1887.0000000,7.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,372.8999940,-1882.0000000,7.0000000,0.0000000,0.0000000,329.9719850); //
	CreateDynamicObject(3594,362.2999880,-1887.5999760,8.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,363.6000060,-1887.5000000,7.2000000,0.0000000,0.0000000,93.9779970); //
	CreateDynamicObject(1411,271.2999880,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3864,279.2999880,-1811.9000240,9.4000000,0.0000000,0.0000000,231.9900050); //
	CreateDynamicObject(987,263.2999880,-1784.5000000,3.2000000,0.0000000,0.0000000,179.9989930); //
	CreateDynamicObject(1411,275.7999880,-1808.3000490,5.0000000,0.0000000,0.0000000,179.2420040); //
	CreateDynamicObject(2673,372.0000000,-1883.4000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,364.7999880,-1887.5000000,7.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1411,266.0000000,-1796.5000000,5.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2673,369.6000060,-1885.4000240,6.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2674,370.8999940,-1884.6999510,6.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,364.8999940,-1887.9000240,8.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,194.6999970,-1826.1999510,3.1000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(2060,263.2000120,-1797.4000240,4.1000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1797.3000490,4.2000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1797.3000490,3.9000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1797.4000240,3.6000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,262.8999940,-1797.3000490,4.4000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.0000000,-1797.5000000,3.8000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,262.2999880,-1796.4000240,3.8000000,0.0000000,0.0000000,84.9919970); //
	CreateDynamicObject(2060,263.1000060,-1798.1999510,4.1000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1798.3000490,4.4000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1798.3000490,4.2000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1798.3000490,3.9000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1798.3000490,3.8000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,262.2999880,-1797.0000000,3.6000000,0.0000000,0.0000000,108.0000000); //
	CreateDynamicObject(2060,263.1000060,-1798.5000000,3.6000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(8874,268.3999940,-1807.0000000,10.3000000,0.0000000,0.0000000,112.0000000); //
	CreateDynamicObject(3279,257.7998050,-1789.7001950,3.3000000,0.0000000,359.7420040,183.7409970); //
	CreateDynamicObject(2060,263.1000060,-1799.1999510,3.9000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1799.1999510,3.8000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1799.3000490,4.2000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1799.3000490,4.1000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.0000000,-1799.4003910,4.4000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1799.5000000,3.6000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1800.1999510,4.2000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1800.1999510,4.1000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1800.1999510,3.9000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1800.1999510,3.8000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.1000060,-1800.1999510,3.6000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(2060,263.0000000,-1800.1999510,4.4000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(8874,263.2999880,-1801.1999510,10.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2036,262.3999940,-1800.3000490,4.0000000,0.7480000,306.7430110,1.0020000); //
	CreateDynamicObject(8873,259.6000060,-1796.0999760,9.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2043,261.8999940,-1801.5999760,3.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2358,262.2999880,-1802.5999760,3.8000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(2358,262.2999880,-1802.5999760,3.6000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(987,251.6000060,-1784.4000240,3.2000000,0.0000000,0.0000000,137.2449950); //
	CreateDynamicObject(1411,265.3999940,-1808.0999760,5.0000000,0.0000000,0.0000000,179.2500000); //
	CreateDynamicObject(2358,262.2999880,-1803.5000000,3.8000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(2358,262.2999880,-1803.5000000,3.6000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(985,263.0000000,-1804.7001950,5.2000000,0.0000000,0.0000000,268.7479860); //
	CreateDynamicObject(2358,262.2999880,-1804.4000240,3.8000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(2358,262.2999880,-1804.4000240,3.6000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3015,262.2999880,-1805.0000000,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3014,262.2999880,-1805.5000000,3.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3013,262.2999880,-1806.0000000,3.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8873,265.2999880,-1812.3000490,9.5000000,0.0000000,0.0000000,108.0000000); //
	CreateDynamicObject(987,262.7000120,-1808.4000240,3.2000000,0.0000000,0.0000000,178.9900050); //
	CreateDynamicObject(987,251.5000000,-1794.3000490,3.2000000,0.0000000,0.0000000,3.9950000); //
	CreateDynamicObject(3388,179.3999940,-1808.1999510,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,365.0000000,-1888.4000240,9.8000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(3594,367.4003910,-1888.2001950,7.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2672,367.2000120,-1888.5999760,7.0000000,0.0000000,0.0000000,1.9750000); //
	CreateDynamicObject(2673,363.2999880,-1890.9000240,6.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,367.6000060,-1889.0000000,8.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3387,185.3999940,-1816.5000000,3.3000000,0.0000000,0.0000000,89.5000000); //
	CreateDynamicObject(3390,194.2851560,-1826.7060550,3.1494700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,255.1000060,-1821.6999510,4.8000000,0.0000000,0.0000000,76.0000000); //
	CreateDynamicObject(3386,193.6999970,-1826.1999510,3.1000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(987,262.5996090,-1831.7998050,3.2000000,0.0000000,0.0000000,89.9950030); //
	CreateDynamicObject(3386,194.6000060,-1827.1999510,3.1000000,0.0000000,0.0000000,263.9899900); //
	CreateDynamicObject(2912,256.7000120,-1825.8000490,4.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3388,179.3999940,-1809.3000490,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3638,171.1999970,-1798.4000240,6.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8209,212.8999940,-1776.4000240,5.9000000,0.0000000,0.0000000,180.0000000); //
	CreateDynamicObject(3386,193.6999970,-1827.3000490,3.1000000,0.0000000,0.0000000,263.9949950); //
	CreateDynamicObject(3287,223.5000000,-1823.5999760,7.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(7096,214.3999940,-1815.8000490,7.6000000,0.0000000,0.0000000,269.7500000); //
	CreateDynamicObject(3397,207.8000030,-1808.6999510,3.5000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1242,208.3000030,-1809.5999760,4.6000000,28.0000000,0.0000000,84.0000000); //
	CreateDynamicObject(2669,191.5000000,-1780.0000000,4.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1212,208.0000000,-1810.0999760,4.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2036,207.8000030,-1809.9000240,4.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1550,207.8999940,-1810.5999760,3.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3397,205.7001950,-1807.5000000,3.5000000,0.0000000,0.0000000,89.2470020); //
	CreateDynamicObject(925,189.0000000,-1781.3000490,3.8000000,0.0000000,0.0000000,90.7450030); //
	CreateDynamicObject(3389,207.6999970,-1814.9000240,3.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,208.1999970,-1816.6999510,9.6000000,8.9980000,0.0000000,90.4940030); //
	CreateDynamicObject(3389,207.6999970,-1815.9000240,3.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,208.1999970,-1817.4000240,9.6000000,8.9980000,0.0000000,90.4940030); //
	CreateDynamicObject(3389,207.6999970,-1816.9000240,3.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,208.1999970,-1818.0999760,9.6000000,8.9980000,0.0000000,90.4940030); //
	CreateDynamicObject(3389,207.6999970,-1817.9000240,3.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2912,208.1999970,-1818.8000490,9.6000000,9.0000000,0.0000000,90.4980010); //
	CreateDynamicObject(3386,194.0000000,-1827.5999760,6.1000000,0.0000000,0.0000000,263.9899900); //
	CreateDynamicObject(3386,194.5000000,-1828.1999510,3.1000000,0.0000000,0.0000000,263.9899900); //
	CreateDynamicObject(3388,179.3999940,-1810.4000240,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(925,164.4003910,-1787.7001950,4.2000000,0.0000000,0.0000000,87.9950030); //
	CreateDynamicObject(3387,183.5000000,-1816.5000000,3.3000000,0.0000000,0.0000000,89.4950030); //
	CreateDynamicObject(3388,179.3999940,-1811.5000000,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,193.6000060,-1828.3000490,3.1000000,0.0000000,0.0000000,263.9899900); //
	CreateDynamicObject(2977,164.6000060,-1789.6999510,3.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,190.6999970,-1826.0999760,3.2000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(3388,179.3999940,-1812.5999760,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2977,164.6000060,-1791.0000000,3.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3388,179.3999940,-1813.6999510,3.4000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3386,188.5000000,-1826.1999510,3.2000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(3386,186.0000000,-1826.0999760,3.2000000,0.0000000,0.0000000,85.9950030); //
	CreateDynamicObject(3593,365.7000120,-1894.4000240,7.4000000,0.0000000,0.0000000,267.9960020); //
	CreateDynamicObject(2672,361.3999940,-1896.6999510,7.2000000,0.0000000,0.0000000,55.9770010); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-59.7999990,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(4246,239.2001950,-1906.2998050,-99.8000030,89.2470020,0.0000000,168.2449950); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,1.4000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(4246,248.1999970,-1978.5999760,-0.6000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,15.6000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-5.6000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-12.8000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,22.4000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0996090,22.4000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-19.2999990,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,29.1000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-25.7999990,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-32.5000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-39.0000000,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-45.7999990,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-52.7999990,0.0000000,0.2470000,349.9800110); //
	CreateDynamicObject(8148,34.0000000,-1787.0999760,-66.8000030,0.0000000,0.2470000,349.9800110); //
  ///objects
  	CreateDynamicObject(971,945.9600220,-1103.3599850,26.7300000,0.0000000,0.0000000,270.6799930); //
	CreateDynamicObject(6300,331.2999880,-2029.4000240,-1.2000000,0.0000000,0.0000000,270.0000000); //
	CreateDynamicObject(9833,2575.5000000,-1511.8000490,17.7000010,0.0000000,58.0000000,356.0000000); //
	CreateDynamicObject(3502,2580.0000000,-1512.1999510,19.5000000,4.7500000,0.0000000,271.9899900); //
	CreateDynamicObject(1654,2649.0000000,-1709.5000000,10.0000000,277.2019960,56.4090000,81.1999970); //
	CreateDynamicObject(1362,2483.1999510,-1654.8000490,12.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1654,2649.8000490,-1708.8000490,10.0000000,277.2019960,56.4090000,81.2020030); //
	CreateDynamicObject(3594,2322.6999510,-1664.6999510,13.6000000,0.0000000,357.9899900,215.9920040); //
	CreateDynamicObject(3594,2322.6999510,-1664.6999510,13.6000000,0.0000000,357.9899900,215.9920040); //
	CreateDynamicObject(1654,2649.3000490,-1710.5999760,10.0000000,277.2019960,56.4259990,18.2140010); //
	CreateDynamicObject(1654,2649.3999020,-1711.0999760,10.0000000,277.2019960,56.4199980,352.2099910); //
	CreateDynamicObject(3594,2472.3999020,-1656.5000000,13.0000000,0.0000000,357.9899900,281.9920040); //
	CreateDynamicObject(1582,2650.1000980,-1709.5999760,10.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,2482.1000980,-1683.0000000,13.1000000,0.0000000,0.0000000,323.9979860); //
	CreateDynamicObject(3594,2478.6999510,-1616.5999760,16.0000000,0.0000000,0.0000000,133.9940030); //
	CreateDynamicObject(1226,2472.1999510,-1723.9000240,14.0000000,294.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(12954,2479.5000000,-1701.5999760,13.1000000,0.0000000,0.0000000,356.4949950); //
	CreateDynamicObject(3594,2485.0000000,-1602.4000240,16.0000000,0.0000000,0.0000000,79.9889980); //
	CreateDynamicObject(17034,2662.3999020,-1750.3000490,9.7000000,0.0000000,0.0000000,332.0000000); //
	CreateDynamicObject(1654,2649.6999510,-1711.8000490,10.0000000,277.2070010,56.4280010,294.2189940); //
	CreateDynamicObject(1654,2650.3000490,-1710.5000000,10.0000000,277.2019960,56.4150010,339.2049870); //
	CreateDynamicObject(1654,2650.6999510,-1711.6999510,10.0000000,277.2019960,56.4090000,29.2029990); //
	CreateDynamicObject(17034,2668.8000490,-1671.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,2291.8999020,-1680.6999510,14.0000000,1.9940000,1.9810000,67.9170000); //
	CreateDynamicObject(3594,2291.8999020,-1680.6999510,14.0000000,1.9940000,1.9810000,67.9170000); //
	CreateDynamicObject(3594,2290.6000980,-1671.6999510,14.7000000,358.0050050,3.9860000,216.1300050); //
	CreateDynamicObject(3594,2290.6000980,-1671.6999510,14.7000000,358.0050050,3.9860000,216.1300050); //
	CreateDynamicObject(3593,2338.5000000,-1620.0000000,18.7999990,12.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,2338.5000000,-1620.0000000,18.7999990,12.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,2312.8999020,-1728.5999760,13.1000000,0.0000000,357.9790040,41.9809990); //
	CreateDynamicObject(3594,2348.2001950,-1653.0000000,13.1000000,0.0000000,357.9790040,77.9810030); //
	CreateDynamicObject(3594,2348.2001950,-1653.0000000,13.1000000,0.0000000,357.9790040,77.9810030); //
	CreateDynamicObject(3594,2338.6999510,-1709.5000000,13.1000000,0.0000000,357.9790040,77.9810030); //
	CreateDynamicObject(3593,2344.8000490,-1573.3000490,23.2999990,359.9970090,0.0000000,26.0000000); //
	CreateDynamicObject(3593,2344.8000490,-1573.3000490,23.2999990,359.9970090,0.0000000,26.0000000); //
	CreateDynamicObject(7091,2351.8000490,-1599.1999510,20.7000010,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,2376.8999020,-1638.4000240,13.1000000,0.0000000,357.9899900,235.9870000); //
	CreateDynamicObject(3593,2358.0000000,-1753.5000000,13.1000000,0.0000000,0.0000000,237.9909970); //
	CreateDynamicObject(3594,2389.5000000,-1667.6999510,13.6000000,0.0000000,331.9899900,274.4870000); //
	CreateDynamicObject(3864,2414.2001950,-1656.2001950,18.5000000,0.0000000,0.0000000,33.9970020); //
	CreateDynamicObject(3594,2420.2001950,-1654.4003910,13.1000000,0.0000000,357.9899900,209.9870000); //
	CreateDynamicObject(3593,2420.6000980,-1686.0999760,13.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18568,2424.3000490,-1646.9000240,13.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18569,2427.7998050,-1640.2998050,13.8000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,2423.8999020,-1605.0999760,12.6000000,0.0000000,358.0000000,0.0000000); //
	CreateDynamicObject(18451,2431.1005860,-1652.7998050,13.1000000,0.0000000,0.0000000,301.9979860); //
	CreateDynamicObject(1238,2434.8000490,-1654.5000000,12.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1238,2435.3999020,-1663.0000000,12.7000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,2436.2998050,-1669.0996090,13.2000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1440,2437.1999510,-1631.0999760,12.9000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1347,2438.5000000,-1634.6999510,13.0000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1439,2438.6999510,-1633.0999760,12.4000000,0.0000000,0.0000000,271.0000000); //
	CreateDynamicObject(973,2440.0000000,-1654.8000490,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(973,2440.8999020,-1662.6999510,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,2443.1999510,-1645.0999760,13.1000000,0.0000000,357.9899900,37.9910010); //
	CreateDynamicObject(3593,2437.0000000,-1725.0999760,13.1000000,0.0000000,0.0000000,237.9940030); //
	CreateDynamicObject(973,2450.1000980,-1654.8000490,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(973,2450.6999510,-1662.6999510,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3594,2453.7998050,-1672.0000000,13.1000000,0.0000000,357.9899900,37.9910010); //
	CreateDynamicObject(12957,2452.3000490,-1621.1999510,14.5000000,352.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(1362,2457.3999020,-1677.5000000,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3593,2409.6000980,-1788.5999760,13.1000000,0.0000000,0.0000000,335.9909970); //
	CreateDynamicObject(12957,2460.1999510,-1665.0999760,13.3000000,0.0000000,0.0000000,90.0000000); //
	CreateDynamicObject(973,2460.3000490,-1662.5999760,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(973,2460.3999020,-1654.9000240,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3578,2466.6999510,-1654.3000490,13.1000000,0.0000000,0.0000000,272.0000000); //
	CreateDynamicObject(2985,2466.8000490,-1655.0999760,13.9000000,0.0000000,0.0000000,188.0000000); //
	CreateDynamicObject(2985,2466.8999020,-1658.9000240,13.9000000,0.0000000,0.0000000,181.9980010); //
	CreateDynamicObject(4526,2473.0000000,-1676.4000240,14.3000000,0.0000000,0.0000000,249.0000000); //
	CreateDynamicObject(2062,2476.6999510,-1723.0999760,13.1000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18451,2489.3000490,-1613.4000240,15.9000000,0.0000000,0.0000000,301.9979860); //
	CreateDynamicObject(3461,2491.6005860,-1691.5996090,17.5000000,287.9960020,0.0000000,3.9940000); //
	CreateDynamicObject(3593,2481.6999510,-1728.0000000,13.1000000,0.0000000,0.0000000,295.9979860); //
	CreateDynamicObject(3461,2497.3000490,-1691.5000000,17.5000000,288.0000000,0.0000000,16.0000000); //
	CreateDynamicObject(3594,2501.6000980,-1650.5999760,13.4000000,0.0000000,0.0000000,25.9939990); //
	CreateDynamicObject(12957,2505.1999510,-1665.8000490,13.3000000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1306,2493.0000000,-1727.5000000,15.8000000,301.8060000,3.7970000,2.9780000); //
	CreateDynamicObject(3864,2505.5000000,-1684.5000000,18.6000000,0.0000000,0.0000000,317.9939880); //
	CreateDynamicObject(3594,2504.1999510,-1619.6999510,17.0000000,358.0010070,357.9989930,79.9160000); //
	CreateDynamicObject(3594,2511.0000000,-1669.4000240,13.1000000,0.0000000,358.0000000,281.9939880); //
	CreateDynamicObject(14467,2527.8000490,-1665.9000240,16.9000000,0.0000000,328.0000000,266.0000000); //
	CreateDynamicObject(3594,2525.0000000,-1712.6999510,13.5000000,349.7500000,359.9890140,177.9880070); //
	CreateDynamicObject(3594,2527.6000980,-1709.8000490,13.1000000,0.0000000,357.9949950,267.9920040); //

		//HIVE2
	CreateDynamicObject(13608, 1397.38965, -1456.66992, 1734.01294, 0.00, 0.00, 0.00); // объект 0
	CreateDynamicObject(13608, 1397.46204, -1456.68994, 1720.13501, 359.75, 179.75, 359.999); // объект 1
	CreateDynamicObject(17453, 1380.10706, -1486.75598, 1722.71899, 0.00, 0.00, 204); // объект 2
	CreateDynamicObject(17453, 1418.00696, -1427.75, 1722.71899, 0.00, 0.00, 26); // объект 3
	CreateDynamicObject(16532, 1381.55957, -1457.23633, 1724.28601, 0.00, 0.00, 0.00); // объект 4
	CreateDynamicObject(16532, 1442.48999, -1452.18506, 1724.28796, 359, 0.25, 358.754); // объект 5
	CreateDynamicObject(16532, 1519.71802, -1459.33997, 1724.28796, 358.995, 0.247, 178.503); // объект 6
	CreateDynamicObject(16532, 1353.33801, -1504.03503, 1722.58398, 1.499, 357.749, 85.809); // объект 7
	CreateDynamicObject(16532, 1381.71997, -1436.828, 1723.56006, 1.244, 2.249, 85.701); // объект 8
	CreateDynamicObject(16532, 1409.9668, -1389.74805, 1722.45898, 6.982, 2.258, 359.467); // объект 9
	CreateDynamicObject(1383, 1421.16296, -1431.24902, 1752.948, 0.00, 0.00, 0.00); // объект 10
	CreateDynamicObject(1383, 1375.39746, -1429.45312, 1751.82202, 0.00, 0.00, 0.00); // объект 11
	CreateDynamicObject(1383, 1411.91296, -1485.85999, 1752.84802, 0.00, 0.00, 8); // объект 12
	CreateDynamicObject(1383, 1369.83704, -1475.80505, 1751.849, 0.00, 0.00, 7.998); // объект 13
	CreateDynamicObject(849, 1364.31897, -1439.60803, 1720.71704, 0.00, 0.00, 0.00); // объект 14
	CreateDynamicObject(849, 1365.05103, -1440.62097, 1720.71704, 0.00, 0.00, 84); // объект 15
	CreateDynamicObject(849, 1363.33899, -1441.23999, 1720.71704, 0.00, 0.00, 83.996); // объект 16
	CreateDynamicObject(849, 1362.37, -1439.47205, 1720.71704, 0.00, 0.00, 27.996); // объект 17
	CreateDynamicObject(849, 1363.73206, -1438.79504, 1720.71704, 0.00, 0.00, 27.993); // объект 18
	CreateDynamicObject(851, 1366.06201, -1438.05603, 1720.70605, 0.00, 359.75, 0.00); // объект 19
	CreateDynamicObject(851, 1364.71802, -1436.83704, 1720.70605, 0.00, 357.747, 34); // объект 20
	CreateDynamicObject(851, 1363.26501, -1436.96106, 1720.70605, 0.00, 357.742, 317.997); // объект 21
	CreateDynamicObject(16305, 1388.6377, -1485.33984, 1722.875, 0.00, 0.00, 0.00); // объект 22
	CreateDynamicObject(16317, 1387.14099, -1515.70801, 1717.09094, 0.00, 0.00, 0.00); // объект 23
	CreateDynamicObject(16317, 1413.60803, -1503.61597, 1717.09094, 0.00, 0.00, 0.00); // объект 24
	CreateDynamicObject(16317, 1370.93506, -1494.93994, 1717.09094, 0.00, 0.00, 0.00); // объект 25
	CreateDynamicObject(16317, 1345.97852, -1491.27637, 1717.09094, 0.00, 0.00, 0.00); // объект 26
	CreateDynamicObject(16317, 1349.81702, -1469.01904, 1717.09094, 0.00, 0.00, 48); // объект 27
	CreateDynamicObject(16317, 1311.9873, -1458.89844, 1717.09094, 0.00, 0.00, 109.995); // объект 28
	CreateDynamicObject(16317, 1339.46497, -1439.91296, 1717.09094, 0.00, 0.00, 143.995); // объект 29
	CreateDynamicObject(16317, 1333.58398, -1460.28601, 1717.09094, 0.00, 0.00, 143.992); // объект 30
	CreateDynamicObject(16317, 1333.88, -1422.36597, 1718.34094, 0.00, 0.00, 143.992); // объект 31
	CreateDynamicObject(16317, 1373.07605, -1418.93701, 1718.34094, 0.00, 0.00, 143.992); // объект 32
	CreateDynamicObject(16317, 1368.31897, -1393.42505, 1718.34094, 0.00, 0.00, 143.992); // объект 33
	CreateDynamicObject(16317, 1400.71387, -1407.62598, 1716.84094, 0.00, 0.00, 143.987); // объект 34
	CreateDynamicObject(16317, 1398.97302, -1403.75, 1716.84094, 0.00, 0.00, 175.992); // объект 35
	CreateDynamicObject(16317, 1395.53894, -1408.30701, 1716.84094, 0.00, 0.00, 175.99); // объект 36
	CreateDynamicObject(16317, 1427.03503, -1419.89697, 1718.09094, 0.00, 0.00, 175.99); // объект 37
	CreateDynamicObject(16317, 1452.69995, -1442.82703, 1717.91602, 0.00, 0.00, 175.99); // объект 38
	CreateDynamicObject(16317, 1447.78198, -1479.14697, 1718.09094, 0.00, 3.75, 251.99); // объект 39
	CreateDynamicObject(16317, 1471.53796, -1488.39795, 1718.09094, 0.00, 3.746, 307.988); // объект 40
	CreateDynamicObject(16317, 1427.43994, -1520.04102, 1718.09094, 0.00, 4.991, 307.985); // объект 41
	CreateDynamicObject(16317, 1473.25195, -1460.97595, 1718.71704, 0.00, 0.00, 175.99); // объект 42
	CreateDynamicObject(16317, 1423.33398, -1436.85803, 1720.24304, 0.00, 0.00, 175.99); // объект 43
	CreateDynamicObject(3675, 1377.96497, -1392.66199, 1723.03601, 312.073, 355.894, 356.95); // объект 44
	CreateDynamicObject(3675, 1479.82495, -1482.79797, 1720.31799, 288.443, 351.26, 229.454); // объект 45
	CreateDynamicObject(3675, 1461.78699, -1408.63, 1721.53601, 300.108, 354.508, 310.243); // объект 46
	CreateDynamicObject(3675, 1487.38196, -1444.35095, 1720.33496, 288.191, 351.153, 278.582); // объект 47
	CreateDynamicObject(3643, 1433.12402, -1501.85706, 1723.64795, 0.00, 0.00, 34); // объект 48
	CreateDynamicObject(3643, 1436.88599, -1498.46899, 1723.64795, 0.00, 0.00, 33.997); // объект 49
	CreateDynamicObject(3643, 1429.59399, -1505.15198, 1723.64795, 0.00, 0.00, 33.997); // объект 50
	CreateDynamicObject(3502, 1440.328, -1400.98499, 1720.93298, 358.757, 353.999, 331.869); // объект 51
	CreateDynamicObject(3502, 1461.29504, -1429.43005, 1720.93298, 358.247, 1.998, 296.056); // объект 52
	CreateDynamicObject(3502, 1469.46704, -1425.53699, 1720.93298, 358.243, 357.492, 115.166); // объект 53
	CreateDynamicObject(3502, 1477.39795, -1421.78894, 1721.25806, 358.242, 357.49, 114.664); // объект 54
	CreateDynamicObject(3502, 1485.172, -1418.21497, 1721.53296, 358.237, 357.484, 114.659); // объект 55
	CreateDynamicObject(3502, 1403.33301, -1399.84204, 1721.03296, 358.242, 1.994, 358.054); // объект 56
	CreateDynamicObject(3502, 1403.69702, -1391.04895, 1721.03296, 358.236, 358.487, 177.192); // объект 57
	CreateDynamicObject(3502, 1359.33203, -1402.21191, 1721.28296, 350.239, 2.016, 26.329); // объект 58
	CreateDynamicObject(3502, 1299.02795, -1448.10205, 1721.28296, 353.96, 194.331, 83.527); // объект 59
	CreateDynamicObject(3502, 1307.10498, -1449.16504, 1722.23401, 7.525, 194.371, 262.062); // объект 60
	CreateDynamicObject(3502, 1315.49902, -1450.40002, 1722.70996, 0.01, 194.244, 260.725); // объект 61
	CreateDynamicObject(3502, 1324.06445, -1451.72363, 1721.95898, 350.799, 194.431, 262.079); // объект 62
	CreateDynamicObject(3502, 1322.69238, -1496.69922, 1721.95898, 3.752, 179.489, 125.755); // объект 63
	CreateDynamicObject(3502, 1329.93994, -1491.39697, 1721.43396, 3.752, 179.489, 125.755); // объект 64
	CreateDynamicObject(3502, 1336.70801, -1486.50195, 1721.05896, 3.752, 179.489, 125.755); // объект 65
	CreateDynamicObject(3502, 1371.05273, -1516.5752, 1721.05896, 356.259, 175.479, 157.423); // объект 66
	CreateDynamicObject(3502, 1400.97595, -1518.83301, 1721.18396, 359.5, 174.489, 185.67); // объект 67
	CreateDynamicObject(3502, 1400.1084, -1510.17676, 1721.25903, 359.495, 174.485, 185.669); // объект 68
	CreateDynamicObject(3502, 1452.19702, -1490.43701, 1721.25903, 359.493, 182.485, 213.74); // объект 69
	CreateDynamicObject(3502, 1457.099, -1497.71899, 1721.13403, 359.489, 182.483, 213.739); // объект 70
	CreateDynamicObject(3502, 1461.84094, -1504.87695, 1721.08398, 0.488, 182.483, 212.946); // объект 71
	CreateDynamicObject(3502, 1465.50098, -1510.604, 1721.08398, 359.489, 182.477, 212.986); // объект 72
	CreateDynamicObject(3502, 1511.62598, -1473.0625, 1727.25903, 359.484, 182.483, 263.738); // объект 73
	CreateDynamicObject(3502, 1503.33301, -1472.07898, 1726.75903, 5.484, 182.489, 263.478); // объект 74
	CreateDynamicObject(3502, 1496.90698, -1471.29895, 1725.63306, 15.473, 182.57, 263.026); // объект 75
	CreateDynamicObject(3502, 1490.703, -1470.61499, 1723.58398, 21.213, 182.652, 263.748); // объект 76
	CreateDynamicObject(3502, 1482.98999, -1469.72205, 1722.08398, 359.23, 182.468, 263.735); // объект 77
	CreateDynamicObject(3502, 1474.21301, -1468.68201, 1721.85901, 3.966, 182.472, 263.524); // объект 78
	CreateDynamicObject(3502, 1465.69397, -1467.63599, 1721.50806, 359.72, 182.215, 262.455); // объект 79
	CreateDynamicObject(1949, 1392.578, -1474.62195, 1720.44299, 0.00, 0.00, 336); // объект 80
	CreateDynamicObject(1949, 1387.51794, -1473.97998, 1720.44299, 0.00, 0.00, 11.995); // объект 81
	CreateDynamicObject(1949, 1381.66101, -1477.29004, 1720.44299, 0.00, 0.00, 45.992); // объект 82
	CreateDynamicObject(1949, 1379.40796, -1482.75598, 1720.44299, 0.00, 0.00, 77.989); // объект 83
	CreateDynamicObject(1949, 1379.59595, -1488.63599, 1720.44299, 0.00, 0.00, 113.986); // объект 84
	CreateDynamicObject(1949, 1382.20801, -1492.87695, 1720.44299, 0.00, 0.00, 137.983); // объект 85
	CreateDynamicObject(1949, 1388.03101, -1495.53796, 1720.44299, 0.00, 0.00, 179.983); // объект 86
	CreateDynamicObject(1949, 1395.06006, -1492.73999, 1720.44299, 0.00, 0.00, 215.978); // объект 87
	CreateDynamicObject(1949, 1397.65796, -1485.64294, 1720.44299, 0.00, 0.00, 275.975); // объект 88
	CreateDynamicObject(1949, 1396.07397, -1479.33899, 1720.44299, 0.00, 0.00, 287.971); // объект 89
	CreateDynamicObject(3785, 1373.64697, -1471.64294, 1722.69299, 0.00, 0.00, 0.00); // объект 90
	CreateDynamicObject(3785, 1374.62695, -1478.651, 1722.69299, 0.00, 0.00, 0.00); // объект 91
	CreateDynamicObject(14882, 1299.37402, -1422.41602, 1726.56702, 359.5, 0.00, 292); // объект 92
	CreateDynamicObject(3865, 1304.21497, -1474.79602, 1721.76794, 346, 0.00, 98); // объект 93
	CreateDynamicObject(3865, 1312.94897, -1473.67004, 1723.96899, 345.998, 0.00, 97.998); // объект 94
	CreateDynamicObject(3865, 1320.63403, -1472.66602, 1725.89404, 345.998, 0.00, 97.998); // объект 95
	CreateDynamicObject(3865, 1328.75598, -1471.65698, 1727.94397, 345.998, 0.00, 97.998); // объект 96
	CreateDynamicObject(3865, 1337.38794, -1470.55396, 1730.11902, 345.998, 0.00, 97.998); // объект 97
	CreateDynamicObject(3865, 1346.35901, -1469.41699, 1732.36902, 345.998, 0.00, 97.998); // объект 98
	CreateDynamicObject(3865, 1355.21704, -1468.28503, 1734.59497, 345.998, 0.00, 97.998); // объект 99
	CreateDynamicObject(3502, 1438.25305, -1516.65002, 1724.25903, 359.657, 132.484, 179.343); // объект 100
	CreateDynamicObject(3502, 1439.43298, -1508.51904, 1721.90906, 35.259, 115.417, 156.258); // объект 101
	CreateDynamicObject(3865, 1503.39905, -1429.38794, 1726.995, 352.248, 0.00, 293.998); // объект 102
	CreateDynamicObject(3865, 1495.13794, -1432.97595, 1728.21997, 352.244, 0.00, 293.994); // объект 103
	CreateDynamicObject(3865, 1487.08301, -1436.43298, 1729.39502, 352.244, 0.00, 293.994); // объект 104
	CreateDynamicObject(3865, 1479.57996, -1439.76501, 1730.52002, 352.244, 0.00, 293.994); // объект 105
	CreateDynamicObject(3865, 1472.55603, -1443.10095, 1729.49402, 24.244, 0.00, 293.994); // объект 0
	CreateDynamicObject(3865, 1463.06995, -1446.54102, 1720.49402, 0.741, 0.00, 319.994); // объект 1
	CreateDynamicObject(3865, 1455.34998, -1450.854, 1721.84399, 25.486, 0.00, 285.993); // объект 2
	CreateDynamicObject(3865, 1445.10706, -1451.99805, 1721.84399, 30.517, 180, 105.991); // объект 3
	CreateDynamicObject(3529, 1414.625, -1388.69897, 1728.07605, 11.5, 0.00, 352.75); // объект 4
	CreateDynamicObject(3287, 1411.729, -1426.24695, 1725.18604, 0.00, 0.00, 0.00); // объект 5
	CreateDynamicObject(3287, 1374.68103, -1482.94995, 1725.18604, 0.00, 0.00, 328); // объект 6
	CreateDynamicObject(9831, 1403.099, -1396.30505, 1720.18396, 18, 0.00, 186.25); // объект 7
	CreateDynamicObject(18739, 1419.40405, -1459.35999, 1725.68799, 0.00, 0.00, 0.00); // объект 8
	CreateDynamicObject(18747, 1449.58203, -1453.703, 1718.59399, 0.00, 0.00, 0.00); // объект 9
	CreateDynamicObject(18707, 1469.98401, -1443.59705, 1729.06006, 86, 180, 132); // объект 10
	CreateDynamicObject(18717, 1386.96997, -1459.53699, 1723.69202, 0.00, 0.00, 0.00); // объект 11
	CreateDynamicObject(18671, 1432.76697, -1495.29504, 1716.26794, 0.00, 0.00, 0.00); // объект 12
	CreateDynamicObject(18671, 1426.41101, -1502.68799, 1716.26794, 0.00, 0.00, 0.00); // объект 13
	CreateDynamicObject(18720, 1439.01904, -1401.547, 1721.11401, 358.706, 93.785, 268.043); // объект 14
	CreateDynamicObject(900, 1332.11096, -1499.43298, 1717.56201, 0.00, 0.00, 44); // объект 15
	CreateDynamicObject(10984, 1454.38403, -1451.05103, 1719.60205, 0.00, 0.00, 330); // объект 16
	CreateDynamicObject(901, 1284.83606, -1455.94495, 1728.14502, 66, 180, 180); // объект 17
	CreateDynamicObject(901, 1475.771, -1401.92505, 1729.14502, 291.995, 179.994, 253.984); // объект 18
	CreateDynamicObject(3675, 1432.82227, -1395.83594, 1723.03601, 312.067, 355.886, 328.694); // объект 19
	CreateDynamicObject(12930, 1376.20898, -1442.16895, 1721.24805, 0.00, 0.00, 94); // объект 20
	CreateDynamicObject(1459, 1376.55103, -1439.63696, 1721.05505, 0.00, 0.00, 88); // объект 21
	CreateDynamicObject(1459, 1376.83496, -1444.89001, 1721.05505, 0.00, 0.00, 87.995); // объект 22
	CreateDynamicObject(1423, 1376.54297, -1442.23303, 1721.15405, 0.00, 0.5, 92.75); // объект 23
	CreateDynamicObject(1327, 1332.797, -1468.48999, 1719.98706, 1.854, 270.749, 67.988); // объект 24
	CreateDynamicObject(926, 1412.13904, -1506.02405, 1720.5, 0.00, 0.00, 0.00); // объект 25
	CreateDynamicObject(926, 1413.78601, -1504.49097, 1720.375, 0.00, 0.00, 60); // объект 26
	CreateDynamicObject(854, 1401.26501, -1519.96899, 1720.80005, 359.367, 327.498, 279.097); // объект 27
	CreateDynamicObject(854, 1401.68298, -1520.61804, 1721.25098, 359.363, 327.497, 274.597); // объект 28
	CreateDynamicObject(854, 1400.22205, -1520.81995, 1721.25098, 359.357, 327.491, 274.592); // объект 29
	CreateDynamicObject(854, 1400.36401, -1520.01697, 1720.82605, 359.357, 327.491, 274.592); // объект 30
	CreateDynamicObject(854, 1400.69104, -1519.46594, 1720.55103, 359.357, 327.491, 274.592); // объект 31
	CreateDynamicObject(854, 1401.11206, -1519.23096, 1720.45105, 358.082, 327.974, 273.552); // объект 32
	CreateDynamicObject(854, 1401.55896, -1519.57605, 1720.651, 358.077, 327.969, 273.549); // объект 33
	CreateDynamicObject(854, 1401.63794, -1520.02502, 1720.92603, 358.077, 327.969, 273.549); // объект 34
	CreateDynamicObject(854, 1401.54395, -1521.70996, 1721.97705, 358.251, 320.468, 268.308); // объект 35
	CreateDynamicObject(854, 1401.74097, -1521.12305, 1721.70203, 358.248, 320.466, 264.553); // объект 36
	CreateDynamicObject(854, 1400.88904, -1521.16504, 1721.677, 358.112, 326.217, 274.484); // объект 37
	CreateDynamicObject(854, 1401.17395, -1521.87903, 1722.22803, 0.196, 329.732, 272.861); // объект 38
	CreateDynamicObject(854, 1401.22095, -1522.28601, 1722.47803, 0.192, 329.727, 272.856); // объект 39
	CreateDynamicObject(852, 1370.63403, -1517.38098, 1720.50305, 0.00, 27.75, 79.5); // объект 40
	CreateDynamicObject(852, 1370.05298, -1518.73999, 1721.32898, 0.00, 27.746, 79.497); // объект 41
	CreateDynamicObject(851, 1371.55103, -1516.21704, 1720.18994, 0.00, 329.25, 246.75); // объект 42
	CreateDynamicObject(850, 1362.56702, -1465.57605, 1720.55396, 0.00, 0.00, 0.00); // объект 43
	CreateDynamicObject(1437, 1428.18994, -1473.44897, 1720.44299, 10.5, 0.00, 244); // объект 44
	CreateDynamicObject(1437, 1428.14502, -1473.42603, 1726.22095, 10.497, 0.00, 243.995); // объект 45
	CreateDynamicObject(1437, 1428.14502, -1473.42603, 1731.99597, 10.497, 0.00, 243.995); // объект 46
	CreateDynamicObject(18886, 1427.07605, -1472.89404, 1734.64197, 0.00, 0.00, 0.00); // объект 47
	CreateDynamicObject(18876, 1335.62695, -1421.71497, 1720.55103, 0.00, 0.00, 0.00); // объект 48
	CreateDynamicObject(18881, 1401.08704, -1489.49304, 1810.18298, 0.00, 0.00, 0.00); // объект 49
	CreateDynamicObject(18881, 1376.96704, -1478.42004, 1810.10803, 0.00, 0.00, 0.00); // объект 50
	CreateDynamicObject(18881, 1407.55103, -1421.41699, 1810.03296, 0.00, 0.00, 0.00); // объект 51
	CreateDynamicObject(19273, 1427.96899, -1472.62305, 1733.62695, 84.075, 207.694, 32.68); // объект 52
	CreateDynamicObject(2228, 1388.28796, -1482.41699, 1722.37402, 0.00, 20.75, 0.00); // объект 53
	CreateDynamicObject(2906, 1388.10498, -1481.93799, 1722.03894, 90, 180, 86); // объект 54
	CreateDynamicObject(2905, 1387.85596, -1481.03601, 1721.86304, 36.223, 80.647, 5.065); // объект 55
	CreateDynamicObject(2905, 1387.16602, -1481.16797, 1721.86304, 21.451, 84.996, 17.694); // объект 56
	CreateDynamicObject(10985, 1402.82104, -1394.64697, 1718.84497, 0.00, 47.5, 265.25); // объект 57
	CreateDynamicObject(16349, 1441.88, -1493.08606, 1721.81799, 0.00, 0.00, 0.00); // объект 58
	CreateDynamicObject(16349, 1420.33997, -1507.59302, 1721.81799, 0.00, 0.00, 0.00); // объект 59
	CreateDynamicObject(853, 1440.66199, -1400.50903, 1721.04602, 0.00, 334.5, 70); // объект 60
	CreateDynamicObject(854, 1441.44104, -1398.73401, 1721.76599, 0.00, 24.75, 251.5); // объект 61
	CreateDynamicObject(854, 1441.85803, -1399.64795, 1721.39099, 0.00, 24.747, 251.499); // объект 62
	CreateDynamicObject(854, 1442.11304, -1398.87097, 1721.89197, 354.644, 26.873, 250.957); // объект 63
	CreateDynamicObject(854, 1441.52698, -1398.43701, 1721.99194, 354.639, 26.873, 228.205); // объект 64
	CreateDynamicObject(854, 1439.29004, -1400.87195, 1720.49194, 354.604, 26.115, 234.382); // объект 65
	CreateDynamicObject(854, 1440.30505, -1401.84399, 1720.26697, 354.6, 26.115, 234.377); // объект 66
	CreateDynamicObject(854, 1439.745, -1402.14795, 1720.09204, 354.6, 26.115, 234.377); // объект 67
	CreateDynamicObject(854, 1439.23596, -1401.93298, 1720.09204, 354.311, 341.144, 69.797); // объект 68
	CreateDynamicObject(854, 1439.88403, -1399.47302, 1721.06604, 354.309, 341.142, 69.796); // объект 69
	CreateDynamicObject(854, 1440.19495, -1398.81799, 1721.29102, 354.309, 341.142, 69.796); // объект 70
	CreateDynamicObject(854, 1440.48401, -1398.20801, 1721.54102, 354.309, 341.142, 69.796); // объект 71
	CreateDynamicObject(854, 1439.90503, -1400.06104, 1720.71704, 15.726, 342.045, 73.756); // объект 72
	CreateDynamicObject(854, 1440.83899, -1400.85205, 1720.54199, 15.721, 342.043, 2.251); // объект 73
	CreateDynamicObject(854, 1441.255, -1400.13794, 1720.89197, 15.716, 342.037, 2.247); // объект 74
	CreateDynamicObject(752, 1474.22803, -1423.40405, 1717.56104, 0.00, 12, 0.00); // объект 75
	CreateDynamicObject(880, 1480.01001, -1422.23401, 1718.229, 12.962, 337.393, 147.336); // объект 76
	CreateDynamicObject(867, 1474.70496, -1421.62402, 1720.43396, 31.913, 4.714, 269.504); // объект 77
	CreateDynamicObject(854, 1474.65198, -1423.36401, 1720.34705, 2.55, 337.977, 10.031); // объект 78
	CreateDynamicObject(854, 1473.08496, -1423.34595, 1720.22205, 2.679, 346.981, 33.119); // объект 79
	CreateDynamicObject(854, 1474.66602, -1422.16699, 1720.69702, 358.769, 348.988, 28.76); // объект 80
	CreateDynamicObject(854, 1476.12195, -1422.24304, 1720.922, 358.774, 346.736, 28.708); // объект 81
	CreateDynamicObject(854, 1475.54504, -1421.55505, 1720.82202, 7.551, 347.376, 16.183); // объект 82
	CreateDynamicObject(854, 1480.86902, -1420.71204, 1721.74695, 7.708, 355.441, 1.11); // объект 83
	CreateDynamicObject(854, 1479.40698, -1421.30396, 1721.47205, 7.692, 354.179, 1.279); // объект 84
	CreateDynamicObject(854, 1478.47998, -1421.68005, 1721.297, 7.658, 352.159, 1.544); // объект 85
	CreateDynamicObject(854, 1477.01794, -1422.73096, 1720.922, 7.657, 352.156, 45.794); // объект 86
	CreateDynamicObject(854, 1477.573, -1422.23596, 1721.14697, 355.884, 15.768, 195.401); // объект 87
	CreateDynamicObject(853, 1478.73303, -1420.33801, 1721.82703, 16.209, 355.834, 304.915); // объект 88
	CreateDynamicObject(849, 1482.63196, -1419.56201, 1722.35095, 4.417, 348.967, 17.61); // объект 89
	CreateDynamicObject(849, 1480.77698, -1419.64697, 1722.10095, 4.417, 348.964, 17.606); // объект 90
	CreateDynamicObject(849, 1481.21106, -1420.68701, 1721.97595, 4.417, 348.964, 15.606); // объект 91
	CreateDynamicObject(854, 1479.26404, -1421.57898, 1721.422, 356.547, 11.996, 187.968); // объект 92
	CreateDynamicObject(854, 1480.24902, -1421.28601, 1721.77197, 347.989, 12.241, 189.817); // объект 93
	CreateDynamicObject(854, 1483.22205, -1418.79199, 1722.52197, 348.428, 19.887, 194.132); // объект 94
	CreateDynamicObject(854, 1483.31299, -1419.93506, 1722.297, 348.426, 19.885, 194.128); // объект 95
	CreateDynamicObject(854, 1484.33496, -1418.98901, 1722.823, 348.426, 19.885, 194.128); // объект 96
	CreateDynamicObject(854, 1484.10095, -1418.57605, 1722.79797, 348.426, 19.885, 194.128); // объект 97
	CreateDynamicObject(854, 1483.68896, -1418.08301, 1722.64795, 348.426, 19.885, 194.128); // объект 98
	CreateDynamicObject(854, 1483.04102, -1418.29395, 1722.49805, 340.919, 20.646, 153); // объект 99
	CreateDynamicObject(854, 1482.81702, -1418.34998, 1722.42297, 340.917, 20.643, 152.996); // объект 100
	CreateDynamicObject(854, 1481.79004, -1418.60596, 1722.12305, 340.917, 20.643, 152.996); // объект 101
	CreateDynamicObject(854, 1477.42102, -1423.08496, 1720.79797, 339.999, 10.075, 189.451); // объект 102
	CreateDynamicObject(854, 1477.84094, -1422.92004, 1720.87305, 339.994, 10.074, 189.448); // объект 103
	CreateDynamicObject(854, 1478.41504, -1422.66797, 1721.02295, 339.994, 10.074, 189.448); // объект 104
	CreateDynamicObject(854, 1511.12695, -1473.09802, 1727.75305, 272, 0.00, 84); // объект 105
	CreateDynamicObject(854, 1511.12695, -1473.09802, 1726.552, 271.999, 0.00, 83.996); // объект 106
	CreateDynamicObject(854, 1511.16199, -1473.276, 1727.72803, 42.934, 95.819, 162.456); // объект 107
	CreateDynamicObject(854, 1511.15503, -1473.34998, 1727.30298, 42.929, 95.817, 162.455); // объект 108
	CreateDynamicObject(854, 1511.09399, -1472.56702, 1727.203, 42.929, 95.817, 168.205); // объект 109
	CreateDynamicObject(854, 1511.06299, -1472.93994, 1727.729, 72.156, 109.768, 156.016); // объект 110
	CreateDynamicObject(854, 1510.83704, -1473.36206, 1725.65295, 56.993, 13.421, 254.126); // объект 111
	CreateDynamicObject(854, 1369.91199, -1517.29895, 1720.79797, 0.00, 326, 258); // объект 112
	CreateDynamicObject(854, 1370.41199, -1516.37598, 1720.22205, 0.00, 325.997, 257.997); // объект 113
	CreateDynamicObject(854, 1371.21204, -1517.70105, 1720.92297, 18.827, 341.739, 214.576); // объект 114
	CreateDynamicObject(854, 1371.11499, -1518.422, 1721.24805, 18.825, 341.735, 214.574); // объект 115
	CreateDynamicObject(854, 1370.99402, -1519.24097, 1721.62305, 18.825, 341.735, 198.325); // объект 116
	CreateDynamicObject(854, 1369.27197, -1518.48999, 1721.37305, 18.82, 341.735, 213.82); // объект 117
	CreateDynamicObject(854, 1369.745, -1519.23804, 1721.84802, 18.344, 337.544, 215.152); // объект 118
	CreateDynamicObject(854, 1370.43701, -1519.55298, 1721.84802, 18.342, 337.544, 215.151); // объект 119
	CreateDynamicObject(854, 1369.97205, -1519.73901, 1722.073, 18.342, 337.544, 215.151); // объект 120
	CreateDynamicObject(3502, 1315.55298, -1501.81201, 1722.56006, 3.752, 179.489, 125.755); // объект 121
	CreateDynamicObject(901, 1437.62, -1527.18005, 1721.35596, 60.254, 97.029, 155.918); // объект 122
	CreateDynamicObject(10984, 1319.70703, -1499.22705, 1720.97498, 0.00, 8, 0.00); // объект 123
	CreateDynamicObject(10984, 1316.698, -1502.03198, 1723.052, 0.00, 12.248, 32); // объект 124
	CreateDynamicObject(1327, 1360.026, -1492.771, 1719.98706, 1.851, 270.747, 67.983); // объект 125
	CreateDynamicObject(1327, 1390.55103, -1505.229, 1719.98706, 1.851, 270.747, 67.983); // объект 126
	CreateDynamicObject(1327, 1443.24805, -1436.85498, 1719.98706, 1.851, 270.747, 67.983); // объект 127
	CreateDynamicObject(1327, 1449.31604, -1433.89795, 1719.98706, 1.851, 270.747, 67.983); // объект 128
	CreateDynamicObject(1327, 1455.36597, -1432.61804, 1719.98706, 1.851, 270.747, 67.983); // объект 129
	CreateDynamicObject(854, 1458.77502, -1500.01404, 1720.44397, 0.00, 276, 312); // объект 130
	CreateDynamicObject(854, 1459.00696, -1499.73499, 1720.84399, 0.00, 266.5, 311.995); // объект 131
	CreateDynamicObject(854, 1458.29895, -1500.24597, 1720.79395, 0.00, 266.495, 311.99); // объект 132
	CreateDynamicObject(854, 1458.80103, -1499.87402, 1721.31995, 0.00, 266.495, 311.99); // объект 133
	CreateDynamicObject(854, 1458.34705, -1500.18298, 1721.31995, 0.00, 266.495, 311.99); // объект 134
	CreateDynamicObject(852, 1304.06702, -1448.68506, 1720.64294, 0.00, 12, 0.00); // объект 135
	CreateDynamicObject(852, 1302.84802, -1448.15698, 1720.81799, 0.00, 11.997, 0.00); // объект 136
	CreateDynamicObject(852, 1300.89099, -1448.49597, 1721.04297, 357.043, 9.76, 4.258); // объект 137
	CreateDynamicObject(852, 1297.41895, -1448.06104, 1721.59399, 357.039, 9.756, 4.257); // объект 138
	CreateDynamicObject(854, 1299.59302, -1447.453, 1721.48303, 2.471, 8.758, 357.369); // объект 139
	CreateDynamicObject(854, 1300.00696, -1446.70605, 1721.10803, 2.466, 8.756, 357.369); // объект 140
	CreateDynamicObject(854, 1301.49805, -1447.43994, 1721.10803, 2.466, 8.756, 357.369); // объект 141
	CreateDynamicObject(854, 1300.65503, -1447.03894, 1721.08301, 2.466, 8.756, 357.369); // объект 142
	CreateDynamicObject(854, 1300.27295, -1446.80396, 1721.08301, 2.466, 8.756, 357.369); // объект 143
	CreateDynamicObject(854, 1300.59399, -1447.71106, 1721.08301, 2.466, 8.756, 357.369); // объект 144
	CreateDynamicObject(854, 1299.38306, -1448.63306, 1721.30798, 2.466, 8.756, 357.369); // объект 145
	CreateDynamicObject(854, 1299.31494, -1449.43005, 1721.33301, 2.466, 8.756, 357.369); // объект 146
	CreateDynamicObject(854, 1302.83398, -1449.35901, 1720.98303, 2.466, 8.756, 357.369); // объект 147
	CreateDynamicObject(854, 1301.599, -1448.84802, 1721.35803, 2.466, 8.756, 357.369); // объект 148
	CreateDynamicObject(854, 1300.35498, -1449.29004, 1721.35803, 2.466, 8.756, 357.369); // объект 149
	CreateDynamicObject(854, 1298.51294, -1448.82898, 1721.60803, 2.466, 8.756, 357.369); // объект 150
	CreateDynamicObject(854, 1298.35803, -1447.15796, 1721.63306, 2.466, 8.756, 357.369); // объект 151
	CreateDynamicObject(854, 1298.84705, -1446.724, 1721.33301, 2.466, 8.756, 357.369); // объект 152
	CreateDynamicObject(854, 1297.23206, -1447.38403, 1721.85901, 2.466, 8.756, 357.369); // объект 153
	CreateDynamicObject(854, 1297.81396, -1449.28699, 1721.43396, 2.466, 8.756, 357.369); // объект 154
	CreateDynamicObject(854, 1296.948, -1447.70898, 1721.95996, 1.63, 35.264, 356.597); // объект 155
	CreateDynamicObject(854, 1297.42102, -1448.927, 1721.58496, 1.919, 15.503, 357.211); // объект 156
	CreateDynamicObject(854, 1297.63403, -1448.37903, 1721.63501, 1.732, 29.508, 356.761); // объект 157
	CreateDynamicObject(850, 1362.427, -1409.02698, 1719.61902, 0.00, 0.00, 31); // объект 158
	CreateDynamicObject(851, 1358.08704, -1400.07605, 1720.43604, 0.00, 21.25, 286); // объект 159
	CreateDynamicObject(851, 1357.927, -1398.33704, 1721.28699, 0.00, 22.998, 289.746); // объект 160
	CreateDynamicObject(854, 1359.03198, -1398.91895, 1720.573, 0.00, 25, 293.75); // объект 161
	CreateDynamicObject(854, 1359.07898, -1399.81201, 1720.34802, 0.00, 24.999, 293.747); // объект 162
	CreateDynamicObject(854, 1358.76599, -1400.82397, 1719.97302, 0.00, 24.999, 293.747); // объект 163
	CreateDynamicObject(854, 1359.25098, -1400.33606, 1719.97302, 0.00, 24.999, 293.747); // объект 164
	CreateDynamicObject(854, 1358.08301, -1400.84998, 1719.97302, 0.00, 24.999, 293.747); // объект 165
	CreateDynamicObject(854, 1357.67395, -1400.297, 1720.34802, 0.00, 24.999, 293.747); // объект 166
	CreateDynamicObject(854, 1357.51501, -1399.52502, 1720.79895, 0.00, 24.999, 293.747); // объект 167
	CreateDynamicObject(854, 1356.63306, -1399.19702, 1720.823, 0.00, 24.999, 293.747); // объект 168
	CreateDynamicObject(854, 1357.06104, -1398.45703, 1721.198, 0.00, 24.999, 293.747); // объект 169
	CreateDynamicObject(854, 1356.83105, -1397.75806, 1721.47302, 0.00, 24.999, 293.747); // объект 170
	CreateDynamicObject(854, 1356.42603, -1398.11401, 1721.24805, 0.00, 24.999, 293.747); // объект 171
	CreateDynamicObject(854, 1356.43701, -1398.56104, 1721.04797, 0.00, 24.999, 293.747); // объект 172
	CreateDynamicObject(854, 1358.40198, -1399.18994, 1720.44897, 0.00, 24.999, 293.747); // объект 173
	CreateDynamicObject(854, 1357.83203, -1397.68298, 1721.44995, 0.00, 24.999, 293.747); // объект 174
	CreateDynamicObject(854, 1356.25598, -1397.65405, 1721.47498, 0.00, 24.999, 293.747); // объект 175
	CreateDynamicObject(3502, 1355.54395, -1394.55103, 1719.80798, 350.239, 2.016, 26.329); // объект 176
	CreateDynamicObject(854, 1357.22998, -1397.18103, 1721.57495, 0.00, 24.999, 293.747); // объект 177
	CreateDynamicObject(854, 1356.755, -1397.46106, 1721.57495, 0.00, 24.999, 293.747); // объект 178
	CreateDynamicObject(2908, 1410.422, -1468.56299, 1720.52002, 0.00, 0.00, 0.00); // объект 179
	CreateDynamicObject(2908, 1384.93298, -1463.15601, 1720.52002, 0.00, 0.00, 170); // объект 180
	CreateDynamicObject(2908, 1364.62305, -1454.75195, 1720.52002, 0.00, 0.00, 169.997); // объект 181
	CreateDynamicObject(2908, 1392.33105, -1441.22595, 1720.52002, 0.00, 0.00, 169.997); // объект 182
	CreateDynamicObject(2908, 1401.18701, -1425.93298, 1720.52002, 0.00, 0.00, 269.997); // объект 183
	CreateDynamicObject(2908, 1400.65002, -1440.67505, 1720.52002, 0.00, 0.00, 269.995); // объект 184
	CreateDynamicObject(2908, 1415.29102, -1445.38196, 1720.52002, 0.00, 0.00, 269.995); // объект 185
	CreateDynamicObject(2908, 1412.84204, -1452.99902, 1720.52002, 0.00, 0.00, 127.995); // объект 186
	CreateDynamicObject(2908, 1426.95496, -1449.13196, 1720.52002, 0.00, 0.00, 37.991); // объект 187
	CreateDynamicObject(2908, 1423.552, -1482.26697, 1720.52002, 0.00, 0.00, 221.985); // объект 188
	CreateDynamicObject(2908, 1386.48401, -1454.10999, 1720.52002, 0.00, 0.00, 221.984); // объект 189
	CreateDynamicObject(2908, 1382.50195, -1469.66797, 1720.52002, 0.00, 0.00, 301.984); // объект 190
	CreateDynamicObject(2908, 1384.13196, -1438.25195, 1720.52002, 0.00, 0.00, 125.981); // объект 191
	CreateDynamicObject(2908, 1404.99304, -1418.76501, 1720.52002, 0.00, 0.00, 23.98); // объект 192
	CreateDynamicObject(2908, 1375.11206, -1453.07996, 1720.52002, 0.00, 0.00, 253.978); // объект 193
    CreateDynamicObject(2908, 1398.05603, -1452.84094, 1720.52002, 0.00, 0.00, 253.976); // объект 0
	CreateDynamicObject(2908, 1406.30396, -1450.82202, 1720.52002, 0.00, 0.00, 117.976); // объект 1
	CreateDynamicObject(2908, 1398.83203, -1463.87598, 1720.52002, 0.00, 0.00, 111.971); // объект 2
	CreateDynamicObject(2908, 1403.52197, -1478.62805, 1720.52002, 0.00, 0.00, 119.967); // объект 3
	CreateDynamicObject(2908, 1406.56104, -1433.47095, 1720.52002, 0.00, 0.00, 17.965); // объект 4
	CreateDynamicObject(2908, 1362.646, -1445.10498, 1720.52002, 0.00, 0.00, 39.963); // объект 5
	CreateDynamicObject(2908, 1371.49402, -1465.11304, 1720.52002, 0.00, 0.00, 91.957); // объект 6
	CreateDynamicObject(2907, 1389.10303, -1424.38696, 1720.60706, 0.00, 0.00, 0.00); // объект 7
	CreateDynamicObject(2907, 1402.90698, -1437.974, 1720.60706, 0.00, 0.00, 102); // объект 8
	CreateDynamicObject(2907, 1404.63904, -1423.43604, 1720.60706, 0.00, 0.00, 185.997); // объект 9
	CreateDynamicObject(2907, 1416.91101, -1452.11694, 1720.60706, 0.00, 0.00, 351.993); // объект 10
	CreateDynamicObject(2907, 1426.86694, -1468.26904, 1720.60706, 0.00, 0.00, 129.991); // объект 11
	CreateDynamicObject(2907, 1425.52295, -1485.71106, 1720.60706, 0.00, 0.00, 195.99); // объект 12
	CreateDynamicObject(2907, 1384.63098, -1468.40796, 1720.60706, 0.00, 0.00, 339.985); // объект 13
	CreateDynamicObject(2907, 1396.69299, -1472.64795, 1720.60706, 0.00, 0.00, 201.983); // объект 14
	CreateDynamicObject(2907, 1391.729, -1451.14502, 1720.60706, 0.00, 0.00, 167.978); // объект 15
	CreateDynamicObject(2907, 1381.29797, -1442.85803, 1720.60706, 0.00, 0.00, 99.975); // объект 16
	CreateDynamicObject(2907, 1374.83801, -1461.21301, 1720.60706, 0.00, 0.00, 251.97); // объект 17
	CreateDynamicObject(2907, 1365.04102, -1467.28198, 1720.58203, 358.25, 0.00, 85.966); // объект 18
	CreateDynamicObject(2907, 1372.328, -1467.09998, 1720.55701, 357.503, 356.997, 113.834); // объект 19
	CreateDynamicObject(2907, 1407.93799, -1463.43701, 1720.55701, 357.501, 356.995, 9.829); // объект 20
	CreateDynamicObject(2907, 1424.677, -1478.18298, 1720.55701, 357.495, 356.995, 141.827); // объект 21
	CreateDynamicObject(2907, 1394.953, -1463.323, 1720.55701, 357.495, 356.995, 129.822); // объект 22
	CreateDynamicObject(2907, 1407.69604, -1475.29895, 1720.55701, 357.495, 356.995, 87.82); // объект 23
	CreateDynamicObject(2907, 1431.76099, -1455.02295, 1720.55701, 357.495, 356.995, 35.819); // объект 24
	CreateDynamicObject(2907, 1418.32104, -1459.17896, 1720.55701, 357.495, 356.995, 227.815); // объект 25
	CreateDynamicObject(2906, 1403.646, -1460.85803, 1720.51697, 0.00, 0.00, 284); // объект 26
	CreateDynamicObject(2906, 1403.79504, -1469.35706, 1720.51697, 0.00, 0.00, 253.997); // объект 27
	CreateDynamicObject(2906, 1421.30896, -1476.83398, 1720.51697, 0.00, 0.00, 65.993); // объект 28
	CreateDynamicObject(2906, 1420.83105, -1449.35706, 1720.51697, 0.00, 0.00, 279.989); // объект 29
	CreateDynamicObject(2906, 1394.35498, -1435.50403, 1720.51697, 0.00, 0.00, 289.987); // объект 30
	CreateDynamicObject(2906, 1397.68799, -1425.94202, 1720.51697, 0.00, 0.00, 277.984); // объект 31
	CreateDynamicObject(2906, 1370.46997, -1435.95398, 1720.51697, 0.00, 0.00, 193.982); // объект 32
	CreateDynamicObject(2906, 1374.18896, -1438.11401, 1720.51697, 0.00, 0.00, 33.98); // объект 33
	CreateDynamicObject(2906, 1369.43005, -1443.58398, 1720.51697, 0.00, 0.00, 179.975); // объект 34
	CreateDynamicObject(2906, 1357.49597, -1458.82898, 1720.51697, 0.00, 0.00, 101.973); // объект 35
	CreateDynamicObject(2906, 1361.38904, -1452.18396, 1720.51697, 0.00, 0.00, 311.97); // объект 36
	CreateDynamicObject(2906, 1370.84705, -1451.29297, 1720.51697, 0.00, 0.00, 255.968); // объект 37
	CreateDynamicObject(2906, 1369.64294, -1457.18201, 1720.51697, 0.00, 0.00, 315.965); // объект 38
	CreateDynamicObject(2906, 1383.14294, -1455.91101, 1720.51697, 0.00, 0.00, 51.961); // объект 39
	CreateDynamicObject(2906, 1407.52698, -1441.89294, 1720.51697, 0.00, 0.00, 71.96); // объект 40
	CreateDynamicObject(2906, 1387.27405, -1429.48706, 1720.51697, 0.00, 0.00, 51.955); // объект 41
	CreateDynamicObject(2906, 1388.94897, -1420.60999, 1720.51697, 0.00, 0.00, 37.954); // объект 42
	CreateDynamicObject(2906, 1392.37, -1428.88696, 1720.51697, 0.00, 0.00, 199.952); // объект 43
	CreateDynamicObject(2906, 1414.47302, -1470.98901, 1720.51697, 0.00, 0.00, 335.951); // объект 44
	CreateDynamicObject(2906, 1424.38306, -1459.927, 1720.51697, 0.00, 0.00, 355.951); // объект 45
	CreateDynamicObject(2906, 1434.172, -1461.979, 1720.51697, 0.00, 0.00, 321.946); // объект 46
	CreateDynamicObject(2906, 1382.80396, -1446.16003, 1720.51697, 0.00, 0.00, 341.943); // объект 47
	CreateDynamicObject(2906, 1368.89905, -1459.86304, 1720.51697, 0.00, 0.00, 251.938); // объект 48
	CreateDynamicObject(2906, 1403.03601, -1486.01001, 1720.51697, 0.00, 0.00, 161.938); // объект 49
	CreateDynamicObject(2906, 1416.94897, -1464.17505, 1720.51697, 0.00, 0.00, 61.933); // объект 50
	CreateDynamicObject(2906, 1404.50806, -1444.99097, 1720.51697, 0.00, 0.00, 349.93); // объект 51
	CreateDynamicObject(2906, 1400.85803, -1430.27002, 1720.51697, 0.00, 0.00, 269.926); // объект 52
	CreateDynamicObject(2906, 1385.22302, -1433.75098, 1720.51697, 0.00, 0.00, 229.923); // объект 53
	CreateDynamicObject(2906, 1390.50305, -1466.83704, 1720.51697, 0.00, 0.00, 139.922); // объект 54
	CreateDynamicObject(2906, 1360.698, -1462.93604, 1720.51697, 0.00, 110, 117.922); // объект 55
	CreateDynamicObject(2906, 1432.77502, -1445.98499, 1720.51697, 0.00, 109.995, 235.922); // объект 56
	CreateDynamicObject(2906, 1410.10498, -1493.58496, 1720.51697, 0.00, 109.995, 235.92); // объект 57
	CreateDynamicObject(2905, 1410.25305, -1455.31006, 1720.53406, 0.00, 0.00, 0.00); // объект 58
	CreateDynamicObject(2905, 1405.46106, -1437.26196, 1720.53406, 0.00, 0.00, 222); // объект 59
	CreateDynamicObject(2905, 1392.65405, -1437.54602, 1720.53406, 0.00, 0.00, 11.995); // объект 60
	CreateDynamicObject(2905, 1387.58301, -1448.47205, 1720.53406, 0.00, 2, 217.992); // объект 61
	CreateDynamicObject(2905, 1374.75098, -1446.224, 1720.53406, 0.00, 2, 131.991); // объект 62
	CreateDynamicObject(2905, 1377.16003, -1464.73303, 1720.53406, 0.00, 2, 359.99); // объект 63
	CreateDynamicObject(2905, 1365.38794, -1463.74097, 1720.53406, 0.00, 2, 239.989); // объект 64
	CreateDynamicObject(2905, 1366.28003, -1447.47095, 1720.53406, 0.00, 2, 141.985); // объект 65
	CreateDynamicObject(2905, 1364.05298, -1437.19897, 1720.53406, 0.00, 2, 61.982); // объект 66
	CreateDynamicObject(2905, 1393.56604, -1419.13098, 1720.53406, 0.00, 2, 331.979); // объект 67
	CreateDynamicObject(2905, 1431.24402, -1469.91602, 1720.53406, 0.00, 2, 347.979); // объект 68
	CreateDynamicObject(2905, 1420.24695, -1469.76904, 1720.53406, 0.00, 2, 323.975); // объект 69
	CreateDynamicObject(2905, 1414.49402, -1492.27795, 1720.53406, 0.00, 2, 153.97); // объект 70
	CreateDynamicObject(2905, 1403.99805, -1492.50806, 1720.53406, 0.00, 2, 319.968); // объект 71
	CreateDynamicObject(2905, 1385.82605, -1493.91003, 1720.53406, 0.00, 2, 63.966); // объект 72
	CreateDynamicObject(2905, 1376.95898, -1488.604, 1720.53406, 0.00, 2, 219.962); // объект 73
	CreateDynamicObject(2905, 1369.56995, -1482.26599, 1720.53406, 0.00, 2, 39.957); // объект 74
	CreateDynamicObject(2905, 1428.13196, -1461.29395, 1720.53406, 0.00, 2, 303.957); // объект 75
	CreateDynamicObject(2905, 1413.75696, -1442.58704, 1720.53406, 0.00, 128, 303.953); // объект 76
	CreateDynamicObject(2905, 1397.34595, -1434.05896, 1720.50903, 0.00, 181.746, 251.953); // объект 77
	CreateDynamicObject(2905, 1392.46594, -1468.60596, 1720.50903, 0.00, 181.741, 297.949); // объект 78
	CreateDynamicObject(2905, 1377.11694, -1475.53406, 1720.50903, 0.00, 181.741, 215.949); // объект 79
	CreateDynamicObject(2905, 1397.63306, -1445.59302, 1720.50903, 0.00, 181.741, 87.949); // объект 80
	CreateDynamicObject(2905, 1361.73401, -1458.625, 1720.50903, 0.00, 181.741, 317.946); // объект 81
	CreateDynamicObject(3092, 1376.54504, -1433.91895, 1721.40698, 0.00, 0.00, 150); // объект 82
	CreateDynamicObject(3092, 1414.82397, -1433.61597, 1720.80603, 37.103, 81.128, 76.979); // объект 83
	CreateDynamicObject(3092, 1371.28699, -1471.20801, 1721.40698, 0.00, 0.00, 357.996); // объект 84
	CreateDynamicObject(3092, 1410.91003, -1482.94397, 1724.58105, 0.00, 86, 67.995); // объект 85
	CreateDynamicObject(19836, 1392.49402, -1451.65198, 1720.51794, 0.00, 0.00, 38); // объект 86
	CreateDynamicObject(19836, 1376.43604, -1433.63196, 1720.49304, 0.00, 0.00, 37.996); // объект 87
	CreateDynamicObject(19836, 1371.31396, -1470.75403, 1720.46802, 0.00, 0.00, 37.996); // объект 88
	CreateDynamicObject(19836, 1411.12805, -1483.11597, 1724.39404, 0.00, 0.00, 291.996); // объект 89
	CreateDynamicObject(19836, 1399.74402, -1428.41394, 1720.46802, 0.00, 0.00, 37.996); // объект 90
	CreateDynamicObject(19836, 1416.86499, -1460.97498, 1720.44702, 0.00, 0.00, 111.996); // объект 91
	CreateDynamicObject(19836, 1366.01294, -1465.31299, 1720.44702, 0.00, 0.00, 111.995); // объект 92
	CreateDynamicObject(19836, 1403.92297, -1440.61304, 1720.44702, 0.00, 0.00, 111.995); // объект 93
	CreateDynamicObject(19836, 1424.10803, -1481.302, 1720.44702, 0.00, 0.00, 111.995); // объект 94
	CreateDynamicObject(19836, 1395.84094, -1466.58997, 1720.44702, 0.00, 0.00, 111.995); // объект 95
	CreateDynamicObject(19836, 1377.76697, -1441.74097, 1720.44702, 0.00, 0.00, 111.995); // объект 96
	//GroveCP
	CreateDynamicObject(1365, 2512.28491, -1665.39502, 13.643, 0.00, 0.00, 84); // объект 0
	CreateDynamicObject(3594, 2505.38892, -1695.03198, 13.19, 0.00, 0.00, 0.00); // объект 1
	CreateDynamicObject(3594, 2475.19995, -1684.06006, 12.965, 0.00, 0.00, 28); // объект 2
	CreateDynamicObject(13591, 2416.65088, -1665.10596, 12.804, 0.00, 0.00, 0.00); // объект 3
	CreateDynamicObject(3578, 2460.53491, -1666.28406, 13.13, 0.00, 0.00, 88); // объект 4
	CreateDynamicObject(3578, 2461.59204, -1651.06995, 13.13, 0.00, 0.00, 87.995); // объект 5
	CreateDynamicObject(3578, 2448.06689, -1659.66199, 13.13, 0.00, 0.00, 87.995); // объект 6
	CreateDynamicObject(3578, 2432.50098, -1653.06995, 13.13, 0.00, 0.00, 87.995); // объект 7
	CreateDynamicObject(3578, 2431.93604, -1667.11597, 13.13, 0.00, 0.00, 87.995); // объект 8
	CreateDynamicObject(3578, 2423.20508, -1660.34399, 13.13, 0.00, 0.00, 87.995); // объект 9
	CreateDynamicObject(1299, 2480.7959, -1691.38904, 12.975, 0.00, 0.00, 0.00); // объект 10
	CreateDynamicObject(1299, 2482.05396, -1718.974, 12.975, 0.00, 0.00, 40); // объект 11
	CreateDynamicObject(1300, 2479.51709, -1686.81702, 12.878, 0.00, 0.00, 0.00); // объект 12
	CreateDynamicObject(1224, 2483.22412, -1687.745, 13.123, 0.00, 0.00, 0.00); // объект 13
	CreateDynamicObject(1358, 2481.28491, -1743.08997, 13.75, 0.00, 0.00, 44); // объект 14
	CreateDynamicObject(1450, 2478.19897, -1717.99805, 13.145, 0.00, 0.00, 86); // объект 15
	CreateDynamicObject(911, 2480.45801, -1704.82495, 13.024, 270, 179.992, 179.992); // объект 16
	CreateDynamicObject(852, 2479.13892, -1719.77197, 12.472, 0.00, 0.00, 0.00); // объект 17
	CreateDynamicObject(852, 2482.56006, -1715.47803, 12.472, 0.00, 0.00, 102); // объект 18
	CreateDynamicObject(852, 2481.45703, -1716.09802, 12.472, 0.00, 0.00, 173.997); // объект 19
	CreateDynamicObject(852, 2482.90405, -1716.56604, 12.472, 0.00, 0.00, 301.996); // объект 20
	CreateDynamicObject(3577, 2482.00488, -1711.776, 13.271, 0.00, 0.00, 90.25); // объект 21
	CreateDynamicObject(3577, 2482.56104, -1711.37195, 15.346, 349.233, 11.964, 122.514); // объект 22
	CreateDynamicObject(3577, 2480.34497, -1701.90405, 13.312, 0.00, 0.00, 0.00); // объект 23
	CreateDynamicObject(2567, 2480.96606, -1696.75, 14.598, 41.732, 357.99, 85.338); // объект 24
	CreateDynamicObject(1685, 2483.99609, -1695.54395, 15.517, 1.47, 11.504, 359.701); // объект 25
	CreateDynamicObject(1226, 2476.64307, -1706.00195, 12.778, 0.751, 289.486, 175.871); // объект 26
	CreateDynamicObject(1685, 2483.51807, -1698.06006, 15.392, 1.375, 336.742, 356.587); // объект 27
	CreateDynamicObject(1230, 2481.74097, -1698.32898, 12.94, 0.00, 0.00, 36); // объект 28
	CreateDynamicObject(1230, 2483.06201, -1697.61694, 12.94, 0.00, 0.00, 315.997); // объект 29
	CreateDynamicObject(1230, 2481.927, -1697.09094, 12.94, 0.00, 0.00, 315.994); // объект 30
	CreateDynamicObject(1230, 2483.3479, -1699.73206, 12.94, 0.00, 0.00, 41.994); // объект 31
	CreateDynamicObject(1332, 2424.07104, -1649.68994, 13.61, 0.00, 0.00, 0.00); // объект 32
	CreateDynamicObject(3594, 2421.84497, -1678.25098, 13.12, 0.00, 0.00, 54); // объект 33
	CreateDynamicObject(3594, 2406.47998, -1664.53101, 13.07, 0.00, 0.00, 53.998); // объект 34
	CreateDynamicObject(3594, 2400.41309, -1654.04395, 13.07, 0.00, 0.00, 117.998); // объект 35
	CreateDynamicObject(3594, 2418.77808, -1651.37195, 13.07, 0.00, 0.00, 71.993); // объект 36
	CreateDynamicObject(3594, 2446.7251, -1672.46106, 12.945, 0.00, 358.25, 25.988); // объект 37
	CreateDynamicObject(3594, 2451.51611, -1686.302, 12.945, 0.00, 358.248, 71.983); // объект 38
	CreateDynamicObject(3594, 2471.78101, -1650.51697, 12.945, 0.00, 358.248, 71.982); // объект 39
	CreateDynamicObject(3594, 2386.87891, -1661.69495, 13.07, 0.00, 0.00, 57.993); // объект 40
	CreateDynamicObject(3594, 2361.99805, -1654.57397, 13.07, 0.00, 0.00, 113.991); // объект 41
	CreateDynamicObject(3594, 2350.66602, -1660.45203, 13.07, 0.00, 0.00, 271.989); // объект 42
	CreateDynamicObject(3594, 2344.16895, -1677.52197, 13.07, 0.00, 0.00, 327.989); // объект 43
	CreateDynamicObject(3594, 2344.24609, -1692.651, 13.07, 0.00, 0.00, 33.986); // объект 44
	CreateDynamicObject(3594, 2344.3269, -1708.34998, 13.07, 0.00, 0.00, 273.981); // объект 45
	CreateDynamicObject(3594, 2335.57593, -1708.43506, 13.07, 0.00, 0.00, 331.977); // объект 46
	CreateDynamicObject(3594, 2322.16699, -1730.55798, 13.07, 0.00, 0.00, 221.974); // объект 47
	CreateDynamicObject(3594, 2303.6499, -1736.18103, 13.07, 0.00, 0.00, 301.973); // объект 48
	CreateDynamicObject(3594, 2307.38208, -1753.29797, 13.07, 0.00, 0.00, 119.97); // объект 49
	CreateDynamicObject(3594, 2349.37695, -1745.75098, 13.07, 0.00, 0.00, 119.965); // объект 50
	CreateDynamicObject(3594, 2344.8689, -1725.07703, 13.07, 0.00, 0.00, 31.965); // объект 51
	CreateDynamicObject(3594, 2371.40503, -1736.24097, 13.07, 0.00, 0.00, 31.965); // объект 52
	CreateDynamicObject(3594, 2313.69409, -1742.20801, 13.07, 0.00, 0.00, 195.965); // объект 53
	CreateDynamicObject(3594, 2253.9519, -1749.26196, 13.07, 0.00, 0.00, 97.963); // объект 54
	CreateDynamicObject(3594, 2286.29102, -1753.85205, 13.07, 0.00, 0.00, 69.96); // объект 55
	CreateDynamicObject(3594, 2262.78906, -1728.854, 13.07, 0.00, 0.00, 315.955); // объект 56
	CreateDynamicObject(3594, 2230.93188, -1732.61499, 13.07, 0.00, 0.00, 239.95); // объект 57
	CreateDynamicObject(3594, 2390.48999, -1750.42297, 12.87, 0.00, 0.00, 307.947); // объект 58
	CreateDynamicObject(3594, 2427.62988, -1727.32898, 13.095, 0.00, 0.00, 259.947); // объект 59
	CreateDynamicObject(3594, 2414.87988, -1744.85498, 12.895, 0.00, 0.00, 155.942); // объект 60
	CreateDynamicObject(3594, 2411.96094, -1741.73206, 12.895, 0.00, 0.00, 107.94); // объект 61
	CreateDynamicObject(3594, 2388.33008, -1737.71301, 13.095, 9.467, 175.184, 180.729); // объект 62
	CreateDynamicObject(3594, 2461.37598, -1738.526, 13.095, 0.00, 0.00, 303.942); // объект 63
	CreateDynamicObject(3594, 2485.29004, -1753.10803, 13.095, 0.00, 0.00, 3.937); // объект 64
	CreateDynamicObject(3594, 2493.86401, -1731.44995, 13.045, 0.00, 0.00, 29.933); // объект 65
	CreateDynamicObject(3594, 2467.87305, -1725.72498, 13.045, 0.00, 0.00, 53.932); // объект 66
	CreateDynamicObject(3594, 2524.88696, -1731.11304, 13.045, 0.00, 0.00, 127.932); // объект 67
	CreateDynamicObject(3594, 2559.521, -1734.38501, 13.045, 0.00, 0.00, 89.93); // объект 68
	CreateDynamicObject(3594, 2560.03589, -1728.90906, 13.045, 0.00, 0.00, 23.929); // объект 69
	CreateDynamicObject(3594, 2600.78198, -1729.78699, 12.595, 1.459, 13.504, 23.578); // объект 70
	CreateDynamicObject(3594, 2603.64697, -1735.06006, 12.145, 5.997, 0.752, 85.848); // объект 71
	CreateDynamicObject(3594, 2585.54492, -1731.27502, 13.045, 0.00, 0.00, 249.928); // объект 72
	CreateDynamicObject(3594, 2587.95508, -1743.61206, 13.045, 356.002, 2.005, 178.068); // объект 73
	CreateDynamicObject(3594, 2612.76904, -1730.03101, 11.295, 3.99, 357.737, 114.083); // объект 74
	CreateDynamicObject(3594, 2623.76294, -1726.65601, 10.97, 5.487, 357.732, 114.142); // объект 75
	CreateDynamicObject(3594, 2628.90991, -1741.70105, 10.745, 359.986, 357.742, 149.92); // объект 76
	CreateDynamicObject(3594, 2648.25, -1741.58899, 10.745, 359.984, 357.737, 39.919); // объект 77
	CreateDynamicObject(3594, 2641.62988, -1720.92798, 10.37, 359.978, 357.731, 79.919); // объект 78
	CreateDynamicObject(2671, 2492.7251, -1664.83105, 12.344, 0.00, 0.00, 0.00); // объект 79
	CreateDynamicObject(2671, 2497.72412, -1665.39905, 12.343, 0.00, 0.00, 0.00); // объект 80
	CreateDynamicObject(2671, 2495.66895, -1670.422, 12.336, 0.00, 0.00, 0.00); // объект 81
	CreateDynamicObject(2671, 2489.73901, -1666.63794, 12.344, 0.00, 0.00, 0.00); // объект 82
	CreateDynamicObject(2672, 2501.7041, -1669.61804, 12.637, 0.00, 0.00, 0.00); // объект 83
	CreateDynamicObject(2672, 2481.09692, -1672.31201, 12.637, 0.00, 0.00, 44); // объект 84
	CreateDynamicObject(2672, 2490.41406, -1658.56995, 12.637, 0.00, 0.00, 43.995); // объект 85
	CreateDynamicObject(2672, 2500.79712, -1677.64795, 12.637, 0.00, 0.00, 59.995); // объект 86
	CreateDynamicObject(2672, 2495.46899, -1671.67896, 12.637, 0.00, 0.00, 59.991); // объект 87
	CreateDynamicObject(2672, 2494.19604, -1678.51294, 12.637, 0.00, 0.00, 167.991); // объект 88
	CreateDynamicObject(2672, 2485.01099, -1670.25, 12.637, 0.00, 0.00, 167.986); // объект 89
	CreateDynamicObject(2676, 2504.24097, -1664.95605, 12.486, 0.00, 0.00, 0.00); // объект 90
	CreateDynamicObject(2676, 2501.08203, -1659.79395, 12.486, 0.00, 0.00, 82); // объект 91
	CreateDynamicObject(2676, 2473.13208, -1658.21497, 12.486, 0.00, 0.00, 105.996); // объект 92
	CreateDynamicObject(2676, 2471.79004, -1674.31396, 12.486, 0.00, 0.00, 147.996); // объект 93
	CreateDynamicObject(1327, 2526.97607, -1663.45996, 14.794, 0.00, 4.25, 92); // объект 94
	CreateDynamicObject(12957, 2497.63696, -1653.22302, 13.162, 0.00, 0.00, 0.00); // объект 95
	CreateDynamicObject(3594, 2510.64307, -1687.56604, 12.945, 0.00, 358.248, 85.982); // объект 96
	//GateCCP
	CreateDynamicObject(3578, 1434.052, -1882.99805, 13.16, 0.00, 0.00, 0.00); // объект 0
	CreateDynamicObject(3578, 1420.30103, -1883.42004, 13.16, 0.00, 0.00, 0.00); // объект 1
	CreateDynamicObject(8210, 1380.88794, -1883.78796, 14.826, 0.00, 0.00, 358.75); // объект 2
	CreateDynamicObject(8210, 1278.37305, -1882.39099, 17.501, 0.00, 0.00, 4.498); // объект 3
	CreateDynamicObject(8210, 1223.83105, -1892.14294, 23.851, 0.00, 0.00, 14.989); // объект 4
	CreateDynamicObject(8210, 1278.39795, -1882.52502, 23.851, 0.00, 0.00, 4.739); // объект 5
	CreateDynamicObject(8210, 1223.93799, -1891.79895, 17.101, 0.00, 0.00, 14.985); // объект 6
	CreateDynamicObject(8210, 1169.38794, -1898.38, 23.851, 0.00, 0.00, 358.235); // объект 7
	CreateDynamicObject(8210, 1169.71899, -1898.05896, 17.376, 0.00, 0.00, 358.231); // объект 8
	CreateDynamicObject(8210, 1115.74402, -1903.51404, 17.101, 59.759, 352.039, 31.12); // объект 9
	CreateDynamicObject(8210, 1115.74304, -1903.51404, 18.526, 64.246, 359.995, 326.232); // объект 10
	CreateDynamicObject(8210, 1112.70203, -1897.27405, 21.526, 29.052, 7.151, 1.737); // объект 11
	CreateDynamicObject(8210, 1075.18103, -1924.33105, 20.126, 0.00, 0.00, 91.231); // объект 12
	CreateDynamicObject(8210, 1075.18103, -1924.33105, 27.126, 0.00, 0.00, 91.23); // объект 13
	CreateDynamicObject(8210, 1075.18103, -1924.33105, 33.876, 0.00, 0.00, 91.23); // объект 14
	CreateDynamicObject(8210, 1076.34802, -1979.896, 33.876, 0.00, 0.00, 91.23); // объект 15
	CreateDynamicObject(8210, 1076.34802, -1979.896, 27.126, 0.00, 0.00, 91.23); // объект 16
	CreateDynamicObject(8210, 1076.34802, -1979.896, 40.876, 0.00, 0.00, 91.23); // объект 17
	CreateDynamicObject(8210, 1076.34802, -1979.896, 47.626, 0.00, 0.00, 91.23); // объект 18
	CreateDynamicObject(8210, 1069.11597, -2034.16797, 47.626, 0.00, 0.00, 73.73); // объект 19
	CreateDynamicObject(8210, 1069.11499, -2034.16797, 41.126, 0.00, 0.00, 73.729); // объект 20
	CreateDynamicObject(8210, 1069.11401, -2034.16797, 34.376, 0.00, 0.00, 73.729); // объект 21
	CreateDynamicObject(8210, 1069.11304, -2034.16797, 27.126, 0.00, 0.00, 73.729); // объект 22
	CreateDynamicObject(8210, 1058.36804, -2088.62988, 47.576, 0.00, 0.00, 83.729); // объект 23
	CreateDynamicObject(8210, 1058.23206, -2088.44312, 40.376, 0.00, 0.00, 83.727); // объект 24
	CreateDynamicObject(8210, 1058.23206, -2088.44189, 33.126, 0.00, 0.00, 83.727); // объект 25
	CreateDynamicObject(8210, 1052.31006, -2143.75391, 47.576, 0.00, 0.00, 83.727); // объект 26
	CreateDynamicObject(8210, 1052.31006, -2143.75391, 40.326, 0.00, 0.00, 83.727); // объект 27
	CreateDynamicObject(8210, 1065.94104, -2193.82007, 47.576, 0.00, 0.00, 125.727); // объект 28
	CreateDynamicObject(8210, 1065.93994, -2193.81909, 40.576, 0.00, 0.00, 125.722); // объект 29
	CreateDynamicObject(8210, 1065.93994, -2193.81812, 54.576, 0.00, 0.00, 125.722); // объект 30
	CreateDynamicObject(8210, 1109.86804, -2218.86792, 54.576, 0.00, 0.00, 174.972); // объект 31
	CreateDynamicObject(8210, 1109.86694, -2218.86694, 47.326, 0.00, 0.00, 174.968); // объект 32
	CreateDynamicObject(8210, 1164.66797, -2223.67896, 47.326, 0.00, 0.00, 174.968); // объект 33
	CreateDynamicObject(8210, 1164.66797, -2223.67896, 40.326, 0.00, 0.00, 174.968); // объект 34
	CreateDynamicObject(8210, 1164.66797, -2223.67896, 54.576, 0.00, 0.00, 174.968); // объект 35
	CreateDynamicObject(8210, 1212.71802, -2206.91699, 54.401, 0.00, 0.00, 222.968); // объект 36
	CreateDynamicObject(8210, 1212.71802, -2206.91699, 47.401, 0.00, 0.00, 222.968); // объект 37
	CreateDynamicObject(8210, 1212.71802, -2206.91699, 40.401, 0.00, 0.00, 222.968); // объект 38
	CreateDynamicObject(8210, 1212.71802, -2206.91699, 33.651, 0.00, 0.00, 222.968); // объект 39
	CreateDynamicObject(8210, 1252.98206, -2169.14111, 38.801, 0.00, 0.00, 222.968); // объект 40
	CreateDynamicObject(8210, 1252.98206, -2169.14111, 45.901, 0.00, 0.00, 222.968); // объект 41
	CreateDynamicObject(8210, 1252.98206, -2169.14111, 52.651, 0.00, 0.00, 222.968); // объект 42
	CreateDynamicObject(8210, 1297.62195, -2136.84595, 52.651, 0.00, 0.00, 208.968); // объект 43
	CreateDynamicObject(8210, 1297.62097, -2136.84595, 45.651, 0.00, 0.00, 208.965); // объект 44
	CreateDynamicObject(8210, 1297.62, -2136.84595, 38.501, 0.00, 0.00, 208.965); // объект 45
	CreateDynamicObject(8210, 1346.05701, -2110.01294, 38.501, 0.00, 0.00, 208.965); // объект 46
	CreateDynamicObject(8210, 1346.05701, -2110.01294, 45.501, 0.00, 0.00, 208.965); // объект 47
	CreateDynamicObject(8210, 1346.05701, -2110.01294, 52.501, 0.00, 0.00, 208.965); // объект 48
	CreateDynamicObject(8210, 1395.08496, -2084.33301, 52.176, 0.00, 0.00, 206.465); // объект 49
	CreateDynamicObject(8210, 1395.08496, -2084.33301, 45.001, 0.00, 0.00, 206.461); // объект 50
	CreateDynamicObject(8210, 1446.70203, -2065.83398, 44.576, 0.00, 0.00, 193.211); // объект 51
	CreateDynamicObject(8210, 1446.70105, -2065.83398, 51.576, 0.00, 0.00, 193.206); // объект 52
	CreateDynamicObject(8210, 1446.69995, -2065.83398, 37.826, 0.00, 0.00, 193.206); // объект 53
	CreateDynamicObject(8210, 1446.69897, -2065.83398, 30.826, 0.00, 0.00, 193.206); // объект 54
	CreateDynamicObject(8210, 1491.53101, -2055.34595, 30.826, 0.00, 0.00, 193.206); // объект 55
	CreateDynamicObject(8210, 1491.53003, -2055.34595, 37.576, 0.00, 0.00, 193.206); // объект 56
	CreateDynamicObject(8210, 1491.52905, -2055.34595, 44.076, 0.00, 0.00, 193.206); // объект 57
	CreateDynamicObject(8210, 1510.19995, -2022.78601, 32.076, 316.034, 2.779, 285.136); // объект 58
	CreateDynamicObject(8210, 1518.18103, -2003.12305, 28.076, 27.209, 350.993, 267.353); // объект 59
	CreateDynamicObject(8210, 1519.16394, -1917.61401, 22.901, 0.00, 0.00, 90.5); // объект 60
	CreateDynamicObject(8210, 1519.16296, -1917.61304, 28.151, 0.00, 0.00, 90.5); // объект 61
	CreateDynamicObject(8210, 1512.16895, -2021.49695, 36.351, 335.515, 2.194, 284.117); // объект 62
	CreateDynamicObject(8210, 1507.82397, -1974.66602, 25.226, 75.815, 331.314, 303.151); // объект 63
	CreateDynamicObject(8210, 1405.80603, -1929.40906, 24.826, 0.00, 0.00, 94.748); // объект 64
	CreateDynamicObject(987, 1404.08704, -1913.22595, 17.232, 0.00, 0.5, 90); // объект 65
	CreateDynamicObject(987, 1404.01294, -1913.21997, 12.482, 0.00, 0.00, 89.246); // объект 66
	CreateDynamicObject(987, 1407.10803, -1943.20496, 16.932, 0.00, 0.00, 94.996); // объект 67
	CreateDynamicObject(987, 1407.10706, -1943.20398, 12.032, 0.00, 0.00, 94.993); // объект 68
	CreateDynamicObject(987, 1404.87695, -1923.39905, 12.032, 0.00, 0.00, 94.993); // объект 69
	CreateDynamicObject(987, 1404.87695, -1923.39795, 16.957, 0.00, 359, 94.993); // объект 70
	CreateDynamicObject(987, 1405.08606, -1922.302, 22.457, 89.75, 180, 95.493); // объект 71
	CreateDynamicObject(987, 1399.17004, -1923.48804, 22.457, 2, 90.038, 359.484); // объект 72
	CreateDynamicObject(987, 1406.73999, -1931.17896, 22.457, 2, 90.033, 186.229); // объект 73
	CreateDynamicObject(10357, 1387.651, -2009.82605, 104.529, 0.00, 0.00, 0.00); // объект 74
	CreateDynamicObject(1278, 1396.21204, -1921.85999, 29.337, 0.00, 0.00, 0.00); // объект 75
	CreateDynamicObject(1278, 1396.26501, -1935.48999, 29.212, 0.00, 0.00, 0.00); // объект 76
	CreateDynamicObject(2892, 1407.13306, -1928.31897, 15.483, 0.00, 8.25, 4); // объект 77
	CreateDynamicObject(3673, 1323.65198, -1987.44702, 65.143, 0.00, 0.00, 173.995); // объект 78
	CreateDynamicObject(3257, 1323.89795, -1997.85205, 45.062, 0.00, 0.00, 268); // объект 79
	CreateDynamicObject(16079, 1319.17395, -2022.73401, 60.211, 0.00, 0.00, 250); // объект 80
	CreateDynamicObject(1681, 1121.02795, -1919.49402, 37.223, 11.875, 344.152, 252.924); // объект 81
	CreateDynamicObject(10984, 1120.68201, -1920.08606, 36.39, 0.00, 21, 116); // объект 82
	CreateDynamicObject(18691, 1115.44397, -1919.44604, 34.027, 0.00, 0.00, 0.00); // объект 83
	CreateDynamicObject(18691, 1116.927, -1916.90601, 33.827, 0.00, 0.00, 0.00); // объект 84
	CreateDynamicObject(18691, 1125.70496, -1920.86804, 36.577, 0.00, 0.00, 0.00); // объект 85
	CreateDynamicObject(18691, 1121.71106, -1913.61694, 32.577, 0.00, 0.00, 0.00); // объект 86
	CreateDynamicObject(18691, 1128.00305, -1917.01599, 34.327, 0.00, 0.00, 0.00); // объект 87
	CreateDynamicObject(9241, 1193.27698, -2019.11401, 69.592, 0.00, 0.00, 0.00); // объект 88
	CreateDynamicObject(9241, 1157.73096, -2018.70801, 69.567, 0.00, 0.00, 270.5); // объект 89
	CreateDynamicObject(9241, 1157.49304, -2053.84204, 69.542, 0.00, 0.00, 0.5); // объект 90
	CreateDynamicObject(9241, 1193.67896, -2052.99097, 69.542, 0.00, 0.00, 90.75); // объект 91
	CreateDynamicObject(3279, 1373.45996, -1889.98401, 12.095, 0.00, 0.00, 272); // объект 92
	CreateDynamicObject(3502, 1096.71106, -1873.87195, 13.476, 0.00, 0.00, 0.00); // объект 93
	CreateDynamicObject(3502, 1084.47595, -1881.16101, 13.476, 0.00, 0.00, 356); // объект 94
	CreateDynamicObject(3502, 1103.26599, -1887.55798, 9.301, 270.901, 123.688, 116.437); // объект 95
	CreateDynamicObject(3502, 1114.02002, -1889.31995, 14.551, 9.5, 0.76, 190.62); // объект 96
	CreateDynamicObject(854, 1084.35095, -1882.26294, 13.801, 0.00, 98, 266); // объект 97
	CreateDynamicObject(854, 1083.66895, -1882.40698, 13.176, 0.00, 91.748, 267.745); // объект 98
	CreateDynamicObject(854, 1084.39502, -1882.43799, 13.176, 0.00, 90.997, 270.242); // объект 99
	CreateDynamicObject(854, 1084.89294, -1882.46106, 13.176, 0.00, 90.994, 270.242); // объект 100
	CreateDynamicObject(854, 1085.45496, -1882.20996, 13.376, 0.00, 90.994, 270.242); // объект 101
	CreateDynamicObject(854, 1085.55396, -1882.21399, 13.701, 0.00, 90.994, 270.242); // объект 102
	CreateDynamicObject(854, 1084.96704, -1882.43896, 13.726, 359.987, 91.494, 269.742); // объект 103
	CreateDynamicObject(854, 1084.01294, -1882.47205, 13.526, 359.984, 91.494, 269.742); // объект 104
	CreateDynamicObject(854, 1084.16394, -1882.453, 14.301, 0.01, 85.5, 270.242); // объект 105
	CreateDynamicObject(854, 1084.67395, -1882.21204, 14.776, 359.283, 64.755, 271.831); // объект 106
	CreateDynamicObject(854, 1096.56995, -1874.04895, 13.58, 81.163, 42.875, 317.466); // объект 107
	CreateDynamicObject(854, 1097.31995, -1874.08203, 13.58, 81.161, 42.874, 318.211); // объект 108
	CreateDynamicObject(854, 1096.01404, -1874.125, 13.18, 81.156, 42.869, 318.208); // объект 109
	CreateDynamicObject(854, 1097.39001, -1874.13794, 13.18, 81.156, 42.869, 318.208); // объект 110
	CreateDynamicObject(854, 1096.43896, -1874.10498, 14.38, 81.156, 42.869, 318.208); // объект 111
	CreateDynamicObject(854, 1097.18896, -1874.13, 14.28, 81.156, 42.869, 318.208); // объект 112
	CreateDynamicObject(854, 1095.88696, -1874.08606, 13.855, 81.156, 42.869, 318.208); // объект 113
	CreateDynamicObject(854, 1096.18506, -1874.146, 14.13, 81.156, 42.869, 318.208); // объект 114
	CreateDynamicObject(854, 1097.55896, -1874.24304, 13.93, 26.312, 86.767, 277.997); // объект 115
	CreateDynamicObject(854, 1096.38, -1874.26501, 13.805, 328.723, 93.976, 278.349); // объект 116
	CreateDynamicObject(853, 1103.27905, -1887.46399, 12.903, 0.00, 0.00, 0.00); // объект 117
	CreateDynamicObject(852, 1102.72705, -1887.15295, 12.516, 0.00, 0.00, 0.00); // объект 118
	CreateDynamicObject(849, 1103.54297, -1887.64502, 12.794, 0.00, 0.00, 0.00); // объект 119
	CreateDynamicObject(854, 1103.49902, -1887.95801, 12.768, 0.00, 0.00, 0.00); // объект 120
	CreateDynamicObject(854, 1103.08105, -1887.03296, 12.768, 0.00, 0.00, 0.00); // объект 121
	CreateDynamicObject(854, 1114.08899, -1889.85901, 14.09, 289.644, 246.813, 245.544); // объект 122
	CreateDynamicObject(854, 1114.08899, -1889.85803, 15.04, 286.737, 242.132, 241.095); // объект 123
	CreateDynamicObject(854, 1113.76904, -1889.80005, 14.365, 286.732, 242.128, 241.095); // объект 124
	CreateDynamicObject(854, 1113.81995, -1889.68604, 14.915, 286.732, 242.128, 241.095); // объект 125
	CreateDynamicObject(854, 1114.46997, -1889.84998, 14.54, 294.745, 252.246, 250.584); // объект 126
	CreateDynamicObject(854, 1114.39905, -1889.76294, 14.915, 294.918, 249.481, 246.076); // объект 127
	///Hive1
	CreateObject(13612, 1346.4004, -1325.2998, 2681.5, 0, 0, 0); // Объект 0
	CreateObject(4812, 1308.7998, -1327.09961, 2680.80005, 0, 2, 93.983); // Объект 1
	CreateObject(9139, 1322.5996, -1296, 2715.2, 0, 0.242, 253.993); // Объект 2
	CreateObject(4812, 1327.7998, -1336, 2680.8, 0, 0, 0.989); // Объект 3
	CreateObject(899, 1312.8, -1296.1, 2681.1001, 0, 0, 0); // Объект 4
	CreateObject(901, 1339.0996, -1323.7998, 2680.2, 0, 351.996, 0); // Объект 5
	CreateObject(901, 1341.8, -1328.2, 2679.2, 15, 14, 295.5); // Объект 6
	CreateObject(901, 1346.2002, -1317.7998, 2679.1001, 0, 0, 65.995); // Объект 7
	CreateObject(901, 1348.6, -1322.9, 2677.5, 0, 0, 65.995); // Объект 8
	CreateObject(901, 1342.7002, -1330.5, 2677.5, 0, 0, 15.991); // Объект 9
	CreateObject(901, 1330.2002, -1326.9004, 2677.5, 0, 0, 113.989); // Объект 10
	CreateObject(901, 1337.9004, -1316.0996, 2677.5, 0, 0, 35.986); // Объект 11
	CreateObject(3865, 1314.5, -1301, 2687.9204, 9.976, 5.125, 33.041); // Объект 12
	CreateObject(3865, 1310.2002, -1330.4004, 2682.8, 11.997, 0, 99.998); // Объект 13
	CreateObject(3865, 1373.7, -1320.9, 2682.8, 11.997, 0, 283.998); // Объект 14
	CreateObject(3865, 1369.7998, -1332.9004, 2682.8, 11.992, 0, 233.987); // Объект 15
	CreateObject(3865, 1365.0996, -1310, 2682.3, 5.982, 0, 325.992); // Объект 16
	CreateObject(3865, 1324.2002, -1345.5996, 2682.8, 11.981, 0, 179.984); // Объект 17
	CreateObject(3865, 1334.9004, -1302.0996, 2682.8, 0.461, 29.515, 342.323); // Объект 18
	CreateObject(17453, 1413, -1288.1, 2683.5, 0, 0.25, 0); // Объект 19
	CreateObject(9831, 1333.9, -1305, 2681.3, 17, 0, 178); // Объект 20
	CreateObject(3092, 1347.8, -1344.6, 2686.8999, 0, 0, 0); // Объект 21
	CreateObject(2908, 1343.5, -1320.8, 2682.8999, 0, 0, 0); // Объект 22
	CreateObject(2908, 1343.5, -1325.4, 2682.8999, 0, 0, 260); // Объект 23
	CreateObject(2908, 1341.4, -1319.4, 2682.8999, 0, 325.75, 233.997); // Объект 24
	CreateObject(2907, 1340.9, -1304.4, 2680.8999, 0, 0, 0); // Объект 25
	CreateObject(2905, 1338.4, -1304, 2680.8999, 0, 0, 62); // Объект 26
	CreateObject(2908, 1329.4, -1302.9, 2681, 0, 0, 76); // Объект 27
	CreateObject(2907, 1318.7, -1302.1, 2685.7, 350, 1, 180); // Объект 28
	CreateObject(2905, 1313.6499, -1305.7321, 2685.4785, 15, 0, 0); // Объект 29
	CreateObject(2907, 1326.7, -1301.9, 2681.1001, 0, 0, 96); // Объект 30
	CreateObject(2906, 1331.1, -1303.8, 2680.8999, 0, 0, 48); // Объект 31
	CreateObject(2906, 1340.1, -1303.6, 2680.8999, 0, 0, 293.999); // Объект 32
	CreateObject(2906, 1336.5, -1303.7, 2680.8999, 0, 0, 9.994); // Объект 33
	CreateObject(2905, 1346.3, -1304.8, 2680.8, 0, 180, 40); // Объект 34
	CreateObject(2908, 1332.6, -1330.3, 2681.3999, 0, 0, 0); // Объект 35
	CreateObject(2908, 1343.1, -1327.3, 2684, 345, 180, 342); // Объект 36
	CreateObject(2908, 1337.6, -1333, 2681.3, 0, 0, 114); // Объект 37
	CreateObject(2908, 1348.8, -1325.3, 2681.3999, 15, 182, 64); // Объект 38
    CreateObject(2908, 1337.2, -1322.4, 2684.7, 0, 0, 0); // Объект 0
	CreateObject(2908, 1337.1, -1315.4, 2681.9099, 0, 210, 50); // Объект 1
	CreateObject(2908, 1340.6, -1316.4, 2681.3, 0, 184, 0); // Объект 2
	CreateObject(2908, 1336.2, -1326.8, 2683.1001, 333.143, 293.137, 64.01); // Объект 3
	CreateObject(2908, 1348, -1319.9, 2682.5901, 0, 254, 84); // Объект 4
	CreateObject(2907, 1330.4, -1327.6, 2682, 0, 0, 0); // Объект 5
	CreateObject(2906, 1336.4004, -1316.4004, 2682.001, 5.999, 0, 0); // Объект 6
	CreateObject(2905, 1335.6, -1322.5, 2683.8999, 0, 0, 0); // Объект 7
	CreateObject(2907, 1345.2002, -1318.4004, 2683.7, 0, 159.747, 119.998); // Объект 8
	CreateObject(880, 1335.4, -1299.6, 2685, 339.179, 72.214, 306.028); // Объект 9
	CreateObject(807, 1320.3, -1302.1, 2685.6001, 0, 0, 0); // Объект 10
	CreateObject(868, 1313.3, -1300.1, 2687.8999, 0, 354.5, 322); // Объект 11
	CreateObject(868, 1313.7998, -1299.7998, 2687.3999, 0, 0, 0); // Объект 12
	CreateObject(880, 1313.1, -1300.1, 2689.1001, 0, 272, 329); // Объект 13
	CreateObject(828, 1311.4, -1330.1, 2681.1001, 0, 0, 0); // Объект 14
	CreateObject(901, 1299.5, -1334.5, 2685.2, 0, 0, 0); // Объект 15
	CreateObject(828, 1309.3, -1330.3, 2681.8999, 0, 0, 0); // Объект 16
	CreateObject(807, 1308.7, -1329.9, 2682.3, 0, 0, 0); // Объект 17
	CreateObject(854, 1313.6, -1298.6, 2688.5, 0, 92, 303.495); // Объект 18
	CreateObject(854, 1308, -1330.3, 2683.3999, 0, 53, 0); // Объект 19
	CreateObject(3092, 1308.5, -1320.3, 2686.8999, 0, 0.75, 256.75); // Объект 20
	CreateObject(868, 1372.7, -1334.9, 2683.3999, 0, 29.5, 235.248); // Объект 21
	CreateObject(880, 1359.5, -1345.3, 2682.8, 0, 0, 0); // Объект 22
	CreateObject(3865, 1363.4, -1346.4, 2682.8, 11.992, 0, 195.987); // Объект 23
	CreateObject(807, 1362.1, -1343.1, 2680.8999, 0, 0, 0); // Объект 24
	CreateObject(807, 1371.5, -1334.5, 2683.3, 0, 261.75, 349.75); // Объект 25
	CreateObject(3865, 1349.9, -1304.5, 2686.8, 0, 0, 0); // Объект 26
	CreateObject(3865, 1349.8, -1311.4, 2686.8, 0, 0, 0); // Объект 27
	CreateObject(3865, 1349.7, -1316.8, 2686.8, 0, 0, 358); // Объект 28
	CreateObject(3865, 1349.5, -1322.9004, 2686.8, 0, 0, 359.995); // Объект 29
	CreateObject(3865, 1351.5, -1330.6, 2686.8, 0, 0, 29.494); // Объект 30
	CreateObject(3865, 1354.4, -1336.4, 2681.3999, 59.983, 358.056, 25.478); // Объект 31
	CreateObject(3931, 1348.3, -1321.4, 2686.6001, 0, 0, 0); // Объект 32
	CreateObject(3929, 1348.9, -1321.4, 2686.1001, 0, 0, 0); // Объект 33
	CreateObject(828, 1349.6, -1321.1, 2685.7, 0, 0, 0); // Объект 34
	CreateObject(758, 1350.4, -1317.1, 2685.6001, 0, 0, 0); // Объект 35
	CreateObject(16530, 1326.5, -1329.6, 2684.5, 352.939, 3.998, 182.112); // Объект 36
	CreateObject(16766, 1326.3, -1311.4, 2685.2, 0, 358.5, 0); // Объект 37
	CreateObject(964, 1334.7, -1311.4, 2680.01, 0, 0, 0); // Объект 38
	CreateObject(3865, 1358.9004, -1338.2998, 2681.3999, 315.818, 180.346, 41.166); // Объект 39
	CreateObject(9831, 1370.1, -1332.7, 2681.3, 0, 4, 62); // Объект 40
	CreateObject(9831, 1314.7, -1301.9, 2685.3, 0.96, 3.549, 226.634); // Объект 41
	CreateObject(9831, 1362.9004, -1341.2998, 2681.3, 0, 0, 7.998); // Объект 42
	CreateObject(828, 1324.8, -1345.2, 2683, 0, 0, 323); // Объект 43
	CreateObject(807, 1323.6, -1345.9, 2683.2, 0, 0, 0); // Объект 44
	CreateObject(3930, 1324.4, -1345.6, 2682, 0, 0, 0); // Объект 45
	CreateObject(3930, 1325.6, -1345.6, 2682.7, 0, 0, 0); // Объект 46
	CreateObject(3930, 1323.1, -1346.5, 2682.8999, 0, 0, 0); // Объект 47
	CreateObject(3930, 1323.2, -1346.2, 2682.6001, 0, 0, 0); // Объект 48
	CreateObject(10984, 1332, -1335.5996, 2680.6001, 0, 0, 0); // Объект 49
	CreateObject(1383, 1313.39941, -1340.89941, 2711, 0, 0, 0); // Объект 50
	CreateObject(1383, 1364.2002, -1318.7002, 2699, 0, 0, 0); // Объект 51
	CreateObject(1383, 1341.2, -1342.2, 2704.3999, 0, 0, 275.999); // Объект 52
	CreateObject(3675, 1354.1, -1306.6, 2685.3, 0, 0.75, 352); // Объект 53
	CreateObject(3675, 1346.2002, -1304.7998, 2685.3, 0, 0.742, 351.991); // Объект 54
	CreateObject(7347, 1343, -1363.2, 2701.1001, 327.984, 359.39, 4.763); // Объект 55
	CreateObject(12930, 1315.9, -1324.3, 2681.1001, 0, 0, 0); // Объект 56
	CreateObject(10984, 1351.6, -1321.7, 2680.6001, 0, 0, 162); // Объект 57
	CreateObject(10984, 1347.2, -1325.9, 2680.6001, 0, 0, 101.999); // Объект 58
	CreateObject(10984, 1344.8, -1328.3, 2680.6001, 0, 0, 101.997); // Объект 59
	CreateObject(10984, 1340, -1329.9, 2680.6001, 0, 0, 101.997); // Объект 60
	CreateObject(10984, 1325.3, -1325.6, 2680.6001, 0, 0, 109.997); // Объект 61
	CreateObject(10984, 1329.4, -1319.5, 2680.6001, 0, 0, 109.995); // Объект 62
	CreateObject(10984, 1333.2, -1317.6, 2680.6001, 0, 0, 109.995); // Объект 63
	CreateObject(10984, 1345.3, -1314.7, 2680.6001, 0, 0, 109.995); // Объект 64
	CreateObject(10984, 1348.9, -1315.6, 2680.6001, 0, 0, 78.995); // Объект 65
	CreateObject(1237, 1311.7, -1323.7, 2680.2, 0, 0, 0); // Объект 66
	CreateObject(1237, 1319.8, -1323.7, 2680.2, 0, 0, 0); // Объект 67
	CreateObject(1282, 1313.1, -1324.2, 2680.8999, 0, 0, 90); // Объект 68
	CreateObject(1282, 1315.2, -1324.2, 2680.8999, 0, 0, 90); // Объект 69
	CreateObject(1282, 1317.8, -1324.2, 2680.8999, 0, 0, 90); // Объект 70
	CreateObject(1437, 1326.1, -1305, 2681.3999, 324.991, 0.278, 32.697); // Объект 71
	CreateObject(13612, 1347.2998, -1328.7998, 2690.5198, 0, 179.341, 347.992); // Объект 72
	CreateObject(854, 1324.8, -1344.8, 2682.499, 0, 264, 275.75); // Объект 73
	CreateObject(854, 1323.8, -1345, 2682.3999, 0, 263.996, 275.746); // Объект 74
	CreateObject(854, 1324.2, -1344.9, 2682.8999, 0, 262.746, 278.746); // Объект 75
	CreateObject(854, 1324.2002, -1344.9004, 2682.3999, 0, 262.744, 278.745); // Объект 76
	CreateObject(854, 1324.2002, -1344.9004, 2682.3999, 0, 262.744, 278.745); // Объект 77
	CreateObject(854, 1313.5996, -1298.5996, 2687.8, 0, 91.994, 303.492); // Объект 78
	CreateObject(854, 1365, -1309.1, 2682.3999, 0, 276.5, 44.5); // Объект 79
	CreateObject(854, 1365, -1309.2, 2682.2, 0, 278.748, 43.495); // Объект 80
	CreateObject(854, 1365.3, -1309.6, 2682.2, 0, 276.495, 41.489); // Объект 81
	CreateObject(854, 1365.5, -1309.9, 2682.2, 0, 273.993, 40.734); // Объект 82
	CreateObject(854, 1365.5, -1309.9004, 2682.6201, 0, 273.988, 43.232); // Объект 83
	CreateObject(854, 1365.1, -1309.3, 2682.6001, 0, 270.738, 36.232); // Объект 84
    CreateObject(854, 1372.6, -1320.2, 2682.5, 0, 270.747, 29.745); // Объект 1
	CreateObject(854, 1373.2, -1321.4, 2682.5, 0, 270.747, 29.745); // Объект 2
	CreateObject(854, 1373.2002, -1321.4004, 2682.5, 0, 270.747, 29.745); // Объект 3
	CreateObject(854, 1372.9, -1321, 2682.4001, 0, 274.497, 30.495); // Объект 4
	CreateObject(854, 1372.5, -1320.6, 2682.3999, 0, 272.493, 34.993); // Объект 5
	CreateObject(854, 1372.6, -1320.7, 2682.8, 0, 271.489, 31.739); // Объект 6
	CreateObject(854, 1373, -1321.3, 2682.9619, 0, 272.989, 31.489); // Объект 7
	CreateObject(854, 1373, -1321.5, 2682.6001, 0, 268.234, 28.987); // Объект 8
	CreateObject(854, 1372.7, -1320.6, 2682.6001, 0, 268.995, 27.999); // Объект 9
	CreateObject(854, 1372.7, -1320.6, 2682.6001, 0, 268.995, 27.999); // Объект 10
	CreateObject(854, 1372.8, -1321.1, 2682.8999, 0, 267.249, 25.999); // Объект 11
	CreateObject(854, 1371.4, -1334.5, 2683.2, 0, 248.75, 314.5); // Объект 12
	CreateObject(854, 1371.8, -1333.7, 2683.3, 0, 246.75, 341); // Объект 13
	CreateObject(854, 1371.7, -1334.4, 2683.2, 0, 255.249, 314.496); // Объект 14
	CreateObject(854, 1371.9004, -1333.7998, 2682.8999, 0, 246.495, 338); // Объект 15
	CreateObject(854, 1371.4, -1334.6, 2683.3, 0, 245.247, 334.499); // Объект 16
	CreateObject(854, 1371.7, -1334, 2683.6001, 0, 237.247, 332.999); // Объект 17
	CreateObject(854, 1371.4004, -1334.5996, 2683.3, 0, 245.242, 334.495); // Объект 18
	CreateObject(4812, 1317, -1331.9, 2680.8, 0, 2, 94.983); // Объект 19
	CreateObject(3865, 1377.1, -1337.9, 2684.8, 11.992, 0, 237.737); // Объект 20
	CreateObject(3865, 1324.1, -1354.5, 2684.5, 11.976, 358.467, 180.302); // Объект 21
	CreateObject(4812, 1316.6, -1335.8, 2680.8, 0, 0, 0.989); // Объект 22
	CreateObject(18739, 1324.24597, -1349.21399, 2677.89111, 356.685, 34.065, 82.239); // Объект 23
	CreateObject(18720, 1348.10999, -1319.37097, 2686.43604, 355.114, 72.655, 15.254); // Объект 24
	CreateObject(19836, 1313.39795, -1338.12097, 2682.55103, 0, 360, 0); // Объект 25
	CreateObject(19836, 1316.26599, -1340.80298, 2682.55103, 0, 359.995, 0); // Объект 26
	///FENCES OF ALL LSA
	CreateDynamicObject(8263, 1154.58899, -761.448, 61.11, 0.00, 0.00, 0.00); // объект 0
	CreateDynamicObject(8263, 1154.58899, -761.44702, 68.11, 0.00, 0.00, 0.00); // объект 1
	CreateDynamicObject(8263, 1154.58887, -761.44531, 74.96, 0.00, 0.00, 0.00); // объект 2
	CreateDynamicObject(8263, 1154.58899, -761.44501, 81.935, 0.00, 0.00, 0.00); // объект 3
	CreateDynamicObject(8263, 1154.58899, -761.44397, 88.985, 0.00, 0.00, 0.00); // объект 4
	CreateDynamicObject(8263, 1154.58899, -761.44299, 95.985, 0.00, 0.00, 0.00); // объект 5
	CreateDynamicObject(8263, 1154.58899, -761.44202, 102.735, 0.00, 0.00, 0.00); // объект 6
	CreateDynamicObject(8263, 1154.58899, -761.44098, 109.735, 0.00, 0.00, 0.00); // объект 7
	CreateDynamicObject(8263, 1154.58899, -761.44, 116.735, 0.00, 0.00, 0.00); // объект 8
	CreateDynamicObject(8263, 1154.58899, -761.43903, 123.235, 0.00, 0.00, 0.00); // объект 9
	CreateDynamicObject(8263, 1154.58899, -761.43903, 129.235, 0.00, 0.00, 0.00); // объект 10
	CreateDynamicObject(8263, 1154.58899, -761.43903, 136.235, 0.00, 0.00, 0.00); // объект 11
	CreateDynamicObject(8263, 1154.58899, -761.43903, 142.485, 0.00, 0.00, 0.00); // объект 12
	CreateDynamicObject(8263, 1154.58899, -761.43903, 149.235, 0.00, 0.00, 0.00); // объект 13
	CreateDynamicObject(8263, 1273.91602, -761.52002, 96.205, 0.00, 0.00, 0.00); // объект 14
	CreateDynamicObject(8263, 1273.91602, -761.52002, 90.705, 0.00, 0.00, 0.00); // объект 15
	CreateDynamicObject(8263, 1273.91602, -761.52002, 103.705, 0.00, 0.00, 0.00); // объект 16
	CreateDynamicObject(8263, 1273.91602, -761.52002, 112.455, 0.00, 0.00, 0.00); // объект 17
	CreateDynamicObject(8263, 1273.91602, -761.52002, 108.205, 0.00, 0.00, 0.00); // объект 18
	CreateDynamicObject(8263, 1273.91602, -761.52002, 101.455, 0.00, 0.00, 0.00); // объект 19
	CreateDynamicObject(8263, 1273.91602, -761.52002, 120.955, 0.00, 0.00, 0.00); // объект 20
	CreateDynamicObject(8263, 1273.91602, -761.52002, 128.455, 0.00, 0.00, 0.00); // объект 21
	CreateDynamicObject(8263, 1273.91602, -761.52002, 132.705, 0.00, 0.00, 0.00); // объект 22
	CreateDynamicObject(8263, 1273.91602, -761.52002, 137.205, 0.00, 0.00, 0.00); // объект 23
	CreateDynamicObject(8263, 1273.91602, -761.52002, 141.455, 0.00, 0.00, 0.00); // объект 24
	CreateDynamicObject(8263, 1273.91602, -761.52002, 145.455, 0.00, 0.00, 0.00); // объект 25
	CreateDynamicObject(8263, 1273.91602, -761.52002, 149.205, 0.00, 0.00, 0.00); // объект 26
	CreateDynamicObject(8263, 1273.91602, -761.52002, 148.955, 0.00, 0.00, 0.00); // объект 27
	CreateDynamicObject(8263, 1273.91602, -761.52002, 114.115, 0.00, 0.00, 0.00); // объект 28
	CreateDynamicObject(8263, 1393.552, -761.48199, 94.375, 0.00, 0.00, 0.00); // объект 29
	CreateDynamicObject(8263, 1393.552, -761.48102, 102.125, 0.00, 0.00, 0.00); // объект 30
	CreateDynamicObject(8263, 1393.552, -761.47998, 101.125, 0.00, 0.00, 0.00); // объект 31
	CreateDynamicObject(8263, 1393.552, -761.47998, 108.875, 0.00, 0.00, 0.00); // объект 32
	CreateDynamicObject(8263, 1393.552, -761.47998, 115.625, 0.00, 0.00, 0.00); // объект 33
	CreateDynamicObject(8263, 1393.552, -761.47998, 122.125, 0.00, 0.00, 0.00); // объект 34
	CreateDynamicObject(8263, 1393.55176, -761.47949, 128.875, 0.00, 0.00, 0.00); // объект 35
	CreateDynamicObject(8263, 1393.552, -761.47998, 135.875, 0.00, 0.00, 0.00); // объект 36
	CreateDynamicObject(8263, 1393.552, -761.47998, 142.375, 0.00, 0.00, 0.00); // объект 37
	CreateDynamicObject(8263, 1393.552, -761.47998, 149.375, 0.00, 0.00, 0.00); // объект 38
	CreateDynamicObject(8263, 1513.55103, -761.45398, 95.135, 0.00, 0.00, 0.00); // объект 39
	CreateDynamicObject(8263, 1513.55103, -761.453, 88.885, 0.00, 0.00, 0.00); // объект 40
	CreateDynamicObject(8263, 1513.55103, -761.45203, 81.885, 0.00, 0.00, 0.00); // объект 41
	CreateDynamicObject(8263, 1513.55103, -761.45099, 75.135, 0.00, 0.00, 0.00); // объект 42
	CreateDynamicObject(8263, 1513.55103, -761.45001, 68.135, 0.00, 0.00, 0.00); // объект 43
	CreateDynamicObject(8263, 1513.55103, -761.44897, 102.145, 0.00, 0.00, 0.00); // объект 44
	CreateDynamicObject(8263, 1513.55103, -761.448, 109.145, 0.00, 0.00, 0.00); // объект 45
	CreateDynamicObject(8263, 1513.55103, -761.44702, 115.895, 0.00, 0.00, 0.00); // объект 46
	CreateDynamicObject(8263, 1513.55103, -761.44598, 122.645, 0.00, 0.00, 0.00); // объект 47
	CreateDynamicObject(8263, 1513.55103, -761.44501, 129.645, 0.00, 0.00, 0.00); // объект 48
	CreateDynamicObject(8263, 1513.55103, -761.44397, 136.395, 0.00, 0.00, 0.00); // объект 49
	CreateDynamicObject(8263, 1513.55103, -761.44299, 143.395, 0.00, 0.00, 0.00); // объект 50
	CreateDynamicObject(8263, 1513.55103, -761.44202, 150.395, 0.00, 0.00, 0.00); // объект 51
	CreateDynamicObject(8263, 1621.60095, -726.026, 67.745, 0.00, 0.00, 36); // объект 52
	CreateDynamicObject(8263, 1621.60095, -726.02502, 60.745, 0.00, 0.00, 35.997); // объект 53
	CreateDynamicObject(8263, 1621.60095, -726.02399, 53.995, 0.00, 0.00, 35.997); // объект 54
	CreateDynamicObject(8263, 1621.60095, -726.02301, 74.585, 0.00, 0.00, 35.997); // объект 55
	CreateDynamicObject(8263, 1621.60095, -726.02197, 81.585, 0.00, 0.00, 35.997); // объект 56
	CreateDynamicObject(8263, 1621.60095, -726.02197, 88.585, 0.00, 0.00, 35.997); // объект 57
	CreateDynamicObject(8263, 1621.60095, -726.02197, 95.585, 0.00, 0.00, 35.997); // объект 58
	CreateDynamicObject(8263, 1621.60095, -726.02197, 102.585, 0.00, 0.00, 35.997); // объект 59
	CreateDynamicObject(8263, 1621.60095, -726.02197, 109.585, 0.00, 0.00, 35.997); // объект 60
	CreateDynamicObject(8263, 1621.60095, -726.02197, 116.335, 0.00, 0.00, 35.997); // объект 61
	CreateDynamicObject(8263, 1621.60095, -726.02197, 123.085, 0.00, 0.00, 35.997); // объект 62
	CreateDynamicObject(8263, 1621.60095, -726.02197, 130.08501, 0.00, 0.00, 35.997); // объект 63
	CreateDynamicObject(8263, 1621.60095, -726.02197, 137.08501, 0.00, 0.00, 35.997); // объект 64
	CreateDynamicObject(8263, 1621.60095, -726.02197, 143.83501, 0.00, 0.00, 35.997); // объект 65
	CreateDynamicObject(8263, 1621.60901, -726.021, 150.58501, 0.00, 0.00, 35.997); // объект 66
	CreateDynamicObject(8263, 1730.14697, -688.70801, 150.58501, 0.00, 0.00, 1.997); // объект 67
	CreateDynamicObject(8263, 1730.14697, -688.70801, 143.58501, 0.00, 0.00, 1.994); // объект 68
	CreateDynamicObject(8263, 1730.14697, -688.70801, 136.58501, 0.00, 0.00, 1.994); // объект 69
	CreateDynamicObject(8263, 1730.14697, -688.70801, 129.58501, 0.00, 0.00, 1.994); // объект 70
	CreateDynamicObject(8263, 1730.14697, -688.70801, 122.585, 0.00, 0.00, 1.994); // объект 71
	CreateDynamicObject(8263, 1730.14697, -688.70801, 115.835, 0.00, 0.00, 1.994); // объект 72
	CreateDynamicObject(8263, 1730.14697, -688.70801, 109.085, 0.00, 0.00, 1.994); // объект 73
	CreateDynamicObject(8263, 1730.14697, -688.70801, 102.085, 0.00, 0.00, 1.994); // объект 74
	CreateDynamicObject(8263, 1730.14697, -688.70801, 95.085, 0.00, 0.00, 1.994); // объект 75
	CreateDynamicObject(8263, 1730.14697, -688.70801, 88.585, 0.00, 0.00, 1.994); // объект 76
	CreateDynamicObject(8263, 1730.14697, -688.70801, 81.585, 0.00, 0.00, 1.994); // объект 77
	CreateDynamicObject(8263, 1730.14697, -688.70801, 74.835, 0.00, 0.00, 1.994); // объект 78
	CreateDynamicObject(8263, 1730.14697, -688.70801, 67.835, 0.00, 0.00, 1.994); // объект 79
	CreateDynamicObject(8263, 1730.14697, -688.70801, 60.835, 0.00, 0.00, 1.994); // объект 80
	CreateDynamicObject(8263, 1730.14697, -688.70801, 54.085, 0.00, 0.00, 1.994); // объект 81
	CreateDynamicObject(8263, 1730.14697, -688.70801, 48.085, 0.00, 0.00, 1.994); // объект 82
	CreateDynamicObject(8263, 1730.14697, -688.70801, 41.085, 0.00, 0.00, 1.994); // объект 83
	CreateDynamicObject(8263, 1830.31104, -731.35101, 86.395, 0.00, 0.00, 311.994); // объект 84
	CreateDynamicObject(8263, 1830.31104, -731.35101, 79.895, 0.00, 0.00, 311.99); // объект 85
	CreateDynamicObject(8263, 1830.31104, -731.35101, 73.145, 0.00, 0.00, 311.99); // объект 86
	CreateDynamicObject(8263, 1830.31104, -731.35101, 93.395, 0.00, 0.00, 311.99); // объект 87
	CreateDynamicObject(8263, 1830.31104, -731.35101, 100.395, 0.00, 0.00, 311.99); // объект 88
	CreateDynamicObject(8263, 1830.31104, -731.35101, 107.145, 0.00, 0.00, 311.99); // объект 89
	CreateDynamicObject(8263, 1830.31104, -731.35101, 114.145, 0.00, 0.00, 311.99); // объект 90
	CreateDynamicObject(8263, 1830.31104, -731.35101, 120.895, 0.00, 0.00, 311.99); // объект 91
	CreateDynamicObject(8263, 1830.31104, -731.35101, 127.895, 0.00, 0.00, 311.99); // объект 92
	CreateDynamicObject(8263, 1830.31104, -731.35101, 134.895, 0.00, 0.00, 311.99); // объект 93
	CreateDynamicObject(8263, 1830.31104, -731.35101, 141.895, 0.00, 0.00, 311.99); // объект 94
	CreateDynamicObject(8263, 1830.31104, -731.35101, 148.895, 0.00, 0.00, 311.99); // объект 95
	CreateDynamicObject(8263, 1830.31104, -731.35101, 150.895, 0.00, 0.00, 311.99); // объект 96
	CreateDynamicObject(8263, 1925.60205, -798.79199, 150.895, 0.00, 0.00, 337.49); // объект 97
	CreateDynamicObject(8263, 1925.60205, -798.79199, 143.895, 0.00, 0.00, 337.489); // объект 98
	CreateDynamicObject(8263, 1925.60205, -798.79199, 137.395, 0.00, 0.00, 337.489); // объект 99
	CreateDynamicObject(8263, 1925.60205, -798.79199, 130.895, 0.00, 0.00, 337.489); // объект 0
	CreateDynamicObject(8263, 1925.60205, -798.79199, 124.145, 0.00, 0.00, 337.489); // объект 1
	CreateDynamicObject(8263, 1925.60205, -798.79199, 117.395, 0.00, 0.00, 337.489); // объект 2
	CreateDynamicObject(8263, 1925.60205, -798.79199, 110.645, 0.00, 0.00, 337.489); // объект 3
	CreateDynamicObject(8263, 1925.60205, -798.79199, 103.645, 0.00, 0.00, 337.489); // объект 4
	CreateDynamicObject(8263, 1925.60205, -798.79199, 96.895, 0.00, 0.00, 337.489); // объект 5
	CreateDynamicObject(8263, 1925.60205, -798.79199, 89.895, 0.00, 0.00, 337.489); // объект 6
	CreateDynamicObject(8263, 1925.60205, -798.79199, 157.97501, 0.00, 0.00, 337.489); // объект 7
	CreateDynamicObject(8263, 1925.60205, -798.79199, 164.72501, 0.00, 0.00, 337.489); // объект 8
	CreateDynamicObject(8263, 2040.22205, -830.07898, 164.72501, 0.00, 0.00, 351.989); // объект 9
	CreateDynamicObject(8263, 2040.22205, -830.078, 157.97501, 0.00, 0.00, 351.985); // объект 10
	CreateDynamicObject(8263, 2040.22205, -830.07703, 151.22501, 0.00, 0.00, 351.985); // объект 11
	CreateDynamicObject(8263, 2040.22205, -830.07599, 144.22501, 0.00, 0.00, 351.985); // объект 12
	CreateDynamicObject(8263, 2040.22205, -830.07501, 137.22501, 0.00, 0.00, 351.985); // объект 13
	CreateDynamicObject(8263, 2040.22205, -830.07397, 130.47501, 0.00, 0.00, 351.985); // объект 14
	CreateDynamicObject(8263, 2040.22205, -830.073, 123.475, 0.00, 0.00, 351.985); // объект 15
	CreateDynamicObject(8263, 2040.22205, -830.07202, 116.475, 0.00, 0.00, 351.985); // объект 16
	CreateDynamicObject(8263, 2040.22205, -830.07098, 109.975, 0.00, 0.00, 351.985); // объект 17
	CreateDynamicObject(8263, 2040.22205, -830.07001, 103.225, 0.00, 0.00, 351.985); // объект 18
	CreateDynamicObject(8263, 2155.81201, -858.992, 103.225, 0.00, 0.00, 339.985); // объект 19
	CreateDynamicObject(8263, 2155.81201, -858.99103, 110.225, 0.00, 0.00, 339.983); // объект 20
	CreateDynamicObject(8263, 2155.81201, -858.98999, 117.225, 0.00, 0.00, 339.983); // объект 21
	CreateDynamicObject(8263, 2155.81201, -858.98901, 124.225, 0.00, 0.00, 339.983); // объект 22
	CreateDynamicObject(8263, 2155.81201, -858.98798, 131.22501, 0.00, 0.00, 339.983); // объект 23
	CreateDynamicObject(8263, 2155.81201, -858.987, 138.22501, 0.00, 0.00, 339.983); // объект 24
	CreateDynamicObject(8263, 2155.81201, -858.98602, 145.22501, 0.00, 0.00, 339.983); // объект 25
	CreateDynamicObject(8263, 2155.81201, -858.98499, 152.22501, 0.00, 0.00, 339.983); // объект 26
	CreateDynamicObject(8263, 2155.81201, -858.98401, 158.97501, 0.00, 0.00, 339.983); // объект 27
	CreateDynamicObject(8263, 2155.81201, -858.98297, 164.77499, 0.00, 0.00, 339.983); // объект 28
	CreateDynamicObject(8263, 2268.50903, -899.91498, 164.77499, 0.00, 0.00, 339.983); // объект 29
	CreateDynamicObject(8263, 2268.50903, -899.914, 158.02499, 0.00, 0.00, 339.983); // объект 30
	CreateDynamicObject(8263, 2268.50903, -899.91302, 151.27499, 0.00, 0.00, 339.983); // объект 31
	CreateDynamicObject(8263, 2268.50903, -899.91199, 145.02499, 0.00, 0.00, 339.983); // объект 32
	CreateDynamicObject(8263, 2268.50903, -899.91101, 139.02499, 0.00, 0.00, 339.983); // объект 33
	CreateDynamicObject(8263, 2268.50903, -899.90997, 133.02499, 0.00, 0.00, 339.983); // объект 34
	CreateDynamicObject(8263, 2268.50903, -899.909, 126.525, 0.00, 0.00, 339.983); // объект 35
	CreateDynamicObject(8263, 2268.50903, -899.90802, 119.525, 0.00, 0.00, 339.983); // объект 36
	CreateDynamicObject(8263, 2268.50903, -899.90698, 112.775, 0.00, 0.00, 339.983); // объект 37
	CreateDynamicObject(8263, 2268.50903, -899.90601, 106.275, 0.00, 0.00, 339.983); // объект 38
	CreateDynamicObject(8263, 2268.50903, -899.90503, 100.525, 0.00, 0.00, 339.983); // объект 39
	CreateDynamicObject(8263, 2268.50903, -899.90399, 93.775, 0.00, 0.00, 339.983); // объект 40
	CreateDynamicObject(8263, 2268.50903, -899.90302, 86.775, 0.00, 0.00, 339.983); // объект 41
	CreateDynamicObject(8263, 2155.83594, -858.98297, 96.2, 0.00, 0.00, 339.983); // объект 42
	CreateDynamicObject(8263, 2155.83594, -858.98199, 89.95, 0.00, 0.00, 339.983); // объект 43
	CreateDynamicObject(8263, 2384.448, -916.45801, 86.7, 0.00, 0.00, 3.733); // объект 44
	CreateDynamicObject(8263, 2384.44702, -916.45801, 93.45, 0.00, 0.00, 3.73); // объект 45
	CreateDynamicObject(8263, 2384.44604, -916.45801, 100.45, 0.00, 0.00, 3.73); // объект 46
	CreateDynamicObject(8263, 2384.44507, -916.45801, 107.2, 0.00, 0.00, 3.73); // объект 47
	CreateDynamicObject(8263, 2384.44409, -916.45801, 113.95, 0.00, 0.00, 3.73); // объект 48
	CreateDynamicObject(8263, 2384.44312, -916.45801, 120.7, 0.00, 0.00, 3.73); // объект 49
	CreateDynamicObject(8263, 2384.44312, -916.45801, 127.7, 0.00, 0.00, 3.73); // объект 50
	CreateDynamicObject(8263, 2384.44312, -916.45801, 134.7, 0.00, 0.00, 3.73); // объект 51
	CreateDynamicObject(8263, 2384.44312, -916.45801, 141.7, 0.00, 0.00, 3.73); // объект 52
	CreateDynamicObject(8263, 2384.44312, -916.45801, 148.7, 0.00, 0.00, 3.73); // объект 53
	CreateDynamicObject(8263, 2384.44312, -916.45801, 155.7, 0.00, 0.00, 3.73); // объект 54
	CreateDynamicObject(8263, 2384.44312, -916.45801, 162.7, 0.00, 0.00, 3.73); // объект 55
	CreateDynamicObject(8263, 2503.82202, -906.31299, 162.7, 0.00, 0.00, 5.98); // объект 56
	CreateDynamicObject(8263, 2503.82104, -906.31299, 155.95, 0.00, 0.00, 5.977); // объект 57
	CreateDynamicObject(8263, 2503.82007, -906.31299, 149.2, 0.00, 0.00, 5.977); // объект 58
	CreateDynamicObject(8263, 2503.81909, -906.31299, 142.45, 0.00, 0.00, 5.977); // объект 59
	CreateDynamicObject(8263, 2503.81812, -906.31299, 135.45, 0.00, 0.00, 5.977); // объект 60
	CreateDynamicObject(8263, 2503.81812, -906.31299, 129.2, 0.00, 0.00, 5.977); // объект 61
	CreateDynamicObject(8263, 2503.81812, -906.31299, 122.45, 0.00, 0.00, 5.977); // объект 62
	CreateDynamicObject(8263, 2503.81812, -906.31299, 115.45, 0.00, 0.00, 5.977); // объект 63
	CreateDynamicObject(8263, 2503.81812, -906.31299, 108.45, 0.00, 0.00, 5.977); // объект 64
	CreateDynamicObject(8263, 2503.81812, -906.31299, 101.95, 0.00, 0.00, 5.977); // объект 65
	CreateDynamicObject(8263, 2503.81812, -906.31299, 94.95, 0.00, 0.00, 5.977); // объект 66
	CreateDynamicObject(8263, 2503.81812, -906.31299, 88.2, 0.00, 0.00, 5.977); // объект 67
	CreateDynamicObject(8263, 2503.81812, -906.31299, 81.45, 0.00, 0.00, 5.977); // объект 68
	CreateDynamicObject(8263, 2503.81738, -906.3125, 81.45, 0.00, 0.00, 5.977); // объект 69
	CreateDynamicObject(8263, 2623.10205, -893.95697, 81.45, 0.00, 0.00, 5.977); // объект 70
	CreateDynamicObject(8263, 2623.10205, -893.95599, 74.7, 0.00, 0.00, 5.977); // объект 71
	CreateDynamicObject(8263, 2623.10205, -893.95502, 67.95, 0.00, 0.00, 5.977); // объект 72
	CreateDynamicObject(8263, 2623.10205, -893.95398, 88.4, 0.00, 0.00, 5.977); // объект 73
	CreateDynamicObject(8263, 2623.10205, -893.953, 95.4, 0.00, 0.00, 5.977); // объект 74
	CreateDynamicObject(8263, 2623.10205, -893.95203, 102.4, 0.00, 0.00, 5.977); // объект 75
	CreateDynamicObject(8263, 2623.10205, -893.95099, 109.15, 0.00, 0.00, 5.977); // объект 76
	CreateDynamicObject(8263, 2623.10205, -893.95001, 116.15, 0.00, 0.00, 5.977); // объект 77
	CreateDynamicObject(8263, 2623.10205, -893.94897, 123.15, 0.00, 0.00, 5.977); // объект 78
	CreateDynamicObject(8263, 2623.10205, -893.948, 130.14999, 0.00, 0.00, 5.977); // объект 79
	CreateDynamicObject(8263, 2623.10205, -893.94702, 137.14999, 0.00, 0.00, 5.977); // объект 80
	CreateDynamicObject(8263, 2623.10205, -893.94598, 143.89999, 0.00, 0.00, 5.977); // объект 81
	CreateDynamicObject(8263, 2623.10205, -893.94501, 150.89999, 0.00, 0.00, 5.977); // объект 82
	CreateDynamicObject(8263, 2623.10205, -893.94397, 157.39999, 0.00, 0.00, 5.977); // объект 83
	CreateDynamicObject(8263, 2623.927, -894.00598, 162.60001, 0.00, 0.00, 5.977); // объект 84
	CreateDynamicObject(8263, 2742.4021, -881.76501, 162.60001, 0.00, 0.00, 5.977); // объект 85
	CreateDynamicObject(8263, 2742.40088, -881.76501, 155.72, 0.00, 0.00, 5.977); // объект 86
	CreateDynamicObject(8263, 2742.40088, -881.76501, 148.72, 0.00, 0.00, 5.977); // объект 87
	CreateDynamicObject(8263, 2742.40088, -881.76501, 141.97, 0.00, 0.00, 5.977); // объект 88
	CreateDynamicObject(8263, 2742.40088, -881.76501, 134.97, 0.00, 0.00, 5.977); // объект 89
	CreateDynamicObject(8263, 2742.40088, -881.76501, 128.22, 0.00, 0.00, 5.977); // объект 90
	CreateDynamicObject(8263, 2742.40088, -881.76501, 121.22, 0.00, 0.00, 5.977); // объект 91
	CreateDynamicObject(8263, 2742.40088, -881.76501, 114.22, 0.00, 0.00, 5.977); // объект 92
	CreateDynamicObject(8263, 2742.40088, -881.76501, 107.72, 0.00, 0.00, 5.977); // объект 93
	CreateDynamicObject(8263, 2742.40088, -881.76501, 100.72, 0.00, 0.00, 5.977); // объект 94
	CreateDynamicObject(8263, 2742.40088, -881.76501, 93.72, 0.00, 0.00, 5.977); // объект 95
	CreateDynamicObject(8263, 2742.40088, -881.76501, 86.72, 0.00, 0.00, 5.977); // объект 96
	CreateDynamicObject(8263, 2742.40088, -881.76501, 79.72, 0.00, 0.00, 5.977); // объект 97
	CreateDynamicObject(8263, 2742.40088, -881.76501, 72.97, 0.00, 0.00, 5.977); // объект 98
	CreateDynamicObject(8263, 2742.40088, -881.76501, 65.97, 0.00, 0.00, 5.977); // объект 99
	CreateDynamicObject(8263, 2742.40088, -881.76501, 58.72, 0.00, 0.00, 5.977); // объект 0
	CreateDynamicObject(8263, 2742.40088, -881.76501, 51.72, 0.00, 0.00, 5.977); // объект 1
	CreateDynamicObject(8263, 2742.40088, -881.76501, 44.97, 0.00, 0.00, 5.977); // объект 2
	CreateDynamicObject(8263, 2742.40088, -881.76501, 37.97, 0.00, 0.00, 5.977); // объект 3
	CreateDynamicObject(8263, 2742.40088, -881.76501, 30.97, 0.00, 0.00, 5.977); // объект 4
	CreateDynamicObject(8263, 2742.40088, -881.76501, 23.72, 0.00, 0.00, 5.977); // объект 5
	CreateDynamicObject(8263, 2861.44897, -869.28198, 23.72, 0.00, 0.00, 5.977); // объект 6
	CreateDynamicObject(8263, 2861.448, -869.28101, 16.72, 0.00, 0.00, 5.977); // объект 7
	CreateDynamicObject(8263, 2861.44702, -869.28003, 9.72, 0.00, 0.00, 5.977); // объект 8
	CreateDynamicObject(8263, 2861.44604, -869.27899, 30.34, 0.00, 0.00, 5.977); // объект 9
	CreateDynamicObject(8263, 2861.44507, -869.27802, 37.34, 0.00, 0.00, 5.977); // объект 10
	CreateDynamicObject(8263, 2861.44409, -869.27698, 44.09, 0.00, 0.00, 5.977); // объект 11
	CreateDynamicObject(8263, 2861.44312, -869.276, 51.09, 0.00, 0.00, 5.977); // объект 12
	CreateDynamicObject(8263, 2861.44312, -869.27502, 58.09, 0.00, 0.00, 5.977); // объект 13
	CreateDynamicObject(8263, 2861.44312, -869.27399, 65.09, 0.00, 0.00, 5.977); // объект 14
	CreateDynamicObject(8263, 2861.44312, -869.27301, 72.09, 0.00, 0.00, 5.977); // объект 15
	CreateDynamicObject(8263, 2861.44312, -869.27197, 78.84, 0.00, 0.00, 5.977); // объект 16
	CreateDynamicObject(8263, 2980.58911, -857.09497, 78.84, 0.00, 0.00, 5.977); // объект 17
	CreateDynamicObject(8263, 2980.58911, -857.09497, 71.84, 0.00, 0.00, 5.977); // объект 18
	CreateDynamicObject(8263, 2980.58911, -857.09497, 65.09, 0.00, 0.00, 5.977); // объект 19
	CreateDynamicObject(8263, 2980.58911, -857.09497, 58.34, 0.00, 0.00, 5.977); // объект 20
	CreateDynamicObject(8263, 2980.58911, -857.09497, 51.34, 0.00, 0.00, 5.977); // объект 21
	CreateDynamicObject(8263, 2980.58911, -857.09497, 44.59, 0.00, 0.00, 5.977); // объект 22
	CreateDynamicObject(8263, 2980.58911, -857.09497, 37.59, 0.00, 0.00, 5.977); // объект 23
	CreateDynamicObject(8263, 2980.58911, -857.09497, 30.84, 0.00, 0.00, 5.977); // объект 24
	CreateDynamicObject(8263, 2980.58911, -857.09497, 24.09, 0.00, 0.00, 5.977); // объект 25
	CreateDynamicObject(8263, 2980.58911, -857.09497, 17.09, 0.00, 0.00, 5.977); // объект 26
	CreateDynamicObject(8263, 2980.58911, -857.09497, 10.09, 0.00, 0.00, 5.977); // объект 27
	CreateDynamicObject(8263, 2980.58911, -857.09497, 3.09, 0.00, 0.00, 5.977); // объект 28
	CreateDynamicObject(8263, 2980.58911, -857.09497, -3.91, 0.00, 0.00, 5.977); // объект 29
	CreateDynamicObject(8263, 2980.58911, -857.09497, -10.91, 0.00, 0.00, 5.977); // объект 30
	CreateDynamicObject(8263, 2980.58911, -857.09497, -17.91, 0.00, 0.00, 5.977); // объект 31
	CreateDynamicObject(8263, 2980.58911, -857.09497, -24.91, 0.00, 0.00, 5.977); // объект 32
	CreateDynamicObject(8263, 2980.58911, -857.09497, -31.91, 0.00, 0.00, 5.977); // объект 33
	CreateDynamicObject(8263, 2980.58911, -857.09497, -38.91, 0.00, 0.00, 5.977); // объект 34
	CreateDynamicObject(8263, 2980.58911, -857.09497, -45.91, 0.00, 0.00, 5.977); // объект 35
	CreateDynamicObject(8263, 2980.58911, -857.09497, -52.91, 0.00, 0.00, 5.977); // объект 36
	CreateDynamicObject(8263, 2980.58911, -857.09497, -59.91, 0.00, 0.00, 5.977); // объект 37
	CreateDynamicObject(8263, 2980.58911, -857.09497, -66.91, 0.00, 0.00, 5.977); // объект 38
	CreateDynamicObject(8263, 3099.70605, -844.57202, -66.91, 0.00, 0.00, 5.977); // объект 39
	CreateDynamicObject(8263, 3099.70605, -844.57098, -59.91, 0.00, 0.00, 5.977); // объект 40
	CreateDynamicObject(8263, 3099.70605, -844.57001, -52.91, 0.00, 0.00, 5.977); // объект 41
	CreateDynamicObject(8263, 3099.70605, -844.56897, -46.16, 0.00, 0.00, 5.977); // объект 42
	CreateDynamicObject(8263, 3099.70605, -844.56799, -39.16, 0.00, 0.00, 5.977); // объект 43
	CreateDynamicObject(8263, 3099.70605, -844.56702, -32.16, 0.00, 0.00, 5.977); // объект 44
	CreateDynamicObject(8263, 3099.70605, -844.56598, -25.16, 0.00, 0.00, 5.977); // объект 45
	CreateDynamicObject(8263, 3099.70605, -844.565, -17.91, 0.00, 0.00, 5.977); // объект 46
	CreateDynamicObject(8263, 3099.70605, -844.56403, -10.91, 0.00, 0.00, 5.977); // объект 47
	CreateDynamicObject(8263, 3099.70605, -844.56403, -3.91, 0.00, 0.00, 5.977); // объект 48
	CreateDynamicObject(8263, 3099.70605, -844.56403, 3.34, 0.00, 0.00, 5.977); // объект 49
	CreateDynamicObject(8263, 3099.70605, -844.56403, 10.34, 0.00, 0.00, 5.977); // объект 50
	CreateDynamicObject(8263, 3099.70605, -844.56403, 17.09, 0.00, 0.00, 5.977); // объект 51
	CreateDynamicObject(8263, 3099.70605, -844.56403, 24.09, 0.00, 0.00, 5.977); // объект 52
	CreateDynamicObject(8263, 3099.70605, -844.56403, 31.09, 0.00, 0.00, 5.977); // объект 53
	CreateDynamicObject(8263, 3099.70605, -844.56403, 38.34, 0.00, 0.00, 5.977); // объект 54
	CreateDynamicObject(8263, 3099.70605, -844.56403, 45.09, 0.00, 0.00, 5.977); // объект 55
	CreateDynamicObject(8263, 3099.70605, -844.56403, 51.84, 0.00, 0.00, 5.977); // объект 56
	CreateDynamicObject(8263, 3099.70605, -844.56403, 58.59, 0.00, 0.00, 5.977); // объект 57
	CreateDynamicObject(8263, 3099.70605, -844.56403, 65.59, 0.00, 0.00, 5.977); // объект 58
	CreateDynamicObject(8263, 3099.70605, -844.56403, 72.59, 0.00, 0.00, 5.977); // объект 59
	CreateDynamicObject(8263, 3099.70605, -844.56403, 79.34, 0.00, 0.00, 5.977); // объект 60
	CreateDynamicObject(8263, 3165.74292, -898.26099, 45.985, 0.00, 0.00, 275.977); // объект 61
	CreateDynamicObject(8263, 3165.74194, -898.26099, 39.235, 0.00, 0.00, 275.971); // объект 62
	CreateDynamicObject(8263, 3165.74097, -898.26099, 32.485, 0.00, 0.00, 275.971); // объект 63
	CreateDynamicObject(8263, 3165.73999, -898.26099, 25.485, 0.00, 0.00, 275.971); // объект 64
	CreateDynamicObject(8263, 3165.73901, -898.26099, 18.485, 0.00, 0.00, 275.971); // объект 65
	CreateDynamicObject(8263, 3165.73804, -898.26099, 11.485, 0.00, 0.00, 275.971); // объект 66
	CreateDynamicObject(8263, 3165.73706, -898.26099, 4.735, 0.00, 0.00, 275.971); // объект 67
	CreateDynamicObject(8263, 3165.73608, -898.26099, -2.265, 0.00, 0.00, 275.971); // объект 68
	CreateDynamicObject(8263, 3165.73511, -898.26099, -9.265, 0.00, 0.00, 275.971); // объект 69
	CreateDynamicObject(8263, 3165.73389, -898.26099, -16.265, 0.00, 0.00, 275.971); // объект 70
	CreateDynamicObject(8263, 3165.7334, -898.26074, -23.265, 0.00, 0.00, 275.966); // объект 71
	CreateDynamicObject(8263, 3165.73389, -898.26099, -30.265, 0.00, 0.00, 275.971); // объект 72
	CreateDynamicObject(8263, 3165.73389, -898.26099, -36.765, 0.00, 0.00, 275.971); // объект 73
	CreateDynamicObject(8263, 3165.73389, -898.26099, -43.765, 0.00, 0.00, 275.971); // объект 74
	CreateDynamicObject(8263, 3165.73389, -898.26099, -50.515, 0.00, 0.00, 275.971); // объект 75
	CreateDynamicObject(8263, 3165.73389, -898.26099, -57.515, 0.00, 0.00, 275.971); // объект 76
	CreateDynamicObject(8263, 3165.73389, -898.26099, -64.515, 0.00, 0.00, 275.971); // объект 77
	CreateDynamicObject(8263, 3165.73389, -898.26099, -71.265, 0.00, 0.00, 275.971); // объект 78
	CreateDynamicObject(8263, 3178.05396, -1017.435, -30.165, 0.00, 0.00, 275.966); // объект 79
	CreateDynamicObject(8263, 3178.05396, -1017.435, -37.415, 0.00, 0.00, 275.966); // объект 80
	CreateDynamicObject(8263, 3178.05396, -1017.435, -44.165, 0.00, 0.00, 275.966); // объект 81
	CreateDynamicObject(8263, 3178.05396, -1017.435, -50.915, 0.00, 0.00, 275.966); // объект 82
	CreateDynamicObject(8263, 3178.05396, -1017.435, -57.665, 0.00, 0.00, 275.966); // объект 83
	CreateDynamicObject(8263, 3178.05396, -1017.435, -64.665, 0.00, 0.00, 275.966); // объект 84
	CreateDynamicObject(8263, 3178.05396, -1017.435, -71.915, 0.00, 0.00, 275.966); // объект 85
	CreateDynamicObject(8263, 3178.05396, -1017.435, -23.495, 0.00, 0.00, 275.966); // объект 86
	CreateDynamicObject(8263, 3178.05396, -1017.435, -16.245, 0.00, 0.00, 275.966); // объект 87
	CreateDynamicObject(8263, 3178.05396, -1017.435, -8.995, 0.00, 0.00, 275.966); // объект 88
	CreateDynamicObject(8263, 3178.05396, -1017.435, -1.745, 0.00, 0.00, 275.966); // объект 89
	CreateDynamicObject(8263, 3178.05396, -1017.435, 5.255, 0.00, 0.00, 275.966); // объект 90
	CreateDynamicObject(8263, 3178.05396, -1017.435, 12.255, 0.00, 0.00, 275.966); // объект 91
	CreateDynamicObject(8263, 3178.05396, -1017.435, 19.255, 0.00, 0.00, 275.966); // объект 92
	CreateDynamicObject(8263, 3178.05396, -1017.435, 26.255, 0.00, 0.00, 275.966); // объект 93
	CreateDynamicObject(8263, 3178.05396, -1017.435, 33.505, 0.00, 0.00, 275.966); // объект 94
	CreateDynamicObject(8263, 3178.05396, -1017.435, 40.505, 0.00, 0.00, 275.966); // объект 95
	CreateDynamicObject(8263, 1080.39001, -703.39301, 149.245, 0.00, 0.00, 284); // объект 96
	CreateDynamicObject(8263, 1080.39001, -703.39301, 156.245, 0.00, 0.00, 283.997); // объект 97
	CreateDynamicObject(8263, 1080.39001, -703.39301, 163.245, 0.00, 0.00, 283.997); // объект 98
	CreateDynamicObject(8263, 1080.39001, -703.39301, 169.995, 0.00, 0.00, 283.997); // объект 99
	CreateDynamicObject(8263, 1080.39001, -703.39301, 176.995, 0.00, 0.00, 283.997); // объект 100
	CreateDynamicObject(8263, 1080.39001, -703.39301, 142.245, 0.00, 0.00, 283.997); // объект 101
	CreateDynamicObject(8263, 1080.38965, -703.39258, 135.245, 0.00, 0.00, 283.997); // объект 102
	CreateDynamicObject(8263, 1080.39001, -703.39301, 128.745, 0.00, 0.00, 283.997); // объект 103
	CreateDynamicObject(8263, 1080.39001, -703.39301, 121.745, 0.00, 0.00, 283.997); // объект 104
	CreateDynamicObject(8263, 1080.39001, -703.39301, 114.745, 0.00, 0.00, 283.997); // объект 105
	CreateDynamicObject(8263, 1080.39001, -703.39301, 107.745, 0.00, 0.00, 283.997); // объект 106
	CreateDynamicObject(8263, 1080.39001, -703.39301, 184.205, 0.00, 0.00, 283.997); // объект 107
	CreateDynamicObject(8263, 1154.60205, -761.37598, 156.03, 0.00, 0.00, 359.997); // объект 108
	CreateDynamicObject(8263, 1154.60205, -761.37598, 162.78, 0.00, 0.00, 359.995); // объект 109
	CreateDynamicObject(7380, 1011.54102, -645.35199, 126.24, 0.00, 0.00, 228.995); // объект 110
	CreateDynamicObject(7380, 1011.54102, -645.35199, 131.74001, 0.00, 0.00, 228.994); // объект 111
	CreateDynamicObject(7380, 1011.54102, -645.35199, 137.24001, 0.00, 0.00, 228.994); // объект 112
	CreateDynamicObject(7380, 1011.54102, -645.35199, 142.49001, 0.00, 0.00, 228.994); // объект 113
	CreateDynamicObject(7380, 1011.54102, -645.35199, 147.99001, 0.00, 0.00, 228.994); // объект 114
	CreateDynamicObject(7380, 1011.54102, -645.35199, 153.49001, 0.00, 0.00, 228.994); // объект 115
	CreateDynamicObject(7380, 1011.54102, -645.35199, 158.74001, 0.00, 0.00, 228.994); // объект 116
	CreateDynamicObject(7380, 1011.54102, -645.35199, 163.99001, 0.00, 0.00, 228.994); // объект 117
	CreateDynamicObject(7380, 1011.54102, -645.35199, 169.49001, 0.00, 0.00, 228.994); // объект 118
	CreateDynamicObject(7380, 1011.54102, -645.35199, 174.99001, 0.00, 0.00, 228.994); // объект 119
	CreateDynamicObject(7380, 1011.54102, -645.35199, 180.49001, 0.00, 0.00, 228.994); // объект 120
	CreateDynamicObject(7380, 1011.54102, -645.35199, 185.49001, 0.00, 0.00, 228.994); // объект 121
	CreateDynamicObject(7380, 1011.54102, -645.35199, 120.93, 0.00, 0.00, 228.994); // объект 122
	CreateDynamicObject(7380, 1011.54102, -645.35199, 115.68, 0.00, 0.00, 228.994); // объект 123
	CreateDynamicObject(8263, 879.08197, -650.36401, 184.02, 0.00, 0.00, 24.497); // объект 124
	CreateDynamicObject(8263, 879.08099, -650.36298, 177.27, 0.00, 0.00, 24.494); // объект 125
	CreateDynamicObject(8263, 879.08002, -650.362, 170.52, 0.00, 0.00, 24.494); // объект 126
	CreateDynamicObject(8263, 879.07898, -650.36102, 163.77, 0.00, 0.00, 24.494); // объект 127
	CreateDynamicObject(8263, 879.078, -650.35999, 157.02, 0.00, 0.00, 24.494); // объект 128
	CreateDynamicObject(8263, 879.07703, -650.35901, 150.27, 0.00, 0.00, 24.494); // объект 129
	CreateDynamicObject(8263, 879.07599, -650.35797, 144.02, 0.00, 0.00, 24.494); // объект 130
	CreateDynamicObject(8263, 879.07501, -650.35699, 137.27, 0.00, 0.00, 24.494); // объект 131
	CreateDynamicObject(8263, 879.07397, -650.35602, 130.52, 0.00, 0.00, 24.494); // объект 132
	CreateDynamicObject(8263, 879.073, -650.35498, 123.52, 0.00, 0.00, 24.494); // объект 133
	CreateDynamicObject(8263, 879.07202, -650.35498, 116.77, 0.00, 0.00, 24.494); // объект 134
	CreateDynamicObject(8263, 879.07098, -650.35498, 110.02, 0.00, 0.00, 24.494); // объект 135
	CreateDynamicObject(8263, 879.07001, -650.35498, 103.27, 0.00, 0.00, 24.494); // объект 136
	CreateDynamicObject(8263, 879.06897, -650.35498, 96.27, 0.00, 0.00, 24.494); // объект 137
	CreateDynamicObject(8263, 879.06799, -650.35498, 89.27, 0.00, 0.00, 24.494); // объект 138
	CreateDynamicObject(8263, 879.06702, -650.35498, 82.77, 0.00, 0.00, 24.494); // объект 139
	CreateDynamicObject(8263, 879.06598, -650.35498, 76.27, 0.00, 0.00, 24.494); // объект 140
	CreateDynamicObject(8263, 879.065, -650.35498, 69.52, 0.00, 0.00, 24.494); // объект 141
	CreateDynamicObject(8263, 879.06403, -650.35498, 62.77, 0.00, 0.00, 24.494); // объект 142
	CreateDynamicObject(8263, 879.06403, -650.35498, 56.27, 0.00, 0.00, 24.494); // объект 143
	CreateDynamicObject(8263, 879.06403, -650.35498, 49.27, 0.00, 0.00, 24.494); // объект 144
	CreateDynamicObject(8263, 879.06403, -650.35498, 42.52, 0.00, 0.00, 24.494); // объект 145
	CreateDynamicObject(8263, 772.24103, -704.46503, 42.495, 0.00, 0.00, 29.244); // объект 146
	CreateDynamicObject(8263, 772.23999, -704.46503, 35.645, 0.00, 0.00, 29.24); // объект 147
	CreateDynamicObject(8263, 772.23901, -704.46503, 28.895, 0.00, 0.00, 29.24); // объект 148
	CreateDynamicObject(8263, 772.23798, -704.46503, 22.145, 0.00, 0.00, 29.24); // объект 149
	CreateDynamicObject(8263, 772.237, -704.46503, 49.375, 0.00, 0.00, 29.24); // объект 150
	CreateDynamicObject(8263, 772.23602, -704.46503, 56.125, 0.00, 0.00, 29.24); // объект 151
	CreateDynamicObject(8263, 772.23499, -704.46503, 62.875, 0.00, 0.00, 29.24); // объект 152
	CreateDynamicObject(8263, 772.23401, -704.46503, 69.625, 0.00, 0.00, 29.24); // объект 153
	CreateDynamicObject(8263, 772.23297, -704.46503, 76.625, 0.00, 0.00, 29.24); // объект 154
	CreateDynamicObject(8263, 772.23199, -704.46503, 83.625, 0.00, 0.00, 29.24); // объект 155
	CreateDynamicObject(8263, 772.23102, -704.46503, 90.625, 0.00, 0.00, 29.24); // объект 156
	CreateDynamicObject(8263, 772.22998, -704.46503, 97.625, 0.00, 0.00, 29.24); // объект 157
	CreateDynamicObject(8263, 772.22998, -704.46503, 104.625, 0.00, 0.00, 29.24); // объект 158
	CreateDynamicObject(8263, 772.22998, -704.46503, 111.125, 0.00, 0.00, 29.24); // объект 159
	CreateDynamicObject(8263, 772.22998, -704.46503, 117.865, 0.00, 0.00, 29.24); // объект 160
	CreateDynamicObject(8263, 772.22998, -704.46503, 124.615, 0.00, 0.00, 29.24); // объект 161
	CreateDynamicObject(8263, 772.22998, -704.46503, 131.61501, 0.00, 0.00, 29.24); // объект 162
	CreateDynamicObject(8263, 772.22998, -704.46503, 138.61501, 0.00, 0.00, 29.24); // объект 163
	CreateDynamicObject(8263, 772.22998, -704.46503, 145.61501, 0.00, 0.00, 29.24); // объект 164
	CreateDynamicObject(8263, 772.22998, -704.46503, 152.11501, 0.00, 0.00, 29.24); // объект 165
	CreateDynamicObject(8263, 772.22998, -704.46503, 158.86501, 0.00, 0.00, 29.24); // объект 166
	CreateDynamicObject(8263, 772.22998, -704.46503, 165.61501, 0.00, 0.00, 29.24); // объект 167
	CreateDynamicObject(8263, 772.22998, -704.46503, 172.61501, 0.00, 0.00, 29.24); // объект 168
	CreateDynamicObject(8263, 772.22998, -704.46503, 179.36501, 0.00, 0.00, 29.24); // объект 169
	CreateDynamicObject(8263, 772.22998, -704.46503, 184.09, 0.00, 0.00, 29.24); // объект 170
	CreateDynamicObject(8263, 676.95001, -775.578, 184.09, 0.00, 0.00, 44.24); // объект 171
	CreateDynamicObject(8263, 676.94897, -775.57703, 177.34, 0.00, 0.00, 44.236); // объект 172
	CreateDynamicObject(8263, 676.948, -775.57599, 170.59, 0.00, 0.00, 44.236); // объект 173
	CreateDynamicObject(8263, 676.94702, -775.57501, 163.59, 0.00, 0.00, 44.236); // объект 174
	CreateDynamicObject(8263, 676.94598, -775.57397, 156.84, 0.00, 0.00, 44.236); // объект 175
	CreateDynamicObject(8263, 676.94501, -775.573, 149.84, 0.00, 0.00, 44.236); // объект 176
	CreateDynamicObject(8263, 676.94397, -775.57202, 142.84, 0.00, 0.00, 44.236); // объект 177
	CreateDynamicObject(8263, 676.94299, -775.57098, 135.84, 0.00, 0.00, 44.236); // объект 178
	CreateDynamicObject(8263, 676.94202, -775.57001, 128.84, 0.00, 0.00, 44.236); // объект 179
	CreateDynamicObject(8263, 676.94098, -775.56897, 121.815, 0.00, 0.00, 44.236); // объект 180
	CreateDynamicObject(8263, 676.94, -775.56799, 114.815, 0.00, 0.00, 44.236); // объект 181
	CreateDynamicObject(8263, 676.93903, -775.56702, 107.565, 0.00, 0.00, 44.236); // объект 182
	CreateDynamicObject(8263, 676.93903, -775.56598, 100.565, 0.00, 0.00, 44.236); // объект 183
	CreateDynamicObject(8263, 676.93903, -775.565, 93.565, 0.00, 0.00, 44.236); // объект 184
	CreateDynamicObject(8263, 676.93903, -775.56403, 86.565, 0.00, 0.00, 44.236); // объект 185
	CreateDynamicObject(8263, 676.93903, -775.56403, 79.565, 0.00, 0.00, 44.236); // объект 186
	CreateDynamicObject(8263, 676.93903, -775.56403, 72.565, 0.00, 0.00, 44.236); // объект 187
	CreateDynamicObject(8263, 676.93903, -775.56403, 65.565, 0.00, 0.00, 44.236); // объект 188
	CreateDynamicObject(8263, 676.93903, -775.56403, 58.565, 0.00, 0.00, 44.236); // объект 189
	CreateDynamicObject(8263, 676.93903, -775.56403, 51.565, 0.00, 0.00, 44.236); // объект 190
	CreateDynamicObject(8263, 676.93903, -775.56403, 44.815, 0.00, 0.00, 44.236); // объект 191
	CreateDynamicObject(8263, 676.93903, -775.56403, 38.065, 0.00, 0.00, 44.236); // объект 192
	CreateDynamicObject(8263, 676.93903, -775.56403, 31.315, 0.00, 0.00, 44.236); // объект 193
	CreateDynamicObject(8263, 676.93903, -775.56403, 24.565, 0.00, 0.00, 44.236); // объект 194
	CreateDynamicObject(8263, 590.97803, -859.00598, 24.565, 0.00, 0.00, 44.236); // объект 195
	CreateDynamicObject(8263, 590.97803, -859.00598, 31.565, 0.00, 0.00, 44.236); // объект 196
	CreateDynamicObject(8263, 590.97803, -859.00598, 38.315, 0.00, 0.00, 44.236); // объект 197
	CreateDynamicObject(8263, 590.97803, -859.00598, 45.065, 0.00, 0.00, 44.236); // объект 198
	CreateDynamicObject(8263, 590.97803, -859.00598, 51.815, 0.00, 0.00, 44.236); // объект 199
	CreateDynamicObject(8263, 590.97803, -859.00598, 58.815, 0.00, 0.00, 44.236); // объект 200
	CreateDynamicObject(8263, 590.97803, -859.00598, 65.815, 0.00, 0.00, 44.236); // объект 201
	CreateDynamicObject(8263, 590.97803, -859.00598, 72.815, 0.00, 0.00, 44.236); // объект 202
	CreateDynamicObject(8263, 590.97803, -859.00598, 79.815, 0.00, 0.00, 44.236); // объект 203
	CreateDynamicObject(8263, 590.97803, -859.00598, 86.815, 0.00, 0.00, 44.236); // объект 204
	CreateDynamicObject(8263, 590.97803, -859.00598, 93.815, 0.00, 0.00, 44.236); // объект 205
	CreateDynamicObject(8263, 590.97803, -859.00598, 100.815, 0.00, 0.00, 44.236); // объект 206
	CreateDynamicObject(8263, 590.97803, -859.00598, 107.565, 0.00, 0.00, 44.236); // объект 207
	CreateDynamicObject(8263, 590.97803, -859.00598, 114.315, 0.00, 0.00, 44.236); // объект 208
	CreateDynamicObject(8263, 590.97803, -859.00598, 121.315, 0.00, 0.00, 44.236); // объект 209
	CreateDynamicObject(8263, 590.97803, -859.00598, 128.315, 0.00, 0.00, 44.236); // объект 210
	CreateDynamicObject(8263, 590.97803, -859.00598, 135.315, 0.00, 0.00, 44.236); // объект 211
	CreateDynamicObject(8263, 590.97803, -859.00598, 142.065, 0.00, 0.00, 44.236); // объект 212
	CreateDynamicObject(8263, 590.97803, -859.00598, 148.315, 0.00, 0.00, 44.236); // объект 213
	CreateDynamicObject(8263, 590.97803, -859.00598, 155.315, 0.00, 0.00, 44.236); // объект 214
	CreateDynamicObject(8263, 590.97803, -859.00598, 162.065, 0.00, 0.00, 44.236); // объект 215
	CreateDynamicObject(8263, 590.97803, -859.00598, 169.065, 0.00, 0.00, 44.236); // объект 216
	CreateDynamicObject(8263, 505.08301, -942.625, 169.03999, 0.00, 0.00, 44.236); // объект 217
	CreateDynamicObject(8263, 505.08301, -942.625, 162.13, 0.00, 0.00, 44.236); // объект 218
	CreateDynamicObject(8263, 505.08301, -942.625, 155.13, 0.00, 0.00, 44.236); // объект 219
	CreateDynamicObject(8263, 505.08301, -942.625, 148.13, 0.00, 0.00, 44.236); // объект 220
	CreateDynamicObject(8263, 505.08301, -942.625, 141.13, 0.00, 0.00, 44.236); // объект 221
	CreateDynamicObject(8263, 505.08301, -942.625, 134.13, 0.00, 0.00, 44.236); // объект 222
	CreateDynamicObject(8263, 505.08301, -942.625, 127.13, 0.00, 0.00, 44.236); // объект 223
	CreateDynamicObject(8263, 505.08301, -942.625, 120.13, 0.00, 0.00, 44.236); // объект 224
	CreateDynamicObject(8263, 505.08301, -942.625, 113.13, 0.00, 0.00, 44.236); // объект 225
	CreateDynamicObject(8263, 505.08301, -942.625, 106.13, 0.00, 0.00, 44.236); // объект 226
	CreateDynamicObject(8263, 505.08301, -942.625, 99.13, 0.00, 0.00, 44.236); // объект 227
	CreateDynamicObject(8263, 505.08301, -942.625, 92.13, 0.00, 0.00, 44.236); // объект 228
	CreateDynamicObject(8263, 505.08301, -942.625, 85.13, 0.00, 0.00, 44.236); // объект 229
	CreateDynamicObject(8263, 505.08301, -942.625, 78.13, 0.00, 0.00, 44.236); // объект 230
	CreateDynamicObject(8263, 505.08301, -942.625, 71.38, 0.00, 0.00, 44.236); // объект 231
	CreateDynamicObject(8263, 416.39801, -1023.16699, 90.73, 0.00, 0.00, 40.236); // объект 232
	CreateDynamicObject(8263, 416.397, -1023.16699, 83.73, 0.00, 0.00, 40.232); // объект 233
	CreateDynamicObject(8263, 416.396, -1023.16699, 76.73, 0.00, 0.00, 40.232); // объект 234
	CreateDynamicObject(8263, 416.396, -1023.16699, 97.48, 0.00, 0.00, 40.232); // объект 235
	CreateDynamicObject(8263, 416.396, -1023.16699, 104.48, 0.00, 0.00, 40.232); // объект 236
	CreateDynamicObject(8263, 416.396, -1023.16699, 111.23, 0.00, 0.00, 40.232); // объект 237
	CreateDynamicObject(8263, 416.396, -1023.16699, 117.98, 0.00, 0.00, 40.232); // объект 238
	CreateDynamicObject(8263, 416.396, -1023.16699, 124.73, 0.00, 0.00, 40.232); // объект 239
	CreateDynamicObject(8263, 416.396, -1023.16699, 131.73, 0.00, 0.00, 40.232); // объект 240
	CreateDynamicObject(8263, 416.396, -1023.16699, 138.73, 0.00, 0.00, 40.232); // объект 241
	CreateDynamicObject(8263, 416.396, -1023.16699, 145.73, 0.00, 0.00, 40.232); // объект 242
	CreateDynamicObject(8263, 416.396, -1023.16699, 152.73, 0.00, 0.00, 40.232); // объект 243
	CreateDynamicObject(8263, 416.396, -1023.16699, 159.73, 0.00, 0.00, 40.232); // объект 244
	CreateDynamicObject(8263, 416.396, -1023.16699, 166.48, 0.00, 0.00, 40.232); // объект 245
	CreateDynamicObject(8263, 324.96701, -1100.48096, 159.73, 0.00, 0.00, 40.232); // объект 246
	CreateDynamicObject(8263, 324.96701, -1100.48096, 152.98, 0.00, 0.00, 40.232); // объект 247
	CreateDynamicObject(8263, 324.96701, -1100.48096, 145.98, 0.00, 0.00, 40.232); // объект 248
	CreateDynamicObject(8263, 324.96701, -1100.48096, 138.98, 0.00, 0.00, 40.232); // объект 249
	CreateDynamicObject(8263, 324.96701, -1100.48096, 132.23, 0.00, 0.00, 40.232); // объект 250
	CreateDynamicObject(8263, 324.96701, -1100.48096, 125.73, 0.00, 0.00, 40.232); // объект 251
	CreateDynamicObject(8263, 324.96701, -1100.48096, 118.73, 0.00, 0.00, 40.232); // объект 252
	CreateDynamicObject(8263, 324.96701, -1100.48096, 111.73, 0.00, 0.00, 40.232); // объект 253
	CreateDynamicObject(8263, 324.96701, -1100.48096, 105.23, 0.00, 0.00, 40.232); // объект 254
	CreateDynamicObject(8263, 324.96701, -1100.48096, 98.23, 0.00, 0.00, 40.232); // объект 255
	CreateDynamicObject(8263, 324.96701, -1100.48096, 91.48, 0.00, 0.00, 40.232); // объект 256
	CreateDynamicObject(8263, 324.96701, -1100.48096, 84.48, 0.00, 0.00, 40.232); // объект 257
	CreateDynamicObject(8263, 324.96701, -1100.48096, 77.98, 0.00, 0.00, 40.232); // объект 258
	CreateDynamicObject(8263, 324.96701, -1100.48096, 70.98, 0.00, 0.00, 40.232); // объект 259
	CreateDynamicObject(8263, 324.96701, -1100.48096, 63.98, 0.00, 0.00, 40.232); // объект 260
	CreateDynamicObject(8263, 233.49699, -1177.88599, 77.955, 0.00, 0.00, 40.232); // объект 261
	CreateDynamicObject(8263, 233.496, -1177.88599, 84.955, 0.00, 0.00, 40.232); // объект 262
	CreateDynamicObject(8263, 233.495, -1177.88599, 91.955, 0.00, 0.00, 40.232); // объект 263
	CreateDynamicObject(8263, 233.494, -1177.88599, 98.705, 0.00, 0.00, 40.232); // объект 264
	CreateDynamicObject(8263, 233.493, -1177.88599, 105.455, 0.00, 0.00, 40.232); // объект 265
	CreateDynamicObject(8263, 233.492, -1177.88599, 112.455, 0.00, 0.00, 40.232); // объект 266
	CreateDynamicObject(8263, 233.491, -1177.88599, 119.455, 0.00, 0.00, 40.232); // объект 267
	CreateDynamicObject(8263, 233.49001, -1177.88599, 126.455, 0.00, 0.00, 40.232); // объект 268
	CreateDynamicObject(8263, 233.489, -1177.88599, 133.205, 0.00, 0.00, 40.232); // объект 269
	CreateDynamicObject(8263, 233.48801, -1177.88599, 140.205, 0.00, 0.00, 40.232); // объект 270
	CreateDynamicObject(8263, 233.487, -1177.88599, 147.205, 0.00, 0.00, 40.232); // объект 271
	CreateDynamicObject(8263, 233.48599, -1177.88599, 154.205, 0.00, 0.00, 40.232); // объект 272
	CreateDynamicObject(8263, 233.485, -1177.88599, 71.055, 0.00, 0.00, 40.232); // объект 273
	CreateDynamicObject(8263, 156.494, -1267.90503, 71.055, 0.00, 0.00, 58.732); // объект 274
	CreateDynamicObject(8263, 156.493, -1267.90405, 64.305, 0.00, 0.00, 58.727); // объект 275
	CreateDynamicObject(8263, 156.492, -1267.90295, 57.805, 0.00, 0.00, 58.727); // объект 276
	CreateDynamicObject(8263, 156.491, -1267.90198, 51.055, 0.00, 0.00, 58.727); // объект 277
	CreateDynamicObject(8263, 156.49001, -1267.901, 44.555, 0.00, 0.00, 58.727); // объект 278
	CreateDynamicObject(8263, 156.489, -1267.90002, 77.685, 0.00, 0.00, 58.727); // объект 279
	CreateDynamicObject(8263, 156.48801, -1267.89905, 84.685, 0.00, 0.00, 58.727); // объект 280
	CreateDynamicObject(8263, 156.487, -1267.89795, 91.685, 0.00, 0.00, 58.727); // объект 281
	CreateDynamicObject(8263, 156.48599, -1267.89795, 98.685, 0.00, 0.00, 58.727); // объект 282
	CreateDynamicObject(8263, 156.485, -1267.89795, 105.685, 0.00, 0.00, 58.727); // объект 283
	CreateDynamicObject(8263, 156.48399, -1267.89795, 112.685, 0.00, 0.00, 58.727); // объект 284
	CreateDynamicObject(8263, 156.483, -1267.89795, 119.685, 0.00, 0.00, 58.727); // объект 285
	CreateDynamicObject(8263, 156.48199, -1267.89795, 126.685, 0.00, 0.00, 58.727); // объект 286
	CreateDynamicObject(8263, 156.481, -1267.89795, 133.685, 0.00, 0.00, 58.727); // объект 287
	CreateDynamicObject(8263, 156.48, -1267.89795, 140.185, 0.00, 0.00, 58.727); // объект 288
	CreateDynamicObject(8263, 156.479, -1267.89795, 146.935, 0.00, 0.00, 58.727); // объект 289
	CreateDynamicObject(8263, 97.006, -1371.53796, 139.935, 0.00, 0.00, 61.477); // объект 290
	CreateDynamicObject(8263, 97.006, -1371.53699, 133.185, 0.00, 0.00, 61.474); // объект 291
	CreateDynamicObject(8263, 97.006, -1371.53601, 126.185, 0.00, 0.00, 61.474); // объект 292
	CreateDynamicObject(8263, 97.006, -1371.53503, 119.185, 0.00, 0.00, 61.474); // объект 293
	CreateDynamicObject(8263, 97.006, -1371.53406, 112.685, 0.00, 0.00, 61.474); // объект 294
	CreateDynamicObject(8263, 97.006, -1371.53296, 105.685, 0.00, 0.00, 61.474); // объект 295
	CreateDynamicObject(8263, 97.006, -1371.53198, 98.935, 0.00, 0.00, 61.474); // объект 296
	CreateDynamicObject(8263, 97.006, -1371.53101, 92.185, 0.00, 0.00, 61.474); // объект 297
	CreateDynamicObject(8263, 97.006, -1371.53003, 85.435, 0.00, 0.00, 61.474); // объект 298
	CreateDynamicObject(8263, 97.006, -1371.52905, 78.935, 0.00, 0.00, 61.474); // объект 299
	CreateDynamicObject(8263, 97.006, -1371.52795, 72.435, 0.00, 0.00, 61.474); // объект 0
	CreateDynamicObject(8263, 97.006, -1371.52698, 65.685, 0.00, 0.00, 61.474); // объект 1
	CreateDynamicObject(8263, 97.006, -1371.526, 58.685, 0.00, 0.00, 61.474); // объект 2
	CreateDynamicObject(8263, 97.006, -1371.52502, 52.185, 0.00, 0.00, 61.474); // объект 3
	CreateDynamicObject(8263, 97.006, -1371.52405, 45.435, 0.00, 0.00, 61.474); // объект 4
	CreateDynamicObject(8263, 97.006, -1371.52295, 38.435, 0.00, 0.00, 61.474); // объект 5
	CreateDynamicObject(8263, 97.006, -1371.52295, 31.685, 0.00, 0.00, 61.474); // объект 6
	CreateDynamicObject(8263, 97.006, -1371.52295, 25.185, 0.00, 0.00, 61.474); // объект 7
	CreateDynamicObject(8263, 97.006, -1371.52295, 18.435, 0.00, 0.00, 61.474); // объект 8
	CreateDynamicObject(8263, 97.006, -1371.52295, 11.435, 0.00, 0.00, 61.474); // объект 9
	CreateDynamicObject(8263, 97.006, -1371.52295, 4.685, 0.00, 0.00, 61.474); // объект 10
	CreateDynamicObject(8263, 97.006, -1371.52295, -2.065, 0.00, 0.00, 61.474); // объект 11
	CreateDynamicObject(8263, 97.006, -1371.52295, -9.065, 0.00, 0.00, 61.474); // объект 12
	CreateDynamicObject(8263, 97.006, -1371.52295, -16.065, 0.00, 0.00, 61.474); // объект 13
	CreateDynamicObject(8263, 97.006, -1371.52295, -23.065, 0.00, 0.00, 61.474); // объект 14
	CreateDynamicObject(8263, 97.006, -1371.52295, -29.815, 0.00, 0.00, 61.474); // объект 15
	CreateDynamicObject(8263, 97.006, -1371.52295, -36.815, 0.00, 0.00, 61.474); // объект 16
	CreateDynamicObject(8263, 97.006, -1371.52295, -43.565, 0.00, 0.00, 61.474); // объект 17
	CreateDynamicObject(8263, 97.006, -1371.52295, -50.315, 0.00, 0.00, 61.474); // объект 18
	CreateDynamicObject(8263, 50.801, -1480.47705, 52.015, 0.00, 0.00, 72.974); // объект 19
	CreateDynamicObject(8263, 50.801, -1480.47705, 45.265, 0.00, 0.00, 72.971); // объект 20
	CreateDynamicObject(8263, 50.801, -1480.47705, 38.515, 0.00, 0.00, 72.971); // объект 21
	CreateDynamicObject(8263, 50.801, -1480.47705, 31.515, 0.00, 0.00, 72.971); // объект 22
	CreateDynamicObject(8263, 50.801, -1480.47705, 24.515, 0.00, 0.00, 72.971); // объект 23
	CreateDynamicObject(8263, 50.801, -1480.47705, 17.765, 0.00, 0.00, 72.971); // объект 24
	CreateDynamicObject(8263, 50.801, -1480.47705, 11.015, 0.00, 0.00, 72.971); // объект 25
	CreateDynamicObject(8263, 50.801, -1480.47705, 4.265, 0.00, 0.00, 72.971); // объект 26
	CreateDynamicObject(8263, 50.801, -1480.47705, -2.485, 0.00, 0.00, 72.971); // объект 27
	CreateDynamicObject(8263, 50.801, -1480.47705, -9.235, 0.00, 0.00, 72.971); // объект 28
	CreateDynamicObject(8263, 50.801, -1480.47705, -15.985, 0.00, 0.00, 72.971); // объект 29
	CreateDynamicObject(8263, 50.801, -1480.47705, -22.235, 0.00, 0.00, 72.971); // объект 30
	CreateDynamicObject(8263, 50.801, -1480.47705, -29.485, 0.00, 0.00, 72.971); // объект 31
	CreateDynamicObject(8263, 50.801, -1480.47705, -36.485, 0.00, 0.00, 72.971); // объект 32
	CreateDynamicObject(8263, 50.801, -1480.47705, -43.235, 0.00, 0.00, 72.971); // объект 33
	CreateDynamicObject(8263, 50.801, -1480.47705, -49.985, 0.00, 0.00, 72.971); // объект 34
	CreateDynamicObject(8263, 44.107, -1596.71594, 4.225, 0.00, 0.00, 100.471); // объект 35
	CreateDynamicObject(8263, 44.106, -1596.71594, -2.275, 0.00, 0.00, 100.47); // объект 36
	CreateDynamicObject(8263, 44.105, -1596.71594, -9.275, 0.00, 0.00, 100.47); // объект 37
	CreateDynamicObject(8263, 44.104, -1596.71594, -16.275, 0.00, 0.00, 100.47); // объект 38
	CreateDynamicObject(8263, 44.104, -1596.71594, -22.775, 0.00, 0.00, 100.47); // объект 39
	CreateDynamicObject(8263, 44.104, -1596.71594, -29.775, 0.00, 0.00, 100.47); // объект 40
	CreateDynamicObject(8263, 44.104, -1596.71594, -36.525, 0.00, 0.00, 100.47); // объект 41
	CreateDynamicObject(8263, 44.104, -1596.71594, -43.275, 0.00, 0.00, 100.47); // объект 42
	CreateDynamicObject(8263, 44.104, -1596.71594, -49.525, 0.00, 0.00, 100.47); // объект 43
	CreateDynamicObject(8263, 44.104, -1596.71594, -56.525, 0.00, 0.00, 100.47); // объект 44
	CreateDynamicObject(8263, 44.104, -1596.71594, 10.985, 0.00, 0.00, 100.47); // объект 45
	CreateDynamicObject(8263, 44.104, -1596.71594, 17.985, 0.00, 0.00, 100.47); // объект 46
	CreateDynamicObject(8263, 44.104, -1596.71594, 24.985, 0.00, 0.00, 100.47); // объект 47
	CreateDynamicObject(8263, 44.104, -1596.71594, 31.735, 0.00, 0.00, 100.47); // объект 48
	CreateDynamicObject(8263, 44.104, -1596.71594, 38.485, 0.00, 0.00, 100.47); // объект 49
	CreateDynamicObject(8263, 44.104, -1596.71594, 45.235, 0.00, 0.00, 100.47); // объект 50
	CreateDynamicObject(8263, 44.104, -1596.71594, 51.735, 0.00, 0.00, 100.47); // объект 51
	CreateDynamicObject(8263, 51.237, -1480.802, 59.06, 0.00, 0.00, 73.47); // объект 52
	CreateDynamicObject(8263, 51.236, -1480.802, 65.81, 0.00, 0.00, 73.466); // объект 53
	CreateDynamicObject(8263, 51.235, -1480.802, 72.81, 0.00, 0.00, 73.466); // объект 54
	CreateDynamicObject(8263, 51.234, -1480.802, 79.56, 0.00, 0.00, 73.466); // объект 55
	CreateDynamicObject(8263, 51.233, -1480.802, 86.31, 0.00, 0.00, 73.466); // объект 56
	CreateDynamicObject(8263, 51.232, -1480.802, 93.31, 0.00, 0.00, 73.466); // объект 57
	CreateDynamicObject(8263, 51.231, -1480.802, 100.31, 0.00, 0.00, 73.466); // объект 58
	CreateDynamicObject(8263, 51.23, -1480.802, 106.81, 0.00, 0.00, 73.466); // объект 59
	CreateDynamicObject(8263, 44.106, -1596.71594, 58.565, 0.00, 0.00, 100.47); // объект 60
	CreateDynamicObject(8263, 44.105, -1596.71594, 65.315, 0.00, 0.00, 100.47); // объект 61
	CreateDynamicObject(8263, 44.104, -1596.71594, 72.065, 0.00, 0.00, 100.47); // объект 62
	CreateDynamicObject(8263, 44.104, -1596.71594, 78.815, 0.00, 0.00, 100.47); // объект 63
	CreateDynamicObject(8263, 44.104, -1596.71594, 85.815, 0.00, 0.00, 100.47); // объект 64
	CreateDynamicObject(8263, 44.104, -1596.71594, 92.815, 0.00, 0.00, 100.47); // объект 65
	CreateDynamicObject(8263, 65.958, -1714.56006, 92.815, 0.00, 0.00, 100.47); // объект 66
	CreateDynamicObject(8263, 65.957, -1714.56006, 85.815, 0.00, 0.00, 100.47); // объект 67
	CreateDynamicObject(8263, 65.956, -1714.56006, 78.815, 0.00, 0.00, 100.47); // объект 68
	CreateDynamicObject(8263, 65.955, -1714.56006, 71.815, 0.00, 0.00, 100.47); // объект 69
	CreateDynamicObject(8263, 65.954, -1714.56006, 65.065, 0.00, 0.00, 100.47); // объект 70
	CreateDynamicObject(8263, 65.953, -1714.56006, 58.315, 0.00, 0.00, 100.47); // объект 71
	CreateDynamicObject(8263, 65.952, -1714.56006, 51.565, 0.00, 0.00, 100.47); // объект 72
	CreateDynamicObject(8263, 65.951, -1714.56006, 44.565, 0.00, 0.00, 100.47); // объект 73
	CreateDynamicObject(8263, 65.95, -1714.56006, 37.815, 0.00, 0.00, 100.47); // объект 74
	CreateDynamicObject(8263, 65.949, -1714.56006, 31.065, 0.00, 0.00, 100.47); // объект 75
	CreateDynamicObject(8263, 65.948, -1714.56006, 23.815, 0.00, 0.00, 100.47); // объект 76
	CreateDynamicObject(8263, 65.947, -1714.56006, 16.815, 0.00, 0.00, 100.47); // объект 77
	CreateDynamicObject(8263, 65.946, -1714.56006, 9.815, 0.00, 0.00, 100.47); // объект 78
	CreateDynamicObject(8263, 65.945, -1714.56006, 2.815, 0.00, 0.00, 100.47); // объект 79
	CreateDynamicObject(8263, 65.944, -1714.56006, -4.185, 0.00, 0.00, 100.47); // объект 80
	CreateDynamicObject(8263, 65.943, -1714.56006, -10.935, 0.00, 0.00, 100.47); // объект 81
	CreateDynamicObject(8263, 65.942, -1714.56006, -17.685, 0.00, 0.00, 100.47); // объект 82
	CreateDynamicObject(8263, 65.941, -1714.56006, -24.685, 0.00, 0.00, 100.47); // объект 83
	CreateDynamicObject(8263, 65.94, -1714.56006, -31.435, 0.00, 0.00, 100.47); // объект 84
	CreateDynamicObject(8263, 65.939, -1714.56006, -38.435, 0.00, 0.00, 100.47); // объект 85
	CreateDynamicObject(8263, 65.938, -1714.56006, -45.435, 0.00, 0.00, 100.47); // объект 86
	CreateDynamicObject(8263, 65.938, -1714.56006, -52.435, 0.00, 0.00, 100.47); // объект 87
	CreateDynamicObject(8263, 65.938, -1714.56006, -59.185, 0.00, 0.00, 100.47); // объект 88
	CreateDynamicObject(8263, 87.562, -1832.52002, -52.71, 0.00, 0.00, 100.47); // объект 89
	CreateDynamicObject(8263, 87.562, -1832.52002, -45.71, 0.00, 0.00, 100.47); // объект 90
	CreateDynamicObject(8263, 87.562, -1832.52002, -38.71, 0.00, 0.00, 100.47); // объект 91
	CreateDynamicObject(8263, 87.562, -1832.52002, -31.71, 0.00, 0.00, 100.47); // объект 92
	CreateDynamicObject(8263, 87.562, -1832.52002, -24.46, 0.00, 0.00, 100.47); // объект 93
	CreateDynamicObject(8263, 87.576, -1832.49597, -17.585, 0.00, 0.00, 100.47); // объект 94
	CreateDynamicObject(8263, 87.575, -1832.495, -10.835, 0.00, 0.00, 100.47); // объект 95
	CreateDynamicObject(8263, 87.574, -1832.49402, -3.835, 0.00, 0.00, 100.47); // объект 96
	CreateDynamicObject(8263, 87.573, -1832.49304, 2.915, 0.00, 0.00, 100.47); // объект 97
	CreateDynamicObject(8263, 87.572, -1832.49194, 9.915, 0.00, 0.00, 100.47); // объект 98
	CreateDynamicObject(8263, 87.571, -1832.49097, 16.165, 0.00, 0.00, 100.47); // объект 99
	CreateDynamicObject(8263, 87.57, -1832.48999, 23.165, 0.00, 0.00, 100.47); // объект 100
	CreateDynamicObject(8263, 87.569, -1832.48901, 30.165, 0.00, 0.00, 100.47); // объект 101
	CreateDynamicObject(8263, 87.568, -1832.48804, 36.915, 0.00, 0.00, 100.47); // объект 102
	CreateDynamicObject(8263, 87.567, -1832.48706, 43.415, 0.00, 0.00, 100.47); // объект 103
	CreateDynamicObject(8263, 87.566, -1832.48596, 50.415, 0.00, 0.00, 100.47); // объект 104
	CreateDynamicObject(8263, 87.565, -1832.48499, 57.415, 0.00, 0.00, 100.47); // объект 105
	CreateDynamicObject(8263, 87.564, -1832.48401, 64.415, 0.00, 0.00, 100.47); // объект 106
	CreateDynamicObject(8263, 109.271, -1950.28003, 64.415, 0.00, 0.00, 100.47); // объект 107
	CreateDynamicObject(8263, 109.271, -1950.27905, 57.415, 0.00, 0.00, 100.47); // объект 108
	CreateDynamicObject(8263, 109.271, -1950.27795, 50.415, 0.00, 0.00, 100.47); // объект 109
	CreateDynamicObject(8263, 109.271, -1950.27698, 43.415, 0.00, 0.00, 100.47); // объект 110
	CreateDynamicObject(8263, 109.271, -1950.276, 36.415, 0.00, 0.00, 100.47); // объект 111
	CreateDynamicObject(8263, 109.271, -1950.27502, 29.415, 0.00, 0.00, 100.47); // объект 112
	CreateDynamicObject(8263, 109.271, -1950.27405, 70.945, 0.00, 0.00, 100.47); // объект 113
	CreateDynamicObject(8263, 109.271, -1950.27295, 77.945, 0.00, 0.00, 100.47); // объект 114
	CreateDynamicObject(8263, 109.271, -1950.27295, 84.945, 0.00, 0.00, 100.47); // объект 115
	CreateDynamicObject(8263, 109.271, -1950.27295, 22.325, 0.00, 0.00, 100.47); // объект 116
	CreateDynamicObject(8263, 109.271, -1950.27295, 15.325, 0.00, 0.00, 100.47); // объект 117
	CreateDynamicObject(8263, 109.271, -1950.27295, 8.325, 0.00, 0.00, 100.47); // объект 118
	CreateDynamicObject(8263, 109.271, -1950.27295, 1.575, 0.00, 0.00, 100.47); // объект 119
	CreateDynamicObject(8263, 109.271, -1950.27295, -5.175, 0.00, 0.00, 100.47); // объект 120
	CreateDynamicObject(8263, 109.271, -1950.27295, -11.675, 0.00, 0.00, 100.47); // объект 121
	CreateDynamicObject(8263, 109.271, -1950.27295, -18.675, 0.00, 0.00, 100.47); // объект 122
	CreateDynamicObject(8263, 109.271, -1950.27295, -24.925, 0.00, 0.00, 100.47); // объект 123
	CreateDynamicObject(8263, 109.271, -1950.27295, -31.425, 0.00, 0.00, 100.47); // объект 124
	CreateDynamicObject(8263, 109.271, -1950.27295, -38.175, 0.00, 0.00, 100.47); // объект 125
	CreateDynamicObject(8263, 109.271, -1950.27295, -45.175, 0.00, 0.00, 100.47); // объект 126
	CreateDynamicObject(8263, 109.271, -1950.27295, -52.175, 0.00, 0.00, 100.47); // объект 127
	CreateDynamicObject(8263, 165.175, -2049.00708, -52.175, 0.00, 0.00, 138.47); // объект 128
	CreateDynamicObject(8263, 165.175, -2049.00708, -44.925, 0.00, 0.00, 138.466); // объект 129
	CreateDynamicObject(8263, 165.175, -2049.00708, -37.925, 0.00, 0.00, 138.466); // объект 130
	CreateDynamicObject(8263, 165.175, -2049.00708, -30.925, 0.00, 0.00, 138.466); // объект 131
	CreateDynamicObject(8263, 165.175, -2049.00708, -23.925, 0.00, 0.00, 138.466); // объект 132
	CreateDynamicObject(8263, 165.175, -2049.00708, -17.175, 0.00, 0.00, 138.466); // объект 133
	CreateDynamicObject(8263, 165.175, -2049.00708, -10.175, 0.00, 0.00, 138.466); // объект 134
	CreateDynamicObject(8263, 165.175, -2049.00708, -3.425, 0.00, 0.00, 138.466); // объект 135
	CreateDynamicObject(8263, 165.175, -2049.00708, 3.825, 0.00, 0.00, 138.466); // объект 136
	CreateDynamicObject(8263, 165.175, -2049.00708, 10.825, 0.00, 0.00, 138.466); // объект 137
	CreateDynamicObject(8263, 165.175, -2049.00708, 17.825, 0.00, 0.00, 138.466); // объект 138
	CreateDynamicObject(8263, 165.175, -2049.00708, 25.075, 0.00, 0.00, 138.466); // объект 139
	CreateDynamicObject(8263, 165.175, -2049.00708, 31.825, 0.00, 0.00, 138.466); // объект 140
	CreateDynamicObject(8263, 165.175, -2049.00708, 38.575, 0.00, 0.00, 138.466); // объект 141
	CreateDynamicObject(8263, 165.175, -2049.00708, 45.575, 0.00, 0.00, 138.466); // объект 142
	CreateDynamicObject(8263, 165.175, -2049.00708, 52.575, 0.00, 0.00, 138.466); // объект 143
	CreateDynamicObject(8263, 165.175, -2049.00708, 59.075, 0.00, 0.00, 138.466); // объект 144
	CreateDynamicObject(8263, 165.175, -2049.00708, 65.825, 0.00, 0.00, 138.466); // объект 145
	CreateDynamicObject(8263, 165.175, -2049.00708, 72.825, 0.00, 0.00, 138.466); // объект 146
	CreateDynamicObject(8263, 165.175, -2049.00708, 79.325, 0.00, 0.00, 138.466); // объект 147
	CreateDynamicObject(8263, 269.086, -2098.94507, 65.575, 0.00, 0.00, 170.466); // объект 148
	CreateDynamicObject(8263, 269.086, -2098.94409, 58.825, 0.00, 0.00, 170.464); // объект 149
	CreateDynamicObject(8263, 269.086, -2098.94312, 51.825, 0.00, 0.00, 170.464); // объект 150
	CreateDynamicObject(8263, 269.086, -2098.94312, 45.075, 0.00, 0.00, 170.464); // объект 151
	CreateDynamicObject(8263, 269.086, -2098.94312, 38.075, 0.00, 0.00, 170.464); // объект 152
	CreateDynamicObject(8263, 269.086, -2098.94312, 31.575, 0.00, 0.00, 170.464); // объект 153
	CreateDynamicObject(8263, 269.086, -2098.94312, 24.825, 0.00, 0.00, 170.464); // объект 154
	CreateDynamicObject(8263, 269.086, -2098.94312, 17.825, 0.00, 0.00, 170.464); // объект 155
	CreateDynamicObject(8263, 269.086, -2098.94312, 11.075, 0.00, 0.00, 170.464); // объект 156
	CreateDynamicObject(8263, 269.086, -2098.94312, 4.575, 0.00, 0.00, 170.464); // объект 157
	CreateDynamicObject(8263, 269.086, -2098.94312, -1.925, 0.00, 0.00, 170.464); // объект 158
	CreateDynamicObject(8263, 269.086, -2098.94312, -8.425, 0.00, 0.00, 170.464); // объект 159
	CreateDynamicObject(8263, 269.086, -2098.94312, -14.925, 0.00, 0.00, 170.464); // объект 160
	CreateDynamicObject(8263, 269.086, -2098.94312, -21.425, 0.00, 0.00, 170.464); // объект 161
	CreateDynamicObject(8263, 269.086, -2098.94312, -27.925, 0.00, 0.00, 170.464); // объект 162
	CreateDynamicObject(8263, 387.34399, -2118.80493, -27.925, 0.00, 0.00, 170.464); // объект 163
	CreateDynamicObject(8263, 387.34399, -2118.80493, -20.925, 0.00, 0.00, 170.464); // объект 164
	CreateDynamicObject(8263, 387.34399, -2118.80493, -13.925, 0.00, 0.00, 170.464); // объект 165
	CreateDynamicObject(8263, 387.34399, -2118.80493, -7.175, 0.00, 0.00, 170.464); // объект 166
	CreateDynamicObject(8263, 387.34399, -2118.80493, -0.175, 0.00, 0.00, 170.464); // объект 167
	CreateDynamicObject(8263, 387.34399, -2118.80493, 6.575, 0.00, 0.00, 170.464); // объект 168
	CreateDynamicObject(8263, 387.34399, -2118.80493, 13.575, 0.00, 0.00, 170.464); // объект 169
	CreateDynamicObject(8263, 387.34399, -2118.80493, 20.325, 0.00, 0.00, 170.464); // объект 170
	CreateDynamicObject(8263, 387.34399, -2118.80493, 27.075, 0.00, 0.00, 170.464); // объект 171
	CreateDynamicObject(8263, 387.34399, -2118.80493, 34.075, 0.00, 0.00, 170.464); // объект 172
	CreateDynamicObject(8263, 387.34399, -2118.80493, 41.075, 0.00, 0.00, 170.464); // объект 173
	CreateDynamicObject(8263, 387.34399, -2118.80493, 47.825, 0.00, 0.00, 170.464); // объект 174
	CreateDynamicObject(8263, 387.34399, -2118.80493, 54.575, 0.00, 0.00, 170.464); // объект 175
	CreateDynamicObject(8263, 505.55701, -2138.66797, 41.075, 0.00, 0.00, 170.464); // объект 176
	CreateDynamicObject(8263, 505.55701, -2138.66797, 34.075, 0.00, 0.00, 170.464); // объект 177
	CreateDynamicObject(8263, 505.55701, -2138.66797, 27.575, 0.00, 0.00, 170.464); // объект 178
	CreateDynamicObject(8263, 505.55701, -2138.66797, 21.075, 0.00, 0.00, 170.464); // объект 179
	CreateDynamicObject(8263, 505.55701, -2138.66797, 14.325, 0.00, 0.00, 170.464); // объект 180
	CreateDynamicObject(8263, 505.55701, -2138.66797, 8.075, 0.00, 0.00, 170.464); // объект 181
	CreateDynamicObject(8263, 505.55701, -2138.66797, 1.325, 0.00, 0.00, 170.464); // объект 182
	CreateDynamicObject(8263, 505.55701, -2138.66797, -5.675, 0.00, 0.00, 170.464); // объект 183
	CreateDynamicObject(8263, 505.55701, -2138.66797, -12.675, 0.00, 0.00, 170.464); // объект 184
	CreateDynamicObject(8263, 505.55701, -2138.66797, -19.425, 0.00, 0.00, 170.464); // объект 185
	CreateDynamicObject(8263, 505.55701, -2138.66797, -25.925, 0.00, 0.00, 170.464); // объект 186
	CreateDynamicObject(8263, 623.66602, -2158.729, -27.425, 0.00, 0.00, 170.464); // объект 187
	CreateDynamicObject(8263, 623.66602, -2158.729, -20.675, 0.00, 0.00, 170.464); // объект 188
	CreateDynamicObject(8263, 623.66602, -2158.729, -13.925, 0.00, 0.00, 170.464); // объект 189
	CreateDynamicObject(8263, 623.66602, -2158.729, -6.925, 0.00, 0.00, 170.464); // объект 190
	CreateDynamicObject(8263, 623.66602, -2158.729, 0.075, 0.00, 0.00, 170.464); // объект 191
	CreateDynamicObject(8263, 623.66602, -2158.729, 7.075, 0.00, 0.00, 170.464); // объект 192
	CreateDynamicObject(8263, 623.66602, -2158.729, 14.075, 0.00, 0.00, 170.464); // объект 193
	CreateDynamicObject(8263, 623.66602, -2158.729, 21.075, 0.00, 0.00, 170.464); // объект 194
	CreateDynamicObject(8263, 623.66602, -2158.729, 27.825, 0.00, 0.00, 170.464); // объект 195
	CreateDynamicObject(8263, 623.66602, -2158.729, 34.575, 0.00, 0.00, 170.464); // объект 196
	CreateDynamicObject(8263, 742.05103, -2178.68408, 27.82, 0.00, 0.00, 170.464); // объект 197
	CreateDynamicObject(8263, 742.05103, -2178.68408, 21.07, 0.00, 0.00, 170.464); // объект 198
	CreateDynamicObject(8263, 742.05103, -2178.68408, 14.32, 0.00, 0.00, 170.464); // объект 199
	CreateDynamicObject(8263, 742.05103, -2178.68408, 7.32, 0.00, 0.00, 170.464); // объект 200
	CreateDynamicObject(8263, 742.05103, -2178.68408, 0.57, 0.00, 0.00, 170.464); // объект 201
	CreateDynamicObject(8263, 742.05103, -2178.68408, -6.43, 0.00, 0.00, 170.464); // объект 202
	CreateDynamicObject(8263, 742.05103, -2178.68408, -13.43, 0.00, 0.00, 170.464); // объект 203
	CreateDynamicObject(8263, 742.05103, -2178.68408, -19.93, 0.00, 0.00, 170.464); // объект 204
	CreateDynamicObject(8263, 742.05103, -2178.68408, -26.43, 0.00, 0.00, 170.464); // объект 205
	CreateDynamicObject(8263, 742.05103, -2178.68408, -33.43, 0.00, 0.00, 170.464); // объект 206
	CreateDynamicObject(8263, 623.94501, -2158.71191, -33.43, 0.00, 0.00, 170.464); // объект 207
	CreateDynamicObject(8263, 849.83099, -2223.43896, 27.745, 0.00, 0.00, 144.464); // объект 208
	CreateDynamicObject(8263, 849.83002, -2223.43896, 20.995, 0.00, 0.00, 144.459); // объект 209
	CreateDynamicObject(8263, 849.82898, -2223.43896, 14.245, 0.00, 0.00, 144.459); // объект 210
	CreateDynamicObject(8263, 849.828, -2223.43896, 7.495, 0.00, 0.00, 144.459); // объект 211
	CreateDynamicObject(8263, 849.82703, -2223.43896, 0.995, 0.00, 0.00, 144.459); // объект 212
	CreateDynamicObject(8263, 849.82599, -2223.43896, -6.005, 0.00, 0.00, 144.459); // объект 213
	CreateDynamicObject(8263, 849.82501, -2223.43896, -13.005, 0.00, 0.00, 144.459); // объект 214
	CreateDynamicObject(8263, 947.039, -2292.92798, -6.005, 0.00, 0.00, 144.459); // объект 215
	CreateDynamicObject(8263, 947.03802, -2292.92798, 0.995, 0.00, 0.00, 144.459); // объект 216
	CreateDynamicObject(8263, 947.03699, -2292.92798, 7.745, 0.00, 0.00, 144.459); // объект 217
	CreateDynamicObject(8263, 947.03601, -2292.92798, 14.495, 0.00, 0.00, 144.459); // объект 218
	CreateDynamicObject(8263, 947.03497, -2292.92798, 21.245, 0.00, 0.00, 144.459); // объект 219
	CreateDynamicObject(8263, 947.034, -2292.92798, 27.745, 0.00, 0.00, 144.459); // объект 220
	CreateDynamicObject(8263, 947.03302, -2292.92798, 34.745, 0.00, 0.00, 144.459); // объект 221
	CreateDynamicObject(8263, 947.03198, -2292.92798, 41.495, 0.00, 0.00, 144.459); // объект 222
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 41.545, 0.00, 0.00, 144.459); // объект 223
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 34.545, 0.00, 0.00, 144.459); // объект 224
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 27.545, 0.00, 0.00, 144.459); // объект 225
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 20.795, 0.00, 0.00, 144.459); // объект 226
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 14.045, 0.00, 0.00, 144.459); // объект 227
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 7.045, 0.00, 0.00, 144.459); // объект 228
	CreateDynamicObject(8263, 1044.33496, -2362.87891, 0.295, 0.00, 0.00, 144.459); // объект 229
	CreateDynamicObject(8263, 1044.33496, -2362.87891, -6.455, 0.00, 0.00, 144.459); // объект 230
	CreateDynamicObject(8263, 1044.40906, -2362.78491, 48.585, 0.00, 0.00, 144.459); // объект 231
	CreateDynamicObject(8263, 947.08197, -2293.00195, 48.61, 0.00, 0.00, 144.459); // объект 232
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 48.61, 0.00, 0.00, 144.459); // объект 233
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 41.61, 0.00, 0.00, 144.459); // объект 234
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 34.61, 0.00, 0.00, 144.459); // объект 235
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 27.86, 0.00, 0.00, 144.459); // объект 236
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 21.11, 0.00, 0.00, 144.459); // объект 237
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 14.36, 0.00, 0.00, 144.459); // объект 238
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 7.36, 0.00, 0.00, 144.459); // объект 239
	CreateDynamicObject(8263, 1141.87305, -2432.39209, 0.36, 0.00, 0.00, 144.459); // объект 240
	CreateDynamicObject(8263, 1141.87305, -2432.39209, -6.59, 0.00, 0.00, 144.459); // объект 241
	CreateDynamicObject(8263, 1234.99097, -2507.2959, 48.58, 0.00, 0.00, 137.959); // объект 242
	CreateDynamicObject(8263, 1234.98999, -2507.2959, 41.58, 0.00, 0.00, 137.955); // объект 243
	CreateDynamicObject(8263, 1234.98901, -2507.2959, 35.08, 0.00, 0.00, 137.955); // объект 244
	CreateDynamicObject(8263, 1234.98804, -2507.2959, 28.08, 0.00, 0.00, 137.955); // объект 245
	CreateDynamicObject(8263, 1234.98706, -2507.2959, 21.33, 0.00, 0.00, 137.955); // объект 246
	CreateDynamicObject(8263, 1234.98596, -2507.2959, 14.83, 0.00, 0.00, 137.955); // объект 247
	CreateDynamicObject(8263, 1234.98499, -2507.2959, 7.83, 0.00, 0.00, 137.955); // объект 248
	CreateDynamicObject(8263, 1234.98401, -2507.2959, 1.33, 0.00, 0.00, 137.955); // объект 249
	CreateDynamicObject(8263, 1234.98303, -2507.2959, -5.42, 0.00, 0.00, 137.955); // объект 250
	CreateDynamicObject(8263, 1323.98499, -2587.5979, 1.46, 0.00, 0.00, 137.955); // объект 251
	CreateDynamicObject(8263, 1323.98401, -2587.5979, 7.96, 0.00, 0.00, 137.955); // объект 252
	CreateDynamicObject(8263, 1323.98303, -2587.5979, 14.96, 0.00, 0.00, 137.955); // объект 253
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 21.96, 0.00, 0.00, 137.955); // объект 254
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 28.71, 0.00, 0.00, 137.955); // объект 255
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 35.46, 0.00, 0.00, 137.955); // объект 256
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 42.46, 0.00, 0.00, 137.955); // объект 257
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 48.585, 0.00, 0.00, 137.955); // объект 258
	CreateDynamicObject(8263, 1427.63501, -2638.19604, 48.56, 0.00, 0.00, 169.955); // объект 259
	CreateDynamicObject(8263, 1427.63501, -2638.19507, 41.56, 0.00, 0.00, 169.953); // объект 260
	CreateDynamicObject(8263, 1427.63501, -2638.19409, 34.56, 0.00, 0.00, 169.953); // объект 261
	CreateDynamicObject(8263, 1427.63501, -2638.19312, 27.81, 0.00, 0.00, 169.953); // объект 262
	CreateDynamicObject(8263, 1427.63501, -2638.19312, 20.81, 0.00, 0.00, 169.953); // объект 263
	CreateDynamicObject(8263, 1427.63501, -2638.19312, 13.81, 0.00, 0.00, 169.953); // объект 264
	CreateDynamicObject(8263, 1546.573, -2648.82788, 13.81, 0.00, 0.00, 179.953); // объект 265
	CreateDynamicObject(8263, 1546.57202, -2648.8269, 20.81, 0.00, 0.00, 179.951); // объект 266
	CreateDynamicObject(8263, 1546.57104, -2648.82593, 27.81, 0.00, 0.00, 179.951); // объект 267
	CreateDynamicObject(8263, 1546.56995, -2648.82495, 34.56, 0.00, 0.00, 179.951); // объект 268
	CreateDynamicObject(8263, 1546.56897, -2648.82397, 41.56, 0.00, 0.00, 179.951); // объект 269
	CreateDynamicObject(8263, 1546.56799, -2648.823, 48.06, 0.00, 0.00, 179.951); // объект 270
	CreateDynamicObject(8263, 1546.56702, -2648.82202, 54.81, 0.00, 0.00, 179.951); // объект 271
	CreateDynamicObject(8263, 1546.56604, -2648.82104, 61.56, 0.00, 0.00, 179.951); // объект 272
	CreateDynamicObject(8263, 1546.56494, -2648.82007, 68.31, 0.00, 0.00, 179.951); // объект 273
	CreateDynamicObject(8263, 1427.63501, -2638.19409, 55.31, 0.00, 0.00, 169.953); // объект 274
	CreateDynamicObject(8263, 1427.63501, -2638.19312, 62.06, 0.00, 0.00, 169.953); // объект 275
	CreateDynamicObject(8263, 1427.63501, -2638.19312, 68.81, 0.00, 0.00, 169.953); // объект 276
	CreateDynamicObject(8263, 1234.98901, -2507.2959, 55.58, 0.00, 0.00, 137.955); // объект 277
	CreateDynamicObject(8263, 1234.98804, -2507.2959, 62.58, 0.00, 0.00, 137.955); // объект 278
	CreateDynamicObject(8263, 1234.98706, -2507.2959, 69.08, 0.00, 0.00, 137.955); // объект 279
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 55.335, 0.00, 0.00, 137.955); // объект 280
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 62.335, 0.00, 0.00, 137.955); // объект 281
	CreateDynamicObject(8263, 1323.98206, -2587.5979, 69.335, 0.00, 0.00, 137.955); // объект 282
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 61.585, 0.00, 0.00, 179.951); // объект 283
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 68.335, 0.00, 0.00, 179.951); // объект 284
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 54.585, 0.00, 0.00, 179.951); // объект 285
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 47.835, 0.00, 0.00, 179.951); // объект 286
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 41.335, 0.00, 0.00, 179.951); // объект 287
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 34.335, 0.00, 0.00, 179.951); // объект 288
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 27.585, 0.00, 0.00, 179.951); // объект 289
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 20.585, 0.00, 0.00, 179.951); // объект 290
	CreateDynamicObject(8263, 1666.38501, -2648.9541, 13.585, 0.00, 0.00, 179.951); // объект 291
	CreateDynamicObject(8263, 1786.21594, -2649.03003, 13.585, 0.00, 0.00, 179.951); // объект 292
	CreateDynamicObject(8263, 1786.21594, -2649.02905, 20.585, 0.00, 0.00, 179.951); // объект 293
	CreateDynamicObject(8263, 1786.21594, -2649.02808, 27.335, 0.00, 0.00, 179.951); // объект 294
	CreateDynamicObject(8263, 1786.21594, -2649.0271, 34.585, 0.00, 0.00, 179.951); // объект 295
	CreateDynamicObject(8263, 1786.21594, -2649.02588, 41.835, 0.00, 0.00, 179.951); // объект 296
	CreateDynamicObject(8263, 1786.21594, -2649.02588, 48.585, 0.00, 0.00, 179.951); // объект 297
	CreateDynamicObject(8263, 1786.21594, -2649.02588, 55.335, 0.00, 0.00, 179.951); // объект 298
	CreateDynamicObject(8263, 1786.21594, -2649.02588, 62.335, 0.00, 0.00, 179.951); // объект 299
	CreateDynamicObject(8263, 1786.21594, -2649.02588, 68.335, 0.00, 0.00, 179.951); // объект 0
	CreateDynamicObject(8263, 1906.11304, -2649.12109, 68.385, 0.00, 0.00, 179.951); // объект 1
	CreateDynamicObject(8263, 1906.11206, -2649.12109, 61.385, 0.00, 0.00, 179.951); // объект 2
	CreateDynamicObject(8263, 1906.11096, -2649.12109, 54.385, 0.00, 0.00, 179.951); // объект 3
	CreateDynamicObject(8263, 1906.10999, -2649.12109, 47.635, 0.00, 0.00, 179.951); // объект 4
	CreateDynamicObject(8263, 1906.10901, -2649.12109, 40.885, 0.00, 0.00, 179.951); // объект 5
	CreateDynamicObject(8263, 1906.10803, -2649.12109, 33.885, 0.00, 0.00, 179.951); // объект 6
	CreateDynamicObject(8263, 1906.10706, -2649.12109, 27.135, 0.00, 0.00, 179.951); // объект 7
	CreateDynamicObject(8263, 1906.10706, -2649.12109, 20.135, 0.00, 0.00, 179.951); // объект 8
	CreateDynamicObject(8263, 1906.10706, -2649.12109, 13.385, 0.00, 0.00, 179.951); // объект 9
	CreateDynamicObject(8263, 2025.91699, -2649.23608, 13.41, 0.00, 0.00, 179.951); // объект 10
	CreateDynamicObject(8263, 2025.91699, -2649.23511, 20.16, 0.00, 0.00, 179.951); // объект 11
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 26.91, 0.00, 0.00, 179.951); // объект 12
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 33.91, 0.00, 0.00, 179.951); // объект 13
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 40.66, 0.00, 0.00, 179.951); // объект 14
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 47.66, 0.00, 0.00, 179.951); // объект 15
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 54.41, 0.00, 0.00, 179.951); // объект 16
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 61.16, 0.00, 0.00, 179.951); // объект 17
	CreateDynamicObject(8263, 2025.91699, -2649.23389, 68.16, 0.00, 0.00, 179.951); // объект 18
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 68.16, 0.00, 0.00, 179.951); // объект 19
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 61.16, 0.00, 0.00, 179.951); // объект 20
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 54.41, 0.00, 0.00, 179.951); // объект 21
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 47.41, 0.00, 0.00, 179.951); // объект 22
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 40.41, 0.00, 0.00, 179.951); // объект 23
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 33.41, 0.00, 0.00, 179.951); // объект 24
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 26.66, 0.00, 0.00, 179.951); // объект 25
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 19.66, 0.00, 0.00, 179.951); // объект 26
	CreateDynamicObject(8263, 2145.72412, -2649.35498, 12.91, 0.00, 0.00, 179.951); // объект 27
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 12.91, 0.00, 0.00, 179.951); // объект 28
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 19.66, 0.00, 0.00, 179.951); // объект 29
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 26.41, 0.00, 0.00, 179.951); // объект 30
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 33.41, 0.00, 0.00, 179.951); // объект 31
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 40.16, 0.00, 0.00, 179.951); // объект 32
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 47.16, 0.00, 0.00, 179.951); // объект 33
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 53.91, 0.00, 0.00, 179.951); // объект 34
	CreateDynamicObject(8263, 2265.58691, -2649.41309, 60.66, 0.00, 0.00, 179.951); // объект 35
	CreateDynamicObject(8263, 2265.55811, -2649.47192, 67.585, 0.00, 0.00, 179.951); // объект 36
	CreateDynamicObject(8263, 2265.55811, -2649.47192, 6.035, 0.00, 0.00, 179.951); // объект 37
	CreateDynamicObject(8263, 2265.55811, -2649.47192, -0.965, 0.00, 0.00, 179.951); // объект 38
	CreateDynamicObject(8263, 2265.55811, -2649.47192, -7.715, 0.00, 0.00, 179.951); // объект 39
	CreateDynamicObject(8263, 2265.55811, -2649.47192, -14.465, 0.00, 0.00, 179.951); // объект 40
	CreateDynamicObject(8263, 2265.55811, -2649.47192, -20.965, 0.00, 0.00, 179.951); // объект 41
	CreateDynamicObject(8263, 2385.40601, -2649.54102, -20.965, 0.00, 0.00, 179.951); // объект 42
	CreateDynamicObject(8263, 2385.40503, -2649.54102, -13.965, 0.00, 0.00, 179.951); // объект 43
	CreateDynamicObject(8263, 2385.40405, -2649.54102, -6.965, 0.00, 0.00, 179.951); // объект 44
	CreateDynamicObject(8263, 2385.40308, -2649.54102, 0.035, 0.00, 0.00, 179.951); // объект 45
	CreateDynamicObject(8263, 2385.4021, -2649.54102, 6.785, 0.00, 0.00, 179.951); // объект 46
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 13.785, 0.00, 0.00, 179.951); // объект 47
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 20.785, 0.00, 0.00, 179.951); // объект 48
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 27.535, 0.00, 0.00, 179.951); // объект 49
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 34.035, 0.00, 0.00, 179.951); // объект 50
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 40.535, 0.00, 0.00, 179.951); // объект 51
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 47.035, 0.00, 0.00, 179.951); // объект 52
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 53.535, 0.00, 0.00, 179.951); // объект 53
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 60.035, 0.00, 0.00, 179.951); // объект 54
	CreateDynamicObject(8263, 2385.40088, -2649.54102, 67.035, 0.00, 0.00, 179.951); // объект 55
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 67.035, 0.00, 0.00, 179.951); // объект 56
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 60.285, 0.00, 0.00, 179.951); // объект 57
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 53.285, 0.00, 0.00, 179.951); // объект 58
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 46.285, 0.00, 0.00, 179.951); // объект 59
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 39.785, 0.00, 0.00, 179.951); // объект 60
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 33.285, 0.00, 0.00, 179.951); // объект 61
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 26.535, 0.00, 0.00, 179.951); // объект 62
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 20.035, 0.00, 0.00, 179.951); // объект 63
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 13.285, 0.00, 0.00, 179.951); // объект 64
	CreateDynamicObject(8263, 2505.30908, -2649.74512, 6.535, 0.00, 0.00, 179.951); // объект 65
	CreateDynamicObject(8263, 2505.30908, -2649.74512, -0.215, 0.00, 0.00, 179.951); // объект 66
	CreateDynamicObject(8263, 2505.30908, -2649.74512, -7.215, 0.00, 0.00, 179.951); // объект 67
	CreateDynamicObject(8263, 2505.30908, -2649.74512, -14.215, 0.00, 0.00, 179.951); // объект 68
	CreateDynamicObject(8263, 2505.30908, -2649.74512, -20.965, 0.00, 0.00, 179.951); // объект 69
	CreateDynamicObject(8263, 3190.33398, -1136.61597, 26.255, 0.00, 0.00, 275.966); // объект 70
	CreateDynamicObject(8263, 3190.33398, -1136.61499, 19.505, 0.00, 0.00, 275.966); // объект 71
	CreateDynamicObject(8263, 3190.33398, -1136.61401, 12.505, 0.00, 0.00, 275.966); // объект 72
	CreateDynamicObject(8263, 3190.33398, -1136.61304, 5.505, 0.00, 0.00, 275.966); // объект 73
	CreateDynamicObject(8263, 3190.33398, -1136.61206, -1.245, 0.00, 0.00, 275.966); // объект 74
	CreateDynamicObject(8263, 3190.33398, -1136.61096, -8.245, 0.00, 0.00, 275.966); // объект 75
	CreateDynamicObject(8263, 3190.33398, -1136.60999, -14.995, 0.00, 0.00, 275.966); // объект 76
	CreateDynamicObject(8263, 3190.33398, -1136.60901, -21.995, 0.00, 0.00, 275.966); // объект 77
	CreateDynamicObject(8263, 3190.33398, -1136.60803, -28.745, 0.00, 0.00, 275.966); // объект 78
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -35.495, 0.00, 0.00, 275.966); // объект 79
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -42.495, 0.00, 0.00, 275.966); // объект 80
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -49.245, 0.00, 0.00, 275.966); // объект 81
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -56.245, 0.00, 0.00, 275.966); // объект 82
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -63.245, 0.00, 0.00, 275.966); // объект 83
	CreateDynamicObject(8263, 3190.33398, -1136.60706, -70.245, 0.00, 0.00, 275.966); // объект 84
	CreateDynamicObject(8263, 3202.78101, -1255.66199, -70.245, 0.00, 0.00, 275.966); // объект 85
	CreateDynamicObject(8263, 3215.10498, -1374.901, -70.245, 0.00, 0.00, 275.966); // объект 86
	CreateDynamicObject(8263, 3227.36597, -1494.21497, -70.245, 0.00, 0.00, 275.966); // объект 87
	CreateDynamicObject(8263, 3202.78003, -1255.66101, -63.245, 0.00, 0.00, 275.966); // объект 88
	CreateDynamicObject(8263, 3202.77905, -1255.66003, -56.245, 0.00, 0.00, 275.966); // объект 89
	CreateDynamicObject(8263, 3202.77808, -1255.65906, -49.245, 0.00, 0.00, 275.966); // объект 90
	CreateDynamicObject(8263, 3202.7771, -1255.65796, -42.245, 0.00, 0.00, 275.966); // объект 91
	CreateDynamicObject(8263, 3202.77588, -1255.65698, -35.245, 0.00, 0.00, 275.966); // объект 92
	CreateDynamicObject(8263, 3202.77588, -1255.65601, -28.495, 0.00, 0.00, 275.966); // объект 93
	CreateDynamicObject(8263, 3202.77588, -1255.65503, -21.745, 0.00, 0.00, 275.966); // объект 94
	CreateDynamicObject(8263, 3202.77588, -1255.65405, -14.995, 0.00, 0.00, 275.966); // объект 95
	CreateDynamicObject(8263, 3202.77588, -1255.65295, -8.245, 0.00, 0.00, 275.966); // объект 96
	CreateDynamicObject(8263, 3202.77588, -1255.65198, -1.245, 0.00, 0.00, 275.966); // объект 97
	CreateDynamicObject(8263, 3202.77588, -1255.651, 5.755, 0.00, 0.00, 275.966); // объект 98
	CreateDynamicObject(8263, 3202.77588, -1255.65002, 12.755, 0.00, 0.00, 275.966); // объект 99
	CreateDynamicObject(8263, 3202.77588, -1255.64905, 19.755, 0.00, 0.00, 275.966); // объект 100
	CreateDynamicObject(8263, 3202.77588, -1255.64795, 26.755, 0.00, 0.00, 275.966); // объект 101
	CreateDynamicObject(8263, 3215.10498, -1374.90002, -62.995, 0.00, 0.00, 275.966); // объект 102
	CreateDynamicObject(8263, 3215.10498, -1374.89905, -56.245, 0.00, 0.00, 275.966); // объект 103
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -49.245, 0.00, 0.00, 275.966); // объект 104
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -42.495, 0.00, 0.00, 275.966); // объект 105
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -35.995, 0.00, 0.00, 275.966); // объект 106
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -29.495, 0.00, 0.00, 275.966); // объект 107
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -22.495, 0.00, 0.00, 275.966); // объект 108
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -15.495, 0.00, 0.00, 275.966); // объект 109
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -8.745, 0.00, 0.00, 275.966); // объект 110
	CreateDynamicObject(8263, 3215.10498, -1374.89795, -1.495, 0.00, 0.00, 275.966); // объект 111
	CreateDynamicObject(8263, 3215.10498, -1374.89795, 5.255, 0.00, 0.00, 275.966); // объект 112
	CreateDynamicObject(8263, 3215.10498, -1374.89795, 12.255, 0.00, 0.00, 275.966); // объект 113
	CreateDynamicObject(8263, 3215.10498, -1374.89795, 19.255, 0.00, 0.00, 275.966); // объект 114
	CreateDynamicObject(8263, 3215.10498, -1374.89795, 26.63, 0.00, 0.00, 275.966); // объект 115
	CreateDynamicObject(8263, 3227.36499, -1494.21497, -63.245, 0.00, 0.00, 275.966); // объект 116
	CreateDynamicObject(8263, 3227.36401, -1494.21497, -56.495, 0.00, 0.00, 275.966); // объект 117
	CreateDynamicObject(8263, 3227.36304, -1494.21497, -49.495, 0.00, 0.00, 275.966); // объект 118
	CreateDynamicObject(8263, 3227.36206, -1494.21497, -42.495, 0.00, 0.00, 275.966); // объект 119
	CreateDynamicObject(8263, 3227.36108, -1494.21497, -35.495, 0.00, 0.00, 275.966); // объект 120
	CreateDynamicObject(8263, 3227.36011, -1494.21497, -28.745, 0.00, 0.00, 275.966); // объект 121
	CreateDynamicObject(8263, 3227.35889, -1494.21497, -22.995, 0.00, 0.00, 275.966); // объект 122
	CreateDynamicObject(8263, 3227.35889, -1494.21497, -16.245, 0.00, 0.00, 275.966); // объект 123
	CreateDynamicObject(8263, 3227.35889, -1494.21497, -9.245, 0.00, 0.00, 275.966); // объект 124
	CreateDynamicObject(8263, 3227.35889, -1494.21497, -2.245, 0.00, 0.00, 275.966); // объект 125
	CreateDynamicObject(8263, 3227.35889, -1494.21497, 0.255, 0.00, 0.00, 275.966); // объект 126
	CreateDynamicObject(8263, 3227.35889, -1494.21497, 7.005, 0.00, 0.00, 275.966); // объект 127
	CreateDynamicObject(8263, 3227.35889, -1494.21497, 14.005, 0.00, 0.00, 275.966); // объект 128
	CreateDynamicObject(8263, 3227.35889, -1494.21497, 21.005, 0.00, 0.00, 275.966); // объект 129
	CreateDynamicObject(8263, 3227.35889, -1494.21497, 26.505, 0.00, 0.00, 275.966); // объект 130
	CreateDynamicObject(8263, 3239.76196, -1613.50806, 26.505, 0.00, 0.00, 275.966); // объект 131
	CreateDynamicObject(8263, 3252.22192, -1732.70801, 26.505, 0.00, 0.00, 275.966); // объект 132
	CreateDynamicObject(8263, 3264.63794, -1851.896, 26.505, 0.00, 0.00, 275.966); // объект 133
	CreateDynamicObject(8263, 3277.17993, -1971.04395, 26.555, 0.00, 0.00, 275.966); // объект 134
	CreateDynamicObject(8263, 3239.76196, -1613.50806, 19.755, 0.00, 0.00, 275.966); // объект 135
	CreateDynamicObject(8263, 3239.76196, -1613.50806, 12.755, 0.00, 0.00, 275.966); // объект 136
	CreateDynamicObject(8263, 3239.76196, -1613.50806, 5.755, 0.00, 0.00, 275.966); // объект 137
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -1.245, 0.00, 0.00, 275.966); // объект 138
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -7.995, 0.00, 0.00, 275.966); // объект 139
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -14.995, 0.00, 0.00, 275.966); // объект 140
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -21.745, 0.00, 0.00, 275.966); // объект 141
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -28.745, 0.00, 0.00, 275.966); // объект 142
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -35.245, 0.00, 0.00, 275.966); // объект 143
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -42.245, 0.00, 0.00, 275.966); // объект 144
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -49.245, 0.00, 0.00, 275.966); // объект 145
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -56.245, 0.00, 0.00, 275.966); // объект 146
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -62.745, 0.00, 0.00, 275.966); // объект 147
	CreateDynamicObject(8263, 3239.76196, -1613.50806, -69.745, 0.00, 0.00, 275.966); // объект 148
	CreateDynamicObject(8263, 3252.22192, -1732.70801, 19.505, 0.00, 0.00, 275.966); // объект 149
	CreateDynamicObject(8263, 3252.22192, -1732.70801, 12.755, 0.00, 0.00, 275.966); // объект 150
	CreateDynamicObject(8263, 3252.22192, -1732.70801, 6.005, 0.00, 0.00, 275.966); // объект 151
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -0.495, 0.00, 0.00, 275.966); // объект 152
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -7.495, 0.00, 0.00, 275.966); // объект 153
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -14.495, 0.00, 0.00, 275.966); // объект 154
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -20.745, 0.00, 0.00, 275.966); // объект 155
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -27.495, 0.00, 0.00, 275.966); // объект 156
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -34.495, 0.00, 0.00, 275.966); // объект 157
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -41.495, 0.00, 0.00, 275.966); // объект 158
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -48.495, 0.00, 0.00, 275.966); // объект 159
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -55.495, 0.00, 0.00, 275.966); // объект 160
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -62.245, 0.00, 0.00, 275.966); // объект 161
	CreateDynamicObject(8263, 3252.22192, -1732.70801, -68.995, 0.00, 0.00, 275.966); // объект 162
	CreateDynamicObject(8263, 3264.63794, -1851.896, 19.505, 0.00, 0.00, 275.966); // объект 163
	CreateDynamicObject(8263, 3264.63794, -1851.896, 12.505, 0.00, 0.00, 275.966); // объект 164
	CreateDynamicObject(8263, 3264.63794, -1851.896, 6.005, 0.00, 0.00, 275.966); // объект 165
	CreateDynamicObject(8263, 3264.63794, -1851.896, -0.995, 0.00, 0.00, 275.966); // объект 166
	CreateDynamicObject(8263, 3264.63794, -1851.896, -7.995, 0.00, 0.00, 275.966); // объект 167
	CreateDynamicObject(8263, 3264.63794, -1851.896, -14.995, 0.00, 0.00, 275.966); // объект 168
	CreateDynamicObject(8263, 3264.63794, -1851.896, -21.745, 0.00, 0.00, 275.966); // объект 169
	CreateDynamicObject(8263, 3264.63794, -1851.896, -28.745, 0.00, 0.00, 275.966); // объект 170
	CreateDynamicObject(8263, 3264.63794, -1851.896, -35.495, 0.00, 0.00, 275.966); // объект 171
	CreateDynamicObject(8263, 3264.63794, -1851.896, -42.245, 0.00, 0.00, 275.966); // объект 172
	CreateDynamicObject(8263, 3264.63794, -1851.896, -48.745, 0.00, 0.00, 275.966); // объект 173
	CreateDynamicObject(8263, 3264.63794, -1851.896, -55.495, 0.00, 0.00, 275.966); // объект 174
	CreateDynamicObject(8263, 3264.63794, -1851.896, -62.495, 0.00, 0.00, 275.966); // объект 175
	CreateDynamicObject(8263, 3264.63794, -1851.896, -69.245, 0.00, 0.00, 275.966); // объект 176
	CreateDynamicObject(8263, 3277.17993, -1971.04395, 19.805, 0.00, 0.00, 275.966); // объект 177
	CreateDynamicObject(8263, 3277.17993, -1971.04395, 13.055, 0.00, 0.00, 275.966); // объект 178
	CreateDynamicObject(8263, 3277.17993, -1971.04395, 6.055, 0.00, 0.00, 275.966); // объект 179
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -0.695, 0.00, 0.00, 275.966); // объект 180
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -7.695, 0.00, 0.00, 275.966); // объект 181
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -14.445, 0.00, 0.00, 275.966); // объект 182
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -21.195, 0.00, 0.00, 275.966); // объект 183
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -28.195, 0.00, 0.00, 275.966); // объект 184
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -35.195, 0.00, 0.00, 275.966); // объект 185
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -42.195, 0.00, 0.00, 275.966); // объект 186
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -48.945, 0.00, 0.00, 275.966); // объект 187
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -55.945, 0.00, 0.00, 275.966); // объект 188
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -62.695, 0.00, 0.00, 275.966); // объект 189
	CreateDynamicObject(8263, 3277.17993, -1971.04395, -69.945, 0.00, 0.00, 275.966); // объект 190
	CreateDynamicObject(8263, 3289.61304, -2090.17798, -69.945, 0.00, 0.00, 275.966); // объект 191
	CreateDynamicObject(8263, 3289.61206, -2090.17798, -63.195, 0.00, 0.00, 275.966); // объект 192
	CreateDynamicObject(8263, 3289.61108, -2090.17798, -56.195, 0.00, 0.00, 275.966); // объект 193
	CreateDynamicObject(8263, 3289.61011, -2090.17798, -49.445, 0.00, 0.00, 275.966); // объект 194
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -42.445, 0.00, 0.00, 275.966); // объект 195
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -35.945, 0.00, 0.00, 275.966); // объект 196
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -29.195, 0.00, 0.00, 275.966); // объект 197
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -22.195, 0.00, 0.00, 275.966); // объект 198
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -15.195, 0.00, 0.00, 275.966); // объект 199
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -8.445, 0.00, 0.00, 275.966); // объект 200
	CreateDynamicObject(8263, 3289.60889, -2090.17798, -1.445, 0.00, 0.00, 275.966); // объект 201
	CreateDynamicObject(8263, 3289.60889, -2090.17798, 5.305, 0.00, 0.00, 275.966); // объект 202
	CreateDynamicObject(8263, 3289.60889, -2090.17798, 12.305, 0.00, 0.00, 275.966); // объект 203
	CreateDynamicObject(8263, 3289.60889, -2090.17798, 19.055, 0.00, 0.00, 275.966); // объект 204
	CreateDynamicObject(8263, 3289.60889, -2090.17798, 26.555, 0.00, 0.00, 275.966); // объект 205
	CreateDynamicObject(8263, 3289.60889, -2090.17798, 19.805, 0.00, 0.00, 275.966); // объект 206
	CreateDynamicObject(8263, 3302.23096, -2209.23901, -22.195, 0.00, 0.00, 275.966); // объект 207
	CreateDynamicObject(8263, 3314.88403, -2328.03394, -22.195, 0.00, 0.00, 275.966); // объект 208
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -22.195, 0.00, 0.00, 275.966); // объект 209
	CreateDynamicObject(8263, 3302.23096, -2209.23804, -29.195, 0.00, 0.00, 275.966); // объект 210
	CreateDynamicObject(8263, 3302.23096, -2209.23706, -36.195, 0.00, 0.00, 275.966); // объект 211
	CreateDynamicObject(8263, 3302.23096, -2209.23608, -43.195, 0.00, 0.00, 275.966); // объект 212
	CreateDynamicObject(8263, 3302.23096, -2209.23511, -49.945, 0.00, 0.00, 275.966); // объект 213
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -56.945, 0.00, 0.00, 275.966); // объект 214
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -63.445, 0.00, 0.00, 275.966); // объект 215
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -70.445, 0.00, 0.00, 275.966); // объект 216
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -15.175, 0.00, 0.00, 275.966); // объект 217
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -8.175, 0.00, 0.00, 275.966); // объект 218
	CreateDynamicObject(8263, 3302.23096, -2209.23389, -1.425, 0.00, 0.00, 275.966); // объект 219
	CreateDynamicObject(8263, 3302.23096, -2209.23389, 5.575, 0.00, 0.00, 275.966); // объект 220
	CreateDynamicObject(8263, 3302.23096, -2209.23389, 12.575, 0.00, 0.00, 275.966); // объект 221
	CreateDynamicObject(8263, 3302.23096, -2209.23389, 19.325, 0.00, 0.00, 275.966); // объект 222
	CreateDynamicObject(8263, 3302.23096, -2209.23389, 26.075, 0.00, 0.00, 275.966); // объект 223
	CreateDynamicObject(8263, 3314.88403, -2328.03296, -28.945, 0.00, 0.00, 275.966); // объект 224
	CreateDynamicObject(8263, 3314.88403, -2328.03198, -15.195, 0.00, 0.00, 275.966); // объект 225
	CreateDynamicObject(8263, 3314.88403, -2328.03101, -8.195, 0.00, 0.00, 275.966); // объект 226
	CreateDynamicObject(8263, 3314.88403, -2328.03003, -1.195, 0.00, 0.00, 275.966); // объект 227
	CreateDynamicObject(8263, 3314.88403, -2328.02905, -35.915, 0.00, 0.00, 275.966); // объект 228
	CreateDynamicObject(8263, 3314.88403, -2328.02808, -42.915, 0.00, 0.00, 275.966); // объект 229
	CreateDynamicObject(8263, 3314.88403, -2328.0271, -49.665, 0.00, 0.00, 275.966); // объект 230
	CreateDynamicObject(8263, 3314.88403, -2328.02588, -56.665, 0.00, 0.00, 275.966); // объект 231
	CreateDynamicObject(8263, 3314.88403, -2328.02588, -63.415, 0.00, 0.00, 275.966); // объект 232
	CreateDynamicObject(8263, 3314.88403, -2328.02588, -70.165, 0.00, 0.00, 275.966); // объект 233
	CreateDynamicObject(8263, 3314.88403, -2328.02905, 5.805, 0.00, 0.00, 275.966); // объект 234
	CreateDynamicObject(8263, 3314.88403, -2328.02808, 12.805, 0.00, 0.00, 275.966); // объект 235
	CreateDynamicObject(8263, 3314.88403, -2328.0271, 19.305, 0.00, 0.00, 275.966); // объект 236
	CreateDynamicObject(8263, 3314.88403, -2328.02588, 26.055, 0.00, 0.00, 275.966); // объект 237
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -29.195, 0.00, 0.00, 275.966); // объект 238
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -36.195, 0.00, 0.00, 275.966); // объект 239
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -42.945, 0.00, 0.00, 275.966); // объект 240
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -49.445, 0.00, 0.00, 275.966); // объект 241
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -55.945, 0.00, 0.00, 275.966); // объект 242
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -62.695, 0.00, 0.00, 275.966); // объект 243
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -69.445, 0.00, 0.00, 275.966); // объект 244
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -15.065, 0.00, 0.00, 275.966); // объект 245
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -8.065, 0.00, 0.00, 275.966); // объект 246
	CreateDynamicObject(8263, 3327.26807, -2447.30811, -1.065, 0.00, 0.00, 275.966); // объект 247
	CreateDynamicObject(8263, 3327.26807, -2447.30811, 5.935, 0.00, 0.00, 275.966); // объект 248
	CreateDynamicObject(8263, 3327.26807, -2447.30811, 12.685, 0.00, 0.00, 275.966); // объект 249
	CreateDynamicObject(8263, 3327.26807, -2447.30811, 19.435, 0.00, 0.00, 275.966); // объект 250
	CreateDynamicObject(8263, 3327.26807, -2447.30811, 26.11, 0.00, 0.00, 275.966); // объект 251
	CreateDynamicObject(8263, 2625.3479, -2649.69409, 39.76, 0.00, 0.00, 179.951); // объект 252
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 32.76, 0.00, 0.00, 179.951); // объект 253
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 26.01, 0.00, 0.00, 179.951); // объект 254
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 19.26, 0.00, 0.00, 179.951); // объект 255
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 12.26, 0.00, 0.00, 179.951); // объект 256
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 5.26, 0.00, 0.00, 179.951); // объект 257
	CreateDynamicObject(8263, 2625.3479, -2649.69312, -1.74, 0.00, 0.00, 179.951); // объект 258
	CreateDynamicObject(8263, 2625.3479, -2649.69312, -8.74, 0.00, 0.00, 179.951); // объект 259
	CreateDynamicObject(8263, 2625.3479, -2649.69312, -15.74, 0.00, 0.00, 179.951); // объект 260
	CreateDynamicObject(8263, 2745.18994, -2649.8689, -15.74, 0.00, 0.00, 179.951); // объект 261
	CreateDynamicObject(8263, 2745.18994, -2649.86792, -8.74, 0.00, 0.00, 179.951); // объект 262
	CreateDynamicObject(8263, 2745.18994, -2649.86694, -1.74, 0.00, 0.00, 179.951); // объект 263
	CreateDynamicObject(8263, 2745.18994, -2649.86597, 5.26, 0.00, 0.00, 179.951); // объект 264
	CreateDynamicObject(8263, 2745.18994, -2649.86499, 12.26, 0.00, 0.00, 179.951); // объект 265
	CreateDynamicObject(8263, 2745.18994, -2649.86401, 19.26, 0.00, 0.00, 179.951); // объект 266
	CreateDynamicObject(8263, 2745.21606, -2649.80005, 26.185, 0.00, 0.00, 179.951); // объект 267
	CreateDynamicObject(8263, 2745.21606, -2649.80005, 33.185, 0.00, 0.00, 179.951); // объект 268
	CreateDynamicObject(8263, 2745.21606, -2649.80005, 39.935, 0.00, 0.00, 179.951); // объект 269
	CreateDynamicObject(8263, 3339.80591, -2566.59106, 26.11, 0.00, 0.00, 275.966); // объект 270
	CreateDynamicObject(8263, 3339.80591, -2566.59106, 19.36, 0.00, 0.00, 275.966); // объект 271
	CreateDynamicObject(8263, 3339.80591, -2566.59106, 12.11, 0.00, 0.00, 275.966); // объект 272
	CreateDynamicObject(8263, 3339.80591, -2566.59106, 5.11, 0.00, 0.00, 275.966); // объект 273
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -1.64, 0.00, 0.00, 275.966); // объект 274
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -8.64, 0.00, 0.00, 275.966); // объект 275
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -15.64, 0.00, 0.00, 275.966); // объект 276
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -22.64, 0.00, 0.00, 275.966); // объект 277
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -29.64, 0.00, 0.00, 275.966); // объект 278
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -36.64, 0.00, 0.00, 275.966); // объект 279
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -43.64, 0.00, 0.00, 275.966); // объект 280
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -50.64, 0.00, 0.00, 275.966); // объект 281
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -57.64, 0.00, 0.00, 275.966); // объект 282
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -64.89, 0.00, 0.00, 275.966); // объект 283
	CreateDynamicObject(8263, 3339.80591, -2566.59106, -71.64, 0.00, 0.00, 275.966); // объект 284
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 46.76, 0.00, 0.00, 179.951); // объект 285
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 53.76, 0.00, 0.00, 179.951); // объект 286
	CreateDynamicObject(8263, 2625.3479, -2649.69312, 60.76, 0.00, 0.00, 179.951); // объект 287
	CreateDynamicObject(8263, 2745.21606, -2649.80005, 46.935, 0.00, 0.00, 179.951); // объект 288
	CreateDynamicObject(8263, 2745.21606, -2649.80005, 53.435, 0.00, 0.00, 179.951); // объект 289
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 47.185, 0.00, 0.00, 179.951); // объект 290
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 40.185, 0.00, 0.00, 179.951); // объект 291
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 33.185, 0.00, 0.00, 179.951); // объект 292
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 26.185, 0.00, 0.00, 179.951); // объект 293
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 19.185, 0.00, 0.00, 179.951); // объект 294
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 12.185, 0.00, 0.00, 179.951); // объект 295
	CreateDynamicObject(8263, 2865.09302, -2649.91895, 4.935, 0.00, 0.00, 179.951); // объект 296
	CreateDynamicObject(8263, 2865.09302, -2649.91895, -2.065, 0.00, 0.00, 179.951); // объект 297
	CreateDynamicObject(8263, 2865.09302, -2649.91895, -8.315, 0.00, 0.00, 179.951); // объект 298
	CreateDynamicObject(8263, 2865.09302, -2649.91895, -15.065, 0.00, 0.00, 179.951); // объект 299
	CreateDynamicObject(8263, 2865.09302, -2649.91895, -21.815, 0.00, 0.00, 179.951); // объект 0
	CreateDynamicObject(8263, 2865.09302, -2649.91895, -28.565, 0.00, 0.00, 179.951); // объект 1
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -28.565, 0.00, 0.00, 179.951); // объект 2
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -35.565, 0.00, 0.00, 179.951); // объект 3
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -41.815, 0.00, 0.00, 179.951); // объект 4
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -48.565, 0.00, 0.00, 179.951); // объект 5
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -55.315, 0.00, 0.00, 179.951); // объект 6
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -62.315, 0.00, 0.00, 179.951); // объект 7
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -69.065, 0.00, 0.00, 179.951); // объект 8
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -21.895, 0.00, 0.00, 179.951); // объект 9
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -15.145, 0.00, 0.00, 179.951); // объект 10
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -7.895, 0.00, 0.00, 179.951); // объект 11
	CreateDynamicObject(8263, 2983.43188, -2650.37793, -1.145, 0.00, 0.00, 179.951); // объект 12
	CreateDynamicObject(8263, 2983.43188, -2650.37793, 5.605, 0.00, 0.00, 179.951); // объект 13
	CreateDynamicObject(8263, 2983.43188, -2650.37793, 12.605, 0.00, 0.00, 179.951); // объект 14
	CreateDynamicObject(8263, 2983.43188, -2650.37793, 19.855, 0.00, 0.00, 179.951); // объект 15
	CreateDynamicObject(8263, 2983.43188, -2650.37793, 26.605, 0.00, 0.00, 179.951); // объект 16
	CreateDynamicObject(8263, 2983.43188, -2650.37793, 33.605, 0.00, 0.00, 179.951); // объект 17
	CreateDynamicObject(8263, 3103.26611, -2650.49512, 12.605, 0.00, 0.00, 179.951); // объект 18
	CreateDynamicObject(8263, 3103.26611, -2650.49512, 19.605, 0.00, 0.00, 179.951); // объект 19
	CreateDynamicObject(8263, 3103.26611, -2650.49512, 26.355, 0.00, 0.00, 179.951); // объект 20
	CreateDynamicObject(8263, 3103.26611, -2650.49512, 5.855, 0.00, 0.00, 179.951); // объект 21
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -0.895, 0.00, 0.00, 179.951); // объект 22
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -7.895, 0.00, 0.00, 179.951); // объект 23
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -14.645, 0.00, 0.00, 179.951); // объект 24
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -21.645, 0.00, 0.00, 179.951); // объект 25
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -28.645, 0.00, 0.00, 179.951); // объект 26
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -35.645, 0.00, 0.00, 179.951); // объект 27
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -42.645, 0.00, 0.00, 179.951); // объект 28
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -49.395, 0.00, 0.00, 179.951); // объект 29
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -56.145, 0.00, 0.00, 179.951); // объект 30
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -63.145, 0.00, 0.00, 179.951); // объект 31
	CreateDynamicObject(8263, 3103.26611, -2650.49512, -70.645, 0.00, 0.00, 179.951); // объект 32
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -69.37, 0.00, 0.00, 179.951); // объект 33
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -69.395, 0.00, 0.00, 179.951); // объект 34
	CreateDynamicObject(8263, 3342.40894, -2591.14209, -69.4, 0.00, 0.00, 275.966); // объект 35
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -62.62, 0.00, 0.00, 179.951); // объект 36
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -55.62, 0.00, 0.00, 179.951); // объект 37
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -48.87, 0.00, 0.00, 179.951); // объект 38
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -41.87, 0.00, 0.00, 179.951); // объект 39
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -34.87, 0.00, 0.00, 179.951); // объект 40
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -27.62, 0.00, 0.00, 179.951); // объект 41
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -20.62, 0.00, 0.00, 179.951); // объект 42
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -13.87, 0.00, 0.00, 179.951); // объект 43
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -7.12, 0.00, 0.00, 179.951); // объект 44
	CreateDynamicObject(8263, 3222.94189, -2650.72607, -0.12, 0.00, 0.00, 179.951); // объект 45
	CreateDynamicObject(8263, 3222.94189, -2650.72607, 6.88, 0.00, 0.00, 179.951); // объект 46
	CreateDynamicObject(8263, 3222.94189, -2650.72607, 13.88, 0.00, 0.00, 179.951); // объект 47
	CreateDynamicObject(8263, 3222.94189, -2650.72607, 20.63, 0.00, 0.00, 179.951); // объект 48
	CreateDynamicObject(8263, 3222.94189, -2650.72607, 26.63, 0.00, 0.00, 179.951); // объект 49
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -62.395, 0.00, 0.00, 179.951); // объект 50
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -55.645, 0.00, 0.00, 179.951); // объект 51
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -48.645, 0.00, 0.00, 179.951); // объект 52
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -41.645, 0.00, 0.00, 179.951); // объект 53
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -34.645, 0.00, 0.00, 179.951); // объект 54
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -27.645, 0.00, 0.00, 179.951); // объект 55
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -20.395, 0.00, 0.00, 179.951); // объект 56
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -13.145, 0.00, 0.00, 179.951); // объект 57
	CreateDynamicObject(8263, 3288.35498, -2650.97192, -6.395, 0.00, 0.00, 179.951); // объект 58
	CreateDynamicObject(8263, 3288.35498, -2650.97192, 0.355, 0.00, 0.00, 179.951); // объект 59
	CreateDynamicObject(8263, 3288.35498, -2650.97192, 7.105, 0.00, 0.00, 179.951); // объект 60
	CreateDynamicObject(8263, 3288.35498, -2650.97192, 13.855, 0.00, 0.00, 179.951); // объект 61
	CreateDynamicObject(8263, 3288.35498, -2650.97192, 20.605, 0.00, 0.00, 179.951); // объект 62
	CreateDynamicObject(8263, 3288.35498, -2650.97192, 26.605, 0.00, 0.00, 179.951); // объект 63
	CreateDynamicObject(8263, 3342.40796, -2591.14209, -62.4, 0.00, 0.00, 275.966); // объект 64
	CreateDynamicObject(8263, 3342.40698, -2591.14209, -55.9, 0.00, 0.00, 275.966); // объект 65
	CreateDynamicObject(8263, 3342.40601, -2591.14209, -49.15, 0.00, 0.00, 275.966); // объект 66
	CreateDynamicObject(8263, 3342.40503, -2591.14209, -42.4, 0.00, 0.00, 275.966); // объект 67
	CreateDynamicObject(8263, 3342.40405, -2591.14209, -35.65, 0.00, 0.00, 275.966); // объект 68
	CreateDynamicObject(8263, 3342.40308, -2591.14209, -28.9, 0.00, 0.00, 275.966); // объект 69
	CreateDynamicObject(8263, 3342.4021, -2591.14209, -21.9, 0.00, 0.00, 275.966); // объект 70
	CreateDynamicObject(8263, 3342.40088, -2591.14209, -14.9, 0.00, 0.00, 275.966); // объект 71
	CreateDynamicObject(8263, 3342.40088, -2591.14209, -7.9, 0.00, 0.00, 275.966); // объект 72
	CreateDynamicObject(8263, 3342.40088, -2591.14209, -0.9, 0.00, 0.00, 275.966); // объект 73
	CreateDynamicObject(8263, 3342.40088, -2591.14209, 5.85, 0.00, 0.00, 275.966); // объект 74
	CreateDynamicObject(8263, 3342.40088, -2591.14209, 12.6, 0.00, 0.00, 275.966); // объект 75
	CreateDynamicObject(8263, 3342.40088, -2591.14209, 19.6, 0.00, 0.00, 275.966); // объект 76
	CreateDynamicObject(8263, 3342.40088, -2591.14209, 26.6, 0.00, 0.00, 275.966); // объект 77
	CreateDynamicObject(8263, 1080.39001, -703.39301, 100.735, 0.00, 0.00, 283.997); // объект 78
	CreateDynamicObject(10828, 2815.24097, -874.16803, 25.511, 0.00, 0.00, 5.288); // объект 79
	CreateDynamicObject(10828, 686.56152, -765.88379, 35.636, 0.00, 2, 44.033); // объект 80
	CreateDynamicObject(10828, 1464.74219, -761.19434, 100.928, 0.00, 0.00, 359.786); // объект 81
	CreateDynamicObject(10828, 1705.16797, -690.28418, 56.248, 0.00, 0.00, 0.786); // объект 82
	CreateDynamicObject(10828, 2780.05811, -877.51398, 25.511, 0.00, 0.00, 5.284); // объект 83
	CreateDynamicObject(10828, 2815.00488, -873.81403, 11.261, 0.00, 0.00, 5.284); // объект 84
	CreateDynamicObject(10828, 2849.68896, -870.57599, 11.261, 0.00, 0.00, 5.284); // объект 85
	CreateDynamicObject(10828, 2849.69409, -870.87598, 25.436, 0.00, 0.00, 5.284); // объект 86
	CreateDynamicObject(10828, 2884.21094, -867.341, 11.011, 0.00, 0.00, 5.284); // объект 87
	CreateDynamicObject(10828, 2882.82397, -867.81, 25.461, 0.00, 0.00, 5.284); // объект 88
	CreateDynamicObject(10828, 2901.58911, -865.68597, 11.011, 0.00, 0.00, 5.284); // объект 89
	CreateDynamicObject(10828, 2901.65601, -865.99701, 25.461, 0.00, 0.00, 5.284); // объект 90
	CreateDynamicObject(3097, 2204.08008, -703.84003, 47.685, 0.00, 0.00, 326); // объект 91
	CreateDynamicObject(3097, 2203.17993, -699.14899, 44.935, 0.00, 68, 23.997); // объект 92
	CreateDynamicObject(3097, 2199.09106, -705.14099, 44.185, 0.00, 198, 23.994); // объект 93
	CreateDynamicObject(3097, 2196.56299, -701.97699, 49.085, 0.00, 211.996, 23.989); // объект 94
	CreateDynamicObject(3097, 2205.17896, -698.69098, 50.96, 0.00, 255.992, 333.983); // объект 95
	CreateDynamicObject(3097, 2203.20605, -707.03802, 47.71, 0.00, 120, 357.979); // объект 96
	CreateDynamicObject(3585, 2199.34692, -706.297, 46.201, 25.728, 8.887, 135.361); // объект 97
	CreateDynamicObject(3585, 2195.55005, -698.34998, 47.401, 25.724, 8.882, 181.357); // объект 98
	CreateDynamicObject(3585, 2185.43994, -695.53198, 47.401, 276.184, 256.015, 81.17); // объект 99
	CreateDynamicObject(3098, 2194.48804, -706.29498, 46.703, 0.00, 0.00, 0.00); // объект 100
	CreateDynamicObject(18691, 2198.44092, -707.177, 46.893, 0.00, 0.00, 0.00); // объект 101
	CreateDynamicObject(18691, 2204.16309, -709.02197, 42.143, 0.00, 0.00, 0.00); // объект 102
	CreateDynamicObject(18691, 2201.7771, -701.48499, 42.143, 0.00, 0.00, 0.00); // объект 103
	CreateDynamicObject(18691, 2198.21704, -698.72998, 47.643, 0.00, 0.00, 0.00); // объект 104
	CreateDynamicObject(18691, 2203.2749, -706.51001, 45.143, 0.00, 0.00, 0.00); // объект 105
	CreateDynamicObject(10984, 2194.49609, -704.78003, 45.295, 0.00, 6, 0.00); // объект 106
	CreateDynamicObject(10984, 2195.6521, -698.56201, 44.645, 0.00, 352.249, 220); // объект 107
	CreateDynamicObject(10828, 1159.84998, -762.867, 70.393, 0.00, 0.00, 2.75); // объект 108
	CreateDynamicObject(10828, 1159.84998, -762.86603, 84.943, 0.00, 0.00, 2.747); // объект 109
	CreateDynamicObject(10828, 1194.56494, -761.23999, 84.943, 0.00, 0.00, 2.747); // объект 110
	CreateDynamicObject(10828, 1126.20398, -764.47699, 84.943, 0.00, 0.00, 2.747); // объект 111
	CreateDynamicObject(10828, 548.31403, -900.06403, 80.073, 0.00, 0.00, 44.25); // объект 112
	CreateDynamicObject(10828, 514.30103, -933.23297, 86.573, 0.00, 0.00, 44.247); // объект 113
	CreateDynamicObject(10828, 424.96875, -1015.46777, 103.073, 0.00, 0.00, 40.243); // объект 114
	CreateDynamicObject(10828, 131.82324, -1308.15527, 56.534, 0.00, 0.00, 59.244); // объект 115
	CreateDynamicObject(10828, 36.8584, -1528.63477, 15.287, 0.00, 0.00, 77.745); // объект 116
	CreateDynamicObject(10828, 86.842, -1020.66302, 20.333, 0.00, 0.00, 90); // объект 117
	CreateDynamicObject(8674, 87.183, -1023.00098, 24.393, 0.00, 0.00, 274); // объект 118
	CreateDynamicObject(8674, 86.421, -1012.69, 24.393, 0.00, 0.00, 273.999); // объект 119
	CreateDynamicObject(8674, 86.984, -1020.42401, 27.243, 0.00, 0.00, 273.999); // объект 120
	CreateDynamicObject(8263, 1393.552, -761.47998, 87.555, 0.00, 0.00, 0.00); // объект 121

	if(fexist("Admin/Teams.txt"))
	{
	    fremove("Admin/Teams.txt");
	    new File:file = fopen("Admin/Teams.txt",io_write);
	    fclose(file);
	}
	else
	{
        new File:file = fopen("Admin/Teams.txt",io_write);
	    fclose(file);
	}
	for(new i; i < MAX_PLAYERS;i++)
	{
		GainXPTD[i] = TextDrawCreate(286.000000, 148.000000, "+10 XP");
		TextDrawBackgroundColor(GainXPTD[i], 255);
		TextDrawFont(GainXPTD[i], 1);
		TextDrawLetterSize(GainXPTD[i], 0.610000, 2.600002);
		TextDrawColor(GainXPTD[i], -1);
		TextDrawSetOutline(GainXPTD[i], 1);
		TextDrawSetProportional(GainXPTD[i], 1);

        Stats[i] = TextDrawCreate(552.000000, 341.000000, " ");
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
		
		XPStats[i] = TextDrawCreate(312.503784, 426.999969, "XP:_15052 / 55000");
		TextDrawLetterSize(XPStats[i], 0.279926, 0.870832);
		TextDrawAlignment(XPStats[i], 2);
		TextDrawColor(XPStats[i], -1);
		TextDrawSetShadow(XPStats[i], 0);
		TextDrawSetOutline(XPStats[i], 1);
		TextDrawBackgroundColor(XPStats[i], 51);
		TextDrawFont(XPStats[i], 2);
		TextDrawSetProportional(XPStats[i], 1);
		
		FuelTD[i] = TextDrawCreate(221.000000, 360.000000, "ЂE®€…®: ~r~~h~ll~y~llllll~g~~h~ll");
		TextDrawBackgroundColor(FuelTD[i], -1499158273);
		TextDrawFont(FuelTD[i], 1);
		TextDrawLetterSize(FuelTD[i], 0.430000, 1.600000);
		TextDrawColor(FuelTD[i], 255);
		TextDrawSetOutline(FuelTD[i], 1);
		TextDrawSetProportional(FuelTD[i], 1);

		OilTD[i] = TextDrawCreate(327.000000, 360.000000, "MAC‡O: ~r~ll~y~llllll~g~~h~ll");
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
	
	CPSCleared = TextDrawCreate(460.000000, 97.000000,"KO®¦PO‡’®‘X ¦OЌEK ЊPO†ѓE®O: ~r~~h~0/8");
	TextDrawBackgroundColor(CPSCleared, 255);
	TextDrawFont(CPSCleared, 2);
	TextDrawLetterSize(CPSCleared, 0.220000, 1.100000);
	TextDrawColor(CPSCleared, -1);
	TextDrawSetOutline(CPSCleared, 0);
	TextDrawSetProportional(CPSCleared, 1);
	TextDrawSetShadow(CPSCleared, 1);

	Infection = TextDrawCreate(460.000000, 111.000000, "…®ЃEK‰…•: ~r~~h~0%");
	TextDrawBackgroundColor(Infection, 255);
	TextDrawFont(Infection, 2);
	TextDrawLetterSize(Infection, 0.220000, 1.100000);
	TextDrawColor(Infection, -1);
	TextDrawSetOutline(Infection, 0);
	TextDrawSetProportional(Infection, 1);
	TextDrawSetShadow(Infection, 1);
	
	XPBox = TextDrawCreate(438.193145, 425.000122, "usebox");
	TextDrawLetterSize(XPBox, 0.000000, 1.422402);
	TextDrawTextSize(XPBox, 185.877029, 0.000000);
	TextDrawAlignment(XPBox, 1);
	TextDrawColor(XPBox, 0);
	TextDrawUseBox(XPBox, true);
	TextDrawBoxColor(XPBox, 102);
	TextDrawSetShadow(XPBox, 0);
	TextDrawSetOutline(XPBox, 0);
	TextDrawFont(XPBox, 0);
	
	RoundStats = TextDrawCreate(262.000000, 352.000000, "Большинство убийств: [Yak]Kyo_Masuyo ~n~Большинство смертей: [Yak]Kyo_Masuyo ~n~Больше зараженных: [Yak]Kyo_Masuyo");
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
    if(IsPlayerNPC(playerid))return 1;
	if(PInfo[playerid][Firstspawn] == 0)
	{
	    if(Team[playerid] == ZOMBIE)
		{
		    SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
		    SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
		    SpawnPlayer(playerid);
		    Team[playerid] = ZOMBIE;
		    SpawnPlayer(playerid);
		    SetPlayerColor(playerid,purple);
		    SetPlayerHealth(playerid,100);
		}
		if(Team[playerid] == HUMAN)
		{
		    Team[playerid] = HUMAN;
		    static sid;
			ChooseSkin: sid = random(299);
			sid = random(299);
			for(new i = 0; i < sizeof(ZombieSkins); i++)
				if(sid == ZombieSkins[i]) goto ChooseSkin;
		   	SetSpawnInfo(playerid,0,sid,0,0,0,0,0,0,0,0,0,0);
			SetPlayerSkin(playerid,sid);
		    PInfo[playerid][JustInfected] = 0;
		    PInfo[playerid][Infected] = 0;
			PInfo[playerid][Dead] = 0;
			PInfo[playerid][CanBite] = 1;
			SpawnPlayer(playerid);
			SetPlayerColor(playerid,green);
			SetPlayerHealth(playerid,100);
		}
	    return 0;
	}
 	SetPlayerPos(playerid,1146.1810,-905.9805,87.1797);
	SetPlayerFacingAngle(playerid,197.1240);
	SetPlayerCameraPos(playerid,1146.1233,-908.6250,87.8143);
	SetPlayerCameraLookAt(playerid,1146.1810,-905.9805,87.1797);
	SetPlayerWeather(playerid,9);
	switch(classid)
	{
	    case 0: Team[playerid] = HUMAN,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~Выжиший",3000,3);
	    case 1: Team[playerid] = ZOMBIE,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~p~Зомби",3000,3);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPVarInt(playerid,"K_Times",0);
	if(IsPlayerNPC(playerid))return 1;
	new RandomGS = random(sizeof(gRandomSkin));
	SetPlayerTime(playerid,23,0);
    SetPlayerHealthRank(playerid);
	if(PInfo[playerid][Firstspawn] == 1)
	{
	    PInfo[playerid][Firstspawn] = 0;
	}
	if(Team[playerid] == HUMAN)
	{
	    if(PInfo[playerid][SPerk] == 19) GivePlayerWeapon(playerid,16,3);
	    ResetPlayerInventory(playerid);
     	new RandomGSS = random(sizeof(bRandomSkin));
		SetPlayerSkin(playerid,bRandomSkin[RandomGSS]);
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
	        SetPlayerTime(playerid,23,0);
			SetPlayerWeather(playerid,9);
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
		    AddItem(playerid,"Dizzy Away Pills",17);
			static file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
			SetPlayerTime(playerid,23,0);
			SetPlayerWeather(playerid,9);
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
		    AddItem(playerid,"Dizzy Away Pills",21);
		    AddItem(playerid,"Mission Molotovs Guide",1);
		    static file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
			rand = random(sizeof Platspawns);
			SetPlayerPos(playerid,Platspawns[rand][0],Platspawns[rand][1],Platspawns[rand][2]);
			SetPlayerFacingAngle(playerid,Platspawns[rand][3]);
			SetPlayerTime(playerid,23,0);
			SetPlayerWeather(playerid,9);
	    }
		PutGlassesOn(playerid);
		PutHatOn(playerid);
	}
    if(Team[playerid] == ZOMBIE)
    {
        SetPlayerFacingAngle(playerid,86.4572);
        SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
        SetPlayerWeather(playerid,188);
        SetPlayerTime(playerid,23,0);
		SetPlayerPos(playerid,1402.0941,-1457.2421,1729.6039);
        TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnFreezePlayer", 3000, false, "i", playerid);
		if(PInfo[playerid][JustInfected] == 1)
	    {
	        SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
	        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
	        InfectPlayer(playerid);
	    }
	    static file[80];
		format(file,sizeof file,Userfile,GetPName(playerid));
		INI_Open(file);
		if(INI_ReadInt("ZSkin") != 0) SetPlayerSkin(playerid,INI_ReadInt("ZSkin"));
		INI_Close();
	    SetPlayerColor(playerid,purple);
	    SetPlayerArmour(playerid,0);
	    SetPlayerHealth(playerid,150.0);
    }
	StopAudioStreamForPlayer(playerid);
	PInfo[playerid][Dead] = 0;
	SetPlayerCP(playerid);
    if(IsPlayerNPC(playerid)) //Проверяет: существует ли игрок(NPC).
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //Получает имя игрока (NPC).
        if(!strcmp(npcname, "sgt_soup", true)) //Проверяет если имя MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 0); //Помещает NPC в транспорт, который мы создали выше.
		}
        GetPlayerName(playerid,npcname,sizeof(npcname));
		if(!strcmp(npcname,"sgt_soup",false))
		SetPlayerSkin(playerid, 287);
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
 	if(PInfo[playerid][Logged] == 0) return 0;
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
    SetPVarInt(playerid,"K_Times",GetPVarInt(playerid,"K_Times") + 1);
	if(GetPVarInt(playerid,"K_Times") > 1) return Kick(playerid);
	PInfo[playerid][Dead] = 1;
    PInfo[playerid][DeathsRound]++;
    RemovePlayerAttachedObject(playerid, PInfo[playerid][oslothat]);
    RemovePlayerAttachedObject(playerid, PInfo[playerid][oslotglasses]);
	if(Mission[playerid] != 0)
	{
    	RemovePlayerMapIcon(playerid,1);
    	Mission[playerid] = 0;
    	SendClientMessage(playerid,red,"Ты провалил задание с молотовым.");
 	}
    if(PInfo[playerid][Lighton] == 1)
	{
		RemovePlayerAttachedObject(playerid,1);
		RemovePlayerAttachedObject(playerid,2);
        PInfo[playerid][Lighton] = 0;
        RemoveItem(playerid,"Flashlight",1);
        static string[90];
 		format(string,sizeof string,""cjam"%s уронил Flashlight.",GetPName(playerid));
		SendNearMessage(playerid,white,string,30);
	}
	if(Team[killerid] == HUMAN && Team[playerid] == HUMAN)
	{
	    if(PInfo[playerid][Infected] == 1)
	    {
	        PInfo[killerid][Kills]++;
	        GivePlayerXP(killerid);
        	CheckRankup(killerid);
        	InfectPlayer(playerid);
		}
	    else
	    {
        	PInfo[killerid][Teamkills]++;
        	SendClientMessage(killerid,white,"» "corange"Убийство товарищей "cred"ЗАПРЕЩЕНА!!! "cwhite"«");
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
	    GivePlayerXP(killerid);
	    CheckRankup(killerid);
	    InfectPlayer(playerid);
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
        case 0: format(string,sizeof string,"» "cred"%s вышел из сервера. (Краш)",GetPName(playerid));
        case 1: format(string,sizeof string,"» "cred"%s вышел из сервера. (Вышел из игры)",GetPName(playerid));
        case 2: format(string,sizeof string,"» "cred"%s вышел из сервера. (Кикнут/забанен)",GetPName(playerid));
    }
    PInfo[playerid][KillsRound] = 0;
    PInfo[playerid][InfectsRound] = 0;
    PInfo[playerid][DeathsRound] = 0;
    PInfo[playerid][RunTimerActivated] = 0;
    PInfo[playerid][PlantedBettys] = 0;
    PInfo[playerid][Bettys] = 0;
    PInfo[playerid][BettyActive1] = 0;
    PInfo[playerid][BettyActive2] = 0;
    PInfo[playerid][BettyActive3] = 0;
    PlayersConnected--;
    SendAdminMessage(white,string);
    DestroyObject(PInfo[playerid][FireObject]);
    DestroyObject(PInfo[playerid][BettyObj1]);
    DestroyObject(PInfo[playerid][BettyObj2]);
    DestroyObject(PInfo[playerid][BettyObj3]);
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
 	if(RoundEnded == 0)
 	{
		INI_Open("Admin/Teams.txt");
		INI_WriteInt(GetPName(playerid),Team[playerid]);
		INI_Save();
		INI_Close();
 	}
	return 1;
}

stock XPTextDraws(playerid)
{
    XPtextdraw[playerid][0] = CreatePlayerTextDraw(playerid, 438.193145, 425.000122, "usebox");
	PlayerTextDrawLetterSize(playerid, XPtextdraw[playerid][0], 0.000000, 1.422402);
	PlayerTextDrawTextSize(playerid, XPtextdraw[playerid][0], 185.877029, 0.000000);
	PlayerTextDrawAlignment(playerid, XPtextdraw[playerid][0], 1);
	PlayerTextDrawColor(playerid, XPtextdraw[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, XPtextdraw[playerid][0], true);
	PlayerTextDrawBoxColor(playerid, XPtextdraw[playerid][0], 102);
	PlayerTextDrawSetShadow(playerid, XPtextdraw[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, XPtextdraw[playerid][0], 0);
	PlayerTextDrawFont(playerid, XPtextdraw[playerid][0], 0);

	XPtextdraw[playerid][1] = CreatePlayerTextDraw(playerid, 256.875366, 426.166748, "LEVO");
	PlayerTextDrawLetterSize(playerid, XPtextdraw[playerid][1], 0.000000, 1.174069);
	PlayerTextDrawTextSize(playerid, XPtextdraw[playerid][1], 309.566711, 0.000000);
	PlayerTextDrawAlignment(playerid, XPtextdraw[playerid][1], 1);
	PlayerTextDrawColor(playerid, XPtextdraw[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, XPtextdraw[playerid][1], true);
	PlayerTextDrawBoxColor(playerid, XPtextdraw[playerid][1], 50067455);
	PlayerTextDrawSetShadow(playerid, XPtextdraw[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, XPtextdraw[playerid][1], 0);
	PlayerTextDrawFont(playerid, XPtextdraw[playerid][1], 0);

	XPtextdraw[playerid][2] = CreatePlayerTextDraw(playerid, 369.321350, 426.166717, "PRAVO");
	PlayerTextDrawLetterSize(playerid, XPtextdraw[playerid][2], 0.000000, 1.174069);
	PlayerTextDrawTextSize(playerid, XPtextdraw[playerid][2], 309.567199, 0.000000);
	PlayerTextDrawAlignment(playerid, XPtextdraw[playerid][2], 1);
	PlayerTextDrawColor(playerid, XPtextdraw[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, XPtextdraw[playerid][2], true);
	PlayerTextDrawBoxColor(playerid, XPtextdraw[playerid][2], 50067455);
	PlayerTextDrawSetShadow(playerid, XPtextdraw[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, XPtextdraw[playerid][2], 0);
	PlayerTextDrawFont(playerid, XPtextdraw[playerid][2], 0);

	XPtextdraw[playerid][3] = CreatePlayerTextDraw(playerid, 312.503784, 426.999969, "XP:_15052 / 55000");
	PlayerTextDrawLetterSize(playerid, XPtextdraw[playerid][3], 0.279926, 0.870832);
	PlayerTextDrawAlignment(playerid, XPtextdraw[playerid][3], 2);
	PlayerTextDrawColor(playerid, XPtextdraw[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, XPtextdraw[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, XPtextdraw[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, XPtextdraw[playerid][3], 51);
	PlayerTextDrawFont(playerid, XPtextdraw[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, XPtextdraw[playerid][3], 1);

	XPtextdraw[playerid][4] = CreatePlayerTextDraw(playerid, 312.972412, 413.583404, "www.infinite-gaming.com");
	PlayerTextDrawLetterSize(playerid, XPtextdraw[playerid][4], 0.369414, 1.139165);
	PlayerTextDrawAlignment(playerid, XPtextdraw[playerid][4], 2);
	PlayerTextDrawColor(playerid, XPtextdraw[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, XPtextdraw[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, XPtextdraw[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, XPtextdraw[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, XPtextdraw[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, XPtextdraw[playerid][4], 51);
	PlayerTextDrawFont(playerid, XPtextdraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, XPtextdraw[playerid][4], 1);
	return true;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("pingchecktimer", 5000, false, "i",playerid);
	new ip[2][16];
    GetPlayerIp(playerid,ip[0],16);
    for(new i, m = GetMaxPlayers(), x; i != m; i++)
    {
        if(!IsPlayerConnected(i) || i == playerid) continue;
        GetPlayerIp(i,ip[1],16);
        if(!strcmp(ip[0],ip[1],true)) x++;
        if(x > 2) return Kick(i);
    }
	if(IsPlayerNPC(playerid))return 1;
	SetPlayerMapIcon(playerid,0,766.2109,-1019.4262,24.1094,42,0);
    SetPlayerMapIcon(playerid,1,761.4731,-1027.2365,23.9575,42,0);
    SetPlayerMapIcon(playerid,2,876.3613,-1353.1510,24.0201,42,0);
    SetPlayerMapIcon(playerid,3,867.0457,-1362.8696,24.0201,159,42,0);
    SetPlayerMapIcon(playerid,4,853.2203,-1366.0519,24.0201,116,42,0);
    SetPlayerMapIcon(playerid,5,359.3699,-1754.7238,16.7337,42,0);
    SetPlayerMapIcon(playerid,6,358.6930,-1738.4240,16.7337,42,0);
    SetPlayerMapIcon(playerid,7,368.1934,-1723.5752,16.7337,42,0);
    SetPlayerMapIcon(playerid,8,1095.6567,-1878.3529,16,42,0);
    SetPlayerMapIcon(playerid,9,1083.4091,-1887.8292,16.7337,42,0);
    SetPlayerMapIcon(playerid,10,1407.6771,-1305.9327,15.1742,42,0);
    SetPlayerMapIcon(playerid,11,1412.6321,-1306.4360,15.1742,42,0);
    SetPlayerMapIcon(playerid,12,1862.1310,-972.3978,46.4318,42,0);
    SetPlayerMapIcon(playerid,13,1857.9124,-966.5098,51.4574,42,0);
    SetPlayerMapIcon(playerid,14,1878.1996,-967.1074,51.4574,42,0);
    SetPlayerMapIcon(playerid,15,1883.8905,-1819.0187,12.0824,42,0);
    SetPlayerMapIcon(playerid,16,1897.5035,-1837.9573,12.0824,42,0);
    SetPlayerMapIcon(playerid,17,1906.9563,-1823.9977,12.0824,42,0);
    SetPlayerMapIcon(playerid,18,2590.3718,-1461.3740,25.9778,42,0);
    SetPlayerMapIcon(playerid,19,2611.7537,-1462.1549,25.9778,42,0);
    SetPlayerMapIcon(playerid,20,2623.9580,-1474.8374,25.9778,42,0);
    SetPlayerMapIcon(playerid,21,1996.5189,-2019.8168,24.6221,42,0);
    SetPlayerMapIcon(playerid,22,2008.5421,-2025.6726,19.8210,42,0);
    SetPlayerMapIcon(playerid,23,1991.2966,-2034.0615,19.8210,42,0);
    SetWorldTime(23);
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
     		ShowPlayerDialog(playerid,Logindialog,3,"Login",""cwhite"Добро пожаловать! \nВведите пароль чтобы "cligreen"загрузить "cwhite"вашу статистику \n","Войти","Отмена");

		}
		INI_Close();
	}
	else
	{
		ShowPlayerDialog(playerid,Registerdialog,3,"Register",""cwhite"Добро пожаловать! \nЧтобы играть на сервере, нужно зарегистрироваться! \nПридумайте пароль и впышите его нижей \n","Регистрация","Отмена");
        SendClientMessage(playerid,green,"Добро пожаловать на Los Santos Zombie Apocalypse!");
		SendClientMessage(playerid,red,"После регистрации обязательно прочитайте /help!!!");
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
    PInfo[playerid][BettyMission] = 0;
    PInfo[playerid][CanDig] = 1;
    PInfo[playerid][GodDig] = 0;
    PInfo[playerid][Vomitmsg] = 1;
    PInfo[playerid][Lighton] = 0;
    PInfo[playerid][NoPM] = 0;
    PInfo[playerid][LastID] = -1;
    PInfo[playerid][Allowedtovomit] = VOMITTIME;
    PInfo[playerid][oslotglasses] = -1;
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
	INI_Open("Admin/Teams.txt");
    if(INI_ReadInt(GetPName(playerid)) != 0)
    {
        PInfo[playerid][Firstspawn] = 0;
		Team[playerid] = INI_ReadInt(GetPName(playerid));
		printf("%i",Team[playerid]);
    }
    INI_Close();
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
            SendFMessage(i,white,"*"cjam"%s заполучил поддержку ввиде ХП и патронов.",GetPName(playerid));
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
			SendFMessage(playerid,white,"» "cblue"Ты заполучил 3 огненные пули. "cgrey"(%i Адские Патроны)",PInfo[playerid][Flamerounds]);
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
	            SendFMessage(i,white,"*"cjam"%s получил новый прочный бронежелет.",GetPName(playerid));
	        }
     	}
     	if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s получил новый бронежелет.",GetPName(playerid));
	        }
     	}
  	}
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    SendClientMessage(playerid,red,"ПРЕДУПРЕЖДЕНИЕ: Ты вышел из контрольной точки!!!");
	return 1;
}

CMD:credits(playerid,params[])
{
    SendClientMessage(playerid,red,"Основатели: Zackster, Flexx");
	SendClientMessage(playerid,gold,"Скриптер: Flexx");
    SendClientMessage(playerid,gold,"Маппинг: Zackster");
	SendClientMessage(playerid,green,"Особое спасибо: Cyber_Punk");
	return 1;
}

CMD:me(playerid,params[])
{
	static msg[128],string[128];
	if(sscanf(params,"s[128]",msg)) return SendClientMessage(playerid,orange,"Введите: "cblue"/me <действие>");
	format(string,sizeof(string),"» %s(ID:%d) %s",GetPName(playerid),playerid,msg);
	SendClientMessageToAll(0x9BFF00FF,string);
	return 1;
}

CMD:tpm(playerid,params[])
{
	new text[80],string[128];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"Введите: "cblue"/tpm <собщение команде >");
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
	    SendClientMessage(playerid,white,"» "corange"Сейчас ты будешь получать личные сообщение!");
 	}
 	else
 	{
 	    PInfo[playerid][NoPM] = 1;
	    SendClientMessage(playerid,white,"» "corange"Ты заблокировал личные сообщения!");
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
	if(sscanf(params,"us[80]",id,text)) return SendClientMessage(playerid,orange,"Введите: "cblue"/pm <ID> <сообщение>");
	if(PInfo[id][NoPM] == 1) return SendClientMessage(playerid,white,"» "cred"Этот игрок заблокировал личные сообщения.");
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
	SendFMessage(playerid,green,"____ Администраторы в сети: %i ____",on);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] == 0) continue;
	    if(PInfo[i][Level] == 1) lvl = "Trial";
	    else if(PInfo[i][Level] == 2) lvl = "Senior";
	    else if(PInfo[i][Level] == 3) lvl = "General";
	    else if(PInfo[i][Level] == 4) lvl = "Lead";
	    else if(PInfo[i][Level] == 5) lvl = "Head";
		if(IsPlayerAdmin(i)) lvl = "Owner";
		SendFMessage(playerid,green,"- %s(%i) %s admin",GetPName(i),i,lvl);
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
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Тебе недоступна эта команда("cgold"GOLD"cred"/"cplat"PLATINUM)!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setzskin <ID скина>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"Cкин должен находится между ID 1-299");
	new valid = 0;
	for(new i = 0; i < sizeof(ZombieSkins); i++)
			if(skin == ZombieSkins[i]) valid = 1;
	if(valid == 0) return SendClientMessage(playerid,red,"Этот скин недоступен для зомби!");
	if(Team[playerid] == ZOMBIE) SetPlayerSkin(playerid,skin);
	SendClientMessage(playerid,orange,"Изменение скина прошла успешно!");
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
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Тебе недоступна эта команда("cgold"GOLD"cred"/"cplat"PLATINUM)!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsskin <ID скина>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"Cкин должен находится между ID 1-299");
	SendClientMessage(playerid,orange,"Изменение скина прошла успешно!.");
	if(Team[playerid] == HUMAN)
	{
		SetPlayerSkin(playerid,skin);
		PutHatOn(playerid);
		PutGlassesOn(playerid);
 	}
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
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Тебе недоступна эта команда("cgold"GOLD"cred"/"cplat"PLATINUM)!");
	new perk,id;
	if(sscanf(params,"ii",id,perk)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsperk <Команда> <Нумерация способности> "cgreen"1 = Survivor "cgrey"| "cjam"2 = Zombie");
	if(id == 1) PInfo[playerid][SPerk] = perk-1;
	else if(id == 2) PInfo[playerid][ZPerk] = perk-1;
	SendClientMessage(playerid,orange,"Вы успешно поменяли способность.");
	return 1;
}


CMD:l(playerid,params[])
{
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"Использование: "cblue"/l <текст>");
	static string[134];
 	format(string,sizeof string,"%s: %s",GetPName(playerid),text);
	SendNearMessage(playerid,white,string,30);
	return 1;
}

CMD:heal(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Ошибка: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"Использование: "cblue"/heal <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
    static string[100];
	format(string,sizeof string,"|| Администратор %s(%i) вылечил %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,100);
	return 1;
}

CMD:sethealth(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,health;
	if(sscanf(params,"ui",id,health)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/sethealth <id> <health>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
    static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has setted %s(%i) health to %i ||",GetPName(playerid),playerid,GetPName(id),id,health);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,health);
	return 1;
}

CMD:nuke(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/nuke <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	CreateExplosion(x,y,z,7,1000);
	static string[100];
	format(string,sizeof string,"|| Administrator %s(%i) has nuked %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:rape(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/rape <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
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
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/bslap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
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
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/slap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
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
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
    static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/saveuser <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
	static string[90];
	format(string,sizeof string,"|| Administrator %s(%i) has saved %s(%i) stats ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SaveStats(id);
	return 1;
}

CMD:goto(playerid,params[])
{
    if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/goto <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
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
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/kick <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
	static string[100];
	format(string,sizeof string,"|| Администратор %s(%i) кикнул игрока %s [Причина: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	Kick(id);
	SendAdminMessage(red,string);
	SaveIn("Kicklog",string,1);
	return 1;
}

CMD:ban(playerid,params[])
{
    if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ban <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!");
    SendFMessageToAll(red,"|| Administrator %s(%i) has banned %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	static string[500],y,mm,d;
	getdate(y,mm,d);
	
	format(string,sizeof string,"Administrator %s has banned %s. Reason: %s",GetPName(playerid),GetPName(id),reason);
	SaveIn("Banlog",string,1);
	
	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: %s. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.extreme-stunting.com if you wish.",GetPName(playerid),GetPName(id),GetIP(id),reason,d,mm,y);
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
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/get <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Игрока нет в сети!!");
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
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
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
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,team;
	if(sscanf(params,"ui",id,team)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setteam <id> <1 = Human | 2 = Zombie>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
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
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setlevel <id> <level>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
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
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,warn[64],string[400],string2[128];
	if(sscanf(params,"us[64]",id,warn)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/warn <id> <warn>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
	format(string,sizeof string,"» Administrator %s(%i) has warned %s(%i) [Reason: %s]",GetPName(playerid),playerid,GetPName(id),id,warn);
	SendAdminMessage(red,string);
	format(string,sizeof string,Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Warns",INI_ReadInt("Warns")+1);
	format(string,sizeof string,"Warn%i",INI_ReadInt("Warns"));
	SendFMessage(id,red,"» You have %i warnings.",INI_ReadInt("Warns"));
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
		format(string,sizeof(string),""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: 3 Warnings. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.extreme-stunting.com if you wish.",GetPName(playerid),GetPName(id),GetIP(id),d,mm,y);
		ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");
		BanEx(id,string);
		INI_Save();
	}
	INI_Close();
	return 1;
}

CMD:setprem(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,prem;
	if(sscanf(params,"ui",id,prem)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setprem <id> <premium> "cgold"1 = Gold "cblue"| "cplat"2 = Platinium");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
	if(prem > 2 && prem < 0) return SendClientMessage(playerid,red,"Maximum admin level is 5!");
	ResetPlayerInventory(id);
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
	    AddItem(id,"Dizzy Away Pills",17);
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
	    AddItem(id,"Dizzy Away Pills",21);
	    AddItem(id,"Mission Molotovs Guide",1);
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
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setrank <id> <rank>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) rank to %i",GetPName(playerid),playerid,GetPName(id),id,level);
	PInfo[id][Rank] = level;
	ResetPlayerWeapons(id);
	CheckRankup(id,1);
	return 1;
}

CMD:setxp(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setxp <id> <xp>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) XP to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][XP] = xp;
	CheckRankup(playerid);
	return 1;
}

CMD:setkills(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setkills <id> <kills>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) kills to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][Kills] = xp;
	return 1;
}

CMD:setdeaths(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setdeaths <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
	SendFMessageToAll(red,"» Administrator %s(%i) has setted %s(%i) deaths to %i",GetPName(playerid),playerid,GetPName(id),id,xp);
	PInfo[id][Deaths] = xp;
	return 1;
}

CMD:setinfects(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"Вам недоступна эта команда!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setinfects <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Игрока нет в сети!");
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
			    InfectPlayer(playerid);
			    GivePlayerXP(issuerid);
			    CheckRankup(issuerid);
			}
	    }
	}
    return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(newstate == PLAYER_STATE_PASSENGER)
    {
        if(!g_EnterAnim{playerid})
        {
            SetPlayerPos(playerid, g_Pos[playerid][0], g_Pos[playerid][1], g_Pos[playerid][2]);
        }
    }
    else if(newstate == PLAYER_STATE_ONFOOT)
    {
        g_EnterAnim{playerid} = false;
    }
    else if(newstate == PLAYER_STATE_ONFOOT)
    {
        g_EnterAnim{playerid} = false;
    }
	if(newstate == PLAYER_STATE_DRIVER) SetPVarInt(playerid,"VehID",GetPlayerVehicleID(playerid));
	{
		if(oldstate == PLAYER_STATE_DRIVER)
        {
            if(BanCar[GetPVarInt(playerid,"VehID")]) KillTimer(TimeUpdate[playerid]);
            TimeUpdate[playerid] = SetTimerEx("UpdateVehiclePos", 10000, false, "ii", GetPVarInt(playerid,"VehID"), 1);
            BanCar[GetPVarInt(playerid,"VehID")] = true;
        }
    }
	if((newstate == 2 && oldstate == 3) || (newstate == 3 && oldstate == 2)) return Kick(playerid);
	if(newstate == 2) SetPVarInt(playerid,"AC_MCS",GetTickCount());
    else if(oldstate == 2) if((GetTickCount() - GetPVarInt(playerid,"AC_MCS")) <= 250) return Kick(playerid);
	if (newstate == PLAYER_STATE_PASSENGER)
    {
    	SetPlayerArmedWeapon (playerid, 1);
    }
	if (newstate == PLAYER_STATE_DRIVER)
    {
    	SetPlayerArmedWeapon (playerid, 1);
    }
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
		if(!IsVehicleStarted(GetPlayerVehicleID(playerid))) SendFMessage(playerid,white,"* "corange"%s не заведена. Нажмите "cwhite"~k~~VEHICLE_FIREWEAPON~"corange" чтобы завести ее. "cwhite"*",GetVehicleName(GetPlayerVehicleID(playerid)));
	}
    if(IsPlayerNPC(playerid))return 1;
    if(oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_ONFOOT && Team[playerid] == ZOMBIE)
    {
        static string[88];
        {
            for(new i; i < MAX_PLAYERS;i++)
			{
				if(PInfo[i][Premium] == 1)
					format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else if(PInfo[i][Premium] == 2)
		  			format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else
		  			format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				Update3DTextLabelText(PInfo[i][Ranklabel],purple,string);
				SetPlayerColor(playerid,purple);
				Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
				ShowPlayerNameTagForPlayer(i,playerid,1);
				PInfo[playerid][CanBite] = 1;
			}
		}
	}
    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT && Team[playerid] == ZOMBIE)
    {
        static string[88];
        {
            for(new i; i < MAX_PLAYERS;i++)
			{
				if(PInfo[i][Premium] == 1)
					format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else if(PInfo[i][Premium] == 2)
		  			format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else
		  			format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				Update3DTextLabelText(PInfo[i][Ranklabel],purple,string);
				SetPlayerColor(playerid,purple);
				Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
				ShowPlayerNameTagForPlayer(i,playerid,1);
    			PInfo[playerid][CanBite] = 1;
			}
		}
	}
    return 1;
}

public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	if(playerid,ispassenger)
    {
        GetPlayerPos(playerid, g_Pos[playerid][0], g_Pos[playerid][1], g_Pos[playerid][2]);
    }

	if(IsPlatVehicle(vehicleid))
	{
	    if(PInfo[playerid][Premium] != 2)
	    {
	        new Float:x,Float:y,Float:z;
	        GetPlayerPos(playerid,x,y,z);
	        SetPlayerPos(playerid,x,y,z);
	        RemovePlayerFromVehicle(playerid);
	        SendClientMessage(playerid,white,"» "cred"Только игроки с "cplat"Platinum "cred"могут сесть в этот транспорт!");
	    }
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(HOLDING(KEY_YES) || PRESSED(KEY_YES))
	{
		if(Team[playerid] == HUMAN)
		{
			ShowPlayerHumanPerks(playerid);
		}
		if(Team[playerid] == ZOMBIE)
		{
			ShowPlayerZombiePerks(playerid);
		}
	}
	if((newkeys & KEY_FIRE) && (oldkeys & KEY_WALK) || (newkeys & KEY_FIRE) && (oldkeys & KEY_WALK))
	{//2902
 		if(Team[playerid] == ZOMBIE) return 0;
	    if(IsPlayerInAnyVehicle(playerid)) return 0;
	    if(PInfo[playerid][Bettys] == 0) return 0;
	    new Float:x,Float:y,Float:z;
	    PInfo[playerid][Bettys]--;
	    PInfo[playerid][PlantedBettys]++;
	    GetPlayerPos(playerid,x,y,z);
	    switch(PInfo[playerid][PlantedBettys])
	    {
	        case 1: PInfo[playerid][BettyObj1] = CreateObject(2902,x,y,z-0.7,0,90,0,200),PInfo[playerid][BettyActive1] = 0,SetTimerEx("ActivateBetty",1500,false,"ii",playerid,1);
	        case 2: PInfo[playerid][BettyObj2] = CreateObject(2902,x,y,z-0.7,0,90,0,200),PInfo[playerid][BettyActive2] = 0,SetTimerEx("ActivateBetty",1500,false,"ii",playerid,2);
	        case 3: PInfo[playerid][BettyObj3] = CreateObject(2902,x,y,z-0.7,0,90,0,200),PInfo[playerid][BettyActive3] = 0,SetTimerEx("ActivateBetty",1500,false,"ii",playerid,3);
	    }
	    static string[90];
 		format(string,sizeof string,""cjam"%s has planted a bouncing betty.",GetPName(playerid));
		SendNearMessage(playerid,white,string,30);
		format(string,sizeof string,"~w~You now have ~r~~h~%i ~w~bouncing ~n~~w~Betty's left.",PInfo[playerid][Bettys]);
		GameTextForPlayer(playerid,string,3000,3);
	}
    if(oldkeys & KEY_FIRE)
    {
    	if(Team[playerid] == ZOMBIE)
		{
            SendClientMessage(playerid,white,"* "cred"Нажмите ПКМ чтобы укусить/крикнуть!");
		}
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
			if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"Транспорт не требует починки!");
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
			if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"Транспорт не требует починки!");
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
				            SendClientMessage(playerid,white,"* "cblue"Ты сделал 3 молотова. Используй их с умом!");
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
				            SendClientMessage(playerid,white,"* "cblue"Ты сделал 3 молотова. Используй их с умом!");
				            GivePlayerWeapon(playerid,18,3);
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
				        }
					}
				}
			}
			if(Mission[playerid] == 2)
			{
				if(MissionPlace[playerid][1] == 1) //From 1 to 3, to know if its string, ethanol or cans.
				{
				    if(MissionPlace[playerid][0] == 1)
				    {
				        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some fuse for your betty's."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some fuse for your betty's."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],62,0,MAPICON_GLOBAL);
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
				            	case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some fuse for your betty's."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some fuse for your betty's."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],62,0,MAPICON_GLOBAL);
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
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some cans for your betty's."), MissionPlace[playerid][0] = 5, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get cans for your betty's."), MissionPlace[playerid][0] = 6, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],62,0,MAPICON_GLOBAL);
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
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some cans for your betty's."), MissionPlace[playerid][0] = 5, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],62,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get cans for your betty's."), MissionPlace[playerid][0] = 6, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],62,0,MAPICON_GLOBAL);
							}
							ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				        }
					}
				}
				if(MissionPlace[playerid][1] == 3)
				{
				    if(MissionPlace[playerid][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 bouncing betty's. Use them wisely!");
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
    						SendClientMessage(playerid,white,"* "cblue"Press WALK + LMB to place a bouncing betty");
    						PInfo[playerid][Bettys] = 3;
				        }
					}
					else if(MissionPlace[playerid][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 bouncing betty's. Use them wisely!");
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
    						SendClientMessage(playerid,white,"* "cblue"Press WALK + LMB to place a bouncing betty");
    						PInfo[playerid][Bettys] = 3;
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 1:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел Large Medical Kits.",GetPName(playerid),playerid);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 3:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел Medium Medical Kits.",GetPName(playerid),playerid);
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
								    SendClientMessage(playerid,white,"* "cred"");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 5:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел Medium Medical Kits.",GetPName(playerid),playerid);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 7:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел таблетки от головокружения.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							AddItem(playerid,"Dizzy Away Pills",1);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 9:
					    {
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел батарейки и Flashlight.",GetPName(playerid),playerid);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 11:
					    {
					        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) нашел путеводитель по созданию молотова.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							PInfo[playerid][MolotovMission] = 1;
							AddItem(playerid,"Mission Molotovs Guide",1);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 13:
					    {
							static rand2;
							rand2 = random(2);
							if(rand2 == 0) return SendClientMessage(playerid,white,"* "cred"Ты нашел... сломанное дилдо...");
	                        static string[100];
							GivePlayerWeapon(playerid,10,1);
							format(string,sizeof string,""cjam"%s(%i) нашел розовое дилдо.",GetPName(playerid),playerid);
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
								    SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
								}
							}
					        else
								SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
					    }
					    case 15:
					    {
					        if(PInfo[playerid][BettyMission] == 1) return SendClientMessage(playerid,white,"* "cred"Ты ничего не нашел...");
		                    static string[100];
						    format(string,sizeof string,""cjam"%s(%i) has found a boucing betty guide.",GetPName(playerid),playerid);
							SendNearMessage(playerid,white,string,20);
							PInfo[playerid][BettyMission] = 1;
							AddItem(playerid,"Bouncing Bettys Guide",1);
					    }
					}
				}
			}
		}
		if(Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][ZPerk] == 2)
		    {
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"Ты устал копать!");
          		new id = -1;
		        id = GetClosestPlayer(playerid,2000);
				if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"Рядом находится зомби!");
				if(id == -1) return SendClientMessage(playerid,red,"Похоже что выживших тут нет...");
				PInfo[playerid][CanDig] = 0;
				PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
		    }
		    if(PInfo[playerid][ZPerk] == 14)
		    {
		        if(PInfo[playerid][GodDig] == 1) return SendClientMessage(playerid,red,"Ты устал копать!");
		        new id = -1,count = 0;
		        goto func;
		        func:
		        {
					new rand = random(PlayersConnected);
					if(Team[rand] == ZOMBIE)
					{
					    if(!IsPlayerConnected(rand)) goto func;
						if(count >= 1 || RoundEnded == 1 || PlayersConnected == 0) return SendClientMessage(playerid,white,"* "cred"Выживших больше нет!");
						else
						{
						    count++;
							goto func;
						}
					}
					else id = rand;
		        }
				if(id == -1) return SendClientMessage(playerid,red,"Похоже что сервер пуст");
				PInfo[playerid][GodDig] = 1;
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
				static string[120];
			 	format(string,sizeof string,"%s(%i) использовал божий подкоп. Следите за ним. || 1 БОЖИЙ ПОДКОП ЗА ИГРУ!",GetPName(playerid),playerid);
				SendAdminMessage(red,string);
		    }
		    if(PInfo[playerid][ZPerk] == 7)
		    {
		        if((GetTickCount() - PInfo[playerid][Allowedtovomit]) < VOMITTIME) return SendClientMessage(playerid,red,"У тебя пусто в желудке!");
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
			    if(PInfo[playerid][CanStomp] == 0) return SendClientMessage(playerid,red,"У тебя нет сил чтобы вызывать подземные толчки.");
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
						SetTimerEx("RemoveStomp",3500,false,"i",i);
						static string[90];
				 		format(string,sizeof string,""cjam"%s упал на землю из-за подземного толчка.",GetPName(i));
						SendNearMessage(playerid,white,string,30);
						ApplyAnimation(i,"PED","KO_skid_back",1.25,0,0,0,0,1225,1);
					}
				}
			}
			if(PInfo[playerid][ZPerk] == 15)
			{
			    if(PInfo[playerid][CanPop] == 0) return SendClientMessage(playerid,red,"У тебя мало сил чтобы лопать шины.");
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
				if(id == -1) return SendClientMessage(playerid,white,"** "cred"Ты слишком далеко от транспорта!");
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
		    format(string,sizeof string,""cjam"%s(%i) приманил зомби тухлым мясом",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
			GetPlayerPos(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
			PInfo[playerid][ZObject] = CreateObject(2908,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]-1,0,0,0,200);
			SetTimerEx("StopBait",40000,false,"i",playerid);
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
	        if(PInfo[playerid][Swimming] == 1)
	        {
	            new Float:health;
	            GetPlayerHealth(playerid,health);
				SetPlayerHealth(playerid,health-4);
				SendClientMessage(playerid,orange,"УХОДИ ИЗ ВОДЫ, ОНА ИНФИЦИРОВАННА!!!");
				if(health <= 5)
				{
				    SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
			        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
			        InfectPlayer(playerid);
				}
			}
	    }
	}
	if(RELEASED(KEY_SPRINT))
	{
	    if(Team[playerid] == ZOMBIE)
        if(!IsPlayerInAnyVehicle(playerid))
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

	if(HOLDING(KEY_NO) || PRESSED(KEY_NO))
    {
        if(Team[playerid] == ZOMBIE) return 0;
        ShowInventory(playerid);
    }
	if(PRESSED(KEY_FIRE))
	{
	    if(PInfo[playerid][StartCar] == 1) return 0;
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	    if(IsVehicleStarted(GetPlayerVehicleID(playerid))) return 0;
		if(Fuel[GetPlayerVehicleID(playerid)] <= 0) return SendClientMessage(playerid,white,"* "cred"В машине кончился бензин!");
		if(Oil[GetPlayerVehicleID(playerid)] <= 0) return SendClientMessage(playerid,white,"* "cred"В машине закончилось масло!");
		static Float:health;
		GetVehicleHealth(GetPlayerVehicleID(playerid),health);
		if(health <= 350) return SendClientMessage(playerid,white,"* "cred"Двигатель слишком поврежден чтобы завести машину!");
		SetTimerEx("Startvehicle",2300,false,"i",playerid);
		static string[64];
		format(string,sizeof string,""cjam"%s(%i) попытется завести транспорт...",GetPName(playerid),playerid);
		SendNearMessage(playerid,white,string,20);
		PInfo[playerid][StartCar] = 1;
	}
	if(HOLDING(KEY_CROUCH) && HOLDING(KEY_SPRINT) || PRESSED(KEY_CROUCH) && PRESSED(KEY_SPRINT) || HOLDING(KEY_SPRINT) && HOLDING(KEY_CROUCH) || PRESSED(KEY_SPRINT) && PRESSED(KEY_CROUCH))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return 0;
		if(PInfo[playerid][SPerk] == 6 && Team[playerid] == HUMAN)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"У тебя нет сил чтобы вызвать большое кол-во энергии.");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			PInfo[playerid][CanBurst] = 0;
			PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[64];
			format(string,sizeof string,""cjam"%s(%i) улетел далеко с помощью своих мощных ботинков.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,20);
		}
		else if(PInfo[playerid][ZPerk] == 9 && Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"У тебя нет сил чтобы вызвать большое кол-во энергии.");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			PInfo[playerid][CanBurst] = 0;
			PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[64];
			format(string,sizeof string,""cjam"%s(%i) улетел далеко с помощью своих мощных ботинков.",GetPName(playerid),playerid);
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
						MakeProperDamage(i);
					else
		  				SetPlayerHealth(i,Health-5);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
				 	if(Health <= 6)
				 	{
				 	    InfectPlayer(i);
					    GivePlayerXP(playerid);
					    CheckRankup(playerid);
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,1,1,1,1,1000,0);
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
								ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
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
		  			if(Health <= 10.0)
      					MakeProperDamage(i);
					else
		  				SetPlayerHealth(i,Health-10.0);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
				 	if(Health <= 11.0)
				 	{
				 	    InfectPlayer(i);
					    GivePlayerXP(playerid);
					    CheckRankup(playerid);
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
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
           		SetTimerEx("CantBite",390,0,"i",playerid);
           		PInfo[playerid][CanBite] = 0;
				PInfo[playerid][Bites]++;
				PInfo[i][Lastbite] = playerid;
				if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
				ApplyAnimation(playerid,"WAYFARER","WF_FWD",3,0,1,1,0,340,1);
				ApplyAnimation(i,"PED","DAM_armL_frmFT",1,0,1,1,0,750,1);
				if(Health <= 6.0)
				{
				    InfectPlayer(i);
				    GivePlayerXP(playerid);
	                CheckRankup(playerid);
				}
				if(PInfo[playerid][ZPerk] == 10)
				{
					new rand = random(3);
					if(rand == 1)
						ApplyAnimation(i,"BEACH","SitnWait_loop_W",2,0,0,0,0,600,1);
				}
      		}
		}
	}
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1100)
    {
		if(response)
		{
			if(listitem == 0)
	     	{
	            SetPlayerPos(playerid,1478.6937,-1440.1582,1730.1855);
	       	}
	        if(listitem == 1)
	       	{
	        	SetPlayerPos(playerid,2621.4460,-1464.2042,18.7799);
	       	}
	       	if(listitem == 2)
	       	{
	        	SetPlayerPos(playerid,1903.7438,-1833.6774,3.9912);
	       	}
	       	if(listitem == 3)
	       	{
	        	SetPlayerPos(playerid,861.9545,-1367.0168,13.5469);
	       	}
	       	if(listitem == 4)
	       	{
	        	SetPlayerPos(playerid,1859.8473,-971.8915,43.8747);
	       	}
	       	if(listitem == 5)
	       	{
	        	SetPlayerPos(playerid,765.9880,-1017.8659,24.1094);
	       	}
	       	if(listitem == 6)
	       	{
	        	SetPlayerPos(playerid,1413.0844,-1318.6985,9.3759);
	       	}
	       	if(listitem == 7)
	       	{
	        	SetPlayerPos(playerid,1993.9326,-2016.9852,13.5469);
	       	}
	       	if(listitem == 8)
	       	{
	        	SetPlayerPos(playerid,356.8175,-1744.4707,5.6835);
	       	}
	       	if(listitem == 9)
	       	{
	        	SetPlayerPos(playerid,1096.5189,-1876.7705,13.5469);
	       	}
		}
		else
		{
			return 1;
		}
	}
       	
	if(dialogid == 1002)
	{
		if(response) //Условие: если мы нажали первую кнопку
		{
            ShowPlayerDialog(playerid,1000,DSL,"Правила и помощь","Суть режима\nВыживший\nЗомби\nПравила", "Выбор", "Отмена");
		}
		else //Условие: если мы нажали вторую кнопку
		{
			return 1;
		}
 	}

    if(dialogid == 1003)
	{
		if(response) //Условие: если мы нажали первую кнопку
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Правила и помощь","Суть режима\nВыживший\nЗомби\nПравила", "Выбор", "Отмена");
		}
		else //Условие: если мы нажали вторую кнопку
		{
			return 1;
		}
 	}

	if(dialogid == 1003)
	{
		if(response) //Условие: если мы нажали первую кнопку
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Правила и помощь","Суть режима\nВыживший\nЗомби\nПравила", "Выбор", "Отмена");
		}
		else //Условие: если мы нажали вторую кнопку
		{
			return 1;
		}
 	}

	if(dialogid == 1000)
	{
		if(listitem == 0) //Если был выбран 1 пункт списка
		{
        	ShowPlayerDialog(playerid,1002,DSM,"Суть Режима", ""cwhite"Данный сервер является TDM сервером, здесь присутствуют 2 команды: Люди и зомби\nДля каждого класса есть особые способности и задачи.","Назад","Закрыть");
			return 1;
		}
		if(listitem == 1) //Если был выбран 2 пункт списка
		{
        	ShowPlayerDialog(playerid,1002,DSM,"Выживший", ""cwhite"Главаная задача выживших - пройти все 8 контрольных точек\nПри прохождении их всех выжившие выигрывают игру\nПри убийстве и прохождении контрольных точек дается по 10 XP\nТак же у вас есть инвентарь в котором уже лежат вещи, они помогут вам выжить в этом аду\nЕсли же ресурсы у вас закончатся, вы можете спокойно их восполнить в домах(например в доме CJ'я на кухне можно поискать вещи (нажмите "cred"C","Назад","Закрыть");
			return 1;
		}
		if(listitem == 2) //Если был выбран 3 пункт списка
		{
        	ShowPlayerDialog(playerid,1003,DSM,"Зомби", ""cwhite"Главная задача зомби - заразить всех выживших, для это используйте укус (нажмите рядом с выжившим "cred"ПКМ"cwhite"), а так же не дать им пойти все контрольные точки\nУ зомби присутствует быстрый бег и особые способности при повышении ранга(нажмите "cred"Y"cwhite"для просмотра)\nПри заражении вы получите +15XP","Назад","Закрыть");
			return 1;
		}
		if(listitem == 3) //Если был выбран 4 пункт списка
		{
        	ShowPlayerDialog(playerid,1004,DSM,"Правила", ""cred"1-Запрещено использовать баги игры, читерских программ и модификаций\n2-Запрещено убивать своих тиммейтов просто так\n3-Запрещено использовать BHop для увеличения скорости передвижения (т.к. это будет не честно по отношению к зомби\n4-При обнаружении бага в моде сообщайте администрации(при злоупотреблении вы можете получить варн!!!)\nУважайте администрацию и игроков, чтобы не получить проблем :)","Назад","Закрыть");
			return 1;
		}
	}

	InventoryOnDialogResponse(playerid, dialogid, response, inputtext);
    if(dialogid == Nozombieperkdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 0;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Hardbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 1;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Diggerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 2;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Refreshingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 3;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Jumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 4;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Deadsensedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 5;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Hardpunchdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 6;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Vomiterdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 7;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Screamerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 8;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == ZBurstrundialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 9;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Stingerbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 10;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Bigjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 11;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Stompdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 12;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Refreshingbitedialog2)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 13;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Goddigdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 14;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Poppingtiresdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 15;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Higherjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 16;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Repellentdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 17;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Ravagingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 18;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Superscreamdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 19;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
    if(dialogid == Zombieperksdialog)
    {
        if(!response) return 0;
        if(listitem == 0)
        {
			ShowPlayerDialog(playerid,Nozombieperkdialog,0,"Ничего",""cwhite"Чтобы получить способность нужно повышать свой ранг.","Установить","Закрыть");
        }
        if(listitem == 1)
        {
			ShowPlayerDialog(playerid,Hardbitedialog,0,"Сильный укус",""cwhite"Ты научился кусать и из-аз этого твой укус стал сильнее \nВыбрав эту способность ты сможешь кусать людей сильнее.","Установить","Закрыть");
        }
        if(listitem == 2)
        {
			ShowPlayerDialog(playerid,Diggerdialog,0,"Подкоп",""cwhite"Ты эволюционируешь и ты научился делать подкопы к ближайшим людям \nНо другие зомби будут дизорентировать тебя и ты не сможешь сделать подкоп \nНажми "cred"C "cwhite"чтобы сделать подкоп. Время восстановления 2 минуты","Установить","Закрыть");
        }
        if(listitem == 3)
        {
			ShowPlayerDialog(playerid,Refreshingbitedialog,0,"Освежающий укус",""cwhite"Твой мертвый организм научился лучше осваивать мясо \nПри укусе ты будешь получать больше HP (+6HP)","Установить","Закрыть");
        }
        if(listitem == 4)
        {
			ShowPlayerDialog(playerid,Jumperdialog,0,"Прыгун",""cwhite"Ты стал весить меньше и ты заметил, что ты можешь прыгать выше чем обычно \nНажми "cred"SPACE "cwhite"чтобы прыгнуть высоко","Set","Close");
        }
        if(listitem == 5)
        {
			ShowPlayerDialog(playerid,Deadsensedialog,0,"Чутье мертвеца",""cwhite"Ты понимаешь, что с другими зомби ты чувствуешь связь \nИ ты можешь чувствовать где находятся твои собратья  \n"cred"Просто активируй способность, чтобы на mini-map увидеть других зомби","Set","Close");
        }
        if(listitem == 6)
        {
			ShowPlayerDialog(playerid,Hardpunchdialog,0,"Тяжелый удар",""cwhite"Ты не чувствуешь боли и можешь бить очень больно с помощью кулаков \n"cred"При активации способности ты сможешь наносить больше урона с помощью кулаков","Set","Close");
        }
        if(listitem == 7)
        {
			ShowPlayerDialog(playerid,Vomiterdialog,0,"Блевун",""cwhite"Не все мясо переваривается в желдке и из-за этого тебя тянет блевать \nНо ты заметил, что блевотина имеет необычные свойства, она радиактивна и выводит из строя транспортное средство \n"corange"Нажми на "cred"CROUCH "corange"чтобы блевануть, время восстановления 1 минута.","Set","Close");
        }
        if(listitem == 8)
        {
			ShowPlayerDialog(playerid,Screamerdialog,0,"Крикун",""cwhite"Твои голосовые связки стали бесполезни для речи, но получили новую особенность \nКогда ты пытаешься кричать изо рта идет сильный поток воздуха \n Крик наносят урон всем выжившим попавших в зону поражения и другие зомби имеют иммунитет к крику \n"cred"Нажмите ПКМ чтобы крикнуть (при активации ты не сможешь кусать!)","Set","Close");
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
			if(PInfo[playerid][Premium] == 1)
			    SendFMessage(playerid,white,"*"cgold"Thanks for supporting our community, gold member %s(%i)!",GetPName(playerid),playerid);
			if(PInfo[playerid][Premium] == 2)
			    SendFMessage(playerid,white,"*"cplat"Thanks for supporting our community, platinium member %s(%i)!",GetPName(playerid),playerid);
            if(Team[playerid] != 0)
			{
			    if(Team[playerid] == ZOMBIE)
				{
				    SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
				    SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
				    SpawnPlayer(playerid);
				    Team[playerid] = ZOMBIE;
				    SpawnPlayer(playerid);
				    SetPlayerColor(playerid,purple);
				    SetPlayerHealth(playerid,100);
			  	}
			  	if(Team[playerid] == HUMAN)
				{
				    Team[playerid] = HUMAN;
				    static sid;
					ChooseSkin: sid = random(299);
					sid = random(299);
					for(new i = 0; i < sizeof(ZombieSkins); i++)
						if(sid == ZombieSkins[i]) goto ChooseSkin;
			    	SetSpawnInfo(playerid,0,sid,0,0,0,0,0,0,0,0,0,0);
				    SetPlayerSkin(playerid,sid);
				    PInfo[playerid][JustInfected] = 0;
				    PInfo[playerid][Infected] = 0;
					PInfo[playerid][Dead] = 0;
					PInfo[playerid][CanBite] = 1;
					SpawnPlayer(playerid);
					SetPlayerColor(playerid,green);
					SetPlayerHealth(playerid,100);
				}
			}
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
    new
        anim = GetPlayerAnimationIndex(playerid)
    ;
    if(anim == 1026 || anim == 1027)
    {
        g_EnterAnim{playerid} = true;
    }
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
       new pname[MAX_PLAYER_NAME];
       GetPlayerName(playerid, pname, sizeof(pname));
       SendClientMessage(playerid, COLOR_WHITE, "Вы были кикнуты за использование чита на JetPack");
       Kick(playerid);
	}
	new gun[] = {46,38,37,36,35,45,44,43,42,41,11,12,13,14,15}; // id's запрещенного оружия для игроков.
	for(new i= 0;i<sizeof(gun);i++)
	{
		if(gun[i] == GetPlayerWeapon(playerid))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Вы Были Кикнуты по подозрению в читерстве.[Исп Запрещенного оружия]");
			Kick(playerid);
			return true;
		}
	}

	if( GetPlayerMoney ( playerid ) != eGetPlayerMoney ( playerid ) ) ResetPlayerMoney( playerid ), GivePlayerMoney( playerid, eGetPlayerMoney ( playerid ) );
	if(IsPlayerNPC(playerid))return 1;
	if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
	{
		new weaponid=GetPlayerWeapon(playerid),oldweapontype = GetWeaponType(OldWeapon[playerid]);
		new weapontype=GetWeaponType(weaponid);
		if(HoldingWeapon[playerid] == weaponid)
		    StopPlayerHoldingObject(playerid);
		    
		if(Team[playerid] == ZOMBIE)
		    StopPlayerHoldingObject(playerid);
		    
		if(OldWeapon[playerid] != weaponid)
		{
		    new modelid = GetWeaponModel(OldWeapon[playerid]);
		    if(modelid != 0 && oldweapontype != WEAPON_TYPE_NONE && oldweapontype != weapontype)
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
		if(oldweapontype != weapontype)
			OldWeapon[playerid] = weaponid;
	}
	if(GetPlayerAnimationIndex(playerid))
    {
        new animlib[32];
        new animname[32];
        GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
        if(strcmp(animlib, "SWIM", true) == 0 && !PInfo[playerid][Swimming])
        {
            PInfo[playerid][Swimming] = 1;
        }
        else if(strcmp(animlib, "SWIM", true) != 0 && PInfo[playerid][Swimming] && strfind(animname, "jump", true) == -1)
        {
            PInfo[playerid][Swimming] = 0;
        }
    }
    else if(PInfo[playerid][Swimming])
    {
        PInfo[playerid][Swimming] = 0;
    }
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
	    if(!IsPlayerConnected(i)) continue;
	    SetPlayerScore(i,PInfo[i][Rank]);
        if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == HUMAN)
	    {
		    static string[88];
		    format(string,sizeof string,"PA®‚: %i ~n~Y—…†C¦‹: %i ~n~T…MK…‡‘: %i ~n~CMEP¦E†: %i ~n~CЊOCO—®OC¦’: %i ~n~KT ЊPO†ѓE®O: %i",
		    PInfo[i][Rank],PInfo[i][Kills],PInfo[i][Teamkills],PInfo[i][Deaths],PInfo[i][SPerk]+1,PInfo[i][CPCleared]);
		    TextDrawSetString(Stats[i],string);
		    TextDrawShowForPlayer(i,Stats[i]);
		    format(string,sizeof string,"XP: %i/%i",PInfo[i][XP],PInfo[i][XPToRankUp]);
	  		TextDrawSetString(XPStats[i],string);
			TextDrawShowForPlayer(i,XPStats[i]);
			TextDrawShowForPlayer(i,XPBox);
			if(PInfo[i][Premium] == 1)
				format(string,sizeof string,""cgold"Ранг: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			else if(PInfo[i][Premium] == 2)
			    format(string,sizeof string,""cplat"Ранг: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			else
			    format(string,sizeof string,""cgreen"Ранг: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
			Update3DTextLabelText(PInfo[i][Ranklabel],green,string);
			static Float:health;
		    GetPlayerHealth(i,health);
			MakeHealthEven(i,health);
			GetPlayerHealth(i,health);
			if(PInfo[i][Swimming] == 1)
			{
				SetPlayerHealth(i,health-4);
				GetPlayerHealth(i,health);
				SendClientMessage(i,orange,"УХОДИ ИЗ ВОДЫ, ОНА ИНФИЦИРОВАННА!!!");
				if(health <= 5)
				{
				    SetSpawnInfo(i,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
			        SetPlayerSkin(i,ZombieSkins[random(sizeof(ZombieSkins))]);
			        InfectPlayer(i);
				}
			}
			
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
			if(Mission[i] == 2)
			{
				if(MissionPlace[i][1] == 1) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 1)
				    {
				        if(IsPlayerInRangeOfPoint(i,1.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some ethanol.",3000,3);
				        }
				    }
				    if(MissionPlace[i][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(i,1.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some ethanol.",3000,3);
				        }
				    }
				}
				if(MissionPlace[i][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[2][0],Locations[2][1],Locations[2][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some fuse.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some fuse.",3000,3);
				        }
					}
				}
				if(MissionPlace[i][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some cans.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some cans.",3000,3);
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
		if(IsPlayerInRangeOfPoint(i,8,945.96, -1103.36, 26.73))
		{
		    if(strfind(GetPName(i),"NZ",false) != -1)
		    {
		        if(NZGateOpened == 0)
		        {
		        	MoveObject(NZGate,945.98, -1103.32, 17.60,3.5);
		        	SetTimer("CloseNZGate",4000,false);
		        	NZGateOpened = 1;
	        	}
		    }
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
	    			ApplyAnimation(f,"PED","WALK_SHUFFLE",100,1,1,1,0,0,1);
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
		if(PInfo[i][PlantedBettys] > 0)
		{
		    for(new j; j < MAX_PLAYERS;j++)
		    {
		        if(!IsPlayerConnected(j)) continue;
		        if(PInfo[j][Dead] == 1) continue;
		        if(IsPlayerInRangeOfObject(j,10.0,PInfo[i][BettyObj1]))
	        	{
	        	    if(PInfo[i][BettyActive1] == 1)
	        	    {
				    	new Float:x,Float:y,Float:z;
				        GetObjectPos(PInfo[i][BettyObj1],x,y,z);
			            MoveObject(PInfo[i][BettyObj1],x,y,z+1.3,5);
			            SetTimerEx("ExplodeBetty",300,false,"ii",i,1);
	           		}
		        }
		        if(IsPlayerInRangeOfObject(j,10.0,PInfo[i][BettyObj2]))
		        {
		            if(PInfo[i][BettyActive2] == 1)
	        	    {
			            new Float:x,Float:y,Float:z;
			            GetObjectPos(PInfo[i][BettyObj2],x,y,z);
			            MoveObject(PInfo[i][BettyObj2],x,y,z+1.3,5);
			            SetTimerEx("ExplodeBetty",300,false,"ii",i,2);
		            }
		        }
		        if(IsPlayerInRangeOfObject(j,10.0,PInfo[i][BettyObj3]))
		        {
		            if(PInfo[i][BettyActive3] == 1)
	        	    {
			            new Float:x,Float:y,Float:z;
			            GetObjectPos(PInfo[i][BettyObj3],x,y,z);
			            MoveObject(PInfo[i][BettyObj3],x,y,z+1.3,5);
			            SetTimerEx("ExplodeBetty",300,false,"ii",i,3);
		            }
		        }
      		}
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
				if(IsPlayerInRangeOfPoint(j,5.5,PInfo[i][Vomitx],PInfo[i][Vomity],PInfo[i][Vomitz]))
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
    	SetPlayerTime(i,23,0);
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
		if(PInfo[i][TokeDizzy] == 0)
		{
			SetPlayerDrunkLevel(i,10000);
            new Float:health;
			GetPlayerHealth(i,health);
			SetPlayerHealth(i,health-3);
	 		if(health <= 0)
		 		{
	    			InfectPlayer(i);
				}
			ApplyAnimation(i,"CRACK", "CRCKDETH2", 2.0, 0, 0, 0, 500, 1);
		}
		else SetPlayerDrunkLevel(i,0);
		SetPlayerWeather(i,306);
		SetPlayerTime(i,23,00);
		if(PInfo[i][Lighton] == 1)
		{
            RemovePlayerAttachedObject(i,1);
            RemovePlayerAttachedObject(i,2);
            PInfo[i][Lighton] = 0;
            RemoveItem(i,"Flashlight",1);
            static string[90];
 			format(string,sizeof string,""cjam"%s flashlight has runned out of bateries.",GetPName(i));
 			ShowPlayerMarkers(0);
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
		SetPlayerWeather(i,9);
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
	    if(Team[i] == ZOMBIE) SetPlayerWeather(i,188);
	    SetPlayerWeather(i,id);
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
	    case 32: PInfo[playerid][XPToRankUp] = 45000;
	    case 33: PInfo[playerid][XPToRankUp] = 50000;
	    case 34: PInfo[playerid][XPToRankUp] = 55000;
	    case 35: PInfo[playerid][XPToRankUp] = 60000;
	    case 36: PInfo[playerid][XPToRankUp] = 65000;
        case 37: PInfo[playerid][XPToRankUp] = 70000;
        case 38: PInfo[playerid][XPToRankUp] = 75000;
        case 39: PInfo[playerid][XPToRankUp] = 80000;
        case 40: PInfo[playerid][XPToRankUp] = 85000;
        case 41: PInfo[playerid][XPToRankUp] = 90000;
        case 42: PInfo[playerid][XPToRankUp] = 95000;
        case 43: PInfo[playerid][XPToRankUp] = 100000;
        case 44: PInfo[playerid][XPToRankUp] = 105000;
        case 45: PInfo[playerid][XPToRankUp] = 110000;
        case 46: PInfo[playerid][XPToRankUp] = 120000;
        case 47: PInfo[playerid][XPToRankUp] = 140000;
        case 48: PInfo[playerid][XPToRankUp] = 160000;
        case 49: PInfo[playerid][XPToRankUp] = 180000;
        case 50: PInfo[playerid][XPToRankUp] = 200000;
		case 51: PInfo[playerid][XPToRankUp] = 225000;
	}
	if(gw == 1)
	{
	    if(Team[playerid] == ZOMBIE) return 0;
	    switch(PInfo[playerid][Rank])
		{
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,60),GivePlayerWeapon(playerid,2,1);
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,110),GivePlayerWeapon(playerid,2,1);
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,160),GivePlayerWeapon(playerid,7,1);
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,190),GivePlayerWeapon(playerid,7,1);
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,100),GivePlayerWeapon(playerid,7,1);
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,150),GivePlayerWeapon(playerid,7,1);
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,200),GivePlayerWeapon(playerid,7,1);
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,250),GivePlayerWeapon(playerid,7,1);
		    case 9: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1);
		    case 10: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,50);
		    case 11: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,400),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,150);
		    case 12: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,500),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,250);
		    case 13: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,600),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,350);
		    case 14: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,700),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,350);
		    case 15: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,100),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,350);
		    case 16: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,200),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,400);
		    case 17: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,300),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,450);
		    case 18: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,400),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,500);
		    case 19: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,500),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,500);
		    case 20: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,650),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,550),GivePlayerWeapon(playerid,28,120),GivePlayerWeapon(playerid,33,50);
		    case 21: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,800),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,600),GivePlayerWeapon(playerid,28,200),GivePlayerWeapon(playerid,33,100);
		    case 22: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1050),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,650),GivePlayerWeapon(playerid,28,250),GivePlayerWeapon(playerid,33,150);
		    case 23: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1200),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,700),GivePlayerWeapon(playerid,28,300),GivePlayerWeapon(playerid,33,200);
		    case 24: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1350),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,750),GivePlayerWeapon(playerid,28,350),GivePlayerWeapon(playerid,33,250);
		    case 25: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1600),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,150),GivePlayerWeapon(playerid,28,400),GivePlayerWeapon(playerid,33,300);
		    case 26: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1800),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,200),GivePlayerWeapon(playerid,28,450),GivePlayerWeapon(playerid,33,350);
		    case 27: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2000),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,250),GivePlayerWeapon(playerid,28,500),GivePlayerWeapon(playerid,33,400);
		    case 28: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2200),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,26,300),GivePlayerWeapon(playerid,28,550),GivePlayerWeapon(playerid,33,450);
		    case 29: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2400),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,400),GivePlayerWeapon(playerid,28,600),GivePlayerWeapon(playerid,33,500);
		    case 30: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2700),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,150),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,120),GivePlayerWeapon(playerid,33,550);
			case 31: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3000),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,200),GivePlayerWeapon(playerid,32,200),GivePlayerWeapon(playerid,30,180),GivePlayerWeapon(playerid,33,600);
			case 32: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3300),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,250),GivePlayerWeapon(playerid,32,300),GivePlayerWeapon(playerid,30,240),GivePlayerWeapon(playerid,33,650);
            case 33: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3600),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,300),GivePlayerWeapon(playerid,32,400),GivePlayerWeapon(playerid,30,300),GivePlayerWeapon(playerid,33,700);
            case 34: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3900),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,400),GivePlayerWeapon(playerid,32,500),GivePlayerWeapon(playerid,30,360),GivePlayerWeapon(playerid,33,750);
            case 35: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,4500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,50),GivePlayerWeapon(playerid,32,600),GivePlayerWeapon(playerid,30,420),GivePlayerWeapon(playerid,33,800);
			case 36: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,100),GivePlayerWeapon(playerid,32,800),GivePlayerWeapon(playerid,30,500),GivePlayerWeapon(playerid,33,950);
			case 37: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,150),GivePlayerWeapon(playerid,32,1000),GivePlayerWeapon(playerid,30,600),GivePlayerWeapon(playerid,33,1000);
			case 38: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,200),GivePlayerWeapon(playerid,32,1200),GivePlayerWeapon(playerid,30,750),GivePlayerWeapon(playerid,33,1050);
			case 39: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,250),GivePlayerWeapon(playerid,32,1400),GivePlayerWeapon(playerid,30,900),GivePlayerWeapon(playerid,33,1100);
			case 40: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,250),GivePlayerWeapon(playerid,32,1800),GivePlayerWeapon(playerid,31,200),GivePlayerWeapon(playerid,33,1150);
			case 41: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,7000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,300),GivePlayerWeapon(playerid,32,2200),GivePlayerWeapon(playerid,31,350),GivePlayerWeapon(playerid,33,1200);
			case 42: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,8000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,400),GivePlayerWeapon(playerid,32,2600),GivePlayerWeapon(playerid,31,500),GivePlayerWeapon(playerid,33,1250);
			case 43: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,9000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,500),GivePlayerWeapon(playerid,32,3000),GivePlayerWeapon(playerid,31,650),GivePlayerWeapon(playerid,33,1300);
			case 44: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,10000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,600),GivePlayerWeapon(playerid,32,3500),GivePlayerWeapon(playerid,31,800),GivePlayerWeapon(playerid,33,1350);
			case 45: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,11000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,700),GivePlayerWeapon(playerid,29,210),GivePlayerWeapon(playerid,31,1000),GivePlayerWeapon(playerid,34,100),GivePlayerWeapon(playerid,39,5),GivePlayerWeapon(playerid,40,1);
			case 46: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,12000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1000),GivePlayerWeapon(playerid,29,300),GivePlayerWeapon(playerid,31,1250),GivePlayerWeapon(playerid,34,200),GivePlayerWeapon(playerid,39,10),GivePlayerWeapon(playerid,40,1);
			case 47: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,13000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1500),GivePlayerWeapon(playerid,29,390),GivePlayerWeapon(playerid,31,1500),GivePlayerWeapon(playerid,34,300),GivePlayerWeapon(playerid,39,15),GivePlayerWeapon(playerid,40,1);
			case 48: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,14000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,2500),GivePlayerWeapon(playerid,29,480),GivePlayerWeapon(playerid,31,1750),GivePlayerWeapon(playerid,34,400),GivePlayerWeapon(playerid,39,20),GivePlayerWeapon(playerid,40,1);
			case 49: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,15000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,3000),GivePlayerWeapon(playerid,29,570),GivePlayerWeapon(playerid,31,2000),GivePlayerWeapon(playerid,34,500),GivePlayerWeapon(playerid,39,25),GivePlayerWeapon(playerid,40,1);
			case 50: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,16000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,5000),GivePlayerWeapon(playerid,29,660),GivePlayerWeapon(playerid,31,2500),GivePlayerWeapon(playerid,34,600),GivePlayerWeapon(playerid,39,30),GivePlayerWeapon(playerid,40,1);
			case 51: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,17000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,7500),GivePlayerWeapon(playerid,29,800),GivePlayerWeapon(playerid,31,3000),GivePlayerWeapon(playerid,34,1000),GivePlayerWeapon(playerid,39,40),GivePlayerWeapon(playerid,40,1);
			
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
			SetPlayerCheckpoint(i,1175.0366,-2036.9196,69.1758,20.0);
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
 		SetPlayerCheckpoint(playerid,1175.0366,-2036.9196,69.1758,20.0);
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~EMPTY");
				GameTextForPlayer(i,"~n~~n~~r~~h~No бензин left!",4000,3);
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~l");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~l");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~ll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~lll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~llll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~lllll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~llllll");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~llllll~g~~h~l");
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
				TextDrawSetString(FuelTD[i],"ЂE®€…®: ~r~~h~ll~y~llllll~g~~h~ll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~EMPTY");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~l");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~l");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~ll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~lll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~llll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~lllll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~llllll");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~llllll~g~~h~l");
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
				TextDrawSetString(OilTD[i],"MAC‡O: ~r~~h~ll~y~llllll~g~~h~ll");
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
	new id;
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


  		id = AddStaticVehicle(vehicletype,SpawnX,SpawnY,SpawnZ+2,SpawnRot,Color1,Color2);
		vehicles_loaded++;
		if(vehicletype == 409) ChangeVehicleColor(id,0,0);
		if(vehicletype == 571) ChangeVehicleColor(id,0,5);
		if(vehicletype == 571) ChangeVehicleColor(id,0,5);
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
            RemoveItem(playerid,"Large Medical Kits",1);
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
			if(health > 100.0) SetPlayerHealth(playerid,100.0);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+40.0);
			else SetPlayerHealth(playerid,health+50.0);
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
            RemoveItem(playerid,"Medium Medical Kits",1);
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 100.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        format(string,sizeof string,""cjam"%s(%i) has taken a medium medical kit.",GetPName(playerid),playerid);
	        RemoveItem(playerid,"Medium Medical Kits",1);
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(health > 100.0) SetPlayerHealth(playerid,100.0);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+25.0);
			else SetPlayerHealth(playerid,health+30.0);
			if(health > 100.0) SetPlayerHealth(playerid,100.0);
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
            RemoveItem(playerid,"Small Medical Kits",1);
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
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+10.0);
			else SetPlayerHealth(playerid,health+18.0);
			if(health > 100.0) SetPlayerHealth(playerid,100.0);
		}
  	}
    if(!strcmp(ItemName,"Fuel",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(Fuel[vehid] >= 99) return SendClientMessage(playerid,white,"» "cred"This %s does not need anymore fuel."),GetVehicleName(vehid),Fuel[vehid] = 100;
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
        if(Oil[vehid] >= 99) return SendClientMessage(playerid,white,"» "cred"This %s does not need anymore oil."),GetVehicleName(vehid),Oil[vehid] = 100;
        RemoveItem(playerid,"Oil",1);
        format(string,sizeof string,""cjam"%s(%i) has added some oil to his vehicle.",GetPName(playerid),playerid);
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 3) Oil[vehid]+=12;
		else Oil[vehid]+=7;
		if(Oil[vehid] > 100) Oil[vehid] = 100;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Dizzy Away Pills",true))
    {
        if(PInfo[playerid][SPerk] != 13)
        {
        	PInfo[playerid][TokeDizzy] = 1;
        	RemoveItem(playerid,"Dizzy Away Pills",1);
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
			RemovePlayerAttachedObject(playerid,1);
			RemovePlayerAttachedObject(playerid,2);
			PInfo[playerid][Lighton] = 0;
			format(string,sizeof string,""cjam"%s has turned off his flashlight.",GetPName(playerid));
			ShowPlayerMarkers(0);
			SendNearMessage(playerid,white,string,30);
       	}
        else
        {
			SetPlayerAttachedObject(playerid, 1, 18656, 5, 0.1, 0.038, -0.1, -90.0, 180.0, 0.0, 0.03, 0.03, 0.03);
			SetPlayerAttachedObject(playerid, 2, 18641, 5, 0.1, 0.02, -0.05, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
			PInfo[playerid][Lighton] = 1;
			format(string,sizeof string,""cjam"%s has turned on his flashlight.",GetPName(playerid));
   			ShowPlayerMarkers(PLAYER_MARKERS_MODE_STREAMED);
			SendNearMessage(playerid,white,string,30);
    	}
	}
	if(!strcmp(ItemName,"Mission Molotovs Guide"))
	{
	    RemoveItem(playerid,"Mission Molotovs Guide",1);
	    new rand = random(2);
		switch(rand)
		{
		    case 0: SendClientMessage(playerid,white,"* "corange"Head over to Pig Pen to get some alcohol"),Mission[playerid] = 1, MissionPlace[playerid][0] = 1, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[0][3],Locations[0][4],Locations[0][5],62,0,MAPICON_GLOBAL);
			case 1: SendClientMessage(playerid,white,"* "corange"Head over to Alhambra to get some alcohol"),Mission[playerid] = 1, MissionPlace[playerid][0] = 2, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[1][3],Locations[1][4],Locations[1][5],62,0,MAPICON_GLOBAL);
		}
	}
	if(!strcmp(ItemName,"Bouncing Bettys Guide"))
	{
	    if(Mission[playerid] == 1) return SendClientMessage(playerid,red,"» Please finish your molotovs mission!");
	    RemoveItem(playerid,"Bouncing Bettys Guide",1);
	    new rand = random(2);
		switch(rand)
		{
		    case 0: SendClientMessage(playerid,white,"* "corange"Head over to Pig Pen to get some ethanol"),Mission[playerid] = 2, MissionPlace[playerid][0] = 1, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[0][3],Locations[0][4],Locations[0][5],62,0,MAPICON_GLOBAL);
			case 1: SendClientMessage(playerid,white,"* "corange"Head over to Alhambra to get some ethanol"),Mission[playerid] = 2, MissionPlace[playerid][0] = 2, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[1][3],Locations[1][4],Locations[1][5],62,0,MAPICON_GLOBAL);
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
		format(string2,sizeof string2,"…®ЃEK‰…•: ~r~~h~%i%%", floatround(100.0 * floatdiv(infects, PlayersConnected)));
		TextDrawSetString(Infection,string2);
		if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 100)
		{
		    if(RoundEnded == 0)
		    {
				SetTimerEx("EndRound",3000,false,"i",1);
				GameTextForAll("~w~The round has ended.",3000,3);
				RoundEnded = 1;
			}
		}
		infects = 0;
	}
	else TextDrawSetString(Infection,"…®ЃEK‰…•: ~r~~h~0%");
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
	format(string,sizeof string,"~g~~h~ЂO‡’Ћ…®C¦‹O Y—…†C¦‹: ~w~%s ~n~~g~~h~ЂO‡’ЋE®C¦‹O CMEP¦E†: ~w~%s ~n~~g~~h~ЂO‡’Ћ…®C¦‹O €APA„E®®‘X: ~w~%s",
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
	if(win == 1) GameTextForAll("~r~~h~100% €APA„E®…•, ‹‘„…‹Ћ…X —O‡’ЋE ®E OC¦A‡OC’!",4500,3);
	else GameTextForAll("~g~~h~‡”ѓ… YCЊE‡… ЊPO†¦… ‹CE ~n~~r~~h~KO®¦PO‡’®‘E ¦OЌK…~g~~h~!",3000,3);
	SetTimer("EndRound2",3500,false);
	return 1;
}

function EndRound2()
{
    SetTimer("EndRoundFinal",5000,false);
    GameTextForAll("~b~~h~CЊAC…—O €A …‚PY ®A ®AЋEM CEP‹EPE",4500,3);
	return 1;
}

function EndRoundFinal()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		GameTextForPlayer(i,"~y~ЊO„A‡Y†C¦A, ЊOѓO„ѓ…¦E, ‹‘ —YѓE¦E ~n~~g~~h~ЊEPEЊOѓK‡”ЌE®‘!",6000,3);
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
        if(!IsPlayerConnected(i)) continue;
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
		 	if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 14;PInfo[playerid][CurrentXP] = 14;}
			else {PInfo[playerid][XP] += 10;PInfo[playerid][CurrentXP] = 10;}
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
			if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 14;PInfo[playerid][CurrentXP] = 14;}
			else {PInfo[playerid][XP] += 10;PInfo[playerid][CurrentXP] = 10;}
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
			if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			else {PInfo[playerid][XP] += 7;PInfo[playerid][CurrentXP] = 7;}
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
            if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 12;PInfo[playerid][CurrentXP] = 12;}
			else {PInfo[playerid][XP] += 7;PInfo[playerid][CurrentXP] = 7;}
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
    if(Health >= 1.0 && Health <= 10.0)
		SetPlayerHealth(i,5.0);
    if(PInfo[playerid][ZPerk] == 18)
	{
	    if(PInfo[i][SPerk] != 5)
		{
		    if(Health <= 10.0 && Health > 0.0)
		    	MakeProperDamage(i);
			else
			    SetPlayerHealth(i,Health-5.0);
		}
		else
		{
		    if(Health <= 10.0 && Health > 0.0)
		    	MakeProperDamage(i);
			else
			    SetPlayerHealth(i,Health-7.0);
		}
		GetPlayerHealth(playerid,Health);
		if(Health >= 100.0) SetPlayerHealth(playerid,100.0);
		else SetPlayerHealth(playerid,Health+6.0);
	}
	else if(PInfo[i][SPerk] == 5)
	{
		GetPlayerHealth(i,Health);
		if(PInfo[playerid][ZPerk] == 1)
		{
			if(Health <= 10.0 && Health > 0.0)
		    	MakeProperDamage(i);
			else
			    SetPlayerHealth(i,Health-7.0);
		}
		else SetPlayerHealth(i,Health-4.0);
	}
    else
	{
		GetPlayerHealth(i,Health);
    	if(PInfo[playerid][ZPerk] == 1)
		{
		    if(Health <= 10.0 && Health > 0.0)
		    	MakeProperDamage(i);
			else
      			SetPlayerHealth(i,Health-8.0);
		}
		else if(PInfo[playerid][ZPerk] != 18.0)
		{
		    if(Health <= 10.0 && Health > 0.0)
		    	MakeProperDamage(i);
			else
   				SetPlayerHealth(i,Health-8.0);
		}
	}
 	GetPlayerHealth(i,Health);
	if(Health <= 5)
	{
	    PInfo[playerid][Kills]++;
	    GivePlayerXP(playerid);
	    InfectPlayer(i);
	}
	return 1;
}

function MakeProperDamage(playerid)
{
	new Float:Health;
	GetPlayerHealth(playerid,Health);
	if(Health <= 10.0 && Health >= 5.0)
	    SetPlayerHealth(playerid,4.0);
	else if(Health <= 5.0 && Health > 0.0)
	    SetPlayerHealth(playerid,1.0);
	GetPlayerHealth(playerid,Health);
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
	if(PInfo[playerid][Rank] == 1) SetPlayerHealth(playerid,80);
	if(PInfo[playerid][Rank] == 2) SetPlayerHealth(playerid,82);
	if(PInfo[playerid][Rank] == 3) SetPlayerHealth(playerid,84);
	if(PInfo[playerid][Rank] == 4) SetPlayerHealth(playerid,86);
	if(PInfo[playerid][Rank] == 5) SetPlayerHealth(playerid,88);
	if(PInfo[playerid][Rank] == 6) SetPlayerHealth(playerid,90);
	if(PInfo[playerid][Rank] == 7) SetPlayerHealth(playerid,92);
	if(PInfo[playerid][Rank] == 8) SetPlayerHealth(playerid,94);
	if(PInfo[playerid][Rank] == 9) SetPlayerHealth(playerid,96);
	if(PInfo[playerid][Rank] == 10) SetPlayerHealth(playerid,98);
	if(PInfo[playerid][Rank] == 11) SetPlayerHealth(playerid,99);
	if(PInfo[playerid][Rank] >= 12) SetPlayerHealth(playerid,100);
	return 1;
}

stock IsPlayerInRangeOfObject(playerid, Float:range, objectid)
{
    new Float:pos[3];
    GetObjectPos(objectid, pos[0], pos[1], pos[2]);
    return IsPlayerInRangeOfPoint(playerid, range, pos[0], pos[1], pos[2]);
}

function ExplodeBetty(playerid,id)
{
	new Float:x,Float:y,Float:z;
	if(id == 1)
	{
		GetObjectPos(PInfo[playerid][BettyObj1],x,y,z);
		CreateExplosion(x,y,z,2,9);
		DestroyObject(PInfo[playerid][BettyObj1]);
		PInfo[playerid][BettyActive1] = 0;
	}
	if(id == 2)
	{
		GetObjectPos(PInfo[playerid][BettyObj2],x,y,z);
		CreateExplosion(x,y,z,2,9);
		DestroyObject(PInfo[playerid][BettyObj2]);
		PInfo[playerid][BettyActive2] = 0;
	}
	if(id == 3)
	{
		GetObjectPos(PInfo[playerid][BettyObj3],x,y,z);
		CreateExplosion(x,y,z,2,9);
		DestroyObject(PInfo[playerid][BettyObj3]);
		PInfo[playerid][BettyActive3] = 0;
	}
	return 1;
}

function ActivateBetty(playerid,id)
{
    if(id == 1)
	{
	 	PInfo[playerid][BettyActive1] = 1;
	}
	if(id == 2)
	{
		PInfo[playerid][BettyActive2] = 1;
	}
	if(id == 3)
	{
		PInfo[playerid][BettyActive3] = 1;
	}
	return 1;
}

function CloseNZGate()
{
	MoveObject(NZGate,945.96, -1103.36, 26.73,5);
	NZGateOpened = 0;
	return 1;
}


function PutGlassesOn(playerid)
{
    static skin, id, slot, glasseid;
	skin = GetPlayerSkin(playerid);
	id = randomEx(1,34);
	PInfo[playerid][oslotglasses] = 6;
	RemovePlayerAttachedObject(playerid,PInfo[playerid][oslotglasses]);
	if(id > 30) goto PutPoliceGlasses;
	else
	{
	    id--;
	    glasseid =  CommonRed + id;
	    if(PInfo[playerid][oslotglasses] != -1) RemovePlayerAttachedObject(playerid,PInfo[playerid][oslotglasses]);
		SetPlayerAttachedObject(playerid, slot, glasseid, 2, SkinOffSetGlasses[skin][0], SkinOffSetGlasses[skin][1], SkinOffSetGlasses[skin][2], SkinOffSetGlasses[skin][3], SkinOffSetGlasses[skin][4], SkinOffSetGlasses[skin][5], SkinOffSetGlasses[skin][6], SkinOffSetGlasses[skin][6], SkinOffSetGlasses[skin][6]);
		return 1;
	}
	PutPoliceGlasses:
	glasseid = CopGlassesBlack + (id - 31);
	if(PInfo[playerid][oslotglasses] != -1) RemovePlayerAttachedObject(playerid,PInfo[playerid][oslotglasses]);
	SetPlayerAttachedObject(playerid, slot, glasseid, 2, SkinOffSetGlasses[skin][0], floatadd(SkinOffSetGlasses[skin][1], 0.004500), SkinOffSetGlasses[skin][2], SkinOffSetGlasses[skin][3], SkinOffSetGlasses[skin][4], SkinOffSetGlasses[skin][5], SkinOffSetGlasses[skin][6], SkinOffSetGlasses[skin][6], SkinOffSetGlasses[skin][6]);
	return 1;
}

function IsPlatVehicle(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 409) return 1;
	if(GetVehicleModel(vehicleid) == 434) return 1;
	if(GetVehicleModel(vehicleid) == 541) return 1;
	if(GetVehicleModel(vehicleid) == 571) return 1;
	return 0;
}

function PutHatOn(playerid)
{
    new skin, id = randomEx(1,12), beret, count;
 	skin = (GetPlayerSkin(playerid) - 1);
 	PInfo[playerid][oslothat] = 5;
 	RemovePlayerAttachedObject(playerid,PInfo[playerid][oslotglasses]);
	switch(id)
	{
	    case 1:     beret = 18926;
	    case 2..10: beret = 18926 + id;
	    case 11:    beret = 19099;
	}
	do
	{
		if(skin == invalidskins[count]) return SendClientMessage(playerid, red, "» "cyellow"DDL NOT FOUND!");
		count++;
	}
	while(count < sizeof invalidskins);
	if(skin < 0) skin = 0;
	SetPlayerAttachedObject(playerid, PInfo[playerid][oslothat], beret, 2, SkinOffSetHat[skin][0], SkinOffSetHat[skin][1], SkinOffSetHat[skin][2], SkinOffSetHat[skin][3], SkinOffSetHat[skin][4], SkinOffSetHat[skin][5]);
	return 1;
}

function InfectPlayer(playerid)
{
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
	PInfo[playerid][DeathsRound]++;
	GetPlayerPos(playerid,x,y,z);
	SetPlayerPos(playerid,x,y,z+4);
	return 1;
}

CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid,1000,DSL,"Правила и помощь","Суть режима\nВыживший\nЗомби\nПравила", "Выбор", "Отмена");
	return 1;
}

public UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, true);
    return true;
}

CMD:w(playerid, params[])
{
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new Float:vh;//создаем переменную для хп транспорта
    GetVehicleHealth(vehicleid, vh);//проверяем хп транспорта
	if(playerid == PLAYER_STATE_PASSENGER) return true;
    if(1000 - vh <= 100)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-5);//отнимаем хп у игрока(сколько было - 10)
        if(PInfo[playerid][Infected] == 1)
	    {
    		GetPlayerHealth(playerid,PH);
			if(PH <= 6.0)
        	InfectPlayer(playerid);
		}
	    else
	    {
			return 1;
    	}
	}
    if(1000 - vh >= 800)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-40);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh > 100)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-10);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 200)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-15);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 300)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-20);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 400)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-24);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 550)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-28);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 650)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-33);//отнимаем хп у игрока(сколько было - 10)
    }
    if(1000 - vh >= 750)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
    {
        new Float:PH;//переменная для проверки хп игрока
        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
        SetPlayerHealth(playerid, PH-37);//отнимаем хп у игрока(сколько было - 10)
    }
    return 1;
}

public AnticheatSH()
{
    for(new i=GetMaxPlayers(); i!=0; )
    {
        i--;
        if(IsPlayerConnected(i) && (GetPlayerSpeed(i) > 260))
        {
            Kick(i);
        }
    }
}

stock GetPlayerSpeed(player)
{
    new Float:x,Float:y,Float:z;
    GetVehicleVelocity(GetPlayerVehicleID(player),x,y,z);
    return floatround(floatsqroot(x*x+y*y+z*z)*195);
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	UpdateVehiclePos(vehicleid, 0);
 	return 1;
}

public UpdateVehiclePos(vehicleid, type)
{
        if(type == 1)
        {
            /*if(!StopCar(vehicleid))
            {
                SetTimerEx("UpdateVehiclePos", 10000, false, "ii", vehicleid, 1);
                return 1;
            }*/
            BanCar[vehicleid] = false;
        }
        GetVehiclePos(vehicleid, VehPos[vehicleid][0], VehPos[vehicleid][1], VehPos[vehicleid][2]);
        GetVehicleZAngle(vehicleid, VehPos[vehicleid][3]);
        return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat)
{
        new Float:Pos[3];
        GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
        new Float:Count[2];
        Count[0] = Difference(Pos[0],VehPos[vehicleid][0]);
        Count[1] = Difference(Pos[1],VehPos[vehicleid][1]);
        switch(GetVehicleModel(vehicleid))
        {
            case 435, 450, 584, 591, 606..608, 610..611: goto UPDATE;
        }
        if((Count[0] > 5 || Count[1] > 5) && !UseCar(vehicleid) && !BanCar[vehicleid])
        {
            SetVehiclePos(vehicleid, VehPos[vehicleid][0], VehPos[vehicleid][1], VehPos[vehicleid][2]);
            SetVehicleZAngle(vehicleid, VehPos[vehicleid][3]);
        }
        else
        {
            UPDATE:
            UpdateVehiclePos(vehicleid, 0);
        }
        return 1;
}

stock Difference(Float:Value1, Float:Value2)
{
        return floatround((Value1 > Value2) ? (Value1 - Value2) : (Value2 - Value1));
}

stock bool: UseCar(carid)
{
        for(new i; i != GetMaxPlayers(); i++)
        {
            if(!IsPlayerConnected(i)) continue;
            if(IsPlayerInVehicle(i, carid)) return true;
        }
        return false;
}

stock SetVehiclePosition(vehicleid, Float:X, Float:Y, Float:Z)
{
        SetVehiclePos(vehicleid ,X,Y,Z);
        UpdateVehiclePos(vehicleid, 0);
}

/*stock bool: StopCar(carid)
{
        new Float:Pos[3];
        GetVehicleVelocity(carid, Pos[0], Pos[1], Pos[2]);
        if(Pos[0] == 0.0 && Pos[1] == 0.0 && Pos[2] == 0.0) return true;
        return false;
}*/

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
      if(IsWeaponWithAmmo(weaponid))
      {
      	new count = 0;
      	if(weaponid != CurrentWeapon[playerid]) CurrentWeapon [playerid]= weaponid, CurrentAmmo [playerid]= GetPlayerWeaponAmmo(playerid,weaponid), count++;
      	if(GetPlayerWeaponAmmo(playerid,weaponid) > CurrentAmmo [playerid]|| GetPlayerWeaponAmmo(playerid,weaponid) < CurrentAmmo[playerid])
      	{
        	CurrentAmmo [playerid]= GetPlayerWeaponAmmo(playerid,weaponid);
        	NoReloading [playerid]= 0;
        	count++;
      	}
		if(GetPlayerWeaponAmmo(playerid,weaponid) != 0 && GetPlayerWeaponAmmo(playerid,weaponid) == CurrentAmmo [playerid]&& count == 0)
      	{
        	NoReloading[playerid]++;
        	if(NoReloading [playerid]>= 5)
        	{
       			NoReloading [playerid]= 0;
        		CurrentWeapon [playerid]= 0;
        		CurrentAmmo [playerid]= 0;
        		Kick(playerid);
        	}
      	}
      }
      return 1;
}

stock IsWeaponWithAmmo(weaponid)
{
    switch(weaponid)
    {
      case 16..18, 22..39, 41..42: return 1;
      default: return 0;
    }
    return 0;

}

stock GetPlayerWeaponAmmo(playerid,weaponid)
{
    new wd[2][13];
    for(new i; i<13; i++) GetPlayerWeaponData(playerid,i,wd[0][i],wd[1][i]);
    for(new i; i<13; i++)
    {
    if(weaponid == wd[0][i]) return wd[1][i];
    }
    return 0;
}

public pingchecktimer(playerid)
{
	if(GetPlayerPing(playerid) > 550) Kick(playerid);
	return 1;
}

public OnPlayerPickUpPickup(playerid,pickupid)
{
	if(pickupid == TT)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TT1)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT2)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT3)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT4)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT5)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TT6)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT7)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT8)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TT9)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TTT6)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT7)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT8)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT9)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TTT10)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT11)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT12)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT13)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT14)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT15)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT16)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT17)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT18)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT19)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	
	if(pickupid == TTT20)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT21)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT22)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT23)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT24)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT25)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT26)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT27)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT28)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT29)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT30)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT31)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT32)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT33)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}

	if(pickupid == TTT34)
	{
        if(Team[playerid] == HUMAN)
        {
        	SendClientMessage(playerid,purple,"Тебе лучше отойти, в любой момент отсюда может вылезти зомби!");
        }
		else
		{
  			ShowPlayerDialog(playerid, 1100, DSL, "Места канализаций", "Улей\nУлица Грув Стрит\nСтанция Юнити\nМаркет Станция\nГлен Парк\nВайнвуд\nЛос-Сантос Центр\nАэропорт Лос-Сантос\nПляж Санта-Мария\nGate-C", "ТП", "Закрыть");
		}
	}
	return 1;
}

CMD:hide(playerid,params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
        if(Team[playerid] == ZOMBIE)
        {
			SendClientMessage(playerid,purple,"* You have successfully hidden!");
			SendClientMessage(playerid,0xFFA000FF,"* Write /unhide to stop hidding!");
			SendClientMessage(playerid,red,"* NOTE: You cant bite while you are hidding!!!");
			ApplyAnimation(playerid,"CRACK", "CRCKDETH2", 2.0, 0, 0, 1, 500, 1);
			Delete3DTextLabel(PInfo[playerid][Ranklabel]);
            for(new i; i < MAX_PLAYERS;i++)
			{
				ShowPlayerNameTagForPlayer(i,playerid,0);
                PInfo[playerid][CanBite] = 0;
 			}
            for(new i; i < MAX_PLAYERS;i++)
			{
				 SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(playerid) & 0xFFFFFF00 ));
			}
		}
	}
	else
	{
		SendClientMessage(playerid,red,"* You cant't hide right now!");
 	}
 	return 1;
}

CMD:unhide(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
        if(Team[playerid] == ZOMBIE)
        ApplyAnimation(playerid,"Muscular","MuscleSprint",4.1,1,1,1,0,0,1);
		SendClientMessage(playerid,purple,"You have stopped hidding!");
        {
       		for(new i; i < MAX_PLAYERS;i++)
			{
				SetPlayerColor(playerid,purple);
				ShowPlayerNameTagForPlayer(i,playerid,1);
				PInfo[playerid][CanBite] = 1;
			}
		}
	}
	else
	{
		SendClientMessage(playerid,red,"You are not hidding!!");
 	}
 	return 1;
}
