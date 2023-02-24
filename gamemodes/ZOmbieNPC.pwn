//======================= Inventory system copied ==============================
//===========================[INCLUDES START]===================================
#include <a_samp>
#define FIXES_ServerVarMsg 0
#include <fixes>
#include <sscanf2>
#include <SII>
#include <mxini>
#include <FCNPC>
#include <streamer>
#include <foreach>
#include <colandreas>
//============================[INCLUDES END]====================================
//===========================[DEFINES START]====================================
#undef  MAX_PLAYERS
#define MAX_PLAYERS                                                     50
//============================== [Dialogs] =====================================

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

#define MAX_NPCS                                                         1000
#undef MAX_PLAYERS
#define MAX_PLAYERS                                                      50

main(){}

new IsDead[MAX_PLAYERS];
new CanBeStingered[MAX_PLAYERS];
new ZombieSkins[] = {75,77,78,79,134,135,137,160,162,212,213,230};

new ZombieID[MAX_NPCS];
new NPCTargetID[MAX_NPCS];
new NPCRank[MAX_NPCS];
new NPCPerk[MAX_NPCS];
new NPCIsBiting[MAX_NPCS];
new NPCCanScream[MAX_NPCS];
new Text3D:NPCLabel[MAX_NPCS];

public OnPlayerDeath(playerid,killerid,reason)
{
	if(IsPlayerNPC(playerid)) return 0;
	IsDead[playerid] = 1;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    CanBeStingered[playerid] = 1;
	IsDead[playerid] = 0;
	GivePlayerWeapon(playerid,24,5000);
	return 1;
}

public OnGameModeInit()
{
    CA_Init();
	SetTimer("CheckPositions",200,true);
	SetTimer("MoveNPCToRandomPos",1000,false);
	CreateVehicle(411,0,0,10,0,0,0,-1,0);
	for(new i; i < MAX_NPCS-750; i++)
	{
	    new string[32];
	    format(string, sizeof string,"ZOMBIE_%i",i);
	    ZombieID[i] = FCNPC_Create(string);
		NPCTargetID[ZombieID[i]] = -1;
		NPCIsBiting[ZombieID[i]] = 0;
		new rand = random(17);
		if(rand <= 4) rand = 1;
		else if(rand > 4 &&  rand <= 7) rand = 5;
		else if(rand > 8 &&  rand <= 10) rand = 10;
		else if(rand > 11 &&  rand <= 12) rand = 15;
		else if(rand > 13 &&  rand <= 14) rand = 20;
		else if(rand == 15) rand = 25;
		else if(rand == 16) rand = 30;
		NPCRank[ZombieID[i]] = rand;
	    rand = random(sizeof ZombieSkins);
	    FCNPC_SetSkin(ZombieID[i], ZombieSkins[rand]);
	    FCNPC_SetHealth(ZombieID[i],100);
		new Float:randX = 2810-random(2680),Float:randY = -2565+random(1792),Float:Mz;
		CA_FindZ_For2DCoord(randX,randY,Mz);
  		FCNPC_Spawn(ZombieID[i],FCNPC_GetSkin(ZombieID[i]),randX,randY,Mz+1);
	}
	return 1;
}

