#include <a_samp>
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     50
#define FIXES_ServerVarMsg 0
#include <fixes>
#include <nex-ac>
#include <sscanf2>
#include <streamer>
#include <mxini>
#include <foreach>
#include <GetVehicleName>
#include <SII>
#include <Pawn.CMD>
#include <j_inventory_v2>
#include <FCNPC>
#include <colandreas>
#include <MAP>
#include <projectile>
//============================[INCLUDES END]====================================
//===========================[DEFINES START]====================================
#define Userfile 														"Admin/Users/%s.ini"
#define snowing                                                         true
#define Version                                                         "2.0"
#define CPTIME                                                          210000//100000Time between each checkpoint 90000
#define CPVALUE                                                         195//175CPValue, the value of, when it gets reached, it the cp gets cleared. 175
#define DIGTIME                                                         120000//Time of cooldown between digging.
#define VOMITTIME                                                       90000//(90000)Time of cooldown between vomitting.
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
#define SusImmunitydialog                                               51
#define MasterRadardialog                                               52
#define FusionBootsdialog                                               53
#define ExplosiveGreeting                                               54
#define ExplodingBait                                                   55
#define SmokeGrenade                                                    56
#define ShadowWarrior                                                   57
#define AssGrLauncher                                                   58
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
#define HumanPerkBoosting                                               2600
#define ZombiePerkBoosting                                              2601
#define BoostingMenu                                                    2602
#define Help                                                            1000
#define HelpMode                                                        1001
#define HelpHuman                                                       1002
#define HelpZombie                                                      1003
#define HelpRule                                                        1004
#define HiveTP                                                          1100
#define WeaponD                                                         1500
#define ShopDialog                                                      1488
#define DonateDialog                                                    2277
#define AdminHelp                                                       1700
#define CraftDialog                                                     100
#define DNADialog                                                       110
#define ChangeModDialog                                                 130
//============================== [Dialogs] =====================================
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
#define pred                                                            0x490B0BFF
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
#define MAX_VEHICLES                                                    200
#undef 	MAX_ITEMS
#define MAX_ITEMS 														21
#undef  MAX_ITEM_STACK
#define MAX_ITEM_STACK                                                  5000
#undef  MAX_ITEM_NAME
#define MAX_ITEM_NAME 													24
#define isEven(%0) 														(!((%0) & 0b1))
#define isOdd(%0) 														!isEven((%0))
#define DSL 															DIALOG_STYLE_LIST
#define DSI 															DIALOG_STYLE_INPUT
#define DSM 															DIALOG_STYLE_MSGBOX
#define DSP 															DIALOG_STYLE_PASSWORD
#define DSTH                                                            DIALOG_STYLE_TABLIST_HEADERS
#define GRENADE_SPEED \
	40.0
#define GRENADE_OBJECT \
    342
#define MAX_PLAYER_GRENADES \
	1
#define MAX_GRENADES \
	(MAX_PLAYERS * MAX_PLAYER_GRENADES)
///////////////////////////////////////////////////////////////////////////////////////////////////////
///============================== [FCNPC config] ===============================
#define FCNPC_MOVE_TYPE_AUTO      										(-1)
#define FCNPC_MOVE_TYPE_WALK      										(0)
#define FCNPC_MOVE_TYPE_RUN       										(1)
#define FCNPC_MOVE_TYPE_SPRINT    										(2)
#define FCNPC_MOVE_TYPE_DRIVE     										(3)

#define FCNPC_MOVE_SPEED_AUTO     										(-1.0)
#define FCNPC_MOVE_SPEED_WALK     										(0.1552086)
#define FCNPC_MOVE_SPEED_RUN      										(0.56444)
#define FCNPC_MOVE_SPEED_SPRINT   										(0.926784)

#define FCNPC_MAX_NODES           										(64)

#define FCNPC_INVALID_MOVEPATH_ID 										(-1)
#define FCNPC_INVALID_RECORD_ID   										(-1)
//============================== [FCNPC config] ================================
//===============================[DEFINES END]==================================

//============================== [Server config] ===============================
//============================== [FORWARDS START] ==============================
forward OnCheatDetected(playerid, ip_address[], type, code);
forward OnNOPWarning(playerid, nopid, count);
forward SaveDeathZombieLastPos(playerid);
forward UnFreezePlayer(playerid);
forward pingchecktimer(playerid);
//================================ [FORWARDS END] ==============================

main(){}
native WP_Hash(buffer[], len, const str[]);

//=============================[Text Draw's Start]==============================
new Text:GainXPTD[MAX_PLAYERS];
new Text:RANKUP[MAX_PLAYERS];
new Text:Stats[MAX_PLAYERS];
new Text:FuelTD[MAX_PLAYERS];
new Text:OilTD[MAX_PLAYERS];
new Text:OILANDFUELTD[MAX_PLAYERS];
new Text:XPBox[MAX_PLAYERS];
new Text:XPStats[MAX_PLAYERS];
new Text:Infection[MAX_PLAYERS];
new Text:CPSCleared[MAX_PLAYERS];
new Text:CPvaluepercent[MAX_PLAYERS];
new Text:XPLEFT[MAX_PLAYERS];
new Text:XPRIGHT[MAX_PLAYERS];
new Text:Dark[MAX_PLAYERS];
new Text:SkinChange[MAX_PLAYERS];
new Text:ZOMSURV[MAX_PLAYERS];
new Text:ArrLeft[MAX_PLAYERS];
new Text:ArrRight[MAX_PLAYERS];
new Text:Effect[9][MAX_PLAYERS];
new Text:RageTD[MAX_PLAYERS];
new Text:CPbar[MAX_PLAYERS];
new Text:CPvaluebar[MAX_PLAYERS];
new Text:CPbartext[MAX_PLAYERS];
new Text:BloodHemorhage[MAX_PLAYERS][40];
new Text:PlayerHealth[MAX_PLAYERS];
new Text:RagePlus[MAX_PLAYERS];
new Text:MatDNAPlus[MAX_PLAYERS];
//===============================[Text Draw's END]==============================
//==============================[MASSIVES START]================================
new Float:Locations[6][6] =
{
    {1215.3832,-13.3531,1000.9219,2421.7861,-1225.6342,25.1479},//Pig Pen
	{502.3529,-15.2895,1000.6719,1833.2510,-1681.9969,13.4811},//Alhambra

	{212.5261,-107.4397,1005.2406,2241.1416,-1658.3157,15.2899},//Binco
	{175.6414,-83.1425,1001.8047,1458.4044,-1141.6309,24.0566},//Zip

	{169.9776,-1797.8832,4.1339,173.6723,-1798.2090,4.0596},//beach
	{2164.6807,-1985.9213,13.5547,2163.9861,-1987.4554,13.9685}//Waste industrial
};
new Float:HiveMeatPos[9][3] =
{
	{1406.3240,-1450.8529,1721.7734},
	{1397.7505,-1452.8732,1721.7734},
	{1410.4015,-1468.5514,1721.7734},
	{1398.8356,-1463.8278,1721.7734},
	{1384.9185,-1463.2385,1721.7734},
	{1371.3898,-1465.1289,1721.7734},
	{1362.7053,-1445.1117,1721.7734},
	{1405.1270,-1418.7037,1721.7734},
	{1401.1051,-1425.9554,1721.7734}
};
new Float:LootOutSide[37][3] =
{
	{2339.4856,-1146.8267,27.4042},
	{2276.1023,-929.9330,28.0409},
	{2437.8464,-1013.4548,54.3438},
	{2051.1807,-1714.5785,13.5547},
	{2094.0132,-2038.6168,18.7733},
	{2230.4419,-2285.5229,14.3751},
	{1682.4973,-2105.1982,13.5469},
	{1436.9169,-1911.7683,25.4370},
	{976.7569,-2148.4744,13.0938},
	{844.9081,-2065.0095,12.8672},
	{835.6259,-2066.5510,12.8672},
	{825.3628,-2060.5806,12.8672},
	{152.8300,-1959.6090,3.7734},
	{324.7328,-1340.0354,17.9531},
	{864.1320,-1297.6951,13.7290},
	{655.2720,-1698.3627,21.8116},
	{1364.3754,-1588.0878,8.6323},
	{1302.1517,-1250.9214,13.5469},
	{1341.2764,-655.0290,108.4832},
	{1547.0929,-1432.7596,23.6172},
	{2110.5652,-1497.0156,10.4219},
	{2810.2029,-1087.0118,30.8839},
	{2371.4734,-2135.7354,27.1797},
	{1098.0568,-826.1382,114.4477},
	{2094.6689,-1815.2462,13.3828},
	{106.4967,-1272.7554,14.6764},
	{90.2109,-1252.5814,14.5447},
	{821.0381,-1356.2751,-0.5078},
	{385.1712,-1079.1930,15.7058},
	{1063.1442,-1562.3579,30.6127},
	{2444.0085,-1719.4344,13.7610},
	{815.5817,-1107.6548,25.7901},
	{2674.5339,-1807.7152,10.3125},
	{802.4839,-1608.7136,22.5345},
	{2330.1111,-1237.6958,22.5000},
	{1731.2758,-1377.2944,30.5234},
	{414.5635,-1606.0372,34.2944}
};
new Float:HiveTeleports[51][3] =
{
	{1462.3741,-1467.1541,1721.6194},
	{1450.4314,-1487.6895,1721.4850},
	{1399.8497,-1507.2013,1721.5878},
	{1372.4011,-1513.4725,1721.4338},
	{1339.2291,-1484.6761,1720.9016},
	{1327.0029,-1452.2429,1721.4467},
	{1360.6263,-1405.1072,1721.8595},
	{1403.1323,-1403.3535,1721.1420},
	{1438.6443,-1403.9200,1720.8679},
	{1458.1005,-1430.9438,1721.1080},
	{1406.0012,-1315.0118,10.0677},
	{1414.7440,-1318.9203,10.0677},
	{1874.5465,-961.1121,50.9356},
	{1887.3398,-960.7676,53.2585},
	{1891.8740,-959.6703,54.4854},
	{2628.5154,-1511.4587,22.0238},
	{2605.6951,-1459.2465,22.4020},
	{2620.1348,-1459.8759,22.4020},
	{2591.3193,-1459.4043,22.6757},
	{1995.5281,-2033.3259,14.2169},
	{1993.9331,-2017.2268,14.0614},
	{2007.8885,-2043.8655,14.0614},
 	{2097.5833,-2489.8188,14.3444},
	{2122.4954,-2468.6140,14.0712},
	{2093.4941,-2419.0759,14.5826},
	{2085.3616,-2412.8171,14.5826},
	{1883.2061,-1819.7147,6.1719},
	{1893.2731,-1821.8771,6.1719},
	{1874.1426,-1816.9952,6.1719},
	{1902.7710,-1836.0640,6.4798},
	{1912.1761,-1838.5150,7.0770},
	{1921.5569,-1840.5591,7.7665},
	{1794.3229,-744.2861,60.7188},
	{1801.3141,-741.4772,62.3130},
	{1797.4307,-749.1287,62.4831},
	{1339.9188,-1809.8347,15.1508},
	{1340.4042,-1817.9510,14.5508},
	{1343.6465,-1820.8569,14.5508},
	{1098.1563,-1879.8721,13.9852},
	{1107.3665,-1887.4077,14.2552},
	{1120.8400,-1887.3119,14.2552},
	{874.9680,-1354.5143,14.8162},
	{865.3853,-1367.8021,14.8162},
	{848.9867,-1361.1276,14.8162},
	{761.4507,-1019.5132,26.7071},
	{760.7345,-1023.8637,26.7881},
	{762.5928,-1014.1992,25.3124},
	{371.2814,-1725.7188,8.0657},
	{359.4603,-1736.4319,7.7397},
	{359.6089,-1744.9672,7.0153},
	{359.8054,-1747.9290,6.8089}
};
new Float:Searchplaces[45][3] =
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
    {2374.3179,-1128.3701,1050.8750},
    {218.1223,70.7492,1005.0391},
    {253.6346,68.9887,1003.6406},
    {2238.0271,-1156.7137,1029.7969},
    {2244.4263,-1162.8511,1029.7969},
    {2238.0420,-1167.5487,1029.7969},
    {2231.0986,-1172.7067,1029.7969},
    {2228.7192,-1185.4711,1029.7969},
    {2204.0354,-1195.3604,1029.7969},
    {2204.0352,-1192.4764,1029.7969},
    {2197.0256,-1178.6289,1029.8043},
    {2190.0464,-1153.9617,1029.7969},
    {2203.2920,-1155.0680,1029.7969},
    {1546.8245,-1352.8496,329.6554},
    {1527.4543,-1366.2529,333.5297},
    {2182.2810,-1206.6904,1049.0234},
    {2182.2815,-1203.2910,1049.0234},
    {2183.8447,-1201.5239,1049.0308},
    {2187.9939,-1213.3485,1049.0234},
    {205.4820,1858.6931,13.1406},
    {2198.7649,-1219.3342,1049.0234}
};

new Float:LootMaterials[6][4] =
{
	{2778.0483,-2464.6934,13.6360},
	{2778.0151,-2447.3684,13.6361},
	{2777.9507,-2502.3679,13.6533},
	{2777.9255,-2485.0920,13.6500},
	{2777.8896,-2409.2441,13.6361},
	{2777.9451,-2426.1428,13.6361}
};

new Float:CraftArrows[4][4] =
{
	{2786.6582,-2476.2073,13.6418},
	{2788.2136,-2474.8875,13.6414},
	{2786.7424,-2473.5837,13.6339},
	{2785.5251,-2474.8506,13.6342}
};

new Float:Randomspawns[12][4] =
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
    {2749.2595,-1205.5306,67.4844,85.0762},
    {2691.1140,-1699.1893,10.4607,42.3558}
};
new Float:Platspawns[4][4] =
{
    {251.9797,-1221.0530,75.7547,220.2234},
    {257.2691,-1219.7448,75.2733,209.6196},
    {250.9525,-1225.0941,75.1626,215.1239},
    {239.0879,-1202.1403,76.1403,33.0048}
};
new Float:Diamspawns[3][4] =
{
    {299.1855,-1155.2341,80.9099,136.8497},
    {304.8700,-1159.7954,80.9099,119.2038},
    {323.4554,-1149.0270,81.5934,316.3053}
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
//==================================[MASSIVES END]==============================
//===================================[ENUMS START]==============================
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
	IgnoreHim,
	Resuedsstrength,
    CraftingTable,
    Antiblindpills,
    Nitro,
    StingerBullets,
    BeaconBullets,
    ImpactBullets,
    Mines,
    CanGiveDizzy,
    Poisoned,
	MineObject,
	ChoseMap,
	CheckMine,
	Resueded,
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
    ExtraXPRealTime,
    PremiumRealTime,
    Training,
    CanGoAFK,
    Afk,
    TradeID,
    PoisonDizzy,
    ImpactBulletsInUse,
    StingerBulletsInUse,
    BeaconBulletsInUse,
    Kicked,
    ResuedObj,
    ResotoreHiveHP,
    SkipRequestClass,
    BeaconMarker,
    WhatThrow,
    DNIPoints,
    Materials,
    GroupName[32],
    SureToLeave,
    SecondsBKick,
    Text3D:ResuedLabel,
	ModeSlot1,
	ModeSlot2,
	ModeSlot3,
	Float:ResusX,
	Float:ResusY,
	Float:ResusZ,
	CanResusDig,
    AllowHACForFightTimer,
    CanHide,
    FlashBangTimerPhase2,
    FlashBangTimerPhase3,
    FlashBangTimerPhase4,
    FlashBangTimerPhase5,
    FlashBangTimerPhase6,
    TrainingPhase,
    PickLockStatus,
    CountHP,
    TeamChooseTimer,
    Waswarnedbh,
    CanUsePickLock,
    ChooseAfterTr,
    KillWarning,
    FoundBullets,
    CanKick,
    MaxGrenades,
    CanGrenadeAgain,
    VotedYes,
    Skin,
	Flashed,
    ACWarning,
    WarningAmmo,
    CanUseSeismicShock,
    FakePerk,
    CheckMuteTimer,
    CJRunWarning,
    SeismicPhase,
    EnabledAC,
    GotInsameRage,
    GotHealingRage,
    GotMoreRage,
    GotImperception,
    GotAccurateDigger,
    GotDizzyTrap,
    GotEdibleResidues,
    GotResuscitation,
    GotCrowdedStomach,
    GotRegeneration,
    GotCollector,
    GotStabilizer,
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
	CanBeStomped,
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
	NewRegExtraXP,
	NewRegExtraXPTime,
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
 	JustRegistered,
 	CPCleared,
 	Assists,
 	Jailed,
	HideInVehicle,
 	Vomited,
 	XPToRankUp,
 	InSearch,
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
    TokeBlind,
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
	Float:AccurX,
	Float:AccurY,
	Float:AccurZ,
	Grenades,
	MuteTimer,
	CanBeStingBull,
	AlreadyChangeMod,
	JailTimer,
	FlashLightTimerOn,
	Throwingstate,
	ThrowingTimer,
	ObjectProj,
	Float:ObjAngz,
	ToBaitTimer,
	Throwed
}

enum E_GBUG
{
        Float:gbug_playerpos[3],
        Float:gbug_vehpos[3],
        gbug_playerenteringveh,
        gbug_pentervtick

}
//=================================[ENUMS END]==================================
//==============================[VARIABLES START]===============================
new LoginTimer[MAX_PLAYERS];
new ExplosionObjective;
new FlashLightTimer[MAX_PLAYERS];
new RageModeTimer[MAX_PLAYERS];
new FloodTimer[MAX_PLAYERS];
new FirstStepMolotov[MAX_PLAYERS];
new SecondStepMolotov[MAX_PLAYERS];
new ThirdStepMolotov[MAX_PLAYERS];
new GateZombie1;
new GateZombie2;
new RandWeather[] = {7,9,19,20,276,367,55};
new RWeather;
new PickUp6thTraining;
new PickUp3rdTraining;
new PickUp4thtraining;
new PickUp1Training;
new PickUp8thTraining;
new PickUp12thTraining;
new PickUp13thTraining;
new PickUp14thTraining;
new PickUpLastTraining;
new DNIEntrence;
new DNIExit;
new PickUpSurvivor;
new PickUpZombie;
new PickUpToUp;
new CanItRandom;
new FlashFlashObj[MAX_PLAYERS];
new MaxChat[MAX_PLAYERS];
new IsMessageSent[MAX_PLAYERS];
new GrenadesObject[MAX_PLAYERS][MAX_GRENADES];
new grenadesCount[MAX_PLAYERS];
new Vehicles[MAX_PLAYERS][4];
static Team[MAX_PLAYERS];
new PInfo[MAX_PLAYERS][PlayerInfo];
new gBugPlayerData[MAX_PLAYERS][E_GBUG];
new CPValue;
new Jason[MAX_PLAYERS];
new CPID;
new Hunter;
new ServerIsVoting = 0;
new KickVoteYes = 0;
new ServerVotingFor = -1;
new TimerForKick;
new VoteEnable;
new developmode;
new AnticheatEnabled;
new CanItSupply;
new ExtraXPEvent;
new ServerVotingReason[256];
new CPscleared;
new PickUpsSearching[sizeof(Searchplaces)];
new LootMaterialsPickups[sizeof(LootMaterials)];
new CraftArrowsPickups[sizeof(CraftArrows)];
new MeatHive[sizeof(HiveMeatPos)];
new TPHive[sizeof(HiveTeleports)];
new LootOutPlaces[sizeof(LootOutSide)];
new Float:Fuel[MAX_VEHICLES];
new Float:Oil[MAX_VEHICLES];
new WasVehicleDamaged[MAX_VEHICLES];
new VehicleStarted[MAX_VEHICLES];
new VehicleHideSomeone[MAX_VEHICLES];
new PlayersConnected;
new SupplyDirect = -1;
new	Float:BefPos[MAX_PLAYERS][4];
new SnowObj[MAX_PLAYERS][2];
new SnowCreated[MAX_PLAYERS];
new Snow = 0;
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
new GroupID;
new sgtSoap;
new Player1stGate;
new Player2ndGate;
new objectsupply1;
new objectsupply2;
new ServerIsAutoBalancing;
new InvadingTimer;
new SupplyHealth = 200;
new SupplyInvaded = 0;
new SupplyDestroyed = 0;
static Text3D:SupplyLabel;
new SupplyInvadeProgress = 0;
new CanSpawn = 0;
new gRandomSkin[] = {78,79,77,75,134,135,137,160,162,200,212,213,230,239};
/*new bRandomSkin[] = {1,2,3,4,5,6,7,8,9,10,279,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,76,80,81,82,83,84,85,86,87,88,89,90,93,94,95,96,97,98,100,101,128,129,130,131,132,133,136,138,139,140,141,142,143,144,145,146,147,
148,149,150,151,152,153,154,155,156,157,158,159,161,163,164,165,166,167,170,171,172,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,196,197,198,199,201,202,203,204,205,206,207,208,209,210,211,215,216,217,218,219,220,221,222,223,225,226,227,228,229,231,232,233,234,235,236,237,238,240,241,242,243,244,245,247,248,249,250,251,252,253,254,255,267,268,
289,290,291,293,295,296,297,298,299};*/
//==============================[VARIABLES END]=================================

//==============================[PUBLICS START]=================================
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
						CheckRankup(playerid,1);
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
			    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
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
			    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
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

public OnProjectileUpdate(projid)
{
	new Float:x,Float:y,Float:z;
	foreach(new f: Player)
	{
        if(projid == PInfo[f][ObjectProj])
        {
	        GetProjectilePos(projid,x,y,z);
			SetObjectPos(PInfo[f][ZObject],x,y,z);
			SetObjectRot(PInfo[f][ZObject],270, 180,PInfo[f][ObjAngz]);
		}
		if(projid == PInfo[f][Grenadeproj])
		{
			for (new i; i < grenadesCount[f]; i++)
			{
				GetProjectilePos(projid, x, y, z);
				SetDynamicObjectPos(GrenadesObject[f][i], x, y, z);
				GetProjectileRot(projid, x, y, z);
				SetDynamicObjectRot(GrenadesObject[f][i], x, y, z);
			}
		}
		if(projid == PInfo[f][FlashBangObjectProj])
    	{
	        GetProjectilePos(projid,x,y,z);
	        SetObjectRot(PInfo[f][FlashBangObject],270, 180,PInfo[f][ObjAngz]);
			SetObjectPos(PInfo[f][FlashBangObject],x,y,z);
	    }
	}
	return 1;
}


public OnProjectileCollide(projid, type, Float:x, Float:y, Float:z, extraid)
{
	foreach(new f: Player)
	{
		if(projid == PInfo[f][ObjectProj])
	    {
	        new Float:vx,Float:vy,Float:vz;
			GetProjectileVel(projid,vx,vy,vz);
			UpdateProjectileVel(projid,0,0,-5);
	    }
  		if(projid == PInfo[f][FlashBangObjectProj])
	    {
	        new Float:vx,Float:vy,Float:vz;
	        GetProjectileVel(projid,vx,vy,vz);
	        UpdateProjectileVel(projid,0,0,-4);
		}
		if(projid == PInfo[f][Grenadeproj])
		{
			for (new i; i < grenadesCount[f]; i++)
			{
	            PInfo[f][WhatThrow] = 0;
				DestroyProjectile(projid);
				DestroyDynamicObject(GrenadesObject[f][i]);
				CreateFakeExplosion(18683,x,y,z-1.25);
				PInfo[f][CanGrenadeAgain] = 1;
				foreach(new g: Player)
				{
				    if(!IsPlayerConnected(g)) continue;
				    if(PInfo[g][Logged] == 0) continue;
				    if(!IsPlayerInRangeOfPoint(g,80,x,y,z)) continue;
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					PlayerPlaySound(g,1159,x,y,z);
					new Float:Health;
				    GetPlayerHealth(g,Health);
			        if(IsPlayerInRangeOfPoint(g,14,x,y,z))
			        {
						if(CheckDealDamage(g,75) <= 75)
						{
						    if(Team[g] == ZOMBIE)
						    {
			  					GivePlayerXP(f);
			  					GivePlayerAssistXP(f);
			  					SetPlayerHealth(g,0);
							}
							if(Team[g] == HUMAN)
							{
								if(PInfo[g][Infected] == 1)
								{
							    	PInfo[g][Dead] = 1;
							    	InfectPlayer(g);
								}
								else
								{
									SetPlayerHealth(g,0);
									if(g != f)
										GiveTK(f);
								}
							}
						}
						else
							DealDamage(g,75);
					}
				}
				for (new a = i, b = --grenadesCount[f]; a < b; a++)
				{
	                GrenadesObject[f][a] = GrenadesObject[f][a + 1];
	            	Streamer_SetIntData(STREAMER_TYPE_OBJECT, GrenadesObject[f][a], E_STREAMER_EXTRA_ID, Streamer_GetIntData(STREAMER_TYPE_OBJECT, GrenadesObject[f][a + 1], E_STREAMER_EXTRA_ID));
				}
			    break;
			}
		}
	}
	return 1;
}

