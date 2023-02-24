 //======================= Inventory system copied =============================
#include <a_samp>
#include <SII>
#include <zcmd>
#include <sscanf2>
#include <GetVehicleColor>
#include <physics>
#include <j_inventory_v2>
#include <GetVehicleName>
#include <streamer>
#include <a_npc>
#include <Offsets>
#include <F_AntiCheat>
#include <a_objects>
#include <colors>
#include <streamer>
#include <gbug>
#include <MAP>

#define Userfile 														"Admin/Users/%s.ini"
#define snowing                                                         true
#define Version                                                         "2.0"
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
#define UltimateExtraMeds                                               24
#define Noperkdialog                                                    23
#define PowerfulGloves                                                  47
#define HellScream                                                      48
#define ThickSkin                                                       49
#define Hemorrage                                                       50


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
#define WeaponD                                                         1500
forward AnticheatSH();
forward OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
forward pingchecktimer(playerid);
forward DamageCheck(vehicleid,playerid);
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
#define DSTH                                                            DIALOG_STYLE_TABLIST_HEADERS
//============================== [Server config] ===============================
forward PHY_OnObjectUpdate(objectid);
forward PHY_OnObjectCollideWithObject(object1, object2); // low bound = 0, high bound = 1
forward PHY_OnObjectCollideWithSAWorld(objectid, Float:cx, Float:cy, Float:cz); // Only with ColAndreas
forward PHY_OnObjectCollideWithWall(objectid, wallid);
forward PHY_OnObjectCollideWithCylinder(objectid, cylinderid);
forward PHY_OnObjectCollideWithPlayer(objectid, playerid);
//============================== [Text Draw's] =================================
forward SaveDeathZombieLastPos(playerid);
forward UnFreezePlayer(playerid);
new Text:GainXPTD[MAX_PLAYERS];
new Text:RANKUP[MAX_PLAYERS];
new Text:Stats[MAX_PLAYERS];
new Text:XPStats[MAX_PLAYERS];
new Text:RANK[MAX_PLAYERS];
new Text:PERK[MAX_PLAYERS];
new Text:KILLS[MAX_PLAYERS];
new Text:DEATHS[MAX_PLAYERS];
new Text:TEAMKILLS[MAX_PLAYERS];
new Text:CPCLEARED[MAX_PLAYERS];
new Text:FLASHBANGS[MAX_PLAYERS];
new Text:FLAMEAMMO[MAX_PLAYERS];
new Text:SKILLPOINTS[MAX_PLAYERS];
new Text:FuelTD[MAX_PLAYERS];
new Text:OilTD[MAX_PLAYERS];
new Text:XPBox;
new Text:Infection;
new Text:CPSCleared;
new Text:RoundStats;
new Text:Effect[9];
new PlayerText:XPtextdraw[MAX_PLAYERS][5];
//============================== [Text Draw's] =================================
//=============================[Hemorrage Textdraws]============================
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11;
new Text:Textdraw12;
new Text:Textdraw13;
new Text:Textdraw14;
new Text:Textdraw15;
new Text:Textdraw16;
new Text:Textdraw17;
new Text:Textdraw18;
new Text:Textdraw19;
new Text:Textdraw20;
new Text:Textdraw21;
new Text:Textdraw22;
new Text:Textdraw23;
new Text:Textdraw24;
new Text:Textdraw25;
new Text:Textdraw26;
new Text:Textdraw27;
new Text:Textdraw28;
new Text:Textdraw29;
new Text:Textdraw30;
new Text:Textdraw31;
new Text:Textdraw32;
new Text:Textdraw33;
new Text:Textdraw34;
new Text:Textdraw35;
new Text:Textdraw36;
new Text:Textdraw37;
new Text:Textdraw38;
new Text:Textdraw39;
//=============================[Hemorrage Textdraws]============================
new Float:BegX[MAX_PLAYERS],Float:BegY[MAX_PLAYERS],Float:BegZ[MAX_PLAYERS];
new HUNTER;
new ZFPC2;
new ZFPC3;
new ZFPC4;
new ZFPC5;
new ZFPC6;
new ZFPC7;
new ZFPC8;
new ZFPC9;
new ZFPC10;
new InOneVehicle[MAX_PLAYERS];
new BaitThrowTimer4[MAX_PLAYERS];
new BaitThrowTimer3[MAX_PLAYERS];
new BaitThrowTimer2[MAX_PLAYERS];
new BaitThrowTimer1[MAX_PLAYERS];
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

new RandWeather[] = {7,9,19,20,22,276,367};
new RWeather;

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
	AfterLifeInfected,
	XP,
	Level,
	Premium,
	Failedlogins,
	Kills,
	Screameds,
	Infects,
	Deaths,
	Teamkills,
	Infected,//Dizzy
	CurrentXP,
	ShowingXP,
	SPerk,
	ZPerk,
	CanBite,
	CanBeSpitted,
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
 	Float:DX,
 	Float:DY,
 	Float:DZ,
	ZObject,
	ZCount,
	OnFire,
    FireMode,
    FireObject,
    TokeDizzy,
    CanJump,
    CanStomp,
	AllowedToBait,
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
	CanZombieRun,
	RunTimer,
	RunTimerActivated,
	Vomit,
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
	oslotglasses,
	oslothat,
	Swimming,
	CanPowerfulGloves,
	ThrowingBaitPhase1,
	ThrowingBaitPhase2,
	ThrowingBaitPhase3,
	ThrowingBaitPhase4,
	PowerfulGlovesTimer,
	CanZombieBaitTimer,
	CanStinger,
	CanUseWeapons,
	Warns,
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
 //Global variable!
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
new NZGate;
new NZGateOpened;
new gRandomSkin[] = {78,79,77,75,134,135,137,160,162,200,212,213,230,239};
new bRandomSkin[] = {1,2,3,4,5,6,7,8,9,10,279,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,76,80,81,82,83,84,85,86,87,88,89,90,92,93,94,95,96,97,98,99,100,101,128,129,130,131,132,133,136,138,139,140,141,142,143,144,145,146,147,
148,149,150,151,152,153,154,155,156,157,158,159,161,163,164,165,166,167,170,171,172,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,196,197,198,199,201,202,203,204,205,206,207,208,209,210,211,215,216,217,218,219,220,221,222,223,225,226,227,228,229,231,232,233,234,235,236,237,238,240,241,242,243,244,245,247,248,249,250,251,252,253,254,255,267,268,
289,290,291,293,295,296,297,298,299};

