new TextEndGameMode[MAX_PLAYERS][64];
new HumanTD[MAX_PLAYERS][32];
new ZombieTD[MAX_PLAYERS][32];
new ZORHTD[MAX_PLAYERS][64];
new CPClearedText[MAX_PLAYERS][50];
new InfectionPers[MAX_PLAYERS][32];
new RegDobXPB[MAX_PLAYERS][64];
new PremEXP[MAX_PLAYERS][128];
new ExtraXPEXP[MAX_PLAYERS][128];
new JailMessage[MAX_PLAYERS][128];
new JailLeftm[MAX_PLAYERS][92];
new TutorialHumanEnd[MAX_PLAYERS][5];
new TIP[32][MAX_PLAYERS][128];
new DIGTLM[MAX_PLAYERS][128];
new DesTR[MAX_PLAYERS][64];
new MolotovFail[MAX_PLAYERS][55];
new DropFlashMSG[MAX_PLAYERS][64];
new HumanPerksNames[MAX_PLAYERS][30][32];
new ZombiePerksNames[MAX_PLAYERS][30][25];
stock SetTexts(playerid, Lang=0)
{
	if(IsPlayerNPC(playerid)) return 0;
	/*if(Lang == 0)
	{
        TextEndGameMode[playerid] = "~w~Please wait~n~~g~~h~You will be ~r~reconnected!";
        HumanTD[playerid] = "~g~~h~Survivor";
		ZombieTD[playerid] = "~p~Zombie";
		ZORHTD[playerid] = "~p~ZOMBIE ~w~/ ~g~SURVIVOR";
		CPClearedText[playerid] = "~w~CHECKPOINTS CLEARED: %i/~r~~h~8";
		InfectionPers[playerid] = "Infection: ~r~~h~%i%%";
		RegDobXPB[playerid] = "*** "cred"Your Double XP boost Pack has been expired!";
		PremEXP[playerid] = "*** "cred"Your premium has been expired and your Premium member was automatically setted to none!";
		ExtraXPEXP[playerid] = "*** "cred"Your Extra Xp Pack has been expired and it was automatically disabled for you!";
		JailMessage[playerid] = "~r~You are jailed! ~r~~n~Wait %i seconds until you will be free!";
		JailLeftm[playerid] = "* "cred"Type "corange"/timeleft"cred" to check how much jail time left";
		{
		    format(TutorialHumanEnd[playerid],2070,""cwhite"You have completed course for humans! Half of course left!\nNow I will tell you about "cpurple"Zombies "cwhite"Gameplay");
      		strcat(TutorialHumanEnd[playerid],"\n"cpurple"Zombies"cwhite" must infect all humans to win round \nYou can check how much players are infected, look at \"Infection\" under \"Cleared Checkpoints\"");
			strcat(TutorialHumanEnd[playerid],"\n"cpurple"Zombies "cwhite"dont have inventory instead they have special "corange"Rage Mode"cwhite". In order to fill your rage meter, you need to get killed by a human");
			strcat(TutorialHumanEnd[playerid],"\nYou are in Hive, you will be spawned here after death, you can teleport to other places in the city and also heal yourself by eating Brains (white arrows)");
			strcat(TutorialHumanEnd[playerid],"\nYou can teleport to hive through pipes and can be seen on radar (they have marker \"T\"), also you can teleport to places");
			strcat(TutorialHumanEnd[playerid],"\nObviously zombies don't have any weapons\nSo what to do?");
			strcat(TutorialHumanEnd[playerid],"\nZombies have bite system (we will talk about that later)\nWhen you play as a zombie, other zombies are your friends and rule of teamkilling is same as for humans\nNow go to any pipe and stand in white pointer to continue course");

		}
		TIP[0][playerid] = "* "cred"TIP: "cwhite"Go to any pickup in the Hive, these pickups are in pipes";
		DIGTLM[playerid] = "* "cjam"You can dig to your last death position, you must be close to your last place atleast 100 meters to dig";
        DesTR[playerid] = "* "cred"You destroyed the tracker!";
        MolotovFail[playerid] = ""cwhite"** "cred" You have failed Molotov Mission!";
        DropFlashMSG[playerid] = ""cjam"%s dropped his Flashlight.";
        {
			HumanPerksNames[playerid][0] = "None";
			HumanPerksNames[playerid][1] = "Extra meds";
			HumanPerksNames[playerid][2] = "Extra fuel";
			HumanPerksNames[playerid][3] = "Extra oil";
			HumanPerksNames[playerid][4] = "Flashbang Grenades";
			HumanPerksNames[playerid][5] = "Less BiTE Damage";
			HumanPerksNames[playerid][6] = "Burst Run";
			HumanPerksNames[playerid][7] = "Double support";
			HumanPerksNames[playerid][8] = "More stamina";
			HumanPerksNames[playerid][9] = "Zombie Bait";
			HumanPerksNames[playerid][10] = "Fire punch";
			HumanPerksNames[playerid][11] = "Mechanic";
			HumanPerksNames[playerid][12] = "Sure Foot";
			HumanPerksNames[playerid][13] = "Immune Stimulant";
			HumanPerksNames[playerid][14] = "Rocket Boots";
			HumanPerksNames[playerid][15] = "Homing Beacon";
			HumanPerksNames[playerid][16] = "Master Mechanic";
			HumanPerksNames[playerid][17] = "Flame Rounds";
			HumanPerksNames[playerid][18] = "Lucky charm";
			HumanPerksNames[playerid][19] = "Grenades";
			HumanPerksNames[playerid][20] = "Ultimate Extra Meds";
			HumanPerksNames[playerid][21] = "Powerful Gloves";
			HumanPerksNames[playerid][22] = "Sustained Immunity";
			HumanPerksNames[playerid][23] = "Master Radar";
			HumanPerksNames[playerid][24] = "Fusion Boots";
			HumanPerksNames[playerid][25] = "Freezing Greeting";
			HumanPerksNames[playerid][26] = "Exploding Bait";
			HumanPerksNames[playerid][27] = "Medical Flag";
			HumanPerksNames[playerid][28] = "Shadow Warrior";
			HumanPerksNames[playerid][29] = "Assault Grenade Launcher";
			ZombiePerksNames[playerid][0] =	"None";
			ZombiePerksNames[playerid][1] =	"Hard Bite";
			ZombiePerksNames[playerid][2] =	"Digger";
			ZombiePerksNames[playerid][3] =	"Refreshing Bite";
			ZombiePerksNames[playerid][4] =	"Jumper";
			ZombiePerksNames[playerid][5] =	"Dead Sense";
			ZombiePerksNames[playerid][6] =	"Hard Punch";
			ZombiePerksNames[playerid][7] =	"Vomiter";
			ZombiePerksNames[playerid][8] =	"Screamer";
			ZombiePerksNames[playerid][9] =	"Burst run";
			ZombiePerksNames[playerid][10] = "Stinger Bite";
			ZombiePerksNames[playerid][11] = "Big Jumper";
			ZombiePerksNames[playerid][12] = "Stomp";
			ZombiePerksNames[playerid][13] = "Thick Skin";
			ZombiePerksNames[playerid][14] = "God Dig";
			ZombiePerksNames[playerid][15] = "Hemorrhage";
			ZombiePerksNames[playerid][16] = "High Jumper";
			ZombiePerksNames[playerid][17] = "Repellent";
			ZombiePerksNames[playerid][18] = "Ravaging Bite";
			ZombiePerksNames[playerid][19] = "Super Scream";
			ZombiePerksNames[playerid][20] = "Popping Tires";
			ZombiePerksNames[playerid][21] = "Extra Refreshing Bite";
			ZombiePerksNames[playerid][22] = "God Sense";
			ZombiePerksNames[playerid][23] = "Blind Bite";
			ZombiePerksNames[playerid][24] = "Hell Scream";
			ZombiePerksNames[playerid][25] = "Super Hard Punch";
			ZombiePerksNames[playerid][26] = "Powerful Dig";
			ZombiePerksNames[playerid][27] = "GodLike Jumper";
			ZombiePerksNames[playerid][28] = "Meat Sharing";
			ZombiePerksNames[playerid][29] = "Toxic Bite";
        }
	}*/
	return 0;
}
