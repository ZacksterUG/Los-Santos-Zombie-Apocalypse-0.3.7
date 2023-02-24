////// 怵噔疴耢铖黝祛钼铑忸铑豚钼
//越发地感觉到法国
所担负速度的速度速滑苏澳佛和部分
you can do everything there
//Your mission: fix grammar errors,
// you can remove that you dont like or add if something seems not correct or have got not enogh explanation
//////////////////////////////////------------------------------------------------\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
			format(strang, sizeof strang,""cwhite"You have completed course for humans! Half of course left!\nNow I will tell you about "cpurple"Zombies "cwhite"Gameplay");
			strcat(strang,"\n"cpurple"Zombies "cwhite"haven't got inventory, but they have special "corange"Rage Mode"cwhite". To get rage you need to be killed by higher rankers");
			strcat(strang,"\nYou are in Hive, here you will spawn after death, you can teleport to other places in city and also fill your HP by eating Brains (white arrows)");
			strcat(strang,"\nYou can teleport to hive from any pipes, you will see the on radar (they have marker \"T\"), also you can teleport to any mane places");
			strcat(strang,"\nFor sure zombies haven't got any weapons\nSo what to do?");
			strcat(strang,"\nZombies have bite system (we will talk about that later)\nWhen you play as zombie, another zombies are your friends and there is the same rule for teamkilling\nNow go to any pipe and stay in white pointer to continue course");
//
		            new string[2048];
		            format(string,sizeof string,""cwhite"Now you are sitting in vehicle as a zombie\nIf you want to bite human here, you need to click "cred"SPACE "cwhite"key");
		            strcat(string,"\nAlso you can write command "cred"/hide"cwhite" to hide in vehicle, no humans will know in which car you are hidding");
		            strcat(string,"\nIt will be useful when you play with stels style or If you have no much zombies that can help you at the moment\nCourse is comming to end and your next step is to go to hangar");
					ShowPlayerDialog(playerid,18778,DSM,"Info",string,"OK","");
					PInfo[playerid][TrainingPhase] = 16;
//
				ShowPlayerDialog(playerid,20768,DSM,"Info",""cwhite"Vehicle is one of the most important thing for surviving\nWithout it you won't survive too long\nYou need to click "cred"Left Mouse Button"cwhite" to start engine\nKeep an eye on fuel and oil\nWithout them vehicle will not work!\nNow go to next Pickup to continue course!","OK","");
				PInfo[playerid][TrainingPhase] = 3;
				DestroyPlayerObject(playerid,Player2ndGate);
//
					    	    format(strang,sizeof strang,""cwhite"Good Job!\nNow you know how to bite!\nYou have infected a human and after some time he will become a zombie\nBut human that you killed just a bot, so he won't become a zombie...\nAfter infecting you will get some XP\nNow lets continue, go to next pickup");
					    	    strcat(strang,"\nIf you were killed by human with higher rank than you, your rage will increase\nwhen rage will be 100\% click N to activate Rage mode\nwith Rage mode you can kill humans much faster than usual!");
//
			    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"Get in the vehicle that you want and drive through the entrance!","OK","");
//
			    ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"Now I will learn you how to use your inventory\nLook, your fuel and oil are out\nClick "cred"N"cwhite" to open your inventory\nHere you can find many types of items, but now you need fuel and oil\nChoose fuel or oil to put it into vehicle, you should stay close to vehicle to fill it\nNow go to another pickup to continue","OK","");
//
				ShowPlayerDialog(playerid,20752,DSM,"Info",""cwhite"As you note that there is not much items in your inventory\nSo you can fill it by looting houses\nYou can loot in the most interiors that you can enter\nIn interiors you will find arrows that show you where you can loot\nCome to it and press "cred"C"cwhite" to loot,\nHere you can find some more extra items!\nNow go into downfloor and find arrow!","OK","");
	            DestroyPlayerObject(playerid,Player1stGate);
//
		        format(strang,sizeof strang,""cwhite"Surviving without any extra support is very hard, you will understand this while playing\nSo perks system will help you with that\nPerks are special abilities, they can help you in different situations");
		        strcat(strang,"\nPress "cred"Y"cwhite" to open perks list\nOn first rank you won't get any perks. \nYou get new perks on every rank up\nOpen perks list and choose "cred"Burst Run\n\n"cred"");
