//===========================[INCLUDES START]===================================
#include <crashdetect>
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
#define ACHD                                                            200
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

#undef INVALID_PROJECTILE_ID
#define INVALID_PROJECTILE_ID 											-1
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
#define AC_MAX_NOP_TIMER_WARNINGS                                       7
#define AC_MIN_TIME_RECONNECT                                           3
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
new Text:TipBox[MAX_PLAYERS];
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

/*new Float:PresentsPos[50][3] =
{
	{398.4194,-1512.5970,32.1348}, // Present
	{549.2121,-1435.3081,16.0016}, // Present
	{189.2155,-1821.9753,4.2427}, // Present
	{356.7580,-2032.1604,10.8880}, // Present
	{738.7299,-1337.5432,13.5337}, // Present
	{847.0777,-1217.4851,16.9766}, // Present,
	{933.3659,-1104.3536,24.6215}, // Present
	{1066.8531,-1775.8623,15.5318}, // Present
	{1141.6964,-2036.7089,69.0078}, // Present
	{1166.6882,-1489.1910,22.7582}, // Present
	{1083.3684,-1493.0825,22.7500}, // Present
	{1172.0808,-728.0872,63.8647}, // Present
	{1160.4548,-694.5425,64.1667},// Present
	{1947.2354,-1210.5402,22.6265}, // Present
	{1905.7834,-1389.5891,10.3594}, // Present
	{1772.2710,-1699.1865,13.4842}, // Present
	{1853.0450,-1863.9370,13.5781},// Present
	{1754.5204,-1916.6968,13.5781}, // Present
	{1720.4874,-1838.1812,13.5499}, // Present
	{2281.7644,-1680.3324,14.3506}, // Present
	{2527.3628,-1669.5846,15.1703}, // Present
	{2720.1182,-1873.0132,9.5456}, // Present
	{2870.0161,-1588.9249,23.3191}, // Present
	{2801.3289,-1610.6924,28.2664}, // Present
	{2804.1787,-1067.4032,30.4025}, // Present
	{2139.1399,-1181.1321,28.1484}, // Present
	{2035.7346,-1447.4758,17.2831}, // Present
	{1631.4478,-1844.8441,25.8990}, // Present
	{1571.1359,-2242.7852,13.5401},// Present
	{909.7426,-944.3022,43.7656}, // Present
	{1680.7443,-476.2507,46.1641}, // Present
	{2585.8923,-1603.1090,3.9472}, // Present
	{1943.0302,-1953.5614,16.8434}, // Present
	{2002.0618,-2067.6606,13.5469}, // Present
	{2734.7493,-2450.4177,17.5938}, // Present
	{1163.1370,-1798.4465,33.6333}, // Present
	{154.4232,-1941.2009,3.7734}, // Present
	{1376.1700,-1432.4043,1724.6233}, // Present
	{1372.5831,-1473.3260,1724.8263}, // Present
	{1408.3691,-1483.1388,1724.9983},// Present
	{1418.2255,-1434.1180,1724.7982}, // Present
	{1446.9153,-1473.6520,1754.3142}, // Present
	{1938.3755,-1831.3711,7.0781},
	{1486.3800,-1638.0402,14.9512}, // present
	{1729.4462,-1065.0299,27.2013}, // present
	{1154.3910,-1770.5857,16.5938}, // present
	{968.3940,-1309.5809,18.0522}, // present
	{836.3166,-1597.1625,18.0970}, // present
	{2754.3765,-1177.6929,69.4034}, // present
	{2695.3862,-1195.6747,69.7155}// present
};*/

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
	IPAdress[32],
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
    Snowon,
    SnowObjects1,
    SnowObjects2,
    SnowObjects3,
    SnowObjects4,
    AlreadyWasInCar,
    CanGiveDizzy,
    Poisoned,
    CheckEnter,
	MineObject,
	ChoseMap,
	DontUpdate,
	CheckMine,
	Resueded,
    SeismicTimerPhase2,
    ClanID,
    ClanName[64],
    ZombieFighting,
    ClanLeader,
    ResetPingWarns,
    SecretAdmin,
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
	AchievementKills,
	AchievementInfect,
	Achievement50Hours,
	AchievementCollect20,
	AchievementAllGiven,
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
	CheckFill,
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
 	DontExplode,
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
	JasonsHP,
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
//new PresentsPU[sizeof(PresentsPos)];
new MeatHive[sizeof(HiveMeatPos)];
new TPHive[sizeof(HiveTeleports)];
new LootOutPlaces[sizeof(LootOutSide)];
new Float:Fuel[MAX_VEHICLES];
new Float:Oil[MAX_VEHICLES];
new VehicleWithoutKeys[MAX_VEHICLES];
new WasVehicleDamaged[MAX_VEHICLES];
new VehicleStarted[MAX_VEHICLES];
new VehicleHideSomeone[MAX_VEHICLES];
new PlayersConnected;
new SupplyDirect = -1;
new	Float:BefPos[MAX_PLAYERS][4];
new RoundEnded;
new Mission[MAX_PLAYERS];
new MissionPlace[MAX_PLAYERS][2];
new GroupID;
new ProjectileType[MAX_PLAYERS][3];
new sgtSoap;
new Player1stGate;
new Player2ndGate;
new objectsupply1;
new DNAPu;
new objectsupply2;
new HelpPickupCraft;
new HelpPickupDNAmod;
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
public OnGameModeInit()
{
	SendRconCommand("hostname [uG] Los Santos Zombie Apocalypse");
	SetGameModeText("LS Zombie Apoc. 0.05.55");
	SetTimer("Dizzy",45000,true);
	SetTimer("UpdateStats",700,true);
	SetTimer("RandomCheckpoint",CPTIME,false);
	SetTimer("FiveSeconds",5000,true);
	SetTimer("Tip",180000,true);
	SetTimer("RemoveOilOrFuel",30000,true);
	SetTimer("TipsAdv",1500,true);
	GivePlayerHealthInCP();
	EnableAntiCheat(39,0);
	EnableAntiCheat(19,0);
	EnableAntiCheat(49,0);
	EnableAntiCheat(32,0);
	SetNameTagDrawDistance(15.0);
	CA_Init();
	print("Trying to include SGT_Soap");
	print("=====================================");
	print("LOS SANTOS ZOMBIE APOCALYPSE...");
	print("LOADING CONFIGURATION...");
	LoadObj();
	print("CHECK UPDATES...");
	print("CHECK LAST VERSIONS PLUGINS...");
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
    
    DNAPu = CreatePickup(2976,23,1456.3890,-1482.4321,1754.4264,-1);
    for(new j; j < sizeof(Searchplaces);j++)
    {
        PickUpsSearching[j] = CreatePickup(1318,23,Searchplaces[j][0],Searchplaces[j][1],Searchplaces[j][2],-1);
	}
    for(new j; j < sizeof(HiveMeatPos);j++)
    {
        MeatHive[j] = CreatePickup(1318,3,HiveMeatPos[j][0],HiveMeatPos[j][1],HiveMeatPos[j][2],0);
    }
    for(new j; j < sizeof(HiveTeleports);j++)
    {
        TPHive[j] = CreatePickup(1559,2,HiveTeleports[j][0],HiveTeleports[j][1],HiveTeleports[j][2],-1);
    }
    for(new j; j < sizeof(LootOutSide);j++)
    {
        LootOutPlaces[j] = CreatePickup(2057,2,LootOutSide[j][0],LootOutSide[j][1],LootOutSide[j][2],-1);
    }
    for(new j; j < sizeof(LootMaterials); j++)
    {
        LootMaterialsPickups[j] = CreatePickup(1318,23,LootMaterials[j][0],LootMaterials[j][1],LootMaterials[j][2],-1);
    }
    for(new j; j < sizeof(CraftArrows); j++)
    {
        CraftArrowsPickups[j] = CreatePickup(1318,23,CraftArrows[j][0],CraftArrows[j][1],CraftArrows[j][2],-1);
    }
    for(new i; i < MAX_PLAYERS; i++)
    {
    	Jason[i] = CreateActor(23,307.1434,2604.6030,16.4844,89.4828);
    	SetActorInvulnerable(Jason[i], 1);
    }
    /*for(new f; f < sizeof(PresentsPos); f++)
    {
        new rand2 = random(3);
		if(rand2 == 0)
		{
		    new radm = random(5);
			PresentsPU[f] = CreatePickup(19054+radm,3,PresentsPos[f][0],PresentsPos[f][1],PresentsPos[f][2],-1);
		}
    }*/
    DNIEntrence = CreatePickup(19134,1,1427.5763,-1473.2388,1721.4471,0);
    DNIExit = CreatePickup(19133,1,1419.3689,-1460.1182,1753.0470,0);
    PickUp1Training = CreatePickup(1239,1,96.6611,1920.4708,18.1450,-1);
    PickUp3rdTraining = CreatePickup(1239,14,144.3880,1915.6431,18.9205, -1);
    PickUp4thtraining = CreatePickup(1239,14,213.9137,1902.2101,17.6406,-1);
    PickUp6thTraining = CreatePickup(1239,1,224.6870,1872.3535,13.7344,-1);
    PickUpToUp = CreatePickup(19134,1,967.8533,2123.8877,488.8970,360); //-1
    PickUp8thTraining = CreatePickup(1239,1,932.1880,2130.6299,500.1382,-1);
    PickUp12thTraining = CreatePickup(1239,1,294.7120,2505.1260,16.4844,-1);
    PickUp13thTraining = CreatePickup(1239,3,317.3385,2504.4272,16.4844,-1);
    PickUp14thTraining = CreatePickup(1239,1,360.6137,2503.6260,16.4844,-1);
    PickUpLastTraining = CreatePickup(1239,3,405.1820,2473.9714,16.5062,-1);
    PickUpSurvivor = CreatePickup(1314,3,424.6116,2474.3247,16.5000,-1);
    PickUpZombie = CreatePickup(1313,3,387.8176,2469.0764,16.5436,-1);
    HelpPickupCraft = CreatePickup(1239,2,2770.5518,-2465.0811,13.6484);
    HelpPickupDNAmod = CreatePickup(1239,2,1438.8745,-1484.7557,1754.3047,-1);
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
	sgtSoap = FCNPC_Create("SGT_Soap");
	FCNPC_Spawn(sgtSoap,287,3000,-3000,100);
	Hunter = CreateVehicle(425,3000,-3000,100,-1,-1,-1,0);
	FCNPC_PutInVehicle(sgtSoap,Hunter,0);
	FCNPC_StartPlayingPlayback(sgtSoap,"mynpc");
	SetPlayerColor(sgtSoap,0x00FF0A30);
	
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
	CreateVehicle(470,382.7319900,-2051.6389200,7.9460000,22.0000000,43,255,-1); //Patriot
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
	CreateVehicle(495,2801.3701200,-1864.2860100,10.4390000,324.2450000,116,115,-1); //Sandking
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
	CreateVehicle(415,289.1730000,-1171.9379900,80.7590000,308.0000000,6,1,-1); //Cheetah
	CreateVehicle(451,291.5910000,-1174.7230200,80.6740000,312.7450000,126,61,-1); //Turismo
	CreateVehicle(434,304.8240100,-1161.0050000,81.0590000,311.9950000,6,6,-1); //Hotknife
	CreateVehicle(434,307.3250100,-1163.0129400,81.0750000,131.9950000,6,6,-1); //Hotknife
	CreateVehicle(444,330.8510100,-1157.7180200,80.9100000,132.0000000,32,53,-1); //Monster
	CreateVehicle(494,332.5270100,-1170.5749500,80.8840000,42.0000000,125,112,-1); //Hotring
	CreateVehicle(494,328.0790100,-1174.7230200,80.8840000,41.9950000,125,112,-1); //Hotring
	CreateVehicle(586,293.6260100,-1157.1169400,80.5070000,126.0000000,126,2,-1); //Wayfarer
	CreateVehicle(409,294.3340100,-1177.5179400,80.8390000,311.5000000,255,255,-1); //Stretch
	CreateVehicle(409,286.6950100,-1169.5100100,80.8390000,309.9990000,1,1,-1); //Stretch
	CreateVehicle(409,266.1069900,-1212.5000000,75.1370000,123.7500000,255,255,-1); //Stretch
	CreateVehicle(409,242.4520000,-1229.5100100,75.2920000,309.9990000,1,1,-1); //Stretch
	CreateVehicle(434,258.6659900,-1216.0360100,75.4620000,121.9950000,6,6,-1); //Hotknife
	CreateVehicle(434,246.3360000,-1224.7020300,75.4620000,306.4920000,6,6,-1); //Hotknife
	CreateVehicle(539,194.8650100,-1234.3409400,78.6970000,46.0000000,96,67,-1); //Vortex
	CreateVehicle(571,326.8569900,-1148.6169400,80.9260000,221.9950000,3,3,-1); //Kart
	CreateVehicle(571,268.7959900,-1202.7039800,74.6510000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,266.1130100,-1204.4410400,74.6630000,213.9970000,3,53,-1); //Kart
	CreateVehicle(571,328.3920000,-1147.2309600,80.9260000,221.9950000,3,53,-1); //Kart
	CreateVehicle(603,2800.4628900,-1087.8819600,30.7210000,0.0000000,108,6,-1); //Phoenix
	CreateVehicle(575,2865.1259800,-1376.4220000,10.8320000,0.0000000,19,96,-1); //Broadway
	CreateVehicle(445,2820.2251000,-1562.6619900,10.9170000,270.0000000,47,47,-1); //Admiral
	CreateVehicle(482,2797.8879400,-1553.1379400,11.1720000,268.2500000,52,52,-1); //Burrito
	CreateVehicle(483,2008.1879900,-1275.9019800,23.9160000,0.0000000,1,31,-1); //Camper
	CreateVehicle(589,1549.3740200,-2210.5869100,13.2720000,0.0000000,23,23,-1); //Club
	CreateVehicle(533,2659.9150400,-1817.8149400,9.1110000,278.5000000,98,1,-1); //Feltzer
	CreateVehicle(455,2714.0529800,-1941.8769500,13.9450000,24.0000000,-1,1,-1); //Flatbed
	CreateVehicle(587,2168.6210900,-2018.5129400,13.3570000,314.0000000,72,1,-1); //Euros
	//CreateVehicle(411,1835.3690200,-1863.5839800,14.0900000,64.0000000,3,1,-1); //Infernus

	LimitPlayerMarkerRadius(15000.0);
	CPID = -1;
	CPscleared = 0;
	RoundEnded = 0;
	new RandW = random(sizeof(RandWeather)); //new year
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
	if(fexist("Admin/Goddigged.txt"))
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
	if(fexist("Admin/ChangedMode.txt"))
	{
	    fremove("Admin/ChangedMode.txt");
	    new File:file = fopen("Admin/ChangedMode.txt",io_write);
	    fclose(file);
	}
	else
	{
        new File:file = fopen("Admin/ChangedMode.txt",io_write);
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
		TextDrawColor(XPRIGHT[i], 16777215); //stand:16777215 halloween:0xCD853FFF new year0xB22222FF
		TextDrawSetShadow(XPRIGHT[i], 0);
		TextDrawSetOutline(XPRIGHT[i], 0);
		TextDrawFont(XPRIGHT[i], 4);
		
		XPLEFT[i] = TextDrawCreate(305.355804, 424.099853, "LD_SPAC:white");
		TextDrawLetterSize(XPLEFT[i], 0.000000, 0.000000);
		TextDrawTextSize(XPLEFT[i], 0.0000000, 18.019538);
		TextDrawAlignment(XPLEFT[i], 1);
		TextDrawColor(XPLEFT[i], 16777215); //stand:16777215 halloween:0xCD853FFF new year 0xB22222FF
		TextDrawSetShadow(XPLEFT[i], 0);
		TextDrawSetOutline(XPLEFT[i], 0);
		TextDrawFont(XPLEFT[i], 4);

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
		
		PlayerHealth[i] = TextDrawCreate(577.687500, 65.974998, "100 HP");
		TextDrawLetterSize(PlayerHealth[i], 0.285000, 0.923333);
		TextDrawAlignment(PlayerHealth[i], 2);
		TextDrawColor(PlayerHealth[i], -1);
		TextDrawSetShadow(PlayerHealth[i], 0);
		TextDrawSetOutline(PlayerHealth[i], 1);
		TextDrawBackgroundColor(PlayerHealth[i], 51);
		TextDrawFont(PlayerHealth[i], 1);
		TextDrawSetProportional(PlayerHealth[i], 1);
		
		RagePlus[i] = TextDrawCreate(15.312500, 248.324783, "RAGE +");
		TextDrawLetterSize(RagePlus[i], 0.441565, 2.133753);
		TextDrawAlignment(RagePlus[i], 1);
		TextDrawColor(RagePlus[i], 0xFFE100FF);
		TextDrawSetShadow(RagePlus[i], 0);
		TextDrawSetOutline(RagePlus[i], 1);
		TextDrawBackgroundColor(RagePlus[i], 0xFF8000FF);
		TextDrawFont(RagePlus[i], 2);
		TextDrawSetProportional(RagePlus[i], 1);
		
		MatDNAPlus[i] = TextDrawCreate(15.625000, 264.248718, "MATERIALS +");
		TextDrawLetterSize(MatDNAPlus[i], 0.426502, 2.044507);
		TextDrawAlignment(MatDNAPlus[i], 1);
		TextDrawColor(MatDNAPlus[i], 0x0B9981FF);
		TextDrawSetShadow(MatDNAPlus[i], 0);
		TextDrawSetOutline(MatDNAPlus[i], 1);
		TextDrawBackgroundColor(MatDNAPlus[i], 0x575757FF);
		TextDrawFont(MatDNAPlus[i], 2);
		TextDrawSetProportional(MatDNAPlus[i], 1);

		GainXPTD[i] = TextDrawCreate(266.222320, 132.426788, "+10 XP");
		TextDrawLetterSize(GainXPTD[i], 0.862222, 0.614222);
		TextDrawAlignment(GainXPTD[i], 1);
		TextDrawColor(GainXPTD[i], -1); // new year:0xB22222FF stand :-1
		TextDrawSetShadow(GainXPTD[i], 0);
		TextDrawSetOutline(GainXPTD[i], 0);
		TextDrawBackgroundColor(GainXPTD[i], 255); //Stand: 255 Halloween: 0xCD853FFF
		TextDrawFont(GainXPTD[i], 1);
		TextDrawSetProportional(GainXPTD[i], 1);

        Stats[i] = TextDrawCreate(488.667083, 329.561523, "usebox");
		TextDrawTextSize(Stats[i], 630.022430, 1000.000000);
		TextDrawAlignment(Stats[i], 1);
		TextDrawColor(Stats[i], -1); //Stand: -1 Halloween: 0xCD853FFF New year 0xB22222FF
		TextDrawUseBox(Stats[i], true);
		TextDrawBoxColor(Stats[i], 169);
		TextDrawLetterSize(Stats[i], 0.2956600, 1.219123);
		TextDrawSetShadow(Stats[i], 1);
		TextDrawSetOutline(Stats[i], 1);
		TextDrawBackgroundColor(Stats[i], 51);
		TextDrawFont(Stats[i], 2);
		TextDrawSetProportional(Stats[i], 1);

		TipBox[i] = TextDrawCreate(498.500000, 145.916641, "1");
		TextDrawLetterSize(TipBox[i], 0.1956600, 1.318391);
		TextDrawTextSize(TipBox[i], 625.875000, 1000.000000);
		TextDrawAlignment(TipBox[i], 1);
		TextDrawColor(TipBox[i], -1);
		TextDrawUseBox(TipBox[i], true);
		TextDrawBoxColor(TipBox[i], 169);
		TextDrawSetShadow(TipBox[i], 1);
		TextDrawSetOutline(TipBox[i], 1);
		TextDrawBackgroundColor(Stats[i], 51);
		TextDrawFont(TipBox[i], 2);
		TextDrawSetProportional(Stats[i], 1);
		
		FuelTD[i] = TextDrawCreate(213.755554, 380.953887, "Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
		TextDrawLetterSize(FuelTD[i], 0.442887, 1.276443);
		TextDrawAlignment(FuelTD[i], 1);
		TextDrawColor(FuelTD[i], -1); //Stand: -1 Halloween: 0xCD853FFF new year: 0xB22222FF
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
		TextDrawColor(OilTD[i], -1); //Stand: -1 Halloween: 0xCD853FFF new year: 0xB22222FF
		TextDrawSetShadow(OilTD[i], 0);
		TextDrawSetOutline(OilTD[i], 1);
		TextDrawBackgroundColor(OilTD[i], 51);
		TextDrawFont(OilTD[i], 1);
		TextDrawSetProportional(OilTD[i], 1);

		XPStats[i] = TextDrawCreate(306.111041, 427.142944, "XP:_15052 / 55000");
		TextDrawLetterSize(XPStats[i], 0.432932, 1.129102);
		TextDrawAlignment(XPStats[i], 2);
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
		if((!IsPlatVehicle(i)) && (!IsDiamVehicle(i)) && (GetVehicleModel(i) != 411))
		{
  			new engine,lights,alarm,doors,bonnet,boot,objective;
    		GetVehicleParamsEx(i,engine,lights,alarm,doors,bonnet,boot,objective);
			new rand = random(3);
			if(rand == 0) VehicleWithoutKeys[i] = 1;
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
	print("EVERYTHING SUCCESSFULY LOADED");
	print("ENJOY...");
	print("=====================================");
	return 1;
}

public OnGameModeExit()
{
    RoundEnded = 0;
	for( new i = 0; i < 2048; i++ )
	{
	   if(i != INVALID_TEXT_DRAW) continue;
	   TextDrawHideForAll(Text: i);
	   TextDrawDestroy(Text: i);
	}
	KillTimer(InvadingTimer);
	DestroyObject(objectsupply1);
	DestroyObject(objectsupply2);
	DestroyDynamic3DTextLabel(SupplyLabel);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if(PInfo[playerid][Logged] == 0) return 1;
    if(PInfo[playerid][Spawned] == 1)
    {
	    if(Team[playerid] == ZOMBIE)
		{
		    Team[playerid] = ZOMBIE;
		    SetPlayerHealth(playerid,100);
		}
	  	if(Team[playerid] == HUMAN)
		{
		    Team[playerid] = HUMAN;
		    PInfo[playerid][JustInfected] = 0;
		    PInfo[playerid][Infected] = 0;
			PInfo[playerid][Dead] = 0;
			SetPlayerHealth(playerid,100);
		}
		SetSpawnInfo(playerid,1,GetPlayerSkin(playerid),0,0,0,0,0,0,0,0,0,0);
		SpawnPlayer(playerid);
 		//SetTimerEx("SpawnHim",500,false,"i",playerid);
 		return 1;
	}
	if(PInfo[playerid][SkipRequestClass] == 1)
	{
	    if(Team[playerid] == ZOMBIE)
		{
		    Team[playerid] = ZOMBIE;
		    SetPlayerHealth(playerid,100);
		}
	  	if(Team[playerid] == HUMAN)
		{
		    Team[playerid] = HUMAN;
		    PInfo[playerid][JustInfected] = 0;
		    PInfo[playerid][Infected] = 0;
			PInfo[playerid][Dead] = 0;
			SetPlayerHealth(playerid,100);
		}
	}
	else
	{
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
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    if(PInfo[playerid][Logged] == 0) return Kick(playerid);
    SetPlayerTeam(playerid,1);
	SetPlayerVirtualWorld(playerid,0);
    PInfo[playerid][IgnoreHim] = 0;
    KillTimer(PInfo[playerid][TeamChooseTimer]);
    PInfo[playerid][Spawned] = 1;
    PInfo[playerid][Dead] = 0;
    //halloween
    /*RemovePlayerAttachedObject(playerid,8);
    new robject = random(4);
    switch (robject)
    {
        case 0: SetPlayerAttachedObject(playerid,8,19320,2,0.1,0,0,90,90,0,0.6,0.6,0.6);
        case 1: SetPlayerAttachedObject(playerid,8,19527,1,-0.3,-0.25,0,0,90,0,0.5,0.35,0.5);
        case 2: SetPlayerAttachedObject(playerid,8,19528,2,0.12,0,0,0,0,0,0.9,0.9,0.9);
        case 3: SetPlayerAttachedObject(playerid,8,11704,2,0.07,0.1,0,0,90,180,0.35,0.35,0.35);
    }*/
    //halloween
    //SetPlayerAttachedObject(playerid,8, 19064, 2, 0.13, 0.0, 0.0, 0.0, 80.0, 80.0); //new year
    TextDrawHideForPlayer(playerid,SkinChange[playerid]);
    //SendClientMessage(playerid,white,"** "corange"You can turn on/off snow by command "cred"/turnsnow");
    TextDrawHideForPlayer(playerid,ZOMSURV[playerid]);
    TextDrawHideForPlayer(playerid,ArrLeft[playerid]);
    TextDrawHideForPlayer(playerid,ArrRight[playerid]);
    SetCameraBehindPlayer(playerid);
    KillTimer(PInfo[playerid][KillingMinute]);
	StopAudioStreamForPlayer(playerid);
	SetPlayerColor(playerid,(GetPlayerColor(playerid) & 0xFFFFFFFF));
	SetPlayerCP(playerid);
    new string2[96];
    format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
	TextDrawSetString(CPSCleared[playerid],string2);
	TextDrawShowForPlayer(playerid,CPSCleared[playerid]);
	new infects;
	foreach(new i: Player)
	{
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(IsPlayerNPC(i)) continue;
	    if(PInfo[i][Afk] == 1) continue;
	    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	new Allplayers;
	foreach(new i: Player)
	{
        if(PInfo[i][Jailed] == 0)
        {
            if(PInfo[i][Training] == 0)
            {
                if(PInfo[i][Afk] == 0)
                {
                	if(PInfo[i][ChooseAfterTr] == 0)
                	{
                    	if(!IsPlayerNPC(i))
      						Allplayers ++;
					}
				}
			}
		}
	}
	new string3[24];
	format(string3,sizeof string3,"Infection: ~r~~h~%i%%", floatround(100.0 * floatdiv(infects, Allplayers)));
	TextDrawSetString(Infection[playerid],string3);
	TextDrawShowForPlayer(playerid,Infection[playerid]);
    TextDrawHideForPlayer(playerid,OILANDFUELTD[playerid]);
	TextDrawHideForPlayer(playerid,FuelTD[playerid]);
	TextDrawHideForPlayer(playerid,OilTD[playerid]);
    PInfo[playerid][KillingMinute] = SetTimerEx("SetMinute",60000,true,"i",playerid);
    if(PInfo[playerid][Premium] > 0)
    {
    	EnableAntiCheatForPlayer(playerid,49,0);
	}
    new day,month,year;
	getdate(year,month,day);
	if(PInfo[playerid][NewRegExtraXP] == 1)
	{
	    if(gettime() >= PInfo[playerid][NewRegExtraXPTime])
	    {
        	SendClientMessage(playerid,white,"*** "cred"Your Double XP boost Pack has been expired!");
            PInfo[playerid][NewRegExtraXP] = 0;
		}
	}
    if(PInfo[playerid][Premium] > 0)
    {
    	if(gettime() > PInfo[playerid][PremiumRealTime])
    	{
        	PInfo[playerid][Premium] = 0;
        	SendClientMessage(playerid,white,"*** "cred"Your premium has been expired and your Premium member was automatically setted to none!");
		}
	}
    if(PInfo[playerid][ExtraXP] > 0)
    {
    	if(gettime() > PInfo[playerid][ExtraXPRealTime])
    	{
        	PInfo[playerid][ExtraXP] = 0;
        	SendClientMessage(playerid,white,"*** "cred"Your Extra Xp Pack has been expired and it was automatically disabled for you!");
		}
	}

	if(PInfo[playerid][Firstspawn] == 1)
	{
	    PInfo[playerid][Firstspawn] = 0;
    	//ShowPlayerDialog(playerid,190,DSM,""cred"New year "cwhite"event",""cwhite"New year event started!\nUnlock new year achievements\nFor completing all of them you can get"cgold" Gold "cwhite"Premium\nFor more info about achievements use "cred"/achievements\n\n"cgreen"GOOD LUCK AND HAPPY NEW YEAR!","Ok","");
//new year
	}
	if(Team[playerid] == HUMAN)
	{
		/*if((PInfo[playerid][AllowToSpawn] == 0) || (PInfo[playerid][Training] == 0))
		{
			if(PInfo[playerid][Infected] == 1)
   			{
				Team[playerid] = ZOMBIE;
				SpawnPlayer(playerid);
				SendClientMessage(playerid,white,"**"cred" Gamemode detected suicide: Your team was automatically setted to zombie!");
				return 1;
			}
		}*/
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
		if(PInfo[playerid][SkipRequestClass] == 1)
		{
		    SetPlayerSkin(playerid,PInfo[playerid][Skin]);
		}
		PInfo[playerid][SkipRequestClass] = 0;
	    //ResetPlayerInventory(playerid);
     	new rand = random(sizeof Randomspawns);
     	SetPlayerWeather(playerid,RWeather);
		SetCameraBehindPlayer(playerid);
		if(PInfo[playerid][Rank] < 5)
		{
		    SetPlayerSkillLevel(playerid,0,900);
		}
		else
            SetPlayerSkillLevel(playerid,0,1000);
		SetPlayerColor(playerid,green);
		if(PInfo[playerid][Premium] == 0)
  		{
  			if(PInfo[playerid][Spectating] == 1)
			{
				SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
				SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
				PInfo[playerid][Spectating] = 0;
			}
			else
			{
				SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
			}
		}
	    else if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
			new file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			if(INI_ReadInt("SSkin") != 0)
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
  			if(PInfo[playerid][Spectating] == 1)
			{
				SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
				SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
				PInfo[playerid][Spectating] = 0;
			}
  			else
			{
				SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
			}
	    }
	    else if(PInfo[playerid][Premium] == 2)
	    {
	        SetPlayerArmour(playerid,150);
		    new file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			if(INI_ReadInt("SSkin") != 0)
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
  			if(PInfo[playerid][Spectating] == 1)
			{
				SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
				SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
				PInfo[playerid][Spectating] = 0;
			}
			else
			{
				rand = random(sizeof Platspawns);
				SetPlayerPos(playerid,Platspawns[rand][0],Platspawns[rand][1],Platspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Platspawns[rand][3]);
			}
		}
	    else if(PInfo[playerid][Premium] == 3)
	    {
	        SetPlayerArmour(playerid,200);
		    new file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			if(INI_ReadInt("SSkin") != 0)
				SetPlayerSkin(playerid,INI_ReadInt("SSkin"));
			INI_Close();
			if(PInfo[playerid][Spectating] == 1)
			{
				SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
				SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
				PInfo[playerid][Spectating] = 0;
			}
			else
			{
				rand = random(sizeof Diamspawns);
				SetPlayerPos(playerid,Diamspawns[rand][0],Diamspawns[rand][1],Diamspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Diamspawns[rand][3]);
			}
		}
		TogglePlayerControllable(playerid, 1);
		
		if(RWeather == 55) SetPlayerTime(playerid,6,0);
		else SetPlayerTime(playerid,23,0);
	}
    if(Team[playerid] == ZOMBIE)
    {
        SetPlayerFacingAngle(playerid,86.4572);
        SetPlayerWeather(playerid,283);
        SetPlayerTime(playerid,23,0);
        if(PInfo[playerid][Premium] > 0)
        {
		    new file[80];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
			if(INI_ReadInt("ZSkin") != 0)
				SetPlayerSkin(playerid,INI_ReadInt("ZSkin"));
			INI_Close();
		}
		else if(PInfo[playerid][SkipRequestClass] == 1)
			SetPlayerSkin(playerid,PInfo[playerid][Skin]);
		PInfo[playerid][SkipRequestClass] = 0;
		if(PInfo[playerid][AfterLifeInfected] == 1)
		{
	        TeleportToLastPos(playerid);
	   		SetPlayerColor(playerid,purple);
		    SetPlayerArmour(playerid,0);
		    new Ahpe;
		    if(PInfo[playerid][Rank] < 5) Ahpe = 100;
		    if(PInfo[playerid][Rank] >= 5 && PInfo[playerid][Rank] < 10) Ahpe = 120;
		    if(PInfo[playerid][Rank] >= 10 && PInfo[playerid][Rank] < 15) Ahpe = 135;
		    if(PInfo[playerid][Rank] >= 15 && PInfo[playerid][Rank] < 20) Ahpe = 150;
		    if(PInfo[playerid][Rank] >= 20 && PInfo[playerid][Rank] < 25) Ahpe = 160;
		    if(PInfo[playerid][Rank] >= 25) Ahpe = 175;
		    SetPlayerHealth(playerid,Ahpe);
		    PInfo[playerid][AfterLifeInfected] = 0;
	        new RandomGS = random(sizeof(gRandomSkin));
	        SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
	        PInfo[playerid][Skin] = gRandomSkin[RandomGS];
	        PInfo[playerid][Dead] = 0;
	        SetPlayerWeather(playerid,283);
	        SetPlayerTime(playerid,23,0);
	        ResetPlayerWeapons(playerid);
		}
		else
		{
			if(PInfo[playerid][Spectating] == 1)
			{
				SetPlayerPos(playerid,PInfo[playerid][sX],PInfo[playerid][sY],PInfo[playerid][sZ]);
				SetPlayerHealth(playerid,PInfo[playerid][BefHP]);
				PInfo[playerid][Spectating] = 0;
			}
			else if(PInfo[playerid][Hiden] == 1)
			{
				new Float:vx,Float:vy,Float:vz;
				GetVehiclePos(PInfo[playerid][HideInVehicle],vx,vy,vz);
				SetPlayerPos(playerid,vx,vy,vz+5);
			}
			else if (CanSpawn == 0)
	        {
	            new rand = random(sizeof Randomspawns);
      			SetPlayerPos(playerid,Randomspawns[rand][0],Randomspawns[rand][1],Randomspawns[rand][2]);
				SetPlayerFacingAngle(playerid,Randomspawns[rand][3]);
			}
			else if(PInfo[playerid][AfterLifeInfected] == 0 && CanSpawn == 1 && PInfo[playerid][Spectating] == 0)
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
	       		TogglePlayerControllable(playerid, 0);
				SetTimerEx("UnFreezePlayer", 1700, false, "i", playerid);
			}
		}
	    SetPlayerColor(playerid,purple);
	    SetPlayerArmour(playerid,0);
	    new Ahpe;
	    if(PInfo[playerid][Rank] < 5) Ahpe = 100;
	    if(PInfo[playerid][Rank] >= 5 && PInfo[playerid][Rank] < 10) Ahpe = 120;
	    if(PInfo[playerid][Rank] >= 10 && PInfo[playerid][Rank] < 15) Ahpe = 135;
	    if(PInfo[playerid][Rank] >= 15 && PInfo[playerid][Rank] < 20) Ahpe = 150;
	    if(PInfo[playerid][Rank] >= 20 && PInfo[playerid][Rank] < 25) Ahpe = 160;
	    if(PInfo[playerid][Rank] >= 25) Ahpe = 175;
	    SetPlayerHealth(playerid,Ahpe);
    }
	if(Team[playerid] == ZOMBIE)
	{
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
	}
    if(PInfo[playerid][Jailed] == 1)
	{
		Jail(playerid);
		new string[90];
		format(string,sizeof string,"~r~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[playerid][JailTimer]);
 		SendClientMessage(playerid,white,"* "cred"Type "corange"/timeleft"cred" to check how much jail time left");
		if(PInfo[playerid][Spawned] == 0)
		{
		    PlayersConnected --;
		}
        GameTextForPlayer(playerid,string, 6500,3);
	}
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(PInfo[playerid][Snowon] == 1)
	{
	    PInfo[playerid][SnowObjects1] = CreatePlayerObject(playerid,18864,x,y,z-15,0,45,90,200);
	    PInfo[playerid][SnowObjects2] = CreatePlayerObject(playerid,18864,x,y,z-10,0,45,180,200);
	    PInfo[playerid][SnowObjects3] = CreatePlayerObject(playerid,18864,x,y,z,0,45,360,200);
	    PInfo[playerid][SnowObjects4] = CreatePlayerObject(playerid,18864,x,y,z,0,45,0,200);
	}
	EnableAntiCheatForPlayer(playerid,27,1);
    if(PInfo[playerid][Training] == 1)
    {
        SetPlayerVirtualWorld(playerid,playerid+16);
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
       		TogglePlayerControllable(playerid, 0);
			SetTimerEx("UnFreezePlayer", 1700, false, "i", playerid);
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
            strcat(strang,"\n"cpurple"Zombies"cwhite" must infect all humans to win round \nYou can check how much players are infected, look at \"Infection\" under \"Cleared Checkpoints\"");
			strcat(strang,"\n"cpurple"Zombies "cwhite"dont have inventory instead they have special "corange"Rage Mode"cwhite". In order to fill your rage meter, you need to get killed by a human");
			strcat(strang,"\nYou are in Hive, you will be spawned here after death, you can teleport to other places in the city and also heal yourself by eating Brains (white arrows)");
			strcat(strang,"\nYou can teleport to hive through pipes and can be seen on radar (they have marker \"T\"), also you can teleport to places");
			strcat(strang,"\nObviously zombies don't have any weapons\nSo what to do?");
			strcat(strang,"\nZombies have bite system (we will talk about that later)\nWhen you play as a zombie, other zombies are your friends and rule of teamkilling is same as for humans\nNow go to any pipe and stand in white pointer to continue course");
			ShowPlayerDialog(playerid,14777,DSM,"Info",strang,"OK","");
			PInfo[playerid][TrainingPhase] = 10;
			SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Go to any pickup in the Hive, these pickups are in pipes");
			Team[playerid] = ZOMBIE;
	        new RandomGS = random(sizeof(gRandomSkin));
	        SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
			DisablePlayerCheckpoint(playerid);
		    return 1;
		}
		DestroyPlayerObject(playerid,Player1stGate);
		DestroyPlayerObject(playerid,Player2ndGate);
		DestroyPlayerObject(playerid,GateZombie1);
		DestroyPlayerObject(playerid,GateZombie2);
		DestroyVehicle(Vehicles[playerid][0]);
		DestroyVehicle(Vehicles[playerid][1]);
		DestroyVehicle(Vehicles[playerid][2]);
		DestroyVehicle(Vehicles[playerid][3]);
		Player1stGate = CreatePlayerObject(playerid,980,214.7910000,1875.6939700,13.1130000,0.0000000,0.0000000,357.9950000); //thisisgateforplayer2
		Player2ndGate = CreatePlayerObject(playerid,980,140.8380000,1915.0629900,20.8630000,0.0000000,0.0000000,88.0000000); //thisisgaterr
	}
	PInfo[playerid][Skin] = GetPlayerSkin(playerid);
	EnableAntiCheatForPlayer(playerid,15,0);
	SetTimerEx("CheckRankUp",1000,false,"i",playerid);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
 	if(PInfo[playerid][Logged] == 0) return 0;
 	if(Team[playerid] != HUMAN && Team[playerid] != ZOMBIE) return 0;
 	if(PInfo[playerid][Spawned] == 1) return SpawnPlayer(playerid);
  	TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason)
{
	EnableAntiCheatForPlayer(playerid,15,0);
	PInfo[playerid][Dead] = 1;
	//SetTimerEx("CheckDead",4500,false,"i",playerid);
    SetTimerEx("EnableWAC",1000,false,"i",playerid);
    if(reason != 255)
    {
		foreach(new i: Player)
		{
	    	if(PInfo[i][Level] >= 1)
				SendDeathMessageToPlayer(i,killerid, playerid, reason);
		}
	}
	if((Team[playerid] == HUMAN))
	{
	    if(reason != 255)
	    {
			if(PInfo[playerid][Infected] == 1)
			{
			    PInfo[playerid][AfterLifeInfected] = 1;
				InfectPlayer(playerid);
				GivePlayerAssistXP(playerid);
				PInfo[playerid][Deaths] ++;
			}
		}
    }
    if(Team[playerid] == ZOMBIE)
    {
        if(PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot2] == 8 || PInfo[playerid][ModeSlot3] == 8)
        {
			if(PInfo[playerid][CanDig] == 1)
			{
			    PInfo[playerid][CanResusDig] = 1;
			    GetPlayerPos(playerid,PInfo[playerid][ResusX],PInfo[playerid][ResusY],PInfo[playerid][ResusZ]);
			    SendClientMessage(playerid,white,"* "cjam"You can dig to your last death position, you must be close to your last postion atleast 100 meters to dig");
			}
        }
    }
    if(PInfo[playerid][InSearch] == 1)
    {
        PInfo[playerid][InSearch] = 0;
        SendClientMessage(playerid,white,"* *"cred"You destroyed the tracker!");
    }
	PInfo[playerid][Dead] = 1;
    PInfo[playerid][DeathsRound]++;
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
        new string[90];
 		format(string,sizeof string,""cjam"%s dropped his Flashlight.",GetPName(playerid));
 		KillTimer(FlashLightTimer[playerid]);
		SendNearMessage(playerid,white,string,30);
	}
 	TextDrawHideForPlayer(playerid,OILANDFUELTD[playerid]);
	TextDrawHideForPlayer(playerid,FuelTD[playerid]);
	TextDrawHideForPlayer(playerid,OilTD[playerid]);
    TextDrawHideForPlayer(playerid,CPvaluebar[playerid]);
    TextDrawHideForPlayer(playerid,CPvaluepercent[playerid]);
    PInfo[playerid][Skin] = GetPlayerSkin(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid,reason)
{
	if(!IsPlayerNPC(playerid))
	{
		if(PInfo[playerid][DeletedAcc] == 0)
		{
			if(PInfo[playerid][Logged] == 1) SaveStats(playerid);
		}
		new string[70];
		switch(reason)
	    {
	        case 0: format(string,sizeof string,"? "cred"%s left the server. (Crash)",GetPName(playerid));
	        case 1: format(string,sizeof string,"? "cred"%s left the server. (Disconnected)",GetPName(playerid));
	        case 2: format(string,sizeof string,"? "cred"%s left the server. (Kick/Ban)",GetPName(playerid));
	    }
	    SendAdminMessage(white,string);
	    if(PInfo[playerid][Level] < 1)
		{
			format(string,sizeof string,"? "cred"%s's IP: "cwhite"%s",GetPName(playerid),PInfo[playerid][IPAdress]);
	    	SendAdminMessage(white,string);
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
	    if(PInfo[playerid][GroupIN] > 0)
	    {
		    if(PInfo[playerid][GroupLeader] == 1)
		    {
		        new strang[100];
		        foreach(new i: Player)
		        {
		            if(PInfo[i][Logged] == 0) continue;
		            if(i == playerid) continue;
		            if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		            {
	                    format(strang,sizeof strang,"* "cred"%s has left your group, |%i|%s become new leader of group!",GetPName(playerid),i,GetPName(i));
	                    PInfo[i][GroupLeader] = 1;
	                    PInfo[i][GroupName] = PInfo[playerid][GroupName];
	                    PInfo[i][GroupPlayers] = PInfo[playerid][GroupPlayers]-1;
	                    break;
					}
				}
		        foreach(new i: Player)
		        {
		            if(PInfo[i][Logged] == 0) continue;
		            if(i == playerid) continue;
		            if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		            {
		                SendClientMessage(playerid,white,strang);
					}
				}
			}
			else if(PInfo[playerid][GroupLeader] == 0)
			{
			    new strong[64];
			    foreach(new i: Player)
			    {
			        if(PInfo[i][Logged] == 0) continue;
			        if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
			        {
			            format(strong,sizeof strong,"* "cred"%s has left group!",GetPName(playerid));
			            SendClientMessage(i,white,strong);
			        	if(PInfo[i][GroupLeader] == 1)
			        	{
			                PInfo[i][GroupPlayers] --;
			        	}
					}
			    }
			}
		}
		DestroyObject(PInfo[playerid][MeatSObject]);
		DestroyDynamic3DTextLabel(PInfo[playerid][LabelMeatForShare]);
	    DestroyObject(PInfo[playerid][Flag1]);
	    DestroyObject(PInfo[playerid][Flag2]);
	    if(PInfo[playerid][Jailed] == 0) PlayersConnected--;
	    DestroyObject(PInfo[playerid][FireObject]);
	    DestroyObject(PInfo[playerid][BettyObj1]);
	    DestroyObject(PInfo[playerid][BettyObj2]);
	    DestroyObject(PInfo[playerid][BettyObj3]);
    	DestroyDynamic3DTextLabel(PInfo[playerid][Ranklabel]);
		KillTimer(LoginTimer[playerid]);
	    RemovePlayerMapIcon(playerid,0);
	    DestroyDynamicMapIcon(PInfo[playerid][BeaconMarker]);
		DestroyObject(PInfo[playerid][Flare]);
		DestroyObject(PInfo[playerid][Vomit]);
		DestroyPlayerObject(playerid,Player2ndGate);
		DestroyPlayerObject(playerid,Player1stGate);
		DestroyPlayerObject(playerid,GateZombie1);
		DestroyPlayerObject(playerid,GateZombie2);
		KillTimer(FlashLightTimer[playerid]);
		KillTimer(PInfo[playerid][KillingMinute]);
		KillTimer(PInfo[playerid][CheckMuteTimer]);
		KillTimer(PInfo[playerid][ResotoreHiveHP]);
		RemovePlayerAttachedObject(playerid,4);
		KillTimer(PInfo[playerid][StompTimer]);
		KillTimer(PInfo[playerid][PowerfulGlovesTimer]);
		KillTimer(PInfo[playerid][CanZombieBaitTimer]);
		KillTimer(PInfo[playerid][RunTimer]);
		KillTimer(PInfo[playerid][DigTimer]);
		DestroyObject(PInfo[playerid][ZObject]);
		KillTimer(PInfo[playerid][DestroyRadar]);
		KillTimer(PInfo[playerid][VomitDamager]);
		KillTimer(PInfo[playerid][TeamChooseTimer]);
	    KillTimer(PInfo[playerid][CheckMine]);
	    DestroyObject(PInfo[playerid][MineObject]);
		KillTimer(PInfo[playerid][ToxinTimer]);
		KillTimer(PInfo[playerid][UpdateStatsTimer]);
		KillTimer(PInfo[playerid][FlagsHPTimer]);
	    if(CPID != -1) DisablePlayerCheckpoint(playerid);
	    if(PInfo[playerid][CanBurst] == 0) PInfo[playerid][CanBurst] = 1, KillTimer(PInfo[playerid][ClearBurst]);
	 	new Float:x,Float:y,Float:z;
	 	if(Team[playerid] == HUMAN)
	 	{
			if(PInfo[playerid][Infected] == 1)
			{
		    	GetPlayerPos(playerid,x,y,z);
				foreach(new i: Player)
				{
				    if(PInfo[i][Logged] == 0) continue;
			    	if(Team[i] == ZOMBIE)
			    	{
			    	    if(IsPlayerInRangeOfPoint(i,15,x,y,z))
			    	    {
			    	        Team[playerid] = ZOMBIE;
			    	        new strang[170];
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
		if(PInfo[playerid][Logged] == 1)
		{
	 		if(RoundEnded == 0)
	 		{
	 	    	if(PInfo[playerid][Training] == 0)
	 	    	{
					INI_Open("Admin/Teams.txt");
					INI_WriteInt(GetPName(playerid),Team[playerid]);
					INI_Save();
					INI_Close();
				}
	 		}
		}
	 	INI_Open("Admin/Goddigged.txt");
	 	if(PInfo[playerid][GodDig] == 1)
	 	{
	 	    INI_WriteInt(GetPName(playerid),PInfo[playerid][GodDig]);
		}
		INI_Save();
		INI_Close();
		INI_Open("Admin/ChangedMode.txt");
		if(PInfo[playerid][AlreadyChangeMod] > 0)
	 	{
	 	    INI_WriteInt(GetPName(playerid),PInfo[playerid][AlreadyChangeMod]);
		}
		INI_Save();
		INI_Close();
		PInfo[playerid][Logged] = 0;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    new string[64];
    format(string,sizeof string,"? "cred"%s(%i) joined server",GetPName(playerid),playerid);
    SendAdminMessage(white,string);
	RemoveBuildingForPlayer(playerid, 729, 379.1250, -1475.3281, 31.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 4516, -141.3359, 468.6484, 12.9141, 0.25);
    ResetPlayerInventory(playerid);
    SetPlayerTeam(playerid, 1);
	PInfo[playerid][CheckMuteTimer] = SetTimerEx("Muting",1000,true,"i",playerid);
    for(new s; s < 100; s++)
    {
        SendClientMessage(playerid,white,"");
        if(s == 99)
        {
            SendClientMessage(playerid,white,"========"cred"Ultimate-"cwhite"Gaming "cred"Presents..."cwhite"========");
			SendClientMessage(playerid,white,"    "cgreen"LOS SANTOS "cpurple"ZOMBIE "dred"APOCALYPSE");
			SendClientMessage(playerid,white,"======================================");
        }
    }
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
    SetPlayerMapIcon(playerid,16,2782.2786,-2474.1709,13.6350,23,0,MAPICON_GLOBAL);
    if(SupplyDirect > -1)
    {
		if((SupplyDestroyed == 0) && (SupplyInvaded == 0))
		{
		 	switch(SupplyDirect)
			{
			    case 0:
			    {
					foreach(new i: Player)
		            {
						SetPlayerMapIcon(i,77,1986.0311,-2381.5178,13.5469,18,0,MAPICON_GLOBAL);
					}
				}
			    case 1:
			    {
		            foreach(new i: Player)
		            {
						SetPlayerMapIcon(i,77,839.1480,-1369.9624,22.5321,18,0,MAPICON_GLOBAL);
					}
				}
			    case 2:
			    {
		            foreach(new i: Player)
		            {
						SetPlayerMapIcon(i,77,2518.4868,-1563.7096,22.8676,18,0,MAPICON_GLOBAL);
					}
				}
			    case 3:
			    {
		            foreach(new i: Player)
		            {
						SetPlayerMapIcon(i,77,2022.0211,-1851.5437,3.9844,18,0,MAPICON_GLOBAL);
					}
				}
			    case 4:
			    {
		            foreach(new i: Player)
		            {
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
		return 1;
	}
	SetTimerEx("CheckRegistration",500,false,"i",playerid);
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
	PInfo[playerid][TradeID] = -1;
	PInfo[playerid][DontExplode] = 0;
	new ips[32];
	format(ips, sizeof ips,"%s",GetHisIP(playerid));
	PInfo[playerid][IPAdress] = ips;
	PInfo[playerid][JasonsHP] = 10;
	PInfo[playerid][CanGiveDizzy] = 1;
	PInfo[playerid][HighPingWarn] = 0;
	PInfo[playerid][ZombieFighting] = 0;
	PInfo[playerid][Firstspawn] = 1;
	PInfo[playerid][Snowon] = 1;
	PInfo[playerid][Resueded] = 0;
	PInfo[playerid][SecretAdmin] = 0;
	DestroyObject(PInfo[playerid][ResuedObj]);
	DestroyDynamic3DTextLabel(PInfo[playerid][ResuedLabel]);
	PInfo[playerid][CanUsePickLock] = 1;
	PInfo[playerid][Flashed] = 0;
	PInfo[playerid][CheckEnter] = 0;
	PInfo[playerid][CanResusDig] = 0;
	PInfo[playerid][AlreadyWasInCar] = 0;
	PInfo[playerid][Resuedsstrength] = 0;
	PInfo[playerid][TokeDizzy] = 0;
	PInfo[playerid][TokeBlind] = 0;
	PInfo[playerid][Grenadeproj] = -1;
	PInfo[playerid][FlashBangObjectProj] = -1;
	PInfo[playerid][ObjectProj] = -1;
	PInfo[playerid][DNIPoints] = 0;
	ProjectileType[playerid][0] = 0;
	ProjectileType[playerid][1] = 0;
	ProjectileType[playerid][2] = 0;
	PInfo[playerid][Materials] = 0;
	PInfo[playerid][IgnoreHim] = 0;
	PInfo[playerid][AchievementKills] = 0;
	PInfo[playerid][AchievementInfect] = 0;
	PInfo[playerid][Achievement50Hours] = 0;
	PInfo[playerid][AchievementCollect20] = 0;
	PInfo[playerid][AchievementAllGiven] = 0;
	PInfo[playerid][CanBeStingBull] = 1;
	PInfo[playerid][Afk] = 0;
	PInfo[playerid][CheckFill] = 0;
	PInfo[playerid][CountHP] = 0;
	PInfo[playerid][CanBeStomped] = 1;
	PInfo[playerid][NewRegExtraXP] = 0;
	PInfo[playerid][NewRegExtraXPTime] = 0;
	PInfo[playerid][CanGoAFK] = 1;
	PInfo[playerid][ChoseMap] = 0;
 	PInfo[playerid][ZombieBait] = 0;
 	PInfo[playerid][VotedYes] = 0;
 	PInfo[playerid][SMeatBite] = 0;
 	PInfo[playerid][JustRegistered] = 0;
 	PInfo[playerid][Poisoned] = 0;
 	PInfo[playerid][CanKick] = 1;
 	PInfo[playerid][AlreadyChangeMod] = 0;
 	PInfo[playerid][CanHide] = 1;
 	PInfo[playerid][InSearch] = 0;
 	PInfo[playerid][StingerBulletsInUse] = 0;
    PInfo[playerid][ImpactBulletsInUse] = 0;
    PInfo[playerid][BeaconBulletsInUse] = 0;
 	PInfo[playerid][SeismicPhase] = 1;
 	PInfo[playerid][WhatThrow] = 0;
 	PInfo[playerid][CanGrenadeAgain] = 1;
 	PInfo[playerid][DeletedAcc] = 0;
 	PInfo[playerid][GotStabilizer] = 0;
    PInfo[playerid][GotInsameRage] = 0;
    PInfo[playerid][GotHealingRage] = 0;
    PInfo[playerid][GotMoreRage] = 0;
    PInfo[playerid][GotImperception] = 0;
    PInfo[playerid][GotAccurateDigger] = 0;
    PInfo[playerid][GotDizzyTrap] = 0;
    PInfo[playerid][GotEdibleResidues] = 0;
    PInfo[playerid][GotResuscitation] = 0;
    PInfo[playerid][GotCrowdedStomach] = 0;
    PInfo[playerid][GotRegeneration] = 0;
    PInfo[playerid][GotCollector] = 0;
 	PInfo[playerid][ACWarning] = 0;
 	PInfo[playerid][Throwingstate] = 1;
 	PInfo[playerid][WarningAmmo] = 0;
 	PInfo[playerid][EnabledAC] = 1;
 	PInfo[playerid][Waswarnedbh] = 0;
 	PInfo[playerid][FoundBullets] = 0;
 	PInfo[playerid][CanUseSeismicShock] = 1;
 	PInfo[playerid][CanBiteVomit] = 1;
 	PInfo[playerid][ModeSlot1] = 0;
 	PInfo[playerid][ModeSlot2] = 0;
 	PInfo[playerid][ModeSlot3] = 0;
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
    PInfo[playerid][CraftingTable] = 0;
    PInfo[playerid][Antiblindpills] = 0;
    PInfo[playerid][Nitro] = 0;
    PInfo[playerid][StingerBullets] = 0;
    PInfo[playerid][BeaconBullets] = 0;
    PInfo[playerid][ImpactBullets] = 0;
    PInfo[playerid][Mines] = 0;
    PInfo[playerid][CanBeBlinded] = 1;
    PInfo[playerid][Allowedtovomit] = VOMITTIME;
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
    Mission[playerid] = 0;
    MissionPlace[playerid][0] = 0;
    MissionPlace[playerid][1] = 0;
    IsMessageSent[playerid] = 0;
    Team[playerid] = 0;
    RemovePlayerMapIcon(playerid,1);
	new Float:health;
	GetPlayerHealth(playerid,health);
	format(PInfo[playerid][RankLabelText],128,""cyellow"%s"cgreen"\nRank: %i | XP: %i/%i\n"cgrey"HEALTH: "cred"%d",PInfo[playerid][ClanName],PInfo[playerid][Rank],PInfo[playerid][XP],PInfo[playerid][XPToRankUp],floatround(health,floatround_round));
	PInfo[playerid][Ranklabel] = CreateDynamic3DTextLabel(PInfo[playerid][RankLabelText],0x008080AA,0,0,0.7,15,playerid,INVALID_VEHICLE_ID,1);
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
			SendClientMessage(playerid,white,"** "cred"In previous session you left server while you were fighting, IT IS NOT ALLOWED!!!");
			SendClientMessage(playerid,white,"** "cred"Your team was automatically setted to zombie, if you continue evade figthing, you will be punished!");
            INI_WriteInt(GetPName(playerid),0);
		}
    }
    INI_Close();
	INI_Open("Admin/Goddigged.txt");
    if(INI_ReadInt(GetPName(playerid)) == 1)
    {
        PInfo[playerid][GodDig] = 1;
    }
    INI_Close();
	INI_Open("Admin/ChangedMode.txt");
    if(INI_ReadInt(GetPName(playerid)) == 1)
    {
         PInfo[playerid][AlreadyChangeMod] = INI_ReadInt(GetPName(playerid));
    }
    INI_Close();
    SetTimerEx("Radar", 750, true, "i", playerid);
    LoginTimer[playerid] = SetTimerEx("TimerLogin",120000,false,"i",playerid);
	SetPlayerWeather(playerid,5123524);
	SetPlayerTime(playerid,23,0);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    if(PInfo[playerid][Spawned] == 0) return 1;
    if(PInfo[playerid][Dead] == 1) return 1;
	if(PInfo[playerid][Firsttimeincp] == 1)
    {
        if(Team[playerid] == ZOMBIE) return 1;
        if(PInfo[playerid][Training] == 1)
        {
            Team[playerid] = ZOMBIE;
            PInfo[playerid][TrainingPhase] = 9;
            SpawnPlayer(playerid);
            return 1;
        }
        PInfo[playerid][EvoidingCP] = 0;
        KillTimer(PInfo[playerid][EvoidingCPTimer]);
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
        foreach(new i: Player)
        {
            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
            SendFMessage(i,white,"* "cjam"%s has been given more ammo and some medical attention from the military.",GetPName(playerid));
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
			SendClientMessage(playerid,white,"? "cblue"You've got 3 flame bullets (Flame Rounds)");
		}
		if(PInfo[playerid][SPerk] == 23)
		{
			AddItem(playerid,"Radar",1);
			SendClientMessage(playerid,white,"? "cblue"You've got a special radar from the military");
		}
		if(PInfo[playerid][SPerk] == 29)
		{
		    PInfo[playerid][AssaultGrenades] ++;
		    SendClientMessage(playerid,white,"? "cblue"You've got a assault grenade from military");
		}
		if(PInfo[playerid][SPerk] == 25)
		{
		    GetPlayerPos(playerid,x,y,z);
		    foreach(new i: Player)
		    {
		        if(PInfo[i][Logged] == 0) continue;
		        PlayerPlaySound(i,17003,x,y,z);
		        if(IsPlayerInRangeOfPoint(i,25,x,y,z))
		        {
			    	GetPlayerPos(i,x,y,z);
			    	if(Team[i] == ZOMBIE)
			    	{
                        TogglePlayerControllable(i, 0);
                        SetTimerEx("UnFreezePlayer", 2000, false, "i", i);
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
		if(PInfo[playerid][SPerk] == 7)
		{
		    SendClientMessage(playerid,white,"? "cblue"You've got extra ammo from military");
			if(PInfo[playerid][Premium] == 0)
			{
				if(weapons[2][0] == 22) GivePlayerWeapon(playerid,22,51*2);
				if(weapons[2][0] == 23) GivePlayerWeapon(playerid,23,51*2);
				if(weapons[2][0] == 24) GivePlayerWeapon(playerid,24,28*2);
				if(weapons[3][0] == 25) GivePlayerWeapon(playerid,25,30*2);
				if(weapons[3][0] == 26) GivePlayerWeapon(playerid,26,24*2);
				if(weapons[3][0] == 27) GivePlayerWeapon(playerid,27,35*2);
				if(weapons[4][0] == 28) GivePlayerWeapon(playerid,28,125*2);
				if(weapons[4][0] == 29) GivePlayerWeapon(playerid,29,60*2);
				if(weapons[5][0] == 30) GivePlayerWeapon(playerid,30,60*2);
				if(weapons[5][0] == 31) GivePlayerWeapon(playerid,31,75*2);
				if(weapons[4][0] == 32) GivePlayerWeapon(playerid,32,150*2);
				if(weapons[6][0] == 33) GivePlayerWeapon(playerid,33,25*2);
				if(weapons[6][0] == 34) GivePlayerWeapon(playerid,34,30*2);
			}
			else if(PInfo[playerid][Premium] >= 2)
			{
				if(weapons[2][0] == 22) GivePlayerWeapon(playerid,22,78*2);
				if(weapons[2][0] == 23) GivePlayerWeapon(playerid,23,78*2);
				if(weapons[2][0] == 24) GivePlayerWeapon(playerid,24,42*2);
				if(weapons[3][0] == 25) GivePlayerWeapon(playerid,25,40*2);
				if(weapons[3][0] == 26) GivePlayerWeapon(playerid,26,32*2);
				if(weapons[3][0] == 27) GivePlayerWeapon(playerid,27,42*2);
				if(weapons[4][0] == 28) GivePlayerWeapon(playerid,28,150*2);
				if(weapons[4][0] == 29) GivePlayerWeapon(playerid,29,90*2);
				if(weapons[5][0] == 30) GivePlayerWeapon(playerid,30,90*2);
				if(weapons[5][0] == 31) GivePlayerWeapon(playerid,31,120*2);
				if(weapons[4][0] == 32) GivePlayerWeapon(playerid,32,175*2);
				if(weapons[6][0] == 33) GivePlayerWeapon(playerid,33,35*2);
				if(weapons[6][0] == 34) GivePlayerWeapon(playerid,34,40*2);
			}
		}
		else
		{
			if(PInfo[playerid][Premium] == 0)
			{
				if(weapons[2][0] == 22) GivePlayerWeapon(playerid,22,51);
				if(weapons[2][0] == 23) GivePlayerWeapon(playerid,23,51);
				if(weapons[2][0] == 24) GivePlayerWeapon(playerid,24,28);
				if(weapons[3][0] == 25) GivePlayerWeapon(playerid,25,30);
				if(weapons[3][0] == 26) GivePlayerWeapon(playerid,26,24);
				if(weapons[3][0] == 27) GivePlayerWeapon(playerid,27,35);
				if(weapons[4][0] == 28) GivePlayerWeapon(playerid,28,125);
				if(weapons[4][0] == 29) GivePlayerWeapon(playerid,29,60);
				if(weapons[5][0] == 30) GivePlayerWeapon(playerid,30,60);
				if(weapons[5][0] == 31) GivePlayerWeapon(playerid,31,75);
				if(weapons[4][0] == 32) GivePlayerWeapon(playerid,32,150);
				if(weapons[6][0] == 33) GivePlayerWeapon(playerid,33,25);
				if(weapons[6][0] == 34) GivePlayerWeapon(playerid,34,30);
			}
			else if(PInfo[playerid][Premium] >= 2)
			{
				if(weapons[2][0] == 22) GivePlayerWeapon(playerid,22,78);
				if(weapons[2][0] == 23) GivePlayerWeapon(playerid,23,78);
				if(weapons[2][0] == 24) GivePlayerWeapon(playerid,24,42);
				if(weapons[3][0] == 25) GivePlayerWeapon(playerid,25,40);
				if(weapons[3][0] == 26) GivePlayerWeapon(playerid,26,32);
				if(weapons[3][0] == 27) GivePlayerWeapon(playerid,27,42);
				if(weapons[4][0] == 28) GivePlayerWeapon(playerid,28,150);
				if(weapons[4][0] == 29) GivePlayerWeapon(playerid,29,90);
				if(weapons[5][0] == 30) GivePlayerWeapon(playerid,30,90);
				if(weapons[5][0] == 31) GivePlayerWeapon(playerid,31,120);
				if(weapons[4][0] == 32) GivePlayerWeapon(playerid,32,175);
				if(weapons[6][0] == 33) GivePlayerWeapon(playerid,33,35);
				if(weapons[6][0] == 34) GivePlayerWeapon(playerid,34,40);
			}
		}
		if(IsPlayerInAnyVehicle(playerid))
		    SetTimerEx("SetWeapon",400,false,"i",playerid);
        if(PInfo[playerid][Premium] == 2)
	    {
	        SetPlayerArmour(playerid,150);
	        foreach(new i: Player)
	        {
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"* "cjam"%s has been given an new durable Kevlar vest from the military",GetPName(playerid));
	        }
     	}
     	if(PInfo[playerid][Premium] == 1)
	    {
	        SetPlayerArmour(playerid,100);
	        foreach(new i: Player)
	        {
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"* "cjam"%s has been given a fresh Kevlar vest from the military.",GetPName(playerid));
	        }
     	}
        if(PInfo[playerid][Premium] == 3)
	    {
	        SetPlayerArmour(playerid,200);
	        foreach(new i: Player)
	        {
	            if(!IsPlayerInRangeOfPoint(i,25.0,x,y,z)) continue;
	            SendFMessage(i,white,"* "cjam"%s has been given an Diamond Kevlar vest from the military",GetPName(playerid));
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
    	SendClientMessage(playerid,white,""cwhite"* "cblue"WARNING: You left from Checkpoint!");
	}
    TextDrawHideForPlayer(playerid,CPbar[playerid]);
    TextDrawHideForPlayer(playerid,CPbartext[playerid]);
    TextDrawHideForPlayer(playerid,CPvaluebar[playerid]);
    TextDrawHideForPlayer(playerid,CPvaluepercent[playerid]);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if(damagedid == INVALID_PLAYER_ID) return 1;
    SkinShootDamage(playerid,damagedid,amount, weaponid, bodypart);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(issuerid != INVALID_PLAYER_ID) // If not self-inflicted
    {
        //LagShootDamage(playerid, issuerid, amount, weaponid, bodypart);
	    new Float:health;
	    if(Team[issuerid] == HUMAN)
	    {
		    if(PInfo[issuerid][SPerk] == 10 && GetPlayerWeapon(issuerid) == 1)
		    {
		        if(PInfo[issuerid][FireMode] == 1) return 1;
		        if(Team[playerid] == HUMAN) return 1;
		        if(Team[issuerid] == ZOMBIE) return 1;
		        if(PInfo[playerid][OnFire] != 0) return 1;
				PInfo[playerid][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
				PInfo[playerid][OnFire] = 1;
				PInfo[issuerid][FireMode] = 1;
				AttachObjectToPlayer(PInfo[playerid][FireObject],playerid,0,0,-0.2,0,0,0);
				SetTimerEx("CanUseFiremode",20000,false,"i",issuerid);
	   			SetTimerEx("AffectFire",500,false,"ii",playerid,issuerid);
		    }
		    if(PInfo[issuerid][Flamerounds] != 0 && GetPlayerWeapon(issuerid) != 0)
		    {
		        if(Team[issuerid] == ZOMBIE) return 1;
		        if(Team[playerid] == HUMAN) return 1;
		        DestroyObject(PInfo[playerid][FireObject]);
		        PInfo[issuerid][Flamerounds]--;
		        PInfo[playerid][OnFire] = 1;
		        PInfo[playerid][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
		        AttachObjectToPlayer(PInfo[playerid][FireObject],playerid,0,0,-0.2,0,0,0);
		        SetTimerEx("AffectFireBull",500,false,"ii",playerid,issuerid);
			}
		}
		else if(Team[issuerid] == ZOMBIE)
		{
		    if(PInfo[issuerid][ZPerk] == 6 && GetPlayerWeapon(issuerid) == 0)
		    {
		        new Float:x,Float:y,Float:z,Float:a;
				GetPlayerVelocity(playerid,x,y,z);
				GetPlayerFacingAngle(issuerid,a);
				GetPlayerHealth(playerid,health);
				x += ( 0.5 * floatsin( -a, degrees ) );
		      	y += ( 0.5 * floatcos( -a, degrees ) );
				SetPlayerVelocity(playerid,x*0.2,y*0.2,z+0.2);
				if(PInfo[issuerid][RageMode] == 0)
				{
					if(health <= 5)
					{
					    InfectPlayer(playerid);
					    PInfo[issuerid][Infects] ++;
					    PInfo[playerid][Dead] = 1;
					    GivePlayerXP(issuerid);
					    GivePlayerAssistXP(issuerid);
				        CheckRankup(issuerid);
				        PInfo[playerid][AfterLifeInfected] = 1;
					}
					else
		   				SetPlayerHealth(playerid,health-5);
					GetPlayerHealth(playerid,health);
				}
				else if(PInfo[issuerid][RageMode] == 1)
				{
					if(health <= 15)
					{
					    InfectPlayer(playerid);
					    PInfo[playerid][Dead] = 1;
					    GivePlayerXP(issuerid);
					    PInfo[issuerid][Infects] ++;
					    GivePlayerAssistXP(issuerid);
				        CheckRankup(issuerid);
				        PInfo[playerid][AfterLifeInfected] = 1;
					}
					else
		   				SetPlayerHealth(playerid,health-15);
					GetPlayerHealth(playerid,health);
				}
			}
		    if(PInfo[issuerid][ZPerk] == 25 && GetPlayerWeapon(issuerid) == 0)
		    {
				if(PInfo[issuerid][CanPunch] == 1)
				{
			        new Float:x,Float:y,Float:z,Float:a;
					GetPlayerVelocity(playerid,x,y,z);
					GetPlayerFacingAngle(issuerid,a);
					GetPlayerHealth(playerid,health);
					x += ( 0.5 * floatsin( -a, degrees ) );
			      	y += ( 0.5 * floatcos( -a, degrees ) );
					SetPlayerVelocity(playerid,x*0.2,y*0.2,z+0.5);
					PInfo[issuerid][CanPunch] = 0;
					SetPlayerAttachedObject(issuerid,2,18701,5,0,0,-1.59,0,0,0,1,1,1,0,0);
					SetPlayerAttachedObject(issuerid,3,18701,6,0,0,-1.59,0,0,0,1,1,1,0,0);
					SetTimerEx("DestroyFirePunches",5000,false,"i",issuerid);
					SetTimerEx("CanPunchAgain",750,false,"i",issuerid);
					if(PInfo[playerid][RageMode] == 0)
					{
						if(health <= 15)
						{
							if(Team[playerid] == HUMAN)
							{
								{
							    	InfectPlayer(playerid);
							    	PInfo[issuerid][Infects] ++;
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
					}
					else if(PInfo[playerid][RageMode] == 1)
					{
						if(health <= 20)
						{
							if(Team[playerid] == HUMAN)
							{
								{
							    	InfectPlayer(playerid);
							    	PInfo[issuerid][Infects] ++;
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
					}
			    }
			}
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
    if(IsPlayerNPC(playerid))return 1;
	if(newstate == PLAYER_STATE_PASSENGER)
    {
       	if((gBugPlayerData[playerid][gbug_playerenteringveh] == 1 || gBugPlayerData[playerid][gbug_playerenteringveh] == 2) && GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBugPlayerData[playerid][gbug_vehpos][0], gBugPlayerData[playerid][gbug_vehpos][1], gBugPlayerData[playerid][gbug_vehpos][2]) > 2)
        {
            EnableAntiCheatForPlayer(playerid,4,0);
            SetPlayerPos(playerid, gBugPlayerData[playerid][gbug_playerpos][0], gBugPlayerData[playerid][gbug_playerpos][1], gBugPlayerData[playerid][gbug_playerpos][2]);
            gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
            //SendClientMessage(playerid, -1, "Entry denied");
            SetTimerEx("EnableEntAC",800,false,"i",playerid);
            GameTextForPlayer(playerid, "~R~Entry denied", 3000, 3);
        }
        else
        {
            gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
            //SendClientMessage(playerid, -1, "Entry accepted");
        }
  		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);

		if(doors == 1)
		{
			SetPlayerPos(playerid,BefPos[playerid][0],BefPos[playerid][1],BefPos[playerid][2]);
			SetPlayerFacingAngle(playerid,BefPos[playerid][3]);
	    	SendClientMessage(playerid,white,"* "cred"Vehicle is locked!");
	    	return 1;
		}
  		if(Team[playerid] == ZOMBIE)
  		{
  		    PInfo[playerid][CanHide] = 0;
  		    SetTimerEx("CanUseHide",1500,false,"i",playerid);
  		}
  		else SetPlayerArmedWeapon(playerid, 1);
	    if(PInfo[playerid][Training] == 1)
	    {
	        if(PInfo[playerid][TrainingPhase] == 15)
	        {
	            new string[1000];
	            format(string,sizeof string,""cwhite"Now you are sitting in a vehicle as a zombie\nIf you have to bite human in vehicle, you need to press "cred"SPACE "cwhite"key");
	            strcat(string,"\nYou can also write command "cred"/hide"cwhite" to hide in vehicle, humans will not be able to detect in which car you're hiding in");
	            strcat(string,"\nThis command will be useful when there are more humans\nCourse is comming to end and your "cred"next step is to go to hangar");
	            SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Enter big hangar (in front of you) and enter pickup there");
				ShowPlayerDialog(playerid,18778,DSM,"Info",string,"OK","");
				PInfo[playerid][TrainingPhase] = 16;
			}
		}
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
		if(Team[playerid] == ZOMBIE)
		{
		    RemovePlayerFromVehicle(playerid);
		    SendClientMessage(playerid,white,"* "cred"Zombies can't drive.");
		    return 1;
		}
		else SetPlayerArmedWeapon(playerid, 1);
		if(Team[playerid] == HUMAN)
		{
			if((IsDiamVehicle(GetPlayerVehicleID(playerid)) && PInfo[playerid][Premium] != 3) || ((IsPlatVehicle(GetPlayerVehicleID(playerid))) && (PInfo[playerid][Premium] != 2 && PInfo[playerid][Premium] != 3)))
			{
				SetPlayerPos(playerid,BefPos[playerid][0],BefPos[playerid][1],BefPos[playerid][2]);
				SetPlayerFacingAngle(playerid,BefPos[playerid][3]);
		  		SendClientMessage(playerid,white,"? "cred"Only players with "cplat"Platinum"cred"/"cblue"Diamond"cred" can enter this vehicle!");
				return 1;
			}
		}
		if(!IsVehicleStarted(GetPlayerVehicleID(playerid)))
		{
			new string[115];
	    	format(string,sizeof string,"** "corange"This vehicle is not Started yet. You can start it with "cred"'Left Mouse Button'"corange"."cwhite"**");
			SendClientMessage(playerid,white,string);
            TextDrawSetString(OilTD[playerid],"Oil: ~r~~h~ll~y~llllll~g~~h~ll");
            TextDrawSetString(FuelTD[playerid],"Fuel: ~r~~h~ll~y~llllll~g~~h~ll");
		}
		else if(IsVehicleStarted(GetPlayerVehicleID(playerid)))
		{
			new string[115];
	    	format(string,sizeof string,"** "corange"This vehicle is running. "cwhite"**");
		    SendClientMessage(playerid,white,string);
		    UpdateVehicleFuelAndOil(GetPlayerVehicleID(playerid));
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
				ShowPlayerDialog(playerid,20768,DSM,"Info",""cwhite"Vehicle is one of the most important thing for a human to survive\nWithout it you won't be able to survive for too long\nYou need to click "cred"Left Mouse Button"cwhite" to start engine\nKeep an eye on fuel and oil meter\nWithout them vehicle will not work!\nNow start vehicle "cred"and drive to Pickup near gate to go to next step!","OK","");
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
   	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(IsPlayerNPC(playerid))return 1;
    if(Team[playerid] == HUMAN)
    {
		if(IsPlatVehicle(vehicleid))
		{
		    if((PInfo[playerid][Premium] != 2) && (PInfo[playerid][Premium] != 3))
		    {
		        if(!ispassenger)
		        {
		            PInfo[playerid][CheckEnter] = 1;
					GetPlayerPos(playerid,BefPos[playerid][0],BefPos[playerid][1],BefPos[playerid][2]);
					GetPlayerFacingAngle(playerid,BefPos[playerid][3]);
				}
			}
		}
		if(IsDiamVehicle(vehicleid))
		{
		    if(PInfo[playerid][Premium] != 3)
		    {
		        if(!ispassenger)
		        {
					GetPlayerPos(playerid,BefPos[playerid][0],BefPos[playerid][1],BefPos[playerid][2]);
					GetPlayerFacingAngle(playerid,BefPos[playerid][3]);
					PInfo[playerid][CheckEnter] = 1;
				}
			}
		}
	}
	if(VehicleWithoutKeys[vehicleid] == 1) SendClientMessage(playerid,white,"* "corange"Seems that vehicle has no keys...");
	/*if(!ispassenger)
	{
	    if(Team[playerid] == HUMAN)
	    {
	        if(IsPlatVehicle(vehicleid) || IsDiamVehicle(vehicleid))
	        {
   				GetPlayerPos(playerid,BefPos[playerid][0],BefPos[playerid][1],BefPos[playerid][2]);
				GetPlayerFacingAngle(playerid,BefPos[playerid][3]);
			}
	    }
	}*/
   	if(!ispassenger || gBugPlayerData[playerid][gbug_playerenteringveh] != 0) return 1;
    gBugPlayerData[playerid][gbug_pentervtick] = GetTickCount();
    GetPlayerPos(playerid, gBugPlayerData[playerid][gbug_playerpos][0], gBugPlayerData[playerid][gbug_playerpos][1], gBugPlayerData[playerid][gbug_playerpos][2]);
    GetVehiclePos(vehicleid, gBugPlayerData[playerid][gbug_vehpos][0], gBugPlayerData[playerid][gbug_vehpos][1], gBugPlayerData[playerid][gbug_vehpos][2]);
    gBugPlayerData[playerid][gbug_playerenteringveh] = 1;
    //SendClientMessage(playerid, -1, "Starting to enter vehicle..");
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsPlayerNPC(playerid))return 1;
    if(RoundEnded == 1) return 1;
    if(PInfo[playerid][Afk] == 1) return 1;
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
	            	SetPlayerAttachedObject(playerid,3,18693,6,0,0,-1.59,0,0,0,1,1,1,0,0);
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
			                foreach(new i: Player)
			                {
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
					    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
									{
									    if(PInfo[playerid][CanGiveDizzy] == 1)
									    {
									        PInfo[playerid][CanGiveDizzy] = 0;
									        PInfo[i][TokeDizzy] = 0;
									        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
									    }
									}
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
							ApplyAnimation(playerid,"PED","FightA_3",8,0,1,1,0,0,1);
							foreach(new i: Player)
			                {
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
						    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
										{
										    if(PInfo[playerid][CanGiveDizzy] == 1)
										    {
										        PInfo[playerid][CanGiveDizzy] = 0;
										        PInfo[i][TokeDizzy] = 0;
										        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
										    }
										}
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
						    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
										{
										    if(PInfo[playerid][CanGiveDizzy] == 1)
										    {
										        PInfo[playerid][CanGiveDizzy] = 0;
										        PInfo[i][TokeDizzy] = 0;
										        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
										    }
										}
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
            //if(PInfo[playerid][WhatThrow] > 0) return 0;
            if((PInfo[playerid][SPerk] == 9) || (PInfo[playerid][SPerk] == 26))
            {
            	if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
				    PInfo[playerid][Throwingstate] = 1;
				    ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",5,0,0,0,1,500,1);
				    SetPlayerAttachedObject(playerid,1,2908,6,0.15,0,0.08,-90,180,90);
				    PInfo[playerid][ThrowingTimer] = SetTimerEx("MaxThrow",100,false,"i",playerid);
				    PInfo[playerid][Baiting] = 1;
				}
			}
			else if(PInfo[playerid][FlashBangs] >= 1)
			{
			    if(!IsPlayerInAnyVehicle(playerid))
			    {
				    if(PInfo[playerid][CanThrowFlashAgain] == 1)
				    {
				    	PInfo[playerid][Throwingstate] = 1;
					    PInfo[playerid][Baiting] = 1;
					    ApplyAnimation(playerid,"GRENADE","WEAPON_START_THROW",5,0,0,0,1,500,1);
					    SetPlayerAttachedObject(playerid,1,343,6,0,0.1,0,180,180,90);
					    PInfo[playerid][ThrowingTimer] = SetTimerEx("MaxThrow",100,false,"i",playerid);
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
                //if(PInfo[playerid][WhatThrow] > 0) return 1;
                if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
                    PInfo[playerid][WhatThrow] = 3;
					SetTimerEx("DestroyBait",200,false,"i",playerid);
				    if(PInfo[playerid][Throwingstate] <= 6)
				    	ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					else if(PInfo[playerid][Throwingstate] > 6)
					    ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
					KillTimer(PInfo[playerid][ThrowingTimer]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					PInfo[playerid][ObjAngz] = ang + 90;
					PInfo[playerid][ObjectProj] = CreateProjectile(x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z + 0.5,(PInfo[playerid][Throwingstate]*1.65) * floatsin(-ang, degrees), (PInfo[playerid][Throwingstate]*1.65) * floatcos(-ang, degrees), PInfo[playerid][Throwingstate] * 1.3, 0, 0, 0, 0.1, 0, 0, 0, 24, 0, false, 1.5);
					if(PInfo[playerid][ObjectProj] == INVALID_PROJECTILE_ID) return 1;
					PInfo[playerid][ZObject] = CreateObject(2908,x,y,z,270, 180,PInfo[playerid][ObjAngz]);
				 	if(PInfo[playerid][Premium] == 3) SetTimerEx("CanZombieBait",110000,false,"i",playerid);
 					else SetTimerEx("CanZombieBait",180000,false,"i",playerid);
 					static string[70];
 					format(string,sizeof string,""cwhite"* "cjam"%s tosses some zombie bait.",GetPName(playerid));
					PInfo[playerid][Baiting] = 0;
					PInfo[playerid][AllowedToBait] = 0;
					PInfo[playerid][IsBaitWithGr] = 0;
 					PInfo[playerid][Throwingstate] = 1;
 					SendNearMessage(playerid,white,string,20);
				}
			}
   			else if(PInfo[playerid][SPerk] == 26)
            {
                if(PInfo[playerid][WhatThrow] > 0) return 1;
                if(PInfo[playerid][AllowedToBait] == 0) return SendClientMessage(playerid,red,"You haven't got a zombie bait!");
                else
                {
                    PInfo[playerid][WhatThrow] = 3;
					SetTimerEx("DestroyBait",200,false,"i",playerid);
				    if(PInfo[playerid][Throwingstate] <= 6)
				    	ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					else if(PInfo[playerid][Throwingstate] > 6)
					    ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
                    KillTimer(PInfo[playerid][ThrowingTimer]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					PInfo[playerid][ObjAngz] = ang + 90;
					PInfo[playerid][ObjectProj] = CreateProjectile(x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z + 0.5,(PInfo[playerid][Throwingstate]*1.5) * floatsin(-ang, degrees), (PInfo[playerid][Throwingstate]*1.5) * floatcos(-ang, degrees), PInfo[playerid][Throwingstate] * 1.3, 0, 0, 0, 0.1, 0, 0, 0, 24, 0, false, 1.5);
					if(PInfo[playerid][ObjectProj] == INVALID_PROJECTILE_ID) return 1;
				 	PInfo[playerid][ZObject] = CreateObject(2908,x,y,z,270, 180,PInfo[playerid][ObjAngz]);
				 	if(PInfo[playerid][Premium] == 3) SetTimerEx("CanZombieBait",210000,false,"i",playerid);
 					else SetTimerEx("CanZombieBait",280000,false,"i",playerid);
 					static string[85];
 					format(string,sizeof string,""cwhite"* "cjam"%s tosses some zombie bait with grenade inside.",GetPName(playerid));
					PInfo[playerid][Baiting] = 0;
					PInfo[playerid][IsBaitWithGr] = 1;
					PInfo[playerid][AllowedToBait] = 0;
 					PInfo[playerid][Throwingstate] = 1;
 					SendNearMessage(playerid,white,string,20);
	                //SetTimerEx("ResetThrow",5000,false,"i",playerid);
				}
			}
			else if(PInfo[playerid][FlashBangs] >= 1)
			{
			    if(PInfo[playerid][WhatThrow] > 0) return 1;
			    if(PInfo[playerid][CanThrowFlashAgain] == 1)
			    {
			        PInfo[playerid][WhatThrow] = 2;
					SetTimerEx("DestroyBait",200,false,"i",playerid);
				    if(PInfo[playerid][Throwingstate] <= 4)
				    	ApplyAnimation(playerid,"GRENADE","WEAPON_THROWU",2,0,0,0,0,500,1);
					else if(PInfo[playerid][Throwingstate] > 4)
					    ApplyAnimation(playerid,"GRENADE","WEAPON_THROW",2,0,0,0,0,500,1);
                    KillTimer(PInfo[playerid][ThrowingTimer]);
					new Float:x, Float:y, Float:z, Float:ang;
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, ang);
					PInfo[playerid][ObjAngz] = ang + 90;
					PInfo[playerid][FlashBangObjectProj] = CreateProjectile(x + 0.5 * floatcos(-(ang + 90.0), degrees), y - 0.5 * floatcos(-(ang + 90.0), degrees), z + 0.5,(PInfo[playerid][Throwingstate]*1.8) * floatsin(-ang, degrees), (PInfo[playerid][Throwingstate]*1.8) * floatcos(-ang, degrees), PInfo[playerid][Throwingstate] * 1.7, 0, 0, 0, 0.1, 0, 0, 0, 24, 0, false, 1.5);
                    if(PInfo[playerid][FlashBangObjectProj] == INVALID_PROJECTILE_ID) return 1;
					PInfo[playerid][FlashBangObject] = CreateObject(343,x,y,z,270, 180,PInfo[playerid][ObjAngz]);
					PInfo[playerid][Baiting] = 0;
					PInfo[playerid][FlashBangs] --;
					PInfo[playerid][CanThrowFlashAgain] = 0;
     				SetTimerEx("BlowFlashbang",3000,false,"i",playerid);
					new string[128];
					GetPlayerPos(playerid,x,y,z);
					format(string,sizeof string,"* "cjam"%s throwed flashbang!",GetPName(playerid));
					foreach(new i: Player)
					{
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
		    return 1;
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
	if((PRESSED(KEY_WALK) && PRESSED(KEY_SPRINT)) || (HOLDING(KEY_WALK) && HOLDING(KEY_SPRINT)))
	{
		if((Team[playerid] == HUMAN && Team[GetPlayerTargetPlayer(playerid)] == HUMAN) && (GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID))
		{
		    if(GetPlayerTargetPlayer(playerid) != INVALID_PLAYER_ID)
		    {
		        if(GetPlayerWeapon(playerid) != 1) return 1;
				new Float:x,Float:y,Float:z;
				GetPlayerPos(GetPlayerTargetPlayer(playerid),x,y,z);
				if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
				{
			        PInfo[playerid][TradeID] = GetPlayerTargetPlayer(playerid);
			        new string[128];
			        format(string,sizeof string,"* "cgreen"You are trading with %s!",GetPName(PInfo[playerid][TradeID]));
			        ShowInventory(playerid);
				}
		    }
		}
	}
	if((newkeys & KEY_FIRE) && (oldkeys & KEY_WALK) || (newkeys & KEY_FIRE) && (oldkeys & KEY_WALK))
	{//2902
 		if(Team[playerid] == ZOMBIE) return 1;
	    if(IsPlayerInAnyVehicle(playerid)) return 1;
	    if(PInfo[playerid][Bettys] == 0) return 1;
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
  		if(strcmp(name, "Grenade", true) == 0)
		{
			SendClientMessage(playerid,white,""cred" ????? ????????? ?????");
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
				    		SendClientMessage(playerid,white,"** "cred"Don't BunnyHop or you will be punished!"cwhite"**");
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
            else if(PInfo[playerid][ZPerk] == 27)
           {
                if(GetTickCount() - PInfo[playerid][CanJump] < 20000 && PInfo[playerid][Jumps] >= 13) return 0;
                if(GetTickCount() - PInfo[playerid][CanJump] > 20000 && PInfo[playerid][Jumps] >= 13) PInfo[playerid][Jumps] = 0;
	            PInfo[playerid][CanJump] = GetTickCount();
	            PInfo[playerid][Jumps]++;
	            static Float:x,Float:y,Float:z;
	            GetPlayerVelocity(playerid,x,y,z);
	            SetPlayerVelocity(playerid,x,y,z+5);
	            PInfo[playerid][CanJump] = GetTickCount();
            }
        }
    }
    if((PRESSED(KEY_JUMP)) && (newkeys & 128))
    {
        if(Team[playerid] == HUMAN)
        {
            //if(PInfo[playerid][WhatThrow] > 0) return 0;
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
                        PInfo[playerid][WhatThrow] = 1;
						PInfo[playerid][Grenadeproj] = CreateProjectile(object_x, object_y, object_z, GRENADE_SPEED * fVX, GRENADE_SPEED * fVY, (GRENADE_SPEED * fVZ) + 5.0, 0, 0, 0, 0.010, 0, 0, 0.5, 15.0, 0.8, false, 1);
			            if(PInfo[playerid][Grenadeproj] == INVALID_PROJECTILE_ID) return 1;
						new obj = CreateDynamicObject(GRENADE_OBJECT, object_x, object_y, object_z + 0.5, 0, 0, 0);
			            if (obj == INVALID_OBJECT_ID)
			            {
			                PInfo[playerid][WhatThrow] = 0;
							DestroyProjectile(PInfo[playerid][Grenadeproj]);
							PInfo[playerid][Grenadeproj] = -1;
			                return 1;
						}
			            GrenadesObject[playerid][grenadesCount[playerid] ++] = obj;
			            Streamer_SetIntData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_EXTRA_ID, PInfo[playerid][Grenadeproj]);
						for (new i, j = GetPlayerPoolSize(); i <= j; i++)
						{
							Streamer_UpdateEx(i, object_x, object_y, object_z, .type = STREAMER_TYPE_OBJECT);
						}
			            PInfo[playerid][AssaultGrenades]--;
			            PInfo[playerid][CanGrenadeAgain] = 0;
				    	ApplyAnimation(playerid,"BUDDY","buddy_fire_poor",3,0,1,1,0,0,1);
				    	new Float:X,Float:Y,Float:Z;
				    	GetPlayerPos(playerid,X,Y,Z);
				    	foreach(new i: Player)
				    	{
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
				static string[128];
				SetTimerEx("PowerfulGlovesSound",350,false,"i",playerid);
				format(string,sizeof string,""cjam"%s hit the ground with his powerful gloves",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				PInfo[playerid][CanPowerfulGloves] = 0;
				if(PInfo[playerid][Premium] == 3) PInfo[playerid][PowerfulGlovesTimer] = SetTimerEx("AllowedToPowerfulGloves",90000,false,"i",playerid);
				else PInfo[playerid][PowerfulGlovesTimer] = SetTimerEx("AllowedToPowerfulGloves",80000,false,"i",playerid);
			}
			if(PInfo[playerid][SPerk] == 11)
		    {
		        if(Team[playerid] == ZOMBIE) return 0;
		        if(IsPlayerInAnyVehicle(playerid)) return 0;
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
					new Float:health;
					GetVehicleHealth(id,health);
					if(health >= 500.0) return SendClientMessage(playerid,white,"? "cred"This vehicle doesn't neet to repair!");
					TurnPlayerFaceToPos(playerid, x-270, y-270);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					new string[100];
				    format(string,sizeof string,""cjam"%s has tweaked his vehicle.",GetPName(playerid));
					SendNearMessage(playerid,white,string,20);
					SetVehicleHealth(id,health+250.0);
				}
			}
			if(PInfo[playerid][SPerk] == 16)
			{
			    if(Team[playerid] == ZOMBIE) return 0;
			    if(IsPlayerInAnyVehicle(playerid)) return 0;
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
					new Float:health;
					GetVehicleHealth(id,health);
					if(health >= 500.0) return SendClientMessage(playerid,white,"? "cred"This vehicle doesn't need to repair!");
					TurnPlayerFaceToPos(playerid, x-270, y-270);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					ApplyAnimation(playerid, "CAR" , "Fixn_Car_Out" , 2.0 , 0 , 0 , 1 , 0 , 0 , 1);
					new string[100];
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
			if(id != -1)
			{
				PInfo[playerid][Searching] = GetTickCount();
				ApplyAnimation(playerid,"COP_AMBIENT","copbrowse_out",2,0,0,0,0,0,1);
				new rand = random(4);
				if(rand == 0)
				{
				    PInfo[playerid][FoundBullets] = 1;
					SearchForBullets(playerid);
				}
				if(PInfo[playerid][SPerk] == 18)
    				SearchInsideWith19Perk(playerid);
				else
				    SearchInside(playerid);
				rand = random(5);
				if(rand == 2)
				{
					if(PInfo[playerid][Materials] >= 5000) SendClientMessage(playerid,white,"** "corange"You can't have more than 5000 materials!");
					else
					{
						new got;
						rand = random(10);
						switch(rand)
						{
							case 0..4: got = random(10)+1;
							case 5..7: got = 15+random(10);
							case 8..9: got = 25+random(15);
						}
						new string[128];
						format(string,sizeof string,"* "cjam"You have found %i materials",got);
						SendClientMessage(playerid,white,string);
						PInfo[playerid][Materials] += got;
						ShowGottenItems(playerid,2);
					}
				}
			}
   			id = -1;
 	  		for(new j; j < sizeof(LootMaterials);j++)
			{
			    if(GetTickCount() - PInfo[playerid][Searching] < 10000) return 0;
 				if(IsPlayerInRangeOfPoint(playerid,2.0,LootMaterials[j][0],LootMaterials[j][1],LootMaterials[j][2]))
				{
		    		id = j;
		    		break;
				}
			}
			if(id != -1)
			{
				PInfo[playerid][Searching] = GetTickCount();
				ApplyAnimation(playerid,"COP_AMBIENT","copbrowse_out",2,0,0,0,0,0,1);
				if(PInfo[playerid][Materials] >= 5000) return SendClientMessage(playerid,white,"** "corange"You can't have more than 5000 materials!");
				new got;
				new rand = random(10);
				switch(rand)
				{
					case 0..4: got = 25+random(40);
					case 5..7: got = 45+random(35);
					case 8..9: got = 60+random(30);
				}
				PInfo[playerid][Materials] += got;
				ShowGottenItems(playerid,2);
				new string[128];
				format(string,sizeof string,"* "cjam"%s has found %i materials",GetPName(playerid),got);
				SendNearMessage(playerid,white,string,20);
				SendFMessage(playerid,white,"* "cgreen"Now you have %i materials!",PInfo[playerid][Materials]);
			}
			if(IsPlayerInRangeOfPoint(playerid,5.0,2786.8557,-2474.8193,14.7170))
			{
			    new header[32];
			    format(header,sizeof header,""cgreen"Materials: "cred"%i",PInfo[playerid][Materials]);
			    new string[732];
				format(string,sizeof string,"Item\tReqires\tChance\n");
			    strcat(string,""cwhite"Mine\t"cyellow"800\t"cgreen"65\%\n");
			    strcat(string,""cwhite"Molotovs\t"cyellow"1000\t"cgreen"70\%\n");
			    strcat(string,""cwhite"Sticky bombs\t"cyellow"2400\t"cyellow"50\%\n");
			    strcat(string,""cwhite"Beacon Bullets\t"cyellow"1400\t"cyellow"50\%\n");
			    strcat(string,""cwhite"Impact Bullets\t"cyellow"1800\t"cyellow"40\%\n");
			    strcat(string,""cwhite"Stinger Bullets\t"cyellow"2350\t"cred"35\%\n");
			    strcat(string,""cwhite"Nitro\t"cyellow"2000\t"cyellow"60\%\n");
				strcat(string,""cwhite"Anti-blindness pills\t"cyellow"400\t"cgreen"90\%\n");
				strcat(string,""cwhite"Crafting Table\t"cyellow"2800\t"cgreen"75\%");
			    ShowPlayerDialog(playerid,CraftDialog,DSTH,header,string,"Craft","Close");
			}
		}
		if(Team[playerid] == ZOMBIE)
		{
  			if(PInfo[playerid][ZPerk] == 2)
    		{
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
				if(PInfo[playerid][ModeSlot1] == 8 || PInfo[playerid][ModeSlot2] == 8 || PInfo[playerid][ModeSlot3] == 8)
				{
					if(PInfo[playerid][CanResusDig] == 1)
					{
					    if(IsPlayerInRangeOfPoint(playerid,1500,PInfo[playerid][ResusX],PInfo[playerid][ResusY],PInfo[playerid][ResusZ]))
						{
							PInfo[playerid][CanResusDig] = 0;
					    	SetTimerEx("DigToLastDeathPos",3000,false,"i",playerid);
					    	SendClientMessage(playerid,white,"* "cjam"You are digging to your last death position.");
    						ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
			   				PInfo[playerid][CanDig] = 0;
							PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
							return 1;
						}
					}
				}
				else if(PInfo[playerid][ModeSlot1] == 5 || PInfo[playerid][ModeSlot2] == 5 || PInfo[playerid][ModeSlot3] ==  5)
	    		{
	    		    if(PInfo[playerid][ChoseMap] == 1)
	    		    {
	    		        if(IsPlayerInRangeOfPoint(playerid,1500,PInfo[playerid][AccurX],PInfo[playerid][AccurY],PInfo[playerid][AccurZ]))
	    		        {
							SetTimerEx("DigToDot",3000,false,"i",playerid);
	    					SendClientMessage(playerid,white,"* "cjam"You are digging to marker");
							ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
		   					PInfo[playerid][CanDig] = 0;
		   					PInfo[playerid][ChoseMap] = 0;
							PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
							return 1;
						}
					}
				}
				new id = -1;
				if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot3] == 4)
		        	id = GetClosestPlayerWithoutZombie(playerid,2000);
				else
				    id = GetClosestPlayer(playerid,2000);
				if(Team[id] == ZOMBIE) return SendClientMessage(playerid,white,"* "cred"You are too close to another zombie!");
				if(PInfo[id][Logged] == 0) return 1;
				if(PInfo[id][SPerk] == 28) return 1;
				if(IsPlayerNPC(id)) return 1;
				if(id == -1) return SendClientMessage(playerid,red,"There are no survivors left...");
   				PInfo[playerid][CanDig] = 0;
				PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",DIGTIME,false,"i",playerid);
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
				SetTimerEx("DigToPlayer",3000,false,"ii",playerid,id);
		    }
		    if(PInfo[playerid][Training] == 1)
		    {
		        if(PInfo[playerid][TrainingPhase] == 14)
		        {
		            if(PInfo[playerid][FakePerk] == 3)
		            {
			            if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
	                    PInfo[playerid][CanDig] = 0;
	                    SetTimerEx("DigToTrainingVehicle",3000,false,"i",playerid);
	                    ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",0.5,0,0,0,1,3000,1);
					}
				}
			}
		    if(PInfo[playerid][ZPerk] == 26)
		    {
		        if(PInfo[playerid][CanDig] == 0) return SendClientMessage(playerid,red,"You are tired to dig!");
          		new id = -1;
				if(PInfo[playerid][ModeSlot1] == 4 || PInfo[playerid][ModeSlot2] == 4 || PInfo[playerid][ModeSlot3] == 4)
		        	id = GetClosestPlayerWithoutZombie(playerid,2000);
				else
				    id = GetClosestPlayer(playerid,2000);
          		if(PInfo[id][Logged] == 0) return 1;
          		if(Team[id] == ZOMBIE) return SendClientMessage(playerid,white,"* "cred"You are too close to another zombie!");
          		if(PInfo[id][SPerk] == 28) return 1;
          		if(IsPlayerNPC(id)) return 1;
          		if(id == -1) return SendClientMessage(playerid,red,"There are no survivors left...");
          		if(PInfo[playerid][Premium] == 2)
          		    PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",140000,false,"i",playerid);
		  		else
				  	PInfo[playerid][DigTimer] = SetTimerEx("ResetDigVar",160000,false,"i",playerid);
          		PInfo[playerid][CanDig] = 0;
				SetTimerEx("DigToPlayer27perk",1200,false,"ii",playerid,id);
				new Float:x,Float:y,Float:z;
				GetPlayerPos(id,x,y,z);
				foreach(new i: Player)
				{
				    if(PInfo[i][Logged] == 0) continue;
				    if(IsPlayerInRangeOfPoint(i,20,x,y,z))
				    {
				        PlayerPlaySound(i,6002,x,y,z);
				        SendClientMessage(i,white,"* "dred"You heard a strange sound under the ground...");
				    }
				}
				ApplyAnimation(playerid,"WUZI","WUZI_GRND_CHK",3,0,0,0,1,700,1);
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
	            new infects;
				foreach(new i: Player)
				{
				    if(PInfo[i][Logged] == 0) continue;
				    if(PInfo[i][Firstspawn] == 1) continue;
				    if(PInfo[i][Jailed] == 1) continue;
				    if(IsPlayerNPC(i)) continue;
				    if(PInfo[i][Afk] == 1) continue;
				    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
				    if(Team[i] == ZOMBIE) infects++;
				}
				new Allplayers;
				foreach(new i: Player)
				{
				    if(PInfo[i][Logged] == 1)
				    {
				    	if(PInfo[i][Firstspawn] == 0)
				    	{
			        		if(PInfo[i][Jailed] == 0)
			        		{
			        		    if(PInfo[i][Afk] == 0)
			        		    {
			        	    		if(PInfo[i][Training] == 0)
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
				if(infects == Allplayers) return SendClientMessage(playerid,red,"Looks like that there no survivors left!");
		        new id = -1;
		        foreach(new i: Player)
		        {
		            if(PInfo[i][Logged] == 0) continue;
		            if(Team[i] == ZOMBIE) continue;
		            if(PInfo[i][Spawned] == 0) continue;
		            if(PInfo[i][Dead] == 1) continue;
		            if(PInfo[i][Jailed] == 1) continue;
		            if(PInfo[i][Afk] == 1) continue;
		            if(PInfo[i][Training] == 1) continue;
		            else
		            {
		                id = i;
		                break;
		            }
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
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				PInfo[playerid][CanStomp] = 0;
				if(PInfo[playerid][Premium] == 3) PInfo[playerid][StompTimer] = SetTimerEx("AllowedToStomp",110000,false,"i",playerid);
				else PInfo[playerid][StompTimer] = SetTimerEx("AllowedToStomp",120000,false,"i",playerid);
				foreach(new i: Player)
				{
					if(Team[i] == ZOMBIE) continue;
					if(IsPlayerInRangeOfPoint(i,15,x,y,z))
					{
					    if(!IsPlayerInAnyVehicle(i))
					    {
					        if(PInfo[i][CanBeStomped] == 0) continue;
					    	TogglePlayerControllable(i,0);
							if(PInfo[i][Stomped] == 0)
							    SetTimerEx("RemoveStomp",2500,false,"i",i);
							static string[90];
				 			format(string,sizeof string,""cjam"%s has been knocked to the ground by the powerful force!",GetPName(i));
							SendNearMessage(playerid,white,string,30);
							SetTimerEx("CanBeStompedAgain",10000,false,"i",i);
							PInfo[i][Stomped] = 1;
							PInfo[i][CanBeStomped] = 0;
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
			if(IsPlayerInRangeOfPoint(playerid,1.5,1456.3890,-1482.4321,1754.4264))
			{
			    if(PInfo[playerid][GotStabilizer] == 0)
			    {
				    new header[64];
				    format(header,sizeof header,""cgreen"DNA Points: "cred"%i",PInfo[playerid][DNIPoints]);
				    new string[1024];
					format(string,sizeof string,"Modification\tCost\tInstability\n");
					strcat(string,""cwhite"Insane Rage\t"cjam"5000\t"dred"Extremely High\n");
					strcat(string,""cwhite"Healing Rage\t"cjam"1150\t"corange"Medium\n");
					strcat(string,""cwhite"More Rage\t"cjam"1500\t"corange"Medium\n");
					strcat(string,""cwhite"Imperception\t"cjam"2400\t"cred"High\n");
					strcat(string,""cwhite"Accurate Digger\t"cjam"1800\t"cgreen"Low\n");
					strcat(string,""cwhite"Dizzy Trap\t"cjam"1000\t"cgreen"Low\n");
					strcat(string,""cwhite"Edible residues\t"cjam"3200\t"corange"Medium\n");
					strcat(string,""cwhite"Resuscitation\t"cjam"3700\t"cred"High\n");
					strcat(string,""cwhite"Crowded stomach\t"cjam"4000\t"cred"Very High\n");
					strcat(string,""cwhite"Regeneration\t"cjam"4500\t"cred"Very High\n");
					strcat(string,""cwhite"Collector\t"cjam"600\t"corange"Medium\n");
					strcat(string,""cwhite"DNA Stabilizer\t"cjam"4800\t"cgreen"Low\n");
				    ShowPlayerDialog(playerid,DNADialog,DSTH,header,string,"Modify","Close");
				}
				else
				{
				    new header[32];
				    format(header,sizeof header,""cgreen"DNA Points: "cred"%i",PInfo[playerid][DNIPoints]);
				    new string[1024];
					format(string,sizeof string,"Modification\tCost\tInstability\n");
					strcat(string,""cwhite"Insane Rage\t"cjam"5000\t"dred"Very High\n");
					strcat(string,""cwhite"Healing Rage\t"cjam"1150\t"cgreen"Low\n");
					strcat(string,""cwhite"More Rage\t"cjam"1500\t"cgreen"Low\n");
					strcat(string,""cwhite"Imperception\t"cjam"2400\t"cred"Medium\n");
					strcat(string,""cwhite"Accurate Digger\t"cjam"1800\t"cgreen"Very Low\n");
					strcat(string,""cwhite"Dizzy Trap\t"cjam"1000\t"cgreen"Very Low\n");
					strcat(string,""cwhite"Edible residues\t"cjam"3200\t"cgreen"Low\n");
					strcat(string,""cwhite"Resuscitation\t"cjam"3700\t"corange"Medium\n");
					strcat(string,""cwhite"Crowded stomach\t"cjam"4000\t"cred"High\n");
					strcat(string,""cwhite"Regeneration\t"cjam"4500\t"cred"High\n");
					strcat(string,""cwhite"Collector\t"cjam"600\t"cgreen"Low\n");
				    ShowPlayerDialog(playerid,DNADialog,DSTH,header,string,"Modify","Close");
				}
			}
		}
	}
	if(HOLDING(KEY_WALK) && HOLDING(KEY_CROUCH) || PRESSED(KEY_WALK) && PRESSED(KEY_CROUCH) || HOLDING(KEY_CROUCH) && HOLDING(KEY_WALK) || PRESSED(KEY_CROUCH) && PRESSED(KEY_WALK))
	{
	    if(PInfo[playerid][SPerk] == 27)
	    {
	        if(Team[playerid] == ZOMBIE) return 0;
	        if(PInfo[playerid][CanPlaceFlag] == 0) return SendClientMessage(playerid,white,"* "cred"Your flag is not charged yet!");

	        new Float:x,Float:y,Float:z;
	        GetPlayerPos(playerid,x,y,z);
			foreach(new i: Player)
			{

				if(IsPlayerInRangeOfPoint(playerid,15,PInfo[i][FlagX],PInfo[i][FlagY],PInfo[i][FlagZ]))
				{
					SendClientMessage(playerid,white,"* "cred"You are too close to another flag, please set it in other place!");
					return 0;
				}
				new string[128];
				format(string, sizeof string, "* "cjam"%s has placed a medical flag, enter it if you need medical help!",GetPName(playerid));
				SendNearMessage(i,white,string,20);
			}
   			PInfo[playerid][CanPlaceFlag] = 0;
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
		    new Float:x,Float:y,Float:z;
		    GetPlayerPos(playerid,x,y,z);
            DestroyDynamicMapIcon(PInfo[playerid][BeaconMarker]);
            new rand = random(5);
            switch(rand)
            {
                case 0:
                {
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,58,0,-1,-1,-1,15000,MAPICON_GLOBAL);
				}
                case 1:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,59,0,-1,-1,-1,15000,MAPICON_GLOBAL);
				}
				case 2:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,60,0,-1,-1,-1,15000,MAPICON_GLOBAL);
				}
                case 3:
				{
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,61,0,-1,-1,-1,15000,MAPICON_GLOBAL);
				}
                case 4:
                {
					PInfo[playerid][BeaconMarker] = CreateDynamicMapIcon(x,y,z,62,0,-1,-1,-1,15000,MAPICON_GLOBAL);
				}
			}
			DestroyObject(PInfo[playerid][Flare]);
			PInfo[playerid][CanFlare] = 0;
			SetTimerEx("CanItFlare",60000,false,"i",playerid);
			PInfo[playerid][Flare] = CreateObject(18728,x,y,z-2,0,0,0,200);
		}
	}
	if(PRESSED(KEY_SPRINT))
	{
	    if(PInfo[playerid][Spectating] == 1)
	    {
	        if(!IsPlayerConnected(PInfo[playerid][SpecID]))
	        {
	            SendClientMessage(playerid,white,"* "cred"Player, who you were spectating left the server, you were automatically stopped spectating");
				foreach(new i: Player)
			    {
			        if(PInfo[i][Level] >= 1)
			        {
						static string[128];
						format(string,sizeof string,""cred"? Administrator %s stopped spectating",GetPName(playerid));
						SendClientMessage(i,white,string);
					}
				}
				TogglePlayerSpectating(playerid, 0);
			 	SetCameraBehindPlayer(playerid);
			 	//SetTimerEx("restorpos",1500,false,"i",playerid);
			 	PInfo[playerid][SpecID] = -1;
			 	SendClientMessage(playerid,white,""cred"You've stopped spectate");
			}
			else
			{
	        	SendClientMessage(playerid,white,"* "cred"Successfuly updated");
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
                foreach(new i: Player)
				{
				    if(IsPlayerInRangeOfPoint(playerid,15,x,y,z))
				    	PlaySound(i,32400);
				}
				new Deb = CreateObject(18683,x,y,z-1.25,0,0,0,300);
				DestroyObject(Deb);
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
    	if(VehicleWithoutKeys[GetPlayerVehicleID(playerid)] == 1) return SendClientMessage(playerid,white,"* "corange"No keys found, try to pick lock (Press "cred"N "cblue"> "cwhite"Picklocks)");
		new Float:health;
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
		    	if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"? "cred"You haven't got enough energy to get a quick burst!");
			    new Float:x,Float:y,Float:z,Float:a;
				GetPlayerVelocity(playerid,x,y,z);
				GetPlayerFacingAngle(playerid,a);
				x += ( 0.5 * floatsin( -a, degrees ) );
		      	y += ( 0.5 * floatcos( -a, degrees ) );
				SetPlayerVelocity(playerid,x,y,z+0.4);
				PInfo[playerid][CanBurst] = 0;
				static string[128];
				format(string,sizeof string,""cwhite"* "cjam"%s gets a quick burst of energy",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
			}
		}
		if(PInfo[playerid][SPerk] == 6 && Team[playerid] == HUMAN)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"? "cred"You haven't got enough energy to get a quick burst!");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
			PInfo[playerid][CanBurst] = 0;
			if(PInfo[playerid][Premium] == 3) PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",110000,false,"i",playerid);
			else PInfo[playerid][ClearBurst] = SetTimerEx("ClearBurstTimer",120000,false,"i",playerid);
			static string[128];
			format(string,sizeof string,""cwhite"* "cjam"%s gets a quick burst of energy",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
		}
		else if(PInfo[playerid][ZPerk] == 9 && Team[playerid] == ZOMBIE)
		{
		    if(PInfo[playerid][CanBurst] == 0) return SendClientMessage(playerid,white,"? "cred"You haven't got enough energy to get a quick burst!");
		    new Float:x,Float:y,Float:z,Float:a;
			GetPlayerVelocity(playerid,x,y,z);
			GetPlayerFacingAngle(playerid,a);
			x += ( 0.5 * floatsin( -a, degrees ) );
	      	y += ( 0.5 * floatcos( -a, degrees ) );
			SetPlayerVelocity(playerid,x,y,z+0.4);
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
	    if(Team[playerid] != ZOMBIE) return 0;
	    if(PInfo[playerid][CanBite] == 0) return 0;
	    new Float:Health,Float:x,Float:y,Float:z,Float:a,Float:vh,Float:ax,Float:ay,Float:az;
		if(PInfo[playerid][ZPerk] == 15)///Hemorrage======================
		{
		    if(IsPlayerInAnyVehicle(playerid)) return 0;
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
		    	GetPlayerPos(playerid,x,y,z);
		        if(IsPlayerInRangeOfPoint(i,5.5,x,y,z))
		        {
		            if(IsPlayerFacingPlayer(playerid, i, 130))
		            {
       					if(PInfo[i][CanBeSpitted] == 0) continue;
		                if(!IsPlayerInAnyVehicle(i))
   						{
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
							for(new ko = 1; ko < 40; ko++)
							{
							    if(ko == 25) continue;
							    if(ko == 28) continue;
                                TextDrawShowForPlayer(i,BloodHemorhage[i][ko]);
							}
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
			SetPlayerAttachedObject(playerid,5,18729,2,0,0,-1.6);
			SetTimerEx("DeleteBlood",650,false,"i",playerid);
            PInfo[playerid][CanSpit] = GetTickCount();
		}
  		else if(PInfo[playerid][ZPerk] == 24)
		{
		    if(GetTickCount() - PInfo[playerid][CanHellScream] < 18000) return 0;
		    if(IsPlayerInAnyVehicle(playerid)) return 0;
		    for(new i, f = MAX_PLAYERS; i < f; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
      		    if(i == playerid) continue;
			    if(PInfo[i][Dead] == 1) continue;
			    if(Team[i] == ZOMBIE) continue;
		    	GetPlayerPos(playerid,x,y,z);
		        if(IsPlayerInRangeOfPoint(i,8,x,y,z))
		        {
		            if(IsPlayerFacingPlayer(playerid, i, 70))
		            {
		                if(!IsPlayerInAnyVehicle(i))
   						{
		                	if(PInfo[i][SPerk] != 12)
		                	{
								GetPlayerVelocity(i,x,y,z);
								GetPlayerFacingAngle(playerid,a);
								x += ( 0.5 * floatsin( -a, degrees ) );
					      		y += ( 0.5 * floatcos( -a, degrees ) );
					      		ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
								SetPlayerVelocity(i,x,y,z+0.15);
        						if(PInfo[i][OnFire] != 0) return 0;
								PInfo[i][FireObject] = CreateObject(18692,0,0,0,0,0,0,200);
								PInfo[i][OnFire] = 1;
								AttachObjectToPlayer(PInfo[i][FireObject],i,0,0,-0.2,0,0,0);
								SetTimerEx("AffectFire",500,false,"ii",i,playerid);
							}
		            	}
		            	else
		            	{
			        		GetVehicleHealth(GetPlayerVehicleID(i),vh);
			        		SetVehicleHealth(GetPlayerVehicleID(i),vh-75);
		        		 	PInfo[i][VehicleFire] = CreateObject(18691,0,0,0,0,0,0,200);
		        		 	AttachObjectToVehicle(PInfo[i][VehicleFire],GetPlayerVehicleID(i),0,2,-1,0,0,0);
		        		 	SetTimerEx("DamageVehicle",500,false,"i",i);
						}
			  			GetPlayerHealth(i,Health);
			  			if(Health <= 7.0)
						{
					    	InfectPlayer(i);
					    	PInfo[i][Dead] = 1;
					    	PInfo[playerid][Screameds] ++;
					    	GivePlayerXP(playerid);
					    	GivePlayerAssistXP(playerid);
				        	CheckRankup(playerid);
				        	PInfo[i][AfterLifeInfected] = 1;
						}
						else
			  				SetPlayerHealth(i,Health-7.0);
					 	GetPlayerHealth(i,Health);
						if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
		    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
						{
						    if(PInfo[playerid][CanGiveDizzy] == 1)
						    {
						        PInfo[playerid][CanGiveDizzy] = 0;
						        PInfo[i][TokeDizzy] = 0;
						        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
						    }
						}
		   			}
				}
			}
            ApplyAnimation(playerid,"RIOT","RIOT_shout",3.5,0,1,1,0,0,1);
            SetPlayerAttachedObject(playerid,4,18694,2,0,0.1,-1.6,0,0,0,1,1,1,0,0);
            SetTimerEx("DestroyHellFire",1455,false,"i",playerid);
            PInfo[playerid][CanHellScream] = GetTickCount();
  		}
		else if(PInfo[playerid][ZPerk] == 8)
		{
		    if(GetTickCount() - PInfo[playerid][Canscream] < 4000) return 0;
		    if(IsPlayerInAnyVehicle(playerid)) return 0;
		    for(new i, f = MAX_PLAYERS; i < f; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
      		    if(i == playerid) continue;
			    if(PInfo[i][Dead] == 1) continue;
			    if(Team[i] == ZOMBIE) continue;
		    	GetPlayerPos(playerid,x,y,z);
		        if(IsPlayerInRangeOfPoint(i,15,x,y,z))
		        {
		            if(IsPlayerFacingPlayer(playerid, i, 70))
		            {
		                if(PInfo[i][SPerk] != 12)
		                {
							GetPlayerVelocity(i,x,y,z);
							GetPlayerFacingAngle(playerid,a);
							x += ( 0.5 * floatsin( -a, degrees ) );
					      	y += ( 0.5 * floatcos( -a, degrees ) );
	      	    			ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
							SetPlayerVelocity(i,x*0.9,y*0.9,z+0.1);
						}
			  			GetPlayerHealth(i,Health);
						if(PInfo[playerid][RageMode] == 0)
						{
						    GetPlayerHealth(i,Health);
				  			if(Health <= 10.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	PInfo[playerid][Screameds] ++;
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-10.0);
						 	GetPlayerHealth(i,Health);
						}
	                    else if(PInfo[playerid][RageMode] == 1)
						{
						    GetPlayerHealth(i,Health);
				  			if(Health <= 15.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	GivePlayerXP(playerid);
						    	PInfo[playerid][Screameds] ++;
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-15.0);
						 	GetPlayerHealth(i,Health);
						}
						if(PInfo[i][Infected] == 0)
						    PInfo[i][Infected] = 1;
		    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
						{
						    if(PInfo[playerid][CanGiveDizzy] == 1)
						    {
						        PInfo[playerid][CanGiveDizzy] = 0;
						        PInfo[i][TokeDizzy] = 0;
						        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
						    }
						}
			        }
	   			}
			}
            ApplyAnimation(playerid,"RIOT","RIOT_shout",3,0,1,1,1,1000,1);
            SetTimerEx("ClearAnim2",700,false,"i",playerid);
            PInfo[playerid][Canscream] = GetTickCount();
  		}
  		else if(PInfo[playerid][ZPerk] == 19)
		{
		    if(GetTickCount() - PInfo[playerid][Canscream] < 5500) return 0;
		    if(IsPlayerInAnyVehicle(playerid)) return 0;
		    for(new i, f = MAX_PLAYERS; i < f; i++)
		    {
		        if(!IsPlayerConnected(i)) continue;
      		    if(i == playerid) continue;
			    if(PInfo[i][Dead] == 1) continue;
			    if(Team[i] == ZOMBIE) continue;
		    	GetPlayerPos(playerid,x,y,z);
		        if(IsPlayerInRangeOfPoint(i,23,x,y,z))
		        {
		            if(IsPlayerFacingPlayer(playerid, i, 70))
		            {
		                if(!IsPlayerInAnyVehicle(i))
   						{
		                	if(PInfo[i][SPerk] != 12)
		                	{
								GetPlayerVelocity(i,x,y,z);
								GetPlayerFacingAngle(playerid,a);
								x += ( 0.5 * floatsin( -a, degrees ) );
					      		y += ( 0.5 * floatcos( -a, degrees ) );
				      		 	ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
								SetPlayerVelocity(i,x*1.1,y*1.1,z+0.14);
							}
						}
						else
						{
							SetVehicleAngularVelocity(GetPlayerVehicleID(i), 0, 0, 0.3);
		            	}
						if(PInfo[playerid][RageMode] == 0)
						{
						    GetPlayerHealth(i,Health);
				  			if(Health <= 12.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	PInfo[playerid][Screameds] ++;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-12.0);
						 	GetPlayerHealth(i,Health);
						}
						else if(PInfo[playerid][RageMode] == 1)
						{
						    GetPlayerHealth(i,Health);
				  			if(Health <= 17.0)
							{
						    	InfectPlayer(i);
						    	PInfo[i][Dead] = 1;
						    	PInfo[playerid][Screameds] ++;
						    	GivePlayerXP(playerid);
						    	GivePlayerAssistXP(playerid);
					        	CheckRankup(playerid);
					        	PInfo[i][AfterLifeInfected] = 1;
							}
							else
				  				SetPlayerHealth(i,Health-17.0);
						 	GetPlayerHealth(i,Health);
						}
						if(PInfo[i][Infected] == 0) PInfo[i][Infected] = 1;
		    			if(PInfo[playerid][ModeSlot1] == 6 || PInfo[playerid][ModeSlot2] == 6 || PInfo[playerid][ModeSlot3] == 6)
						{
						    if(PInfo[playerid][CanGiveDizzy] == 1)
						    {
						        PInfo[playerid][CanGiveDizzy] = 0;
						        PInfo[i][TokeDizzy] = 0;
						        SetTimerEx("CanGiveDizzyD",140000,false,"i",playerid);
						    }
						}
					}
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
			    GetPlayerPos(playerid,x,y,z);
			    new i;
			    i = -1;
			    foreach(new j:Player)
			    {
			        if(j == playerid) continue;
			        if(PInfo[j][Dead] == 1) continue;
			        if(Team[j] == ZOMBIE) continue;
			        if(PInfo[playerid][CanBite] == 0) continue;
			        if((!IsPlayerInAnyVehicle(j) && IsPlayerInAnyVehicle(playerid)) || (IsPlayerInAnyVehicle(j) && !IsPlayerInAnyVehicle(playerid))) continue;
                    if((IsPlayerInAnyVehicle(j) && IsPlayerInAnyVehicle(playerid)) && (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(j))) continue;
					if(IsPlayerInRangeOfPoint(j,1.5,x,y,z))
			        {
			            i = j;
			            break;
			        }
      			}
      			GetPlayerPos(i,ax,ay,az);
      			if(IsPlayerInRangeOfPoint(playerid,1.5,ax,ay,az))
      			{
					new rando = random(5);
					if(rando == 1)
					{
					    new dim;
					    if(PInfo[playerid][ModeSlot1] == 11 || PInfo[playerid][ModeSlot2] == 11 || PInfo[playerid][ModeSlot3] == 11)
			    	 		dim = 15+random(25);
					    else
							dim = 5+random(15);
					    PInfo[playerid][DNIPoints] += dim;
					    if(PInfo[playerid][DNIPoints] >= 5000)
					    {
					        PInfo[playerid][DNIPoints] = 5000;
					        SendClientMessage(playerid,white,"***"cjam" You got maximum of DNA Points (you have 5000 DNA Points), spend them in laboratory (in Hive)");
					    }
					    ShowGottenItems(playerid,1);
					}
      			    rando = random(4);
      			    if(rando == 2)
      			    {
      			        if((PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot3] == 1) || (PInfo[playerid][ModeSlot1] == 3 || PInfo[playerid][ModeSlot2] == 3 || PInfo[playerid][ModeSlot3] == 3))
						{
							if(PInfo[playerid][RageModeStatus] >= 98)
							{
						    	PInfo[playerid][RageModeStatus] = 100;
							    PInfo[playerid][CanUseRage] = 1;
							}
							else PInfo[playerid][RageModeStatus] += 2;
						}
						else
						{
							if(PInfo[playerid][RageModeStatus] >= 99)
							{
						    	PInfo[playerid][RageModeStatus] = 100;
							    PInfo[playerid][CanUseRage] = 1;
							}
							else PInfo[playerid][RageModeStatus] ++;
						}
						ShowGottenRage(playerid);
      			    }
      			    EnableAntiCheatForPlayer(playerid,12,0);
		            GetPlayerHealth(i,Health);
		  			Damageplayer(playerid,i);
		  			PInfo[playerid][CanBite] = 0;
		  			new MaxHealthRank;
		  			new ExtraHP;
       				if(((PInfo[playerid][ModeSlot1] == 1 || PInfo[playerid][ModeSlot2] == 1 || PInfo[playerid][ModeSlot3] == 1) || (PInfo[playerid][ModeSlot1] == 2 || PInfo[playerid][ModeSlot2] == 2 || PInfo[playerid][ModeSlot3] == 2)) && (PInfo[playerid][RageMode] == 1)) ExtraHP = 2;
		  			if(PInfo[playerid][Rank] < 5) MaxHealthRank = 125;
		  			if((PInfo[playerid][Rank] >= 5) && (PInfo[playerid][Rank] < 10)) MaxHealthRank = 150;
		  			if((PInfo[playerid][Rank] >= 10) && (PInfo[playerid][Rank] < 15)) MaxHealthRank = 175;
		  			if((PInfo[playerid][Rank] >= 15) && (PInfo[playerid][Rank] < 20)) MaxHealthRank = 200;
		  			if((PInfo[playerid][Rank] >= 20) && (PInfo[playerid][Rank] < 25)) MaxHealthRank = 225;
		  			if(PInfo[playerid][Rank] >= 25) MaxHealthRank = 250;
					GetPlayerHealth(playerid,Health);
					if(Health >= MaxHealthRank) SetPlayerHealth(playerid,MaxHealthRank);
					else
					{
					    if(PInfo[playerid][ZPerk] == 3 || PInfo[playerid][ZPerk] == 18)
						{
							if(Health < MaxHealthRank-5) SetPlayerHealth(playerid,Health+5+ExtraHP);
							else SetPlayerHealth(playerid,MaxHealthRank);
						}
						else if(PInfo[playerid][ZPerk] == 21)
						{
							if(Health < MaxHealthRank-8) SetPlayerHealth(playerid,Health+8+ExtraHP);
							else SetPlayerHealth(playerid,MaxHealthRank);
						}
					    else 
   						{
							if(Health < MaxHealthRank-3) SetPlayerHealth(playerid,Health+3+ExtraHP);
							else SetPlayerHealth(playerid,MaxHealthRank);
						}
					}
					SetTimerEx("ActivateCheat",1000,false,"i",playerid);
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
								foreach(new l: Player)
								{
									if(IsPlayerInRangeOfPoint(l,15,x,y,z))
										SendClientMessage(l,white,stranng);
								}
								SendClientMessage(i,white,"* "dred"You are poisoned, use Dizzy Away Pills to decrease effect of toxin!");
					            PInfo[i][PoisonDizzy] = 1;
					            SetPlayerWeather(i,417);
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
							ApplyAnimation(i,"PED","DAM_Stomach_frmFT",0.5,0,0,0,0,0,1);
							SetTimerEx("StingerPhase1", 500, false, "i", i);
							SetTimerEx("StingerPhase2", 1000, false, "i", i);
							PInfo[i][CanStinger] = 0;
							SetTimerEx("CanBeStingeredTime", 12000, false, "i", i);
						}
					}
	      		}
			}
		}
		if(PInfo[playerid][Training] == 1)
		{
		    if(PInfo[playerid][TrainingPhase] == 12)
		    {
				new Float:acX,Float:acY,Float:acZ;
				GetActorPos(Jason[playerid],acX,acY,acZ);
				if(IsPlayerInRangeOfPoint(playerid,1.4,acX,acY,acZ))
				{
				    if(PInfo[playerid][CanBite] == 1)
				    {
				    	ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
				    	PInfo[playerid][CanBite] = 0;
				    	SetTimerEx("CantBite",535,0,"i",playerid);
				    	PlayerPlaySound(playerid,1136,acX,acY,acZ);
				    	ApplyActorAnimation(Jason[playerid],"PED","DAM_armR_frmFT",2,0,1,1,0,0);
				    	if(PInfo[playerid][JasonsHP] == 1)
				    	{
				    	    new strang[512];
				    	    format(strang,sizeof strang,""cwhite"Good Job!\nNow you know how to bite!\nYou have infected a human and after some time he will become a zombie\nBut the human you killed was just a bot, so he won't...\nAfter infecting humans you will get some XP");
				    	    strcat(strang,"\nIf you were killed by human, your rage will increase\nWhen "corange"rage "cwhite"will be 100\% click N to activate "corange"Rage mode\n"cwhite"With "corange"Rage mode"cwhite" you can infect humans much faster than usual!");
				            PInfo[playerid][TrainingPhase] = 13;
				            SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Go to next pickup");
				            Jason[playerid] = SetActorPos(Jason[playerid],307.1434,2604.6030,16.4844);
				            ShowPlayerDialog(playerid,18885,DSM,"Info",strang,"OK","");
				            DestroyPlayerObject(playerid,GateZombie2);
				            GateZombie1 = CreatePlayerObject(playerid,986,297.4650000,2504.6460000,15.4340000,0.0000000,0.0000000,266.2480000);
						}
						else
						PInfo[playerid][JasonsHP] --;
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
			    if(IsPlayerInRangeOfPoint(playerid,3,SX,SY,SZ) && !IsPlayerInAnyVehicle(playerid))
			    {
			        if(SupplyHealth <= 2)
			        {
			            SupplyDestroyed = 1;
			            SupplyHealth = 0;
						DestroyObject(objectsupply1);
						KillTimer(InvadingTimer);
						DestroyObject(objectsupply2);
						DestroyDynamic3DTextLabel(SupplyLabel);
						new Deb = CreateObject(18683,x,y,z-1.25,0,0,0,300);
						DestroyObject(Deb);
				        PInfo[playerid][CanBite] = 0;
				        SetTimerEx("CantBite",800,0,"i",playerid);
				        PlayNearSound(playerid,1136);
				        ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
						foreach(new i: Player)
						{
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
									PInfo[i][RageModeStatus] += 40;
									if(PInfo[i][RageModeStatus] >= 100)
									{
										PInfo[i][RageModeStatus] = 100;
										PInfo[i][CanUseRage] = 1;
									}
									ShowGottenRage(i);
						     	    SendClientMessage(i,white,"** "cred"You've got Extra XP and Rage!");
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
							static string[155];
							format(string,sizeof string,""cred"Containers Health: "cgreen"%i\n"cred"Capture Progress:"cgreen" %i\%",SupplyHealth,SupplyInvadeProgress);
					        UpdateDynamic3DTextLabelText(SupplyLabel,green,string);
					        ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
					        SupplyHealth -=1;
						}
					}
				}
			}
		}
		foreach(new i: Player)
	    {
			if(IsValidObject(PInfo[i][ResuedObj]))
			{
				if(PInfo[playerid][CanBite] == 1)
				{
		        	GetObjectPos(PInfo[i][ResuedObj],x,y,z);
					if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
					{
					    new Float:health;
					    GetPlayerHealth(playerid,health);
					    if(health >= 100) return SendClientMessage(playerid,white,"* "cred"You are not hungry");
					    if(PInfo[i][Resuedsstrength] > 1)
					    {
							PInfo[playerid][CanBite] = 0;
			        		ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
							PlayNearSound(playerid,1136);
					        SetTimerEx("CantBite",1250,0,"i",playerid);
					        PInfo[i][Resuedsstrength] --;
					        SetPlayerHealth(playerid,health+10);
						}
						if(PInfo[i][Resuedsstrength] == 1)
						{
						    PInfo[i][Resuedsstrength] = 0;
						    DestroyObject(PInfo[i][ResuedObj]);
						    DestroyDynamic3DTextLabel(PInfo[i][ResuedLabel]);
							PInfo[playerid][CanBite] = 0;
			        		ApplyAnimation(playerid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
							PlayNearSound(playerid,1136);
					        SetTimerEx("CantBite",1250,0,"i",playerid);
					        SetPlayerHealth(playerid,health+10);
						}
					}
				}
			}
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
								PlayNearSound(playerid,1136);
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
						foreach(new l: Player)
						{
						    if(PInfo[l][Logged] == 0) continue;
						    if(IsPlayerInRangeOfPoint(l,15,PInfo[i][MeatSX],PInfo[i][MeatSY],PInfo[i][MeatSZ]))
						    	PlayNearSound(l,1136);
						}
						SetTimerEx("CantBite",1000,0,"i",playerid);
						if(PInfo[i][SMeatBite] > 1)
						{
							PInfo[i][SMeatBite] --;
							static strang[155];
							format(strang,sizeof strang,""cred"%s's "cwhite"meat\nClick "cgreen"Right Mouse Button "cwhite"to increase your HP\nBites available "cred"%i "cwhite"/"cgreen" 15",GetPName(i),PInfo[i][SMeatBite]);
							UpdateDynamic3DTextLabelText(PInfo[i][LabelMeatForShare],white,strang);
						}
						else if(PInfo[i][SMeatBite] == 1)
						{
					    	if(Team[i] == ZOMBIE)
					    	{
					    		static string[128];
					    		PInfo[i][SMeatBite] = 0;
								format(string,sizeof string,"* "cjam"%s's meat for share was eaten!",GetPName(i));
								SendClientMessage(i,white,string);
								DestroyObject(PInfo[i][MeatSObject]);
								PInfo[i][ShareMeatVomited] = 0;
								DestroyDynamic3DTextLabel(PInfo[i][LabelMeatForShare]);
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
	if(dialogid == ACHD)
	{
	    if(!response) return 1;
	    new string[256];
	    new progress[64];
	    if(listitem == 0)
		{
		    if(PInfo[playerid][AchievementKills] >= 100)
		    	format(progress, sizeof progress,""cred"Progress "cblue"100"cred"/100");
		    else
			 	format(progress, sizeof progress,""cred"Progress "cblue"%i"cred"/100",PInfo[playerid][AchievementKills]);
			format(string,sizeof string,""cwhite"Kill 100 "cpurple"ZOMBIES\n\n"cred"REWARD: "cgreen"5000 Materials\n\n%s",progress);
			ShowPlayerDialog(playerid,190,DSM,""cgreen"Kill 100 Zombies achievement",string,"Ok","");
		}
  		if(listitem == 1)
  		{
  		    if(PInfo[playerid][AchievementInfect] >= 100)
 		    	format(progress, sizeof progress,""cred"Progress "cblue"100"cred"/100");
			else
  				format(progress, sizeof progress,""cred"Progress "cblue"%i"cred"/100",PInfo[playerid][AchievementInfect]);
            format(string,sizeof string,""cwhite"Infect 100 "cgreen"HUMANS\n\n"cred"REWARD: "cgreen"5000 DNA Points\n\n%s",progress);
	  		ShowPlayerDialog(playerid,190,DSM,""cgreen"Infect 100 Humans achievement",string,"Ok","");
		}
		if(listitem == 2)
		{
  		    if(PInfo[playerid][Achievement50Hours] >= 30)
 		    	format(progress, sizeof progress,""cred"Progress "cblue"30"cred"/30");
			else
  				format(progress, sizeof progress,""cred"Progress "cblue"%i"cred"/30",PInfo[playerid][Achievement50Hours]);
            format(string,sizeof string,""cwhite"Play 30 "cred"REAL"cwhite" hours\n\n"cred"REWARD: "cgreen"2x XP Booster for 20 days\n\n%s",progress);
			ShowPlayerDialog(playerid,190,DSM,""cgreen"Play 30 hours achievement",string,"Ok","");
		}
		if(listitem == 3)
		{
  		    if(PInfo[playerid][AchievementCollect20] >= 20)
 		    	format(progress, sizeof progress,""cred"Progress "cblue"20"cred"/20");
			else
  				format(progress, sizeof progress,""cred"Progress "cblue"%i"cred"/20",PInfo[playerid][AchievementCollect20]);
            format(string,sizeof string,""cwhite"Collect 20 presens\nYou can find them near Checkpoints and around LS\n\n"cred"REWARD: "cgreen"2000 XP\n\n%s",progress);
			ShowPlayerDialog(playerid,190,DSM,""cgreen"Collect 20 presents achievement",string,"Ok","");
		}
		if(listitem == 4)
		{
		    new count;
		    if(PInfo[playerid][AchievementCollect20] >= 20) count ++;
		    if(PInfo[playerid][Achievement50Hours] >= 30) count ++;
		    if(PInfo[playerid][AchievementInfect] >= 100) count ++;
		    if(PInfo[playerid][AchievementKills] >= 100) count ++;
			format(progress, sizeof progress,""cred"Progress "cblue"%i"cred"/4",count);
            format(string,sizeof string,""cwhite"Complete all "cred"NEW YEAR "cwhite"Achievements\n\n"cred"REWARD: "cgold"Gold "cgreen"Premium for 30 days\n\n%s",progress);
			ShowPlayerDialog(playerid,190,DSM,""cgreen"Collect 20 presents achievement",string,"Ok","");
		}
		return 1;
	}
	if(dialogid == ChangeModDialog)
	{
	    if(!response) return 1;
	    new Have1[10],Have2[10],Have3[10],Have4[10],Have5[10],Have6[10],Have7[10],Have8[10],Have9[10],Have10[10],Have11[10];
	    if(PInfo[playerid][GotInsameRage] == 1) Have1 = "{05E200}"; else Have1 = "{FF1111}";
	    if(PInfo[playerid][GotHealingRage] == 1) Have2 = "{05E200}"; else Have2 = "{FF1111}";
	    if(PInfo[playerid][GotMoreRage] == 1) Have3 = "{05E200}"; else Have3 = "{FF1111}";
	    if(PInfo[playerid][GotImperception] == 1) Have4 = "{05E200}"; else Have4 = "{FF1111}";
	    if(PInfo[playerid][GotAccurateDigger] == 1) Have5 = "{05E200}"; else Have5 = "{FF1111}";
	    if(PInfo[playerid][GotDizzyTrap] == 1) Have6 = "{05E200}"; else Have6 = "{FF1111}";
	    if(PInfo[playerid][GotEdibleResidues] == 1) Have7 = "{05E200}"; else Have7 = "{FF1111}";
	    if(PInfo[playerid][GotResuscitation] == 1) Have8 = "{05E200}"; else Have8 = "{FF1111}";
	    if(PInfo[playerid][GotCrowdedStomach] == 1) Have9 = "{05E200}"; else Have9 = "{FF1111}";
	    if(PInfo[playerid][GotRegeneration] == 1) Have10 = "{05E200}"; else Have10 = "{FF1111}";
	    if(PInfo[playerid][GotCollector] == 1) Have11 = "{05E200}"; else Have11 = "{FF1111}";
	    new string[256];
	    format(string,sizeof string,""cgreen"None\n%sInsane Rage\n%sHealing Rage\n%sMore Rage\n%sImperception\n%sAccurate Digger\n%sDizzy Trap\n%sEdible residues\n%sResuscitation\n%sCrowded stomach\n%sRegeneration\n%sCollector",Have1,Have2,Have3,Have4,Have5,Have6,Have7,Have8,Have9,Have10,Have11);
	    if(listitem == 0) ShowPlayerDialog(playerid,131,DSL,""cwhite"1st Slot",string,"Set","Close");
	    if(listitem == 1) ShowPlayerDialog(playerid,132,DSL,""cwhite"2nd Slot",string,"Set","Close");
	    if(listitem == 2) ShowPlayerDialog(playerid,133,DSL,""cwhite"3rd Slot",string,"Set","Close");
		format(string,sizeof string,"* "cpurple"You are edditing "cred"%i "cpurple"slot!",listitem+1);
		SendClientMessage(playerid,white,string);
	    return 1;
	}
	if(dialogid == 131)
	{
	    if(!response) return 1;
     	if(listitem == 0) ShowPlayerDialog(playerid,134,DSM,""cred"None",""cwhite"Sets slot of DNA modification to None","Set","Close");
	    if(listitem == 1) ShowPlayerDialog(playerid,135,DSM,""cgreen"Insane Rage",""cwhite"This rage will let you receive more health in rage mode like with "cred"Healing Rage\n"cwhite"Plus you will receive more rage like with "cred"More Rage\nAlso it have higher damage!","Set","Close");
	    if(listitem == 2) ShowPlayerDialog(playerid,136,DSM,""cgreen"Healing Rage",""cwhite"After biting with rage mode you receive more health","Set","Close");
	    if(listitem == 3) ShowPlayerDialog(playerid,137,DSM,""cgreen"More Rage",""cwhite"You will receive more Rage after biting/dead","Set","Close");
	    if(listitem == 4) ShowPlayerDialog(playerid,138,DSM,""cgreen"Imperception",""cwhite"After using dig you can dig to human,even if there are zombies close","Set","Close");
	    if(listitem == 5) ShowPlayerDialog(playerid,139,DSM,""cgreen"Accurate Digger",""cwhite"You can not only to human, with this modification you can choose place that you want\n"cred"NOTE: need to choose place on MAP to dig to it\nAlso this place mustn't be further than 100 meters","Set","Close");
	    if(listitem == 6) ShowPlayerDialog(playerid,140,DSM,""cgreen"Dizzy Trap",""cwhite"Human will get dizzy again after damaging\nIt gives dizzy every minute","Set","Close");
	    if(listitem == 7) ShowPlayerDialog(playerid,141,DSM,""cgreen"Edible residues",""cwhite"After infecting human from him falls the remnants of food that you can eat\nStay close to his body and click Right Mouse Button to eat it\n"cred"NOTE: Not only you can eat his remains!","Set","Close");
	    if(listitem == 8) ShowPlayerDialog(playerid,142,DSM,""cgreen"Resuscitation",""cwhite"After death you can dig to your last death position\nYou must be close to it within 100 meters","Set","Close");
	    if(listitem == 9) ShowPlayerDialog(playerid,143,DSM,""cgreen"Crowded stomach",""cwhite"After death you will explode\nHumans that close to you will get poisoning, that will damage them\nIt damges for 10 seconds","Set","Close");
	    if(listitem == 10) ShowPlayerDialog(playerid,144,DSM,""cgreen"Regeneration",""cwhite"Your health will regenarate over time\nEvery 10 seconds you receive 5 HP","Set","Close");
	    if(listitem == 11) ShowPlayerDialog(playerid,145,DSM,""cgreen"Collector",""cwhite"You will get more DNA Points\nIt will let you faster collect DNA Points for combining new modifications","Set","Close");
		return 1;
	}
	if(dialogid == 132)
	{
	    if(!response) return 1;
     	if(listitem == 0) ShowPlayerDialog(playerid,146,DSM,""cred"None",""cwhite"Sets slot of DNA modification to None","Set","Close");
	    if(listitem == 1) ShowPlayerDialog(playerid,147,DSM,""cgreen"Insane Rage",""cwhite"This rage will let you receive more health in rage mode like with "cred"Healing Rage\n"cwhite"Plus you will receive more rage like with "cred"More Rage\nAlso it have higher damage!","Set","Close");
	    if(listitem == 2) ShowPlayerDialog(playerid,148,DSM,""cgreen"Healing Rage",""cwhite"After biting with rage mode you receive more health","Set","Close");
	    if(listitem == 3) ShowPlayerDialog(playerid,149,DSM,""cgreen"More Rage",""cwhite"You will receive more Rage after biting/dead","Set","Close");
	    if(listitem == 4) ShowPlayerDialog(playerid,150,DSM,""cgreen"Imperception",""cwhite"After using dig you can dig to human,even if there are zombies close","Set","Close");
	    if(listitem == 5) ShowPlayerDialog(playerid,151,DSM,""cgreen"Accurate Digger",""cwhite"You can not only to human, with this modification you can choose place that you want\n"cred"NOTE: need to choose place on MAP to dig to it\nAlso this place mustn't be further than 100 meters","Set","Close");
	    if(listitem == 6) ShowPlayerDialog(playerid,152,DSM,""cgreen"Dizzy Trap",""cwhite"Human will get dizzy again after damaging\nIt gives dizzy every minute","Set","Close");
	    if(listitem == 7) ShowPlayerDialog(playerid,153,DSM,""cgreen"Edible residues",""cwhite"After infecting human from him falls the remnants of food that you can eat\nStay close to his body and click Right Mouse Button to eat it\n"cred"NOTE: Not only you can eat his remains!","Set","Close");
	    if(listitem == 8) ShowPlayerDialog(playerid,154,DSM,""cgreen"Resuscitation",""cwhite"After death you can dig to your last death position\nYou must be close to it within 100 meters","Set","Close");
	    if(listitem == 9) ShowPlayerDialog(playerid,155,DSM,""cgreen"Crowded stomach",""cwhite"After death you will explode\nHumans that close to you will get poisoning, that will damage them\nIt damges for 10 seconds","Set","Close");
	    if(listitem == 10) ShowPlayerDialog(playerid,156,DSM,""cgreen"Regeneration",""cwhite"Your health will regenarate over time\nEvery 10 seconds you receive 5 HP","Set","Close");
	    if(listitem == 11) ShowPlayerDialog(playerid,157,DSM,""cgreen"Collector",""cwhite"You will get more DNA Points\nIt will let you faster collect DNA Points for combining new modifications","Set","Close");
		return 1;
	}
	if(dialogid == 133)
	{
	    if(!response) return 1;
     	if(listitem == 0) ShowPlayerDialog(playerid,158,DSM,""cred"None",""cwhite"Sets slot of DNA modification to None","Set","Close");
	    if(listitem == 1) ShowPlayerDialog(playerid,159,DSM,""cgreen"Insane Rage",""cwhite"This rage will let you receive more health in rage mode like with "cred"Healing Rage\n"cwhite"Plus you will receive more rage like with "cred"More Rage\nAlso it have higher damage!","Set","Close");
	    if(listitem == 2) ShowPlayerDialog(playerid,160,DSM,""cgreen"Healing Rage",""cwhite"After biting with rage mode you receive more health","Set","Close");
	    if(listitem == 3) ShowPlayerDialog(playerid,161,DSM,""cgreen"More Rage",""cwhite"You will receive more Rage after biting/dead","Set","Close");
	    if(listitem == 4) ShowPlayerDialog(playerid,162,DSM,""cgreen"Imperception",""cwhite"After using dig you can dig to human,even if there are zombies close","Set","Close");
	    if(listitem == 5) ShowPlayerDialog(playerid,163,DSM,""cgreen"Accurate Digger",""cwhite"You can not only to human, with this modification you can choose place that you want\n"cred"NOTE: need to choose place on MAP to dig to it\nAlso this place mustn't be further than 100 meters","Set","Close");
	    if(listitem == 6) ShowPlayerDialog(playerid,164,DSM,""cgreen"Dizzy Trap",""cwhite"Human will get dizzy again after damaging\nIt gives dizzy every minute","Set","Close");
	    if(listitem == 7) ShowPlayerDialog(playerid,165,DSM,""cgreen"Edible residues",""cwhite"After infecting human from him falls the remnants of food that you can eat\nStay close to his body and click Right Mouse Button to eat it\n"cred"NOTE: Not only you can eat his remains!","Set","Close");
	    if(listitem == 8) ShowPlayerDialog(playerid,166,DSM,""cgreen"Resuscitation",""cwhite"After death you can dig to your last death position\nYou must be close to it within 100 meters","Set","Close");
	    if(listitem == 9) ShowPlayerDialog(playerid,167,DSM,""cgreen"Crowded stomach",""cwhite"After death you will explode\nHumans that close to you will get poisoning, that will damage them\nIt damges for 10 seconds","Set","Close");
	    if(listitem == 10) ShowPlayerDialog(playerid,168,DSM,""cgreen"Regeneration",""cwhite"Your health will regenarate over time\nEvery 10 seconds you receive 5 HP","Set","Close");
	    if(listitem == 11) ShowPlayerDialog(playerid,169,DSM,""cgreen"Collector",""cwhite"You will get more DNA Points\nIt will let you faster collect DNA Points for combining new modifications","Set","Close");
		return 1;
	}
	switch(dialogid)
	{
	    case 134..169:
	    {
	        new Modif;
	        if(dialogid == 134 || dialogid == 146 || dialogid == 158) Modif = 0;
	        if(dialogid == 135 || dialogid == 147 || dialogid == 159) Modif = 1;
	        if(dialogid == 136 || dialogid == 148 || dialogid == 160) Modif = 2;
	        if(dialogid == 137 || dialogid == 149 || dialogid == 161) Modif = 3;
	        if(dialogid == 138 || dialogid == 150 || dialogid == 162) Modif = 4;
	        if(dialogid == 139 || dialogid == 151 || dialogid == 163) Modif = 5;
	        if(dialogid == 140 || dialogid == 152 || dialogid == 164) Modif = 6;
	        if(dialogid == 141 || dialogid == 153 || dialogid == 165) Modif = 7;
	        if(dialogid == 142 || dialogid == 154 || dialogid == 166) Modif = 8;
	        if(dialogid == 143 || dialogid == 155 || dialogid == 167) Modif = 9;
	        if(dialogid == 144 || dialogid == 156 || dialogid == 168) Modif = 10;
	        if(dialogid == 145 || dialogid == 157 || dialogid == 169) Modif = 11;
     		if(dialogid >= 134 && dialogid <= 145) ChangePlayerModSlot(playerid,1,Modif);
     		if(dialogid >= 146 && dialogid <= 157) ChangePlayerModSlot(playerid,2,Modif);
     		if(dialogid >= 158 && dialogid <= 169) ChangePlayerModSlot(playerid,3,Modif);
     		return 1;
	    }
	}
	if(dialogid == DNADialog)
	{
	    if(!response) return 1;
	    else
	    {
		    if(listitem == 0) ShowPlayerDialog(playerid,111,DSM,""cgreen"Insane Rage",""cwhite"This rage will let you receive more health in rage mode like with "cred"Healing Rage\n"cwhite"Plus you will receive more rage like with "cred"More Rage\nAlso it have higher damage!","Modify","Close");
		    if(listitem == 1) ShowPlayerDialog(playerid,112,DSM,""cgreen"Healing Rage",""cwhite"After biting with rage mode you receive more health","Modify","Close");
		    if(listitem == 2) ShowPlayerDialog(playerid,113,DSM,""cgreen"More Rage",""cwhite"You will receive more Rage after biting/dead","Modify","Close");
		    if(listitem == 3) ShowPlayerDialog(playerid,114,DSM,""cgreen"Imperception",""cwhite"After using dig you can dig to human,even if there are zombies close","Modify","Close");
		    if(listitem == 4) ShowPlayerDialog(playerid,115,DSM,""cgreen"Accurate Digger",""cwhite"You can not only to human, with this modification you can choose place that you want\n"cred"NOTE: need to choose place on MAP to dig to it\nAlso this place mustn't be further than 100 meters","Modify","Close");
		    if(listitem == 5) ShowPlayerDialog(playerid,116,DSM,""cgreen"Dizzy Trap",""cwhite"Human will get dizzy again after damaging\nIt gives dizzy every minute","Modify","Close");
		    if(listitem == 6) ShowPlayerDialog(playerid,117,DSM,""cgreen"Edible residues",""cwhite"After infecting human from him falls the remnants of food that you can eat\nStay close to his body and click Right Mouse Button to eat it\n"cred"NOTE: Not only you can eat his remains!","Modify","Close");
		    if(listitem == 7) ShowPlayerDialog(playerid,118,DSM,""cgreen"Resuscitation",""cwhite"After death you can dig to your last death position\nYou must be close to it within 100 meters","Modify","Close");
		    if(listitem == 8) ShowPlayerDialog(playerid,119,DSM,""cgreen"Crowded stomach",""cwhite"After death you will explode\nHumans that close to you will get poisoning, that will damage them\nIt damges for 10 seconds","Modify","Close");
		    if(listitem == 9) ShowPlayerDialog(playerid,120,DSM,""cgreen"Regeneration",""cwhite"Your health will regenarate over time\nEvery 10 seconds you receive 5 HP","Modify","Close");
		    if(listitem == 10) ShowPlayerDialog(playerid,121,DSM,""cgreen"Collector",""cwhite"You will get more DNA Points\nIt will let you faster collect DNA Points for combining new modifications","Modify","Close");
		    if(listitem == 11) ShowPlayerDialog(playerid,122,DSM,""cgreen"DNA Stabilizer",""cwhite"After modifying this you wil get more chances for succes DNA modifications\nJust use it once for getting unlimited stabilization","Modify","Close");
	    }
	    return 1;
	}
	if(dialogid == 111) //Insame Rage
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 5000) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotInsameRage] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 50) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 35))
                {
			        PInfo[playerid][GotInsameRage] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 5000;
            }
	    }
	}
	if(dialogid == 112) // Healing Rage
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 1150) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotHealingRage] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 80) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 60))
                {
			        PInfo[playerid][GotHealingRage] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 1150;
            }
	    }
	}
	if(dialogid == 113) // More Rage
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 1500) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotMoreRage] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 60) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 40))
                {
			        PInfo[playerid][GotMoreRage] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 1500;
            }
	    }
	}
	if(dialogid == 114) //Imperception
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 2400) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotImperception] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 65) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 45))
                {
			        PInfo[playerid][GotImperception] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 2400;
            }
	    }
	}
	if(dialogid == 115) // Accurate Digger
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 1800) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotAccurateDigger] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
            else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 85) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 65))
                {
			        PInfo[playerid][GotAccurateDigger] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 1800;
            }
	    }
	}
	if(dialogid == 116) // Dizzy Trap
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 1000) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotDizzyTrap] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 75) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 60))
                {
			        PInfo[playerid][GotDizzyTrap] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 1000;
            }
	    }
	}
	if(dialogid == 117) //Edible residues
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 3200) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotEdibleResidues] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 65) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 45))
                {
			        PInfo[playerid][GotEdibleResidues] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 3200;
            }
	    }
	}
	if(dialogid == 118)// Resuscitation
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 3700) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotResuscitation] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
            else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 45) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 25))
                {
			        PInfo[playerid][GotResuscitation] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 3700;
            }
	    }
	}
	if(dialogid == 119) //Crowded stomach
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 4000) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotCrowdedStomach] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
            else
            {
                new rand = random(1000);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 60) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 40))
                {
			        PInfo[playerid][GotCrowdedStomach] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 4000;
            }
	    }
	}
	if(dialogid == 120) //Regeneration
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 4500) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotRegeneration] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 50) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 30))
                {
			        PInfo[playerid][GotRegeneration] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 4500;
            }
	    }
	}
	if(dialogid == 121) //Collector
	{
	    if(!response) return 1;
	    else
	    {
            if(PInfo[playerid][DNIPoints] < 600) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotCollector] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
           	else
            {
                new rand = random(100);
                if((PInfo[playerid][GotStabilizer] == 1 && rand <= 80) || (PInfo[playerid][GotStabilizer] == 0 && rand <= 60))
                {
			        PInfo[playerid][GotCollector] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
				}
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 600;
            }
	    }
	}
	if(dialogid == 122) //DNA stabilizer
	{
	    if(!response) return 1;
	    else
	    {
	        if(PInfo[playerid][DNIPoints] < 4800) return SendClientMessage(playerid,white,"* "cred"Not enough DNA Points!");
            if(PInfo[playerid][GotStabilizer] == 1) return SendClientMessage(playerid,white,"* "cred"You already have this modifictation!");
			else
			{
			    new rand = random(100);
			    if(rand <= 85)
			    {
			        PInfo[playerid][GotStabilizer] = 1;
			        SendClientMessage(playerid,white,"** "cgreen"The modification was successful, DNA is not destroyed!");
			    }
			    else SendClientMessage(playerid,white,"** "cred"The modification failed, DNA destroyed, DNA Points losted!");
                PInfo[playerid][DNIPoints] -= 4800;
			}
		}
	}
	if(dialogid == CraftDialog)
	{
	    if(!response) return 1;
	    else
		{
			if(listitem == 0) ShowPlayerDialog(playerid,101,DSM,""cgreen"Mine",""cwhite"This mine can be places on the ground\nEvery who step it will be explosed\n"cred"NOTE: Everyone who will be in range will get damage, becareful where you place it!","Craft","Close");
			if(listitem == 1) ShowPlayerDialog(playerid,102,DSM,""cgreen"Molotovs",""cwhite"You can craft molotovs instead of searching it\nAfter crafting you can get up to 3 molotovs, use them wisely!","Craft","Close");
			if(listitem == 2) ShowPlayerDialog(playerid,103,DSM,""cgreen"Sticky Bombs",""cwhite"You can get sticky bombs and detonator for them","Craft","Close");
			if(listitem == 3) ShowPlayerDialog(playerid,104,DSM,""cgreen"Beacon Bullets",""cwhite"After activating that bullets just shoot zombie, he will appear for other humans on radar\nIt will help you to kill zombies if they escape\n"cred"NOTE: It works until zombie die","Craft","Close");
			if(listitem == 4) ShowPlayerDialog(playerid,105,DSM,""cgreen"Impact Bullets",""cwhite"When you shoot humans they will be thrown away\nUseful to use for horde of zombies!","Craft","Close");
			if(listitem == 5) ShowPlayerDialog(playerid,106,DSM,""cgreen"Stinger Bullets",""cwhite"This bullets will stop zombies for a very small period of time\nWill be useful for escape!","Craft","Close");
			if(listitem == 6) ShowPlayerDialog(playerid,107,DSM,""cgreen"Nitro",""cwhite"You can place nitro to your vehicle\nJust stay close to your vehicle to attach nitro to it","Craft","Close");
			if(listitem == 7) ShowPlayerDialog(playerid,108,DSM,""cgreen"Anti-blindness pills",""cwhite"After taking this pills you won't get blind affect from dizzy","Craft","Close");
			if(listitem == 8) ShowPlayerDialog(playerid,109,DSM,""cgreen"Crafting Table",""cwhite"You can craft this table for further conveniences\nYou won't need to go to this crafting table to create items","Craft","Close");
		}
		return 1;
	}
	if(dialogid == 101)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 800) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,0);
			PInfo[playerid][Materials] -= 800;
		}
	}
	if(dialogid == 102)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 1000) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,1);
			PInfo[playerid][Materials] -= 1000;
		}
	}
	if(dialogid == 103)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 2400) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,2);
			PInfo[playerid][Materials] -= 2400;
		}
	}
	if(dialogid == 104)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 1400) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,3);
			PInfo[playerid][Materials] -= 1400;
		}
	}
	if(dialogid == 105)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 1800) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,4);
			PInfo[playerid][Materials] -= 1800;
		}
	}
	if(dialogid == 106)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 2350) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,5);
			PInfo[playerid][Materials] -= 2350;
		}
	}
	if(dialogid == 107)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 2000) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,6);
			PInfo[playerid][Materials] -= 2000;
		}
	}
	if(dialogid == 108)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 400) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,7);
			PInfo[playerid][Materials] -= 400;
		}
	}
	if(dialogid == 109)
	{
	    if(!response) return 1;
	    else
		{
		    if(PInfo[playerid][Materials] < 2800) return SendClientMessage(playerid,red,""cwhite"** "cred"Error: Not enough materials!");
			CraftValue(playerid,8);
			PInfo[playerid][Materials] -= 2800;
		}
	}
    if(dialogid == 13777)
    {
        if(!response) return 1;
        else
        {
            PInfo[playerid][FakePerk] = 1;
            ShowPlayerDialog(playerid,13779,DSM,"Info",""cwhite"Now use "cred"Burst Run"cwhite" to jump to another end of room\nClick "cred"C + Space"cwhite" to use burst run!\n"cred"If you failed this step, jump into the pit to repeat thi step again!","OK","");
			SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Come close to the edge of platform and press "corange"C + SPACE"cwhite" to use "cwhite"Burst run");
			SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"If you failed this step, fall into the pit and try step again");
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
		        SetActorFacingAngle(Jason[playerid],89.4828);
		        SetActorPos(Jason[playerid],307.1434,2504.6030,16.4844);
		        SetActorVirtualWorld(Jason[playerid],GetPlayerVirtualWorld(playerid));
		        SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Enter next pickup to continue");
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
            SaveStats(playerid);
            if(PInfo[playerid][Firstspawn] == 0)
				SpawnPlayer(playerid);
		}
		else
		{
		    SetPlayerVirtualWorld(playerid,playerid+2000);
		    if(PInfo[playerid][Training] == 1)
		    {
			    if(PInfo[playerid][TrainingPhase] < 9 )
			    {
			        Team[playerid] = HUMAN;
			        SpawnPlayer(playerid);
			    	PInfo[playerid][TrainingPhase] = 1;
				}
				if(PInfo[playerid][TrainingPhase] >= 9)
				{
			        Team[playerid] = ZOMBIE;
			        SpawnPlayer(playerid);
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
				GivePlayerWeapon(playerid,7,1);
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
				GivePlayerWeapon(playerid,6,1);
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
				GivePlayerWeapon(playerid,5,1);
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
				GivePlayerWeapon(playerid,4,1);
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
				GivePlayerWeapon(playerid,3,1);
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
				GivePlayerWeapon(playerid,8,1);
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
				GivePlayerWeapon(playerid,9,1);
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
			if(IsPlayerInAnyVehicle(playerid))
		    	SetTimerEx("SetWeapon",400,false,"i",playerid);
  			SendClientMessage(playerid,white,"** "corange"You have successfully changed your weapons!");
		}
		return 0;
	}
	if(dialogid == 1100)
    {
		if(response)
		{
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
	if(dialogid == AdminHelp)
	{
	    if(!response) return 0;
	    if(listitem == 0)
	    {
	        new string[1000];
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
	        strcat(string,"\n"cred"/Ans "cwhite"- Send admin message to player");
	        ShowPlayerDialog(playerid,1831,DSM,""cwhite"Trial Admin",string,"Back","Close");
		}
	    if(listitem == 1)
	    {
     		new string[468];
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
    		new string[420];
	        format(string,sizeof string,""cred"/Heal "cwhite"- Heal player");
	        strcat(string,"\n"cred"/SetHealth "cwhite"- Sets the number of HP entered for the player");
	        strcat(string,"\n"cred"/Nuke "cwhite"- Just explode player, useful for GM test");
	        strcat(string,"\n"cred"/Ban "cwhite"- Ban player from the server");
	        strcat(string,"\n"cred"/Put "cwhite"- Teleport player to player");
	        ShowPlayerDialog(playerid,1831,DSM,""cjam"General Admin",string,"Back","Close");
		}
	    if(listitem == 3)
	    {
    		new string[530];
	        format(string,sizeof string,""cred"/Killrandom "cwhite"- Deactivate random set on the server");
	        strcat(string,"\n"cred"/GetIP "cwhite"- Get Player's IP");
	        strcat(string,"\n"cred"/BanIP "cwhite"- Drop IP into blacklist");
	        strcat(string,"\n"cred"/BanOff "cwhite"- Ban offline player");
	        strcat(string,"\n"cred"/SBan "cwhite"- Quietly ban player");
	        strcat(string,"\n"cred"/SKick "cwhite"- Quietly kick player");
	        strcat(string,"\n"cred"/UnBan "cwhite"- UnBan Player");
	        strcat(string,"\n"cred"/TPEvery "cwhite"- Teleport everyone to your position");
	        strcat(string,"\n"cred"/Announce "cwhite"- Make announce in the middle of the screen");
	        strcat(string,"\n"cred"/CanVote "cwhite"- Enable/Disable voting on server ("cred"USE IT ONLY WITH PERMISSION OF HIGHER ADMIN!"cwhite")");
            strcat(string,"\n"cred"/EnableSupply "cwhite"- Enable/Disable supply containers on server ("cred"USE IT ONLY WITH PERMISSION OF HIGHER ADMIN!"cwhite")");
            strcat(string,"\n"cred"/DoRandomSet "cwhite"- Starts random set on server ("cred"recommended use if there are no zombies and AutoRandom is disabled!"cwhite")");
			ShowPlayerDialog(playerid,1831,DSM,""cgreen"Lead Admin",string,"Back","Close");
		}
	    if(listitem == 4)
	    {
    		new string[500];
	        format(string,sizeof string,""cred"/RestartServer "cwhite"- Restart Server");
	        strcat(string,"\n"cred"/SetXP "cwhite"- Set player's XP");
	        strcat(string,"\n"cred"/SetRank "cwhite"- Set player's Rank");
	        strcat(string,"\n"cred"/SetZMoney "cwhite"- Set player's ZMoney");
	        strcat(string,"\n"cred"/SetKills "cwhite"- Set player's Kills");
	        strcat(string,"\n"cred"/SetDeaths "cwhite"- Set player's Deaths");
	        strcat(string,"\n"cred"/SetInfects "cwhite"- Set player's Infects");
	        strcat(string,"\n"cred"/ExtraXP "cwhite"- Set server's XP multiplier");
	        strcat(string,"\n"cred"/EnableAntiCheat "cwhite"- Enable/Disable anticheat");
	        strcat(string,"\n"cred"/FakeMessage "cwhite"- Send fake message");
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
	if(dialogid == 1002)
	{
		if(response) //???????: ???? ?? ?????? ?????? ??????
		{
            ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
		}
		else //???????: ???? ?? ?????? ?????? ??????
		{
			return 1;
		}
		return 1;
 	}
	if(dialogid == 1003)
	{
	    new string[2048];
        if(!response) return 0;
        if(listitem == 0)
        {
       		format(string,sizeof string,""cwhite""dred"Los Santos Apocalypse"cwhite" is a survival TDM (Team Death Match) mode with 2 teams! \nThere are 2 teams: "cgreen"Survivors "cwhite"and "cpurple"Zombies\n"cwhite"Goal of "cpurple"zombies "cwhite"is infect every "cgreen"human"cwhite" and don't let them clear all "cred"8 Checkpoints!");
			strcat(string,""cwhite"\nThe main goal of "cgreen"suvivors "cwhite"is clear all checkpoints");
            strcat(string,""cwhite"\nBoth teams have their own features that help defeat opposite team");
            strcat(string,""cwhite"\nIt is required to play as team, you won't beat enemy without support of your teammates\nSo killing your teammates is NOT allowed\nIf you do that you will lost XP or will be jailed!");
            strcat(string,""cwhite"\nWhen one of the team completes goal the round restarts");
            strcat(string,""cwhite"\nThen players are able to change their team again");
            strcat(string,""cwhite"\n"cred"Note: "cwhite"you can't change your team after spawn\nFor changing your team you need wait for the round end\nAlso if there is 70+ infection, or 5+ checkpoints cleared your team will be automatically setted to zombie!");
            ShowPlayerDialog(playerid,1002,DSM,"Main Info",string,"Back","Close");
        }
        if(listitem == 1)
        {
            format(string,sizeof string,""cwhite"You rank up by getting required amount of XP\nWhen you rank up, XP, that needed for new rank increases too");
            strcat(string,""cwhite"\nAlso with increasing your rank you get more useful perks, weapons for humans and maximum HP for zombies");
            strcat(string,""cwhite"\nYou receive XP by killing/infecting players from opposite team, assisting and clearing checkpoints (for humans)");
    		ShowPlayerDialog(playerid,1002,DSM,"Ranks",string,"Back","Close");
		}
        if(listitem == 2)
        {
            format(string,sizeof string,""cwhite"Perks are special abilities that gives advantage over the enemy");
            strcat(string,""cwhite"\nPress "cred"Y "cwhite"to open perks' list\nPerks are availabled for both teams\nEvery time when you rank up, you get perks, first perks you get on 2nd rank!");
            strcat(string,""cwhite"\nNote: You can use only one perk at time\nEvery perk can be useful in different situations");
    		ShowPlayerDialog(playerid,1002,DSM,"Ranks",string,"Back","Close");
		}
        if(listitem == 3)
        {
            format(string,sizeof string,""cwhite"Groups are very useful when you play with your friends");
            strcat(string,""cwhite"\nIt have many advantages like increased XP for assisting and see your groupmates on radar");
            strcat(string,""cwhite"\nAnd also it have group private chat "cred"/gc");
            strcat(string,""cwhite"\nFor creating group use "cred"/groupcreate [Name of group]");
            strcat(string,""cwhite"\nAfter creating you will become leader of group, so you are able to invite others to group!");
            strcat(string,""cwhite"\nUse "cred"/groupinvite [ID]"cwhite" to invite your friend(s), you can't add player to your group if he is already in group!");
            strcat(string,""cwhite"\nYou can't add more than 10 players yo your group, so keep it in mind when you invite many people to group!");
            strcat(string,""cwhite"\nFor removing member use "cred"/delgmate [ID]"cwhite" for checking count of members use "cred"/groupmates");
			ShowPlayerDialog(playerid,1002,DSM,"Groups",string,"Back","Close");
		}
        return 1;
	}
	if(dialogid == 1004)
	{
	    new string[2048];
	    if(listitem == 0)
	    {
			format(string, sizeof string,""cwhite"Main goal of "cgreen"Survivors"cwhite" is clear all 8 "cred"Checkpoints"cwhite". If they manage to do, so they win the round.\n"cgreen"Survivors"cwhite" can get XP by killing "cpurple"Zombies"cwhite" or clearing "cred"Checkpoints");
			strcat(string,""cwhite"\nAlso "cgreen"Survivors"cwhite" have an inventory (pressing "cred"N"cwhite"). \nIt will help them survive out there. \nOnce they've used their items, they can loot for more in opened interiors or search around or find loot boxes around the LS");
			strcat(string,""cwhite"\nHumans can't avoid Checkpoints, it is their main goal. \nWhen CP appears every human must reach it not later than 5 minutes\nIf you do that you will be warned for every zombie and also appear in their radar, so they can find you easily");
			strcat(string,""cwhite"\nWhen humans clear all Checkpoints they win the round\nFor extra support there are perks, each perk can be unlocked by ranking up, as higher your rank as more useful perk you get\nOf course humans have weapons unlike zombies\n"cred"BUT"cwhite" dont think that it will be easy to kill them");
			strcat(string,""cwhite"\nIf zombie with higher rank is come closer to you, you have low chances to survive, so you need to jump on objects and keep their distance");
			strcat(string,""cwhite"\nBecause zombies are much more powerful when they are biting\nAlso if you run away from zombies you aren't allowed to use BHOP (BunnyHop) to gain speed it is against the rules and you can be punished for that");
			strcat(string,""cwhite"\nYou receive new weapons each 5 rank, as higher ranks as more powerful weapons you get");
			ShowPlayerDialog(playerid,1002,DSM,"Main Info",string,"Back","Close");
		}
	    if(listitem == 1)
	    {
			format(string, sizeof string,""cwhite"Survivors have inventory "cred"Press Y"cwhite" to open it");
			strcat(string,""cwhite"\nHere you can see medical kits, fuel, oil, flashlight");
			strcat(string,""cwhite"\nMedical kits increases your HP, fuel and oil fill your vehicle and flashlight, that let you see zombies on radar for 1 minute");
            strcat(string,""cwhite"\nThat is not all items that are available, for more items you can loot\nIf you want to loot enter any interior, in most of interiors you can loot\nIn interior you need to find white arror and click "cred"CROUCH KEY"cwhite" to loot");
            strcat(string,""cwhite"\nIn looting you can find items that you can see in inventory, also you can find dizzy away pills, molotovs guide, materials and ammo for weapons");
            strcat(string,""cwhite"\nDizzy away pills remove dizzy effect, molotovs guide is the mission which by completing it you get 3 molotovs, materials that are needed for crafting");
            strcat(string,""cwhite"\nIf you want to share your item with another human, you need to aim at human, who you want to give item, "cred"with your fist"cwhite"\nAnd click "cred"SPACE + ALT"cwhite", then choose item that you want to give");
	  		ShowPlayerDialog(playerid,1002,DSM,"Inventory",string,"Back","Close");
		}
	    if(listitem == 2)
	    {
			format(string, sizeof string,""cwhite"Survivors have weapons. \nDepending on their rank they get new powerful weapons on each 5 rank\nFor example on 5 rank you get 2 pistols");
			strcat(string,""cwhite"\nAmmo for weapons are not unlimited, so if you waste all of them you can use "cred"/weapons"cwhite" to change weapon or add ammo\n"cred"Note:"cwhite" You can use this command only 1 time!\nFor changin weapons again you need to clear checkpoint");
			strcat(string,""cwhite"\nAlso you can get ammo for weapons by looting in interiors and by entering checkpoint\nAmmo that you receive in the beginning of round depends on your rank too.");
	  		ShowPlayerDialog(playerid,1002,DSM,"Weapons",string,"Back","Close");
		}
	    if(listitem == 3)
	    {
			format(string, sizeof string,""cwhite"Checkpoints are the most useful and necessary for suvivors ");
			strcat(string,""cwhite"\nHere you get ammo, health and XP (after clearing)\nWhile you are staying on checkpoint you receive HP\nFrequency of receiving HP depends on infection percentage, the higher infection, higher frequency");
			strcat(string,""cwhite"\nWhen CP progress reaches 100% you clear checkpoint and then you get XP\nWhen survivors clear 8/8 checkpoints, humans win the round and game restarts");
            strcat(string,""cwhite"\n"cred"Note:"cwhite" If you evade checkpoint you will appear for zombies on radar, so you will get less chances to survive\nIf you evade it too long you will be automatically teleported to it.");
	  		ShowPlayerDialog(playerid,1002,DSM,"Weapons",string,"Back","Close");
		}
		if(listitem == 4)
		{
		    format(string,sizeof string,""cwhite"In ocean docks you can craft some items for extra support (blue skull on radar)");
		    strcat(string,"\n"cwhite"For crafting you need materials, that you can get by looting in interiors or looting in LS docks \n"cred"YOU CAN HAVE MAXIMUM 5000 MATERIALS");
	        strcat(string,"\n"cwhite"For crafting items you need to go to crafting table (LS docks)\nOr you can use craft table in inventory (first need to craft it in crafting table in LS Docks)");
	        strcat(string,"\n"cwhite"Each item have chance and cost, after successful crafting, this items are saved \nEven you exit server they will be available in inventory, except sticky bombs and molotovs");
	        strcat(string,"\n"cwhite"In crafting table you can check info about every item by clicking it in crafting dialog");
            ShowPlayerDialog(playerid,1002,DSM,"Craft system",string,"Back","Close");
		}
		return 1;
	}
	if(dialogid == 1005)
	{
	    new string[2048];
	    if(listitem == 0)
	    {
		    format(string,sizeof string,""cwhite"The main goal of "cpurple"Zombies"cwhite" is infecting all "cgreen"Humans"cwhite" and don't let them clear all the 8 "cred"Checkpoints"cwhite".");
		    strcat(string,""cwhite"\n"cpurple"Zombies"cwhite" are faster than "cgreen"Humans");
			strcat(string,""cwhite"\nFor infecting zombies must use biting system. For biting you must click "cred"Right Mouse Button"cwhite", in vehicle click "cred"Space"cwhite"");
			strcat(string,""cwhite"\nZombies doesn't have weapons, vehicles and inventory. \nInstead you must be mobile and don't let humans get into you, keep them close to you to do bites, that won't them shoot you while you are biting");
            strcat(string,""cwhite"\nIf you are alone you can use hide "cred"/hide"cwhite", for hiding in humans' vehicles\nGet in the car as passenger and use /hide (for unhide use /hide again)");
            strcat(string,""cwhite"\nAfter death you spawn in hive, there you can full your HP and teleport to the most places on LS\nAlso "dred"T"cwhite" on radar shows you where you can teleport too");
            strcat(string,""cwhite"\nInstead of iventory zombies have "corange"RAGE"cwhite". You can get it by biting, dying. When you receive 100 RAGE activate it by pressing"cred" N");
            strcat(string,""cwhite"\nDepending on your rank, your maximum health and health after spawn increases");
			ShowPlayerDialog(playerid,1002,DSM,"Main Info",string,"Back","Close");
		}
		if(listitem == 1)
		{
		    format(string,sizeof string,""cwhite"If you spawn as zombie in beginning of the round, you spawn near humans\nBut if you spawn later you will spawn in hive");
            strcat(string,""cwhite"\nHive is the place where zombies spawn after death, here you can heal your HP, enter abandoned laboratory (DNA modification system)\nAnd teleport close to checkpoint");
            strcat(string,""cwhite"\nHive is not only place from where you can teleport, in LS find letter T on radar, that are places for teleporting\nFrom them you can teleport to another places in LS, also you can teleport to hive");
            ShowPlayerDialog(playerid,1002,DSM,"Hive and teleports",string,"Back","Close");
		}
		if(listitem == 2)
		{
		    format(string,sizeof string,""cwhite"Biting system is the most important for zombies, with that you can faster infect humans (much faster than fists)\nFor biting click "cred"Right Mouse Button"cwhite"\nFor biting you must to stay close to human that you want to bite and click Right mouse button as much as you can");
		    strcat(string,""cwhite"\nThe faster you click, more bites you can do\nIf you are sitting in vehicle click "cred"SPACE"cwhite" to bite\nAlso with biting you increase your HP");
		    ShowPlayerDialog(playerid,1002,DSM,"Biting",string,"Back","Close");
		}
		if(listitem == 3)
		{
		    format(string,sizeof string,""cwhite"Rage is ability that let you damage much more than usual\nRage time depends on you rank, higher your rank, lower rage time\nYou receive rage by biting humans and dying\nWhen rage reaches 100%, press "cred"N"cwhite" to activate rage mode");
            strcat(string,""cwhite"\nYou can disable rage mode by pressing "cred"N "cwhite"again");
			ShowPlayerDialog(playerid,1002,DSM,"Rage",string,"Back","Close");
		}
		if(listitem == 4)
		{
		    format(string,sizeof string,""cwhite"Hiding system let you hide in vehicle on passenger seat\nUse command "cred"/hide"cwhite" to hide");
            strcat(string,""cwhite"\nHiding useful when you are alone and want to make surprise to human that is sitting in vehicle");
            strcat(string,""cwhite"\nWhen you are hiding, humans can't see you, even if they use their flashlights");
			ShowPlayerDialog(playerid,1002,DSM,"Hiding",string,"Back","Close");
		}
		if(listitem == 5)
		{
		    format(string,sizeof string,""cwhite"In abandoned laboratory (find it in hive) you can create DNA Modifications ");
		    strcat(string,"\n"cwhite"This Modifications let you use some perks and abilities with more features");
	        strcat(string,"\n"cwhite"For Combining modifications you need DNA Points\nYou can get them by biting humans and infecting them "cred"YOU CAN MAXIMUM HAVE 5000 DNA POINTS");
	        strcat(string,"\n"cwhite"After getting DNA Points you need to enter special machine (in the corner of laboratory) to spend them");
	        strcat(string,"\n"cwhite"Each modification have instability and cost\nAs higher instability as lower chance you have to combine modification");
	        strcat(string,"\n"cwhite"You can decrease instability by combining DNA Stabilizer");
	        strcat(string,"\n"cwhite"You can check information about all modifications by clicking them in "cred"Combining Dialog");
	        strcat(string,"\n"cwhite"After successful combining you can use it by putting them into slot of modifications");
			strcat(string,"\n"cwhite"You can change slots by using command"cred"/ChangeMod \nNOTE: You can change modification limited times depending on your rank");
			strcat(string,"\n"cwhite""cred"From 1 to 14 - 1 time, From 15 to 29 - 2 times, From 30 and higher - 3 times");
		    ShowPlayerDialog(playerid,1002,DSM,"DNA Modifications",string,"Back","Close");
		}
		return 1;
	}
	if(dialogid == 1000)
	{
	    new string[2048];
	    if(!response) return 0;
		if(listitem == 0) 
		{
  			ShowPlayerDialog(playerid,1003,DSL,"Game Mode",""cwhite"Main info\nRanks\nPerks\nGroups","Choose","Close");
			return 1;
		}
		if(listitem == 1) 
		{
			ShowPlayerDialog(playerid,1004,DSL,"Survivors", ""cwhite"Main Info\nIntentory and looting\nWeapons\nCheckpoints\nCraft System","Back","Close");
			return 1;
		}
		if(listitem == 2) 
		{
			ShowPlayerDialog(playerid,1005,DSL,"Zombies",""cwhite"Main Info\nHive and teleports\nBiting\nRage\nHiding\nDNA Modifications","Back","Close");
			return 1;
		}
		if(listitem == 3) 
		{
		    format(string,sizeof string,""corange"There are not allowed: \n1-Using all kinds of hacks (Cleo, Sobeit and etc.) that destroy the gameplay");
		    strcat(string,""corange"\n2-Killing your teammates, you must know that it is a TDM server and you should work in team!");
            strcat(string,""corange"\n3-Using BHop (bunnyhop, BH) for gaining speed, you should be mobility, if you want to run from zombie (jump on building, high objects and etc)");
            strcat(string,""corange"\n4-Using bugs is not allowed too, if you found it, you should tell it about to online adminstrators or in our main forum "cblue"ug-ultimategaming.proboards.com");
            strcat(string,""corange"\n5-Insulting anyone in any form, you must respect others on server!");
            strcat(string,""corange"\n"cred"P.S. Respect administrators, they keep the gameplay clean and make everything to make your game on server more comfortable and interesting!\nDont break rules, if you don't want to get ban or another kind of punishment!\n\n "cblue"For more info check our forum: ug-ultimategaming.proboards.com");
			ShowPlayerDialog(playerid,1002,DSM,"Rules",string,"Back","Close");
			return 1;
		}
		if(listitem == 4) 
		{
		    format(string,sizeof string,""corange"General commands:");
		    strcat(string,""corange"\n\t"cred"Key Y"cwhite" - Open perks list");
            strcat(string,""corange"\n\t"cred"/report [ID] [Reason]"cwhite" - Send report to online admins");
            strcat(string,""corange"\n\t"cred"/pm [ID] [Message]"cwhite" - Send private message");
            strcat(string,""corange"\n\t"cred"/tpm [Message]"cwhite" - Send private message to your team");
            strcat(string,""corange"\n\t"cred"/l [Message]"cwhite" - Local area chat");
            strcat(string,""corange"\n\t"cred"/me [Action]"cwhite" - Player expressive command (Player Action)");
            strcat(string,""corange"\n\t"cred"/shop"cwhite" - Show server's donation services");
            strcat(string,""corange"\n\t"cred"/admins"cwhite" - Check online admins");
            strcat(string,""corange"\n\t"cred"/AFK"cwhite" - Let you go AFK");
            strcat(string,""corange"\n\t"cred"/VoteKick [ID] [Reason]"cwhite" - Starts voting for kicking playerid");
            strcat(string,""corange"\n"cgreen"Survivor Commands:");
            strcat(string,""corange"\n\t"cred"/weapons"cwhite" - Set another earned weapons");
            strcat(string,""corange"\n"dred"Group Commands:");
            strcat(string,""corange"\n\t"cred"/groupcreate [Group Name]"cwhite" - Create a group");
            strcat(string,""corange"\n\t"cred"/groups "cwhite" - Check list of created groups");
            strcat(string,""corange"\n\t"cred"/groupjoin"cwhite" - Joins the group that you have been invited to");
            strcat(string,""corange"\n\t"cred"/groupmates"cwhite" - Check number of players in your group");
            strcat(string,""corange"\n\t"cred"/groupinvite [ID]"cwhite" - Invite player to your group (only for leaders)");
            strcat(string,""corange"\n\t"cred"/delgmate [ID]"cwhite" - Kick player from your group (only for leaders)");
            strcat(string,""corange"\n\t"cred"/gc"cwhite" - Talk to your groupmates");
            strcat(string,""corange"\n"cpurple"Zombie Commands:");
            strcat(string,""corange"\n\t"cred"/hide"cwhite" - Allows zombie to hide on the passenger seat of vehicle");
            strcat(string,""corange"\n"cgold"Premium Member's Commands:");
            strcat(string,""corange"\n\t"cred"/setperk [Team] [Perk ID] - /setSskin [Skin ID] - /setZskin [Skin ID]");
			ShowPlayerDialog(playerid,1002,DSM,"Commands",string,"Back","Close");
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
			ShowPlayerDialog(playerid,Refreshingbitedialog,0,""cred"Refreshing BiTE",""cwhite"Biting humans with this perk will grant you more HP","Set","Cancel");
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
			ShowPlayerDialog(playerid,Screamerdialog,0,""cred"Screamer",""cwhite"When you press "cred"RMB"cwhite", instead of biting, you will scream\nWhen you scream, everyone human near you will get damaged and thrown away","Set","Close");
        }
        if(listitem == 9)
        {
			ShowPlayerDialog(playerid,ZBurstrundialog,0,""cred"Burst run",""cwhite"This perk works like Burst Run for humans without any changes\nPress"cred" C + Space"cwhite" to use","Set","Close");
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
			ShowPlayerDialog(playerid,Stompdialog,0,""cred"Stomp",""cwhite"When activated, every human in range of 10 meters will get stomping effect. \nIt works 5 seconds, press "cred"CROUCH"cwhite" to send a powerful earthquake\n"cred"NOTE: Cool down of 2 minutes.","Set","Close");
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
			ShowPlayerDialog(playerid,Ravagingbitedialog,0,""cred"Ravaging Bite",""cwhite"It is the most powerful zombie bite perk at the moment \nWhen you bite a human, you do the same amount of damage with Hard Bite and you get healed with the same amount as Refreshing bite. \n"cred"NOTE: -10HP of damage on a victim and +6HP to you.","Set","Close");
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
			ShowPlayerDialog(playerid,Refreshingbitedialog2,0,""cred"Extra Refreshing Bite",""cwhite"This perk is as same as \"Refreshing Bite\" but instead \nOn each Bite you will receive "cred"+9 HP!","Set","Close");
        }
		if(listitem == 22)
        {
			ShowPlayerDialog(playerid,60,0,""cred"God Sense",""cwhite"When you activate this perk, you will see everyone all around the map. \n"cred"NOTE: if player is not in the same interior with you, you won't see him on radar","Set","Close");
        }
        if(listitem == 23)
        {
        	ShowPlayerDialog(playerid,61,0,""cred"Blind Bite",""cwhite"Biting humans using this perk will make him blind, this effect disappears 2 seconds after the bite\n"cred"You can flash human every 6 seconds","Set","Close");
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
		    ShowPlayerDialog(playerid,64,0,""cred"Powerful Digger",""cwhite"This type of digger has more features like faster teleportation\nAfter digging human will be stomped\nIf human is in vehicle, his vehicle's engine will stop working.\n"cred"Use key CROUCH to dig","Set","Close");
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
		    ShowPlayerDialog(playerid,67,0,""cred"Toxic Bite",""cwhite"Upon biting humans using this perk will poison them, the toxin will damage them for 30 seconds\nAnd also it will effect humans with extra effects like dizzy, convulsions and partial blindness\nBut you need to eat another player's vomit, who have the same rank or higher rank than yours\nAfter biting it, you could bite 3 time with this toxin\n"cred"Just bite human with this perk to inject toxin into human","Set","Close");
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
	        ShowPlayerDialog(playerid,Extramedsdialog,0,""cred"Extra meds",""cwhite"When you use any med kits from your inventory, you will got extra "cred"10 HP\nTIP: Press N to open your inventory","Set","Cancel");
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
	        ShowPlayerDialog(playerid,Flashbangsdialog,0,""cred"Flashbangs",""cwhite"When you enter a checkpoint, you receive +3 flashbangs.\nWhen your throw flashbang, everyone in radius of 20 meters will get blindness effect\n"cred"Press CROUCH + WALK to throw flashbang\nNOTE: As the longer you press CROUCH + WALK, farther the flashbang will be thrown","Set","Cancel");
	    }
	    if(listitem == 5)
	    {
	        ShowPlayerDialog(playerid,Lessbitedialog,0,""cred"Less Bite Damage",""cwhite"When a zombie bites, you will take less damage\n"cred"This perk will not work when zombies are using perks such as \""cred"Screamer\" or \""cred"Hard Punch\""cwhite"!","Set","Cancel");
	    }
	    if(listitem == 6)
	    {
	        ShowPlayerDialog(playerid,Burstdialog,0,""cred"Burst Run",""cwhite"This perk gives you a quick burst of energy. It should be useful to get away from zombies on foot.\nOnce you can use it you must wait 3 minutes before using it again.\nWhen this perk is set press keys "cred"C + Space"cwhite" to activate. ","Set","Cancel");
	    }
	    if(listitem == 7)
	    {
	        ShowPlayerDialog(playerid,Medicdialog,0,""cred"Double support",""cwhite"Military can trust you and gives extra ammo\nActivate this perk before you enter CP\n"cred"NOTE: You will receive 2X more ammo than usual\nAlso if you activate this perk before you select team, you get extra ammo too!","Set","Cancel");
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
	        ShowPlayerDialog(playerid,Fielddoctordialog,0,""cred"-",""cwhite"Comming soon!","Set","Cancel");
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
	        ShowPlayerDialog(playerid,UltimateExtraMeds,0,""cred"Ultimate Extra Meds",""cwhite"Your meds have unusual structure\nAnd with this structure med kits will give you extra +"cred"15 HP","Set","Cancel");
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
			new MaxOnline;
			new OnlineNow;
			foreach(new i: Player)
			{
			    if(PInfo[i][Logged] == 0) continue;
			    OnlineNow++;
			}
			INI_Open("Admin/Config/ServerConfig.ini");
			MaxOnline = INI_ReadInt("MaxOnline");
			if(OnlineNow > MaxOnline)
			{
			    INI_WriteInt("MaxOnline",OnlineNow);
			    INI_Save();
			    INI_Close();
			}
			INI_Close();
			SendFMessage(playerid,white,"|| "cgreen"Welcome back, %s!",GetPName(playerid));
			LoadStats(playerid);
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
			if(PInfo[playerid][Training] == 1)
			{
   				ShowPlayerDialog(playerid,999,DSM,"Training course",""cwhite"You didn't passed training course!\nDo you want to continue?", "Yes","No");
			}
			INI_Open(file);
 			if(INI_ReadInt("OldAccount") == 0)
 			{
 			    new ftime = gettime();
 			    PInfo[playerid][Rank] = 5;
 			    PInfo[playerid][XP] = 0;
 			    CheckRankup(playerid);
 			    SetPlayerScore(playerid,5);
        		INI_WriteInt("NewRegExtraXP",1);
    			INI_WriteInt("NewRegExtraXPTime",ftime + (604800*2));
 			    INI_WriteInt("OldAccount",1);
	     		PInfo[playerid][NewRegExtraXP] = 1;
 				PInfo[playerid][NewRegExtraXPTime] = ftime + (604800*2);
				SendClientMessage(playerid,red,""cwhite"*** "cgold"You've got compensation for resetting accounts!");
				SendClientMessage(playerid,red,""cwhite"*** "cgold"You rank was setted to 5 and you got 2X XP for 2 weeks!");
 			}
 			INI_Save();
			INI_Close();
			PInfo[playerid][Logged] = 1;
			PInfo[playerid][Failedlogins] = 0;
			if(PInfo[playerid][Premium] == 1)
			    SendFMessage(playerid,white,"* "cgold"Thanks for supporting our community, Gold member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 2)
			    SendFMessage(playerid,white,"* "cplat"Thanks for supporting our community, Platinum member %s!",GetPName(playerid));
			if(PInfo[playerid][Premium] == 3)
			    SendFMessage(playerid,white,"* "cblue"Thanks for supporting our community, Diamond member %s!",GetPName(playerid));
			new infects;
		    foreach(new i: Player)
	    	{
	    		if(PInfo[i][Firstspawn] == 1) continue;
	    		if(PInfo[i][Logged] == 0) continue;
	    		if(PInfo[i][Training] == 1) continue;
	    		if(PInfo[i][Jailed] == 1) continue;
	    		if(PInfo[i][Afk] == 1) continue;
	    		if(Team[i] == ZOMBIE) infects++;
			}
			if(PInfo[playerid][Training] == 0)
			{
			    if(floatround(100.0 * floatdiv(infects, PlayersConnected)) >= 70)
			    {
					Team[playerid] = ZOMBIE;
	       	        new RandomGS = random(sizeof(gRandomSkin));
	        		SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
	        		PInfo[playerid][SkipRequestClass] = 1;
	        		PInfo[playerid][Skin] = gRandomSkin[RandomGS];
				    SetSpawnInfo(playerid,1,GetPlayerSkin(playerid),0,0,0,0,0,0,0,0,0,0);
					SpawnPlayer(playerid);
					SendClientMessage(playerid,white,""cred"Zombie team has over 70\% of the server infected, help them win, kill the last survivors!");
					SendClientMessage(playerid,white,"** "cred"Autobalance: "cwhite"Zombie's team was autobalanced!");
					return 1;
			    }
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
			}
			if(Team[playerid] != 0 && PInfo[playerid][Training] == 0)
			{

			    if(Team[playerid] == ZOMBIE)
				{
   					SendClientMessage(playerid, white, ""cwhite"** "cred"GameMode Detected your team: You were automatically setted to your previous team");
                    Team[playerid] = ZOMBIE;
           	        new RandomGS = random(sizeof(gRandomSkin));
	        		SetPlayerSkin(playerid,gRandomSkin[RandomGS]);
	        		PInfo[playerid][Skin] = gRandomSkin[RandomGS];
				    SetSpawnInfo(playerid,1,RandomGS,0,0,0,0,0,0,0,0,0,0);
				    SpawnPlayer(playerid);
				    SetPlayerHealth(playerid,100);
				    PInfo[playerid][SkipRequestClass] = 1;
				    return 1;
				}
			  	else if(Team[playerid] == HUMAN)
				{
					SendClientMessage(playerid, white, ""cwhite"** "cred"GameMode Detected your team: You were automatically setted to your previous team");
				    Team[playerid] = HUMAN;
				    static sid;
					ChooseSkin: sid = random(299);
					sid = random(299);
					for(new i = 0; i < sizeof(ZombieSkins); i++)
					{
						if(sid == ZombieSkins[i]) goto ChooseSkin;
					}
					if(sid == 0 || sid == 74 || sid == 99 || sid == 92) goto ChooseSkin;
				    PInfo[playerid][Skin] = sid;
				    SetSpawnInfo(playerid,1,PInfo[playerid][Skin],0,0,0,0,0,0,0,0,0,0);
				    SpawnPlayer(playerid);
				    PInfo[playerid][JustInfected] = 0;
				    PInfo[playerid][Infected] = 0;
					PInfo[playerid][Dead] = 0;
					SetPlayerHealth(playerid,100);
					PInfo[playerid][SkipRequestClass] = 1;
					return 1;
				}
			}
			PInfo[playerid][TeamChooseTimer] = SetTimerEx("RemoveIgnore",75000,false,"i",playerid);
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
			strcat(string,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.55");
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
		}
		return 1;
	}
	if(dialogid == ShopDialog)
	{
		if(!response) return 0;
	    if(listitem == 0)
	    {
			static string[575];
			format(string,sizeof string,""cwhite"In our official website you can get some donate \"ZMoney\" \n");
			strcat(string,"\nWith ZMoney you can buy some useful things that can help you with many things, or just diversifies the game \n");
			strcat(string,"\nFor example: if you buy "cplat"Platinum"cwhite" premium, you will get extra xp for killing or infecting, more info you can check by clicking on it \n");
			strcat(string,"\nFor more info check our forum "cblue"ug-ultimategaming.proboards.com"cwhite" there you will find guide how to donate \n");
			strcat(string,"\nSo, Good Luck And Have FUN!!!");
			ShowPlayerDialog(playerid,1154,0,"FAQ",string,"Back","Close");
		}
		if(listitem == 1)
		{
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
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
            ShowPlayerDialog(playerid,1157,0,""cgold"Gold Premium",""cwhite"After purchasing you will get \n8 of every item in inventory\nCommands: "cred"/setperk /setSskin /setZskin\n"cwhite"\n\n"cwhite"Are you sure that you want buy"cgold"Gold Premium?","Buy","Back");
        }
        if(listitem == 1)
        {
            ShowPlayerDialog(playerid,1158,0,""cplat"Platinum Premium",""cwhite"After purchasing you will get \n13 of every item in inventory\nYou will spawn in special "cplat"Platinum"cwhite" Spawn\nCommands: "cred"/setperk /setSskin /setZskin\n"cwhite"Extra ammo after reaching CP\n\n"cwhite"Are you sure that you want to buy "cplat"Platinum Premium?","Buy","Back");
        }
        if(listitem == 2)
        {
            ShowPlayerDialog(playerid,1161,0,""cblue"Diamond Premium",""cwhite"After purchasing you will get \n18 of every item in inventory\nYou will spawn in special "cblue"Diamond"cwhite" Spawn\nDecreased cooldown for perks\nCommands: "cred"/setperk /setSskin /setZskin\n"cwhite"Extra ammo after reaching CP\n\n"cwhite"Are you sure that you want to buy "cblue"Diamond Premium?","Buy","Back");
        }
        if(listitem == 3)
        {
            ShowPlayerDialog(playerid,1159,0,""corange"x2 XP",""cwhite"After purchasing you will get "corange"x2 "cwhite"XP booster\nYou will get 2x more XP than usual\n\nAre you sure that you want to buy "corange"x2 XP pack?","Buy","Back");
        }
        if(listitem == 4)
        {
            ShowPlayerDialog(playerid,1160,0,""dred"x3 XP",""cwhite"After purchasing you will get "corange"x3 "cwhite"XP booster\nYou will get 3x more XP than usual\n\nAre you sure that you want to buy "dred"x3 XP pack?","Buy","Back");
        }
   		if(listitem == 5)
        {
            ShowPlayerDialog(playerid,1162,0,""cgreen"Stats Reset",""cwhite"After purchasing your statictics will be setted to 0 \n(Kills, Deaths, Assists, Cleared CPs, Infecteds, Vomiteds and Screameds)\n\n"cwhite"Are you sure that you want to "cgreen"Reset your Stats?","Buy","Back");
        }
        if(listitem == 6)
        {
            ShowPlayerDialog(playerid,1163,0,""cred"Nickname Change",""cwhite"After using nickname changer \nYou can change your nickname that you want\nThe new nickname mustn't break the server rule\n\n"cwhite"Are you sure that you want to "cred"Change your nickname?","Buy","Back");
        }
        return 1;
	}
	if(dialogid == 1157)
	{
        if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1750)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cgold" Gold Premium "cwhite"30 days");
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
   	 				INI_WriteInt("PremiumRealTime",gettime() + 2629743);
   	 				INI_WriteInt("PremiumMonth",month+1);
   	 				if(month == 12)
   	 				{
    					INI_WriteInt("PremiumMonth",1);
    					INI_WriteInt("PremiumYear",year+1);
					}
					INI_Save();
    				INI_Close();
				    AddItem(playerid,"Fuel",8);
				    AddItem(playerid,"Oil",8);
				    AddItem(playerid,"Flashlight",8);
				    AddItem(playerid,"Picklock",8);
				    AddItem(playerid,"Dizzy Away",8);
			    	PInfo[playerid][Premium] = 1;
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumRealTime] = gettime() + 2629743;
			    	PInfo[playerid][PremiumMonth] = month+1;
 					if(month == 12)
   	 				{
    					PInfo[playerid][PremiumYear] = year+1;
    					PInfo[playerid][PremiumMonth] = 1;
					}
					SaveStats(playerid);
				    if(PInfo[playerid][Antiblindpills] > 0) AddItem(playerid,"Anti-blindness pills",PInfo[playerid][Antiblindpills]);
				    if(PInfo[playerid][Nitro] > 0) AddItem(playerid,"Nitro",PInfo[playerid][Nitro]);
				    if(PInfo[playerid][StingerBullets] > 0) AddItem(playerid,"Stinger Bullets",PInfo[playerid][StingerBullets]);
                    if(PInfo[playerid][BeaconBullets] > 0) AddItem(playerid,"Beacon Bullets",PInfo[playerid][BeaconBullets]);
					if(PInfo[playerid][ImpactBullets] > 0) AddItem(playerid,"Impact Bullets",PInfo[playerid][ImpactBullets]);
				    if(PInfo[playerid][Mines] > 0) AddItem(playerid,"Mines",PInfo[playerid][Mines]);
				    if(PInfo[playerid][CraftingTable] > 0) AddItem(playerid,"Crafting Table",PInfo[playerid][CraftingTable]);

					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 1750;
				}
				else
				{
				    SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
		else
		{
		    if(PInfo[playerid][ZMoney] < 500) return SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
			PInfo[playerid][ZMoney] -= 500;
			SaveStats(playerid);
		}
		return 1;
	}
	if(dialogid == 1163)
	{
 		if(!response)
        {
		    if(PInfo[playerid][Premium] >= 1)
		    {
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
	    else
	    {

	    	if(PInfo[playerid][ZMoney] < 200) return SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
    		PInfo[playerid][ChangingName] = 1;
    		ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cwhite"This is nickname changer dialog"cred"\n\tWrite your new nickname below.","Change","Cancel");
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
	    else
	    {
	        if((strlen(inputtext) < 3) || (strlen(inputtext) > 20)) return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"Error: "cwhite"New nickname mustn't be longer 20 charactes and less than 3 characters\n\n\t\tWrite your new nickname below.","Change","Cancel");
            if(fexist(file)) return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"Error: "cwhite"Someone is already have this nickname! \nYou should change to another\n\n\tWrite your new nickname below.","Change","Cancel");
            switch(SetPlayerName(playerid, inputtext))
            {
		        case -1: return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"Error: "cwhite"New nickname has invalid characters\nYou need to change it to another\n\n\tWrite your new nickname below.","Change","Cancel");
		        case 0: return ShowPlayerDialog(playerid,1355,1,""cred"Nickname Change",""cred"Error: "cwhite"You already have this nickname!\nChoose new nickname!\n\n\twrite your new nickname below.","Change","Cancel");
			    case 1:
	        	{
    	    		PInfo[playerid][ZMoney] -= 200;
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1750)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cblue" Diamond Premium "cwhite"30 days");
   					if(Team[playerid] == HUMAN)
						SetPlayerArmour(playerid,200);
		    		new year,month,day;
				    getdate(year,month,day);
			        AddItem(playerid,"Small Med Kits",19);
			     	AddItem(playerid,"Medium Med Kits",19);
				    AddItem(playerid,"Large Med Kits",19);
				    AddItem(playerid,"Fuel",19);
				    AddItem(playerid,"Oil",19);
				    AddItem(playerid,"Flashlight",19);
				    AddItem(playerid,"Picklock",19);
				    AddItem(playerid,"Dizzy Away",19);
			    	PInfo[playerid][Premium] = 3;
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("PremiumYear",year);
   	 				INI_WriteInt("PremiumDay",day);
   	 				INI_WriteInt("PremiumRealTime",gettime() + 2629743);
   	 				INI_WriteInt("PremiumMonth",month+1);
 					if(month == 12)
   	 				{
    					INI_WriteInt("PremiumMonth",1);
    					INI_WriteInt("PremiumYear",year+1);
					}
					INI_Save();
    				INI_Close();
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumRealTime] = gettime() + 2629743;
			    	PInfo[playerid][PremiumMonth] = month+1;
					if(month == 12)
   	 				{
   	 				    PInfo[playerid][PremiumMonth] = 1;
   	 				    PInfo[playerid][PremiumYear] = year+1;
   	 				}
					SaveStats(playerid);
				    if(PInfo[playerid][Antiblindpills] > 0) AddItem(playerid,"Anti-blindness pills",PInfo[playerid][Antiblindpills]);
				    if(PInfo[playerid][Nitro] > 0) AddItem(playerid,"Nitro",PInfo[playerid][Nitro]);
				    if(PInfo[playerid][StingerBullets] > 0) AddItem(playerid,"Stinger Bullets",PInfo[playerid][StingerBullets]);
                    if(PInfo[playerid][BeaconBullets] > 0) AddItem(playerid,"Beacon Bullets",PInfo[playerid][BeaconBullets]);
					if(PInfo[playerid][ImpactBullets] > 0) AddItem(playerid,"Impact Bullets",PInfo[playerid][ImpactBullets]);
				    if(PInfo[playerid][Mines] > 0) AddItem(playerid,"Mines",PInfo[playerid][Mines]);
				    if(PInfo[playerid][CraftingTable] > 0) AddItem(playerid,"Crafting Table",PInfo[playerid][CraftingTable]);

					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 4500;
				}
				else
				{
				    SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][Premium] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You already have a premium!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 2500)
                {
                    ResetPlayerInventory(playerid);
					SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"cplat" Platinum Premium "cwhite"30 days");
   					if(Team[playerid] == HUMAN)
						SetPlayerArmour(playerid,150);
			        AddItem(playerid,"Small Med Kits",13);
			     	AddItem(playerid,"Medium Med Kits",13);
				    AddItem(playerid,"Large Med Kits",13);
				    AddItem(playerid,"Fuel",13);
				    AddItem(playerid,"Oil",13);
				    AddItem(playerid,"Flashlight",13);
				    AddItem(playerid,"Picklock",13);
				    AddItem(playerid,"Dizzy Away",13);
				    new year,month,day;
				    getdate(year,month,day);
    				static file[128];
					format(file,sizeof file,Userfile,GetPName(playerid));
					INI_Open(file);
    				INI_WriteInt("PremiumYear",year);
   	 				INI_WriteInt("PremiumDay",day);
    				INI_WriteInt("PremiumMonth",month+1);
    				INI_WriteInt("PremiumRealTime",gettime() + 2629743);
					if(month == 12)
   	 				{
    					INI_WriteInt("PremiumMonth",1);
    					INI_WriteInt("PremiumYear",year+1);
					}
					INI_Save();
    				INI_Close();
			    	PInfo[playerid][Premium] = 2;
			    	PInfo[playerid][PremiumYear] = year;
			    	PInfo[playerid][PremiumDay] = day;
			    	PInfo[playerid][PremiumRealTime] = gettime() + 2629743;
			    	PInfo[playerid][PremiumMonth] = month+1;
					if(month == 12)
   	 				{
    					PInfo[playerid][PremiumMonth] = 1;
    					PInfo[playerid][PremiumYear] = year+1;
					}
					SaveStats(playerid);
	    			if(PInfo[playerid][Antiblindpills] > 0) AddItem(playerid,"Anti-blindness pills",PInfo[playerid][Antiblindpills]);
				    if(PInfo[playerid][Nitro] > 0) AddItem(playerid,"Nitro",PInfo[playerid][Nitro]);
				    if(PInfo[playerid][StingerBullets] > 0) AddItem(playerid,"Stinger Bullets",PInfo[playerid][StingerBullets]);
                    if(PInfo[playerid][BeaconBullets] > 0) AddItem(playerid,"Beacon Bullets",PInfo[playerid][BeaconBullets]);
					if(PInfo[playerid][ImpactBullets] > 0) AddItem(playerid,"Impact Bullets",PInfo[playerid][ImpactBullets]);
				    if(PInfo[playerid][Mines] > 0) AddItem(playerid,"Mines",PInfo[playerid][Mines]);
				    if(PInfo[playerid][CraftingTable] > 0) AddItem(playerid,"Crafting Table",PInfo[playerid][CraftingTable]);

					PInfo[playerid][ZMoney] = PInfo[playerid][ZMoney] - 2500;
				}
				else
				{
				    SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][ExtraXP] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You already have an extra XP pack!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 800)
                {
                    SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"corange" x2 XP pack "cwhite"30 days");
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
    				INI_WriteInt("ExtraXPRealTime",gettime() + 2629743);
    				if(month == 12)
    				{
    				    INI_WriteInt("ExtraXPMonth",1);
    				    INI_WriteInt("ExtraXPYear",year+1);
    				}
    				INI_Save();
    				INI_Close();
    				PInfo[playerid][ExtraXPYear] = year;
			    	PInfo[playerid][ExtraXPDay] = day;
			    	PInfo[playerid][ExtraXPRealTime] = gettime() + 2629743;
			    	PInfo[playerid][ExtraXPMonth] = month+1;
    				if(month == 12)
    				{
                        PInfo[playerid][ExtraXPMonth] = 1;
                        PInfo[playerid][ExtraXPYear] = year+1;
    				}
                    SaveStats(playerid);
				}
				else
				{
				    SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cgreen"200 ZMoney","Choose","Close");
			}
			else
		    	ShowPlayerDialog(playerid,1156,2,""cgreen"Services",""cgold"Gold Premium\t\t\t"cwhite"1 month/1750 ZMoney\n"cplat"Platinum Premium\t\t"cwhite"1 month/2500 ZMoney\n"cblue"Diamond Premium\t\t"cwhite"1 month/4500 ZMoney\n"corange"x2 XP\t\t\t\t"cwhite"1 month/800 ZMoney\n"dred"x3 XP\t\t\t\t"cwhite"1 month/1250 ZMoney\n"cgreen"Stats Reset\t\t\t"cwhite"500 ZMoney\n"cred"Nickname Change\t\t"cwhite"200 ZMoney","Choose","Close");
		}
        else
        {
            if(PInfo[playerid][ExtraXP] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You already have an extra XP pack!");
            else
            {
                if(PInfo[playerid][ZMoney] >= 1250)
                {
                    SendClientMessage(playerid,white,"Thank you for supporting our community, you have successfuly bought a"dred" x3 XP pack "cwhite"30 days");
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
    				INI_WriteInt("ExtraXPRealTime",gettime() + 2629743);
    				if(month == 12)
    				{
    				    INI_WriteInt("ExtraXPMonth",1);
    				    INI_WriteInt("ExtraXPYear",year+1);
    				}
    				INI_Save();
    				INI_Close();
 					PInfo[playerid][ExtraXPYear] = year;
			    	PInfo[playerid][ExtraXPDay] = day;
			    	PInfo[playerid][ExtraXPRealTime] = gettime() + 2629743;
			    	PInfo[playerid][ExtraXPMonth] = month+1;
    				if(month == 12)
    				{
    				    PInfo[playerid][ExtraXPMonth] = 1;
                        PInfo[playerid][ExtraXPYear] = year+1;
    				}
                    SaveStats(playerid);
				}
				else
				{
				    SendClientMessage(playerid,white,"* "cred"Error: You haven't got enough ZMoney to buy this item!");
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
   		new string[256];
        new file = ini_openFile("Promocodes.ini");
        if(ini_getInteger(file, inputtext, donate) == 0)
        {
        	if(donate == 1)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"10000 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 10000;
				ini_removeKey(file,inputtext);
   				format(string,sizeof string," || User: %s Activated promocode %s and got 10 000 ZMoney",GetPName(playerid),inputtext);
			}
			else if(donate == 2)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"7500 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 7500;
				ini_removeKey(file,inputtext);
				format(string,sizeof string," || User: %s Activated promocode %s and got 7 500 ZMoney",GetPName(playerid),inputtext);
			}
			else if(donate == 3)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"5000 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 5000;
				ini_removeKey(file,inputtext);
				format(string,sizeof string," || User: %s Activated promocode %s and got 5 000 ZMoney",GetPName(playerid),inputtext);
			}
			else if(donate == 4)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"2500 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 2500;
				ini_removeKey(file,inputtext);
				format(string,sizeof string," || User: %s Activated promocode %s and got 2 500 ZMoney",GetPName(playerid),inputtext);
			}
			else if(donate == 5)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"1000 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 1000;
				ini_removeKey(file,inputtext);
				format(string,sizeof string," || User: %s Activated promocode %s and got 1 000 ZMoney",GetPName(playerid),inputtext);
			}
			else if(donate == 6)
            {
           	 	SendClientMessage(playerid, red, ""cgreen"Thanks for donating, you got "cgold"500 "cgreen"ZMoney, enjoy your purchase!");
           	 	PInfo[playerid][ZMoney] += 500;
				ini_removeKey(file,inputtext);
				format(string,sizeof string," || User: %s Activated promocode %s and got 500 ZMoney",GetPName(playerid),inputtext);
			}
			ini_removeKey(file,inputtext);
			SaveIn("Donatelog",string,1);
        }
		else
		{
		    SendClientMessage(playerid, red, ""cwhite"* "cred"Error: Promocode has not been found, check your promocode again!");
		}
        ini_closeFile(file);
        return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(Team[playerid] == ZOMBIE)
	{
	    SetPlayerArmedWeapon(playerid,0);
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
	/*if(PInfo[playerid][CheckEnter] == 1)
	{
        PInfo[playerid][CheckEnter] = 0;
        ClearAnimations(playerid,1);
        return 0;
	}*/
    new Float:x, Float:y, Float:z;
    GetPlayerVelocity(playerid, x, y, z);
    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_ENTER_VEHICLE && gBugPlayerData[playerid][gbug_playerenteringveh] == 0) // OnPlayerEnterVehicle wasn't called, tsk tsk tsk
    {
        gBugPlayerData[playerid][gbug_pentervtick] = GetTickCount();
        GetPlayerPos(playerid, gBugPlayerData[playerid][gbug_playerpos][0], gBugPlayerData[playerid][gbug_playerpos][1], gBugPlayerData[playerid][gbug_playerpos][2]);
        gBugPlayerData[playerid][gbug_playerenteringveh] = 1;
        //SendClientMessage(playerid, -1, "Starting to enter vehicle..");
        return 1;
    }
    if(gBugPlayerData[playerid][gbug_playerenteringveh] == 0) return 1; // Not handling
    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_ENTER_VEHICLE && gBugPlayerData[playerid][gbug_playerenteringveh] != 3 && GetTickCount()-gBugPlayerData[playerid][gbug_pentervtick] > 321)
    {
        gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
        //SendClientMessage(playerid, -1, "Cancelled entry while running to door: special action");
        return 1;
    }
    if(gBugPlayerData[playerid][gbug_playerenteringveh] == 3 && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_ENTER_VEHICLE)
    {
        gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
        //SendClientMessage(playerid, -1, "Cancelled entry while stepping in (special action)");
        return 1;
    }
    if(x == 0 && y == 0 && z == 0) // Standing still, did they get in?
    {
        if(gBugPlayerData[playerid][gbug_playerenteringveh] != 3)
        {
            if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_ENTER_VEHICLE && GetTickCount()-gBugPlayerData[playerid][gbug_pentervtick] > 321)
            {
                if(gBugPlayerData[playerid][gbug_playerenteringveh] == 2) // Stepping in
                {
                    gBugPlayerData[playerid][gbug_playerenteringveh] = 3;
                    //SendClientMessage(playerid, -1, "Stepping in");
                }
                else
                {
                    gBugPlayerData[playerid][gbug_playerenteringveh] = 2; // Stepping in?
                    //SendClientMessage(playerid, -1, "Stepping in?");
                    gBugPlayerData[playerid][gbug_pentervtick] = GetTickCount();
                }
            }
            else if(GetTickCount()-gBugPlayerData[playerid][gbug_pentervtick] > 321) // Cancelled entry
            {
                gBugPlayerData[playerid][gbug_playerenteringveh] = 0;
                //SendClientMessage(playerid, -1, "Cancelled entry while running to door (special action)");
            }
        }
    }
	return 1;
}

public OnPlayerUseItem(playerid,ItemName[])
{
	static string[196];
	if(PInfo[playerid][TradeID] != -1)
	{
	    if(!IsPlayerConnected(PInfo[playerid][TradeID]))
		{
			SendClientMessage(playerid,white,"* "cred"Player is not staying close to you!");
			PInfo[playerid][TradeID] = -1;
			return 1;
		}
    	if(Team[playerid] == ZOMBIE)
		{
			SendClientMessage(playerid,white,"* "cred"Player is not staying close to you!");
			PInfo[playerid][TradeID] = -1;
			return 1;
		}
		if(Team[PInfo[playerid][TradeID]] == ZOMBIE)
		{
			SendClientMessage(playerid,white,"* "cred"Player is not staying close to you!");
			PInfo[playerid][TradeID] = -1;
			return 1;
		}
		new Float:x,Float:y,Float:z;
    	GetPlayerPos(PInfo[playerid][TradeID],x,y,z);
    	if(IsPlayerInRangeOfPoint(playerid,5,x,y,z))
    	{
    	    RemoveItem(playerid,ItemName,1);
    	    if(!strcmp(ItemName,"Mines",true))
    	    {
    	        PInfo[playerid][Mines] --;
    	        PInfo[PInfo[playerid][TradeID]][Mines] ++;
    	    }
    	    if(!strcmp(ItemName,"Anti-blindness pills",true))
    	    {
    	        PInfo[playerid][Antiblindpills] --;
    	        PInfo[PInfo[playerid][TradeID]][Antiblindpills] ++;
    	    }
    	    if(!strcmp(ItemName,"Stinger Bullets",true))
    	    {
    	        PInfo[playerid][StingerBullets] --;
    	        PInfo[PInfo[playerid][TradeID]][StingerBullets] ++;
    	    }
    	    if(!strcmp(ItemName,"Beacon Bullets",true))
    	    {
    	        PInfo[playerid][BeaconBullets] --;
    	        PInfo[PInfo[playerid][TradeID]][BeaconBullets] ++;
    	    }
    	    if(!strcmp(ItemName,"Impact Bullets",true))
    	    {
    	        PInfo[playerid][ImpactBullets] --;
    	        PInfo[PInfo[playerid][TradeID]][ImpactBullets] ++;
    	    }
    	    if(!strcmp(ItemName,"Crafting Table",true))
    	    {
    	        PInfo[playerid][CraftingTable] --;
    	        PInfo[PInfo[playerid][TradeID]][CraftingTable] ++;
    	    }
    	    if(!strcmp(ItemName,"Nitro",true))
    	    {
    	        PInfo[playerid][Nitro] --;
    	        PInfo[PInfo[playerid][TradeID]][Nitro] ++;
    	    }
    	    AddItem(PInfo[playerid][TradeID],ItemName,1);
			format(string,sizeof string,"* "cgreen"You got item \"%s\" from %s!",ItemName,GetPName(playerid));
			SendClientMessage(PInfo[playerid][TradeID],white,string);
			format(string,sizeof string,"* "cgreen"You gave item \"%s\" to %s!",ItemName,GetPName(PInfo[playerid][TradeID]));
            SendClientMessage(playerid,white,string);
			PInfo[playerid][TradeID] = -1;
    	}
    	else
    	{
    		SendClientMessage(playerid,white,"* "cred"Player is not staying close to you!");
			PInfo[playerid][TradeID] = -1;
			return 0;
    	}
	}
	else
	{
	    if(!strcmp(ItemName,"Impact Bullets",true))
	    {
	        PInfo[playerid][ImpactBullets] --;
			RemoveItem(playerid,"Impact Bullets",1);
			PInfo[playerid][ImpactBulletsInUse] ++;
			format(string,sizeof string,"* "cjam"%s loaded gun clip with Impact bullet",GetPName(playerid));
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can combinate special bullets "cwhite"**");
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can add more bullets by selecting them in inventory "cwhite"**");
			SendNearMessage(playerid,white,string,20);
			ApplyAnimation(playerid,"BUDDY","buddy_reload",3,0,1,1,0,0,1);
			PlayNearSound(playerid,36401);
	    }
	    if(!strcmp(ItemName,"Beacon Bullets",true))
	    {
	        PInfo[playerid][BeaconBullets] --;
			RemoveItem(playerid,"Beacon Bullets",1);
			PInfo[playerid][BeaconBulletsInUse] ++;
			format(string,sizeof string,"* "cjam"%s loaded gun clip with Beacon bullet",GetPName(playerid));
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can combinate special bullets "cwhite"**");
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can add more bullets by selecting them in inventory "cwhite"**");
			SendNearMessage(playerid,white,string,20);
			ApplyAnimation(playerid,"BUDDY","buddy_reload",3,0,1,1,0,0,1);
            PlayNearSound(playerid,36401);
	    }
	    if(!strcmp(ItemName,"Stinger Bullets",true))
	    {
	        PInfo[playerid][StingerBullets] --;
			RemoveItem(playerid,"Stinger Bullets",1);
			PInfo[playerid][StingerBulletsInUse] ++;
			format(string,sizeof string,"* "cjam"%s loaded gun clip with Stinger bullet",GetPName(playerid));
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can combinate special bullets "cwhite"**");
			SendClientMessage(playerid,orange,""cwhite"** "cred"TIP: You can add more bullets by selecting them in inventory "cwhite"**");
			SendNearMessage(playerid,white,string,20);
			ApplyAnimation(playerid,"BUDDY","buddy_reload",3,0,1,1,0,0,1);
			PlayNearSound(playerid,36401);
	    }
	    if(!strcmp(ItemName,"Nitro",true))
	    {
	        new vehid;
	        vehid = -1;
	        vehid = GetClosestVehicle(playerid,4.0);
	        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? You need to get out of the vehicle!");
	        if(vehid == -1) return SendClientMessage(playerid,white,"? "cred"You aren't near a vehicle!");
			switch(GetVehicleModel(vehid))
   			{
                case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,493,495,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return SendClientMessage(playerid,white,"? "cred"You can't place nitro to this vehicle!");
			}
			RemoveItem(playerid,"Nitro",1);
			PInfo[playerid][Nitro] --;
			AddVehicleComponent(vehid,1010);
			format(string,sizeof string,"* "cjam"%s has placed nitro to his vehicle!",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
		}
	    if(!strcmp(ItemName,"Crafting Table",true))
	    {
		    new header[32];
		    format(header,sizeof header,""cgreen"Materials: "cred"%i",PInfo[playerid][Materials]);
		    new strang[732];
			format(strang,sizeof string,"Item\tReqires\tChance\n");
		    strcat(strang,""cwhite"Mine\t"cyellow"800\t"cgreen"65\%\n");
		    strcat(strang,""cwhite"Molotovs\t"cyellow"1000\t"cgreen"70\%\n");
		    strcat(strang,""cwhite"Sticky bombs\t"cyellow"2400\t"cyellow"50\%\n");
		    strcat(strang,""cwhite"Beacon Bullets\t"cyellow"1400\t"cyellow"50\%\n");
		    strcat(strang,""cwhite"Impact Bullets\t"cyellow"1800\t"cyellow"40\%\n");
		    strcat(strang,""cwhite"Stinger Bullets\t"cyellow"2350\t"cred"35\%\n");
		    strcat(strang,""cwhite"Nitro\t"cyellow"2000\t"cyellow"60\%\n");
			strcat(strang,""cwhite"Anti-blindness pills\t"cyellow"400\t"cgreen"90\%\n");
			strcat(strang,""cwhite"Crafting Table\t"cyellow"2800\t"cgreen"75\%");
		    ShowPlayerDialog(playerid,CraftDialog,DSTH,header,strang,"Craft","Close");
	    }
	    if(!strcmp(ItemName,"Anti-blindness pills",true))
	    {
            RemoveItem(playerid,"Anti-blindness pills",1);
			format(string,sizeof string,"* "cjam"%s has taken some anti-blindness pills and now he sees well.",GetPName(playerid));
			SendNearMessage(playerid,white,string,20);
			SetPlayerWeather(playerid,RWeather);
			if(RWeather == 55) SetPlayerTime(playerid,6,0);
			else SetPlayerTime(playerid,23,0);
			PInfo[playerid][TokeBlind] = 1;
			PInfo[playerid][Antiblindpills] --;
	    }
	    if(!strcmp(ItemName,"Mines",true))
	    {
	        if(IsValidObject(PInfo[playerid][MineObject]))
			{
			    new Float:x,Float:y,Float:z;
				GetObjectPos(PInfo[playerid][MineObject],x,y,z);
				if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
				{
				    SendClientMessage(playerid,white,"* "cjam"You have pickuped your mine!");
				    KillTimer(PInfo[playerid][CheckMine]);
				    DestroyObject(PInfo[playerid][MineObject]);
				}
				else return SendClientMessage(playerid,white,"* "cred"You already placed mine, you can remove it, stay close to your mine to remove it");
			}
			else
			{
				format(string,sizeof string,"* "cjam"%s has placed mine.",GetPName(playerid));
				SendClientMessage(playerid,orange,""cwhite"** "cred"You can pickup mine by selecting it from the inventory. "cwhite"**");

				ApplyAnimation(playerid,"BOMBER","BOM_Plant",2,0,0,0,0,0,1);
				SendNearMessage(playerid,white,string,20);
				new Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				PInfo[playerid][MineObject] = CreateObject(19602,x,y,z-0.98,0,0,0,300);
			 	PInfo[playerid][CheckMine] = SetTimerEx("CheckMineDH",100,false,"i",playerid);
			}
	    }
	  	if(!strcmp(ItemName,"Large Med Kits",true))
	  	{
			{
			    EnableAntiCheatForPlayer(playerid,12,0);
	            RemoveItem(playerid,"Large Med Kits",1);
				format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and is feeling much better.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				new Float:health;
				GetPlayerHealth(playerid,health);
				if(PInfo[playerid][SPerk] != 1 && PInfo[playerid][SPerk] != 20)
				{
					if(health > 65.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+35.0);
				}
				else if(PInfo[playerid][SPerk] == 1)
				{
				    if(health > 55.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+45.0);
				}
				else if(PInfo[playerid][SPerk] == 20)
				{
				    if(health > 50.0) SetPlayerHealth(playerid,100.0);
				    else SetPlayerHealth(playerid,health+50.0);
				}
				SetTimerEx("ActivateCheat",1000,false,"i",playerid);
			}
	  	}
	  	if(!strcmp(ItemName,"Medium Med Kits",true))
	  	{
			{
			    EnableAntiCheatForPlayer(playerid,12,0);
		        format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and feels ok.",GetPName(playerid));
		        RemoveItem(playerid,"Medium Med Kits",1);
				SendNearMessage(playerid,white,string,20);
				new Float:health;
				GetPlayerHealth(playerid,health);
				if(PInfo[playerid][SPerk] != 1 && PInfo[playerid][SPerk] != 20)
				{
					if(health > 75.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+25.0);
				}
				else if(PInfo[playerid][SPerk] == 1)
				{
				    if(health > 65.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+35.0);
				}
				else if(PInfo[playerid][SPerk] == 20)
				{
				    if(health > 60.0) SetPlayerHealth(playerid,100.0);
				    else SetPlayerHealth(playerid,health+40.0);
				}
				SetTimerEx("ActivateCheat",1000,false,"i",playerid);
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
			{
			    EnableAntiCheatForPlayer(playerid,12,0);
		        RemoveItem(playerid,"Small Med Kits",1);
		        format(string,sizeof string,"* "cjam"%s has taken some pills from a med kit and feels slighty better.",GetPName(playerid));
				SendNearMessage(playerid,white,string,20);
				new Float:health;
				GetPlayerHealth(playerid,health);
				if(PInfo[playerid][SPerk] != 1 && PInfo[playerid][SPerk] != 20)
				{
					if(health > 85.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+15.0);
				}
				else if(PInfo[playerid][SPerk] == 1)
				{
				    if(health > 75.0) SetPlayerHealth(playerid,100.0);
					else SetPlayerHealth(playerid,health+25.0);
				}
				else if(PInfo[playerid][SPerk] == 20)
				{
				    if(health > 70.0) SetPlayerHealth(playerid,100.0);
				    else SetPlayerHealth(playerid,health+30.0);
				}
				SetTimerEx("ActivateCheat",1000,false,"i",playerid);
			}
	  	}
	    if(!strcmp(ItemName,"Fuel",true))
	    {
	        new vehid;
	        vehid = -1;
	        vehid = GetClosestVehicle(playerid,4.0);
	        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? You need to get out of the vehicle!");
	        if(vehid == -1) return SendClientMessage(playerid,white,"? "cred"You aren't near a vehicle!");
	        if(Fuel[vehid] >= 10) return SendClientMessage(playerid,white,"? "cred"This vehicle doesn't need anymore fuel.");
	        RemoveItem(playerid,"Fuel",1);
	        format(string,sizeof string,""cjam"%s adds some Fuel to the vehicle.",GetPName(playerid));
	        SendNearMessage(playerid,white,string,20);
			if(PInfo[playerid][SPerk] == 2) Fuel[vehid]+=2;
			else Fuel[vehid]+=1.5;
			if(PInfo[playerid][TrainingPhase] == 4) PInfo[playerid][CheckFill] ++;
			UpdateVehicleFuelAndOil(vehid);
	    }
		if(!strcmp(ItemName,"Picklock",true))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? You must to be in vehicle to use it!");
		    if(PInfo[playerid][CanUsePickLock] == 0) return 1;
			if(VehicleWithoutKeys[GetPlayerVehicleID(playerid)] == 0) return SendClientMessage(playerid,red,"? This vehicle have keys!");
			PInfo[playerid][CanUsePickLock] = 0;
			new rand = random(2);
			if(rand == 1)
			{
			    new engine,lights,alarm,doors,bonnet,boot,objective;
			    GetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(GetPlayerVehicleID(playerid),engine,lights,1,doors,bonnet,boot,objective);
			}
			SendClientMessage(playerid,white,"* "dred"Attempting to select suitable key...");
			SetTimerEx("AttemptOpen",5000,false,"i",playerid);
		}
	    if(!strcmp(ItemName,"Oil",true))
	    {
	        new vehid;
	        vehid = -1;
	        vehid = GetClosestVehicle(playerid,4.0);
	        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? You need to get out of the vehicle!");
	        if(vehid == -1) return SendClientMessage(playerid,red,"? You aren't near a vehicle!");
	        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? First you need to exit your vehicle!");
	        if(Oil[vehid] >= 10) return SendClientMessage(playerid,white,"? "cred"This vehicle doesn't need anymore oil.");
	        RemoveItem(playerid,"Oil",1);
	        format(string,sizeof string,""cjam"%s adds some Oil to the vehicle.",GetPName(playerid));
	        SendNearMessage(playerid,white,string,20);
			if(PInfo[playerid][SPerk] == 3) Oil[vehid]+=2;
			else Oil[vehid]+=1.5;
			PInfo[playerid][CheckFill] ++;
			UpdateVehicleFuelAndOil(vehid);
	    }
	    if(!strcmp(ItemName,"Dizzy Away",true))
	    {
	        if(PInfo[playerid][PoisonDizzy] == 1)
	        {
	            PInfo[playerid][PoisonDizzy] = 0;
	            SetPlayerDrunkLevel(playerid,0);
			}
        	PInfo[playerid][TokeDizzy] = 1;
        	RemoveItem(playerid,"Dizzy Away",1);
        	format(string,sizeof string,""cjam"%s has taken some dizzy away pills.",GetPName(playerid));
        	SendNearMessage(playerid,white,string,20);
			SetPlayerWeather(playerid,RWeather);
			if(RWeather == 55) SetPlayerTime(playerid,6,0);
			else SetPlayerTime(playerid,23,0);
        	SetPlayerDrunkLevel(playerid,0);
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
		    if(Mission[playerid] == 1) return SendClientMessage(playerid,red,"? Please finish your molotovs mission!");
		    RemoveItem(playerid,"Bouncing Bettys Guide",1);
		    new rand = random(2);
			switch(rand)
			{
			    case 0: SendClientMessage(playerid,white,"* "corange"Head over to Pig Pen to get some ethanol"),Mission[playerid] = 2, MissionPlace[playerid][0] = 1, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[0][3],Locations[0][4],Locations[0][5],62,0,MAPICON_GLOBAL);
				case 1: SendClientMessage(playerid,white,"* "corange"Head over to Alhambra to get some ethanol"),Mission[playerid] = 2, MissionPlace[playerid][0] = 2, MissionPlace[playerid][1] = 1,SetPlayerMapIcon(playerid,1,Locations[1][3],Locations[1][4],Locations[1][5],62,0,MAPICON_GLOBAL);
			}
		}
	}
  	return 0;
}

public UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, true);
    return true;
}

public OnPlayerPickUpPickup(playerid,pickupid)
{
	if(pickupid == FirstStepMolotov[playerid] || pickupid == SecondStepMolotov[playerid] || pickupid == ThirdStepMolotov[playerid]) return 0;
	if(pickupid == DNAPu) return 0;
	if(pickupid == HelpPickupCraft)
	{
	    new string[1024];
	    format(string,sizeof string,""cwhite"Here in ocean docks you can craft some items for extra support");
	    strcat(string,"\n"cwhite"For crafting you need materials, that you can get by looting\nIn interiors (low amount of materials) or here (higher amount of materials) "cred"YOU CAN HAVE MAXIMUM 5000 MATERIALS");
        strcat(string,"\n"cwhite"For crafting items you need to go to crafting table \nOr you can use craft table in inventory (first need to craft it in crafting table in LS Docks)");
        strcat(string,"\n"cwhite"Each item have chance and cost, after successful crafting this items are saved \nEven you exit server they will be available in inventory, except sticky bombs and molotovs");
        strcat(string,"\n"cwhite"For looting materials you can go to arrows (find them in hangars) and start collecting materials for further usage");
        strcat(string,"\n"cwhite"You can get more info about items by clicking them in crafting dialog");
		ShowPlayerDialog(playerid,16555,DSM,""cred"Info - Craft System",string,"Ok","");
	    return 1;
	}
	if(pickupid == HelpPickupDNAmod)
	{
	    new string[1024];
	    format(string,sizeof string,""cwhite"In abandoned laboratory you can create DNA Modifications ");
	    strcat(string,"\n"cwhite"This Modifications let you use some perks and abilities with more features");
        strcat(string,"\n"cwhite"For Combining modifications you need DNA Points\nYou can get them by biting humans and infecting them "cred"YOU CAN MAXIMUM HAVE 5000 DNA POINTS");
        strcat(string,"\n"cwhite"After getting DNA Points you need to enter special machine (in the corner of laboratory) to spend them");
        strcat(string,"\n"cwhite"Each modification have instability and cost\nAs higher instability as lower chance you have to combine modification");
        strcat(string,"\n"cwhite"You can decrease instability by combining DNA Stabilizer");
        strcat(string,"\n"cwhite"You can check information about all modifications by clicking them in "cred"Combining Dialog");
        strcat(string,"\n"cwhite"After successful combining you can use it by putting them into slot of modifications");
		strcat(string,"\n"cwhite"You can change slots by "cred"/ChangeMod \nNOTE: You can change modification limited times depending on your rank");
		strcat(string,"\n"cwhite""cred"From 1 to 14 - 1 time, From 15 to 29 - 2 times, From 30 and higher - 3 times");
		ShowPlayerDialog(playerid,16555,DSM,""cred"Info - DNA Modification",string,"Ok","");
	    return 1;
	}
    for(new j; j < sizeof(HiveMeatPos);j++)
    {
        if(pickupid == MeatHive[j])
        {
		    new Float:a;
		    GetPlayerHealth(playerid,a);
			if(a >= 100)
			{
				SendClientMessage(playerid,white,"* "cred"You don't want to eat brains right now!");
			    return 1;
			}
			if(PInfo[playerid][EatenMeat] >= 3)
			{
	  			SendClientMessage(playerid, white, "* "cred"You have already been filled with brains!");
	  			if(PInfo[playerid][EatenMeat] == 3)
	  			{
	  				KillTimer(PInfo[playerid][ResotoreHiveHP]);
	  				SetTimerEx("CanEatAgain",20000,false,"i",playerid);
	  				PInfo[playerid][EatenMeat] ++;
				}
	  			return 1;
			}
			else
			{
			    new string[64];
			    format(string,sizeof string,""cwhite"* "cjam"%s munches on some leftover brains.",GetPName(playerid));
				if(a >= 50) SetPlayerHealth(playerid,100);
				else SetPlayerHealth(playerid,a+50);
				SendNearMessage(playerid,white,string,30);
				KillTimer(PInfo[playerid][ResotoreHiveHP]);
				PInfo[playerid][ResotoreHiveHP] = SetTimerEx("CanEatAgain",20000,false,"i",playerid);
				PInfo[playerid][EatenMeat] ++;
			}
			return 0;
		}
	}
	/*for(new j; j < sizeof(PresentsPos);j++)
    {
		if(pickupid == PresentsPU[j])
		{
		    if(PInfo[playerid][AchievementCollect20] >= 20) return SendClientMessage(playerid,white,"** "cred"You have already found 20 presents!");
			if(PInfo[playerid][AchievementCollect20] == 19)
			{
		  		SendClientMessage(playerid,white,"** "cgreen"Achievement Get! "cred"Collect 20 presents "cgreen"unlocked!");
		    	SendClientMessage(playerid,white,"** "cred"REWARD: "cgreen"2000 XP");
		    	PInfo[playerid][XP] += 2000;
		    	PlayerPlaySound(playerid,4201,0,0,0);
		    	PInfo[playerid][AchievementCollect20] ++;
		    	CheckAchievement(playerid);
			}
			else
			{
				DestroyPickup(PresentsPU[j]);
				PInfo[playerid][AchievementCollect20] ++;
			    SendFMessage(playerid,green,"? You have found present! "cred"%i/20 Found! "corange"Use /achievements for more info",PInfo[playerid][AchievementCollect20]);
			}
			return 0;
		}
	}*/
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
	if(pickupid == DNIExit)
	{
	    SetPlayerPosAndAngle(playerid,1425.6604,-1472.4076,1721.4471,65.2419);
	    return 0;
	}
	if(pickupid == DNIEntrence)
	{
	    SetPlayerPosAndAngle(playerid,1421.4320,-1461.9127,1753.0470,230.0172);
	    return 0;
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
	        	ApplyAnimation(playerid,"BOMBER","BOM_Plant",2,0,0,0,0,0,1);
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
				SendClientMessage(playerid,white,"* "cred"TIP: Find and get in the car.");
				Vehicles[playerid][0] = CreateVehicle(587,103.1150000,1934.5260000,18.2890000,180.0000000,72,1,-1); //Euros
				Vehicles[playerid][1] = CreateVehicle(603,107.2350000,1934.7790500,18.6310000,182.0000000,69,1,-1); //Phoenix
				Vehicles[playerid][2] = CreateVehicle(506,111.3070000,1934.3979500,18.5600000,180.0000000,7,7,-1); //Super GT
		        SetVehicleVirtualWorld(Vehicles[playerid][0],GetPlayerVirtualWorld(playerid));
		        SetVehicleVirtualWorld(Vehicles[playerid][1],GetPlayerVirtualWorld(playerid));
		        SetVehicleVirtualWorld(Vehicles[playerid][2],GetPlayerVirtualWorld(playerid));
		        SetVehicleParamsEx(Vehicles[playerid][0],0,0,0,0,0,0,0);
		        SetVehicleParamsEx(Vehicles[playerid][1],0,0,0,0,0,0,0);
		        SetVehicleParamsEx(Vehicles[playerid][2],0,0,0,0,0,0,0);
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
			    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"Now I will teach you, how to use your inventory\nLook, you are low of fuel and oil\nClick "cred"N"cwhite" to open your inventory\nHere you can find different types of items, but "cred"check fuel and oil for now"cwhite"\nTo put fuel and oil to vehicle you need first you need "cred"to exit vehicle"cwhite" then you must stay close to a vehicle to fill it\nFill you vehicle and drive to next pickup","OK","");
				SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Exit vehicle, then open your inventory "corange"Press N"cwhite" and choose oil and fuel to fill your vehicle.");
    			SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"After filling enter vehicle and "cred"start "cwhite"it again, then go to next pickup continue.");
				Fuel[GetPlayerVehicleID(playerid)] = 0;
				Oil[GetPlayerVehicleID(playerid)] = 0;
				VehicleStarted[GetPlayerVehicleID(playerid)] = 0;
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
				ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"As you note that there is not much items in your inventory\nSo you can fill it by looting houses\nYou can loot in the most interiors that you can enter\nInteriors will be marked by arrows\nCome to it and press "cred"C"cwhite" to loot,\nHere you can find some more extra items!\n"cred"Now go down and find the arrow!","OK","");
	            DestroyPlayerObject(playerid,Player1stGate);
	            SendClientMessage(playerid,white,"* "cred"TIP: Go down and find arrow pickup");
	            DestroyVehicle(GetPlayerVehicleID(playerid));
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
		        new strang[1150];
		        TogglePlayerControllable(playerid, 0);
				SetTimerEx("UnFreezePlayer", 2000, false, "i", playerid);
		        format(strang,sizeof strang,""cwhite"Surviving without any extra support is very hard, you will understand this while playing\nSo perks system will help you with that\nPerks are special abilities, they can help you in different situations");
		        strcat(strang,"\nPress "cred"Y"cwhite" to open perks list\nOn first rank you won't get any perks. \nYou get new perks every time rank up\nOpen perks list and choose "cred"Burst Run\n\n"cred"");
		        SetPlayerPosAndAngle(playerid,998.2286,2133.3354,500.1364,78.3310);
		        SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Press "corange"Y "cwhite"to open perks' list and choose "cblue"Burst run");
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
	    	SetPlayerHealth(playerid,100);
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
			    new strang[2000];
			    DisablePlayerCheckpoint(playerid);
		        format(strang,sizeof strang,""cwhite"Good Job!\nNow I will tell you about Checkpoint system\nAs told earlier Checkpoint(CP) is red marker on radar\nThat is not all, when you enter CP you will receive ammo for your weapons\nAnd while you are staying in it your hp will increase");
		        strcat(strang,"\nStaying  in CP for a longer duration may clear it. Time of the CP is depended entirely upon the no. of players playing\nIf you avoid CP for too long, you will become 1st victim of infection!"cred"\nIf you avoid CP for more than 10 minutes, you will automatically be teleported to CP!"cwhite"");
				strcat(strang,"\nYou must clear 8 CPs to win the game\nCheck right upper corner of screen to check how much humans cleared CP\nIn CP you will meet other humans\nHumans are your friends and have green nickname");
				strcat(strang,"\nKilling your teammates will cause you to lose XP and if you continue to do so you will be jailed for some time\nYou need to work together in order to win the game\n"cred"");
		    	strcat(strang,"\nKilling zombies (they have purple nicknames and have purple marker on radar) will give you XP, that is needed for increasing your rank\nNow go to CP and we will continue!");
				SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Enter "cred"Checkpoint "cwhite"to continue");
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
			    new strang[916];
			    format(strang,sizeof strang,""cwhite"Now you will be told about the most important thing for zombies, about Bite system\nOn first look, Bite system looks hard, but it's not");
			    strcat(strang,"\nYou need to get used to the bite system, later you will become the most dangerous zombie in the city\nGo to the human that is standing in front of you\nGet as much close to him and click "cred"Right Mouse Button as fast as you can and infect him!");
			    ShowPlayerDialog(playerid,13759,DSM,"Info",strang,"OK","");
			    SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Come closer to human (in front of you) and click "cred"Right Mouse Button"cwhite" to bite him");
            	SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"As faster you click "cred"RMB "cwhite"as faster he will get infected");
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
				new strang[234];
				format(strang,sizeof strang,""cwhite"Zombies also have perks\nTo open perks list you need to:\nClick "cred"Y"cwhite" key to open perk list\nThen choose jumper perk");
				SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Open perk menu "cred"Y "cwhite" and choose "cblue"Jumper perk"cred"");
                SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Jump through big boxes and find pickup behind them");
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
				new strang[200];
				format(strang,sizeof strang,""cwhite"Good job!\nNow you need to teleport to a vehicle\nActivate Dig perk in your perks menu (click "cred"Y"cwhite") to open");
				SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Open perk list again "cred"Y "cwhite"choose "cred"digger perk"cwhite" and "cred"press C");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
				Vehicles[playerid][3] = CreateVehicle(527,401.7200000,2500.7309600,16.2680000,180.0000000,53,1,-1);
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(Vehicles[playerid][3], engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleVirtualWorld(Vehicles[playerid][3],GetPlayerVirtualWorld(playerid));
				SetVehicleParamsEx(Vehicles[playerid][3], engine, lights, alarm, doors, bonnet, boot, 1);
				StartVehicle(Vehicles[playerid][3],0);
				VehicleStarted[Vehicles[playerid][3]] = 0;
				SetVehicleParamsEx(Vehicles[playerid][3],0,0,0,0,0,0,0);
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
				new strang[450];
				format(strang,sizeof strang,""cwhite"Well done!\nYou have passed your training course!\nNow you are ready for a real fight!\nIf you need further assisstance you can ask online administrators");
				strcat(strang,"\nIt is also recommended to read rules (/help)\nNow choose your class that you want play in and start enjoying your game on our server (go left to play as a Human or go right to play as a zombie)");
				strcat(strang,"\n\n"cred"GOOD LUCK AND HAVE FUN!!!");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
				SendClientMessage(playerid,white,"*** "cgreen"You've got XP for complaining training course!");
				PInfo[playerid][Training] = 0;
				PInfo[playerid][TrainingPhase] = 0;
				PInfo[playerid][ChooseAfterTr] = 1;
				static string[16];
		 		PInfo[playerid][XP] += 50;
		 		PInfo[playerid][CurrentXP] += 50;
				format(string,sizeof string,"+%i XP",PInfo[playerid][CurrentXP]);
				TextDrawSetString(GainXPTD[playerid],string);
				PInfo[playerid][ShowingXP] = 1;
				SetTimerEx("ShowXP1",100,0,"d",playerid);
			    TextDrawShowForPlayer(playerid,GainXPTD[playerid]);
			    PlaySound(playerid,1083);
			    SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Choose your "dred"team to start play");
			    SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Go left for choosing "cgreen"Survivors team "cwhite"or right for "cpurple"Zombies team");
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
			{
				if(sid == ZombieSkins[i]) goto ChooseSkin;
			}
			if(sid == 0 || sid == 74 || sid == 99 || sid == 92) goto ChooseSkin;
	        SendClientMessage(playerid,white,"* "cgreen"You have chosen Survivor Class!");
	        SetPlayerVirtualWorld(playerid,0);
	        SetPlayerCP(playerid);
	        SetPlayerSkin(playerid,sid);
		}
		return 0;
	}
	return 1;
}

public SaveDeathZombieLastPos(playerid)
{
    {
    	GetPlayerPos(playerid,PInfo[playerid][DX],PInfo[playerid][DY],PInfo[playerid][DZ]);
    }
	return 1;
}

public OnPlayerCommandReceived(playerid,cmd[], params[], flags)
{
	if(PInfo[playerid][Logged] == 0) return SendClientMessage(playerid,red,""cwhite"* "cred"Error: You need to login to write any commands!");
    new string[256];
    if(PInfo[playerid][Level] < 1)
    {
    	format(string,sizeof string," || User: %s used command %s",GetPName(playerid),cmd);
	}
	else if(PInfo[playerid][Level] >= 1)
	{
		format(string,sizeof string," || Administrator: %s used command %s",GetPName(playerid),cmd);
	}
	SaveIn("Commandlog",string,1);
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if((result == -1) || (result == 0))
    {
        return SendClientMessage(playerid,white,"* "dred"Command isn't found! Use /help for searching commands!");
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
    new sendername[24];
    static string[145];
    GetPlayerName(playerid, sendername, 32);
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	if(PInfo[playerid][Logged] == 0) return SendClientMessage(playerid,red,""cwhite"* "cred"Error: You need to login to write any messages!");
	KillTimer(FloodTimer[playerid]);
	FloodTimer[playerid] = SetTimerEx("TimerFlood",1500,false,"i",playerid);
	MaxChat[playerid] ++;
	if(MaxChat[playerid] > 3 && MaxChat[playerid] <=6)
	{
	    SendClientMessage(playerid,white,"*** "cred"You are writting in the chat too fast!");
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
    	format(string, sizeof string, ""cwhite"|%i| "cgreen"%s: "cwhite"%s", playerid, sendername, text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
	}
	else if(Team[playerid] == ZOMBIE)
	{
	 	format(string, sizeof string, ""cwhite"|%i| "cpurple"%s: "cwhite"%s", playerid, sendername, text);
    	SendClientMessageToAll(GetPlayerColor(playerid), string);
	}
	format(string,256,"Main Chat:|%i| %s: %s", playerid, sendername, text);
	SaveIn("ChatLog",string,1);
    return 0;
}

public OnPlayerClickPlayer(playerid,clickedplayerid,source)
{
	if(PInfo[playerid][Logged] == 0) return SendClientMessage(playerid,red,""cwhite"* "cred"Error: You must to log in to check stats of other players!");
	else
	{
	    if(PInfo[clickedplayerid][Logged] == 1)
	    {
     		static string[50];
 			format(string,sizeof string,""cwhite"? "cgreen"%s is logged in!",GetPName(clickedplayerid));
			SendClientMessage(playerid,white,string);
		}
		else if(PInfo[clickedplayerid][Logged] == 0)
  		{
     		static string[50];
 			format(string,sizeof string,""cwhite"? "cblue"%s is NOT logged in!",GetPName(clickedplayerid));
			SendClientMessage(playerid,white,string);
		}
		static sstring[128];
		if(Team[clickedplayerid] == ZOMBIE)
			format(sstring,sizeof sstring,""cpurple"User: "cwhite"%s",GetPName(clickedplayerid));
		else if(Team[clickedplayerid] == HUMAN)
			format(sstring,sizeof sstring,""cgreen"User: "cwhite"%s",GetPName(clickedplayerid));
		else format(sstring,sizeof sstring,""cwhite"User: "cwhite"%s",GetPName(clickedplayerid));
		new string[512];
		new prem[25];
		new dtxp[29];
		new date1[64];
		new date2[64];
		if(PInfo[clickedplayerid][ExtraXP] == 0) dtxp = "Not Activated";
		else if(PInfo[clickedplayerid][ExtraXP] == 1) dtxp = ""corange"Double XP activated";
		else if(PInfo[clickedplayerid][ExtraXP] == 2) dtxp = ""dred"Triple XP activated";
		if(PInfo[clickedplayerid][Premium] == 0) prem = "None";
		else if(PInfo[clickedplayerid][Premium] == 1) prem = ""cgold"Gold";
		else if(PInfo[clickedplayerid][Premium] == 2) prem = ""cplat"Platinum";
		else if(PInfo[clickedplayerid][Premium] == 3) prem = ""cblue"Diamond";
		if(PInfo[clickedplayerid][Premium] > 0)
		{
		    new PRTime = PInfo[clickedplayerid][PremiumRealTime]-gettime();
		    if(PRTime/86400 >= 1)
		    	format(date1,sizeof date1,""cred"(Expires in %d days)",floatround(PRTime/86400,floatround_round));
			else if(PRTime/3600 >= 1)
				format(date1,sizeof date1,""cred"(Expires in %d hours)",floatround(PRTime/3600,floatround_round));
			else if(PRTime/3600 < 1)
				format(date1,sizeof date1,""cred"(Expires in %d minutes)",floatround(PRTime/60,floatround_round));
			format(string,sizeof string,""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s "cred"%s"cwhite" - Extra XP Pack: %s\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,date1,dtxp,PInfo[clickedplayerid][HoursPlayed]);
		}
		if(PInfo[clickedplayerid][ExtraXP] > 0)
		{
		    new ExRTime = PInfo[clickedplayerid][ExtraXPRealTime]-gettime();
		    if(ExRTime/86400 >= 1)
		    	format(date2,sizeof date2,""cred"(Expires in %d days)",floatround(ExRTime/86400,floatround_round));
			else if(ExRTime/3600 >= 1)
				format(date2,sizeof date2,""cred"(Expires in %d hours)",floatround(ExRTime/3600,floatround_round));
			else if(ExRTime/3600 < 1)
				format(date2,sizeof date2,""cred"(Expires in %d minutes)",floatround(ExRTime/60,floatround_round));
			format(string,sizeof string,""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s - "cwhite"Extra XP Pack: %s "cred"%s"cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,dtxp,date2,PInfo[clickedplayerid][HoursPlayed]);
		}
		if((PInfo[clickedplayerid][Premium] > 0) && (PInfo[clickedplayerid][ExtraXP] > 0))
		{
		    new PRTime = PInfo[clickedplayerid][PremiumRealTime]-gettime();
		    new ExRTime = PInfo[clickedplayerid][ExtraXPRealTime]-gettime();
		    if(PRTime/86400 >= 1)
		    	format(date1,sizeof date1,""cred"(Expires in %d days)",floatround(PRTime/86400,floatround_round));
			else if(PRTime/3600 >= 1)
				format(date1,sizeof date1,""cred"(Expires in %d hours)",floatround(PRTime/3600,floatround_round));
			else if(PRTime/3600 < 1)
				format(date1,sizeof date1,""cred"(Expires in %d minutes)",floatround(PRTime/60,floatround_round));
		    if(ExRTime/86400 >= 1)
		    	format(date2,sizeof date2,""cred"(Expires in %d days)",floatround(ExRTime/86400,floatround_round));
			else if(ExRTime/3600 >= 1)
				format(date2,sizeof date2,""cred"(Expires in %d hours)",floatround(ExRTime/3600,floatround_round));
			else if(ExRTime/3600 < 1)
				format(date2,sizeof date2,""cred"(Expires in %d minutes)",floatround(ExRTime/60,floatround_round));
			format(string,sizeof string,""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s "cred"%s - "cwhite"Extra XP Pack: %s "cred"%s"cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,date1,dtxp,
			date2,PInfo[clickedplayerid][HoursPlayed]);
		}
		else if((PInfo[clickedplayerid][Premium] == 0) && (PInfo[clickedplayerid][ExtraXP] == 0))
		{
			format(string,sizeof string,""cwhite"Rank: %i - XP: %i/%i - SPerk: %i - ZPerk: %i\n\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i - Survivor Assists: %i - Zombie Assists: %i\n\nPremium: %s - "cwhite"Extra XP Pack: %s "cwhite"\n\n"cwhite"Hours Played: "corange"%i",
			PInfo[clickedplayerid][Rank],PInfo[clickedplayerid][XP],PInfo[clickedplayerid][XPToRankUp],PInfo[clickedplayerid][SPerk]+1,PInfo[clickedplayerid][ZPerk]+1,PInfo[clickedplayerid][Kills],
			PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths],
			PInfo[clickedplayerid][sAssists],PInfo[clickedplayerid][zAssists],prem,dtxp,PInfo[clickedplayerid][HoursPlayed]);
		}
		//format(string,sizeof (string),""cwhite"\nKills: %i - Infects: %i - TeamKills: %i - Bites: %i - Screamed: %i - Vomited: %i - Deaths: %i",PInfo[clickedplayerid][Kills],PInfo[clickedplayerid][Infects],PInfo[clickedplayerid][Teamkills],PInfo[clickedplayerid][Bites],PInfo[clickedplayerid][Screameds],PInfo[clickedplayerid][Vomited],PInfo[clickedplayerid][Deaths]);
		if(PInfo[clickedplayerid][ClanID] == -1)
		{
			ShowPlayerDialog(playerid, 228, DSM, sstring, string, "Close", "");
		}
		else if(PInfo[clickedplayerid][ClanID] > -1)
		{
		    new ClanNameStr[192];
			format(ClanNameStr, sizeof ClanNameStr,""cyellow"Clan: "cred"["cwhite"%s"cred"]          %s",PInfo[clickedplayerid][ClanName],sstring);
			ShowPlayerDialog(playerid, 228, DSM,ClanNameStr, string, "Close", "");
		}
	}
	return 1;
}

public OnPlayerInteriorChange(playerid,newinteriorid,oldinteriorid)
{
	if(newinteriorid != 0) StopSound(playerid);
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
						PInfo[playerid][ACWarning] ++;
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked using Teleport Hacks (TP between Vehicles)",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						SendAdminMessage(white,string);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						if(PInfo[playerid][ACWarning] >= 2)
						{
						    CheckCode(playerid,code);
						}
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
				    	if(code == 10)
						{
							PInfo[playerid][ACWarning] ++;
							if(PInfo[playerid][ACWarning] == 2)
							{
								format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Speed Hack",GetPName(playerid));
								SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
								SendAdminMessage(white,string);
								PInfo[playerid][Kicked] = 1;
								SetTimerEx("kicken",20,false,"i",playerid);
								return 1;
							}
							else
							{
							    format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat|WARNING| %s maybe using Speed Hacks (1st Type)",GetPName(playerid));
								SendAdminMessage(white,string);
								return 1;
							}
						}
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
						if(code == 15) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| - %s maybe using Weapon Hack",GetPName(playerid));
						if(code == 16) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| - %s maybe using Ammo Hack",GetPName(playerid));
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
				    	static string[128];
				    	SendAdminMessage(white,string);
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for CJ Run",GetPName(playerid));
						SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
						PInfo[playerid][Kicked] = 1;
						SetTimerEx("kicken",20,false,"i",playerid);
						if(PInfo[playerid][ACWarning] >= 1)
						{
						    CheckCode(playerid,code);
						}
						PInfo[playerid][ACWarning] ++;
						SpawnPlayer(playerid);
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
					case 38:
					{
					    KillTimer(PInfo[playerid][ResetPingWarns]);
					    PInfo[playerid][ResetPingWarns] = SetTimerEx("SetWarnsPing",32000,false,"i",playerid);
					    PInfo[playerid][HighPingWarn] ++;
					    if(PInfo[playerid][HighPingWarn] == 5)
					    {
							static string[128];
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected a High Ping - %s Kicked for 500+ Ping",GetPName(playerid));
							SendAdminMessage(white,string);
							SendClientMessage(playerid,white,"^^ "cred"U-AntiCheat kicked you for high ping (500+), please check your internet connection and connect server again");
							SetTimerEx("kicken",50,false,"i",playerid);
						}
						return 1;
					}
					case 40:
					{
						static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using SandBoxie",GetPName(playerid));
						SendAdminMessage(white,string);
						Kick(playerid);
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
			    	    return 1;
			    	}
				}
				SetTimerEx("KillWarn",30000,false,"i",playerid);
				PInfo[playerid][ACWarning] ++;
				switch(code)
				{
			    	case 2:
					{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Teleport Hacks (1st Type)",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 3)
						{
						    CheckCode(playerid,code);
						}
						return 1;
					}
					case 5: return 1;
			    	case 7..8:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fly Hacks",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 2)
						{
						    CheckCode(playerid,code);
						}
						return 1;
					}
			    	case 11..12:
			    	{
			    	    if(PInfo[playerid][Hiden] == 1) return 0;
			    	    if(PInfo[playerid][ZombieFighting] == 1) return 0;
			    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
				    	static string[128];
						if(code == 11) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Vehicle Health Hack",GetPName(playerid));
						if(code == 12) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Health Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 6)
						{
						    CheckCode(playerid,code);
						}
						return 1;
					}
					case 17:
			    	{
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Infinite ammo Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 2)
						{
						    CheckCode(playerid,code);
						}
						return 1;
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
						    SetTimerEx("KillWarn",30000,false,"i",playerid);
							format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Special Actions Hack",GetPName(playerid));
							SendAdminMessage(white,string);
    						if(PInfo[playerid][ACWarning] >= 2)
							{
							    CheckCode(playerid,code);
							}
						}
						return 1;
					}
					case 19..20:
			    	{
						if(PInfo[playerid][ZombieFighting] == 1) return 0;
			    	    if(Team[playerid] == HUMAN && IsPlayerInCheckpoint(playerid)) return 0;
				    	static string[128];
						format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using GodMode Hack",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 3)
						{
						    CheckCode(playerid,code);
						}
						return 1;
					}
  					case 27..28:
		    		{
				    	static string[128];
						if(code == 27) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fake Spawn",GetPName(playerid));
						if(code == 28) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat |WARNING| %s maybe using Fake Kill",GetPName(playerid));
						SendAdminMessage(white,string);
						if(PInfo[playerid][ACWarning] >= 2)
						{
						    CheckCode(playerid,code);
						}
						return 1;
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
			return 1;
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
			return 1;
		}
		if(projid == PInfo[f][FlashBangObjectProj])
    	{
	        GetProjectilePos(projid,x,y,z);
	        SetObjectRot(PInfo[f][FlashBangObject],270, 180,PInfo[f][ObjAngz]);
			SetObjectPos(PInfo[f][FlashBangObject],x,y,z);
			return 1;
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
   			if(!IsValidProjectile(PInfo[f][ObjectProj])) return 1;
	        new Float:vx,Float:vy,Float:vz;
			GetProjectileVel(projid,vx,vy,vz);
			UpdateProjectileVel(projid,0,0,-5);
	    }
  		if(projid == PInfo[f][FlashBangObjectProj])
	    {
   			if(!IsValidProjectile(PInfo[f][FlashBangObjectProj])) return 1;
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
				PInfo[f][Grenadeproj] = -1;
				ProjectileType[f][2] = 0;
				DestroyDynamicObject(GrenadesObject[f][i]);
				CreatePlayerExplosion(f,x,y,z-1.25,15,15);
				PInfo[f][CanGrenadeAgain] = 1;
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
   			if(!IsValidProjectile(PInfo[i][FlashBangObjectProj])) return 1;
	        PInfo[i][WhatThrow] = 0;
   	 		GetProjectilePos(projid,x,y,z);
	        GetProjectileRot(projid,rx,ry,rz);
	        SetObjectPos(PInfo[i][FlashBangObject],x,y,z);
			PInfo[i][FlashBangObjectProj] = -1;
	        DestroyProjectile(projid);
	        ProjectileType[i][1] = 0;
	        GetObjectPos(PInfo[i][FlashBangObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
	        PInfo[i][Throwed] = 0;
	    }
	    if(projid == PInfo[i][ObjectProj])
	    {
   			if(!IsValidProjectile(PInfo[i][ObjectProj])) return 1;
	        GetProjectilePos(projid,x,y,z);
	        GetProjectileRot(projid,rx,ry,rz);
	        SetObjectPos(PInfo[i][ZObject],x,y,z);
			PInfo[i][ObjectProj] = -1;
	        DestroyProjectile(projid);
	        ProjectileType[i][0] = 1;
	        PInfo[i][WhatThrow] = 0;
	        GetObjectPos(PInfo[i][ZObject],PInfo[i][ZX],PInfo[i][ZY],PInfo[i][ZZ]);
	        PInfo[i][Throwed] = 0;
	        if(PInfo[i][IsBaitWithGr] == 1)
			{
				SetTimerEx("ExplodeBait", 3000, false, "i", i);
				PInfo[i][IsBaitWithGr] = 0;
			}
			KillTimer(PInfo[i][ToBaitTimer]);
	        PInfo[i][ToBaitTimer] = SetTimerEx("MoveTobait",650,true,"i",i);
	        SetTimerEx("StopBait", 15000, false, "i", i);
	    }
    	if(projid == PInfo[i][Grenadeproj])
		{
		    ProjectileType[i][2] = 0;
			PInfo[i][Grenadeproj] = -1;
			return DestroyProjectile(projid);
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
		    /*if(PInfo[playerid][NOPWarnings] == 10)
		    {
				static string[256];
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected that you were using cheat programms and kicked you (NOP code: %i)",nopid);
				SendClientMessage(playerid,white,string);
				SendClientMessage(playerid,white,""cred"If you didn't use any hacks please check your internet connection and connect to the server again");
				SetTimerEx("kicken",100,false,"i",playerid);
				PInfo[playerid][Kicked] = 1;
				format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s was kicked for using anti-NOPs hacks",GetPName(playerid));
				SendAdminMessage(white,string);
			}
			else
			{*/
		    KillTimer(PInfo[playerid][NOPSReset]);
		    PInfo[playerid][NOPWarnings] ++;
		    PInfo[playerid][NOPSReset] = SetTimerEx("ResetNOPsWarnings",30000,false,"i",playerid);
		    if(PInfo[playerid][NOPWarnings] == 1)
		    {
			    static strang[256];
				format(strang,sizeof strang,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s maybe using anti-NOPs hacks (NOP code: %i |count: %i|)",GetPName(playerid),nopid,PInfo[playerid][NOPWarnings]);
				SendAdminMessage(white,strang);
			}
		    if(PInfo[playerid][NOPWarnings] == 10)
		    {
			    static strang[256];
				format(strang,sizeof strang,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s maybe using anti-NOPs hacks (NOP code: %i |count: %i|)",GetPName(playerid),nopid,PInfo[playerid][NOPWarnings]);
				SendAdminMessage(white,strang);
			}
		    if(PInfo[playerid][NOPWarnings] == 20)
		    {
			    static strang[256];
				format(strang,sizeof strang,""cwhite"^^ "cred"U-AntiCheat Detected antiNOPS - %s maybe using anti-NOPs hacks (NOP code: %i |count: %i|)",GetPName(playerid),nopid,PInfo[playerid][NOPWarnings]);
				SendAdminMessage(white,strang);
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
//==============================[PUBLICS END]=================================

/*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\\
========================================COMMANDS Start====================================*/
/*CMD:turnsnow(playerid)
{
	if(PInfo[playerid][Snowon] == 1)
	{
	    PInfo[playerid][Snowon] = 0;
		SendClientMessage(playerid,white,"* "cred"You have turned off snowfall");
	}
	else if(PInfo[playerid][Snowon] == 0)
	{
	    PInfo[playerid][Snowon] = 1;
		SendClientMessage(playerid,white,"* "cred"You have turned on snowfall");
	}
	return 1;
}*/

CMD:achievements(playerid)
{
	SendClientMessage(playerid,white,"*** "cred"Sorry, event is over!");
	/*new GotOrNo[5][32];
 	if(PInfo[playerid][AchievementKills] >= 100) GotOrNo[0] = ""cgreen"Unlocked";
 	else GotOrNo[0] = ""cred"Locked";
	if(PInfo[playerid][AchievementInfect] >=100) GotOrNo[1] = ""cgreen"Unlocked";
	else GotOrNo[1] = ""cred"Locked";
	if(PInfo[playerid][Achievement50Hours] >= 50) GotOrNo[2] = ""cgreen"Unlocked";
	else GotOrNo[2] = ""cred"Locked";
	if(PInfo[playerid][AchievementCollect20] >= 20) GotOrNo[3] = ""cgreen"Unlocked";
	else GotOrNo[3] = ""cred"Locked";
	if(PInfo[playerid][AchievementAllGiven] == 1) GotOrNo[4] = ""cgreen"Unlocked";
	else GotOrNo[4] = ""cred"Locked";
	new string[256];
	format(string,sizeof string,""cblue"Achievement\tStatus\n100 Kills Achievement\t%s\n100 Infecteds Achievement\t%s\nPlay 30 hours Achievement\t%s\nCollect 20 Presents Achievement\t%s\nGet All Achievements\t%s",GotOrNo[0],GotOrNo[1],GotOrNo[2],GotOrNo[3],GotOrNo[4]);
	ShowPlayerDialog(playerid,ACHD,DSTH,""cred"NEW YEAR "cgreen"ACHIEVEMENTS",string,"Info","Close");*/
	return 1;
}

CMD:checkinvehicle(playerid,params[])
{
	new id;
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setmaterials <ID> <Count>");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid,orange,"He is in vehicle!");
	else if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid,orange,"No he is not in vehicle!");
	return 1;
}

CMD:setmaterials(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new id,count;
	if(sscanf(params,"ii",id,count)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setmaterials <ID> <Count>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	PInfo[id][Materials] = count;
	return 1;
}

CMD:setdna(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new id,count;
	if(sscanf(params,"ii",id,count)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setdna <ID> <Count>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	PInfo[id][DNIPoints] = count;
	return 1;
}

CMD:changemod(playerid)
{
	if(Team[playerid] == HUMAN) return SendClientMessage(playerid,white,"* "cred"Only zombies can change modifications!");
	if(PInfo[playerid][Rank] < 15 && PInfo[playerid][AlreadyChangeMod] == 1) return SendClientMessage(playerid,white,"* "cred"You can change modifications 1 time per round!");
   	if((PInfo[playerid][Rank] >= 15 && PInfo[playerid][Rank] < 30) && (PInfo[playerid][AlreadyChangeMod] == 2)) return SendClientMessage(playerid,white,"* "cred"You can change modifications 2 times per round!");
   	if(PInfo[playerid][Rank] >= 30 && PInfo[playerid][AlreadyChangeMod] == 3) return SendClientMessage(playerid,white,"* "cred"You can change modifications 3 times per round!");

	new Slot1[16];
	new Slot2[16];
	new Slot3[16];
	new string[196];
	if(PInfo[playerid][Rank] < 15)
	{
		switch(PInfo[playerid][ModeSlot1])
		{
			case 0: Slot1 = "None";
    	    case 1: Slot1 = "Insane Rage";
			case 2: Slot1 = "Healing Rage";
			case 3: Slot1 = "More Rage";
			case 4: Slot1 = "Imperception";
			case 5: Slot1 = "Accurate Digger";
			case 6: Slot1 = "Dizzy Trap";
			case 7: Slot1 = "Edible Residues";
			case 8: Slot1 = "Resuscitation";
			case 9: Slot1 = "Crowded Stomach";
			case 10: Slot1 = "Regeneration";
			case 11: Slot1 = "Collector";
		}
		format(string,sizeof string,"Slot\tModification\n"cwhite"1st Slot\t"cpurple"%s",Slot1);
		ShowPlayerDialog(playerid,ChangeModDialog,DSTH,""cred"Modification Change",string,"Change","Close");
	}
	if(PInfo[playerid][Rank] >= 15 && PInfo[playerid][Rank] < 30)
	{
		switch(PInfo[playerid][ModeSlot1])
		{
			case 0: Slot1 = "None";
    	    case 1: Slot1 = "Insane Rage";
			case 2: Slot1 = "Healing Rage";
			case 3: Slot1 = "More Rage";
			case 4: Slot1 = "Imperception";
			case 5: Slot1 = "Accurate Digger";
			case 6: Slot1 = "Dizzy Trap";
			case 7: Slot1 = "Edible Residues";
			case 8: Slot1 = "Resuscitation";
			case 9: Slot1 = "Crowded Stomach";
			case 10: Slot1 = "Regeneration";
			case 11: Slot1 = "Collector";
		}
		switch(PInfo[playerid][ModeSlot2])
		{
			case 0: Slot2 = "None";
    	    case 1: Slot2 = "Insane Rage";
			case 2: Slot2 = "Healing Rage";
			case 3: Slot2 = "More Rage";
			case 4: Slot2 = "Imperception";
			case 5: Slot2 = "Accurate Digger";
			case 6: Slot2 = "Dizzy Trap";
			case 7: Slot2 = "Edible Residues";
			case 8: Slot2 = "Resuscitation";
			case 9: Slot2 = "Crowded Stomach";
			case 10: Slot2 = "Regeneration";
			case 11: Slot2 = "Collector";
		}
		format(string,sizeof string,"Slot\tModification\n"cwhite"1st Slot\t"cpurple"%s"cwhite"\n2nd Slot\t"cpurple"%s",Slot1,Slot2);
		ShowPlayerDialog(playerid,ChangeModDialog,DSTH,""cred"Modification Change",string,"Change","Close");
	}
    if(PInfo[playerid][Rank] >= 30)
    {
		switch(PInfo[playerid][ModeSlot1])
		{
			case 0: Slot1 = "None";
    	    case 1: Slot1 = "Insane Rage";
			case 2: Slot1 = "Healing Rage";
			case 3: Slot1 = "More Rage";
			case 4: Slot1 = "Imperception";
			case 5: Slot1 = "Accurate Digger";
			case 6: Slot1 = "Dizzy Trap";
			case 7: Slot1 = "Edible Residues";
			case 8: Slot1 = "Resuscitation";
			case 9: Slot1 = "Crowded Stomach";
			case 10: Slot1 = "Regeneration";
			case 11: Slot1 = "Collector";
		}
		switch(PInfo[playerid][ModeSlot2])
		{
			case 0: Slot2 = "None";
    	    case 1: Slot2 = "Insane Rage";
			case 2: Slot2 = "Healing Rage";
			case 3: Slot2 = "More Rage";
			case 4: Slot2 = "Imperception";
			case 5: Slot2 = "Accurate Digger";
			case 6: Slot2 = "Dizzy Trap";
			case 7: Slot2 = "Edible Residues";
			case 8: Slot2 = "Resuscitation";
			case 9: Slot2 = "Crowded Stomach";
			case 10: Slot2 = "Regeneration";
			case 11: Slot2 = "Collector";
		}
		switch(PInfo[playerid][ModeSlot3])
		{
			case 0: Slot3 = "None";
    	    case 1: Slot3 = "Insane Rage";
			case 2: Slot3 = "Healing Rage";
			case 3: Slot3 = "More Rage";
			case 4: Slot3 = "Imperception";
			case 5: Slot3 = "Accurate Digger";
			case 6: Slot3 = "Dizzy Trap";
			case 7: Slot3 = "Edible Residues";
			case 8: Slot3 = "Resuscitation";
			case 9: Slot3 = "Crowded Stomach";
			case 10: Slot3 = "Regeneration";
			case 11: Slot3 = "Collector";
		}
		format(string,sizeof string,"Slot\tModification\n"cwhite"1st Slot\t"cpurple"%s"cwhite"\n2nd Slot\t"cpurple"%s"cwhite"\n3rd Slot\t"cpurple"%s",Slot1,Slot2,Slot3);
		ShowPlayerDialog(playerid,ChangeModDialog,DSTH,""cred"Modification Change",string,"Change","Close");
	}
	return 1;
}

CMD:date(playerid)
{
	new time = gettime();
	new date = getdate();
	SendFMessage(playerid,white,"Time: %i",time);
	SendFMessage(playerid,white,"Date: %i",date);
	return 1;
}

CMD:afk(playerid)
{
	if(ServerIsAutoBalancing == 1) return SendClientMessage(playerid,white,""cred"You can't go AFK, because random set started!");
	new Float:x,Float:y,Float:z;
	if(PInfo[playerid][Spawned] == 0 || PInfo[playerid][Dead] == 1) return SendClientMessage(playerid,white,""cred"You can't go AFK right now!");
	if(IsPlayerInCheckpoint(playerid)) return SendClientMessage(playerid,white,""cred"You can't go AFK while you are staying in CP!");
	if(PInfo[playerid][Training] == 1) return SendClientMessage(playerid,white,""cred"You can't go AFK right now!");
	if(PInfo[playerid][Afk] == 0)
	{
	    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"? First exit vehicle to go AFK.");
		if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid,red,"? First exit interior.");
	 	if(PInfo[playerid][CanGoAFK] == 0) return SendClientMessage(playerid,red,"? Please wait.");
	 	if(PInfo[playerid][Spectating] == 1) return SendClientMessage(playerid,red,"? You can't got AFK while you are spectating.");
	    GetPlayerPos(playerid,x,y,z);
	    foreach(new i: Player)
	    {
	        if(PInfo[i][Logged] == 0) continue;
	        if(i == playerid) continue;
	        if(IsPlayerInRangeOfPoint(i,100,x,y,z)) return SendClientMessage(playerid,red,"? There must be nobody close to you when you go AFK!");
	    }
	    PInfo[playerid][CanGoAFK] = 0;
	    TogglePlayerControllable(playerid,0);
		SendClientMessage(playerid,white,""cgreen"You will go AFK in 10 seconds!");
		SetTimerEx("GoAFK",10000,false,"i",playerid);
	}
	else if(PInfo[playerid][Afk] == 1)
	{
		SetTimerEx("CanGoAfkAgain",60000,false,"i",playerid);
		SendClientMessage(playerid,white,""cgreen"You will be able to go AFK after minute!");
		TogglePlayerControllable(playerid,1);
		SetPlayerVirtualWorld(playerid,0);
		SetPlayerInterior(playerid,0);
		PInfo[playerid][Afk] = 0;
	}
	return 1;
}

CMD:fakemessage(playerid,params[])
{
	new msg[256];
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	if(sscanf(params,"s[256]",msg)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/fakemessage <Message>");
	SendFMessageToAll(red,"? Administrator %s %s",GetPName(playerid),msg);

	return 1;
}

CMD:dorandomset(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new infectionpers;
	if(sscanf(params,"d",infectionpers)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/dorandomset <Percentage>");
	new string[128];
	format(string,sizeof string,"? Administrator %s started random set on server ||",GetPName(playerid));
	SendClientMessage(playerid,red,string);
	new infects;
	new Iterator:Randomplayers<MAX_PLAYERS>;
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged]== 0) continue;
	    if(Team[i] == ZOMBIE) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][Training] == 1) continue;
	    Iter_Add(Randomplayers,i);
	}
	foreach(new i: Player)
	{
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][Afk] == 1) continue;
	    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
    new rand;
	while(floatround(100.0 * floatdiv(infects, PlayersConnected)) < infectionpers)
	{
	    if(Iter_Random(Randomplayers) == -1) break;
	    rand = Iter_Random(Randomplayers);
		SendClientMessage(rand,white,"** "cred"Autobalance: "cwhite"Random chose you! Help zombies win this round!");
		Team[rand] = ZOMBIE;
		infects ++;
	    new RandomGS = random(sizeof(gRandomSkin));
	    PInfo[rand][Skin] = gRandomSkin[RandomGS];
	    SetPlayerSkin(rand,gRandomSkin[RandomGS]);
	    SetSpawnInfo(rand,1,GetPlayerSkin(rand),0,0,0,0,0,0,0,0,0,0);
		SpawnPlayer(rand);
		Iter_Remove(Randomplayers,rand);
		if(floatround(100.0 * floatdiv(infects, PlayersConnected)) > infectionpers) break;
	}
	return 1;
}

/*CMD:checkonline(playerid)
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
	new infects;
	for(new i; i < MAX_PLAYERS; i ++)
	{
	    if(PInfo[i][Firstspawn] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(IsPlayerNPC(i)) continue;
	    if((PInfo[i][Training] == 1) || (PInfo[i][ChooseAfterTr])) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	new string[32];
	format(string,sizeof string,"Online: %i, Infection: %i",PlayersConnected,floatround(100.0 * floatdiv(infects, PlayersConnected)));
	SendClientMessage(playerid,white,string);
	return 1;
}*/

CMD:claninvite(playerid,params[])
{
	if(PInfo[playerid][ClanID] == -1) return SendClientMessage(playerid,white,"* "cred"Error: You are not in clan!");
	if(PInfo[playerid][ClanLeader] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not a leader!");
	new id,string[128];
	if(sscanf(params,"d",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/claninvite <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not connected!");
	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,white,"* "cred"Error: Player is not logged in!");
	if(PInfo[id][ClanID] > -1) return SendClientMessage(playerid,white,"* "cred"Error: This player is already in clan!");
	if(PInfo[id][ClanIDLeaderInvite] > -1) return SendClientMessage(playerid,white,"* "cred"Error: Someone have already invited this player!");
	format(string,sizeof string,"* "cgreen"%s invites you to his clan! Use /clanaccept to join",GetPName(playerid));
	PlayerPlaySound(id,1058,0,0,0);
	SendClientMessage(id,white,string);
	format(string,sizeof string,""cgreen"You have successfully invited %s to your clan!",GetPName(id));
	SendClientMessage(playerid,white,string);
	PInfo[id][ClanIDLeaderInvite] = playerid;
	return 1;
}

CMD:clanremovemember(playerid,params[])
{
	if(PInfo[playerid][ClanID] == -1) return SendClientMessage(playerid,white,"* "cred"Error: You are not in clan!");
	if(PInfo[playerid][ClanLeader] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not a leader!");
	new id,string[128];
	if(sscanf(params,"d",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/claninvite <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not connected!");
	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,white,"* "cred"Error: Player is not logged in!");
	if(PInfo[id][ClanID] != PInfo[playerid][ClanID]) return SendClientMessage(playerid,white,"* "cred"Error: This player is not in your clan!");
	format(string,sizeof string,"Admin/Users/%s.ini",GetPName(playerid));
    INI_Open(string);
   	INI_WriteInt("ClanID",-1);
	INI_Save();
	INI_Close();
	format(string,sizeof string,"Admin/Clans/%i.ini",PInfo[playerid][ClanID]);
	INI_Open(string);
	new pcount = INI_ReadInt("PlayersCount");
	INI_WriteInt("PlayersCount",pcount--);
	INI_RemoveEntry(GetPName(id));
	INI_Save();
	INI_Close();
	return 1;
}

CMD:cc(playerid,params[])
{
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	if(PInfo[playerid][ClanID] == -1) return SendClientMessage(playerid,white,"* "cred"Error: You are not in clan!");
	new mass[128],string[128];
	if(sscanf(params,"s[128]",mass)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/CC <Message>");
	if(PInfo[playerid][ClanLeader] == 0)
		format(string,sizeof string,""cyellow"|Clan Chat|"cband"|%i| %s: "cred"%s",playerid,GetPName(playerid),mass);
	else if(PInfo[playerid][ClanLeader] == 1)
		format(string,sizeof string,""cyellow"|Clan Chat|"cband"|Leader|"cblue"|%i| %s: "cred"%s",playerid,GetPName(playerid),mass);
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][ClanID] != PInfo[playerid][ClanID]) continue;
	    SendClientMessage(i,white,string);
	}
	return 1;
}

CMD:clanaccept(playerid,params[])
{
	if(PInfo[playerid][ClanIDLeaderInvite] == -1) return SendClientMessage(playerid,orange,"* "cred"Error: Nobody invited you to join clan!");
	if(!IsPlayerConnected(PInfo[playerid][ClanIDLeaderInvite]))
	{
	    PInfo[playerid][ClanIDLeaderInvite] = -1;
		return SendClientMessage(playerid,orange,"* "cred"Error: Nobody invited you to join clan!");
	}
	new string[128];
	format(string,sizeof string,"Admin/Users/%s.ini",GetPName(playerid));
	INI_Open(string);
	INI_WriteInt("ClanID",PInfo[PInfo[playerid][ClanIDLeaderInvite]][ClanID]);
	INI_WriteInt("ClanLeader",0);
	INI_Save();
	INI_Close();
	format(string,sizeof string,"Admin/Clans/%i.ini",PInfo[PInfo[playerid][ClanIDLeaderInvite]][ClanID]);
	INI_Open(string);
	new pcount = INI_ReadInt("PlayersCount");
	INI_WriteInt("PlayersCount",pcount++);
	INI_WriteInt(GetPName(playerid),1);
	INI_Save();
	INI_Close();
	SendClientMessage(playerid,white,""cgreen"You have successfully joined clan!");
	SendClientMessage(playerid,white,""cgreen"Reconnect to server to see changes!");
	format(string,sizeof string,""cgreen"%s joined your clan!",GetPName(playerid));
	SendClientMessage(PInfo[playerid][ClanIDLeaderInvite],white,string);
	PInfo[playerid][ClanIDLeaderInvite] = -1;
	return 1;
}

CMD:setrage(playerid,params[])
{
	static pers;
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	if(sscanf(params,"d",pers)) return 0;
	if(pers >= 100)
	{
    	PInfo[playerid][RageModeStatus] = 100;
	    PInfo[playerid][CanUseRage] = 1;
	}
    else
    {
        PInfo[playerid][RageModeStatus] = pers;
	}
	return 1;
}

CMD:clearchat(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	for(new j = 0; j < 90; j ++)
	{
	 	SendClientMessageToAll(white,"  ");
	}
    SendClientMessageToAll(white,""cred"__________Administrator has cleared the chat!__________");
    return 1;
}

CMD:groupcreate(playerid,params[])
{
	new gname[32];
	if(sscanf(params,"s[32]",gname)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/groupcreate <Group Name>");
	if(PInfo[playerid][GroupIN] > 0) return SendClientMessage(playerid,white,""cwhite"* "cred"Error: You are already in group!");
	if((strlen(gname) > 32) || (strlen(gname) < 3)) return SendClientMessage(playerid,white,"* "cred"Error: Group name length must be between 3 and 16 symbols!");
    GroupID ++;
    new string[256];
    format(string,sizeof string,"* "cgreen"You have successfully created a group %s!",gname);
    SendClientMessage(playerid,white,string);
    PInfo[playerid][GroupIN] = GroupID;
    PInfo[playerid][GroupLeader] = 1;
    PInfo[playerid][GroupPlayers] ++;
    PInfo[playerid][GroupName] = gname;
	return 1;
}

CMD:groups(playerid,params[])
{
	new groupcount = 0;
	SendClientMessage(playerid,white,""cgreen"[Groups List]");
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][GroupIN] == 0) continue;
	    if(PInfo[i][GroupLeader] == 1)
	    {
	        new string[512];
	        format(string,sizeof string,"|| "cgreen"Group: %s "cwhite"|| "cgreen"Leader: |%i|%s "cwhite"|| "cgreen"Group ID: %i",PInfo[i][GroupName],i,GetPName(i),PInfo[i][GroupIN]);
	        SendClientMessage(playerid,white,string);
            groupcount ++;
		}
	}
	new strang[128];
	format(strang,sizeof strang,""cgreen"In total there are %i group(s)",groupcount);
	SendClientMessage(playerid,white,strang);
	return 1;
}

CMD:gc(playerid,params[])
{
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You must be in group to send messages!");
	new text[80],string[256];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/gc <message for group>");
    format(string,sizeof string,""cgreen"|Group Chat|"cblue"|%i| %s: %s",playerid,GetPName(playerid),text);
	foreach(new i: Player)
	{
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	    {
	    	SendClientMessage(i,white,string);
		}
	}
	return 1;
}

CMD:groupinvite(playerid,params[])
{
	new id;
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You must be in group to invite!");
	foreach(new i: Player)
	{
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	    {
	        if(PInfo[i][GroupLeader] == 1)
	        {
	            if(PInfo[i][GroupPlayers] >= 10)
	            {
					SendClientMessage(playerid,white,"* "cred"Error: Your group have 10 users! You can't invite more!");
					break;
				}
			}
		}
	}
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/groupinvite Player's ID");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: This player is not on server!");
	if(PInfo[id][GroupIN] > 0) return SendClientMessage(playerid,white,"* "cred"Error: This player is already in group!");
	if(PInfo[id][InviteID] == PInfo[playerid][GroupIN]) return SendClientMessage(playerid,white,"* "cred"Error: You have already invited this player!");
	PInfo[id][InviteID] = PInfo[playerid][GroupIN];
	new strang[128];
	PlayerPlaySound(id,21002,0,0,0);
	format(strang,sizeof strang,"* "cgreen"You have successfully invited %s to your group!",GetPName(id));
	SendClientMessage(playerid,white,strang);
	new string[256];
	foreach(new i: Player)
	{
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	    {
	        if(PInfo[i][GroupLeader] == 1)
	        {
	        	format(string,sizeof string,"* "cgreen"|%i|%s invited you to join group ["cred"%s"cgreen"]!",playerid,GetPName(playerid),PInfo[i][GroupName]);
	        	break;
	        }
	 	}
	}
	SendClientMessage(id,white,string);
	SendClientMessage(id,white,"* "corange"Write command /groupjoin if you want to accept request");
	return 1;
}

CMD:groupjoin(playerid,params[])
{
	if(PInfo[playerid][InviteID] == 0) return SendClientMessage(playerid,white,"* "cred"Error: Nobody invited you!");
	if(PInfo[playerid][GroupIN] > 0) return SendClientMessage(playerid,white,"* "cred"Error: You are aldready in group!");
    new dead = 0;
	foreach(new i: Player)
	{
	    if(PInfo[i][GroupIN] == PInfo[playerid][InviteID])
	    {
	        if(PInfo[i][GroupLeader] == 1)
	        {
	            if(PInfo[i][GroupPlayers] >= 10)
	            {
					SendClientMessage(playerid,white,"* "cred"Error: This group is full of players!");
					dead = 1;
					break;
				}
			}
		}
	}
	if(dead == 0)
	{
		PInfo[playerid][GroupIN] = PInfo[playerid][InviteID];
		new string[90];
		foreach(new i: Player)
		{
		    if(PInfo[i][Logged] == 0) continue;
		    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		    {
		        if(PInfo[i][GroupLeader] == 1)
		        {
		            PInfo[i][GroupPlayers] ++;
				}
				format(string,sizeof string,"* "cgreen"|%i|%s has joined group!",playerid,GetPName(playerid));
				SendClientMessage(i,white,string);
			}
		}
		PInfo[playerid][InviteID] = 0;
	}
	return 1;
}

CMD:groupquit(playerid,params[])
{
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not in group!");
	if(PInfo[playerid][SureToLeave] == 0)
	{
	    PInfo[playerid][SureToLeave] = 1;
	    if(PInfo[playerid][GroupLeader] == 1)
	    {
			SendClientMessage(playerid,white,"* "cred"Are you sure that you want to leave?");
			SendClientMessage(playerid,white,"* "cred"If you will leave, you wouldn't join this group again without inviting!");
			SendClientMessage(playerid,white,"* "cred"Also random member of your group will become a leader!");
	    	SendClientMessage(playerid,white,"* "cred"If you are sure write /groupquit again");
		}
	    if(PInfo[playerid][GroupLeader] == 0)
	    {
			SendClientMessage(playerid,white,"* "cred"Are you sure that you want to leave?");
			SendClientMessage(playerid,white,"* "cred"If you will leave, you wouldn't join this group again without inviting!");
	    	SendClientMessage(playerid,white,"* "cred"If you are sure write /groupquit again");
		}
	}
	else if(PInfo[playerid][SureToLeave] == 1)
	{
	    PInfo[playerid][SureToLeave] = 0;
	    if(PInfo[playerid][GroupLeader] == 1)
	    {
	        static string[256];
	        foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(i == playerid) continue;
	            if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	            {
                    format(string,sizeof string,"* "cred"%s has left your group, |%i|%s become new leader of group!",GetPName(playerid),i,GetPName(i));
                    PInfo[i][GroupLeader] = 1;
                    PInfo[i][GroupName] = PInfo[playerid][GroupName];
                    PInfo[i][GroupPlayers] = PInfo[playerid][GroupPlayers]-1;
                    break;
				}
			}
	        foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(i == playerid) continue;
	            if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
	            {
	                SendClientMessage(playerid,white,string);
				}
			}
			PInfo[playerid][GroupLeader] = 0;
			PInfo[playerid][GroupPlayers] = 0;
			PInfo[playerid][GroupIN] = 0;
			SendClientMessage(playerid,white,"* "cred"You have successfuly quited group!");
		}
		else if(PInfo[playerid][GroupLeader] == 0)
		{
		    static strang[50];
		    foreach(new i: Player)
		    {
		        if(PInfo[i][Logged] == 0) continue;
		        if(i == playerid) continue;
		        if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
		        {
		            format(strang,sizeof strang,"* "cred"%s has left group!",GetPName(playerid));
		            SendClientMessage(i,white,strang);
		        	if(PInfo[i][GroupLeader] == 1)
		        	{
		                PInfo[i][GroupPlayers] --;
		        	}
				}
		    }
		    SendClientMessage(playerid,white,"* "cred"You have successfuly quited group!");
		    PInfo[playerid][GroupIN] = 0;
		}
	}
 	return 1;
}

CMD:delgmate(playerid,params[])
{
    if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not in group!");
    if(PInfo[playerid][GroupLeader] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You must be a leader of group to use this command!");
    static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/delgmate Player's ID");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not on server!");
	if(PInfo[playerid][GroupIN] != PInfo[id][GroupIN]) return SendClientMessage(playerid,white,"* "cred"Error: This player is not in your group!");
	if(id == playerid) return SendClientMessage(playerid,white,"* "cred"Error: You can't kick yourself from group, use /groupquit to quit group!");
    PInfo[id][GroupIN] = 0;
    PInfo[playerid][GroupPlayers] --;
   	new string[80];
	format(string,sizeof string,""cred"You kicked %s from your group!",GetPName(id));
	SendClientMessage(playerid,white,string);
    SendClientMessage(id,red,""cred"You were removed from group by a leader!");
    new strang[128];
    foreach(new i: Player)
    {
        if(PInfo[i][Logged] == 0) continue;
        if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN])
        {
            if(PInfo[i][GroupLeader] == 0)
            {
				format(strang,sizeof strang,"* "cred"%s was kicked by leader of group!",GetPName(id));
				SendClientMessage(i,white,strang);
			}
		}
	}
    return 1;
}

/*CMD:mygroup(playerid,params[])
{
	new string[128];
	format(string, sizeof string,"You are in %i ID group, Group want to join %i Survivivor want to join %i",PInfo[playerid][GroupIN],PInfo[playerid][GroupWantJoin],PInfo[playerid][SurvivorWantToJoin]);
	SendClientMessage(playerid,white,string);
	return 1;
}*/

CMD:mute(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* Error: "cred"You are not allowed to use this command!");
	static id,reason[40],time;
	if(sscanf(params,"us[40]i",id,reason,time)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/mute <ID> <reason> <time in seconds>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white, "*"cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(id == playerid) return SendClientMessage(playerid,white,"* "cred"Error: You can't mute yourself!");
	if(PInfo[id][Level] > PInfo[playerid][Level]) return SendClientMessage(playerid,white,"* "cred"Error: You can't mute administrators with higher levels!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s muted player %s [Reason: %s] [Time: %i seconds] ||",GetPName(playerid),GetPName(id),reason,time);
	PInfo[id][Muted] = 1;
	PInfo[id][MuteTimer] = time;
	SendAdminMessage(red,string);
	return 1;
}

CMD:unmute(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unmute <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s unmuted player %s ||",GetPName(playerid),GetPName(id));
	PInfo[id][Muted] = 0;
	PInfo[id][MuteTimer] = -1;
	SendAdminMessage(red,string);
	return 1;
}

CMD:jail(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,reason[40],time;
	if(sscanf(params,"us[40]i",id,reason,time)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/jail <ID> <reason> <time in seconds>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred" Error: Player is not found!");
	//if(id == playerid) return SendClientMessage(playerid,red,"Error: You can't jail yourself!");
	if(PInfo[id][Level] > PInfo[playerid][Level]) return SendClientMessage(playerid,white,"* "cred"Error: You can't jail administrators with higher levels!");
	if(PInfo[id][Jailed] == 1) return SendClientMessage(playerid,white,"* "cred"Error: This player is already jailed!");
	static string[100];
	format(string,sizeof string,"|| Administrator %s jailed player %s [Reason: %s] [Time: %i seconds] ||",GetPName(playerid),GetPName(id),reason,time);
	PInfo[id][JailTimer] = time;
	Jail(id);
	new strang[90];
	format(strang,sizeof strang,"~w~You are jailed! ~r~~n~Wait %i seconds until you will be free!",PInfo[playerid][JailTimer]);
	SendClientMessage(id,white,"* "cred"Type "corange"/timeleft"cred" to check how much time left");
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
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,money;
	if(sscanf(params,"ui",id,money)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setzmoney <ID> <zmoney>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s ZMoney to %i",GetPName(playerid),GetPName(id),money);
	PInfo[id][ZMoney] = money;
	SaveStats(id);
	return 1;
}

CMD:givezmoney(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static type,id,money;
	if(sscanf(params,"uui",type,id,money)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/givezmoney <1-add/2-remove> <ID> <zmoney>");
	if(type < 1 || type > 2) return SendClientMessage(playerid,orange,"USAGE: "cblue"/givezmoney <1-add/2-remove> <ID> <zmoney>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s gave %i ZMoney to %s",GetPName(playerid),money,GetPName(id));
	if(type == 1) PInfo[id][ZMoney] = PInfo[id][ZMoney] + money;
	if(type == 2)
	{
		PInfo[id][ZMoney] = PInfo[id][ZMoney] - money;
		if(PInfo[id][ZMoney] < 0) PInfo[id][ZMoney] = 0;
	}
	SaveStats(id);
	return 1;
}

CMD:unjail(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"* "cred" Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unjail <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[id][Jailed] == 0) return SendClientMessage(playerid,white,"* "cred"Error: This player is not jailed!");
	static string[100];
	format(string,sizeof string,"? Administrator %s unjailed player %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	PInfo[id][Jailed] = 0;
	PlayersConnected ++;
	PInfo[id][JailTimer] = -1;
	SendClientMessage(id,white,"* "cred"You were unjailed! Now relog to server to continue play!");
	SetTimerEx("kicken",50,false,"i",id);
	return 1;
}


CMD:shop(playerid,params[])
{
	static Main[60];
	format(Main, sizeof Main,""cgreen"Your ZMoney: "cred"%i",PInfo[playerid][ZMoney]);
    ShowPlayerDialog(playerid,ShopDialog,2,Main,"FAQ\nServices","Choose","Exit");
    return 1;
}

CMD:donate(playerid,params[])
{
	new string[256];
	format(string,sizeof string,""cwhite"It is a donating menu\nWhen you donate, you get special promocode\nIt looks like \""corange"xxxx-xxxx-xxxx-xxx\"\n"cwhite"\n\t\t\t"cwhite"Write promocode below");
	ShowPlayerDialog(playerid,DonateDialog,1,""cred"Donate Menu",string,"Activate","Close");
	return 1;
}

CMD:froze(playerid,params[])
{
   	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred" Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/froze <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Player is not connected!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	TogglePlayerControllable(id, 0);
	static string[100];
	format(string,sizeof string,"? Administrator %s has frozen %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	return 1;
}

CMD:unfroze(playerid,params[])
{
   	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"? Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/froze <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Player is not connected!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	TogglePlayerControllable(id, 1);
	static string[100];
	format(string,sizeof string,"? %s was unfrozed by Administrator %s||",GetPName(id),GetPName(playerid));
	SendAdminMessage(red,string);
	return 1;
}

CMD:weapons(playerid,params[])
{
    if(Team[playerid] == ZOMBIE) SendClientMessage(playerid,white,"** "cred"Only humans can change weapons!");
    if((PInfo[playerid][CanUseWeapons] == 0) && (Team[playerid] == HUMAN)) SendClientMessage(playerid,white,"** "cred"You need to clear Checkpoint, to change weapons again!");
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

CMD:hide(playerid,params[])
{
    if(Team[playerid] == ZOMBIE)
	{
	    if(PInfo[playerid][Training] == 1) return SendClientMessage(playerid,white,"* "cjam"You need to complete the course to hide!");
	    if(PInfo[playerid][CanHide] == 0) return SendClientMessage(playerid,white,"* "cjam"You can't hide too fast!");
		if(PInfo[playerid][Hiden] == 1)
        {
			SendClientMessage(playerid,white,"* "cjam" You have stopped hidding!");
			static sstring[60];
			VehicleHideSomeone[GetPlayerVehicleID(playerid)] = 0;
			//SetSpawnInfo(playerid,1,PInfo[playerid][Skin],0,0,0,0,0,0,0,0,0,0);
			TogglePlayerSpectating(playerid,0);
			format(sstring,sizeof sstring,""cwhite"** "cjam"%s got out from under the seat!",GetPName(playerid));
			SendNearMessage(playerid,white,sstring,15);
			foreach(new i: Player)
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
					PInfo[playerid][CanBite] = 0;
					TogglePlayerSpectating(playerid, 1);
					PInfo[playerid][Hiden] = 1;
					EnableAntiCheatForPlayer(playerid,11,0);
					EnableAntiCheatForPlayer(playerid,4,0);
					EnableAntiCheatForPlayer(playerid,12,0);
					//SetTimerEx("PutVehicle",350,false,"i",playerid);
					PlayerSpectateVehicle(playerid,PInfo[playerid][HideInVehicle],1);
		            foreach(new i: Player)
					{
						ShowPlayerNameTagForPlayer(i,playerid,0);
		 			}
				}
			}
		}
		SetTimerEx("CanUseHide",1500,false,"i",playerid);
		PInfo[playerid][CanHide] = 0;
	}
	else
	{
		SendClientMessage(playerid,red,"* Only zombies can hide!");
 	}
 	return 1;
}

CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid,1000,DSL,"Help menu","Game Mode\nSurvivors\nZombies\nRules\nCommands", "Choose", "Close");
	return 1;
}

CMD:me(playerid,params[])
{
	static msg[128],string[128];
	if(sscanf(params,"s[128]",msg)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/me <action>");
	format(string,sizeof(string),""cjam"%s %s",GetPName(playerid),msg);
 	SendNearMessage(playerid,white,string,25);
	format(string,256,"ME/Action Chat:|%i| %s: %s", playerid, GetPName(playerid), msg);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:tpm(playerid,params[])
{
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	new text[80],string[128];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/tpm <message for team>");
	format(string,sizeof string,"TPM from |%i| %s: %s",playerid,GetPName(playerid),text);
	foreach(new i: Player)
	{
		if(Team[i] == Team[playerid])
		{
		    SendClientMessage(i,0x00E1FFFF,string);
		}
	}
	format(string,256,"TPM:|%i| %s: %s", playerid, GetPName(playerid), text);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:nopm(playerid,params[])
{
	#pragma unused params
	if(PInfo[playerid][NoPM] == 1)
	{
	    PInfo[playerid][NoPM] = 0;
	    SendClientMessage(playerid,white,"* "corange"Now you are opened for PM!");
 	}
 	else
 	{
 	    PInfo[playerid][NoPM] = 1;
	    SendClientMessage(playerid,white,"* "corange"You have blocked PM, now you won't get any messages!");
  	}
	return 1;
}

CMD:r(playerid,params[])
{
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	new string[256],text[80];
	if(sscanf(params,"s[80]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/r <text>");
	if(PInfo[playerid][LastID] == -1) return SendClientMessage(playerid,white,"? "cred"No recent messages!");
	if(PInfo[PInfo[playerid][LastID]][NoPM] == 1) return SendClientMessage(playerid,white,"? "cred"That player does not want to be bother'd with PM's.");
	format(string,sizeof(string),"PM from %s(%i): %s",GetPName(playerid),playerid,text);
	SendClientMessage(PInfo[playerid][LastID],0xFFFF22AA,string);
	PlayerPlaySound(PInfo[playerid][LastID],1058,0,0,0);
	format(string,sizeof(string),"PM sent to %s(%i): %s",GetPName(PInfo[playerid][LastID]),PInfo[playerid][LastID],text);
	SendClientMessage(playerid,0xFFCC2299,string);
	return 1;
}

CMD:pm(playerid,params[])
{
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	new id,text[80],string[256];
	if(sscanf(params,"us[80]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/pm <ID> <message>");
	if(PInfo[id][NoPM] == 1) return SendClientMessage(playerid,white,"? "cred"This player dont want to receive private messages.");
	format(string,sizeof(string),"PM from %s(%i): %s",GetPName(playerid),playerid,text);
	SendClientMessage(id,0xFFFF22AA,string);
	format(string,sizeof(string),"PM sent to %s(%i): %s",GetPName(id),id,text);
	SendClientMessage(playerid,0xFFCC2299,string);
	PlayerPlaySound(id,1058,0,0,0);
	PInfo[id][LastID] = playerid;
	return 1;
}

CMD:groupmates(playerid,params[])
{
	if(PInfo[playerid][GroupIN] == 0) return SendClientMessage(playerid,white,"* "cred"You are not in group!");
	new on,lead[15];
	foreach(new i: Player)
	{
	    if(PInfo[i][GroupIN] == PInfo[playerid][GroupIN]) on++;
 	}
    SendFMessage(playerid,green,""cblue"___There are %i players in your group!",on);
    foreach(new i: Player)
	{
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
	foreach(new i: Player)
	{
	    if(PInfo[i][SecretAdmin] == 1) continue;
	    if(PInfo[i][Level] > 0) on++;
 	}
	SendFMessage(playerid,green,"____ Administrators Online: %i ____",on);
	foreach(new i: Player)
	{
	    if(PInfo[i][Level] == 0) continue;
	    if(PInfo[i][SecretAdmin] == 1) continue;
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
	if(id < 1 || id > 2) return SendClientMessage(playerid,white,"* "cred"Error: Use 1 for "cgreen"HUMAN "cred"and 2 for "cpurple"ZOMBIE");
	if(perk > PInfo[playerid][Rank]) return SendClientMessage(playerid,white,"* "cred"Error: You did not get this perk!");
	if(PInfo[id][Jailed] == 1) return SendClientMessage(playerid,white,"* "cred"Error: You can't use this command when you are jailed!");
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
    if(PInfo[playerid][Muted] == 1)
    {
		static strang[128];
		format(strang,sizeof strang,"You are muted, you will be automatically unmuted in %i seconds",PInfo[playerid][MuteTimer]);
		SendClientMessage(playerid,red,strang);
		return 0;
	}
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/l <message>");
	static string[134];
 	format(string,sizeof string,"%s: %s",GetPName(playerid),text);
	SendNearMessage(playerid,white,string,30);
	format(string,256,"Local Chat:|%i| %s: %s", playerid, GetPName(playerid), text);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:heal(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/heal <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"? Administrator %s(%i) healed %s(%i) ||",GetPName(playerid),playerid,GetPName(id),id);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,100);
	return 1;
}

CMD:killrandom(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new string[128];
	if(CanItRandom == 1)
	{
		format(string,sizeof string,"? Administrator %s has deactivated random set on server ||",GetPName(playerid));
		SendClientMessageToAll(red,string);
		CanItRandom = 0;
	}
	else if(CanItRandom == 0)
	{
		format(string,sizeof string,"? Administrator %s has activated random set on server ||",GetPName(playerid));
		SendClientMessageToAll(red,string);
		CanItRandom = 1;
	}
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("Random",CanItRandom);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:announce(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/announce <Text>");
	static string[128];
	format(string,sizeof string,"~h~~r~%s",text);
	GameTextForAll(string,2100,3);
	return 1;
}

CMD:tpevery(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(IsPlayerNPC(i)) continue;
	    SetPlayerPos(i,x+random(4),y+random(4),z+1);
	}
	static string[128];
	format(string,sizeof string,"? Administrator %s has teleported everyone to his position ||",GetPName(playerid));
	SendAdminMessage(red,string);
	return 1;
}

CMD:getip(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,ipaddress[16];
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/GetIP <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[id][Level] >= PInfo[playerid][Level]) return SendClientMessage(playerid,red,"? Error: You can't check IPs of higher administrators!");
	GetPlayerIp(id,ipaddress,sizeof ipaddress);
	new string[128];
	new IP[40];
	format(string,sizeof string,Userfile,GetPName(id));
	INI_Open(string);
	INI_ReadString(IP,"IP");
	INI_Close();
	format(string,sizeof string,"* "cred"%s|%i|'s IP: "cwhite"%s | Reg IP: %s",GetPName(id),id,ipaddress,IP);
	SendClientMessage(playerid,white,string);
	return 1;
}

CMD:banip(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
 	new type[16],string[128];
	if(sscanf(params, "s[16]", type)) return SendClientMessage(playerid, orange, "USAGE: /BanIP <IP>");
	//if((strlen(type) > 16) || (strlen(type) < 16)) return SendClientMessage(playerid, orange, "? Error: IP-Addresses length must be 16!");
	/*format(string, sizeof(string),"banip %s", type);
	SendRconCommand(string);
	SendRconCommand("reloadbans");*/
	foreach(new i: Player)
	{
	    new IP1[16],IP2[16];
	    GetPlayerIp(i, IP1, sizeof(IP1));
	    foreach(new g: Player)
	    {
	        if(i == g) continue;
	        GetPlayerIp(g, IP2, sizeof(IP2));
	        format(string,sizeof string,"* "cred"Error: Player |%i|%s is connected, kick him before you ban IP",i,GetPName(i));
	        if(!strcmp(IP1, IP2, true)) return SendClientMessage(playerid,white,string);
	    }
	}
    new iniFile = ini_openFile("Admin/BannedIPs.ini");
    format(string, sizeof(string), "%s", type);
    ini_setInteger(iniFile,string,1);
    ini_closeFile(iniFile);
    format(string, sizeof(string), "? Administrator %s has banned IP-address: %s ||", GetPName(playerid),type);
	foreach(new i: Player)
	{
	    if(PInfo[i][Level] < 2) continue;
    	SendClientMessage(i,red,string);
	}
	SaveIn("BanIPlog",string,1);
    printf("[Banip] %s banned IP: %s", GetPName(playerid), type);
    return 1;
}

CMD:unbanip(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
 	new type[16],string[256];
	if(sscanf(params, "s[16]", type)) return SendClientMessage(playerid, orange, "USAGE: /UnBanIP <IP>");
    new iniFile = ini_openFile("Admin/BannedIPs.ini");
    format(string, sizeof(string), "%s", type);
    ini_setInteger(iniFile,string,0);
    ini_closeFile(iniFile);
    format(string, sizeof(string), "? Administrator %s has unbanned IP-address: %s ||", GetPName(playerid),type);
	foreach(new i: Player)
	{
	    if(PInfo[i][Level] < 2) continue;
    	SendClientMessage(i,red,string);
	}
	SaveIn("BanIPlog",string,1);
    printf("[Banip] %s unbanned IP: %s", GetPName(playerid), type);
	return 1;
}

CMD:unban(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static nickname[50],string[256];
	if(sscanf(params,"s[50]",nickname)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/unban <NickName>");
	static y,mm,d;
	getdate(y,mm,d);
	static file[500];
	format(file,sizeof file,Userfile,nickname);
	if(!fexist(file)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found in database!");
	else
	{
		INI_Open(file);
		if(INI_ReadInt("Banned") == 0)
		{
			SendClientMessage(playerid,white,"* "cred"Error: Player is not banned!");
			INI_Close();
			return 1;
		}
		if(INI_ReadInt("Warns") == 3)
		{
		    INI_WriteInt("Warns",0);
		}
		INI_WriteInt("Banned",0);
		INI_RemoveEntry("BanReason");
		INI_RemoveEntry("BanDate");
		INI_RemoveEntry("WhoBanned");
		INI_Save();
		INI_Close();
	}
	SendFMessageToAll(red,"? Administrator %s has unbanned %s ||",GetPName(playerid),nickname);
	format(string,sizeof string,"? Administrator %s has unbanned %s",GetPName(playerid),nickname);
	SaveIn("Banlog",string,1);
	format(string,sizeof string,"%s has unbanned %s.",GetPName(playerid),nickname);
	return 1;
}

CMD:banoff(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static nickname[100],string[256],reason[64],time,type;
	if(sscanf(params,"s[100]iis[64]",nickname,type,time,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/banoff <NickName> <Type: 1-Hours,2-Days,3-Permament> <Time (if permament use any)> <Reason>");
	if(type < 1 || type > 3) return SendClientMessage(playerid,orange,"USAGE: "cblue"/banoff <NickName> <Type: 1-Hours,2-Days,3-Permament> <Time (if permament use any)> <Reason>");
	if(time <= 0 && type != 3)  return SendClientMessage(playerid,orange,"* "cred"Error: You can't ban for 0 hours/days!");
	static y,mm,d;
	getdate(y,mm,d);
	static file[500];
	format(file,sizeof file,Userfile,nickname);
	foreach(new i: Player)
	{
	    new nick[40];
	    GetPlayerName(i,nick,sizeof nick);
	    if(!strcmp(nick, nickname, true)) return SendClientMessage(playerid,white,"* "cred"Error: Player is connected!");
	}
	if(!fexist(file)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found in database!");
	else
	{
		INI_Open(file);
		if((PInfo[playerid][Level]) <= (INI_ReadInt("Level")))
		{
		    INI_Close();
  			return SendClientMessage(playerid,white,"* "cred"Error: This player have higher level than you!");
		}
		if(INI_ReadInt("Banned") == 1) return SendClientMessage(playerid,white,"* "cred"Error: This player is already banned!");
		else
		{
		    new ds[128],hour,minute,second;
		    getdate(y,mm,d);
		    gettime(hour,minute,second);
		    format(ds, sizeof ds,"%02d/%02d/%d | %02d:%02d:%02d",d,mm,y,hour,minute,second);
			INI_WriteInt("Banned",1);
			INI_WriteString("BanReason",reason);
			INI_WriteString("WhoBanned",GetPName(playerid));
			INI_WriteString("BanDate",ds);
			if(type == 1)
				INI_WriteInt("BanTime",gettime() + 3600*time);
			else if(type == 2)
			    INI_WriteInt("BanTime",gettime() + 86400*time);
			else if(type == 3)
				INI_WriteInt("BanTime",-1);
			INI_Save();
			INI_Close();
		}
	}
	if(type == 1)
		SendFMessageToAll(red,"? Administrator %s has banned offline %s [Reason: %s][Time: %i Hours]||",GetPName(playerid),nickname,reason,time);
	else if(type == 2)
		SendFMessageToAll(red,"? Administrator %s has banned offline %s [Reason: %s][Time: %i Days]||",GetPName(playerid),nickname,reason,time);
	else if(type == 3)
		SendFMessageToAll(red,"? Administrator %s has banned offline %s [Reason: %s]||",GetPName(playerid),nickname,reason);
    if(type == 1)
		format(string,sizeof string,"? Administrator %s has banned offline %s [Reason: %s][Time: %i Hours]",GetPName(playerid),nickname,reason,time);
    else if(type == 2)
		format(string,sizeof string,"? Administrator %s has banned offline %s [Reason: %s][Time: %i Days]",GetPName(playerid),nickname,reason,time);
    else if(type == 3)
		format(string,sizeof string,"? Administrator %s has banned offline %s [Reason: %s]",GetPName(playerid),nickname,reason);

	SaveIn("Banlog",string,1);
	return 1;
}

CMD:sethealth(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,health;
	if(sscanf(params,"ui",id,health)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/SetPlayerHealth <ID> <health>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"? Administrator %s has setted %s health to %i ||",GetPName(playerid),GetPName(id),health);
	SendAdminMessage(red,string);
	SetPlayerHealth(id,health);
	return 1;
}

CMD:spec(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"? Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/spec <ID>");
 	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[playerid][Afk] == 1) return SendClientMessage(playerid,white,"* "cred"Error: You can't spectate while you are AFK!");
 	if(id == playerid) return SendClientMessage(playerid,white,"* "cred"Error: You can't spectate yourself!");
 	if(PInfo[id][Spectating] == 1) return SendClientMessage(playerid,white,"* "cred"Error: This player is spectating someone!");
 	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,white,"* "cred"Error: This player is not logged in!");
	if(PInfo[id][Spawned] == 0) return SendClientMessage(playerid,white,"* "cred"Error: This player is not spawned!");
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
    foreach(new i: Player)
    {
        if(PInfo[i][Level] >= 1)
        {
			static string[128];
			format(string,sizeof string,""cred"? Administrator %s started spectating %s",GetPName(playerid),GetPName(id));
			SendClientMessage(i,white,string);
		}
	}
	PInfo[playerid][SpecID] = id;
	PInfo[playerid][Spectating] = 1;
	PInfo[playerid][AllowToSpawn] = 1;
	SetPlayerHealth(playerid,10000000);
    SendClientMessage(playerid,white,"* "cred"You've started spectate, use /specoff to stop spectating");
    SendClientMessage(playerid,white,"* "cred"Press "corange"SPACE "cred"to update spectating mode");
	return 1;
}

CMD:specoff(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    if(PInfo[playerid][Spectating] == 0) return SendClientMessage(playerid,white,"* "cred"Error: You are not spectating!");
	foreach(new i: Player)
    {
        if(PInfo[i][Level] >= 1)
        {
			static string[128];
			format(string,sizeof string,""cred"? Administrator %s stopped spectating",GetPName(playerid));
			SendClientMessage(i,white,string);
		}
	}
	SetPlayerVirtualWorld(playerid,0);
	TogglePlayerSpectating(playerid, 0);
 	SetCameraBehindPlayer(playerid);
 	//SetTimerEx("restorpos",1500,false,"i",playerid);
 	PInfo[playerid][SpecID] = -1;
 	SendClientMessage(playerid,white,"* "cred"You've stopped spectate");
 	return 1;
}

CMD:nuke(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/nuke <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	CreateExplosion(x,y,z,8,2);
	static string[100];
	format(string,sizeof string,"? Administrator %s has nuked %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:bslap(playerid,params[])
{
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"? Error: "cred"You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/bslap <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+9);
	static string[100];
	format(string,sizeof string,"? Administrator %s has slapped %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

CMD:slap(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/slap <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	SetPlayerPos(id,x,y,z+6);
	static string[100];
	format(string,sizeof string,"? Administrator %s has slapped %s ||",GetPName(playerid),GetPName(id));
	SendClientMessageToAll(red,string);
	return 1;
}

/*CMD:saveuser(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"? Error: "cred"You are not allowed to use this command!");
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
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/goto <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(id,x,y,z);
	if(IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid),x,y+3,z);
	}
	else SetPlayerPos(playerid,x,y+3,z);
	SetPlayerInterior(playerid,GetPlayerInterior(id));
	static string[100];
	format(string,sizeof string,"? Administrator %s has teleported to %s ||",GetPName(playerid),GetPName(id));
	SendAdminMessage(red,string);
	return 1;
}

CMD:put(playerid,params[])
{
	if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static idf, ids;
	if(sscanf(params,"uu",idf,ids)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/put <who TP ID> <TP to ID");
	if(!IsPlayerConnected(idf)) return SendClientMessage(playerid,white,"* "cred"Error: One of players is not found!");
	if(!IsPlayerConnected(ids)) return SendClientMessage(playerid,white,"* "cred"Error: One of players is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(ids,x,y,z);
	if(IsPlayerInAnyVehicle(idf))
	{
	    SetVehiclePos(GetPlayerVehicleID(idf),x,y+3,z);
	}
	else SetPlayerPos(idf,x,y+3,z);
	SetPlayerInterior(idf,GetPlayerInterior(ids));
	static string[100];
	format(string,sizeof string,"? Administrator %s has teleported %s to %s ||",GetPName(playerid),GetPName(idf),GetPName(ids));
	SendAdminMessage(red,string);
	return 1;
}

CMD:kick(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/kick <ID> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[id][Level] >= 6) return SendClientMessage(playerid,white,"* "cred"Error: This player can't be kicked!");
	static string[100];
	format(string,sizeof string,"? Administrator %s(%i) kicked player %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	SetTimerEx("kicken",100,false,"i",id);
	SendClientMessageToAll(red,string);
	SaveIn("Kicklog",string,1);
	return 1;
}

CMD:skick(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,reason[40];
	if(sscanf(params,"us[40]",id,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/skick <ID> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static string[100];
	format(string,sizeof string,"? Administrator %s(%i) "cyellow"QUITLY "cred"kicked player %s [Reason: %s] ||",GetPName(playerid),playerid,GetPName(id),reason);
	SetTimerEx("kicken",100,false,"i",id);
	SendAdminMessage(red,string);
	SaveIn("Kicklog",string,1);
	return 1;
}

CMD:sban(playerid,params[])
{
    if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    static id,type,time,reason[40];
   	if(sscanf(params,"uuus[40]",id,type,time,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/sban <ID> <Type:1-hours,2-days,3-permament> <Time(if permament use any)> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[id][Level] >= PInfo[playerid][Level]) return SendClientMessage(playerid,white,"* "cred"Error: This player has a higher level than you!");
	if(type < 1 || type > 3) return SendClientMessage(playerid,orange,"USAGE: "cblue"/sban <ID> <Type:1-hours,2-days,3-permament> <Time(if permament use any)> <reason>");
	if(time <= 0 && type != 3) return SendClientMessage(playerid,white,"* "cred"Error: You can't ban for 0 hours/days!");
	static string[500],y,mm,d,ds[128],hour,minute,second;
	if(type == 1)
		format(string,sizeof string,"Administrator %s has "cyellow"QUETELY"cred" banned %s. [Reason: %s][Time: %i Hours]",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 2)
 		format(string,sizeof string,"? Administrator %s has "cyellow"QUETELY"cred" banned %s [Reason: %s][Time: %i Days]||",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 3)
	 		format(string,sizeof string,"? Administrator %s has "cyellow"QUETELY"cred" banned %s [Reason: %s]||",GetPName(playerid),GetPName(id),reason);
	SendAdminMessage(red,string);
	getdate(y,mm,d);
	gettime(hour,minute,second);
    if(type == 1)
		format(string,sizeof string,"Administrator %s has QUITELY banned %s. [Reason: %s][Time: %i Hours]",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 2)
 		format(string,sizeof string,"? Administrator %s has QUITELY banned %s [Reason: %s][Time: %i Days]||",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 3)
 		format(string,sizeof string,"? Administrator %s has QUITELY banned %s [Reason: %s]||",GetPName(playerid),GetPName(id),reason);

	SaveIn("Banlog",string,1);

	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason: %s. \nDate: %02d/%02d/%d \nTime: %02d:%02d:%d\n\n\n\t"cgreen"\nIf you think that you got ban for nothing\nTake a picture of this box and post an unban appeal at our forum.",GetPName(playerid),GetPName(id),GetHisIP(id),reason,d,mm,y,hour,minute,second);
	ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");

	format(ds, sizeof ds,"%02d/%02d/%d | %02d:%02d:%02d",d,mm,y,hour,minute,second);

	format(string,sizeof string, Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Banned",1);
	INI_WriteString("BanReason",reason);
	INI_WriteString("WhoBanned",GetPName(playerid));
	INI_WriteString("BanDate",ds);
	if(type == 1)
		INI_WriteInt("BanTime",gettime() + time*3600);
    else if(type == 2)
        INI_WriteInt("BanTime",gettime() + time*86400);
	else if(type == 3)
	    INI_WriteInt("BanTime",-1);
	INI_Save();
	INI_Close();
	SetTimerEx("kicken",100,false,"i",id);
	return 1;
}

CMD:ban(playerid,params[])
{
    if(PInfo[playerid][Level] < 3) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    static id,type,time,reason[40];
   	if(sscanf(params,"uiis[40]",id,type,time,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ban <ID> <Type:1-hours,2-days,3-permament> <Time(if permament use any)> <reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[id][Level] >= PInfo[playerid][Level]) return SendClientMessage(playerid,white,"* "cred"Error: This player has a higher level than you!");
	if(type < 1 || type > 3) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ban <ID> <Type:1-hours,2-days,3-permament> <Time(if permament use any)> <reason>");
	if(time <= 0 && type != 3) return SendClientMessage(playerid,white,"* "cred"Error: You can't ban for 0 hours/days!");
	static string[500],y,mm,d,ds[128],hour,minute,second;
	if(type == 1)
		format(string,sizeof string,"Administrator %s has banned %s. [Reason: %s][Time: %i Hours]",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 2)
 		format(string,sizeof string,"? Administrator %s has banned %s [Reason: %s][Time: %i Days]||",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 3)
	 		format(string,sizeof string,"? Administrator %s has banned %s [Reason: %s]||",GetPName(playerid),GetPName(id),reason);
	SendClientMessageToAll(red,string);
	getdate(y,mm,d);
	gettime(hour,minute,second);
    if(type == 1)
		format(string,sizeof string,"Administrator %s has banned %s. [Reason: %s][Time: %i Hours]",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 2)
 		format(string,sizeof string,"? Administrator %s has banned %s [Reason: %s][Time: %i Days]||",GetPName(playerid),GetPName(id),reason,time);
	else if(type == 3)
 		format(string,sizeof string,"? Administrator %s has banned %s [Reason: %s]||",GetPName(playerid),GetPName(id),reason);

	SaveIn("Banlog",string,1);

	format(string,sizeof string ,""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason: %s. \nDate: %02d/%02d/%d \nTime:%02d:%02d:%d\n\n\n\t"cgreen"\nIf you think that you got ban for nothing\nTake a picture of this box and post an unban appeal at our forum.",GetPName(playerid),GetPName(id),GetHisIP(id),reason,d,mm,y,hour,minute,second);
	ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");

	format(ds, sizeof ds,"%02d/%02d/%d | %02d/%02d/%02d",d,mm,y,hour,minute,second);

	format(string,sizeof string, Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Banned",1);
	INI_WriteString("BanReason",reason);
	INI_WriteString("WhoBanned",GetPName(playerid));
	INI_WriteString("BanDate",ds);
	if(type == 1)
		INI_WriteInt("BanTime",gettime() + time*3600);
    else if(type == 2)
        INI_WriteInt("BanTime",gettime() + time*86400);
	else if(type == 3)
	    INI_WriteInt("BanTime",-1);
	INI_Save();
	INI_Close();
	SetTimerEx("kicken",100,false,"i",id);
	return 1;
}

CMD:get(playerid,params[])
{
    if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id;
	if(sscanf(params,"u",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/get <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	static Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(IsPlayerInAnyVehicle(id))
	{
	    SetVehiclePos(GetPlayerVehicleID(id),x,y+3,z);
	}
	else SetPlayerPos(id,x,y+3,z);
	SetPlayerInterior(id,GetPlayerInterior(playerid));
	static string[100];
	format(string,sizeof string,"? Administrator %s has teleported %s to his location ||",GetPName(playerid),GetPName(id));
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
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static text[128];
	if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ac <message>");
	foreach(new i: Player)
	{
		if(!IsPlayerConnected(i)) continue;
	    if(PInfo[i][Level] >= 1)
	    {
			new string[128];
			format(string,sizeof string,""cblue"|Admin Chat|"cgrey"|%i|"cred"%s: "cband"%s",playerid,GetPName(playerid),text);
	        SendClientMessage(i,white,string);
		}
	}
	new string[256];
	format(string,sizeof string,"Admin Chat:|%i| %s: %s", playerid, GetPName(playerid), text);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:amc(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    static text[128];
    if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/amc <message>");
	new string[128];
	format(string,sizeof string,""cwhite"** "cred"ADMINISTRATOR: "corange"%s",text);
    SendClientMessageToAll(white,string);
	format(string,256,"Admin Main Chat:|%i| %s: %s", playerid, GetPName(playerid), text);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:report(playerid,params[])
{
	static id,text[128];
	if(sscanf(params,"us[128]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/report <ID> <reason>");
	if(!IsPlayerConnected(id) || IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	foreach(new i: Player)
	{
     	if((PInfo[i][Level] >= 1) || (IsPlayerAdmin(i)))
     	{
			static string[128];
			format(string, sizeof string,""cred"|Report| |%i|%s reported |%i|%s Reason: %s",playerid,GetPName(playerid),id,GetPName(id),text);
			SendClientMessage(i,white,string);
		}
	}
	SendClientMessage(playerid,white,""cwhite"* "corange"Thanks for reporting, online administrators will check it soon!");
	return 1;
}

CMD:ans(playerid,params[])
{
	if(PInfo[playerid][Level] < 1) SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,text[128],string[256];
	if(sscanf(params,"us[128]",id,text)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/ans <ID> <message>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	format(string,sizeof string,"? Administrator |%i|%s: "corange"%s",playerid,GetPName(playerid),text);
	SendClientMessage(id,red,string);
	format(string,sizeof string,"? Administrator |%i|%s: "corange"%s |To %s|%i||",playerid,GetPName(playerid),text,GetPName(id),id);
	SendAdminMessage(white,string);
	PlayerPlaySound(id,1058,0,0,0);
	format(string,256,"Admin Answer:|%i| %s: %s", playerid, GetPName(playerid), text);
	SaveIn("ChatLog",string,1);
	return 1;
}

CMD:setteam(playerid,params[])
{
    if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,team,reason[64];
	if(sscanf(params,"uis[64]",id,team,reason)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setteam <id> <1 = Human | 2 = Zombie> <Reason>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(team == ZOMBIE)
	{
	    new string[128];
	    SetPlayerSkin(id,ZombieSkins[random(sizeof(ZombieSkins))]);
	    Team[id] = ZOMBIE;
        new RandomGS = random(sizeof(gRandomSkin));
        PInfo[id][Skin] = gRandomSkin[RandomGS];
		SetSpawnInfo(id,1,PInfo[id][Skin],0,0,0,0,0,0,0,0,0,0);
	    SetPlayerColor(id,purple);
	    SpawnPlayer(id);
	    SetPlayerHealth(id,100);
	    PInfo[id][GroupIN] = 0;
		format(string,sizeof string,""cred"? Administrator %s has set %s's team to [ZOMBIE] [Reason: %s]",GetPName(playerid),GetPName(id),reason);
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
		{
			if(sid == ZombieSkins[i]) goto ChooseSkin;
		}
		if(sid == 0 || sid == 74 || sid == 99 || sid == 92) goto ChooseSkin;
	    SetPlayerSkin(id,sid);
	    PInfo[id][Skin] = sid;
	    PInfo[id][JustInfected] = 0;
	    PInfo[id][AllowToSpawn] = 1;
	    PInfo[id][Infected] = 0;
		PInfo[id][Dead] = 0;
		PInfo[id][CanBite] = 1;
        /*new RandomBS = random(sizeof(bRandomSkin));
        PInfo[id][Skin] = RandomBS;*/
        SetSpawnInfo(id,1,sid,0,0,0,0,0,0,0,0,0,0);
		SpawnPlayer(id);
		SetPlayerColor(id,green);
		SetPlayerHealth(id,100);
		format(string,sizeof string,""cred"? Administrator %s has set %s's team to [HUMAN] [Reason: %s]",GetPName(playerid),GetPName(id),reason);
		SendClientMessageToAll(white,string);
		DestroyObject(PInfo[id][MeatSObject]);
		DestroyObject(PInfo[id][Vomit]);
		PInfo[id][ShareMeatVomited] = 0;
		DestroyDynamic3DTextLabel(PInfo[id][LabelMeatForShare]);
		KillTimer(PInfo[id][ToxinTimer]);
		KillTimer(PInfo[id][VomitDamager]);
	}
	else SendClientMessage(playerid,white,"* "cred"Error: team doesn't found");
	return 1;
}

CMD:setlevel(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setlevel <id> <level>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(level > 6) return SendClientMessage(playerid,red,"Maximum admin level is 6!");
	if(PInfo[playerid][Level] <= PInfo[id][Level]) return SendClientMessage(playerid,white,"* "cred"Error:This admin have a higher level than you!");
	SendFMessageToAll(red,"? Administrator %s has setted %s admin level to %i",GetPName(playerid),GetPName(id),level);
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
	if(PInfo[playerid][Level] < 1) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
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
	if(PInfo[playerid][Level] < 2) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,warn[64],string[440],string2[128];
	if(sscanf(params,"us[64]",id,warn)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/warn <id> <warn>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	if(PInfo[playerid][Level] <= PInfo[id][Level]) return SendClientMessage(playerid,white,"* "cred"Error: This admin have a higher level than you!");
	format(string,sizeof string,"? Administrator %s has warned %s [Reason: %s]",GetPName(playerid),GetPName(id),warn);
	SendClientMessageToAll(red,string);
	format(string,sizeof string,Userfile,GetPName(id));
	INI_Open(string);
	INI_WriteInt("Warns",INI_ReadInt("Warns")+1);
	format(string,sizeof string,"Warn%i",INI_ReadInt("Warns"));
	SendFMessage(id,red,"? You have %i warnings.",INI_ReadInt("Warns"));
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
	    SendFMessageToAll(red,"? Administrator %s has banned %s [Reason: 3 Warnings]",GetPName(playerid),GetPName(id));
		SendFMessageToAll(red,"||Warning 1: %s||",warn1);
		SendFMessageToAll(red,"||Warning 2: %s||",warn2);
		SendFMessageToAll(red,"||Warning 3: %s||",warn3);
		format(string2,sizeof string2,"%s has banned %s",GetPName(playerid),GetPName(id));
		format(string,sizeof(string),""corange"Administrator name: %s \nYour name: %s \nYour IP Address: %s \nReason why you got banned: 3 Warnings. \nDate: %d/%d/%d \n\n\n\t"cgreen"Take a screenshot of this dialog and post an unban appeal at "cred"ug-ultimategaming.proboards.com",GetPName(playerid),GetPName(id),GetHisIP(id),d,mm,y);
		ShowPlayerDialog(id,4533,0,""cred"You have been banned - read the following details!",string,"Close","");
		BanEx(id,string);
		INI_Save();
	}
	INI_Close();
	return 1;
}

CMD:setrank(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,level;
	if(sscanf(params,"ui",id,level)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setrank <id> <rank>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s rank to %i",GetPName(playerid),GetPName(id),level);
	PInfo[id][Rank] = level;
	ResetPlayerWeapons(id);
	CheckRankup(id,1);
	return 1;
}

CMD:setxp(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setxp <id> <xp>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s XP to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][XP] = xp;
	CheckRankup(playerid);
	return 1;
}

CMD:setkills(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setkills <id> <kills>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s kills to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Kills] = xp;
	return 1;
}

CMD:restartserver(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	foreach(new i: Player)
	{
		new string[256];
		format(string,sizeof string,"*** "cred"ANNOUNCE: "cblue"Administrator %s restarted server! Your stats have been automatically saved!",GetPName(playerid));
		SendClientMessage(i,white,string);
	}
	SetTimer("RestartServer",1000,false);
	return 1;
}

CMD:setdeaths(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setdeaths <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s deaths to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Deaths] = xp;
	return 1;
}

CMD:setinfects(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	static id,xp;
	if(sscanf(params,"ui",id,xp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setinfects <id> <deaths>");
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	SendFMessageToAll(red,"? Administrator %s has setted %s infects to %i",GetPName(playerid),GetPName(id),xp);
	PInfo[id][Infects] = xp;
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

CMD:setclearedcp(playerid,params[])
{
	if(PInfo[playerid][Level] <= 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new cp;
	if(sscanf(params,"i",cp)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/setclearedcp <RoundClearedCP>");
	if((cp < 0) || (cp > 8)) return SendClientMessage(playerid,white,"* "cred"Error: Cleared CPs must be between 0 and 8!");
	CPscleared = cp;
    static string2[96];
    format(string2,sizeof string2,"~w~CHECKPOINTS CLEARED: %i/~r~~h~8",CPscleared);
    foreach(new i: Player)
    {
		TextDrawSetString(CPSCleared[playerid],string2);
	}
	return 1;
}

CMD:evoidhim(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    new id;
	if(sscanf(params,"i",id)) return SendClientMessage(playerid,orange,"USAGE: "cblue"/evoidhim <ID>");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not connected!");
	if(PInfo[id][Logged] == 0) return SendClientMessage(playerid,white,"* "cred"Error: Player is not Logged In!");
	PInfo[id][EvoidingCP] = 1;
	return 1;
}
CMD:letsdothat(playerid,params[])
{
    if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"? Error: "cred"You are not allowed to use this command!");
	DropSupply();
	return 1;
}

CMD:createclan(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new clanname[32],nickname[32],string[128];
	if(sscanf(params,"s[32]s[32]",nickname,clanname)) return SendClientMessage(playerid,white,""corange"USAGE: "cblue"/createclan <Leader's NickName> <ClanName>");
    if(strlen(clanname) < 3 || strlen(clanname) > 32) return SendClientMessage(playerid,white,"* "cred"Error: Clan's name length must be more than 3 and not more than 32 symbols!");
	static file[128];
	format(file,sizeof file,Userfile,nickname);
	if(!INI_Exist(file)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found in our database!");
	INI_Open(file);
	if(INI_ReadInt("ClanID") > -1) return SendClientMessage(playerid,white,"* "cred"Error: Player is in someone's clan!");
	INI_Close();
	INI_Open("Admin/Config/ServerConfig.ini");
    new clansamount = INI_ReadInt("Clans")+1;
    INI_WriteInt("Clans",clansamount);
    INI_Save();
    INI_Close();
	new cfile[64];
	format(cfile,sizeof cfile,"Admin/Clans/%i.ini",clansamount);
	INI_Open(cfile);
	INI_WriteString("ClanName",clanname);
	INI_WriteInt("ClanRemoved",0);
	INI_WriteInt("WarPoints",0);
	INI_WriteString("ClanLeader",nickname);
	INI_WriteInt("PlayersCount",1);
	INI_Save();
	INI_Close();
	format(file,sizeof file,Userfile,nickname);
	INI_Open(file);
	INI_WriteInt("ClanID",clansamount);
	INI_WriteInt("ClanLeader",1);
	INI_Save();
	INI_Close();
	format(string,sizeof string,"? Administrator %s has created clan %s for leader %s ||",GetPName(playerid),clanname,nickname);
	SendClientMessageToAll(red,string);
	SendClientMessage(playerid,white,"* "cred"If leader is online he should reconnect to join his clan!");
	return 1;
}

CMD:canvote(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    new string[128];
	if(VoteEnable == 0)
	{
	    VoteEnable = 1;
		format(string,sizeof string,"? "cred"Administrator %s has activated votings on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	else if(VoteEnable == 1)
	{
	    VoteEnable = 0;
		format(string,sizeof string,"? "cred"Administrator %s has deactivated votings on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("VoteEnable",VoteEnable);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:extraxp(playerid,params[])
{
   	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
	new muchxp;
	if(sscanf(params,"d",muchxp)) return SendClientMessage(playerid,white,""corange"USAGE: "cblue"/extraxp <XP multiplier> ");
	if(muchxp < 1) return SendClientMessage(playerid,white,"* "cred"Error: XP multiplier must be 1 or more!");
    ExtraXPEvent = muchxp;
    new string[128];
	format(string,sizeof string,"? "cred"Administrator %s has setted XP multiplier to %d!",GetPName(playerid),muchxp);
	SendClientMessageToAll(white,string);
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("ExtraXP",muchxp);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:enableanticheat(playerid,params[])
{
	if(PInfo[playerid][Level] < 5) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    new string[256];
	if(AnticheatEnabled == 0)
	{
	    AnticheatEnabled = 1;
		format(string,sizeof string,"? "cred"Administrator %s has activated anticheat on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	else if(AnticheatEnabled == 1)
	{
	    AnticheatEnabled = 0;
		format(string,sizeof string,"? "cred"Administrator %s has deactivated anticheat on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("AnticheatEnable",AnticheatEnabled);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:testmode(playerid,params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    new string[256];
	if(developmode == 0)
	{
	    developmode = 1;
		format(string,sizeof string,"? "cred"Administrator %s has activated testing mode on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	else if(developmode == 1)
	{
	    developmode = 0;
		format(string,sizeof string,"? "cred"Administrator %s has deactivated testing mode on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("DevelopingMode",developmode);
	INI_Save();
	INI_Close();
	if(developmode == 1)
	{
	    foreach(new i: Player)
	    {
			if(PInfo[i][Level] >= 1) continue;
			if(IsPlayerNPC(i)) continue;
			SetTimerEx("kicken",200,false,"i",i);
			SendClientMessage(i,white,"* "cred"Sorry, server is on maintenance, you can't play on server right now.");
		}
		SendRconCommand("hostname ** Server is on maintenance! **");
	}
	return 1;
}

CMD:enablesupply(playerid,params[])
{
	if(PInfo[playerid][Level] < 4) return SendClientMessage(playerid,white,"* "cred"Error: You are not allowed to use this command!");
    new string[256];
	if(CanItSupply == 0)
	{
	    CanItSupply = 1;
		format(string,sizeof string,"? "cred"Administrator %s has activated supply event on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	else if(CanItSupply == 1)
	{
	    CanItSupply = 0;
		format(string,sizeof string,"? "cred"Administrator %s has deactivated supply event on server!",GetPName(playerid));
		SendClientMessageToAll(white,string);
	}
	INI_Open("Admin/Config/ServerConfig.ini");
	INI_WriteInt("EnableSupply",CanItSupply);
	INI_Save();
	INI_Close();
	return 1;
}

CMD:votekick(playerid,params[])
{
	new id,Reason[79];
	new WarnCanKick[65];
	if(VoteEnable == 0) return SendClientMessage(playerid,white,"* "cred"Error: Voting was disabled on server by administrators!");
	if(ServerIsVoting == 1) return SendClientMessage(playerid,white,"* "cred"Error: someone has already started voting! Wait until it will end!");
	format(WarnCanKick,sizeof WarnCanKick,"* "cred"Error: Wait %i seconds to make new voting again!",PInfo[playerid][SecondsBKick]);
	if(PInfo[playerid][CanKick] == 0) return SendClientMessage(playerid,white,WarnCanKick);
	if(sscanf(params,"%i%s[79]",id,Reason)) return SendClientMessage(playerid,white,"USAGE: "cblue"/votekick <ID> <Reason>");
	if(id == playerid) return SendClientMessage(playerid,white,"* "cred"Error: you can't start vote yourself!");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
    if(IsPlayerNPC(id)) return SendClientMessage(playerid,white,"* "cred"Error: Player is not found!");
	new string[256];
	KickVoteYes ++;
	ServerIsVoting = 1;
	PInfo[playerid][SecondsBKick] = 60;
	TimerForKick = SetTimerEx("MinusSecondForNextKick",1000,false,"i",playerid);
	SetTimerEx("EndVoting",27700,false,"i",playerid);
	PInfo[playerid][CanKick] = 0;
	PInfo[playerid][VotedYes] = 1;
	ServerVotingFor = id;
	ServerVotingReason = Reason;
	format(string,sizeof string,"*** "cred"|%i|%s started voting for kicking |%i|%s [Reason: %s]",playerid,GetPName(playerid),id,GetPName(id),Reason);
	SendClientMessage(playerid,white,string);
	SendClientMessage(playerid,white,"* "cred"Voting will end in 30 seconds! To vote you need to write /vote!");
	SendClientMessage(playerid,white,"* "cred"If you don't want to kick the player just don't want!");
	return 1;
}

CMD:vote(playerid,params[])
{
	if(PInfo[playerid][VotedYes] == 1) return SendClientMessage(playerid,white,"* "cred"Error: You have already voted!");
	if(ServerIsVoting == 0) return SendClientMessage(playerid,white,"* "cred"Error: There are no votings progressing!");
	if(ServerVotingFor == playerid) return SendClientMessage(playerid,white,"* "cred"Error: You can't vote yourself!");
    PInfo[playerid][VotedYes] = 1;
    KickVoteYes ++;
    SendClientMessage(playerid,white,"* "cgreen"You have successfuly voted!");
    new PlayersOnline;
    foreach(new i: Player)
    {
        if(PInfo[i][Logged] == 0) continue;
        PlayersOnline ++;
    }
    if(KickVoteYes == PlayersOnline)
    {
        foreach(new i: Player)
        {
        	PInfo[i][VotedYes] = 0;
		}
        KickVoteYes = 0;
        KillTimer(TimerForKick);
        ServerVotingFor = -1;
        ServerIsVoting = 0;
        if(IsPlayerConnected(ServerVotingFor))
        {
			new string[128];
			format(string,sizeof string,"* "cred"|%i|%s was kicked from server [Reason: %s]",ServerVotingFor,GetPName(ServerVotingFor),ServerVotingReason);
		}
	}
	return 1;
}
/*========================================COMMANDS END====================================
=======================================FUNCTIONS START==================================*/
function SkinShootDamage(playerid,damagedid,Float:amount, weaponid, bodypart)
{
	if(PInfo[damagedid][Dead] == 1) return 1;
    if(Team[playerid] == ZOMBIE)
    {
        if(GetDealPlayerDamage(damagedid,amount) == 1)
        {
	    	if(Team[damagedid] == HUMAN)
			{
			    PInfo[playerid][Infects]++;
			    GivePlayerXP(playerid);
			    CheckRankup(playerid);
			    InfectPlayer(damagedid);
			}
			else if(Team[damagedid] == ZOMBIE)
			{
			    GiveTK(playerid);
			}
			PInfo[damagedid][Dead] = 1;
			foreach(new i: Player)
			{
	    		if(PInfo[i][Level] >= 1)
					SendDeathMessageToPlayer(i,playerid, damagedid, 255);
			}
			SetPlayerHealth(damagedid,0);
			SetTimerEx("MinusHP",500,false,"i",damagedid);
			AddKillList(playerid,damagedid,weaponid);
	    }
	    else DealPlayerDamage(damagedid,amount);
	}
    if(Team[playerid] == HUMAN)
    {
		new extradamage;
		new damage;
		new Float:health;
		new Float:SHX;
		switch(weaponid)
		{
		    case 7: extradamage = 2;
			case 23: extradamage = 4;
			case 22: extradamage = 4;
			case 2: extradamage = 3;
			case 6: extradamage = 4;
			case 5: extradamage = 5;
			case 4: extradamage = 6;
			case 3: extradamage = 8;
			case 8: extradamage = 10;
			case 25: SHX = amount*0.2;
		}
		if(Team[damagedid] == ZOMBIE && PInfo[damagedid][ZPerk] == 13) damage = floatround((amount+extradamage-SHX)/1.67,floatround_ceil);
		else damage = floatround(amount+extradamage-SHX,floatround_ceil);
		GetPlayerHealth(damagedid,health);
		if(GetDealPlayerDamage(damagedid,damage) == 1)
		{
		    SetPlayerHealth(damagedid,0);
		    SetTimerEx("MinusHP",500,false,"i",damagedid);
		    PInfo[damagedid][Deaths]++;
		    PInfo[damagedid][Dead] = 1;
		    if((Team[damagedid] == ZOMBIE) || (Team[damagedid] == HUMAN && PInfo[damagedid][Infected] == 1))
		    {
			    PInfo[playerid][Kills]++;
			    PInfo[playerid][KillsRound]++;
			    PInfo[damagedid][Dead] = 1;
			    if(Team[damagedid] == ZOMBIE)
			    {
					if(PInfo[damagedid][ModeSlot1] == 9 || PInfo[damagedid][ModeSlot2] == 9 || PInfo[damagedid][ModeSlot3] == 9)
					{
					    new rand = random(2);
					    if(rand == 0)
					    {
					        new Float:x,Float:y,Float:z;
					        GetPlayerPos(damagedid,x,y,z);
			        		CreatePlayerExplosion(damagedid,x,y,z,17,7);
					    	foreach(new i: Player)
							{
								if(IsPlayerInRangeOfPoint(i,17,x,y,z))
								    SendClientMessage(i,white,"* "cjam"You were damaged by zombie's explosion");
					    	}
						}
				    }
				}
			    GivePlayerXP(playerid);
			    CheckRankup(playerid);
			    GiveRage(playerid,damagedid);
				GivePlayerAssistXP(playerid);
				new got;
				new rand = random(3);
				switch(rand)
				{
					case 0: got = random(10)+10;
					case 1: got = 20+random(10);
					case 2: got = 25+random(15);
				}
				if(Team[damagedid] == HUMAN && PInfo[damagedid][Infected] == 1) InfectPlayer(damagedid);
				PInfo[playerid][Materials] += got;
				ShowGottenItems(playerid,2);
			}
			else
			{
	        	PInfo[playerid][Teamkills]++;
	        	SendClientMessage(playerid,white,"? "cwhite"TeamKilling is "cred"NOT ALLOWED!!! "cwhite"?");
	        	if(PInfo[playerid][WarnJail] == 2)
	        	{
	        	    SendClientMessage(playerid,white,"? "cred"If you continue killing your teammates, you will be jailed!!! "cwhite"?");
				}
				if(PInfo[playerid][WarnJail] == 3)
				{
				    SendClientMessage(playerid,white,"? "cred"Last warning, if you kill your teammate again, you will be jailed!!! "cwhite"?");
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
	    	}
			foreach(new i: Player)
			{
	    		if(PInfo[i][Level] >= 1)
					SendDeathMessageToPlayer(i,playerid, damagedid, weaponid);
			}
			AddKillList(playerid,damagedid,weaponid);
		}
		else DealPlayerDamage(damagedid,damage);
        if(PInfo[playerid][ImpactBulletsInUse] != 0 && GetPlayerWeapon(playerid) != 0)
        {
			if(Team[damagedid] == ZOMBIE)
			{
            	PInfo[playerid][ImpactBulletsInUse] --;
				new Float:fPX,Float:fPY,Float:fPZ;
		        GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
			    new Float:x,Float:y,Float:z,Float:ix,Float:iy,Float:iz;
				if(!IsPlayerInAnyVehicle(damagedid)) //PowerfulGlovesSound
				{
				    GetPlayerPos(damagedid,ix,iy,iz);
					GetPlayerVelocity(damagedid,x,y,z);
					new Float:a = 180.0-atan2(ix-fPX,iy-fPY);
					x += ( 0.5 * floatsin( -a, degrees ) );
		      		y += ( 0.5 * floatcos( -a, degrees ) );
		      		ApplyAnimation(damagedid,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
					SetPlayerVelocity(damagedid,-x*0.9,-y*0.9,z+0.1);
            	}//////////
            	PlayNearSound(damagedid,1095);
			}
        }
        if(PInfo[playerid][StingerBulletsInUse] != 0 && GetPlayerWeapon(playerid) != 0)
        {
            if(Team[damagedid] == ZOMBIE)
            {
                if(PInfo[damagedid][CanBeStingBull] == 1)
                {
	                PInfo[playerid][StingerBulletsInUse] --;
	                TogglePlayerControllable(damagedid,0);
	                PInfo[damagedid][CanBeStingBull] = 0;
	                SetTimerEx("CanBeStingeredBull",2000,false,"i",damagedid);
	                SetTimerEx("UnFreezePlayer", 800, false, "i", damagedid);
	                SetTimerEx("GetUpAnim",600,false,"i",damagedid);
	                ApplyAnimation(damagedid,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
				}
			}
        }
        if(PInfo[playerid][BeaconBulletsInUse] != 0 && GetPlayerWeapon(playerid) != 0)
        {
            if(Team[damagedid] == ZOMBIE)
            {
            	if(PInfo[damagedid][InSearch] != 1)
            	{
            		PInfo[playerid][BeaconBulletsInUse] --;
            		PInfo[damagedid][InSearch] = 1;
            		SendFMessage(playerid,white,"* "cjam"You placed tracker on %s!",GetPName(damagedid));
            		SendClientMessage(damagedid,white,"* "cblue"Someone placed tracker on you, now every human can see you on radar!");
				}
			}
        }
	}
	return 1;
}

function UpdateSnow()
{
	foreach(new i: Player)
	{
		if(PInfo[i][Logged] == 0) continue;
		if(PInfo[i][Snowon] == 0)
		{
		    DestroyPlayerObject(i,PInfo[i][SnowObjects1]);
		    DestroyPlayerObject(i,PInfo[i][SnowObjects2]);
		    DestroyPlayerObject(i,PInfo[i][SnowObjects3]);
		    DestroyPlayerObject(i,PInfo[i][SnowObjects4]);
		    return 1;
		}
		new Float:x,Float:y,Float:z;
		GetPlayerPos(i,x,y,z);
    	SetPlayerObjectPos(i,PInfo[i][SnowObjects1],x,y,z-15);
		SetPlayerObjectPos(i,PInfo[i][SnowObjects2],x,y,z-10);
	 	SetPlayerObjectPos(i,PInfo[i][SnowObjects3],x,y,z);
	}
	return 1;
}

function CheckAchievement(playerid)
{
	if(PInfo[playerid][AchievementAllGiven] == 1) return 1;
	new count;
	if(PInfo[playerid][AchievementKills] >= 100) count++;
	if(PInfo[playerid][AchievementInfect] >= 100) count++;
	if(PInfo[playerid][Achievement50Hours] >= 30) count++;
	if(PInfo[playerid][AchievementCollect20] >= 20) count++;
	if(count == 4)
	{
		PInfo[playerid][AchievementAllGiven] = 1;
  		SendClientMessage(playerid,white,"** "cgreen"Achievement Get! "cred"ALL NEW YEAR ACHIEVEMENTS UNLOCKED!");
    	SendClientMessage(playerid,white,"** "cred"REWARD: "cgold"Gold "cgreen"Premium for 30 Days");
    	ShowPlayerDialog(playerid,190,DSM,""cred"Gratitude",""cred"Congratulations!!!\n"cwhite"You've got all new year Achievements!\nFor this work you get special present!\n"cgold"Gold "cwhite"premium for 30 days!\
    	\nThank you for playing on our server\n\n"cgreen"Happy new year!","Ok","");
		static file[128];
		format(file,sizeof file,Userfile,GetPName(playerid));
		INI_Open(file);
     	if(PInfo[playerid][Premium] == 0)
		{
		    INI_WriteInt("PremiumRealTime",gettime() + 2629743);
		    PInfo[playerid][PremiumRealTime] = gettime()+2592000;
			PInfo[playerid][Premium] = 1;
		}
     	else if(PInfo[playerid][Premium] > 0)
	 	{
		 	PInfo[playerid][PremiumRealTime] += gettime()+2592000;
		 	INI_WriteInt("PremiumRealTime",PInfo[playerid][PremiumRealTime]+gettime() + 2629743);
        }
		INI_Save();
		INI_Close();
		if(Team[playerid] == HUMAN)
			SetPlayerArmour(playerid,100);
        ResetPlayerInventory(playerid);
        AddItem(playerid,"Small Med Kits",8);
     	AddItem(playerid,"Medium Med Kits",8);
	    AddItem(playerid,"Large Med Kits",8);
	    if(PInfo[playerid][Antiblindpills] > 0) AddItem(playerid,"Anti-blindness pills",PInfo[playerid][Antiblindpills]);
	    if(PInfo[playerid][Nitro] > 0) AddItem(playerid,"Nitro",PInfo[playerid][Nitro]);
	    if(PInfo[playerid][StingerBullets] > 0) AddItem(playerid,"Stinger Bullets",PInfo[playerid][StingerBullets]);
        if(PInfo[playerid][BeaconBullets] > 0) AddItem(playerid,"Beacon Bullets",PInfo[playerid][BeaconBullets]);
		if(PInfo[playerid][ImpactBullets] > 0) AddItem(playerid,"Impact Bullets",PInfo[playerid][ImpactBullets]);
	    if(PInfo[playerid][Mines] > 0) AddItem(playerid,"Mines",PInfo[playerid][Mines]);
	    if(PInfo[playerid][CraftingTable] > 0) AddItem(playerid,"Crafting Table",PInfo[playerid][CraftingTable]);
		PlayerPlaySound(playerid,4201,0,0,0);
        SaveStats(playerid);
	}
	return 1;
}

function TipsAdv()
{
	new string[276];
	foreach(new i: Player)
	{
		if(PInfo[i][Logged] == 0) continue;
		if(PInfo[i][Spawned] == 0) continue;
		/*if(PInfo[i][Training] == 1)
		{
		    switch(PInfo[i][TrainingPhase])
		    {
			    case 1: format(string,sizeof string,"~r~~h~ENTER PICKUP");
			    case 2:
			    {
			        if(!IsPlayerInAnyVehicle(i))
			        {
			            DisablePlayerRaceCheckpoint(i);
			            format(string,sizeof string,"~g~~h~ENTER VEHICLE");
			        }
			    }
			    case 3:
			    {
			        if(!IsPlayerInAnyVehicle(i))
			        {
			            DisablePlayerRaceCheckpoint(i);
			            format(string,sizeof string,"~r~~h~RETURN TO THE  VEHICLE");
			        }
			        else
			        {
			            if(IsVehicleStarted(GetPlayerVehicleID(i)))
			            {
			            	format(string,sizeof string,"~r~~h~GO TO NEXT PICKUP");
			            	SetPlayerRaceCheckpoint(i,1,144.5750,1915.6713,18.9212,0,0,0,3);
						}
						else
						{
						    format(string,sizeof string,"~w~START YOUR VEHICLE~n~~w~~h~CLICK ~r~~k~~PED_FIREWEAPON~ ~w~TO START IT");
						}
			        }
			    }
			    case 4:
			    {
			        if(PInfo[i][CheckFill] == 0)
			        {
				        if(IsPlayerInAnyVehicle(i))
				        {
				        	DisablePlayerRaceCheckpoint(i);
				            format(string,sizeof string,"~r~~h~EXIT VEHICLE~n~THEN OPEN YOUR INVENTORY (~r~~h~PRESS ~k~~CONVERSATION_NO~)~n~CHOOSE FUEL AND OIL TO FILL VEHICLE");
				        }
				        else
				        {
				            format(string,sizeof string,"~w~OPEN YOUR INVENTORY (~r~~h~PRESS ~k~~CONVERSATION_NO~~w~)~n~FILL YOUR VEHICLE BY CLICKING FUEL AND OIL IN INVENTORY");
				        }
					}
					if(PInfo[i][CheckFill] == 1) format(string,sizeof string,"~w~OPEN INVENTORY AGAIN~n~FILL YOUR VEHICLE WITH FUEL OR OIL");
					else if(PInfo[i][CheckFill] >= 2)
					{
					    if(!IsPlayerInAnyVehicle(i))
					    {
				            format(string,sizeof string,"~r~~h~ENTER YOUR VEHICLE BACK");
					    }
					    else
					    {
					        if(!IsVehicleStarted(GetPlayerVehicleID(i)))
					        {
						    	format(string,sizeof string,"~w~~h~START YOUR VEHICLE~n~~h~CLICK ~r~~k~~PED_FIREWEAPON~ ~w~TO START IT");
							}
							else
							{
						    	format(string,sizeof string,"~r~~h~DRIVE TO NEXT PICKUP");
								SetPlayerRaceCheckpoint(i,1,214.0248,1902.0900,17.6406,0,0,0,3);
							}
					    }
					}
			    }
			    case 5:
			    {
			        DisablePlayerRaceCheckpoint(i);
			        format(string,sizeof string,"~w~~h~GO DOWN AND FIND ARROW PICKUP");
			    }
			    case 6:
			    {
			        format(string,sizeof string,"~r~~h~GO TO NEXT PICKUP");
			        SetPlayerRaceCheckpoint(i,1,224.5079,1872.2692,13.7344,0,0,0,2);
			    }
				case 7:
				{
				    if(PInfo[i][FakePerk] == 1)
				    {
				        format(string,sizeof string,"~w~USE ~b~BURST RUN ~n~~w~TO JUMP TO ANOTHER END OF ROOM");
					    if(PInfo[i][CanBurst] == 1)
					    {
					        SetPlayerRaceCheckpoint(i,1,932.5883,2130.7683,500.1382,0,0,0,2);
					    	GameTextForPlayer(i,"~n~~n~~n~~r~PRESS ~w~~k~~PED_DUCK~ + ~k~~PED_SPRINT~~n~~r~TO USE ~b~BURST RUN",1500,3);
					    }
					}
					else format(string,sizeof string,"~w~OPEN PERKS LIST (~r~PRESS ~k~~CONVERSATION_YES~~w~)~n~AND CHOOSE ~r~~h~BURST RUN");
			        if(IsPlayerInRangeOfPoint(i,24,960.6539,2133.0374,476.9765))
			        {
				    	SetPlayerPosAndAngle(i,969.3508,2127.1736,500.1418,90);
				    	SetPlayerHealth(i,100);
				    	PInfo[i][CanBurst] = 1;
			        }
				}
				case 8:
				{
				    DisablePlayerRaceCheckpoint(i);
				    format(string,sizeof string,"~w~ENTER ~r~~h~CHECKPOINT");
				}
				case 10: format(string,sizeof string,"~w~FIND ANY PICKUP IN ANY PIPE~n~AND ENTER IT");
				case 11: format(string,sizeof string,"~r~~h~GO TO NEXT PICKUP");
				case 12:
				{
				    if(IsPlayerInRangeOfPoint(i,1.5,307.1434,2504.6030,16.4844)) GameTextForPlayer(i,"~n~~n~~n~~r~PRESS ~w~~k~~PED_LOCK_TARGET~~r~ TO BITE",1500,3);
				    format(string,sizeof string,"~w~COME CLOSE TO HUMAN AND BITE HIM ~r~~h~10 ~w~TIMES~n~AS FASTER YOU CLICK ~n~AS MUCH BITES YOU CAN DO~n~~n~~r~PRESS ~w~~k~~PED_LOCK_TARGET~~r~ TO BITE");
				}
				case 13:
				{
				    SetPlayerRaceCheckpoint(i,1,360.5663,2503.4712,16.4844,0,0,0,3);
				    if(PInfo[i][FakePerk] != 2) format(string,sizeof string,"~w~OPEN PERKS LIST (~r~PRESS ~k~~CONVERSATION_YES~~w~)~n~AND CHOOSE ~r~~h~JUMPER");
					if(PInfo[i][FakePerk] == 2) format(string,sizeof string,"~w~NOW JUST JUMP THROUGH THESE BOXES~n~AND ENTER PICKUP BEHIND THEM");
				}
				case 14:
				{
				    DisablePlayerRaceCheckpoint(i);
				    if(PInfo[i][FakePerk] != 3) format(string,sizeof string,"~w~OPEN PERKS LIST (~r~PRESS ~k~~CONVERSATION_YES~~w~)~n~AND CHOOSE ~r~~h~DIGGER");
					if(PInfo[i][FakePerk] == 3)
					{
					    if(PInfo[i][CanDig] == 1) format(string,sizeof string,"~w~NOW PRESS ~r~~h~~k~~PED_DUCK~~n~TO DIG TO VEHICLE");
					}
				}
				case 15:
				{
				    DisablePlayerRaceCheckpoint(i);
   					format(string,sizeof string,"~w~ENTER ~r~~h~VEHICLE ~w~AS PASSENGER ~n~CLICK ~r~~h~G ~w~TO ENTER VEHICLE AS PASSENGER");
				}
				case 16:
				{
				    SetPlayerRaceCheckpoint(i,1,404.9118,2476.9131,16.4922,0,0,0,2);
					format(string,sizeof string,"~w~ENTER ~r~~h~HANGAR ~w~AND ENTER PICKUP~n~FOR FINISHING TRAINING COURSE");
				}
			}
   			TextDrawSetString(TipBox[i],string);
      		TextDrawShowForPlayer(i,TipBox[i]);
		}
		else if(PInfo[i][ChooseAfterTr] == 1)
		{
		    DisablePlayerRaceCheckpoint(i);
			format(string,sizeof string,"~w~NOW CHOOSE YOUR TEAM!~n~GO LEFT IF YOU WANT TO BE A ~g~HUMAN~w~GO RIGHT TO BE A ~p~ZOMBIE");
   			TextDrawSetString(TipBox[i],string);
      		TextDrawShowForPlayer(i,TipBox[i]);
		}*/
		new Float:hp;
		if(PInfo[i][Rank] <= 5 && PInfo[i][AllowedToTip] == 1)
		{
	        GetPlayerHealth(i,hp);
	        if(Team[i] == HUMAN)
	        {
	            if(CPID != -1)
				{
				    if(!IsPlayerInCheckpoint(i))
				    {
  					    if(IsPlayerInAnyVehicle(i))
					    {
							if(VehicleStarted[GetPlayerVehicleID(i)] == 0)	format(string,sizeof string,"~w~VEHICLE IS NOT STARTED!~n~CLICK ~r~LEFT MOUSE BUTTONG ~w~TO START IT!");
							else format(string,sizeof string,"~w~REACH TO ~r~~h~CHECKPOINT ~n~~r~(RED MARKER ON RADAR)~n~~w~YOU WILL RECEIVE XP, AMMO AND HEALTH~n~ALSO HERE~n~~w~YOU GET MORE CHANCES TO SURVIVE!");
							if(VehicleWithoutKeys[GetPlayerVehicleID(i)] == 1) format(string,sizeof string,"~w~THERE ARE NOT KEYS IN VEHICLE~n~OPEN YOUR INVENTORY ~n~~r~PRESS ~k~~CONVERSATION_NO~~w~ AND USE PICKLOCKS");
						}
						else format(string,sizeof string,"~w~REACH TO ~r~~h~CHECKPOINT ~n~~r~(RED MARKER ON RADAR)~n~~w~YOU WILL RECEIVE XP, AMMO AND HEALTH~n~ALSO, STAYING ON IT,~n~~w~YOU GET MORE CHANCES TO SURVIVE!");
					}
					else format(string,sizeof string,"~w~YOU'VE REACHED ~r~~h~CP~n~~w~STAY IN CP UNTIL YOU CLEAR IT~n~WHILE YOU ARE STAYING YOU RECEIVE HP~n~~n~AFTER CLEARING ~r~~h~CP~w~ YOU GET XP");
				}
				else if(CPID == -1)
				{
				    if(IsPlayerInAnyVehicle(i))
				    {
						if(VehicleStarted[GetPlayerVehicleID(i)] == 0) format(string,sizeof string,"~w~VEHICLE IS NOT STARTED!~n~CLICK ~r~LEFT MOUSE BUTTONG ~w~TO START IT!");
						else format(string,sizeof string,"~w~WAIT FOR ~r~~h~CHECKPOINT~n~~w~IT WIll APPEAR SOON~n~WHILE YOU ARE WAITING~n~YOU CAN LOOT FOR ITEMS~n~~r~FIND AND ENTER ANY INTERIOR");
			   			if(VehicleWithoutKeys[GetPlayerVehicleID(i)] == 1) format(string,sizeof string,"~w~THERE ARE NOT KEYS IN VEHICLE~n~OPEN YOUR INVENTORY ~n~~r~PRESS ~k~~CONVERSATION_NO~~w~ AND USE PICKLOCKS");
					}
				    else if(PInfo[i][AlreadyWasInCar] == 0) format(string,sizeof string,"~w~FIND VEHICLE");
					else format(string,sizeof string,"~w~WAIT FOR ~r~~h~CHECKPOINT~n~~w~IT WIll APPEAR SOON~n~WHILE YOU ARE WAITING~n~YOU CAN LOOT FOR ITESM~n~~r~FIND AND ENTER ANY INTERIOR");
				}
				if(GetPlayerInterior(i) != 0) format(string,sizeof string,"~w~YOU ENTERED INTERIOR~n~HERE YOU CAN LOOT~n~FIND WHITE ARROW TO LOOT");
				if(PInfo[i][Rank] >= 2)
				{
				    if(PInfo[i][SPerk] == 0) format(string,sizeof string,"~w~YOU'VE GOT NEW PERK!~n~OPEN PERKS LIST~n~~r~~h~CLICK ~k~~CONVERSATION_YES~ AND CHOOSE NEW PERK!");
				}
				if(hp <= 30) format(string,sizeof string,"~w~YOU HAVE LOW AMOUNT OF HP!~n~~r~~h~OPEN INVENTORY ~n~~r~PRESS ~k~~CONVERSATION_NO~~w~ AND USE MEDICAL KITS");
			}
	        if(Team[i] == ZOMBIE)
	        {
			    if(IsPlayerInAnyVehicle(i)) format(string,sizeof string,"~w~PRESS ~r~~h~~k~~VEHICLE_HANDBRAKE~ ~w~TO BITE HUMANS IN VEHICLE~n~~n~ALSO YOU CAN HIDE~n~USE COMMAND ~r~~h~/HIDE");
				else format(string,sizeof string,"~p~ZOMBIES ~w~CAN TELEPORT THROUGH LS~n~~w~FIND LETTER ~r~T~w~ ON RADAR~n~~n~YOU CAN BITE HUMANS~n~CLICK ~r~~h~~k~~PED_LOCK_TARGET~~w~TO BITE~n~WITH BITING YOU RECEIVE HP");
				if(PInfo[i][Rank] >= 2)
				{
				    if(PInfo[i][ZPerk] == 0) format(string,sizeof string,"~w~YOU'VE GOT NEW PERK!~n~OPEN PERKS LIST~n~~r~~h~CLICK ~k~~CONVERSATION_YES~ AND CHOOSE NEW PERK!");
				}
				if(hp <= 30) format(string,sizeof string,"~w~YOU HAVE LOW AMOUNT OF HP!~n~~r~~h~TELEPORT TO HIVE~n~HERE YOU CAN FILL YOUR HP~n~ALSO YOU CAN HEAL ~r~HP ~w~BY BITING HUMANS");
	        }
			TextDrawSetString(TipBox[i],string);
  			TextDrawShowForPlayer(i,TipBox[i]);
	    }
	    else TextDrawHideForPlayer(i,TipBox[i]);
	}
	return 1;
}

function AddKillList(playerid,damagedid,weaponid)
{
	new string[158];
	new weaponname[32];
	GetWeaponName(weaponid,weaponname,sizeof weaponname);
	format(string,sizeof string,"%s Killed %s [Weapon: %s]",GetPName(playerid),GetPName(damagedid),weaponname);
	SaveIn("KillLog",string,1);
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
	SetTimerEx("SetTDAlpha4",1500,false,"ii",playerid,1);
	return 1;
}

function ShowGottenRage(playerid)
{
    static string[32];
    format(string,sizeof string,"RAGE+");
    TextDrawSetString(RagePlus[playerid],string);
    TextDrawShowForPlayer(playerid,RagePlus[playerid]);
    SetTimerEx("SetTDAlpha4",1500,false,"ii",playerid,2);
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
    PInfo[playerid][CanBeStingBull] = 1;
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
	new Float:x,Float:y,Float:z;
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
	        CreatePlayerExplosion(playerid,x,y,z,15,80);
	        DestroyObject(PInfo[playerid][MineObject]);
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
	        new rand = random(100);
	        if(rand <= 75)
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
     		new rand = random(100);
	        if(rand <= 80)
	        {
	            new dim = random(2)+1;
	            GivePlayerWeapon(playerid,18,dim);
         		SendFMessage(playerid,green,"* "cgreen"You created %i molotov(s)! "cred"Check Inventory (press N)",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 2://sticky bombs
	    {
			new rand = random(100);
	        if(rand <= 60)
	        {
	            new dim = random(2)+1;
	            GivePlayerWeapon(playerid,39,dim);
         		SendFMessage(playerid,green,"* "cgreen"You created %i sticky bomb(s) "cred"Check Inventory (press N)!",dim);
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 3://beacon bullets
	    {
  			new rand = random(100);
	        if(rand <= 75)
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
  			new rand = random(100);
	        if(rand <= 65)
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
  			new rand = random(100);
	        if(rand <= 50)
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
			new rand = random(100);
	        if(rand <= 75)
	        {
	            AddItem(playerid,"Nitro",1);
	            PInfo[playerid][Nitro] += 1;
           		SendClientMessage(playerid,green,"* "cgreen"You created Nitro for vehicle! "cred"Check Inventory (press N)");
	        }
	        else SendClientMessage(playerid,red,""cred"What a failure! Crafting failed, you broke item and you lost your materials!");
	    }
	    case 7://anti-blind
	    {
			new rand = random(100);
	        if(rand <= 90)
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
			new rand = random(100);
	        if(rand <= 85)
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
	SendClientMessage(playerid,white,"? "cwhite"TeamKilling is "cred"NOT ALLOWED!!! "cwhite"?");
	if(PInfo[playerid][WarnJail] == 2)
	{
	    SendClientMessage(playerid,white,"? "cred"If you continue killing your teammates, you will be jailed!!! "cwhite"?");
	}
	if(PInfo[playerid][WarnJail] == 3)
	{
	    SendClientMessage(playerid,white,"? "cred"Last warning, if you kill your teammate again, you will be jailed!!! "cwhite"?");
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
        if(IsPlayerInRangeOfPoint(i,50,x,y,z)) return SendClientMessage(playerid,red,"? There must be nobody close to you when you go AFK!");
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
    SetPlayerTeam(playerid,1);
    SetPlayerTeam(damageid,1);
    return 1;
}

function EnableEntAC(playerid)
{
    EnableAntiCheatForPlayer(playerid,4,1);
	return 1;
}

function AttemptOpen(playerid,vehicleid)
{
	PInfo[playerid][CanUsePickLock] = 1;
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,white,"? "cred"You must be in vehicle!");
	new rand = random(4);
	new string[128];
	if(rand == 0)
	{
	    format(string,sizeof string,""cjam"%s has picked vehicle's locks!",GetPName(playerid));
		SendNearMessage(playerid,white,string,15);
		SetTimerEx("OffAlarm",15000,false,"i",GetPlayerVehicleID(playerid));
		VehicleWithoutKeys[GetPlayerVehicleID(playerid)] = 0;
	}
	else
	{
 		SendClientMessage(playerid,white,"* "cred"Attempt to pick locks failed!");
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
	if(!IsValidObject(PInfo[playerid][ZObject])) return 1;
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
    TogglePlayerControllable(playerid, 0);
 	SetPlayerPos(playerid,1446.2224,-1303.2131,1056.5103);
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
		strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.55");
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
			strcat(strang,""dred"\n Los - Santos Zombie Apocalypse. "cwhite" Script Ver. 0.05.55");
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

function Tip()
{
    new rand = random(8);
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
		case 5:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You are playing with friends?");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Create group! "cred"/groupcreate");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Groups are very useful when you play with friends!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"It have more benefits, than playing alone!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You get more XP for assisting, can see each other on Radar and you have private group chat!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Groups' commands: "cred"/groupcreate /groupinvite /groups /gc");
			    	SendClientMessage(i,white,""cgreen"=========================================");
					SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
		case 6:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite""cgreen"Humans "cwhite"have crafting system!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"For craftig you need to come to "cblue"blue"cwhite" skull on radar");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Also you need materials to craft items");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You get materials by looting, killing zombies and looting in LSA docks ("cblue"Blue "cwhite"skull on radar)!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Items that you craft saves, so you can use them when you want");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You can check description of items in crafting table that placed on LSA docks");
			    	SendClientMessage(i,white,""cgreen"=========================================");
					SendClientMessage(i,white,"* "cred"You can turn tips off with command /tips");
				}
			}
		}
		case 7:
	    {
  			foreach(new i: Player)
	        {
	            if(PInfo[i][Logged] == 0) continue;
	            if(PInfo[i][AllowedToTip] == 1)
	            {
			    	SendClientMessage(i,white,""cgreen"==================="cred"TIP"cgreen"===================");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite""cpurple"Zombies"cwhite" have DNA modifications!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"You can combine them in abandoned laboratory that is placed in hive");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"For combining you need DNA Points!");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"These points you get by infecting humans and bitting");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"DNA modifications that you combine can be used any time");
			    	SendClientMessage(i,white,""cgreen"|| "cwhite"Depending on your rank you have slots (1-14 ranks - one slot, 15-29 - two slots, 30+ three slots)");
                    SendClientMessage(i,white,""cgreen"|| "cwhite"You can change slots with /changemod");
                    SendClientMessage(i,white,""cgreen"|| "cwhite""cred"Number of changes is limited! You can change modifications, according your rank, limited times per round!");
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
	new rand = random(24);
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
	return 1;
}

function Loot2(playerid)
{
	new randem = random(15);
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
	SendClientMessage(playerid,red,"? Your gloves charged enough (Powerful Gloves ready)");
	PInfo[playerid][CanPowerfulGloves] = 1;
	return 1;
}

function CanZombieBait(playerid)
{
	SendClientMessage(playerid,red,"? You have found a zombie bait! (Zombie Bait Ready)");
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

function StopBait(playerid)
{
	KillTimer(PInfo[playerid][ToBaitTimer]);
	PInfo[playerid][ZX] = 0.0;
	ProjectileType[playerid][1] = 0;
	DestroyProjectile(PInfo[playerid][ObjectProj]);
	PInfo[playerid][ObjectProj] = -1;
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

function CreatePlayerExplosion(playerid,Float:x,Float:y,Float:z,Float:rangemax,Float:Power)
{
	ExplosionObjective = CreateObject(18683,x,y,z,0,0,0,250);
	SetTimer("DestroyFakeExplosion",3000,false);
	PlayNearSound(playerid,1159);
	PlayNearSound(playerid,1159);
	PlayNearSound(playerid,1159);
	PlayNearSound(playerid,1159);
	PlayNearSound(playerid,1159);
	new Float:ax,Float:ay,Float:az;
	new Float:hp;
	foreach(new i: Player)
	{
	    GetPlayerPos(i,ax,ay,az);
	    if(IsPlayerInRangeOfPoint(i,rangemax,x,y,z))
	    {
		    new Float:rx,Float:ry,Float:rz;
			if(!IsPlayerInAnyVehicle(i)) //PowerfulGlovesSound
			{
			    GetPlayerPos(i,ax,ay,az);
				GetPlayerVelocity(i,rx,ry,rz);
				new Float:a = 180.0-atan2(ax-x,ay-y);
				rx += ( 0.5 * floatsin( -a, degrees ) );
	      		ry += ( 0.5 * floatcos( -a, degrees ) );
				SetPlayerVelocity(i,-rx*0.9,-ry*0.9,rz+0.1);
        	}//////////*/
	        GetPlayerHealth(i,hp);
			hp = floatround(hp,floatround_round);
	        if(GetDealPlayerDamage(i,5*Power) == 1)
	        {
	            if(Team[i] == Team[playerid])
	            {
             		if(i != playerid) GiveTK(playerid);
	            }
	            if(Team[i] != Team[playerid])
	            {
	                GivePlayerXP(playerid);
	                GivePlayerAssistXP(playerid);
					if(Team[i] == ZOMBIE)
					{
					    GiveRage(playerid,i);
						PInfo[playerid][Infects] ++;
					}
	            }
	            PInfo[i][Dead] = 1;
	            SetPlayerHealth(i,0);
	        }
	        else DealPlayerDamage(i,5*Power);
	    }
	}
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
	PInfo[playerid][Stomped] = 0;
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

function FiveSeconds()
{
	UpdateVehicleDamage();
	UpdateSnow();
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
		GameTextForPlayer(i,"~r~~h~HAPPY NEW YEAR!!!",1900,3); //halloween ~0xFF9600FF new year: 0xB22222FF
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
	SendClientMessage(playerid,red,"? You feel rested to send a mini earthquake (stomp ready)");
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
	    /*if(PInfo[playerid][AchievementInfect] == 99)
	    {
	        SendClientMessage(playerid,white,"** "cgreen"Achievement Get! "cred"Infect 100 humans achievement unlocked!");
	        SendClientMessage(playerid,white,"** "cred"REWARD: "cgreen"5000 DNA Points!");
	        PInfo[playerid][DNIPoints] += 5000;
	        PInfo[playerid][AchievementInfect] ++;
	        CheckAchievement(playerid);
	        PlayerPlaySound(playerid,4201,0,0,0);
	    }
	    else PInfo[playerid][AchievementInfect] ++;*/
		new rand;
		if(PInfo[playerid][ModeSlot1] == 11 || PInfo[playerid][ModeSlot2] == 11 || PInfo[playerid][ModeSlot3] == 11)
        	rand = random(2);
		else rand = random(4);
		if(rand == 1)
		{
			ShowGottenItems(playerid,1);
			new dim;
   			if(PInfo[playerid][ModeSlot1] == 11 || PInfo[playerid][ModeSlot2] == 11 || PInfo[playerid][ModeSlot3] == 11)
				dim = 5+random(25)+random(15)+random(15)+random(30);
			else
				dim = 5+random(15)+random(10)+random(5)+random(20);
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
	    /*if(PInfo[playerid][AchievementKills] == 99)
	    {
	        SendClientMessage(playerid,white,"** "cgreen"Achievement Get! "cred"Kill 100 zombies achievement unlocked!");
	        SendClientMessage(playerid,white,"** "cred"REWARD: "cgreen"5000 Materials!");
	        PInfo[playerid][DNIPoints] += 5000;
	        PInfo[playerid][AchievementKills] ++;
	        PlayerPlaySound(playerid,4201,0,0,0);
	        CheckAchievement(playerid);
	    }
	    else PInfo[playerid][AchievementKills] ++;*/
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
	    SetTimerEx("CantBite",750,0,"i",playerid);
	else
		SetTimerEx("CantBite",600,0,"i",playerid);
	PInfo[playerid][CanBite] = 0;
	EnableAntiCheatForPlayer(i,12,0);
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
			    if(Health <= 6 && Health > 0.0)
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
				    SetPlayerHealth(i,Health-6);
			}
			GetPlayerHealth(playerid,Health);
		}
		else if((PInfo[playerid][ZPerk] != 18) || (PInfo[playerid][ZPerk] != 1))
		{
		    if((PInfo[i][SPerk] != 5) && (PInfo[i][SPerk] != 22))
			{
			    if(Health <= 6 && Health > 0.0)
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
				    SetPlayerHealth(i,Health-6);
			}
			else
			{
			    if(Health <= 4.0 && Health > 0.0)
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
				    SetPlayerHealth(i,Health-4.0);
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
	SetTimerEx("ActivateCheat",1000,false,"i",i);
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
	PInfo[playerid][Deaths] ++;
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
    SetSpawnInfo(playerid,1,gRandomSkin[RandomGS],0,0,0,0,0,0,0,0,0,0);
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
 	PInfo[playerid][AchievementKills] = INI_ReadInt("AchievementKills");
	PInfo[playerid][AchievementInfect] = INI_ReadInt("AchievementInfect");
	PInfo[playerid][Achievement50Hours] = INI_ReadInt("Achievement50Hours");
	PInfo[playerid][AchievementCollect20] = INI_ReadInt("AchievementCollect20");
	PInfo[playerid][AchievementAllGiven] = INI_ReadInt("AchievementAllGiven");
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
    PInfo[playerid][Snowon] = INI_ReadInt("Snowon");
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
    PInfo[playerid][SecretAdmin] = INI_ReadInt("SecretAdmin");
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
	INI_WriteString("LastLoginIP",GetHisIP(playerid));
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
 	INI_WriteInt("AchievementKills",PInfo[playerid][AchievementKills]);
	INI_WriteInt("AchievementInfect",PInfo[playerid][AchievementInfect]);
	INI_WriteInt("Achievement50Hours",PInfo[playerid][Achievement50Hours]);
	INI_WriteInt("AchievementCollect20",PInfo[playerid][AchievementCollect20]);
	INI_WriteInt("AchievementAllGiven",PInfo[playerid][AchievementAllGiven]);
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
    INI_WriteInt("Snowon",PInfo[playerid][Snowon]);
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
		/*if(IsPlayerInAnyVehicle(playerid))
		{
		    GetVehicleHealth(GetPlayerVehicleID(playerid),health);
		    if(health <= 200) SetVehicleHealth(GetPlayerVehicleID(playerid),350);
		}*/
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
	            if(PInfo[i][Afk] == 1) continue;
	            if(PInfo[i][Training] == 1) continue;
				if(Team[i] == HUMAN)
				{
	        	    GetPlayerPos(i,x,y,z);
	        	    if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
	        	    {
	        	        GameTextForPlayer(playerid,"~w~CLICK ~r~RIGHT MOUSE BUTTON ~w~TO BITE",1500,3);
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
		new string[1880];
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
   	    new string[1920];
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
	 	new string[1960];
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
		new string[2000];
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
		new string[2048];
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
		new string[1760];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 24)
	{
		new string[1800];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 25)
	{
		new string[1840];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 26)
	{
		new string[1880];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 27)
	{
		new string[1920];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 28)
	{
		new string[1960];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig\n28\tGodLike Jumper");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] == 29)
	{
		new string[2000];
		format(string,sizeof string,"1\tNone\n2\tHard Bite\n3\tDigger\n4\tRefreshing Bite\n5\tJumper");
		strcat(string,"\n6\tDead Sense\n7\tHard Punch\n8\tVomiter\n9\tScreamer\n10\tBurst run\n11\tStinger Bite\n12\tBig Jumper\n13\tStomp\n14\tThick Skin\n15\tGod Dig\n16\tHemorrhage");
		strcat(string,"\n17\tHigh Jumper\n18\tRepellent \n19\tRavaging Bite\n20\tSuper Scream\n21\tPopping Tires\n22\tExtra Refreshing Bite");
		strcat(string,"\n23\tGod Sense\n24\tBlind Bite\n25\tHell Scream\n26\tSuper Hard Punch\n27\tPowerful Dig\n28\tGodLike Jumper\n29\tMeat Sharing");
		ShowPlayerDialog(playerid,Zombieperksdialog,2,"Zombie perks",string,"Choose","Cancel");
		return 1;
	}
   	if(PInfo[playerid][Rank] >= 30)
	{
		new string[2048];
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
					SendClientMessage(i,white,"* "corange"No Fuel left, you can fill your car, using your fuel from inventory ("cred"PRESS N"corange"), or find another car!");
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
					SendClientMessage(i,white,"* "corange"No oil left, you can fill your car, using your oil from inventory ("cred"PRESS N"corange"), or find another car!");
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
	    if(PInfo[playerid][Training] == 1)
		{
		    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
		    StartVehicle(GetPlayerVehicleID(playerid),1);
		    PInfo[playerid][StartCar] = 0;
		    VehicleStarted[GetPlayerVehicleID(playerid)] = 1;
		    SetTimerEx("UpdateFOVehicle",650,false,"i",playerid);
		    return 1;
		}
		new rand = random(2);
		if(rand == 0) return SendClientMessage(playerid,white,"** "cred"Starting Vehicle Failed!"cwhite"**"),PInfo[playerid][StartCar] = 0;
		else
		{
		    SendClientMessage(playerid,white,"* "corange"The vehicle has successfully started");
		    PInfo[playerid][AlreadyWasInCar] = 1;
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
    new strang[1816];
	format(strang,sizeof strang,""cwhite""dred"Los Santos Apocalypse"cwhite" is a survival TDM (Team Death Match) mode with 2 teams! \nThere are 2 teams: "cgreen"Survivors "cwhite"and "cpurple"Zombies\n"cwhite"Goal of "cpurple"zombies "cwhite"is infect every "cgreen"human"cwhite" and don't let them clear all "cred"8 Checkpoints!");
	strcat(strang,""cwhite"\nThe main goal of "cgreen"suvivors "cwhite"is survive and clear all checkpoints to win the round\nBoth teams have their own features that will help them defeat opposing team\nFor getting stronger teams need to increase their ranks");
	strcat(strang,""cwhite"\nFor that you need XP, you can receive them by Killing, Assisting - for "cgreen"Humans"cwhite", For "cpurple"zombies "cwhite"by Infecting, Screaming, Vomiting and Assiting\nAlso you can be in "cgreen"Groups "cwhite"to get more XP from assisting");
	ShowPlayerDialog(playerid,79591,DSM,"GameMode",strang,"Go","");
	return 1;
}

function DigToTrainingVehicle(playerid)
{
	SetPlayerPosAndAngle(playerid,399.7230,2500.6580,16.4844,269.6100);
    new strang[240];
    format(strang,sizeof strang,""cwhite"Good Job!\nNow you perfectly know basics of the game");
    strcat(strang,"\nNow get in the passenger seat and I will say what to do next");
	SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Enter car as passenger ("cred"Press G"cwhite")");
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
    	    new strang[1470];
			format(strang,sizeof strang,""cwhite"Good Job!\nIf you are lucky enough you've got a new item in your inventory! ("cred"Press N to open it"cwhite")\nOther things can be found there such as :\n\n"cgreen"Bullets for your weapons\nMed kits (give you health)\nFlashlights (lets you spot zombies on map)");
			strcat(strang,"\nPicklock (let you open locked vehicles)\nDizzy Away Pills (decreases dizzy effect after zombies' attack)\nMolotov mission (lets you craft molotov)\nFuel and Oil(you can fill your vehicle with it)\n\n\n"cred"Go to next pickup, it is behind you, to go to next step.");
			SendClientMessage(playerid,white,"* "cred"TIP: "cwhite"Find next pickup to continue");
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
			    format(string,sizeof string,""cjam"%s has found can of Oil.",GetPName(playerid));
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
			    format(string,sizeof string,""cjam"%s has found can of Oil.",GetPName(playerid));
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

/*function ShowHumanBoosts(playerid)
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
}*/


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
			    else GrXP = 0;
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
				    else GrXP = 0;
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
    if(!IsValidObject(PInfo[playerid][FlashBangObject])) return 1;
	new Float:x,Float:y,Float:z;
	GetObjectPos(PInfo[playerid][FlashBangObject],x,y,z);
	FlashFlashObj[playerid] = CreateObject(18670,x,y,z-1.5,0,0,0,100);
	SetTimerEx("DestoystrFlash",1000,false,"i",playerid);
	CreateExplosion(x,y,z,13,5);
	foreach(new i: Player)
	{
		if(PInfo[i][Logged] == 0) continue;
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		PlayerPlaySound(i,1159,x,y,z);
		if(IsPlayerInRangeOfPoint(i,35,x,y,z))
		{
		    if(IsPlayerFacingObject(i,PInfo[playerid][FlashBangObject],140))
		    {
		    	Flashbang(i);
				PInfo[i][Flashed] = 1;
			}
			else Flashbang5(i);
		}
	}
 	PInfo[playerid][CanThrowFlashAgain] = 1;
    DestroyProjectile(PInfo[playerid][FlashBangObjectProj]);
	PInfo[playerid][FlashBangObjectProj] = -1;
    ProjectileType[playerid][2] = 0;
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
	CreatePlayerExplosion(playerid,PInfo[playerid][ZX],PInfo[playerid][ZY],PInfo[playerid][ZZ],15,12);
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
	new infects;
	if(CanItRandom == 1)
	{
		new humans;
	    foreach(new i: Player)
		{
		    if(PInfo[i][Logged] == 0) continue;
		    if(PInfo[i][Spawned] == 0) continue;
		    if(PInfo[i][Training] == 1) continue;
		    if(PInfo[i][Jailed] == 1) continue;
		    if(PInfo[i][ChooseAfterTr] == 1) continue;
			if(Team[i] == ZOMBIE) infects++;
		}
		foreach(new i: Player)
		{
		    if(PInfo[i][Logged] == 0) continue;
		    if(PInfo[i][Spawned] == 0) continue;
		    if(PInfo[i][Training] == 1) continue;
		    if(PInfo[i][Jailed] == 1) continue;
		    if(PInfo[i][ChooseAfterTr] == 1) continue;
			humans++;
		}
		if((floatround(100.0 * floatdiv(infects, humans)) > 30) || (humans < 4)) return 1;
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
	new humans;
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Training] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][ChooseAfterTr] == 1) continue;
	    if(Team[i] == ZOMBIE) infects++;
	}
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Training] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][ChooseAfterTr] == 1) continue;
		humans++;
	}

	if(floatround(100.0 * floatdiv(infects, humans)) >= 30)
	{
	    foreach(new i: Player)
	    {
	        SendClientMessage(i,white,"** "cred"Autobalance: Autobalance was cancelled Reason: Infection is more than 30\%");
		}
		ServerIsAutoBalancing = 0;
		return 1;
	}
	if(PlayersConnected < 4)
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
	new humans;
	new rand = Iter_Random(Player);
    if(!IsPlayerConnected(rand) || PInfo[rand][Logged] == 0 || Team[rand] == ZOMBIE || PInfo[rand][Jailed] == 1 || PInfo[rand][Training] == 1)
    {
		SetTimer("RandomSet",100,false);
		return 0;
	}
    foreach(new i: Player)
    {
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Training] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][ChooseAfterTr] == 1) continue;
		if(Team[i] == ZOMBIE) infects++;
	}
	foreach(new i: Player)
	{
	    if(PInfo[i][Logged] == 0) continue;
	    if(PInfo[i][Spawned] == 0) continue;
	    if(PInfo[i][Training] == 1) continue;
	    if(PInfo[i][Jailed] == 1) continue;
	    if(PInfo[i][ChooseAfterTr] == 1) continue;
		humans++;
	}
    Destained = floatround(100.0 * floatdiv(infects, humans));
	SendClientMessage(rand,white,"** "cred"Autobalance: "cwhite"Random chose you! Help zombies win this round!");
	Team[rand] = ZOMBIE;
	infects ++;
    new RandomGS = random(sizeof(gRandomSkin));
    PInfo[rand][Skin] = gRandomSkin[RandomGS];
    SetPlayerSkin(rand,gRandomSkin[RandomGS]);
	SetSpawnInfo(rand,1,PInfo[rand][Skin],0,0,0,0,0,0,0,0,0,0);
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
				        new Float:Health;
		    			GetPlayerHealth(i,Health);
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
		    				if(Health <= 10.0 && Health > 0.0)
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
			    				SetPlayerHealth(i,Health-10.0);
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
			if(code == 11) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Vehicle Health Hack",GetPName(playerid));
			if(code == 12) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Health Hack",GetPName(playerid));
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %i)",code);
			SendAdminMessage(white,string);
    	    if(code == 11)
    	    {
            	PInfo[playerid][Kicked] = 1;
            	SetTimerEx("kicken",20,false,"i",playerid);
			}
			return 1;
		}
		case 16:
    	{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Ammo Hack",GetPName(playerid));
			SendAdminMessage(white,string);
			SendFMessage(playerid,white,"*** "cred"AntiCheat detected that you used hacks and kicked you! (code: %d)",code);
			PInfo[playerid][Kicked] = 1;
			SetTimerEx("kicken",20,false,"i",playerid);
			return 1;
		}
		case 17:
  		{
	    	static string[128];
			format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Infinite Ammo",GetPName(playerid));
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
			if(code == 27) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fake Spawn",GetPName(playerid));
			if(code == 28) format(string,sizeof string,""cwhite"^^ "cred"U-AntiCheat Detected Hacks - %s Kicked for using Fake Kill",GetPName(playerid));
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
	    /*if(PInfo[playerid][Achievement50Hours] == 29)
	    {
	        SendClientMessage(playerid,white,"** "cgreen"Achievement Get! "cred"Play 30 hours achievement unlocked!");
	        SendClientMessage(playerid,white,"** "cred"REWARD: "cgreen"2x XP Booster for 20 days!");
			static file[128];
			format(file,sizeof file,Userfile,GetPName(playerid));
			INI_Open(file);
	     	if(PInfo[playerid][ExtraXP] == 0)
			{
			    INI_WriteInt("ExtraXPRealTime",gettime() + 1728000);
			    PInfo[playerid][ExtraXPRealTime] = gettime()+1728000;
				PInfo[playerid][ExtraXP] = 1;
			}
	     	else if(PInfo[playerid][ExtraXP] > 0)
		 	{
			 	PInfo[playerid][ExtraXPRealTime] += gettime()+1728000;
			 	INI_WriteInt("ExtraXPRealTime",PInfo[playerid][ExtraXPRealTime]+gettime() + 1728000);
	        }
			INI_Save();
			INI_Close();
			PInfo[playerid][ExtraXP] = 1;
	        PInfo[playerid][ExtraXPRealTime] = gettime() + 1728000;
	        PInfo[playerid][Achievement50Hours] ++;
	        CheckAchievement(playerid);
	        SaveStats(playerid);
	        PlayerPlaySound(playerid,4201,0,0,0);
	    }
	    else PInfo[playerid][Achievement50Hours] ++;*/
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
/*=======================================FUNCTIONS END==================================
=======================================STOCKS START==================================*/
stock DealPlayerDamage(playerid, Float:damage)
{
	new Float:health,Float:armour;
	GetPlayerHealth(playerid,health);
	GetPlayerArmour(playerid,armour);
	if(armour != 0)
	{
		if(armour >= damage) return SetPlayerArmour(playerid,armour - damage);
		if(armour < damage)
		{
		    SetPlayerArmour(playerid,0);
		    SetPlayerHealth(playerid,health-damage+armour);
		}
	}
	else
	{
	    SetPlayerHealth(playerid,health-damage);
	}
    return 1;
}

stock GetDealPlayerDamage(playerid, Float:damage)
{
	new Float:health,Float:armour;
	GetPlayerHealth(playerid,health);
	GetPlayerArmour(playerid,armour);
	if(armour != 0)
	{
		if(armour >= damage) return 0;
		if(armour < damage)
		{
		    if((health-damage+armour) < 0) return 1;
		    else return 0;
		}
	}
	else
	{
	    if(health > damage) return 0;
	    else return 1;
	}
    return 0;
}

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
		    case 1: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,175),GivePlayerWeapon(playerid,15,1); //Silenced Pistol + Knuckles + Cane
		    case 2: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,23,202),GivePlayerWeapon(playerid,15,1);//Silenced Pistol + Knuckles + Cane
		    case 3: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,164),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 4: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,179),GivePlayerWeapon(playerid,7,1);//Silenced Pistol + Knuckles + Billiard Cue
		    case 5: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,195),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 6: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,206),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 7: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,211),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
		    case 8: GivePlayerWeapon(playerid,1,1),GivePlayerWeapon(playerid,22,222),GivePlayerWeapon(playerid,2,1);//2 dual pistols + Knuckles + Billiard Cue
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
///=======================================STOCKS END==================================