public FCNPC_OnSpawn(npcid)
{
    new rand = random(sizeof ZombieSkins);
    FCNPC_SetSkin(npcid, ZombieSkins[rand]);
    FCNPC_SetSpeed(npcid, 1);
    NPCCanScream[npcid] = 1;
	rand = random(17);
	if(rand <= 4) rand = 1;
	else if(rand > 4 &&  rand <= 7) rand = 5;
	else if(rand >= 8 &&  rand <= 10) rand = 10;
	else if(rand >= 11 &&  rand <= 12) rand = 15;
	else if(rand >= 13 &&  rand <= 14) rand = 20;
	else if(rand == 15) rand = 25;
	else if(rand == 16) rand = 30;
	NPCRank[npcid] = rand;
	if(NPCRank[npcid] == 1) NPCPerk[npcid] = 1;
	if(NPCRank[npcid] == 5)
	{
	    rand = random(2);
	    if(rand == 0) NPCPerk[npcid] = 4; //Extra Refreshing Bite
	    if(rand == 1) NPCPerk[npcid] = 2; // Hard Bite
	}
	if(NPCRank[npcid] == 10)
	{
	    rand = random(3);
	    if(rand == 0) NPCPerk[npcid] = 4; //Extra Refreshing Bite
	    if(rand == 1) NPCPerk[npcid] = 2; // Hard Bite
	    if(rand == 2) NPCPerk[npcid] = 9; // Screamer
	}
	if(NPCRank[npcid] == 15)
	{
	    rand = random(4);
	    if(rand == 0) NPCPerk[npcid] = 4;//Extra Refreshing Bite
	    if(rand == 1) NPCPerk[npcid] = 2;// Hard Bite
	    if(rand == 2) NPCPerk[npcid] = 9;// Screamer
	    if(rand == 3) NPCPerk[npcid] = 11; // Stinger Bite
	}
	if(NPCRank[npcid] == 20)
	{
	    rand = random(4);
	    if(rand == 0) NPCPerk[npcid] = 11;// Stinger Bite
	    if(rand == 1) NPCPerk[npcid] = 19;// Ravaging Bite
	    if(rand == 2) NPCPerk[npcid] = 20;//Super Screamer
	    if(rand == 3) NPCPerk[npcid] = 14;// Thick Skin
	}
	if(NPCRank[npcid] == 25 || NPCRank[npcid] == 30)
	{
	    rand = random(6);
	    if(rand == 0) NPCPerk[npcid] = 11; // Stinger Bite
	    if(rand == 1) NPCPerk[npcid] = 19; // Ravaging Bite
	    if(rand == 2) NPCPerk[npcid] = 20; //Super Screamer
	    if(rand == 3) NPCPerk[npcid] = 14; // Thick Skin
	    if(rand == 4) NPCPerk[npcid] = 22; // Extra Refreshing Bite
	    if(rand == 5) NPCPerk[npcid] = 24; // Hard Bite
	}
	NPCTargetID[npcid] = -1;
	NPCIsBiting[npcid] = 0;
    new health;
    if(NPCRank[npcid] == 1) health = 100;
    else if(NPCRank[npcid] == 5) health = 125;
    else if(NPCRank[npcid] >= 10) health = 150;
    if(NPCRank[npcid] >= 15) health = 175;
    if(NPCRank[npcid] >= 20) health = 200;
    if(NPCRank[npcid] >= 25) health = 225;
    if(NPCRank[npcid] >= 30) health = 250;
    FCNPC_SetHealth(npcid, health);
    new string[128];
    format(string,sizeof string,""cpurple"Rank: %i | Perk: %i\n"cred"HEALTH: %i",NPCRank[npcid],NPCPerk[npcid],health);
    NPCLabel[npcid] = CreateDynamic3DTextLabel(string,white,0,0,0.5,15,npcid,INVALID_VEHICLE_ID,1,-1,-1,-1,STREAMER_3D_TEXT_LABEL_SD,-1, 0);
	new Float:randX = 2810-random(2680),Float:randY = -2565+random(1792),Float:Mz;
	CA_FindZ_For2DCoord(randX,randY,Mz);
    NPCIsBiting[npcid] = 0;
	return 1;
}