public OnProjectileStop(projid)
{
    new Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz;
	foreach(new i: Player)
	{
	    if(projid == PInfo[i][FlashBangObjectProj])
	    {
	        PInfo[i][WhatThrow] = 0;
   	 		GetProjectilePos(projid,x,y,z);
	        GetProjectileRot(projid,rx,ry,rz);
	        SetObjectPos(PInfo[i][FlashBangObject],x,y,z);
	        DestroyProjectile(projid);
	        GetObjectPos(PInfo[i][FlashBangObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
	        PInfo[i][Throwed] = 0;
	    }
	    if(projid == PInfo[i][ObjectProj])
	    {
	        GetProjectilePos(projid,x,y,z);
	        GetProjectileRot(projid,rx,ry,rz);
	        SetObjectPos(PInfo[i][ZObject],x,y,z);
	        DestroyProjectile(projid);
	        PInfo[i][WhatThrow] = 0;
	        GetObjectPos(PInfo[i][ZObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
	        PInfo[i][Throwed] = 0;
	        if(PInfo[i][IsBaitWithGr] == 1)
			{
				SetTimerEx("ExplodeBait", 3000, false, "i", i);
				PInfo[i][IsBaitWithGr] = 0;
			}
	        PInfo[i][ToBaitTimer] = SetTimerEx("MoveTobait",650,true,"i",i);
	        SetTimerEx("StopBait", 15000, false, "i", i);
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
					SendClientMessage(i,white,strang);
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

public FCNPC_OnFinishPlayback(npcid)
{
    FCNPC_StartPlayingPlayback(sgtSoap,"mynpc");
	return 1;
}

public OnPlayerStreamIn(playerid,forplayerid)
{
	if(IsPlayerNPC(forplayerid)) return 0;
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	if(IsPlayerNPC(forplayerid)) return 0;
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(Team[playerid] == ZOMBIE)
	{
	    if(PInfo[playerid][CanDig] == 0) return 1;
	    if(PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot2] == 5 || PInfo[playerid][ModeSlot3] ==  5)
	    {
	        PInfo[playerid][ChoseMap] = 1;
			PInfo[playerid][AccurX] = fX;
			PInfo[playerid][AccurY] = fY;
			PInfo[playerid][AccurZ] = fZ;
			SendClientMessage(playerid,white,"* "cjam"You chose position for dig, get close to that place atleast 200 meters and use Digger Perk");
	    }
	}
	return 1;
}
=======================================FUNCTIONS START==================================*/
function CheckDead(playerid)
{
	if(PInfo[playerid][Dead] == 1)
	{
	    SetTimerEx("CheckDeadAgain",1000,false,"i",playerid);
	}
	return 1;
}

function CheckDeadAgain(playerid)
{
	if(PInfo[playerid][Dead] == 1)
	{
	    SetSpawnInfo(playerid,NO_TEAM,GetPlayerSkin(playerid),0,0,0,0,0,0,0,0,0,0);
	    SpawnPlayer(playerid);
	}
	return 1;
}

function DigToDot(playerid)
{
	SetPlayerPos(playerid,PInfo[playerid][AccurX],PInfo[playerid][AccurY],PInfo[playerid][AccurZ]+5.5);
	return 1;
}

function CanGiveDizzyD(playerid)
{
    PInfo[playerid][CanGiveDizzy] = 1;
    return 1;
}

function DigToLastDeathPos(playerid)
{
	SetPlayerPos(playerid,PInfo[playerid][ResusX],PInfo[playerid][ResusY],PInfo[playerid][ResusZ]);
	return 1;
}


function ShowGottenItems(playerid,Type)
{
	static string[48];
	if(Type == 1) format(string,sizeof string,"DNA POINTS+");
	if(Type == 2) format(string,sizeof string,"MATERIALS+");
	TextDrawSetString(MatDNAPlus[playerid],string);
	TextDrawShowForPlayer(playerid,MatDNAPlus[playerid]);
	SetTimerEx("SetTDAlpha",300,false,"ii",playerid,1);
	return 1;
}

function ShowGottenRage(playerid)
{
    static string[32];
    format(string,sizeof string,"RAGE+");
    TextDrawSetString(RagePlus[playerid],string);
    TextDrawShowForPlayer(playerid,RagePlus[playerid]);
    SetTimerEx("SetTDAlpha",300,false,"ii",playerid,2);
}

function SetTDAlpha(playerid,Type)
{
	if(Type == 1)
	{
    	SetTimerEx("SetTDAlpha1",300,false,"ii",playerid,1);
	}
    if(Type == 2)
    {
        SetTimerEx("SetTDAlpha1",300,false,"ii",playerid,2);
    }
	return 1;
}

function SetTDAlpha1(playerid,Type)
{
	if(Type == 1)
	{
    	SetTimerEx("SetTDAlpha2",300,false,"ii",playerid,1);
	}
    if(Type == 2)
    {
        SetTimerEx("SetTDAlpha2",300,false,"ii",playerid,2);
    }
	return 1;
}

function SetTDAlpha2(playerid,Type)
{
	if(Type == 1)
	{
    	SetTimerEx("SetTDAlpha3",300,false,"ii",playerid,1);
	}
    if(Type == 2)
    {
        SetTimerEx("SetTDAlpha3",300,false,"ii",playerid,2);
    }
	return 1;
}

function SetTDAlpha3(playerid,Type)
{
	if(Type == 1)
	{
    	SetTimerEx("SetTDAlpha4",300,false,"ii",playerid,1);
	}
    if(Type == 2)
    {
        SetTimerEx("SetTDAlpha4",300,false,"ii",playerid,2);
    }
	return 1;
}

function SetTDAlpha4(playerid,Type)
{
	if(Type == 1) TextDrawHideForPlayer(playerid,MatDNAPlus[playerid]);
    if(Type == 2) TextDrawHideForPlayer(playerid,RagePlus[playerid]);
	return 1;
}

function ChangePlayerModSlot(playerid,Slot,ModificationID)
{
	if(ModificationID == 1 && PInfo[playerid][GotInsameRage] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 2 && PInfo[playerid][GotHealingRage] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 3 && PInfo[playerid][GotMoreRage] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 4 && PInfo[playerid][GotImperception] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 5 && PInfo[playerid][GotAccurateDigger] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 6 && PInfo[playerid][GotDizzyTrap] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 7 && PInfo[playerid][GotEdibleResidues] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 8 && PInfo[playerid][GotResuscitation] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 9 && PInfo[playerid][GotCrowdedStomach] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 10 && PInfo[playerid][GotRegeneration] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	if(ModificationID == 11 && PInfo[playerid][GotCollector] == 0) return SendClientMessage(playerid,white,"** "cred"You didn't combine this modification!");
	new string[75] = "* "cred"You can't use the same types of modification in same time!";
  	if(ModificationID == 1)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 2 || PInfo[playerid][ModeSlot2] == 3 || PInfo[playerid][ModeSlot3] == 2 || PInfo[playerid][ModeSlot3] == 3) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 2 || PInfo[playerid][ModeSlot1] == 3 || PInfo[playerid][ModeSlot3] == 2 || PInfo[playerid][ModeSlot3] == 3) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 2 || PInfo[playerid][ModeSlot1] == 3 || PInfo[playerid][ModeSlot2] == 2 || PInfo[playerid][ModeSlot2] == 3) return SendClientMessage(playerid,white,string);
		}
 	}
 	if(ModificationID == 2)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot2] == 3 || PInfo[playerid][ModeSlot3] == 1 || PInfo[playerid][ModeSlot3] == 3) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot1] == 3 || PInfo[playerid][ModeSlot3] == 1 || PInfo[playerid][ModeSlot3] == 3) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot1] == 3 || PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot2] == 3) return SendClientMessage(playerid,white,string);
		}
 	}
 	if(ModificationID == 3)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot2] == 2 || PInfo[playerid][ModeSlot3] == 1 || PInfo[playerid][ModeSlot3] == 2) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot1] == 2 || PInfo[playerid][ModeSlot3] == 1 || PInfo[playerid][ModeSlot3] == 2) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot1] == 2 || PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot2] == 2) return SendClientMessage(playerid,white,string);
		}
 	}
 	if(ModificationID == 4)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 5 || PInfo[playerid][ModeSlot2] == 8 || PInfo[playerid][ModeSlot3] == 5 || PInfo[playerid][ModeSlot3] == 8) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot3] == 5 || PInfo[playerid][ModeSlot3] == 8) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot2] == 5 || PInfo[playerid][ModeSlot2] == 8) return SendClientMessage(playerid,white,string);
		}
 	}
 	if(ModificationID == 5)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot2] == 8 || PInfo[playerid][ModeSlot3] == 4 || PInfo[playerid][ModeSlot3] == 8) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot3] == 4 || PInfo[playerid][ModeSlot3] == 8) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot2] == 8) return SendClientMessage(playerid,white,string);
		}
 	}
 	if(ModificationID == 8)
 	{
 	    if(Slot == 1)
 	    {
 	    	if(PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot2] == 5 || PInfo[playerid][ModeSlot3] == 4 || PInfo[playerid][ModeSlot3] == 5) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 2)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot3] == 4 || PInfo[playerid][ModeSlot3] == 5) return SendClientMessage(playerid,white,string);
		}
		if(Slot == 3)
		{
 	    	if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot2] == 5) return SendClientMessage(playerid,white,string);
		}
 	}
	if(Slot == 1) PInfo[playerid][ModeSlot1] = ModificationID;
	if(Slot == 2) PInfo[playerid][ModeSlot2] = ModificationID;
	if(Slot == 3) PInfo[playerid][ModeSlot3] = ModificationID;
	PInfo[playerid][AlreadyChangeMod] ++;
	if(Slot == 1) SendClientMessage(playerid,white,"* "cjam"You changed 1st slot of DNA modifications!");
	if(Slot == 2) SendClientMessage(playerid,white,"* "cjam"You changed 2nd slot of DNA modifications!");
	if(Slot == 3) SendClientMessage(playerid,white,"* "cjam"You changed 3rd slot of DNA modifications!");
	return 1;
}

function CanBeStingeredBull(playerid)
{
    PInfo[playerid][CanBeStingBull] = 0;
    return 1;
}
function GetUpAnim(playerid)
{
	ApplyAnimation(playerid,"PED","getup",2.0,0,0,0,0,0,1);
	return 1;
}

function CheckMineDH(playerid)
{
	if(!IsPlayerConnected(playerid))
	{
		if(IsValidObject(PInfo[playerid][MineObject]))
	 		DestroyObject(PInfo[playerid][MineObject]);
		return 0;
	}
	new Float:x,Float:y,Float:z,Float:health,Float:mx,Float:my,Float:mz;
	if(IsValidObject(PInfo[playerid][MineObject]))
	{
	    GetObjectPos(PInfo[playerid][MineObject],x,y,z);
	    new id = -1;
	    foreach(new i: Player)
	    {
	        if(!IsPlayerInRangeOfPoint(i,2,x,y,z)) continue;
	        if(PInfo[i][Spawned] == 0) continue;
	        if(PInfo[i][Dead] == 1) continue;
			if(Team[i] == ZOMBIE)
			{
			    id = i;
			    break;
			}
		}
	    if(id == -1) return SetTimerEx("CheckMineDH",100,false,"i",playerid);
	    else
	    {
	        RemoveItem(playerid,"Mines",1);
	        PInfo[playerid][Mines] --;
	        CreateFakeExplosion(18685,x,y,z);
	        DestroyObject(PInfo[playerid][MineObject]);
	        foreach(new i: Player)
	        {
				PlayerPlaySound(i,1159,x,y,z);
				PlayerPlaySound(i,1159,x,y,z);
				PlayerPlaySound(i,1159,x,y,z);
				PlayerPlaySound(i,1159,x,y,z);
				PlayerPlaySound(i,1159,x,y,z);
	            if(IsPlayerInRangeOfPoint(i,10,x,y,z))
	            {
				    new Float:ix,Float:iy,Float:iz;
					GetPlayerPos(i,ix,iy,iz);
					if(!IsPlayerInAnyVehicle(i))
					{
	                	if(PInfo[i][SPerk] != 12)
	                	{
							GetPlayerVelocity(i,mx,my,mz);
							new Float:a = 180.0-atan2(ix-x,iy-y);
							mx += ( 0.5 * floatsin( -a, degrees ) );
				      		my += ( 0.5 * floatcos( -a, degrees ) );
				      		ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
							SetPlayerVelocity(i,-mx,-my,mz+0.2);
						}
					}
					else
					{
					    new Float:hp;
					    GetVehicleHealth(GetPlayerVehicleID(i),hp);
			 			SetVehicleHealth(GetPlayerVehicleID(i),hp - 300);
					}
					GetPlayerHealth(i,health);
	                if(CheckDealDamage(i,80) <= 80)
	                {
	                    if(Team[i] == HUMAN)
						{
							if(PInfo[i][Infected] == 1)
							{
							    SetPlayerHealth(i,0);
							    InfectPlayer(i);
							    PInfo[playerid][Kills] ++;
							    PInfo[i][Deaths] ++;
							    PInfo[i][Dead] = 1;
							    GivePlayerXP(playerid);
							    GivePlayerAssistXP(playerid);
							}
							else
							{
							    SetPlayerHealth(i,0);
							    PInfo[i][Deaths] ++;
							    PInfo[i][Dead] = 1;
							    if(i != playerid)
						     		GiveTK(playerid);
							}
						}
						else
						{
						    SetPlayerHealth(i,0);
						    PInfo[playerid][Kills] ++;
						    PInfo[i][Deaths] ++;
						    PInfo[i][Dead] = 1;
						    GivePlayerXP(playerid);
						    GivePlayerAssistXP(playerid);
						}
	                }
	                else DealDamage(i,80);
	            }
	        }
			return 1;
		}
	}
	return 1;
}

function CraftValue(playerid,Value)
{
	switch(Value)
	{
	    case 0://mine
	    {
	        new rand = random(1000);
	        if(rand <= 650)
	        {
	            new dim = random(3)+1;
	            AddItem(playerid,"Mines",dim);
	            PInfo[playerid][Mines] += dim;
	            SendFMessage(playerid,green,"* "cgreen"You created %i mine(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,"* "cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 1://molotovs
	    {
     		new rand = random(1000);
	        if(rand <= 700)
	        {
	            new dim = random(2)+1;
	            GivePlayerWeapon(playerid,18,dim);
         		SendFMessage(playerid,green,"* "cgreen"You created %i molotov(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 2://sticky bombs
	    {
			new rand = random(1000);
	        if(rand <= 500)
	        {
	            new dim = random(2)+1;
	            GivePlayerWeapon(playerid,39,dim);
         		SendFMessage(playerid,green,"* "cgreen"You created %i sticky bomb(s) "cred"Check Inventory (press N)!",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 3://beacon bullets
	    {
  			new rand = random(1000);
	        if(rand <= 500)
	        {
	            new dim = random(5)+random(5)+1;
	            AddItem(playerid,"Beacon Bullets",dim);
	            PInfo[playerid][BeaconBullets] += dim;
           		SendFMessage(playerid,green,"* "cgreen"You created %i Beacon Bullet(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 4://impact bullets
	    {
  			new rand = random(1000);
	        if(rand <= 400)
	        {
	            new dim = random(4)+random(3)+1;
	            AddItem(playerid,"Impact Bullets",dim);
	            PInfo[playerid][ImpactBullets] += dim;
           		SendFMessage(playerid,green,"* "cgreen"You created %i Impact Bullet(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 5://stinger bullets
	    {
  			new rand = random(1000);
	        if(rand <= 350)
	        {
	            new dim = random(4)+random(3)+1;
	            AddItem(playerid,"Stinger Bullets",dim);
	            PInfo[playerid][StingerBullets] += dim;
           		SendFMessage(playerid,green,"* "cgreen"You created %i Stinger Bullet(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 6://nitro
	    {
			new rand = random(1000);
	        if(rand <= 600)
	        {
	            AddItem(playerid,"Nitro",1);
	            PInfo[playerid][Nitro] += 1;
           		SendClientMessage(playerid,green,"* "cgreen"You created Nitro for vehicle! "cred"Check Inventory (press N)");
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 7://anti-blind
	    {
			new rand = random(1000);
	        if(rand <= 900)
	        {
	            new dim = random(2)+random(2)+1;
	            AddItem(playerid,"Anti-blindness pills",dim);
	            PInfo[playerid][Antiblindpills] += dim;
           		SendFMessage(playerid,green,"* "cgreen"You created %i Anti-blind pills(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 8://crafting table
	    {
			new rand = random(1000);
	        if(rand <= 750)
	        {
	            AddItem(playerid,"Crafting Table",1);
	            PInfo[playerid][CraftingTable] += 1;
           		SendClientMessage(playerid,green,"* "cgreen"You created Crafting Table! "cred"Check Inventory (press N)");
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	}
	return 1;
}

function GiveTK(playerid)
{
	PInfo[playerid][Teamkills]++;
	SendClientMessage(playerid,white,"» "cwhite"TeamKilling is "cred"NOT ALLOWED!!! "cwhite"«");
	if(PInfo[playerid][WarnJail] == 2)
	{
	    SendClientMessage(playerid,white,"» "cred"If you continue killing your teammates, you will be jailed!!! "cwhite"«");
	}
	if(PInfo[playerid][WarnJail] == 3)
	{
	    SendClientMessage(playerid,white,"» "cred"Last warning, if you kill your teammate again, you will be jailed!!! "cwhite"«");
	}
	if(PInfo[playerid][WarnJail] == 4)
	{
		Jail(playerid);
		new string[128];
		if(PInfo[playerid][Rank] < 10)
		{
			PInfo[playerid][JailTimer] = 600;
		}
		else if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 20))
		{
		    PInfo[playerid][JailTimer] = 1500;
		}
		else if(PInfo[playerid][Rank] >= 20)
		{
		    PInfo[playerid][JailTimer] = 3000;
		}
		format(string,sizeof string,"~t~~r~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[playerid][JailTimer]);
	 	GameTextForPlayer(playerid,string, 6500,3);
	}
	else PInfo[playerid][WarnJail] ++;
	if(PInfo[playerid][XP] <= 5) PInfo[playerid][XP] = 0;
	else
	{
	    PInfo[playerid][TeamKilling] = 1;
     	if(PInfo[playerid][ShowingXP] == 0)
	    {
			static string[7];
			PInfo[playerid][XP] -= 5;
			PInfo[playerid][CurrentXP] += 5;
			format(string,sizeof string,"-%i XP",PInfo[playerid][CurrentXP]);
			TextDrawSetString(GainXPTD[playerid],string);
			PInfo[playerid][ShowingXP] = 1;
			SetTimerEx("ShowXP1",100,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
		}
		else
		{
		    static string[7];
			PInfo[playerid][XP] -= 5;
			PInfo[playerid][CurrentXP] += 5;
			format(string,sizeof string,"-%i XP",PInfo[playerid][CurrentXP]);
			KillTimer(PInfo[playerid][XPDTimer]);
			PInfo[playerid][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",playerid);
		    TextDrawSetString(GainXPTD[playerid],string);
		}
	}
	CheckRankup(playerid);
	return 1;
}

function CanGoAfkAgain(playerid)
{
	PInfo[playerid][CanGoAFK] = 1;
	return 1;
}

function GoAFK(playerid)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(PInfo[playerid][Spawned] == 0 || PInfo[playerid][Dead] == 1) return SendClientMessage(playerid,white,""cred"You can't go AFK right now!");
	if(PInfo[playerid][Training] == 1) return SendClientMessage(playerid,white,""cred"You can't go AFK right now!");
    foreach(new i: Player)
    {
        if(i == playerid) continue;
        if(PInfo[i][Logged] == 0) continue;
        if(IsPlayerInRangeOfPoint(i,50,x,y,z)) return SendClientMessage(playerid,red,"» There must be nobody close to you when you go AFK!");
    }
    new string[128];
    format(string,sizeof string, "WARNING: %s went AFK!",GetPName(playerid));
    SendAdminMessage(red, string);
    SendClientMessage(playerid,white,"* "cred"You are staying AFK, while you are staying you can't be touched by humans/zombies.");
    SendClientMessage(playerid,white,"* "cred"Also you can't do most of things");
    SendClientMessage(playerid,white,"* "cred"When you will want to leave from AFK mode use /AFK again");
    SetPlayerVirtualWorld(playerid,playerid+30);
    SetPlayerInterior(playerid,1);
	PInfo[playerid][Afk] = 1;
	return 1;
}

function ReturnTeams(playerid,damageid)
{
    SetPlayerTeam(playerid,NO_TEAM);
    SetPlayerTeam(damageid,NO_TEAM);
    return 1;
}

function EnableEntAC(playerid)
{
    EnableAntiCheatForPlayer(playerid,4,1);
	return 1;
}

function AttemptOpen(playerid,vehicleid)
{
	new Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid,x,y,z);
	PInfo[playerid][CanUsePickLock] = 1;
	if(!IsPlayerInRangeOfPoint(playerid,3.5,x,y,z)) return SendClientMessage(playerid,white,"» "cred"You must stay close to vehicle!");
	new rand = random(5);
	new string[64];
	if(rand == 0)
	{
	    format(string,sizeof string,""cjam"%s successfully opened doors with a picklock!",GetPName(playerid));
		SendNearMessage(playerid,white,string,15);
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetTimerEx("OffAlarm",15000,false,"i",vehicleid);
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, 0, bonnet, boot, objective);
	}
	else
	{
 		SendClientMessage(playerid,white,"* "cred"Attempt to unlock the car failed!");
	}
	PInfo[playerid][PickLockStatus] --;
	if(PInfo[playerid][PickLockStatus] == 0)
	{
	    SendClientMessage(playerid,white,"* "cred"You broke your picklock!");
		RemoveItem(playerid,"Picklock",1);
		PInfo[playerid][PickLockStatus] = 3;
	}
	return 1;
}

function OffAlarm(vehicleid)
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, 0, doors, bonnet, boot, objective);
	return 1;
}

function MoveTobait(playerid)
{
    foreach(new i: Player)
    {
        if(!IsPlayerConnected(i)) continue;
		if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == HUMAN) continue;
		if(PInfo[i][ZPerk] == 17) continue;
		if(PInfo[i][EatenBait] == 1) continue;
		if((IsPlayerInRangeOfPoint(i,16.0,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ])) && (PInfo[playerid][EatenBait] != 1))
		{
            new Float:x,Float:y,Float:z,Float:a,Float:ix,Float:iy,Float:iz;
			GetPlayerVelocity(i,x,y,z);
			GetPlayerPos(i,ix,iy,iz);
			TurnPlayerFaceToPos(i,PInfo[playerid][ZX],PInfo[playerid][ZY]);
			a = 180.0-atan2(ix-PInfo[playerid][ZX],iy-PInfo[playerid][ZY]);
			x += ( 0.5 * floatsin( -a, degrees ) );
  			y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(i,x*0.2,y*0.2,0.1);
			ApplyAnimation(i, "PED" , "WALK_SHUFFLE" , 5.0 , 0 , 1 , 1 , 0 , 15000 , 1);
		}
		if((IsPlayerInRangeOfPoint(i,2.5,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ])) && (PInfo[i][EatenBait] == 0))
		{
		    PInfo[i][EatenBait] = 1;
		    SendClientMessage(i,white,"* "cjam"You have eaten a bait!");
		    ClearAnimations(i,1);
			SetTimerEx("PickUpBait", 20000,false,"i",i);
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

function PutInVehicle(playerid)
{
	PutPlayerInVehicle(playerid,PInfo[playerid][HideInVehicle],PInfo[playerid][SeatID]);
	VehicleHideSomeone[PInfo[playerid][HideInVehicle]] = 0;
	PInfo[playerid][Hiden] = 0;
	return 1;
}

function ActivateCheat(playerid)
{
    EnableAntiCheatForPlayer(playerid,12,1);
	return 1;
}

function SpawnHim(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

function CheckRegistration(playerid)
{
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
		if(developmode == 1)
		{
	    	if(INI_ReadInt("Level") == 0)
	    	{
				SendClientMessage(playerid,white,"* "cred"Sorry, server is on maintenance, you can't play on server right now.");
				SetTimerEx("kicken",200,false,"i",playerid);
				return 0;
			}
	 	}
	 	INI_Close();
	    new string[79];
	    format(string,sizeof string,"\t"cred"Ultimate - "cwhite"Gaming");
		new strang[2048];
		format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
		strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.5");
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
			if(developmode == 1)
			{
				SendClientMessage(playerid,white,"* "cred"Sorry, server is on maintenance, you can't play on server right now.");
				SetTimerEx("kicken",200,false,"i",playerid);
				return 0;
		 	}
			new strang[2048];
			format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
			strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.5");
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
	  		SetPlayerWeather(playerid,5123524);
    		SetPlayerTime(playerid,23,0);
		}
	}
	return 1;
}

function SetWarnsPing(playerid)
{
	PInfo[playerid][HighPingWarn] = 0;
	return 1;
}

function ACForFight(playerid)
{
	PInfo[playerid][ZombieFighting] = 0;
	return 1;
}

function CanItFlare(playerid)
{
	SendClientMessage(playerid,white,"* "cblue"You've got a special signal flare (Homing Beacon ready)");
	PInfo[playerid][CanFlare] = 1;
	return 1;
}


function FixOnline()
{
	PlayersConnected = 0;
	for(new i = 0; i < GetMaxPlayers(); i ++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PInfo[i][Jailed] == 0)
	        {
	            if(PInfo[i][Training] == 0)
	            {
	                if(!IsPlayerNPC(i))
	                {
	                	if(PInfo[i][ChooseAfterTr] == 0)
	                	{
	            			PlayersConnected ++;
						}
					}
				}
			}
		}
	}
	return 1;
}

function DestroyFires(playerid)
{
	RemovePlayerAttachedObject(playerid, 5);
    RemovePlayerAttachedObject(playerid, 6);
    return 1;
}

function CanEatAgain(playerid)
{
    PInfo[playerid][EatenMeat] = 0;
    return 1;
}

function NewTips()
{

    UpdateStats();
	return 1;
}

function Tip()
{
    new rand = random(5);
	switch(rand)
	{
	    case 0:
	    {
	        foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
	    			SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"The Main Goal of "cpurple"ZOMBIES"cwhite": Kill all of "cgreen"Survivors"cwhite", before they clear all of Checkpoints.");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"The Main Goal of "cgreen"SURVIVORS"cwhite": Clear all the "cred"Checkpoints"cwhite", before the Zombies kill you.");
	    			SendClientMessage(i,white,""cgreen"=========================================");
	    			SendClientMessage(i,white,"* "cred"You can turn tips of with command /tips");
				}
			}
		}
  		case 1:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite""cgreen"SURVIVORS "cwhite"have an inventory");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"They can open it by clicking button "cred"N"cwhite"");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Here you can find Med. Kits, flashlights, oil, fuel");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"If you use all of your kits, you may loot in houses or find special crates");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Crates are placed all over Los Santos, there are more than 40 of them");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You can loot in opened houses like CJ's house, The Alhambra Club and etc.");
			    	SendClientMessage(i,white,""cgreen"=========================================");
			    	SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
  		case 2:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite""cgreen"SURVIVORS "cwhite"and "cpurple"ZOMBIES "cwhite"have perks");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You can open the list of perks by pressing the "cred"Y"cwhite" button");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Perks are special abilities");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite""cgreen"SURVIVORS "cwhite"and "cpurple"ZOMBIES "cwhite"have the same amount of perks");
					SendClientMessage(i,white,""cgreen"|| "cwhite"You can get perks by leveling up, being the first at rank "cred"2");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Perks give a small advantage over opponents, they are useful in different situations!");
			    	SendClientMessage(i,white,""cgreen"=========================================");
			    	SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
  		case 3:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
	    			SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite""cpurple"ZOMBIES "cwhite"can infect "cgreen"SURVIVORS");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"When you stay close enough to them, spam "cred"AIM Key/Right Mouse Button "cwhite"to bite");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"If they are in vehicles, get in any passenger seat and press button "cred"SPACE");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"If you are alone, you can get in a vehicle and hide there "cred"(/hide)");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite""cpurple"ZOMBIES "cwhite"can travel throught the map using the marked Sewers on map "dred"(T)"cwhite"");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"If you have low Health, you can heal yourself by biting humans or eating meat in Hive");
	    			SendClientMessage(i,white,""cgreen"=========================================");
	    			SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
		case 4:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"New on server? Write /help for more info about the server");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"If you saw a rulebreaker don't flood about it in main chat, use "cred"/report "cwhite"for that");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Have suggestions or found a bug? Visit "cblue"ug-ultimategaming.proboards.com "cwhite"and post there your cool ideas!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Also you can post there your reports, if someone breaks the rules");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Just play by the rules, enjoy, and have fun!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"If you have questions ask in main chat, admins will help you :)");
			    	SendClientMessage(i,white,""cgreen"=========================================");
					SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
	}
	return 1;
}

function PickUpBait(f)
{
    PInfo[f][EatenBait] = 0;
    return 1;
}

function kicken(playerid)
{
	Kick(playerid);
	return 1;
}

function Muting(playerid)
{
    UpdateStatsForPlayer(playerid);
	if(PInfo[playerid][Muted] == 1)
	{
	    if(PInfo[playerid][MuteTimer] > 0)
	    {
	    	PInfo[playerid][MuteTimer] --;
	    }
	    if(PInfo[playerid][MuteTimer] == 0)
	    {
	        SendClientMessage(playerid,white,"** "corange"You were unmuted, please don't break the chat rules in the future.");
	        PInfo[playerid][MuteTimer] = -1;
	        PInfo[playerid][Muted] = 0;
		}
	}
	if(Team[playerid] == ZOMBIE)
	{
	    if(PInfo[playerid][ModeSlot1] == 10 || PInfo[playerid][ModeSlot2] == 10 || PInfo[playerid][ModeSlot3] == 10)
		PInfo[playerid][CountHP] ++;
		if(PInfo[playerid][CountHP] == 10)
		{
		    PInfo[playerid][CountHP] = 0;
		    new Float:health;
		    GetPlayerHealth(playerid,health);
		    if(health < 100) SetPlayerHealth(playerid,health+5);
		}
	}
	if(PInfo[playerid][Spawned] == 1)
	{
		if(PInfo[playerid][Jailed] == 1)
		{
		    if(PInfo[playerid][JailTimer] > 0)
		    {
		        PInfo[playerid][JailTimer] --;
		        if(!IsPlayerInRangeOfPoint(playerid,250,-1350.0763,-22.6054,14.1484))
				{
	       			TogglePlayerControllable(playerid, 0);
					SetTimerEx("UnFreezePlayer", 700, false, "i", playerid);
				    new rand = random(2);
				    switch(rand)
				    {
				        case 0: SetPlayerPosAndAngle(playerid,-1350.2959,-27.6325,79.0570,261.4352);
				        case 1: SetPlayerPosAndAngle(playerid,-1347.4170,-20.6739,79.0570,5.8806);
					}
				}
			}
		}
		if(PInfo[playerid][JailTimer] == 0)
		{
			PInfo[playerid][Jailed] = 0;
			PlayersConnected ++;
			PInfo[playerid][JailTimer] = -1;
			SendClientMessage(playerid,white,"* "cred"You were unjailed! Now relog to server to continue play!");
			SetTimerEx("kicken",50,false,"i",playerid);
		}
	}
	if(PInfo[playerid][Premium] == 0)
	{
	    new Float:arm;
	    GetPlayerArmour(playerid,arm);
	    if(arm >= 1)
	    {
			new string[128];
 			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Armour Hacks",GetPName(playerid));
	        SendClientMessageToAll(white,string);
	        SetTimerEx("kicken",50,false,"i",playerid);
		}
	}
	return 1;
}