public OnGameModeInit()
{
	SendRconCommand("hostname Сергей Петух "Version"");
	SetGameModeText("LS Zombie Apocalypse");
	ConnectNPC("SGT_Soap","npc");
	HUNTER = CreateVehicle(425,1000,100,50,0,0,0,0);
	for(new i = 0; i < 312; i++)
    switch(i)
    {
        case 0,74,92,99,78,79,77,75,134,135,137,160,162,200,212,213,230,239: continue; 
        default:AddPlayerClass(i,0,0,0,0,0,0,0,0,0,0);
    }
   	for(new i = 0; i < 312; i++)
    switch(i)
    {
        case 78,79,77,75,134,135,137,160,162,200,212,213,230,239: AddPlayerClass(i,0,0,0,0,0,0,0,0,0,0);
        default:continue;
    }
    LoadObj();
	SetTimer("UpdateStats",2000,true);
	SetTimer("UpdateBait",400,true);
	//SetTimer("Marker",20000,true);
	SetTimer("Dizzy",60000,true);
	SetTimer("WeatherUpdate",53213561328321132132236535631265312658863528213,false);
	SetTimer("RandomCheckpoint",CPTIME,false);
	SetTimer("RandomSounds",120000,true);
	SetTimer("FiveSeconds",5000,true);
	//WeatherUpdate();
	LoadStaticVehicles();
	LimitPlayerMarkerRadius(100.0);
	CPID = -1;
	CPscleared = 0;
	RoundEnded = 0;
	NZGateOpened = 0;
	SetTimer("Anticheat",2000,1);
	new RandW = random(sizeof(RandWeather));
    SetWeather(RandWeather[RandW]);
    RWeather = RandWeather[RandW];
	EnableStuntBonusForAll(0);
	//Zombie Food
	ZFPC2 = CreatePickup(1318,3,1406.3240,-1450.8529,1721.7734);
	ZFPC3 = CreatePickup(1318,3,1397.7505,-1452.8732,1721.7734);
	ZFPC4 = CreatePickup(1318,3,1410.4015,-1468.5514,1721.7734);
	ZFPC5 = CreatePickup(1318,3,1398.8356,-1463.8278,1721.7734);
	ZFPC6 = CreatePickup(1318,3,1384.9185,-1463.2385,1721.7734);
	ZFPC7 = CreatePickup(1318,3,1371.3898,-1465.1289,1721.7734);
	ZFPC8 = CreatePickup(1318,3,1362.7053,-1445.1117,1721.7734);
	ZFPC9 = CreatePickup(1318,3,1405.1270,-1418.7037,1721.7734);
	ZFPC10 = CreatePickup(1318,3,1401.1051,-1425.9554,1721.7734);
	
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
		RANKUP[i] = TextDrawCreate(280.888824, 104.035560, "RANK UP!");
		TextDrawLetterSize(RANKUP[i], 0.647780, 0.295812);
		TextDrawAlignment(RANKUP[i], 1);
		TextDrawColor(RANKUP[i], -1);
		TextDrawSetShadow(RANKUP[i], 0);
		TextDrawSetOutline(RANKUP[i], 0);
		TextDrawBackgroundColor(RANKUP[i], 51);
		TextDrawFont(RANKUP[i], 1);
		TextDrawSetProportional(RANKUP[i], 1);
	
		GainXPTD[i] = TextDrawCreate(266.222320, 132.426788, "+10 XP");
		TextDrawLetterSize(GainXPTD[i], 0.862222, 0.614222);
		TextDrawAlignment(GainXPTD[i], 1);
		TextDrawColor(GainXPTD[i], -1);
		TextDrawSetShadow(GainXPTD[i], 0);
		TextDrawSetOutline(GainXPTD[i], 0);
		TextDrawBackgroundColor(GainXPTD[i], 255);
		TextDrawFont(GainXPTD[i], 1);
		TextDrawSetProportional(GainXPTD[i], 1);

        Stats[i] = TextDrawCreate(629.111450, 353.926513, "usebox");
		TextDrawLetterSize(Stats[i], 0.000000, 9.869014);
		TextDrawTextSize(Stats[i], 491.333679, 0.000000);
		TextDrawAlignment(Stats[i], 1);
		TextDrawColor(Stats[i], 0);
		TextDrawUseBox(Stats[i], true);
		TextDrawBoxColor(Stats[i], 102);
		TextDrawSetShadow(Stats[i], 0);
		TextDrawSetOutline(Stats[i], 0);
		TextDrawFont(Stats[i], 0);
		
		XPStats[i] = TextDrawCreate(265.333526, 428.586639, "XP:_15052 / 55000");
		TextDrawLetterSize(XPStats[i], 0.374889, 1.022578);
		TextDrawAlignment(XPStats[i], 1);
		TextDrawColor(XPStats[i], -1);
		TextDrawSetShadow(XPStats[i], -3);
		TextDrawSetOutline(XPStats[i], 0);
		TextDrawBackgroundColor(XPStats[i], 51);
		TextDrawFont(XPStats[i], 2);
		TextDrawSetProportional(XPStats[i], 1);
		
		RANK[i] = TextDrawCreate(496.444488, 353.919921, "RANK: 0");
		TextDrawLetterSize(RANK[i], 0.328666, 0.947912);
		TextDrawAlignment(RANK[i], 1);
		TextDrawColor(RANK[i], -1);
		TextDrawSetShadow(RANK[i], 0);
		TextDrawSetOutline(RANK[i], 0);
		TextDrawBackgroundColor(RANK[i], 51);
		TextDrawFont(RANK[i], 2);
		TextDrawSetProportional(RANK[i], 1);

		PERK[i] = TextDrawCreate(496.555572, 363.382110, "PERK: 1");
		TextDrawLetterSize(PERK[i], 0.328666, 0.947912);
		TextDrawAlignment(PERK[i], 1);
		TextDrawColor(PERK[i], -1);
		TextDrawSetShadow(PERK[i], 0);
		TextDrawSetOutline(PERK[i], 0);
		TextDrawBackgroundColor(PERK[i], 51);
		TextDrawFont(PERK[i], 2);
		TextDrawSetProportional(PERK[i], 1);

		KILLS[i] = TextDrawCreate(496.222167, 371.848693, "KILLS: 0");
		TextDrawLetterSize(KILLS[i], 0.328666, 0.947912);
		TextDrawAlignment(KILLS[i], 1);
		TextDrawColor(KILLS[i], -1);
		TextDrawSetShadow(KILLS[i], 0);
		TextDrawSetOutline(KILLS[i], 0);
		TextDrawBackgroundColor(KILLS[i], 51);
		TextDrawFont(KILLS[i], 2);
		TextDrawSetProportional(KILLS[i], 1);

		DEATHS[i] = TextDrawCreate(495.888793, 380.813079, "DEATHS: 0");
		TextDrawLetterSize(DEATHS[i], 0.328666, 0.947912);
		TextDrawAlignment(DEATHS[i], 1);
		TextDrawColor(DEATHS[i], -1);
		TextDrawSetShadow(DEATHS[i], 0);
		TextDrawSetOutline(DEATHS[i], 0);
		TextDrawBackgroundColor(DEATHS[i], 51);
		TextDrawFont(DEATHS[i], 2);
		TextDrawSetProportional(DEATHS[i], 1);

		TEAMKILLS[i] = TextDrawCreate(495.111022, 390.275421, "TEAM KILLS: 0");
		TextDrawLetterSize(TEAMKILLS[i], 0.328666, 0.947912);
		TextDrawAlignment(TEAMKILLS[i], 1);
		TextDrawColor(TEAMKILLS[i], -1);
		TextDrawSetShadow(TEAMKILLS[i], 0);
		TextDrawSetOutline(TEAMKILLS[i], 0);
		TextDrawBackgroundColor(TEAMKILLS[i], 51);
		TextDrawFont(TEAMKILLS[i], 2);
		TextDrawSetProportional(TEAMKILLS[i], 1);

		CPCLEARED[i] = TextDrawCreate(496.110900, 400.235321, "CP CLEARED: 0");
		TextDrawLetterSize(CPCLEARED[i], 0.328666, 0.947912);
		TextDrawAlignment(CPCLEARED[i], 1);
		TextDrawColor(CPCLEARED[i], -1);
		TextDrawSetShadow(CPCLEARED[i], 0);
		TextDrawSetOutline(CPCLEARED[i], 0);
		TextDrawBackgroundColor(CPCLEARED[i], 51);
		TextDrawFont(CPCLEARED[i], 2);
		TextDrawSetProportional(CPCLEARED[i], 1);

		FLASHBANGS[i] = TextDrawCreate(496.222015, 409.697540, "FLASHBANGS: 0");
		TextDrawLetterSize(FLASHBANGS[i], 0.328666, 0.947912);
		TextDrawAlignment(FLASHBANGS[i], 1);
		TextDrawColor(FLASHBANGS[i], -1);
		TextDrawSetShadow(FLASHBANGS[i], 0);
		TextDrawSetOutline(FLASHBANGS[i], 0);
		TextDrawBackgroundColor(FLASHBANGS[i], 51);
		TextDrawFont(FLASHBANGS[i], 2);
		TextDrawSetProportional(FLASHBANGS[i], 1);

		FLAMEAMMO[i] = TextDrawCreate(496.333099, 420.155273, "FLAME AMMO: 0");
		TextDrawLetterSize(FLAMEAMMO[i], 0.328666, 0.947912);
		TextDrawAlignment(FLAMEAMMO[i], 1);
		TextDrawColor(FLAMEAMMO[i], -1);
		TextDrawSetShadow(FLAMEAMMO[i], 0);
		TextDrawSetOutline(FLAMEAMMO[i], 0);
		TextDrawBackgroundColor(FLAMEAMMO[i], 51);
		TextDrawFont(FLAMEAMMO[i], 2);
		TextDrawSetProportional(FLAMEAMMO[i], 1);

		SKILLPOINTS[i] = TextDrawCreate(495.999786, 431.110809, "SKILL POINTS: 0");
		TextDrawLetterSize(SKILLPOINTS[i], 0.328666, 0.947912);
		TextDrawAlignment(SKILLPOINTS[i], 1);
		TextDrawColor(SKILLPOINTS[i], -1);
		TextDrawSetShadow(SKILLPOINTS[i], 0);
		TextDrawSetOutline(SKILLPOINTS[i], 0);
		TextDrawBackgroundColor(SKILLPOINTS[i], 51);
		TextDrawFont(SKILLPOINTS[i], 2);
		TextDrawSetProportional(SKILLPOINTS[i], 1);
		
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
	    Fuel[i] = randomEx(1,6);
		Oil[i] = randomEx(1,6);
		StartVehicle(i,0);
		VehicleStarted[i] = 0;
	}
	
	CPSCleared = TextDrawCreate(497.778076, 99.555580, "CheckPoints Cleared: 0/~r~~h~8");
	TextDrawLetterSize(CPSCleared, 0.225999, 1.127110);
	TextDrawAlignment(CPSCleared, 1);
	TextDrawColor(CPSCleared, -1);
	TextDrawSetShadow(CPSCleared, 0);
	TextDrawSetOutline(CPSCleared, 1);
	TextDrawBackgroundColor(CPSCleared, 255);
	TextDrawFont(CPSCleared, 2);
	TextDrawSetProportional(CPSCleared, 1);

	Infection = TextDrawCreate(497.777496, 108.864097, "Infection: ~r~~h~0%");
	TextDrawLetterSize(Infection, 0.293733, 1.208247);
	TextDrawAlignment(Infection, 1);
	TextDrawColor(Infection, -1);
	TextDrawSetShadow(Infection, 0);
	TextDrawSetOutline(Infection, 1);
	TextDrawBackgroundColor(Infection, 255);
	TextDrawFont(Infection, 2);
	TextDrawSetProportional(Infection, 1);

	XPBox = TextDrawCreate(461.999847, 426.602172, "usebox");
	TextDrawLetterSize(XPBox, 0.000000, 1.684322);
	TextDrawTextSize(XPBox, 166.000091, 0.000000);
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
	
	Textdraw0 = TextDrawCreate(413.333496, 223.004379, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw0, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw0, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw0, 1);
	TextDrawColor(Textdraw0, -1);
	TextDrawUseBox(Textdraw0, true);
	TextDrawBoxColor(Textdraw0, 0);
	TextDrawBackgroundColor(Textdraw0, 0x00000000);
	TextDrawSetShadow(Textdraw0, 0);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawFont(Textdraw0, 5);
	TextDrawSetPreviewModel(Textdraw0, 19836);
	TextDrawSetPreviewRot(Textdraw0, 121.000000, 13.000000, 15.000000, 1.000000);

	Textdraw1 = TextDrawCreate(-57.666526, 208.075515, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw1, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw1, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw1, 1);
	TextDrawColor(Textdraw1, -1);
	TextDrawUseBox(Textdraw1, true);
	TextDrawBoxColor(Textdraw1, 0);
	TextDrawSetShadow(Textdraw1, 0);
	TextDrawBackgroundColor(Textdraw1, 0x00000000);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawFont(Textdraw1, 5);
	TextDrawSetPreviewModel(Textdraw1, 19836);
	TextDrawSetPreviewRot(Textdraw1, 25.000000, 13.000000, 15.000000, 2.000000);

	Textdraw2 = TextDrawCreate(371.777954, 94.088844, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw2, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw2, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColor(Textdraw2, -1);
	TextDrawUseBox(Textdraw2, true);
	TextDrawBackgroundColor(Textdraw2, 0x00000000);
	TextDrawBoxColor(Textdraw2, 0);
	TextDrawSetShadow(Textdraw2, 0);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawFont(Textdraw2, 5);
	TextDrawSetPreviewModel(Textdraw2, 19836);
	TextDrawSetPreviewRot(Textdraw2, 13122.000000, 13.000000, 15.000000, 2.000000);

	Textdraw3 = TextDrawCreate(171.888977, -106.013412, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw3, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw3, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw3, 1);
	TextDrawColor(Textdraw3, -1);
	TextDrawUseBox(Textdraw3, true);
	TextDrawBoxColor(Textdraw3, 0);
	TextDrawSetShadow(Textdraw3, 0);
	TextDrawSetOutline(Textdraw3, 0);
	TextDrawFont(Textdraw3, 5);
	TextDrawBackgroundColor(Textdraw3, 0x00000000);
	TextDrawSetPreviewModel(Textdraw3, 19836);
	TextDrawSetPreviewRot(Textdraw3, 25.000000, 13.000000, 15.000000, 2.000000);

	Textdraw4 = TextDrawCreate(476.000244, 315.608856, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw4, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw4, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw4, 1);
	TextDrawColor(Textdraw4, -1);
	TextDrawUseBox(Textdraw4, true);
	TextDrawBoxColor(Textdraw4, 0);
	TextDrawSetShadow(Textdraw4, 0);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawFont(Textdraw4, 5);
	TextDrawBackgroundColor(Textdraw4, 0x00000000);
	TextDrawSetPreviewModel(Textdraw4, 19836);
	TextDrawSetPreviewRot(Textdraw4, 25.000000, 13.000000, 15.000000, 2.000000);

	Textdraw5 = TextDrawCreate(-147.444259, 36.342082, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw5, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw5, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw5, 1);
	TextDrawColor(Textdraw5, -1);
	TextDrawUseBox(Textdraw5, true);
	TextDrawBoxColor(Textdraw5, 0);
	TextDrawSetShadow(Textdraw5, 0);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawBackgroundColor(Textdraw5, 0x00000000);
	TextDrawFont(Textdraw5, 5);
	TextDrawSetPreviewModel(Textdraw5, 19836);
	TextDrawSetPreviewRot(Textdraw5, 121.000000, 13.000000, 15.000000, 1.000000);

	Textdraw6 = TextDrawCreate(158.889053, 301.662017, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw6, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw6, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw6, 1);
	TextDrawColor(Textdraw6, -1);
	TextDrawUseBox(Textdraw6, true);
	TextDrawBoxColor(Textdraw6, 0);
	TextDrawSetShadow(Textdraw6, 0);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawFont(Textdraw6, 5);
	TextDrawBackgroundColor(Textdraw6, 0x00000000);
	TextDrawSetPreviewModel(Textdraw6, 19836);
	TextDrawSetPreviewRot(Textdraw6, 15.000000, 13.000000, 15.000000, 1.000000);

	Textdraw7 = TextDrawCreate(69.444587, 13.942190, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw7, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw7, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw7, 1);
	TextDrawColor(Textdraw7, -1);
	TextDrawUseBox(Textdraw7, true);
	TextDrawBackgroundColor(Textdraw7, 0x00000000);
	TextDrawBoxColor(Textdraw7, 0);
	TextDrawSetShadow(Textdraw7, 0);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawFont(Textdraw7, 5);
	TextDrawSetPreviewModel(Textdraw7, 19836);
	TextDrawSetPreviewRot(Textdraw7, 8.000000, 0.000000, 0.000000, 1.000000);

	Textdraw8 = TextDrawCreate(426.444580, 151.831024, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw8, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw8, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw8, 1);
	TextDrawColor(Textdraw8, -1);
	TextDrawUseBox(Textdraw8, true);
	TextDrawBoxColor(Textdraw8, 0);
	TextDrawSetShadow(Textdraw8, 0);
	TextDrawSetOutline(Textdraw8, 0);
	TextDrawBackgroundColor(Textdraw8, 0x00000000);
	TextDrawFont(Textdraw8, 5);
	TextDrawSetPreviewModel(Textdraw8, 19836);
	TextDrawSetPreviewRot(Textdraw8, 8.000000, 0.000000, 0.000000, 1.000000);

	Textdraw9 = TextDrawCreate(6.555710, 261.844329, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw9, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw9, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw9, 1);
	TextDrawColor(Textdraw9, -1);
	TextDrawUseBox(Textdraw9, true);
	TextDrawBoxColor(Textdraw9, 0);
	TextDrawSetShadow(Textdraw9, 0);
	TextDrawSetOutline(Textdraw9, 0);
	TextDrawBackgroundColor(Textdraw9, 0x00000000);
	TextDrawFont(Textdraw9, 5);
	TextDrawSetPreviewModel(Textdraw9, 19836);
	TextDrawSetPreviewRot(Textdraw9, 8.000000, 0.000000, 0.000000, 1.000000);

	Textdraw10 = TextDrawCreate(507.555725, -119.946792, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw10, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw10, 295.999877, 255.857772);
	TextDrawAlignment(Textdraw10, 1);
	TextDrawColor(Textdraw10, -1);
	TextDrawUseBox(Textdraw10, true);
	TextDrawBoxColor(Textdraw10, 0);
	TextDrawSetShadow(Textdraw10, 0);
	TextDrawSetOutline(Textdraw10, 0);
	TextDrawBackgroundColor(Textdraw10, 0x00000000);
	TextDrawFont(Textdraw10, 5);
	TextDrawSetPreviewModel(Textdraw10, 19836);
	TextDrawSetPreviewRot(Textdraw10, 8.000000, 0.000000, 0.000000, 1.000000);

	Textdraw11 = TextDrawCreate(190.333541, 146.866500, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw11, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw11, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw11, 1);
	TextDrawColor(Textdraw11, -1);
	TextDrawUseBox(Textdraw11, true);
	TextDrawBoxColor(Textdraw11, 0);
	TextDrawSetShadow(Textdraw11, 0);
	TextDrawSetOutline(Textdraw11, 0);
	TextDrawBackgroundColor(Textdraw11, 0x00000000);
	TextDrawFont(Textdraw11, 5);
	TextDrawSetPreviewModel(Textdraw11, 19836);
	TextDrawSetPreviewRot(Textdraw11, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw12 = TextDrawCreate(-158.888580, 329.555389, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw12, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw12, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw12, 1);
	TextDrawColor(Textdraw12, -1);
	TextDrawUseBox(Textdraw12, true);
	TextDrawBoxColor(Textdraw12, 0);
	TextDrawSetShadow(Textdraw12, 0);
	TextDrawSetOutline(Textdraw12, 0);
	TextDrawFont(Textdraw12, 5);
	TextDrawBackgroundColor(Textdraw12, 0x00000000);
	TextDrawSetPreviewModel(Textdraw12, 19836);
	TextDrawSetPreviewRot(Textdraw12, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw13 = TextDrawCreate(-235.221939, -157.764617, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw13, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw13, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw13, 1);
	TextDrawColor(Textdraw13, -1);
	TextDrawUseBox(Textdraw13, true);
	TextDrawBoxColor(Textdraw13, 0);
	TextDrawSetShadow(Textdraw13, 0);
	TextDrawBackgroundColor(Textdraw13, 0x00000000);
	TextDrawSetOutline(Textdraw13, 0);
	TextDrawFont(Textdraw13, 5);
	TextDrawSetPreviewModel(Textdraw13, 19836);
	TextDrawSetPreviewRot(Textdraw13, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw14 = TextDrawCreate(314.222534, -207.040176, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw14, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw14, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw14, 1);
	TextDrawColor(Textdraw14, -1);
	TextDrawUseBox(Textdraw14, true);
	TextDrawBoxColor(Textdraw14, 0);
	TextDrawSetShadow(Textdraw14, 0);
	TextDrawSetOutline(Textdraw14, 0);
	TextDrawBackgroundColor(Textdraw14, 0x00000000);
	TextDrawFont(Textdraw14, 5);
	TextDrawSetPreviewModel(Textdraw14, 19836);
	TextDrawSetPreviewRot(Textdraw14, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw15 = TextDrawCreate(509.000335, -33.809070, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw15, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw15, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw15, 1);
	TextDrawColor(Textdraw15, -1);
	TextDrawUseBox(Textdraw15, true);
	TextDrawBoxColor(Textdraw15, 0);
	TextDrawSetShadow(Textdraw15, 0);
	TextDrawSetOutline(Textdraw15, 0);
	TextDrawBackgroundColor(Textdraw15, 0x00000000);
	TextDrawFont(Textdraw15, 5);
	TextDrawSetPreviewModel(Textdraw15, 19836);
	TextDrawSetPreviewRot(Textdraw15, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw16 = TextDrawCreate(358.889282, 334.053131, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw16, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw16, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw16, 1);
	TextDrawColor(Textdraw16, -1);
	TextDrawUseBox(Textdraw16, true);
	TextDrawBoxColor(Textdraw16, 0);
	TextDrawSetShadow(Textdraw16, 0);
	TextDrawBackgroundColor(Textdraw16, 0x00000000);
	TextDrawSetOutline(Textdraw16, 0);
	TextDrawFont(Textdraw16, 5);
	TextDrawSetPreviewModel(Textdraw16, 19836);
	TextDrawSetPreviewRot(Textdraw16, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw17 = TextDrawCreate(248.778182, 351.479705, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw17, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw17, 394.222015, 325.049041);
	TextDrawAlignment(Textdraw17, 1);
	TextDrawColor(Textdraw17, -1);
	TextDrawUseBox(Textdraw17, true);
	TextDrawBoxColor(Textdraw17, 0);
	TextDrawSetShadow(Textdraw17, 0);
	TextDrawBackgroundColor(Textdraw17, 0x00000000);
	TextDrawSetOutline(Textdraw17, 0);
	TextDrawFont(Textdraw17, 5);
	TextDrawSetPreviewModel(Textdraw17, 19836);
	TextDrawSetPreviewRot(Textdraw17, 229.000000, 15.000000, 25.000000, 1.000000);

	Textdraw18 = TextDrawCreate(60.000270, 97.119750, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw18, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw18, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw18, 1);
	TextDrawColor(Textdraw18, -1);
	TextDrawUseBox(Textdraw18, true);
	TextDrawBoxColor(Textdraw18, 0);
	TextDrawBackgroundColor(Textdraw18, 0x00000000);
	TextDrawSetShadow(Textdraw18, 0);
	TextDrawSetOutline(Textdraw18, 0);
	TextDrawFont(Textdraw18, 5);
	TextDrawSetPreviewModel(Textdraw18, 19836);
	TextDrawSetPreviewRot(Textdraw18, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw19 = TextDrawCreate(378.778076, -24.333578, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw19, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw19, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw19, 1);
	TextDrawColor(Textdraw19, -1);
	TextDrawUseBox(Textdraw19, true);
	TextDrawBoxColor(Textdraw19, 0);
	TextDrawSetShadow(Textdraw19, 0);
	TextDrawSetOutline(Textdraw19, 0);
	TextDrawFont(Textdraw19, 5);
	TextDrawSetPreviewModel(Textdraw19, 19836);
	TextDrawBackgroundColor(Textdraw19, 0x00000000);
	TextDrawSetPreviewRot(Textdraw19, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw20 = TextDrawCreate(133.111373, 180.755340, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw20, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw20, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw20, 1);
	TextDrawColor(Textdraw20, -1);
	TextDrawUseBox(Textdraw20, true);
	TextDrawBoxColor(Textdraw20, 0);
	TextDrawSetShadow(Textdraw20, 0);
	TextDrawSetOutline(Textdraw20, 0);
	TextDrawFont(Textdraw20, 5);
	TextDrawSetPreviewModel(Textdraw20, 19836);
	TextDrawBackgroundColor(Textdraw20, 0x00000000);
	TextDrawSetPreviewRot(Textdraw20, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw21 = TextDrawCreate(-106.333084, 160.350906, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw21, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw21, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw21, 1);
	TextDrawColor(Textdraw21, -1);
	TextDrawUseBox(Textdraw21, true);
	TextDrawBoxColor(Textdraw21, 0);
	TextDrawSetShadow(Textdraw21, 0);
	TextDrawSetOutline(Textdraw21, 0);
	TextDrawFont(Textdraw21, 5);
	TextDrawSetPreviewModel(Textdraw21, 19836);
	TextDrawBackgroundColor(Textdraw21, 0x00000000);
	TextDrawSetPreviewRot(Textdraw21, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw22 = TextDrawCreate(306.666900, 56.817550, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw22, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw22, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw22, 1);
	TextDrawColor(Textdraw22, -1);
	TextDrawUseBox(Textdraw22, true);
	TextDrawBoxColor(Textdraw22, 0);
	TextDrawSetShadow(Textdraw22, 0);
	TextDrawSetOutline(Textdraw22, 0);
	TextDrawFont(Textdraw22, 5);
	TextDrawSetPreviewModel(Textdraw22, 19836);
	TextDrawBackgroundColor(Textdraw22, 0x00000000);
	TextDrawSetPreviewRot(Textdraw22, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw23 = TextDrawCreate(90.777984, -54.182445, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw23, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw23, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw23, 1);
	TextDrawColor(Textdraw23, -1);
	TextDrawUseBox(Textdraw23, true);
	TextDrawBoxColor(Textdraw23, 0);
	TextDrawSetShadow(Textdraw23, 0);
	TextDrawBackgroundColor(Textdraw23, 0x00000000);
	TextDrawSetOutline(Textdraw23, 0);
	TextDrawFont(Textdraw23, 5);
	TextDrawSetPreviewModel(Textdraw23, 19836);
	TextDrawSetPreviewRot(Textdraw23, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw24 = TextDrawCreate(496.222412, 63.795333, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw24, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw24, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw24, 1);
	TextDrawColor(Textdraw24, -1);
	TextDrawUseBox(Textdraw24, true);
	TextDrawBackgroundColor(Textdraw24, 0x00000000);
	TextDrawBoxColor(Textdraw24, 0);
	TextDrawSetShadow(Textdraw24, 0);
	TextDrawSetOutline(Textdraw24, 0);
	TextDrawFont(Textdraw24, 5);
	TextDrawSetPreviewModel(Textdraw24, 19836);
	TextDrawSetPreviewRot(Textdraw24, 15.000000, 0.000000, 2.000000, 1.000000);

	Textdraw25 = TextDrawCreate(479.000183, -26.297996, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw25, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw25, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw25, 1);
	TextDrawColor(Textdraw25, -1);
	TextDrawUseBox(Textdraw25, true);
	TextDrawBoxColor(Textdraw25, 0);
	TextDrawSetShadow(Textdraw25, 0);
	TextDrawSetOutline(Textdraw25, 0);
	TextDrawBackgroundColor(Textdraw25, 0x00000000);
	TextDrawFont(Textdraw25, 5);
	TextDrawSetPreviewModel(Textdraw25, 19836);
	TextDrawSetPreviewRot(Textdraw25, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw26 = TextDrawCreate(352.000152, 110.097564, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw26, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw26, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw26, 1);
	TextDrawColor(Textdraw26, -1);
	TextDrawUseBox(Textdraw26, true);
	TextDrawBoxColor(Textdraw26, 0);
	TextDrawSetShadow(Textdraw26, 0);
	TextDrawSetOutline(Textdraw26, 0);
	TextDrawFont(Textdraw26, 5);
	TextDrawSetPreviewModel(Textdraw26, 19836);
	TextDrawBackgroundColor(Textdraw26, 0x00000000);
	TextDrawSetPreviewRot(Textdraw26, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw27 = TextDrawCreate(21.889022, -10.857992, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw27, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw27, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw27, 1);
	TextDrawColor(Textdraw27, -1);
	TextDrawUseBox(Textdraw27, true);
	TextDrawBoxColor(Textdraw27, 0);
	TextDrawSetShadow(Textdraw27, 0);
	TextDrawSetOutline(Textdraw27, 0);
	TextDrawBackgroundColor(Textdraw27, 0x00000000);
	TextDrawFont(Textdraw27, 5);
	TextDrawSetPreviewModel(Textdraw27, 19836);
	TextDrawSetPreviewRot(Textdraw27, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw28 = TextDrawCreate(-1.555413, 177.306442, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw28, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw28, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw28, 1);
	TextDrawColor(Textdraw28, -1);
	TextDrawUseBox(Textdraw28, true);
	TextDrawBoxColor(Textdraw28, 0);
	TextDrawSetShadow(Textdraw28, 0);
	TextDrawSetOutline(Textdraw28, 0);
	TextDrawBackgroundColor(Textdraw28, 0x00000000);
	TextDrawFont(Textdraw28, 5);
	TextDrawSetPreviewModel(Textdraw28, 19836);
	TextDrawSetPreviewRot(Textdraw28, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw29 = TextDrawCreate(-123.666557, 251.479782, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw29, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw29, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw29, 1);
	TextDrawColor(Textdraw29, -1);
	TextDrawUseBox(Textdraw29, true);
	TextDrawBoxColor(Textdraw29, 0);
	TextDrawSetShadow(Textdraw29, 0);
	TextDrawSetOutline(Textdraw29, 0);
	TextDrawBackgroundColor(Textdraw29, 0x00000000);
	TextDrawFont(Textdraw29, 5);
	TextDrawSetPreviewModel(Textdraw29, 19836);
	TextDrawSetPreviewRot(Textdraw29, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw30 = TextDrawCreate(167.111221, 121.066444, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw30, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw30, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw30, 1);
	TextDrawColor(Textdraw30, -1);
	TextDrawUseBox(Textdraw30, true);
	TextDrawBoxColor(Textdraw30, 0);
	TextDrawSetShadow(Textdraw30, 0);
	TextDrawSetOutline(Textdraw30, 0);
	TextDrawBackgroundColor(Textdraw30, 0x00000000);
	TextDrawFont(Textdraw30, 5);
	TextDrawSetPreviewModel(Textdraw30, 19836);
	TextDrawSetPreviewRot(Textdraw30, 61.000000, 0.000000, 2.000000, 1.000000);

	Textdraw31 = TextDrawCreate(261.000122, 0.110886, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw31, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw31, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw31, 1);
	TextDrawColor(Textdraw31, -1);
	TextDrawUseBox(Textdraw31, true);
	TextDrawBoxColor(Textdraw31, 0);
	TextDrawSetShadow(Textdraw31, 0);
	TextDrawSetOutline(Textdraw31, 0);
	TextDrawBackgroundColor(Textdraw31, 0x00000000);
	TextDrawFont(Textdraw31, 5);
	TextDrawSetPreviewModel(Textdraw31, 19836);
	TextDrawSetPreviewRot(Textdraw31, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw32 = TextDrawCreate(403.333496, 35.457553, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw32, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw32, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw32, 1);
	TextDrawColor(Textdraw32, -1);
	TextDrawUseBox(Textdraw32, true);
	TextDrawBoxColor(Textdraw32, 0);
	TextDrawSetShadow(Textdraw32, 0);
	TextDrawSetOutline(Textdraw32, 0);
	TextDrawFont(Textdraw32, 5);
	TextDrawBackgroundColor(Textdraw32, 0x00000000);
	TextDrawSetPreviewModel(Textdraw32, 19836);
	TextDrawSetPreviewRot(Textdraw32, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw33 = TextDrawCreate(341.666809, -76.040245, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw33, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw33, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw33, 1);
	TextDrawColor(Textdraw33, -1);
	TextDrawUseBox(Textdraw33, true);
	TextDrawBoxColor(Textdraw33, 0);
	TextDrawSetShadow(Textdraw33, 0);
	TextDrawSetOutline(Textdraw33, 0);
	TextDrawFont(Textdraw33, 5);
	TextDrawBackgroundColor(Textdraw33, 0x00000000);
	TextDrawSetPreviewModel(Textdraw33, 19836);
	TextDrawSetPreviewRot(Textdraw33, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw34 = TextDrawCreate(146.666793, -16.302473, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw34, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw34, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw34, 1);
	TextDrawColor(Textdraw34, -1);
	TextDrawUseBox(Textdraw34, true);
	TextDrawBoxColor(Textdraw34, 0);
	TextDrawSetShadow(Textdraw34, 0);
	TextDrawSetOutline(Textdraw34, 0);
	TextDrawFont(Textdraw34, 5);
	TextDrawSetPreviewModel(Textdraw34, 19836);
	TextDrawBackgroundColor(Textdraw34, 0x00000000);
	TextDrawSetPreviewRot(Textdraw34, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw35 = TextDrawCreate(180.555633, -104.404716, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw35, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw35, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw35, 1);
	TextDrawColor(Textdraw35, -1);
	TextDrawUseBox(Textdraw35, true);
	TextDrawBoxColor(Textdraw35, 0);
	TextDrawSetShadow(Textdraw35, 0);
	TextDrawSetOutline(Textdraw35, 0);
	TextDrawFont(Textdraw35, 5);
	TextDrawSetPreviewModel(Textdraw35, 19836);
	TextDrawBackgroundColor(Textdraw35, 0x00000000);
	TextDrawSetPreviewRot(Textdraw35, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw36 = TextDrawCreate(84.222312, -85.982490, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw36, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw36, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw36, 1);
	TextDrawColor(Textdraw36, -1);
	TextDrawUseBox(Textdraw36, true);
	TextDrawBoxColor(Textdraw36, 0);
	TextDrawSetShadow(Textdraw36, 0);
	TextDrawSetOutline(Textdraw36, 0);
	TextDrawFont(Textdraw36, 5);
	TextDrawBackgroundColor(Textdraw36, 0x00000000);
	TextDrawSetPreviewModel(Textdraw36, 19836);
	TextDrawSetPreviewRot(Textdraw36, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw37 = TextDrawCreate(131.000076, 229.613067, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw37, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw37, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw37, 1);
	TextDrawColor(Textdraw37, -1);
	TextDrawUseBox(Textdraw37, true);
	TextDrawBoxColor(Textdraw37, 0);
	TextDrawSetShadow(Textdraw37, 0);
	TextDrawSetOutline(Textdraw37, 0);
	TextDrawBackgroundColor(Textdraw37, 0x00000000);
	TextDrawFont(Textdraw37, 5);
	TextDrawSetPreviewModel(Textdraw37, 19836);
	TextDrawSetPreviewRot(Textdraw37, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw38 = TextDrawCreate(366.666809, 308.266418, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw38, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw38, 186.222030, 187.164535);
	TextDrawAlignment(Textdraw38, 1);
	TextDrawBackgroundColor(Textdraw38, 0x00000000);
	TextDrawColor(Textdraw38, -1);
	TextDrawUseBox(Textdraw38, true);
	TextDrawBoxColor(Textdraw38, 0);
	TextDrawSetShadow(Textdraw38, 0);
	TextDrawSetOutline(Textdraw38, 0);
	TextDrawFont(Textdraw38, 5);
	TextDrawSetPreviewModel(Textdraw38, 19836);
	TextDrawSetPreviewRot(Textdraw38, 61.000000, 0.000000, 2.000000, 2.000000);

	Textdraw39 = TextDrawCreate(363.666809, 37.479770, "particle:bloodpool_64");
	TextDrawLetterSize(Textdraw39, 0.141776, 1.398754);
	TextDrawTextSize(Textdraw39, 186.222030, 187.164535);
	TextDrawBackgroundColor(Textdraw39, 0x00000000);
	TextDrawAlignment(Textdraw39, 1);
	TextDrawColor(Textdraw39, -1);
	TextDrawUseBox(Textdraw39, true);
	TextDrawBoxColor(Textdraw39, 0);
	TextDrawSetShadow(Textdraw39, 0);
	TextDrawSetOutline(Textdraw39, 0);
	TextDrawFont(Textdraw39, 5);
	TextDrawSetPreviewModel(Textdraw39, 19836);
	TextDrawSetPreviewRot(Textdraw39, 61.000000, 0.000000, 2.000000, 2.000000);
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
	SetPlayerWeather(playerid,RWeather);
	switch(classid)
	{
	    case 0..293: Team[playerid] = HUMAN,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~g~~h~Выжиший",3000,3);
	    case 294..311: Team[playerid] = ZOMBIE,GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~p~Зомби",3000,3);
	    //case 0,74,92,99,78,79,77,75,134,135,137,160,162,200,212,213,230,239:
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid))
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //Получает имя игрока (NPC).
        if(!strcmp(npcname, "SGT_Soap", true)) //Проверяет если имя MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, HUNTER, 0); //Помещает NPC в транспорт, который мы создали выше.
        }
        return 1;
    }
	if(PInfo[playerid][AfterLifeInfected] == 1)
   	{
        TeleportToLastPos(playerid);
   		SetPlayerColor(playerid,purple);
	    SetPlayerArmour(playerid,0);
	    SetPlayerHealth(playerid,100.0);
        new RandomGS = random(sizeof(gRandomSkin));
        PInfo[playerid][AfterLifeInfected] = 0;
        SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
        SetPlayerWeather(playerid,188);
	}
	else if(PInfo[playerid][AfterLifeInfected] == 0)
	{
		SetPVarInt(playerid,"K_Times",0);
		if(IsPlayerNPC(playerid))return 1;
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
				SetPlayerWeather(playerid,RWeather);
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
				SetPlayerWeather(playerid,RWeather);
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
		    }
			SetPlayerWeather(playerid,RWeather);
		}
	    if(Team[playerid] == ZOMBIE)
	    {
	        SetPlayerFacingAngle(playerid,86.4572);
	        SetPlayerWeather(playerid,188);
	        SetPlayerTime(playerid,23,0);
	  		new rand = random(11);
			switch(rand)
			{
			    case 0: SetPlayerPos(playerid,1401.5406,-1466.9052,1723.5464);
				case 1: SetPlayerPos(playerid,1410.3510,-1466.0276,1723.5464);
				case 2: SetPlayerPos(playerid,1415.7129,-1452.5636,1723.5464);
				case 3: SetPlayerPos(playerid,1412.5336,-1440.9100,1723.5464);
				case 4: SetPlayerPos(playerid,1397.1378,-1436.0222,1723.5464);
				case 5: SetPlayerPos(playerid,1388.0233,-1438.6526,1723.5464);
				case 6: SetPlayerPos(playerid,1381.9015,-1442.5560,1723.5464);
				case 7: SetPlayerPos(playerid,1380.9508,-1457.2130,1723.5464);
				case 8: SetPlayerPos(playerid,1395.4236,-1457.3495,1723.5464);
				case 9: SetPlayerPos(playerid,1399.8475,-1466.8781,1723.5464);
				case 10: SetPlayerPos(playerid,1404.1053,-1453.0607,1723.5464);
			}
	        TogglePlayerControllable(playerid, 0);
			SetTimerEx("UnFreezePlayer", 3000, false, "i", playerid);
			if(PInfo[playerid][JustInfected] == 1)
		    {
				random(11);
				switch(rand)
				{
				    case 0: SetPlayerPos(playerid,1401.5406,-1466.9052,1723.5464);
					case 1: SetPlayerPos(playerid,1410.3510,-1466.0276,1723.5464);
					case 2: SetPlayerPos(playerid,1415.7129,-1452.5636,1723.5464);
					case 3: SetPlayerPos(playerid,1412.5336,-1440.9100,1723.5464);
					case 4: SetPlayerPos(playerid,1397.1378,-1436.0222,1723.5464);
					case 5: SetPlayerPos(playerid,1388.0233,-1438.6526,1723.5464);
					case 6: SetPlayerPos(playerid,1381.9015,-1442.5560,1723.5464);
					case 7: SetPlayerPos(playerid,1380.9508,-1457.2130,1723.5464);
					case 8: SetPlayerPos(playerid,1395.4236,-1457.3495,1723.5464);
					case 9: SetPlayerPos(playerid,1399.8475,-1466.8781,1723.5464);
					case 10: SetPlayerPos(playerid,1404.1053,-1453.0607,1723.5464);
				}
		        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
		    }
		    static file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			if(INI_ReadInt("ZSkin") != 0) SetPlayerSkin(playerid,INI_ReadInt("ZSkin"));
			INI_Close();
		    SetPlayerColor(playerid,purple);
		    SetPlayerArmour(playerid,0);
		    SetPlayerHealth(playerid,100.0);
	    }
		StopAudioStreamForPlayer(playerid);
		PInfo[playerid][Dead] = 0;
		SetPlayerColor(playerid,(GetPlayerColor(playerid) & 0xFFFFFFFF));
		SetPlayerCP(playerid);
	}
	TextDrawShowForPlayer(playerid,CPSCleared);
	TextDrawShowForPlayer(playerid,Infection);
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
	//if(GetPVarInt(playerid,"K_Times") > 1) return Kick(playerid);
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
	
    /*if((Team[playerid] == HUMAN))
    {
    	if(PInfo[playerid][Infected] == 1)
    	{
			switch(reason)
			{
			    case 49,50,51,53,54,255:
				{
	   				InfectPlayer(playerid);
	   				PInfo[playerid][AfterLifeInfected] = 1;
				}
			}
		}
    }*/
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
	KillTimer(PInfo[playerid][PowerfulGlovesTimer]);
	KillTimer(PInfo[playerid][CanZombieBaitTimer]);
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
	SetTimerEx("pingchecktimer", 15000, false, "i",playerid);
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
    if(!IsPlayerNPC(playerid)) PlayersConnected++;
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
       		static string[90];
 			format(string,sizeof string,""cblue"Welcome back, %s.",GetPName(playerid));
			SendClientMessage(playerid,white,string);
		}
		INI_Close();
	}
	else
	{
	    if(!IsPlayerNPC(playerid))
	    {
			ShowPlayerDialog(playerid,Registerdialog,3,"Register",""cwhite"Добро пожаловать! \nЧтобы играть на сервере, нужно зарегистрироваться! \nПридумайте пароль и впышите его нижей \n","Регистрация","Отмена");
	        SendClientMessage(playerid,green,"Welcome To Los Santos Zombie Apocalypse!");
		}
	}
	PInfo[playerid][Logged] = 0;
	PInfo[playerid][Failedlogins] = 0;
	PInfo[playerid][CanBite] = 1;
	PInfo[playerid][CanSpit] = 1;
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
    PInfo[playerid][ThrowingBaitPhase1] = 1;
    PInfo[playerid][ThrowingBaitPhase2] = 1;
    PInfo[playerid][ThrowingBaitPhase3] = 1;
    PInfo[playerid][ThrowingBaitPhase4] = 1;
	PInfo[playerid][CanStomp] = 1;
	PInfo[playerid][CanRun] = 1;
	PInfo[playerid][CanZombieRun] = 1;
    PInfo[playerid][Flamerounds] = 0;
    PInfo[playerid][MolotovMission] = 0;
    PInfo[playerid][BettyMission] = 0;
    PInfo[playerid][CanDig] = 1;
    PInfo[playerid][GodDig] = 0;
    PInfo[playerid][Vomitmsg] = 1;
    PInfo[playerid][Lighton] = 0;
    PInfo[playerid][NoPM] = 0;
    PInfo[playerid][LastID] = -1;
    PInfo[playerid][CanPowerfulGloves] = 1;
    PInfo[playerid][CanStinger] = 1;
    PInfo[playerid][Allowedtovomit] = VOMITTIME;
   	PInfo[playerid][AllowedToBait] = 1;
    PInfo[playerid][oslotglasses] = -1;
    PInfo[playerid][CanUseWeapons] = 1;
    PInfo[playerid][CanBeSpitted] = 1;
    PInfo[playerid][AfterLifeInfected] = 0;
    Mission[playerid] = 0;
    MissionPlace[playerid][0] = 0;
    MissionPlace[playerid][1] = 0;
    RemovePlayerMapIcon(playerid,1);
	format(file,sizeof file,""cgreen"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
 	PInfo[playerid][Ranklabel] = Create3DTextLabel(file,0x008080AA,0,0,0,40.0,0);
	Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
	SetPlayerWeather(playerid,RWeather);
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
    SetTimerEx("Radar", 1500, true, "i", playerid);
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

CMD:me(playerid,params[])
{
	static msg[128],string[128];
	if(sscanf(params,"s[128]",msg)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/me <action>");
	format(string,sizeof(string),""cjam"%s %s",GetPName(playerid),msg);
	SendClientMessageToAll(white,string);
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
	if(perk > PInfo[playerid][Rank]) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR:You did not get this perk!");
	else if(id == 1) PInfo[playerid][SPerk] = perk-1;
	if(perk > PInfo[playerid][Rank]) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR:You did not get this perk!");
	else if(id == 2) PInfo[playerid][ZPerk] = perk-1;
	if(id < 1 || id > 2) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR: Use 1 for "cgreen"HUMAN "cred"and 2 for "cjam"ZOMBIE!");
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
	
	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: %s. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.extreme-stunting.com if you wish.",GetPName(playerid),GetPName(id),GetHisIP(id),reason,d,mm,y);
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
        new RandomGS = random(sizeof(gRandomSkin));
        SetPlayerSkin(id,gRandomSkin[RandomGS]);
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
        new RandomBS = random(sizeof(bRandomSkin));
        SetPlayerSkin(id,bRandomSkin[RandomBS]);
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
		format(string,sizeof(string),""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: 3 Warnings. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a picture of this box and post an unban appeal at www.extreme-stunting.com if you wish.",GetPName(playerid),GetPName(id),GetHisIP(id),d,mm,y);
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
    if(Team[issuerid] == HUMAN)
    {
	    if(PInfo[issuerid][SPerk] == 10 && GetPlayerWeapon(issuerid) == 1)
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
		if(PInfo[playerid][ZPerk] == 13)
		{
            new Float:health;
			GetPlayerHealth(playerid,health);
			if(GetPlayerWeapon(issuerid) == 22) SetPlayerHealth(playerid,health-8); //COLT 45 22
			if(GetPlayerWeapon(issuerid) == 23) SetPlayerHealth(playerid,health-8); //USP 23
			if(GetPlayerWeapon(issuerid) == 24) SetPlayerHealth(playerid,health-23); //DEAGLE 24
			if(GetPlayerWeapon(issuerid) == 25) SetPlayerHealth(playerid,health-19); //Shotgun 25
			if(GetPlayerWeapon(issuerid) == 26) SetPlayerHealth(playerid,health-16); //SAWN 26
			if(GetPlayerWeapon(issuerid) == 27) SetPlayerHealth(playerid,health-23); //SPAZ 27
			if(GetPlayerWeapon(issuerid) == 28) SetPlayerHealth(playerid,health-4); //UZI 28
			if(GetPlayerWeapon(issuerid) == 29) SetPlayerHealth(playerid,health-14); //MP5 29
			if(GetPlayerWeapon(issuerid) == 30) SetPlayerHealth(playerid,health-18); //AK47 30
			if(GetPlayerWeapon(issuerid) == 31) SetPlayerHealth(playerid,health-22); //M4 31
            if(GetPlayerWeapon(issuerid) == 32) SetPlayerHealth(playerid,health-10); //TEC9 32
            if(GetPlayerWeapon(issuerid) == 33) SetPlayerHealth(playerid,health-14); //rifle 33
            if(GetPlayerWeapon(issuerid) == 34) SetPlayerHealth(playerid,health-25); //SniperRifle 34
            if(GetPlayerWeapon(issuerid) == 38) SetPlayerHealth(playerid,health-0); //MINIGUN 38
            return 1;
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
			if(health <= 6)
			{
			    InfectPlayer(playerid);
			    GivePlayerXP(issuerid);
			    CheckRankup(issuerid);
			    PInfo[playerid][AfterLifeInfected] = 1;
			}
	    }
	}
    return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
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
				SetPlayerColor(playerid,GetPlayerColor(playerid) & 0xFFFFFF00 );
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
				SetPlayerColor(playerid,GetPlayerColor(playerid) & 0xFFFFFF00 );
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
/*    if(PRESSED(KEY_WALK) && PRESSED(KEY_CROUCH))
    {
        if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][SPerk] == 0)
            {
				BaitThrowTimer4[playerid] = SetTimerEx("BaitPhase4",2000,false,"i",playerid);
				BaitThrowTimer3[playerid] = SetTimerEx("BaitPhase3",1200,false,"i",playerid);
				BaitThrowTimer2[playerid] = SetTimerEx("BaitPhase2",300,false,"i",playerid);
				BaitThrowTimer1[playerid] = SetTimerEx("BaitPhase1",125,false,"i",playerid);
			}
		}
	}
	*/
	if(HOLDING(KEY_WALK) && HOLDING(KEY_CROUCH))
    {
        if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][SPerk] == 0)
            {
				BaitThrowTimer4[playerid] = SetTimerEx("BaitPhase4",2000,false,"i",playerid);
				BaitThrowTimer3[playerid] = SetTimerEx("BaitPhase3",1400,false,"i",playerid);
				BaitThrowTimer2[playerid] = SetTimerEx("BaitPhase2",550,false,"i",playerid);
				BaitThrowTimer1[playerid] = SetTimerEx("BaitPhase1",125,false,"i",playerid);
				ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",2,0,0,0,1,500,1);
                SendClientMessage(playerid,white,"* "cred"YOU ARE HOLDING ALT AND CROUCH!");
 				SetPlayerAttachedObject(playerid,1,2908,6,0.15,0,0.08,-90,180,90);
			}
		}
	}
	if((oldkeys & KEY_WALK) && (oldkeys & KEY_CROUCH))
	{
      if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][SPerk] == 0)
            {
				if(PInfo[playerid][ThrowingBaitPhase1] == 1)
				{
					SetTimerEx("DestroyBait",500,false,"i",playerid);
					ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
	                SendClientMessage(playerid,white,"* "cred"YOUR OLD KEY IS ALT AND CROUCH!1st phase");
	                KillTimer(BaitThrowTimer4[playerid]);
	                KillTimer(BaitThrowTimer3[playerid]);
	                KillTimer(BaitThrowTimer2[playerid]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					new obj = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
				 	PHY_InitObject(obj);
					PHY_SetObjectVelocity(obj, 5 * floatsin(-ang, degrees), 5 * floatcos(-ang, degrees), 3);
					PHY_SetObjectFriction(obj, 500); // This will stop the object when it touchs the ground.
					PHY_SetObjectGravity(obj, 50);
					PHY_SetObjectZBound(obj, z - 0.9, _, 0.0);
				}
				else if(PInfo[playerid][ThrowingBaitPhase2] == 1)
				{
					SetTimerEx("DestroyBait",500,false,"i",playerid);
					ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
	                SendClientMessage(playerid,white,"* "cred"YOUR OLD KEY IS ALT AND CROUCH!2nd phase");
                 	KillTimer(BaitThrowTimer3[playerid]);
                 	KillTimer(BaitThrowTimer4[playerid]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					new obj = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
				 	PHY_InitObject(obj);
					PHY_SetObjectVelocity(obj, 7.5 * floatsin(-ang, degrees), 7.5 * floatcos(-ang, degrees), 11);
					PHY_SetObjectFriction(obj, 500); // This will stop the object when it touchs the ground.
					PHY_SetObjectGravity(obj, 50);
					PHY_SetObjectZBound(obj, z - 0.9, _, 0.0);
				}
				else if(PInfo[playerid][ThrowingBaitPhase3] == 1)
				{
					SetTimerEx("DestroyBait",500,false,"i",playerid);
					ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
	                SendClientMessage(playerid,white,"* "cred"YOUR OLD KEY IS ALT AND CROUCH!3rd phase");
                 	KillTimer(BaitThrowTimer4[playerid]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					new obj = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
				 	PHY_InitObject(obj);
					PHY_SetObjectVelocity(obj, 15 * floatsin(-ang, degrees), 15 * floatcos(-ang, degrees), 13);
					PHY_SetObjectFriction(obj, 500); // This will stop the object when it touchs the ground.
					PHY_SetObjectGravity(obj, 50);
					PHY_SetObjectZBound(obj, z - 0.9, _, 0.0);
				}
				else if(PInfo[playerid][ThrowingBaitPhase4] == 1)
				{
					SetTimerEx("DestroyBait",500,false,"i",playerid);
					ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
	                SendClientMessage(playerid,white,"* "cred"YOUR OLD KEY IS ALT AND CROUCH!4th phase");
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					new obj = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
				 	PHY_InitObject(obj);
					PHY_SetObjectVelocity(obj, 20 * floatsin(-ang, degrees), 20 * floatcos(-ang, degrees), 18);
					PHY_SetObjectFriction(obj, 500); // This will stop the object when it touchs the ground.
					PHY_SetObjectGravity(obj, 50);
					PHY_SetObjectZBound(obj, z - 0.9, _, 0.0);
				}
                //SetTimerEx("ResetThrow",5000,false,"i",playerid);
			}
		}
	}
	
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
		if(Team[playerid] == HUMAN)
  		{
			if(PInfo[playerid][SPerk] == 21)
			{
	  			if(IsPlayerInAnyVehicle(playerid)) return 0;
		        if(Team[playerid] == ZOMBIE) return 0;
				if(PInfo[playerid][CanPowerfulGloves] == 0) return SendClientMessage(playerid,red,"Your gloves are not ready!");
				ApplyAnimation(playerid,"FIGHT_B","FightB_G",5.0,1,0,0,0,700,1);
				static Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				static string[901];
				SetTimerEx("PowerfulGlovesSound",350,false,"i",playerid);
				format(string,sizeof string,""cjam"%s(%i) hit the ground with his powerful gloves!",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][CanPowerfulGloves] = 0;
				PInfo[playerid][PowerfulGlovesTimer] = SetTimerEx("AllowedToPowerfulGloves",5000,false,"i",playerid);
				for(new i; i < MAX_PLAYERS;i++)
				{
					if(!IsPlayerConnected(i)) continue;
					if(Team[i] == HUMAN) continue;
					if(IsPlayerInRangeOfPoint(i,15,x,y,z))
					{
					    if(IsPlayerFacingPlayer(i, playerid, 30))
					    {
							GetPlayerVelocity(i,x,y,z);
					      	PlaySound(i,14600);
							SetPlayerVelocity(i,x,y,z+0.10);
							SetTimerEx("PowerfulGlovesThrow",400,false,"i",i);
						}
					}
					if(IsPlayerInRangeOfPoint(i,50,x,y,z))
					{
					    PlaySound(i,14600);
					}
				}
			}
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
					    case 14:
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
		        if((GetTickCount() - PInfo[playerid][Allowedtovomit]) < VOMITTIME) return SendClientMessage(playerid,red,"You haven't got enough meat un your stomach!");
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
						ApplyAnimation(i,"PED","KO_skid_back",2,0,0,0,0,1750,1);
					}
				}
			}
			if(PInfo[playerid][ZPerk] == 20)
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
            if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
			if(Team[playerid] == ZOMBIE) return 0;
		    if(PInfo[playerid][ZombieBait] == 1) return 0;
		    static string[70];
			PInfo[playerid][ZombieBait] = 1;
			SetTimerEx("CanZombieBaitTimer",20000,false,"i",playerid);
		    format(string,sizeof string,""cjam"%s приманил зомби тухлым мясом",GetPName(playerid));
		    new Float:a,Float:x,Float:y;
		    GetPlayerFacingAngle(playerid,a);
   			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SendNearMessage(playerid,white,string,20);
			GetPlayerPos(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
			PInfo[playerid][ZObject] = CreateObject(2908,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]-1,0,0,0,200);
			SetTimerEx("StopBait",15000,false,"i",playerid);
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
	if(PRESSED(KEY_HANDBRAKE))
	{
		if(IsPlayerInAnyVehicle(playerid))
	 	{
	   		if(PInfo[playerid][CanBite] == 0) return 0;
	   		if(Team[playerid] != HUMAN)
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
			        if(IsPlayerInRangeOfPoint(j,5,x,y,z) && (IsPlayerInAnyVehicle(j)))
			        {
			            i = j;
			            break;
			        }
	  			}
	  			static Float:Health;
	            GetPlayerHealth(i,Health);
	            MakeHealthEven(i,Health);
	  			DamagePlayer(playerid,i);
	            GetPlayerHealth(i,Health);
	            MakeHealthEven(i,Health);
	  			DamagePlayer(playerid,i);
				if(PInfo[playerid][ZPerk] == 3)
				{
					GetPlayerHealth(playerid,Health);
					if(Health >= 100.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,Health+6);
				}
				else if(PInfo[playerid][ZPerk] == 21)
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
		   		SetTimerEx("CantBite",455,0,"i",playerid);
		   		PInfo[playerid][CanBite] = 0;
				PInfo[playerid][Bites]++;
				PInfo[i][Lastbite] = playerid;
				if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
				ApplyAnimation(playerid,"WAYFARER","WF_FWD",2.15,1,0,0,0,200,1);
				ApplyAnimation(i,"PED","DAM_armL_frmFT",1,0,1,1,0,750,1);
				if(Health <= 6.0)
				{
				    InfectPlayer(i);
				    GivePlayerXP(playerid);
		            CheckRankup(playerid);
		            PInfo[i][AfterLifeInfected] = 1;
				}
				if(PInfo[playerid][ZPerk] == 10)
				{
		            if(PInfo[i][CanStinger] == 0) return 0;
		            else
		            {
						/*new rand = random(1);
						if(rand == 1)
						*/
						{
							ApplyAnimation(i,"PED","DAM_Stomach_frmFT",2,0,0,0,0,600,1);
							SetTimerEx("StingerPhase1", 650, false, "i", i);
							SetTimerEx("StingerPhase2", 1400, false, "i", i);
							PInfo[i][CanStinger] = 0;
							SetTimerEx("CanBeStingeredTime", 10000, false, "i", i);
						}
					}
				}
			}
		}
	}
	if(HOLDING(KEY_SPRINT))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
			if(!IsPlayerInAnyVehicle(playerid) && PInfo[playerid][CanZombieRun] != 0)
			{
				ApplyAnimation(playerid,"Muscular","MuscleSprint",4.1,1,1,1,1,1,1);
			}
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
            	PInfo[playerid][Infected] = 1;
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
	}
	if(RELEASED(KEY_SPRINT))
	{
		if(Team[playerid] == HUMAN)
  		{
	        if(PInfo[playerid][SPerk] == 8)
	        {
	            if(PInfo[playerid][CanRun] == 0) return 0;
	            if(IsPlayerInAnyVehicle(playerid)) return 0;
	            ApplyAnimation(playerid,"PED","run_stopr",10,1,1,1,0,1,1);
     		//	ApplyAnimation(playerid,"PED","run_stopr",10,1,1,1,0,1,1);
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
		if(Fuel[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,white,"* "cred"В машине кончился бензин!");
		if(Oil[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,white,"* "cred"В машине закончилось масло!");
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
			format(string,sizeof string,""cjam"%s(%i) улетел далеко с помощью своих мощных ботинок.",GetPName(playerid),playerid);
			SendNearMessage(playerid,white,string,35);
		}
	}
	if(PRESSED(KEY_HANDBRAKE))//Aim Key
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    if(Team[playerid] != ZOMBIE) return 0;
		    if(PInfo[playerid][CanBite] == 0) return 0;
			if(PInfo[playerid][ZPerk] == 15)///Hemorrage======================
			{
				if(GetTickCount() - PInfo[playerid][CanSpit] < 30000)
				{
					SendClientMessage(playerid,white,""cwhite"* "cred"You haven't got enough blood in your mouth!");
					return 0;
				}
			    for(new i, f = MAX_PLAYERS; i < f; i++)
			    {
			        if(!IsPlayerConnected(i)) continue;
	      		    if(i == playerid) continue;
				    if(PInfo[i][Dead] == 1) continue;
				    if(Team[i] == ZOMBIE) continue;
     				static Float:x,Float:y,Float:z;
			    	GetPlayerPos(playerid,x,y,z);
			        if(IsPlayerInRangeOfPoint(i,4,x,y,z))
			        {
			            if(IsPlayerFacingPlayer(playerid, i, 70))
			            {
           					if(PInfo[i][CanBeSpitted] == 0) continue;
			                if(!IsPlayerInAnyVehicle(i))
	   						{
								new Float:a;
								GetPlayerVelocity(i,x,y,z);
								GetPlayerFacingAngle(playerid,a);
								x += ( 0.5 * floatsin( -a, degrees ) );
					      		y += ( 0.5 * floatcos( -a, degrees ) );
					      		ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
		      					static string[64];
								format(string,sizeof string,""cjam"%s has spit blood on face of %s.",GetPName(playerid),GetPName(i));
								SendNearMessage(i,white,string,50);
								PInfo[i][CanBeSpitted] = 0;
								SetTimerEx("CanBeSpittedTimer",150000,false,"i",i);
								TextDrawShowForPlayer(i,Textdraw1);
								TextDrawShowForPlayer(i,Textdraw2);
								TextDrawShowForPlayer(i,Textdraw3);
								TextDrawShowForPlayer(i,Textdraw4);
								TextDrawShowForPlayer(i,Textdraw5);
								TextDrawShowForPlayer(i,Textdraw6);
								TextDrawShowForPlayer(i,Textdraw7);
								TextDrawShowForPlayer(i,Textdraw8);
								TextDrawShowForPlayer(i,Textdraw9);
								TextDrawShowForPlayer(i,Textdraw10);
								TextDrawShowForPlayer(i,Textdraw11);
								TextDrawShowForPlayer(i,Textdraw12);
								TextDrawShowForPlayer(i,Textdraw13);
								TextDrawShowForPlayer(i,Textdraw14);
								TextDrawShowForPlayer(i,Textdraw15);
								TextDrawShowForPlayer(i,Textdraw16);
								TextDrawShowForPlayer(i,Textdraw17);
								TextDrawShowForPlayer(i,Textdraw18);
								TextDrawShowForPlayer(i,Textdraw19);
								TextDrawShowForPlayer(i,Textdraw19);
								TextDrawShowForPlayer(i,Textdraw20);
								TextDrawShowForPlayer(i,Textdraw21);
								TextDrawShowForPlayer(i,Textdraw22);
								TextDrawShowForPlayer(i,Textdraw23);
								TextDrawShowForPlayer(i,Textdraw24);
								TextDrawShowForPlayer(i,Textdraw25);
								TextDrawShowForPlayer(i,Textdraw26);
								TextDrawShowForPlayer(i,Textdraw27);
								TextDrawShowForPlayer(i,Textdraw28);
								TextDrawShowForPlayer(i,Textdraw29);
								TextDrawShowForPlayer(i,Textdraw30);
								TextDrawShowForPlayer(i,Textdraw31);
								TextDrawShowForPlayer(i,Textdraw32);
								TextDrawShowForPlayer(i,Textdraw33);
								TextDrawShowForPlayer(i,Textdraw34);
								TextDrawShowForPlayer(i,Textdraw35);
								TextDrawShowForPlayer(i,Textdraw36);
								TextDrawShowForPlayer(i,Textdraw37);
								TextDrawShowForPlayer(i,Textdraw38);
								TextDrawShowForPlayer(i,Textdraw39);
								SetTimerEx("DissapearBloodPhase1",25000,false,"i",i);
								SetTimerEx("DissapearBloodPhase2",60000,false,"i",i);
								SetTimerEx("DissapearBloodPhase3",100000,false,"i",i);
			            	}
			            }
					}
		        }
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
                SetTimerEx("ClearAnim2",700,false,"i",playerid);
				SetPlayerAttachedObject(playerid,7,18729,2,0,0,-1.6);
				SetTimerEx("DeleteBlood",650,false,"i",playerid);
                PInfo[playerid][CanSpit] = GetTickCount();
			}
      		else if(PInfo[playerid][ZPerk] == 22)
			{
			    if(GetTickCount() - PInfo[playerid][CanHellScream] < 25000)
				{
					SendClientMessage(playerid,orange,"* YOU CANT USE HELL SCREAM RIGHT NOW!");
					return 0;
				}
			    for(new i, f = MAX_PLAYERS; i < f; i++)
			    {
			        if(!IsPlayerConnected(i)) continue;
	      		    if(i == playerid) continue;
				    if(PInfo[i][Dead] == 1) continue;
				    if(Team[i] == ZOMBIE) continue;
           			static Float:x,Float:y,Float:z;
			    	GetPlayerPos(playerid,x,y,z);
			        if(IsPlayerInRangeOfPoint(i,8,x,y,z))
			        {
			            if(IsPlayerFacingPlayer(playerid, i, 70))
			            {
			                if(!IsPlayerInAnyVehicle(i))
	   						{
								new Float:a;
			                	if(PInfo[i][SPerk] != 12)
			                	{
									GetPlayerVelocity(i,x,y,z);
									GetPlayerFacingAngle(playerid,a);
									x += ( 0.5 * floatsin( -a, degrees ) );
						      		y += ( 0.5 * floatcos( -a, degrees ) );
						      		ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
									SetPlayerVelocity(i,x,y,z+0.15);
	        						if(PInfo[i][OnFire] != 0) return 0;
									PInfo[i][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
									PInfo[i][OnFire] = 1;
									AttachObjectToPlayer(PInfo[i][FireObject],i,0,0,-0.2,0,0,0);
									SetTimerEx("AffectFire",500,false,"i",i,playerid);
								}
			            	}
							else
							{
							    SetVehicleAngularVelocity(GetPlayerVehicleID(i), 0, 0, 0.15);
							}
			            }
			        }
			        static Float:Health;
		  			GetPlayerHealth(i,Health);
					MakeHealthEven(i,Health);
		  			if(Health <= 4.0)
      					MakeProperDamage(i);
					else
		  				SetPlayerHealth(i,Health-4.0);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
				 	if(Health <= 1.0)
				 	{
				 	    InfectPlayer(i);
					    GivePlayerXP(playerid);
					    CheckRankup(playerid);
					    PInfo[playerid][Screameds]++;
					    PInfo[i][AfterLifeInfected] = 1;
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
       			static string[64];
				format(string,sizeof string,""cjam"%s(%i) screamed HellFire!",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
                SetTimerEx("ClearAnim2",700,false,"i",playerid);
                PInfo[playerid][CanHellScream] = GetTickCount();
      		}
			else if(PInfo[playerid][ZPerk] == 8)
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
			                new Float:a;
			                if(PInfo[i][SPerk] != 12)
			                {
								GetPlayerVelocity(i,x,y,z);
								GetPlayerFacingAngle(playerid,a);
								x += ( 0.5 * floatsin( -a, degrees ) );
						      	y += ( 0.5 * floatcos( -a, degrees ) );
						      	ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
								SetPlayerVelocity(i,x,y,z+0.15);
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
					    PInfo[playerid][Screameds]++;
					    PInfo[i][AfterLifeInfected] = 1;
				 	}
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
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
			                	if(PInfo[i][SPerk] != 12)
			                	{
									GetPlayerVelocity(i,x,y,z);
									GetPlayerFacingAngle(playerid,a);
									x += ( 0.5 * floatsin( -a, degrees ) );
						      		y += ( 0.5 * floatcos( -a, degrees ) );
						      		ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
									SetPlayerVelocity(i,x,y,z+0.15);
								}
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
					    PInfo[playerid][Screameds]++;
					    PInfo[i][AfterLifeInfected] = 1;
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
           		SetTimerEx("CantBite",455,0,"i",playerid);
           		PInfo[playerid][CanBite] = 0;
				PInfo[playerid][Bites]++;
				PInfo[i][Lastbite] = playerid;
				if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
				ApplyAnimation(playerid,"WAYFARER","WF_FWD",2.15,1,0,0,0,200,1);
				ApplyAnimation(i,"PED","DAM_armL_frmFT",1,0,1,1,0,750,1);
				if(Health <= 6.0)
				{
				    InfectPlayer(i);
				    GivePlayerXP(playerid);
	                CheckRankup(playerid);
	                PInfo[i][AfterLifeInfected] = 1;
				}
                
				if(PInfo[playerid][ZPerk] == 10)
				{
                    if(PInfo[i][CanStinger] == 0) return 0;
                    else
                    {
						/*new rand = random(1);
						if(rand == 1)
						*/
						{
							ApplyAnimation(i,"PED","DAM_Stomach_frmFT",2,1,0,0,0,600,1);
							SetTimerEx("StingerPhase1", 650, false, "i", i);
							SetTimerEx("StingerPhase2", 1400, false, "i", i);
							PInfo[i][CanStinger] = 0;
							SetTimerEx("CanBeStingeredTime", 10000, false, "i", i);
						}
					}
				}
      		}
		}
	}
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1502)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            if(GetPlayerWeapon(playerid) == 23)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,23,ammo+50);
				}
				else if(GetPlayerWeapon(playerid) != 23)
				{
				    GivePlayerWeapon(playerid,23,50);
				}
			}
			if(listitem == 1)
			{
	            if(GetPlayerWeapon(playerid) == 22)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,22,ammo+100);
				}
				else if(GetPlayerWeapon(playerid) != 22)
				{
				    GivePlayerWeapon(playerid,22,100);
				}
			}
			if(listitem == 2)
			{
	            if(GetPlayerWeapon(playerid) == 25)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,25,ammo+100);
				}
				else if(GetPlayerWeapon(playerid) != 25)
				{
				    GivePlayerWeapon(playerid,25,100);
				}
			}
			if(listitem == 3)
			{
	            if(GetPlayerWeapon(playerid) == 24)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,24,ammo+150);
				}
				else if(GetPlayerWeapon(playerid) != 24)
				{
				    GivePlayerWeapon(playerid,24,150);
				}
			}
			if(listitem == 4)
			{
	            if(GetPlayerWeapon(playerid) == 28)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,28,ammo+200);
				}
				else if(GetPlayerWeapon(playerid) != 28)
				{
				    GivePlayerWeapon(playerid,28,200);
				}
	            if(GetPlayerWeapon(playerid) == 33)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,33,ammo+50);
				}
				else if(GetPlayerWeapon(playerid) != 33)
				{
				    GivePlayerWeapon(playerid,28,50);
				}
			}
			if(listitem == 5)
			{
	            if(GetPlayerWeapon(playerid) == 26)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,26,ammo+200);
				}
				else if(GetPlayerWeapon(playerid) != 26)
				{
				    GivePlayerWeapon(playerid,26,200);
				}
			}
			if(listitem == 6)
			{
	            if(GetPlayerWeapon(playerid) == 30)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,30,ammo+90);
				}
				else if(GetPlayerWeapon(playerid) != 30)
				{
				    GivePlayerWeapon(playerid,30,90);
				}
	            if(GetPlayerWeapon(playerid) == 32)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,32,ammo+250);
				}
				else if(GetPlayerWeapon(playerid) != 32)
				{
				    GivePlayerWeapon(playerid,32,250);
				}
			}
			if(listitem == 7)
			{
	            if(GetPlayerWeapon(playerid) == 27)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,27,ammo+250);
				}
				else if(GetPlayerWeapon(playerid) != 27)
				{
				    GivePlayerWeapon(playerid,27,250);
				}
			}
			if(listitem == 8)
			{
	            if(GetPlayerWeapon(playerid) == 31)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,31,ammo+300);
				}
				else if(GetPlayerWeapon(playerid) != 31)
				{
				    GivePlayerWeapon(playerid,31,300);
				}
			}
			if(listitem == 9)
			{
	            if(GetPlayerWeapon(playerid) == 34)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,34,ammo+150);
				}
				else if(GetPlayerWeapon(playerid) != 34)
				{
				    GivePlayerWeapon(playerid,34,150);
				}
	            if(GetPlayerWeapon(playerid) == 29)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,29,ammo+350);
				}
				else if(GetPlayerWeapon(playerid) != 29)
				{
				    GivePlayerWeapon(playerid,29,350);
				}
			}
  			PInfo[playerid][CanUseWeapons] = 0;
  			SendClientMessage(playerid,white,"**"corange"You have successfully changed your weapons!");
		}
		else return 1;
	}
	if(dialogid == 1501)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            if(GetPlayerWeapon(playerid) == 23)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,23,ammo+50);
				}
				else if(GetPlayerWeapon(playerid) != 23)
				{
				    GivePlayerWeapon(playerid,23,50);
				}
			}
			if(listitem == 1)
			{
	            if(GetPlayerWeapon(playerid) == 22)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,22,ammo+100);
				}
				else if(GetPlayerWeapon(playerid) != 22)
				{
				    GivePlayerWeapon(playerid,22,100);
				}
			}
			PInfo[playerid][CanUseWeapons] = 0;
			SendClientMessage(playerid,white,"**"corange"You have successfully changed your weapons!");
		}
		else return 1;
	}
	if(dialogid == 1500)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            if(GetPlayerWeapon(playerid) == 23)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,23,ammo+50);
				}
				else if(GetPlayerWeapon(playerid) != 23)
				{
				    GivePlayerWeapon(playerid,23,50);
				}
			}
        	PInfo[playerid][CanUseWeapons] = 0;
        	SendClientMessage(playerid,white,"**"corange"You have successfully changed your weapons!");
		}
		else return 1;
	}
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
        	ShowPlayerDialog(playerid,1002,DSM,"Выживший", ""cwhite"Главаная задача выживших - пройти все 8 контрольных точек\nПри прохождении их всех выжившие выигрывают игру\nПри убийстве и прохождении контрольных точек дается по 10 XP\nТак же у вас есть инвентарь в котором уже лежат вещи, они помогут вам выжить в этом аду\nЕсли же ресурсы у вас закончатся, вы можете спокойно их восполнить в домах(например в доме CJ'я на кухне можно поискать вещи (нажмите "cred"C)","Назад","Закрыть");
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
		PInfo[playerid][ZPerk] = 21;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == Hemorrage)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 15;
		SendClientMessage(playerid,orange,"Ты успешно поменял способность!");
	}
	if(dialogid == ThickSkin)
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
		PInfo[playerid][ZPerk] = 20;
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
	if(dialogid == HellScream)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 22;
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
			ShowPlayerDialog(playerid,Deadsensedialog,0,"Dead Sense",""cwhite"Your sensitives become better \nSo, you can see other zombies on radar!","Set","Close");
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
			ShowPlayerDialog(playerid,ThickSkin,0,"Thick Skin",""cwhite"Your skin becomes more harder and thicker\nYou will get less damage from bullets \n"cred"Just choose this perk to activate","Set","Close");
        }
        if(listitem == 14)
        {
			ShowPlayerDialog(playerid,Goddigdialog,0,"God dig",""cwhite"With this perk, you are allowed to dig to the closest human, even tho you have a zombie in your way.","Set","Close");
        }
        if(listitem == 15)
        {
			ShowPlayerDialog(playerid,Hemorrage,0,"Hemorrage",""cwhite"Your mouth have got some blood, which you can spit on other humans\n"cred"Stay close to humans and press RMB to spit some blood on humans' faces ","Set","Close");
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
		if(listitem == 20)
        {
			ShowPlayerDialog(playerid,HellScream,0,"Hell Scream",""cwhite"This scream calls upon Hellfire from your mouth. \nAll humans within 5 meters will receive severe burns, they will get burning effect for 7 seconds \n"cred"NOTE:Click RMB to scream HellFire \nCooldown between screams - 25 seconds!","Set","Close");
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
	if(dialogid == UltimateExtraMeds)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 20;
		SendClientMessage(playerid,orange,"You have successfully changed your survivor perk.");
	}
	if(dialogid == PowerfulGloves)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 21;
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
	        ShowPlayerDialog(playerid,Extraammodialog,0,"Sure foot",""cwhite"This perk allows you to stay steadily on the surface,\nSo you will not get effect when zombie screams","Set","Cancel");
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
	    if(listitem == 20)
	    {
	        ShowPlayerDialog(playerid,UltimateExtraMeds,0,"Ultimate Extra Meds",""cwhite"Your meds have unusual structure, \nBut with this structure, med. kits make you healthy. \n"cred"NOTE: you will get more much HP after using med.kits!","Set","Cancel");
	    }
	    if(listitem == 21)
	    {
	        ShowPlayerDialog(playerid,PowerfulGloves,0,"Powerful Gloves",""cwhite"You have gloves with powerful force  \nWhen you use these gloves, all zombies in 15 meters will be thrown away. \n"cred"NOTE: Click C to use your gloves!\nGloves have cooldown on 1.5 minutes! ","Set","Cancel");
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
    PInfo[playerid][Screameds] = INI_ReadInt("Screameds");
    PInfo[playerid][Teamkills] = INI_ReadInt("Teamkills");
    PInfo[playerid][SPerk] = INI_ReadInt("SPerk");
    PInfo[playerid][ZPerk] = INI_ReadInt("ZPerk");
    PInfo[playerid][Bites] = INI_ReadInt("Bites");
    PInfo[playerid][CPCleared] = INI_ReadInt("CPCleared");
    PInfo[playerid][Assists] = INI_ReadInt("Assists");
    PInfo[playerid][Vomited] = INI_ReadInt("Vomited");
    PInfo[playerid][Premium] = INI_ReadInt("Premium");
    PInfo[playerid][Warns] = INI_ReadInt("Warns");
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
	INI_WriteString("IP",GetHisIP(playerid));
 	INI_WriteInt("Level",0);
 	INI_WriteInt("Rank",1);
 	INI_WriteInt("XP",0);
 	INI_WriteInt("Kills",0);
    INI_WriteInt("Deaths",0);
    INI_WriteInt("Screameds",0);
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
    INI_WriteInt("Screameds",PInfo[playerid][Screameds]);
    INI_WriteInt("Teamkills",PInfo[playerid][Teamkills]);
    INI_WriteInt("Infects",PInfo[playerid][Infects]);
    INI_WriteInt("SPerk",PInfo[playerid][SPerk]);
    INI_WriteInt("ZPerk",PInfo[playerid][ZPerk]);
    INI_WriteInt("Bites",PInfo[playerid][Bites]);
    INI_WriteInt("CPCleared",PInfo[playerid][CPCleared]);
    INI_WriteInt("Vomited",PInfo[playerid][Vomited]);
    INI_WriteInt("Assists",PInfo[playerid][Assists]);
    INI_WriteInt("Premium",PInfo[playerid][Premium]);
    INI_WriteInt("Warns",PInfo[playerid][Warns]);
    INI_Save();
 	INI_Close();
	return 1;
}

function ShowXP4(playerid)//5th phase
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawLetterSize(GainXPTD[playerid], 1.269777, 3.108088);
	TextDrawAlignment(GainXPTD[playerid], 1);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetShadow(GainXPTD[playerid], 0);
	TextDrawSetOutline(GainXPTD[playerid], -1);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("HideXP",1000,0,"i",playerid);
	static string[7];
	format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	TextDrawSetString(GainXPTD[playerid],string);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	return 1;
}

