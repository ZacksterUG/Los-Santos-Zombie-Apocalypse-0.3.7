//======================= Inventory system copied =============================
#include <a_samp>
#define FIXES_ServerVarMsg 0
#include <fixes>
#include <sscanf2>
#include <a_npc>
#include <a_objects>
#include <streamer>
#include <GetVehicleName>
#include <SII>
#include <zcmd>
#include <mxini>
#include <j_inventory_v2>
#include <MAP>
#include <gbug>
#include <colandreas>
#include <mapandreas>
#include <FCNPC>
#include <modelsizes>
#include <nex-ac>
#include <physics>
#include <projectile>

#define Userfile 														"Admin/Users/%s.ini"
#define snowing                                                         true
#define Version                                                         "2.0"
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     50
#define CPTIME                                                          140000//100000Time between each checkpoint 90000
#define CPVALUE                                                         190//175CPValue, the value of, when it gets reached, it the cp gets cleared. 175
#define DIGTIME                                                         120000//Time of cooldown between digging.
#define VOMITTIME                                                       90000//(90000)Time of cooldown between vomitting.
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
forward AnticheatSH();
forward OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
forward pingchecktimer(playerid);
//forward OnVehicleDamageStatusUpdate(vehicleid, playerid);
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
/////////////////////////////////////////////////////////////////////////////////////////////////////
#define GRENADE_SPEED \
	40.0

#define GRENADE_OBJECT \
    342

#define MAX_PLAYER_GRENADES \
	1
////////////////////////////////////////////////////////////////////////////////////////////////////////
#define MAX_GRENADES \
	(MAX_PLAYERS * MAX_PLAYER_GRENADES)
///////////////////////////////////////////////////////////////////////////////////////////////////////
//============================== [Server config] ===============================
forward PHY_OnObjectUpdate(objectid);
forward PHY_OnObjectCollideWithObject(object1, object2); // low bound = 0, high bound = 1
forward PHY_OnObjectCollideWithSAWorld(objectid, Float:cx, Float:cy, Float:cz); // Only with ColAndreas
forward PHY_OnObjectCollideWithWall(objectid, wallid);
forward PHY_OnObjectCollideWithCylinder(objectid, cylinderid);
forward PHY_OnObjectCollideWithPlayer(objectid, playerid);
forward OnCheatDetected(playerid, ip_address[], type, code);
forward OnPlayerWeaponsHack(playerid, weaponid, ammo, type);
//============================== [Text Draw's] =================================
forward SaveDeathZombieLastPos(playerid);
forward UnFreezePlayer(playerid);
new Text:GainXPTD[MAX_PLAYERS];
new Text:RANKUP[MAX_PLAYERS];
new Text:Stats[MAX_PLAYERS];
new Text:FuelTD[MAX_PLAYERS];
new Text:OilTD[MAX_PLAYERS];
new Text:OILANDFUELTD[MAX_PLAYERS];
new Text:XPBox;
new Text:XPStats[MAX_PLAYERS];
new Text:Infection;
new Text:CPSCleared;
new Text:CPvaluepercent[MAX_PLAYERS];
new Text:XPLEFT[MAX_PLAYERS];
new Text:XPRIGHT[MAX_PLAYERS];
new Text:Dark[MAX_PLAYERS];
new Text:SkinChange[MAX_PLAYERS];
new Text:ZOMSURV[MAX_PLAYERS];
new Text:ArrLeft[MAX_PLAYERS];
new Text:ArrRight[MAX_PLAYERS];
new Text:Effect[9];
new PlayerText:XPtextdraw[MAX_PLAYERS][5];
new Text:BiteOrInv[MAX_PLAYERS];
new Text:BiteOrInvBOX[MAX_PLAYERS];
new Text:RelocateOrCP[MAX_PLAYERS];
new Text:RelocateOrCPBOX[MAX_PLAYERS];
new Text:PerksTIP[MAX_PLAYERS];
new Text:PerksTIPBOX[MAX_PLAYERS];
new LoginTimer[MAX_PLAYERS];
new Text:RageTD[MAX_PLAYERS];
new Text:CPbar[MAX_PLAYERS];
new Text:CPvaluebar[MAX_PLAYERS];
new Text:CPbartext[MAX_PLAYERS];
new bool:TimeOfDeath[MAX_PLAYERS];
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
new BaitThrowTimer4[MAX_PLAYERS];
new BaitThrowTimer3[MAX_PLAYERS];
new BaitThrowTimer2[MAX_PLAYERS];
new BaitThrowTimer1[MAX_PLAYERS];
new FlashLightTimer[MAX_PLAYERS];
new RageModeTimer[MAX_PLAYERS];
new FirstStepMolotov[MAX_PLAYERS];
new SecondStepMolotov[MAX_PLAYERS];
new ThirdStepMolotov[MAX_PLAYERS];
new GateZombie1;
new GateZombie2;
new CanItRandom;
new IsMessageSent[MAX_PLAYERS];
new WaitAirCheat[MAX_PLAYERS];
bool: UseCar(carid);
new GrenadesObject[MAX_PLAYERS][MAX_GRENADES];
new grenadesCount[MAX_PLAYERS];
//bool: StopCar(carid);
main(){}
native WP_Hash(buffer[], len, const str[]);

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

new Float:LootOutSide[32][3] =
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
	{815.5817,-1107.6548,25.7901}
};

new Vehicles[MAX_PLAYERS][4];

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

new RandWeather[] = {7,9,19,20,22,276,367,55};
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
new PickUpSurvivor;
new PickUpZombie;
new PickUpToUp;


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
	Premium,
    Poisoned,
    SeismicTimerPhase2,
    Text3D:LabelMeatForShare,
    SMeatBite,
    DeletedAcc,
    FlashBangThrowPhase,
    AllowToSpawn,
    Training,
    PoisonDizzy,
    BeaconMarker,
    FlashBangTimerPhase2,
    FlashBangTimerPhase3,
    FlashBangTimerPhase4,
    FlashBangTimerPhase5,
    FlashBangTimerPhase6,
    TrainingPhase,
    Waswarnedbh,
    ChooseAfterTr,
    KillWarning,
    FoundBullets,
    MaxGrenades,
    CanGrenadeAgain,
    AssaultGrenadeThrowed,
	Flashed,
    ACWarning,
    CanUseSeismicShock,
    FakePerk,
    CJRunWarning,
    SeismicPhase,
    MeatSObject,
    ToxinTimer,
	TipBiteTimer,
	TenHoursAch,
	FlashBangObject,
	ShareMeatVomited,
	Float:MeatSX,
	Float:MeatSY,
	Float:MeatSZ,
	ToxicBites,
	SpecID,
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
	CanVel,
	Stomped,
	CanBeStompedTimer,
	CanPunch,
	Baiting,
	UpdateStatsTimer,
	Infected,//Dizzy
	CurrentXP,
	SeatID,
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
	DetectingAir,
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
 	Float:Int,
	HideInVehicle,
 	Vomited,
 	XPToRankUp,
 	ExtraXP,
 	Text3D:Ranklabel,
 	MasterRadared,
 	Firsttimeincp,
 	CanBurst,
 	Float:HideHP,
 	TeamKilling,
 	ClearBurst,
 	WarnJail,
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
	ZCount,
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
	Flamerounds,
	Searching,
	MolotovMission,
	BettyMission,
	DigTimer,
	CanDig,
	GodDig,
	Lastbite,
	CanRun,
	NormalTP,
	InviteID,
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
	Spawned,
	GroupLeader,
	GroupPlayers,
	GroupWantJoin,
	SurvivorWantToJoin,
	FlashBangs,
	Grenades,
	MuteTimer,
	JailTimer,
	FlashLightTimerOn,
}

static Team[MAX_PLAYERS];
new PInfo[MAX_PLAYERS][PlayerInfo];
new CPValue;
new Jason[MAX_PLAYERS];
new CPID;
new CPscleared;
new PickUpsSearching[sizeof(Searchplaces)];
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
new SnowObj[MAX_PLAYERS][2];
new SnowCreated[MAX_PLAYERS];
new Snow = 0;
 //Global variable!
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
new NZGate;
new GroupID;
new objectsupply1;
new objectsupply2;
new InvadingTimer;
new SupplyHealth = 200;
new SupplyInvaded = 0;
new SupplyDestroyed = 0;
new Text3D:SupplyLabel;
new SupplyInvadeProgress = 0;
new CanSpawn = 0;
new NZGateOpened;
new gRandomSkin[] = {78,79,77,75,134,135,137,160,162,200,212,213,230,239};
new bRandomSkin[] = {1,2,3,4,5,6,7,8,9,10,279,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,76,80,81,82,83,84,85,86,87,88,89,90,93,94,95,96,97,98,100,101,128,129,130,131,132,133,136,138,139,140,141,142,143,144,145,146,147,
148,149,150,151,152,153,154,155,156,157,158,159,161,163,164,165,166,167,170,171,172,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,196,197,198,199,201,202,203,204,205,206,207,208,209,210,211,215,216,217,218,219,220,221,222,223,225,226,227,228,229,231,232,233,234,235,236,237,238,240,241,242,243,244,245,247,248,249,250,251,252,253,254,255,267,268,
289,290,291,293,295,296,297,298,299};

function SpawnAtFirst()
{
	CanSpawn = 1;
	return 1;
}

public OnGameModeInit()
{
	SendRconCommand("hostname [uG] Los Santos Zombie Apocalypse |Double XP|");
	SetGameModeText("LS Zombie Apoc. 0.05.3");
	SetTimer("Dizzy",45000,true);
	SetTimer("NewTips",1500,true);
	SetTimer("FixOnline",10000,true);
	SetTimer("RemoveOilOrFuel",25000,true);
	SetTimer("SpawnAtFirst",30000,false);
	SetTimer("AutoBalance",30000,true);
	SetTimer("UpdateVehicleDamage",15000,true);
	SetTimer("GivePlayerHealthInCP",250,true);
	EnableAntiCheat(39,0);
	EnableAntiCheat(49,0);
	LoadObj();
	CA_Init();
	print("Trying to include SGT_Soap");
	print("my gamemode");
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
    for(new j; j < sizeof(Searchplaces);j++)
    {
        PickUpsSearching[j] = CreatePickup(1318,23,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2],-1);
	}
    for(new j; j < sizeof(HiveMeatPos);j++)
    {
        MeatHive[j] = CreatePickup(1318,3,HiveMeatPos[j][0],HiveMeatPos[j][1],HiveMeatPos[j][2],-1);
    }
    for(new j; j < sizeof(HiveTeleports);j++)
    {
        TPHive[j] = CreatePickup(1559,2,HiveTeleports[j][0],HiveTeleports[j][1],HiveTeleports[j][2],-1);
    }
    for(new j; j < sizeof(LootOutSide);j++)
    {
        LootOutPlaces[j] = CreatePickup(2057,2,LootOutSide[j][0],LootOutSide[j][1],LootOutSide[j][2],-1);
    }
    PickUp1Training = CreatePickup(1239,1,96.6611,1920.4708,18.1450,-1);
    PickUp3rdTraining = CreatePickup(1239,14,144.3880,1915.6431,18.9205, -1);
    PickUp4thtraining = CreatePickup(1239,1,213.9137,1902.2101,17.6406,-1);
    PickUp6thTraining = CreatePickup(1239,1,224.6870,1872.3535,13.7344,-1);
    PickUpToUp = CreatePickup(19134,1,967.8533,2123.8877,488.8970,-1);
    PickUp8thTraining = CreatePickup(1239,1,932.1880,2130.6299,500.1382,-1);
    PickUp12thTraining = CreatePickup(1239,1,294.7120,2505.1260,16.4844,-1);
    PickUp13thTraining = CreatePickup(1239,3,317.3385,2504.4272,16.4844,-1);
    PickUp14thTraining = CreatePickup(1239,1,360.6137,2503.6260,16.4844,-1);
    PickUpLastTraining = CreatePickup(1239,3,405.1820,2473.9714,16.5062,-1);
    PickUpSurvivor = CreatePickup(1314,3,424.6116,2474.3247,16.5000,-1);
    PickUpZombie = CreatePickup(1313,3,387.8176,2469.0764,16.5436,-1);
	SetTimer("UpdateStats",2000,true);
	SetTimer("UpdateBait",625,true);
  	SetWeather(5123524);
    SetWorldTime(23);
	INI_Open("Admin/Config/ServerConfig.ini");
	CanItRandom = INI_ReadInt("Random");
	VoteEnable = INI_ReadInt("VoteEnable");
	AnticheatEnabled = INI_ReadInt("AnticheatEnable");
	developmode = INI_ReadInt("DevelopingMode");
	CanItSupply = INI_ReadInt("EnableSupply");
	ExtraXPEvent = INI_ReadInt("ExtraXP");
	INI_Close();
	//SetTimer("Marker",20000,true);
	SetTimer("WeatherUpdate",53213561328321132132236535631265312658863528213,false);
	SetTimer("RandomCheckpoint",CPTIME,false);
	SetTimer("RandomSounds",120000,true);
	SetTimer("FiveSeconds",5000,true);
	SetTimer("Tip",180000,true);
	SetTimer("CheckHealth",1000,1);
	//WeatherUpdate();
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
	FCNPC_InitMapAndreas(MapAndreas_GetAddress());
	sgtSoap = FCNPC_Create("SGT_Soap");
	FCNPC_Spawn(sgtSoap,287,3000,-3000,100);
	Hunter = CreateVehicle(425,3000,-3000,100,-1,-1,-1,0);
	FCNPC_PutInVehicle(sgtSoap,Hunter,0);
	FCNPC_StartPlayingPlayback(sgtSoap,"mynpc");
	SetPlayerColor(sgtSoap,green);
	CreateVehicle(470,1182.2000000,-1725.3000000,13.3000000,130.0000000,95,10,-1); //Patriot
	CreateVehicle(562,1164.1000000,-1647.0000000,13.8000000,0.0000000,40,40,-1); //Elegy
	CreateVehicle(424,425.6992200,-1815.0996100,6.5000000,183.9990000,15,30,-1); //BF Injection
	CreateVehicle(477,296.1709900,-1515.8239700,24.4440000,54.5000000,101,1,-1); //ZR-350
	CreateVehicle(559,1744.7030000,-1371.6379400,27.0200000,270.0000000,36,8,-1); //Jester
	CreateVehicle(545,1273.9429900,-2014.5860600,58.9710000,0.0000000,39,1,-1); //Hustler
	CreateVehicle(470,1245.0140400,-2015.8599900,59.7510000,175.9950000,43,255,-1); //Patriot
	CreateVehicle(599,1263.2939500,-2015.9404300,59.7110000,182.0000000,2,1,-1); //Police Ranger
	CreateVehicle(439,1265.4300500,-1674.7910200,13.5470000,0.0000000,43,21,-1); //Stallion
	CreateVehicle(491,1230.9200400,-2483.6379400,12.0320000,0.0000000,40,65,-1); //Virgo
	CreateVehicle(555,1561.7810100,-2284.0449200,-3.1870000,38.0000000,60,1,-1); //Windsor
	CreateVehicle(438,1719.0479700,-2248.8081100,13.3720000,272.0000000,6,76,-1); //Cabbie
	CreateVehicle(404,2223.9819300,-2408.6950700,13.3770000,222.0000000,113,39,-1); //Perrenial
	CreateVehicle(596,1187.5970500,-1817.2170400,13.3900000,140.0000000,116,1,-1); //Police Car (LSPD)
	CreateVehicle(596,1599.9530000,-1704.3590100,5.7110000,90.5000000,116,1,-1); //Police Car (LSPD)
	CreateVehicle(596,1583.5720200,-1718.9950000,6.0390000,230.0020000,116,1,-1); //Police Car (LSPD)
	CreateVehicle(596,1536.7568400,-1673.2949200,13.2030000,0.0000000,116,1,-1); //Police Car (LSPD)
	CreateVehicle(561,979.2340100,-1299.9790000,13.3070000,218.0000000,1,1,-1); //Stratum
	CreateVehicle(470,932.4660000,-1228.3349600,17.0140000,290.0000000,43,255,-1); //Patriot
	CreateVehicle(470,789.7349900,-1380.6689500,13.7710000,179.9950000,43,255,-1); //Patriot
	CreateVehicle(470,931.2441400,-1212.8212900,17.0140000,239.9910000,43,255,-1); //Patriot
	CreateVehicle(470,268.0509900,-1812.3220200,4.4430000,297.9950000,43,255,-1); //Patriot
	CreateVehicle(470,767.4277300,-1387.2324200,13.7600000,89.9950000,43,255,-1); //Patriot
	CreateVehicle(470,269.0679900,-1793.3220200,4.4550000,263.9930000,43,255,-1); //Patriot
	CreateVehicle(400,1835.2180200,-1604.1070600,13.6830000,89.2500000,101,1,-1); //Landstalker
	CreateVehicle(550,1897.3330100,-1431.1009500,11.0320000,29.5000000,15,15,-1); //Sunrise
	CreateVehicle(527,2070.5459000,-1587.3499800,13.2740000,0.0000000,109,1,-1); //Cadrona
	CreateVehicle(492,2509.0148900,-1671.9749800,13.2870000,356.2500000,95,14,-1); //Greenwood
	CreateVehicle(551,2492.4838900,-1951.7910200,13.3200000,0.0000000,91,1,-1); //Merit
	CreateVehicle(426,2742.1999500,-2395.8610800,13.4530000,0.0000000,42,42,-1); //Premier
	CreateVehicle(475,1125.5510300,-1385.7170400,14.1810000,0.0000000,37,255,-1); //Sabre
	CreateVehicle(470,1170.1009500,-1488.7110600,14.8210000,86.0000000,43,255,-1); //Patriot
	CreateVehicle(479,299.0809900,-1431.8979500,23.6290000,296.0000000,45,32,-1); //Regina
	CreateVehicle(442,205.9160000,-1560.5720200,29.0360000,1.7310000,40,36,-1); //Romero
	CreateVehicle(470,306.1210000,-2018.8669400,7.9650000,0.0000000,43,255,-1); //Patriot
	CreateVehicle(482,706.0410200,-1674.9809600,3.6880000,0.0000000,85,85,-1); //Burrito
	CreateVehicle(555,873.4689900,-1668.1789600,13.3270000,0.0000000,36,1,-1); //Windsor
	CreateVehicle(491,907.6890300,-1548.6309800,13.4480000,0.0000000,64,72,-1); //Virgo
	CreateVehicle(549,2174.2080100,-999.2769800,62.8310000,0.0000000,79,39,-1); //Tampa
	CreateVehicle(405,2338.3630400,-1194.7619600,27.9770000,66.0000000,36,1,-1); //Sentinel
	CreateVehicle(546,2410.2180200,-1377.1200000,24.3130000,308.0000000,7,78,-1); //Intruder
	CreateVehicle(576,2039.1400100,-1717.4919400,13.2970000,0.0000000,74,8,-1); //Tornado
	CreateVehicle(500,1253.1280500,-2016.4570300,59.8360000,0.0000000,13,119,-1); //Mesa
	CreateVehicle(579,1279.1070600,-1802.3399700,13.4830000,264.0000000,62,62,-1); //Huntley
	CreateVehicle(429,1524.7779500,-1462.5179400,9.2500000,0.0000000,1,3,-1); //Banshee
	CreateVehicle(490,1150.7099600,-1239.6820100,15.8520000,0.0000000,255,255,-1); //FBI Rancher
	CreateVehicle(470,1765.8399700,-1940.5450400,13.6780000,320.0000000,43,255,-1); //Patriot
	CreateVehicle(433,1685.7569600,-430.7550000,33.8390000,192.2500000,43,255,-1); //Barracks
	CreateVehicle(470,1706.2840600,-515.0440100,34.5080000,218.0000000,43,255,-1); //Patriot
	CreateVehicle(470,1720.5340600,-516.0490100,34.5270000,165.9960000,43,255,-1); //Patriot
	CreateVehicle(543,1939.2440200,-1090.3129900,24.9500000,267.2480000,43,8,-1); //Sadler
	CreateVehicle(470,1659.3179900,-1047.3840300,24.0080000,0.0000000,43,255,-1); //Patriot
	CreateVehicle(478,1463.1700400,-1018.8880000,24.9920000,87.6250000,45,1,-1); //Walton
	CreateVehicle(470,1141.6569800,-865.4879800,43.3380000,0.0000000,43,255,-1); //Patriot
	CreateVehicle(470,1419.4759500,-1886.6860400,13.7330000,0.0000000,43,255,-1); //Patriot
	CreateVehicle(495,2767.0129400,-1845.6080300,10.3190000,324.2500000,116,115,-1); //Sandking
	CreateVehicle(504,2856.3300800,-2043.5899700,10.8780000,0.0000000,45,29,-1); //Bloodring Banger
	CreateVehicle(589,2650.8669400,-2224.8811000,13.2640000,0.0000000,37,37,-1); //Club
	CreateVehicle(470,2785.5529800,-2418.4919400,13.7440000,92.0000000,43,255,-1); //Patriot
	CreateVehicle(470,2783.8491200,-2455.7561000,13.7450000,274.0000000,43,255,-1); //Patriot
	CreateVehicle(518,2415.5490700,-2458.3300800,13.4250000,260.0000000,21,1,-1); //Buccaneer
	CreateVehicle(542,2194.8449700,-2381.1411100,13.2250000,0.0000000,45,92,-1); //Clover
	CreateVehicle(560,494.0010100,-1545.4639900,17.9600000,30.0000000,6,43,-1); //Sultan
	CreateVehicle(518,543.5430300,-1288.6020500,17.0370000,0.0000000,41,29,-1); //Buccaneer
	CreateVehicle(457,752.9149800,-1264.5880100,13.2910000,0.0000000,18,1,-1); //Caddy
	CreateVehicle(489,869.4849900,-1448.4489700,13.9590000,298.0000000,112,120,-1); //Rancher
	CreateVehicle(406,2580.8969700,-2171.8149400,1.3580000,180.0000000,1,1,-1); //Dumper
	CreateVehicle(427,2566.5959500,-2158.6799300,0.0000000,154.0000000,255,1,-1); //Enforcer
	CreateVehicle(478,2586.2399900,-2130.7758800,0.2060000,126.0000000,72,1,-1); //Walton
	CreateVehicle(599,1638.3840300,-1866.2600100,25.7400000,203.9890000,2,1,-1); //Police Ranger
	CreateVehicle(451,286.5889900,-1168.2750200,80.6740000,314.0000000,126,14,-1); //Turismo
	CreateVehicle(415,289.1730000,-1171.9379900,80.7590000,308.0000000,6,1,-1); //Cheetah
	CreateVehicle(451,291.5910000,-1174.7230200,80.6740000,312.7450000,126,61,-1); //Turismo
	CreateVehicle(415,294.0040000,-1177.6040000,80.7590000,307.9960000,6,1,-1); //Cheetah
	CreateVehicle(434,296.4939900,-1180.5340600,81.0630000,312.0000000,6,6,-1); //Hotknife
	CreateVehicle(434,307.3250100,-1163.0129400,81.0750000,131.9950000,6,6,-1); //Hotknife
	CreateVehicle(444,330.8510100,-1157.7180200,80.9100000,132.0000000,32,53,-1); //Monster
	CreateVehicle(494,332.5270100,-1170.5749500,80.8840000,42.0000000,125,112,-1); //Hotring
	CreateVehicle(494,328.0790100,-1174.7230200,80.8840000,41.9950000,125,112,-1); //Hotring
	CreateVehicle(586,293.6260100,-1157.1169400,80.5070000,126.0000000,126,2,-1); //Wayfarer
	CreateVehicle(409,300.7909900,-1183.8859900,80.8390000,0.0000000,255,255,-1); //Stretch
	CreateVehicle(409,284.2410000,-1164.2879600,80.8390000,274.0000000,1,1,-1); //Stretch
	CreateVehicle(409,266.1069900,-1212.5000000,75.1370000,123.7500000,255,255,-1); //Stretch
	CreateVehicle(409,242.4520000,-1229.5100100,75.2920000,309.9990000,1,1,-1); //Stretch
	CreateVehicle(434,258.6659900,-1216.0360100,75.4620000,121.9950000,6,6,-1); //Hotknife
	CreateVehicle(434,246.3360000,-1224.7020300,75.4620000,306.4920000,6,6,-1); //Hotknife
	CreateVehicle(429,265.1120000,-1224.2889400,74.4690000,22.0000000,81,8,-1); //Banshee
	CreateVehicle(539,194.8650100,-1234.3409400,78.6970000,46.0000000,96,67,-1); //Vortex
	CreateVehicle(571,321.9070100,-1145.9859600,80.9260000,222.0000000,3,3,-1); //Kart
	CreateVehicle(571,264.8309900,-1197.2230200,74.6510000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,268.7959900,-1202.7039800,74.6510000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,266.1130100,-1204.4410400,74.6630000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,262.3320000,-1198.9069800,74.6390000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,328.3920000,-1147.2309600,80.9260000,221.9950000,3,53,-1); //Kart
	CreateVehicle(603,2800.4628900,-1087.8819600,30.7210000,0.0000000,108,6,-1); //Phoenix
	CreateVehicle(575,2865.1259800,-1376.4220000,10.8320000,0.0000000,19,96,-1); //Broadway
	CreateVehicle(445,2820.2251000,-1562.6619900,10.9170000,270.0000000,47,47,-1); //Admiral
	CreateVehicle(482,2797.8879400,-1553.1379400,11.1720000,268.2500000,52,52,-1); //Burrito
	CreateVehicle(483,2008.1879900,-1275.9019800,23.9160000,0.0000000,1,31,-1); //Camper
	CreateVehicle(589,1549.3740200,-2210.5869100,13.2720000,0.0000000,23,23,-1); //Club

	LimitPlayerMarkerRadius(15000.0);
	CPID = -1;
	CPscleared = 0;
	RoundEnded = 0;
	NZGateOpened = 0;
	SetTimer("Anticheat",2000,1);
	new RandW = random(sizeof(RandWeather));
    SetWeather(RandWeather[RandW]);
    RWeather = RandWeather[RandW];
	EnableStuntBonusForAll(0);
	GroupID = 0;
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
	if(fexist("Admin/ExitInWarned.txt"))
	{
	    new File:file = fopen("Admin/ExitInWarned.txt",io_write);
	    fclose(file);
	}
	if(fexist("Goddigged.txt"))
	{
	    fremove("Admin/Goddigged.txt");
	    new File:file = fopen("Admin/Goddigged.txt",io_write);
	    fclose(file);
	}
	else
	{
        new File:file = fopen("Admin/Goddigged.txt",io_write);
	    fclose(file);
	}

	if(developmode == 1)
	{
	    SendRconCommand("hostname ** Server is on maintenance! **");
	}

	for(new i; i < MAX_PLAYERS;i++)
	{
		XPBox[i] = TextDrawCreate(457.822265, 425.158630, "usebox");
		TextDrawLetterSize(XPBox[i], 0.000000, 1.798391);
		TextDrawTextSize(XPBox[i], 152.888854, 0.000000);
		TextDrawAlignment(XPBox[i], 1);
		TextDrawColor(XPBox[i], 0);
		TextDrawUseBox(XPBox[i], true);
		TextDrawBoxColor(XPBox[i], 102);
		TextDrawSetShadow(XPBox[i], 0);
		TextDrawSetOutline(XPBox[i], 0);
		TextDrawFont(XPBox[i], 0);

		XPRIGHT[i] = TextDrawCreate(305.355804, 424.099853, "LD_SPAC:white");
		TextDrawLetterSize(XPRIGHT[i], 0.000000, 0.000000);
		TextDrawTextSize(XPRIGHT[i], 0.0000000, 18.019538);
		TextDrawAlignment(XPRIGHT[i], 1);
		TextDrawColor(XPRIGHT[i], 16777215);
		TextDrawSetShadow(XPRIGHT[i], 0);
		TextDrawSetOutline(XPRIGHT[i], 0);
		TextDrawFont(XPRIGHT[i], 4);

		XPLEFT[i] = TextDrawCreate(305.355804, 424.099853, "LD_SPAC:white");
		TextDrawLetterSize(XPLEFT[i], 0.000000, 0.000000);
		TextDrawTextSize(XPLEFT[i], 0.0000000, 18.019538);
		TextDrawAlignment(XPLEFT[i], 1);
		TextDrawColor(XPLEFT[i], 16777215);
		TextDrawSetShadow(XPLEFT[i], 0);
		TextDrawSetOutline(XPLEFT[i], 0);
		TextDrawFont(XPLEFT[i], 4);

		BiteOrInv[i] = TextDrawCreate(1.688873, 297.671051, "Click RMB near humans to bite");
		TextDrawLetterSize(BiteOrInv[i], 0.245110, 1.435731);
		TextDrawAlignment(BiteOrInv[i], 1);
		TextDrawColor(BiteOrInv[i], -1);
		TextDrawSetShadow(BiteOrInv[i], 0);
		TextDrawSetOutline(BiteOrInv[i], 1);
		TextDrawBackgroundColor(BiteOrInv[i], 51);
		TextDrawFont(BiteOrInv[i], 1);
		TextDrawSetProportional(BiteOrInv[i], 1);

		CPvaluepercent[i] = TextDrawCreate(326.875000, 411.833251, "100%");
		TextDrawLetterSize(CPvaluepercent[i], 0.266249, 1.150833);
		TextDrawAlignment(CPvaluepercent[i], 1);
		TextDrawColor(CPvaluepercent[i], -1);
		TextDrawSetShadow(CPvaluepercent[i], 0);
		TextDrawSetOutline(CPvaluepercent[i], 1);
		TextDrawBackgroundColor(CPvaluepercent[i], 51);
		TextDrawFont(CPvaluepercent[i], 2);
		TextDrawSetProportional(CPvaluepercent[i], 1);

		CPbar[i] = TextDrawCreate(229.375000, 413.874847, "LD_SPAC:white");
		TextDrawLetterSize(CPbar[i], 0.000000, 0.000000);
		TextDrawTextSize(CPbar[i], 226.750000, 8.341631);
		TextDrawAlignment(CPbar[i], 1);
		TextDrawColor(CPbar[i], 255);
		TextDrawSetShadow(CPbar[i], 0);
		TextDrawSetOutline(CPbar[i], 0);
		TextDrawFont(CPbar[i], 4);

		CPvaluebar[i] = TextDrawCreate(229.375000, 413.874847, "LD_SPAC:white");
		TextDrawLetterSize(CPvaluebar[i], 0.000000, 0.000000);
		TextDrawTextSize(CPvaluebar[i], 1.000000, 8.341631);
		TextDrawAlignment(CPvaluebar[i], 1);
		TextDrawColor(CPvaluebar[i], -1523963137);
		TextDrawSetShadow(CPvaluebar[i], 0);
		TextDrawSetOutline(CPvaluebar[i], 0);
		TextDrawFont(CPvaluebar[i], 4);

		CPbartext[i] = TextDrawCreate(156.875000, 412.416656, "CP Progress:");
		TextDrawLetterSize(CPbartext[i], 0.345624, 1.075000);
		TextDrawAlignment(CPbartext[i], 1);
		TextDrawColor(CPbartext[i], -1);
		TextDrawSetShadow(CPbartext[i], 0);
		TextDrawSetOutline(CPbartext[i], 1);
		TextDrawBackgroundColor(CPbartext[i], 51);
		TextDrawFont(CPbartext[i], 1);
		TextDrawSetProportional(CPbartext[i], 1);

		BiteOrInvBOX[i] = TextDrawCreate(130.311019, 296.533111, "usebox");
		TextDrawLetterSize(BiteOrInvBOX[i], 0.000000, 1.867033);
		TextDrawTextSize(BiteOrInvBOX[i], -2.133334, 0.000000);
		TextDrawAlignment(BiteOrInvBOX[i], 1);
		TextDrawColor(BiteOrInvBOX[i], 0);
		TextDrawUseBox(BiteOrInvBOX[i], true);
		TextDrawBoxColor(BiteOrInvBOX[i], 102);
		TextDrawSetShadow(BiteOrInvBOX[i], 0);
		TextDrawSetOutline(BiteOrInvBOX[i], 0);
		TextDrawFont(BiteOrInvBOX[i], 0);

		RelocateOrCP[i] = TextDrawCreate(2.133335, 274.972564, "Find letter  on radar to relocate");
		TextDrawLetterSize(RelocateOrCP[i], 0.219333, 1.361066);
		TextDrawAlignment(RelocateOrCP[i], 1);
		TextDrawColor(RelocateOrCP[i], -1);
		TextDrawSetShadow(RelocateOrCP[i], 0);
		TextDrawSetOutline(RelocateOrCP[i], 1);
		TextDrawBackgroundColor(RelocateOrCP[i], 51);
		TextDrawFont(RelocateOrCP[i], 1);
		TextDrawSetProportional(RelocateOrCP[i], 1);

		RelocateOrCPBOX[i] = TextDrawCreate(146.088867, 295.139190, "usebox");
		TextDrawLetterSize(RelocateOrCPBOX[i], 0.000000, -2.727036);
		TextDrawTextSize(RelocateOrCPBOX[i], -2.227776, 0.000000);
		TextDrawAlignment(RelocateOrCPBOX[i], 1);
		TextDrawColor(RelocateOrCPBOX[i], 0);
		TextDrawUseBox(RelocateOrCPBOX[i], true);
		TextDrawBoxColor(RelocateOrCPBOX[i], 102);
		TextDrawSetShadow(RelocateOrCPBOX[i], 0);
		TextDrawSetOutline(RelocateOrCPBOX[i], 0);
		TextDrawFont(RelocateOrCPBOX[i], 0);

		PerksTIP[i] = TextDrawCreate(1.244409, 320.419311, "Press Y to open your perks list");
		TextDrawLetterSize(PerksTIP[i], 0.305066, 1.215217);
		TextDrawAlignment(PerksTIP[i], 1);
		TextDrawColor(PerksTIP[i], -1);
		TextDrawSetShadow(PerksTIP[i], 0);
		TextDrawSetOutline(PerksTIP[i], 1);
		TextDrawBackgroundColor(PerksTIP[i], 51);
		TextDrawFont(PerksTIP[i], 1);
		TextDrawSetProportional(PerksTIP[i], 1);

		PerksTIPBOX[i] = TextDrawCreate(162.444396, 319.629913, "usebox");
		TextDrawLetterSize(PerksTIPBOX[i], 0.000000, 1.619134);
		TextDrawTextSize(PerksTIPBOX[i], -3.511113, 0.000000);
		TextDrawAlignment(PerksTIPBOX[i], 1);
		TextDrawColor(PerksTIPBOX[i], 0);
		TextDrawUseBox(PerksTIPBOX[i], true);
		TextDrawBoxColor(PerksTIPBOX[i], 102);
		TextDrawSetShadow(PerksTIPBOX[i], 0);
		TextDrawSetOutline(PerksTIPBOX[i], 0);
		TextDrawFont(PerksTIPBOX[i], 0);

		Dark[i] = TextDrawCreate(641.555541, 1.500000, "usebox");
		TextDrawLetterSize(Dark[i], 0.000000, 49.405799);
		TextDrawTextSize(Dark[i], -2.000000, 0.000000);
		TextDrawAlignment(Dark[i], 1);
		TextDrawColor(Dark[i], 0);
		TextDrawUseBox(Dark[i], true);
		TextDrawBoxColor(Dark[i], 117);
		TextDrawSetShadow(Dark[i], 0);
		TextDrawSetOutline(Dark[i], 0);
		TextDrawFont(Dark[i], 0);

		SkinChange[i] = TextDrawCreate(91.288909, 198.216522, "LD_SPAC:white");
		TextDrawLetterSize(SkinChange[i], 0.000000, 0.000000);
		TextDrawTextSize(SkinChange[i], 137.600051, 14.385770);
		TextDrawAlignment(SkinChange[i], 1);
		TextDrawColor(SkinChange[i], 255);
		TextDrawSetShadow(SkinChange[i], 0);
		TextDrawSetOutline(SkinChange[i], 0);
		TextDrawBackgroundColor(SkinChange[i], 0x00000050);
		TextDrawFont(SkinChange[i], 4);
		TextDrawSetPreviewModel(SkinChange[i], 0);
		TextDrawSetPreviewRot(SkinChange[i], 0.000000, 0.000000, 0.000000, 0.000000);

		ZOMSURV[i] = TextDrawCreate(106.622039, 200.262329, "ZOMBIE / SURVIVOR");
        TextDrawLetterSize(ZOMSURV[i], 0.283999, 1.069369);
		TextDrawAlignment(ZOMSURV[i], 1);
		TextDrawColor(ZOMSURV[i], -1);
		TextDrawSetShadow(ZOMSURV[i], 0);
		TextDrawSetOutline(ZOMSURV[i], 0);
		TextDrawBackgroundColor(ZOMSURV[i], 51);
		TextDrawFont(ZOMSURV[i], 2);
		TextDrawSetProportional(ZOMSURV[i], 1);

		ArrLeft[i] = TextDrawCreate(93.777786, 200.271118, "LD_BEAT:Left");
		TextDrawLetterSize(ArrLeft[i], 0.000000, 0.000000);
		TextDrawTextSize(ArrLeft[i], 12.444443, 9.955556);
		TextDrawAlignment(ArrLeft[i], 1);
		TextDrawColor(ArrLeft[i], -1);
		TextDrawSetShadow(ArrLeft[i], 0);
		TextDrawSetOutline(ArrLeft[i], 0);
		TextDrawFont(ArrLeft[i], 4);

		ArrRight[i] = TextDrawCreate(213.222259, 200.271118, "LD_BEAT:Right");
		TextDrawLetterSize(ArrRight[i], 0.000000, 0.000000);
		TextDrawTextSize(ArrRight[i], 12.444443, 9.955556);
		TextDrawAlignment(ArrRight[i], 1);
		TextDrawColor(ArrRight[i], -1);
		TextDrawSetShadow(ArrRight[i], 0);
		TextDrawSetOutline(ArrRight[i], 0);
		TextDrawFont(ArrRight[i], 4);

		RANKUP[i] = TextDrawCreate(280.888824, 104.035560, "RANK UP!");
		TextDrawLetterSize(RANKUP[i], 0.647780, 0.295812);
		TextDrawAlignment(RANKUP[i], 1);
		TextDrawColor(RANKUP[i], -1);
		TextDrawSetShadow(RANKUP[i], 0);
		TextDrawSetOutline(RANKUP[i], 0);
		TextDrawBackgroundColor(RANKUP[i], 51);
		TextDrawFont(RANKUP[i], 1);
		TextDrawSetProportional(RANKUP[i], 1);

	    RageTD[i] = TextDrawCreate(498.400299, 118.371536, "RAGE: 100%");
		TextDrawLetterSize(RageTD[i], 0.257444, 1.342782);
		TextDrawAlignment(RageTD[i], 1);
		TextDrawColor(RageTD[i], -5963521);
		TextDrawSetShadow(RageTD[i], 0);
		TextDrawSetOutline(RageTD[i], 257);
		TextDrawBackgroundColor(RageTD[i], -2147483393);
		TextDrawFont(RageTD[i], 2);
		TextDrawSetProportional(RageTD[i], 1);

		GainXPTD[i] = TextDrawCreate(266.222320, 132.426788, "+10 XP");
		TextDrawLetterSize(GainXPTD[i], 0.862222, 0.614222);
		TextDrawAlignment(GainXPTD[i], 1);
		TextDrawColor(GainXPTD[i], -1);
		TextDrawSetShadow(GainXPTD[i], 0);
		TextDrawSetOutline(GainXPTD[i], 0);
		TextDrawBackgroundColor(GainXPTD[i], 255);
		TextDrawFont(GainXPTD[i], 1);
		TextDrawSetProportional(GainXPTD[i], 1);

        Stats[i] = TextDrawCreate(488.667083, 329.561523, "usebox");
		TextDrawTextSize(Stats[i], 630.022430, 1000.000000);
		TextDrawAlignment(Stats[i], 1);
		TextDrawColor(Stats[i], -1);
		TextDrawUseBox(Stats[i], true);
		TextDrawBoxColor(Stats[i], 169);
		TextDrawLetterSize(Stats[i], 0.2956600, 1.219123);
		TextDrawSetShadow(Stats[i], 1);
		TextDrawSetOutline(Stats[i], 1);
		TextDrawBackgroundColor(Stats[i], 51);
		TextDrawFont(Stats[i], 2);
		TextDrawSetProportional(Stats[i], 1);

		FuelTD[i] = TextDrawCreate(213.755554, 380.953887, "Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
		TextDrawLetterSize(FuelTD[i], 0.442887, 1.276443);
		TextDrawAlignment(FuelTD[i], 1);
		TextDrawColor(FuelTD[i], -1);
		TextDrawSetShadow(FuelTD[i], 0);
		TextDrawSetOutline(FuelTD[i], 0);
		TextDrawBackgroundColor(FuelTD[i], 51);
		TextDrawFont(FuelTD[i], 1);
		TextDrawSetProportional(FuelTD[i], 1);

		OILANDFUELTD[i] = TextDrawCreate(204.577819, 377.813323, "LD_SPAC:white");
		TextDrawLetterSize(OILANDFUELTD[i], 0.000000, 0.000000);
		TextDrawTextSize(OILANDFUELTD[i], 182.755477, 19.263984);
		TextDrawAlignment(OILANDFUELTD[i], 1);
		TextDrawColor(OILANDFUELTD[i], 255);
		TextDrawSetShadow(OILANDFUELTD[i], 0);
		TextDrawSetOutline(OILANDFUELTD[i], 0);
		TextDrawFont(OILANDFUELTD[i], 4);

		OilTD[i] = TextDrawCreate(306.377410, 380.953887, "Oil: ~r~ll~y~llllll~g~~h~ll");
		TextDrawLetterSize(OilTD[i], 0.442887, 1.276443);
		TextDrawAlignment(OilTD[i], 1);
		TextDrawColor(OilTD[i], -1);
		TextDrawSetShadow(OilTD[i], 0);
		TextDrawSetOutline(OilTD[i], 1);
		TextDrawBackgroundColor(OilTD[i], 51);
		TextDrawFont(OilTD[i], 1);
		TextDrawSetProportional(OilTD[i], 1);

		XPStats[i] = TextDrawCreate(259.911041, 427.142944, "XP:_15052 / 55000");
		TextDrawLetterSize(XPStats[i], 0.432932, 1.129102);
		TextDrawAlignment(XPStats[i], 1);
		TextDrawColor(XPStats[i], -1);
		TextDrawSetShadow(XPStats[i], 1);
		TextDrawSetOutline(XPStats[i], 0);
		TextDrawBackgroundColor(XPStats[i], 255);
		TextDrawFont(XPStats[i], 2);
		TextDrawSetProportional(XPStats[i], 1);

		CPSCleared[i] = TextDrawCreate(497.778076, 99.555580, "CheckPoints Cleared: 0/~r~~h~8");
		TextDrawLetterSize(CPSCleared[i], 0.225999, 1.127110);
		TextDrawAlignment(CPSCleared[i], 1);
		TextDrawColor(CPSCleared[i], -1);
		TextDrawSetShadow(CPSCleared[i], 0);
		TextDrawSetOutline(CPSCleared[i], 1);
		TextDrawBackgroundColor(CPSCleared[i], 255);
		TextDrawFont(CPSCleared[i], 2);
		TextDrawSetProportional(CPSCleared[i], 1);

		Infection[i] = TextDrawCreate(497.777496, 108.864097, "Infection: ~r~~h~0%");
		TextDrawLetterSize(Infection[i], 0.293733, 1.208247);
		TextDrawAlignment(Infection[i], 1);
		TextDrawColor(Infection[i], -1);
		TextDrawSetShadow(Infection[i], 0);
		TextDrawSetOutline(Infection[i], 1);
		TextDrawBackgroundColor(Infection[i], 255);
		TextDrawFont(Infection[i], 2);
		TextDrawSetProportional(Infection[i], 1);

		Effect[0][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[0][i],1);
		TextDrawBoxColor(Effect[0][i],0xffffffff);
		TextDrawTextSize(Effect[0][i],950.000000,0.000000);
		TextDrawAlignment(Effect[0][i],0);
		TextDrawBackgroundColor(Effect[0][i],0x000000ff);
		TextDrawFont(Effect[0][i],3);
		TextDrawLetterSize(Effect[0][i],1.000000,70.000000);
		TextDrawColor(Effect[0][i],0xffffffff);
		TextDrawSetOutline(Effect[0][i],1);
		TextDrawSetProportional(Effect[0][i],1);
		TextDrawSetShadow(Effect[0][i],1);

		Effect[1][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[1][i],1);
		TextDrawBoxColor(Effect[1][i],0xffffffcc);
		TextDrawTextSize(Effect[1][i],950.000000,0.000000);
		TextDrawAlignment(Effect[1][i],0);
		TextDrawBackgroundColor(Effect[1][i],0x000000ff);
		TextDrawFont(Effect[1][i],3);
		TextDrawLetterSize(Effect[1][i],1.000000,70.000000);
		TextDrawColor(Effect[1][i],0xffffffff);
		TextDrawSetOutline(Effect[1][i],1);
		TextDrawSetProportional(Effect[1][i],1);
		TextDrawSetShadow(Effect[1][i],1);

		Effect[2][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[2][i],1);
		TextDrawBoxColor(Effect[2][i],0xffffff99);
		TextDrawTextSize(Effect[2][i],950.000000,0.000000);
		TextDrawAlignment(Effect[2][i],0);
		TextDrawBackgroundColor(Effect[2][i],0x000000ff);
		TextDrawFont(Effect[2][i],3);
		TextDrawLetterSize(Effect[2][i],1.000000,70.000000);
		TextDrawColor(Effect[2][i],0xffffffff);
		TextDrawSetOutline(Effect[2][i],1);
		TextDrawSetProportional(Effect[2][i],1);
		TextDrawSetShadow(Effect[2][i],1);

		Effect[3][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[3][i],1);
		TextDrawBoxColor(Effect[3][i],0xffffff66);
		TextDrawTextSize(Effect[3][i],950.000000,0.000000);
		TextDrawAlignment(Effect[3][i],0);
		TextDrawBackgroundColor(Effect[3][i],0x000000ff);
		TextDrawFont(Effect[3][i],3);
		TextDrawLetterSize(Effect[3][i],1.000000,70.000000);
		TextDrawColor(Effect[3][i],0xffffffff);
		TextDrawSetOutline(Effect[3][i],1);
		TextDrawSetProportional(Effect[3][i],1);
		TextDrawSetShadow(Effect[3][i],1);

		Effect[4][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[4][i],1);
		TextDrawBoxColor(Effect[4][i],0xffffff33);
		TextDrawTextSize(Effect[4][i],950.000000,0.000000);
		TextDrawAlignment(Effect[4][i],0);
		TextDrawBackgroundColor(Effect[4][i],0x000000ff);
		TextDrawFont(Effect[4][i],3);
		TextDrawLetterSize(Effect[4][i],1.000000,70.000000);
		TextDrawColor(Effect[4][i],0xffffffff);
		TextDrawSetOutline(Effect[4][i],1);
		TextDrawSetProportional(Effect[4][i],1);
		TextDrawSetShadow(Effect[4][i],1);

		Effect[5][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[5][i],1);
		TextDrawBoxColor(Effect[5][i],0xffffff22);
		TextDrawTextSize(Effect[5][i],950.000000,0.000000);
		TextDrawAlignment(Effect[5][i],0);
		TextDrawBackgroundColor(Effect[5][i],0x000000ff);
		TextDrawFont(Effect[5][i],3);
		TextDrawLetterSize(Effect[5][i],1.000000,70.000000);
		TextDrawColor(Effect[5][i],0xffffffff);
		TextDrawSetOutline(Effect[5][i],1);
		TextDrawSetProportional(Effect[5][i],1);
		TextDrawSetShadow(Effect[5][i],1);

		Effect[6][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[6][i],1);
		TextDrawBoxColor(Effect[6][i],0xffffff11);
		TextDrawTextSize(Effect[6][i],950.000000,0.000000);
		TextDrawAlignment(Effect[6][i],0);
		TextDrawBackgroundColor(Effect[6][i],0x000000ff);
		TextDrawFont(Effect[6][i],3);
		TextDrawLetterSize(Effect[6][i],1.000000,70.000000);
		TextDrawColor(Effect[6][i],0xffffffff);
		TextDrawSetOutline(Effect[6][i],1);
		TextDrawSetProportional(Effect[6][i],1);
		TextDrawSetShadow(Effect[6][i],1);

		Effect[7][i] = TextDrawCreate(1.000000,1.000000,"________________________________________________________________________________________________________________________________");
		TextDrawUseBox(Effect[7][i],1);
		TextDrawBoxColor(Effect[7][i],0xffffff11);
		TextDrawTextSize(Effect[7][i],950.000000,0.000000);
		TextDrawAlignment(Effect[7][i],0);
		TextDrawBackgroundColor(Effect[7][i],0x000000ff);
		TextDrawFont(Effect[7][i],3);
		TextDrawLetterSize(Effect[7][i],1.000000,70.000000);
		TextDrawColor(Effect[7][i],0xffffffff);
		TextDrawSetOutline(Effect[7][i],1);
		TextDrawSetProportional(Effect[7][i],1);
		TextDrawSetShadow(Effect[7][i],1);

		BloodHemorhage[i][0] = TextDrawCreate(413.333496, 223.004379, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][0], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][0], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][0], 1);
		TextDrawColor(BloodHemorhage[i][0], -1);
		TextDrawUseBox(BloodHemorhage[i][0], true);
		TextDrawBoxColor(BloodHemorhage[i][0], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][0], 0x00000000);
		TextDrawSetShadow(BloodHemorhage[i][0], 0);
		TextDrawSetOutline(BloodHemorhage[i][0], 0);
		TextDrawFont(BloodHemorhage[i][0], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][0], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][0], 121.000000, 13.000000, 15.000000, 1.000000);

		BloodHemorhage[i][1] = TextDrawCreate(-57.666526, 208.075515, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][1], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][1], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][1], 1);
		TextDrawColor(BloodHemorhage[i][1], -1);
		TextDrawUseBox(BloodHemorhage[i][1], true);
		TextDrawBoxColor(BloodHemorhage[i][1], 0);
		TextDrawSetShadow(BloodHemorhage[i][1], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][1], 0x00000000);
		TextDrawSetOutline(BloodHemorhage[i][1], 0);
		TextDrawFont(BloodHemorhage[i][1], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][1], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][1], 25.000000, 13.000000, 15.000000, 2.000000);

		BloodHemorhage[i][2] = TextDrawCreate(371.777954, 94.088844, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][2], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][2], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][2], 1);
		TextDrawColor(BloodHemorhage[i][2], -1);
		TextDrawUseBox(BloodHemorhage[i][2], true);
		TextDrawBackgroundColor(BloodHemorhage[i][2], 0x00000000);
		TextDrawBoxColor(BloodHemorhage[i][2], 0);
		TextDrawSetShadow(BloodHemorhage[i][2], 0);
		TextDrawSetOutline(BloodHemorhage[i][2], 0);
		TextDrawFont(BloodHemorhage[i][2], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][2], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][2], 13122.000000, 13.000000, 15.000000, 2.000000);

		BloodHemorhage[i][3] = TextDrawCreate(171.888977, -106.013412, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][3], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][3], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][3], 1);
		TextDrawColor(BloodHemorhage[i][3], -1);
		TextDrawUseBox(BloodHemorhage[i][3], true);
		TextDrawBoxColor(BloodHemorhage[i][3], 0);
		TextDrawSetShadow(BloodHemorhage[i][3], 0);
		TextDrawSetOutline(BloodHemorhage[i][3], 0);
		TextDrawFont(BloodHemorhage[i][3], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][3], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][3], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][3], 25.000000, 13.000000, 15.000000, 2.000000);

		BloodHemorhage[i][4] = TextDrawCreate(476.000244, 315.608856, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][4], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][4], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][4], 1);
		TextDrawColor(BloodHemorhage[i][4], -1);
		TextDrawUseBox(BloodHemorhage[i][4], true);
		TextDrawBoxColor(BloodHemorhage[i][4], 0);
		TextDrawSetShadow(BloodHemorhage[i][4], 0);
		TextDrawSetOutline(BloodHemorhage[i][4], 0);
		TextDrawFont(BloodHemorhage[i][4], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][4], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][4], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][4], 25.000000, 13.000000, 15.000000, 2.000000);

		BloodHemorhage[i][5] = TextDrawCreate(-147.444259, 36.342082, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][5], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][5], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][5], 1);
		TextDrawColor(BloodHemorhage[i][5], -1);
		TextDrawUseBox(BloodHemorhage[i][5], true);
		TextDrawBoxColor(BloodHemorhage[i][5], 0);
		TextDrawSetShadow(BloodHemorhage[i][5], 0);
		TextDrawSetOutline(BloodHemorhage[i][5], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][5], 0x00000000);
		TextDrawFont(BloodHemorhage[i][5], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][5], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][5], 121.000000, 13.000000, 15.000000, 1.000000);

		BloodHemorhage[i][6] = TextDrawCreate(158.889053, 301.662017, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][6], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][6], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][6], 1);
		TextDrawColor(BloodHemorhage[i][6], -1);
		TextDrawUseBox(BloodHemorhage[i][6], true);
		TextDrawBoxColor(BloodHemorhage[i][6], 0);
		TextDrawSetShadow(BloodHemorhage[i][6], 0);
		TextDrawSetOutline(BloodHemorhage[i][6], 0);
		TextDrawFont(BloodHemorhage[i][6], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][6], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][6], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][6], 15.000000, 13.000000, 15.000000, 1.000000);

		BloodHemorhage[i][7] = TextDrawCreate(69.444587, 13.942190, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][7], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][7], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][7], 1);
		TextDrawColor(BloodHemorhage[i][7], -1);
		TextDrawUseBox(BloodHemorhage[i][7], true);
		TextDrawBackgroundColor(BloodHemorhage[i][7], 0x00000000);
		TextDrawBoxColor(BloodHemorhage[i][7], 0);
		TextDrawSetShadow(BloodHemorhage[i][7], 0);
		TextDrawSetOutline(BloodHemorhage[i][7], 0);
		TextDrawFont(BloodHemorhage[i][7], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][7], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][7], 8.000000, 0.000000, 0.000000, 1.000000);

		BloodHemorhage[i][8] = TextDrawCreate(426.444580, 151.831024, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][8], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][8], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][8], 1);
		TextDrawColor(BloodHemorhage[i][8], -1);
		TextDrawUseBox(BloodHemorhage[i][8], true);
		TextDrawBoxColor(BloodHemorhage[i][8], 0);
		TextDrawSetShadow(BloodHemorhage[i][8], 0);
		TextDrawSetOutline(BloodHemorhage[i][8], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][8], 0x00000000);
		TextDrawFont(BloodHemorhage[i][8], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][8], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][8], 8.000000, 0.000000, 0.000000, 1.000000);

		BloodHemorhage[i][9] = TextDrawCreate(6.555710, 261.844329, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][9], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][9], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][9], 1);
		TextDrawColor(BloodHemorhage[i][9], -1);
		TextDrawUseBox(BloodHemorhage[i][9], true);
		TextDrawBoxColor(BloodHemorhage[i][9], 0);
		TextDrawSetShadow(BloodHemorhage[i][9], 0);
		TextDrawSetOutline(BloodHemorhage[i][9], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][9], 0x00000000);
		TextDrawFont(BloodHemorhage[i][9], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][9], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][9], 8.000000, 0.000000, 0.000000, 1.000000);

		BloodHemorhage[i][10] = TextDrawCreate(507.555725, -119.946792, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][10], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][10], 295.999877, 255.857772);
		TextDrawAlignment(BloodHemorhage[i][10], 1);
		TextDrawColor(BloodHemorhage[i][10], -1);
		TextDrawUseBox(BloodHemorhage[i][10], true);
		TextDrawBoxColor(BloodHemorhage[i][10], 0);
		TextDrawSetShadow(BloodHemorhage[i][10], 0);
		TextDrawSetOutline(BloodHemorhage[i][10], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][10], 0x00000000);
		TextDrawFont(BloodHemorhage[i][10], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][10], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][10], 8.000000, 0.000000, 0.000000, 1.000000);

		BloodHemorhage[i][11] = TextDrawCreate(190.333541, 146.866500, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][11], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][11], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][11], 1);
		TextDrawColor(BloodHemorhage[i][11], -1);
		TextDrawUseBox(BloodHemorhage[i][11], true);
		TextDrawBoxColor(BloodHemorhage[i][11], 0);
		TextDrawSetShadow(BloodHemorhage[i][11], 0);
		TextDrawSetOutline(BloodHemorhage[i][11], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][11], 0x00000000);
		TextDrawFont(BloodHemorhage[i][11], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][11], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][11], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][12] = TextDrawCreate(-158.888580, 329.555389, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][12], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][12], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][12], 1);
		TextDrawColor(BloodHemorhage[i][12], -1);
		TextDrawUseBox(BloodHemorhage[i][12], true);
		TextDrawBoxColor(BloodHemorhage[i][12], 0);
		TextDrawSetShadow(BloodHemorhage[i][12], 0);
		TextDrawSetOutline(BloodHemorhage[i][12], 0);
		TextDrawFont(BloodHemorhage[i][12], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][12], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][12], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][12], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][13] = TextDrawCreate(-235.221939, -157.764617, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][13], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][13], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][13], 1);
		TextDrawColor(BloodHemorhage[i][13], -1);
		TextDrawUseBox(BloodHemorhage[i][13], true);
		TextDrawBoxColor(BloodHemorhage[i][13], 0);
		TextDrawSetShadow(BloodHemorhage[i][13], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][13], 0x00000000);
		TextDrawSetOutline(BloodHemorhage[i][13], 0);
		TextDrawFont(BloodHemorhage[i][13], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][13], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][13], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][14] = TextDrawCreate(314.222534, -207.040176, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][14], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][14], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][14], 1);
		TextDrawColor(BloodHemorhage[i][14], -1);
		TextDrawUseBox(BloodHemorhage[i][14], true);
		TextDrawBoxColor(BloodHemorhage[i][14], 0);
		TextDrawSetShadow(BloodHemorhage[i][14], 0);
		TextDrawSetOutline(BloodHemorhage[i][14], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][14], 0x00000000);
		TextDrawFont(BloodHemorhage[i][14], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][14], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][14], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][15] = TextDrawCreate(509.000335, -33.809070, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][15], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][15], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][15], 1);
		TextDrawColor(BloodHemorhage[i][15], -1);
		TextDrawUseBox(BloodHemorhage[i][15], true);
		TextDrawBoxColor(BloodHemorhage[i][15], 0);
		TextDrawSetShadow(BloodHemorhage[i][15], 0);
		TextDrawSetOutline(BloodHemorhage[i][15], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][15], 0x00000000);
		TextDrawFont(BloodHemorhage[i][15], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][15], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][15], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][16] = TextDrawCreate(358.889282, 334.053131, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][16], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][16], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][16], 1);
		TextDrawColor(BloodHemorhage[i][16], -1);
		TextDrawUseBox(BloodHemorhage[i][16], true);
		TextDrawBoxColor(BloodHemorhage[i][16], 0);
		TextDrawSetShadow(BloodHemorhage[i][16], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][16], 0x00000000);
		TextDrawSetOutline(BloodHemorhage[i][16], 0);
		TextDrawFont(BloodHemorhage[i][16], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][16], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][16], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][17] = TextDrawCreate(248.778182, 351.479705, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][17], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][17], 394.222015, 325.049041);
		TextDrawAlignment(BloodHemorhage[i][17], 1);
		TextDrawColor(BloodHemorhage[i][17], -1);
		TextDrawUseBox(BloodHemorhage[i][17], true);
		TextDrawBoxColor(BloodHemorhage[i][17], 0);
		TextDrawSetShadow(BloodHemorhage[i][17], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][17], 0x00000000);
		TextDrawSetOutline(BloodHemorhage[i][17], 0);
		TextDrawFont(BloodHemorhage[i][17], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][17], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][17], 229.000000, 15.000000, 25.000000, 1.000000);

		BloodHemorhage[i][18] = TextDrawCreate(60.000270, 97.119750, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][18], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][18], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][18], 1);
		TextDrawColor(BloodHemorhage[i][18], -1);
		TextDrawUseBox(BloodHemorhage[i][18], true);
		TextDrawBoxColor(BloodHemorhage[i][18], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][18], 0x00000000);
		TextDrawSetShadow(BloodHemorhage[i][18], 0);
		TextDrawSetOutline(BloodHemorhage[i][18], 0);
		TextDrawFont(BloodHemorhage[i][18], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][18], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][18], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][19] = TextDrawCreate(378.778076, -24.333578, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][19], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][19], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][19], 1);
		TextDrawColor(BloodHemorhage[i][19], -1);
		TextDrawUseBox(BloodHemorhage[i][19], true);
		TextDrawBoxColor(BloodHemorhage[i][19], 0);
		TextDrawSetShadow(BloodHemorhage[i][19], 0);
		TextDrawSetOutline(BloodHemorhage[i][19], 0);
		TextDrawFont(BloodHemorhage[i][19], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][19], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][19], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][19], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][20] = TextDrawCreate(133.111373, 180.755340, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][20], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][20], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][19], 1);
		TextDrawColor(BloodHemorhage[i][20], -1);
		TextDrawUseBox(BloodHemorhage[i][20], true);
		TextDrawBoxColor(BloodHemorhage[i][20], 0);
		TextDrawSetShadow(BloodHemorhage[i][20], 0);
		TextDrawSetOutline(BloodHemorhage[i][20], 0);
		TextDrawFont(BloodHemorhage[i][20], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][20], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][20], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][20], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][21] = TextDrawCreate(-106.333084, 160.350906, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][21], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][21], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][21], 1);
		TextDrawColor(BloodHemorhage[i][21], -1);
		TextDrawUseBox(BloodHemorhage[i][21], true);
		TextDrawBoxColor(BloodHemorhage[i][21], 0);
		TextDrawSetShadow(BloodHemorhage[i][21], 0);
		TextDrawSetOutline(BloodHemorhage[i][21], 0);
		TextDrawFont(BloodHemorhage[i][21], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][21], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][21], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][21], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][22] = TextDrawCreate(306.666900, 56.817550, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][22], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][22], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][22], 1);
		TextDrawColor(BloodHemorhage[i][22], -1);
		TextDrawUseBox(BloodHemorhage[i][22], true);
		TextDrawBoxColor(BloodHemorhage[i][22], 0);
		TextDrawSetShadow(BloodHemorhage[i][22], 0);
		TextDrawSetOutline(BloodHemorhage[i][22], 0);
		TextDrawFont(BloodHemorhage[i][22], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][22], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][22], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][22], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][23] = TextDrawCreate(90.777984, -54.182445, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][23], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][23], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][23], 1);
		TextDrawColor(BloodHemorhage[i][23], -1);
		TextDrawUseBox(BloodHemorhage[i][23], true);
		TextDrawBoxColor(BloodHemorhage[i][23], 0);
		TextDrawSetShadow(BloodHemorhage[i][23], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][23], 0x00000000);
		TextDrawSetOutline(BloodHemorhage[i][23], 0);
		TextDrawFont(BloodHemorhage[i][23], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][23], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][23], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][24] = TextDrawCreate(496.222412, 63.795333, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][24], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][24], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][24], 1);
		TextDrawColor(BloodHemorhage[i][24], -1);
		TextDrawUseBox(BloodHemorhage[i][24], true);
		TextDrawBackgroundColor(BloodHemorhage[i][24], 0x00000000);
		TextDrawBoxColor(BloodHemorhage[i][24], 0);
		TextDrawSetShadow(BloodHemorhage[i][24], 0);
		TextDrawSetOutline(BloodHemorhage[i][24], 0);
		TextDrawFont(BloodHemorhage[i][24], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][24], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][24], 15.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][25] = TextDrawCreate(479.000183, -26.297996, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][25], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][25], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][25], 1);
		TextDrawColor(BloodHemorhage[i][25], -1);
		TextDrawUseBox(BloodHemorhage[i][25], true);
		TextDrawBoxColor(BloodHemorhage[i][25], 0);
		TextDrawSetShadow(BloodHemorhage[i][25], 0);
		TextDrawSetOutline(BloodHemorhage[i][25], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][25], 0x00000000);
		TextDrawFont(BloodHemorhage[i][25], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][25], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][25], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][26] = TextDrawCreate(352.000152, 110.097564, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][26], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][26], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][26], 1);
		TextDrawColor(BloodHemorhage[i][26], -1);
		TextDrawUseBox(BloodHemorhage[i][26], true);
		TextDrawBoxColor(BloodHemorhage[i][26], 0);
		TextDrawSetShadow(BloodHemorhage[i][26], 0);
		TextDrawSetOutline(BloodHemorhage[i][26], 0);
		TextDrawFont(BloodHemorhage[i][26], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][26], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][26], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][26], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][27] = TextDrawCreate(21.889022, -10.857992, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][27], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][27], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][27], 1);
		TextDrawColor(BloodHemorhage[i][27], -1);
		TextDrawUseBox(BloodHemorhage[i][27], true);
		TextDrawBoxColor(BloodHemorhage[i][27], 0);
		TextDrawSetShadow(BloodHemorhage[i][27], 0);
		TextDrawSetOutline(BloodHemorhage[i][27], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][27], 0x00000000);
		TextDrawFont(BloodHemorhage[i][27], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][27], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][27], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][28] = TextDrawCreate(-1.555413, 177.306442, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][28], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][28], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][28], 1);
		TextDrawColor(BloodHemorhage[i][28], -1);
		TextDrawUseBox(BloodHemorhage[i][28], true);
		TextDrawBoxColor(BloodHemorhage[i][28], 0);
		TextDrawSetShadow(BloodHemorhage[i][28], 0);
		TextDrawSetOutline(BloodHemorhage[i][28], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][28], 0x00000000);
		TextDrawFont(BloodHemorhage[i][28], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][28], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][28], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][29] = TextDrawCreate(-123.666557, 251.479782, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][29], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][29], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][29], 1);
		TextDrawColor(BloodHemorhage[i][29], -1);
		TextDrawUseBox(BloodHemorhage[i][29], true);
		TextDrawBoxColor(BloodHemorhage[i][29], 0);
		TextDrawSetShadow(BloodHemorhage[i][29], 0);
		TextDrawSetOutline(BloodHemorhage[i][29], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][29], 0x00000000);
		TextDrawFont(BloodHemorhage[i][29], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][29], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][29], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][30] = TextDrawCreate(167.111221, 121.066444, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][30], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][30], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][30], 1);
		TextDrawColor(BloodHemorhage[i][30], -1);
		TextDrawUseBox(BloodHemorhage[i][30], true);
		TextDrawBoxColor(BloodHemorhage[i][30], 0);
		TextDrawSetShadow(BloodHemorhage[i][30], 0);
		TextDrawSetOutline(BloodHemorhage[i][30], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][30], 0x00000000);
		TextDrawFont(BloodHemorhage[i][30], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][30], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][30], 61.000000, 0.000000, 2.000000, 1.000000);

		BloodHemorhage[i][31] = TextDrawCreate(261.000122, 0.110886, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][31], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][31], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][31], 1);
		TextDrawColor(BloodHemorhage[i][31], -1);
		TextDrawUseBox(BloodHemorhage[i][31], true);
		TextDrawBoxColor(BloodHemorhage[i][31], 0);
		TextDrawSetShadow(BloodHemorhage[i][31], 0);
		TextDrawSetOutline(BloodHemorhage[i][31], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][31], 0x00000000);
		TextDrawFont(BloodHemorhage[i][31], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][31], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][31], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][32] = TextDrawCreate(403.333496, 35.457553, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][32], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][32], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][32], 1);
		TextDrawColor(BloodHemorhage[i][32], -1);
		TextDrawUseBox(BloodHemorhage[i][32], true);
		TextDrawBoxColor(BloodHemorhage[i][32], 0);
		TextDrawSetShadow(BloodHemorhage[i][32], 0);
		TextDrawSetOutline(BloodHemorhage[i][32], 0);
		TextDrawFont(BloodHemorhage[i][32], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][32], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][32], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][32], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][33] = TextDrawCreate(341.666809, -76.040245, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][33], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][33], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][33], 1);
		TextDrawColor(BloodHemorhage[i][33], -1);
		TextDrawUseBox(BloodHemorhage[i][33], true);
		TextDrawBoxColor(BloodHemorhage[i][33], 0);
		TextDrawSetShadow(BloodHemorhage[i][33], 0);
		TextDrawSetOutline(BloodHemorhage[i][33], 0);
		TextDrawFont(BloodHemorhage[i][33], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][33], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][33], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][33], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][34] = TextDrawCreate(146.666793, -16.302473, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][34], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][34], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][34], 1);
		TextDrawColor(BloodHemorhage[i][34], -1);
		TextDrawUseBox(BloodHemorhage[i][34], true);
		TextDrawBoxColor(BloodHemorhage[i][34], 0);
		TextDrawSetShadow(BloodHemorhage[i][34], 0);
		TextDrawSetOutline(BloodHemorhage[i][34], 0);
		TextDrawFont(BloodHemorhage[i][34], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][34], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][34], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][34], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][35] = TextDrawCreate(180.555633, -104.404716, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][35], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][35], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][35], 1);
		TextDrawColor(BloodHemorhage[i][35], -1);
		TextDrawUseBox(BloodHemorhage[i][35], true);
		TextDrawBoxColor(BloodHemorhage[i][35], 0);
		TextDrawSetShadow(BloodHemorhage[i][35], 0);
		TextDrawSetOutline(BloodHemorhage[i][35], 0);
		TextDrawFont(BloodHemorhage[i][35], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][35], 19836);
		TextDrawBackgroundColor(BloodHemorhage[i][35], 0x00000000);
		TextDrawSetPreviewRot(BloodHemorhage[i][35], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][36] = TextDrawCreate(84.222312, -85.982490, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][36], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][36], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][36], 1);
		TextDrawColor(BloodHemorhage[i][36], -1);
		TextDrawUseBox(BloodHemorhage[i][36], true);
		TextDrawBoxColor(BloodHemorhage[i][36], 0);
		TextDrawSetShadow(BloodHemorhage[i][36], 0);
		TextDrawSetOutline(BloodHemorhage[i][36], 0);
		TextDrawFont(BloodHemorhage[i][36], 5);
		TextDrawBackgroundColor(BloodHemorhage[i][36], 0x00000000);
		TextDrawSetPreviewModel(BloodHemorhage[i][36], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][36], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][37] = TextDrawCreate(131.000076, 229.613067, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][37], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][37], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][37], 1);
		TextDrawColor(BloodHemorhage[i][37], -1);
		TextDrawUseBox(BloodHemorhage[i][37], true);
		TextDrawBoxColor(BloodHemorhage[i][37], 0);
		TextDrawSetShadow(BloodHemorhage[i][37], 0);
		TextDrawSetOutline(BloodHemorhage[i][37], 0);
		TextDrawBackgroundColor(BloodHemorhage[i][37], 0x00000000);
		TextDrawFont(BloodHemorhage[i][37], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][37], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][37], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][38] = TextDrawCreate(366.666809, 308.266418, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][38], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][38], 186.222030, 187.164535);
		TextDrawAlignment(BloodHemorhage[i][38], 1);
		TextDrawBackgroundColor(BloodHemorhage[i][38], 0x00000000);
		TextDrawColor(BloodHemorhage[i][38], -1);
		TextDrawUseBox(BloodHemorhage[i][38], true);
		TextDrawBoxColor(BloodHemorhage[i][38], 0);
		TextDrawSetShadow(BloodHemorhage[i][38], 0);
		TextDrawSetOutline(BloodHemorhage[i][38], 0);
		TextDrawFont(BloodHemorhage[i][38], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][38], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][38], 61.000000, 0.000000, 2.000000, 2.000000);

		BloodHemorhage[i][39] = TextDrawCreate(363.666809, 37.479770, "particle:bloodpool_64");
		TextDrawLetterSize(BloodHemorhage[i][39], 0.141776, 1.398754);
		TextDrawTextSize(BloodHemorhage[i][39], 186.222030, 187.164535);
		TextDrawBackgroundColor(BloodHemorhage[i][39], 0x00000000);
		TextDrawAlignment(BloodHemorhage[i][39], 1);
		TextDrawColor(BloodHemorhage[i][39], -1);
		TextDrawUseBox(BloodHemorhage[i][39], true);
		TextDrawBoxColor(BloodHemorhage[i][39], 0);
		TextDrawSetShadow(BloodHemorhage[i][39], 0);
		TextDrawSetOutline(BloodHemorhage[i][39], 0);
		TextDrawFont(BloodHemorhage[i][39], 5);
		TextDrawSetPreviewModel(BloodHemorhage[i][39], 19836);
		TextDrawSetPreviewRot(BloodHemorhage[i][39], 61.000000, 0.000000, 2.000000, 2.000000);
	}
	for(new i; i < MAX_VEHICLES; i++)
	{
	    VehicleHideSomeone[i] = 0;
	    Fuel[i] = randomEx(1,6);
		Oil[i] = randomEx(1,6);
		if((!IsPlatVehicle(i)) && (!IsDiamVehicle(i)))
		{
  			new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,boot,objective);
			new rand = random(3);
			if(rand == 2) SetVehicleParamsEx(i,engine,lights,alarm,1,bonnet,boot,objective);
		}
		StartVehicle(i,0);
		WasVehicleDamaged[i] = 0;
		VehicleStarted[i] = 0;
		if(i == Hunter)
		{
		    StartVehicle(i,1);
		    VehicleStarted[i] = 1;
  			new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,boot,objective);
    		SetVehicleParamsEx(i,engine,lights,alarm,1,bonnet,boot,objective);
		}
	}
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
	KillTimer(InvadingTimer);
	DestroyObject(objectsupply1);
	DestroyObject(objectsupply2);
	Delete3DTextLabel(SupplyLabel);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if(IsPlayerNPC(playerid))return 1;
    if(PInfo[playerid][Logged] == 0) return 1;
	if(PInfo[playerid][Firstspawn] == 0)
	{
	    if(Team[playerid] == ZOMBIE)
		{
		    SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
		    SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
		    Team[playerid] = ZOMBIE;
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
			SetPlayerColor(playerid,green);
			SetPlayerHealth(playerid,100);
		}
	    return 0;
	}
	PInfo[playerid][NormalTP] = 1;
	WaitAirCheat[playerid] = 2;
 	SetPlayerPos(playerid,1146.1810,-905.9805,87.1797);
	SetPlayerFacingAngle(playerid,180);
	SetPlayerCameraPos(playerid,1146.0978,-909.2910,87.8659);
	SetPlayerCameraLookAt(playerid,1146.1810,-905.9805,87.9797);
	SetPlayerWeather(playerid,RWeather);
	if(RWeather == 55) SetPlayerTime(playerid,6,0);
	else SetPlayerTime(playerid,23,0);
	switch(classid)
	{
	    case 0..293: Team[playerid] = HUMAN,GameTextForPlayer(playerid,"~g~~h~Survivor",3000,3);
	    case 294..311: Team[playerid] = ZOMBIE,GameTextForPlayer(playerid,"~p~Zombie",3000,3);
	    //case 0,74,92,99,78,79,77,75,134,135,137,160,162,200,212,213,230,239:
	}
	TextDrawShowForPlayer(playerid,SkinChange[playerid]);
	TextDrawShowForPlayer(playerid,ZOMSURV[playerid]);
	TextDrawSetString(ZOMSURV[playerid],"~p~ZOMBIE ~w~/ ~g~SURVIVOR");
	TextDrawShowForPlayer(playerid,ArrLeft[playerid]);
	TextDrawShowForPlayer(playerid,ArrRight[playerid]);
	return 1;
}

function StartDetecting(playerid)
{
    PInfo[playerid][DetectingAir] = 1;
    return 1;
}

new Player1stGate;
new Player2ndGate;

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    TextDrawHideForPlayer(playerid,SkinChange[playerid]);
    TextDrawHideForPlayer(playerid,ZOMSURV[playerid]);
    TextDrawHideForPlayer(playerid,ArrLeft[playerid]);
    if((Team[playerid] != ZOMBIE) && (Team[playerid] != HUMAN))
    {
        Team[playerid] = HUMAN;
        SpawnPlayer(playerid);
	}
    PInfo[playerid][KillingMinute] = SetTimerEx("SetMinute",100000,true,"i",playerid);
    if(PInfo[playerid][Premium] > 0)
    {
    	EnableAntiCheatForPlayer(playerid,49,0);
	}
    TimeOfDeath[playerid] = false;
    PInfo[playerid][TipBiteTimer] = SetTimerEx("TipBitting",1000,true,"i",playerid);
    TextDrawHideForPlayer(playerid,ArrRight[playerid]);
    new day,month,year;
    SetTimerEx("StartDetecting",2400,false,"i",playerid);
	getdate(year,month,day);
    if(PInfo[playerid][Premium] > 0)
    {
    	if((year > PInfo[playerid][PremiumYear]) || ((PInfo[playerid][PremiumYear] == year) && (PInfo[playerid][PremiumMonth] < month)) || ((PInfo[playerid][PremiumYear] == year) && (PInfo[playerid][PremiumMonth] == month) && (PInfo[playerid][PremiumDay] <= day)))
    	{
        	PInfo[playerid][Premium] = 0;
        	SendClientMessage(playerid,white,"*** "cred"Your premium has been expired and your Premium member was automatically setted to none!");
		}
	}
    if(PInfo[playerid][ExtraXP] > 0)
    {
    	if((PInfo[playerid][ExtraXPYear] < year) || ((PInfo[playerid][ExtraXPYear] == year) && (PInfo[playerid][ExtraXPMonth] < month)) || ((PInfo[playerid][ExtraXPYear] == year) && (PInfo[playerid][ExtraXPMonth] == month) && (PInfo[playerid][ExtraXPDay] <= day)))
    	{
        	PInfo[playerid][ExtraXP] = 0;
        	SendClientMessage(playerid,white,"*** "cred"Your Extra Xp Pack has been expired and it was automatically disabled for you!");
		}
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
        PInfo[playerid][Dead] = 0;
        SetPlayerWeather(playerid,283);
        SetPlayerTime(playerid,23,0);
	}
	else if(PInfo[playerid][AfterLifeInfected] == 0)
	{
		if(IsPlayerNPC(playerid))return 1;
	    SetPlayerHealthRank(playerid);
		if(PInfo[playerid][Firstspawn] == 1)
		{
		    PInfo[playerid][Firstspawn] = 0;
		}
		if(Team[playerid] == HUMAN)
		{
		    new infects;
		    for(new i; i < MAX_PLAYERS; i++)
	    	{
	    		if(!IsPlayerConnected(i)) continue;
	    		if(PInfo[i][Firstspawn] == 1) continue;
	    		if(Team[i] == ZOMBIE) infects++;
			}
			if((PInfo[playerid][AllowToSpawn] == 0) || (PInfo[playerid][Training] == 0))
			{
			    if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 70)
			    {
					Team[playerid] = ZOMBIE;
					SpawnPlayer(playerid);
					SendClientMessage(playerid,white,""cred"Zombie team has over 70\% of the server infected, help them win, kill the last survivors!");
					SendClientMessage(playerid,white,"**"cred"Autobalance: "cwhite"Zombie's team was autobalanced!");
					return 1;
			    }
	     		if(CPscleared >= 5)
				{
					Team[playerid] = ZOMBIE;
					SpawnPlayer(playerid);
					SendClientMessage(playerid,white,""cred"Survivors have cleared more than 5 checkpoints, help zombies, don't let humans clear all checkpoints!");
					SendClientMessage(playerid,white,"**"cred"Autobalance: "cwhite"Zombie's team was autobalanced!");
					return 1;
				}
				if(PInfo[playerid][Infected] == 1)
	   			{
					Team[playerid] = ZOMBIE;
					SpawnPlayer(playerid);
					SendClientMessage(playerid,white,"**"cred" Gamemode detected suicide: Your team was automatically setted to zombie!");
					return 1;
				}
			}
			PInfo[playerid][AllowToSpawn] = 0;
			if(PInfo[playerid][SPerk] == 19) GivePlayerWeapon(playerid,16,3);
			if(PInfo[playerid][SPerk] == 23)
			{
				AddItem(playerid,"Radar",1);
			}
			if(PInfo[playerid][SPerk] == 29)
			{
			    PInfo[playerid][AssaultGrenades] ++;
			}
		    ResetPlayerInventory(playerid);
	     	new rand = random(sizeof Randomspawns);
	     	SetPlayerWeather(playerid,RWeather);
	     	SetTimerEx("Weather",2500,false,"i",playerid);
			SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
			SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
			SetCameraBehindPlayer(playerid);
			if((PInfo[playerid][Rank] ==3) || (PInfo[playerid][Rank] == 4))
			{
			    SetPlayerSkillLevel(playerid,0,998);
			}
			else
                SetPlayerSkillLevel(playerid,0,1000);
			CheckRankup(playerid,1);
			SetPlayerColor(playerid,green);
			if(PInfo[playerid][Premium] == 0)
	  		{
				AddItem(playerid,"Small Med Kits",5);
			    AddItem(playerid,"Medium Med Kits",4);
		        AddItem(playerid,"Large Med Kits",3);
		        AddItem(playerid,"Fuel",3);
		        AddItem(playerid,"Oil",3);
		        AddItem(playerid,"Flashlight",3);
		    }
		    if(PInfo[playerid][Premium] == 1)
		    {
		        SetPlayerArmour(playerid,100);
			    AddItem(playerid,"Small Med Kits",8);
		     	AddItem(playerid,"Medium Med Kits",8);
			    AddItem(playerid,"Large Med Kits",8);
			    AddItem(playerid,"Fuel",8);
			    AddItem(playerid,"Oil",8);
			    AddItem(playerid,"Flashlight",8);
			    AddItem(playerid,"Dizzy Away",8);
				static file[80];
				format(file,sizeof file,Userfile,GetPName(playerid));
				INI_Open(file);
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
				INI_Close();
		    }
		    if(PInfo[playerid][Premium] == 2)
		    {
		        SetPlayerArmour(playerid,150);
			    AddItem(playerid,"Small Med Kits",13);
		     	AddItem(playerid,"Medium Med Kits",13);
			    AddItem(playerid,"Large Med Kits",13);
			    AddItem(playerid,"Fuel",13);
			    AddItem(playerid,"Oil",13);
			    AddItem(playerid,"Flashlight",13);
			    AddItem(playerid,"Dizzy Away",13);
			    AddItem(playerid,"Molotov Guide",1);
			    static file[80];
				format(file,sizeof file,Userfile,GetPName(playerid));
				INI_Open(file);
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
				INI_Close();
				rand = random(sizeof Platspawns);
				SetPlayerPos(playerid,Platspawns[rand][0],Platspawns[rand][1],Platspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Platspawns[rand][3]);
		    }
		    if(PInfo[playerid][Premium] == 3)
		    {
		        SetPlayerArmour(playerid,300);
			    AddItem(playerid,"Small Med Kits",19);
		     	AddItem(playerid,"Medium Med Kits",19);
			    AddItem(playerid,"Large Med Kits",19);
			    AddItem(playerid,"Fuel",19);
			    AddItem(playerid,"Oil",19);
			    AddItem(playerid,"Flashlight",19);
			    AddItem(playerid,"Dizzy Away",19);
			    AddItem(playerid,"Molotov Guide",2);
			    static file[80];
				format(file,sizeof file,Userfile,GetPName(playerid));
				INI_Open(file);
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
				INI_Close();
				rand = random(sizeof Diamspawns);
				SetPlayerPos(playerid,Diamspawns[rand][0],Diamspawns[rand][1],Diamspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Diamspawns[rand][3]);
			}
			TogglePlayerControllable(playerid, 1);
			if(RWeather == 55) SetPlayerTime(playerid,6,0);
			else SetPlayerTime(playerid,23,0);
		}
	    if(Team[playerid] == ZOMBIE)
	    {
	        PInfo[playerid][NormalTP] = 1;
	        WaitAirCheat[playerid]=2;
	        SetPlayerFacingAngle(playerid,86.4572);
	        SetPlayerWeather(playerid,283);
	        SetPlayerTime(playerid,23,0);
	        if (CanSpawn == 0)
	        {
	            new rand = random(sizeof Randomspawns);
      			SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
			}
			else
			{
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
			}
	        TogglePlayerControllable(playerid, 0);
			SetTimerEx("UnFreezePlayer", 3000, false, "i", playerid);
			if(PInfo[playerid][JustInfected] == 1)
			{
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
			}
		    //SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
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
    TextDrawHideForPlayer(playerid,OILANDFUELTD[playerid]);
	TextDrawHideForPlayer(playerid,FuelTD[playerid]);
	TextDrawHideForPlayer(playerid,OilTD[playerid]);
	PInfo[playerid][Spawned] = 1;
    if(PInfo[playerid][Jailed] == 1)
	{
		Jail(playerid);
		new string[90];
		format(string,sizeof string,"~r~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[playerid][JailTimer]);
 		SendClientMessage(playerid,white,"* "cred"Type "corange"/timeleft"cred" to check how much jail time left");
		if(PInfo[playerid][Spawned] == 0)
		{
		    PlayersConnected --;
		    PInfo[playerid][Spawned] = 1;
		}
        GameTextForPlayer(playerid,string, 6500,3);
	}
	if(!GetPVarInt(playerid, "Animations")) PreloadAnimLib(playerid);
	if(PInfo[playerid][Hiden] == 1)
	{
	    TogglePlayerControllable(playerid, 1);
	    SetPlayerHealth(playerid,PInfo[playerid][HideHP]);
	    SetTimerEx("UnFreezePlayer", 1000, false, "i", playerid);
		PutPlayerInVehicle(playerid,PInfo[playerid][HideInVehicle],PInfo[playerid][SeatID]);
		VehicleHideSomeone[PInfo[playerid][HideInVehicle]] = 0;
		PInfo[playerid][Hiden] = 0;
		SetTimerEx("EnableACHide",1550,false,"i",playerid);
	}
	PInfo[playerid][Dead] = 0;
	EnableAntiCheatForPlayer(playerid,27,1);
    if(PInfo[playerid][Training] == 1)
    {
        if(PInfo[playerid][TrainingPhase] < 9)
        {
            SetPlayerPosAndAngle(playerid,78.3376,1921.1488,17.6406,268.3526);
            SetTimerEx("Show1stDialog",600,false,"i",playerid);
            Team[playerid] = HUMAN;
		}
		if(PInfo[playerid][TrainingPhase] >= 9)
		{
	  		new rand = random(11);
	  		new strang[2070];
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
			format(strang, sizeof strang,""cwhite"You have completed course for humans! Half of course left!\nNow I will tell you about "cpurple"Zombies "cwhite"Gameplay");
			strcat(strang,"\n"cpurple"Zombies "cwhite"haven't got inventory, but they have special "corange"Rage Mode"cwhite". To get rage you need to be killed by higher rankers");
			strcat(strang,"\nYou are in Hive, here you will spawn after death, you can teleport to other places in city and also fill your HP by eating Brains (white arrows)");
			strcat(strang,"\nYou can teleport to hive from any pipes, you will see the on radar (they have marker \"T\"), also you can teleport to any mane places");
			strcat(strang,"\nFor sure zombies haven't got any weapons\nSo what to do?");
			strcat(strang,"\nZombies have bite system (we will talk about that later)\nWhen you play as zombie, another zombies are your friends and there is the same rule for teamkilling\nNow go to any pipe and stay in white pointer to continue course");
			ShowPlayerDialog(playerid,14777,DSM,"Info",strang,"OK","");
			PInfo[playerid][TrainingPhase] = 10;
			Team[playerid] = ZOMBIE;
			DisablePlayerCheckpoint(playerid);
		    return 1;
		}
		DestroyPlayerObject(playerid,Player1stGate);
		DestroyPlayerObject(playerid,Player2ndGate);
		DestroyPlayerObject(playerid,GateZombie1);
		DestroyPlayerObject(playerid,GateZombie2);
		DestroyActor(Jason[playerid]);
		DestroyVehicle(Vehicles[playerid][0]);
		DestroyVehicle(Vehicles[playerid][1]);
		DestroyVehicle(Vehicles[playerid][2]);
		DestroyVehicle(Vehicles[playerid][3]);
		Player1stGate = CreatePlayerObject(playerid,980,214.7910000,1875.6939700,13.1130000,0.0000000,0.0000000,357.9950000); //thisisgateforplayer2
		Player2ndGate = CreatePlayerObject(playerid,980,140.8380000,1915.0629900,20.8630000,0.0000000,0.0000000,88.0000000); //thisisgaterr
	}
	return 1;
}

function EnableACHide(playerid)
{
	EnableAntiCheatForPlayer(playerid,11,1);
	EnableAntiCheatForPlayer(playerid,12,1);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
 	if(PInfo[playerid][Logged] == 0) return 0;
  	TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	PInfo[playerid][Dead] = 1;
    PInfo[playerid][DeathsRound]++;
    RemovePlayerAttachedObject(playerid, PInfo[playerid][oslothat]);
    RemovePlayerAttachedObject(playerid, PInfo[playerid][oslotglasses]);
	if(Mission[playerid] != 0)
	{
    	RemovePlayerMapIcon(playerid,1);
    	Mission[playerid] = 0;
    	DestroyPickup(FirstStepMolotov[playerid]);
    	DestroyPickup(SecondStepMolotov[playerid]);
    	DestroyPickup(ThirdStepMolotov[playerid]);
    	SendClientMessage(playerid,white,""cwhite"** "cred" You have failed Molotov Mission!");
 	}
    if(PInfo[playerid][Lighton] == 1)
	{
		RemovePlayerAttachedObject(playerid,4);
        PInfo[playerid][Lighton] = 0;
        RemoveItem(playerid,"Flashlight",1);
        static string[90];
 		format(string,sizeof string,""cjam"%s dropped his Flashlight.",GetPName(playerid));
 		KillTimer(FlashLightTimer[playerid]);
		SendNearMessage(playerid,white,string,30);
	}
	if(Team[killerid] == HUMAN && Team[playerid] == HUMAN)
	{
	    if(PInfo[playerid][Infected] == 1)
	    {
	        PInfo[killerid][Kills]++;
	        PInfo[playerid][Dead] = 1;
	        GivePlayerXP(killerid);
        	CheckRankup(killerid);
        	InfectPlayer(playerid);
        	GivePlayerAssistXP(killerid);
		}
	    else
	    {
        	PInfo[killerid][Teamkills]++;
        	SendClientMessage(killerid,white,"» "cwhite"TeamKilling is "cred"NOT ALLOWED!!! "cwhite"«");
        	if(PInfo[killerid][WarnJail] == 2)
        	{
        	    SendClientMessage(killerid,white,"» "cred"If you continue killing your teammates, you will be jailed!!! "cwhite"«");
			}
			if(PInfo[killerid][WarnJail] == 3)
			{
			    SendClientMessage(killerid,white,"» "cred"Last warning, if you kill your teammate again, you will be jailed!!! "cwhite"«");
   			}
        	if(PInfo[killerid][WarnJail] == 4)
        	{
				Jail(killerid);
				new string[128];
				if(PInfo[killerid][Rank] < 10)
				{
					PInfo[killerid][JailTimer] = 600;
				}
				else if((PInfo[killerid][Rank] >= 10) && (PInfo[killerid][Rank] < 20))
				{
				    PInfo[killerid][JailTimer] = 1500;
				}
				else if(PInfo[killerid][Rank] >= 20)
				{
				    PInfo[killerid][JailTimer] = 3000;
				}
				format(string,sizeof string,"~t~~r~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[killerid][JailTimer]);
       		 	GameTextForPlayer(killerid,string, 6500,3);
			}
        	else PInfo[killerid][WarnJail] ++;
        	if(PInfo[playerid][XP] <= 5) PInfo[playerid][XP] = 0;
        	else
        	{
        	    PInfo[killerid][TeamKilling] = 1;
		     	if(PInfo[playerid][ShowingXP] == 0)
			    {
					static string[7];
					PInfo[killerid][XP] -= 5;
					PInfo[killerid][CurrentXP] += 5;
					format(string,sizeof string,"-%i XP",PInfo[killerid][CurrentXP]);
					TextDrawSetString(GainXPTD[killerid],string);
					PInfo[killerid][ShowingXP] = 1;
					SetTimerEx("ShowXP1",100,0,"d",killerid);
				    TextDrawShowForPlayer(killerid,GainXPTD[killerid]);
				}
				else
				{
				    static string[7];
					PInfo[killerid][XP] -= 5;
					PInfo[killerid][CurrentXP] += 5;
					format(string,sizeof string,"-%i XP",PInfo[killerid][CurrentXP]);
				    TextDrawSetString(GainXPTD[killerid],string);
				}
			}
        	PInfo[playerid][Deaths]++;
        	CheckRankup(playerid);
    	}
	}
	else if(Team[killerid] == HUMAN && Team[playerid] == ZOMBIE)
	{
	    PInfo[killerid][Kills]++;
	    PInfo[playerid][Deaths]++;
	    PInfo[killerid][KillsRound]++;
	    PInfo[playerid][Dead] = 1;
	    GivePlayerXP(killerid);
	    CheckRankup(killerid);
	    GiveRage(killerid,playerid);
		GivePlayerAssistXP(killerid);
	}
	else if(Team[killerid] == ZOMBIE && Team[playerid] == HUMAN)
	{
	    PInfo[killerid][Infects]++;
	    PInfo[playerid][Dead] = 1;
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
    TextDrawHideForPlayer(playerid,OILANDFUELTD[playerid]);
	TextDrawHideForPlayer(playerid,FuelTD[playerid]);
	TextDrawHideForPlayer(playerid,OilTD[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	if(PInfo[playerid][DeletedAcc] == 0)
	{
		if(PInfo[playerid][Logged] == 1) SaveStats(playerid);
	}
	static string[64];
	switch(reason)
    {
        case 0: format(string,sizeof string,"» "cred"%s left the server. (Crash)",GetPName(playerid));
        case 1: format(string,sizeof string,"» "cred"%s left the server. (Disconnected)",GetPName(playerid));
        case 2: format(string,sizeof string,"» "cred"%s left the server. (Kick/Ban)",GetPName(playerid));
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
	DestroyObject(PInfo[playerid][MeatSObject]);
	Delete3DTextLabel(PInfo[playerid][LabelMeatForShare]);
    DestroyObject(PInfo[playerid][Flag1]);
    DestroyObject(PInfo[playerid][Flag2]);
    if(PInfo[playerid][Jailed] == 0) PlayersConnected--;
    SendAdminMessage(white,string);
    DestroyObject(PInfo[playerid][FireObject]);
    DestroyObject(PInfo[playerid][BettyObj1]);
    DestroyObject(PInfo[playerid][BettyObj2]);
    DestroyObject(PInfo[playerid][BettyObj3]);
    Delete3DTextLabel(PInfo[playerid][Ranklabel]);
    RemovePlayerMapIcon(playerid,0);
    DestroyDynamicMapIcon(PInfo[playerid][BeaconMarker]);
	DestroyObject(PInfo[playerid][Flare]);
	DestroyObject(PInfo[playerid][Vomit]);
	DestroyPlayerObject(playerid,Player2ndGate);
	DestroyPlayerObject(playerid,Player1stGate);
	DestroyPlayerObject(playerid,GateZombie1);
	DestroyPlayerObject(playerid,GateZombie2);
	DestroyActor(Jason[playerid]);
	KillTimer(FlashLightTimer[playerid]);
	KillTimer(PInfo[playerid][KillingMinute]);
	RemovePlayerAttachedObject(playerid,4);
	KillTimer(PInfo[playerid][StompTimer]);
	KillTimer(PInfo[playerid][PowerfulGlovesTimer]);
	KillTimer(PInfo[playerid][CanZombieBaitTimer]);
	KillTimer(PInfo[playerid][RunTimer]);
	KillTimer(PInfo[playerid][DigTimer]);
	DestroyObject(PInfo[playerid][ZObject]);
	KillTimer(PInfo[playerid][DestroyRadar]);
	KillTimer(PInfo[playerid][TipBiteTimer]);
	KillTimer(PInfo[playerid][VomitDamager]);
	if(PInfo[playerid][ChangingName] == 1)
	{
	    if(PInfo[playerid][Premium] == 0)
	    {
	    	PInfo[playerid][ZMoney] += 200;
	    	SaveStats(playerid);
		}
	}
	KillTimer(PInfo[playerid][ToxinTimer]);
	KillTimer(PInfo[playerid][UpdateStatsTimer]);
	KillTimer(PInfo[playerid][FlagsHPTimer]);
    if(CPID != -1) DisablePlayerCheckpoint(playerid);
    if(PInfo[playerid][CanBurst] == 0) PInfo[playerid][CanBurst] = 1, KillTimer(PInfo[playerid][ClearBurst]);
    SnowCreated[playerid] = 0;
	for(new g = 0; g < 2; g++)
	{
       	DestroyDynamicObject(SnowObj[playerid][g]);
 	}
 	new Float:x,Float:y,Float:z;
 	if(Team[playerid] == HUMAN)
 	{
		if(PInfo[playerid][Infected] == 1)
		{
	    	GetPlayerPos(playerid,x,y,z);
			for (new i; i < MAX_PLAYERS; i++)
			{
			    if(!IsPlayerConnected(i)) continue;
			    if(PInfo[i][Logged] == 0) continue;
		    	if(Team[i] == ZOMBIE)
		    	{
		    	    if(IsPlayerInRangeOfPoint(i,5,x,y,z))
		    	    {
		    	        Team[playerid] = ZOMBIE;
		    	        new strang[200];
		    	        format(strang,sizeof strang,"** "cred"You've got a compensation, because %s left the game when he was in fight, so his team has been automatically setted to zombie!",GetPName(playerid));
		    	        SendClientMessage(i,white,strang);
		    	        GivePlayerXP(i);
		    	        INI_Open("Admin/ExitInWarned.txt");
		    	        INI_WriteInt(GetPName(playerid),1);
   	        			INI_Save();
						INI_Close();
					}
				}
			}
		}
	}
 	if(RoundEnded == 0)
 	{
		INI_Open("Admin/Teams.txt");
		INI_WriteInt(GetPName(playerid),Team[playerid]);
		INI_Save();
		INI_Close();
 	}
 	INI_Open("Admin/Goddigged.txt");
 	if(PInfo[playerid][GodDig] == 1)
 	{
 	    INI_WriteInt(GetPName(playerid),PInfo[playerid][GodDig]);
	}
	INI_Save();
	INI_Close();
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

function TimerLogin(playerid)
{
	SendClientMessage(playerid,white,"** "cred"The time to login has ended, reconnect to the server to log in again!");
	SetTimerEx("kicken",300,false,"i",playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
	RemoveBuildingForPlayer(playerid, 729, 379.1250, -1475.3281, 31.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 4516, -141.3359, 468.6484, 12.9141, 0.25);
  	SetPlayerWeather(playerid,5123524);
  	TimeOfDeath[playerid] = false;
    SetPlayerTime(playerid,23,0);
    WaitAirCheat[playerid]=0;
	SetTimerEx("Muting",1300,true,"i",playerid);
	PInfo[playerid][UpdateStatsTimer] = SetTimerEx("UpdateStatsForPlayer",600,true,"i",playerid);
	//LoginTimer[playerid] = SetTimerEx("TimerLogin",150000,true,"i",playerid);
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
	if(IsPlayerNPC(playerid))return 1;
	SetPlayerMapIcon(playerid,0,1796.4291,-746.1771,70.0653,42,0);
    SetPlayerMapIcon(playerid,1,1879.4840,-961.0296,57.9495,42,0);
    SetPlayerMapIcon(playerid,2,764.9189,-1020.6819,32.5458,42,0);
    SetPlayerMapIcon(playerid,3,874.3699,-1354.1659,19.1583,42,0);
    SetPlayerMapIcon(playerid,4,855.9189,-1367.5089,19.1583,42,0);
    SetPlayerMapIcon(playerid,5,359.5788,-1737.4358,19.1583,42,0);
    SetPlayerMapIcon(playerid,6,1111.5894,-1882.8074,19.1583,42,0);
    SetPlayerMapIcon(playerid,7,1343.1594,-1820.1277,19.1583,42,0);
    SetPlayerMapIcon(playerid,8,1878.0483,-1820.8726,19.1583,42,0);
    SetPlayerMapIcon(playerid,9,1908.6268,-1836.7859,19.1583,42,0);
    SetPlayerMapIcon(playerid,10,2001.3937,-2026.8290,19.1583,42,0);
    SetPlayerMapIcon(playerid,11,2107.1982,-2426.6914,19.1583,42,0);
    SetPlayerMapIcon(playerid,12,2102.5164,-2469.0520,19.1583,42,0);
    SetPlayerMapIcon(playerid,13,2623.5386,-1467.3356,27.4473,42,0);
    SetPlayerMapIcon(playerid,14,2600.9202,-1465.5054,27.4473,42,0);
    SetPlayerMapIcon(playerid,15,1411.0238,-1314.0334,14.0279,42,0);
    if(SupplyDirect > -1)
    {
		if((SupplyDestroyed == 0) && (SupplyInvaded == 0))
		{
		 	switch(SupplyDirect)
			{
			    case 0:
			    {
		            for(new i; i < MAX_PLAYERS; i++)
		            {
						if(!IsPlayerConnected(i)) continue;
						SetPlayerMapIcon(i,77,1986.0311,-2381.5178,13.5469,18,0,MAPICON_GLOBAL);
					}
				}
			    case 1:
			    {
		            for(new i; i < MAX_PLAYERS; i++)
		            {
						if(!IsPlayerConnected(i)) continue;
						SetPlayerMapIcon(i,77,839.1480,-1369.9624,22.5321,18,0,MAPICON_GLOBAL);
					}
				}
			    case 2:
			    {
		            for(new i; i < MAX_PLAYERS; i++)
		            {
						if(!IsPlayerConnected(i)) continue;
						SetPlayerMapIcon(i,77,2518.4868,-1563.7096,22.8676,18,0,MAPICON_GLOBAL);
					}
				}
			    case 3:
			    {
		            for(new i; i < MAX_PLAYERS; i++)
		            {
						if(!IsPlayerConnected(i)) continue;
						SetPlayerMapIcon(i,77,2022.0211,-1851.5437,3.9844,18,0,MAPICON_GLOBAL);
					}
				}
			    case 4:
			    {
		            for(new i; i < MAX_PLAYERS; i++)
		            {
						if(!IsPlayerConnected(i)) continue;
						SetPlayerMapIcon(i,77,1360.9065,-1262.3665,13.3828,18,0,MAPICON_GLOBAL);
					}
				}
			}
		}
	}
    SetPlayerTime(playerid,23,0);
	PlaySound(playerid,1077);
    if(!IsPlayerNPC(playerid))
    {
		PlayersConnected++;
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
	}
    static file[128];
	format(file,sizeof file,Userfile,GetPName(playerid));
	if(INI_Exist(file))
	{
	    INI_Open(file);
	    if(INI_ReadInt("Banned") == 1)
	    {
	        SendFMessageToAll(red,"%s has tried to ban evade. He was disconnected.",GetPName(playerid));
			format(file,sizeof file,"%s has tried to ban evade.",GetPName(playerid));
			SaveIn("Banevadelog",file,1);
			SetTimerEx("BanPlayer",10,false,"i",playerid);
		}
		else
		{
		    new string[25];
		    format(string,sizeof string,"\tUltimate - Gaming.com");
			new strang[2048];
			format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
			strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.04.92"cred" BETA");
			strcat(strang,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
		 	strcat(strang,""cwhite"\n Script Author: "dred"Zackster, Flexx");
            strcat(strang,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy), Zackster");
        	strcat(strang,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n\n\n\n");
        	strcat(strang,""cwhite"\t\t\t    Please, write your password below to "cred"Start Playing!");
	 		ShowPlayerDialog(playerid,Logindialog,3,string,strang,"Login","Quit");
	  		SetPlayerWeather(playerid,5123524);
    		SetPlayerTime(playerid,23,0);
		}
		INI_Close();
	}
	else
	{
	    if(!IsPlayerNPC(playerid))
	    {
			new strang[2048];
			format(strang,sizeof strang,"\n\n\t\t\t\t\t"corange"||"cwhite" Welcome "cred"%s "corange"||\n\n",GetPName(playerid));
			strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.04.92"cred" BETA");
			strcat(strang,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
		 	strcat(strang,""cwhite"\n Script Author: "dred"Zackster, Flexx");
            strcat(strang,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy), Zackster");
        	strcat(strang,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n\n\n\n");
        	strcat(strang,""cwhite"\t\t\t        You must to "cred"register "cwhite"to play on server!\n\t\t\t        Create a password and enter it below!");
			ShowPlayerDialog(playerid,Registerdialog,3,"Ultimate - Gaming.com",strang,"Register","Quit");
	  		SetPlayerWeather(playerid,5123524);
    		SetPlayerTime(playerid,23,0);
		}
	}
	PInfo[playerid][Logged] = 0;
	PInfo[playerid][Failedlogins] = 0;
	PInfo[playerid][CanBite] = 1;
	PInfo[playerid][CanSpit] = 1;
	PInfo[playerid][JustInfected] = 0;
	PInfo[playerid][Infected] = 0;
	PInfo[playerid][Dead] = 1;
	PInfo[playerid][MaxGrenades] = 0;
	PInfo[playerid][Firsttimeincp] = 1;
	PInfo[playerid][CanBurst] = 1;
	PInfo[playerid][Firstspawn] = 1;
	PInfo[playerid][Flashed] = 0;
 	PInfo[playerid][ZombieBait] = 0;
 	PInfo[playerid][SMeatBite] = 0;
 	PInfo[playerid][Poisoned] = 0;
 	PInfo[playerid][SeismicPhase] = 1;
 	PInfo[playerid][CanGrenadeAgain] = 1;
 	PInfo[playerid][DeletedAcc] = 0;
 	PInfo[playerid][ACWarning] = 0;
 	PInfo[playerid][Waswarnedbh] = 0;
 	PInfo[playerid][FoundBullets] = 0;
 	PInfo[playerid][CanUseSeismicShock] = 1;
 	PInfo[playerid][CanBiteVomit] = 1;
	PInfo[playerid][FireMode] = 0;
	PInfo[playerid][PoisonDizzy] = 0;
	PInfo[playerid][ChooseAfterTr] = 0;
	PInfo[playerid][CanUseRage] = 0;
	PInfo[playerid][OnFire] = 0;
	PInfo[playerid][FakePerk] = 0;
	PInfo[playerid][EvoidingCP] = 0;
	PInfo[playerid][TokeDizzy] = 0;
	PInfo[playerid][ShareMeatVomited] = 0;
	PInfo[playerid][CanJump] = 8000;
	PInfo[playerid][Spectating] = 0;
	PInfo[playerid][SpecID] = -1;
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
	PInfo[playerid][PressingKeyShift] = 0;
    PInfo[playerid][ThrowingBaitPhase1] = 1;
    PInfo[playerid][ThrowingBaitPhase2] = 1;
    PInfo[playerid][ThrowingBaitPhase3] = 1;
    PInfo[playerid][ThrowingBaitPhase4] = 1;
	PInfo[playerid][CanStomp] = 1;
	PInfo[playerid][Stomped] = 0;
	PInfo[playerid][CanRun] = 1;
	PInfo[playerid][NormalTP] = 0;
	PInfo[playerid][RageMode] = 0;
	PInfo[playerid][CanVel] = 0;
	PInfo[playerid][CanPunch] = 1;
	PInfo[playerid][RageModeStatus] = 0;
	PInfo[playerid][CanZombieRun] = 1;
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
    PInfo[playerid][Allowedtovomit] = VOMITTIME;
   	PInfo[playerid][AllowedToBait] = 1;
    PInfo[playerid][oslotglasses] = -1;
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
    PInfo[playerid][DetectingAir] = 0;
    PInfo[playerid][GroupPlayers] = 0;
    PInfo[playerid][GroupWantJoin] = 0;
    PInfo[playerid][JumpsHops] = 0;
    PInfo[playerid][SurvivorWantToJoin] = -1;
    PInfo[playerid][FlashLightTimerOn] = 90;
    PInfo[playerid][FlashBangs] = 0;
    PInfo[playerid][Grenades] = 0;
    PInfo[playerid][EatenMeat] = 0;
    Mission[playerid] = 0;
    MissionPlace[playerid][0] = 0;
    MissionPlace[playerid][1] = 0;
    IsMessageSent[playerid] = 0;
    RemovePlayerMapIcon(playerid,1);
	format(file,sizeof file,""cgreen"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
 	PInfo[playerid][Ranklabel] = Create3DTextLabel(file,0x008080AA,0,0,0,35.0,0,1);
	Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
	SetPlayerTime(playerid,23,0);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    SetPlayerMarkerForPlayer(i,playerid,0x969696FF);
	}
	INI_Open("Admin/ExitInWarned.txt");
    if(INI_ReadInt(GetPName(playerid)) != 0)
    {
        if(INI_ReadInt(GetPName(playerid)) == 1)
        {
			SendClientMessage(playerid,white,"** "cred"In previous exit you left server while you were fighting, IT IS NOT ALLOWED!!!");
			SendClientMessage(playerid,white,"** "cred"Your team was automatically setted to zombie, if you continue evade figthing, you will be punished!");
            INI_WriteInt(GetPName(playerid),0);
		}
    }
    INI_Close();
	INI_Open("Admin/Teams.txt");
    if(INI_ReadInt(GetPName(playerid)) != 0)
    {
        PInfo[playerid][Firstspawn] = 0;
        if(PInfo[playerid][Training] == 0)
        {
			Team[playerid] = INI_ReadInt(GetPName(playerid));
			printf("%i",Team[playerid]);
		}
		else if(PInfo[playerid][Training] == 1)
		{
		    if(PInfo[playerid][TrainingPhase] >= 9)
		    	Team[playerid] = ZOMBIE;
		    else
		        Team[playerid] = HUMAN;
		}
    }
    INI_Close();
	INI_Open("Admin/Goddigged.txt");
    if(INI_ReadInt(GetPName(playerid)) == 1)
    {
        PInfo[playerid][GodDig] = 1;
    }
    INI_Close();
    SetTimerEx("Radar", 750, true, "i", playerid);
  	SetPlayerWeather(playerid,5123524);
    SetPlayerTime(playerid,23,0);
	return 1;
}

CMD:flashb(playerid,params[])
{
	PInfo[playerid][FlashBangs] = 15;
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    if(PInfo[playerid][Spawned] == 0) return 0;
    if(PInfo[playerid][Dead] == 1) return 0;
	if(PInfo[playerid][Firsttimeincp] == 1)
    {
        if(Team[playerid] == ZOMBIE) return 0;
        if(PInfo[playerid][Training] == 1)
        {
            Team[playerid] = ZOMBIE;
            PInfo[playerid][TrainingPhase] = 9;
            SpawnPlayer(playerid);
            return 0;
        }
        PInfo[playerid][EvoidingCP] = 0;
        KillTimer(PInfo[playerid][EvoidingCPTimer]);
		static Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
        for(new i; i < MAX_PLAYERS;i++)
        {
            if(!IsPlayerConnected(i)) continue;
            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
            SendFMessage(i,white,"*"cjam"%s has been given more ammo and some medical attention from the military.",GetPName(playerid));
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
			SendClientMessage(playerid,white,"» "cblue"You've got 3 flame bullets (Flame Rounds)");
		}
		if(PInfo[playerid][SPerk] == 23)
		{
			AddItem(playerid,"Radar",1);
			SendClientMessage(playerid,white,"» "cblue"You've got a special radar from the military");
		}
		if(PInfo[playerid][SPerk] == 29)
		{
		    PInfo[playerid][AssaultGrenades] ++;
		    SendClientMessage(playerid,white,"» "cblue"You've got a assault grenade from military");
		}
		if(PInfo[playerid][SPerk] == 25)
		{
		    for(new i; i < MAX_PLAYERS; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
		        if(PInfo[i][Logged] == 0) continue;
		        if(IsPlayerInCheckpoint(i))
		        {
			    	GetPlayerPos(i,x,y,z);
			    	PlayerPlaySound(i,17003,x,y,z);
			    	if(Team[i] == ZOMBIE)
			    	{
                        TogglePlayerControllable(i, 0);
                        SetTimerEx("UnFreezePlayer", 2800, false, "i", i);
					}
				}
				new string[139];
				format(string,sizeof string,"* "cjam"%s activated a frozing bomb and every zombie won't move for several seconds!",GetPName(playerid));
				SendClientMessage(i,white,string);
			}
		}
		if(PInfo[playerid][SPerk] == 4)
		{
 			PInfo[playerid][FlashBangs] += 3;
		}
		if(PInfo[playerid][SPerk] == 19) GivePlayerWeapon(playerid,16,3);
		if(weapons[2][0] == 22) GivePlayerWeapon(playerid,22,34);
		if(weapons[2][0] == 23) GivePlayerWeapon(playerid,23,24);
		if(weapons[2][0] == 24) GivePlayerWeapon(playerid,24,14);
		if(weapons[3][0] == 25) GivePlayerWeapon(playerid,25,20);
		if(weapons[3][0] == 26) GivePlayerWeapon(playerid,26,16);
		if(weapons[3][0] == 27) GivePlayerWeapon(playerid,27,21);
		if(weapons[4][0] == 28) GivePlayerWeapon(playerid,28,100);
		if(weapons[4][0] == 29) GivePlayerWeapon(playerid,29,60);
		if(weapons[5][0] == 30) GivePlayerWeapon(playerid,30,30);
		if(weapons[5][0] == 31) GivePlayerWeapon(playerid,31,50);
		if(weapons[4][0] == 32) GivePlayerWeapon(playerid,32,125);
		if(weapons[6][0] == 33) GivePlayerWeapon(playerid,33,25);
		if(weapons[6][0] == 34) GivePlayerWeapon(playerid,34,30);
        if(PInfo[playerid][Premium] == 2)
	    {
	        SetPlayerArmour(playerid,150);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s has been given an new durable Kevlar vest from the military",GetPName(playerid));
	        }
     	}
     	if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s has been given a fresh Kevlar vest from the military.",GetPName(playerid));
	        }
     	}
        if(PInfo[playerid][Premium] == 3)
	    {
	        SetPlayerArmour(playerid,300);
	        for(new i; i < MAX_PLAYERS;i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"*"cjam"%s has been given an Diamond Kevlar vest from the military",GetPName(playerid));
	        }
     	}
  	}
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
	if(Team[playerid] != ZOMBIE)
	{
    	SendClientMessage(playerid,white,""cwhite"* "cblue"WARNING: You have left from CheckPoint!");
	    TextDrawHideForPlayer(playerid,CPbar[playerid]);
	    TextDrawHideForPlayer(playerid,CPbartext[playerid]);
	    TextDrawHideForPlayer(playerid,CPvaluebar[playerid]);
	    TextDrawHideForPlayer(playerid,CPvaluepercent[playerid]);
	}
	return 1;
}

CMD:me(playerid,params[])
{
	static msg[128],string[128];
	if(sscanf(params,"s[128]",msg)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/me <action>");
	format(string,sizeof(string),""cjam"%s %s",GetPName(playerid),msg);
 	SendNearMessage(playerid,white,string,25);
	return 1;
}

CMD:tpm(playerid,params[])
{
	new text[80],string[128];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/tpm <message for team>");
	format(string,sizeof string,"TPM from |%i| %s: %s",playerid,GetPName(playerid),text);
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
	    SendClientMessage(playerid,white,"» "corange"Now you are opened for PM!");
 	}
 	else
 	{
 	    PInfo[playerid][NoPM] = 1;
	    SendClientMessage(playerid,white,"» "corange"You have blocked PM, now you won't get any messages!");
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
	if(sscanf(params,"us[80]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/pm <ID> <message>");
	if(PInfo[id][NoPM] == 1) return SendClientMessage(playerid,white,"» "cred"This player dont want to receive private messages.");
	format(string,sizeof(string),"PM from %s(%i): %s",GetPName(playerid),playerid,text);
	SendClientMessage(id,0xFFFF22AA,string);
	format(string,sizeof(string),"PM sent to %s(%i): %s",GetPName(id),id,text);
	SendClientMessage(playerid,0xFFCC2299,string);
	PInfo[id][LastID] = playerid;
	return 1;
}

CMD:groupmates(playerid,params[])
{
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"You are not in group!");
	new on,lead[15];
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) on++;
 	}
    SendFMessage(playerid,green,""cblue"___There are %i humans in your group!",on);
    for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][GroupIN] != PInfo[playerid][GroupIN]) continue;
	    if(PInfo[i][GroupLeader] == 1)
	    {
			lead = "Group Leader";
			SendFMessage(playerid,green,""cblue"|%s |%i| - %s",GetPName(i),i,lead);
		}
		else SendFMessage(playerid,green,""cblue"|%s |%i|",GetPName(i),i);
	}
	return 1;
}

CMD:admins(playerid,params[])
{
	new lvl[11],on;
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] > 0) on++;
 	}
	SendFMessage(playerid,green,"____ Administartors Online: %i ____",on);
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] == 0) continue;
	    if(PInfo[i][Level] == 1) lvl = "Trial";
	    else if(PInfo[i][Level] == 2) lvl = "Senior";
	    else if(PInfo[i][Level] == 3) lvl = "General";
	    else if(PInfo[i][Level] == 4) lvl = "Lead";
	    else if(PInfo[i][Level] == 5) lvl = "Head";
	    else if(PInfo[i][Level] == 6) lvl = "Developer";
		if(IsPlayerAdmin(i)) lvl = "Owner";
		SendFMessage(playerid,green,"- %s |%i| %s admin",GetPName(i),i,lvl);
	}
	SendFMessage(playerid,green,"___________________________",on);
	return 1;
}

/*CMD:setav(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return 0;
	new Float:x,Float:y,Float:z;
	if(sscanf(params,"fff",x,y,z)) return SendClientMessage(playerid,orange,"USAGE: /setav <x> <y> <z>");
	SetVehicleAngularVelocity(GetPlayerVehicleID(playerid), x, y, z);
	return 1;
}*/

CMD:setzskin(playerid,params[])
{
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Only players with "cgold"GOLD"cred"/"cplat"PLATINUM "cred"can use this command!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setzskin <Skin ID>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"Skin must to be between 1 - 299 !");
	new valid = 0;
	for(new i = 0; i < sizeof(ZombieSkins); i++)
			if(skin == ZombieSkins[i]) valid = 1;
	if(valid == 0) return SendClientMessage(playerid,red,"This skin is not allowed for zombie team!");
	if(Team[playerid] == ZOMBIE) SetPlayerSkin(playerid,skin);
	SendClientMessage(playerid,white,""cwhite"* "cblue"You changed your skin successfully!");
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
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Only players with "cgold"GOLD"cred"/"cplat"PLATINUM "cred"can use this command!");
	new skin;
	if(sscanf(params,"i",skin)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsskin <Skin ID>");
	if(skin < 1 || skin > 299) return SendClientMessage(playerid,red,"Skin must to be between 1 - 299 !");
	if(skin == 74) return SendClientMessage(playerid,red,"This Skin is not allowed!");
	if(skin == 92) return SendClientMessage(playerid,red,"This Skin is not allowed!");
	if(skin == 99) return SendClientMessage(playerid,red,"This Skin is not allowed!");
	SendClientMessage(playerid,white,""cwhite"* "cblue"You changed your skin successfully!");
	if(Team[playerid] == HUMAN)
	{
		SetPlayerSkin(playerid,skin);
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
	if(PInfo[playerid][Premium] == 0) return SendClientMessage(playerid,white,"* "cred"Error: Only players with "cgold"GOLD"cred"/"cplat"PLATINUM "cred"can use this command!");
	new perk,id;
	if(sscanf(params,"ii",id,perk)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setsperk <Team> <Perk's ID> "cgreen"1 = Survivor "cgrey"| "cjam"2 = Zombie");
	if(id < 1 || id > 2) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR: Use 1 for "cgreen"HUMAN "cred"and 2 for "cpurple"ZOMBIE");
	if(perk > PInfo[playerid][Rank]) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR: You did not get this perk!");
	if(PInfo[id][Jailed] == 1) return SendClientMessage(playerid,red,""cwhite"** "cred"ERROR: You can't use this command when you are jailed!");
	if(id == 1)
	{
		PInfo[playerid][SPerk] = perk-1;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk slot");
	}
	if(id == 2)
	{
		PInfo[playerid][ZPerk] = perk-1;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk slot");
	}
	return 1;
}


CMD:l(playerid,params[])
{
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/l <message>");
	static string[134];
 	format(string,sizeof string,"%s: %s",GetPName(playerid),text);
	SendNearMessage(playerid,white,string,30);
	return 1;
}

CMD:heal(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/heal <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
    static string[100];
	format(string,sizeof string,"|| Administartor %s(%i) healed %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,100);
	return 1;
}

CMD:killrandom(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static type,string[144];
	if(sscanf(params,"i",type)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/killrandom 1 - Activate,  2 - Deactivate");
	if(type < 0 || type > 1) return SendClientMessage(playerid,white,"* "cred"Error: Use 1 for activate, or 2 for deactivate");
	CanItRandom = type;
	if(type == 0)
	{
		format(string,sizeof string,"|| Administrator %s has deactivated random set on server ||",GetPName(playerid));
		SendAdminMessage(red,string);
	}
	if(type == 1)
	{
		format(string,sizeof string,"|| Administrator %s has activated random set on server ||",GetPName(playerid));
		SendAdminMessage(red,string);
	}
	return 1;
}

CMD:announce(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/announce <Text>");
	static string[128];
	format(string,sizeof string,"~h~~r~%s",text);
	GameTextForAll(string,2100,3);
	return 1;
}

CMD:tpevery(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Logged] == 0) continue;
	    SetPlayerPos(i,x+random(4),y+random(4),z+1);
	}
	static string[128];
	format(string,sizeof string,"|| Administrator %s has teleported everyone to his position ||",GetPName(playerid));
	SendAdminMessage(red,string);
	return 1;
}

CMD:getip(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,ipaddress[16];
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/GetIP <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: This player is not connected!");
	if(PInfo[id][Level] >= PInfo[playerid][Level]) return SendClientMessage(playerid,red,"» Error: You can't check IPs of higher administrators!");
	GetPlayerIp(id,ipaddress,sizeof ipaddress);
	new string[128];
	format(string,sizeof string,"* "cred"%s|%i|'s IP: "cwhite"%s",GetPName(id),id,ipaddress);
	SendClientMessage(playerid,white,string);
	return 1;
}

CMD:banip(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
 	new type[16],string[128];
	if(sscanf(params, "s[16]", type)) return SendClientMessage(playerid, orange, "USAGE: /BanIP <IP>");
	//if((strlen(type) > 16) || (strlen(type) < 16)) return SendClientMessage(playerid, orange, "» Error: IP-Addresses length must be 16!");
	/*format(string, sizeof(string),"banip %s", type);
	SendRconCommand(string);
	SendRconCommand("reloadbans");*/
    new iniFile = ini_openFile("Admin/BannedIPs.ini");
    format(string, sizeof(string), "%s", type);
    ini_setInteger(iniFile,string,1);
    ini_closeFile(iniFile);
    format(string, sizeof(string), "|| Administrator %s has banned IP-address: %s ||", GetPName(playerid),type);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] < 2) continue;
    	SendClientMessage(i,red,string);
	}
	SaveIn("BanIPlog",string,1);
    printf("[Banip] %s banned IP: %s", GetPName(playerid), type);
    return 1;
}

CMD:unbanip(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
 	new type[16],string[128];
	if(sscanf(params, "s[16]", type)) return SendClientMessage(playerid, orange, "USAGE: /UnBanIP <IP>");
    new iniFile = ini_openFile("Admin/BannedIPs.ini");
    format(string, sizeof(string), "%s", type);
    ini_setInteger(iniFile,string,0);
    ini_closeFile(iniFile);
    format(string, sizeof(string), "|| Administrator %s has unbanned IP-address: %s ||", GetPName(playerid),type);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] < 2) continue;
    	SendClientMessage(i,red,string);
	}
	SaveIn("BanIPlog",string,1);
    printf("[Banip] %s unbanned IP: %s", GetPName(playerid), type);
	return 1;
}

CMD:unban(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static nickname[50],string[256];
	if(sscanf(params,"s[50]",nickname)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unban <NickName>");
	static y,mm,d;
	getdate(y,mm,d);
	static file[500];
	format(file,sizeof file,Userfile,nickname);
	if(!fexist(file)) return SendClientMessage(playerid,white,"» Error: "cred"Player is not found in database!");
	else
	{
		INI_Open(file);
		INI_WriteInt("Banned",0);
		INI_Save();
		INI_Close();
	}
	SendFMessageToAll(red,"|| Administrator %s has unbanned %s ||",GetPName(playerid),nickname);
	format(string,sizeof string,"Administrator %s has unbanned %s",GetPName(playerid),nickname);
	SaveIn("Banlog",string,1);
	format(string,sizeof string,"%s has unbanned %s.",GetPName(playerid),nickname);
	return 1;
}

CMD:banoff(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static nickname[100],string[256],reason[64];
	if(sscanf(params,"s[100]s[64]",nickname,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/banoff <NickName> <Reason>");
	static y,mm,d;
	getdate(y,mm,d);
	static file[500];
	format(file,sizeof file,Userfile,nickname);
	if(!fexist(file)) return SendClientMessage(playerid,white,"» Error: "cred"Player is not found in database!");
	else
	{
		INI_Open(file);
		if((PInfo[playerid][Level]) <= (INI_ReadInt("Level")))
		{
		    INI_Close();
  			return SendClientMessage(playerid,white,"» Error: "cred"This player have higher level than you!");
		}
		else
		{
			INI_WriteInt("Banned",1);
			INI_Save();
			INI_Close();
		}
	}
	SendFMessageToAll(red,"|| Administrator %s has banned offline %s [Reason:%s]||",GetPName(playerid),nickname,reason);
	format(string,sizeof string,"Administrator %s has banned offline %s Reason: %s",GetPName(playerid),nickname,reason);
	SaveIn("Banlog",string,1);
	format(string,sizeof string,"%s has banned offline %s Reason: %s.",GetPName(playerid),nickname,reason);
	return 1;
}

CMD:sethealth(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,health;
	if(sscanf(params,"ui",id,health)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/SetPlayerHealth <id> <health>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
    static string[100];
	format(string,sizeof string,"|| Administrator %s has setted %s health to %i ||",GetPName(playerid),GetPName(id),health);
	TimeOfDeath[id] = true;
	SendAdminMessage(red,string);
	SetPlayerHealth(id,health);
	return 1;
}

CMD:spec(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/spec <id>");
 	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
 	if(id == playerid) return SendClientMessage(playerid,red,"» Error: You can't spectate yourself!");
 	if(PInfo[id][Spectating] == 1) return SendClientMessage(playerid,red,"» Error: This player is spectating someone!");
 	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,red,"» Error: This player is not logged in!");
 	if(PInfo[playerid][Spectating] == 0)
 	{
		SaveBeforePos(playerid);
		GetPlayerHealth(playerid,PInfo[playerid][BefHP]);
	}
  	if(GetPlayerState(id) == 1)
   	{
        SetPlayerInterior(playerid,GetPlayerInterior(id));
        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        TogglePlayerSpectating(playerid, 1);
        PlayerSpectatePlayer(playerid, id);
    }
    else if(GetPlayerState(id) == 2)
    {
        SetPlayerInterior(playerid,GetPlayerInterior(id));
        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        new idid = GetPlayerVehicleID(id);
        TogglePlayerSpectating(playerid, 1);
        PlayerSpectateVehicle(playerid, idid);
    }
    else if(GetPlayerState(id) == 3)
    {
        SetPlayerInterior(playerid,GetPlayerInterior(id));
        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
        new idid = GetPlayerVehicleID(id);
        TogglePlayerSpectating(playerid, 1);
        PlayerSpectateVehicle(playerid, idid);
    }
    for(new i;i < MAX_PLAYERS; i ++)
    {
        if(PInfo[i][Level] >= 1)
        {
			static string[128];
			format(string,sizeof string,""cred"Administrator %s started spectating %s",GetPName(playerid),GetPName(id));
			SendClientMessage(i,white,string);
		}
	}
	PInfo[playerid][SpecID] = id;
	PInfo[playerid][Spectating] = 1;
	PInfo[playerid][AllowToSpawn] = 1;
	SetPlayerHealth(playerid,10000000);
    SendClientMessage(playerid,white,""cred"You've started spectate, use /specoff to stop spectating");
    SendClientMessage(playerid,white,""cred"Press "corange"SPACE "cred"to update spectating mode");
	return 1;
}

CMD:specoff(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
    if(PInfo[playerid][Spectating] == 0) return SendClientMessage(playerid,white,"» Error: "cred"You are not spectating!");
	for(new i;i < MAX_PLAYERS; i ++)
    {
        if(PInfo[i][Level] >= 1)
        {
			static string[128];
			format(string,sizeof string,""cred"Administrator %s stopped spectating",GetPName(playerid));
			SendClientMessage(i,white,string);
		}
	}
	TogglePlayerSpectating(playerid, 0);
 	SetCameraBehindPlayer(playerid);
 	SetTimerEx("restorpos",1500,false,"i",playerid);
 	PInfo[playerid][SpecID] = -1;
 	SendClientMessage(playerid,white,""cred"You've stopped spectate");
 	return 1;
}

function restorpos(playerid)
{
	if(PInfo[playerid][Spectating] == 1)
	{
	    PInfo[playerid][NormalTP] = 1;
	    WaitAirCheat[playerid]=2;
		SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
		SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
		PInfo[playerid][Spectating] = 0;
	}
	return 1;
}

function SaveBeforePos(playerid)
{
	GetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
	return 1;
}

CMD:nuke(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/nuke <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	CreateExplosion(x,y,z,8,2);
	static string[100];
	format(string,sizeof string,"|| Administrator %s has nuked %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:bslap(playerid,params[])
{
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/bslap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+9);
	static string[100];
	format(string,sizeof string,"|| Administrator %s has slapped %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:slap(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/slap <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+6);
	static string[100];
	format(string,sizeof string,"|| Administrator %s has slapped %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

/*CMD:saveuser(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
    static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/saveuser <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static string[90];
	format(string,sizeof string,"|| Administrator %s has saved %s stats ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	SaveStats(id);
	return 1;
}*/

CMD:goto(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/goto <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	if(IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid),x,y+3,z);
	}
	else SetPlayerPos(playerid,x,y+3,z);
	WaitAirCheat[playerid]=2;
	PInfo[playerid][NormalTP] = 1;
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	static string[100];
	format(string,sizeof string,"|| Administrator %s has teleported to %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	return 1;
}

CMD:kick(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/kick <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"|| Administartor %s(%i) kicked player %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	SetTimerEx("kicken",50,false,"i",id);
	SendAdminMessage(red,string);
	SaveIn("Kicklog",string,1);
	return 1;
}

CMD:ban(playerid,params[])
{
    if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ban <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	if(PInfo[id][Level] >= PInfo[playerid][Level]) return SendClientMessage(playerid,red,"Error: This player has a higher level than you!");
    SendFMessageToAll(red,"|| Administrator %s has banned %s [Reason: %s] ||",GetPName(playerid),GetPName(id),reason);
	static string[500],y,mm,d;
	getdate(y,mm,d);

	format(string,sizeof string,"Administrator %s has banned %s. [Reason: %s]",GetPName(playerid),GetPName(id),reason);
	SaveIn("Banlog",string,1);

	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: %s. \nDate: %d/%d/%d \n\n\n\t"cgreen"\nIf you think that you got ban fo nothing\nTake a picture of this box and post an unban appeal at Ultimate - Gaming forum.",GetPName(playerid),GetPName(id),GetHisIP(id),reason,d,mm,y);
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
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/get <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(IsPlayerInAnyVehicle(id))
	{
	    SetVehiclePos(GetPlayerVehicleID(id),x,y+3,z);
	}
	else SetPlayerPos(id,x,y+3,z);
	WaitAirCheat[id]=2;
	PInfo[id][NormalTP] = 1;
	SetPlayerInterior(id,GetPlayerInterior(playerid));
	static string[100];
	format(string,sizeof string,"|| Administrator %s has teleported %s to his location ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	return 1;
}


CMD:perks(playerid,params[])
{
	if(PInfo[playerid][Jailed])
	{
	    SendClientMessage(playerid,red,"You are jailed!!! You can't use this command right now!");
	    return 0;
	}
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

CMD:ac(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ac <message>");
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] >= 1)
	    {
			new string[128];
			format(string,sizeof string,""cblue"|Admin Chat|"cgrey"|%i|"cred"%s: "cband"%s",playerid,GetPName(playerid),text);
	        SendClientMessage(i,white,string);
		}
	}
	return 1;
}

CMD:amc(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
    static text[128];
    if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/amc <message>");
	new string[128];
	format(string,sizeof string,""cwhite"** "cred"ADMINISTRATOR: "corange"%s",text);
    SendClientMessageToAll(white,string);
	return 1;
}

CMD:report(playerid,params[])
{
	static id,text[128];
	if(sscanf(params,"us[128]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/report <id> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	for(new i; i < MAX_PLAYERS; i ++)
	{
     	if((PInfo[i][Level] >= 1) || (IsPlayerAdmin(i)))
     	{
			static string[128];
			format(string, sizeof string,""cred"|Report| |%i|%s reported |%i|%s, Reason:%s",playerid,GetPName(playerid),id,GetPName(id),text);
			SendClientMessage(i,white,string);
		}
	}
	SendClientMessage(playerid,white,""cwhite"* "corange"Thanks for reporting, online administrators will check it soon!");
	return 1;
}


CMD:setteam(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,team,reason[64];
	if(sscanf(params,"uis[64]",id,team,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setteam <id> <1 = Human | 2 = Zombie> <Reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	if(team == ZOMBIE)
	{
	    new string[128];
	    SetSpawnInfo(id,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
	    SetPlayerSkin(id,ZombieSkins[random(sizeof(ZombieSkins))]);
	    SpawnPlayer(id);
	    Team[id] = ZOMBIE;
        new RandomGS = random(sizeof(gRandomSkin));
        SetPlayerSkin(id,gRandomSkin[RandomGS]);
	    SetPlayerColor(id,purple);
	    SetPlayerHealth(id,100);
	    PInfo[id][GroupIN] = 0;
		format(string,sizeof string,""cred"» Administrator %s has set %s's team to [ZOMBIE] [Reason: %s]",GetPName(playerid),GetPName(id),reason);
		SendClientMessageToAll(white,string);
		DestroyObject(PInfo[id][Flare]);
		DestroyObject(PInfo[id][ZObject]);
		KillTimer(PInfo[id][FlagsHPTimer]);
  		DestroyObject(PInfo[id][Flag1]);
    	DestroyObject(PInfo[id][Flag2]);
    	KillTimer(PInfo[id][ToxinTimer]);
	}
  	else if(team == HUMAN)
	{
	    new string[128];
	    Team[id] = HUMAN;
	    static sid;
		ChooseSkin: sid = random(299);
		sid = random(299);
		for(new i = 0; i < sizeof(ZombieSkins); i++)
			if(sid == ZombieSkins[i]) goto ChooseSkin;
    	SetSpawnInfo(id,0,sid,0,0,0,0,0,0,0,0,0,0);
	    SetPlayerSkin(id,sid);
	    PInfo[id][JustInfected] = 0;
	    PInfo[id][AllowToSpawn] = 1;
	    PInfo[id][Infected] = 0;
		PInfo[id][Dead] = 0;
		PInfo[id][CanBite] = 1;
        new RandomBS = random(sizeof(bRandomSkin));
        SetPlayerSkin(id,bRandomSkin[RandomBS]);
		SpawnPlayer(id);
		if(PInfo[id][Premium] == 0)
		{
			AddItem(playerid,"Small Med Kits",5);
	    	AddItem(playerid,"Medium Med Kits",4);
        	AddItem(playerid,"Large Med Kits",3);
        	AddItem(playerid,"Fuel",3);
        	AddItem(playerid,"Oil",3);
        	AddItem(playerid,"Flashlight",3);
		}
		if(PInfo[id][Premium] == 1)
        {
		    AddItem(playerid,"Small Med Kits",8);
	     	AddItem(playerid,"Medium Med Kits",8);
		    AddItem(playerid,"Large Med Kits",8);
		    AddItem(playerid,"Fuel",8);
		    AddItem(playerid,"Oil",8);
		    AddItem(playerid,"Flashlight",8);
		    AddItem(playerid,"Dizzy Away",8);
		}
		if(PInfo[id][Premium] == 2)
        {
		    AddItem(playerid,"Small Med Kits",13);
	     	AddItem(playerid,"Medium Med Kits",13);
		    AddItem(playerid,"Large Med Kits",13);
		    AddItem(playerid,"Fuel",13);
		    AddItem(playerid,"Oil",13);
		    AddItem(playerid,"Flashlight",13);
		    AddItem(playerid,"Dizzy Away",13);
		    AddItem(playerid,"Molotov Guide",1);
		}
		if(PInfo[id][Premium] == 3)
        {
		    AddItem(playerid,"Small Med Kits",19);
	     	AddItem(playerid,"Medium Med Kits",19);
		    AddItem(playerid,"Large Med Kits",19);
		    AddItem(playerid,"Fuel",19);
		    AddItem(playerid,"Oil",19);
		    AddItem(playerid,"Flashlight",19);
		    AddItem(playerid,"Dizzy Away",19);
		    AddItem(playerid,"Molotov Guide",2);
		}
		SetPlayerColor(id,green);
		SetPlayerHealth(id,100);
		format(string,sizeof string,""cred"» Administrator %s has set %s's team to [HUMAN] [Reason: %s]",GetPName(playerid),GetPName(id),reason);
		SendClientMessageToAll(white,string);
		DestroyObject(PInfo[id][MeatSObject]);
		DestroyObject(PInfo[id][Vomit]);
		PInfo[id][ShareMeatVomited] = 0;
		Delete3DTextLabel(PInfo[id][LabelMeatForShare]);
		KillTimer(PInfo[id][ToxinTimer]);
		KillTimer(PInfo[id][VomitDamager]);
	}
	else SendClientMessage(playerid,white,"* "cred"Error: team doesn't found");
	return 1;
}

CMD:setlevel(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setlevel <id> <level>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	if(level > 6) return SendClientMessage(playerid,red,"Maximum admin level is 6!");
	if(PInfo[playerid][Level] <= PInfo[id][Level]) return SendClientMessage(playerid,red,"This admin have a higher level than you!");
	SendFMessageToAll(red,"» Administrator %s has setted %s admin level to %i",GetPName(playerid),GetPName(id),level);
	if(level > PInfo[id][Level])
	    GameTextForPlayer(id,"~g~~h~Promoted!",4000,3);
	else
	    GameTextForPlayer(id,"~r~~h~Demoted!",4000,3);
	PInfo[id][Level] = level;
	SaveStats(id);
	return 1;
}

CMD:adminhelp(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	if(PInfo[playerid][Level] == 1)
	{
		ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial","Choose","Close");
	}
	if(PInfo[playerid][Level] == 2)
	{
		ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior","Choose","Close");
	}
	if(PInfo[playerid][Level] == 3)
	{
		ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General","Choose","Close");
	}
	if(PInfo[playerid][Level] == 4)
	{
		ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General\nLevel 4\t"cgreen"Lead","Choose","Close");
	}
	if(PInfo[playerid][Level] >= 5)
	{
		ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General\nLevel 4\t"cgreen"Lead\nLevel 5\t"dred"Head","Choose","Close");
	}
	return 1;
}

CMD:warn(playerid,params[])
{
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,warn[64],string[400],string2[128];
	if(sscanf(params,"us[64]",id,warn)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/warn <id> <warn>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	if(PInfo[playerid][Level] <= PInfo[id][Level]) return SendClientMessage(playerid,red,"This admin have a higher level than you!");
	format(string,sizeof string,"» Administrator %s has warned %s [Reason: %s]",GetPName(playerid),GetPName(id),warn);
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
	    SendFMessageToAll(red,"|| Administrator %s has banned %s [Reason: 3 Warnings]",GetPName(playerid),GetPName(id));
		SendFMessageToAll(red,"||Warning 1: %s||",warn1);
		SendFMessageToAll(red,"||Warning 2: %s||",warn2);
		SendFMessageToAll(red,"||Warning 3: %s||",warn3);
		format(string2,sizeof string2,"%s has banned %s",GetPName(playerid),GetPName(id));
		format(string,sizeof(string),""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: 3 Warnings. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a screenshot of this dialog and post an unban appeal at "cred"ultimate-gaming.com",GetPName(playerid),GetPName(id),GetHisIP(id),d,mm,y);
		ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");
		BanEx(id,string);
		INI_Save();
	}
	INI_Close();
	return 1;
}

/*CMD:setprem(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,prem;
	if(sscanf(params,"ui",id,prem)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setprem <id> <premium> "cgold"1 = Gold "cblue"| "cplat"2 = Platinum");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	if(prem > 4 && prem < 0) return SendClientMessage(playerid,red,"Max premium is diamond(3)!");
	ResetPlayerInventory(id);
	if(prem == 1)
	{
	    SendFMessageToAll(red,"» Administrator %s "cwhite"|| "cred"%i "cwhite"|| "cred" has setted %s premium to "cgold"Gold",GetPName(playerid),playerid,GetPName(id));
		if(Team[id] == HUMAN)
			SetPlayerArmour(id,100);
        AddItem(id,"Small Med Kits",8);
     	AddItem(id,"Medium Med Kits",8);
	    AddItem(id,"Large Med Kits",8);
	    AddItem(id,"Fuel",8);
	    AddItem(id,"Oil",8);
	    AddItem(id,"Flashlight",8);
	    AddItem(id,"Dizzy Away",8);
	    PInfo[id][ItemSMedKit] = 8;
	    PInfo[id][ItemMMedKit] = 8;
	    PInfo[id][ItemLMedKit] = 8;
	    PInfo[id][ItemFuel] = 8;
	    PInfo[id][ItemOil] = 8;
	    PInfo[id][ItemFlashlight] = 8;
	    PInfo[id][ItemDizzy] = 8;
	}
	else if(prem == 2)
	{
	    SendFMessageToAll(red,"» Administrator %s "cwhite"|| "cred"%i "cwhite"|| "cred" has setted %s premium to "cplat"Platinum",GetPName(playerid),playerid,GetPName(id));
		if(Team[id] == HUMAN)
			SetPlayerArmour(id,150);
        AddItem(id,"Small Med Kits",13);
     	AddItem(id,"Medium Med Kits",13);
	    AddItem(id,"Large Med Kits",13);
	    AddItem(id,"Fuel",13);
	    AddItem(id,"Oil",13);
	    AddItem(id,"Flashlight",13);
	    AddItem(id,"Dizzy Away",13);
	    AddItem(id,"Molotov Guide",1);
	    PInfo[id][ItemSMedKit] = 13;
	    PInfo[id][ItemMMedKit] = 13;
	    PInfo[id][ItemLMedKit] = 13;
	    PInfo[id][ItemFuel] = 13;
	    PInfo[id][ItemOil] = 13;
	    PInfo[id][ItemFlashlight] = 13;
	    PInfo[id][ItemDizzy] = 13;
	    PInfo[id][ItemMolotov] = 1;
	}
	else if(prem == 3)
	{
	    SendFMessageToAll(red,"» Administrator %s "cwhite"|| "cred"%i "cwhite"|| "cred" has setted %s premium to "cblue"Diamond",GetPName(playerid),playerid,GetPName(id));
		if(Team[id] == HUMAN)
			SetPlayerArmour(id,300);
        AddItem(id,"Small Med Kits",19);
     	AddItem(id,"Medium Med Kits",19);
	    AddItem(id,"Large Med Kits",19);
	    AddItem(id,"Fuel",19);
	    AddItem(id,"Oil",19);
	    AddItem(id,"Flashlight",19);
	    AddItem(id,"Dizzy Away",19);
	    AddItem(id,"Molotov Guide",2);
	    PInfo[id][ItemSMedKit] = 19;
	    PInfo[id][ItemMMedKit] = 19;
	    PInfo[id][ItemLMedKit] = 19;
	    PInfo[id][ItemFuel] = 19;
	    PInfo[id][ItemOil] = 19;
	    PInfo[id][ItemFlashlight] = 19;
	    PInfo[id][ItemDizzy] = 19;
	    PInfo[id][ItemMolotov] = 2;
	}
	else
	{
	    SendFMessageToAll(red,"» Administrator %s "cwhite"|| "cred"%i "cwhite"|| "cred" has setted %s premium to None.",GetPName(playerid),playerid,GetPName(id));
		SetPlayerArmour(id,0);
		AddItem(id,"Small Med Kits",5);
	    AddItem(id,"Medium Med Kits",4);
        AddItem(id,"Large Med Kits",3);
        AddItem(id,"Fuel",3);
        AddItem(id,"Oil",3);
        AddItem(id,"Flashlight",3);
        PInfo[id][ItemSMedKit] = 5;
        PInfo[id][ItemMMedKit] = 4;
        PInfo[id][ItemLMedKit] = 3;
        PInfo[id][ItemFuel] = 3;
        PInfo[id][ItemOil] = 3;
        PInfo[id][ItemFlashlight] = 3;
	}
	PInfo[id][Premium] = prem;
	SaveStats(id);
	return 1;
}*/

CMD:setrank(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setrank <id> <rank>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s rank to %i",GetPName(playerid),GetPName(id),level);
	PInfo[id][Rank] = level;
	ResetPlayerWeapons(id);
	CheckRankup(id,1);
	return 1;
}

CMD:setxp(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setxp <id> <xp>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s XP to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][XP] = xp;
	CheckRankup(playerid);
	return 1;
}

CMD:setkills(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setkills <id> <kills>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s kills to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Kills] = xp;
	return 1;
}

CMD:restartserver(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	for(new i; i < MAX_PLAYERS; i++)
	{
		new string[256];
		format(string,sizeof string,"*** "cred"ANNOUNCE: "cblue"Administrator %s restarted server! Your stats have been automatically saved!",GetPName(playerid));
		SendClientMessage(i,white,string);
	}
	SetTimer("RestartServer",1000,false);
	return 1;
}

function RestartServer()
{
	SendRconCommand("gmx");
	return 1;
}

CMD:setdeaths(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setdeaths <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s deaths to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Deaths] = xp;
	return 1;
}

CMD:setinfects(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setinfects <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s infects to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Infects] = xp;
	return 1;
}
public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	if(Team[damagedid] == ZOMBIE)
	{
	    if(PInfo[damagedid][ZPerk] == 13)
	    {
	        new Float:health;
	        GetPlayerHealth(damagedid,health);
			if(GetPlayerWeapon(playerid) == 22) SetPlayerHealth(damagedid,health-8); //COLT 45 22
			if(GetPlayerWeapon(playerid) == 23) SetPlayerHealth(damagedid,health-8); //USP 23
			if(GetPlayerWeapon(playerid) == 24) SetPlayerHealth(damagedid,health-20); //DEAGLE 24
			if(GetPlayerWeapon(playerid) == 25) SetPlayerHealth(damagedid,health-14); //Shotgun 25
			if(GetPlayerWeapon(playerid) == 26) SetPlayerHealth(damagedid,health-16); //SAWN 26
			if(GetPlayerWeapon(playerid) == 27) SetPlayerHealth(damagedid,health-20); //SPAZ 27
			if(GetPlayerWeapon(playerid) == 28) SetPlayerHealth(damagedid,health-3); //UZI 28
			if(GetPlayerWeapon(playerid) == 29) SetPlayerHealth(damagedid,health-6); //MP5 29
			if(GetPlayerWeapon(playerid) == 30) SetPlayerHealth(damagedid,health-8); //AK47 30
			if(GetPlayerWeapon(playerid) == 31) SetPlayerHealth(damagedid,health-10); //M4 31
            if(GetPlayerWeapon(playerid) == 32) SetPlayerHealth(damagedid,health-4); //TEC9 32
            if(GetPlayerWeapon(playerid) == 33) SetPlayerHealth(damagedid,health-17); //rifle 33
            if(GetPlayerWeapon(playerid) == 34) SetPlayerHealth(damagedid,health-30); //SniperRifle 34
            if(GetPlayerWeapon(playerid) == 38) SetPlayerHealth(damagedid,health-0); //MINIGUN 38
		}
	}
	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    if(IsPlayerNPC(playerid))return 1;
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
	        SetTimerEx("AffectFireBull",500,false,"ii",playerid,issuerid);
		}
		/*if(PInfo[playerid][ZPerk] == 13)
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
		}*/
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
			SetPlayerVelocity(playerid,x*0.2,y*0.2,z+0.2);
			WaitAirCheat[playerid]=2;
			if(PInfo[playerid][RageMode] == 0)
			{
				if(health <= 5)
				{
				    InfectPlayer(playerid);
				    PInfo[playerid][Dead] = 1;
				    GivePlayerXP(issuerid);
				    GivePlayerAssistXP(issuerid);
			        CheckRankup(issuerid);
			        PInfo[playerid][AfterLifeInfected] = 1;
				}
				else
	   				SetPlayerHealth(playerid,health-5);
				GetPlayerHealth(playerid,health);
				MakeHealthEven(playerid,health);
			}
			else if(PInfo[playerid][RageMode] == 1)
			{
				if(health <= 15)
				{
				    InfectPlayer(playerid);
				    PInfo[playerid][Dead] = 1;
				    GivePlayerXP(issuerid);
				    GivePlayerAssistXP(issuerid);
			        CheckRankup(issuerid);
			        PInfo[playerid][AfterLifeInfected] = 1;
				}
				else
	   				SetPlayerHealth(playerid,health-15);
				GetPlayerHealth(playerid,health);
				MakeHealthEven(playerid,health);
			}
		}
	    if(PInfo[issuerid][ZPerk] == 25 && GetPlayerWeapon(issuerid) == 0)
	    {
			if(PInfo[issuerid][CanPunch] == 1)
			{
		        new Float:x,Float:y,Float:z,Float:a,Float:health;
				GetPlayerVelocity(playerid,x,y,z);
				GetPlayerFacingAngle(issuerid,a);
				GetPlayerHealth(playerid,health);
				x += ( 0.5 * floatsin( -a, degrees ) );
		      	y += ( 0.5 * floatcos( -a, degrees ) );
				SetPlayerVelocity(playerid,x*0.2,y*0.2,z+0.5);
				PInfo[issuerid][CanPunch] = 0;
				SetPlayerAttachedObject(issuerid,8,18701,5,0,0,-1.59,0,0,0,1,1,1,0,0);
				SetPlayerAttachedObject(issuerid,9,18701,6,0,0,-1.59,0,0,0,1,1,1,0,0);
				SetTimerEx("DestroyFirePunches",5000,false,"i",issuerid);
				SetTimerEx("CanPunchAgain",750,false,"i",issuerid);
				WaitAirCheat[playerid]=2;
				if(PInfo[playerid][RageMode] == 0)
				{
					if(health <= 15)
					{
						if(Team[playerid] == HUMAN)
						{
							{
						    	InfectPlayer(playerid);
						    	PInfo[playerid][Dead] = 1;
						    	GivePlayerXP(issuerid);
						    	GivePlayerAssistXP(issuerid);
					        	CheckRankup(issuerid);
					        	PInfo[playerid][AfterLifeInfected] = 1;
							}
						}
					}
					else
		   				SetPlayerHealth(playerid,health-15);
					GetPlayerHealth(playerid,health);
					MakeHealthEven(playerid,health);
				}
				else if(PInfo[playerid][RageMode] == 1)
				{
					if(health <= 20)
					{
						if(Team[playerid] == HUMAN)
						{
							{
						    	InfectPlayer(playerid);
						    	PInfo[playerid][Dead] = 1;
						    	GivePlayerXP(issuerid);
						    	GivePlayerAssistXP(issuerid);
					        	CheckRankup(issuerid);
					        	PInfo[playerid][AfterLifeInfected] = 1;
							}
						}
					}
					else
		   				SetPlayerHealth(playerid,health-20);
					GetPlayerHealth(playerid,health);
					MakeHealthEven(playerid,health);
				}
		    }
		}
	}
    return 1;
}


public OnPlayerStateChange(playerid,newstate,oldstate)
{
    if(IsPlayerNPC(playerid))return 1;
    WaitAirCheat[playerid]=2;
	if (newstate == PLAYER_STATE_PASSENGER)
    {
        if(Team[playerid] == HUMAN)
    		SetPlayerArmedWeapon(playerid, 1);
		else
		{
		    if(PInfo[playerid][Training] == 1)
		    {
		        if(PInfo[playerid][TrainingPhase] == 15)
		        {
		            new string[2048];
		            format(string,sizeof string,""cwhite"Now you are sitting in vehicle as a zombie\nIf you want to bite human here, you need to click "cred"SPACE "cwhite"key");
		            strcat(string,"\nAlso you can write command "cred"/hide"cwhite" to hide in vehicle, no humans will know in which car you are hidding");
		            strcat(string,"\nIt will be useful when you play with stels style or If you have no much zombies that can help you at the moment\nCourse is comming to end and your next step is to go to hangar");
					ShowPlayerDialog(playerid,18778,DSM,"Info",string,"OK","");
					PInfo[playerid][TrainingPhase] = 16;
				}
			}
		}
    }
	if (newstate == PLAYER_STATE_DRIVER)
    {
    	SetPlayerArmedWeapon(playerid, 1);
    }
	if(newstate == PLAYER_STATE_DRIVER && Team[playerid] == ZOMBIE)
	{
	    RemovePlayerFromVehicle(playerid);
	    SendClientMessage(playerid,white,"* "cred"Zombies can't drive.");
	}
	if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT)
	{
	    TextDrawHideForPlayer(playerid,OILANDFUELTD[playerid]);
	    TextDrawHideForPlayer(playerid,FuelTD[playerid]);
		TextDrawHideForPlayer(playerid,OilTD[playerid]);
	}
	else if(newstate == PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_ONFOOT)
	{
	    TextDrawShowForPlayer(playerid,OILANDFUELTD[playerid]);
	    TextDrawShowForPlayer(playerid,FuelTD[playerid]);
		TextDrawShowForPlayer(playerid,OilTD[playerid]);
		UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
		if(!IsVehicleStarted(GetPlayerVehicleID(playerid)))
		{
		    if(Team[playerid] == HUMAN)
		    {
		    	new string[115];
		    	format(string,sizeof string,"** "corange"This vehicle is not Started yet. You can start it with "cred"'Left Mouse Button'"corange"."cwhite"**");
				SendClientMessage(playerid,white,string);
                TextDrawSetString(OilTD[playerid],"Oil: ~r~~h~ll~y~llllll~g~~h~ll");
                TextDrawSetString(FuelTD[playerid],"Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
			}
		}
		if(PInfo[playerid][Training] == 1)
		{
		    VehicleHideSomeone[GetPlayerVehicleID(playerid)] = 0;
		    Fuel[GetPlayerVehicleID(playerid)] = 6;
			Oil[GetPlayerVehicleID(playerid)] = 6;
			UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
			StartVehicle(GetPlayerVehicleID(playerid),0);
			WasVehicleDamaged[GetPlayerVehicleID(playerid)] = 0;
			VehicleStarted[GetPlayerVehicleID(playerid)] = 0;
			if(PInfo[playerid][TrainingPhase] == 2)
			{
				ShowPlayerDialog(playerid,20768,DSM,"Info",""cwhite"Vehicle is one of the most important thing for surviving\nWithout it you won't survive too long\nYou need to click "cred"Left Mouse Button"cwhite" to start engine\nKeep an eye on fuel and oil\nWithout them vehicle will not work!\nNow go to next Pickup to continue course!","OK","");
				PInfo[playerid][TrainingPhase] = 3;
				DestroyPlayerObject(playerid,Player2ndGate);
			}
		}
	}
    if(IsPlayerNPC(playerid))return 1;
    return 1;
}

public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
    if(IsPlayerNPC(playerid))return 1;
	if(IsPlatVehicle(vehicleid))
	{
	    if(Team[playerid] == ZOMBIE) return 1;
	    if((PInfo[playerid][Premium] != 2) && (PInfo[playerid][Premium] != 3))
	    {
	        if(ispassenger == 0)
	        {
		        new Float:x,Float:y,Float:z;
		        GetPlayerPos(playerid,x,y,z);
		        SetPlayerPos(playerid,x,y,z);
		        RemovePlayerFromVehicle(playerid);
		        SendClientMessage(playerid,white,"» "cred"Only players with "cplat"Platinum"cred"/"cblue"Diamond"cred" can enter this vehicle!");
			}
		}
	}
	if(IsDiamVehicle(vehicleid))
	{
	    if(Team[playerid] == ZOMBIE) return 1;
	    if(PInfo[playerid][Premium] != 3)
	    {
	        if(ispassenger == 0)
	        {
		        new Float:x,Float:y,Float:z;
		        GetPlayerPos(playerid,x,y,z);
		        SetPlayerPos(playerid,x,y,z);
		        RemovePlayerFromVehicle(playerid);
		        SendClientMessage(playerid,white,"» "cred"Only players with "cblue"Diamond"cred" can enter this vehicle!");
			}
		}
	}
	return 1;
}

function SeismicPhaseOn2(playerid)
{
    PInfo[playerid][SeismicPhase] = 2;
    SetPlayerAttachedObject(playerid,5,18681,6,0,0,-1.59,0,0,0,1,1,1,0,0);
    SetPlayerAttachedObject(playerid,6,18728,6,0,0,-1.59,0,0,0,1,1,1,0,0);
	return 1;
}

function CanUseSeismic(playerid)
{
    PInfo[playerid][CanUseSeismicShock] = 1;
	return 1;
}

function DestroyPucnhesSeis(playerid)
{
	RemovePlayerAttachedObject(playerid, 5);
	RemovePlayerAttachedObject(playerid, 6);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsPlayerNPC(playerid))return 1;
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
	if(HOLDING(KEY_JUMP) && HOLDING(KEY_CROUCH))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
	        if(PInfo[playerid][ZPerk] == 25)
	        {
	            if(!IsPlayerInAnyVehicle(playerid))
	            {
	            	if(PInfo[playerid][CanUseSeismicShock] == 0) return SendClientMessage(playerid,white,"* "cred"You are not ready to use seismic shock again!");
	            	PInfo[playerid][SeismicPhase] = 1;
	            	SetPlayerAttachedObject(playerid,6,18693,6,0,0,-1.59,0,0,0,1,1,1,0,0);
	            	ApplyAnimation(playerid,"PED","FIGHTIDLE",1,0,0,0,1,0,1);
					PInfo[playerid][SeismicTimerPhase2] = SetTimerEx("SeismicPhaseOn2",2500,false,"i",playerid);
				}
			}
		}
	}
	if((oldkeys & KEY_JUMP) && (oldkeys & KEY_CROUCH))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
	        if(PInfo[playerid][ZPerk] == 25)
	        {
	            if(!IsPlayerInAnyVehicle(playerid))
	            {
	                if(PInfo[playerid][CanUseSeismicShock] == 1)
	                {
			            KillTimer(PInfo[playerid][SeismicTimerPhase2]);
			            PInfo[playerid][CanUseSeismicShock] = 0;
			            if(PInfo[playerid][Premium] == 3)
			            {
			            	SetTimerEx("CanUseSeismic",95000,false,"i",playerid);
						}
						else SetTimerEx("CanUseSeismic",125000,false,"i",playerid);
		             	new Float:x,Float:y,Float:z,Float:a,Float:hp;
		              	new Float:vx,Float:vy,Float:vz;
		               	GetPlayerPos(playerid,x,y,z);
		               	SetTimerEx("DestroyPucnhesSeis",450,false,"i",playerid);
			            if(PInfo[playerid][SeismicPhase] == 1)
			            {
			                ApplyAnimation(playerid,"PED","FightA_3",2,0,1,1,0,0,1);
			                for(new i; i < MAX_PLAYERS; i ++)
			                {
			                    if(!IsPlayerConnected(i)) continue;
			                    if(Team[i] == ZOMBIE) continue;
			                    if(IsPlayerInAnyVehicle(i)) continue;
			                    if(IsPlayerInRangeOfPoint(i,2.5,x,y,z))
			                    {
			                        SendClientMessage(playerid,white," Phase 1");
			                        GetPlayerHealth(i,hp);
			                        if(hp <= 28)
			                        {
									    PInfo[playerid][Infects]++;
									    PInfo[i][Dead] = 1;
									    GivePlayerXP(playerid);
									    CheckRankup(playerid);
									    InfectPlayer(i);
									}
									else
										SetPlayerHealth(i,hp - 28);
									if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
									GetPlayerVelocity(i,vx,vy,vz);
									GetPlayerFacingAngle(playerid,a);
									vx += ( 0.5 * floatsin( -a, degrees ) );
						      		vy += ( 0.5 * floatcos( -a, degrees ) );
					      		 	ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
									SetPlayerVelocity(i,vx*1.1,vy*1.1,z+0.14);
								}
							}
						}
						if(PInfo[playerid][SeismicPhase] == 2)
						{
		    				/*for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
		    				{
		    				    new Float:vhx,Float:vhy,Float:vhz,Float:vehdis,Float:vhp;
		    				    vehdis = GetVehicleDistanceFromPoint(i,x,y,z);
		    				    if(vehdis > 4) continue;
		    				    if(!IsVehicleOccupied(i))
		    				    {
		    				        SendClientMessage(playerid,white," Phase  2 vehicle");
		    				        GetVehicleVelocity(i,vhx,vhy,vhz);
									GetPlayerFacingAngle(playerid,a);
									x += ( 0.5 * floatsin( -a, degrees ) );
						      		y += ( 0.5 * floatcos( -a, degrees ) );
						      		SetVehicleVelocity(i,15,15,2);
						      		SetVehicleAngularVelocity(i,0,0,0.75);
								}
							}*/
							ApplyAnimation(playerid,"PED","FightA_3",8,0,1,1,0,0,1);
							for(new i; i < MAX_PLAYERS; i ++)
			                {
			                    if(!IsPlayerConnected(i)) continue;
			                    if(Team[i] == ZOMBIE) continue;
			                    if(!IsPlayerInAnyVehicle(i))
			                    {
				                    if(IsPlayerInRangeOfPoint(i,2.5,x,y,z))
				                    {
				                        GetPlayerHealth(i,hp);
				                        if(hp <= 37)
				                        {
										    PInfo[playerid][Infects]++;
										    PInfo[i][Dead] = 1;
										    GivePlayerXP(playerid);
										    CheckRankup(playerid);
										    InfectPlayer(i);
										}
										else
											SetPlayerHealth(i,hp - 37);
										if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
										GetPlayerVelocity(i,vx,vy,vz);
										GetPlayerFacingAngle(playerid,a);
										vx += ( 0.5 * floatsin( -a, degrees ) );
							      		vy += ( 0.5 * floatcos( -a, degrees ) );
						      		 	ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
										SetPlayerVelocity(i,vx*1.5,vy*1.5,vz+0.21);
									}
								}
								if(IsPlayerInAnyVehicle(i))
								{
								    if(IsPlayerInRangeOfPoint(i,4,x,y,z))
								    {
								        new Float:vhx,Float:vhy,Float:vhz,Float:vhp;
			    				        GetVehicleVelocity(GetPlayerVehicleID(i),vhx,vhy,vhz);
										GetPlayerFacingAngle(playerid,a);
										vhx += ( 0.5 * floatsin( -a, degrees ) );
							      		vhy += ( 0.5 * floatcos( -a, degrees ) );
							      		SetVehicleVelocity(GetPlayerVehicleID(i),vhx*1.1,vhy*1.1,vhz+0.1);
							      		GetVehicleHealth(GetPlayerVehicleID(i),vhp);
							      		SetVehicleHealth(GetPlayerVehicleID(i),vhp - 200);
							      		new rand = random(4);
							      		if(rand == 0)
							      		{
					      					StartVehicle(GetPlayerVehicleID(i),0);
											VehicleStarted[GetPlayerVehicleID(i)] = 0;
											SendClientMessage(i,white,"* "cred"Your vehicle was damaged by powerful force, you need to start it again!");
										}
							      		SetVehicleAngularVelocity(GetPlayerVehicleID(i),0,0,0.4);
		             					GetPlayerHealth(i,hp);
				                        if(hp <= 23)
				                        {
										    PInfo[playerid][Infects]++;
										    PInfo[i][Dead] = 1;
										    GivePlayerXP(playerid);
										    CheckRankup(playerid);
										    InfectPlayer(i);
										}
										else
											SetPlayerHealth(i,hp - 23);
										if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if(HOLDING(KEY_WALK) && HOLDING(KEY_CROUCH))
    {
        if(Team[playerid] == HUMAN)
        {
            if((PInfo[playerid][SPerk] == 9) || (PInfo[playerid][SPerk] == 26))
            {
            	if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
					BaitThrowTimer4[playerid] = SetTimerEx("BaitPhase4",2000,false,"i",playerid);
					BaitThrowTimer3[playerid] = SetTimerEx("BaitPhase3",1400,false,"i",playerid);
					BaitThrowTimer2[playerid] = SetTimerEx("BaitPhase2",550,false,"i",playerid);
					BaitThrowTimer1[playerid] = SetTimerEx("BaitPhase1",125,false,"i",playerid);
					ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",5,0,0,0,1,0,1);
					PInfo[playerid][Baiting] = 1;
	 				SetPlayerAttachedObject(playerid,1,2908,6,0.15,0,0.08,-90,180,90);
				}
			}
			else if(PInfo[playerid][FlashBangs] >= 1)
			{
			    if(!IsPlayerInAnyVehicle(playerid))
			    {
				    if(PInfo[playerid][CanThrowFlashAgain] == 1)
				    {
						PInfo[playerid][FlashBangThrowPhase] = 1;
					    PInfo[playerid][FlashBangTimerPhase2] = SetTimerEx("ChangePhase2",150,false,"i",playerid);
					    PInfo[playerid][FlashBangTimerPhase3] = SetTimerEx("ChangePhase3",400,false,"i",playerid);
					    PInfo[playerid][FlashBangTimerPhase4] = SetTimerEx("ChangePhase4",700,false,"i",playerid);
					    PInfo[playerid][FlashBangTimerPhase5] = SetTimerEx("ChangePhase5",1000,false,"i",playerid);
					    PInfo[playerid][FlashBangTimerPhase6] = SetTimerEx("ChangePhase6",1350,false,"i",playerid);
					    PInfo[playerid][Baiting] = 1;
					    ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",5,0,0,0,1,0,1);
					    SetPlayerAttachedObject(playerid,1,343,6,0,0.1,0,180,180,90);
					}
				}
			}
		}
	}
	if((oldkeys & KEY_WALK) && (oldkeys & KEY_CROUCH))
	{
      if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][SPerk] == 9)
            {
                if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
					if(PInfo[playerid][ThrowingBaitPhase1] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
		                KillTimer(BaitThrowTimer4[playerid]);
		                KillTimer(BaitThrowTimer3[playerid]);
		                KillTimer(BaitThrowTimer2[playerid]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
					 	//PHY_UseColAndreas(PInfo[playerid][ZObject], 2);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 5 * floatsin(-ang, degrees), 5 * floatcos(-ang, degrees), 3);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z-0.9, _, 0.0);
						SetTimerEx("GetBaitPos", 600, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase2] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
	                 	KillTimer(BaitThrowTimer3[playerid]);
	                 	KillTimer(BaitThrowTimer4[playerid]);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
					 	//PHY_UseColAndreas(PInfo[playerid][ZObject], 2);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 7.5 * floatsin(-ang, degrees), 7.5 * floatcos(-ang, degrees), 11);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("GetBaitPos", 800, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase3] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
	                 	KillTimer(BaitThrowTimer4[playerid]);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
                        //PHY_UseColAndreas(PInfo[playerid][ZObject], 2);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 15 * floatsin(-ang, degrees), 15 * floatcos(-ang, degrees), 13);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("GetBaitPos", 900, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase4] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
					 	//PHY_UseColAndreas(PInfo[playerid][ZObject], 2);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 20 * floatsin(-ang, degrees), 20 * floatcos(-ang, degrees), 18);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("GetBaitPos", 1050, false, "i", playerid);
					}
 					PInfo[playerid][AllowedToBait] = 0;
 					if(PInfo[playerid][Premium] == 3) SetTimerEx("CanZombieBait",110000/*110000*/,false,"i",playerid);
 					else SetTimerEx("CanZombieBait",180000/*180000*/,false,"i",playerid);
 					SetTimerEx("StopBait", 15000, false, "i", playerid);
 					static string[70];
 					format(string,sizeof string,""cwhite"* "cjam"%s tosses some zombie bait.",GetPName(playerid));
					PInfo[playerid][Baiting] = 0;
 					SendNearMessage(playerid,white,string,20);
	                //SetTimerEx("ResetThrow",5000,false,"i",playerid);
				}
				for(new i ; i < MAX_PLAYERS; i ++)
				{
	   				PInfo[i][EatenBait] = 0;
				}
			}
   			else if(PInfo[playerid][SPerk] == 26)
            {
                if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
					if(PInfo[playerid][ThrowingBaitPhase1] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
		                KillTimer(BaitThrowTimer4[playerid]);
		                KillTimer(BaitThrowTimer3[playerid]);
		                KillTimer(BaitThrowTimer2[playerid]);
						new Float:x, Float:y, Float:z, Float:ang;
						//new Float:Pos[2];
						//new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						//GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						//MapAndreas_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
					 	//PHY_UseColAndreas(PInfo[playerid][ZObject], 1);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 5 * floatsin(-ang, degrees), 5 * floatcos(-ang, degrees), 3);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z-0.9, _, 0.0);
						SetTimerEx("ExplodeBait", 4500, false, "i", playerid);
						//PHY_SetObjectZBound(PInfo[playerid][ZObject], newZ+12.65, z-0.9, 0.0);
						SetTimerEx("GetBaitPos", 600, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase2] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
	                 	KillTimer(BaitThrowTimer3[playerid]);
	                 	KillTimer(BaitThrowTimer4[playerid]);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 7.5 * floatsin(-ang, degrees), 7.5 * floatcos(-ang, degrees), 11);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("ExplodeBait", 4500, false, "i", playerid);
						SetTimerEx("GetBaitPos", 800, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase3] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
	                 	KillTimer(BaitThrowTimer4[playerid]);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 15 * floatsin(-ang, degrees), 15 * floatcos(-ang, degrees), 13);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("ExplodeBait", 4500, false, "i", playerid);
						SetTimerEx("GetBaitPos", 900, false, "i", playerid);
					}
					else if(PInfo[playerid][ThrowingBaitPhase4] == 1)
					{
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
						new Float:x, Float:y, Float:z, Float:ang;
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						PInfo[playerid][ZObject] = CreateObject(2908, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 270, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][ZObject]);
						PHY_SetObjectVelocity(PInfo[playerid][ZObject], 20 * floatsin(-ang, degrees), 20 * floatcos(-ang, degrees), 18);
						PHY_SetObjectFriction(PInfo[playerid][ZObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][ZObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][ZObject], z - 0.9, _, 0.0);
						SetTimerEx("ExplodeBait", 4500, false, "i", playerid);
						SetTimerEx("GetBaitPos", 1050, false, "i", playerid);
					}
 					PInfo[playerid][AllowedToBait] = 0;
 					if(PInfo[playerid][Premium] == 3) SetTimerEx("CanZombieBait",190,false,"i",playerid);
 					else SetTimerEx("CanZombieBait",280000,false,"i",playerid);
 					static string[99];
 					format(string,sizeof string,""cwhite"* "cjam"%s tosses some zombie bait with grenade inside.",GetPName(playerid));
					PInfo[playerid][Baiting] = 0;
 					SendNearMessage(playerid,white,string,20);
	                //SetTimerEx("ResetThrow",5000,false,"i",playerid);
				}
				for(new i ; i < MAX_PLAYERS; i ++)
				{
	   				PInfo[i][EatenBait] = 0;
				}
			}
			else if(PInfo[playerid][FlashBangs] >= 1)
			{
			    if(PInfo[playerid][Baiting] == 1)
			    {
				    if(PInfo[playerid][FlashBangThrowPhase] == 1)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase2]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase3]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase4]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase5]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase6]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 5 * floatsin(-ang, degrees), 5 * floatcos(-ang, degrees), 3);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
				    else if(PInfo[playerid][FlashBangThrowPhase] == 2)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase3]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase4]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase5]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase6]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 7.5 * floatsin(-ang, degrees), 7.5 * floatcos(-ang, degrees), 4);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 1); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
				    else if(PInfo[playerid][FlashBangThrowPhase] == 3)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase4]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase5]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase6]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 10.5 * floatsin(-ang, degrees), 10.5 * floatcos(-ang, degrees), 7);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
				    else if(PInfo[playerid][FlashBangThrowPhase] == 4)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase5]);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase6]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 13 * floatsin(-ang, degrees), 13 * floatcos(-ang, degrees), 10);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
				    else if(PInfo[playerid][FlashBangThrowPhase] == 5)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
					    KillTimer(PInfo[playerid][FlashBangTimerPhase6]);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 16 * floatsin(-ang, degrees), 16 * floatcos(-ang, degrees), 12.5);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
				    else if(PInfo[playerid][FlashBangThrowPhase] == 6)
				    {
						SetTimerEx("DestroyBait",500,false,"i",playerid);
						ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
						new Float:x, Float:y, Float:z, Float:ang, Float:newZ;
						new Float:Pos[2];
						new Float:SPos[4];
						GetPlayerPos(playerid, x, y, z);
						GetPlayerFacingAngle(playerid, ang);
						GetXYInFrontOfPoint(SPos[0], SPos[1], Pos[0], Pos[1], SPos[3], 0.5);
						CA_FindZ_For2DCoord(Pos[0], Pos[1],newZ);
						PInfo[playerid][FlashBangObject] = CreateObject(343, x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z, 90, 180, ang + 90);
					 	PHY_InitObject(PInfo[playerid][FlashBangObject]);
						PHY_SetObjectVelocity(PInfo[playerid][FlashBangObject], 20 * floatsin(-ang, degrees), 20 * floatcos(-ang, degrees), 16.5);
						PHY_SetObjectFriction(PInfo[playerid][FlashBangObject], 500); // This will stop the object when it touchs the ground.
						PHY_SetObjectGravity(PInfo[playerid][FlashBangObject], 50);
						PHY_SetObjectZBound(PInfo[playerid][FlashBangObject], z-0.9, _, 0.0);
					}
					PInfo[playerid][CanThrowFlashAgain] = 0;
					PInfo[playerid][Baiting] = 0;
					PInfo[playerid][FlashBangs] --;
					SetTimerEx("CanFlashAgain",2600,false,"i",playerid);
					new string[128];
					new Float:x,Float:y,Float:z;
					GetPlayerPos(playerid,x,y,z);
					format(string,sizeof string,"* "cjam"%s thrown flashbang!",GetPName(playerid));
					for(new i; i < MAX_PLAYERS; i++)
					{
					    if(!IsPlayerConnected(i)) continue;
					    if(PInfo[i][Logged] == 0) continue;
					    if(Team[i] == ZOMBIE) continue;
						if(!IsPlayerInRangeOfPoint(i,20,x,y,z)) continue;
					    SendClientMessage(i,white,string);
					}
				}
			}
		}
	}

	if(HOLDING(KEY_YES) || PRESSED(KEY_YES))
	{
		if(PInfo[playerid][Jailed])
		{
		    SendClientMessage(playerid,red,"You are jailed! You can't use perks!");
		    return 0;
		}
		if(Team[playerid] == HUMAN)
		{
		    if(PInfo[playerid][Training] == 1)
		    {
		        if(PInfo[playerid][TrainingPhase] == 7)
		        {
		            ShowPlayerDialog(playerid,13777,DSL,"Survivor perks","7\tBurst run","Choose","Cancel");
				}
			}
			else
				ShowPlayerHumanPerks(playerid);
		}
		if(Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][TrainingPhase] == 13)
		        ShowPlayerDialog(playerid,13778,DSL,"Zombie perks","3\tDigger\n5\tJumper","Choose","Cancel");
			else if(PInfo[playerid][TrainingPhase] == 14)
			    ShowPlayerDialog(playerid,13778,DSL,"Zombie perks","3\tDigger\n5\tJumper","Choose","Cancel");
			else
				ShowPlayerZombiePerks(playerid);
		}
	}
	if(HOLDING(KEY_SPRINT) && HOLDING(KEY_WALK))
	{
	    if(PInfo[playerid][Rank] >=15)
	    {
	    	if(PInfo[playerid][Logged] == 1)
	    	{
				ShowPlayerDialog(playerid,BoostingMenu,2,""cred"Boosting Menu",""cgreen"Human's "cwhite"perks\n"cpurple"Zombie's "cwhite"perks\n"cred"FAQ","Choose","Close");
			}
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
        if((PInfo[playerid][ZPerk] !=25) && (PInfo[playerid][ZPerk] != 5))
        {
            if(!IsPlayerInAnyVehicle(playerid))
            {
    			if(Team[playerid] == ZOMBIE)
				{
            		SendClientMessage(playerid,white,"* "cred"Click RIGHT MOUSE BUTTON To Bite!");
				}
			}
			else
			{
    			if(Team[playerid] == ZOMBIE)
				{
            		SendClientMessage(playerid,white,"* "cred"Click SPACE To Bite!");
				}
			}
		}
    }
	if(RELEASED (KEY_JUMP))
	{
	    if(Team[playerid] == HUMAN)
	    {
	        PInfo[playerid][PressingKeyShift] = 0;
		}
	}

    if(PRESSED(KEY_JUMP))
    {
        /*
  		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
  		if(strcmp(name, "Flexx", true) == 0)
		{
			SendClientMessage(playerid,white,""cred" ðåøèë ïîïðûãàòü àààà?");
			ApplyAnimation(playerid,"PED","KO_shot_front",2,0,0,0,1,0,1);
   			TogglePlayerControllable(playerid, 0);
   			SetPlayerPos(playerid,321312132312,321132132321321,132321321323);
			SetTimerEx("UnFreezePlayer", 900, false, "i", playerid);
		}*/
        if(Team[playerid] == HUMAN)
        {
	        if((GetPlayerWeapon(playerid) == 31) || (GetPlayerWeapon(playerid) == 30))
	        {
	            PInfo[playerid][PressingKeyShift] = 1;
			}
			if(PInfo[playerid][JumpsHops] == 5)
			{
			    if(PInfo[playerid][Rank] < 10)
			    {
			        if(!IsPlayerInAnyVehicle(playerid))
			        {
			            if(PInfo[playerid][Training] == 1)
						{
						    if(PInfo[playerid][Waswarnedbh] == 0)
						    {
								ShowPlayerDialog(playerid,20142,DSM,""cred"Warning!",""cred"You must to know that BHop (BunnyHop) for gaining speed \nIs not allowed on server\nAdmins can warn you if you do that while you will run from zombies!","OK","");
								PInfo[playerid][Waswarnedbh] = 1;
							}
						}
						else
						{
				    		SendClientMessage(playerid,white,"**"cred"Don't BunnyHop or you will be punished!"cwhite"**");
				    		PInfo[playerid][JumpsHops] = 0;
						}
					}
				}
			}
			else
			{
			    KillTimer(PInfo[playerid][KillTimerBHOP]);
			    PInfo[playerid][KillTimerBHOP] = SetTimerEx("TimerKillBhop",4000,false,"i",playerid);
			    PInfo[playerid][JumpsHops] ++;
			}
            if(PInfo[playerid][SPerk] == 14)
            {
	            if(GetTickCount() - PInfo[playerid][CanJump] < 8000) return 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            WaitAirCheat[playerid]=2;
	            PInfo[playerid][CanJump] = GetTickCount();
				SetPlayerAttachedObject(playerid,5,18702,9,0.00,0.00,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Left foot
				SetPlayerAttachedObject(playerid,6,18702,10,0.00,-0.09,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Right foot
				SetTimerEx("DestroyFires",850,false,"i",playerid);
			}
			else if(PInfo[playerid][SPerk] == 24)
			{
                if(GetTickCount() - PInfo[playerid][CanJump] < 13000 && PInfo[playerid][Jumps] >= 2) return 0;
                if(GetTickCount() - PInfo[playerid][CanJump] > 13000 && PInfo[playerid][Jumps] >= 2) PInfo[playerid][Jumps] = 0;
                if(PInfo[playerid][Jumps] == 0)
                {
					SetPlayerAttachedObject(playerid,5,18702,9,0.00,0.00,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Left foot
					SetPlayerAttachedObject(playerid,6,18702,10,0.00,-0.09,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Right foot
					SetTimerEx("CreateExplosionFires",900,false,"i",playerid);
				}
			 	if(PInfo[playerid][Jumps] == 1)
                {
					RemovePlayerAttachedObject(playerid, 5);
				    RemovePlayerAttachedObject(playerid, 6);
					SetPlayerAttachedObject(playerid,5,18694,9,0.00,0.00,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Left foot
					SetPlayerAttachedObject(playerid,6,18694,10,0.00,-0.09,-1.63,0.0,0.0,0.0,1.00,1.00,1.00);//Right foot
					SetTimerEx("DestroyFires",1050,false,"i",playerid);
				}
	            PInfo[playerid][CanJump] = GetTickCount();
	            PInfo[playerid][Jumps]++;
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            WaitAirCheat[playerid]=2;
	            PInfo[playerid][CanJump] = GetTickCount();
            }
        }
        if(Team[playerid] == ZOMBIE)
        {
            if((PInfo[playerid][ZPerk] == 4) || ((PInfo[playerid][FakePerk] == 2) &&(PInfo[playerid][Training] == 1)))
            {
	            if(GetTickCount() - PInfo[playerid][CanJump] < 3500) return 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            WaitAirCheat[playerid]=2;
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
	            WaitAirCheat[playerid]=2;
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
	            WaitAirCheat[playerid]=2;
	            PInfo[playerid][CanJump] = GetTickCount();
            }
            else if(PInfo[playerid][ZPerk] == 27)
           {
                if(GetTickCount() - PInfo[playerid][CanJump] < 20000 && PInfo[playerid][Jumps] >= 13) return 0;
                if(GetTickCount() - PInfo[playerid][CanJump] > 20000 && PInfo[playerid][Jumps] >= 13) PInfo[playerid][Jumps] = 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            PInfo[playerid][Jumps]++;
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            WaitAirCheat[playerid]=2;
	            PInfo[playerid][CanJump] = GetTickCount();
            }
        }
    }
    if((PRESSED(KEY_JUMP)) && (newkeys & 128))
    {
        if(Team[playerid] == HUMAN)
        {
            if(PInfo[playerid][AssaultGrenades] >=1)
            {
                if((GetPlayerWeapon(playerid) == 31) || (GetPlayerWeapon(playerid) == 30))
                {
                	if(PInfo[playerid][CanGrenadeAgain] == 1)
                	{
				  		new Float:fPX,
							Float:fPY,
							Float:fPZ;
				        GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
				        new Float:fVX,
							Float:fVY,
							Float:fVZ;
				        GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);
			         	const Float:fScale = 5.0;
				        new Float:object_x = fPX + floatmul(fVX, fScale);
				        new Float:object_y = fPY + floatmul(fVY, fScale);
				        new Float:object_z = fPZ + floatmul(fVZ, fScale);

						new proj = Projectile(object_x, object_y, object_z, GRENADE_SPEED * fVX, GRENADE_SPEED * fVY, (GRENADE_SPEED * fVZ) + 5.0, .air_resistance = 1.0, .sphere_radius = 0.010, .gravity = 15.0);
			            if (proj == -1) return 1;
						new obj = CreateDynamicObject(GRENADE_OBJECT, object_x, object_y, object_z + 0.5, 0, 0, 0);
			            if (obj == INVALID_OBJECT_ID)
			            {
							StopProjectile(proj);
			                return 1;
						}
			            GrenadesObject[playerid][grenadesCount[playerid] ++] = obj;
			            Streamer_SetIntData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_EXTRA_ID, proj);
						for (new i, j = GetPlayerPoolSize(); i <= j; i++)
						{
							Streamer_UpdateEx(i, object_x, object_y, object_z, .type = STREAMER_TYPE_OBJECT);
						}
			            PInfo[playerid][AssaultGrenades]--;
			            PInfo[playerid][CanGrenadeAgain] = 0;
				    	ApplyAnimation(playerid,"BUDDY","buddy_fire_poor",3,0,1,1,0,0,1);
				    	new Float:X,Float:Y,Float:Z;
				    	GetPlayerPos(playerid,X,Y,Z);
				    	for(new i; i < MAX_PLAYERS; i++)
				    	{
				    	    if(!IsPlayerConnected(i)) continue;
				    	    if(PInfo[i][Logged] == 0) continue;
							if(!IsPlayerInRangeOfPoint(i,10,X,Y,Z)) continue;
				    		PlayerPlaySound(i,16200,X,Y,Z);
						}
					}
				}
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
				static string[901];
				SetTimerEx("PowerfulGlovesSound",350,false,"i",playerid);
				format(string,sizeof string,""cjam"%s hit the ground with his powerful gloves",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][CanPowerfulGloves] = 0;
				if(PInfo[playerid][Premium] == 3) PInfo[playerid][PowerfulGlovesTimer] = SetTimerEx("AllowedToPowerfulGloves",90000,false,"i",playerid);
				else PInfo[playerid][PowerfulGlovesTimer] = SetTimerEx("AllowedToPowerfulGloves",80000,false,"i",playerid);
				for(new i; i < MAX_PLAYERS;i++)
				{
    				new Float:ax,Float:ay,Float:az;
					GetPlayerPos(playerid,ax,ay,az);
					if(!IsPlayerConnected(i)) continue;
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
						      		ApplyAnimation(i,"PED","KO_skid_front",1.5,0,0,0,0,1250,1);
									SetPlayerVelocity(i,-x,-y,z+0.15);
								}
			            	}//////////*/
						}
						SetTimerEx("PowerfulGlovesThrow",400,false,"i",i,ax,ay,az);
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
				if(id > -1)
				{
					static Float:health;
					GetVehicleHealth(id,health);
					if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't neet to repair!");
					TurnPlayerFaceToPos(playerid, x-270, y-270);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					static string[100];
				    format(string,sizeof string,""cjam"%s has tweaked his vehicle.",GetPName(playerid));
					SendNearMessage(playerid,white,string,20);
					SetVehicleHealth(id,health+250.0);
				}
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
				if(id > -1)
				{
					static Float:health;
					GetVehicleHealth(id,health);
					if(health >= 500.0) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't need to repair!");
					TurnPlayerFaceToPos(playerid, x-270, y-270);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					static string[100];
				    format(string,sizeof string,""cjam"%s has fixed his vehicle.",GetPName(playerid));
					SendNearMessage(playerid,white,string,20);
					RepairVehicle(id);
					SetVehicleHealth(id,1000.0);
				}
			}
			if(Mission[playerid] == 1)
			{
				if(MissionPlace[playerid][1] == 1) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 1)
				    {
        				if(IsPlayerInRangeOfPoint(playerid,4.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some cloth for your molotovs.");
									MissionPlace[playerid][0] = 3;
									MissionPlace[playerid][1] = 2;
									SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],19,0,MAPICON_GLOBAL);
         							SecondStepMolotov[playerid] = CreatePickup(2386,1,213.0049,-103.5259,1005.2578,0);
									DestroyPickup(FirstStepMolotov[playerid]);
								}
								case 1:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some cloth for your molotovs.");
									MissionPlace[playerid][0] = 4;
								 	MissionPlace[playerid][1] = 2;
								 	SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],19,0,MAPICON_GLOBAL);
 									SecondStepMolotov[playerid] = CreatePickup(2386,1,175.6414,-83.1425,1001.8047,0);
									DestroyPickup(FirstStepMolotov[playerid]);
								}
							}
				        }
				    }
				    else if(MissionPlace[playerid][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(playerid,4.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
				            	case 0:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some cloth for your molotovs.");
									MissionPlace[playerid][0] = 3;
									MissionPlace[playerid][1] = 2;
									SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],19,0,MAPICON_GLOBAL);
                           			SecondStepMolotov[playerid] = CreatePickup(2386,1,213.0049,-103.5259,1005.2578,0);
									DestroyPickup(FirstStepMolotov[playerid]);
								}
								case 1:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some cloth for your molotovs.");
								 	MissionPlace[playerid][0] = 4;
								 	MissionPlace[playerid][1] = 2;
								 	SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],19,0,MAPICON_GLOBAL);
									SecondStepMolotov[playerid] = CreatePickup(2386,1,175.6414,-83.1425,1001.8047,0);
									DestroyPickup(FirstStepMolotov[playerid]);
								}
							}
       					}
				    }
				}
				if(MissionPlace[playerid][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,4.0,Locations[2][0],Locations[2][1],Locations[2][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some inflamable liquid.");
									MissionPlace[playerid][0] = 5;
									MissionPlace[playerid][1] = 3;
									SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],53,0,MAPICON_GLOBAL);
  									ThirdStepMolotov[playerid] = CreatePickup(2043,1,169.9776,-1797.8832,4.1339,0);
									DestroyPickup(SecondStepMolotov[playerid]);
								}
								case 1:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get some inflamable liquid.");
									MissionPlace[playerid][0] = 6;
									MissionPlace[playerid][1] = 3;
									SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],53,0,MAPICON_GLOBAL);
         							ThirdStepMolotov[playerid] = CreatePickup(2043,1,2164.6807,-1985.9213,13.5547,0);
                                    DestroyPickup(SecondStepMolotov[playerid]);
								}
							}
						}
					}
					else if(MissionPlace[playerid][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,3.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            new rand = random(2);
 							switch(rand)
							{
							    case 0:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some inflamable liquid.");
									MissionPlace[playerid][0] = 5;
									MissionPlace[playerid][1] = 3;
									SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],53,0,MAPICON_GLOBAL);
									ThirdStepMolotov[playerid] = CreatePickup(2043,1,169.9776,-1797.8832,4.1339,0);
									DestroyPickup(SecondStepMolotov[playerid]);
								}
								case 1:
								{
									SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get some inflamable liquid.");
									MissionPlace[playerid][0] = 6;
								 	MissionPlace[playerid][1] = 3;
									SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],53,0,MAPICON_GLOBAL);
                                    ThirdStepMolotov[playerid] = CreatePickup(2043,1,2164.6807,-1985.9213,13.5547,0);
                                    DestroyPickup(SecondStepMolotov[playerid]);
								}
							}
				        }
					}
				}
				if(MissionPlace[playerid][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[playerid][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,3.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 Molotovs. Use them carefuly!");
				            GivePlayerWeapon(playerid,18,3);
				            RemovePlayerMapIcon(playerid,1);
    						Mission[playerid] = 0;
    						DestroyPickup(ThirdStepMolotov[playerid]);
				        }
					}
					else if(MissionPlace[playerid][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(playerid,3.0,Locations[5][0],Locations[5][1],Locations[5][2]))
				        {
				            ApplyAnimation(playerid,"KISSING","gift_give",3.0,0,1,1,1,2000,1);
				            SendClientMessage(playerid,white,"* "cblue"You have created 3 Molotovs. Use them carefuly!");
				            GivePlayerWeapon(playerid,18,3);
				            RemovePlayerMapIcon(playerid,1);
				            DestroyPickup(ThirdStepMolotov[playerid]);
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
				        if(IsPlayerInRangeOfPoint(playerid,3.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some fuse for your betty's."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],19,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some fuse for your betty's."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],19,0,MAPICON_GLOBAL);
							}
				        }
				    }
				    else if(MissionPlace[playerid][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(playerid,1.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            new rand = random(2);
							switch(rand)
							{
				            	case 0: SendClientMessage(playerid,white,"* "corange"Now head over to Binco to get some fuse for your betty's."), MissionPlace[playerid][0] = 3, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[2][3],Locations[2][4],Locations[2][5],19,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to ZIP to get some fuse for your betty's."), MissionPlace[playerid][0] = 4, MissionPlace[playerid][1] = 2,SetPlayerMapIcon(playerid,1,Locations[3][3],Locations[3][4],Locations[3][5],19,0,MAPICON_GLOBAL);
				        	}
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
							    case 0: SendClientMessage(playerid,white,"* "corange"Now head over to The Beach to get some cans for your betty's."), MissionPlace[playerid][0] = 5, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[4][3],Locations[4][4],Locations[4][5],53,0,MAPICON_GLOBAL);
								case 1: SendClientMessage(playerid,white,"* "corange"Now head over to The Waste Industrial to get cans for your betty's."), MissionPlace[playerid][0] = 6, MissionPlace[playerid][1] = 3,SetPlayerMapIcon(playerid,1,Locations[5][3],Locations[5][4],Locations[5][5],53,0,MAPICON_GLOBAL);
							}
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
			    if(IsPlayerInRangeOfPoint(playerid,2.0,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2]))
				{
				    id = j;
				    break;
				}
			}
			if(id == -1) return 0;
			else
			{
				PInfo[playerid][Searching] = GetTickCount();
				ApplyAnimation(playerid,"COP_AMBIENT","copbrowse_out",2,0,0,0,0,0,1);
				new rand = random(5);
				if(rand == 0)
				{
				    PInfo[playerid][FoundBullets] = 1;
					SearchForBullets(playerid);
				}
				if(PInfo[playerid][SPerk] == 18)
    				SearchInsideWith19Perk(playerid);
				else
				    SearchInside(playerid);
			}
		}
		if(Team[playerid] == ZOMBIE)
		{
  			if(PInfo[playerid][ZPerk] == 2)
    		{
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
          		new id = -1;
		        id = GetClosestPlayer(playerid,2000);
				if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"Zombies are too close to dig!");
				if(PInfo[id][Logged] == 0) return 1;
				if(PInfo[id][SPerk] == 28) return 1;
				if(id == -1) return SendClientMessage(playerid,red,"There are no survivors left...");
				PInfo[playerid][CanDig] = 0;
				PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
		    }
		    if(PInfo[playerid][Training] == 1)
		    {
		        if(PInfo[playerid][TrainingPhase] == 14)
		        {
		            if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
                    PInfo[playerid][CanDig] = 0;
                    SetTimerEx("DigToTrainingVehicle",3000,false,"i",playerid);
                    ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
				}
			}
		    if(PInfo[playerid][ZPerk] == 26)
		    {
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
          		new id = -1;
          		id = GetClosestPlayer(playerid,2000);
          		if(PInfo[id][Logged] == 0) return 1;
          		if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"Zombies are too close to dig!");
          		if(PInfo[id][SPerk] == 28) return 1;
          		if(id == -1) return SendClientMessage(playerid,red,"There are no survivors left...");
          		if(PInfo[playerid][Premium] == 2)
          		    PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",140000,false,"i",playerid);
		  		else
				  	PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",160000,false,"i",playerid);
          		PInfo[playerid][CanDig] = 0;
				SetTimerEx("DigToPlayer27perk",1500,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",1.5,0,0,0,1,3000,1);
		    }
		    if(PInfo[playerid][ZPerk] == 2)
		    {
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
          		new id = -1;
		        id = GetClosestPlayer(playerid,2000);
				if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"Zombies are too close to dig!");
				if(PInfo[id][Logged] == 0) return 1;
				if(PInfo[id][SPerk] == 28) return 1;
				if(id == -1) return SendClientMessage(playerid,red,"There are no survivors left...");
				PInfo[playerid][CanDig] = 0;
				PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
		    }
		    if(PInfo[playerid][ZPerk] == 28)
		    {
		        if(!IsPlayerInAnyVehicle(playerid))
		        {
		        	if(PInfo[playerid][MeatForShare] == 0) return SendClientMessage(playerid,white,"** "cred"Your stomach is empty! You need to infect human for share meat!");
		        	if(PInfo[playerid][ShareMeatVomited] == 1) return SendClientMessage(playerid,white,"** "cred"You have already vomited meat for share, your previous meat must be eaten to vomit meat for share again!");
		        	new Float:x,Float:y,Float:z;
		        	GetPlayerPos(playerid,x,y,z);
					PInfo[playerid][MeatSX] = x;
					PInfo[playerid][MeatSY] = y;
					PInfo[playerid][MeatSZ] = z;
					ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
					PInfo[playerid][MeatForShare] --;
					PInfo[playerid][ShareMeatVomited] = 1;
					SetTimerEx("VomitShareMeat",4500,false,"i",playerid);
				}
			}
		    if(PInfo[playerid][ZPerk] == 14)
		    {
		        if(PInfo[playerid][GodDig] == 1) return SendClientMessage(playerid,red,"You are tired to dig!");
		        new id = -1,count = 0;
		        goto func;
		        func:
		        {
					new rand = random(PlayersConnected);
					if(Team[rand] == ZOMBIE)
					{
					    if(!IsPlayerConnected(rand)) goto func;
					    if(PInfo[rand][Jailed] == 1) goto func;
					    if(PInfo[rand][Spawned] == 0) goto func;
					    if(PInfo[rand][Training] == 1) goto func;
						if(count >= 1 || RoundEnded == 1 || PlayersConnected == 0) return SendClientMessage(playerid,white,"* "cred"All survivors dead!");
						else
						{
						    count++;
							goto func;
						}
					}
					else id = rand;
		        }
				if(id == -1) return SendClientMessage(playerid,red,"Looks like that there no survivors left!");
				PInfo[playerid][GodDig] = 1;
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
		 		INI_Open("Admin/Goddigged.txt");
	    		INI_WriteInt(GetPName(playerid),PInfo[playerid][GodDig]);
				INI_Save();
				INI_Close();
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
				static string[120];
			 	format(string,sizeof string,"%s(%i) has used a God Dig. Keep an eye on him. || Only 1 God Dig Per Round!",GetPName(playerid),playerid);
				SendAdminMessage(red,string);
		    }
		    if(PInfo[playerid][ZPerk] == 7)
		    {
		        if((GetTickCount() - PInfo[playerid][Allowedtovomit]) < VOMITTIME) return SendClientMessage(playerid,red,"You haven't got enough meat in your stomach!");
                new Float:x,Float:y,Float:z;
                KillTimer(PInfo[playerid][VomitDamager]);
		        GetPlayerPos(playerid,x,y,z);
		        PInfo[playerid][Vomitx] = x;
		        PInfo[playerid][Vomity] = y;
		        PInfo[playerid][Vomitz] = z;
		        ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
				new rand = random(6);
				switch(rand)
				{
			    	case 0: PInfo[playerid][VomitRandomMeat] = 0;
			    	case 1: PInfo[playerid][VomitRandomMeat] = 1;
			    	case 2: PInfo[playerid][VomitRandomMeat] = 2;
			    	case 3: PInfo[playerid][VomitRandomMeat] = 3;
			    	case 4: PInfo[playerid][VomitRandomMeat] = 4;
			    	case 5: PInfo[playerid][VomitRandomMeat] = 5;
			    }
		        SetTimerEx("VomitPlayer",4500,false,"i",playerid);
			}
			if(PInfo[playerid][ZPerk] == 12)
			{
			    if(PInfo[playerid][CanStomp] == 0) return SendClientMessage(playerid,red,"You a not rested enough to use Stomper!");
				ApplyAnimation(playerid,"PED","FIGHTA_G",5.0,0,0,0,0,700,1);
				static Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				PInfo[playerid][CanStomp] = 0;
				if(PInfo[playerid][Premium] == 3) PInfo[playerid][StompTimer] = SetTimerEx("AllowedToStomp",110000,false,"i",playerid);
				else PInfo[playerid][StompTimer] = SetTimerEx("AllowedToStomp",120000,false,"i",playerid);
				for(new i; i < MAX_PLAYERS;i++)
				{
					if(!IsPlayerConnected(i)) continue;
					if(Team[i] == ZOMBIE) continue;
					if(IsPlayerInRangeOfPoint(i,15,x,y,z))
					{
					    if(!IsPlayerInAnyVehicle(i))
					    {
					    	TogglePlayerControllable(i,0);
					    	if(PInfo[i][Stomped] == 1)
					    	{
								SetTimerEx("RemoveStomp",1250,false,"i",i);
								KillTimer(PInfo[i][CanBeStompedTimer]);
							}
							else if(PInfo[i][Stomped] == 0)
							    SetTimerEx("RemoveStomp",3500,false,"i",i);
							static string[90];
				 			format(string,sizeof string,""cjam"%s has been knocked to the ground by the powerful force!",GetPName(i));
							SendNearMessage(playerid,white,string,30);
							PInfo[i][CanBeStompedTimer] = SetTimerEx("CanBeStompedAgain",1100,false,"i",i);
							PInfo[i][Stomped] = 1;
							ApplyAnimation(i,"PED","KO_shot_front",2,0,1,1,0,0,1);
						}
					}
				}
			}
			if(PInfo[playerid][ZPerk] == 20)
			{
			    if(PInfo[playerid][CanPop] == 0) return SendClientMessage(playerid,red,"You haven't got enough power to pop again!");
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
				if(id == -1) return SendClientMessage(playerid,white,"** "cred"You are too far from the vehicle!");
				PInfo[playerid][CanPop] = 0;
				SetTimerEx("ClearAnim2",3000,false,"ii",playerid,id);
				if(PInfo[playerid][Premium] == 3) SetTimerEx("PopAgain",110000,false,"i",playerid);
				else SetTimerEx("PopAgain",120000,false,"i",playerid);
				ApplyAnimation(playerid,"RIFLE","RIFLE_crouchload",0.5,0,0,0,1,0,1);
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
	    if(PInfo[playerid][SPerk] == 27)
	    {
	        if(Team[playerid] == ZOMBIE) return 0;
	        if(PInfo[playerid][CanPlaceFlag] == 0) return SendClientMessage(playerid,white,"* "cred"Your flag is not charged yet!");

	        static Float:x,Float:y,Float:z;
	        PInfo[playerid][CanPlaceFlag] = 0;
	        GetPlayerPos(playerid,x,y,z);
			for(new i; i < MAX_PLAYERS; i ++)
			{
			    if(IsPlayerInRangeOfPoint(playerid,15,PInfo[i][FlagX],PInfo[i][FlagY],PInfo[i][FlagZ])) return SendClientMessage(playerid,white,"* "cred"You are too close to another flag, please set it in other place!");
				new string[128];
				format(string, sizeof string, "* "cjam"%s has placed a medical flag, enter it if you need medical help!",GetPName(playerid));
				SendClientMessage(i,white,string);
			}
			PInfo[playerid][Flag1] = CreateObject(2914,x,y,z-0.9,0,0,0,300);
			PInfo[playerid][Flag2] = CreateObject(6964,x,y,z-1.7,0,0,0,300);
			SetObjectMaterial(PInfo[playerid][Flag2],0,19836,"none","none",0xFF0000FF);
			GetObjectPos(PInfo[playerid][Flag1],PInfo[playerid][FlagX],PInfo[playerid][FlagY],PInfo[playerid][FlagZ]);
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
			PInfo[playerid][FlagsHPTimer] = SetTimerEx("FeelHPFlag",3000,true,"i",playerid);
			SetTimerEx("DestroyFlag",50000,false,"i",playerid);
			SetTimerEx("RestoreFlag",340000,false,"i",playerid);
		}
		if(PInfo[playerid][SPerk] == 15)
		{
		    if(Team[playerid] == ZOMBIE) return 0;
		    if(PInfo[playerid][CanFlare] == 0) return SendClientMessage(playerid,white,"* "cred"You haven't got a signal flare yet.");
		    static Float:x,Float:y,Float:z;
		    GetPlayerPos(playerid,x,y,z);
            DestroyDynamicMapIcon(PInfo[playerid][BeaconMarker]);
            new rand = random(5);
            switch(rand)
            {
                case 0:
                {
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,58,0,-1,-1,-1,15000);
				}
                case 1:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,59,0,-1,-1,-1,15000);
				}
				case 2:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,60,0,-1,-1,-1,15000);
				}
                case 3:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,61,0,-1,-1,-1,15000);
				}
                case 4:
                {
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,62,0,-1,-1,-1,15000);
				}
			}
			DestroyObject(PInfo[playerid][Flare]);
			PInfo[playerid][CanFlare] = 0;
			SetTimerEx("CanItFlare",60000,false,"i",playerid);
			PInfo[playerid][Flare] = CreateObject(18728,x,y,z-2,0,0,0,200);
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
	  		    static Float:ax,Float:ay,Float:az;
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
				GetPlayerPos(i,ax,ay,az);
	  			if(IsPlayerInRangeOfPoint(playerid,5,ax,ay,az))
      			{
	      			static Float:Health;
		            GetPlayerHealth(i,Health);
		            MakeHealthEven(i,Health);
		  			DamagePlayer(playerid,i);
				 	if(PInfo[playerid][ZPerk] == 3)
					{
						GetPlayerHealth(playerid,Health);
						if(PInfo[playerid][Rank] < 5)
						{
							if(Health <= 125.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
						{
							if(Health <= 150.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
						{
							if(Health <= 175.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
						{
							if(Health <= 200.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if(PInfo[playerid][Rank] > 20)
						{
							if(Health <= 225.0)
								SetPlayerHealth(playerid,Health+7);
						}
					}
					else if(PInfo[playerid][ZPerk] == 21)
					{
						GetPlayerHealth(playerid,Health);
						if(PInfo[playerid][Rank] < 5)
						{
							if(Health <= 125.0)
								SetPlayerHealth(playerid,Health+10);
						}
						if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
						{
							if(Health <= 150.0)
								SetPlayerHealth(playerid,Health+10);
						}
						if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
						{
							if(Health <= 175.0)
								SetPlayerHealth(playerid,Health+10);
						}
						if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
						{
							if(Health <= 200.0)
								SetPlayerHealth(playerid,Health+10);
						}
						if(PInfo[playerid][Rank] > 20)
						{
							if(Health <= 225.0)
								SetPlayerHealth(playerid,Health+10);
						}
					}
					else if(PInfo[playerid][ZPerk] == 18)
					{
						GetPlayerHealth(playerid,Health);
						if(PInfo[playerid][Rank] < 5)
						{
							if(Health <= 125.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
						{
							if(Health <= 150.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
						{
							if(Health <= 175.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
						{
							if(Health <= 200.0)
								SetPlayerHealth(playerid,Health+7);
						}
						if(PInfo[playerid][Rank] > 20)
						{
							if(Health <= 225.0)
								SetPlayerHealth(playerid,Health+7);
						}
					}
					else
					{
						if(PInfo[playerid][ZPerk] != 18)
						{
							GetPlayerHealth(playerid,Health);
							if(PInfo[playerid][Rank] < 5)
							{
								if(Health <= 125.0)
									SetPlayerHealth(playerid,Health+5);
							}
							if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
							{
								if(Health <= 150.0)
									SetPlayerHealth(playerid,Health+5);
							}
							if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
							{
								if(Health <= 175.0)
									SetPlayerHealth(playerid,Health+5);
							}
							if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
							{
								if(Health <= 200.0)
									SetPlayerHealth(playerid,Health+5);
							}
							if(PInfo[playerid][Rank] > 20)
							{
								if(Health <= 225.0)
									SetPlayerHealth(playerid,Health+5);
							}
						}
					}
					if(PInfo[playerid][ZPerk] == 29)
					{
					    if(PInfo[playerid][ToxicBites] > 0)
					    {
					        if(PInfo[i][Poisoned] == 0)
					        {
					            PInfo[playerid][ToxicBites] --;
					            PInfo[i][Poisoned] = 1;
					            SetTimerEx("WierdAnimation",1500,false,"i",i);
					            SetTimerEx("CanBePoisonedAgain",60000,false,"i",i);
								new stranng[144];
								GetPlayerPos(playerid,x,y,z);
								format(stranng,sizeof stranng,"* "cjam"%s poisoned by %s by toxic bite",GetPName(i),GetPName(playerid));
								for(new l; l < MAX_PLAYERS; l++)
								{
								    if(!IsPlayerConnected(l)) continue;
									if(IsPlayerInRangeOfPoint(l,15,x,y,z))
										SendClientMessage(l,white,stranng);
								}
								SendClientMessage(i,white,"* "dred"You are poisoned, use Dizzy Away Pills to decrease effect of toxin!");
					            PInfo[i][PoisonDizzy] = 1;
					            SetPlayerWeather(i,1447);
					            SetPlayerDrunkLevel(i,4000);
					            SetTimerEx("KillTimerOfPoison",30000,false,"i",i);
					            PInfo[i][ToxinTimer] = SetTimerEx("ToxinPlayer",2500,true,"ii",i,playerid);
							}
						}
					}
					if(PInfo[playerid][ZPerk] == 23)
					{
					    if(PInfo[i][CanBeBlinded] == 1)
					    {
					        PInfo[i][CanBeBlinded] = 0;
					        SetTimerEx("BlindPlayer",10,0,"i",i);
					        SetTimerEx("AllowToBlinded",6250,false,"i",i);
						}
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
								{
									ApplyAnimation(i,"PED","DAM_Stomach_frmFT",0.5,0,0,0,0,0,1);
									SetTimerEx("StingerPhase1", 800, false, "i", i);
									SetTimerEx("StingerPhase2", 1300, false, "i", i);
									PInfo[i][CanStinger] = 0;
									SetTimerEx("CanBeStingeredTime", 7000, false, "i", i);
								}
							}
						}
					}
				}
			}
		}
	}
	if(PRESSED(KEY_SPRINT))
	{
	    if(PInfo[playerid][Spectating] == 1)
	    {
	        if(!IsPlayerConnected(PInfo[playerid][SpecID]))
	        {
	            SendClientMessage(playerid,white,"* "cred"Player, who you were spectating left the server, you were automatically stopped spectating");
				for(new i;i < MAX_PLAYERS; i ++)
			    {
			        if(PInfo[i][Level] >= 1)
			        {
						static string[128];
						format(string,sizeof string,""cred"Administrator %s stopped spectating",GetPName(playerid));
						SendClientMessage(i,white,string);
					}
				}
				TogglePlayerSpectating(playerid, 0);
			 	SetCameraBehindPlayer(playerid);
			 	SetTimerEx("restorpos",1500,false,"i",playerid);
			 	PInfo[playerid][SpecID] = -1;
			 	SendClientMessage(playerid,white,""cred"You've stopped spectate");
			}
			else
			{
	        	SendClientMessage(playerid,white,"* "cred"Successfully updated");
		  		if(GetPlayerState(PInfo[playerid][SpecID]) == 1)
			   	{
			        SetPlayerInterior(playerid,GetPlayerInterior(PInfo[playerid][SpecID]));
			        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PInfo[playerid][SpecID]));
			        TogglePlayerSpectating(playerid, 1);
			        PlayerSpectatePlayer(playerid, PInfo[playerid][SpecID]);
			    }
			    else if(GetPlayerState(PInfo[playerid][SpecID]) == 2)
			    {
			        SetPlayerInterior(playerid,GetPlayerInterior(PInfo[playerid][SpecID]));
			        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PInfo[playerid][SpecID]));
			        new idid = GetPlayerVehicleID(PInfo[playerid][SpecID]);
			        TogglePlayerSpectating(playerid, 1);
			        PlayerSpectateVehicle(playerid, idid);
			    }
			    else if(GetPlayerState(PInfo[playerid][SpecID]) == 3)
			    {
			        SetPlayerInterior(playerid,GetPlayerInterior(PInfo[playerid][SpecID]));
			        SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(PInfo[playerid][SpecID]));
			        new idid = GetPlayerVehicleID(PInfo[playerid][SpecID]);
			        TogglePlayerSpectating(playerid, 1);
			        PlayerSpectateVehicle(playerid, idid);
			    }
			}
		}
	    if(Team[playerid] == ZOMBIE)
	    {
			if(!IsPlayerInAnyVehicle(playerid))
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
				if(PInfo[playerid][RunTimerActivated] == 0) PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",50000,false,"ii",playerid,1),PInfo[playerid][RunTimerActivated] = 1;
	        }
	        if(PInfo[playerid][Swimming] == 1)
	        {
	            new Float:health;
	            GetPlayerHealth(playerid,health);
            	PInfo[playerid][Infected] = 1;
				SetPlayerHealth(playerid,health-4);
				SendClientMessage(playerid,orange,"GO OUT FROM THE WATER, IT IS INFECTED!!!");
				if(health <= 4)
				{
    				SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
				    SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
				    InfectPlayer(playerid);
				}
			}
	    }
	}
	else if((RELEASED(KEY_SPRINT)) && !(newkeys & KEY_JUMP))
	{
	    if(Team[playerid] == ZOMBIE)
	    {
	        //ApplyAnimation(playerid,"PED","run_gang1",20,1,0,0,1,1,1);
	        ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	    }
	    else if(Team[playerid] == HUMAN)
	    {
	        if(PInfo[playerid][SPerk] == 8)
	        {
	            if(PInfo[playerid][CanRun] == 0) return 0;
     			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
			}
	    }
	}
	if(HOLDING(KEY_NO) || PRESSED(KEY_NO))
    {
        if(Team[playerid] == HUMAN)
        	ShowInventory(playerid);
		else
		{
			if(PInfo[playerid][CanUseRage] == 0) return SendClientMessage(playerid,white,"** "cred"You haven't got enough rage to call a surge of enormous energy!");
   			if(PInfo[playerid][RageMode] == 1)
		    {
		        PInfo[playerid][RageMode] = 0;
		        KillTimer(RageModeTimer[playerid]);
		        SendClientMessage(playerid,white,"** "cred"You have turned off your rage mode, press N to use it again!");
                RemovePlayerAttachedObject(playerid,2);
			}
			else if((PInfo[playerid][RageMode] == 0) && (PInfo[playerid][CanUseRage] == 1))
		    {
                PInfo[playerid][RageMode] = 1;
                new rand = random(2);
                {
                	if(rand == 0)
						ApplyAnimation(playerid,"PED","FIGHTA_G",5.0,0,0,0,0,700,1);
					if(rand == 1)
                		ApplyAnimation(playerid,"FIGHT_B","FightB_G",5.0,1,0,0,0,700,1);
				}
                new Float:x,Float:y,Float:z;
                GetPlayerPos(playerid,x,y,z);
                SetPlayerAttachedObject(playerid,2,18688,2,-0.5,0,-1.75,0,0,0,1,1,1);
                for(new i; i < MAX_PLAYERS; i ++)
				{
				    if(IsPlayerInRangeOfPoint(playerid,15,x,y,z))
				    	PlaySound(i,32400);
				}
				CreateFakeExplosion(18683,x,y,z-1.25);
				if(PInfo[playerid][Rank] <= 5)
				{
					RageModeTimer[playerid] = SetTimerEx("RageTime",2100,true,"i",playerid);
				}
				if((PInfo[playerid][Rank] > 5) && (PInfo[playerid][Rank] <= 13))
				{
				    RageModeTimer[playerid] = SetTimerEx("RageTime",1650,true,"i",playerid);
				}
				if(PInfo[playerid][Rank] > 13)
				{
				    RageModeTimer[playerid] = SetTimerEx("RageTime",1200,true,"i",playerid);
				}
			}
		}
    }
	if(PRESSED(KEY_FIRE))
	{
	    if(PInfo[playerid][StartCar] == 1) return 0;
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
	    if(IsVehicleStarted(GetPlayerVehicleID(playerid))) return 0;
		if(Fuel[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,white,"* "cred"This vehicle is out of fuel!");
		if(Oil[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,white,"* "cred"This vehicle is out of oil!");
		static Float:health;
		GetVehicleHealth(GetPlayerVehicleID(playerid),health);
		if(health <= 300) return SendClientMessage(playerid,white,"* "cred"Engine is too damaged to start!");
		SetTimerEx("Startvehicle",3000,false,"i",playerid);
		static string[64];
		format(string,sizeof string,""cjam"%s is attempting to start a vehicle...",GetPName(playerid));
		SendNearMessage(playerid,white,string,20);
		PInfo[playerid][StartCar] = 1;
	}
	if(HOLDING(KEY_CROUCH) && HOLDING(KEY_SPRINT) || PRESSED(KEY_CROUCH) && PRESSED(KEY_SPRINT) || HOLDING(KEY_SPRINT) && HOLDING(KEY_CROUCH) || PRESSED(KEY_SPRINT) && PRESSED(KEY_CROUCH))
	{
	    if(IsPlayerInAnyVehicle(playerid)) return 0;
	    if(PInfo[playerid][Training] == 1)
	    {
	        if(PInfo[playerid][FakePerk] == 1)
	        {
		    	if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"You haven't got enough energy to get a quick burst!");
			    new Float:x,Float:y,Float:z,Float:a;
				GetPlayerVelocity(playerid,x,y,z);
				GetPlayerFacingAngle(playerid,a);
				x += ( 0.5 * floatsin( -a, degrees ) );
		      	y += ( 0.5 * floatcos( -a, degrees ) );
				SetPlayerVelocity(playerid,x,y,z+0.4);
				WaitAirCheat[playerid]=2;
				PInfo[playerid][CanBurst] = 0;
				static string[128];
				format(string,sizeof string,""cwhite"*"cjam"%s gets a quick burst of energy",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
			}
		}
		if(PInfo[playerid][SPerk] == 6 && Team[playerid] == HUMAN)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"You haven't got enough energy to get a quick burst!");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			WaitAirCheat[playerid]=2;
			PInfo[playerid][CanBurst] = 0;
			if(PInfo[playerid][Premium] == 3) PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",110000,false,"i",playerid);
			else PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[128];
			format(string,sizeof string,""cwhite"*"cjam"%s gets a quick burst of energy",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
		}
		else if(PInfo[playerid][ZPerk] == 9 && Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"» "cred"You haven't got enough energy to get a quick burst!");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			WaitAirCheat[playerid]=2;
			PInfo[playerid][CanBurst] = 0;
			if(PInfo[playerid][Premium] == 3) PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",110000,false,"i",playerid);
			else PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[128];
			format(string,sizeof string,""cwhite"* "cjam"%s gets a quick burst of energy",GetPName(playerid));
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
				    if(PInfo[i][Dead] == 1) continue;
				    if(Team[i] == ZOMBIE) continue;
  		    		if(i == playerid) continue;
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
						  		ApplyAnimation(i,"PED","gas_cwr",2,0,0,0,0,0,1);
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
								SetTimerEx("DissapearBloodPhase1",20000,false,"i",i);
								SetTimerEx("DissapearBloodPhase2",45000,false,"i",i);
								SetTimerEx("DissapearBloodPhase3",70000,false,"i",i);
								SetTimerEx("DissapearBloodPhase4",85000,false,"i",i);
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
      		else if(PInfo[playerid][ZPerk] == 24)
			{
			    if(GetTickCount() - PInfo[playerid][CanHellScream] < 18000)
				{
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
						      		ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
									SetPlayerVelocity(i,x,y,z+0.15);
									WaitAirCheat[i]=2;
	        						if(PInfo[i][OnFire] != 0) return 0;
									PInfo[i][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
									PInfo[i][OnFire] = 1;
									AttachObjectToPlayer(PInfo[i][FireObject],i,0,0,-0.2,0,0,0);
									SetTimerEx("AffectFire",500,false,"ii",i,playerid);
								}
			            	}
			            	else
			            	{
				        		new Float:vh;
				        		GetVehicleHealth(GetPlayerVehicleID(i),vh);
				        		SetVehicleHealth(GetPlayerVehicleID(i),vh-75);
			        		 	PInfo[i][VehicleFire] = CreateObject(18691,0,0,0,0,0,0,200);
			        		 	AttachObjectToVehicle(PInfo[i][VehicleFire],GetPlayerVehicleID(i),0,2,-1,0,0,0);
			        		 	SetTimerEx("DamageVehicle",500,false,"i",i);
							}
						}
			        }
			        static Float:Health;
		  			GetPlayerHealth(i,Health);
					MakeHealthEven(i,Health);
		  			if(Health <= 4.0)
					{
				    	InfectPlayer(i);
				    	PInfo[i][Dead] = 1;
				    	GivePlayerXP(playerid);
				    	GivePlayerAssistXP(playerid);
			        	CheckRankup(playerid);
			        	PInfo[i][AfterLifeInfected] = 1;
					}
					else
		  				SetPlayerHealth(i,Health-4.0);
				 	MakeHealthEven(i,Health);
				 	GetPlayerHealth(i,Health);
					if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
       			}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3.5,0,1,1,0,0,1);
                SetPlayerAttachedObject(playerid,4,18694,2,0,0.1,-1.6,0,0,0,1,1,1,0,0);
                SetTimerEx("DestroyHellFire",1455,false,"i",playerid);
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
		      	    			ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
								SetPlayerVelocity(i,x*0.9,y*0.9,z+0.1);
								WaitAirCheat[i]=2;
							}
						}
	       				static Float:Health;
			  			GetPlayerHealth(i,Health);
						MakeHealthEven(i,Health);
						if(PInfo[playerid][RageMode] == 0)
						{
				  			if(Health <= 10.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-10.0);
						 	MakeHealthEven(i,Health);
						 	GetPlayerHealth(i,Health);
						}
                        else if(PInfo[playerid][RageMode] == 1)
						{
				  			if(Health <= 15.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-15.0);
						 	MakeHealthEven(i,Health);
						 	GetPlayerHealth(i,Health);
						}
						if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
			        }
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
					      		 	ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
									SetPlayerVelocity(i,x*1.1,y*1.1,z+0.14);
									WaitAirCheat[i]=2;
								}
							}
							else
							{
								SetVehicleAngularVelocity(GetPlayerVehicleID(i), 0, 0, 0.3);
			            	}
						}
       					static Float:Health;
			  			GetPlayerHealth(i,Health);
						MakeHealthEven(i,Health);
						if(PInfo[playerid][RageMode] == 0)
						{
				  			if(Health <= 12.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-12.0);
						 	MakeHealthEven(i,Health);
						 	GetPlayerHealth(i,Health);
						}
						else if(PInfo[playerid][RageMode] == 1)
						{
				  			if(Health <= 17.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-17.0);
						 	MakeHealthEven(i,Health);
						 	GetPlayerHealth(i,Health);
						}
						if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
					}
				}
                ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
                SetTimerEx("ClearAnim2",700,false,"i",playerid);
                PInfo[playerid][Canscream] = GetTickCount();
      		}
      		else
      		{
      		    if(PInfo[playerid][CanBite] == 0) return 0;
      		    else
      		    {
	      		    static Float:x,Float:y,Float:z;
	      		    static Float:ax,Float:ay,Float:az;
				    GetPlayerPos(playerid,x,y,z);
				    new i;
				    i = -1;
				    for(new j, f = MAX_PLAYERS; j < f; j++)
				    {
				        if(j == playerid) continue;
				        if(PInfo[j][Dead] == 1) continue;
				        if(Team[j] == ZOMBIE) continue;
				        if(PInfo[playerid][CanBite] == 0) continue;
				        if(IsPlayerInAnyVehicle(j)) continue;
				        if(IsPlayerInRangeOfPoint(j,1.2,x,y,z))
				        {
				            i = j;
				            break;
				        }
	      			}
	      			GetPlayerPos(i,ax,ay,az);
	      			if(IsPlayerInRangeOfPoint(playerid,1.65,ax,ay,az))
	      			{
		      			static Float:Health;
			            GetPlayerHealth(i,Health);
			            MakeHealthEven(i,Health);
			  			DamagePlayer(playerid,i);
			  			PInfo[playerid][CanBite] = 0;
					 	if(PInfo[playerid][ZPerk] == 3)
						{
							GetPlayerHealth(playerid,Health);
							if(PInfo[playerid][Rank] < 5)
							{
								if(Health <= 125.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
							{
								if(Health <= 150.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
							{
								if(Health <= 175.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
							{
								if(Health <= 200.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if(PInfo[playerid][Rank] > 20)
							{
								if(Health <= 225.0)
									SetPlayerHealth(playerid,Health+7);
							}
						}
						else if(PInfo[playerid][ZPerk] == 21)
						{
							GetPlayerHealth(playerid,Health);
							if(PInfo[playerid][Rank] < 5)
							{
								if(Health <= 125.0)
									SetPlayerHealth(playerid,Health+10);
							}
							if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
							{
								if(Health <= 150.0)
									SetPlayerHealth(playerid,Health+10);
							}
							if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
							{
								if(Health <= 175.0)
									SetPlayerHealth(playerid,Health+10);
							}
							if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
							{
								if(Health <= 200.0)
									SetPlayerHealth(playerid,Health+10);
							}
							if(PInfo[playerid][Rank] > 20)
							{
								if(Health <= 225.0)
									SetPlayerHealth(playerid,Health+10);
							}
						}
						else if(PInfo[playerid][ZPerk] == 18)
						{
							GetPlayerHealth(playerid,Health);
							if(PInfo[playerid][Rank] < 5)
							{
								if(Health <= 125.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
							{
								if(Health <= 150.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
							{
								if(Health <= 175.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
							{
								if(Health <= 200.0)
									SetPlayerHealth(playerid,Health+7);
							}
							if(PInfo[playerid][Rank] > 20)
							{
								if(Health <= 225.0)
									SetPlayerHealth(playerid,Health+7);
							}
						}
						else
						{
							if(PInfo[playerid][ZPerk] != 18)
							{
								GetPlayerHealth(playerid,Health);
								if(PInfo[playerid][Rank] < 5)
								{
									if(Health <= 125.0)
										SetPlayerHealth(playerid,Health+5);
								}
								if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10))
								{
									if(Health <= 150.0)
										SetPlayerHealth(playerid,Health+5);
								}
								if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15))
								{
									if(Health <= 175.0)
										SetPlayerHealth(playerid,Health+5);
								}
								if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20))
								{
									if(Health <= 200.0)
										SetPlayerHealth(playerid,Health+5);
								}
								if(PInfo[playerid][Rank] > 20)
								{
									if(Health <= 225.0)
										SetPlayerHealth(playerid,Health+5);
								}
							}
						}
						if(PInfo[playerid][ZPerk] == 29)
						{
						    if(PInfo[playerid][ToxicBites] > 0)
						    {
						        if(PInfo[i][Poisoned] == 0)
						        {
						            PInfo[playerid][ToxicBites] --;
						            PInfo[i][Poisoned] = 1;
						            SetTimerEx("WierdAnimation",1500,false,"i",i);
						            SetTimerEx("CanBePoisonedAgain",60000,false,"i",i);
									new stranng[144];
									GetPlayerPos(playerid,x,y,z);
									format(stranng,sizeof stranng,"* "cjam"%s poisoned by %s by toxic bite",GetPName(i),GetPName(playerid));
									for(new l; l < MAX_PLAYERS; l++)
									{
									    if(!IsPlayerConnected(l)) continue;
										if(IsPlayerInRangeOfPoint(l,15,x,y,z))
											SendClientMessage(l,white,stranng);
									}
									SendClientMessage(i,white,"* "dred"You are poisoned, use Dizzy Away Pills to decrease effect of toxin!");
						            PInfo[i][PoisonDizzy] = 1;
						            SetPlayerWeather(i,1447);
						            SetPlayerDrunkLevel(i,4000);
						            SetTimerEx("KillTimerOfPoison",30000,false,"i",i);
						            PInfo[i][ToxinTimer] = SetTimerEx("ToxinPlayer",2500,true,"ii",i,playerid);
								}
							}
						}
						if(PInfo[playerid][ZPerk] == 23)
						{
					    	if(PInfo[i][CanBeBlinded] == 1)
	   	 					{
					        	PInfo[i][CanBeBlinded] = 0;
					        	SetTimerEx("BlindPlayer",10,0,"i",i);
					        	SetTimerEx("AllowToBlinded",6250,false,"i",i);
							}
						}
						if(PInfo[playerid][ZPerk] == 10)
						{
		                    if(PInfo[i][CanStinger] == 0) return 0;
		                    else
		                    {
								/*new rand = random(1);
								if(rand == 1)*/
								{
									ApplyAnimation(i,"PED","DAM_Stomach_frmFT",0.5,0,0,0,0,0,1);
									SetTimerEx("StingerPhase1", 800, false, "i", i);
									SetTimerEx("StingerPhase2", 1300, false, "i", i);
									PInfo[i][CanStinger] = 0;
									SetTimerEx("CanBeStingeredTime", 10000, false, "i", i);
								}
							}
						}
		      		}
				}
			}
			if(PInfo[playerid][Training] == 1)
			{
			    if(PInfo[playerid][TrainingPhase] == 12)
			    {
					new Float:acX,Float:acY,Float:acZ,Float:actorHP;
					GetActorPos(Jason[playerid],acX,acY,acZ);
					if(IsPlayerInRangeOfPoint(playerid,1.65,acX,acY,acZ))
					{
					    if(PInfo[playerid][CanBite] == 1)
					    {
					    	ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
					    	PInfo[playerid][CanBite] = 0;
					    	SetTimerEx("CantBite",455,0,"i",playerid);
					    	PlayerPlaySound(playerid,1136,acX,acY,acZ);
					    	ApplyActorAnimation(Jason[playerid],"PED","DAM_armR_frmFT",2,0,1,1,0,0);
					    	GetActorHealth(Jason[playerid],actorHP);
					    	if(actorHP <= 7)
					    	{
					    	    DestroyActor(Jason[playerid]);
					    	    new strang[2048];
					    	    format(strang,sizeof strang,""cwhite"Good Job!\nNow you know how to bite!\nYou have infected a human and after some time he will become a zombie\nBut human that you killed just a bot, so he won't become a zombie...\nAfter infecting you will get some XP\nNow lets continue, go to next pickup");
					    	    strcat(strang,"\nIf you were killed by human with higher rank than you, your rage will increase\nwhen rage will be 100\% click N to activate Rage mode\nwith Rage mode you can kill humans much faster than usual!");
					            PInfo[playerid][TrainingPhase] = 13;
					            ShowPlayerDialog(playerid,18885,DSM,"Info",strang,"OK","");
					            DestroyPlayerObject(playerid,GateZombie2);
					            GateZombie1 = CreatePlayerObject(playerid,986,297.4650000,2504.6460000,15.4340000,0.0000000,0.0000000,266.2480000);
							}
							else
							SetActorHealth(Jason[playerid],actorHP-7);
						}
					}
				}
			}
			if(SupplyDirect > -1)
			{
			    if((SupplyInvaded == 0) && (SupplyDestroyed == 0))
			    {
				    new Float:SX,Float:SY,Float:SZ;
				    GetObjectPos(objectsupply1,SX,SY,SZ);
				    if(IsPlayerInRangeOfPoint(playerid,3,SX,SY,SZ))
				    {
				        if(SupplyHealth <= 2)
				        {
				            SupplyDestroyed = 1;
				            SupplyHealth = 0;
							DestroyObject(objectsupply1);
							KillTimer(InvadingTimer);
							DestroyObject(objectsupply2);
							Delete3DTextLabel(SupplyLabel);
							CreateFakeExplosion(18683,SX,SY,SZ);
					        PInfo[playerid][CanBite] = 0;
					        SetTimerEx("CantBite",800,0,"i",playerid);
					        PlayNearSound(playerid,1136);
					        ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
							for(new i; i < MAX_PLAYERS; i++)
							{
							    if(!IsPlayerConnected(i)) continue;
    							RemovePlayerMapIcon(i,77);
							    if(PInfo[i][Logged] == 0) continue;
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								PlayerPlaySound(i,1159,SX,SY,SZ);
								if(Team[i]== HUMAN)
								{
								    SendClientMessage(i,white,"** "cred"Container was destroyed!");
								}
								if(Team[i]== ZOMBIE)
								{
								    SendClientMessage(i,white,"** "cred"Container was destroyed!");
							     	if(IsPlayerInRangeOfPoint(i,15,SX,SY,SZ))
							     	{
							     	    SendClientMessage(i,white,"** "cred"You've got Extra XP!");
							     		GivePlayerXP(i);
									}
								}
							}
						}
						else
						{
						    if(PInfo[playerid][CanBite] == 1)
						    {
						        PInfo[playerid][CanBite] = 0;
						        SetTimerEx("CantBite",800,0,"i",playerid);
						        PlayNearSound(playerid,1136);
								new string[512];
								format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
						        Update3DTextLabelText(SupplyLabel,green,string);
						        ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
						        SupplyHealth -=2;
							}
						}
					}
				}
			}
   			for(new i, f = MAX_PLAYERS; i < f; i++)
		    {
		        if(IsPlayerInRangeOfPoint(playerid,1.5,PInfo[i][Vomitx],PInfo[i][Vomity],PInfo[i][Vomitz]))
				{
				    if(playerid != i)
				    {
				    	if(IsValidObject(PInfo[i][Vomit]))
				    	{
				        	if(PInfo[playerid][CanBite] == 1)
				        	{
								if(PInfo[playerid][ZPerk] == 29)
								{
				            		if(PInfo[playerid][CanBiteVomit] == 0) return SendClientMessage(playerid,white,"* "cred"Your stomach's not ready to digest toxic meat yet!");
  									PInfo[playerid][CanBite] = 0;
					        		ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
									PlayNearSound(i,1136);
									SetTimerEx("CantBite",1000,0,"i",playerid);
									if(PInfo[playerid][Rank] < PInfo[i][Rank])
				            		{
				            	    	PInfo[playerid][ToxicBites] += 3;
				            	    	SendClientMessage(playerid,white,"* "cjam"You have bitten someone's vomit, you can bite 3 times with toxic meat");
									}
									else if(PInfo[playerid][Rank] == PInfo[i][Rank])
									{
 		            	    			PInfo[playerid][ToxicBites] += 2;
				            	    	SendClientMessage(playerid,white,"* "cjam"You have bitten someone's vomit, you can bite 2 times with toxic meat");
									}
									else if(PInfo[playerid][Rank] > PInfo[i][Rank])
									{
 		            	    			PInfo[playerid][ToxicBites] ++;
				            		    SendClientMessage(playerid,white,"* "cjam"You have bitten someone's vomit, you can bite 1 times with toxic meat");
									}
									PInfo[playerid][CanBiteVomit] = 0;
									SetTimerEx("CanBiteVomitAgain",135000,false,"i",playerid);
								}
							}
						}
					}
				}
			    else if(IsPlayerInRangeOfPoint(playerid,1.5,PInfo[i][MeatSX],PInfo[i][MeatSY],PInfo[i][MeatSZ]))
			    {
			        if(IsValidObject(PInfo[i][MeatSObject]))
			        {
			        	if(PInfo[playerid][CanBite] == 1)
			        	{
			        	    new Float:HP;
			        	    GetPlayerHealth(playerid,HP);
							if(HP >= 100) return SendClientMessage(playerid,white,"* "cred"You have full HP, you don't need to eat any meat right now!");
							if(HP >=85)
						 		SetPlayerHealth(playerid,100);
							if(HP < 85)
							    SetPlayerHealth(playerid,HP + 15);
      						PInfo[playerid][CanBite] = 0;
			        		ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
							for(new z; z < MAX_PLAYERS; z++)
							{
							    if(!IsPlayerConnected(z)) continue;
							    if(PInfo[z][Logged] == 0) continue;
							    PlayerPlaySound(i,1136,PInfo[i][MeatSX],PInfo[i][MeatSY],PInfo[i][MeatSZ]);
							}
							SetTimerEx("CantBite",1000,0,"i",playerid);
							if(PInfo[i][SMeatBite] > 1)
							{
								PInfo[i][SMeatBite] --;
								new strang[155];
								format(strang,sizeof strang,""cred"%s's "cwhite"meat\nClick "cgreen"Right Mouse Button "cwhite"to increase your HP\nBites available "cred"%i "cwhite"/"cgreen" 15",GetPName(i),PInfo[i][SMeatBite]);
								Update3DTextLabelText(PInfo[i][LabelMeatForShare],white,strang);
							}
							else if(PInfo[i][SMeatBite] == 1)
							{
						    	if(Team[i] == ZOMBIE)
						    	{
						    		new string[128];
						    		PInfo[i][SMeatBite] = 0;
									format(string,sizeof string,"* "cjam"%s's meat for share was eaten!",GetPName(i));
									SendClientMessage(i,white,string);
									DestroyObject(PInfo[i][MeatSObject]);
									PInfo[i][ShareMeatVomited] = 0;
									Delete3DTextLabel(PInfo[i][LabelMeatForShare]);
								}
							}
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
    if(IsPlayerNPC(playerid))return 1;
    if(dialogid == 13777)
    {
        if(!response) return 1;
        else
        {
            PInfo[playerid][FakePerk] = 1;
            ShowPlayerDialog(playerid,13779,DSM,"Info",""cwhite"Now use "cred"Burst Run"cwhite" to jump to another end of room\nClick "cred"C + Space"cwhite" to use burst run!\n"cred"If you failed this step, find green arrow pickup under ladder and try use Burst Run again!","OK","");
		}
		return 1;
	}
	if(dialogid == 13778)
	{
	    if(!response) return 1;
	    else
	    {
			if(listitem == 0)
			{
			    if(PInfo[playerid][TrainingPhase] == 14)
			    {
			    	PInfo[playerid][FakePerk] = 3;
      				ShowPlayerDialog(playerid,13778,DSM,"Info",""cwhite"Press "cred"C"cwhite" to dig to the car and continue course","OK","");
				}
				else if(PInfo[playerid][TrainingPhase] == 13)
				{
					ShowPlayerDialog(playerid,13778,DSM,"Info",""cwhite"You need to use Jumper perk to continue course!","OK","");
				}
			}
	        if(listitem == 1)
	        {
	            if(PInfo[playerid][TrainingPhase] == 13)
	            {
	        		PInfo[playerid][FakePerk] = 2;
             		ShowPlayerDialog(playerid,13778,DSM,"Info",""cwhite"Jump through these boxes \nJust "cred"JUMP"cwhite" to jump higher\nThen go to next pickup to continue","OK","");
				}
				else if(PInfo[playerid][TrainingPhase] == 14)
				{
  					ShowPlayerDialog(playerid,13778,DSM,"Info",""cwhite"You need to use Digger perk to complete this step!","OK","");
				}
			}
		}
		return 1;
	}
	if(dialogid == 14779)
	{
		if(!response) return 1;
		else
		{
		    if(listitem == 0)
		    {
		        PInfo[playerid][TrainingPhase] = 11;
		        SetPlayerPosAndAngle(playerid,277.7416,2497.2471,16.4844,313.8315);
		        Jason[playerid] = CreateActor(23,307.1434,2504.6030,16.4844,89.4828);
		        SetActorVirtualWorld(Jason[playerid],GetPlayerVirtualWorld(playerid));
		        GateZombie1 = CreatePlayerObject(playerid,986,297.4650000,2504.6460000,15.4340000,0.0000000,0.0000000,266.2480000);
                GateZombie2 = CreatePlayerObject(playerid,986,315.4240100,2504.6159700,14.9090000,0.0000000,0.0000000,266.2480000);
			}
		}
		return 1;
	}
    if(dialogid == 999)
    {
        if(!response)
        {
			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules", "Choose", "Close");
            PInfo[playerid][Training] = 0;
            PInfo[playerid][TrainingPhase] = 0;
		}
		else
		{
		    SetPlayerVirtualWorld(playerid,playerid+2000);
		    if(PInfo[playerid][Training] == 1)
		    {
			    if(PInfo[playerid][TrainingPhase] < 9 )
			    {
			    	PInfo[playerid][TrainingPhase] = 1;
				}
				if(PInfo[playerid][TrainingPhase] >= 9)
				{
				    PInfo[playerid][TrainingPhase] = 9;
				}
			}
			else if(PInfo[playerid][Training] == 0)
			{
			    PInfo[playerid][TrainingPhase] = 1;
			    PInfo[playerid][Training] = 1;
			}
			SpawnPlayer(playerid);
		}
		return 1;
	}
	if(dialogid == 1502)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            if(GetPlayerWeapon(playerid) == 23)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,23,ammo+51);
				}
				else if(GetPlayerWeapon(playerid) != 23)
				{
				    GivePlayerWeapon(playerid,23,51);
				}
			}
			if(listitem == 1)
			{
	            if(GetPlayerWeapon(playerid) == 22)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,22,ammo+95);
				}
				else if(GetPlayerWeapon(playerid) != 22)
				{
				    GivePlayerWeapon(playerid,22,95);
				}
			}
			if(listitem == 2)
			{
	            if(GetPlayerWeapon(playerid) == 25)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,25,ammo+35);
				}
				else if(GetPlayerWeapon(playerid) != 25)
				{
				    GivePlayerWeapon(playerid,25,35);
				}
			}
			if(listitem == 3)
			{
	            if(GetPlayerWeapon(playerid) == 24)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,24,ammo+42);
				}
				else if(GetPlayerWeapon(playerid) != 24)
				{
				    GivePlayerWeapon(playerid,24,42);
				}
			}
			if(listitem == 4)
			{
	            if(GetPlayerWeapon(playerid) == 28)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,28,ammo+100);
				}
				else if(GetPlayerWeapon(playerid) != 28)
				{
				    GivePlayerWeapon(playerid,28,100);
				}
	            if(GetPlayerWeapon(playerid) == 33)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,33,ammo+50);
				}
				else if(GetPlayerWeapon(playerid) != 33)
				{
				    GivePlayerWeapon(playerid,33,50);
				}
			}
			if(listitem == 5)
			{
	            if(GetPlayerWeapon(playerid) == 26)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,26,ammo+36);
				}
				else if(GetPlayerWeapon(playerid) != 26)
				{
				    GivePlayerWeapon(playerid,26,36);
				}
			}
			if(listitem == 6)
			{
	            if(GetPlayerWeapon(playerid) == 30)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,30,ammo+60);
				}
				else if(GetPlayerWeapon(playerid) != 30)
				{
				    GivePlayerWeapon(playerid,30,60);
				}
	            if(GetPlayerWeapon(playerid) == 32)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,32,ammo+150);
				}
				else if(GetPlayerWeapon(playerid) != 32)
				{
				    GivePlayerWeapon(playerid,32,150);
				}
			}
			if(listitem == 7)
			{
	            if(GetPlayerWeapon(playerid) == 27)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,27,ammo+49);
				}
				else if(GetPlayerWeapon(playerid) != 27)
				{
				    GivePlayerWeapon(playerid,27,49);
				}
			}
			if(listitem == 8)
			{
	            if(GetPlayerWeapon(playerid) == 31)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,31,ammo+100);
				}
				else if(GetPlayerWeapon(playerid) != 31)
				{
				    GivePlayerWeapon(playerid,31,100);
				}
			}
			if(listitem == 9)
			{
	            if(GetPlayerWeapon(playerid) == 34)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,34,ammo+30);
				}
				else if(GetPlayerWeapon(playerid) != 34)
				{
				    GivePlayerWeapon(playerid,34,30);
				}
	            if(GetPlayerWeapon(playerid) == 29)
	            {
					new ammo = GetPlayerAmmo(playerid);
					SetPlayerAmmo(playerid,29,ammo+60);
				}
				else if(GetPlayerWeapon(playerid) != 29)
				{
				    GivePlayerWeapon(playerid,29,60);
				}
			}
  			PInfo[playerid][CanUseWeapons] = 0;
  			SendClientMessage(playerid,white,"**"corange"You have successfully changed your weapons!");
		}
		return 0;
	}
	if(dialogid == 1100)
    {
		if(response)
		{
		    PInfo[playerid][NormalTP] = 1;
		    WaitAirCheat[playerid]=2;
			if(listitem == 0) //Hive
	     	{
       			TogglePlayerControllable(playerid, 0);
				SetTimerEx("UnFreezePlayer", 975, false, "i", playerid);
  	  			new rand = random(11);
				switch(rand)
				{
				    case 0: SetPlayerPosAndAngle(playerid,1460.5132,-1466.9683,1719.5442,84.5054);
				    case 1: SetPlayerPosAndAngle(playerid,1448.8417,-1486.1240,1719.5936,33.4291);
				    case 2: SetPlayerPosAndAngle(playerid,1399.8403,-1505.0916,1719.5756,5.3044);
				    case 3: SetPlayerPosAndAngle(playerid,1372.8685,-1511.4741,1719.5831,343.0889);
				    case 4: SetPlayerPosAndAngle(playerid,1340.8456,-1483.6285,1719.5442,307.5982);
				    case 5: SetPlayerPosAndAngle(playerid,1328.9656,-1452.5067,1719.5442,257.2136);
				    case 6: SetPlayerPosAndAngle(playerid,1361.6819,-1407.4862,1719.5442,210.7511);
				    case 7: SetPlayerPosAndAngle(playerid,1403.2418,-1404.8214,1720.8575,185.9819);
				    case 8: SetPlayerPosAndAngle(playerid,1438.1006,-1405.0886,1720.0638,155.1862);
				    case 9: SetPlayerPosAndAngle(playerid,1456.8851,-1431.7415,1719.5442,115.7291);
				    case 10: SetPlayerPosAndAngle(playerid,1479.4906,-1439.6598,1730.0663,113.1023);
				}
	       	}
	        if(listitem == 1) //Grove Street
	       	{
	        	new rand = random(7);
				switch(rand)
				{
				    case 0: SetPlayerPosAndAngle(playerid,2620.0542,-1462.2609,19.4964,176.7836);
				    case 1: SetPlayerPosAndAngle(playerid,2605.8286,-1461.4834,19.7831,176.3789);
				    case 2: SetPlayerPosAndAngle(playerid,2591.1614,-1461.1997,19.8877,181.5595);
				    case 3: SetPlayerPosAndAngle(playerid,2625.1345,-1476.4379,17.1762,94.1828);
				    case 4: SetPlayerPosAndAngle(playerid,2628.2393,-1489.5166,16.7990,153.1918);
				    case 5: SetPlayerPosAndAngle(playerid,2627.0767,-1511.1414,18.4501,89.5321);
				    case 6: SetPlayerPosAndAngle(playerid,2581.0872,-1512.1718,19.0606,271.2540);
				}
	       	}
	       	if(listitem == 2) //Unity Station
	       	{
	        	new rand = random(6);
				switch(rand)
				{
				    case 0: SetPlayerPosAndAngle(playerid,1921.7760,-1838.5387,3.9844,348.4833);
				    case 1: SetPlayerPosAndAngle(playerid,1912.7422,-1836.7341,3.9844,341.3235);
				    case 2: SetPlayerPosAndAngle(playerid,1902.9943,-1835.1410,3.9912,353.5905);
				    case 3: SetPlayerPosAndAngle(playerid,1892.9271,-1822.6309,3.9844,163.4136);
				    case 4: SetPlayerPosAndAngle(playerid,1882.8904,-1820.6244,3.9844,172.1557);
				    case 5: SetPlayerPosAndAngle(playerid,1873.6471,-1818.1238,3.9844,166.4086);
				}
	       	}
	       	if(listitem == 3) // Market Station
	       	{
	        	new rand = random(3);
				switch(rand)
				{
				    case 0: SetPlayerPosAndAngle(playerid,851.0190,-1361.8948,14.7264,238.8987);
				    case 1: SetPlayerPosAndAngle(playerid,864.0385,-1366.7883,14.6026,62.7255);
				    case 2: SetPlayerPosAndAngle(playerid,875.1151,-1354.3022,13.6479,95.0224);
				}
	       	}
	       	if(listitem == 4) // Glen Park
	       	{
	        	new rand = random(3);
				switch(rand)
				{
				    case 0: SetPlayerPosAndAngle(playerid,1876.1813,-962.3055,49.7472,222.1064);
				    case 1: SetPlayerPosAndAngle(playerid,1887.3263,-961.2328,52.2962,187.4252);
				    case 2: SetPlayerPosAndAngle(playerid,1892.2560,-960.1830,53.6512,179.4559);
				}
	       	}
	       	if(listitem == 5) // Vinewood
	       	{
	        	new rand = random(3);
				switch(rand)
				{
 		 			case 0: SetPlayerPosAndAngle(playerid,763.2237,-1019.5946,24.0599,270.3856);
   					case 1: SetPlayerPosAndAngle(playerid,762.4956,-1023.8790,24.0073,268.4244);
				    case 2: SetPlayerPosAndAngle(playerid,763.5172,-1016.2543,24.0957,204.1905);
				}
	       	}
	       	if(listitem == 6) //Los Santos Center
	       	{
	        	new rand = random(4);
				switch(rand)
				{
 		 			case 0: SetPlayerPosAndAngle(playerid,1407.8484,-1306.3011,9.8543,178.5364);
 		 			case 1: SetPlayerPosAndAngle(playerid,1412.3447,-1306.3000,9.8543,178.3379);
   					case 2: SetPlayerPosAndAngle(playerid,1413.3711,-1318.8639,9.3276,94.5229);
				    case 3: SetPlayerPosAndAngle(playerid,1407.6669,-1315.2234,9.2825,271.3882);
				}
	       	}
	       	if(listitem == 7) // Willowfield
	       	{
	        	new rand = random(3);
				switch(rand)
				{
 		 			case 0: SetPlayerPosAndAngle(playerid,1995.8726,-2018.7202,13.5469,234.6600);
 		 			case 1: SetPlayerPosAndAngle(playerid,1993.3193,-2037.4153,13.5452,150.8450);
   					case 2: SetPlayerPosAndAngle(playerid,2003.1001,-2045.5048,13.5469,108.7168);
				}
	       	}
	       	if(listitem == 8)// Santa Maria Beach
	       	{
	        	new rand = random(4);
				switch(rand)
				{
	        		case 0: SetPlayerPosAndAngle(playerid,358.6554,-1743.5533,5.9866,98.6428);
 		 			case 1: SetPlayerPosAndAngle(playerid,358.2688,-1736.5593,6.1962,103.4995);
 		 			case 2: SetPlayerPosAndAngle(playerid,360.3278,-1749.2504,6.0079,129.1225);
   					case 3: SetPlayerPosAndAngle(playerid,371.1052,-1724.4656,7.3405,359.4117);
				}
	       	}
	       	if(listitem == 9) // Gate-C
	       	{
	        	new rand = random(3);
				switch(rand)
				{
	        		case 0: SetPlayerPosAndAngle(playerid,1098.4636,-1881.0302,13.5469,200.4868);
 		 			case 1: SetPlayerPosAndAngle(playerid,1107.5178,-1885.5521,13.5178,358.0062);
 		 			case 2: SetPlayerPosAndAngle(playerid,1120.9423,-1885.8994,13.4271,0.1109);
				}
			}
	       	if(listitem == 10) // Los Santos Airport
	       	{
	        	new rand = random(4);
				switch(rand)
				{
	        		case 0: SetPlayerPosAndAngle(playerid,2096.8198,-2488.2090,14.2184,12.4539);
 		 			case 1: SetPlayerPosAndAngle(playerid,2121.0176,-2466.5571,13.7938,36.5755);
 		 			case 2: SetPlayerPosAndAngle(playerid,2091.5046,-2419.0439,13.5469,101.5745);
 		 			case 3: SetPlayerPosAndAngle(playerid,2084.7026,-2414.7698,13.5469,150.9511);
				}
			}
	       	if(listitem == 11) // Los Santos City hall
	       	{
	        	new rand = random(4);
				switch(rand)
				{
	        		case 0: SetPlayerPosAndAngle(playerid,1340.3403,-1811.4690,13.7993,186.8907);
 		 			case 1: SetPlayerPosAndAngle(playerid,1339.4036,-1819.7505,14.1210,155.4839);
 		 			case 2: SetPlayerPosAndAngle(playerid,1345.0969,-1821.7928,13.7924,271.7213);
 		 			case 3: SetPlayerPosAndAngle(playerid,1336.6552,-1817.4032,13.5469,227.5253);
				}
			}
	       	if(listitem == 12) // Small Thicket
	       	{
	        	new rand = random(3);
				switch(rand)
				{
	        		case 0: SetPlayerPosAndAngle(playerid,1798.7383,-749.9318,61.7386,60.4178);
 		 			case 1: SetPlayerPosAndAngle(playerid,1792.8885,-744.4794,59.5339,232.6250);
 		 			case 2: SetPlayerPosAndAngle(playerid,1801.3530,-742.6094,61.5651,54.2663);
				}
			}
		}
		else
		{
			return 1; //\nLos Santos Airport\nLos Santos City hall\Los Santos City hall
		}
		return 1;
	}

	if(dialogid == 1002)
	{
		if(response) //Óñëîâèå: åñëè ìû íàæàëè ïåðâóþ êíîïêó
		{
            ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //Óñëîâèå: åñëè ìû íàæàëè âòîðóþ êíîïêó
		{
			return 1;
		}
		return 1;
 	}

    if(dialogid == 1003)
	{
		if(response) //Óñëîâèå: åñëè ìû íàæàëè ïåðâóþ êíîïêó
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //Óñëîâèå: åñëè ìû íàæàëè âòîðóþ êíîïêó
		{
			return 1;
		}
		return 1;
 	}

	if(dialogid == 1003)
	{
		if(response) //Óñëîâèå: åñëè ìû íàæàëè ïåðâóþ êíîïêó
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //Óñëîâèå: åñëè ìû íàæàëè âòîðóþ êíîïêó
		{
			return 1;
		}
		return 1;
 	}

	if(dialogid == 1004)
	{
		if(response) //Óñëîâèå: åñëè ìû íàæàëè ïåðâóþ êíîïêó
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //Óñëîâèå: åñëè ìû íàæàëè âòîðóþ êíîïêó
		{
			return 1;
		}
		return 1;
 	}

	if(dialogid == 1005)
	{
		if(response) //Óñëîâèå: åñëè ìû íàæàëè ïåðâóþ êíîïêó
		{
 			ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //Óñëîâèå: åñëè ìû íàæàëè âòîðóþ êíîïêó
		{
			return 1;
		}
		return 1;
 	}
 	if(dialogid == HumanPerkBoosting)
 	{
 	    if(!response) return 0;
 	    if(listitem == 0)
 	    {
		    new string[1024];
		    format(string,sizeof string,""cwhite"When you boost Extra Meds to 1 level you will have 15 \% to not exhaust your meds when use with perk Extra Meds ");
		    strcat(string,"\nOn 2nd level you will get 25 \% to not exhaust your meds");
		    strcat(string,"\nOn 3nd level you will get 40 \% to not exhaust your meds");
            strcat(string,"\n\n"cgreen"1 Level: Needs 15 rank and 900 Skill Points\n2 Level: Needs 20 rank and 1600 Skill Points\n3 Level: Needs 25 rank and 2500 Skill Points");
  			ShowPlayerDialog(playerid,9101,DSM,""cred"Extra Meds Boosting",string,"Boost","Close");
		}
 	    if(listitem == 1)
 	    {
		    new string[1024];
		    format(string,sizeof string,""cwhite"When you boost Extra Fuel to 1 level you will have 15 \% to not exhaust your Fuel when use with perk Extra Fuel ");
		    strcat(string,"\nOn 2nd level you will get 25 \% to not exhaust your fuel");
		    strcat(string,"\nOn 3nd level you will get 40 \% to not exhaust your Fuel");
            strcat(string,"\n\n"cgreen"1 Level: Needs 15 rank and 700 Skill Points\n2 level: Needs 20 rank and 1400 Skill Points\n3 Level: Needs 25 rank and 2200 Skill Points");
   			ShowPlayerDialog(playerid,9102,DSM,""cred"Extra Fuel Boosting",string,"Boost","Close");
		}
 	    if(listitem == 2)
 	    {
		    new string[1024];
		    format(string,sizeof string,""cwhite"When you boost Extra Oil to 1 level you will have 15 \% to not exhaust your Oil when use with perk Extra Oil ");
		    strcat(string,"\nOn 2nd level you will get 25 \% to not exhaust your Oil");
		    strcat(string,"\nOn 3nd level you will get 40 \% to not exhaust your Oil");
            strcat(string,"\n\n"cgreen"1 Level: Needs 15 rank and 700 Skill Points\n2 Level: Needs 20 rank and 1400 Skill Points\n3 Level: Needs 25 rank and 2200 Skill Points");
   			ShowPlayerDialog(playerid,9103,DSM,""cred"Extra Oil Boosting",string,"Boost","Close");
		}
		return 1;
	}
	if(dialogid == BoostingMenu)
	{
	    if(!response) return 0;
		if(listitem == 0)
		{
		    ShowHumanBoosts(playerid);
		}
		if(listitem == 1)
		{
		    ShowZombieBoosts(playerid);
		}
		if(listitem == 2)
		{
		    new string[612];
		    format(string,sizeof string,""cwhite"You have opened a special perk boosting menu!");
		    strcat(string,"\nWhile you are playing you can notice that sometimes some perks are not effective, when you need.");
		    strcat(string,"\nBut with perk boosting system you can improve your perks in some aspects");
		    strcat(string,"\nYou need special "cred"Skill Points"cwhite"");
		    strcat(string,"\nYou can get this points by killing zombies or humans, clearing CPs or with killing assists");
		    strcat(string,"\nAll perks need different number of "cred"Skill Points"cwhite"");
		    strcat(string,"\nIt depends on level that you want to boost your perk and what rank does this perk open");
		    strcat(string,"\nNow you know everything that you should know about Perk Boosting, so good luck and have fun!");
			ShowPlayerDialog(playerid,7777,DSM,""cred"FAQ",string,"Back","Close");
		}
		return 1;
	}
	if(dialogid == AdminHelp)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
	        new string[1488];
	        format(string,sizeof string,""cred"/Spec "cwhite"- Spectate player");
	        strcat(string,"\n"cred"/Specoff "cwhite"- Stop spectating player");
	        strcat(string,"\n"cred"/Slap "cwhite"- Slap player");
	        strcat(string,"\n"cred"/Kick "cwhite"- Kick player");
	        strcat(string,"\n"cred"/Froze "cwhite"- Froze player");
	        strcat(string,"\n"cred"/UnFroze "cwhite"- Unfroze player");
	        strcat(string,"\n"cred"/AMC "cwhite"- Send message into main chat as administrator");
	        strcat(string,"\n"cred"/AC "cwhite"- Send message into admin chat");
	        strcat(string,"\n"cred"/SetTeam "cwhite"- Change player's team");
	        strcat(string,"\n"cred"/Mute "cwhite"- Mute player");
	        strcat(string,"\n"cred"/UnMute "cwhite"- Unmute player");
	        strcat(string,"\n"cred"/ClearChat "cwhite"- Cleat Chat");
	        ShowPlayerDialog(playerid,1831,DSM,""cwhite"Trial Admin",string,"Back","Close");
		}
	    if(listitem == 1)
	    {
     		new string[512];
	        format(string,sizeof string,""cred"/Bslap "cwhite"- The same as "cred"/Slap "cwhite"but slap much higher");
            strcat(string,"\n"cred"/Goto "cwhite"- Teleport to other player");
            strcat(string,"\n"cred"/Get "cwhite"- Teleport player to your position");
            strcat(string,"\n"cred"/Jail "cwhite"- Jail player");
            strcat(string,"\n"cred"/UnJail "cwhite"- UnJail player");
            strcat(string,"\n"cred"/Warn "cwhite"- Warn player");
			ShowPlayerDialog(playerid,1831,DSM,""cblue"Senior Admin",string,"Back","Close");
		}
	    if(listitem == 2)
	    {
    		new string[512];
	        format(string,sizeof string,""cred"/Heal "cwhite"- Heal player");
	        strcat(string,"\n"cred"/SetHealth "cwhite"- Sets the number of HP entered for the player");
	        strcat(string,"\n"cred"/Nuke "cwhite"- Just explode player, useful for GM test");
	        strcat(string,"\n"cred"/Ban "cwhite"- Ban player from the server");
	        ShowPlayerDialog(playerid,1831,DSM,""cjam"General Admin",string,"Back","Close");
		}
	    if(listitem == 3)
	    {
    		new string[512];
	        format(string,sizeof string,""cred"/Killrandom "cwhite"- Deactivate random set on the server");
	        strcat(string,"\n"cred"/GetIP "cwhite"- Get Player's IP");
	        strcat(string,"\n"cred"/BanIP "cwhite"- Drop IP into blacklist");
	        strcat(string,"\n"cred"/BanOff "cwhite"- Bun offline player");
	        strcat(string,"\n"cred"/UnBan "cwhite"- UnBan Player");
	        strcat(string,"\n"cred"/TPEvery "cwhite"- Teleport everyone to your position");
	        strcat(string,"\n"cred"/Announce "cwhite"- Make announce in the middle of the screen");
	        ShowPlayerDialog(playerid,1831,DSM,""cgreen"Lead Admin",string,"Back","Close");
		}
	    if(listitem == 4)
	    {
    		new string[716];
	        format(string,sizeof string,""cred"/RestartServer "cwhite"- Restart Server");
	        strcat(string,"\n"cred"/SetXP "cwhite"- Set player's XP");
	        strcat(string,"\n"cred"/SetRank "cwhite"- Set player's Rank");
	        strcat(string,"\n"cred"/SetZMoney "cwhite"- Set player's ZMoney");
	        strcat(string,"\n"cred"/SetKills "cwhite"- Set player's Kills");
	        strcat(string,"\n"cred"/SetDeaths "cwhite"- Set player's Deaths");
	        strcat(string,"\n"cred"/SetInfects "cwhite"- Set player's Infects");
	        ShowPlayerDialog(playerid,1831,DSM,""dred"Head Admin",string,"Back","Close");
		}
		return 1;
	}
	if(dialogid == 1831)
	{
		if(!response) return 0;
		if(PInfo[playerid][Level] == 1)
		{
			ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial","Choose","Close");
		}
		if(PInfo[playerid][Level] == 2)
		{
			ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior","Choose","Close");
		}
		if(PInfo[playerid][Level] == 3)
		{
			ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General","Choose","Close");
		}
		if(PInfo[playerid][Level] == 4)
		{
			ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General\nLevel 4\t"cgreen"Lead","Choose","Close");
		}
		if(PInfo[playerid][Level] >= 5)
		{
			ShowPlayerDialog(playerid,AdminHelp,DSL,""cred"Admin Help","Level 1\t"cwhite"Trial\nLevel 2\t"cblue"Senior\nLevel 3\t"cjam"General\nLevel 4\t"cgreen"Lead\nLevel 5\t"dred"Head","Choose","Close");
		}
		return 1;
	}
	if(dialogid == 7777)
	{
		if(!response) return 0;
		else
	        ShowPlayerDialog(playerid,BoostingMenu,2,""cred"Boosting Menu",""cgreen"Human's "cwhite"perks\n"cpurple"Zombie's "cwhite"perks\n"cred"FAQ","Choose","Close");
    	return 1;
	}
	if(dialogid == 1000)
	{
	    if(!response) return 0;
		if(listitem == 0) //Åñëè áûë âûáðàí 1 ïóíêò ñïèñêà
		{
        	ShowPlayerDialog(playerid,1002,DSM,"Game Mode", ""cwhite""dred"Los Santos Apocalypse"cwhite" is a survival horror team death match game mode with "cpurple"Zombies"cwhite"! \nThere are 2 teams: "cgreen"Survivors "cwhite"and "cpurple"Zombies\n"cwhite"Both of them have a main goal, and special gameplay!","Back","Close");
			return 1;
		}
		if(listitem == 1) //Åñëè áûë âûáðàí 2 ïóíêò ñïèñêà
		{
		    new string[512];
		    format(string, sizeof string,""cwhite"Main goal of "cgreen"Survivors"cwhite" is to clear all 8 red "cred"CheckPoints"cwhite". If they manage to do, so they win the round.\n"cgreen"Survivors"cwhite" can get XP by killing "cpurple"Zombies"cwhite" or clearing "cred"CheckPoints");
			strcat(string,""cwhite"\nAlso "cgreen"Survivors"cwhite" have an inventory (pressing "cred"N"cwhite"). \nIt will help them survive out there. \nOnce they've used their items, they can loot for more in opened interiors or search around "cred"40"cwhite" marked boxes on the map.");
			ShowPlayerDialog(playerid,1002,DSM,"Survivors", string,"Back","Close");
			return 1;
		}
		if(listitem == 2) //Åñëè áûë âûáðàí 3 ïóíêò ñïèñêà
		{
  			new string[512];
		    format(string,sizeof string,""cwhite"The main goal of "cpurple"Zombies"cwhite" is to infect all "cgreen"Humans"cwhite", for that they need to bite them (using "cred"Right Click"cwhite" when you are close enough), \nAnd don't let them clear all the 8 "cred"CheckPoints"cwhite".");
		    strcat(string,""cwhite"\n"cpurple"Zombies"cwhite" are faster than "cgreen"Humans and have lots of unlockable perks (press "cred"Y"cwhite" to check). \nAfter infecting you get "cred"+14 XP"cwhite", for assist you get"cred"+7 XP");
        	ShowPlayerDialog(playerid,1003,DSM,"Zombies",string,"Back","Close");
			return 1;
		}
		if(listitem == 3) //Åñëè áûë âûáðàí 4 ïóíêò ñïèñêà
		{
			new string[1024];
		    format(string,sizeof string,""corange"There are not allowed: \n1-Using all kinds of hacks (Cleo, Sobeit and etc.) that destroy the gameplay");
		    strcat(string,""corange"\n2-Killing your teammates, you must know that it is a TDM server and you should work in team!");
            strcat(string,""corange"\n3-Using BHop (bunnyhop, BH) for gaining speed, you should be mobility, if you want to run from zombie (jump on building, high objects and etc)");
            strcat(string,""corange"\n4-Using bugs is not allowed too, if you found it, you should tell it about to online adminstrators or in our main forum "cblue"Ultimate-Gaming.com");
            strcat(string,""corange"\n5-Insulting anyone in any form, you must respect others on server!");
            strcat(string,""corange"\n"cred"P.S. Respect administrators, they keep the gameplay clean and make everything to make your game on server more comfortable and interesting!\nDont break rules, if you don't want to get ban or another kind of punishment!");
			ShowPlayerDialog(playerid,1004,DSM,"Rules",string,"Back","Close");
			return 1;
		}
		if(listitem == 4) //Åñëè áûë âûáðàí 4 ïóíêò ñïèñêà
		{
			new string[1216];
		    format(string,sizeof string,""corange"General commands:");
		    strcat(string,""corange"\n\t"cred"Key Y"cwhite" - Open perks list");
            strcat(string,""corange"\n\t"cred"/report"cwhite" - Send report to online admins");
            strcat(string,""corange"\n\t"cred"/pm"cwhite" - Send private message");
            strcat(string,""corange"\n\t"cred"/tpm"cwhite" - Send private message to your team");
            strcat(string,""corange"\n\t"cred"/l"cwhite" - Local area chat");
            strcat(string,""corange"\n\t"cred"/me"cwhite" - Player expressive command (Player Action)");
            strcat(string,""corange"\n\t"cred"/shop"cwhite" - Show server's donation services");
            strcat(string,""corange"\n\t"cred"/admins"cwhite" - Check online admins");
            strcat(string,""corange"\n"cgreen"Survivor Commands:");
            strcat(string,""corange"\n\t"cred"/weapons"cwhite" - Set another earned weapons");
            strcat(string,""corange"\n\t"cred"/groupcreate"cwhite" - Create a group");
            strcat(string,""corange"\n\t"cred"/groupjoin ID"cwhite" - Join player's group");
            strcat(string,""corange"\n\t"cred"/groupmates"cwhite" - Check number of humans in your group");
            strcat(string,""corange"\n\t"cred"/groupinvite ID"cwhite" - Invite player to your group (only for leaders)");
            strcat(string,""corange"\n\t"cred"/delgmate ID"cwhite" - Kick player from your group (only for leaders)");
            strcat(string,""corange"\n\t"cred"/gc"cwhite" - Talk to your groupmates");
            strcat(string,""corange"\n"cpurple"Zombie Commands:");
            strcat(string,""corange"\n\t"cred"/hide"cwhite" - Allows zombie to hide on the passenger seat of vehicle");
            strcat(string,""corange"\n"cgold"Premium Member's Commands:");
            strcat(string,""corange"\n\t"cred"/setperk - /setSskin - /setZskin");
			ShowPlayerDialog(playerid,1005,DSM,"Commands",string,"Back","Close");
			return 1;
		}
		return 1;
	}
	InventoryOnDialogResponse(playerid, dialogid, response, inputtext);
    if(dialogid == Nozombieperkdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 0;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Hardbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 1;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Diggerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 2;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Refreshingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 3;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Jumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 4;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Deadsensedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 5;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Hardpunchdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 6;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Vomiterdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 7;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Screamerdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 8;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == ZBurstrundialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 9;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Stingerbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 10;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Bigjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 11;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Stompdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 12;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Refreshingbitedialog2)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 21;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Hemorrage)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 15;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == ThickSkin)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 13;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Goddigdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 14;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Poppingtiresdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 20;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Higherjumperdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 16;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Repellentdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 17;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Ravagingbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 18;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == Superscreamdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][ZPerk] = 19;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 61)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 23;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 60)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 22;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 62)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 24;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 63)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 25;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 64)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 26;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 65)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 27;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 66)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 28;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == HellScream)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 24;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
	if(dialogid == 67)
	{
	    if(!response) return 0;
	    PInfo[playerid][ZPerk] = 29;
	    SendClientMessage(playerid,white,""cblue"You have successfully changed your zombie perk!");
	}
    if(dialogid == Zombieperksdialog)
    {

        if(!response) return 0;
        if(listitem == 0)
        {
			ShowPlayerDialog(playerid,Nozombieperkdialog,0,""cred"None",""cwhite"You need to rank up to get a new perk!","Set","Cancel");
        }
        if(listitem == 1)
        {
			ShowPlayerDialog(playerid,Hardbitedialog,0,""cred"Hard BiTE",""cwhite"When this perk is activated, your bite damage increases\nAnd when you bite, you damage human a little more than usual","Set","Cancel");
        }
        if(listitem == 2)
        {
			ShowPlayerDialog(playerid,Diggerdialog,0,""cred"Digger",""cwhite"When humans are too far from you , you can activate this perk and teleport to the closest human around the map, \nThis perk will not work when zombies are near you. \nPress "cred"C "cwhite"to dig. Cooldown 3 minutes","Set","Cancel");
        }
        if(listitem == 3)
        {
			ShowPlayerDialog(playerid,Refreshingbitedialog,0,""cred"Refreshing BiTE",""cwhite"Bitting humans with this perk will grant you more HP","Set","Cancel");
        }
        if(listitem == 4)
        {
			ShowPlayerDialog(playerid,Jumperdialog,0,""cred"Jumper",""cwhite"When this perk is activated, you will jump higher \nThis perk will be useful, when you need to catch a human on a high building \n"cred"Just jump to use this perk, cooldown - 3 seconds","Set","Cancel");
        }
        if(listitem == 5)
        {
			ShowPlayerDialog(playerid,Deadsensedialog,0,""cred"Dead Sense",""cwhite"By activating this perk, you will see your other fellow zombies on radar","Set","Cancel");
        }
        if(listitem == 6)
        {
			ShowPlayerDialog(playerid,Hardpunchdialog,0,""cred"Hard punch",""cwhite"When you punch a human using this perk, Human will loose alot of HP and will be thrown far away.","Set","Close");
        }
        if(listitem == 7)
        {
			ShowPlayerDialog(playerid,Vomiterdialog,0,""cred"Vomiter",""cwhite"By activating this perk you can vomit a toxic meat. \nThis meat damages every human in the range of 5 meters, and it also damages vehicles\n"corange"Press "cred"CROUCH "corange"to vomit","Set","Close");
        }
        if(listitem == 8)
        {
			ShowPlayerDialog(playerid,Screamerdialog,0,""cred"Screamer",""cwhite"When you press "cred"RMB"cwhite", instead of bitting, you will scream\nWhen you scream, everyone human near you will get damaged and thrown away","Set","Close");
        }
        if(listitem == 9)
        {
			ShowPlayerDialog(playerid,ZBurstrundialog,0,""cred"Burst run",""cwhite"This perk works like Burst Run for humans without any changes\nPress"cred" SPRINT + CROUCH"cwhite" to use","Set","Close");
        }
        if(listitem == 10)
        {
			ShowPlayerDialog(playerid,Stingerbitedialog,0,""cred"Stinger bite",""cwhite"When you bite, humans will get a stopping effect"cred"\nHumans will be stopped for 2 seconds","Set","Close");
        }
        if(listitem == 11)
        {
			ShowPlayerDialog(playerid,Bigjumperdialog,0,""cred"Big jumper",""cwhite"This perk works like \"Jumper\" but instead it grants you to jump twice in a row.","Set","Close");
        }
        if(listitem == 12)
        {
			ShowPlayerDialog(playerid,Stompdialog,0,""cred"Stomp",""cwhite"When activated, every human in range of 10 meters will get stomping effect. \nIt works 5 seconds, press "cred"CROUCH"cwhite" to send a powerful earthquake\n"cred"Note: Cool down of 2 minutes.","Set","Close");
        }
        if(listitem == 13)
        {
			ShowPlayerDialog(playerid,ThickSkin,0,""cred"Thick Skin",""cwhite"When this perk is turned on you get a thick skin and you loose less HP when hit by a bullet. \n"cred"Just choose this perk to activate","Set","Close");
        }
        if(listitem == 14)
        {
			ShowPlayerDialog(playerid,Goddigdialog,0,""cred"God dig",""cwhite"This perk is same as Digger, But instead you can use god dig even if you have a zombie near by.\n"cred"NOTE: You can use this perk only one time per round","Set","Close");
        }
        if(listitem == 15)
        {
			ShowPlayerDialog(playerid,Hemorrage,0,""cred"Hemorrhage",""cwhite"When this perk is activated, you can spit some blood on humans\n"cred"Stay close to humans and press "cred"RMB "cwhite"to spit some blood on humans.","Set","Close");
        }
        if(listitem == 16)
        {
			ShowPlayerDialog(playerid,Higherjumperdialog,0,""cred"High Jumper",""cwhite"This perk is also as same as "cred"\"Jumper\" "cwhite"and "cred"\"Big Jumper\""cwhite", But instead you are able to jump four times in a row.","Set","Close");
        }
        if(listitem == 17)
        {
			ShowPlayerDialog(playerid,Repellentdialog,0,""cred"Repellent",""cwhite"With this perk, you will not be attractd by zombie baits.","Set","Close");
        }
        if(listitem == 18)
        {
			ShowPlayerDialog(playerid,Ravagingbitedialog,0,""cred"Ravaging Bite",""cwhite"It is the most powerful zombie bite perk at the moment \nWhen you bite a human, you do the same amount of damage with Hard Bite and you get healed with the same amount as Refreshing bite. \n"cred"Note: -10HP of damage on a victim and +6HP to you.","Set","Close");
        }
        if(listitem == 19)
        {
			ShowPlayerDialog(playerid,Superscreamdialog,0,""cred"Super Scream",""cwhite"This scream is a bit more powerful than usual scream.\nWhen you scream the victim will loose a little more HP than usual scream and vehicles will get effected too.","Set","Close");
        }
		if(listitem == 20)
        {
			ShowPlayerDialog(playerid,Poppingtiresdialog,0,""cred"Popping Tires",""cwhite"Activating this perk will be able to make you pierce through tire of a vehicle. \n"cred"USAGE: Press "cred"CROUCH "cwhite"Button to the closest vehicle to pierce its tires!","Set","Close");
        }
		if(listitem == 21)
        {
			ShowPlayerDialog(playerid,Refreshingbitedialog2,0,""cred"Extra Refreshing Bite",""cwhite"This perk is as same as \"Refreshing Bite\" but instead \nOn each Bite you will receive "cred"+10 HP!","Set","Close");
        }
		if(listitem == 22)
        {
			ShowPlayerDialog(playerid,60,0,""cred"God Sense",""cwhite"When you activate this perk, you will see everyone all around the map. \n"cred"NOTE: if player is not in the same interior with you, you won't see him on radar","Set","Close");
        }
        if(listitem == 23)
        {
        	ShowPlayerDialog(playerid,61,0,""cred"Blind Bite",""cwhite"Biting the human using this perk will make him blind, this effect disappears 2 seconds after the bite\n"cred"You can flash human every 6 seconds","Set","Close");
		}
		if(listitem == 24)
		{
		    ShowPlayerDialog(playerid,HellScream,0,""cred"Hell Scream",""cwhite"While you are screaming, Hell fire will come out from your mouth, this fire hurts everyone whoever you aim at and also this perk damages vehicles\n"cred"This scream have a smaller effective casualty radius and smaller throwing effect ","Set","Close");
		}
		if(listitem == 25)
		{
		    ShowPlayerDialog(playerid,63,0,""cred"Super Hard Punch",""cwhite"This perk have increased damage, throwing effect and extra ability, it is a seismic shock.\nWhen you punch human using this perk, he will be thrown farther and get critical damage\nIf you punch vehicle it will be discarded as well as the human\n"cred"Use C + SHIFT to use seismic shock\n"cred"NOTE: as long you press C + SHIFT, as larger will be effect","Set","Close");
		}
		if(listitem == 26)
		{
		    ShowPlayerDialog(playerid,64,0,""cred"Powerful Digger",""cwhite"It is a special dig. It has more features like faster teleportation\nAfter digging on human or a vehicle, In which a human is sitting, will be thrown in an upwards direction\n"cred"Use key CROUCH to dig","Set","Close");
		}
		if(listitem == 27)
		{
		    ShowPlayerDialog(playerid,65,0,""cred"GodLike Jumper",""cwhite"It is the most powerful jumper perk\nWith this perk you are able to jump 13 times in mid air","Set","Close");
		}
		if(listitem == 28)
		{
		    ShowPlayerDialog(playerid,66,0,""cred"Meat Sharing",""cwhite"Using this perk you can vomit a tasty meat for other zombies\nThis meat will give them HP\nBut this meat is not infinite, this meat can be bitten only 15 times and after that it dissapears\n"cred"It has a higher cooldown, so use it carefully!","Set","Close");
		}
		if(listitem == 29)
		{
		    ShowPlayerDialog(playerid,67,0,""cred"Toxic Bite",""cwhite"Upon biting humans using this perk will poison them, the toxin will damage them for 30 seconds\nAnd also it will effect humans with extra effects like dizzy, convulsions and partial blindness\nBut you need to eat another player's vomit, who have the same rank or higher rank than yours\nAfter bitting it, you could bite 3 time with this toxin\n"cred"Just bite human with this perk to inject toxin into human","Set","Close");
		}
		return 1;
	}
    if(dialogid == Noperkdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 0;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
    if(dialogid == Extramedsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 1;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extrafueldialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 2;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extraoildialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 3;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Lessbitedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 5;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
    if(dialogid == Flashbangsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 4;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Burstdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 6;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Medicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 7;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Morestaminadialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 8;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Zombiebaitdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 9;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Firemodedialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 10;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Mechanicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 11;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Extraammodialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 12;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Fielddoctordialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 13;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Rocketbootsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 14;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Homingbeacondialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 15;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Mastermechanicdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 16;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Flameroundsdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 17;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Luckycharmdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 18;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Grenadesdialog)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 19;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == UltimateExtraMeds)
	{
	    if(!response) return 0;
		PInfo[playerid][SPerk] = 20;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == PowerfulGloves)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 21;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 51)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 22;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 52)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 23;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 53)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 24;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 54)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 25;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 55)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 26;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 56)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 27;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 57)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 28;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == 58)
	{
		if(!response) return 0;
		PInfo[playerid][SPerk] = 29;
		SendClientMessage(playerid,white,""cblue"You have successfully changed your survivor perk.");
	}
	if(dialogid == Humanperksdialog)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
	        ShowPlayerDialog(playerid,Noperkdialog,0,""cred"None",""cwhite"You need to rank up to get a new perk!","Set","Cancel");
	    }
	    if(listitem == 1)
	    {
	        ShowPlayerDialog(playerid,Extramedsdialog,0,""cred"Extra meds",""cwhite"When you use any med kits from your inventory, you will got extra "cred"5 HP\nTIP: Press N to open your inventory","Set","Cancel");
	    }
	    if(listitem == 2)
	    {
	        ShowPlayerDialog(playerid,Extrafueldialog,0,""cred"Extra fuel",""cwhite"When you use any fuel from your inventory, you will pour extra fuel to your vehicle"cred"\nTIP: Use fuel from your inventory when you stay close enough to the vehicle","Set","Cancel");
	    }
	    if(listitem == 3)
	    {
	        ShowPlayerDialog(playerid,Extraoildialog,0,""cred"Extra oil",""cwhite"When you use any oil from your inventory, you will pour extra oil to your vehicle"cred"\nTIP: Use oil from your inventory when you stay close enough to the vehicle","Set","Cancel");
	    }
	    if(listitem == 4)
	    {
	        ShowPlayerDialog(playerid,Flashbangsdialog,0,""cred"Flashbangs",""cwhite"When you enter a checkpoint, you receive +3 flashbangs.\nWhen your throw flashbang, everyone in radius of 20 meters will get blindness effect\n"cred"Press CROUCH + SPACE to throw flashbang\nNOTE: As the longer you press CROUCH + SPACE, farther the flashbang will be thrown","Set","Cancel");
	    }
	    if(listitem == 5)
	    {
	        ShowPlayerDialog(playerid,Lessbitedialog,0,""cred"Less Bite Damage",""cwhite"When a zombie bites, you will take less damage\n"cred"This perk will not work when zombies are using perks such as \""cred"Screamer\" or \""cred"Hard Punch\""cwhite"!","Set","Cancel");
	    }
	    if(listitem == 6)
	    {
	        ShowPlayerDialog(playerid,Burstdialog,0,""cred"Burst Run",""cwhite"This perk gives you a quick burst of energy. It should be useful to get away from zombies on foot.\nOnce you can use it you must wait 3 minutes before using it again.\nWhen this perk is set press keys "cred"JUMP + CROUCH"cwhite" to activate. ","Set","Cancel");
	    }
	    if(listitem == 7)
	    {
	        ShowPlayerDialog(playerid,Medicdialog,0,""cred"Medic",""cwhite"You can assist humans with your med kits\nStay close to humans and use your med kits!","Set","Cancel");
	    }
	    if(listitem == 8)
	    {
	        ShowPlayerDialog(playerid,Morestaminadialog,0,""cred"More Stamina",""cwhite"When you are sprinting using this perk, you can sprint for a longer duration of time. i.e - 2 min\n"cred"Cool Down - 3 minutes","Set","Cancel");
	    }
	    if(listitem == 9)
	    {
	        ShowPlayerDialog(playerid,Zombiebaitdialog,0,""cred"Zombie bait",""cwhite"When you throw this bait, every zombie who is in range of 15 meters, will get attracted to the bait\nBe careful, when zombies use their \""cred"Repellent\" "cwhite"perk they won't get effected by this perk\n"cred"Press WALK + CROUCH to throw it, the longer you press it, farther the bait will be thrown\nCool Down is 1.5 minutes","Set","Cancel");
	    }
	    if(listitem == 10)
	    {
	        ShowPlayerDialog(playerid,Firemodedialog,0,""cred"Fire punch",""cwhite"Your fists acquire the power of Fire, when you punch a zombie, he will put on fire for a small period of time\n"cred"Fire Punch has cooldown of 10 second ","Set","Cancel");
	    }
	    if(listitem == 11)
	    {
	        ShowPlayerDialog(playerid,Mechanicdialog,0,""cred"Mechanic",""cwhite"Using this perk you can repair any car\nYou can easily repair cars when they are too damaged\n"cred"Press CROUCH close to a broken vehicle to repair it","Set","Cancel");
	    }
	    if(listitem == 12)
	    {
	        ShowPlayerDialog(playerid,Extraammodialog,0,""cred"Sure foot",""cwhite"When zombies scream at you, you will stick to the surface\nSo you won't be thrown away","Set","Cancel");
	    }
	    if(listitem == 13)
	    {
	        ShowPlayerDialog(playerid,Fielddoctordialog,0,""cred"Field Doctor",""cwhite"This perk is better than Medic\nNow you can assist not only meds kits with other human\nYou can aso assist Dizzy Away pills to other survivors","Set","Cancel");
	    }
	    if(listitem == 14)
	    {
	        ShowPlayerDialog(playerid,Rocketbootsdialog,0,""cred"Rocket Boots",""cwhite"Using this perk will give you Rocket Boots that allows you to jump much higher and farther than normal.\nWhen this perk is set simply press key "cred"JUMP"cwhite" to activate. \n"cred"You can only jump once every 8 seconds.","Set","Cancel");
	    }
	    if(listitem == 15)
	    {
	        ShowPlayerDialog(playerid,Homingbeacondialog,0,""cred"Homing Beacon",""cwhite"If you need any help you can send special signal for other humans \"Signal Flare\"\nBut be careful using this per, some zombies can see the signal too\n"cred"Press WALK + CROUCH to send signal","Set","Cancel");
	    }
	    if(listitem == 16)
	    {
	        ShowPlayerDialog(playerid,Mastermechanicdialog,0,""cred"Master Mechanic",""cwhite"You have perfect mechanic skill and you can easily fix all vehicles \n"cred"Press CROUCH close to broken vehicles to fix them","Set","Cancel");
	    }
	    if(listitem == 17)
	    {
	        ShowPlayerDialog(playerid,Flameroundsdialog,0,""cred"Flame rounds",""cwhite"Military have a good terms with you\nThey have new bullets with unusual metal, This bullets can burn zombies\nWhen you shoot at them, they will get fire affect for 5 seconds"cred"\nNOTE: Go to CP to get Flame Rounds","Set","Cancel");
	    }
     	if(listitem == 18)
	    {
	        ShowPlayerDialog(playerid,Luckycharmdialog,0,""cred"Lucky Charm",""cwhite"While you are searching you can activate this perk and when you search again you will get extra 20\% chance to find anything","Set","Cancel");
	    }
	    if(listitem == 19)
	    {
	        ShowPlayerDialog(playerid,Grenadesdialog,0,""cred"Grenades",""cwhite"The Military finally seems to trust you enough to hand you some Grenades.\nJust set this perk before walking into a Military Checkpoint to recieve 3 grenades.\n"cred"NOTE: If you activate this perk before you join a team, you will get grenades after spawn!","Set","Cancel");
	    }
	    if(listitem == 20)
	    {
	        ShowPlayerDialog(playerid,UltimateExtraMeds,0,""cred"Ultimate Extra Meds",""cwhite"Your meds have unusual structure\nAnd with this structure med kits will give you extra +"cred"10 HP","Set","Cancel");
	    }
	    if(listitem == 21)
	    {
	        ShowPlayerDialog(playerid,PowerfulGloves,0,""cred"Powerful Gloves",""cwhite"These gloves are very strong and unbreakable \nWhen you use these gloves, all zombies in the range of 15 meters will be thrown away. \n"cred"NOTE: Click C to use your gloves!\nGloves have cooldown on 1.5 minutes! ","Set","Cancel");
	    }
	    if(listitem == 22)
	    {
	        ShowPlayerDialog(playerid,51,0,""cred"Sustained Immunity",""cwhite"While this perk is active you will get you will recieve less damage when zombies bite you\nthis perk comes with one with useful effect \nWhen zombie bites they have to wait a couple of seconds before biting you again","Set","Cancel");
	    }
	    if(listitem == 23)
	    {
	        ShowPlayerDialog(playerid,52,0,""cred"Master Radar",""cwhite"When you enter to CP with this perk, you will get a new item in your inventory\nThis special radar allows you to see zombies and humans all over the map\nIt works 30 seconds!","Set","Cancel");
	    }
	    if(listitem == 24)
	    {
	        ShowPlayerDialog(playerid,53,0,""cred"Fusion Boots",""cwhite"These boots are modified verison of rocket boots\nThey will let you jump twice a row in the middle of air\n"cred"You can jump twice in every 13 seconds","Set","Cancel");
	    }
	    if(listitem == 25)
	    {
	        ShowPlayerDialog(playerid,54,0,""cred"Freezing Greeting",""cwhite"Activate this perk before you enter CP\nWhen you enter a CP with this perk every zombie in CP will freeze for 5 seconds\nIt will help you clear CP easier\n"cred"NOTE: Humans won't get effect","Set","Cancel");
	    }
	    if(listitem == 26)
	    {
	        ShowPlayerDialog(playerid,55,0,""cred"Exploding Bait",""cwhite"It is a zombie bait with grenade inside\nWhen you throw it you need to stay from it as far as you can\nIt will explode in 5 seconds after it has made a contact with the surface\n"cred"CoolDown - 3 minutes","Set","Cancel");
	    }
	    if(listitem == 27)
	    {
	        ShowPlayerDialog(playerid,56,0,""cred"Medical Flag",""cwhite"You have created a special flag with medical effect\nAfter placing this flag, every survivor in the radius of the flag will get +5 HP every 3 seconds\n"cred"Press WALK + CROUCH to place the flag (it works 30 seconds), CoolDown - 5 minutes","Set","Cancel");
	    }
	    if(listitem == 28)
	    {
	        ShowPlayerDialog(playerid,57,0,""cred"Shadow Warrior",""cwhite"While this perk is active, you will disspear from zombie's radar, and also zombies can't dig to you\n"cred"NOTE: You need to know that zombies can dig to you only with using God Dig \nAnd also they can see you on map if they are using God Sense","Set","Cancel");
	    }
	    if(listitem == 29)
	    {
	        ShowPlayerDialog(playerid,58,0,""cred"Assault Grenade Launcher",""cwhite"When you get rank 30 you get new weapon AK-47\nIt will become more powerful with this perk\nWhen you enter to CP with this perk, you will get 1 suitable grenade launcher and 1 bullet with grenade\n"cred"When you have 1 or more bullet grenades, you can use it by aiming with AK-47\n"cred"While you are aiming press SHIFT+LMB to shoot","Set","Cancel");
	    }
	    return 1;
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
			KillTimer(LoginTimer[playerid]);
			SendFMessage(playerid,white,"|| "cgreen"Welcome back, %s!",GetPName(playerid));
			LoadStats(playerid);
			if(PInfo[playerid][Training] == 1)
			{
   				ShowPlayerDialog(playerid,999,DSM,"Training course",""cwhite"You haven't passed training course!\nDo you want to continue?", "Yes","No");
			}
			PInfo[playerid][Logged] = 1;
			PInfo[playerid][Failedlogins] = 0;
			if(PInfo[playerid][Premium] == 1)
			    SendFMessage(playerid,white,"*"cgold"Thanks for supporting our community, Gold member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 2)
			    SendFMessage(playerid,white,"*"cplat"Thanks for supporting our community, Platinum member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 3)
			    SendFMessage(playerid,white,"*"cblue"Thanks for supporting our community, Diamond member %s!",GetPName(playerid));
            if(Team[playerid] != 0)
			{
			    ResetPlayerWeapons(playerid);
			    if(Team[playerid] == ZOMBIE)
				{
				    Team[playerid] = ZOMBIE;
				    SetSpawnInfo(playerid,0,ZombieSkins[random(sizeof(ZombieSkins))],0,0,0,0,0,0,0,0,0,0);
				    SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
				    SetPlayerColor(playerid,purple);
				    PInfo[playerid][CanBite] = 1;
				    SetPlayerHealth(playerid,100);
				}
			  	else if(Team[playerid] == HUMAN)
				{
				    Team[playerid] = HUMAN;
				    static sid;
					ChooseSkin: sid = random(299);
					sid = random(299);
					for(new i = 0; i < sizeof(ZombieSkins); i++)
					{
						if(sid == ZombieSkins[i]) goto ChooseSkin;
					}
					if((sid == 0) || (sid == 74) || (sid == 92) || (sid == 99))
					    goto ChooseSkin;
			    	SetSpawnInfo(playerid,0,sid,0,0,0,0,0,0,0,0,0,0);
				    SetPlayerSkin(playerid,sid);
				    PInfo[playerid][JustInfected] = 0;
				    PInfo[playerid][Infected] = 0;
					PInfo[playerid][Dead] = 0;
					PInfo[playerid][CanBite] = 1;
					SetPlayerColor(playerid,green);
					SetPlayerHealth(playerid,100);
				}
				SpawnPlayer(playerid);
				SendClientMessage(playerid, white, ""cwhite"** "cred"GameMode Detected your team: You were automatically setted to your previous team");
				PInfo[playerid][Spawned] = 1;
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
	    return 1;
	}
	if(dialogid == Registerdialog)
	{
	    if(!response) return Kick(playerid);
        if(strlen(inputtext) < 3 || strlen(inputtext) > 22)
	    {
			new string[1025];
			strcat(string,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.04.92"cred" BETA");
			strcat(string,""cwhite"\n Team Death Match Server "cgreen"Survivors "cwhite"VS "cpurple"Zombies");
		 	strcat(string,""cwhite"\n Script Author: "dred"Zackster, Flexx");
            strcat(string,""cwhite"\n Main Map: "dred"Alan, Ze_D(aka. timurbboy), Zackster");
        	strcat(string,""cwhite"\n Special Thanks: "dred"Beta Testers, "cblue"Cyber_Punk "dred"(Original Gamemode Idea), "cplat"Platinum"dred","cgold" Gold "dred"and "cblue"Diamond members!\n\n\n\n\n");
        	strcat(string,""cwhite"\t\t\t        You must to "cred"register "cwhite"to play on server!\n\t\t\t        Your password mustn't have less than 3 or more than 22!");
			ShowPlayerDialog(playerid,Registerdialog,3,"Ultimate - Gaming.com",string,"Register","Quit");
		}
	    else
	    {
	        static buf[131];
    		WP_Hash(buf, sizeof (buf), inputtext);
    		RegisterPlayer(playerid,buf);
    		ShowPlayerDialog(playerid,999,DSM,"Training course",""cwhite"Do you want to pass training course on the server?", "Yes","No");
		}
		return 1;
	}
	if(dialogid == ShopDialog)
	{
		if(!response) return 0;
	    if(listitem == 0)
	    {
			static string[530];
			format(string,sizeof string,""cwhite"In our official website you can get some donate \"ZMoney\" \n");
			strcat(string,"\nWith ZMoney you can buy some useful things that can help you with many things, or just diversifies the game \n");
			strcat(string,"\nFor example: if you buy "cgold"Platinum"cwhite" premium, you will get extra xp for killing or infecting, more info you can check by clicking on it \n");
			strcat(string,"\nFor more info check our forum "cblue"Ultimate-Gaming.com"cwhite" there you will find guide how to donate \n");
			strcat(string,"\nSo, Good Luck And Have FUN!!!");
			ShowPlayerDialog(playerid,1154,0,"FAQ",string,"Back","Close");
		}
		if(listitem == 1)
		{
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
		return 1;
	}
	if(dialogid == 1154)
	{
		if(!response) return 0;
	    else
	    {
        	static Main[60];
			format(Main, sizeof Main,""cgreen"Your ZMoney: "cred"%i",PInfo[playerid][ZMoney]);
			ShowPlayerDialog(playerid,ShopDialog,2,Main,"FAQ\nServices","Choose","Exit");
		}
		return 1;
	}
	if(dialogid == 1156)
	{
        if(!response) return 0;
        if(listitem == 0)
        {
            ShowPlayerDialog(playerid,1157,0,""cgold"Gold Premium",""cwhite"After purchasing you will get \n8 of every item in inventory\nCommands: "cred"/setperk /setSskin /setZskin\n\n"cwhite"Are you sure that you want buy"cgold"Gold Premium?","Buy","Back");
        }
        if(listitem == 1)
        {
            ShowPlayerDialog(playerid,1158,0,""cplat"Platinum Premium",""cwhite"After purchasing you will get \n13 of every item in inventory\nYou will spawn in special "cplat"Platinum"cwhite" Spawn\nCommands: "cred"/setperk /setSskin /setZskin\n\n"cwhite"Are you sure that you want to buy "cplat"Platinum Premium?","Buy","Back");
        }
        if(listitem == 2)
        {
            ShowPlayerDialog(playerid,1161,0,""cblue"Diamond Premium",""cwhite"After purchasing you will get \n18 of every item in inventory\nYou will spawn in special "cblue"Diamond"cwhite" Spawn\nDecreased cooldown for perks\nCommands: "cred"/setperk /setSskin /setZskin\n\n"cwhite"Are you sure that you want to buy "cblue"Diamond Premium?","Buy","Back");
        }
        if(listitem == 3)
        {
            ShowPlayerDialog(playerid,1159,0,""corange"x2 XP",""cwhite"After purchasing you will get "corange"x2 "cwhite"more than usual\nAfter killing or infecting and for assists too\n\nAre you sure that you want to buy "corange"x2 XP pack?","Buy","Back");
        }
        if(listitem == 4)
        {
            ShowPlayerDialog(playerid,1160,0,""dred"x3 XP",""cwhite"After purchasing you will get "corange"x3 "cwhite"more than usual\nAfter killing or infecting and for assists too\n\nAre you sure that you want to buy "dred"x3 XP pack?","Buy","Back");
        }
   		if(listitem == 5)
        {
            ShowPlayerDialog(playerid,1162,0,""cgreen"Stats Reset",""cwhite"After purchasing your statictics will be setted to 0 \n(Kills, Deaths, Assists, Cleared CPs, Infecteds, Vomiteds and Screameds\n\n"cwhite"Are you sure that you want to "cgreen"Reset your Stats?","Buy","Back");
        }
        if(listitem == 6)
        {
            ShowPlayerDialog(playerid,1163,0,""cred"Nickname Change",""cwhite"After using nickname changer \nYou can change your nickname you want\nThe new nickname mustn't break the server rule\n\n"cwhite"Are you sure that you want to "cred"Change your nickname?","Buy","Back");
        }
        return 1;
	}
	if(dialogid == 1157)
	{
        if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,""cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1750)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cgold" Gold Premium");
   					if(Team[playerid] == HUMAN)
						SetPlayerArmour(playerid,100);
			        AddItem(playerid,"Small Med Kits",8);
			     	AddItem(playerid,"Medium Med Kits",8);
				    AddItem(playerid,"Large Med Kits",8);
				    new year,month,day;
				    getdate(year,month,day);
      				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("PremiumYear",year);
   	 				INI_WriteInt("PremiumDay",day);
    				INI_WriteInt("PremiumMonth",month+1);
					INI_WriteInt("SSkin",1);
					INI_WriteInt("ZSkin",78);
					INI_Save();
    				INI_Close();
				    AddItem(playerid,"Fuel",8);
				    AddItem(playerid,"Oil",8);
				    AddItem(playerid,"Flashlight",8);
				    AddItem(playerid,"Dizzy Away",8);
			    	PInfo[playerid][Premium] = 1;
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumMonth] = month+1;
					SaveStats(playerid);
					static string[128];
					format(string,sizeof string,"* "corange"Your premium will expire at %i.%i.%i",month+1,day,year);
					SendClientMessage(playerid,white,string);
					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 1750;
				}
				else
				{
				    SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
				}
			}
		}
		return 1;
	}
	if(dialogid == 1162)
	{
        if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
		else
		{
		    if(PInfo[playerid][ZMoney] < 500) return SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
		    PInfo[playerid][Kills] = 0;
		    PInfo[playerid][Deaths] = 0;
		    PInfo[playerid][Infects] = 0;
		    PInfo[playerid][CPCleared] = 0;
		    PInfo[playerid][Bites] = 0;
		    PInfo[playerid][Teamkills] = 0;
		    PInfo[playerid][sAssists] = 0;
		    PInfo[playerid][zAssists] = 0;
			PInfo[playerid][Vomited] = 0;
			PInfo[playerid][Screameds] = 0;
			SaveStats(playerid);
			PInfo[playerid][ZMoney] -= 500;
		}
		return 1;
	}
	if(dialogid == 1163)
	{
 		if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
	    else
	    {
	        if(PInfo[playerid][Premium] == 0)
	        {
   		    	if(PInfo[playerid][ZMoney] < 200) return SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
        		PInfo[playerid][ZMoney] -= 200;
        		PInfo[playerid][ChangingName] = 1;
        		ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cwhite"This is nickname changer dialog\nWrite your new nickname below\n"cred"NOTE:"cwhite" If you close this dialog server will give your ZMoney back\nThe same will happen if server will restart or you will be crashed\n\n\t\tWrite your new nickname below.","Change","Cancel");
			}
			else
			{
 				ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cwhite"This is nickname changer dialog\nWrite your new nickname below\n"cred"NOTE:"cwhite" If you close this dialog server will give your ZMoney back\nThe same will happen if server will restart or you will be crashed\n\n\t\tWrite your new nickname below.","Change","Cancel");
			    PInfo[playerid][ChangingName] = 1;
			}
		}
		return 1;
	}
	if(dialogid == 1355)
	{
		static file[500];
		format(file,sizeof file,Userfile,inputtext);
		new oldnickname[40];
		GetPlayerName(playerid,oldnickname,40);
	    if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
	    else
	    {
	        if((strlen(inputtext) < 3) || (strlen(inputtext) > 20)) return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"ERROR: "cwhite"New nickname mustn't be longer 20 charactes and less than 3 characters\n\n\t\tWrite your new nickname below.","Change","Cancel");
            if(fexist(file)) return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"ERROR: "cwhite"Someone is already have this nickname! \nYou should change to another\n\n\tWrite your new nickname below.","Change","Cancel");
            switch(SetPlayerName(playerid, inputtext))
            {
		        case -1: return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"ERROR: "cwhite"New nickname has invalid characters\nYou need to change it to another\n\n\tWrite your new nickname below.","Change","Cancel");
		        case 0: return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"ERROR: "cwhite"You already have this nickname!\nChoose new nickname!\n\n\twrite your new nickname below.","Change","Cancel");
			    case 1:
	        	{
	        	    SaveStats(playerid);
	        	    static fale[128];
					static password[256];
					format(fale,sizeof fale,Userfile,oldnickname);
					INI_Open(fale);
					INI_ReadString(password,"Password");
				 	INI_Close();
				 	format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
					INI_WriteString("Password",password);
					INI_WriteInt("SSkin",1);
					INI_WriteInt("ZSkin",78);
				    INI_Save();
				 	INI_Close();
				 	new filen[85];
				 	format(filen, sizeof filen,"Admin/Users/%s.ini",oldnickname);
	                fremove(filen);
	                PInfo[playerid][DeletedAcc] = 1;
	                new string[128];
	                SendClientMessage(playerid,white,"** "cgreen"You have successfully changed your nickname!");
                    format(string,sizeof string,"** "cgreen"Your new nickname is %s",GetPName(playerid));
                    SendClientMessage(playerid,white,string);
					SendClientMessage(playerid,white,"** "cgreen"Change your nickname in SAMP client and enjoy.");
	                SendClientMessage(playerid,white,"** "cgreen"Your old nickname was deleted from our database.");
	                PInfo[playerid][ChangingName] = 0;
					SetTimerEx("kicken",750,false,"i",playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == 1161)
	{
 		if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,""cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1750)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cblue" Diamond Premium");
   					if(Team[playerid] == HUMAN)
						SetPlayerArmour(playerid,300);
		    		new year,month,day;
				    getdate(year,month,day);
			        AddItem(playerid,"Small Med Kits",19);
			     	AddItem(playerid,"Medium Med Kits",19);
				    AddItem(playerid,"Large Med Kits",19);
				    AddItem(playerid,"Fuel",19);
				    AddItem(playerid,"Oil",19);
				    AddItem(playerid,"Flashlight",19);
				    AddItem(playerid,"Dizzy Away",19);
			    	PInfo[playerid][Premium] = 3;
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("PremiumYear",year);
   	 				INI_WriteInt("PremiumDay",day);
    				INI_WriteInt("PremiumMonth",month+1);
					INI_WriteInt("SSkin",1);
					INI_WriteInt("ZSkin",78);
					INI_Save();
    				INI_Close();
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumMonth] = month+1;
					SaveStats(playerid);
					static string[128];
					format(string,sizeof string,"* "corange"Your premium will expire at %i.%i.%i",month+1,day,year);
					SendClientMessage(playerid,white,string);
					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 4500;
				}
				else
				{
				    SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
				}
			}
		}
		return 1;
	}
	if(dialogid == 1158)
	{
 		if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,""cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 2500)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cplat" Platinum Premium");
   					if(Team[playerid] == HUMAN)
						SetPlayerArmour(playerid,150);
			        AddItem(playerid,"Small Med Kits",13);
			     	AddItem(playerid,"Medium Med Kits",13);
				    AddItem(playerid,"Large Med Kits",13);
				    AddItem(playerid,"Fuel",13);
				    AddItem(playerid,"Oil",13);
				    AddItem(playerid,"Flashlight",13);
				    AddItem(playerid,"Dizzy Away",13);
				    new year,month,day;
				    getdate(year,month,day);
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("PremiumYear",year);
   	 				INI_WriteInt("PremiumDay",day);
    				INI_WriteInt("PremiumMonth",month+1);
					INI_WriteInt("SSkin",1);
					INI_WriteInt("ZSkin",78);
					INI_Save();
    				INI_Close();
			    	PInfo[playerid][Premium] = 2;
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumMonth] = month+1;
					SaveStats(playerid);
					static string[128];
					format(string,sizeof string,"* "corange"Your premium will expire at %i.%i.%i",month+1,day,year);
					SendClientMessage(playerid,white,string);
					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 2500;
				}
				else
				{
				    SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
				}
			}
		}
		return 1;
	}
	if(dialogid == 1159)
	{
        if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][ExtraXP] > 0) return SendClientMessage(playerid,white,""cred"Error: You already have an extra XP pack!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 800)
                {
                    SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"corange" x2 XP pack");
                    PInfo[playerid][ExtraXP] = 1;
                    PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 800;
				    new year,month,day;
				    getdate(year,month,day);
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("ExtraXPYear",year);
   	 				INI_WriteInt("ExtraXPDay",day);
    				INI_WriteInt("ExtraXPMonth",month+1);
    				INI_Close();
					static string[128];
					format(string,sizeof string,"* "corange"Your Extra XP Pack will expire at %i.%i.%i",month+1,day,year);
					SendClientMessage(playerid,white,string);
    				PInfo[playerid][ExtraXPYear] = year;
			    	PInfo[playerid][ExtraXPDay] = day;
			    	PInfo[playerid][ExtraXPMonth] = month+1;
                    SaveStats(playerid);
				}
				else
				{
				    SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
				}
			}
		}
		return 1;
	}
	if(dialogid == 1160)
	{
        if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"Free","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][ExtraXP] > 0) return SendClientMessage(playerid,white,""cred"Error: You already have an extra XP pack!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1250)
                {
                    SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"dred" x3 XP pack");
                    PInfo[playerid][ExtraXP] = 2;
				    new year,month,day;
				    getdate(year,month,day);
                    PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 1250;
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("ExtraXPYear",year);
   	 				INI_WriteInt("ExtraXPDay",day);
    				INI_WriteInt("ExtraXPMonth",month+1);
    				INI_Close();
					static string[128];
					format(string,sizeof string,"* "corange"Your Extra XP Pack will expire at %i.%i.%i",month+1,day,year);
					SendClientMessage(playerid,white,string);
 					PInfo[playerid][ExtraXPYear] = year;
			    	PInfo[playerid][ExtraXPDay] = day;
			    	PInfo[playerid][ExtraXPMonth] = month+1;
                    SaveStats(playerid);
				}
				else
				{
				    SendClientMessage(playerid,white,""cred"Error: You haven't got enough ZMoney to buy this item!");
				}
			}
		}
		return 1;
	}
	if(dialogid == 1155)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
        	static Main[60];
			format(Main, sizeof Main,""cgreen"Your ZMoney: "cred"%i",PInfo[playerid][ZMoney]);
			ShowPlayerDialog(playerid,ShopDialog,2,Main,"FAQ\nServices","Choose","Exit");
		}
		return 1;
	}
	if(dialogid == DonateDialog)
	{
        if(!response) return 0;
        if(!strlen(inputtext)) return ShowPlayerDialog(playerid,DonateDialog,1,""cred"Donate menu",""cwhite"Please, write your promocode below!","Activate","Close");
        new donate;
        new file = ini_openFile("Promocodes.ini");
        if(ini_getInteger(file, inputtext, donate) == 0)
        {
        	if(donate == 1)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"5000 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 5000;
				ini_removeKey(file,inputtext);
			}
			else if(donate == 2)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"2500 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 2500;
				ini_removeKey(file,inputtext);
			}
			else if(donate == 3)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"1000 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 1000;
				ini_removeKey(file,inputtext);
			}
			else if(donate == 4)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"500 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 500;
				ini_removeKey(file,inputtext);
			}
			else if(donate == 5)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"250 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 250;
				ini_removeKey(file,inputtext);
			}
			else if(donate == 6)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"100 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 100;
				ini_removeKey(file,inputtext);
			}
			ini_removeKey(file,inputtext);
        }
		else
		{
		    SendClientMessage(playerid, red, ""cwhite"* "cred"Error: promocode doesn't found, check your promocode again!");
		}
        ini_closeFile(file);
        return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
	/*new Float: velocity; GetPlayerVelocity(playerid, velocity, velocity, velocity);
	if(velocity < 0.0 && WaitAirCheat[playerid] == 0)
	{
		WaitAirCheat[playerid]=2;
	}
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
	{
       new pname[MAX_PLAYER_NAME];
       GetPlayerName(playerid, pname, sizeof(pname));
       new string[128];
       format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using JetPack",GetPName(playerid));
       SendClientMessageToAll(red,string);
       Kick(playerid);
	}
	if(Team[playerid] == HUMAN)
	{
		new gun[] = {46,38,37,36,35,45,44,43,42,41,11,12,13,14}; // id's çàïðåùåííîãî îðóæèÿ äëÿ èãðîêîâ.
		for(new i= 0;i<sizeof(gun);i++)
		{
			if(gun[i] == GetPlayerWeapon(playerid))
			{
	  			new string[128];
	     		format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Weapon Hacks",GetPName(playerid));
	       		SendClientMessageToAll(red,string);
				SetTimerEx("kicken",200,false,"i",playerid);
				return true;
			}
		}
	}*/
	if(Team[playerid] == ZOMBIE)
	{
	    SetPlayerArmedWeapon(playerid,0);
	}
	if( GetPlayerMoney ( playerid ) != eGetPlayerMoney ( playerid ) ) ResetPlayerMoney( playerid ), GivePlayerMoney( playerid, eGetPlayerMoney ( playerid ) );
	if(IsPlayerNPC(playerid))return 1;
	/*if(GetPlayerState(playerid)==PLAYER_STATE_ONFOOT)
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
	}*/
	if(!IsPlayerInAnyVehicle(playerid))
	{
	     new animlib[30], animname[30];
	     new Float:vx,Float:vy,Float:vz;
	     GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
	     new Float:posx, Float:posy, Float:posz;
	     GetPlayerPos(playerid, posx, posy, posz);
	     if(posz >= 2)//???? posz ????? ???? ?????? 2 ??????, ??....
	     {
	        GetPlayerVelocity(playerid,vx,vy,vz);
	        if(((vx > 4) || (vx < -4)) || ((vy > 4) || (vy < -4)) || ((vz > 4) || (vz < -4)))
	        {
	             if(strcmp(animlib, "SWIM", true) == 0 && strcmp(animname, "SWIM_crawl", true) == 0)//????????? ?? ????????, ???? ??? ????? ??....
	             {
                     new plname[MAX_PLAYER_NAME];//??????????
                     GetPlayerName(playerid, plname, sizeof(plname));//?????? ??? ??????
	             }
			}
		}
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
    PInfo[playerid][Warns] = INI_ReadInt("Warns");
    PInfo[playerid][Muted] = INI_ReadInt("Muted");
    PInfo[playerid][ExtraXP] = INI_ReadInt("ExtraXP");
    PInfo[playerid][MuteTimer] = INI_ReadInt("MuteTimer");
    PInfo[playerid][Jailed] = INI_ReadInt("Jailed");
    PInfo[playerid][JailTimer] = INI_ReadInt("JailTimer");
    PInfo[playerid][TrainingPhase] = INI_ReadInt("TrainingPhase");
    PInfo[playerid][ZMoney] = INI_ReadInt("ZMoney");
    PInfo[playerid][sAssists] = INI_ReadInt("sAssists");
    PInfo[playerid][zAssists] = INI_ReadInt("zAssists");
    PInfo[playerid][ExtraXPDay] = INI_ReadInt("ExtraXPDay");
    PInfo[playerid][AllowedToTip] = INI_ReadInt("AllowedToTip");
    PInfo[playerid][ExtraXPMonth] = INI_ReadInt("ExtraXPMonth");
    PInfo[playerid][ExtraXPYear] = INI_ReadInt("ExtraXPYear");
    PInfo[playerid][PremiumDay] = INI_ReadInt("PremiumDay");
    PInfo[playerid][PremiumMonth] = INI_ReadInt("PremiumMonth");
    PInfo[playerid][PremiumYear] = INI_ReadInt("PremiumYear");
    PInfo[playerid][SkillPoints] = INI_ReadInt("SkillPoints");
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
    INI_WriteInt("HoursPlayed",0);
    INI_WriteInt("TenHoursAch",0);
    INI_WriteInt("PlayedMinutes",0);
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
    INI_WriteInt("Premium",PInfo[playerid][Premium]);
	INI_WriteInt("PremiumYear",PInfo[playerid][PremiumYear]);
	INI_WriteInt("PremiumMonth",PInfo[playerid][PremiumMonth]);
	INI_WriteInt("PremiumDay",PInfo[playerid][PremiumDay]);
	INI_WriteInt("ExtraXPYear",PInfo[playerid][ExtraXPYear]);
	INI_WriteInt("ExtraXPMonth",PInfo[playerid][ExtraXPMonth]);
	INI_WriteInt("ExtraXPDay",PInfo[playerid][ExtraXPDay]);
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
    INI_WriteInt("JailTimer",PInfo[playerid][JailTimer]);
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
	static string[7];
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
	static string[7];
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

function UpdateStatsForPlayer(playerid)
{
	if(PInfo[playerid][Spawned] == 0) return 0;
	if(PInfo[playerid][Dead] == 1) return 0;
	if(GetPlayerPing(playerid) > 500)
	{
		static string[128];
		format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected a High Ping - %s Kicked for 500+ Ping",GetPName(playerid));
		SendClientMessageToAll(white,string);
		SetTimerEx("kicken",50,false,"i",playerid);
	}
	new Float:vhealth;
    GetVehicleHealth(GetPlayerVehicleID(playerid),vhealth);
    if(vhealth <= 250)
    {
		StartVehicle(GetPlayerVehicleID(playerid),0);
		WasVehicleDamaged[GetPlayerVehicleID(playerid)] = 1;
		VehicleStarted[GetPlayerVehicleID(playerid)] = 0;
		SetVehicleHealth(GetPlayerVehicleID(playerid),300);
	}
	new strang[64];
	format(strang,sizeof strang,"XP: %i/%i",PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
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
		TextDrawShowForPlayer(playerid,XPBox);
	}
	else if(XPs >=100)
	{
		TextDrawTextSize(XPLEFT[playerid], -150, 18.019538);
		TextDrawTextSize(XPRIGHT[playerid], 150, 18.019538);
		TextDrawShowForPlayer(playerid,XPBox);
	}
	if(Team[playerid] == HUMAN)
	{
	    static string[228];
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
	}
	else if(Team[playerid] == ZOMBIE)
	{
	    static string[228];
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
	    Extra1XP = PInfo[playerid][XP] - PInfo[playerid][XPToRankUp];
	    PInfo[playerid][Rank]++;
	    PInfo[playerid][XP] = Extra1XP;
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
				SetPlayerSkillLevel(playerid,0,999);
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
				SendClientMessage(playerid,white,"** "cred"You have opened perk boosting services! (press SPACE + ALT)");

			}
            case 20:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
                SendClientMessage(playerid,white,"** "cjam"Zombie's health increased to 225! "cred"(Max Zombie's Health get!)");
			}
            case 25:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
			}
            case 30:
            {
                SendClientMessage(playerid,white,"** "corange"You've got new weapons for human class!");
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
		CheckRankup(playerid);
  		SetPlayerScore(playerid,PInfo[playerid][Rank]);
  		if(Team[playerid] == HUMAN) GiveRankGun(playerid);
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
  	TextDrawShowForPlayer(playerid,Stats[playerid]);
	return 1;
}

function UpdateStats()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Logged] == 1) SetPlayerScore(i,PInfo[i][Rank]);
	    if(PInfo[i][Spawned] == 0) continue;
        if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == HUMAN)
	    {
		    static string[228];
		    TextDrawHideForPlayer(i,RageTD[i]);
			TextDrawShowForPlayer(i,XPBox);
			if(PInfo[i][Flashed] == 0)
			{
				if(PInfo[i][Premium] == 1)
					format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else if(PInfo[i][Premium] == 2)
				    format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
   				else if(PInfo[i][Premium] == 3)
				    format(string,sizeof string,""cblue"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else
				    format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				Update3DTextLabelText(PInfo[i][Ranklabel],green,string);
			}
			static Float:health;
		    GetPlayerHealth(i,health);
			MakeHealthEven(i,health);
			GetPlayerHealth(i,health);
			if(PInfo[i][Swimming] == 1)
			{
				SetPlayerHealth(i,health-4);
				GetPlayerHealth(i,health);
				SendClientMessage(i,white,"*** "cred"GO OUT FROM THE WATER, IT IS INFECTED!!!");
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
				        if(IsPlayerInRangeOfPoint(i,3.0,Locations[0][0],Locations[0][1],Locations[0][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for bottles.",3000,3);
				        }
				    }
				    if(MissionPlace[i][0] == 2)
				    {
				        if(IsPlayerInRangeOfPoint(i,3.0,Locations[1][0],Locations[1][1],Locations[1][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for bottles.",3000,3);
				        }
				    }
				}
				if(MissionPlace[i][1] == 2) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 3)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,212.0680,-102.1175,1005.2578/*Locations[2][0],Locations[2][1],Locations[2][2]*/))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some clothes.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 4)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[3][0],Locations[3][1],Locations[3][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some clothes.",3000,3);
				        }
					}
				}
				if(MissionPlace[i][1] == 3) //From 1 to 3, to know if its clothes, liquid or cans.
				{
				    if(MissionPlace[i][0] == 5)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[4][0],Locations[4][1],Locations[4][2]))
				        {
				            GameTextForPlayer(i,"~w~Press ~r~~h~Crouch ~w~to search for some glue.",3000,3);
				        }
					}
					else if(MissionPlace[i][0] == 6)
				    {
                        if(IsPlayerInRangeOfPoint(i,3.0,Locations[5][0],Locations[5][1],Locations[5][2]))
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
    	    static string[228];
			if(PInfo[i][Flashed] == 0)
			{
				if(PInfo[i][Premium] == 1)
					format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else if(PInfo[i][Premium] == 2)
				    format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else if(PInfo[i][Premium] == 3)
				    format(string,sizeof string,""cblue"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				else
				    format(string,sizeof string,""cpurple"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				Update3DTextLabelText(PInfo[i][Ranklabel],green,string);
			}
		    /*format(string,sizeof string,"XP: %i/%i",PInfo[i][XP],PInfo[i][XPToRankUp]);
	  		TextDrawSetString(XPStats[i],string);*/
			TextDrawShowForPlayer(i,XPStats[i]);
			TextDrawShowForPlayer(i,XPBox);
			if(PInfo[i][RageModeStatus] == 100)
			{
		        static Rangest[33];
		        format(Rangest,sizeof Rangest,"Press N for rage mode");
		        TextDrawLetterSize(RageTD[i], 0.257444, 1.342782);
		        TextDrawSetString(RageTD[i],Rangest);
			}
			else
			{
				static Rangest[25];
				format(Rangest,sizeof Rangest,"RAGE: %i%",PInfo[i][RageModeStatus]);
				TextDrawLetterSize(RageTD[i], 0.360444, 1.312782);
				TextDrawSetString(RageTD[i],Rangest);
			}
			TextDrawShowForPlayer(i,RageTD[i]);
			if(PInfo[i][Hiden] != 1)
			{
				format(string,sizeof string,"Rank: %i | XP: %i/%i",PInfo[i][Rank],PInfo[i][XP],PInfo[i][XPToRankUp]);
				Update3DTextLabelText(PInfo[i][Ranklabel],purple,string);
			}
			new Float:Health;
		    GetPlayerHealth(i,Health);
		    if(Health >= 5 && Health <= 10)
				SetPlayerHealth(i,5);
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
			if((GetTickCount() - PInfo[i][Allowedtovomit]) >= VOMITTIME && PInfo[i][Vomitmsg] == 0)
			    SendClientMessage(i,red,"You have your stomach full (vomit ready)"),PInfo[i][Vomitmsg] = 1;
			if((GetTickCount() - PInfo[i][CanJump] >= 3500)) PInfo[i][Jumps] = 0;
		}
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
		if(PInfo[i][PoisonDizzy] == 1)
		{
			SetPlayerWeather(i,1447);
			SetPlayerTime(i,23,00);
			SetPlayerDrunkLevel(i,10000);
		}
		else if(PInfo[i][Infected] == 1)
		{
			SetPlayerWeather(i,345);
			SetPlayerTime(i,23,00);
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
	for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
	{
		if(!IsVehicleOccupied(i)) continue;
		if(!IsVehicleStarted(i)) continue;
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
    for(new i; i < MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i)) continue;
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
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
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
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,51),GivePlayerWeapon(playerid,15,1); //Silenced Pistol + Knuckles + Cane
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,68),GivePlayerWeapon(playerid,15,1);//Silenced Pistol + Knuckles + Cane
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,85),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,102),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,129),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,146),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,155),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,164),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 9: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,173),GivePlayerWeapon(playerid,6,1);//2 dual pistols + Knuckles + shovel
		    case 10: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,182),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,25);//2 dual pistols + Knuckles + shovel+shotgun
		    case 11: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,191),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,30);//2 dual pistols + Knuckles + shovel+shotgun
		    case 12: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,208),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,35);//2 dual pistols + Knuckles + shovel+shotgun
		    case 13: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,225),GivePlayerWeapon(playerid,6,1),GivePlayerWeapon(playerid,25,40);//2 dual pistols +Knuckles + shovel+Shotgun
		    case 14: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,242),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,45);//2 dual pistols +Knuckles + BaseBall Bat + Shotgun
		    case 15: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,35),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,50);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 16: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,42),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,55);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 17: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,49),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,60);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 18: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,56),GivePlayerWeapon(playerid,5,1),GivePlayerWeapon(playerid,25,65);//Deagle +Knuckles + BaseBall Bat + Shotgun
		    case 19: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,63),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,70);//Deagle +Knuckles + knife + Shotgun
		    case 20: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,70),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,75),GivePlayerWeapon(playerid,28,100),GivePlayerWeapon(playerid,33,20); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 21: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,77),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,80),GivePlayerWeapon(playerid,28,125),GivePlayerWeapon(playerid,33,30); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 22: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,84),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,85),GivePlayerWeapon(playerid,28,150),GivePlayerWeapon(playerid,33,40); //Deagle +Knuckles + knife + Shotgun + UZIS+ rifle
		    case 23: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,91),GivePlayerWeapon(playerid,4,1),GivePlayerWeapon(playerid,25,90),GivePlayerWeapon(playerid,28,175),GivePlayerWeapon(playerid,33,50); //Deagle +Knuckles + knife + Shotgun + UZIS + rifle
		    case 24: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,98),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,25,100),GivePlayerWeapon(playerid,28,200),GivePlayerWeapon(playerid,33,60); //Deagle +Knuckles + Night Stick + Shotgun + UZIS + rifle
		    case 25: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,105),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,32),GivePlayerWeapon(playerid,28,225),GivePlayerWeapon(playerid,33,70); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 26: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,112),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,36),GivePlayerWeapon(playerid,28,250),GivePlayerWeapon(playerid,33,80); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 27: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,119),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,40),GivePlayerWeapon(playerid,28,275),GivePlayerWeapon(playerid,33,90); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 28: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,126),GivePlayerWeapon(playerid,3,1),GivePlayerWeapon(playerid,26,44),GivePlayerWeapon(playerid,28,300),GivePlayerWeapon(playerid,33,100); //Deagle +Knuckles + Night Stick + Sawn-off Shotgun + UZIS + rifle
		    case 29: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,133),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,48),GivePlayerWeapon(playerid,28,350),GivePlayerWeapon(playerid,33,110); //Deagle +Knuckles + Katana + Sawn-off Shotgun + UZIS + rifle
		    case 30: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,140),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,52),GivePlayerWeapon(playerid,32,150),GivePlayerWeapon(playerid,30,60),GivePlayerWeapon(playerid,33,120); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 31: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,147),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,56),GivePlayerWeapon(playerid,32,175),GivePlayerWeapon(playerid,30,90),GivePlayerWeapon(playerid,33,130); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
			case 32: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,154),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,60),GivePlayerWeapon(playerid,32,200),GivePlayerWeapon(playerid,30,120),GivePlayerWeapon(playerid,33,140); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 33: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,161),GivePlayerWeapon(playerid,8,1),GivePlayerWeapon(playerid,26,64),GivePlayerWeapon(playerid,32,225),GivePlayerWeapon(playerid,30,150),GivePlayerWeapon(playerid,33,150); //Deagle +Knuckles + Katana + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 34: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,168),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,26,80),GivePlayerWeapon(playerid,32,250),GivePlayerWeapon(playerid,30,180),GivePlayerWeapon(playerid,33,160); //Deagle +Knuckles + ChainSaw + Sawn-off Shotgun + Tec 9 + AK-47 + rifle
            case 35: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,175),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,42),GivePlayerWeapon(playerid,32,275),GivePlayerWeapon(playerid,30,210),GivePlayerWeapon(playerid,33,170); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 36: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,182),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,49),GivePlayerWeapon(playerid,32,300),GivePlayerWeapon(playerid,30,240),GivePlayerWeapon(playerid,33,180); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 37: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,189),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,56),GivePlayerWeapon(playerid,32,325),GivePlayerWeapon(playerid,30,270),GivePlayerWeapon(playerid,33,190); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 38: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,196),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,63),GivePlayerWeapon(playerid,32,350),GivePlayerWeapon(playerid,30,300),GivePlayerWeapon(playerid,33,200); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 39: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,203),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,70),GivePlayerWeapon(playerid,32,375),GivePlayerWeapon(playerid,30,330),GivePlayerWeapon(playerid,33,210); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 40: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,210),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,77),GivePlayerWeapon(playerid,32,400),GivePlayerWeapon(playerid,31,100),GivePlayerWeapon(playerid,33,220); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + AK-47 + rifle
			case 41: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,217),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,84),GivePlayerWeapon(playerid,32,425),GivePlayerWeapon(playerid,31,125),GivePlayerWeapon(playerid,33,230); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 42: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,224),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,91),GivePlayerWeapon(playerid,32,450),GivePlayerWeapon(playerid,31,150),GivePlayerWeapon(playerid,33,240); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 43: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,231),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,98),GivePlayerWeapon(playerid,32,475),GivePlayerWeapon(playerid,31,175),GivePlayerWeapon(playerid,33,250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 44: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,238),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,105),GivePlayerWeapon(playerid,32,500),GivePlayerWeapon(playerid,31,200),GivePlayerWeapon(playerid,33,275); //Deagle +Knuckles + ChainSaw + SPAZ 12 + Tec 9 + M4A1 + rifle
			case 45: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,245),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,112),GivePlayerWeapon(playerid,29,90),GivePlayerWeapon(playerid,31,225),GivePlayerWeapon(playerid,34,25); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 46: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,252),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,119),GivePlayerWeapon(playerid,29,120),GivePlayerWeapon(playerid,31,250),GivePlayerWeapon(playerid,34,30); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 47: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,259),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,126),GivePlayerWeapon(playerid,29,150),GivePlayerWeapon(playerid,31,275),GivePlayerWeapon(playerid,34,35); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 48: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,266),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,133),GivePlayerWeapon(playerid,29,180),GivePlayerWeapon(playerid,31,300),GivePlayerWeapon(playerid,34,40); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 49: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,273),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,140),GivePlayerWeapon(playerid,29,210),GivePlayerWeapon(playerid,31,325),GivePlayerWeapon(playerid,34,45); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 50: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,280),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,175),GivePlayerWeapon(playerid,29,240),GivePlayerWeapon(playerid,31,350),GivePlayerWeapon(playerid,34,50); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle
			case 51..100: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,24,350),GivePlayerWeapon(playerid,9,1),GivePlayerWeapon(playerid,27,12500),GivePlayerWeapon(playerid,29,2100),GivePlayerWeapon(playerid,31,3000),GivePlayerWeapon(playerid,34,1250); //Deagle +Knuckles + ChainSaw + SPAZ 12 + SMG + M4A1 + Sniper rifle

		}
	}
	SetPlayerScore(playerid,PInfo[playerid][Rank]);
	return 1;
}

function RandomCheckpoint()
{
	new rand = random(17);
	CPID = rand;
	if(RoundEnded == 1) return 0;
	if(rand == 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
			if(!IsPlayerConnected(i)) continue;
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
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerConnected(i)) continue;
	        if(Team[i] == ZOMBIE) continue;
	        if(PInfo[i][Training] == 1) continue;
	        if(PInfo[i][Jailed] == 1) continue;
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
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(PInfo[i][Firstspawn] == 1) continue;
		    if(Team[i] == ZOMBIE) infects++;
		}
		new infections = floatround(100.0 * floatdiv(infects, PlayersConnected));
	    if((CPscleared == 5) && (infections >= 60))
	    {
	        if(SupplyDirect == -1)
	    		SetTimer("DropSupply",30000,false);
		}
	    static string2[96];
	    format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
   		TextDrawSetString(CPSCleared,string2);
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerConnected(i)) continue;
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
        		static string[7];
				if(PInfo[i][Premium] == 2)
				{
				    if(PInfo[i][ExtraXP] == 0)
				    {
		        		PInfo[i][XP] += 22;
		        		PInfo[i][CurrentXP] += 22;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				    if(PInfo[i][ExtraXP] == 1)
				    {
		        		PInfo[i][XP] += 44;
		        		PInfo[i][CurrentXP] += 44;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				    if(PInfo[i][ExtraXP] == 2)
				    {
		        		PInfo[i][XP] += 66;
		        		PInfo[i][CurrentXP] += 66;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				}
				else if(PInfo[i][Premium] == 3)
				{
				    if(PInfo[i][ExtraXP] == 0)
				    {
		        		PInfo[i][XP] += 24;
		        		PInfo[i][CurrentXP] += 24;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				    if(PInfo[i][ExtraXP] == 1)
				    {
		        		PInfo[i][XP] += 48;
		        		PInfo[i][CurrentXP] += 48;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				    if(PInfo[i][ExtraXP] == 2)
				    {
		        		PInfo[i][XP] += 72;
		        		PInfo[i][CurrentXP] += 72;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				}
				else
				{
				    if(PInfo[i][ExtraXP] == 0)
				    {
		        		PInfo[i][XP] += 20;
		        		PInfo[i][CurrentXP] += 20;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
					if(PInfo[i][ExtraXP] == 1)
				    {
		        		PInfo[i][XP] += 40;
		        		PInfo[i][CurrentXP] += 40;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
					if(PInfo[i][ExtraXP] == 2)
				    {
		        		PInfo[i][XP] += 60;
		        		PInfo[i][CurrentXP] += 60;
						format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					}
				}
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
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerConnected(i)) continue;
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
	    	format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
	   		TextDrawSetString(CPSCleared,string2);
		    for(new i; i < MAX_PLAYERS; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
		        //GameTextForPlayer(i,string2,4000,3);
				if(PInfo[i][Logged] == 0) continue;
			    TextDrawHideForPlayer(i,CPbar[i]);
			    TextDrawHideForPlayer(i,CPbartext[i]);
			    TextDrawHideForPlayer(i,CPvaluebar[i]);
			    TextDrawHideForPlayer(i,CPvaluepercent[i]);
	        	PInfo[i][Firsttimeincp] = 1;
	        	if(IsPlayerInCheckpoint(i) && Team[i] == HUMAN)
	        	{
	        		SendClientMessage(i,white,"** "cred"The Military seems to be leaving, so should you.");
	        		static string[7];
					if(PInfo[i][Premium] == 2)
					{
					    if(PInfo[i][ExtraXP] == 0)
					    {
			        		PInfo[i][XP] += 22;
			        		PInfo[i][CurrentXP] += 22;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					    if(PInfo[i][ExtraXP] == 1)
					    {
			        		PInfo[i][XP] += 44;
			        		PInfo[i][CurrentXP] += 44;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					    if(PInfo[i][ExtraXP] == 2)
					    {
			        		PInfo[i][XP] += 66;
			        		PInfo[i][CurrentXP] += 66;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					}
					else if(PInfo[i][Premium] == 3)
					{
					    if(PInfo[i][ExtraXP] == 0)
					    {
			        		PInfo[i][XP] += 24;
			        		PInfo[i][CurrentXP] += 24;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					    if(PInfo[i][ExtraXP] == 1)
					    {
			        		PInfo[i][XP] += 48;
			        		PInfo[i][CurrentXP] += 48;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					    if(PInfo[i][ExtraXP] == 2)
					    {
			        		PInfo[i][XP] += 72;
			        		PInfo[i][CurrentXP] += 72;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					}
					else
					{
					    if(PInfo[i][ExtraXP] == 0)
					    {
			        		PInfo[i][XP] += 20;
			        		PInfo[i][CurrentXP] += 20;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
						if(PInfo[i][ExtraXP] == 1)
					    {
			        		PInfo[i][XP] += 40;
			        		PInfo[i][CurrentXP] += 40;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
						if(PInfo[i][ExtraXP] == 2)
					    {
			        		PInfo[i][XP] += 60;
			        		PInfo[i][CurrentXP] += 60;
							format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
						}
					}
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
	if(PInfo[playerid][Rank] == 22) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 23) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 24) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 25) return ShowPlayerDialog(playerid,Humanperksdialog,2,
	"Survivor perks","1\tNone\n2\tExtra meds \n3\tExtra fuel \n4\tExtra oil \n5\tFlashbang Grenades \
	\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait \n11\tFire punch \n12\tMechanic \n13\tSure Foot \n14\tField Doctor \n15\tRocket Boots \n16\tHoming Beacon \
	\n17\tMaster Mechanic \n18\tFlame Rounds \n19\tLucky charm \n20\tGrenades \n21\tUltimate Extra Meds \
    \n22\tPowerful Gloves\n23\tSustained Immunity\n24\tMaster Radar\n25\tFusion Boots","Choose","Cancel");
   	if(PInfo[playerid][Rank] == 26)
	{
		new string[3500];
		format(string,sizeof string,"1\tNone\n2\tExtra meds\n3\tExtra fuel\n4\tExtra oil\n5\tFlashbang Grenades");
		strcat(string,"\n6\tLess BiTE Damage\n7\tBurst Run\n8\tMedic\n9\tMore stamina\n10\tZombie Bait\n11\tFire punch\n12\tMechanic\n13\tSure Foot\n14\tField Doctor\n15\tRocket Boots\n16\tHoming Beacon");
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
		strcat(string,"\n6\tLess BiTE Damage\n7\tBurst Run\n8\tMedic\n9\tMore stamina\n10\tZombie Bait\n11\tFire punch");
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
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina \n10\tZombie Bait ");
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
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina");
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
		strcat(string,"\n6\tLess BiTE Damage \n7\tBurst Run \n8\tMedic \n9\tMore stamina");
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
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStop\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
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
    SetTimerEx("UpdateOil",50,false,"i",vehicleid);
	if(Fuel[vehicleid] == 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(FuelTD[i],"Fuel: ~r~~h~-");
				GameTextForPlayer(i,"~n~~n~~r~~h~No fuel left!",4000,3);
				if(PInfo[i][Rank] < 5)
				{
					SendClientMessage(i,white,"* "corange"No fuel left, you can fill your car, using your fuel from inventory, or find another car!");
				}
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	else if((Fuel[vehicleid] > 0) && (Fuel[vehicleid] < 2))
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
	else if((Fuel[vehicleid] >= 2) && (Fuel[vehicleid] <3))
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
	else if((Fuel[vehicleid] >= 3) && (Fuel[vehicleid] <4))
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
	else if((Fuel[vehicleid] >= 4) && (Fuel[vehicleid] <5))
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
	else if((Fuel[vehicleid] >= 5) && (Fuel[vehicleid] <6))
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
	else if((Fuel[vehicleid] >= 6) && (Fuel[vehicleid] <7))
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
	else if((Fuel[vehicleid] >= 7) && (Fuel[vehicleid] <8))
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
	else if((Fuel[vehicleid] >= 8) && (Fuel[vehicleid] <9))
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
	else if((Fuel[vehicleid] >= 9) && (Fuel[vehicleid] < 10))
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
	else if(Fuel[vehicleid] >= 10)
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
	return 1;
}

function UpdateOil(vehicleid)
{
	if(Oil[vehicleid] == 0)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
		    if(!IsPlayerConnected(i)) continue;
		    if(Team[i] == ZOMBIE) continue;
			if(IsPlayerInVehicle(i,vehicleid))
			{
				TextDrawSetString(OilTD[i],"Oil: ~r~~h~-");
				GameTextForPlayer(i,"~n~~n~~r~~h~No oil left!",4000,3);
				if(PInfo[i][Rank] < 5)
				{
					SendClientMessage(i,white,"* "corange"No oil left, you can fill your car, using your oil from inventory, or find another car!");
				}
			}
		}
		StartVehicle(vehicleid,0);
		VehicleStarted[vehicleid] = 0;
	}
	else if((Oil[vehicleid] > 0) && (Oil[vehicleid] <2))
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
	else if((Oil[vehicleid] >= 2) && (Oil[vehicleid] <3))
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
	else if((Oil[vehicleid] > 3) && (Oil[vehicleid] <4))
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
	else if((Oil[vehicleid] >=4) && (Oil[vehicleid] <5))
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
	else if((Oil[vehicleid] >= 5) && (Oil[vehicleid] <6))
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
	else if((Oil[vehicleid] >= 6) && (Oil[vehicleid] <7))
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
	else if((Oil[vehicleid] >= 7) && (Oil[vehicleid] <8))
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
	else if((Oil[vehicleid] >= 8) && (Oil[vehicleid] <9))
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
	else if((Oil[vehicleid] >= 9) && (Oil[vehicleid] < 10))
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
	else if(Oil[vehicleid] >= 10)
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
	if(WasVehicleDamaged[GetPlayerVehicleID(playerid)] == 0)
	{
		new rand = random(2);
		if(rand == 0) return SendClientMessage(playerid,white,"**"cred"Starting Vehicle Failed!"cwhite"**"),PInfo[playerid][StartCar] = 0;
		else
		{
		    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
		    StartVehicle(GetPlayerVehicleID(playerid),1);
		    PInfo[playerid][StartCar] = 0;
		    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
		    SetTimerEx("UpdateVehicleFuelAndOil",650,false,"i",playerid);
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
		    SetTimerEx("UdpateStaredVeh",650,false,"i",playerid);
		    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
		}
		else return SendClientMessage(playerid,white,"**"cred"Starting Vehicle Failed!"cwhite"**"),PInfo[playerid][StartCar] = 0;
	}
	return 1;
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
    if(IsPlayerNPC(playerid))return 1;
	static string[100];
  	if(!strcmp(ItemName,"Large Med Kits",true))
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
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player doesn't need medical attention.");
            SetPlayerHealth(id,health+35.0);
            RemoveItem(playerid,"Large Med Kits",1);
            format(string,sizeof string,""cjam"%s has assisted %s with a Large med kit.",GetPName(playerid),GetPName(id));
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 66.0) SetPlayerHealth(id,100.0);
		}
		else
		{
            RemoveItem(playerid,"Large Med Kits",1);
			format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and is feeling much better.",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(health > 99.0) SetPlayerHealth(playerid,100.0);
			if(PInfo[playerid][SPerk] != 1)
			{
				if(health > 65.0) SetPlayerHealth(playerid,100.0);
				else SetPlayerHealth(playerid,health+35.0);
			}
			if(PInfo[playerid][SPerk] == 1)
			{
			    if(health > 60.0) SetPlayerHealth(playerid,100.0);
				else SetPlayerHealth(playerid,health+40.0);
			}
			if(PInfo[playerid][SPerk] == 20)
			{
			    if(health > 55.0) SetPlayerHealth(playerid,100.0);
			    else SetPlayerHealth(playerid,health+45.0);
			}
		}
  	}
  	if(!strcmp(ItemName,"Medium Med Kits",true))
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
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player doesn't need medical attention.");
            SetPlayerHealth(id,health+25.0);
            format(string,sizeof string,""cjam"%s has assisted %s with a medium med kit.",GetPName(playerid),GetPName(id));
            RemoveItem(playerid,"Medium Med Kits",1);
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health >= 100.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and feels ok.",GetPName(playerid));
	        RemoveItem(playerid,"Medium Med Kits",1);
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(health > 76.0) SetPlayerHealth(playerid,100.0);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+25.0);
			else SetPlayerHealth(playerid,health+30.0);
			if(PInfo[playerid][SPerk] == 20)
			{
			    SetPlayerHealth(playerid,health+35.0);
			}
			if(health >= 75.0) SetPlayerHealth(playerid,100.0);
		}
  	}
  	if(!strcmp(ItemName,"Radar",true))
  	{
  	    if(PInfo[playerid][MasterRadared] == 1)
  	    {
  	        KillTimer(PInfo[playerid][DestroyRadar]);
		}
  	    format(string,sizeof string,"* "cjam"%s turned on his radar.",GetPName(playerid));
  	    RemoveItem(playerid,"Radar",1);
  	    SendNearMessage(playerid,white,string,20);
  	    PInfo[playerid][MasterRadared] = 1;
  	    PInfo[playerid][DestroyRadar] = SetTimerEx("TurnOffRadar",65000,false,"i",playerid);
	}

  	if(!strcmp(ItemName,"Small Med Kits",true))
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
			if(health >= 100.0) return SendClientMessage(playerid,white,"* "cred"This player doesn't need medical attention."),SetPlayerHealth(id,100.0);
            SetPlayerHealth(id,health+15.0);
            RemoveItem(playerid,"Small Med Kits",1);
            format(string,sizeof string,""cjam"%s has assisted %s with a small med kit.",GetPName(playerid),GetPName(id));
			SendNearMessage(playerid,white,string,20);
			GetPlayerHealth(id,health);
            if(health > 86.0) SetPlayerHealth(id,100.0);
		}
		else
		{
	        RemoveItem(playerid,"Small Med Kits",1);
	        format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and feels slighty better.",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(PInfo[playerid][SPerk] != 1) SetPlayerHealth(playerid,health+15.0);
			else SetPlayerHealth(playerid,health+20.0);
			if(PInfo[playerid][SPerk] == 20)
			{
			    SetPlayerHealth(playerid,health+25.0);
			}
			if(health > 86.0) SetPlayerHealth(playerid,100.0);
		}
  	}
    if(!strcmp(ItemName,"Fuel",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"» You need to get out of the vehicle!");
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"» First you need to exit your vehicle!");
        if(Fuel[vehid] >= 10) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't need anymore fuel.");
        RemoveItem(playerid,"Fuel",1);
        format(string,sizeof string,""cjam"%s adds some Fuel to the vehicle.",GetPName(playerid));
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 2) Fuel[vehid]+=2;
		else Fuel[vehid]+=1.5;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Oil",true))
    {
        static vehid;
        vehid = -1;
        vehid = GetClosestVehicle(playerid,4.0);
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"» You need to get out of the vehicle!");
        if(vehid == -1) return SendClientMessage(playerid,red,"» You aren't near a vehicle!");
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"» First you need to exit your vehicle!");
        if(Oil[vehid] >= 10) return SendClientMessage(playerid,white,"» "cred"This vehicle doesn't need anymore oil.");
        RemoveItem(playerid,"Oil",1);
        format(string,sizeof string,""cjam"%s adds some Oil to the vehicle.",GetPName(playerid));
        SendNearMessage(playerid,white,string,20);
		if(PInfo[playerid][SPerk] == 3) Oil[vehid]+=2;
		else Oil[vehid]+=1.5;
		UpdateVehicleFuelAndOil(vehid);
    }
    if(!strcmp(ItemName,"Dizzy Away",true))
    {
        if(PInfo[playerid][PoisonDizzy] == 1)
        {
            PInfo[playerid][PoisonDizzy] = 0;
            SetPlayerDrunkLevel(playerid,0);
		}
        if(PInfo[playerid][SPerk] != 13)
        {
        	PInfo[playerid][TokeDizzy] = 1;
        	RemoveItem(playerid,"Dizzy Away",1);
        	format(string,sizeof string,""cjam"%s has taken some dizzy away pills.",GetPName(playerid));
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
        	format(string,sizeof string,""cjam"%s has assisted %s some dizzy away pills.",GetPName(playerid),GetPName(id));
        	RemoveItem(playerid,"Dizzy Away",1);
        	SendNearMessage(playerid,white,string,20);
  		}
    }
    if(!strcmp(ItemName,"Flashlight",true))
    {
        if(PInfo[playerid][Lighton] == 1)
        {
			RemovePlayerAttachedObject(playerid,4);
			PInfo[playerid][Lighton] = 0;
			format(string,sizeof string,""cjam"%s has turned off his flashlight.",GetPName(playerid));
			KillTimer(FlashLightTimer[playerid]);
			SendNearMessage(playerid,white,string,30);
       	}
        else
        {
			SetPlayerAttachedObject(playerid, 4, 18641, 5, 0.1, 0.02, -0.05, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);
			PInfo[playerid][Lighton] = 1;
			format(string,sizeof string,""cjam"%s has turned on his flashlight.",GetPName(playerid));
			SendClientMessage(playerid,white,""cwhite"** "cred"You can turn your flashlight off by selecting it from the inventory. "cwhite"**");
			FlashLightTimer[playerid] = SetTimerEx("FlashLightOn",1000,true,"i",playerid);
			SendNearMessage(playerid,white,string,30);
    	}
	}
	if(!strcmp(ItemName,"Molotov Guide"))
	{
	    if(Mission[playerid] == 1) return SendClientMessage(playerid,white,"* "corange"You have already started Molotov mission! You need to complete previous mission to start new Molotov mission again!");
	    RemoveItem(playerid,"Molotov Guide",1);
	    new rand = random(2);
		switch(rand)
		{
		    case 0:
		    {
				SendClientMessage(playerid,white,"* "corange"Head over to Pig Pen to get some alcohol");
				Mission[playerid] = 1;
				MissionPlace[playerid][0] = 1;
			 	MissionPlace[playerid][1] = 1;
			 	SetPlayerMapIcon(playerid,1,Locations[0][3],Locations[0][4],Locations[0][5],19,0,MAPICON_GLOBAL);
				FirstStepMolotov[playerid] = CreatePickup(1551,1,1215.3832,-13.3531,1000.9219,0);
			}
			case 1:
			{
				SendClientMessage(playerid,white,"* "corange"Head over to Alhambra to get some alcohol");
				Mission[playerid] = 1;
				MissionPlace[playerid][0] = 2;
			 	MissionPlace[playerid][1] = 1;
			 	SetPlayerMapIcon(playerid,1,Locations[1][3],Locations[1][4],Locations[1][5],19,0,MAPICON_GLOBAL);
                FirstStepMolotov[playerid] = CreatePickup(1551,1,502.3529,-15.2895,1000.6719,0);
			}
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
	    PInfo[i][EatenBait] = 0;
	    PInfo[i][CanZombieRun] = 1;
	    if(!IsPlayerConnected(i)) continue;
   		if(PInfo[i][Dead] == 1) continue;
	    if(Team[i] == HUMAN) continue;
		if(IsPlayerInRangeOfPoint(i,15.0,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
		for(new f; f < MAX_PLAYERS;f++)
		{
		    ClearAnimations(i,1);
		    PInfo[i][CanVel] = 0;
		}
	}
	PInfo[playerid][ZX] = 0.0;
	DestroyObject(PInfo[playerid][ZObject]);
	PInfo[playerid][ZombieBait] = 0;
 	PInfo[playerid][ThrowingBaitPhase1] = 1;
    PInfo[playerid][ThrowingBaitPhase2] = 0;
    PInfo[playerid][ThrowingBaitPhase3] = 0;
    PInfo[playerid][ThrowingBaitPhase4] = 0;
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
		if(health <= 4)
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
		    SetPlayerHealth(playerid,health-4);
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
	    SetTimerEx("AffectFireBull",750,false,"ii",playerid,id);
        static Float:health;
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
		    SetPlayerHealth(playerid,health-7);
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

/*function RandomSounds()
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
*/
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

new ExplosionObjective;

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
	PInfo[playerid][NormalTP] = 1;
	SetPlayerPos(playerid,x,y+1,z+1);
	WaitAirCheat[playerid]=2;
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	return 1;
}

function DigToPlayer27perk(playerid,id)
{
    ClearAnimations(playerid);
    SetPlayerInterior(playerid,GetPlayerInterior(id));
	new Float:x,Float:y,Float:z,Float:vx,Float:vy,Float:vz,Float:vhx,Float:vhy,Float:vhz;
	GetPlayerPos(id,x,y,z);
	PInfo[playerid][NormalTP] = 1;
	SetPlayerPos(playerid,x,y+1,z+1);
	GetPlayerVelocity(playerid,vx,vy,vz);
	SetPlayerVelocity(playerid,vx,vy,vz*2);
	if(!IsPlayerInAnyVehicle(id))
	{
		GetPlayerVelocity(id,vx,vy,vz);
		SetPlayerVelocity(id,vx,vy,vz+5);
	}
	else
	{
    	GetVehicleVelocity(GetPlayerVehicleID(id),vhx,vhy,vhz);
    	SetVehicleVelocity(GetPlayerVehicleID(id),vhx,vhy,vhz+0.035);
    	SetVehicleAngularVelocity(GetPlayerVehicleID(id),0,0,0);
	}
	WaitAirCheat[id]=2;
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
function VomitShareMeat(playerid)
{

	new Float:x,Float:y,Float:z,string[128],Float:a;
	PInfo[playerid][SMeatBite] = 15;
	GetPlayerPos(playerid,x,y,z);
	format(string,sizeof string,"* "cjam"%s vomited tasty meat for other zombies! Bite it and get few HP!",GetPName(playerid));
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(!IsPlayerConnected(i)) continue;
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
	PInfo[playerid][LabelMeatForShare] = Create3DTextLabel(strang,white,PInfo[playerid][MeatSX],PInfo[playerid][MeatSY],PInfo[playerid][MeatSZ]+0.4,15,0,1);
	return 1;
}
function VomitPlayer(playerid)
{
	DestroyObject(PInfo[playerid][Vomit]);
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
	PInfo[playerid][VomitDamager] = SetTimerEx("VomitDamageTimer",2000,true,"i",playerid);
	return 1;
}

function MakeHealthEven(playerid,Float:health)
{
	if(health == 1) return 0;
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
                SetTimerEx("EndRound",3000,false,"i",1);
				GameTextForAll("~n~~b~ The round has ended...",1250,3);
				RoundEnded = 1;
    			for(new i; i < MAX_PLAYERS; i ++)
		        {
					SetTimerEx("EndRoundDarking",400,false,"i",i);
					TextDrawBoxColor(Dark[i], 0x00000010);
				}
			}
		}
		infects = 0;
	}
	else TextDrawSetString(Infection,"Infection: ~r~~h~0%");
	if(CPscleared >= 8)
	{
	    if(RoundEnded == 0)
	    {
     		for(new i; i < MAX_PLAYERS; i ++)
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
	for(new i; i < MAX_PLAYERS;i++)
	{
	    TextDrawHideForPlayer(i,Dark[i]);
	    if(!IsPlayerConnected(i)) continue;
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
		for(new i; i < MAX_PLAYERS; i++)
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
		GameTextForAll("~h~~g~Survivors Win! ~h~~g~~n~Humans have cleared all of the ~r~CheckPoints~g~~h~!",3000,3);
		for(new i; i < MAX_PLAYERS; i++)
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
    SetTimer("EndRoundFinal",5000,false);
   	for(new i; i < MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i)) continue;
		GameTextForPlayer(i,"~b~Thanks for playing ~n~~b~Los - Santos Zombie Apocalypse!!!",4500,3);
	}
	return 1;
}

function EndRoundFinal()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		GameTextForPlayer(i,"~w~Please wait~n~~g~~h~You will be ~r~reconnected!",6000,3);
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
    new Float:Ranger = 999.9;
    new id = -1;
    for(new i; i < MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i)) continue;
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

function AllowToBlinded(i)
{
    PInfo[i][CanBeBlinded] = 1;
    return 1;
}

function BlindPlayer(playerid)
{
	TextDrawShowForPlayer(playerid,Effect[0]);
	for(new i; i < MAX_PLAYERS; i++)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,0);
	}
	SetTimerEx("BlindHuman2", 750, false, "i", playerid);
	return 1;
}
function BlindHuman2(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[0]);
	TextDrawShowForPlayer(playerid,Effect[1]);
	SetTimerEx("BlindHuman3", 300, false, "i", playerid);
	return 1;
}

function BlindHuman3(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[1]);
	TextDrawShowForPlayer(playerid,Effect[2]);
	SetTimerEx("BlindHuman4", 300, false, "i", playerid);
	return 1;
}

function BlindHuman4(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[2]);
	TextDrawShowForPlayer(playerid,Effect[3]);
	SetTimerEx("BlindHuman5", 300, false, "i", playerid);
	return 1;
}

function BlindHuman5(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[3]);
	TextDrawShowForPlayer(playerid,Effect[4]);
	SetTimerEx("BlindHuman6", 150, false, "i", playerid);
	return 1;
}

function BlindHuman6(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[5]);
	TextDrawShowForPlayer(playerid,Effect[6]);
	for(new i; i < MAX_PLAYERS; i++)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,1);
	}
	SetTimerEx("BlindHuman7", 720, false, "i", playerid);
	return 1;
}

function BlindHuman7(playerid)
{
	TextDrawHideForPlayer(playerid,Effect[7]);
	TextDrawShowForPlayer(playerid,Effect[8]);
	SetTimerEx("BlindHuman8", 740, false, "i", playerid);
	return 1;
}

function BlindHuman8(playerid)
{
	for(new i; i < 8; i++)
		TextDrawHideForPlayer(playerid,Effect[i]);
	return 1;
}

function Flashbang(playerid)
{
	TextDrawShowForPlayer(playerid,Effect[0]);
	SetTimerEx("Flashbang2", 3500, false, "i", playerid);
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	Delete3DTextLabel(PInfo[playerid][Ranklabel]);
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
	SetPlayerDrunkLevel(playerid,0);
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
	for(new i; i < MAX_PLAYERS; i++)
	{
 		ShowPlayerNameTagForPlayer(playerid,i,1);
	}
	new string[90];
	if(Team[playerid] == HUMAN)
	{
		if(PInfo[playerid][Premium] == 1)
			format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else if(PInfo[playerid][Premium] == 2)
		    format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else if(PInfo[playerid][Premium] == 3)
		    format(string,sizeof string,""cblue"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else
		    format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
	}
	if(Team[playerid] == ZOMBIE)
	{
		if(PInfo[playerid][Premium] == 1)
			format(string,sizeof string,""cgold"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else if(PInfo[playerid][Premium] == 2)
		    format(string,sizeof string,""cplat"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else if(PInfo[playerid][Premium] == 3)
		    format(string,sizeof string,""cblue"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		else
		    format(string,sizeof string,""cpurple"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
	}
	PInfo[playerid][Ranklabel] = Create3DTextLabel(string,0x6E0C91aa,0,0,0,40.0,0);
   	Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
	Update3DTextLabelText(PInfo[playerid][Ranklabel],green,string);
	PInfo[playerid][Flashed] = 0;
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
	    if(PInfo[playerid][Rank] >= 29)
	    {
	        PInfo[playerid][MeatForShare] ++;
		}
     	if(PInfo[playerid][ShowingXP] == 0)
	    {
			static string[7];
		 	if(PInfo[playerid][Premium] == 2)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 26;
			 		PInfo[playerid][CurrentXP] += 26;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 52;
			 		PInfo[playerid][CurrentXP] += 52;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 78;
			 		PInfo[playerid][CurrentXP] += 78;
				}
			}
		 	else if(PInfo[playerid][Premium] == 3)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 28;
			 		PInfo[playerid][CurrentXP] += 28;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 56;
			 		PInfo[playerid][CurrentXP] += 56;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 84;
			 		PInfo[playerid][CurrentXP] += 84;
				}
			}
			else
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 24;
					PInfo[playerid][CurrentXP] += 24;
				}
		 	    if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 48;
					PInfo[playerid][CurrentXP] += 48;
				}
		 	    if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 72;
					PInfo[playerid][CurrentXP] += 72;
				}
			}
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
			if(PInfo[playerid][Premium] == 2)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 26;
			 		PInfo[playerid][CurrentXP] += 26;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 52;
			 		PInfo[playerid][CurrentXP] += 52;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 78;
			 		PInfo[playerid][CurrentXP] += 78;
				}
			}
		 	else if(PInfo[playerid][Premium] == 3)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 28;
			 		PInfo[playerid][CurrentXP] += 28;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 56;
			 		PInfo[playerid][CurrentXP] += 56;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 84;
			 		PInfo[playerid][CurrentXP] += 84;
				}
			}
			else
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 24;
					PInfo[playerid][CurrentXP] += 24;
				}
		 	    if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 48;
					PInfo[playerid][CurrentXP] += 48;
				}
		 	    if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 72;
					PInfo[playerid][CurrentXP] += 72;
				}
			}
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
			if(PInfo[playerid][Premium] == 2)
			{
 				if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 18;
					PInfo[playerid][CurrentXP] += 18;
				}
 				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 36;
					PInfo[playerid][CurrentXP] += 36;
				}
 				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 54;
					PInfo[playerid][CurrentXP] += 54;
				}
			}
		 	else if(PInfo[playerid][Premium] == 3)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 20;
			 		PInfo[playerid][CurrentXP] += 20;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 40;
			 		PInfo[playerid][CurrentXP] += 40;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 60;
			 		PInfo[playerid][CurrentXP] += 60;
				}
			}
			else
			{
				if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 16;
					PInfo[playerid][CurrentXP] += 16;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 32;
					PInfo[playerid][CurrentXP] += 32;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 48;
					PInfo[playerid][CurrentXP] += 48;
				}
			}
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
            if(PInfo[playerid][Premium] == 2)
			{
 				if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 18;
					PInfo[playerid][CurrentXP] += 18;
				}
 				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 36;
					PInfo[playerid][CurrentXP] += 36;
				}
 				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 54;
					PInfo[playerid][CurrentXP] += 54;
				}
			}
		 	else if(PInfo[playerid][Premium] == 3)
		 	{
		 	    if(PInfo[playerid][ExtraXP] == 0)
		 	    {
			 		PInfo[playerid][XP] += 20;
			 		PInfo[playerid][CurrentXP] += 20;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
			 		PInfo[playerid][XP] += 40;
			 		PInfo[playerid][CurrentXP] += 40;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
			 		PInfo[playerid][XP] += 60;
			 		PInfo[playerid][CurrentXP] += 60;
				}
			}
			else
			{
				if(PInfo[playerid][ExtraXP] == 0)
		 	    {
					PInfo[playerid][XP] += 16;
					PInfo[playerid][CurrentXP] += 16;
				}
				if(PInfo[playerid][ExtraXP] == 1)
		 	    {
					PInfo[playerid][XP] += 32;
					PInfo[playerid][CurrentXP] += 32;
				}
				if(PInfo[playerid][ExtraXP] == 2)
		 	    {
					PInfo[playerid][XP] += 48;
					PInfo[playerid][CurrentXP] += 48;
				}
			}
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
	if(PInfo[playerid][CanBite] == 0) return 0;
	if(PInfo[i][SPerk] == 22)
	    SetTimerEx("CantBite",755,0,"i",playerid);
	else
		SetTimerEx("CantBite",455,0,"i",playerid);
	PInfo[playerid][CanBite] = 0;
	if(PInfo[playerid][RageMode] == 0)
	{
		new Float:Health;
	    GetPlayerHealth(i,Health);
	    /*if(Health >= 1.0 && Health <= 5.0)
			SetPlayerHealth(i,1.0);*/
	    if((PInfo[playerid][ZPerk] == 18) || (PInfo[playerid][ZPerk] == 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 10.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-10.0);
			}
			else
			{
			    if(Health <= 6.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-6.0);
			}
			GetPlayerHealth(playerid,Health);
		}
		else if((PInfo[i][SPerk] == 5) || (PInfo[i][SPerk] == 22))
		{
			GetPlayerHealth(i,Health);
			if((PInfo[playerid][ZPerk] == 1) || (PInfo[playerid][ZPerk] == 18))
			{
				if(Health <= 8.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-8.0);
			}
			else if(Health <= 6 && Health > 0.0)
			{
			    InfectPlayer(i);
			    PInfo[i][Dead] = 1;
			    GivePlayerXP(playerid);
			    GivePlayerAssistXP(playerid);
		        CheckRankup(playerid);
		        PInfo[i][AfterLifeInfected] = 1;
			}
			else SetPlayerHealth(i,Health-6);
		}
	    else
		{
			GetPlayerHealth(i,Health);
	    	if((PInfo[playerid][ZPerk] == 1) || (PInfo[playerid][ZPerk] == 18))
			{
			    if(Health <= 10.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
	      			SetPlayerHealth(i,Health-10.0);
			}
			else if((PInfo[playerid][ZPerk] != 18.0) && (PInfo[playerid][ZPerk] != 1))
			{
			    if(Health <= 7.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
	   				SetPlayerHealth(i,Health-7.0);
			}
		}
		GetPlayerHealth(i,Health);
		/*if(Health <= 10.0)
		{
		    InfectPlayer(i);
		    GivePlayerXP(playerid);
		    GivePlayerAssistXP(playerid);
	        CheckRankup(playerid);
	        PInfo[i][AfterLifeInfected] = 1;
		}
		else
		    SetPlayerHealth(i,Health-10.0);*/
	}
	else if(PInfo[playerid][RageMode] == 1)
	{
		new Float:Health;
	    GetPlayerHealth(i,Health);
	    /*if(Health >= 1.0 && Health <= 5.0)
			SetPlayerHealth(i,1.0);*/
	    if((PInfo[playerid][ZPerk] == 18)  || (PInfo[playerid][ZPerk] == 1))
		{
		    if(PInfo[i][SPerk] != 5)
			{
			    if(Health <= 15.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-15.0);
			}
			else
			{
			    if(Health <= 10.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-10.0);
			}
			GetPlayerHealth(playerid,Health);
		}
		else if((PInfo[i][SPerk] == 5) || (PInfo[i][SPerk] == 22))
		{
			GetPlayerHealth(i,Health);
			if(PInfo[playerid][ZPerk] == 1)
			{
				if(Health <= 12.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
				    SetPlayerHealth(i,Health-12.0);
			}
			else
			{
			    if(Health <= 9.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
				    GivePlayerAssistXP(playerid);
			        CheckRankup(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
					SetPlayerHealth(i,Health-9.0);
			}
		}
	    else
		{
			GetPlayerHealth(i,Health);
	    	if((PInfo[playerid][ZPerk] == 1) || (PInfo[playerid][ZPerk] == 18))
			{
			    if(Health <= 14.0 && Health > 0.0)
			    {
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
			        CheckRankup(playerid);
			        GivePlayerAssistXP(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
	      			SetPlayerHealth(i,Health-14.0);
			}
			else if((PInfo[playerid][ZPerk] != 18.0) && (PInfo[playerid][ZPerk] != 1))
			{
			    if(Health <= 10.0 && Health > 0.0)
				{
				    InfectPlayer(i);
				    PInfo[i][Dead] = 1;
				    GivePlayerXP(playerid);
			        CheckRankup(playerid);
			        GivePlayerAssistXP(playerid);
			        PInfo[i][AfterLifeInfected] = 1;
				}
				else
	   				SetPlayerHealth(i,Health-10.0);
			}
		}
		GetPlayerHealth(i,Health);
	}
  	PlayNearSound(i,1136);
	PInfo[playerid][CanBite] = 0;
	PInfo[playerid][Bites]++;
	PInfo[i][Lastbite] = playerid;
	if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
	if(PInfo[i][Baiting] == 0)
	{
	    ApplyAnimation(i,"PED","DAM_armR_frmFT",2,0,1,1,0,0,1);
	}
	ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
	return 1;
}

function MakeProperDamage(playerid)
{
	new Float:Health;
	GetPlayerHealth(playerid,Health);
	if(Health <= 10.0 && Health >= 5.0)
	    SetPlayerHealth(playerid,4.0);
	else if(Health <= 5.0 && Health > 1.0)
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
     		if(PInfo[playerid][Premium] == 3) PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",110000,false,"ii",playerid,2);
			else PInfo[playerid][RunTimer] = SetTimerEx("ResetRunVar",120000,false,"ii",playerid,2);
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

function IsPlatVehicle(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 409) return 1;
	if(GetVehicleModel(vehicleid) == 434) return 1;
	if(GetVehicleModel(vehicleid) == 539) return 1;
	if(GetVehicleModel(vehicleid) == 571) return 1;
	if(GetVehicleModel(vehicleid) == 429) return 1;
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
	static Float:x,Float:y,Float:z;
 	GetPlayerPos(playerid,x,y,z);
	PInfo[playerid][Deaths]++;
	PInfo[playerid][Dead] = 1;
	TimeOfDeath[playerid] = true;
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
    SetTimerEx("MinusHP",125,false,"i",playerid);
    if(PInfo[playerid][GroupLeader] == 0)
    {
        PInfo[playerid][GroupPlayers] ++;
        PInfo[playerid][GroupIN] = 0;
        for(new i; i < MAX_PLAYERS; i++)
        {
            if((PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) && (PInfo[i][GroupIN] != 0))
            {
				new string[64];
                format(string,sizeof string,""cwhite"* "cgreen"Your group mate %s dead!",GetPName(i));
                SendClientMessage(i,white,string);
			}
			if((PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) && (PInfo[i][GroupLeader] == 1))
			{
			    PInfo[i][GroupPlayers] --;
			}
		}
	}
	else if(PInfo[playerid][GroupLeader] == 1)
	{
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if((PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) && (PInfo[i][GroupIN] != 0))
	        {
	        	PInfo[i][GroupIN] = 0;
	        	SendClientMessage(playerid,white,""cwhite"* "cblue"Your group lost its leader, so it disintegrated!!");
	        	PInfo[playerid][GroupPlayers] = 0;
	        	GroupID --;
			}
		}
	}
	DestroyObject(PInfo[playerid][ZObject]);
	PInfo[playerid][DeathsRound]++;
	TextDrawHideForPlayer(playerid,Textdraw0);
	TextDrawHideForPlayer(playerid,Textdraw1);
	TextDrawHideForPlayer(playerid,Textdraw2);
	TextDrawHideForPlayer(playerid,Textdraw3);
	TextDrawHideForPlayer(playerid,Textdraw4);
	TextDrawHideForPlayer(playerid,Textdraw5);
	TextDrawHideForPlayer(playerid,Textdraw6);
	TextDrawHideForPlayer(playerid,Textdraw7);
	TextDrawHideForPlayer(playerid,Textdraw8);
	TextDrawHideForPlayer(playerid,Textdraw9);
	TextDrawHideForPlayer(playerid,Textdraw10);
	TextDrawHideForPlayer(playerid,Textdraw11);
	TextDrawHideForPlayer(playerid,Textdraw12);
	TextDrawHideForPlayer(playerid,Textdraw13);
	TextDrawHideForPlayer(playerid,Textdraw14);
	TextDrawHideForPlayer(playerid,Textdraw15);
	TextDrawHideForPlayer(playerid,Textdraw16);
	TextDrawHideForPlayer(playerid,Textdraw17);
	TextDrawHideForPlayer(playerid,Textdraw18);
	TextDrawHideForPlayer(playerid,Textdraw19);
	TextDrawHideForPlayer(playerid,Textdraw20);
	TextDrawHideForPlayer(playerid,Textdraw21);
	TextDrawHideForPlayer(playerid,Textdraw22);
	TextDrawHideForPlayer(playerid,Textdraw23);
	TextDrawHideForPlayer(playerid,Textdraw24);
	TextDrawHideForPlayer(playerid,Textdraw25);
	TextDrawHideForPlayer(playerid,Textdraw26);
	TextDrawHideForPlayer(playerid,Textdraw27);
	TextDrawHideForPlayer(playerid,Textdraw28);
	TextDrawHideForPlayer(playerid,Textdraw29);
	TextDrawHideForPlayer(playerid,Textdraw30);
	TextDrawHideForPlayer(playerid,Textdraw31);
	TextDrawHideForPlayer(playerid,Textdraw32);
	TextDrawHideForPlayer(playerid,Textdraw33);
	TextDrawHideForPlayer(playerid,Textdraw34);
	TextDrawHideForPlayer(playerid,Textdraw35);
	TextDrawHideForPlayer(playerid,Textdraw36);
	TextDrawHideForPlayer(playerid,Textdraw37);
	TextDrawHideForPlayer(playerid,Textdraw38);
	TextDrawHideForPlayer(playerid,Textdraw39);
	return 1;
}

CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
	return 1;
}

public UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, true);
    return true;
}


/*public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new Float:vh,Float:x,Float:y,Float:z;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    GetPlayerPos(playerid,x,y,z);
	    if(IsPlayerInRangeOfPoint(i,10.0,x,y,z))
	    {
	        if((GetPlayerVehicleID(i)) == (GetPlayerVehicleID(playerid)))
			{
   				new Float:PH;
				GetPlayerHealth(i,PH);
			    if(PInfo[i][Infected] == 1)
				{
					if(i <= 1.0) InfectPlayer(playerid);
				}
				GetVehicleHealth(vehicleid, vh);//ïðîâåðÿåì õï òðàíñïîðòà
			    if(1000 - vh >= 125)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-5);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
				}
			    else if(1000 - vh >= 800)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-40);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 165)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-10);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 200)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-15);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 300) //ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-20);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 400)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-24);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 550)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-28);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 650)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-33);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			    else if(1000 - vh >= 750)//ñòàâèì ïðîâåðêó, åñëè 1000õï -vh(êîòîðîå ñòàëî ó àâòî) áóäåò áîëüøå èëè ðàâíî 500, òîãäà ...
			    {
			        GetPlayerHealth(i, PH);//ïðîâåðÿåì ñêîëüêî ó èãðîêà õï
			        SetPlayerHealth(i, PH-37);//îòíèìàåì õï ó èãðîêà(ñêîëüêî áûëî - 10)
			    }
			}
		}
	}
    return 1;
}*/

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
      /*if(IsWeaponWithAmmo(weaponid))
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
      }*/
	/*if(Team[playerid] == HUMAN)
  	{
  	    if(PInfo[playerid][PressingKeyShift] == 1)
  	    {
	  		if(PInfo[playerid][AssaultGrenades] >= 1)
	  		{
				if((GetPlayerWeapon(playerid) == 31) || (GetPlayerWeapon(playerid) == 30))
				{
			    	PInfo[playerid][AssaultGrenades] --;
			    	new Float:x,Float:y,Float:z;
			    	GetPlayerPos(playerid,x,y,z);
			    	SetTimerEx("CreateGrenade",1500,false,"iiii",playerid,Float:fX, Float:fY, Float:fZ);
			    	ApplyAnimation(playerid,"BUDDY","buddy_fire_poor",3,0,1,1,0,0,1);
			    	for(new i; i < MAX_PLAYERS; i++)
			    	{
			    		PlayerPlaySound(i,14408,fX,fY,fZ);
			    		PlayerPlaySound(i,16200,x,y,z);
					}
				}
			}
		}
	}*/
 	return 1;
}

function CreateGrenade(playerid,Float:fX, Float:fY, Float:fZ)
{
	CreateFakeExplosion(18685,fX,fY,fZ);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Logged] == 0) continue;
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
		PlayerPlaySound(i,1159,fX,fY,fZ);
	}
	new Float:Health;
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(!IsPlayerConnected(i)) continue;
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


public OnPlayerPickUpPickup(playerid,pickupid)
{
    for(new j; j < sizeof(HiveMeatPos);j++)
    {
        if(pickupid == MeatHive[j])
        {
		    new Float:a;
		    GetPlayerHealth(playerid,a);
			if(a >= 100)
			{
				SendClientMessage(playerid,white,"* "cred"You don't need to eat any meat right now!");
			    SetPlayerHealth(playerid,a);
			    return 1;
			}
			if(PInfo[playerid][EatenMeat] == 3)
			{
	  			SendClientMessage(playerid, white, "* "cred"You have already been filled with brains!");
	  			PInfo[playerid][EatenMeat] ++;
	  			SetTimerEx("CanEatAgain",40000,false,"i",playerid);
	  			return 1;
			}
			if(PInfo[playerid][EatenMeat] == 4) return SendClientMessage(playerid, white, "* "cred"You have already been filled with brains!");
			else
			{
			    new string[64];
			    format(string,sizeof string,""cwhite"* "cjam"%s munches on some leftover brains.",GetPName(playerid));
				SetPlayerHealth(playerid,a+20);
				SendNearMessage(playerid,white,string,30);
				SetTimerEx("CanEatAgain",40000,false,"i",playerid);
				PInfo[playerid][EatenMeat] ++;
			}
			return 0;
		}
	}
	for(new j; j < sizeof(HiveTeleports); j ++)
	{
	    if(pickupid == TPHive[j])
	    {
	        if(Team[playerid] == HUMAN)
	        {
	        	return 0;
	        }
			else
			{
			    if(PInfo[playerid][Training] == 1)
			    {
			    	if(PInfo[playerid][TrainingPhase] == 10)
		  				ShowPlayerDialog(playerid, 14779, DSL, "Canalization Ways", "Training Course", "Move", "Close");
				}
			    else
	  				ShowPlayerDialog(playerid, 1100, DSL, "Canalization Ways", "Hive\nGrove Street\nUnity Station\nMarket Station\nGlen Park\nVinewood\nLos Santos Center\nWillowfield\nSanta Maria Beach\nGate-C\nLos Santos Airport\nLos Santos City hall\nSmall Thicket", "Move", "Close");
			}
			return 0;
		}
	}
	for(new j; j < sizeof(Searchplaces); j ++)
	{
		if(pickupid == PickUpsSearching[j]) return 0;
	}
	for(new j; j < sizeof(LootOutSide); j ++)
	{
	    if(pickupid == LootOutPlaces[j])
	    {
	        if(Team[playerid] == ZOMBIE) return 0;
	        else
	        {
	        	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,1);
	        	if(PInfo[playerid][SPerk] != 18) Loot1(playerid);
	        	else Loot2(playerid);
			}
			return 0;
		}
	}
	if(pickupid == PickUp1Training)
	{
		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 1)
		    {
			    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"Get in the vehicle that you want and drive through the entrance!","OK","");
			    Vehicles[playerid][0] = CreateVehicle(587,103.1150000,1934.5260000,18.2890000,180.0000000,72,1,-1); //Euros
				Vehicles[playerid][1] = CreateVehicle(603,107.2350000,1934.7790500,18.6310000,182.0000000,69,1,-1); //Phoenix
				Vehicles[playerid][2] = CreateVehicle(506,111.3070000,1934.3979500,18.5600000,180.0000000,7,7,-1); //Super GT
		        SetVehicleVirtualWorld(Vehicles[playerid][0],GetPlayerVirtualWorld(playerid));
		        SetVehicleVirtualWorld(Vehicles[playerid][1],GetPlayerVirtualWorld(playerid));
		        SetVehicleVirtualWorld(Vehicles[playerid][2],GetPlayerVirtualWorld(playerid));
		        PInfo[playerid][TrainingPhase] = 2;
			}
		}
		return 0;
	}
	if(pickupid == PickUp3rdTraining)
	{
		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 3)
		    {
			    PInfo[playerid][TrainingPhase] = 4;
			    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"Now I will learn you how to use your inventory\nLook, your fuel and oil are out\nClick "cred"N"cwhite" to open your inventory\nHere you can find many types of items, but now you need fuel and oil\nChoose fuel or oil to put it into vehicle, you should stay close to vehicle to fill it\nNow go to another pickup to continue","OK","");
			    Fuel[GetPlayerVehicleID(playerid)] = 0;
				Oil[GetPlayerVehicleID(playerid)] = 0;
				UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
			}
		}
	    return 0;
	}
	if(pickupid == PickUp4thtraining)
	{
 		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 4)
		    {
		        PInfo[playerid][TrainingPhase] = 5;
	    	    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"As you note that there is not much items in your inventory\nSo you can fill it by looting houses\nYou can loot in the most interiors that you can enter\nIn interiors you will find arrows that show you where you can loot\nCome to it and press "cred"C"cwhite" to loot,\nHere you can find some more extra items!\nNow go into downfloor and find arrow!","OK","");
	            DestroyPlayerObject(playerid,Player1stGate);
	            Player2ndGate = CreatePlayerObject(playerid,980,140.8380000,1915.0629900,20.8630000,0.0000000,0.0000000,88.0000000); //thisisgaterr
			}
		}
		return 0;
	}
	if(pickupid == PickUp6thTraining)
	{
 		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 6)
		    {
		        PInfo[playerid][TrainingPhase] = 7;
		        new strang[2025];
		        TogglePlayerControllable(playerid, 0);
				SetTimerEx("UnFreezePlayer", 1000, false, "i", playerid);
		        format(strang,sizeof strang,""cwhite"Surviving without any extra support is very hard, you will understand this while playing\nSo perks system will help you with that\nPerks are special abilities, they can help you in different situations");
		        strcat(strang,"\nPress "cred"Y"cwhite" to open perks list\nOn first rank you won't get any perks. \nYou get new perks on every rank up\nOpen perks list and choose "cred"Burst Run\n\n"cred"");
		        SetPlayerPosAndAngle(playerid,998.2286,2133.3354,500.1364,78.3310);
	   	    	ShowPlayerDialog(playerid,20752,DSM,"Info",strang,"OK","");
			}
		}
		return 0;
	}
	if(pickupid == PickUpToUp)
	{
	    if(PInfo[playerid][Training] == 1)
	    {
	    	SetPlayerPosAndAngle(playerid,968.5852,2123.7542,500.1382,261.9929);
	    	PInfo[playerid][CanBurst] = 1;
		}
		return 0;
	}
	if(pickupid == PickUp8thTraining)
	{
		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 7)
		    {
			    PInfo[playerid][TrainingPhase] = 8;
			    SetPlayerPosAndAngle(playerid,306.8794,1955.0277,17.6406,89.0749);
			    new strang[2025];
			    DisablePlayerCheckpoint(playerid);
		        format(strang,sizeof strang,""cwhite"Good Job!\nNow I will tell you about CheckPoint system\nAs we said in the beginning Checkpoint(CP) is red marker on radar\nThat is not all, when you enter CP you will receive ammo for your weapons\nAnd while you are staying in it your hp will increase");
		        strcat(strang,"\nDuring long staying in CP, it will be cleared. As much humans staying in CP, as faster CP will be cleared\nIf you will avoid CP for too long, you will become 1st victim for them and they would find and infect you easily!"cred"\nIf you will avoid CP more then 10 minutes, you will automatically teleported to CP!"cwhite"");
				strcat(strang,"\nYou must clear 8 CPs to win the game\nIn CP you will see another humans\nHumans are your friends and have green nickname");
				strcat(strang,"\nFor killing your teammates you will lose XP, and if you continue do that you will be jailed for some time\nSo you need to work together and you will get more chances to survive and win the game\n"cred"");
		    	strcat(strang,"\nFor killing zombies (they have purple nicknames and have purple marker on radar) you receive XP. XP needs to increase your rank\nAs higher your rank as much XPs needs to increase your rank\nNow go to CP and we will continue!");
				ShowPlayerDialog(playerid,13999,DSM,"Info",strang,"OK","");
				SetPlayerCheckpoint(playerid,279.2454,1954.3246,17.6406,10.0);
			}
		}
		return 0;
	}
	if(pickupid == PickUp12thTraining)
	{
 		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 11)
		    {
			    PInfo[playerid][TrainingPhase] = 12;
			    DestroyPlayerObject(playerid,GateZombie1);
			    new strang[2025];
			    format(strang,sizeof strang,""cwhite"Now I will tell you about very important thing for zombies, about Bite system\nOn first look, Bite system looks hard, but it is not");
			    strcat(strang,"\nYou need to get used to the bite system, later you will become a dangerous zombie in the city \nAnd you will not be so easy to kill\nGo to the human that staying infront of you, get closer to him and click Right Mouse Button as fast as you can and infect him!");
			    ShowPlayerDialog(playerid,13759,DSM,"Info",strang,"OK","");
			    SetActorHealth(Jason[playerid],100);
			}
		}
	    return 0;
	}
	if(pickupid == PickUp13thTraining)
	{
 		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 13)
		    {
				GateZombie2 = CreatePlayerObject(playerid,986,315.4240100,2504.6159700,14.9090000,0.0000000,0.0000000,266.2480000);
				new strang[2080];
				format(strang,sizeof strang,""cwhite"Zombies like humans have perks\nI know that you know how to open perks list, but I will remind you:\nClick "cred"Y"cwhite" key to open perk list\nThen choose jumper perk");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
			}
		}
	    return 0;
	}
	if(pickupid == PickUp14thTraining)
	{
 		if(PInfo[playerid][Training] == 1)
	    {
		    if(PInfo[playerid][TrainingPhase] == 13)
		    {
		        PInfo[playerid][TrainingPhase] = 14;
				new strang[2080];
				format(strang,sizeof strang,""cwhite"Nice job!\nNow you need to teleport to the vehicle\nYou need to activate Dig perk in your perks menu (click "cred"Y"cwhite") to open");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
				Vehicles[playerid][3] = CreateVehicle(527,401.7200000,2500.7309600,16.2680000,180.0000000,53,1,-1);
				SetVehicleVirtualWorld(Vehicles[playerid][3],GetPlayerVirtualWorld(playerid));
				StartVehicle(Vehicles[playerid][3],0);
				VehicleStarted[Vehicles[playerid][3]] = 0;
			}
		}
		return 0;
	}
	if(pickupid == PickUpLastTraining)
	{
		if(PInfo[playerid][Training] == 1)
	    {
	    	if(PInfo[playerid][TrainingPhase] == 16)
	    	{
				new strang[2080];
				format(strang,sizeof strang,""cwhite"Well done!\nYou have passed your training course!\nNow you are ready for real fight!\nIf you need extra help you can ask online admistrators");
				strcat(strang,"\nAlso recommended to read rules (/help)\nNow choose class that you want play now and start enjoying your game on our server (go left to play as a Human or go right to continue play as a zombie)");
				strcat(strang,"\n\n"cred"GOOD LUCK AND HAVE FUN!!!");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
				SendClientMessage(playerid,white,"*** "cgreen"You've got XP for complaining training course!");
				PInfo[playerid][Training] = 0;
				PInfo[playerid][TrainingPhase] = 0;
				PInfo[playerid][ChooseAfterTr] = 1;
				static string[7];
		 		PInfo[playerid][XP] += 50;
		 		PInfo[playerid][CurrentXP] += 50;
				format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
				TextDrawSetString(GainXPTD[playerid],string);
				PInfo[playerid][ShowingXP] = 1;
				SetTimerEx("ShowXP1",100,0,"d",playerid);
			    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
			    PlaySound(playerid,1083);
			}
		}
		return 0;
	}
	if(pickupid == PickUpZombie)
	{
	    if(PInfo[playerid][ChooseAfterTr] == 1)
	    {
	        PInfo[playerid][ChooseAfterTr] = 0;
	        Team[playerid] = ZOMBIE;
	        SpawnPlayer(playerid);
	        SendClientMessage(playerid,white,"* "cpurple"You have chosen Zombie Class!");
	        SetPlayerVirtualWorld(playerid,0);
	        SetPlayerCP(playerid);
	        SetPlayerSkin(playerid,ZombieSkins[random(sizeof(ZombieSkins))]);
		}
		return 0;
	}
	if(pickupid == PickUpSurvivor)
	{
	    if(PInfo[playerid][ChooseAfterTr] == 1)
	    {
	        PInfo[playerid][ChooseAfterTr] = 0;
	        Team[playerid] = HUMAN;
	        SpawnPlayer(playerid);
		    static sid;
			ChooseSkin: sid = random(299);
			sid = random(299);
			for(new i = 0; i < sizeof(ZombieSkins); i++)
				if(sid == ZombieSkins[i]) goto ChooseSkin;
	        SendClientMessage(playerid,white,"* "cgreen"You have chosen Survivor Class!");
	        SetPlayerVirtualWorld(playerid,0);
	        SetPlayerCP(playerid);
	        SetPlayerSkin(playerid,sid);
		}
		return 0;
	}
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

CMD:hide(playerid,params[])
{
    if(Team[playerid] == ZOMBIE)
	{
	    if(PInfo[playerid][Training] == 1) return SendClientMessage(playerid,white,"* "cjam"You need to complete the course to hide!");
		if(PInfo[playerid][Hiden] == 1)
        {
            static string[100];
			SendClientMessage(playerid,white,"*"cjam" You have stopped hidding!");
			format(string,sizeof string,""cgreen"Rank: %i | XP: %i/%i",PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp]);
		 	PInfo[playerid][Ranklabel] = Create3DTextLabel(string,0x008080AA,0,0,0,40.0,0);
			Attach3DTextLabelToPlayer(PInfo[playerid][Ranklabel], playerid, 0.0, 0.0, 0.7);
			static sstring[60];
			TogglePlayerSpectating(playerid,0);
			VehicleHideSomeone[GetPlayerVehicleID(playerid)] = 0;
			format(sstring,sizeof sstring,""cwhite"** "cjam"%s got out from under the seat!",GetPName(playerid));
			SendNearMessage(playerid,white,sstring,15);
			for(new i; i < MAX_PLAYERS;i++)
			{
				ShowPlayerNameTagForPlayer(i,playerid,1);
				PInfo[playerid][CanBite] = 1;
			}
		}
		else
		{
 			if(!IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid,red,"You need to be in vehicle to hide!!");
			else if(IsPlayerInAnyVehicle(playerid))
	        {
	            if(PInfo[playerid][Hiden] == 0)
	            {
	                if(GetPlayerVehicleSeat(playerid) == 0) return SendClientMessage(playerid,white,"* "cred"You must to seat on passenger place to hide!");
					if(VehicleHideSomeone[GetPlayerVehicleID(playerid)] == 1) return SendClientMessage(playerid,white,"* "cred"Someone is already hidding in this vehicle!");
					GetPlayerHealth(playerid,PInfo[playerid][HideHP]);
					PInfo[playerid][HideInVehicle] = GetPlayerVehicleID(playerid);
					VehicleHideSomeone[GetPlayerVehicleID(playerid)] = 1;
			   		PInfo[playerid][SeatID] = GetPlayerVehicleSeat(playerid);
					SendClientMessage(playerid,white,"* "cjam"You have successfully hidden!");
					SendClientMessage(playerid,white,"* "cred"Write /hide again to stop hidding!");
					SendNearMessage(playerid,white,"* "dred"You heard strange sound in someone's vehicle...",10);
					ApplyAnimation(playerid,"CRACK", "CRCKDETH2", 2.0, 0, 0, 1, 0, 1);
					Delete3DTextLabel(PInfo[playerid][Ranklabel]);
					PInfo[playerid][CanBite] = 0;
					TogglePlayerSpectating(playerid, 1);
					PInfo[playerid][Hiden] = 1;
					EnableAntiCheatForPlayer(playerid,11,0);
					EnableAntiCheatForPlayer(playerid,12,0);
					SetTimerEx("PutVehicle",350,false,"i",playerid);
					PlayerSpectateVehicle(playerid,PInfo[playerid][HideInVehicle],1);
		            for(new i; i < MAX_PLAYERS;i++)
					{
						ShowPlayerNameTagForPlayer(i,playerid,0);
		 			}
				}
			}
		}
	}
	else
	{
		SendClientMessage(playerid,red,"* Only zombies can hide!");
 	}
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
    PlaySound(playerid,14600);
    return 1;
}

function PowerfulGlovesThrow(playerid,ax,ay,az)
{
	if(IsPlayerInRangeOfPoint(playerid,50,ax,ay,az))
	{
	    PlaySound(playerid,14600);
	    ApplyAnimation(playerid,"PED","KO_skid_front",1.25,1,0,0,0,900,1);
	}
    return 1;
}



function DestroyBait(playerid)
{
	RemovePlayerAttachedObject(playerid, 1);
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

public SaveDeathZombieLastPos(playerid)
{
    {
    	GetPlayerPos(playerid,PInfo[playerid][DX],PInfo[playerid][DY],PInfo[playerid][DZ]);
    }
	return 1;
}

function TeleportToLastPos(playerid)
{
    PInfo[playerid][NormalTP] = 1;
    SetPlayerPos(playerid,PInfo[playerid][DX],PInfo[playerid][DY],PInfo[playerid][DZ]+3);
    WaitAirCheat[playerid]=2;
    return 1;
}
CMD:weapons(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) SendClientMessage(playerid,white,"**"cred"Only humans can change weapons!");
    if((PInfo[playerid][CanUseWeapons] == 0) && (Team[playerid] == HUMAN)) SendClientMessage(playerid,white,"**"cred"You need to clear CheckPoint, to change weapons again!");
	if((PInfo[playerid][CanUseWeapons] == 1) && (Team[playerid] == HUMAN))
	{
	    if(PInfo[playerid][Rank] <= 2) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51","Select","Cancel");
		else if((PInfo[playerid][Rank] > 2) && (PInfo[playerid][Rank] <=9)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95","Select","Cancel");
        else if((PInfo[playerid][Rank] > 9) && (PInfo[playerid][Rank] <=14)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35","Select","Cancel");
		else if((PInfo[playerid][Rank] > 14) && (PInfo[playerid][Rank] <=19)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42","Select","Cancel");
		else if((PInfo[playerid][Rank] > 19) && (PInfo[playerid][Rank] <=24)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20","Select","Cancel");
		else if((PInfo[playerid][Rank] > 24) && (PInfo[playerid][Rank] <=29)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36","Select","Cancel");
		else if((PInfo[playerid][Rank] > 29) && (PInfo[playerid][Rank] <=34)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36\nAK-47 and TEC\t30\t60 and 150","Select","Cancel");
		else if((PInfo[playerid][Rank] > 34) && (PInfo[playerid][Rank] <=39)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36\nAK-47 and TEC\t30\t60 and 150\nCombat Shotgun\t35\t49","Select","Cancel");
		else if((PInfo[playerid][Rank] > 39) && (PInfo[playerid][Rank] <=44)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36\nAK-47 and TEC\t30\t60 and 150\nCombat Shotgun\t35\t49\nM4\t40\t100","Select","Cancel");
		else if((PInfo[playerid][Rank] > 44) && (PInfo[playerid][Rank] <=49)) return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36\nAK-47 and TEC\t30\t60 and 150\nCombat Shotgun\t35\t49\nM4\t40\t100\nSniper Rifle and SMG\t45\t30 and 60","Select","Cancel");
		else if(PInfo[playerid][Rank] >=50)  return ShowPlayerDialog(playerid, 1502, 5, "Weapons","Weapons\tRank\tAmmo\nSilenced Pistol\t1\t51\nDual Colt\t5\t95\nShotgun\t10\t35\nDesert Eagle\t15\t42\nUZI's and Rifle\t20\t100 and 20\nSawnoff Shotgun\t25\t36\nAK-47 and TEC\t30\t60 and 150\nCombat Shotgun\t35\t49\nM4\t40\t100\nSniper Rifle and SMG\t45\t30 and 60","Select","Cancel");
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
	RemovePlayerAttachedObject(playerid, 7);
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
				    SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
			}
			if(IsPlayerInRangeOfPoint(i,190,x,y,z))
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
				    if(PInfo[i][SPerk] == 28)
				    {
				        if(PInfo[playerid][ZPerk] == 22)
				        	SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
				        else
				            SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
					}
					else SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFFFF));
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
	    for(new i; i < MAX_PLAYERS; i++)
	    {
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
					}
				}
				else SetPlayerMarkerForPlayer(playerid,i,(GetPlayerColor(i) & 0xFFFFFF00));
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

new FloodTimer[MAX_PLAYERS];
new MaxChat[MAX_PLAYERS];
public OnPlayerText(playerid, text[])
{
    new sendername[40];
    static string[200];
    GetPlayerName(playerid, sendername, 32);
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	if(PInfo[playerid][Logged] == 0)
 	{
  		SendClientMessage(playerid,red,""cwhite"** "cred"Error: You need to login to write any messages!");
    	return 0;
    }
    else
    {
		KillTimer(FloodTimer[playerid]);
		FloodTimer[playerid] = SetTimerEx("TimerFlood",1500,false,"i",playerid);
		MaxChat[playerid] ++;
		if(MaxChat[playerid] == 4)
		{
		    SendClientMessage(playerid,white,"*** "cred"You are writting too fast in the chat!");
		    return 0;
		}
		if(MaxChat[playerid] == 5)
		{
		    SendClientMessage(playerid,white,"*** "cred"You are writting too fast in the chat!");
		    return 0;
		}
		if(MaxChat[playerid] == 6)
		{
		    SendClientMessage(playerid,white,"*** "cred"STOP FLOODING!!! OR YOU WILL BE KICKED!");
		    return 0;
		}
		if(MaxChat[playerid] >= 7)
		{
		    SendClientMessage(playerid,white,"*** "cred"You were kick for trying to flood!");
		    SetTimerEx("kicken",100,false,"i",playerid);
		    return 0;
		}
	    if(Team[playerid] == HUMAN)
	    {
	    	format(string, 256, ""cwhite"|%i| "cgreen"%s: "cwhite"%s", playerid, sendername, text);
	    	SendClientMessageToAll(GetPlayerColor(playerid), string);
		}
		else if(Team[playerid] == ZOMBIE)
		{
		 	format(string, 256, ""cwhite"|%i| "cpurple"%s: "cwhite"%s", playerid, sendername, text);
	    	SendClientMessageToAll(GetPlayerColor(playerid), string);
		}
	}
    return 0;
}

function TimerFlood(playerid)
{
    MaxChat[playerid] = 0;
    return 1;
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
}//25 28

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

function DissapearBloodPhase4(i)
{
    TextDrawHideForPlayer(i,Textdraw16);
    TextDrawHideForPlayer(i,Textdraw18);
    TextDrawHideForPlayer(i,Textdraw26);
    return 1;
}


function UpdateBait()
{
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
        if(PInfo[i][Dead] == 1) continue;
		if(Team[i] == ZOMBIE) continue;
		if(PInfo[i][ZX] == 0) continue;
		if(IsValidObject(PInfo[i][ZObject]))
		{
		    for(new f; f < MAX_PLAYERS;f++)
		    {
		        if(!IsPlayerConnected(f)) continue;
	    		if(PInfo[f][Dead] == 1) continue;
	    		if(Team[f] == HUMAN) continue;
       			if(PInfo[f][ZPerk] == 17) continue;
       			if(PInfo[f][EatenBait] == 1) continue;
	    		if((IsPlayerInRangeOfPoint(f,16.0,PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ])) && (PInfo[f][EatenBait] != 1))
				{
                    new Float:x,Float:y,Float:z,Float:a,Float:ix,Float:iy,Float:iz;
					GetPlayerVelocity(f,x,y,z);
					GetPlayerPos(f,ix,iy,iz);
					TurnPlayerFaceToPos(f,PInfo[i][ZX],PInfo[i][ZY]);
					a = 180.0-atan2(ix-PInfo[i][ZX],iy-PInfo[i][ZY]);
					x += ( 0.5 * floatsin( -a, degrees ) );
	      			y += ( 0.5 * floatcos( -a, degrees ) );
					SetPlayerVelocity(f,x*0.2,y*0.2,0.1);
					ApplyAnimation(f, "PED" , "WALK_SHUFFLE" , 5.0 , 0 , 1 , 1 , 0 , 15000 , 1);
				}
				if((IsPlayerInRangeOfPoint(f,1.5,PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ])) && (PInfo[f][EatenBait] != 1))
				{
				    PInfo[f][EatenBait] = 1;
				    SendClientMessage(f,white,"* "cjam"You have eaten a bait!");
				    ClearAnimations(f,1);
					SetTimerEx("PickUpBait", 20000,false,"i",f);
				}
			}
		}
	}
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
		else if(PInfo[playerid][Logged] == 0)
  		{
     		static string[50];
 			format(string,sizeof string,""cwhite"» "cblue"%s is NOT logged in!",GetPName(clickedplayerid));
			SendClientMessage(playerid,white,string);
		}
		static sstring[128];
		format(sstring,sizeof sstring,""cwhite"User: %s",GetPName(clickedplayerid));
		new string[512];
		new prem[25];
		new dtxp[29];
		if(PInfo[clickedplayerid][ExtraXP] == 0) dtxp = "Not Activated";
		else if(PInfo[clickedplayerid][ExtraXP] == 1) dtxp = ""corange"Double XP activated";
		else if(PInfo[clickedplayerid][ExtraXP] == 2) dtxp = ""dred"Triple XP activated";
		if(PInfo[clickedplayerid][Premium] == 0) prem = "None";
		else if(PInfo[clickedplayerid][Premium] == 1) prem = ""cgold"Gold";
		else if(PInfo[clickedplayerid][Premium] == 2) prem = ""cplat"Platinum";
		else if(PInfo[clickedplayerid][Premium] == 3) prem = ""cblue"Diamond";
		if(PInfo[clickedplayerid][Premium] > 0)
		{
			format(string,sizeof (string),""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s "cred"(%i/%i/%i)"cwhite" - Extra XP Pack: %s\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,PInfo[clickedplayerid][PremiumMonth],PInfo[clickedplayerid][PremiumDay],PInfo[clickedplayerid][PremiumYear],dtxp,PInfo[clickedplayerid][HoursPlayed]);
		}
		if(PInfo[clickedplayerid][ExtraXP] > 0)
		{
			format(string,sizeof (string),""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s - "cwhite"Extra XP Pack: %s "cred"(%i/%i/%i)"cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,dtxp,PInfo[clickedplayerid][ExtraXPMonth],PInfo[clickedplayerid][ExtraXPDay],PInfo[clickedplayerid][ExtraXPYear],PInfo[clickedplayerid][HoursPlayed]);
		}
		if((PInfo[clickedplayerid][Premium] > 0) && (PInfo[clickedplayerid][ExtraXP] > 0))
		{
			format(string,sizeof (string),""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s (%i/%i/%i) - "cwhite"Extra XP Pack: %s "cred"(%i/%i/%i)"cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,PInfo[clickedplayerid][PremiumMonth],PInfo[clickedplayerid][PremiumDay],PInfo[clickedplayerid][PremiumYear],dtxp,
			PInfo[clickedplayerid][ExtraXPMonth],PInfo[clickedplayerid][ExtraXPDay],PInfo[clickedplayerid][ExtraXPYear],PInfo[clickedplayerid][HoursPlayed]);
		}
		else
		{
			format(string,sizeof (string),""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s - "cwhite"Extra XP Pack: %s "cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,dtxp,PInfo[clickedplayerid][HoursPlayed]);
		}
		//format(string,sizeof (string),""cwhite"\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i",PInfo[clickedplayerid][Kills],PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths]);
		ShowPlayerDialog(playerid, 228, DIALOG_STYLE_MSGBOX, sstring, string, "Close", "");
	}
	return 1;
}

/*function GetBaitPos(playerid)
{
	GetObjectPos(PInfo[playerid][ZObject],PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
    return 1;
}*/

CMD:groupcreate(playerid,params[])
{
	if((Team[playerid] == HUMAN) && (PInfo[playerid][GroupIN] == 0))
	{
	    GroupID ++;
		SendClientMessage(playerid,white,""cwhite"* "cblue"You have successfully created a group!");
		PInfo[playerid][GroupIN] = GroupID;
		PInfo[playerid][GroupLeader] = 1;
		PInfo[playerid][GroupPlayers] ++;
	}
	else if(PInfo[playerid][GroupIN] > 0)
	{
	    SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are already in group or you already created it!");
	    SendClientMessage(playerid,white,""cwhite"* "cred"If you are in group use /groupquit to leave it!");
	}
	if(Team[playerid] == ZOMBIE)
	{
	    SendClientMessage(playerid,white,""cwhite"* "cred"Error: Only survivors can team up!");
	}
	return 1;
}

CMD:gc(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Only survivors can use this command!");
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You must be in group to send messages!");
	new text[80],string[256];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/gc <message for group>");
    format(string,sizeof string,""cgreen"|Group Chat| "cblue"|%i| %s: %s",playerid,GetPName(playerid),text);
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	    {
	    	SendClientMessage(i,white,string);
		}
	}
	return 1;
}
CMD:groupjoin(playerid,params[])
{
	if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombie can't join groups!");
	if((Team[playerid] == HUMAN) && (PInfo[playerid][GroupIN] > 0)) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are already in group!");
	else
	{
	    static id;
		if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/groupjoin Player's ID");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not on server!");
        if(PInfo[id][GroupIN] == 0) return SendClientMessage(playerid,red,"» Error: This player is not in group!");
        if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"» Error: This player is in zombie team!");
        if(PInfo[id][GroupIN] == 0) return SendClientMessage(playerid,red,"» Error: This player is not a leader!");
        if((PInfo[id][GroupIN] > 0) && (PInfo[id][GroupLeader] == 1))
        {
			new string[128];
			format(string,sizeof string,""cgreen"%s wants to join your group! Write /gaccept or /gdeny",GetPName(playerid));
            SendClientMessage(id,red,string);
            PInfo[id][SurvivorWantToJoin] = playerid;
		}
		PInfo[playerid][GroupWantJoin] = 1;
  		SendClientMessage(playerid,white,""cgreen"You have send request for joining group!");
	}
	return 1;
}

CMD:groupinvite(playerid,params[])
{
	if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombies can't team up!");
	if((Team[playerid] == HUMAN) && (PInfo[playerid][GroupIN] == 0)) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are not in group!");
	if((PInfo[playerid][GroupLeader] == 0) && (PInfo[playerid][GroupIN] == 0)) return SendClientMessage(playerid,white,"* "cred"Error: You are not a leader group");
	else
	{
	    static id;
		if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/groupinvite Player's ID");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not on server!");
        if(PInfo[id][GroupIN] > 0) return SendClientMessage(playerid,red,"» Error: This player is already in group!");
        if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"» Error: This player is in zombie team!");
        if(PInfo[playerid][GroupPlayers] == 5) return SendClientMessage(playerid,red,"» Error: Your group already have 5 players!");
        if((PInfo[id][GroupIN] > 0) && (PInfo[id][GroupLeader] == 1))
        {
            PInfo[id][InviteID] = PInfo[playerid][GroupIN];
		}
		PInfo[id][InviteID] = PInfo[playerid][GroupIN];
		SendClientMessage(playerid,white,""cgreen"You have send inviting to join your group!");
		new string[128];
		format(string,sizeof string,""cgreen"%s invites you to join his group write /jaccept or /jdeny!",GetPName(playerid));
	    SendClientMessage(id,red,string);
	}
	return 1;
}

CMD:jaccept(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombies can't accept requests!");
    if(PInfo[playerid][GroupIN] > 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are already in group!");
    if(PInfo[playerid][InviteID] == 0) return SendClientMessage(playerid,red,""cwhite"* "cred"Error: Nobody send you invites!");
    else if(PInfo[playerid][InviteID] > 0)
    {
		PInfo[playerid][GroupIN] = PInfo[playerid][InviteID];
		for(new i; i < MAX_PLAYERS; i++)
		{
		    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		    {
				PInfo[playerid][InviteID] = 0;
				static string[89];
				format(string,sizeof string,""cgreen"%s joined your group!",GetPName(playerid));
				SendClientMessage(i,white,string);
				if(PInfo[i][GroupLeader]) PInfo[i][GroupPlayers] ++;
			}
		}
		SendClientMessage(playerid,white,"*"cgreen" You have successfully joined group!");
	}
    return 1;
}

CMD:jdeny(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombies can't deny requests!");
    if(PInfo[playerid][GroupIN] > 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are already in group!");
    if(PInfo[playerid][InviteID] == 0) return SendClientMessage(playerid,red,""cwhite"* "cred"Error: Nobody send you invites!");
    else if(PInfo[playerid][InviteID] > 0)
    {
		for(new i; i < MAX_PLAYERS; i++)
		{
		    if((PInfo[i][GroupIN] == PInfo[playerid][InviteID]) && (PInfo[i][GroupLeader] == 1))
		    {
				static string[89];
				format(string,sizeof string,""cred"%s denied your request!",GetPName(playerid));
				SendClientMessage(i,white,string);
				PInfo[playerid][InviteID] = 0;
			}
		}
		SendClientMessage(playerid,white,"*"cred" You have successfully denied your group join request!");
	}
    return 1;
}

CMD:delgmate(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombies can't use this command!");
    if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are not in group!");
    if(PInfo[playerid][GroupLeader] == 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You must be a leader to use this command!");
    static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/delgmate Player's ID");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not on server!");
	if(PInfo[playerid][GroupIN] != PInfo[id][GroupIN]) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: This player is not in your group!");
    if(Team[id] == ZOMBIE) return SendClientMessage(playerid,red,"» Error: This player is in zombie team!");
    PInfo[id][GroupIN] = 0;
   	new string[128];
	format(string,sizeof string,""cred"You kicked %s fro your group!",GetPName(id));
	SendClientMessage(playerid,white,string);
    SendClientMessage(id,red,""cred"You were removed from group by a leader!");
    return 1;
}

CMD:gaccept(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombie can't team up!");
    if(PInfo[playerid][GroupLeader] == 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Only group leaders can accept!");
    if(PInfo[playerid][SurvivorWantToJoin] == -1) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You haven't got team requests!");
    if(PInfo[playerid][GroupPlayers] == 5) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Your group already have 5 players!");
    SendClientMessage(playerid,white,""cgreen"You have accepted a request!");
	SendClientMessage(PInfo[playerid][SurvivorWantToJoin],white,"* "cgreen"You have successfuly joined a group!");
   	PInfo[PInfo[playerid][SurvivorWantToJoin]][GroupIN] = PInfo[playerid][GroupIN];
	PInfo[playerid][SurvivorWantToJoin] = -1;
	PInfo[PInfo[playerid][SurvivorWantToJoin]][GroupWantJoin] = 0;
    for(new i; i < MAX_PLAYERS; i++)
    {
		if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		{
			new strang[64];
			format(strang,sizeof strang,""cgreen"%s is a new group mate!",GetPName(PInfo[playerid][SurvivorWantToJoin]));
			SendClientMessage(i,white,strang);
		}
	}
	return 1;
}

CMD:gdeny(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Zombie can't team up!");
    if(PInfo[playerid][GroupLeader] == 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Only group leaders can deny!");
    if(PInfo[playerid][SurvivorWantToJoin] == -1) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You haven't got team requests!");
    if(PInfo[playerid][GroupPlayers] == 5) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Your group already have 5 players!");
    SendClientMessage(PInfo[playerid][SurvivorWantToJoin],red,""cred"Group leader has denied your request.");
    SendClientMessage(playerid,white,""cred"You have denied a request!");
   	PInfo[playerid][SurvivorWantToJoin] = -1;
   	PInfo[PInfo[playerid][SurvivorWantToJoin]][GroupWantJoin] = 0;
	return 1;
}

CMD:groupquit(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: Only survivors can left from group!");
    if((Team[playerid] == HUMAN) && (PInfo[playerid][GroupIN] == 0)) return SendClientMessage(playerid,white,""cwhite"* "cred"You are not in group, so you dont need to leave!");
    for(new i; i < MAX_PLAYERS; i++)
    {
  		if(PInfo[playerid][GroupLeader] == 1)
   		{
   			if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
        	{
	        	PInfo[i][GroupIN] = 0;
	        	SendClientMessage(playerid,white,""cwhite"* "cblue"You have successfully left a group and your group was deleted!");
	        	if(PInfo[i][GroupLeader] == 0)	SendClientMessage(playerid,white,""cwhite"* "cblue"Your group leader quited group, so this group was removed!");
	        	PInfo[playerid][GroupPlayers] = 0;
	        	PInfo[playerid][GroupLeader] = 0;
	        	GroupID --;
			}
		}
		else
		{
			if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
        	{
   	    		new string[64];
				format(string,sizeof string,""cgreen"Your groupmate %s have left your group!",GetPName(playerid));
				SendClientMessage(i,red,string);
				if(PInfo[i][GroupLeader] == 1) PInfo[i][GroupPlayers] --;
			}
		}
	}
	PInfo[playerid][GroupIN] = 0;
	SendClientMessage(playerid,white,""cwhite"* "cblue"You have successfully left a group!");
	return 1;
}

/*CMD:mygroup(playerid,params[])
{
	new string[128];
	format(string, sizeof string,"You are in %i ID group, Group want to join %i Survivivor want to join %i",PInfo[playerid][GroupIN],PInfo[playerid][GroupWantJoin],PInfo[playerid][SurvivorWantToJoin]);
	SendClientMessage(playerid,white,string);
	return 1;
}*/

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
    /*if(PInfo[playerid][Logged] == 0) return 1;
    if(Team[playerid] == ZOMBIE) return 1;
    if((PInfo[playerid][Infected] == 0) && (Team[playerid] == HUMAN)) return 1;*/
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

CMD:mute(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,reason[40],time;
	if(sscanf(params,"us[40]i",id,reason,time)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/mute <id> <reason> <time in seconds>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	if(id == playerid) return SendClientMessage(playerid,red,"Error: You can't mute yourself!");
	if(PInfo[id][Level] > PInfo[playerid][Level]) return SendClientMessage(playerid,red,"Error: You can't mute administrators with higher levels!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s muted player %s [Reason: %s] [Time: %i seconds] ||",GetPName(playerid),GetPName(id),reason,time);
	PInfo[id][Muted] = 1;
	PInfo[id][MuteTimer] = time;
	SendAdminMessage(red,string);
	return 1;
}

CMD:unmute(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unmute <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s unmuted player %s ||",GetPName(playerid),GetPName(id));
	PInfo[id][Muted] = 0;
	PInfo[id][MuteTimer] = -1;
	SendAdminMessage(red,string);
	return 1;
}

function Muting(playerid)
{
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
	if(PInfo[playerid][Jailed] == 1)
	{
	    if(PInfo[playerid][JailTimer] > 0)
	    {
	        PInfo[playerid][JailTimer] --;
	        if(!IsPlayerInRangeOfPoint(playerid,15,193.7800,174.6417,1003.0234))
			{
			    PInfo[playerid][NormalTP] = 1;
			    WaitAirCheat[playerid]=2;
			    new rand = random(2);
			    switch(rand)
			    {
			        case 0: SetPlayerPos(playerid,193.7800,174.6417,1003.0234);
			        case 1: SetPlayerPos(playerid,198.2025,174.8940,1003.0234);
				}
			}

		}
		if(PInfo[playerid][JailTimer] == 0)
		{
			PInfo[playerid][Jailed] = 0;
			PlayersConnected ++;
			PInfo[playerid][JailTimer] = -1;
			SendClientMessage(playerid,white,"* "cred"You were unjailed! Now relog to server to continue to play!");
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
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid,x,y,z);
	   /* if(z > 137)
	    {
			new string[128];
 			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fly Hacks",GetPName(playerid));
	        SendClientMessageToAll(white,string);
	        SetTimerEx("kicken",300,false,"i",playerid);
		}*/
	    new engine, lights, alarm, doors, bonnet, boot, objective;
	    GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine, lights, alarm, doors, bonnet, boot, objective);
	    {
	        if(engine == 0)
	        {
				new Float:vx,Float:vy,Float:vz;
				GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
				{
				    if(((vx > 1.65) || (vx < -1.65)) || ((vy > 1.65) || (vy < -1.65)))
				    {
						new string[128];
			 			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Car Shot",GetPName(playerid));
				        SendClientMessageToAll(white,string);
				        SetTimerEx("kicken",50,false,"i",playerid);
					}
				}
			}
			else
			{
				new Float:vx,Float:vy,Float:vz;
				GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
				{
				    if(((vx > 2.0) || (vx < -2.0)) || ((vy > 2.0) || (vy < -2.0)))
				    {
						new string[128];
			 			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Car Shot",GetPName(playerid));
				        SendClientMessageToAll(white,string);
				        SetTimerEx("kicken",50,false,"i",playerid);
					}
				}
			}
		}
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(IsPlayerInAnyVehicle(playerid)) continue;
	    new Float:x,Float:y,Float:z;
		GetPlayerPos(i,x,y,z);
		{
		    if(IsPlayerInAnyVehicle(i))
		    {
		        if(IsPlayerInRangeOfPoint(playerid,10,x,y,z))
		        {
     				WaitAirCheat[playerid]=2;
				}
			}
		}
	}
	if((IsPlayerInRangeOfPoint(playerid,10,1548.0122,-1365.8546,326.2109)) || (IsPlayerInRangeOfPoint(playerid,10,1574.0468,-1336.2745,16.4844)))
	{
	    WaitAirCheat[playerid]=2;
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
	static rand;
	rand = random(5);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 1:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 2:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 3:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 4:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		}
	}
	return 1;
}
function Loot2(playerid)
{
	static randem;
	randem = random(18);
	goto Random;
	Random:
	{
		switch(randem)
		{
		    case 0:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
	   		case 1:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 2:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 3:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 4:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 5:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 6:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 7:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 8:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 9:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 10:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 11:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 12:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
			}
		    case 13:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 14:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 15:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 16:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 17:
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

function Jail(playerid)
{
	if(PInfo[playerid][Logged] == 0) return 1;
	PInfo[playerid][NormalTP] = 1;
	if(PInfo[playerid][Jailed] == 1)
	{
	    SetPlayerVirtualWorld(playerid,17);
	    new rand = random(2);
	    switch(rand)
	    {
	        case 0: SetPlayerPos(playerid,193.7800,174.6417,1003.0234);
	        case 1: SetPlayerPos(playerid,198.2025,174.8940,1003.0234);
		}
		SetPlayerInterior(playerid,3);
		PInfo[playerid][CanBite] = 0;
		WaitAirCheat[playerid]=2;
		ResetPlayerWeapons(playerid);
		PInfo[playerid][ZPerk] = 0;
		PInfo[playerid][SPerk] = 0;
		SetPlayerHealth(playerid, 28000);
		PInfo[playerid][CanUseWeapons] = 0;
	}
	else if(PInfo[playerid][Jailed] == 0)
	{
 		SetPlayerVirtualWorld(playerid,17);
 		SetPlayerInterior(playerid,3);
   		new rand = random(2);
	    switch(rand)
	    {
	        case 0: SetPlayerPos(playerid,193.7800,174.6417,1003.0234);
	        case 1: SetPlayerPos(playerid,198.2025,174.8940,1003.0234);
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

CMD:jail(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,reason[40],time;
	if(sscanf(params,"us[40]i",id,reason,time)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/jail <id> <reason> <time in seconds>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	//if(id == playerid) return SendClientMessage(playerid,red,"Error: You can't jail yourself!");
	if(PInfo[id][Level] > PInfo[playerid][Level]) return SendClientMessage(playerid,red,"Error: You can't jail administrators with higher levels!");
	if(PInfo[id][Jailed] == 1) return SendClientMessage(playerid,white,"* "cred"Error: This player is already jailed!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s jailed player %s [Reason: %s] [Time: %i seconds] ||",GetPName(playerid),GetPName(id),reason,time);
	PInfo[id][JailTimer] = time;
	Jail(id);
	new strang[90];
	format(strang,sizeof strang,"~w~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[playerid][JailTimer]);
	SendClientMessage(id,white,"* "cred"Type "corange"/timeleft"cred" to check how much jail time left");
    GameTextForPlayer(id,strang, 6500,3);
	SendAdminMessage(red,string);
	return 1;
}

CMD:timeleft(playerid,params[])
{
	if(PInfo[playerid][Jailed] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not jailed!");
	new strang[90];
	format(strang,sizeof strang,"* "corange"%i "cred"seconds left",PInfo[playerid][JailTimer]);
	SendClientMessage(playerid,white,strang);
	return 1;
}

CMD:setzmoney(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id,money;
	if(sscanf(params,"ui",id,money)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setzmoney <id> <xp>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"» Error: Player is not found!");
	SendFMessageToAll(red,"» Administrator %s has setted %s ZMoney to %i",GetPName(playerid),GetPName(id),money);
	PInfo[id][ZMoney] = money;
	SaveStats(id);
	return 1;
}

CMD:unjail(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unjail <id>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,red,"Error: Player is not found!");
	if(PInfo[id][Jailed] == 0) return SendClientMessage(playerid,white,"* "cred"Error: This player is not jailed!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s unjailed player %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	PInfo[id][Jailed] = 0;
	PlayersConnected ++;
	PInfo[id][JailTimer] = -1;
	SendClientMessage(id,white,"* "cred"You were unjailed! Now relog to server to continue play!");
	SetTimerEx("kicken",50,false,"i",id);
	return 1;
}

function kicken(playerid)
{
	Kick(playerid);
	return 1;
}

CMD:jailtime(playerid,params[])
{
	static string[50];
 	format(string,sizeof string,"Jailed: %i",PInfo[playerid][Jailed]);
	SendClientMessage(playerid,white,string);
	return 1;
}

CMD:shop(playerid,params[])
{
	static Main[60];
	format(Main, sizeof Main,""cgreen"Your ZMoney: "cred"%i",PInfo[playerid][ZMoney]);
    ShowPlayerDialog(playerid,ShopDialog,2,Main,"FAQ\nServices","Choose","Exit");
    return 1;
}

stock IsVehicleRangeOfPoint(vehicleid,Float:range,Float:x,Float:y,Float:z)
{
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    new Float:DistantaCar = GetVehicleDistanceFromPoint(vehicleid, x, y, z);
    if(DistantaCar <= range) return 1;
    return 0;
}

function Tip()
{
    new rand = random(5);
	switch(rand)
	{
	    case 0:
	    {
	        for(new i; i < MAX_PLAYERS; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
	    			SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"The Main Goal of "cpurple"ZOMBIES"cwhite": Kill all of "cgreen"Survivors"cwhite", before they clear all of CheckPoints.");
	    			SendClientMessage(i,white,""cgreen"|| "cwhite"The Main Goal of "cgreen"SURVIVORS"cwhite": Clear all the "cred"CheckPoints"cwhite", before the Zombies kill you.");
	    			SendClientMessage(i,white,""cgreen"=========================================");
	    			SendClientMessage(i,white,"* "cred"You can turn tips of with command /tips");
				}
			}
		}
  		case 1:
	    {
  			for(new i; i < MAX_PLAYERS; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
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
  			for(new i; i < MAX_PLAYERS; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
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
  			for(new i; i < MAX_PLAYERS; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
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
  			for(new i; i < MAX_PLAYERS; i++)
	        {
	            if(!IsPlayerConnected(i)) continue;
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"New on server? Write /help for more info about the server");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"If you saw a rulebreaker don't flood about it in main chat, use "cred"/report "cwhite"for that");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Have suggestions or found a bug? Visit "cblue"Ultimate-Gaming.com "cwhite"and post there your cool ideas!");
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
    PInfo[f][EatenBait] = 1;
    return 1;
}

CMD:donate(playerid,params[])
{
	new string[327];
	format(string,sizeof string,""cwhite"It is a donating menu\nWhen you donate, you get special promocode\nIt is always send to your e-mail, which you wrote on website\nIt looks like \""corange"xxxx-xxxx-xxxx-xxx\"\n"cwhite"If you didn't got any message on your email, make a topic on our forum "cblue" Ultimate-gaming.com\n\t\t\t"cwhite"Write your promocode below");
	ShowPlayerDialog(playerid,DonateDialog,1,""cred"Donate Menu",string,"Activate","Close");
	return 1;
}

function CanEatAgain(playerid)
{
    PInfo[playerid][EatenMeat] = 0;
    return 1;
}

function NewTips()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Logged] == 0) continue;
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Training] == 1) continue;
		/*if(!IsPlayerInCheckpoint(i))
		{
		    TextDrawHideForPlayer(i,CPbar[i]);
		    TextDrawHideForPlayer(i,CPbartext[i]);
		    TextDrawHideForPlayer(i,CPvaluebar[i]);
		    TextDrawHideForPlayer(i,CPvaluepercent[i]);
		}
	    if((PInfo[i][Rank] >= 5) || (PInfo[i][AllowedToTip] == 0))
	    {
	        TextDrawHideForPlayer(i,BiteOrInv[i]);
	        TextDrawHideForPlayer(i,BiteOrInvBOX[i]);
	        TextDrawHideForPlayer(i,RelocateOrCP[i]);
	        TextDrawHideForPlayer(i,RelocateOrCPBOX[i]);
	        TextDrawHideForPlayer(i,PerksTIP[i]);
	        TextDrawHideForPlayer(i,PerksTIPBOX[i]);
		}
		else
		{
			if(Team[i] == HUMAN)
			{
			    TextDrawShowForPlayer(i,BiteOrInv[i]);
				TextDrawSetString(BiteOrInv[i],"~w~Press ~r~N ~w~to open your inventory");
			    TextDrawShowForPlayer(i,BiteOrInvBOX[i]);
			    if(CPID >= 0)
			    {
			    	TextDrawShowForPlayer(i,RelocateOrCP[i]);
			    	TextDrawSetString(RelocateOrCP[i],"~w~Go to ~r~CheckPoint ~w~(red marker on radar)");
			    	TextDrawShowForPlayer(i,RelocateOrCPBOX[i]);
				}
				else
				{
				    TextDrawHideForPlayer(i,RelocateOrCP[i]);
				    TextDrawHideForPlayer(i,RelocateOrCPBOX[i]);
				}
			    if(PInfo[i][Rank] >= 2)
			    {
			    	TextDrawShowForPlayer(i,PerksTIP[i]);
			    	TextDrawSetString(PerksTIP[i],"~w~Press ~r~Y ~w~to open your perks list");
				    TextDrawShowForPlayer(i,PerksTIPBOX[i]);
				}
			}
			else
			{
   				TextDrawShowForPlayer(i,BiteOrInv[i]);
				TextDrawSetString(BiteOrInv[i],"~w~Click ~r~RMB ~w~near humans to bite");
			    TextDrawShowForPlayer(i,BiteOrInvBOX[i]);
   				TextDrawShowForPlayer(i,RelocateOrCP[i]);
				TextDrawSetString(RelocateOrCP[i],"~w~Find letter ~r~T ~w~on radar to relocate");
			    TextDrawShowForPlayer(i,RelocateOrCPBOX[i]);
			    if(PInfo[i][Rank] >= 2)
			    {
			    	TextDrawShowForPlayer(i,PerksTIP[i]);
			    	TextDrawSetString(PerksTIP[i],"~w~Press ~r~Y ~w~to open your perks list");
				    TextDrawShowForPlayer(i,PerksTIPBOX[i]);
				}
			}
		}*/
	}
	return 1;
}

public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
    WaitAirCheat[playerid]=2;
    PInfo[playerid][NormalTP] = 1;
	if(GetPlayerInterior(playerid) > 0)
	{
		if(PInfo[playerid][AllowedToTip] == 1)
		{
			if(PInfo[playerid][Rank] < 5)
				SendClientMessage(playerid,white,"* "cred"TIP:"corange"You are in a building, here you can loot in some places");
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

CMD:clearchat(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* Error: "cred"You are not allowed to use this command!");
	for(new j = 0; j < 90; j ++)
	{
	 	SendClientMessageToAll(white,"  ");
	}
    SendClientMessageToAll(white,""cred"__________Administrator has cleared the chat!__________");
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
	                if(PInfo[i][ChooseAfterTr] == 0)
	                {
	            		PlayersConnected ++;
					}
				}
			}
		}
	}
	return 1;
}

public OnVehicleMod(playerid,vehicleid,componentid)
{

    if(GetPlayerInterior(playerid) == 0)
    {
  	 	new string[128];
       	format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Tuning Hacks",GetPName(playerid));
       	SendClientMessageToAll(red,string);
        SetTimerEx("kicken",50,false,"i",playerid); // Anti-tuning hacks script
        return 0; // Prevents the bad modification from being synced to other players
        //(Tested and it works even on servers wich allow you to mod your vehicle using commands, menus, dialogs, etc..
    }
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

stock GetXYInFrontOfPoint(Float:x, Float:y, &Float:x2, &Float:y2, Float:A, Float:distance)
{
    x2 = x + (distance * floatsin(-A, degrees));
    y2 = y + (distance * floatcos(-A, degrees));
}

public OnCheatDetected(playerid, ip_address[], type, code)
{
	if(!IsPlayerAdmin(playerid))
	{
		switch(code)
		{
		    case 0..1:
		    {
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Airbreak",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
	    	case 13:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Armour Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
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
			case 15:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Weapon Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 19..20:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using GodMode Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 21:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Invisible Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 22:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using lagcomp-spoof",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 23:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Tuning Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 24:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Parkour Mode",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 25:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Quick Turn Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 26:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Rapid Fire",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 27..28:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Kill Flooding",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 29:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Aimbot",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 30:
	    	{
	    	    if(PInfo[playerid][CJRunWarning] == 0)
	    	    {
	    	    	SpawnPlayer(playerid);
	    	    	PInfo[playerid][CJRunWarning] = 1;
				}
				if(PInfo[playerid][CJRunWarning] == 1)
				{
			    	static string[128];
					format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for CJ Run",GetPName(playerid));
					SetTimerEx("kicken",20,false,"i",playerid);
					SendClientMessageToAll(white,string);
				}
				return 1;
			}
			case 31:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Car Shot",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 32:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using CarJack Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 33:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Anti-Freeze Hack",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 34:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using AFK Ghost",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 35:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Aim Bot (type 2)",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 36:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fake NPC",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 41:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Invalid version - %s kicked for wrong version of client",GetPName(playerid));
				SetTimerEx("kicken",20,false,"i",playerid);
				SendClientMessageToAll(white,string);
				return 1;
			}
			case 42:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected try for hacking rcon password - %s kicked for brutting",GetPName(playerid));
				for(new i; i < MAX_PLAYERS;i++)
				{
				    if(PInfo[i][Level] >=1)
				    {
				    	SendClientMessage(i,white,string);
					}
				}
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
	    	    SetTimerEx("kicken",10,false,"i",playerid);
	    	}
	    	case 52:
	    	{
		    	static string[128];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected suspicious - %s possibly use anti-nops",GetPName(playerid));
				for(new i; i < MAX_PLAYERS;i++)
				{
				    if(PInfo[i][Level] >=1)
				    {
				    	SendClientMessage(i,white,string);
					}
				}
	    	}
		}
		if(GetPlayerPing(playerid) < 100)
		{
		    if(PInfo[playerid][ACWarning] == 1)
		    	CheckCode(playerid,code);
			else
			{
			    PInfo[playerid][ACWarning] ++;
				for(new i; i < MAX_PLAYERS; i++)
				{
				    if(!IsPlayerConnected(i)) continue;
				    if(PInfo[i][Logged] == 0) continue;
				    if(PInfo[i][Level] < 1) continue;
					switch(code)
					{
				    	case 2..3:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				 		case 4:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (2-nd type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 5: return 1;
				 		case 6:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (3-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 7..8:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 9..10:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Speed Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 11..12:
				    	{
				    	    if(PInfo[playerid][Hiden] == 1) return 0;
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 16..17:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Ammo Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 18:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
					}
				}
			    KillTimer(PInfo[playerid][KillWarning]);
			    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
			}
		}
		else if((GetPlayerPing(playerid) >= 100) && (GetPlayerPing(playerid) < 200))
		{
		    if(PInfo[playerid][ACWarning] == 2)
		    	CheckCode(playerid,code);
			else
			{
			    PInfo[playerid][ACWarning] ++;
				for(new i; i < MAX_PLAYERS; i++)
				{
				    if(!IsPlayerConnected(i)) continue;
				    if(PInfo[i][Logged] == 0) continue;
				    if(PInfo[i][Level] < 1) continue;
					switch(code)
					{
				    	case 2..3:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				 		case 4:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (2-nd type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 5: return 1;
				 		case 6:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (3-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 7..8:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 9..10:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Speed Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 11..12:
				    	{
				    	    if(PInfo[playerid][Hiden] == 1) return 0;
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 16..17:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Ammo Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 18:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
					}
				}
			    KillTimer(PInfo[playerid][KillWarning]);
			    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
			}
		}
		else if((GetPlayerPing(playerid) >= 200) && (GetPlayerPing(playerid) < 300))
		{
		    if(PInfo[playerid][ACWarning] == 3)
		    	CheckCode(playerid,code);
			else
			{
			    PInfo[playerid][ACWarning] ++;
				for(new i; i < MAX_PLAYERS; i++)
				{
				    if(!IsPlayerConnected(i)) continue;
				    if(PInfo[i][Logged] == 0) continue;
				    if(PInfo[i][Level] < 1) continue;
					switch(code)
					{
				    	case 2..3:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				 		case 4:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (2-nd type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 5: return 1;
				 		case 6:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (3-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 7..8:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 9..10:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Speed Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 11..12:
				    	{
				    	    if(PInfo[playerid][Hiden] == 1) return 0;
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 16..17:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Ammo Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 18:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
					}
				}
			    KillTimer(PInfo[playerid][KillWarning]);
			    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
			}
		}
		else if(GetPlayerPing(playerid) >= 300)
		{
		    if(PInfo[playerid][ACWarning] == 4)
		    	CheckCode(playerid,code);
			else
			{
			    PInfo[playerid][ACWarning] ++;
				for(new i; i < MAX_PLAYERS; i++)
				{
				    if(!IsPlayerConnected(i)) continue;
				    if(PInfo[i][Logged] == 0) continue;
				    if(PInfo[i][Level] < 1) continue;
					switch(code)
					{
				    	case 2..3:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				 		case 4:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (2-nd type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 5: return 1;
				 		case 6:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (3-st type)",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 7..8:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 9..10:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Speed Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
				    	case 11..12:
				    	{
				    	    if(PInfo[playerid][Hiden] == 1) return 0;
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 16..17:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Ammo Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
						case 18:
				    	{
					    	static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendClientMessage(i,white,string);
							return 1;
						}
					}
				}
			    KillTimer(PInfo[playerid][KillWarning]);
			    PInfo[playerid][KillWarning] = SetTimerEx("KillWarn",60000,false,"i",playerid);
			}
		}
	}
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
    	case 2..3:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Teleport Hacks (1-st type)",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
 		case 4:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Teleport Hacks (2-nd type)",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
		case 5: return 1;
 		case 6:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Teleport Hacks (3-st type)",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
    	case 7..8:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fly Hacks",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
    	case 9..10:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Speed Hack",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
    	case 11..12:
    	{
    	    if(PInfo[playerid][Hiden] == 1) return 0;
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Health Hack",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
		case 16..17:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Ammo Hack",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
			return 1;
		}
		case 18:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Special Actions Hack",GetPName(playerid));
			SetTimerEx("kicken",20,false,"i",playerid);
			SendClientMessageToAll(white,string);
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
			    static string[9];
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
			    static string[9];
				PInfo[playerid][XP] += 150;
				PInfo[playerid][CurrentXP] += 150;
				PInfo[playerid][InfectsRound]++;
				format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
			    TextDrawSetString(GainXPTD[playerid],string);
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


public PHY_OnObjectCollideWithZBound(objectid, lowhigh)
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if((objectid == PInfo[i][ZObject]) && (objectid != PInfo[i][FlashBangObject]) && (objectid != PInfo[i][Vomit]))
		{
		    if(IsValidObject(PInfo[i][ZObject]))
		    {
		    	new Float:x, Float:y, Float:z,Float:newZ;
		    	GetObjectPos(PInfo[i][ZObject],x,y,z);
				if(x == 0) continue;
		    	CA_FindZ_For2DCoord(x,y,newZ);
		    	if((newZ - z) > 5)
				{
					GetObjectPos(PInfo[i][ZObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
					PHY_DeleteObject(PInfo[i][ZObject]);
				}
				else
		    	{
		    		PHY_SetObjectZBound(PInfo[i][ZObject], newZ+0.18, _, 0.0);
					GetObjectPos(PInfo[i][ZObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
					SetObjectPos(PInfo[i][ZObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]-0.5);
					PHY_DeleteObject(PInfo[i][ZObject]);
				}
			}
		}
		if((objectid == PInfo[i][FlashBangObject]) && (objectid != PInfo[i][ZObject]) && (objectid != PInfo[i][Vomit]))
		{
			if(IsValidObject(PInfo[i][FlashBangObject]))
			{
			    new Float:x, Float:y, Float:z,Float:newZ;
			    GetObjectPos(PInfo[i][FlashBangObject],x,y,z);
				if(x == 0) continue;
			    CA_FindZ_For2DCoord(x,y,newZ);
			    if((newZ - z) > 5)
				{
					GetObjectPos(PInfo[i][FlashBangObject],x,y,z);
					PHY_DeleteObject(PInfo[i][FlashBangObject]);
				}
				else
			    {
			    	PHY_SetObjectZBound(PInfo[i][FlashBangObject], newZ+0.18, _, 0.0);
					GetObjectPos(PInfo[i][FlashBangObject],x,y,z);
					SetObjectPos(PInfo[i][FlashBangObject],x,y,z-0.5);
					PHY_DeleteObject(PInfo[i][FlashBangObject]);
				}
				SetTimerEx("BlowFlashbang",1700,false,"i",i);
			}
		}
	}
    return 1;
}

new FlashFlashObj[MAX_PLAYERS];

function BlowFlashbang(playerid)
{
	new Float:x,Float:y,Float:z;
	GetObjectPos(PInfo[playerid][FlashBangObject],x,y,z);
	FlashFlashObj[playerid] = CreateObject(18670,x,y,z-1.5,0,0,0,100);
	SetTimerEx("DestoystrFlash",1000,false,"i",playerid);
	CreateExplosion(x,y,z,13,5);
	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(PInfo[i][Logged] == 0) continue;
		if(IsPlayerInRangeOfPoint(i,20,x,y,z))
		{
		    if(IsPlayerFacingObject(i,PInfo[playerid][FlashBangObject],140))
		    {
		    	Flashbang(i);
		    	for(new f; f < MAX_PLAYERS; f++)
		    	{
		    	    if(!IsPlayerConnected(f)) continue;
		    	    if(PInfo[f][Logged] == 0) continue;
					ShowPlayerNameTagForPlayer(i,f,0);
				}
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
	DestroyObject(PInfo[playerid][FlashBangObject]);
	return 1;
}

function DestoystrFlash(playerid)
{
    DestroyObject(FlashFlashObj[playerid]);
	return 1;
}

public PHY_OnObjectCollideWithSAWorld(objectid, Float:cx, Float:cy, Float:cz)
{
	for(new i; i < MAX_PLAYERS;i++)
	{
		if(objectid == PInfo[i][ZObject])
		{
            PHY_DeleteObject(PInfo[i][ZObject]);
		}
	}
	return 1;
}

function ExplodeBait(playerid)
{
	CreateFakeExplosion(18686,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
	new Float:HP,Float:Armour,Float:SavAr;
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Logged] == 0) continue;
	    GetPlayerHealth(i,HP);
	    GetPlayerArmour(i,Armour);
	    if(IsPlayerInRangeOfPoint(i,50,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
	    {
	    	PlayerPlaySound(i,1159,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]);
		}
	    if(IsPlayerInRangeOfPoint(i,5,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ]))
	    {
			/*GetPlayerVelocity(i,VelX,VelY,VelZ);
			GetPlayerFacingAngle(i,a);
			VelX += ( 0.5 * floatsin( -a, degrees ) );
	      	VelY += ( 0.5 * floatcos( -a, degrees ) );
			if(Team[i] == ZOMBIE)
			{
				SetPlayerVelocity(i,VelX*-0.9,VelY*-0.9,VelZ+0.1);
			}*/
			ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
		    if(Armour >= 1)
		    {
			    if(Armour <= 35)
			    {
			       if((Armour - 35) < 0)
			       {
						SavAr = Armour - 35;
						SetPlayerHealth(i, HP - SavAr);
						if(GetPlayerHealth(i,HP) <=0)
						{
							if(Team[i] == ZOMBIE)
							{
								GivePlayerXP(playerid);
								GivePlayerAssistXP(playerid);
								GiveRage(playerid,i);
							}
							else if(Team[i] == HUMAN)
							{
								if(PInfo[i][Infected] == 1)
								{
								    PInfo[i][Dead] = 1;
									GivePlayerXP(playerid);
									GivePlayerAssistXP(playerid);
									GiveRage(playerid,i);
									SetPlayerHealth(i,HP - 35);
									InfectPlayer(i);
								}
							}
						}
					}
				}
				else
				{
				    SetPlayerArmour(i, Armour - 35);
				}
			}
			else
			{
			    GetPlayerHealth(i,HP);
				if(Team[i] == ZOMBIE)
				{
					if(HP <= 35)
					{
						GivePlayerXP(playerid);
						GivePlayerAssistXP(playerid);
						GiveRage(playerid,i);
					}
				    else
						SetPlayerHealth(i,HP - 35);
				}
				if(Team[i] == HUMAN)
				{
				    if(PInfo[i][Infected] == 1)
				    {
						if(HP <= 35)
						{
						    PInfo[i][Dead] = 1;
							GivePlayerXP(playerid);
							GivePlayerAssistXP(playerid);
							GiveRage(playerid,i);
							InfectPlayer(i);
						}
		    			else
							SetPlayerHealth(i,HP - 35);
					}
					else
					{
					    SetPlayerHealth(i,HP - 35);
					}
				}
			}
		}
	}
	StopBait(playerid);
	return 1;
}


function GiveRage(playerid,i)
{
    if(PInfo[playerid][Rank] >= PInfo[i][Rank])
    {
        if((PInfo[i][RageModeStatus] == 100) || (PInfo[i][RageMode] == 1)) return 1;
        new rand = random(17);
		if(PInfo[i][Rank] <= 5)
		{
		    if(PInfo[i][RageModeStatus] >= 83)
		    {
		        PInfo[i][RageModeStatus] = 100;
			}
			else
			{
				rand = random(17);
				switch(rand)
				{
				    case 0: PInfo[i][RageModeStatus] += 11;
				    case 1: PInfo[i][RageModeStatus] += 11;
				    case 2: PInfo[i][RageModeStatus] += 11;
				    case 3: PInfo[i][RageModeStatus] += 11;
				    case 4: PInfo[i][RageModeStatus] += 11;
				    case 5: PInfo[i][RageModeStatus] += 12;
				    case 6: PInfo[i][RageModeStatus] += 12;
				    case 7: PInfo[i][RageModeStatus] += 12;
				    case 8: PInfo[i][RageModeStatus] += 12;
				    case 9: PInfo[i][RageModeStatus] += 13;
				    case 10: PInfo[i][RageModeStatus] += 13;
				    case 11: PInfo[i][RageModeStatus] += 13;
				    case 12: PInfo[i][RageModeStatus] += 14;
				    case 13: PInfo[i][RageModeStatus] += 14;
				    case 14: PInfo[i][RageModeStatus] += 15;
				    case 15: PInfo[i][RageModeStatus] += 16;
				    case 16: PInfo[i][RageModeStatus] += 17;
				}
			}
		}
		if((PInfo[i][Rank] > 5) && (PInfo[i][Rank] <= 13))
		{
		    if(PInfo[i][RageModeStatus] >= 86)
		    {
		        PInfo[i][RageModeStatus] = 100;
			}
			else
			{
				rand = random(17);
				switch(rand)
				{
				    case 0: PInfo[i][RageModeStatus] += 8;
				    case 1: PInfo[i][RageModeStatus] += 8;
				    case 2: PInfo[i][RageModeStatus] += 8;
				    case 3: PInfo[i][RageModeStatus] += 8;
				    case 4: PInfo[i][RageModeStatus] += 8;
				    case 5: PInfo[i][RageModeStatus] += 9;
				    case 6: PInfo[i][RageModeStatus] += 9;
				    case 7: PInfo[i][RageModeStatus] += 9;
				    case 8: PInfo[i][RageModeStatus] += 9;
				    case 9: PInfo[i][RageModeStatus] += 10;
				    case 10: PInfo[i][RageModeStatus] += 10;
				    case 11: PInfo[i][RageModeStatus] += 10;
				    case 12: PInfo[i][RageModeStatus] += 11;
				    case 13: PInfo[i][RageModeStatus] += 11;
				    case 14: PInfo[i][RageModeStatus] += 12;
				    case 15: PInfo[i][RageModeStatus] += 13;
				    case 16: PInfo[i][RageModeStatus] += 14;
				}
			}
		}
		if(PInfo[i][Rank] > 14)
		{
		    if(PInfo[i][RageModeStatus] >= 90)
		    {
		        PInfo[i][RageModeStatus] = 100;
			}
			else
			{
				rand = random(17);
				switch(rand)
				{
				    case 0: PInfo[i][RageModeStatus] += 5;
				    case 1: PInfo[i][RageModeStatus] += 5;
				    case 2: PInfo[i][RageModeStatus] += 5;
				    case 3: PInfo[i][RageModeStatus] += 5;
				    case 4: PInfo[i][RageModeStatus] += 5;
				    case 5: PInfo[i][RageModeStatus] += 6;
				    case 6: PInfo[i][RageModeStatus] += 6;
				    case 7: PInfo[i][RageModeStatus] += 6;
				    case 8: PInfo[i][RageModeStatus] += 6;
				    case 9: PInfo[i][RageModeStatus] += 7;
				    case 10: PInfo[i][RageModeStatus] += 7;
				    case 11: PInfo[i][RageModeStatus] += 7;
				    case 12: PInfo[i][RageModeStatus] += 7;
				    case 13: PInfo[i][RageModeStatus] += 7;
				    case 14: PInfo[i][RageModeStatus] += 8;
				    case 15: PInfo[i][RageModeStatus] += 9;
				    case 16: PInfo[i][RageModeStatus] += 10;
				}
			}
		}
	}
	return 1;
}

function DestroyFlag(playerid)
{
	for(new i ; i < MAX_PLAYERS; i ++)
	{
		new string[128];
		format(string, sizeof string, "* "cjam"%s's flag has ended its charge!",GetPName(playerid));
		SendClientMessage(i,white,string);
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
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
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
				    GetPlayerPos(i,x,y,z);
				    PlayerPlaySound(i,40405,x,y,z);
				    SetPlayerHealth(i,HP+5);
				}
			}
		}
	}
	return 1;
}

function AutoBalance()
{
	new infects,SurvLoggedIn;
	if(CanItRandom == 1)
	{
		for(new i; i < MAX_PLAYERS;i++)
		{
	    	if(!IsPlayerConnected(i)) continue;
		    if(PInfo[i][Firstspawn] == 1) continue;
		    if(PInfo[i][Training] == 1) continue;
		    if(Team[i] == ZOMBIE) infects++;
		    if((Team[i] == HUMAN) && (PInfo[i][Spawned] == 1))
		    {
		        SurvLoggedIn++;
			}
		}
		if((floatround(100.0 * floatdiv(infects, SurvLoggedIn)) >= 30) || (SurvLoggedIn < 5)) return 1;
		else
		{
		    SetTimer("Auto4",1000,false);
			for( new z; z < MAX_PLAYERS; z++)
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
	for( new z; z < MAX_PLAYERS; z++)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 4...");
    }
    return 1;
}

function Auto3()
{
	SetTimer("Auto2",1000,false);
	for( new z; z < MAX_PLAYERS; z++)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 3...");
    }
    return 1;
}

function Auto2()
{
	SetTimer("Auto1",1000,false);
	for( new z; z < MAX_PLAYERS; z++)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 2...");
    }
    return 1;
}

function Auto1()
{
	SetTimer("AutoBalanceEnd",1000,false);
	for( new z; z < MAX_PLAYERS; z++)
	{
		SendClientMessage(z,white,"** "cred"Autobalance: 1...");
    }
    return 1;
}

function AutoBalanceEnd(playerid)
{
	new infects;
	for(new i; i < MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 30)
	{
	    for (new i ; i < MAX_PLAYERS; i ++)
	    {
	        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance was cancelled. Reason: Infection is more than 30 %");
		}
		return 1;
	}
	if(PlayersConnected < 5)
	{
 		for (new i ; i < MAX_PLAYERS; i ++)
	    {
	        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance was cancelled. Reason: Not enough players for autobalance");
		}
		return 1;
	}
	SetTimer("RandomSet",100,false);
	for (new i ; i < MAX_PLAYERS; i ++)
    {
        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance successfully chose random humans!");
	}
	return 1;
}


function RandomSet()
{
	new infects;
	new Destained;
	new rand = random(PlayersConnected)+1;
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
    for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(PInfo[i][Firstspawn] == 1) continue;
		if(Team[i] == ZOMBIE) infects++;
	}
    Destained = floatround(100.0 * floatdiv(infects, PlayersConnected));
	SendClientMessage(rand,white,"** "cred"Autobalance: "cwhite"Random chose you! Help zombies for winning this round!");
	Team[rand] = ZOMBIE;
	infects ++;
	SpawnPlayer(rand);
	Destained = floatround(100.0 * floatdiv(infects, PlayersConnected));
	if(Destained < 30)
		SetTimer("RandomSet",100,false);
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

function TipBitting(playerid)
{
	new Float:x,Float:y,Float:z;
	if(Team[playerid] == ZOMBIE)
	{
	    if(PInfo[playerid][Rank] <=5)
	    {
	    	for(new i; i < MAX_PLAYERS;i++)
	    	{
	        	if(Team[i] == HUMAN)
	        	{
	        	    GetPlayerPos(i,x,y,z);
	        	    if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
	        	    {
	        	        GameTextForPlayer(playerid,"~w~CLICK ~r~RIGHT MOUSE BUTTON~n~~w~TO BITE",1500,3);
					}
				}
			}
		}
	}
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
			   	for(new i; i < MAX_PLAYERS;i++)
			    {
			        if(Team[i] == ZOMBIE) continue;
			        if(!IsPlayerConnected(i)) continue;
			        if(PInfo[i][Dead] == 1) continue;
					if(IsPlayerInRangeOfPoint(i,5.5,PInfo[playerid][Vomitx],PInfo[playerid][Vomity],PInfo[playerid][Vomitz]))
					{
					    if(IsPlayerInAnyVehicle(i))
					    {
					        new Float:vh;
					        GetVehicleHealth(GetPlayerVehicleID(i),vh);
					        SetVehicleHealth(GetPlayerVehicleID(i),vh-50);
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
			    				if(Health <= 9.0 && Health > 0.0)
								{
							    	InfectPlayer(i);
							    	PInfo[i][Dead] = 1;
							    	GivePlayerXP(playerid);
							    	GivePlayerAssistXP(playerid);
						        	CheckRankup(playerid);
						        	PInfo[i][AfterLifeInfected] = 1;
								}
								else
				    				SetPlayerHealth(i,Health-9.0);
							}
							else if(PInfo[i][Rank] < PInfo[playerid][Rank])
							{
			    				if(Health <= 13.0 && Health > 0.0)
								{
							    	InfectPlayer(i);
							    	PInfo[i][Dead] = 1;
							    	GivePlayerXP(playerid);
							    	GivePlayerAssistXP(playerid);
						        	CheckRankup(playerid);
						        	PInfo[i][AfterLifeInfected] = 1;
								}
								else
				    				SetPlayerHealth(i,Health-13.0);
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
	PInfo[i][Stomped] = 0;
	return 1;
}

CMD:tips(playerid,params[])
{
	if(PInfo[playerid][AllowedToTip] == 1)
	{
	    SendClientMessage(playerid,white,"* "cred"You have successfuly turned off tips!");
	    PInfo[playerid][AllowedToTip] = 0;
	}
	else
	{
	    SendClientMessage(playerid,white,"* "cred"You have successfuly turned on tips!");
	    PInfo[playerid][AllowedToTip] = 1;
	}
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
	new Float:HP;
	GetPlayerHealth(playerid,HP);
	PlayerPlaySound(playerid,32402,0,0,0);
	if(HP >= 4)
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
		for(new i; i < MAX_PLAYERS; i++)
		{
		    if(i == playerid) continue;
		    if(PInfo[i][Dead] == 1) continue;
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			if(IsPlayerInRangeOfPoint(i,20.0,x,y,z))
			if(Team[i] == HUMAN)
			{
				PInfo[i][sAssists] ++;
				if(PInfo[i][ShowingXP] == 0)
				{
					static string[7];
					if(PInfo[i][Premium] == 2)
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 10;
							PInfo[i][CurrentXP] += 10;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 20;
							PInfo[i][CurrentXP] += 20;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 30;
							PInfo[i][CurrentXP] += 30;
						}
					}
					else if(PInfo[i][Premium] == 3)
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 12;
							PInfo[i][CurrentXP] += 12;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 36;
							PInfo[i][CurrentXP] += 36;
						}
					}
					else
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 8;
							PInfo[i][CurrentXP] += 8;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 16;
							PInfo[i][CurrentXP] += 16;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
					}
					PInfo[i][InfectsRound]++;
					format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					TextDrawSetString(GainXPTD[i],string);
					PInfo[i][ShowingXP] = 1;
				    SetTimerEx("ShowXP1",100,0,"d",i);
				    TextDrawShowForPlayer(i,GainXPTD[i]);
				}
				else
				{
			        static string[7];
		            if(PInfo[i][Premium] == 2)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 10;
							PInfo[i][CurrentXP] += 10;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 20;
							PInfo[i][CurrentXP] += 20;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 30;
							PInfo[i][CurrentXP] += 30;
						}
					}
		            else if(PInfo[i][Premium] == 3)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 12;
							PInfo[i][CurrentXP] += 12;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 36;
							PInfo[i][CurrentXP] += 36;
						}
					}
					else
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 8;
							PInfo[i][CurrentXP] += 8;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 16;
							PInfo[i][CurrentXP] += 16;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
					}
					PInfo[i][InfectsRound]++;
			        format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
			        TextDrawSetString(GainXPTD[i],string);
				}
			}
		}
	}
	else if(Team[playerid] == ZOMBIE)
	{
	    for(new i; i < MAX_PLAYERS; i++)
	    {
	        if(i == playerid) continue;
	        if(PInfo[i][Dead] == 1) continue;
	        PInfo[i][zAssists] ++;
	        if(Team[i] == ZOMBIE)
	        {
				if(PInfo[i][ShowingXP] == 0)
				{
					static string[7];
					if(PInfo[i][Premium] == 2)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 14;
							PInfo[i][CurrentXP] += 14;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 28;
							PInfo[i][CurrentXP] += 28;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 42;
							PInfo[i][CurrentXP] += 42;
						}
					}
					else if(PInfo[i][Premium] == 3)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 16;
							PInfo[i][CurrentXP] += 16;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 32;
							PInfo[i][CurrentXP] += 32;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 48;
							PInfo[i][CurrentXP] += 48;
						}
					}
					else
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 12;
							PInfo[i][CurrentXP] += 12;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 36;
							PInfo[i][CurrentXP] += 36;
						}
					}
					PInfo[i][InfectsRound]++;
					format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
					TextDrawSetString(GainXPTD[i],string);
					PInfo[i][ShowingXP] = 1;
				    SetTimerEx("ShowXP1",100,0,"d",i);
				    TextDrawShowForPlayer(i,GainXPTD[i]);
				}
				else
				{
			        static string[7];
		            if(PInfo[i][Premium] == 2)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 14;
							PInfo[i][CurrentXP] += 14;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 28;
							PInfo[i][CurrentXP] += 28;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 42;
							PInfo[i][CurrentXP] += 42;
						}
					}
					else if(PInfo[i][Premium] == 3)
					{
		 				if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 16;
							PInfo[i][CurrentXP] += 16;
						}
		 				if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 32;
							PInfo[i][CurrentXP] += 32;
						}
		 				if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 48;
							PInfo[i][CurrentXP] += 48;
						}
					}
					else
					{
						if(PInfo[i][ExtraXP] == 0)
				 	    {
							PInfo[i][XP] += 12;
							PInfo[i][CurrentXP] += 12;
						}
						if(PInfo[i][ExtraXP] == 1)
				 	    {
							PInfo[i][XP] += 24;
							PInfo[i][CurrentXP] += 24;
						}
						if(PInfo[i][ExtraXP] == 2)
				 	    {
							PInfo[i][XP] += 36;
							PInfo[i][CurrentXP] += 36;
						}
					}
					PInfo[i][InfectsRound]++;
			        format(string,sizeof string,"+%i XP",PInfo[i][CurrentXP]);
			        TextDrawSetString(GainXPTD[i],string);
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
    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);
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

public OnProjectileUpdate(projid)
{
	new Float:x,
		Float:y,
		Float:z;
	for(new f; f < MAX_PLAYERS; f++)
	{
		for (new i; i < grenadesCount[f]; i++)
		{
	    	if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, GrenadesObject[f][i], E_STREAMER_EXTRA_ID) == projid)
	    	{
				GetProjectilePos(projid, x, y, z);
				SetDynamicObjectPos(GrenadesObject[f][i], x, y, z);

				GetProjectileRot(projid, x, y, z);
				SetDynamicObjectRot(GrenadesObject[f][i], x, y, z);
	        	break;
	    	}
		}
	}
	return 1;
}


public OnProjectileCollide(projid, type, Float:x, Float:y, Float:z, extraid)
{
	for(new f; f < MAX_PLAYERS; f++)
	{
		for (new i; i < grenadesCount[f]; i++)
		{
	    	if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, GrenadesObject[f][i], E_STREAMER_EXTRA_ID) == projid)
			{

				StopProjectile(projid);
				DestroyDynamicObject(GrenadesObject[f][i]);
				CreateFakeExplosion(18683,x,y,z-1.25);
				PInfo[f][CanGrenadeAgain] = 1;
				for(new g; g < MAX_PLAYERS; g ++)
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
			        if(IsPlayerInRangeOfPoint(g,10.5,x,y,z))
			        {
						if(Health <=30)
						{
						    if((Team[g] == ZOMBIE) || ((PInfo[g][Infected] == 1) && (Team[g] == HUMAN)))
						    {
			  					GivePlayerXP(f);
			  					GivePlayerAssistXP(f);
							}
							if((PInfo[g][Infected] == 1) && (Team[g] == HUMAN))
							{
							    PInfo[g][Dead] = 1;
							    InfectPlayer(g);
							}
							else
							SetPlayerHealth(g,0);
						}
						else
							SetPlayerHealth(g,Health-30);
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

function CheckIfEvoid(playerid)
{
    PInfo[playerid][EvoidingCP] = 1;
	new Float:x,Float:y,Float:z;
    SendClientMessage(playerid,white,"** "cred"You too long not entered CheckPoint!");
    SendClientMessage(playerid,white,"** "cred"Zombies felt you and they can easily find you now!");
    SendClientMessage(playerid,white,"** "cred"Find shelter or quickly enter the checkpoint!");
    GetPlayerPos(playerid,x,y,z);
    PlayerPlaySound(playerid,30600,x,y,z);
    PlayerPlaySound(playerid,30600,x,y,z);
    new string[190];
    for(new i; i < MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(PInfo[i][Logged] == 0) continue;
        if(PInfo[i][Level] >=1)
        {
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected CheckPoint Avoiding, possibly %s is avoding CP!",GetPName(playerid));
			SendClientMessage(i,white,string);
		}
	}
	return 1;
}


CMD:givegr(playerid,params[])
{
	PInfo[playerid][AssaultGrenades] += 10;
	return 1;
}

CMD:setclearedcp(playerid,params[])
{
	if(PInfo[playerid][Level] <= 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
	new cp;
	if(sscanf(params,"i",cp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setclearedcp <RoundClearedCP>");
	if((cp < 0) || (cp > 8)) return SendClientMessage(playerid,white,"** "cred"ERROR: Cleared CPs must be between 0 and 8!");
	CPscleared = cp;
    static string2[96];
    format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
	TextDrawSetString(CPSCleared,string2);
	return 1;
}

CMD:evoidhim(playerid,params[])
{
	if(PInfo[playerid][Level] <= 4) return SendClientMessage(playerid,white,"» Error: "cred"You are not allowed to use this command!");
    new id;
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/evoidhim <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"** "cred"ERROR: Player is not connected!");
	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,white,"** "cred"ERROR: Player is not Logged In!");
	PInfo[id][EvoidingCP] = 1;
	return 1;
}

function UpdateVehicleDamage()
{
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(!IsPlayerConnected(i)) continue;
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
	return 1;
}

function GivePlayerHealthInCP()
{
	new Float:hp;
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Logged] == 0) continue;
	    if(Team[i] == ZOMBIE) continue;
	    if(!IsPlayerInCheckpoint(i)) continue;
	    GetPlayerHealth(i,hp);
	    if(hp < 100)
 		SetPlayerHealth(i,hp+1);
	}
	return 1;
}

function SearchInside(playerid)
{
	if(PInfo[playerid][Training] == 1)
	{
    	if(PInfo[playerid][TrainingPhase] == 5)
    	{
    	    new strang[1577];
			format(strang,sizeof strang,""cwhite"Good Job!\nIf you were lucky you've got new item in your inventory!("cred"Press N to open it"cwhite")\nAlso you can find there:\n\n"cgreen"Bullets for your weapon(s)\nMed kits\nFlashlights (let you see zombies on map)");
			strcat(strang,"\nDizzy Away Pills (decreased dizzy effect after zombies' attack)\nMolotov mission (let you craft molotov)\nFuel and Oil(you can fill with it your vehicle)\nGo to the next pickup to continue your course!");
			ShowPlayerDialog(playerid,20752,DSM,"Info",strang,"OK","");
            PInfo[playerid][TrainingPhase] = 6;
 			Player1stGate = CreatePlayerObject(playerid,980,214.7910000,1875.6939700,13.1130000,0.0000000,0.0000000,357.9950000); //thisisgateforplayer2
		}
	}
	static rand;
	rand = random(30);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 1:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
		    case 2:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 3:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 4:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 5:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 6:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 7:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 8:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 9:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 10:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 11:
		    {
		        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"You haven't found anything...");
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Molotov Guide.",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][MolotovMission] = 1;
				AddItem(playerid,"Molotov Guide",1);
		    }
		    case 12:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 13:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 14:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 15:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 16:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 17:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 18:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 19:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 20:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 21:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 22:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 23:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 24:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 25:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 26:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 27:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 28:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 29:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		}
	}
	PInfo[playerid][FoundBullets] = 0;
	return 1;
}

function SearchInsideWith19Perk(playerid)
{
	static rand;
	rand = random(23);
	goto Random;
	Random:
	{
		switch(rand)
		{
		    case 0:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 1:
		    {
                static string[100];
			    format(string,sizeof string,""cwhite"* "cjam"%s has found Large Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Large Med Kits",1);
		    }
		    case 2:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 3:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 4:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Medium Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Medium Med Kits",1);
		    }
		    case 5:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 6:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 7:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 8:
		    {
		        if(PInfo[playerid][MolotovMission] == 1) return SendClientMessage(playerid,white,"* "cred"You haven't found anything...");
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Molotov Guide.",GetPName(playerid),playerid);
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][MolotovMission] = 1;
				AddItem(playerid,"Molotov Guide",1);
		    }
		    case 10:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 11:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 12:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 13:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 14:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Small Med Kit.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Small Med Kits",1);
		    }
		    case 15:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Flashlight.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Flashlight",1);
		    }
		    case 16:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found Dizzy Away Pills.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Dizzy Away",1);
		    }
		    case 17:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 18:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 19:
		    {
				SendClientMessage(playerid,white,"* "cred"You haven't found any items...");
		    }
		    case 20:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Fuel.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Fuel",1);
		    }
		    case 21:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		    case 22:
		    {
                static string[100];
			    format(string,sizeof string,""cjam"%s has found some Oil.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				AddItem(playerid,"Oil",1);
		    }
		}
	}
	PInfo[playerid][FoundBullets] = 0;
	return 1;
}

function SearchForBullets(playerid)
{
	static rand;
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

CMD:letsdothat(playerid,params[])
{
	DropSupply();
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
	            for(new i; i < MAX_PLAYERS; i++)
	            {
					if(!IsPlayerConnected(i)) continue;
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Airport.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Containers will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 0;
				SetTimer("SendSupply",20000,false);
			}
			case 1:
			{
	            for(new i; i < MAX_PLAYERS; i++)
	            {
					if(!IsPlayerConnected(i)) continue;
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Market.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Containers will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 1;
				SetTimer("SendSupply",20000,false);
			}
			case 2:
			{
	            for(new i; i < MAX_PLAYERS; i++)
	            {
					if(!IsPlayerConnected(i)) continue;
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered near "cwhite"Grove st.");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Containers will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 2;
				SetTimer("SendSupply",20000,false);
			}
			case 3:
			{
	            for(new i; i < MAX_PLAYERS; i++)
	            {
					if(!IsPlayerConnected(i)) continue;
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered to "cwhite"drains near Unity");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Containers will be released in 20 seconds.");
					SendClientMessage(i,white,"Announcer: "cpblue"Please Go There For Extra Assistance");
				    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
				}
				SupplyDirect = 3;
				SetTimer("SendSupply",20000,false);
			}
			case 4:
			{
	            for(new i; i < MAX_PLAYERS; i++)
	            {
					if(!IsPlayerConnected(i)) continue;
				    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
				    SendClientMessage(i,white,"Announcer: "cpblue"Infection in Los Santos reached more than "cred"60%"cpblue"!!!");
				    SendClientMessage(i,white,"Announcer: "cpblue"Container with sets of support kits will be delivered to "cwhite"Ammunation");
				    SendClientMessage(i,white,"Announcer: "cpblue"In support kits you will find medical kits, ammunition and etc.");
				    SendClientMessage(i,white,"Announcer: "cpblue"Containers will be released in 20 seconds.");
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
    for(new i; i < MAX_PLAYERS; i++)
    {
		if(!IsPlayerConnected(i)) continue;
	    SendClientMessage(i,white,"** "cred"You hear something from nearby radio "cwhite"**");
	    SendClientMessage(i,white,"Announcer: "cpblue"Container have been delivered to final destination!");
	    SendClientMessage(i,white,"**"cred"The Radio cuts to Static...");
	}
	new string[512];
	format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
	switch(SupplyDirect)
	{
	    case 0:
	    {
            for(new i; i < MAX_PLAYERS; i++)
            {
				if(!IsPlayerConnected(i)) continue;
				SetPlayerMapIcon(i,77,1986.0311,-2381.5178,13.5469,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,1986.40405,-2383.26196,12.547,0,0,0,300);
			objectsupply1 = CreateObject(18728,1986.40405,-2383.26196,12.547,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = Create3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,0);
		}
	    case 1:
	    {
            for(new i; i < MAX_PLAYERS; i++)
            {
				if(!IsPlayerConnected(i)) continue;
				SetPlayerMapIcon(i,77,839.1480,-1369.9624,22.5321,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,834.56836,-1367.35254,21.532,0,0,0,300);
			objectsupply2 = CreateObject(18728,834.56836,-1367.35254,21.532,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = Create3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,0);
		}
	    case 2:
	    {
            for(new i; i < MAX_PLAYERS; i++)
            {
				if(!IsPlayerConnected(i)) continue;
				SetPlayerMapIcon(i,77,2518.4868,-1563.7096,22.8676,18,0,MAPICON_GLOBAL);
			}
   			objectsupply1 = CreateObject(2973,2517.23706,-1561.51404,21.945,0,0,0,300);
   			objectsupply2 = CreateObject(18728,2517.23706,-1561.51404,21.945,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = Create3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,0);
		}
	    case 3:
	    {
            for(new i; i < MAX_PLAYERS; i++)
            {
				if(!IsPlayerConnected(i)) continue;
				SetPlayerMapIcon(i,77,2022.0211,-1851.5437,3.9844,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,2023.30896,-1851.44397,2.984,0,0,0,300);
			objectsupply2 = CreateObject(18728,2023.30896,-1851.44397,2.984,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = Create3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,0);
		}
	    case 4:
	    {
            for(new i; i < MAX_PLAYERS; i++)
            {
				if(!IsPlayerConnected(i)) continue;
				SetPlayerMapIcon(i,77,1360.9065,-1262.3665,13.3828,18,0,MAPICON_GLOBAL);
			}
			objectsupply1 = CreateObject(2973,1359.78601,-1263.35803,12.383,0,0,0,300);
			objectsupply2 = CreateObject(18728,1359.78601,-1263.35803,12.383,0,0,0,300);
			GetObjectPos(objectsupply1,SX,SY,SZ);
			SupplyLabel = Create3DTextLabel(string,0x6E0C91aa,SX,SY,SZ+1.5,20.0,0);
		}
	}
	return 1;
}

function invadinprogress()
{
	if((SupplyDestroyed == 0) && (SupplyInvaded == 0))
	{
		new Float:SX,Float:SY,Float:SZ,id = -1;
		GetObjectPos(objectsupply1,SX,SY,SZ);
		for(new i; i < MAX_PLAYERS; i ++)
		{
			if(!IsPlayerConnected(i)) continue;
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
			    Delete3DTextLabel(SupplyLabel);
			    for(new i; i < MAX_PLAYERS; i ++)
			    {
					if(!IsPlayerConnected(i)) continue;
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
				new string[512];
				format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
				Update3DTextLabelText(SupplyLabel,green,string);
			}
		}
	}
	return 1;
}



function Show1stDialog(playerid)
{
    new strang[2048];
    format(strang,sizeof strang,""cwhite"You are playing on TDM "cpurple"Zombie "cwhite"server!\nThere are 2 teams: Zombies and Humans\nBoth of them have main goal\n"cpurple"Zombies "cwhite"must to infect all humans and don't let "cgreen" Humans to clear all "cred"Checkpoints"cgreen"");
    strcat(strang,"\n"cgreen"Humans' "cwhite"main goal is clear all "cred"Checkpoints\nCheckPoints "cwhite"are red marker on your radar\nThey appear every 2 minutes after its clearing");
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