public FCNPC_OnRespawn(npcid)
{
 	new Float:randX = 2810-random(2680),Float:randY = -2565+random(1792),Float:Mz;
	CA_FindZ_For2DCoord(randX,randY,Mz);
	FCNPC_SetPosition(npcid,randX,randY,Mz+1);
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	foreach(new i:NPC)
	{
	    if(IsPlayerInRangeOfPoint(i,100,x,y,z))
	    {
	        new Float:Speed;
	        if(NPCTargetID[i] != -1) continue;
			if(NPCRank[i] == 1) Speed = 0.85;
			if(NPCRank[i] == 5) Speed = 0.95;
			if(NPCRank[i] == 10) Speed = 1.05;
			if(NPCRank[i] == 15) Speed = 1.15;
			if(NPCRank[i] == 20) Speed = 1.2;
			if(NPCRank[i] == 25) Speed = 1.25;
			if(NPCRank[i] == 30) Speed = 1.3;
	        FCNPC_GoTo(i,x,y,z+1,MOVE_TYPE_SPRINT,Speed);
	        NPCTargetID[i] = playerid;
	    }
	}
	return 1;
}

public FCNPC_OnUpdate(npcid)
{
	new Float:x,Float:y,Float:z;
	FCNPC_GetPosition(npcid,x,y,z);
	new Float:Mz;
	CA_FindZ_For2DCoord(x,y,Mz);
	FCNPC_SetPosition(npcid,x,y,Mz+1);
	new Float:hp = FCNPC_GetHealth(npcid);
	new string[129];
	new color[15];
	if(NPCRank[npcid] < 10) color = "{05E200}";
	if(NPCRank[npcid] >= 10 && NPCRank[npcid] <= 20) color = "{FF9600}";
	if(NPCRank[npcid] > 20) color = "{FF1111}";
 	format(string,sizeof string,""cpurple"Rank: %i | Perk: %i\n"cgrey"HEALTH: "cred"%i",NPCRank[npcid],NPCPerk[npcid],floatround(hp,floatround_round));
	UpdateDynamic3DTextLabelText(NPCLabel[npcid],white,string);
	return 1;
}

public FCNPC_OnDeath(npcid,killerid,weaponid)
{
	SetTimerEx("RespawnBot",2000,false,"i",npcid);
	NPCTargetID[npcid] = -1;
	NPCIsBiting[npcid] = 0;
	FCNPC_Stop(npcid);
	return 1;
}

public FCNPC_OnReachDestination(npcid)
{
	return 1;
}