function ShowXP3(playerid)//4th phase
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawLetterSize(GainXPTD[playerid], 1.269777, 3.108088);
	TextDrawAlignment(GainXPTD[playerid], 1);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetShadow(GainXPTD[playerid], 0);
	TextDrawSetOutline(GainXPTD[playerid], 0);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("HideXP",200,0,"i",playerid);
	static string[7];
	format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	TextDrawSetString(GainXPTD[playerid],string);
	SetTimerEx("ShowXP4",200,0,"i",playerid);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	return 1;
}

function ShowXP2(playerid)//3th phase
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawLetterSize(GainXPTD[playerid], 1.058223, 1.913422);
	TextDrawAlignment(GainXPTD[playerid], 1);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetShadow(GainXPTD[playerid], 0);
	TextDrawSetOutline(GainXPTD[playerid], 0);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("HideXP",50,0,"i",playerid);
	static string[7];
	format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	TextDrawSetString(GainXPTD[playerid],string);
	SetTimerEx("ShowXP3",50,0,"i",playerid);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	return 1;
}

function ShowXP1(playerid)//2nd PHASE
{
    TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawLetterSize(GainXPTD[playerid], 0.862222, 0.614222);
	TextDrawAlignment(GainXPTD[playerid], 1);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetShadow(GainXPTD[playerid], 0);
	TextDrawSetOutline(GainXPTD[playerid], 0);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
	TextDrawSetProportional(GainXPTD[playerid], 1);
	SetTimerEx("ShowXP2",50,0,"i",playerid);
	TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
	return 1;
}