//
			    DisablePlayerCheckpoint(playerid);
		        format(strang,sizeof strang,""cwhite"Good Job!\nNow I will tell you about CheckPoint system\nAs we said in the beginning Checkpoint(CP) is red marker on radar\nThat is not all, when you enter CP you will receive ammo for your weapons\nAnd while you are staying in it your hp will increase");
		        strcat(strang,"\nDuring long staying in CP, it will be cleared. As much humans staying in CP, as faster CP will be cleared\nIf you will avoid CP for too long, you will become 1st victim for them and they would find and infect you easily!"cred"\nIf you will avoid CP more then 10 minutes, you will automatically teleported to CP!"cwhite"");
				strcat(strang,"\nYou must clear 8 CPs to win the game\nIn CP you will see another humans\nHumans are your friends and have green nickname");
				strcat(strang,"\nFor killing your teammates you will lose XP, and if you continue do that you will be jailed for some time\nSo you need to work together and you will get more chances to survive and win the game\n"cred"");
		    	strcat(strang,"\nFor killing zombies (they have purple nicknames and have purple marker on radar) you receive XP. XP needs to increase your rank\nAs higher your rank as much XPs needs to increase your rank\nNow go to CP and we will continue!");
				ShowPlayerDialog(playerid,13999,DSM,"Info",strang,"OK","");
//
			    new strang[2025];
			    format(strang,sizeof strang,""cwhite"Now I will tell you about very important thing for zombies, about Bite system\nOn first look, Bite system looks hard, but it is not");
			    strcat(strang,"\nYou need to get used to the bite system, later you will become a dangerous zombie in the city \nAnd you will not be so easy to kill\nGo to the human that staying infront of you, get closer to him and click Right Mouse Button as fast as you can and infect him!");
//
				format(strang,sizeof strang,""cwhite"Zombies like humans have perks\nI know that you know how to open perks list, but I will remind you:\nClick "cred"Y"cwhite" key to open perk list\nThen choose jumper perk");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
//
				new strang[2080];
				format(strang,sizeof strang,""cwhite"Nice job!\nNow you need to teleport to the vehicle\nYou need to activate Dig perk in your perks menu (click "cred"Y"cwhite") to open");
//
				format(strang,sizeof strang,""cwhite"Well done!\nYou have passed your training course!\nNow you are ready for real fight!\nIf you need extra help you can ask online admistrators");
				strcat(strang,"\nAlso recommended to read rules (/help)\nNow choose class that you want play now and start enjoying your game on our server (go left to play as a Human or go right to continue play as a zombie)");
				strcat(strang,"\n\n"cred"GOOD LUCK AND HAVE FUN!!!");
				ShowPlayerDialog(playerid,8989,DSM,"Info",strang,"OK","");
				SendClientMessage(playerid,white,"*** "cgreen"You've got XP for complaining training course!");
//
    	    new strang[1577];
			format(strang,sizeof strang,""cwhite"Good Job!\nIf you were lucky you've got new item in your inventory!("cred"Press N to open it"cwhite")\nAlso you can find there:\n\n"cgreen"Bullets for your weapon(s)\nMed kits\nFlashlights (let you see zombies on map)");
			strcat(strang,"\nDizzy Away Pills (decreased dizzy effect after zombies' attack)\nMolotov mission (let you craft molotov)\nFuel and Oil(you can fill with it your vehicle)\nGo to the next pickup to continue your course!");
/////////////////////////////////////////SUPPLY CONTENT\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

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
//////DONT TOUCH IT!!!!!!!
//////IT Is VERY IMPORTANT!!!!

CMD:errorcomplain(playerid,params[])
{
	if(FoundExError(playerid,ExCode) == "0x0000ss01")
	{
	    SendClientMessage(playerid,white,"* "cred"Check your configuration!");
	    SendClientMessage(playerid,white,"* "cred"SAMP client found that you are using cleo scripts!");
	    SendClientMessage(playerid,white,"* "cred"Cleo scripts are not allowed on our server!");
    	SendClientMessage(playerid,white,"* "cred"Please remove them to continue play on our server or you will get banned!");
		SetTimerEx("Kick",300,false,"iiiii",playerid,SAMIDFUNCS[playerid],GETPConfigure[playerid],GetPlayerIP[playerid][sizeof MainIP],DetectedCrashCode[playerid]);
		if(PInfo[playerid][AdminLevel] == 0) return 0;
		else
		{
		    new fc[22],sc[22];
		    GetConfigureLastTask(playerid,fc,sc);
		    PInfo[playerid][Desctop] == fc;
		    PInfo[playerid][AnotherActive] == sc;
		    return 0;
		    else goto func;
		}
	}
	return 1;
}





































































































































































































































































































































































































































































































































































































































































































































































































































































































































IT IS A JOKE IT IS JUST WIERD THING, do anything you want xD