function Weather(playerid)
{
	if(RWeather == 55) SetPlayerTime(playerid,7,0);
	else SetPlayerTime(playerid,23,0);
	return 1;
}

function Loot1(playerid)
{
	new rand;
	rand = random(24);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0..3:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found can of Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 4..7:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found can of Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 8..11:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 12..15:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 16..17:
			{
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
			    AddItem(playerid,"Dizzy Away",1);
			}
			case 18..20:
			{
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Picklock.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Picklock",1);
			}
			case 21..22:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 23:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
		}
	}
	return 1;
}

function Loot2(playerid)
{
	new randem;
	randem = random(15);
	goto Random;
	Random:
	{
		switch(randem)
		{
		    case 0..2:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found can of Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 3..5:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found can of Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
			}
		    case 6..8:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 9..11:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 12..13:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 14:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
			case 15..17:
			{
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Picklock.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Picklock",1);
			}
			case 18..19:
			{
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
			    AddItem(playerid,"Dizzy Away",1);
			}
		}
	}
	return 1;
}

function Jail(playerid)
{
	if(PInfo[playerid][Logged] == 0) return 1;
	if(PInfo[playerid][Jailed] == 1)
	{
	    SetPlayerVirtualWorld(playerid,17);
	    new rand = random(2);
	    switch(rand)
	    {
	        case 0: SetPlayerPosAndAngle(playerid,-1350.2959,-27.6325,79.0570,261.4352);
	        case 1: SetPlayerPosAndAngle(playerid,-1347.4170,-20.6739,79.0570,5.8806);
		}
        TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnFreezePlayer", 2500, false, "i", playerid);
		SetPlayerInterior(playerid,3);
		PInfo[playerid][CanBite] = 0;
		ResetPlayerWeapons(playerid);
		PInfo[playerid][ZPerk] = 0;
		PInfo[playerid][SPerk] = 0;
		SetPlayerHealth(playerid, 28000);
		PInfo[playerid][CanUseWeapons] = 0;
	}
	else if(PInfo[playerid][Jailed] == 0)
	{
        TogglePlayerControllable(playerid, 0);
		SetTimerEx("UnFreezePlayer", 2500, false, "i", playerid);
 		SetPlayerVirtualWorld(playerid,17);
 		SetPlayerInterior(playerid,3);
   		new rand = random(2);
	    switch(rand)
	    {
	        case 0: SetPlayerPosAndAngle(playerid,-1350.2959,-27.6325,79.0570,261.4352);
	        case 1: SetPlayerPosAndAngle(playerid,-1347.4170,-20.6739,79.0570,5.8806);
		}
		PInfo[playerid][CanBite] = 0;
		ResetPlayerWeapons(playerid);
		PInfo[playerid][ZPerk] = 0;
		PInfo[playerid][SPerk] = 0;
		SetPlayerHealth(playerid, 28000);
		PInfo[playerid][CanUseWeapons] = 0;
		PInfo[playerid][Jailed] = 1;
		ResetPlayerInventory(playerid);
		PlayersConnected --;
	}
	return 1;
}

function FlashLightOn(playerid)
{
	if(PInfo[playerid][FlashLightTimerOn] > 0)
	{
	    PInfo[playerid][FlashLightTimerOn]--;
	}
	else if(PInfo[playerid][FlashLightTimerOn] == 0)
	{
	    PInfo[playerid][Lighton] = 0;
        RemovePlayerAttachedObject(playerid,4);
        RemoveItem(playerid,"Flashlight",1);
        static string[90];
		format(string,sizeof string,""cjam"%s's flashlight has runned out of bateries.",GetPName(playerid));
		SendNearMessage(playerid,white,string,30);
		KillTimer(FlashLightTimer[playerid]);
		PInfo[playerid][FlashLightTimerOn] = 90;
	}
	return 1;
}


function DetectSuicide(playerid)
{
    if((PInfo[playerid][Infected] == 1) && (Team[playerid] == HUMAN))
    {
	    new Float:a;
	    GetPlayerHealth(playerid,a);
	    if(a <= 1)
	    {
			InfectPlayer(playerid);
		}
	}
	return 1;
}

function GiveRankGun(playerid)
{
	switch(PInfo[playerid][Rank])
	{
	    case 2: GivePlayerWeapon(playerid,23,17),GivePlayerWeapon(playerid,2,1);//Silenced Pistol + Knuckles + Cane
	    case 3: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
	    case 4: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
	    case 5: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
	    case 6: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
	    case 7: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
	    case 8: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,7,1);//2 dual pistols + Knuckles + Billiard Cue
	    case 9: GivePlayerWeapon(playerid,22,17),GivePlayerWeapon(playerid,6,1);//2 dual pistols + Knuckles + shovel
	    case 10: GivePlayerWeapon(playerid,22,34),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,10);//2 dual pistols + Knuckles + shovel+shotgun
	    case 11: GivePlayerWeapon(playerid,22,34),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,10);//2 dual pistols + Knuckles + shovel+shotgun
	    case 12: GivePlayerWeapon(playerid,22,34),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,10);//2 dual pistols + Knuckles + shovel+shotgun
	    case 13: GivePlayerWeapon(playerid,22,34),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,10);//2 dual pistols +Knuckles + shovel+Shotgun
	    case 14: GivePlayerWeapon(playerid,22,34),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,15);//2 dual pistols +Knuckles + BaseBall Bat + Shotgun
	    case 15: GivePlayerWeapon(playerid,24,14),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,15);//Deagle +Knuckles + BaseBall Bat + Shotgun
	    case 16: GivePlayerWeapon(playerid,24,14),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,15);//Deagle +Knuckles + BaseBall Bat + Shotgun
	    case 17: GivePlayerWeapon(playerid,24,14),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,15);//Deagle +Knuckles + BaseBall Bat + Shotgun
	    case 18: GivePlayerWeapon(playerid,24,14),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,15);//Deagle +Knuckles + BaseBall Bat + Shotgun
	    case 19: GivePlayerWeapon(playerid,24,14),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,20);//Deagle +Knuckles + knife + Shotgun
	    case 20: GivePlayerWeapon(playerid,24,21),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,20),GivePlayerWeapon(playerid,28,50),GivePlayerWeapon(playerid,33,15); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
	    case 21: GivePlayerWeapon(playerid,24,21),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,20),GivePlayerWeapon(playerid,28,50),GivePlayerWeapon(playerid,33,15); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
	    case 22: GivePlayerWeapon(playerid,24,21),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,20),GivePlayerWeapon(playerid,28,50),GivePlayerWeapon(playerid,33,15); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
	    case 23: GivePlayerWeapon(playerid,24,21),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,20),GivePlayerWeapon(playerid,28,50),GivePlayerWeapon(playerid,33,15); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
	    case 24: GivePlayerWeapon(playerid,24,21),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,20),GivePlayerWeapon(playerid,28,50),GivePlayerWeapon(playerid,33,15); //Deagle +Knuckles + Night Stick + Shotgun + UZIS + rifle
	    case 25: GivePlayerWeapon(playerid,24,28),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,8),GivePlayerWeapon(playerid,28,75),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
	    case 26: GivePlayerWeapon(playerid,24,28),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,8),GivePlayerWeapon(playerid,28,75),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
	    case 27: GivePlayerWeapon(playerid,24,28),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,8),GivePlayerWeapon(playerid,28,75),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
	    case 28: GivePlayerWeapon(playerid,24,28),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,8),GivePlayerWeapon(playerid,28,75),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
	    case 29: GivePlayerWeapon(playerid,24,28),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,8),GivePlayerWeapon(playerid,28,75),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + Katana + Sawn-off Shotgun + UZIS + rifle
	    case 30: GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,12),GivePlayerWeapon(playerid,32,75),GivePlayerWeapon(playerid,30,30),GivePlayerWeapon(playerid,33,25); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
		case 31: GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,12),GivePlayerWeapon(playerid,32,75),GivePlayerWeapon(playerid,30,30),GivePlayerWeapon(playerid,33,25); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
		case 32: GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,12),GivePlayerWeapon(playerid,32,75),GivePlayerWeapon(playerid,30,30),GivePlayerWeapon(playerid,33,25); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
        case 33: GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,12),GivePlayerWeapon(playerid,32,75),GivePlayerWeapon(playerid,30,30),GivePlayerWeapon(playerid,33,25); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
        case 34: GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,12),GivePlayerWeapon(playerid,32,75),GivePlayerWeapon(playerid,30,30),GivePlayerWeapon(playerid,33,25); //Deagle +Knuckles + ChainSaw + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
        case 35: GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,21),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 36: GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,21),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 37: GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,21),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 38: GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,21),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 39: GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,21),GivePlayerWeapon(playerid,32,100),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 40: GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,28),GivePlayerWeapon(playerid,32,125),GivePlayerWeapon(playerid,31,50),GivePlayerWeapon(playerid,33,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
		case 41: GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,28),GivePlayerWeapon(playerid,32,125),GivePlayerWeapon(playerid,31,50),GivePlayerWeapon(playerid,33,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
		case 42: GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,28),GivePlayerWeapon(playerid,32,125),GivePlayerWeapon(playerid,31,50),GivePlayerWeapon(playerid,33,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
		case 43: GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,28),GivePlayerWeapon(playerid,32,125),GivePlayerWeapon(playerid,31,50),GivePlayerWeapon(playerid,33,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
		case 44: GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,28),GivePlayerWeapon(playerid,32,125),GivePlayerWeapon(playerid,31,50),GivePlayerWeapon(playerid,33,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
		case 45: GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,35),GivePlayerWeapon(playerid,29,30),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,34,20); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 46: GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,35),GivePlayerWeapon(playerid,29,30),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,34,20); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 47: GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,35),GivePlayerWeapon(playerid,29,30),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,34,20); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 48: GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,35),GivePlayerWeapon(playerid,29,30),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,34,20); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 49: GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,35),GivePlayerWeapon(playerid,29,30),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,34,20); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 50: GivePlayerWeapon(playerid,24,63),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,42),GivePlayerWeapon(playerid,29,60),GivePlayerWeapon(playerid,31,150),GivePlayerWeapon(playerid,34,25); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
		case 51..100: GivePlayerWeapon(playerid,24,3800),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,1000),GivePlayerWeapon(playerid,29,800),GivePlayerWeapon(playerid,31,2200),GivePlayerWeapon(playerid,34,675); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
	}
	return 1;
}

/*function GetBaitPos(playerid)
{
	GetObjectPos(PInfo[playerid][ZObject],PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
    return 1;
}*/

function TimerFlood(playerid)
{
    MaxChat[playerid] = 0;
    return 1;
}

function DissapearBloodPhase1(i)
{
    TextDrawHideForPlayer(i,BloodHemorhage[i][1]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][4]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][9]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][13]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][14]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][19]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][31]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][35]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][37]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][39]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][33]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][32]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][22]);
    return 1;
}

function DissapearBloodPhase2(i)
{
    TextDrawHideForPlayer(i,BloodHemorhage[i][2]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][7]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][10]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][21]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][25]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][28]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][30]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][34]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][36]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][38]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][3]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][15]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][20]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][37]);
    return 1;
}//25 28

function DissapearBloodPhase3(i)
{
    TextDrawHideForPlayer(i,BloodHemorhage[i][5]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][6]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][8]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][11]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][12]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][17]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][23]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][24]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][25]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][28]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][29]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][32]);
    TextDrawHideForPlayer(i,BloodHemorhage[i][27]);
    return 1;
}

function DissapearBloodPhase4(i)
{
	for(new f = 1; f < 39; f++)
	{
	    if(f == 25) continue;
	    if(f == 28) continue;
        TextDrawHideForPlayer(i,BloodHemorhage[i][f]);
	}
	return 1;
}


function UpdateBait()
{
    NewTips();
    SetTimer("UpdateBait",625,false);
	return 1;
}

function GivePlayerHealthInCP()
{
	new infects;
	foreach(new i: Player)
	{
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][Afk] == 1) continue;
	    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	new Allplayers;
	foreach(new i: Player)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PInfo[i][Jailed] == 0)
	        {
	            if(PInfo[i][Training] == 0)
	            {
	                if(PInfo[i][Afk] == 0)
	                {
                		if(PInfo[i][ChooseAfterTr] == 0)
                		{
            				Allplayers ++;
						}
					}
				}
			}
		}
	}
	new pers = floatround(100.0 * floatdiv(infects, PlayersConnected));
	new Float:hp;
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
		if(!IsPlayerInCheckpoint(i))
		    EnableAntiCheatForPlayer(i,12,1);
	    if(Team[i] == ZOMBIE) continue;
	    if(IsPlayerInCheckpoint(i))
	    {
			EnableAntiCheatForPlayer(i,12,0);
	    	GetPlayerHealth(i,hp);
	    	if(hp > 98) SetPlayerHealth(i,100);
	    	if(hp <= 98) SetPlayerHealth(i,hp+2);
		}
	}
	if(pers < 20) SetTimer("GivePlayerHealthInCP",750,false);
	else if(pers >= 20 && pers < 50) SetTimer("GivePlayerHealthInCP",600,false);
	else if(pers >= 50 && pers < 80) SetTimer("GivePlayerHealthInCP",500,false);
	else if(pers >= 80 && pers < 90) SetTimer("GivePlayerHealthInCP",300,false);
	else if(pers >= 90 && pers < 95) SetTimer("GivePlayerHealthInCP",200,false);
	else if(pers >= 95) SetTimer("GivePlayerHealthInCP",130,false);
	return 1;
}

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

function MinusHP(playerid)
{
	SetPlayerHealth(playerid,0);
	return 1;
}

function DeleteBlood(playerid)
{
	RemovePlayerAttachedObject(playerid, 5);
    return 1;
}

function CanBeSpittedTimer(i)
{
	PInfo[i][CanBeSpitted] = 1;
	return 1;
}

function Radar(playerid)
{
    for(new i; i < MAX_PLAYERS; i++)
		if(IsPlayerNPC(i)) SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF30));
	if(Team[playerid] == ZOMBIE)
	{
	    foreach(new i: Player)
	    {
	        if(!IsPlayerConnected(i)) continue;
	        if(PInfo[i][Logged] == 0) continue;
	        if(PInfo[i][Spawned] == 0 || PInfo[i][Dead] == 1) continue;
	        if(PInfo[i][Afk] == 1) continue;
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(IsPlayerInRangeOfPoint(i,19000,x,y,z))
			{
			    if(PInfo[playerid][ZPerk] == 22)
			    {
					if(GetPlayerInterior(playerid) == GetPlayerInterior(i))
					{
					    if(Team[i] == HUMAN)
					    {
					        if(PInfo[i][SPerk]== 28)
					        {
					            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
							}
							else SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
						}
						if(Team[i] == ZOMBIE)
						{
						    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
						}
					}
					else
						SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
				}
				else
				    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF300));
			}
			if(IsPlayerInRangeOfPoint(i,190,x,y,z))
			{
		        if(((PInfo[playerid][ZPerk] == 5) && (Team[i] == ZOMBIE)) || (((PInfo[playerid][GroupIN]) == (PInfo[i][GroupIN]) && (PInfo[playerid][GroupIN] >0) &&(PInfo[i][GroupIN] >0))))
				{
	   				SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				}
				else if((PInfo[playerid][ZPerk] != 5) && (Team[i] == ZOMBIE))
				{
					SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
				}
				if(Team[i] == HUMAN)
				{
				    if(PInfo[i][SPerk] == 28)
				    {
				        if(PInfo[playerid][ZPerk] == 22)
				        	SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				        else
				            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
					}
					else SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				}
				if(PInfo[playerid][ClanID] > -1)
				{
				    if(PInfo[playerid][ClanID] == PInfo[i][ClanID])
				    {
				        SetPlayerMarkerForPlayer(playerid,i,pred);
				    }
				}
			}
			if(PInfo[i][EvoidingCP] == 1)
			{
				if(IsPlayerInRangeOfPoint(i,190000,x,y,z))
				    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				else
				    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
			}
		}
	}
	if(Team[playerid] == HUMAN)
	{
	    foreach(new i: Player)
	    {
	        if(PInfo[i][Logged] == 0) continue;
	        if(PInfo[i][Spawned] == 0 || PInfo[i][Dead] == 1) continue;
	        if(PInfo[i][Afk] == 1) continue;
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(PInfo[playerid][MasterRadared] == 1)
			{
			    if(IsPlayerInRangeOfPoint(i,15000,x,y,z))
			    {
					SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				}
				else
				{
				    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
				}
			}
			else
			{
				if(IsPlayerInRangeOfPoint(i,190,x,y,z))
				{
			        if(Team[i] == HUMAN)
			        {
		                if((PInfo[playerid][GroupIN] == PInfo[i][GroupIN]) && (PInfo[i][GroupIN] != 0))
		                {
							SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
						}
						if((PInfo[playerid][GroupIN] != PInfo[i][GroupIN]) || (PInfo[i][GroupIN] == 0))
		    			{
							SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
						}
					}
			        if(PInfo[i][Hiden] == 1)
			        {
			            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
		                ShowPlayerNameTagForPlayer(playerid,i,0);
					}
					else if(PInfo[i][Hiden] == 0)
					{
						if((PInfo[playerid][Lighton] == 1) && (Team[i] == ZOMBIE))
				        {
				            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
		                    ShowPlayerNameTagForPlayer(playerid,i,1);
						}
						else if((PInfo[playerid][Lighton] == 0) && (Team[i] == ZOMBIE))
						{
						    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
						}
						if(PInfo[i][InSearch] == 1 && Team[i] == ZOMBIE)
						{
						    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
						}
					}
				}
				else SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
				if(IsPlayerInRangeOfPoint(i,190,x,y,z))
				{
					if(PInfo[playerid][ClanID] > -1)
					{
					    if(PInfo[playerid][ClanID] == PInfo[i][ClanID])
					    {
					        if(Team[i] == HUMAN)
					        	SetPlayerMarkerForPlayer(playerid,i,pred);
					    }
					}
				}
			}
		}
	}
	return 1;
}

function TeleportToLastPos(playerid)
{
    SetPlayerPos(playerid,PInfo[playerid][DX],PInfo[playerid][DY],PInfo[playerid][DZ]+3);
    return 1;
}

function CanUseHide(playerid)
{
    PInfo[playerid][CanHide] = 1;
	return 1;
}

function AllowedToPowerfulGloves(playerid)
{
	SendClientMessage(playerid,red,"» Your gloves charged enough (Powerful Gloves ready)");
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
	new Float:ax,Float:ay,Float:az;
	GetPlayerPos(playerid,ax,ay,az);
	foreach(new i: Player)
	{
	    PlayerPlaySound(i,14600,ax,ay,az);
		if(Team[i] == HUMAN) continue;
		if(IsPlayerInRangeOfPoint(i,15,ax,ay,az))
		{
		    new Float:x,Float:y,Float:z,Float:ix,Float:iy,Float:iz;
			GetPlayerPos(i,ix,iy,iz);
		    {
				if(!IsPlayerInAnyVehicle(i))
				{
                	if(PInfo[i][SPerk] != 12)
                	{
						GetPlayerVelocity(i,x,y,z);
						new Float:a = 180.0-atan2(ix-ax,iy-ay);
						x += ( 0.5 * floatsin( -a, degrees ) );
			      		y += ( 0.5 * floatcos( -a, degrees ) );
			      		ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
						SetPlayerVelocity(i,-x,-y,z+0.15);
					}
            	}//////////*/
			}
		}
	}
    return 1;
}

function PowerfulGlovesThrow(playerid,ax,ay,az)
{
	if(IsPlayerInRangeOfPoint(playerid,50,ax,ay,az))
	{
	    PlaySound(playerid,14600);
	}
    return 1;
}



function DestroyBait(playerid)
{
	RemovePlayerAttachedObject(playerid, 1);
    return 1;
}

function StingerPhase1(i)
{
    ApplyAnimation(i,"PED","DAM_LegL_frmFT",5,0,0,0,0,0,1);
	return 1;
}

function StingerPhase2(i)
{
    ApplyAnimation(i,"PED","DAM_stomach_frmRT",5,0,0,0,0,0,1);
	return 1;
}

function CanBeStingeredTime(i)
{
    PInfo[i][CanStinger] = 1;
	return 1;
}

function PutVehicle(playerid)
{
    PInfo[playerid][Hiden] = 1;
    return 1;
}

function PutBackVehicle(playerid)
{
    PutPlayerInVehicle(playerid,PInfo[playerid][HideInVehicle],PInfo[playerid][SeatID]);
    return 1;
}

function CreateGrenade(playerid,Float:fX, Float:fY, Float:fZ)
{
	CreateFakeExplosion(18685,fX,fY,fZ);
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
	}
	new Float:Health;
	foreach(new i: Player)
	{
	    GetPlayerHealth(i,Health);
        if(IsPlayerInRangeOfPoint(i,6,fX,fY,fZ))
        {
			if(Health <=25)
			{
			    if(Team[i] == ZOMBIE)
			    {
  					GivePlayerXP(playerid);
  					GivePlayerAssistXP(playerid);
				}
				SetPlayerHealth(i,0);
			}
			else
				SetPlayerHealth(i,Health-25);
		}
	}
	return 1;
}

function StopBait(playerid)
{
	foreach(new i: Player)
	{
   		if(PInfo[i][Dead] == 1) continue;
	    if(Team[i] == HUMAN) continue;
		if(IsPlayerInRangeOfPoint(i,15.0,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
		foreach(new f: Player)
		{
		    ClearAnimations(i,1);
		}
	}
	KillTimer(PInfo[playerid][ToBaitTimer]);
	PInfo[playerid][ZX] = 0.0;
	DestroyProjectile(PInfo[playerid][ObjectProj]);
	PInfo[playerid][WhatThrow] = 0;
	DestroyObject(PInfo[playerid][ZObject]);
	PInfo[playerid][ZObject] = 0;
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
        new Float:health;
		GetPlayerHealth(playerid,health);
		if(health <= 7)
		{
			if(Team[id] == HUMAN)
			{
			    if(Team[playerid] == HUMAN)
			    {
			        if(PInfo[playerid][Infected] == 1)
			        {
				        PInfo[id][Kills]++;
				        PInfo[playerid][Dead] = 1;
				        GivePlayerXP(id);
			        	CheckRankup(id);
			        	InfectPlayer(playerid);
			        	GivePlayerAssistXP(id);
					}
				}
				else
				{
			        {
				        PInfo[id][Kills]++;
				        GivePlayerXP(id);
			        	CheckRankup(id);
			        	GivePlayerAssistXP(id);
					}
				}
			}
			else
			{
		        PInfo[id][Screameds]++;
		        PInfo[playerid][Dead] = 1;
		        GivePlayerXP(id);
	        	CheckRankup(id);
	        	InfectPlayer(playerid);
	        	GivePlayerAssistXP(id);
			}
		}
		else
		    SetPlayerHealth(playerid,health-7);
		PInfo[playerid][OnFire]++;
	}
	return 1;
}

function AffectFireBull(playerid,id)
{
	if(PInfo[playerid][OnFire] == 5)
	{
		PInfo[playerid][OnFire] = 0;
		DestroyObject(PInfo[playerid][FireObject]);
	}
	else
	{
        new Float:health;
		GetPlayerHealth(playerid,health);
		if(health <= 7)
		{
			if(Team[id] == HUMAN)
			{
			    if(Team[playerid] == HUMAN)
			    {
			        if(PInfo[playerid][Infected] == 1)
			        {
				        PInfo[id][Kills]++;
				        PInfo[playerid][Dead] = 1;
				        GivePlayerXP(id);
			        	CheckRankup(id);
			        	InfectPlayer(playerid);
			        	GivePlayerAssistXP(id);
					}
				}
				else
				{
			        {
				        PInfo[id][Kills]++;
				        GivePlayerXP(id);
			        	CheckRankup(id);
			        	GivePlayerAssistXP(id);
					}
				}
			}
			else
			{
		        PInfo[id][Infects]++;
		        PInfo[playerid][Dead] = 1;
		        GivePlayerXP(id);
	        	CheckRankup(id);
	        	InfectPlayer(playerid);
	        	GivePlayerAssistXP(id);
			}
		}
		else
		{
		    SetPlayerHealth(playerid,health-7);
 	    	SetTimerEx("AffectFireBull",750,false,"ii",playerid,id);
		}
		PInfo[playerid][OnFire]++;
	}
	return 1;
}

function UnloadMusic(playerid)
{
    StopAudioStreamForPlayer(playerid);
    return 1;
}

function CreateFakeExplosion(objectid,Float:x,Float:y,Float:z)
{
	ExplosionObjective = CreateObject(objectid,x,y,z,0,0,0,250);
	SetTimer("DestroyFakeExplosion",3000,false);
	return 1;
}

function DestroyFakeExplosion()
{
    DestroyObject(ExplosionObjective);
    return 1;
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
	SetPlayerPos(playerid,x,y+1,z+0.5);
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	return 1;
}

function DigToPlayer27perk(playerid,id)
{
    ClearAnimations(playerid);
    SetPlayerInterior(playerid,GetPlayerInterior(id));
	new Float:x,Float:y,Float:z;
	new string[128];
	format(string, sizeof string,"* "cjam"%s has dropped out of the ground, calling a small earthquake",GetPName(playerid));
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(playerid,x,y+1,z+1);
	SetPlayerVirtualWorld(playerid,0);
	GetPlayerPos(id,x,y,z);
	foreach(new i: Player)
	{
	    if(IsPlayerInRangeOfPoint(i,10,x,y,z))
	    {
	    	if(IsPlayerInAnyVehicle(i))
	    	{
	    		VehicleStarted[GetPlayerVehicleID(i)] = 0;
	    		StartVehicle(GetPlayerVehicleID(i),0);
			}
		}
	}
    foreach(new i: Player)
    {
        if(PInfo[i][Logged] == 0) continue;
        if(!IsPlayerInRangeOfPoint(i,10,x,y,z)) continue;
		SendClientMessage(i,white,string);
        if(Team[i] == ZOMBIE) continue;
        if(!IsPlayerInAnyVehicle(i))
        {
			TogglePlayerControllable(i,0);
            SetTimerEx("UnFreezePlayer",1000,false,"i",i);
        }
    }
	return 1;
}

function VomitShareMeat(playerid)
{

	new Float:x,Float:y,Float:z,string[128],Float:a;
	PInfo[playerid][SMeatBite] = 15;
	GetPlayerPos(playerid,x,y,z);
	format(string,sizeof string,"* "cjam"%s vomited tasty meat for other zombies! Bite it and get few HP!",GetPName(playerid));
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(Team[i] == HUMAN) continue;
	    if(IsPlayerInRangeOfPoint(i,15,x,y,z))
	    {
	    	SendClientMessage(i,white,string);
		}
	}
	GetPlayerFacingAngle(playerid,a);
	PInfo[playerid][MeatSObject] = CreateObject(2804,PInfo[playerid][MeatSX],PInfo[playerid][MeatSY],PInfo[playerid][MeatSZ]-0.95,0,0,a + 90,200);
	new strang[155];
	format(strang,sizeof strang,""cred"%s's "cwhite"meat\nClick "cgreen"Right Mouse Button "cwhite"to increase your HP\nBites available "cred"%i "cwhite"/"cgreen" 15",GetPName(playerid),PInfo[playerid][SMeatBite]);
	PInfo[playerid][LabelMeatForShare] = CreateDynamic3DTextLabel(strang,white,PInfo[playerid][MeatSX],PInfo[playerid][MeatSY],PInfo[playerid][MeatSZ]+0.4,15,INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	return 1;
}
function VomitPlayer(playerid)
{
	DestroyObject(PInfo[playerid][Vomit]);
	KillTimer(PInfo[playerid][VomitDamager]);
	new Float:ang;
	GetPlayerFacingAngle(playerid,ang);
	switch(PInfo[playerid][VomitRandomMeat])
	{
    	case 0:
		{
			PInfo[playerid][Vomit] = CreateObject(2905,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-0.93,0,0,ang + 90,200);
			//SendClientMessage(playerid,white,"ITs is meat 0");
		}
		case 1:
		{
            //SendClientMessage(playerid,white,"ITs is meat 1");
			PInfo[playerid][Vomit] = CreateObject(2905,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-0.6,270, 180,ang + 90,200);
		}
		case 2:
		{
            //SendClientMessage(playerid,white,"ITs is meat 2");
			PInfo[playerid][Vomit] = CreateObject(2906,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-0.95,0,0,ang + 90,200);
		}
		case 3:
		{
            //SendClientMessage(playerid,white,"ITs is meat 3");
			PInfo[playerid][Vomit] = CreateObject(2906,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-0.7,270, 180,ang + 90,200);
		}
		case 4:
		{
			PInfo[playerid][Vomit] = CreateObject(2908,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]-0.9,0,0,ang + 90,200);
            //SendClientMessage(playerid,white,"ITs is meat 4");
		}
		case 5:
		{
        	//SendClientMessage(playerid,white,"ITs is meat 5");
			PInfo[playerid][Vomit] = CreateObject(2908,PInfo[playerid][Vomitx],PInfo[playerid][Vomity] ,PInfo[playerid][Vomitz]-0.885,270, 180,ang + 90,200);
		}
	}
    PInfo[playerid][Allowedtovomit] = GetTickCount();
	PInfo[playerid][Vomitmsg] = 0;
	PInfo[playerid][VomitDamager] = SetTimerEx("VomitDamageTimer",1500,true,"i",playerid);
	return 1;
}