function HideXP(playerid)
{
	TextDrawHideForPlayer(playerid,GainXPTD[playerid]);
	TextDrawLetterSize(GainXPTD[playerid], 0.862222, 0.614222);
	TextDrawAlignment(GainXPTD[playerid], 1);
	TextDrawColor(GainXPTD[playerid], -1);
	TextDrawSetShadow(GainXPTD[playerid], 0);
	TextDrawSetOutline(GainXPTD[playerid], 0);
	TextDrawBackgroundColor(GainXPTD[playerid], 255);
	TextDrawFont(GainXPTD[playerid], 1);
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
		    format(string,sizeof string,"RANK: %i ~n~KILLS: %i ~n~TEAM KILLS: %i ~n~DEATHS: %i ~n~PERK: %i ~n~CP CLEARED: %i",
		    PInfo[i][Rank],PInfo[i][Kills],PInfo[i][Teamkills],PInfo[i][Deaths],PInfo[i][SPerk]+1,PInfo[i][CPCleared]);
		    //TextDrawSetString(Stats[i],string);
		    TextDrawShowForPlayer(i,Stats[i]);
//STATS TEXDRAW
		    format(string,sizeof string,"RANK: %i",PInfo[i][Rank]);
	  		TextDrawSetString(RANK[i],string);
	  		TextDrawShowForPlayer(i,RANK[i]);
			format(string,sizeof string,"PERK: %i",PInfo[i][SPerk]+1);
	  		TextDrawSetString(PERK[i],string);
	  		TextDrawShowForPlayer(i,PERK[i]);
		    format(string,sizeof string,"KILLS: %i",PInfo[i][Kills]);
	  		TextDrawSetString(KILLS[i],string);
	  		TextDrawShowForPlayer(i,KILLS[i]);
		    format(string,sizeof string,"DEATHS: %i",PInfo[i][Deaths]);
	  		TextDrawSetString(DEATHS[i],string);
	  		TextDrawShowForPlayer(i,DEATHS[i]);
		    format(string,sizeof string,"TEAM KILLS: %i",PInfo[i][Teamkills]);
	  		TextDrawSetString(TEAMKILLS[i],string);
	  		TextDrawShowForPlayer(i,TEAMKILLS[i]);
		    format(string,sizeof string,"CP CLEARED: %i",PInfo[i][CPCleared]);
	  		TextDrawSetString(CPCLEARED[i],string);
	  		TextDrawShowForPlayer(i,CPCLEARED[i]);
		    format(string,sizeof string,"FLASHBANGS: 0");
	  		TextDrawSetString(FLASHBANGS[i],string);
	  		TextDrawShowForPlayer(i,FLASHBANGS[i]);
		    format(string,sizeof string,"FLAME AMMO: %i",PInfo[i][Flamerounds]);
	  		TextDrawSetString(FLAMEAMMO[i],string);
	  		TextDrawShowForPlayer(i,FLAMEAMMO[i]);
		    format(string,sizeof string,"SKILLPOINTS: 0");
	  		TextDrawSetString(SKILLPOINTS[i],string);
	  		TextDrawShowForPlayer(i,SKILLPOINTS[i]);
//Stats Textdraw
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
     	if(PInfo[i][XP] == PInfo[i][XPToRankUp])
		{
		    TextDrawShowForPlayer(i,RANKUP[i]);
		    SetTimerEx("RANKUP2",50,false,"ii",i);
		    PInfo[i][Rank]++;
		    PInfo[i][XP] = 0;
		    CheckRankup(i);
		    SetPlayerScore(i,PInfo[i][Rank]);
		}
		else if(PInfo[i][XP] >= PInfo[i][XPToRankUp])
		{
			new ExtraXP;
			TextDrawShowForPlayer(i,RANKUP[i]);
			SetTimerEx("RANKUP2",50,false,"ii",i);
		    ExtraXP = PInfo[i][XP] - PInfo[i][XPToRankUp];
		    PInfo[i][Rank]++;
		    PInfo[i][XP] = ExtraXP;
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
                            PInfo[i][Vomited]++;
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
		}
		else SetPlayerDrunkLevel(i,0);
		SetPlayerWeather(i,345);
		SetPlayerTime(i,23,00);
		if(PInfo[i][Lighton] == 1)
		{
            RemovePlayerAttachedObject(i,1);
            RemovePlayerAttachedObject(i,2);
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
		Fuel[i]-=1;
		Oil[i]-=1;
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
		SetPlayerWeather(i,RWeather);
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
		case 52: PInfo[playerid][XPToRankUp] = 250000;
		case 53: PInfo[playerid][XPToRankUp] = 275000;
		case 54: PInfo[playerid][XPToRankUp] = 300000;
		case 55: PInfo[playerid][XPToRankUp] = 325000;
		case 56: PInfo[playerid][XPToRankUp] = 350000;
		case 57: PInfo[playerid][XPToRankUp] = 375000;
		case 58: PInfo[playerid][XPToRankUp] = 400000;
		case 59: PInfo[playerid][XPToRankUp] = 425000;
		case 60: PInfo[playerid][XPToRankUp] = 450000;
		case 61: PInfo[playerid][XPToRankUp] = 500000;
		case 62: PInfo[playerid][XPToRankUp] = 550000;
		case 63: PInfo[playerid][XPToRankUp] = 600000;
		case 64: PInfo[playerid][XPToRankUp] = 650000;
		case 65: PInfo[playerid][XPToRankUp] = 700000;
		case 66: PInfo[playerid][XPToRankUp] = 750000;
		case 67: PInfo[playerid][XPToRankUp] = 800000;
		case 68: PInfo[playerid][XPToRankUp] = 850000;
		case 69: PInfo[playerid][XPToRankUp] = 900000;
		case 70: PInfo[playerid][XPToRankUp] = 1000000;
		case 71: PInfo[playerid][XPToRankUp] = 1100000;
		case 72: PInfo[playerid][XPToRankUp] = 1200000;
		case 73: PInfo[playerid][XPToRankUp] = 1300000;
		case 74: PInfo[playerid][XPToRankUp] = 1400000;
		case 75: PInfo[playerid][XPToRankUp] = 1500000;
		case 76: PInfo[playerid][XPToRankUp] = 1600000;
		case 77: PInfo[playerid][XPToRankUp] = 1700000;
		case 78: PInfo[playerid][XPToRankUp] = 1800000;
		case 79: PInfo[playerid][XPToRankUp] = 1900000;
		case 80: PInfo[playerid][XPToRankUp] = 2000000;
		case 81: PInfo[playerid][XPToRankUp] = 2250000;
		case 82: PInfo[playerid][XPToRankUp] = 2500000;
		case 83: PInfo[playerid][XPToRankUp] = 2750000;
		case 84: PInfo[playerid][XPToRankUp] = 3000000;
		case 85: PInfo[playerid][XPToRankUp] = 3250000;
        case 86: PInfo[playerid][XPToRankUp] = 3500000;
        case 87: PInfo[playerid][XPToRankUp] = 3750000;
        case 88: PInfo[playerid][XPToRankUp] = 4000000;
        case 89: PInfo[playerid][XPToRankUp] = 4250000;
        case 90: PInfo[playerid][XPToRankUp] = 4500000;
        case 91: PInfo[playerid][XPToRankUp] = 5000000;
        case 92: PInfo[playerid][XPToRankUp] = 5500000;
        case 93: PInfo[playerid][XPToRankUp] = 6000000;
        case 94: PInfo[playerid][XPToRankUp] = 6500000;
        case 95: PInfo[playerid][XPToRankUp] = 7000000;
        case 96: PInfo[playerid][XPToRankUp] = 7500000;
        case 97: PInfo[playerid][XPToRankUp] = 8000000;
        case 98: PInfo[playerid][XPToRankUp] = 8500000;
        case 99: PInfo[playerid][XPToRankUp] = 9000000;
        case 100: PInfo[playerid][XPToRankUp] = 10000000;
	}
	if(gw == 1)
	{
	    if(Team[playerid] == ZOMBIE) return 0;
	    switch(PInfo[playerid][Rank])
		{
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,60),GivePlayerWeapon(playerid,2,1); //Silenced Pistol + Knuckles + Cane
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,110),GivePlayerWeapon(playerid,2,1);//Silenced Pistol + Knuckles + Cane
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,160),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,190),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,100),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,150),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,200),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,250),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 9: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,300),GivePlayerWeapon(playerid,6,1);//2 dual pistols + Knuckles + shovel
		    case 10: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,400),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,50);//2 dual pistols + Knuckles + shovel+shotgun
		    case 11: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,500),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,100);//2 dual pistols + Knuckles + shovel+shotgun
		    case 12: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,600),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,150);//2 dual pistols + Knuckles + shovel+shotgun
		    case 13: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,700),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,200);//2 dual pistols +Knuckles + shovel+Shotgun
		    case 14: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,800),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,250);//2 dual pistols +Knuckles + BaseBall Bat + Shotgun
		    case 15: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,100),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,500);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 16: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,200),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,750);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 17: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,300),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,1000);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 18: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,400),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,1250);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 19: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,500),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,1500);//Deagle +Knuckles + knife + Shotgun
		    case 20: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,650),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,2000),GivePlayerWeapon(playerid,28,150),GivePlayerWeapon(playerid,33,50); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 21: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,800),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,2500),GivePlayerWeapon(playerid,28,200),GivePlayerWeapon(playerid,33,100); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 22: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1050),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,3000),GivePlayerWeapon(playerid,28,250),GivePlayerWeapon(playerid,33,150); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 23: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1200),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,3500),GivePlayerWeapon(playerid,28,300),GivePlayerWeapon(playerid,33,200); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 24: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1350),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,4000),GivePlayerWeapon(playerid,28,350),GivePlayerWeapon(playerid,33,250); //Deagle +Knuckles + Night Stick + Shotgun + UZIS + rifle
		    case 25: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1600),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,300),GivePlayerWeapon(playerid,28,400),GivePlayerWeapon(playerid,33,300); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 26: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,1800),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,400),GivePlayerWeapon(playerid,28,500),GivePlayerWeapon(playerid,33,400); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 27: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2000),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,500),GivePlayerWeapon(playerid,28,600),GivePlayerWeapon(playerid,33,500); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 28: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2200),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,600),GivePlayerWeapon(playerid,28,700),GivePlayerWeapon(playerid,33,600); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 29: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2400),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,700),GivePlayerWeapon(playerid,28,800),GivePlayerWeapon(playerid,33,700); //Deagle +Knuckles + Katana + Sawn-off Shotgun + UZIS + rifle
		    case 30: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,2700),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1000),GivePlayerWeapon(playerid,32,300),GivePlayerWeapon(playerid,30,120),GivePlayerWeapon(playerid,33,900); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 31: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3000),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1300),GivePlayerWeapon(playerid,32,400),GivePlayerWeapon(playerid,30,180),GivePlayerWeapon(playerid,33,1100); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 32: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3300),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1600),GivePlayerWeapon(playerid,32,500),GivePlayerWeapon(playerid,30,240),GivePlayerWeapon(playerid,33,1300); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 33: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3600),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,1900),GivePlayerWeapon(playerid,32,600),GivePlayerWeapon(playerid,30,300),GivePlayerWeapon(playerid,33,1500); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 34: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,3900),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,2200),GivePlayerWeapon(playerid,32,700),GivePlayerWeapon(playerid,30,360),GivePlayerWeapon(playerid,33,1700); //Deagle +Knuckles + ChainSaw + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 35: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,4500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,400),GivePlayerWeapon(playerid,32,1000),GivePlayerWeapon(playerid,30,420),GivePlayerWeapon(playerid,33,2000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 36: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,500),GivePlayerWeapon(playerid,32,1250),GivePlayerWeapon(playerid,30,540),GivePlayerWeapon(playerid,33,2300); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 37: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,5500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,600),GivePlayerWeapon(playerid,32,1500),GivePlayerWeapon(playerid,30,660),GivePlayerWeapon(playerid,33,2600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 38: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,700),GivePlayerWeapon(playerid,32,1750),GivePlayerWeapon(playerid,30,880),GivePlayerWeapon(playerid,33,2900); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 39: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,800),GivePlayerWeapon(playerid,32,2000),GivePlayerWeapon(playerid,30,1100),GivePlayerWeapon(playerid,33,3200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 40: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,6500),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1000),GivePlayerWeapon(playerid,32,2500),GivePlayerWeapon(playerid,31,200),GivePlayerWeapon(playerid,33,3600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 41: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,7000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1500),GivePlayerWeapon(playerid,32,3000),GivePlayerWeapon(playerid,31,350),GivePlayerWeapon(playerid,33,4000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 42: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,8000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,2000),GivePlayerWeapon(playerid,32,3500),GivePlayerWeapon(playerid,31,500),GivePlayerWeapon(playerid,33,4400); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 43: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,9000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,2500),GivePlayerWeapon(playerid,32,4000),GivePlayerWeapon(playerid,31,650),GivePlayerWeapon(playerid,33,4800); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 44: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,10000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,3000),GivePlayerWeapon(playerid,32,4500),GivePlayerWeapon(playerid,31,800),GivePlayerWeapon(playerid,33,5200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 45: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,11000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,4000),GivePlayerWeapon(playerid,29,600),GivePlayerWeapon(playerid,31,1000),GivePlayerWeapon(playerid,34,150); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 46: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,12000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,5000),GivePlayerWeapon(playerid,29,800),GivePlayerWeapon(playerid,31,1250),GivePlayerWeapon(playerid,34,300); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 47: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,13000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,6000),GivePlayerWeapon(playerid,29,1000),GivePlayerWeapon(playerid,31,1500),GivePlayerWeapon(playerid,34,450); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 48: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,14000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,7000),GivePlayerWeapon(playerid,29,1200),GivePlayerWeapon(playerid,31,1750),GivePlayerWeapon(playerid,34,600); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 49: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,15000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,8000),GivePlayerWeapon(playerid,29,1400),GivePlayerWeapon(playerid,31,2000),GivePlayerWeapon(playerid,34,750); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 50: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,16000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,10000),GivePlayerWeapon(playerid,29,1750),GivePlayerWeapon(playerid,31,2500),GivePlayerWeapon(playerid,34,1000); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 51..100: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,17000),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,12500),GivePlayerWeapon(playerid,29,2100),GivePlayerWeapon(playerid,31,3000),GivePlayerWeapon(playerid,34,1250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			
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
   		format(string2,sizeof string2,"CheckPoints Cleared: %i/~r~~h~8",CPscleared);
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
				PInfo[i][CanUseWeapons] = 1;
				TextDrawSetString(GainXPTD[i],string);
				SetTimerEx("ShowXP1",100,0,"d",i);
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
	   		format(string2,sizeof string2,"CheckPoints Cleared: %i/~r~~h~8",CPscleared);
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
					PInfo[i][CanUseWeapons] = 1;
					SetTimerEx("ShowXP1",100,0,"d",i);
					TextDrawShowForPlayer(i,GainXPTD[i]);
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
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot","Choose","Cancel");
	if(PInfo[playerid][Rank] == 14) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor","Choose","Cancel");
 	if(PInfo[playerid][Rank] == 15) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots","Choose","Cancel");
	if(PInfo[playerid][Rank] == 16) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm","Choose","Cancel");
	if(PInfo[playerid][Rank] == 20) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades","Choose","Cancel");
	if(PInfo[playerid][Rank] == 21) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds","Choose","Cancel");
	if(PInfo[playerid][Rank] >= 22) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves","Choose","Cancel");
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
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin","Choose","Cancel");
	if(PInfo[playerid][Rank] == 15) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig","Choose","Cancel");
	if(PInfo[playerid][Rank] == 16) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage \n17\tHigher Jumper","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage \n17\tHigher Jumper \n18\tRepellent","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage \n17\tHigher Jumper \n18\tRepellent \n19\tRavaging Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 20) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite\n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage \n17\tHigher Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper scream","Choose","Cancel");
	if(PInfo[playerid][Rank] >= 21) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrage \n17\tHigher Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper scream \n21\tHell Scream","Choose","Cancel");
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
	if(Fuel[vehicleid] == 0)
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
	if(Fuel[vehicleid] == 1)
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
	if(Fuel[vehicleid] == 2)
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
	if(Fuel[vehicleid] == 3)
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
	if(Fuel[vehicleid] == 4)
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
	if(Fuel[vehicleid] == 5)
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
	if(Fuel[vehicleid] == 6)
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
	if(Fuel[vehicleid] == 7)
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
	if(Fuel[vehicleid] == 8)
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
	if(Fuel[vehicleid] == 9)
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
	if(Fuel[vehicleid] >= 10)
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
	
	if(Oil[vehicleid] == 0)
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
	if(Oil[vehicleid] == 1)
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
	if(Oil[vehicleid] == 2)
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
	if(Oil[vehicleid] == 3)
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
	if(Oil[vehicleid] == 4)
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
	if(Oil[vehicleid] == 5)
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
	if(Oil[vehicleid] == 6)
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
	if(Oil[vehicleid] == 7)
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
	if(Oil[vehicleid] == 8)
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
	if(Oil[vehicleid] == 9)
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
	if(Oil[vehicleid] >= 10)
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
			if(PInfo[playerid][SPerk] == 20)
			{
			    SetPlayerHealth(playerid,health+70.0);
			}
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
            if(health >= 100.0) SetPlayerHealth(id,100.0);
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
			else SetPlayerHealth(playerid,health+35.0);
			if(PInfo[playerid][SPerk] == 20)
			{
			    SetPlayerHealth(playerid,health+45.0);
			}
			if(health >= 100.0) SetPlayerHealth(playerid,100.0);
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
			if(PInfo[playerid][SPerk] == 20)
			{
			    SetPlayerHealth(playerid,health+29.0);
			}
			if(health > 100.0) SetPlayerHealth(playerid,100.0);
		}
  	}
    if(!strcmp(ItemName,"Fuel",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(Fuel[vehid] >= 10) return SendClientMessage(playerid,white,"» "cred"This vehicle does not need anymore fuel.");
        RemoveItem(playerid,"Fuel",1);
        format(string,sizeof string,""cjam"%s has added some fuel to his vehicle.",GetPName(playerid));
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 2) Fuel[vehid]+=2;
		else Fuel[vehid]+=1;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Oil",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(Oil[vehid] >= 10) return SendClientMessage(playerid,white,"» "cred"This vehicle does not need anymore oil.");
        RemoveItem(playerid,"Oil",1);
        format(string,sizeof string,""cjam"%s has added some oil to his vehicle.",GetPName(playerid));
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 3) Oil[vehid]+=2;
		else Oil[vehid]+=1;
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
			SendNearMessage(playerid,white,string,30);
       	}
        else
        {
			SetPlayerAttachedObject(playerid, 1, 18656, 5, 0.1, 0.038, -0.1, -90.0, 180.0, 0.0, 0.03, 0.03, 0.03);
			SetPlayerAttachedObject(playerid, 2, 18641, 5, 0.1, 0.02, -0.05, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
			PInfo[playerid][Lighton] = 1;
			format(string,sizeof string,""cjam"%s has turned on his flashlight.",GetPName(playerid));
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
    if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
	else
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
	   		if(PInfo[i][Dead] == 1) continue;
		    if(Team[i] == HUMAN) continue;
			if(IsPlayerInRangeOfPoint(i,15.0,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
            PInfo[i][CanZombieRun] = 1;
			for(new f; f < MAX_PLAYERS;f++)
			{
			    ClearAnimations(i,1);
			}
		}
		PInfo[playerid][ZX] = 0.0;
		DestroyObject(PInfo[playerid][ZObject]);
		PInfo[playerid][ZombieBait] = 0;
		return 1;
	}
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

/*function Marker()
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
*/
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
			return 0;
/*
		    if(RoundEnded == 0)
		    {
				SetTimerEx("EndRound",3000,false,"i",1);
				GameTextForAll("~w~The round has ended.",3000,3);
				RoundEnded = 1;
			}
		}
		infects = 0;
*/
		}
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
			else {PInfo[playerid][XP] += 10;PInfo[playerid][CurrentXP] += 10;}
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			TextDrawSetString(GainXPTD[playerid],string);
			PInfo[playerid][ShowingXP] = 1;
			SetTimerEx("ShowXP1",100,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
		    PlaySound(playerid,1083);
		}
		else
		{
		    static string[7];
			if(PInfo[playerid][Premium] == 2){PInfo[playerid][XP] += 14;PInfo[playerid][CurrentXP] = 14;}
			else {PInfo[playerid][XP] += 10;PInfo[playerid][CurrentXP] += 10;}
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
		    SetTimerEx("ShowXP1",100,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
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


function SetPlayerHealthRank(playerid)
{
	if(PInfo[playerid][Rank] >= 1) SetPlayerHealth(playerid,100);
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
	static Float:x,Float:y,Float:z;
 	GetPlayerPos(playerid,x,y,z);
	PInfo[playerid][Deaths]++;
	PInfo[playerid][Dead] = 1;
    PInfo[playerid][JustInfected] = 1;
    Team[playerid] = ZOMBIE;
    GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
    SetPlayerColor(playerid,purple);
    SaveDeathZombieLastPos(playerid);
    PInfo[playerid][AfterLifeInfected] = 1;
    SetTimerEx("MinusHP",250,false,"i",playerid);
	PInfo[playerid][DeathsRound]++;
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

public DamageCheck(vehicleid,playerid)
{
    new Float:vh;//создаем переменную для хп транспорта
    new newstate = GetPlayerState(playerid);
    InOneVehicle[playerid] = GetPlayerVehicleID(playerid);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    InOneVehicle[i] = GetPlayerVehicleID(i);
	    if(PInfo[playerid][Infected] == 1)
		{
	        new Float:PH;
			GetPlayerHealth(playerid,PH);
			if(PH <= 1.0)
			InfectPlayer(playerid);
		}
		if (((newstate == PLAYER_STATE_DRIVER) || (newstate == PLAYER_STATE_PASSENGER)) || (InOneVehicle[playerid] == InOneVehicle[i]))
		{
			GetVehicleHealth(vehicleid, vh);//проверяем хп транспорта
		    if(1000 - vh >= 125)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(i, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(i, PH-5);//отнимаем хп у игрока(сколько было - 10)
			}
		    else if(1000 - vh >= 800)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-40);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 165)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-10);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 200)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-15);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 300) //ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-20);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 400)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-24);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 550)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-28);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 650)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-33);//отнимаем хп у игрока(сколько было - 10)
		    }
		    else if(1000 - vh >= 750)//ставим проверку, если 1000хп -vh(которое стало у авто) будет больше или равно 500, тогда ...
		    {
		        new Float:PH;//переменная для проверки хп игрока
		        GetPlayerHealth(playerid, PH);//проверяем сколько у игрока хп
		        SetPlayerHealth(playerid, PH-37);//отнимаем хп у игрока(сколько было - 10)
		    }
		}
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
	if(pickupid == ZFPC2)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC3)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC4)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC5)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC6)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC7)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC9)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC8)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC10)
	{
		new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}

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
    if(Team[playerid] == ZOMBIE)
	{
 		SendClientMessage(playerid,red,"You need to be in vehicle to hide!!");
		if(IsPlayerInAnyVehicle(playerid))
        {
			SendClientMessage(playerid,purple,"* You have successfully hidden!");
			SendClientMessage(playerid,0xFFA000FF,"* Write /unhide to stop hidding!");
			SendClientMessage(playerid,red,"* NOTE: You cant bite while you are hidding!!!");
			SetPlayerColor(playerid,(GetPlayerColor(playerid) & 0xFFFFFF00 ));
			/////SetPlayerColor(MAX_PLAYERS,playerid,(GetPlayerColor(MAX_PLAYERS) & 0xFFFFFF00 ));
			ApplyAnimation(playerid,"CRACK", "CRCKDETH2", 2.0, 0, 0, 1, 500, 1);
			Delete3DTextLabel(PInfo[playerid][Ranklabel]);
            for(new i; i < MAX_PLAYERS;i++)
			{
				ShowPlayerNameTagForPlayer(i,playerid,0);
                PInfo[playerid][CanBite] = 0;
 			}
		}
	}
	else
	{
		SendClientMessage(playerid,red,"* Only zombies can hide!");
 	}
 	return 1;
}