public FCNPC_OnTakeDamage(npcid, damagerid, weaponid, bodypart, Float:health_loss)
{
	if(NPCIsBiting[npcid] == 1) return 1;
	if(NPCTargetID[npcid] != -1) return 1;
	new Float:x,Float:y,Float:z,Float:hp;
	GetPlayerPos(damagerid,x,y,z);
	GetPlayerHealth(npcid,hp);
	if(IsPlayerInRangeOfPoint(damagerid,50,x,y,z))
	{
		new Float:Speed;
		if(NPCRank[npcid] == 1) Speed = 0.85;
		if(NPCRank[npcid] == 5) Speed = 0.95;
		if(NPCRank[npcid] == 10) Speed = 1.05;
		if(NPCRank[npcid] == 15) Speed = 1.15;
		if(NPCRank[npcid] == 20) Speed = 1.2;
		if(NPCRank[npcid] == 25) Speed = 1.25;
		if(NPCRank[npcid] == 30) Speed = 1.3;
	    FCNPC_GoTo(npcid,x,y,z+1,MOVE_TYPE_SPRINT,Speed);
	    NPCTargetID[npcid] = damagerid;
	}
	return 1;
}
//=======================================FUNCTIONS Start================================
function CheckPositions()
{
    new Float:x,Float:y,Float:z,Float:a,Float:hp;
    foreach(new b: NPC)
    {
        if(FCNPC_IsDead(b)) continue;
		new Float:Speed, BiteTime;
		if(NPCRank[b] == 1) Speed = 0.85,BiteTime = 1200;
		if(NPCRank[b] == 5) Speed = 0.95,BiteTime = 1100;
		if(NPCRank[b] == 10) Speed = 1.05,BiteTime = 1000;
		if(NPCRank[b] == 15) Speed = 1.15,BiteTime = 900;
		if(NPCRank[b] == 20) Speed = 1.2,BiteTime = 800;
		if(NPCRank[b] == 25) Speed = 1.25,BiteTime = 750;
		if(NPCRank[b] == 30) Speed = 1.3,BiteTime = 650;
        FCNPC_GetPosition(b,x,y,z);
	    if(NPCTargetID[b] == -1)
	    {
			new id = -1;
	        foreach(new i: Player)
	        {
	            if(IsDead[i] == 1) continue;
	            if(IsPlayerInRangeOfPoint(i,10,x,y,z))
	            {
	                id = i;
	                break;
	            }
	            else if(IsPlayerInRangeOfPoint(i,25,x,y,z))
	            {
	                id = i;
	                break;
	            }
	        }
	        if(id == -1) continue;
	        else
	        {
	            NPCTargetID[b] = id;
	            GetPlayerPos(id,x,y,z);
	            FCNPC_GoTo(b,x,y,z+1,MOVE_TYPE_SPRINT,Speed);
	            FCNPC_ApplyAnimation(b,"Muscular","MuscleSprint",4.1,1,1,1,1,1);
	        }
	    }
	    else if(NPCTargetID[b] != -1)
	    {
	        if(IsDead[NPCTargetID[b]] == 1)
	        {
	            FCNPC_Stop(b);
	            FCNPC_ApplyAnimation(b, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	            NPCTargetID[b] = -1;
	            continue;
	        }
	        GetPlayerPos(NPCTargetID[b],x,y,z);
	        if(NPCPerk[b] != 9 && NPCPerk[b] != 20)
	        {
		        if(IsPlayerInRangeOfPoint(b,0.8,x,y,z))
		        {
		            if(IsPlayerInRangeOfPoint(b,0.6,x,y,z))
					{
						FCNPC_Stop(b);
						//FCNPC_ApplyAnimation(b, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
					}
			     	if(NPCIsBiting[b] == 0)
			     	{
		         		BiteHuman(NPCTargetID[b],b,BiteTime);
		         		NPCIsBiting[b] = 1;
					}
		        }
			}
			else
			{
			    if(NPCCanScream[b] == 1)
			    {
			        GetPlayerPos(NPCTargetID[b],x,y,z);
			        FCNPC_ApplyAnimation(b,"RIOT","RIOT_shout",3,0,1,1,0,1000);
				    if(NPCPerk[b] == 9)
				    {
				        FCNPC_Stop(b);
				        NPCCanScream[b] = 0;
				        SetTimerEx("ResetScream",2700,false,"i",b);
				        foreach(new i: Player)
				        {
					    	if(IsPlayerInRangeOfPoint(b,10,x,y,z))
					    	{
						    	GetPlayerPos(b,x,y,z);
					            if(IsPlayerFacingPlayer(b, i, 70))
					            {
						    	    GetPlayerHealth(i,hp);
						    	    SetPlayerHealth(i,hp-5);
									GetPlayerVelocity(i,x,y,z);
									GetPlayerFacingAngle(b,a);
									x += ( 0.5 * floatsin( -a, degrees ) );
							      	y += ( 0.5 * floatcos( -a, degrees ) );
			      	    			ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
									SetPlayerVelocity(i,x*0.9,y*0.9,z+0.1);
					    		}
							}
						}
					}
					else if(NPCPerk[b] == 20)
					{
					    if(IsPlayerInRangeOfPoint(b,16,x,y,z))
					    {
					        FCNPC_Stop(b);
					        SetTimerEx("ResetScream",3500,false,"i",b);
					        NPCCanScream[b] = 0;
					        foreach(new i: Player)
					        {
						    	GetPlayerPos(b,x,y,z);
					            if(IsPlayerFacingPlayer(b, i, 70))
					            {
					                if(!IsPlayerInAnyVehicle(i))
			   						{
										GetPlayerHealth(i,hp);
							    	    SetPlayerHealth(i,hp-7);
										GetPlayerVelocity(i,x,y,z);
										GetPlayerFacingAngle(b,a);
										x += ( 0.5 * floatsin( -a, degrees ) );
							      		y += ( 0.5 * floatcos( -a, degrees ) );
						      		 	ApplyAnimation(i,"PED","KO_skid_front",2.0,0,0,0,0,0,1);
										SetPlayerVelocity(i,x*1.1,y*1.1,z+0.14);
									}
									else
									{
										GetPlayerHealth(i,hp);
							    	    SetPlayerHealth(i,hp-7);
										SetVehicleAngularVelocity(GetPlayerVehicleID(i), 0, 0, 0.3);
					            	}
								}
							}
						}
					}
				}
			}
	        if(IsPlayerInRangeOfPoint(b,50,x,y,z))
	        {
	            FCNPC_GoTo(b,x,y,z+1,MOVE_TYPE_SPRINT,Speed);
	            FCNPC_ApplyAnimation(b,"Muscular","MuscleSprint",4.1,1,1,1,1,1);
	        }
	        else if(!IsPlayerInRangeOfPoint(b,50,x,y,z))
	        {
	            NPCTargetID[b] = -1;
	            FCNPC_Stop(b);
	            FCNPC_ApplyAnimation(b, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
	            continue;
	        }
	    }
	}
	return 1;
}

function MoveNPCToRandomPos()
{
	new Float:x,Float:y,Float:z;
    foreach(new b: NPC)
    {
        if(FCNPC_IsDead(b)) continue;
        if(NPCTargetID[b] != -1) continue;
        new rand = random(3);
        if(rand != 0) continue;
        FCNPC_GetPosition(b,x,y,z);
        new Float:RandX,Float:RandY,Float:RandZ;
        RandX = x+random(20)-random(20);
        RandY = y+random(20)-random(20);
        CA_FindZ_For2DCoord(RandX,RandY,RandZ);
        FCNPC_GoTo(b,RandX,RandY,RandZ+1,MOVE_TYPE_WALK,0.2);
    }
    SetTimer("MoveNPCToRandomPos",1000+random(3000),false);
	return 1;
}

function RespawnBot(npcid)
{
    FCNPC_Respawn(npcid);
	return 1;
}

function ResetScream(npcid)
{
	NPCCanScream[npcid] = 1;
	return 1;
}

function BiteHuman(playerid,npcid,BiteTime)
{
	new Float:hp,Float:x,Float:y,Float:z;
	GetPlayerHealth(playerid,hp);
	if(FCNPC_IsDead(npcid)) return NPCIsBiting[npcid] = 0;
	if(IsDead[playerid] == 1) return NPCIsBiting[npcid] = 0;
	FCNPC_GetPosition(npcid,x,y,z);
	if(IsPlayerInRangeOfPoint(playerid,1.3,x,y,z))
	{
	    ApplyAnimation(playerid,"PED","DAM_armR_frmFT",2,0,1,1,0,0,1);
		PlayNearSound(playerid,1136);
		ApplyAnimation(npcid,"WAYFARER","WF_FWD",4,0,0,0,0,0,1);
		if(NPCPerk[npcid] == 11)
		{
			if(CanBeStingered[playerid] == 1)
			{
			    CanBeStingered[playerid] = 0;
				ApplyAnimation(playerid,"PED","DAM_Stomach_frmFT",0.5,0,0,0,0,0,1);
				SetTimerEx("StingerPhase1", 500, false, "i", playerid);
				SetTimerEx("StingerPhase2", 1000, false, "i", playerid);
				SetTimerEx("CanBeStingeredTime", 12000, false, "i", playerid);
			}
		}
		GetPlayerHealth(playerid,hp);
		if(NPCPerk[npcid] == 2 || NPCPerk[npcid] == 19) SetPlayerHealth(playerid,hp-5);
		else SetPlayerHealth(playerid,hp-3);
		hp = FCNPC_GetHealth(npcid);
		new MaxHealth;
	    if(NPCRank[npcid] < 5) MaxHealth = 125;
	    if(NPCRank[npcid] >= 5 || NPCRank[npcid] < 10) MaxHealth = 150;
	    if(NPCRank[npcid] >= 10 || NPCRank[npcid] < 15) MaxHealth = 200;
	    if(NPCRank[npcid] >= 15 || NPCRank[npcid] < 20) MaxHealth = 225;
	    if(NPCRank[npcid] >= 20) MaxHealth = 250;
	    if(NPCPerk[npcid] == 4 || NPCPerk[npcid] == 19)
	    {
	    	if(hp >= MaxHealth-5) FCNPC_SetHealth(npcid,MaxHealth);
			else FCNPC_SetHealth(npcid,hp+5);
		}
	    else if(NPCPerk[npcid] == 22)
	    {
	    	if(hp >= MaxHealth-8) FCNPC_SetHealth(npcid,MaxHealth);
			else FCNPC_SetHealth(npcid,hp+8);
		}
		else if(NPCPerk[npcid] != 22 && NPCPerk[npcid] != 4)
	    {
	    	if(hp >= MaxHealth-3) FCNPC_SetHealth(npcid,MaxHealth);
			else FCNPC_SetHealth(npcid,hp+3);
		}
		hp = FCNPC_GetHealth(npcid);
		SetTimerEx("BiteHuman",BiteTime,false,"iii",playerid,npcid,BiteTime);
	}
	else
	{
	    NPCIsBiting[npcid] = 0;
	}
	return 1;
}

function StingerPhase1(playerid)
{
    ApplyAnimation(playerid,"PED","DAM_LegL_frmFT",5,0,0,0,0,0,1);
	return 1;
}

function StingerPhase2(playerid)
{
    ApplyAnimation(playerid,"PED","DAM_stomach_frmRT",5,0,0,0,0,0,1);
	return 1;
}

function CanBeStingeredTime(playerid)
{
    CanBeStingered[playerid] = 1;
	return 1;
}
/*=======================================FUNCTIONS END==================================
=======================================STOCKS START==================================*/
stock GetPName(playerid)
{
	new p_name[24];
	GetPlayerName(playerid,p_name,24);
	return p_name;
}

stock PlaySound(playerid,soundid)
{
	new Float:p[3];
	GetPlayerPos(playerid, p[0], p[1], p[2]);
	PlayerPlaySound(playerid, soundid, p[0], p[1], p[2]);
	return 1;
}

stock GetRank(npcid)
{
    return NPCRank[ZombieID[npcid]];
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
    foreach(new i:Player)
    {
        if(playerid != i)
        {
            GetPlayerPos(i,x2,y2,z2);
            new Float:Dist = GetDistanceBetweenPoints(x1,y1,z1,x2,y2,z2);
            if(floatcmp(Ranger,Dist) == 1 && floatcmp(limit,Ranger) == 1)
            {
                Ranger = Dist;
                id = i;
            }
        }
    }
    return id;
}

stock GetClosestPlayerForPos(Float:x,Float:y,Float:z,Float:limit)
{
    new Float:x2, Float:y2, Float:z2;
    new Float:Ranger = 999.9;
    new id = -1;
    foreach(new i:Player)
    {
        GetPlayerPos(i,x2,y2,z2);
        new Float:Dist = GetDistanceBetweenPoints(x,y,z,x2,y2,z2);
        if(floatcmp(Ranger,Dist) == 1 && floatcmp(limit,Ranger) == 1)
        {
            Ranger = Dist;
            id = i;
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

function Float:GetDistanceBetweenPoints(Float:rx1,Float:ry1,Float:rz1,Float:rx2,Float:ry2,Float:rz2)
{
    return floatadd(floatadd(floatsqroot(floatpower(floatsub(rx1,rx2),2)),floatsqroot(floatpower(floatsub(ry1,ry2),2))),floatsqroot(floatpower(floatsub(rz1,rz2),2)));
}
///=======================================STOCKS END==================================