function CheckPing()
{
	foreach(new i: Player)
	{
		if(GetPlayerPing(i) > 500)
		{
	  		new name[MAX_PLAYER_NAME];
			GetPlayerName(i, name, sizeof(name));
	  		if(strcmp(name, "[DK]freefaal", true) == 0)
	  		{
			    KillTimer(PInfo[i][ResetPingWarns]);
			    PInfo[i][ResetPingWarns] = SetTimerEx("SetWarnsPing",32000,false,"i",i);
			    PInfo[i][HighPingWarn] ++;
			    if(PInfo[i][HighPingWarn] == 5)
			    {
					static string[128];
					format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected a High Ping - %s Kicked for 500+ Ping",GetPName(i));
					SendClientMessageToAll(white,string);
					SetTimerEx("kicken",50,false,"i",i);
				}
			}
		}
	}
}

function FiveSeconds()
{
	CheckPing();
	UpdateVehicleDamage();
	new infects;
	foreach(new i: Player)
	{
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][Afk] == 1) continue;
	    if(PInfo[i][IgnoreHim] == 1) continue;
	    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	new Allplayers;
	foreach(new i: Player)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(PInfo[i][Jailed] == 0)
	        {
	            if(PInfo[i][Training] == 0)
	            {
	                if(PInfo[i][IgnoreHim] == 0)
	                {
	                	if(PInfo[i][Afk] == 0)
	                	{
                			if(PInfo[i][ChooseAfterTr] == 0)
                			{
            					Allplayers ++;
							}
						}
					}
				}
			}
		}
	}
	if(infects > 0)
	{
	    for(new i; i < MAX_PLAYERS; i ++)
	    {
			static string2[24];
			format(string2,sizeof string2,"Infection: ~r~~h~%i%%", floatround(100.0 * floatdiv(infects, Allplayers)));
			TextDrawSetString(Infection[i],string2);
		}
		if(floatround(100.0 * floatdiv(infects, Allplayers)) >= 100)
		{
		    if(RoundEnded == 0)
		    {
                SetTimerEx("EndRound",3000,false,"i",1);
				GameTextForAll("~n~~b~ The round has ended...",1250,3);
				RoundEnded = 1;
    			foreach(new i: Player)
		        {
					SetTimerEx("EndRoundDarking",400,false,"i",i);
					TextDrawBoxColor(Dark[i], 0x00000010);
				}
			}
		}
		infects = 0;
	}
	else
	{
 		foreach(new i: Player)
	    {
			TextDrawSetString(Infection[i],"Infection: ~r~~h~0%");
		}
	}
	if(CPscleared >= 8)
	{
	    if(RoundEnded == 0)
	    {
     		foreach(new i: Player)
	        {
				SetTimerEx("EndRoundDarking",500,false,"i",i);
				TextDrawBoxColor(Dark[i], 0x00000010);
			}
			SetTimerEx("EndRound",3000,false,"i",0);
			GameTextForAll("~n~~b~The round has ended...",1250,3);
			RoundEnded = 1;
		}
	}
	return 1;
}

function EndRoundDarking(i)
{
	TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000010);
	SetTimerEx("EndRoundDarking1",125,false,"i",i);
	return 1;
}

function EndRoundDarking1(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000020);
 	SetTimerEx("EndRoundDarking2",125,false,"i",i);
	return 1;
}

function EndRoundDarking2(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000030);
 	SetTimerEx("EndRoundDarking3",125,false,"i",i);
	return 1;
}

function EndRoundDarking3(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000040);
    SetTimerEx("EndRoundDarking4",125,false,"i",i);
	return 1;
}

function EndRoundDarking4(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000050);
    SetTimerEx("EndRoundDarking5",125,false,"i",i);
	return 1;
}

function EndRoundDarking5(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000060);
    SetTimerEx("EndRoundDarking6",125,false,"i",i);
	return 1;
}

function EndRoundDarking6(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000070);
    SetTimerEx("EndRoundDarking7",125,false,"i",i);
	return 1;
}

function EndRoundDarking7(i)
{
	TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000080);
    SetTimerEx("EndRoundDarking8",125,false,"i",i);
	return 1;
}

function EndRoundDarking8(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x00000090);
    SetTimerEx("EndRoundDarking9",125,false,"i",i);
	return 1;
}

function EndRoundDarking9(i)
{
    TextDrawShowForPlayer(i,Dark[i]);
	TextDrawBoxColor(Dark[i], 0x000000FF);
	return 1;
}

function EndRound(win)
{
	foreach(new i: Player)
	{
	    TextDrawHideForPlayer(i,Dark[i]);
		TogglePlayerControllable(i,0);
		new Float:x,Float:y,Float:z;
		GetPlayerPos(i,x,y,z);
		SetPlayerCameraPos(i,x,y+15,z+5);
		SetPlayerCameraLookAt(i,x,y,z+5);
		PlaySound(i,1185);
	}
	if(win == 1)
	{
		GameTextForAll("~p~Zombies Win!~n~~p~100% of infection!",4500,3);
		foreach(new i: Player)
		{
			if(Team[i] == ZOMBIE)
			{
			    ApplyAnimation(i,"DANCING","DAN_Left_A",5,1,0,0,0,0,1);
			    SetTimerEx("DanceAgain",700,false,"i",i);
			}
		}
	}
	else
	{
		GameTextForAll("~h~~g~Survivors Win! ~h~~g~~n~Humans have cleared all of the ~r~Checkpoints~g~~h~!",3000,3);
		foreach(new i: Player)
		{
		    if(Team[i] == HUMAN)
		    {
		        ApplyAnimation(i,"DANCING","DAN_Left_A",5,1,0,0,0,0,1);
		        SetTimerEx("DanceAgain",200,false,"i",i);
			}
		    if(Team[i] == ZOMBIE)
		    {
		        ApplyAnimation(i,"SWEET","Sweet_injuredloop",5,1,0,0,0,0,1);
		        SetTimerEx("NotDanceAgain",200,false,"i",i);
		    }
		}
	}
	SetTimer("EndRound2",3500,false);
	return 1;
}

function DanceAgain(playerid)
{
    ApplyAnimation(playerid,"DANCING","DAN_Left_A",5,1,0,0,0,0,1);
	return 1;
}

function NotDanceAgain(playerid)
{
    ApplyAnimation(playerid,"SWEET","Sweet_injuredloop",5,1,0,0,0,0,1);
	return 1;
}

function EndRound2()
{
    //SetTimer("HappyHalloween",3500,false);
    SetTimer("EndRoundFinal",3000,false);
   	foreach(new i: Player)
	{
		GameTextForPlayer(i,"~b~Thanks for playing ~n~~b~Los - Santos Zombie Apocalypse!!!",3000,3);
	}
	return 1;
}

function HappyHalloween()
{
    SetTimer("EndRoundFinal",2000,false);
   	foreach(new i: Player)
	{
		GameTextForPlayer(i,"~0xFF9600FF~HAPPY HALLOWEEN!!!",1900,3);
	}
	return 1;
}

function EndRoundFinal()
{
	foreach(new i: Player)
	{
		GameTextForPlayer(i,"~w~Please wait~n~~g~~h~You will be ~r~reconnected!",6000,3);
	}
	SetTimer("RestartServer",1000,false);
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

function AllowToBlinded(i)
{
    PInfo[i][CanBeBlinded] = 1;
    return 1;
}

function BlindPlayer(playerid)
{
	TextDrawShowForPlayer(playerid,Effect[0][playerid]);
	foreach(new i: Player)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,0);
	}
	SetTimerEx("BlindHuman2", 750, false, "i", playerid);
	return 1;
}
function BlindHuman2(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[0][playerid]);
	TextDrawShowForPlayer(playerid,Effect[1][playerid]);
	SetTimerEx("BlindHuman3", 300, false, "i", playerid);
	return 1;
}

function BlindHuman3(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[1][playerid]);
	TextDrawShowForPlayer(playerid,Effect[2][playerid]);
	SetTimerEx("BlindHuman4", 300, false, "i", playerid);
	return 1;
}

function BlindHuman4(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[2][playerid]);
	TextDrawShowForPlayer(playerid,Effect[3][playerid]);
	SetTimerEx("BlindHuman5", 300, false, "i", playerid);
	return 1;
}

function BlindHuman5(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[3][playerid]);
	TextDrawShowForPlayer(playerid,Effect[4][playerid]);
	SetTimerEx("BlindHuman6", 150, false, "i", playerid);
	return 1;
}

function BlindHuman6(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[5][playerid]);
	TextDrawShowForPlayer(playerid,Effect[6][playerid]);
	foreach(new i: Player)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,1);
	}
	SetTimerEx("BlindHuman7", 720, false, "i", playerid);
	return 1;
}

function BlindHuman7(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[7][playerid]);
	TextDrawShowForPlayer(playerid,Effect[8][playerid]);
	SetTimerEx("BlindHuman8", 740, false, "i", playerid);
	return 1;
}

function BlindHuman8(playerid)
{
	for(new i; i < 8; i++)
		TextDrawHideForPlayer(playerid,Effect[i][playerid]);
	return 1;
}

function Flashbang(playerid)
{
	TextDrawShowForPlayer(playerid,Effect[0][playerid]);
	SetTimerEx("Flashbang2", 3500, false, "i", playerid);
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	foreach(new i: Player)
	{
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
		PlayerPlaySound(i,1159,X,Y,Z);
	}
	return 1;
}

function Flashbang2(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[0][playerid]);
	TextDrawShowForPlayer(playerid,Effect[1][playerid]);
	SetTimerEx("Flashbang3", 2000, false, "i", playerid);
	return 1;
}
function Flashbang3(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[1][playerid]);
	TextDrawShowForPlayer(playerid,Effect[2][playerid]);
	SetTimerEx("Flashbang4", 600, false, "i", playerid);
	return 1;
}

function Flashbang4(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[2][playerid]);
	TextDrawShowForPlayer(playerid,Effect[3][playerid]);
	SetTimerEx("Flashbang5", 600, false, "i", playerid);
	return 1;
}

function Flashbang5(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[3][playerid]);
	TextDrawShowForPlayer(playerid,Effect[4][playerid]);
	SetPlayerDrunkLevel(playerid,0);
	SetTimerEx("Flashbang6", 600, false, "i", playerid);
	return 1;
}

function Flashbang6(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[4][playerid]);
	TextDrawShowForPlayer(playerid,Effect[5][playerid]);
	SetTimerEx("Flashbang7", 600, false, "i", playerid);
	return 1;
}

function Flashbang7(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[6][playerid]);
	TextDrawShowForPlayer(playerid,Effect[7][playerid]);
	foreach(new i: Player)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,1);
	}
	PInfo[playerid][Flashed] = 0;
	SetTimerEx("Flashbang8", 600, false, "i", playerid);
	return 1;
}

function Flashbang8(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[7][playerid]);
	TextDrawShowForPlayer(playerid,Effect[8][playerid]);
	SetTimerEx("Flashbang9", 600, false, "i", playerid);
	return 1;
}

function Flashbang9(playerid)
{
	for(new i; i < 8; i++)
		TextDrawHideForPlayer(playerid,Effect[i][playerid]);
	return 1;
}

function GivePlayerXP(playerid)
{
    new ExeXP = 1;
    new DborTrXP = 1;
    new PremExXP = 0;
    if(PInfo[playerid][Premium] == 2) PremExXP += 2;
    if(PInfo[playerid][Premium] == 3) PremExXP += 2;
    if(PInfo[playerid][ExtraXP] == 1) DborTrXP = 2;
    if(PInfo[playerid][ExtraXP] == 2) DborTrXP = 3;
    if(PInfo[playerid][NewRegExtraXP] == 1) ExeXP = 2;
	if(Team[playerid] == ZOMBIE)
	{
		new rand = random(4);
		if(rand == 1)
		{
			ShowGottenItems(playerid,1);
			new dim;
   			if(PInfo[playerid][ModeSlot1] == 11 || PInfo[playerid][ModeSlot2] == 11 || PInfo[playerid][ModeSlot3] == 11)
				dim = 5+random(18)+random(13)+random(7)+random(24);
			else
				dim = 1+random(15)+random(10)+random(5)+random(20);
		    PInfo[playerid][DNIPoints] += dim;
		    if(PInfo[playerid][DNIPoints] >= 5000)
		    {
		        PInfo[playerid][DNIPoints] = 5000;
		        SendClientMessage(playerid,white,"***"cjam" You got maximum of DNA Points (you have 5000 DNA Points), spend them in laboratory (in Hive)");
		    }
		    ShowGottenItems(playerid,1);
		}
	    if(PInfo[playerid][Rank] >= 29)
	    {
	        PInfo[playerid][MeatForShare] ++;
		}
     	if(PInfo[playerid][ShowingXP] == 0)
	    {
			static string[16];
			PInfo[playerid][XP] += (24+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][CurrentXP] += (24+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
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
		    static string[16];
			PInfo[playerid][XP] += (24+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][CurrentXP] += (24+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
		    TextDrawSetString(GainXPTD[playerid],string);
		    KillTimer(PInfo[playerid][XPDTimer]);
		    PInfo[playerid][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",playerid);
		    PlaySound(playerid,1083);
		}
	}
	else
	{
	    if(PInfo[playerid][ShowingXP] == 0)
  		{
			static string[16];
			PInfo[playerid][XP] += (16+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][CurrentXP] += (16+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][InfectsRound]++;
			format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			TextDrawSetString(GainXPTD[playerid],string);
			PInfo[playerid][ShowingXP] = 1;
		    SetTimerEx("ShowXP1",100,0,"d",playerid);
		    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
		}
		else
		{
	        static string[16];
			PInfo[playerid][XP] += (16+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][CurrentXP] += (16+PremExXP) * ExeXP * DborTrXP * ExtraXPEvent;
			PInfo[playerid][InfectsRound]++;
	        format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
	        KillTimer(PInfo[playerid][XPDTimer]);
	        PInfo[playerid][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",playerid);
	        TextDrawSetString(GainXPTD[playerid],string);
	        PlaySound(playerid,1083);
		}
	}
	return 1;
}

function Damageplayer(playerid,i)
{
	if(PInfo[playerid][CanBite] == 0) return 0;
	if(PInfo[i][SPerk] == 22)
	    SetTimerEx("CantBite",720,0,"i",playerid);
	else
		SetTimerEx("CantBite",530,0,"i",playerid);
	PInfo[playerid][CanBite] = 0;
	if(PInfo[playerid][RageMode] == 0)
	{
		new Float:Health;
	    GetPlayerHealth(i,Health);
	    if((PInfo[playerid][ZPerk] == 18) || (PInfo[playerid][ZPerk] == 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 8.0 && Health > 0.0)
				{
				    if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
				    	PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[playerid][Infects] ++;
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-8.0);
			}
			else
			{
			    if(Health <= 6.5 && Health > 0.0)
				{
				    if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
				    	PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    PInfo[playerid][Infects] ++;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-6.5);
			}
			GetPlayerHealth(playerid,Health);
		}
		else if((PInfo[playerid][ZPerk] != 18) || (PInfo[playerid][ZPerk] != 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 6.5 && Health > 0.0)
				{
    				if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
			    		PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[playerid][Infects] ++;
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-6.5);
			}
			else
			{
			    if(Health <= 5.0 && Health > 0.0)
				{
				    if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
				    	PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    PInfo[playerid][Infects] ++;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-5.0);
			}
			GetPlayerHealth(playerid,Health);
		}
	}
	else if(PInfo[playerid][RageMode] == 1)
	{
		new Float:Health;
	    GetPlayerHealth(i,Health);
	    new ExtraDamage;
	    if(PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot3] == 1) ExtraDamage = 2;
	    if((PInfo[playerid][ZPerk] == 18) || (PInfo[playerid][ZPerk] == 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 12.0+ExtraDamage && Health > 0.0)
				{
    				if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
			    		PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[playerid][Infects] ++;
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-12.0-ExtraDamage);
			}
			else
			{
			    if(Health <= 10.0+ExtraDamage && Health > 0.0)
				{
    				if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
			    		PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    PInfo[playerid][Infects] ++;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-10.0-ExtraDamage);
			}
			GetPlayerHealth(playerid,Health);
		}
		else if((PInfo[playerid][ZPerk] != 18) || (PInfo[playerid][ZPerk] != 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 10.0+ExtraDamage && Health > 0.0)
				{
				    if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
				    	PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[playerid][Infects] ++;
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-10.0-ExtraDamage);
			}
			else
			{
			    if(Health <= 8.0+ExtraDamage && Health > 0.0)
				{
				    if(PInfo[playerid][ModeSlot1] == 7 || PInfo[playerid][ModeSlot2] == 7 || PInfo[playerid][ModeSlot3] == 7)
				    	PInfo[i][Resueded] = 1;
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    PInfo[playerid][Infects] ++;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-8.0-ExtraDamage);
			}
			GetPlayerHealth(playerid,Health);
		}
	}
  	PlayNearSound(i,1136);
	PInfo[playerid][CanBite] = 0;
	PInfo[playerid][Bites]++;
	PInfo[i][Lastbite] = playerid;
	if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
	if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
	{
	    if(PInfo[playerid][CanGiveDizzy] == 1)
	    {
	        PInfo[playerid][CanGiveDizzy] = 0;
	        PInfo[i][TokeDizzy] = 0;
	        SetTimerEx("CanGiveDizzy",140000,false,"i",playerid);
	    }
	}
	if(PInfo[i][Baiting] == 0)
	{
	    ApplyAnimation(i,"PED","DAM_armR_frmFT",2,0,1,1,0,0,1);
	}
	ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
	return 1;
}

function ResetRunVar(playerid,var)
{
	if(var == 1)
	{
	    if(Team[playerid] == HUMAN)
	    {
     		if(!IsPlayerInAnyVehicle(playerid)) ApplyAnimation(playerid,"PED","run_stopr",10,1,1,1,0,1,1);
     		if(PInfo[playerid][Premium] == 3) PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",110000,false,"ii",playerid,2);
			else PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",120000,false,"ii",playerid,2);
		 	PInfo[playerid][CanRun] = 0;
	    }
	}
	if(var == 2)
	{
	    if(Team[playerid] == HUMAN)
	    {
	        SendClientMessage(playerid,white,"* "cred"You feel rested enough to run faster (more stamina ready)");
	        PInfo[playerid][CanRun] = 1;
	        PInfo[playerid][RunTimerActivated] = 0;
	    }
	}
	return 1;
}

function ResetDigVar(playerid)
	return PInfo[playerid][CanDig] = 1, SendClientMessage(playerid,red,"You have enough energy to dig again. (digger ready)");

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

function IsPlatVehicle(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 409) return 1;
	if(GetVehicleModel(vehicleid) == 434) return 1;
	if(GetVehicleModel(vehicleid) == 539) return 1;
	if(GetVehicleModel(vehicleid) == 571) return 1;
	return 0;
}

function IsDiamVehicle(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 586) return 1;
	if(GetVehicleModel(vehicleid) == 451) return 1;
	if(GetVehicleModel(vehicleid) == 494) return 1;
	if(GetVehicleModel(vehicleid) == 444) return 1;
	if(GetVehicleModel(vehicleid) == 415) return 1;
	return 0;
}