CMD:unhide(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(Team[playerid] == ZOMBIE)
  		{
		  	static string[88];
			ApplyAnimation(playerid,"Muscular","MuscleSprint",4.1,1,1,1,0,0,1);
			SendClientMessage(playerid,purple,"You have stopped hidding!");
			Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
			format(string,sizeof string,"Rank: %playerid | XP: %playerid/%playerid",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
			Update3DTextLabelText(PInfo[playerid][Ranklabel],purple,string);
	        {
	       		for(new i; i < MAX_PLAYERS;i++)
				{
					SetPlayerColor(playerid,purple);
					ShowPlayerNameTagForPlayer(i,playerid,1);
					PInfo[playerid][CanBite] = 1;
				}
			}
		}
		else if(Team[playerid] == HUMAN)
		{
 			SendClientMessage(playerid,purple,"You are not a zombie!");
		}
	}
	else
	{
		SendClientMessage(playerid,red,"You are not hidding!!");
 	}
 	return 1;
}

function AllowedToPowerfulGloves(playerid)
{
	SendClientMessage(playerid,red,"» Your gloves are ready to use (Powerful Gloves ready)!");
	PInfo[playerid][CanPowerfulGloves] = 1;
	return 1;
}

function CanZombieBait(playerid)
{
	SendClientMessage(playerid,red,"» You have found a zombie bait! (Zombie Bait Ready)");
	PInfo[playerid][AllowedToBait] = 1;
	return 1;
}

function PowerfulGlovesSound(playerid)
{
    PlaySound(playerid,14600);
    return 1;
}

function PowerfulGlovesThrow(i)
{
	static Float:x,Float:y,Float:z;
	ApplyAnimation(i,"PED","KO_skid_front",1.25,1,0,0,0,900,1);
	SetPlayerVelocity(i,x+2.5,y,z+3);
    return 1;
}

function FACETOPOSETIMERBAIT(f)
{
	for(new i; i < MAX_PLAYERS;i++)
	{
		TurnPlayerFaceToPos(f,PInfo[i][ZX],PInfo[i][ZY]);
	}
	return 1;
}

function VELOCITYONZOMBIEBAIT(f)
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		new Float:a,Float:x,Float:y,Float:z;
		GetPlayerVelocity(f,x,y,z);
		GetPlayerFacingAngle(f,a);
		x += ( 0.5 * floatsin( -a, degrees ) );
		y += ( 0.5 * floatcos( -a, degrees ) );
		SetPlayerVelocity(f,PInfo[i][ZX]-0.001,y,PInfo[i][ZZ]+0.09);
	}
	return 1;
}

function DestroyBait(playerid)
{
    for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
    }
    return 1;
}

function BaitPhase4(playerid)
{
    PInfo[playerid][ThrowingBaitPhase3] = 0;
    PInfo[playerid][ThrowingBaitPhase2] = 0;
    PInfo[playerid][ThrowingBaitPhase1] = 0;
    PInfo[playerid][ThrowingBaitPhase4] = 1;
    return 1;
}