function InfectPlayer(playerid)
{
	new Float:x,Float:y,Float:z;
 	GetPlayerPos(playerid,x,y,z);
	PInfo[playerid][Deaths]++;
	if(PInfo[playerid][Resueded] == 1)
	{
	    PInfo[playerid][Resueded] = 0;
	    new Float:ang;
	    GetPlayerFacingAngle(playerid,ang);
		PInfo[playerid][ResuedObj] = CreateObject(2907,x,y,z-0.9,0,0,ang+90,300);
		new string[128];
		new rand = random(5)+random(2)+1;
		PInfo[playerid][Resuedsstrength] = rand;
		format(string,sizeof string,""cgreen"Survivors "cred"residues\n"cwhite"Click "cred"Right Mouse Button"cwhite" to munch them");
		PInfo[playerid][ResuedLabel] = CreateDynamic3DTextLabel(string,0x008080AA,x,y,z+1.2,20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
	}
	PInfo[playerid][Dead] = 1;
    PInfo[playerid][JustInfected] = 1;
    Team[playerid] = ZOMBIE;
    GameTextForPlayer(playerid,"~r~~h~Infected!",4000,3);
    PInfo[playerid][Baiting] = 0;
    SetPlayerColor(playerid,purple);
    SaveDeathZombieLastPos(playerid);
    SetPlayerHealth(playerid,0);
    DestroyObject(PInfo[playerid][Flag1]);
    DestroyObject(PInfo[playerid][Flag2]);
    PInfo[playerid][EvoidingCP] = 0;
    DestroyDynamicMapIcon(PInfo[playerid][BeaconMarker]);
    KillTimer(PInfo[playerid][ToxinTimer]);
    PInfo[playerid][AfterLifeInfected] = 1;
    SetPlayerHealth(playerid,0);
    new RandomGS = random(sizeof(gRandomSkin));
    SetSpawnInfo(playerid,NO_TEAM,gRandomSkin[RandomGS],0,0,0,0,0,0,0,0,0,0);
    //SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
    PInfo[playerid][Skin] = gRandomSkin[RandomGS];
    SetTimerEx("MinusHP",500,false,"i",playerid);
	DestroyObject(PInfo[playerid][ZObject]);
	PInfo[playerid][DeathsRound]++;
	for(new f = 1; f < 39; f++)
	{
	    if(f == 25) continue;
	    if(f == 28) continue;
        TextDrawHideForPlayer(playerid,BloodHemorhage[playerid][f]);
	}
	return 1;
}

function LoadStats(playerid)
{
    PlaySound(playerid,6401);
   	new year,month,day,hour,minute,second;
	getdate(year,month,day);
	gettime(hour,minute,second);
	new DateStr[128];
	format(DateStr, sizeof DateStr,"%02d/%02d/%d - %02d:%02d:%02d",month,day,year,hour,minute,second);
	static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
 	PInfo[playerid][Level] = INI_ReadInt("Level");
 	PInfo[playerid][Rank] = INI_ReadInt("Rank");
 	PInfo[playerid][XP] = INI_ReadInt("XP");
 	PInfo[playerid][Kills] = INI_ReadInt("Kills");
 	PInfo[playerid][HoursPlayed] = INI_ReadInt("HoursPlayed");
 	PInfo[playerid][TenHoursAch] = INI_ReadInt("TenHoursAch");
 	PInfo[playerid][PlayedMinutes] = INI_ReadInt("PlayedMinutes");
 	PInfo[playerid][Infects] = INI_ReadInt("Infects");
    PInfo[playerid][Deaths] = INI_ReadInt("Deaths");
    PInfo[playerid][Screameds] = INI_ReadInt("Screameds");
    PInfo[playerid][Teamkills] = INI_ReadInt("Teamkills");
    PInfo[playerid][SPerk] = INI_ReadInt("SPerk");
    PInfo[playerid][ZPerk] = INI_ReadInt("ZPerk");
    PInfo[playerid][Bites] = INI_ReadInt("Bites");
    PInfo[playerid][Training] = INI_ReadInt("Training");
    PInfo[playerid][CPCleared] = INI_ReadInt("CPCleared");
    PInfo[playerid][Assists] = INI_ReadInt("Assists");
    PInfo[playerid][Vomited] = INI_ReadInt("Vomited");
    PInfo[playerid][Premium] = INI_ReadInt("Premium");
    PInfo[playerid][Materials] = INI_ReadInt("Materials");
    PInfo[playerid][DNIPoints] = INI_ReadInt("DNIPoints");
    PInfo[playerid][Warns] = INI_ReadInt("Warns");
    PInfo[playerid][Muted] = INI_ReadInt("Muted");
    PInfo[playerid][ExtraXP] = INI_ReadInt("ExtraXP");
    PInfo[playerid][MuteTimer] = INI_ReadInt("MuteTimer");
    PInfo[playerid][Jailed] = INI_ReadInt("Jailed");
    PInfo[playerid][JailTimer] = INI_ReadInt("JailTimer");
    PInfo[playerid][ClanID] = INI_ReadInt("ClanID");
    PInfo[playerid][ClanLeader] = INI_ReadInt("ClanLeader");
    PInfo[playerid][TrainingPhase] = INI_ReadInt("TrainingPhase");
    PInfo[playerid][ZMoney] = INI_ReadInt("ZMoney");
    PInfo[playerid][sAssists] = INI_ReadInt("sAssists");
    PInfo[playerid][zAssists] = INI_ReadInt("zAssists");
    PInfo[playerid][ExtraXPDay] = INI_ReadInt("ExtraXPDay");
    PInfo[playerid][AllowedToTip] = INI_ReadInt("AllowedToTip");
    PInfo[playerid][ExtraXPMonth] = INI_ReadInt("ExtraXPMonth");
    PInfo[playerid][ExtraXPYear] = INI_ReadInt("ExtraXPYear");
    PInfo[playerid][PremiumDay] = INI_ReadInt("PremiumDay");
    PInfo[playerid][NewRegExtraXP] = INI_ReadInt("NewRegExtraXP");
    PInfo[playerid][NewRegExtraXPTime] = INI_ReadInt("NewRegExtraXPTime");
    PInfo[playerid][PremiumRealTime] = INI_ReadInt("PremiumRealTime");
    PInfo[playerid][ExtraXPRealTime] = INI_ReadInt("ExtraXPRealTime");
    PInfo[playerid][PremiumMonth] = INI_ReadInt("PremiumMonth");
    PInfo[playerid][PremiumYear] = INI_ReadInt("PremiumYear");
    PInfo[playerid][SkillPoints] = INI_ReadInt("SkillPoints");
    PInfo[playerid][CraftingTable] = INI_ReadInt("CraftingTable");
    PInfo[playerid][Antiblindpills] = INI_ReadInt("Antiblindpills");
    PInfo[playerid][Nitro] = INI_ReadInt("Nitro");
    PInfo[playerid][StingerBullets] = INI_ReadInt("StingerBullets");
    PInfo[playerid][ImpactBullets] = INI_ReadInt("ImpactBullets");
    PInfo[playerid][BeaconBullets] = INI_ReadInt("BeaconBullets");
    PInfo[playerid][Mines] = INI_ReadInt("Mines");
    PInfo[playerid][GotInsameRage] = INI_ReadInt("GotInsameRage");
    PInfo[playerid][GotHealingRage] = INI_ReadInt("GotHealingRage");
    PInfo[playerid][GotMoreRage] = INI_ReadInt("GotMoreRage");
    PInfo[playerid][GotImperception] = INI_ReadInt("GotImperception");
    PInfo[playerid][GotAccurateDigger] = INI_ReadInt("GotAccurateDigger");
    PInfo[playerid][GotDizzyTrap] = INI_ReadInt("GotDizzyTrap");
    PInfo[playerid][GotEdibleResidues] = INI_ReadInt("GotEdibleResidues");
    PInfo[playerid][GotResuscitation] = INI_ReadInt("GotResuscitation");
    PInfo[playerid][GotCrowdedStomach] = INI_ReadInt("GotCrowdedStomach");
    PInfo[playerid][GotRegeneration] = INI_ReadInt("GotRegeneration");
    PInfo[playerid][GotCollector] = INI_ReadInt("GotCollector");
    PInfo[playerid][GotStabilizer] = INI_ReadInt("GotStabilizer");
	PInfo[playerid][ModeSlot1] = INI_ReadInt("ModeSlot1");
	PInfo[playerid][ModeSlot2] = INI_ReadInt("ModeSlot2");
	PInfo[playerid][ModeSlot3] = INI_ReadInt("ModeSlot3");
	format(DateStr, sizeof DateStr,"%02d/%02d/%d - %02d:%02d:%02d",month,day,year,hour,minute,second);
	INI_WriteString("LastLoginTimeDate",DateStr);
	INI_Save();
 	INI_Close();
	if(PInfo[playerid][ClanID] > -1)
	{
	    new ClanStr[64];
	    format(ClanStr, sizeof ClanStr,"Admin/Clans/%i.ini",PInfo[playerid][ClanID]);
	    INI_Open(ClanStr);
	    if(INI_ReadInt("ClanRemoved") == 1)
	    {
	        PInfo[playerid][ClanID] = -1;
	        PInfo[playerid][ClanLeader] = 0;
		}
		else
		{
		    new ClanNameSt[64];
		    INI_ReadString(ClanNameSt,"ClanName");
		    PInfo[playerid][ClanName] = ClanNameSt;
		}
		INI_Close();
	}
 	CheckRankup(playerid);
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
	if(PInfo[playerid][Premium] == 0)
	{
		AddItem(playerid,"Small Med Kits",5);
	    AddItem(playerid,"Medium Med Kits",4);
        AddItem(playerid,"Large Med Kits",3);
        AddItem(playerid,"Fuel",3);
        AddItem(playerid,"Oil",3);
        AddItem(playerid,"Flashlight",3);
        AddItem(playerid,"Picklock",3);
    }
    if(PInfo[playerid][Premium] == 1)
	{
	    AddItem(playerid,"Small Med Kits",8);
	 	AddItem(playerid,"Medium Med Kits",8);
	    AddItem(playerid,"Large Med Kits",8);
	    AddItem(playerid,"Fuel",8);
	    AddItem(playerid,"Oil",8);
	    AddItem(playerid,"Flashlight",8);
	    AddItem(playerid,"Dizzy Away",8);
	    AddItem(playerid,"Picklock",8);
    }
    if(PInfo[playerid][Premium] == 2)
    {
	    AddItem(playerid,"Small Med Kits",13);
     	AddItem(playerid,"Medium Med Kits",13);
	    AddItem(playerid,"Large Med Kits",13);
	    AddItem(playerid,"Fuel",13);
	    AddItem(playerid,"Oil",13);
	    AddItem(playerid,"Flashlight",13);
	    AddItem(playerid,"Picklock",13);
	    AddItem(playerid,"Dizzy Away",13);
	    AddItem(playerid,"Molotov Guide",1);
    }
    if(PInfo[playerid][Premium] == 3)
    {
	    AddItem(playerid,"Small Med Kits",19);
     	AddItem(playerid,"Medium Med Kits",19);
	    AddItem(playerid,"Large Med Kits",19);
	    AddItem(playerid,"Fuel",19);
	    AddItem(playerid,"Oil",19);
	    AddItem(playerid,"Flashlight",19);
	    AddItem(playerid,"Picklock",19);
	    AddItem(playerid,"Dizzy Away",19);
	    AddItem(playerid,"Molotov Guide",2);
	}
    if(PInfo[playerid][Antiblindpills] > 0) AddItem(playerid,"Anti-blindness pills",PInfo[playerid][Antiblindpills]);
    if(PInfo[playerid][Nitro] > 0) AddItem(playerid,"Nitro",PInfo[playerid][Nitro]);
    if(PInfo[playerid][StingerBullets] > 0) AddItem(playerid,"Stinger Bullets",PInfo[playerid][StingerBullets]);
    if(PInfo[playerid][ImpactBullets] > 0) AddItem(playerid,"Impact Bullets",PInfo[playerid][ImpactBullets]);
    if(PInfo[playerid][BeaconBullets] > 0) AddItem(playerid,"Beacon Bullets",PInfo[playerid][BeaconBullets]);
    if(PInfo[playerid][Mines] > 0) AddItem(playerid,"Mines",PInfo[playerid][Mines]);
    if(PInfo[playerid][CraftingTable] > 0) AddItem(playerid,"Crafting Table",PInfo[playerid][CraftingTable]);
	return 1;
}

function RegisterPlayer(playerid,pass[])
{
    static file[128];
    new year,month,day,hour,minute,second;
	getdate(year,month,day);
	gettime(hour,minute,second);
	new ftime = gettime();
	new DateStr[128];
	format(DateStr, sizeof DateStr,"%02d/%02d/%d - %02d:%02d:%02d",month,day,year,hour,minute,second);
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
	INI_WriteString("Password",pass);
	INI_WriteString("IP",GetHisIP(playerid));
 	INI_WriteInt("Level",0);
 	INI_WriteInt("Rank",1);
 	INI_WriteInt("XP",0);
 	INI_WriteInt("Kills",0);
    INI_WriteInt("Deaths",0);
    INI_WriteInt("HoursPlayed",0);
    INI_WriteInt("TenHoursAch",0);
    INI_WriteInt("PlayedMinutes",0);
    INI_WriteInt("Screameds",0);
    INI_WriteInt("Teamkills",0);
    INI_WriteInt("Infects",0);
    INI_WriteInt("SPerk",0);
    INI_WriteInt("ZPerk",0);
    INI_WriteInt("Bites",0);
    INI_WriteInt("ClanID",-1);
    INI_WriteInt("ClanLeader",0);
    INI_WriteInt("OldAccount",1);
    INI_WriteInt("CPCleared",0);
    INI_WriteInt("Vomited",0);
    INI_WriteInt("Assists",0);
    INI_WriteInt("Premium",0);
    INI_WriteInt("Materials",0);
    INI_WriteInt("DNIPoints",0);
    INI_WriteInt("NewRegExtraXP",1);
    INI_WriteInt("NewRegExtraXPTime",ftime + 604800);
    INI_WriteInt("SSkin",0);
    INI_WriteInt("ZSkin",0);
    INI_WriteInt("Warns",0);
    INI_WriteInt("Muted",0);
    INI_WriteInt("MuteTimer",-1);
    INI_WriteInt("JailTimer",-1);
	INI_WriteInt("sAssists",0);
	INI_WriteInt("zAssists",0);
    INI_WriteInt("Banned",0);
    INI_WriteInt("Jailed",0);
    INI_WriteInt("ZMoney",0);
    INI_WriteInt("ExtraXP",0);
    INI_WriteInt("AllowedToTip",1);
    INI_WriteInt("SkillPoints",0);
    INI_WriteString("Warn1","None");
    INI_WriteString("Warn2","None");
    INI_WriteString("Warn3","None");
    INI_WriteString("RegistrationDate",DateStr);
	INI_WriteString("LastLoginTimeDate",DateStr);
    INI_Save();
 	INI_Close();
 	LoadStats(playerid);
 	PInfo[playerid][NewRegExtraXP] = 1;
 	PInfo[playerid][NewRegExtraXPTime] = ftime + 604800;
 	PInfo[playerid][Logged] = 1;
	GameTextForPlayer(playerid,"~g~~h~You have been successfully ~n~~y~~h~registered!",4000,3);
	return 1;
}

function SaveStats(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(!IsPlayerConnected(playerid)) return 1;
    static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	INI_Open(file);
 	INI_WriteInt("Level",PInfo[playerid][Level]);
 	INI_WriteInt("Rank",PInfo[playerid][Rank]);
 	INI_WriteInt("XP",PInfo[playerid][XP]);
 	INI_WriteInt("Kills",PInfo[playerid][Kills]);
 	INI_WriteInt("HoursPlayed",PInfo[playerid][HoursPlayed]);
 	INI_WriteInt("TenHoursAch",PInfo[playerid][TenHoursAch]);
 	INI_WriteInt("PlayedMinutes",PInfo[playerid][PlayedMinutes]);
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
    INI_WriteInt("sAssists",PInfo[playerid][sAssists]);
    INI_WriteInt("zAssists",PInfo[playerid][zAssists]);
    INI_WriteInt("Materials",PInfo[playerid][Materials]);
    INI_WriteInt("DNIPoints",PInfo[playerid][DNIPoints]);
    INI_WriteInt("Premium",PInfo[playerid][Premium]);
	INI_WriteInt("PremiumYear",PInfo[playerid][PremiumYear]);
	INI_WriteInt("PremiumMonth",PInfo[playerid][PremiumMonth]);
	INI_WriteInt("PremiumDay",PInfo[playerid][PremiumDay]);
	INI_WriteInt("ExtraXPYear",PInfo[playerid][ExtraXPYear]);
	INI_WriteInt("ExtraXPMonth",PInfo[playerid][ExtraXPMonth]);
	INI_WriteInt("ExtraXPDay",PInfo[playerid][ExtraXPDay]);
	INI_WriteInt("NewRegExtraXP",PInfo[playerid][NewRegExtraXP]);
    INI_WriteInt("Warns",PInfo[playerid][Warns]);
    INI_WriteInt("Training",PInfo[playerid][Training]);
    INI_WriteInt("TrainingPhase",PInfo[playerid][TrainingPhase]);
    INI_WriteInt("Muted",PInfo[playerid][Muted]);
    INI_WriteInt("ZMoney",PInfo[playerid][ZMoney]);
    INI_WriteInt("ExtraXP",PInfo[playerid][ExtraXP]);
    INI_WriteInt("MuteTimer",PInfo[playerid][MuteTimer]);
    INI_WriteInt("AllowedToTip",PInfo[playerid][AllowedToTip]);
    INI_WriteInt("Jailed",PInfo[playerid][Jailed]);
    INI_WriteInt("SkillPoints",PInfo[playerid][SkillPoints]);
    INI_WriteInt("CraftingTable",PInfo[playerid][CraftingTable]);
    INI_WriteInt("Antiblindpills",PInfo[playerid][Antiblindpills]);
    INI_WriteInt("Nitro",PInfo[playerid][Nitro]);
    INI_WriteInt("StingerBullets",PInfo[playerid][StingerBullets]);
    INI_WriteInt("ImpactBullets",PInfo[playerid][ImpactBullets]);
    INI_WriteInt("BeaconBullets",PInfo[playerid][BeaconBullets]);
    INI_WriteInt("Mines",PInfo[playerid][Mines]);
    INI_WriteInt("JailTimer",PInfo[playerid][JailTimer]);
    INI_WriteInt("GotInsameRage",PInfo[playerid][GotInsameRage]);
    INI_WriteInt("GotHealingRage",PInfo[playerid][GotHealingRage]);
    INI_WriteInt("GotMoreRage",PInfo[playerid][GotMoreRage]);
    INI_WriteInt("GotImperception",PInfo[playerid][GotImperception]);
    INI_WriteInt("GotAccurateDigger",PInfo[playerid][GotAccurateDigger]);
    INI_WriteInt("GotDizzyTrap",PInfo[playerid][GotDizzyTrap]);
    INI_WriteInt("GotEdibleResidues",PInfo[playerid][GotEdibleResidues]);
    INI_WriteInt("GotResuscitation",PInfo[playerid][GotResuscitation]);
    INI_WriteInt("GotCrowdedStomach",PInfo[playerid][GotCrowdedStomach]);
    INI_WriteInt("GotRegeneration",PInfo[playerid][GotRegeneration]);
    INI_WriteInt("GotCollector",PInfo[playerid][GotCollector]);
    INI_WriteInt("GotStabilizer",PInfo[playerid][GotStabilizer]);
 	INI_WriteInt("ModeSlot1",PInfo[playerid][ModeSlot1]);
 	INI_WriteInt("ModeSlot2",PInfo[playerid][ModeSlot2]);
 	INI_WriteInt("ModeSlot3",PInfo[playerid][ModeSlot3]);
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
	static string[16];
	if(PInfo[playerid][TeamKilling] == 1) format(string,sizeof string,"-%i XP",PInfo[playerid][CurrentXP]);
	else format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
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
	static string[16];
	if(PInfo[playerid][TeamKilling] == 1) format(string,sizeof string," - %i XP",PInfo[playerid][CurrentXP]);
	else format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
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
	static string[16];
	if(PInfo[playerid][TeamKilling] == 1) format(string,sizeof string,"- %i XP",PInfo[playerid][CurrentXP]);
	else format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
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
	PInfo[playerid][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",playerid);
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
	PInfo[playerid][TeamKilling] = 0;
	PInfo[playerid][CurrentXP] = 0;
	return 1;
}

function CantBite(playerid)
{
    PInfo[playerid][CanBite] = 1;
	return 1;
}

function UpdateStatsForPlayer(playerid)
{
	if(PInfo[playerid][Spawned] == 0) return 0;
	if(PInfo[playerid][Dead] == 1) return 0;
	new Float:health;
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
    GetPlayerHealth(playerid,health);
   	if(PInfo[playerid][Afk] == 1)
   	{
   		TogglePlayerControllable(playerid,0);
   	}
	if(PInfo[playerid][Premium] == 0)
	{
	    if(Team[playerid] == HUMAN)
	    	format(PInfo[playerid][RankLabelText],128,""cyellow"%s\n"cgreen"Rank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
		if(Team[playerid] == ZOMBIE)
	    	format(PInfo[playerid][RankLabelText],128,""cyellow"%s\n"cpurple"Rank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
	}
	else if(PInfo[playerid][Premium] == 1)
		format(PInfo[playerid][RankLabelText],128,""cyellow"%s\n"cgold"Rank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
	else if(PInfo[playerid][Premium] == 2)
	    format(PInfo[playerid][RankLabelText],128,""cyellow"%s\n"cplat"Rank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
	else if(PInfo[playerid][Premium] == 3)
	    format(PInfo[playerid][RankLabelText],128,""cyellow"%s\n"cblue"Rank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
	UpdateDynamic3DTextLabelText(PInfo[playerid][Ranklabel],green,PInfo[playerid][RankLabelText]);
	static HPst[9];
	GetPlayerHealth(playerid,health);
	format(HPst,sizeof HPst,"%d HP",floatround(health,floatround_round));
	TextDrawSetString(PlayerHealth[playerid], HPst);
	TextDrawShowForPlayer(playerid,PlayerHealth[playerid]);
	if(Team[playerid] == HUMAN)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
		    GetVehicleHealth(GetPlayerVehicleID(playerid),health);
		    if(health <= 200) SetVehicleHealth(GetPlayerVehicleID(playerid),350);
		}
		if(PInfo[playerid][Swimming] == 1)
		{
		    GetPlayerHealth(playerid,health);
			SetPlayerHealth(playerid,health-3);
			GetPlayerHealth(playerid,health);
			if(PInfo[playerid][Infected] == 0) PInfo[playerid][Infected] = 1;
			SendClientMessage(playerid,white,"*** "cred"GO OUT FROM THE WATER, IT IS INFECTED!!!");
			if(health <= 3)
			{
		        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
		        InfectPlayer(playerid);
			}
		}
	    TextDrawHideForPlayer(playerid,RageTD[playerid]);
		TextDrawShowForPlayer(playerid,XPBox[playerid]);
	    GetPlayerHealth(playerid,health);
	    new string[256];
		if(PInfo[playerid][Rank] == 1)
		{
	    	format(string,sizeof string,"RANK: %i ~n~KILLS: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~TEAMKILLS: %i ~n~CP CLEARED: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][Kills],PInfo[playerid][sAssists],PInfo[playerid][Deaths],PInfo[playerid][Teamkills],PInfo[playerid][CPCleared]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if((PInfo[playerid][Rank] >=2) && (PInfo[playerid][Rank] <=4))
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~KILLS: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~TEAMKILLS: %i ~n~CP CLEARED: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][SPerk]+1,PInfo[playerid][Kills],PInfo[playerid][sAssists],PInfo[playerid][Deaths],PInfo[playerid][Teamkills],PInfo[playerid][CPCleared]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if((PInfo[playerid][Rank] >=5) && (PInfo[playerid][Rank] <=17))
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~KILLS: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~TEAMKILLS: %i ~n~CP CLEARED: %i ~n~FLASHBANGS: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][SPerk]+1,PInfo[playerid][Kills],PInfo[playerid][sAssists],PInfo[playerid][Deaths],PInfo[playerid][Teamkills],PInfo[playerid][CPCleared],PInfo[playerid][FlashBangs]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
	    else if((PInfo[playerid][Rank] >=18) && (PInfo[playerid][Rank] <= 29))
	    {
			format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~KILLS: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~TEAMKILLS: %i ~n~CP CLEARED: %i ~n~FLASHBANGS: %i ~n~FLAME AMMO: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][SPerk]+1,PInfo[playerid][Kills],PInfo[playerid][sAssists],PInfo[playerid][Deaths],PInfo[playerid][Teamkills],PInfo[playerid][CPCleared],PInfo[playerid][FlashBangs],PInfo[playerid][Flamerounds]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if(PInfo[playerid][Rank] >=30)
		{
			format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~KILLS: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~TEAMKILLS: %i ~n~CP CLEARED: %i ~n~FLASHBANGS: %i ~n~FLAME AMMO: %i ~n~ASSAULT GRENADES: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][SPerk]+1,PInfo[playerid][Kills],PInfo[playerid][sAssists],PInfo[playerid][Deaths],PInfo[playerid][Teamkills],PInfo[playerid][CPCleared],PInfo[playerid][FlashBangs],PInfo[playerid][Flamerounds],PInfo[playerid][AssaultGrenades]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		if(GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID)
		{
		    if(Team[GetPlayerTargetPlayer(playerid)] == HUMAN)
		    {
				new Float:x,Float:y,Float:z;
				GetPlayerPos(GetPlayerTargetPlayer(playerid),x,y,z);
				if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
				{
				   	if(GetPlayerWeapon(playerid) == 1)
		        		GameTextForPlayer(playerid,"~n~~n~~r~PRESS ~w~~k~~SNEAK_ABOUT~ + ~k~~PED_SPRINT~~n~~r~TO TRADE",1500,3);
				}
			}
		}
	}
	if(Team[playerid] == ZOMBIE)
	{
	    new Float:x,Float:y,Float:z;
	    if(PInfo[playerid][Rank] <=5)
	    {
		    foreach(new i: Player)
		    {
		        if(PInfo[i][Logged] == 0) continue;
		        if(PInfo[i][Dead] == 1) continue;
	            if(PInfo[i][Spawned] == 0) continue;
	            if(PInfo[i][Afk] == 0) continue;
	            if(PInfo[i][Training] == 1) continue;
				if(Team[i] == HUMAN)
				{
	        	    GetPlayerPos(i,x,y,z);
	        	    if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
	        	    {
	        	        GameTextForPlayer(playerid,"~w~CLICK ~r~~k~~RIGHT MOUSE BUTTON~~n~~w~TO BITE",1500,3);
	        	        break;
					}
				}
			}
		}
		TextDrawShowForPlayer(playerid,XPStats[playerid]);
		TextDrawShowForPlayer(playerid,XPBox[playerid]);
		if(PInfo[playerid][RageModeStatus] == 100)
		{
	        static Rangest[33];
	        format(Rangest,sizeof Rangest,"Press N for rage mode");
	        TextDrawLetterSize(RageTD[playerid], 0.257444, 1.342782);
	        TextDrawSetString(RageTD[playerid],Rangest);
		}
		else
		{
			static Rangest[25];
			format(Rangest,sizeof Rangest,"RAGE: %i%",PInfo[playerid][RageModeStatus]);
			TextDrawLetterSize(RageTD[playerid], 0.360444, 1.312782);
			TextDrawSetString(RageTD[playerid],Rangest);
		}
		TextDrawShowForPlayer(playerid,RageTD[playerid]);
	    GetPlayerHealth(playerid,health);
	    new string[266];
		if(PInfo[playerid][Rank] == 1)
		{
	    	format(string,sizeof string,"RANK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites]);
	    	TextDrawSetString(Stats[playerid],string);
	    	//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if((PInfo[playerid][Rank] >= 2) && (PInfo[playerid][Rank] <= 7))
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][ZPerk]+1,PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if(PInfo[playerid][Rank] == 8)
		{

	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i ~n~VOMITED: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][ZPerk]+1,PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites],PInfo[playerid][Vomited]);
			TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if((PInfo[playerid][Rank] >= 9) && (PInfo[playerid][Rank] <= 28))
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i ~n~VOMITED: %i ~n~SCREAMED: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][ZPerk]+1,PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites],PInfo[playerid][Vomited], PInfo[playerid][Screameds]);
            TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if(PInfo[playerid][Rank] == 29)
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i ~n~VOMITED: %i ~n~SCREAMED: %i ~n~MEAT FOR SHARE: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][ZPerk]+1,PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites],PInfo[playerid][Vomited], PInfo[playerid][Screameds],PInfo[playerid][MeatForShare]);
            TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
		else if(PInfo[playerid][Rank] >= 30)
		{
	    	format(string,sizeof string,"RANK: %i ~n~PERK: %i ~n~INFECTED: %i ~n~ASSISTS: %i ~n~DEATHS: %i ~n~BITES: %i ~n~VOMITED: %i ~n~SCREAMED: %i ~n~MEAT FOR SHARE: %i ~n~TOXIC BITES: %i",
	    	PInfo[playerid][Rank],PInfo[playerid][ZPerk]+1,PInfo[playerid][Infects],PInfo[playerid][zAssists],PInfo[playerid][Deaths],PInfo[playerid][Bites],PInfo[playerid][Vomited], PInfo[playerid][Screameds],PInfo[playerid][MeatForShare],PInfo[playerid][ToxicBites]);
            TextDrawSetString(Stats[playerid],string);
			//TextDrawHideForPlayer(playerid,Stats[playerid]);
			TextDrawShowForPlayer(playerid,Stats[playerid]);
		}
	}
	if(PInfo[playerid][XP] >= PInfo[playerid][XPToRankUp])
	{
		new Extra1XP;
		TextDrawShowForPlayer(playerid,RANKUP[playerid]);
		SetTimerEx("RANKUP2",50,false,"ii",playerid);
		goto func;
		func:
		{
	    	Extra1XP = PInfo[playerid][XP] - PInfo[playerid][XPToRankUp];
	    	PInfo[playerid][Rank]++;
	    	PInfo[playerid][XP] = Extra1XP;
	    	CheckRankup(playerid);
	    	if(PInfo[playerid][XP] >= PInfo[playerid][XPToRankUp]) goto func;
		}
	    new string[64];
	   	format(string, sizeof string, "* "cjam"%s just ranked up!",GetPName(playerid));
		SendNearMessage(playerid,white,string,15);
		PlayerPlaySound(playerid,31205,0,0,0);
	    if(PInfo[playerid][Rank] <= 30)
	    	SendClientMessage(playerid,white,"* "cred"CONGRATULATIONS! New perks unlocked!  (press "cwhite"Y"cred")");
		else if(PInfo[playerid][Rank] > 30)
		    SendClientMessage(playerid,white,"* "cred"CONGRATULATIONS! You've got a new high level!");
		switch(PInfo[playerid][Rank])
		{
		    case 2: SendClientMessage(playerid,white,"** "corange"You've got first perk for human and zombie class, you can check them in perks list (Press "cred"Y"corange")!");
			case 3:
			{
				SendClientMessage(playerid,white,"** "corange"You've got new weapon for human class!");
				SetPlayerSkillLevel(playerid,0,900);
			}
			case 5:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 150!");
                SetPlayerSkillLevel(playerid,0,1000);
			}
            case 10:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 175!");
			}
            case 15:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 200!");
                SendClientMessage(playerid,white,"** "cjam"Now you have 2 slots for DNI Modifications!");
				//SendClientMessage(playerid,white,"** "cred"You have opened perk boosting services! (press SPACE + ALT)");
			}
            case 20:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 225!");
			}
            case 25:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 250! "cred"(Max Zombie's Health get!)");
			}
            case 30:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Now you have 3 slots for DNI Modifications!");
			}
            case 35:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
			}
            case 40:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
			}
            case 45:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
			}
            case 50:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
			}
		}
		CheckRankup(playerid,0);
		CheckRankup(playerid,1);
		//if(Team[playerid] == HUMAN) GiveRankGun(playerid);
  		SetPlayerScore(playerid,PInfo[playerid][Rank]);
	}
	new strang[64];
	format(strang,sizeof strang,"XP: %i / %i",PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
	TextDrawSetString(XPStats[playerid],strang);
	TextDrawSetShadow(XPStats[playerid], 1);
	TextDrawShowForPlayer(playerid,XPStats[playerid]);
	TextDrawShowForPlayer(playerid,XPLEFT[playerid]);
	TextDrawShowForPlayer(playerid,XPRIGHT[playerid]);
	new Float:XPs = 100.0 * floatdiv(PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
	if(XPs < 100)
	{
		TextDrawTextSize(XPLEFT[playerid], -1.491*XPs, 18.019538);
		TextDrawTextSize(XPRIGHT[playerid], 1.491*XPs, 18.019538);
		TextDrawShowForPlayer(playerid,XPBox[playerid]);
	}
	else if(XPs >=100)
	{
		TextDrawTextSize(XPLEFT[playerid], -150, 18.019538);
		TextDrawTextSize(XPRIGHT[playerid], 150, 18.019538);
		TextDrawShowForPlayer(playerid,XPBox[playerid]);
	}
	for(new j; j < sizeof(Searchplaces);j++)
	{
	    if(Team[playerid] == HUMAN)
	    {
 			if(IsPlayerInRangeOfPoint(playerid,2.0,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2]))
			{
		    	GameTextForPlayer(playerid,"~n~~n~~r~~h~Press ~w~~k~~PED_DUCK~~r~~h~ to search for items",1200,3);
			}
		}
	}
	for(new j; j < sizeof(LootMaterials);j++)
	{
	    if(Team[playerid] == HUMAN)
	    {
 			if(IsPlayerInRangeOfPoint(playerid,2.0,LootMaterials[j][0],LootMaterials[j][1],LootMaterials[j][2]))
			{
		    	GameTextForPlayer(playerid,"~n~~n~~r~~h~Press ~w~~k~~PED_DUCK~~r~~h~ to search for MATERIALS",1200,3);
			}
		}
	}
 	if(Team[playerid] == HUMAN)
    {
		if(IsPlayerInRangeOfPoint(playerid,5.0,2786.8557,-2474.8193,14.7170))
		{
 			GameTextForPlayer(playerid,"~n~~n~~r~~h~Press ~w~~k~~PED_DUCK~~n~~r~~h~To open Craft dialog",1200,3);
		}
	}
	if(Team[playerid] == ZOMBIE)
	{
	    if(IsPlayerInRangeOfPoint(playerid,1.5,1456.3890,-1482.4321,1754.4264))
 			GameTextForPlayer(playerid,"~n~~n~~r~~h~Press ~w~~k~~PED_DUCK~ ~r~~h~TO Open~n~~r~~h~DNA MODIFICATION Dialog",1200,3);
	}
  	TextDrawShowForPlayer(playerid,Stats[playerid]);
	return 1;
}

function UpdateStats()
{
	foreach(new i: Player)
	{
	    if(PInfo[i][Spawned] == 0) continue;
        if(PInfo[i][Dead] == 1) continue;
		new Float:vhealth;
	    GetVehicleHealth(GetPlayerVehicleID(i),vhealth);
	    if(vhealth <= 250)
	    {
	        if(VehicleStarted[GetPlayerVehicleID(i)] == 1)
	        {
				StartVehicle(GetPlayerVehicleID(i),0);
				WasVehicleDamaged[GetPlayerVehicleID(i)] = 1;
				VehicleStarted[GetPlayerVehicleID(i)] = 0;
				SetVehicleHealth(GetPlayerVehicleID(i),300);
			}
		}
		if(Team[i] == HUMAN)
	    {
			if(Mission[i] == 1)
			{
				if(MissionPlace[i][1] == 1) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 1)
				    {
				        if(IsPlayerInRangeOfPoint(i,3.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for bottles.",3000,3);
				        }
				    }
				    if(MissionPlace[i][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(i,3.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for bottles.",3000,3);
				        }
				    }
				}
				if(MissionPlace[i][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,212.0680,-102.1175,1005.2578/*Locations[2][0],Locations[2][1],Locations[2][2]*/))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some clothes.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some clothes.",3000,3);
				        }
					}
				}
				if(MissionPlace[i][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some glue.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some glue.",3000,3);
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
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some ethanol.",3000,3);
				        }
				    }
				    if(MissionPlace[i][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(i,1.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some ethanol.",3000,3);
				        }
				    }
				}
				if(MissionPlace[i][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[2][0],Locations[2][1],Locations[2][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some fuse.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some fuse.",3000,3);
				        }
					}
				}
				if(MissionPlace[i][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some cans.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(i,1.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~~k~~PED_DUCK~ ~w~to search for some cans.",3000,3);
				        }
					}
				}
			}
    	}
		if(Team[i] == ZOMBIE)
		{
			if((GetTickCount() - PInfo[i][Allowedtovomit]) >= VOMITTIME && PInfo[i][Vomitmsg] == 0)
			    SendClientMessage(i,red,"You have your stomach full (vomit ready)"),PInfo[i][Vomitmsg] = 1;
			if((GetTickCount() - PInfo[i][CanJump] >= 3500)) PInfo[i][Jumps] = 0;
		}
	}
	return 1;
}

function Dizzy()
{
    AutoBalance();
	foreach(new i: Player)
	{
		if(Team[i] == ZOMBIE) continue;
		if(Team[i] == HUMAN && PInfo[i][Infected] == 0) continue;
		if(PInfo[i][PoisonDizzy] == 1)
		{
			SetPlayerWeather(i,417);
			SetPlayerTime(i,23,00);
			SetPlayerDrunkLevel(i,10000);
		}
		else if(PInfo[i][Infected] == 1)
		{
			if(PInfo[i][TokeBlind] == 0)
			{
				SetPlayerWeather(i,345);
                SetPlayerTime(i,23,00);
			}
			else
			{
				SetPlayerWeather(i,683198);
				SetPlayerTime(i,23,00);
			}
			if(PInfo[i][TokeDizzy] == 0) SetPlayerDrunkLevel(i,10000);
			if(PInfo[i][Rank] < 5)
			{
				new Float:hp;
				GetPlayerHealth(i,hp);
				if(hp <= 20)
					SendClientMessage(i,white,"* "corange"You have low amount of health, use your medical kits from inventory or go to CP");
			}
		}
	}
	SetTimer("Enddizzy",10000,false);
	//321346
	return 1;
}

function RemoveOilOrFuel()
{
	if(CanSpawn == 0)
		CanSpawn = 1;
	for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
	{
		if(!IsVehicleOccupied(i)) continue;
		if(!IsVehicleStarted(i)) continue;
		if(i == Hunter) continue;
		new rand = random(2);
		switch(rand)
		{
			case 0:
			{
			    if(Fuel[i] >= 1)
					Fuel[i] = Fuel[i]-1;
				else if(Fuel[i] <= 1)
				    Fuel[i]=0;
			}
		 	case 1:
		 	{
		 	    if(Oil[i] >= 1)
				    Oil[i]= Oil[i]-1;
				else if	(Oil[i] <= 1)
			 		Oil[i]=0;
			}
		}
		UpdateVehicleFuelAndOil(i);
	}
	return 1;
}

function Enddizzy()
{
    foreach(new i: Player)
	{
		if(Team[i] == ZOMBIE) continue;
		if(Team[i] == HUMAN && PInfo[i][Infected] == 0) continue;
		SetPlayerDrunkLevel(i,0);
		SetPlayerWeather(i,RWeather);
		if(RWeather == 55) SetPlayerTime(i,7,0);
		else SetPlayerTime(i,23,0);
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
	foreach(new i: Player)
	{
	    if(Team[i] == ZOMBIE) SetPlayerWeather(i,283);
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

function RandomCheckpoint()
{
	new rand = random(17);
	CPID = rand;
	if(RoundEnded == 1) return 0;
	if(rand == 0)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
			SetPlayerCheckpoint(i,1175.0366,-2036.9196,69.1758,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Gate - C.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 1)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
			SetPlayerCheckpoint(i,1773.7175,-1943.9563,13.5575,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Unity.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 2)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
			SetPlayerCheckpoint(i,1969.8950,-1198.7197,25.6510,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Glen Park.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 3)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
			SetPlayerCheckpoint(i,872.0963,-1223.6838,16.8897,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Movie studio.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 4)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
			SetPlayerCheckpoint(i,769.8062,-1350.9500,13.5307,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Inter Global.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 5)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,532.4576,-1415.2734,15.9532,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Rodeo.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 6)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,195.2865,-1797.4672,4.1415,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Santa Maria Beach.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 7)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,2492.3152,-1668.8440,13.3438,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Grove Street.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 8)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1621.4279,-1826.1715,13.5294,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Bridge Blocked Way.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 9)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1693.8783,-1053.2822,23.9063,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Mulholland.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 10)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,2779.8269,-1632.2987,21.3661,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"East Beach.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 11)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1083.4144,-1751.2872,13.7659,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Bus Station Command Center.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 12)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1127.7173,-1490.0740,17.1947,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Mall.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 13)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1184.4330,-671.5289,60.4694,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"VineWood.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 14)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,399.3344,-1533.6930,32.4410,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Military Center.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 15)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,338.8185,-2032.8333,7.8547,20.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"Brown Star Fish.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	if(rand == 16)
	{
		foreach(new i: Player)
		{
			if(PInfo[i][Training] == 1) continue;
		    SetPlayerCheckpoint(i,1702.2764,-485.8964,55.2125,35.0);
		    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
		    SendClientMessage(i,white,"Announcer: "cpblue"This is the Emergency Broadcast system THIS IS NOT A TEST!!!");
		    SendClientMessage(i,white,"Announcer: "cpblue"If Any Survivors can hear me, head over to "cwhite"One Way Los - Santos Exit.");
		    SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Further Assistance");
		    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
		}
	}
	SetTimer("CheckCP",1000,false);
	if(CPscleared >= 4)
	{
	    foreach(new i: Player)
	    {
	        if(Team[i] == ZOMBIE) continue;
	        if(PInfo[i][Training] == 1) continue;
	        if(PInfo[i][Jailed] == 1) continue;
	        if(PInfo[i][Afk] == 1) continue;
	        if(IsPlayerNPC(i)) continue;
	    	PInfo[i][EvoidingCPTimer] = SetTimerEx("CheckIfEvoid",240000,false,"i",i);
		}
	}
	return 1;
}

function CheckCP()
{
	if(CPValue >= CPVALUE)
	{
	    CPscleared++;
		new infects;
		foreach(new i: Player)
		{
		    if(PInfo[i][Firstspawn] == 1) continue;
		    if(Team[i] == ZOMBIE) infects++;
		}
		new infections = floatround(100.0 * floatdiv(infects, PlayersConnected));
	    if((CPscleared == 5) && (infections >= 60))
	    {
	        if(CanItSupply == 1)
	        {
	        	if(SupplyDirect == -1)
	    			SetTimer("DropSupply",30000,false);
			}
		}
	    foreach(new i: Player)
	    {
	        static string2[96];
	    	format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
   			TextDrawSetString(CPSCleared[i],string2);
	        GameTextForPlayer(i,string2,4000,3);
	        if(PInfo[i][Logged] == 0) continue;
        	PInfo[i][Firsttimeincp] = 1;
		    TextDrawHideForPlayer(i,CPbar[i]);
		    TextDrawHideForPlayer(i,CPbartext[i]);
		    TextDrawHideForPlayer(i,CPvaluebar[i]);
		    TextDrawHideForPlayer(i,CPvaluepercent[i]);
        	if(IsPlayerInCheckpoint(i) && Team[i] == HUMAN)
        	{
        		SendClientMessage(i,white,"** "cred"The Military seems to be leaving, so should you... "cwhite"**");
				PInfo[i][CanUseWeapons] = 1;
				CheckRankup(i);
				PInfo[i][CPCleared]++;
			    new DorTrXP = 1;
			    new PremExXP = 0;
			    new RegPlayExXP = 1;
			    if(PInfo[i][ExtraXP] == 1) DorTrXP = 2;
			    if(PInfo[i][ExtraXP] == 2) DorTrXP = 3;
			    if(PInfo[i][Premium] == 2) PremExXP = 2;
			    if(PInfo[i][Premium] == 3) PremExXP = 4;
			    if(PInfo[i][NewRegExtraXP] == 1) RegPlayExXP = 2;
				if(PInfo[i][ShowingXP] == 0)
				{
	      			static string[16];
	      			PInfo[i][XP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
	      			PInfo[i][CurrentXP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
					format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					TextDrawSetString(GainXPTD[i],string);
					PInfo[i][ShowingXP] = 1;
					SetTimerEx("ShowXP1",100,0,"d",i);
				    TextDrawShowForPlayer(i,GainXPTD[i]);
				    PlaySound(i,1083);
				}
				else
				{
	      			static string[16];
	      			PInfo[i][XP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
	      			PInfo[i][CurrentXP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
					format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
				    TextDrawSetString(GainXPTD[i],string);
				    KillTimer(PInfo[i][XPDTimer]);
				    PInfo[i][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",i);
				    PlaySound(i,1083);
				}
       		}
       		DisablePlayerCheckpoint(i);
   		}
   		if((CPscleared == 5) && (infections >= 60))
   			SetTimer("RandomCheckpoint",250000,false);
		else
		    SetTimer("RandomCheckpoint",CPTIME,false);
   		CPID = -1;
   		CPValue = 0;
		static string3[288];
		format(string3,sizeof string3,"~w~SURVIVORS HAVE CLEARED~n~~y~%i ~w~/ ~r~8 ~w~CHECKPOINTS",CPscleared);
		GameTextForAll(string3,5000,3);
   		return 1;
	}
	else
	{
	    foreach(new i: Player)
	    {
	        if(PInfo[i][Logged] == 0) continue;
	        if(IsPlayerInCheckpoint(i))
	        {
				new string[64];
				format(string, sizeof string,"~r~CP ~w~Progress:");
				TextDrawSetString(CPbartext[i],string);
				TextDrawShowForPlayer(i,CPbar[i]);
				TextDrawShowForPlayer(i,CPbartext[i]);
				if(floatround(100.0 * floatdiv(CPValue,CPVALUE)) >= 100)
				{
                    TextDrawSetString(CPvaluepercent[i],"100\%");
				}
				else
				{
					format(string,sizeof string,"%i\%",floatround(100.0 * floatdiv(CPValue,CPVALUE)));
					TextDrawSetString(CPvaluepercent[i],string);
				}
				TextDrawShowForPlayer(i,CPvaluepercent[i]);
				TextDrawTextSize(CPvaluebar[i],2.2675 * floatround(100.0 * floatdiv(CPValue,CPVALUE)),8.341631);
				TextDrawShowForPlayer(i,CPvaluebar[i]);
				if(Team[i] == HUMAN)
				{
		            CPValue++;
				}
	        }
	    }
	    if(CPValue >= CPVALUE)
		{
		    CPscleared++;
		    static string2[35];
		    foreach(new i: Player)
		    {
		        //GameTextForPlayer(i,string2,4000,3);
				if(PInfo[i][Logged] == 0) continue;
		    	format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
		   		TextDrawSetString(CPSCleared[i],string2);
			    TextDrawHideForPlayer(i,CPbar[i]);
			    TextDrawHideForPlayer(i,CPbartext[i]);
			    TextDrawHideForPlayer(i,CPvaluebar[i]);
			    TextDrawHideForPlayer(i,CPvaluepercent[i]);
	        	PInfo[i][Firsttimeincp] = 1;
	        	if(IsPlayerInCheckpoint(i) && Team[i] == HUMAN)
	        	{
	        		SendClientMessage(i,white,"** "cred"The Military seems to be leaving, so should you.");
				    new DorTrXP = 1;
				    new PremExXP = 0;
				    new RegPlayExXP = 1;
				    if(PInfo[i][ExtraXP] == 1) DorTrXP = 2;
				    if(PInfo[i][ExtraXP] == 2) DorTrXP = 3;
				    if(PInfo[i][Premium] == 2) PremExXP = 2;
				    if(PInfo[i][Premium] == 3) PremExXP = 4;
				    if(PInfo[i][NewRegExtraXP] == 1) RegPlayExXP = 2;
					if(PInfo[i][ShowingXP] == 0)
					{
		      			static string[16];
		      			PInfo[i][XP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
		      			PInfo[i][CurrentXP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						TextDrawSetString(GainXPTD[i],string);
						PInfo[i][ShowingXP] = 1;
						SetTimerEx("ShowXP1",100,0,"d",i);
					    TextDrawShowForPlayer(i,GainXPTD[i]);
					    PlaySound(i,1083);
					}
					else
					{
		      			static string[16];
		      			PInfo[i][XP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
		      			PInfo[i][CurrentXP] += (20 + PremExXP) * DorTrXP * ExtraXPEvent * RegPlayExXP;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					    TextDrawSetString(GainXPTD[i],string);
					    KillTimer(PInfo[i][XPDTimer]);
					    PInfo[i][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",i);
					    PlaySound(i,1083);
					}
					PInfo[i][ShowingXP] = 1;
					PInfo[i][CanUseWeapons] = 1;
					CheckRankup(i);
					PInfo[i][CPCleared]++;
	       		}
	       		DisablePlayerCheckpoint(i);
	   		}
	   		SetTimer("RandomCheckpoint",CPTIME,false);
			static string3[288];
			format(string3,sizeof string3,"~w~SURVIVORS HAVE CLEARED~n~~y~%i ~w~/ ~r~8 ~w~CHECKPOINTS",CPscleared);
			GameTextForAll(string3,5000,3);
	   		CPID = -1;
	   		CPValue = 0;
	   		return 1;
		}
	}
	return SetTimer("CheckCP",1000,false);
}

function SetPlayerCP(playerid)
{
	if(PInfo[playerid][Training] == 1) return 0;
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
 		SetPlayerCheckpoint(playerid,872.0963,-1223.6838,16.8897,20.0);
	}
	if(CPID == 4)
	{
 		SetPlayerCheckpoint(playerid,769.8062,-1350.9500,13.5307,20.0);
	}
 	if(CPID == 5)
	{
 		SetPlayerCheckpoint(playerid,532.4576,-1415.2734,15.9532,20.0);
	}
	if(CPID == 6)
	{
 		SetPlayerCheckpoint(playerid,195.2865,-1797.4672,4.1415,20.0);
	}
	if(CPID == 7)
	{
 		SetPlayerCheckpoint(playerid,2492.3152,-1668.8440,13.3438,20.0);
	}
	if(CPID == 8)
	{
		SetPlayerCheckpoint(playerid,1621.4279,-1826.1715,13.5294,20.0);
	}
	if(CPID == 9)
	{
		SetPlayerCheckpoint(playerid,1693.8783,-1053.2822,23.9063,20.0);
	}
	if(CPID == 10)
	{
		SetPlayerCheckpoint(playerid,2779.8269,-1632.2987,21.3661,20.0);
	}
	if(CPID == 11)
	{
		SetPlayerCheckpoint(playerid,1083.4144,-1751.2872,13.7659,20.0);
	}
	if(CPID == 12)
	{
		SetPlayerCheckpoint(playerid,1127.7173,-1490.0740,17.1947,20.0);
	}
	if(CPID == 13)
	{
		SetPlayerCheckpoint(playerid,1184.4330,-671.5289,60.4694,20.0);
	}
	if(CPID == 14)
	{
		SetPlayerCheckpoint(playerid,399.3344,-1533.6930,32.4410,20.0);
	}
	if(CPID == 15)
	{
		SetPlayerCheckpoint(playerid,338.8185,-2032.8333,7.8547,20.0);
	}
	if(CPID == 16)
	{
		SetPlayerCheckpoint(playerid,1702.2764,-485.8964,55.2125,35.0);
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
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support","Choose","Cancel");
	if(PInfo[playerid][Rank] == 9) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina","Choose","Cancel");
	if(PInfo[playerid][Rank] == 10) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait","Choose","Cancel");
	if(PInfo[playerid][Rank] == 11) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch","Choose","Cancel");
	if(PInfo[playerid][Rank] == 12) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 13) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot","Choose","Cancel");
	if(PInfo[playerid][Rank] == 14) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor","Choose","Cancel");
 	if(PInfo[playerid][Rank] == 15) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots","Choose","Cancel");
	if(PInfo[playerid][Rank] == 16) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm","Choose","Cancel");
	if(PInfo[playerid][Rank] == 20) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades","Choose","Cancel");
	if(PInfo[playerid][Rank] == 21) return ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds","Choose","Cancel");
	if(PInfo[playerid][Rank] == 22) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 23) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 24) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 25) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 26)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tExtra meds\n3\tExtra fuel\n4\tExtra oil\n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage\n7\tBurst Run\n8\tDouble support\n9\tMore stamina\n10\tZombie Bait\n11\tFire punch\n12\tMechanic\n13\tSure Foot\n14\tField Doctor\n15\tRocket Boots\n16\tHoming Beacon");
		strcat(string,"\n17\tMaster Mechanic\n18\tFlame Rounds n19\tLucky charm\n20\tGrenades\n21\tUltimate Extra Meds");
	    strcat(string,"\n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots");
		strcat(string,"\n26\tFreezing Greeting");
		ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 27)
   	{
   	    new string[3600];
		format(string,sizeof string,"1\tNone\n2\tExtra meds\n3\tExtra fuel\n4\tExtra oil\n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage\n7\tBurst Run\n8\tDouble support\n9\tMore stamina\n10\tZombie Bait\n11\tFire punch");
		strcat(string,"\n12\tMechanic\n13\tSure Foot\n14\tField Doctor\n15\tRocket Boots\n16\tHoming Beacon");
		strcat(string,"\n17\tMaster Mechanic\n18\tFlame Rounds\n19\tLucky charm\n20\tGrenades\n21\tUltimate Extra Meds");
	    strcat(string,"\n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots");
		strcat(string,"\n26\tFreezing Greeting\n27\tExploding Bait");
		ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 28)
 	{
	 	new string[3700];
		format(string,sizeof string,"1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina \n10\tZombie Bait ");
		strcat(string,"\n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon ");
		strcat(string,"\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds ");
	    strcat(string,"\n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots");
		strcat(string,"\n26\tFreezing Greeting\n27\tExploding Bait\n28\tMedical Flag");
		ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 29)
   	{
		new string[3800];
		format(string,sizeof string,"1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina");
		strcat(string,"\n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon");
		strcat(string,"\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds");
	    strcat(string,"\n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots");
		strcat(string,"\n26\tFreezing Greeting\n27\tExploding Bait\n28\tMedical Flag\n29\tShadow Warrior");
		ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] >= 30)
 	{
		new string[3800];
		format(string,sizeof string,"1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tDouble support \n9\tMore stamina");
		strcat(string,"\n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon");
		strcat(string,"\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds");
	    strcat(string,"\n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots");
		strcat(string,"\n26\tFreezing Greeting\n27\tExploding Bait\n28\tMedical Flag\n29\tShadow Warrior\n30\tAssault Grenade Launcher");
		ShowPlayerDialog(playerid,Humanperksdialog,2,"Survivor perks",string,"Choose","Cancel");
		return 1;
	}
	return 1;
}

/*function ShowPlayerBoostingHuman(playerid)
{
	new string[4096];
	format(string,sizeof (string),""cgreen"Extra meds\t"cwhite"Level: "cred"%i \n"cgreen"\nExtra Fuel\t"cwhite"
	Level: "cred"%i\n"cgreen"Extra Oil\t"cwhite"Level: "cred"%i \n"cgreen"Flashbang Grenades\
	t"cwhite"\nLevel: "cred"%i\n"cgreen"Less BiTE Damage\t"cwhite"Level: "cred"%i\n"cgre
	en"Burst Run\t"cwhite"Level: "cred"%i\n"cgreen"Medic\t"cwhite"Level: "cred"%i\n"cgreen"More Stamina\t"cwhite
	"Level: "cred"%i\n"cgreen"Zombie Bait\t"cwhite"Level: "cred"%i\n"cgreen"Fire Punch\t"cwhite"Level: "c
	red"%i\n"cgreen"Mechanic\t"cwhite"Level: "cred"%i\n"cgreen"Sure Foot\t"cwhite"Level: "cred"%i\n"cgreen
	"Field Doctor\t"cwhite"Level: "cred"%i\n"cgreen"Rocket Boots\t"cwhite"Level: "cred"%i\n"cgreen"Master M
	echanic\t"cwhite"Level: "cred"%i\n"cgreen"Flame Rounds\t"cwhite"Level: "cred"%i\n"cgreen"Lucky Charm\t"cw
	hite"Level: "cred"%i\n"cgreen"Ultimate Extra Meds\t"cwhite"Level "cred"%i\n"cgreen"Powerful Gloves\t"cwhite"Level:
	 "cred"%i\n"cgreen"Sustained Immunity\t"cwhite"Level: "cred"%i\n"cgreen"Fusion Boots\t
	 "cwhite"Level: "cred"%i\n"cgreen"Freezing Greeting\t"cwhite"Level: "cred"%i\n"cgreen"Exploding Bait\t"cwhite
	 "Level: "cred"%i\n"cgreen"Medical Flag\t"cwhite"Level: "cred"%i\n"cgreen"Assault Grenade Launcher\t"cwhite"
	 Level: "cred"%i");
	ShowPlayerDialog(playerid,HumanPerkBoosting,2,""cred"Perk Boosting: "cgreen"Human",string,"Choose","Cancel");
	return 1;
}*/




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
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage","Choose","Cancel");
	if(PInfo[playerid][Rank] == 17) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper","Choose","Cancel");
	if(PInfo[playerid][Rank] == 18) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper \n18\tRepellent","Choose","Cancel");
	if(PInfo[playerid][Rank] == 19) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper \n18\tRepellent \n19\tRavaging Bite","Choose","Cancel");
	if(PInfo[playerid][Rank] == 20) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite\n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper Scream","Choose","Cancel");
	if(PInfo[playerid][Rank] == 21) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper Scream \n21\tPopping Tires","Choose","Cancel");
	if(PInfo[playerid][Rank] == 22) return ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks","1\tNone\n2\tHard Bite \n3\tDigger \n4\tRefreshing Bite \n5\tJumper \n6\tDead Sense \
	\n7\tHard Punch \n8\tVomiter \n9\tScreamer \n10\tBurst run \n11\tStinger Bite \n12\tBig jumper \n13\tStomp \n14\tThick Skin \n15\tGod Dig\n16\tHemorrhage \n17\tHigh Jumper \n18\tRepellent \n19\tRavaging Bite \n20\tSuper Scream \n21\tPopping Tires \n22\tExtra Refreshing Bite","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 23)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 24)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 25)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 26)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 27)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 28)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig\n28\tGodLike Jumper");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 29)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig\n28\tGodLike Jumper\n29\tMeat Sharing");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] >= 30)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig\n28\tGodLike Jumper\n29\tMeat Sharing\n30\tToxic Bite");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
	return 1;
}

function ClearBurstTimer(playerid)
{
	PInfo[playerid][CanBurst] = 1;
	SendClientMessage(playerid,white,"* "cblue"You feel rested enough to get a quick burst of energy (Burst Run Ready)");
	return 1;
}