function BaitPhase3(playerid)
{
    PInfo[playerid][ThrowingBaitPhase4] = 0;
    PInfo[playerid][ThrowingBaitPhase2] = 0;
    PInfo[playerid][ThrowingBaitPhase1] = 0;
    PInfo[playerid][ThrowingBaitPhase3] = 1;
    return 1;
}

function BaitPhase2(playerid)
{
    PInfo[playerid][ThrowingBaitPhase4] = 0;
    PInfo[playerid][ThrowingBaitPhase3] = 0;
    PInfo[playerid][ThrowingBaitPhase1] = 0;
    PInfo[playerid][ThrowingBaitPhase2] = 1;
    return 1;
}

function BaitPhase1(playerid)
{
    PInfo[playerid][ThrowingBaitPhase4] = 0;
    PInfo[playerid][ThrowingBaitPhase3] = 0;
    PInfo[playerid][ThrowingBaitPhase2] = 0;
    PInfo[playerid][ThrowingBaitPhase1] = 1;
    return 1;
}

function ResetThrow(playerid)
{
	PInfo[playerid][ThrowingBaitPhase4] = 1;
    PInfo[playerid][ThrowingBaitPhase3] = 1;
    PInfo[playerid][ThrowingBaitPhase2] = 1;
    PInfo[playerid][ThrowingBaitPhase1] = 1;
	return 1;
}