UpdateVehicleFuelAndOil(vehicleid)
{
	if(Fuel[vehicleid] == 0)
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~-");
				GameTextForPlayer(i,"~n~~n~~r~~h~No fuel left!",4000,3);
				if(PInfo[i][Rank] < 5)
				{
					SendClientMessage(i,white,"* "corange"No Fuel left, you can fill your car, using your fuel from inventory, or find another car!");
				}
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	else if((Fuel[vehicleid] > 0) && (Fuel[vehicleid] < 2))
	{
		foreach(new i: Player)
		{
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~l");
			}
		}
	}
	else if((Fuel[vehicleid] >= 2) && (Fuel[vehicleid] <3))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 3) && (Fuel[vehicleid] <4))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~l");
			}
		}
	}
	else if((Fuel[vehicleid] >= 4) && (Fuel[vehicleid] <5))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~ll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 5) && (Fuel[vehicleid] <6))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~lll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 6) && (Fuel[vehicleid] <7))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 7) && (Fuel[vehicleid] <8))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~lllll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 8) && (Fuel[vehicleid] <9))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll");
			}
		}
	}
	else if((Fuel[vehicleid] >= 9) && (Fuel[vehicleid] < 10))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll~g~~h~l");
			}
		}
	}
	else if(Fuel[vehicleid] >= 10)
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
			}
		}
	}
	if(Oil[vehicleid] == 0)
	{
        foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~-");
				GameTextForPlayer(i,"~n~~n~~r~~h~No Oil left!",4000,3);
				if(PInfo[i][Rank] < 5)
				{
					SendClientMessage(i,white,"* "corange"No oil left, you can fill your car, using your oil from inventory, or find another car!");
				}
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	else if((Oil[vehicleid] > 0) && (Oil[vehicleid] < 2))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~l");
			}
		}
	}
	else if((Oil[vehicleid] >= 2) && (Oil[vehicleid] <3))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll");
			}
		}
	}
	else if((Oil[vehicleid] >= 3) && (Oil[vehicleid] <4))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~l");
			}
		}
	}
	else if((Oil[vehicleid] >= 4) && (Oil[vehicleid] <5))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~ll");
			}
		}
	}
	else if((Oil[vehicleid] >= 5) && (Oil[vehicleid] <6))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~lll");
			}
		}
	}
	else if((Oil[vehicleid] >= 6) && (Oil[vehicleid] <7))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llll");
			}
		}
	}
	else if((Oil[vehicleid] >= 7) && (Oil[vehicleid] <8))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~lllll");
			}
		}
	}
	else if((Oil[vehicleid] >= 8) && (Oil[vehicleid] <9))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llllll");
			}
		}
	}
	else if((Oil[vehicleid] >= 9) && (Oil[vehicleid] < 10))
	{
		foreach(new i: Player)
		{
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~ll~y~llllll~g~~h~l");
			}
		}
	}
	else if(Oil[vehicleid] >= 10)
	{
		foreach(new i: Player)
		{
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
	if(WasVehicleDamaged[GetPlayerVehicleID(playerid)] == 0)
	{
		new rand = random(2);
		if(rand == 0) return SendClientMessage(playerid,white,"** "cred"Starting Vehicle Failed!"cwhite"**"),PInfo[playerid][StartCar] = 0;
		else
		{
		    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
		    StartVehicle(GetPlayerVehicleID(playerid),1);
		    PInfo[playerid][StartCar] = 0;
		    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
		    SetTimerEx("UpdateFOVehicle",650,false,"i",playerid);
		}
	}
	else if(WasVehicleDamaged[GetPlayerVehicleID(playerid)] == 1)
	{
		new rand = random(4);
		if(rand == 0)
		{
		    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
		    StartVehicle(GetPlayerVehicleID(playerid),1);
		    PInfo[playerid][StartCar] = 0;
		    SetTimerEx("UpdateFOVehicle",650,false,"i",playerid);
		    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
		}
		else return SendClientMessage(playerid,white,"** "cred"Starting Vehicle Failed!"cwhite"**"),PInfo[playerid][StartCar] = 0;
	}
	return 1;
}

function SeismicPhaseOn2(playerid)
{
    PInfo[playerid][SeismicPhase] = 2;
    SetPlayerAttachedObject(playerid,3,18681,6,0,0,-1.59,0,0,0,1,1,1,0,0);
    SetPlayerAttachedObject(playerid,4,18728,6,0,0,-1.59,0,0,0,1,1,1,0,0);
	return 1;
}

function CanUseSeismic(playerid)
{
    PInfo[playerid][CanUseSeismicShock] = 1;
	return 1;
}

function DestroyPucnhesSeis(playerid)
{
	RemovePlayerAttachedObject(playerid, 3);
	RemovePlayerAttachedObject(playerid, 4);
	return 1;
}

function RestartServer()
{
	SendRconCommand("gmx");
	return 1;
}

/*function restorpos(playerid)
{
	if(PInfo[playerid][Spectating] == 1)
	{
		SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
		SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
		PInfo[playerid][Spectating] = 0;
	}
	return 1;
}*/

function SaveBeforePos(playerid)
{
	GetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
	return 1;
}

function EnableAllAC(playerid)
{
    PInfo[playerid][EnabledAC] = 1;
	return 1;
}

function CheckRankUp(playerid)
{
    CheckRankup(playerid,1);
	if(PInfo[playerid][SPerk] == 7) CheckRankup(playerid,1);
	SetTimerEx("EnableWAC",500,false,"i",playerid);
	return 1;
}

function EnableWAC(playerid)
{
    EnableAntiCheatForPlayer(playerid,15,1);
    return 1;
}

function EnableACHide(playerid)
{
	EnableAntiCheatForPlayer(playerid,4,1);
	EnableAntiCheatForPlayer(playerid,11,1);
	EnableAntiCheatForPlayer(playerid,12,1);
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

function DropSupply()
{
	new rand = random(5);
	{
	    switch(rand)
	    {
	        case 0:
	        {
	            foreach(new i: Player)
	            {
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60\%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Airport.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 0;
				SetTimer("SendSupply",20000,false);
			}
			case 1:
			{
	            foreach(new i: Player)
	            {
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60\%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Market.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 1;
				SetTimer("SendSupply",20000,false);
			}
			case 2:
			{
	            foreach(new i: Player)
	            {
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60\%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Grove st.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 2;
				SetTimer("SendSupply",20000,false);
			}
			case 3:
			{
	            foreach(new i: Player)
	            {
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60\%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered to "cwhite"drains near Unity");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 3;
				SetTimer("SendSupply",20000,false);
			}
			case 4:
			{
	            foreach(new i: Player)
	            {
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60\%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered to "cwhite"Ammunation");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 4;
				SetTimer("SendSupply",20000,false);
			}
		}
	}
	return 1;
}


function SendSupply()
{
	InvadingTimer = SetTimer("invadinprogress",1250,true);
	new Float:SX,Float:SY,Float:SZ;
    foreach(new i: Player)
    {
	    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
	    SendClientMessage(i,white,"Announcer: "cpblue"Container has been delivered to final destination!");
	    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
	}
	static string[512];
	format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
	switch(SupplyDirect)
	{
	    case 0:
	    {
            foreach(new i: Player)
            {
				SetPlayerMapIcon(i,77,1986.0311,-2381.5178,13.5469,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,1986.40405,-2383.26196,12.547,0,0,0,300);
			objectsupply1 = CreateObject(18728,1986.40405,-2383.26196,12.547,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = CreateDynamic3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
		}
	    case 1:
	    {
            foreach(new i: Player)
            {
				SetPlayerMapIcon(i,77,839.1480,-1369.9624,22.5321,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,834.56836,-1367.35254,21.532,0,0,0,300);
			objectsupply2 = CreateObject(18728,834.56836,-1367.35254,21.532,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = CreateDynamic3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
		}
	    case 2:
	    {
            foreach(new i: Player)
            {
				SetPlayerMapIcon(i,77,2518.4868,-1563.7096,22.8676,18,0,MAPICON_GLOBAL);
			}
   			objectsupply1 = CreateObject(2973,2517.23706,-1561.51404,21.945,0,0,0,300);
   			objectsupply2 = CreateObject(18728,2517.23706,-1561.51404,21.945,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = CreateDynamic3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
		}
	    case 3:
	    {
            foreach(new i: Player)
            {
				SetPlayerMapIcon(i,77,2022.0211,-1851.5437,3.9844,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,2023.30896,-1851.44397,2.984,0,0,0,300);
			objectsupply2 = CreateObject(18728,2023.30896,-1851.44397,2.984,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = CreateDynamic3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
		}
	    case 4:
	    {
            foreach(new i: Player)
            {
				SetPlayerMapIcon(i,77,1360.9065,-1262.3665,13.3828,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,1359.78601,-1263.35803,12.383,0,0,0,300);
			objectsupply2 = CreateObject(18728,1359.78601,-1263.35803,12.383,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = CreateDynamic3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0);
		}
	}
	return 1;
}

function RemoveIgnore(playerid)
{
	PInfo[playerid][IgnoreHim] = 1;
	return 1;
}

function invadinprogress()
{
	if((SupplyDestroyed == 0) && (SupplyInvaded == 0))
	{
		new Float:SX,Float:SY,Float:SZ,id = -1;
		GetObjectPos(objectsupply1,SX,SY,SZ);
		foreach(new i: Player)
		{
			if(PInfo[i][Logged] == 0) continue;
			if(Team[i] == ZOMBIE) continue;
			if(!IsPlayerInRangeOfPoint(i,10,SX,SY,SZ)) continue;
			id ++;
		}
		if(id != -1)
		{
			if(SupplyInvadeProgress >= 100)
			{
			    KillTimer(InvadingTimer);
			    SupplyInvaded = 1;
			    DestroyObject(objectsupply1);
			    DestroyObject(objectsupply2);
			    DestroyDynamic3DTextLabel(SupplyLabel);
			    foreach(new i: Player)
			    {
	    			RemovePlayerMapIcon(i,77);
					if(PInfo[i][Logged] == 0) continue;
					SendClientMessage(i,white,"** "cgreen"Container was Captured!");
					SendClientMessage(i,white,"** "cgreen"Humans got new Items to their inventory!");
					if(IsPlayerInRangeOfPoint(i,15,SX,SY,SZ))
					{
						if(Team[i] == HUMAN)
						{
					        new weapons[13][2];
							for(new f = 0; f < 13; f++)
							{
							    GetPlayerWeaponData(i, f, weapons[f][0], weapons[f][1]);
							}
						    SendClientMessage(i,white,"** "cgreen"You've got 3 items of all items!");
						    SendClientMessage(i,white,"** "cgreen"You've got extra ammo for your weapons!");
						    SendClientMessage(i,white,"** "cgreen"You've got extra XP for captured container!");
						    GivePlayerXP(i);
						    PlayerPlaySound(i,6401,SX,SY,SZ);
						    AddItem(i,"Small Med Kits",3);
					     	AddItem(i,"Medium Med Kits",3);
						    AddItem(i,"Large Med Kits",3);
						    AddItem(i,"Fuel",3);
						    AddItem(i,"Oil",3);
						    AddItem(i,"Flashlight",3);
						    AddItem(i,"Picklock",3);
						    AddItem(i,"Dizzy Away",3);
							if(weapons[2][0] == 22) GivePlayerWeapon(i,22,102);
							if(weapons[2][0] == 23) GivePlayerWeapon(i,23,72);
							if(weapons[2][0] == 24) GivePlayerWeapon(i,24,42);
							if(weapons[3][0] == 25) GivePlayerWeapon(i,25,60);
							if(weapons[3][0] == 26) GivePlayerWeapon(i,26,48);
							if(weapons[3][0] == 27) GivePlayerWeapon(i,27,63);
							if(weapons[4][0] == 28) GivePlayerWeapon(i,28,300);
							if(weapons[4][0] == 29) GivePlayerWeapon(i,29,180);
							if(weapons[5][0] == 30) GivePlayerWeapon(i,30,90);
							if(weapons[5][0] == 31) GivePlayerWeapon(i,31,150);
							if(weapons[4][0] == 32) GivePlayerWeapon(i,32,375);
							if(weapons[6][0] == 33) GivePlayerWeapon(i,33,75);
							if(weapons[6][0] == 34) GivePlayerWeapon(i,34,90);
						}
					}
				}
			}
			else
			{
				SupplyInvadeProgress++;
				static string[512];
				format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
				UpdateDynamic3DTextLabelText(SupplyLabel,green,string);
			}
		}
	}
	return 1;
}



function Show1stDialog(playerid)
{
    new strang[2048];
    format(strang,sizeof strang,""cwhite"You are playing on TDM "cpurple"Zombie "cwhite"server!\nThere are 2 teams: Zombies and Humans\nBoth of them have main goal\n"cpurple"Zombies "cwhite"must to infect all humans and don't let "cgreen" Humans to clear all "cred"Checkpoints"cgreen"");
    strcat(strang,"\n"cgreen"Humans' "cwhite"main goal is clear all "cred"Checkpoints\nCheckpoints "cwhite"are red marker on your radar\nThey appear every 2 minutes after its clearing");
    strcat(strang,"\nOn training Course you will learn basics of the game that will help you later\nNow you know about gamemode, lets continue your course!");
	ShowPlayerDialog(playerid,79591,DSM,"GameMode",strang,"Go","");
	return 1;
}

function DigToTrainingVehicle(playerid)
{
	SetPlayerPosAndAngle(playerid,399.7230,2500.6580,16.4844,269.6100);
    new strang[2048];
    format(strang,sizeof strang,""cwhite"Good Job!\nNow you perfectly know basics of the game");
    strcat(strang,"\nNow get in the passenger seat and I will say what to do next");
	ShowPlayerDialog(playerid,16866,DSM,"GameMode",strang,"OK","");
    PInfo[playerid][TrainingPhase] = 15;
	return 1;
}

function UpdateFOVehicle(playerid)
{
	UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
	return 1;
}

function ResetNOPsWarnings(playerid)
{
	PInfo[playerid][NOPWarnings] = 0;
	return 1;
}

function SetWeapon(playerid)
{
	SetPlayerArmedWeapon(playerid,1);
	return 1;
}

function Spawnplayer(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

function MinusSecondForNextKick(playerid)
{
	if(PInfo[playerid][SecondsBKick] != -1)
	{
	    if(PInfo[playerid][SecondsBKick] == 0)
	    {
	    	PInfo[playerid][SecondsBKick] = 0;
	    	PInfo[playerid][CanKick] = 1;
	    	SendClientMessage(playerid,white,"* "cgreen"Now you can start new vote again!");
		}
		else
		{
		    PInfo[playerid][SecondsBKick] --;
		    SetTimerEx("MinusSecondForNextKick",1000,false,"i",playerid);
		}
	}
	return 1;
}

function EndVoting(playerid)
{
	new PlayersOnline;
	foreach(new i: Player)
	{
	    PInfo[i][VotedYes] = 0;
	    if(PInfo[i][Logged] == 1)
	    	PlayersOnline++;
	}
	if(floatround(100.0 * floatdiv(KickVoteYes, PlayersOnline)) >= 60)
	{
		new string[128];
		format(string,sizeof string,"* "cred"Server: |%i|%s has been kicked from server [Reason: %s]",ServerVotingFor,GetPName(ServerVotingFor),ServerVotingReason);
		foreach(new i: Player)
		{
			SendClientMessage(i,white,string);
		}
		SetTimerEx("kicken",100,false,"i",playerid);
 	}
	else
	{
	    new string[128];
		format(string,sizeof string,"* "cred"Server: |%i|%s won't be kicked [Reason: not enough votes]",ServerVotingFor,GetPName(ServerVotingFor),ServerVotingReason);
		foreach(new i: Player)
		{
			SendClientMessage(i,white,string);
		}
	}
	KickVoteYes = -1;
    ServerVotingFor = -1;
    ServerIsVoting = 0;
	return 1;
}


function UpdateVehicleDamage()
{
    FixOnline();
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(Team[i] == ZOMBIE) continue;
		if(IsPlayerInAnyVehicle(i))
		{
			if(GetPlayerVehicleSeat(i) == 0)
			{
			    if(WasVehicleDamaged[GetPlayerVehicleID(i)] == 1)
			    {
			        new rand = random(15);
			        if(rand == 0)
			        {
			            StartVehicle(GetPlayerVehicleID(i),0);
			            VehicleStarted[GetPlayerVehicleID(i)] = 0;
					}
			    }
			    if(PInfo[i][EvoidingCP] == 1)
			    {
			        new rand = random(9);
			        if(rand == 0)
			        {
			            StartVehicle(GetPlayerVehicleID(i),0);
			            VehicleStarted[GetPlayerVehicleID(i)] = 0;
					}
			    }
			}
		}
	}
}

function SearchInside(playerid)
{
	if(PInfo[playerid][Training] == 1)
	{
    	if(PInfo[playerid][TrainingPhase] == 5)
    	{
    	    new strang[1577];
			format(strang,sizeof strang,""cwhite"Good Job!\nIf you are lucky enough you've got a new item in your inventory! ("cred"Press N to open it"cwhite")\nOther things can be found there such as :\n\n"cgreen"Bullets for your weapons\nMed kits (give you health)\nFlashlights (lets you spot zombies on map)");
			strcat(strang,"\nPicklock (let you open locked vehicles)\nDizzy Away Pills (decreases dizzy effect after zombies' attack)\nMolotov mission (lets you craft molotov)\nFuel and Oil(you can fill your vehicle with it)\nGo to the next pickup to continue your course!");
			ShowPlayerDialog(playerid,20752,DSM,"Info",strang,"OK","");
            PInfo[playerid][TrainingPhase] = 6;
 			Player1stGate = CreatePlayerObject(playerid,980,214.7910000,1875.6939700,13.1130000,0.0000000,0.0000000,357.9950000); //thisisgateforplayer2
		}
	}
	new rand;
	rand = random(46);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0..22:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 23..25:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found can of Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 26..28:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found can of can of Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 29..31:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 32..34:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 35..37:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 38..39:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 40..41:
		    {
		        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Molotov Guide.",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][MolotovMission] = 1;
				AddItem(playerid,"Molotov Guide",1);
		    }
		    case 42:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite""cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
		    case 43..45:
		    {
		        static string[100];
   			    format(string,sizeof string,""cwhite""cjam"%s has found Picklock.",GetPName(playerid));
		        SendNearMessage(playerid,white,string,20);
		        AddItem(playerid,"Picklock",1);
		    }
		}
	}
	PInfo[playerid][FoundBullets] = 0;
	return 1;
}

function SearchInsideWith19Perk(playerid)
{
	new rand;
	rand = random(46);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0..12:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 13..16:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found can of Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 17..20:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found can of can of Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 21..24:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 25..28:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 29..32:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 33..36:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 38..40:
		    {
		        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Molotov Guide.",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][MolotovMission] = 1;
				AddItem(playerid,"Molotov Guide",1);
		    }
		    case 41..42:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite""cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
		    case 43..45:
		    {
		        static string[100];
   			    format(string,sizeof string,""cwhite""cjam"%s has found Picklock.",GetPName(playerid));
		        SendNearMessage(playerid,white,string,20);
		        AddItem(playerid,"Picklock",1);
		    }
		}
	}
	PInfo[playerid][FoundBullets] = 0;
	return 1;
}

function SearchForBullets(playerid)
{
	new rand;
	new string[228];
 	new weapons[13][2];
	for(new f = 0; f < 13; f++)
	{
	    GetPlayerWeaponData(playerid, f, weapons[f][0], weapons[f][1]);
	}
	if(PInfo[playerid][Rank] < 3)
	{
		if(weapons[2][0] == 23)
		{
	    	rand = random(17)+17;
	    	GivePlayerWeapon(playerid,23,rand);
	    	format(string,sizeof string,"* "cgreen"You have found %i bullets for your pistol!",rand);
	    	SendClientMessage(playerid,white,string);
		}
	}
	else if((PInfo[playerid][Rank] >= 3) && (PInfo[playerid][Rank] < 10))
	{
		if(weapons[2][0] == 22)
		{
		    rand = random(34)+17;
		    GivePlayerWeapon(playerid,22,rand);
		    format(string,sizeof string,"* "cgreen"You have found %i bullets for your pistol(s)!",rand);
		    SendClientMessage(playerid,white,string);
		}
	}
	else if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
	{
	    new randomer = random(2);
		if(randomer == 0)
		{
			if(weapons[3][0] == 25)
			{
			    rand = random(10)+10;
			    GivePlayerWeapon(playerid,25,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[2][0] == 22)
			{
			    rand = random(34)+17;
			    GivePlayerWeapon(playerid,22,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your pistol(s)!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
	{
	    new randomer = random(2);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 25)
			{
			    rand = random(10)+10;
			    GivePlayerWeapon(playerid,25,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 20) && (PInfo[playerid][Rank] < 25))
	{
	    new randomer = random(4);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 25)
			{
			    rand = random(10)+10;
			    GivePlayerWeapon(playerid,25,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 28)
			{
			    rand = random(50)+50;
			    GivePlayerWeapon(playerid,28,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Uzis!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 33)
			{
			    rand = random(10)+15;
			    GivePlayerWeapon(playerid,33,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Country Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 25) && (PInfo[playerid][Rank] < 30))
	{
	    new randomer = random(4);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 26)
			{
			    rand = random(8)+12;
			    GivePlayerWeapon(playerid,26,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Sawn-Off Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 28)
			{
			    rand = random(50)+50;
			    GivePlayerWeapon(playerid,28,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Uzis!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 33)
			{
			    rand = random(10)+15;
			    GivePlayerWeapon(playerid,33,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Country Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 30) && (PInfo[playerid][Rank] < 35))
	{
	    new randomer = random(5);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 26)
			{
			    rand = random(8)+12;
			    GivePlayerWeapon(playerid,26,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Sawn-Off Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 32)
			{
			    rand = random(50)+80;
			    GivePlayerWeapon(playerid,32,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Tec-9!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 33)
			{
			    rand = random(10)+15;
			    GivePlayerWeapon(playerid,33,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Country Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 4)
		{
			if(weapons[5][0] == 30)
			{
			    rand = random(15)+30;
			    GivePlayerWeapon(playerid,30,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your AK-47!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 35) && (PInfo[playerid][Rank] < 40))
	{
	    new randomer = random(5);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 27)
			{
			    rand = random(14)+14;
			    GivePlayerWeapon(playerid,27,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Combat Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 32)
			{
			    rand = random(50)+80;
			    GivePlayerWeapon(playerid,32,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Tec-9!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 33)
			{
			    rand = random(10)+15;
			    GivePlayerWeapon(playerid,33,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Country Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 4)
		{
			if(weapons[5][0] == 30)
			{
			    rand = random(15)+30;
			    GivePlayerWeapon(playerid,30,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your AK-47!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if((PInfo[playerid][Rank] >= 40) && (PInfo[playerid][Rank] < 45))
	{
	    new randomer = random(5);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 27)
			{
			    rand = random(14)+14;
			    GivePlayerWeapon(playerid,27,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Combat Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 32)
			{
			    rand = random(50)+80;
			    GivePlayerWeapon(playerid,32,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Tec-9!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 33)
			{
			    rand = random(10)+15;
			    GivePlayerWeapon(playerid,33,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Country Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 4)
		{
			if(weapons[5][0] == 31)
			{
			    rand = random(25)+40;
			    GivePlayerWeapon(playerid,31,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your M4!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	else if(PInfo[playerid][Rank] >= 45)
	{
	    new randomer = random(5);
		if(randomer == 0)
		{
			if(weapons[2][0] == 24)
			{
			    rand = random(7)+14;
			    GivePlayerWeapon(playerid,24,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Desert Eagle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 1)
		{
			if(weapons[3][0] == 27)
			{
			    rand = random(14)+14;
			    GivePlayerWeapon(playerid,27,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Combat Shotgun!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 2)
		{
			if(weapons[4][0] == 29)
			{
			    rand = random(15)+30;
			    GivePlayerWeapon(playerid,29,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your MP5!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 3)
		{
			if(weapons[6][0] == 34)
			{
			    rand = random(15)+20;
			    GivePlayerWeapon(playerid,34,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your Sniper Rifle!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
		if(randomer == 4)
		{
			if(weapons[5][0] == 31)
			{
			    rand = random(25)+40;
			    GivePlayerWeapon(playerid,31,rand);
			    format(string,sizeof string,"* "cgreen"You have found %i bullets for your M4!",rand);
			    SendClientMessage(playerid,white,string);
			}
		}
	}
	return 1;
}

function CheckIfEvoid(playerid)
{
	if(PInfo[playerid][Logged] == 0) return 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(Team[playerid] == ZOMBIE) return 0;
    PInfo[playerid][EvoidingCP] = 1;
	new Float:x,Float:y,Float:z;
    SendClientMessage(playerid,white,"** "cred"You too long not entered Checkpoint!");
    SendClientMessage(playerid,white,"** "cred"Zombies felt you and they can easily find you now!");
    SendClientMessage(playerid,white,"** "cred"Find shelter or quickly enter the checkpoint!");
    GetPlayerPos(playerid,x,y,z);
    //PlayerPlaySound(playerid,30600,0,0,0);
    //PlayerPlaySound(playerid,30600,0,0,0);
    new string[190];
    foreach(new i: Player)
    {
        if(PInfo[i][Logged] == 0) continue;
        if(PInfo[i][Level] >=1)
        {
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Checkpoint Avoiding, possibly %s is avoding CP!",GetPName(playerid));
			SendClientMessage(i,white,string);
		}
	}
	return 1;
}

function StopSound(playerid)
{
    PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	return 1;
}

function ShowHumanBoosts(playerid)
{
	new string[3800];
	format(string,sizeof string,"Extra meds \nExtra fuel \nExtra oil");
	strcat(string,"\nLess BiTE Damage \nBurst Run \nMedic \nMore stamina");
	strcat(string,"\nZombie Bait \nFire punch \nMechanic \nSure Foot \nField Doctor \nRocket Boots");
	strcat(string,"\nMaster Mechanic \nFlame Rounds \nLucky charm \nUltimate Extra Meds");
    strcat(string,"\nPowerful Gloves\nSustained Immunity\nFusion Boots");
	strcat(string,"\nFreezing Greeting\nExploding Bait\nMedical Flag\nAssault Grenade Launcher");
	ShowPlayerDialog(playerid,HumanPerkBoosting,2,""cgreen"Survivor "cwhite"boosting "cred"perks",string,"Boost","Cancel");
	return 1;
}

function ShowZombieBoosts(playerid)
{
	new string[3500];
	format(string,sizeof string,"Hard Bite\nDigger\nRefreshing Bite\nJumper");
	strcat(string,"\nHard Punch\nVomiter\nScreamer\nBurst run\nStinger Bite\nBig Jumper\nStomp\nThick Skin\nGod Dig");
	strcat(string,"\nHigh Jumper\nRavaging Bite\nSuper Scream\nExtra Refreshing Bite");
	strcat(string,"\nBlind Bite\nHell Scream\nSuper Hard Punch\nPowerful Dig\nGodLike Jumper\nMeat Sharing\nToxic Bite");
	ShowPlayerDialog(playerid,ZombiePerkBoosting,2,""cpurple"Zombie "cwhite"boosting "cred"perks",string,"Boost","Cancel");
	return 1;
}


function CanBiteVomitAgain(playerid)
{
	PInfo[playerid][CanBiteVomit] = 1;
	return 1;
}

function CanBePoisonedAgain(playerid)
{
    PInfo[playerid][Poisoned] = 0;
    return 1;
}

function ToxinPlayer(playerid,i)
{
	if(PInfo[playerid][Dead] == 1) return 1;
	if(Team[playerid] == HUMAN)
	{
		new Float:HP;
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		GetPlayerHealth(playerid,HP);
		PlayerPlaySound(playerid,32402,x,y,z);
		if(HP > 3)
		{
		    SetPlayerHealth(playerid,HP - 3);
		}
		else if(HP <= 3)
		{
		    SetPlayerHealth(playerid,HP - 3);
		    InfectPlayer(playerid);
		    PInfo[playerid][Dead] = 1;
			PInfo[i][Infects]++;
			GivePlayerXP(i);
			GivePlayerAssistXP(i);
		}
	}
	return 1;
}

function KillTimerOfPoison(playerid)
{
	KillTimer(PInfo[playerid][ToxinTimer]);
    SetPlayerDrunkLevel(playerid,4000);
	PInfo[playerid][PoisonDizzy] = 0;
	return 1;
}

function WierdAnimation(playerid)
{
    ApplyAnimation(playerid,"CRACK","CRCKDETH2",1.5,0,0,0,0,1250,1);
    return 1;
}

function GivePlayerAssistXP(playerid)
{
	if(Team[playerid] == HUMAN)
	{
		foreach(new i: Player)
		{
		    if(i == playerid) continue;
		    if(PInfo[i][Dead] == 1) continue;
		    if(PInfo[i][Afk] == 1) continue;
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(IsPlayerInRangeOfPoint(i,30.0,x,y,z))
			{
			    new GrXP;
			    if((PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) && (PInfo[playerid][GroupIN] != 0))
			    {
			        GrXP = 2*ExtraXPEvent;
			    }
			    if((PInfo[i][ClanID] == PInfo[playerid][ClanID]) && (PInfo[playerid][ClanID] != -1))
			    {
			        GrXP = (GrXP + 4)*ExtraXPEvent;
			    }
			    else GrXP = 1;
			    new DorTrXP = 1;
			    new PremExXP = 0;
			    new RegPlayExXP = 1;
			    if(PInfo[i][ExtraXP] == 1) DorTrXP = 2;
			    if(PInfo[i][ExtraXP] == 2) DorTrXP = 3;
			    if(PInfo[i][Premium] == 2) PremExXP = 2;
			    if(PInfo[i][Premium] == 3) PremExXP = 4;
			    if(PInfo[i][NewRegExtraXP] == 1) RegPlayExXP = 2;
				PInfo[i][sAssists] ++;
				if(Team[i] == HUMAN)
				{
					if(PInfo[i][ShowingXP] == 0)
					{
						static string[16];
						PInfo[i][XP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][CurrentXP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][InfectsRound]++;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						TextDrawSetString(GainXPTD[i],string);
						PInfo[i][ShowingXP] = 1;
					    SetTimerEx("ShowXP1",100,0,"d",i);
					    TextDrawShowForPlayer(i,GainXPTD[i]);
					}
					else
					{
				        static string[16];
						PInfo[i][XP] += (8+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][CurrentXP] += (8+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][InfectsRound]++;
				        format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
				        TextDrawSetString(GainXPTD[i],string);
				        KillTimer(PInfo[i][XPDTimer]);
				        PInfo[i][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",i);
					}
				}
			}
		}
	}
	else if(Team[playerid] == ZOMBIE)
	{
	    foreach(new i: Player)
	    {
	        if(i == playerid) continue;
	        if(PInfo[i][Dead] == 1) continue;
	        if(PInfo[i][Afk] == 1) continue;
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(IsPlayerInRangeOfPoint(i,20.0,x,y,z))
			{
		        if(Team[i] == ZOMBIE)
		        {
				    new GrXP;
				    if((PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) && (PInfo[playerid][GroupIN] != 0))
				    {
				        GrXP = 2*ExtraXPEvent;
				    }
				    if((PInfo[i][ClanID] == PInfo[playerid][ClanID]) && (PInfo[playerid][ClanID] != -1))
				    {
				        GrXP = (GrXP + 4)*ExtraXPEvent;
				    }
				    else GrXP = 1;
				    new DorTrXP = 1;
				    new PremExXP = 0;
				    new RegPlayExXP = 1;
				    if(PInfo[i][ExtraXP] == 1) DorTrXP = 2;
				    if(PInfo[i][ExtraXP] == 2) DorTrXP = 3;
				    if(PInfo[i][Premium] == 2) PremExXP = 2;
				    if(PInfo[i][Premium] == 3) PremExXP = 4;
				    if(PInfo[i][NewRegExtraXP] == 1) RegPlayExXP = 2;
		            PInfo[i][zAssists] ++;
					if(PInfo[i][ShowingXP] == 0)
					{
						static string[16];
						PInfo[i][XP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][CurrentXP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][InfectsRound]++;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						TextDrawSetString(GainXPTD[i],string);
						PInfo[i][ShowingXP] = 1;
					    SetTimerEx("ShowXP1",100,0,"d",i);
					    TextDrawShowForPlayer(i,GainXPTD[i]);
					}
					else
					{
				        static string[16];
						PInfo[i][XP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][CurrentXP] += (10+PremExXP+GrXP)*DorTrXP*ExtraXPEvent*RegPlayExXP;
						PInfo[i][InfectsRound]++;
				        format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
				        TextDrawSetString(GainXPTD[i],string);
				        KillTimer(PInfo[i][XPDTimer]);
				        PInfo[i][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",i);
					}
				}
			}
		}
	}
	return 1;
}

function DestroyHellFire(playerid)
{
    RemovePlayerAttachedObject(playerid, 4);
	return 1;
}

function DestroyFirePunches(playerid)
{
    RemovePlayerAttachedObject(playerid, 2);
    RemovePlayerAttachedObject(playerid, 3);
	return 1;
}

function ChangePhase2(playerid)
{
    PInfo[playerid][FlashBangThrowPhase] = 2;
	return 1;
}

function ChangePhase3(playerid)
{
    PInfo[playerid][FlashBangThrowPhase] = 3;
	return 1;
}

function ChangePhase4(playerid)
{
    PInfo[playerid][FlashBangThrowPhase] = 4;
	return 1;
}

function ChangePhase5(playerid)
{
    PInfo[playerid][FlashBangThrowPhase] = 5;
	return 1;
}

function ChangePhase6(playerid)
{
    PInfo[playerid][FlashBangThrowPhase] = 6;
	return 1;
}

function CanFlashAgain(playerid)
{
	PInfo[playerid][CanThrowFlashAgain] = 1;
	return 1;
}

function BlowFlashbang(playerid)
{
	new Float:x,Float:y,Float:z;
	GetObjectPos(PInfo[playerid][FlashBangObject],x,y,z);
	FlashFlashObj[playerid] = CreateObject(18670,x,y,z-1.5,0,0,0,100);
	SetTimerEx("DestoystrFlash",1000,false,"i",playerid);
	CreateExplosion(x,y,z,13,5);
	foreach(new i: Player)
	{
		if(PInfo[i][Logged] == 0) continue;
		if(IsPlayerInRangeOfPoint(i,20,x,y,z))
		{
		    if(IsPlayerFacingObject(i,PInfo[playerid][FlashBangObject],140))
		    {
		    	Flashbang(i);
				PInfo[i][Flashed] = 1;
			}
			else
			{
			    new Float:X,Float:Y,Float:Z;
			    Flashbang5(i);
				GetPlayerPos(i,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
				PlayerPlaySound(i,1159,X,Y,Z);
			}
		}
	}
 	PInfo[playerid][CanThrowFlashAgain] = 1;
    DestroyProjectile(PInfo[playerid][FlashBangObjectProj]);
    PInfo[playerid][WhatThrow] = 0;
	DestroyObject(PInfo[playerid][FlashBangObject]);
	PInfo[playerid][FlashBangObject] = 0;
	return 1;
}

function DestoystrFlash(playerid)
{
    DestroyObject(FlashFlashObj[playerid]);
	return 1;
}

function ExplodeBait(playerid)
{
	CreateFakeExplosion(18683,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
	new Float:HP,Float:x,Float:y,Float:z,Float:ix,Float:iy,Float:iz;
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    GetPlayerHealth(i,HP);
    	PlayerPlaySound(i,1159,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
	    if(IsPlayerInRangeOfPoint(i,15,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
	    {
			GetPlayerPos(i,ix,iy,iz);
			GetPlayerVelocity(i,x,y,z);
  			new Float:a = 180.0-atan2(ix-PInfo[playerid][ZX],iy-PInfo[playerid][ZY]);
			x += ( 0.5 * floatsin( -a, degrees ) );
  			y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(i,-x*0.6,-y*0.6,0.5);
		    GetPlayerHealth(i,HP);
			if(Team[i] == ZOMBIE)
			{
				if(CheckDealDamage(i,60) <= 60)
				{
					GivePlayerXP(playerid);
					GivePlayerAssistXP(playerid);
					GiveRage(playerid,i);
					SetPlayerHealth(i,0);
				}
			    else
					DealDamage(i,60);
			}
			else if(Team[i] == HUMAN)
			{
			    if(PInfo[i][Infected] == 1)
			    {
					if(CheckDealDamage(i,60) <= 60)
					{
					    PInfo[i][Dead] = 1;
						GivePlayerXP(playerid);
						GivePlayerAssistXP(playerid);
						InfectPlayer(i);
					}
	    			else
						DealDamage(i,60);
				}
				else
				{
					if(CheckDealDamage(i,60) <= 60)
					{
					    PInfo[i][Dead] = 1;
					    SetPlayerHealth(i,0);
					    if(i != playerid)
					    	GiveTK(playerid);
					}
	    			else
						DealDamage(i,60);
				}
			}
		}
	}
	StopBait(playerid);
	return 1;
}


function GiveRage(playerid,i)
{
    ShowGottenRage(i);
    new ExtraRage;
    if((PInfo[i][ModeSlot1] == 1 || PInfo[i][ModeSlot2] == 1 || PInfo[i][ModeSlot3] == 1) || (PInfo[i][ModeSlot1] == 3 || PInfo[i][ModeSlot2] == 3 || PInfo[i][ModeSlot3] == 3))
    ExtraRage = random(12);
    if(PInfo[playerid][Rank] >= PInfo[i][Rank])
    {
        if((PInfo[i][RageModeStatus] == 100) || (PInfo[i][RageMode] == 1)) return 1;
        new rand = random(17);
		if(PInfo[i][Rank] <= 5)
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..4: PInfo[i][RageModeStatus] += 15+ExtraRage;
			    case 5..9: PInfo[i][RageModeStatus] += 17+ExtraRage;
			    case 10..11: PInfo[i][RageModeStatus] += 18+ExtraRage;
			    case 12..13: PInfo[i][RageModeStatus] += 19+ExtraRage;
			    case 14: PInfo[i][RageModeStatus] += 20+ExtraRage;
			    case 15: PInfo[i][RageModeStatus] += 21+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 22+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
		if((PInfo[i][Rank] > 5) && (PInfo[i][Rank] <= 13))
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..8: PInfo[i][RageModeStatus] += 12+ExtraRage;
			    case 9..11: PInfo[i][RageModeStatus] += 13+ExtraRage;
			    case 12..13: PInfo[i][RageModeStatus] += 15+ExtraRage;
			    case 14..15: PInfo[i][RageModeStatus] += 17+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 18+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
		if(PInfo[i][Rank] > 14)
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..8: PInfo[i][RageModeStatus] += 8+ExtraRage;
			    case 9..11: PInfo[i][RageModeStatus] += 9+ExtraRage;
			    case 12..13: PInfo[i][RageModeStatus] += 10+ExtraRage;
			    case 14: PInfo[i][RageModeStatus] += 11+ExtraRage;
			    case 15: PInfo[i][RageModeStatus] += 12+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 13+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
	}
    else if(PInfo[playerid][Rank] < PInfo[i][Rank])
    {
        if((PInfo[i][RageModeStatus] == 100) || (PInfo[i][RageMode] == 1)) return 1;
        new rand = random(17);
		if(PInfo[i][Rank] <= 5)
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..4: PInfo[i][RageModeStatus] += 7+ExtraRage;
			    case 5..9: PInfo[i][RageModeStatus] += 8+ExtraRage;
			    case 10..11: PInfo[i][RageModeStatus] += 9+ExtraRage;
			    case 12: PInfo[i][RageModeStatus] += 10+ExtraRage;
			    case 13: PInfo[i][RageModeStatus] += 11+ExtraRage;
			    case 14: PInfo[i][RageModeStatus] += 11+ExtraRage;
			    case 15: PInfo[i][RageModeStatus] += 12+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 13+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
		if((PInfo[i][Rank] > 5) && (PInfo[i][Rank] <= 13))
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..7: PInfo[i][RageModeStatus] += 6+ExtraRage;
			    case 8..11: PInfo[i][RageModeStatus] += 7+ExtraRage;
			    case 12..13: PInfo[i][RageModeStatus] += 8+ExtraRage;
			    case 14..15: PInfo[i][RageModeStatus] += 9+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 10+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
		if(PInfo[i][Rank] > 14)
		{
			rand = random(17);
			switch(rand)
			{
			    case 0..4: PInfo[i][RageModeStatus] += 5+ExtraRage;
			    case 5..8: PInfo[i][RageModeStatus] += 6+ExtraRage;
			    case 9..11: PInfo[i][RageModeStatus] += 7+ExtraRage;
			    case 12..13: PInfo[i][RageModeStatus] += 8+ExtraRage;
			    case 14: PInfo[i][RageModeStatus] += 9+ExtraRage;
			    case 15: PInfo[i][RageModeStatus] += 10+ExtraRage;
			    case 16: PInfo[i][RageModeStatus] += 11+ExtraRage;
			}
			if(PInfo[i][RageModeStatus] >= 100) PInfo[i][RageModeStatus] = 100,PInfo[i][CanUseRage] = 1;
		}
	}
	return 1;
}

function DestroyFlag(playerid)
{
	foreach(new i: Player)
	{
		new string[128];
		format(string, sizeof string, "* "cjam"%s's flag has ended its charge!",GetPName(playerid));
		SendNearMessage(i,white,string,30);
	}
	SendClientMessage(playerid,white,"* "cred"Your flag spent all its energy, wait until it will be recharged!");
	if(IsValidObject(PInfo[playerid][Flag1]))
	{
		DestroyObject(PInfo[playerid][Flag1]);
	}
	if(IsValidObject(PInfo[playerid][Flag2]))
	{
		DestroyObject(PInfo[playerid][Flag2]);
	}
	PInfo[playerid][FlagX] = 0.0;
	KillTimer(PInfo[playerid][FlagsHPTimer]);
	return 1;
}

function RestoreFlag(playerid)
{
	SendClientMessage(playerid,white,"* "cblue"Your medical flag has been recharged! (Medical Flag Ready)");
	PInfo[playerid][CanPlaceFlag] = 1;
	return 1;
}


function FeelHPFlag(playerid)
{
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(Team[i] == ZOMBIE) continue;
	    if(PInfo[playerid][FlagX] != 0)
	    {
		    if(Team[i] == ZOMBIE) continue;
			new Float:HP,Float:x,Float:y,Float:z;
			GetPlayerHealth(i,HP);
			if(IsPlayerInRangeOfPoint(i,9.2,PInfo[playerid][FlagX],PInfo[playerid][FlagY],PInfo[playerid][FlagZ]))
			{
				if(HP >=100) continue;
				else
				{
				    EnableAntiCheatForPlayer(i,12,0);
				    GetPlayerPos(i,x,y,z);
				    PlayerPlaySound(i,40405,x,y,z);
				    SetPlayerHealth(i,HP+5);
				}
			}
			else
			    EnableAntiCheatForPlayer(i,12,1);
		}
	}
	return 1;
}

function AutoBalance()
{
	new infects,SurvLoggedIn;
	if(CanItRandom == 1)
	{
		foreach(new i: Player)
		{
		    if(PInfo[i][Firstspawn] == 1) continue;
		    if(PInfo[i][Logged] == 0) continue;
		    if(PInfo[i][Training] == 1) continue;
		    if(IsPlayerNPC(i)) continue;
		    if(PInfo[i][Jailed] == 1) continue;
		    if(Team[i] == ZOMBIE) infects++;
		    if((Team[i] == HUMAN) && (PInfo[i][Spawned] == 1))
		    {
		        SurvLoggedIn++;
			}
		}
		if((floatround(100.0 * floatdiv(infects, SurvLoggedIn)) > 30) || (SurvLoggedIn < 4)) return 1;
		else
		{
		    ServerIsAutoBalancing = 1;
		    SetTimer("Auto4",1000,false);
			foreach(new z: Player)
			{
			    SendClientMessage(z,white,"** "cred"WARNING: Autobalance will choose random survivors for supporting zombie team!!!");
				SendClientMessage(z,white,"** "cred"Autobalance: Random survivors will be chosen in...");
				SendClientMessage(z,white,"** "cred"Autobalance: 5...");
		    }
	   	}
	}
	return 1;
}

function Auto4()
{
	SetTimer("Auto3",1000,false);
	foreach(new z: Player)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 4...");
    }
    return 1;
}

function Auto3()
{
	SetTimer("Auto2",1000,false);
	foreach(new z: Player)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 3...");
    }
    return 1;
}

function Auto2()
{
	SetTimer("Auto1",1000,false);
	foreach(new z: Player)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 2...");
    }
    return 1;
}

function Auto1()
{
	SetTimer("AutoBalanceEnd",1000,false);
	foreach(new z: Player)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 1...");
    }
    return 1;
}

function AutoBalanceEnd(playerid)
{
	new infects;
	foreach(new i: Player)
	{
	    if(IsPlayerNPC(i)) continue;
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][Training] == 1) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 30)
	{
	    foreach(new i: Player)
	    {
	        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance was cancelled Reason: Infection is more than 30\%");
		}
		ServerIsAutoBalancing = 0;
		return 1;
	}
	if(PlayersConnected < 5)
	{
 		foreach(new i: Player)
	    {
	        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance was cancelled Reason: Not enough players for autobalance");
		}
		ServerIsAutoBalancing = 0;
		return 1;
	}
	SetTimer("RandomSet",100,false);
	foreach(new i: Player)
    {
        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance successfully chose random humans!");
	}
	return 1;
}


function RandomSet()
{
	new infects;
	new Destained;
	new rand = Iter_Random(Player);
    if(!IsPlayerConnected(rand))
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
    if(PInfo[rand][Logged]== 0)
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
    if(Team[rand] == ZOMBIE)
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
    if(PInfo[rand][Jailed] == 1)
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
	if(IsPlayerNPC(rand))
	{
		SetTimer("RandomSet",100,false);
		return 0;
	}
	if(PInfo[rand][Training] == 1)
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
    foreach(new i: Player)
	{
		if(PInfo[i][Firstspawn] == 1) continue;
		if(Team[i] == ZOMBIE) infects++;
	}
    Destained = floatround(100.0 * floatdiv(infects, PlayersConnected));
	SendClientMessage(rand,white,"** "cred"Autobalance: "cwhite"Random chose you! Help zombies win this round!");
	Team[rand] = ZOMBIE;
	infects ++;
    new RandomGS = random(sizeof(gRandomSkin));
    PInfo[rand][Skin] = gRandomSkin[RandomGS];
    SetPlayerSkin(rand,gRandomSkin[RandomGS]);
	SetSpawnInfo(rand,NO_TEAM,PInfo[rand][Skin],0,0,0,0,0,0,0,0,0,0);
	SpawnPlayer(rand);
	Destained = floatround(100.0 * floatdiv(infects, PlayersConnected));
	if(Destained < 30)
		SetTimer("RandomSet",100,false);
	else ServerIsAutoBalancing = 0;
    return 1;
}


function DamageVehicle(i)
{
	new Float:vh;
	GetVehicleHealth(GetPlayerVehicleID(i),vh);
	SetVehicleHealth(GetPlayerVehicleID(i),vh-75);
	SetTimerEx("DestroyVhFire",500,false,"i",i);
	return 1;
}
function DestroyVhFire(i)
{
	DestroyObject(PInfo[i][VehicleFire]);
	return 1;
}

function TimerKillBhop(playerid)
{
	PInfo[playerid][JumpsHops] = 0;
	return 1;
}

function CanPunchAgain(issuerid)
{
	PInfo[issuerid][CanPunch] = 1;
	return 1;
}

function VomitDamageTimer(playerid)
{
	if(PInfo[playerid][Vomitx] != 0)
	{
	    if(IsValidObject(PInfo[playerid][Vomit]))
	    {
			if(Team[playerid] == ZOMBIE)
			{
			   	foreach(new i: Player)
			    {
			        if(Team[i] == ZOMBIE) continue;
			        if(PInfo[i][Dead] == 1) continue;
					if(IsPlayerInRangeOfPoint(i,6,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]))
					{
					    if(IsPlayerInAnyVehicle(i))
					    {
					        new Float:vh;
					        GetVehicleHealth(GetPlayerVehicleID(i),vh);
					        SetVehicleHealth(GetPlayerVehicleID(i),vh-200);
					        StartVehicle(GetPlayerVehicleID(i),0);
							VehicleStarted[GetPlayerVehicleID(i)] = 0;
					    }
					    else
					    {
					        new Float:Health;
			    			GetPlayerHealth(i,Health);
						    if(Health >= 1.0 && Health <= 5.0)
								SetPlayerHealth(i,1.0);
							else
			    			if(PInfo[i][Rank] > PInfo[playerid][Rank])
							{
			    				if(Health <= 5.0 && Health > 0.0)
								{
								    PInfo[i][Dead] = 1;
							    	InfectPlayer(i);
							    	PInfo[playerid][Vomited]++;
							    	GivePlayerXP(playerid);
							    	GivePlayerAssistXP(playerid);
						        	CheckRankup(playerid);
						        	PInfo[i][AfterLifeInfected] = 1;
								}
								else
				    				SetPlayerHealth(i,Health-5.0);
							}
							else if(PInfo[i][Rank] == PInfo[playerid][Rank])
							{
			    				if(Health <= 8.0 && Health > 0.0)
								{
							    	InfectPlayer(i);
							    	PInfo[i][Dead] = 1;
							    	GivePlayerXP(playerid);
							    	PInfo[playerid][Vomited]++;
							    	GivePlayerAssistXP(playerid);
						        	CheckRankup(playerid);
						        	PInfo[i][AfterLifeInfected] = 1;
								}
								else
				    				SetPlayerHealth(i,Health-8.0);
							}
							else if(PInfo[i][Rank] < PInfo[playerid][Rank])
							{
			    				if(Health <= 11.0 && Health > 0.0)
								{
							    	InfectPlayer(i);
							    	PInfo[i][Dead] = 1;
							    	PInfo[playerid][Vomited]++;
							    	GivePlayerXP(playerid);
							    	GivePlayerAssistXP(playerid);
						        	CheckRankup(playerid);
						        	PInfo[i][AfterLifeInfected] = 1;
								}
								else
				    				SetPlayerHealth(i,Health-11.0);
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

function CanBeStompedAgain(i)
{
	PInfo[i][CanBeStomped] = 1;
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
    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
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
    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
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


function SetMinute(playerid)
{
	if(PInfo[playerid][PlayedMinutes] == 60)
	{
	    PInfo[playerid][HoursPlayed] ++;
	    PInfo[playerid][PlayedMinutes] = 0;
	}
	else
	    PInfo[playerid][PlayedMinutes] ++;
	if(PInfo[playerid][HoursPlayed] == 10)
	{
		if(PInfo[playerid][TenHoursAch] == 0)
  		{
			if(PInfo[playerid][ShowingXP] == 0)
 			{
				PInfo[playerid][XP] += 150;
				PInfo[playerid][CurrentXP] += 150;
			    static string[16];
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
			    static string[16];
				PInfo[playerid][XP] += 150;
				PInfo[playerid][CurrentXP] += 150;
				PInfo[playerid][InfectsRound]++;
				format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			    TextDrawSetString(GainXPTD[playerid],string);
			    KillTimer(PInfo[playerid][XPDTimer]);
			    PInfo[playerid][XPDTimer] = SetTimerEx("HideXP",2500,0,"i",playerid);
			    PlaySound(playerid,1083);
			}
			PInfo[playerid][TenHoursAch] = 1;
		}
	}
	return 1;
}

function CreateExplosionFires(playerid)
{
	RemovePlayerAttachedObject(playerid, 5);
    RemovePlayerAttachedObject(playerid, 6);
	SetPlayerAttachedObject(playerid,5,18688,9,0.00,0.00,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Left foot
	SetPlayerAttachedObject(playerid,6,18688,10,0.00,-0.09,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Right foot
	return 1;
}

function TurnOffRadar(playerid)
{
	new string[64];
    PInfo[playerid][MasterRadared] = 0;
    format(string,sizeof string,"* "cjam"%s's radar is out of energy.",GetPName(playerid));
    SendNearMessage(playerid,white,string,20);
    return 1;
}

function RageTime(playerid)
{
	if(PInfo[playerid][RageMode] == 0) return 1;
	if(PInfo[playerid][RageModeStatus] > 1)
	{
	    PInfo[playerid][RageModeStatus] --;
		static string[22];
		format(string, sizeof string,"Rage: %i%",PInfo[playerid][RageModeStatus]);
		TextDrawSetString(RageTD[playerid],string);
	}
	if(PInfo[playerid][RageModeStatus] == 1)
	{
	    PInfo[playerid][RageModeStatus] = 0;
	    SendClientMessage(playerid,white,"** "corange"Your rage is out, rage mode has been deactivated!");
	    PInfo[playerid][RageMode] = 0;
	    PInfo[playerid][CanUseRage] = 0;
	    RemovePlayerAttachedObject(playerid,2);
	    KillTimer(RageModeTimer[playerid]);
	}
	return 1;
}
//=======================================FUNCTIONS END==================================
//==============================[PUBLICS END]=================================
stock gbug_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
        gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
        return PutPlayerInVehicle(playerid, vehicleid, seatid);
}

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
	    if(Team[playerid] == ZOMBIE) return 1;
	    switch(PInfo[playerid][Rank])
		{
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,95),GivePlayerWeapon(playerid,15,1); //Silenced Pistol + Knuckles + Cane
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,154),GivePlayerWeapon(playerid,15,1);//Silenced Pistol + Knuckles + Cane
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,112),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,129),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,145),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,166),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,181),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,202),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 9: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,232),GivePlayerWeapon(playerid,6,1);//2 dual pistols + Knuckles + shovel
		    case 10: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,256),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,25);//2 dual pistols + Knuckles + shovel+shotgun
		    case 11: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,272),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,30);//2 dual pistols + Knuckles + shovel+shotgun
		    case 12: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,291),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,35);//2 dual pistols + Knuckles + shovel+shotgun
		    case 13: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,308),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,40);//2 dual pistols +Knuckles + shovel+Shotgun
		    case 14: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,325),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,45);//2 dual pistols +Knuckles + BaseBall Bat + Shotgun
		    case 15: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,50);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 16: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,55);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 17: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,60);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 18: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,65);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 19: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,63),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,70);//Deagle +Knuckles + knife + Shotgun
		    case 20: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,70),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,75),GivePlayerWeapon(playerid,28,150),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 21: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,77),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,80),GivePlayerWeapon(playerid,28,175),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 22: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,84),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,85),GivePlayerWeapon(playerid,28,200),GivePlayerWeapon(playerid,33,40); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 23: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,91),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,90),GivePlayerWeapon(playerid,28,225),GivePlayerWeapon(playerid,33,50); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 24: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,98),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,100),GivePlayerWeapon(playerid,28,250),GivePlayerWeapon(playerid,33,60); //Deagle +Knuckles + Night Stick + Shotgun + UZIS + rifle
		    case 25: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,105),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,40),GivePlayerWeapon(playerid,28,275),GivePlayerWeapon(playerid,33,70); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 26: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,112),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,48),GivePlayerWeapon(playerid,28,300),GivePlayerWeapon(playerid,33,80); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 27: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,119),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,56),GivePlayerWeapon(playerid,28,375),GivePlayerWeapon(playerid,33,90); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 28: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,126),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,64),GivePlayerWeapon(playerid,28,400),GivePlayerWeapon(playerid,33,100); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 29: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,133),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,72),GivePlayerWeapon(playerid,28,425),GivePlayerWeapon(playerid,33,110); //Deagle +Knuckles + Katana + Sawn-off Shotgun + UZIS + rifle
		    case 30: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,140),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,80),GivePlayerWeapon(playerid,32,250),GivePlayerWeapon(playerid,30,90),GivePlayerWeapon(playerid,33,120); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 31: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,147),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,88),GivePlayerWeapon(playerid,32,275),GivePlayerWeapon(playerid,30,120),GivePlayerWeapon(playerid,33,130); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 32: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,154),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,96),GivePlayerWeapon(playerid,32,300),GivePlayerWeapon(playerid,30,150),GivePlayerWeapon(playerid,33,140); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 33: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,161),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,104),GivePlayerWeapon(playerid,32,325),GivePlayerWeapon(playerid,30,180),GivePlayerWeapon(playerid,33,150); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 34: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,168),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,112),GivePlayerWeapon(playerid,32,350),GivePlayerWeapon(playerid,30,210),GivePlayerWeapon(playerid,33,160); //Deagle +Knuckles + ChainSaw + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 35: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,175),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,42),GivePlayerWeapon(playerid,32,375),GivePlayerWeapon(playerid,30,240),GivePlayerWeapon(playerid,33,170); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 36: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,182),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,49),GivePlayerWeapon(playerid,32,400),GivePlayerWeapon(playerid,30,270),GivePlayerWeapon(playerid,33,180); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 37: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,189),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,56),GivePlayerWeapon(playerid,32,425),GivePlayerWeapon(playerid,30,300),GivePlayerWeapon(playerid,33,190); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 38: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,196),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,63),GivePlayerWeapon(playerid,32,450),GivePlayerWeapon(playerid,30,330),GivePlayerWeapon(playerid,33,200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 39: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,203),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,70),GivePlayerWeapon(playerid,32,475),GivePlayerWeapon(playerid,30,360),GivePlayerWeapon(playerid,33,210); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 40: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,210),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,77),GivePlayerWeapon(playerid,32,500),GivePlayerWeapon(playerid,31,125),GivePlayerWeapon(playerid,33,220); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 41: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,217),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,84),GivePlayerWeapon(playerid,32,525),GivePlayerWeapon(playerid,31,150),GivePlayerWeapon(playerid,33,230); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 42: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,224),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,91),GivePlayerWeapon(playerid,32,550),GivePlayerWeapon(playerid,31,175),GivePlayerWeapon(playerid,33,240); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 43: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,231),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,98),GivePlayerWeapon(playerid,32,575),GivePlayerWeapon(playerid,31,200),GivePlayerWeapon(playerid,33,250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 44: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,238),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,105),GivePlayerWeapon(playerid,32,600),GivePlayerWeapon(playerid,31,225),GivePlayerWeapon(playerid,33,275); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 45: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,245),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,112),GivePlayerWeapon(playerid,29,90),GivePlayerWeapon(playerid,31,250),GivePlayerWeapon(playerid,34,25); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 46: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,252),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,119),GivePlayerWeapon(playerid,29,120),GivePlayerWeapon(playerid,31,275),GivePlayerWeapon(playerid,34,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 47: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,259),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,126),GivePlayerWeapon(playerid,29,150),GivePlayerWeapon(playerid,31,300),GivePlayerWeapon(playerid,34,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 48: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,266),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,133),GivePlayerWeapon(playerid,29,180),GivePlayerWeapon(playerid,31,325),GivePlayerWeapon(playerid,34,40); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 49: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,273),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,140),GivePlayerWeapon(playerid,29,210),GivePlayerWeapon(playerid,31,350),GivePlayerWeapon(playerid,34,45); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 50: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,280),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,175),GivePlayerWeapon(playerid,29,240),GivePlayerWeapon(playerid,31,375),GivePlayerWeapon(playerid,34,50); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 51..100: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,350),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,12500),GivePlayerWeapon(playerid,29,2100),GivePlayerWeapon(playerid,31,3000),GivePlayerWeapon(playerid,34,1250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle

		}
	}
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
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
	    if(GetPlayerVehicleSeat(i) != 0) continue;
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
            if(PInfo[i][Afk] == 1) continue;
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

stock GetClosestPlayerWithoutZombie(playerid,Float:limit)
{
    new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid,x1,y1,z1);
    new Float:Ranger = 999.9;
    new id = -1;
    foreach(new i: Player)
    {
        if(playerid != i)
        {
            if(PInfo[i][Afk] == 1) continue;
            if(Team[i] == ZOMBIE) continue;
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

stock PreloadAnimLib(playerid)
{
    ApplyAnimation(playerid,"BOMBER","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"RAPPING","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"SHOP","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"BEACH","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"SMOKING","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"FOOD","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"ON_LOOKERS","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"DEALER","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"CRACK","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"CARRY","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"COP_AMBIENT","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"PARK","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"INT_HOUSE","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"FOOD","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"CRIB","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"ROB_BANK","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"JST_BUISNESS","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"PED","null",0.0,0,0,0,0,0);
    ApplyAnimation(playerid,"OTB","null",0.0,0,0,0,0,0);
    SetPVarInt(playerid, "Animations", 1);
}

stock DealDamage(playerid,Float:damage)
{
	new Float:health,Float:armour;
	GetPlayerHealth(playerid,health);
	GetPlayerArmour(playerid,armour);
	if(armour == 0) SetPlayerHealth(playerid,health - damage);
	if(armour >= damage) SetPlayerArmour(playerid,armour - damage);
	if(armour < damage)
	{
	    SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid,health - (damage - armour));
	}
	return 1;
}

stock CheckDealDamage(playerid,Float:damage)
{
	new Float:health,Float:armour,Float:CheckHP;
	GetPlayerHealth(playerid,health);
	GetPlayerArmour(playerid,armour);
	if(armour == 0) CheckHP = health - damage;
	if(armour >= damage) return 100;
	if(armour < damage) CheckHP = health - (damage - armour);
	return floatround(CheckHP,floatround_round);
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