function StingerPhase1(i)
{
    ApplyAnimation(i,"PED","DAM_LegL_frmLT",2,1,0,0,0,600,1);
	return 1;
}

function StingerPhase2(i)
{
    ApplyAnimation(i,"PED","DAM_armR_frmFT",2,1,0,0,0,600,1);
	return 1;
}

function CanBeStingeredTime(i)
{
    PInfo[i][CanStinger] = 1;
	return 1;
}

public SaveDeathZombieLastPos(playerid)
{
    {
    	GetPlayerPos(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
    }
	return 1;
}

function TeleportToLastPos(playerid)
{
    SetPlayerPos(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]+3);
    return 1;
}
CMD:weapons(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) SendClientMessage(playerid,white,"**"cred"Only humans can change weapons!");
    if((PInfo[playerid][CanUseWeapons] == 0) && (Team[playerid] == HUMAN)) SendClientMessage(playerid,white,"**"cred"You need to clear CheckPoint, to change weapons again!");
	if((PInfo[playerid][CanUseWeapons] == 1) && (Team[playerid] == HUMAN))
	{
	    if(PInfo[playerid][Rank] <= 4) return ShowPlayerDialog(playerid, WeaponD, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50","Select","Cancel");
	    else if((PInfo[playerid][Rank] > 4) && (PInfo[playerid][Rank] <=9)) return ShowPlayerDialog(playerid, 1501, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100","Select","Cancel");
        else if((PInfo[playerid][Rank] > 9) && (PInfo[playerid][Rank] <=14)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150","Select","Cancel");
		else if((PInfo[playerid][Rank] > 14) && (PInfo[playerid][Rank] <=19)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150","Select","Cancel");
		else if((PInfo[playerid][Rank] > 19) && (PInfo[playerid][Rank] <=24)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50","Select","Cancel");
		else if((PInfo[playerid][Rank] > 24) && (PInfo[playerid][Rank] <=29)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200","Select","Cancel");
		else if((PInfo[playerid][Rank] > 29) && (PInfo[playerid][Rank] <=34)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200\nAK-47 and TEC\t30\t90 and 250","Select","Cancel");
		else if((PInfo[playerid][Rank] > 34) && (PInfo[playerid][Rank] <=39)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200\nAK-47 and TEC\t30\t90 and 250\nCombat Shotgun\t35\t250","Select","Cancel");
		else if((PInfo[playerid][Rank] > 39) && (PInfo[playerid][Rank] <=44)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200\nAK-47 and TEC\t30\t90 and 250\nCombat Shotgun\t35\t250\nM4\t40\t300","Select","Cancel");
		else if((PInfo[playerid][Rank] > 44) && (PInfo[playerid][Rank] <=49)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200\nAK-47 and TEC\t30\t90 and 250\nCombat Shotgun\t35\t250\nM4\t40\t300\nSniper Rifle and SMG\t45\t150 and 350","Select","Cancel");
		else if(PInfo[playerid][Rank] >=50)  return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t50\nDual Colt\t5\t100\nShotgun\t10\t150\nDesert Eagle\t15\t150\nUZI's and Rifle\t20\t200 and 50\nSawnoff Shotgun\t25\t200\nAK-47 and TEC\t30\t90 and 250\nCombat Shotgun\t35\t250\nM4\t40\t300\nSniper Rifle and SMG\t45\t150 and 350","Select","Cancel");
	}
	return 1;
}

public OnPlayerCommandReceived(playerid,cmdtext[])
{
	if(PInfo[playerid][Logged] == 0)
 	{
  		SendClientMessage(playerid,red,""cwhite"** "cred"Error: you need to login to write any commands!");
    	return 0;
    }
	return 1;
}

function DeleteBlood(playerid)
{
    for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i)) RemovePlayerAttachedObject(playerid, i);
    }
    return 1;
}

function CanBeSpittedTimer(i)
{
	PInfo[i][CanBeSpitted] = 1;
	return 1;
}

function Radar(playerid)
{
	if(Team[playerid] == ZOMBIE)
	{
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if((PInfo[playerid][ZPerk] == 5) && (Team[i] == ZOMBIE))
			{
   				SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
			}
			else if((PInfo[playerid][ZPerk] != 5) && (Team[i] == ZOMBIE))
			{
				SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
			}
			if(Team[i] == HUMAN)
			{
				SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
			}
		}
	}
	if(Team[playerid] == HUMAN)
	{
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(Team[i] == HUMAN) SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
	        else if((PInfo[playerid][Lighton] == 1) && (Team[i] == ZOMBIE))
	        {
	            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
			}
			else if((PInfo[playerid][Lighton] == 0) && (Team[i] == ZOMBIE))
			{
			    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
			}
		}
	}
	return 1;
}

CMD:froze(playerid,params[])
{
   	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/froze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,""cwhite"* "cred"Player is not connected!");
	TogglePlayerControllable(id, 0);
	static string[100];
	format(string,sizeof string,"|| Administrator %s has frozen %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	return 1;
}

CMD:unfroze(playerid,params[])
{
   	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/froze <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,""cwhite"* "cred"Player is not connected!");
	TogglePlayerControllable(id, 1);
	static string[100];
	format(string,sizeof string,"|| %s was unfrozed by Administartor %s||",GetPName(id),GetPName(playerid));
	SendAdminMessage(red,string);
	return 1;
}

stock GetHisIP(playerid)
{
	new ip[16];
	GetPlayerIp(playerid,ip,16);
	return ip;
}

public OnPlayerText(playerid, text[])
{
    new sendername[32];
    static string[100];
    GetPlayerName(playerid, sendername, 32);
    if(Team[playerid] == HUMAN)
    {
    	format(string, 128, ""cwhite"|%d| "cgreen"%s: "cwhite"%s", playerid, sendername, text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
	}
	else if(Team[playerid] == ZOMBIE)
	{
	 	format(string, 128, ""cwhite"|%d| "cjam"%s: "cwhite"%s", playerid, sendername, text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
	}
	if(PInfo[playerid][Logged] == 0)
 	{
  		SendClientMessage(playerid,red,""cwhite"** "cred"Error: you need to login to write any messages!");
    	return 0;
    }
    return 0;
}

function DissapearBloodPhase1(i)
{
    TextDrawHideForPlayer(i,Textdraw1);
    TextDrawHideForPlayer(i,Textdraw4);
    TextDrawHideForPlayer(i,Textdraw9);
    TextDrawHideForPlayer(i,Textdraw13);
    TextDrawHideForPlayer(i,Textdraw14);
    TextDrawHideForPlayer(i,Textdraw19);
    TextDrawHideForPlayer(i,Textdraw31);
    TextDrawHideForPlayer(i,Textdraw35);
    TextDrawHideForPlayer(i,Textdraw37);
    TextDrawHideForPlayer(i,Textdraw39);
    TextDrawHideForPlayer(i,Textdraw33);
    TextDrawHideForPlayer(i,Textdraw32);
    TextDrawHideForPlayer(i,Textdraw22);
    return 1;
}

function DissapearBloodPhase2(i)
{
    TextDrawHideForPlayer(i,Textdraw2);
    TextDrawHideForPlayer(i,Textdraw7);
    TextDrawHideForPlayer(i,Textdraw10);
    TextDrawHideForPlayer(i,Textdraw21);
    TextDrawHideForPlayer(i,Textdraw25);
    TextDrawHideForPlayer(i,Textdraw28);
    TextDrawHideForPlayer(i,Textdraw30);
    TextDrawHideForPlayer(i,Textdraw34);
    TextDrawHideForPlayer(i,Textdraw36);
    TextDrawHideForPlayer(i,Textdraw38);
    TextDrawHideForPlayer(i,Textdraw3);
    TextDrawHideForPlayer(i,Textdraw15);
    TextDrawHideForPlayer(i,Textdraw20);
    TextDrawHideForPlayer(i,Textdraw37);
    return 1;
}

function DissapearBloodPhase3(i)
{
    TextDrawHideForPlayer(i,Textdraw5);
    TextDrawHideForPlayer(i,Textdraw6);
    TextDrawHideForPlayer(i,Textdraw8);
    TextDrawHideForPlayer(i,Textdraw11);
    TextDrawHideForPlayer(i,Textdraw12);
    TextDrawHideForPlayer(i,Textdraw17);
    TextDrawHideForPlayer(i,Textdraw23);
    TextDrawHideForPlayer(i,Textdraw24);
    TextDrawHideForPlayer(i,Textdraw25);
    TextDrawHideForPlayer(i,Textdraw28);
    TextDrawHideForPlayer(i,Textdraw29);
    TextDrawHideForPlayer(i,Textdraw32);
    TextDrawHideForPlayer(i,Textdraw27);
    return 1;
}

CMD:inf(playerid,params[])
{
    PInfo[playerid][Infected] = 1;
    return 1;
}

function UpdateBait()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
        if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == HUMAN)
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
                    new Float:x,Float:y,Float:z;
                    GetPlayerVelocity(f,x,y,z);
					TurnPlayerFaceToPos(f,PInfo[i][ZX],PInfo[i][ZY]);
					PInfo[f][CanZombieRun] = 0;
					ApplyAnimation(f, "PED" , "WALK_SHUFFLE" , 5.0 , 0 , 1 , 1 , 0 , 15000 , 1);
					SetPlayerVelocity(f,x,y,z+0.15);
				}
			}
		}
	}
	return 1;
}

CMD:givexp(playerid,params[])
    return GivePlayerXP(playerid);

function RANKUP2(playerid)//2nd phase
{
    TextDrawHideForPlayer(playerid,RANKUP[playerid]);
    RANKUP[playerid] = TextDrawCreate(280.110992, 98.564453, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.656670, 0.848346);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 0);
	TextDrawBackgroundColor(RANKUP[playerid], 51);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	TextDrawSetString(RANKUP[playerid],"RANK UP!");
	SetTimerEx("RANKUP3",100,0,"i",playerid);
	TextDrawShowForPlayer(playerid,RANKUP[playerid]);
	return 1;
}

function RANKUP3(playerid)
{
	TextDrawHideForPlayer(playerid,RANKUP[playerid]);
	RANKUP[playerid] = TextDrawCreate(279.333129, 93.591117, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.685115, 1.301323);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 0);
	TextDrawBackgroundColor(RANKUP[playerid], 51);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	TextDrawSetString(RANKUP[playerid],"RANK UP!");
	SetTimerEx("RANKUP4",100,0,"i",playerid);
	TextDrawShowForPlayer(playerid,RANKUP[playerid]);
	return 1;
}

function RANKUP4(playerid)
{
    TextDrawHideForPlayer(playerid,RANKUP[playerid]);
    RANKUP[playerid] = TextDrawCreate(278.555480, 84.635551, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.726448, 2.013146);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 0);
	TextDrawBackgroundColor(RANKUP[playerid], 51);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	TextDrawSetString(RANKUP[playerid],"RANK UP!");
	SetTimerEx("RANKUP5",100,0,"i",playerid);
	TextDrawShowForPlayer(playerid,RANKUP[playerid]);
	return 1;
}

function RANKUP5(playerid)
{
    TextDrawHideForPlayer(playerid,RANKUP[playerid]);
    RANKUP[playerid] = TextDrawCreate(275.999877, 74.684463, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.793116, 2.784701);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 0);
	TextDrawBackgroundColor(RANKUP[playerid], 51);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	TextDrawSetString(RANKUP[playerid],"RANK UP!");
	SetTimerEx("RANKUP6",100,0,"i",playerid);
	TextDrawShowForPlayer(playerid,RANKUP[playerid]);
	return 1;
}

function RANKUP6(playerid)
{
    TextDrawHideForPlayer(playerid,RANKUP[playerid]);
    RANKUP[playerid] = TextDrawCreate(275.666503, 73.693344, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.793116, 2.784701);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 1);
	TextDrawBackgroundColor(RANKUP[playerid], 255);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	TextDrawSetString(RANKUP[playerid],"RANK UP!");
	SetTimerEx("HIDERANKUP",1250,0,"i",playerid);
	TextDrawShowForPlayer(playerid,RANKUP[playerid]);
	return 1;
}

function HIDERANKUP(playerid)
{
	TextDrawHideForPlayer(playerid,RANKUP[playerid]);
	RANKUP[playerid] = TextDrawCreate(280.888824, 104.035560, "RANK UP!");
	TextDrawLetterSize(RANKUP[playerid], 0.647780, 0.295812);
	TextDrawAlignment(RANKUP[playerid], 1);
	TextDrawColor(RANKUP[playerid], -1);
	TextDrawSetShadow(RANKUP[playerid], 0);
	TextDrawSetOutline(RANKUP[playerid], 0);
	TextDrawBackgroundColor(RANKUP[playerid], 51);
	TextDrawFont(RANKUP[playerid], 1);
	TextDrawSetProportional(RANKUP[playerid], 1);
	return 1;
}

command(launch,playerid, params[])
{
	#define SPEED (15.0)
	#define Z_SPEED (10.0)
	#define GRAVITY (50.0) // Deagle Model ID
	new Float:x, Float:y, Float:z, Float:ang;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, ang);
	new obj = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
 	PHY_InitObject(obj);
	PHY_SetObjectVelocity(obj, SPEED * floatsin(-ang, degrees), SPEED * floatcos(-ang, degrees), Z_SPEED);
	PHY_SetObjectFriction(obj, 500); // This will stop the object when it touchs the ground.
	PHY_SetObjectGravity(obj, GRAVITY);
	PHY_SetObjectZBound(obj, z - 0.9, _, 0.0);
	ApplyAnimation(playerid,"GRENADE","WEAPON_throwu",3.0,0,0,0,0,0);
	return 1;
}

function MinusHP(playerid)
{
	SetPlayerHealth(playerid,0);
	return 1;
}

public OnPlayerClickPlayer(playerid,clickedplayerid,source)
{
	if(PInfo[playerid][Logged] == 0) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR: You must to log in to check stats of other players!");
	else
	{
	    if(PInfo[playerid][Logged] == 1)
	    {
     		static string[50];
 			format(string,sizeof string,""cwhite"» "cgreen"%s is logged in!",GetPName(clickedplayerid));
			SendClientMessage(playerid,white,string);
		}
		else
  		{
     		static string[50];
 			format(string,sizeof string,""cwhite"» "cblue"%s is NOT logged in!",GetPName(clickedplayerid));
			SendClientMessage(playerid,white,string);
		}
		static sstring[128];
		format(sstring,sizeof sstring,""cwhite"User: %s",GetPName(clickedplayerid));
		new string[256];
		format(string,sizeof (string),""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n",PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1);

		//format(string,sizeof (string),""cwhite"\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i",PInfo[clickedplayerid][Kills],PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths]);
		ShowPlayerDialog(playerid, 228, DIALOG_STYLE_MSGBOX, sstring, string, "Close", "");
	}
	return 1;
}


