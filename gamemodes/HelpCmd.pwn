


/*
1st = ENGLISH
2nd = RUSSIAN
3rd = SPANISH

1st = ENGLISH
2nd = RUSSIAN
3rd = SPANISH

1st = ENGLISH
2nd = RUSSIAN
3rd = SPANISH

1st = ENGLISH
2nd = RUSSIAN
3rd = SPANISH

1st = ENGLISH
2nd = RUSSIAN
3rd = SPANISH



*/
/////////////////////////////////////SCRIPT (HERE v
	if(PInfo[playerid][lnaguage] == 1)///////////////////////////////////////////////////ENGLISH/////////
	{
		if(dialogid == Guidesurvivor)
	    {
	        new string[650];
	        if(response)
	        {
	        	ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
	        else//if(PInfo[playerid][lnaguage] == 2)
	        {
				strcat(string,"\n- You also access a new weapon after 5 ranks up, (Rank 5, Rank 10... etc), you can select the desired weapon by using the following cmd "cred"/weapons \n"cwhite"and then selecting the name of the gun.\n");
				strcat(string,"\n- Survivors also got inventory to open the inventory you should press "cred"''~k~~CONVERSATION_NO~/[N] "cwhite" KEY\nin the inventory you can fined..Medkits("cred"+HP"cwhite"),Fuel,Oil and etc..\nto get more items you should go to cj's or another house to search for items by pressing "cred"''~k~~PED_DUCK~ /[C]''"cwhite"\n");
				strcat(string,"\n- Each perk has got a duration of cooldown, you must wait sometime upon activating a perk to use another one.\n\n");
				ShowPlayerDialog(playerid,Guidesurvivor2,DIALOG_STYLE_MSGBOX,"Survivor Team Guide Page 2",string,"Previous Page","Close");
			}
			return 1;
		}
		if(dialogid == Guidesurvivor2)
	    {
	        if(response)
	        {
	       		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"Survivor Team");
				format(string, sizeof(string), ""cwhite" - You've just accessed the "cgreen"Survivors "cwhite"Team assistance list.\n");
				strcat(string,"\n- As a survivor, your objective to win the round is to clear all the eight "cred"checkpoints "cwhite"(Randomly placed on the map as red marks in various locations).\n");
				strcat(string,"\n- To clear a checkpoint you must stand inside the red mark for a short period of time to clear it\nyou receive health and ammo upon entering the "cred"red mark"cwhite", after clearing you gain +10 EXP.\n");
				strcat(string,"\n- Clearing these "cred"checkpoints "cwhite"won't be a walk in the park, you will have to pass through zombies, killing a zombie will make you gain 10 EXP,\nassisting on a kill makes you gain 1 EXP. You keep gaining EXP until you rank up.\n");
				strcat(string,"\n- Ranking up grants you extra ''PERKS'', Perks are basically extra skills and abilities that you can use in order to survive\nto access the list of Perk you press "cred"~k~~CONVERSATION_YES~/Y"cwhite" and then you select the desired perk.\n");
				ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Go Back","Next Page");
	        }
	        return 1;
		}
		if(dialogid == Guidezombie)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
			//ELSE CLOSE!
	        return 1;
		}
		if(dialogid == Guiderules)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
	        else
	        {
				new strin[1000],strin2[100];
				format(strin2, sizeof(strin2), ""cwhite"Server Rules Page 2");
				format(strin, sizeof(strin), " ");
		 		strcat(strin,"\n"cwhite"- 6) Hacking/Cheats/Mods: Using any kind of Hacks or \nCLEO mods or anything that gives you advantages rather than any normal player is NOT allowed,\nviolating this rule will get you banned from the server.\n");
				strcat(strin,"\n"cwhite"- 7) Suiciding: Suiciding in order to avoid being killed by the other team is NOT allowed,\nviolating this will get you set to the other team or further punishment.\n");
				strcat(strin,"\n"cwhite"- 8) Abusing Bugs: Finding any kind of bug in the script or in the map and abusing it is NOT allowed\nand is NOT tolerated at all, if you find a bug you report it on forum");
				strcat(strin,"\nif you ever get caught abusing any bug you will get warned or might get banned from the community.\n");
				strcat(strin,"\n"cwhite"- 9) Respect Administrators: Respecting administrators is a MUST, their duty is to keep your gameplay");
				strcat(strin,"\nfun with no cheaters or hackers, if you ever had a question, do not hesitate and ask it\ndisrespecting admins might result a bad punishment (warn/kick/ban).\n\n");
				ShowPlayerDialog(playerid,Guiderules2,DIALOG_STYLE_MSGBOX,strin2,strin, "Previous Page","Close");
			}
	        return 1;
		}
	 	if(dialogid == Guiderules2)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	                new string[1200],string2[12];
					format(string2, sizeof(string2), ""cwhite"Server Rules");
					format(string, sizeof(string), ""cwhite"- You've just accessed the Server Rules list, read them carefully and avoid breaking them.\n");
					strcat(string,"\n- 1) Bunny Hoping (BH): As a survivor (Most likely), you are NOT allowed to spam jumping while running in order to gain speed,\nviolating this rule gets you slapped/warned or further punishment.\n");
					strcat(string,"\n- 2) TeamKilling (TK): You aren't allowed as AT ALL ("cgreen"Survivors "cwhite"or "cpurple"Zombies"cwhite") to kill your teammates, it's a Team Deathmatch (TDM) server\nyou team up with your teammates and kill the other team.\nViolating this rule gets you slapped/warned or further punshiment.\n");
					strcat(string,"\n- 3) Spamming the Chat: You aren't allowed AT ALL to spam the chat, whether public chat or team chat. Violating this rule gets you muted from speaking.\n");
					strcat(string,"\n- 4) Discrimination & Bad Conduct: We do not tolerate any offensive words, racist, or sexist or any jokes about religions in our community,\nviolating this rule might get you banned from the whole community.\n");
					strcat(string,"\n- 5) Advertising for another server: Advertising for another server is NOT allowed and is NOT tolerated, violating this will get you perma-ban from the server.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Next Page");

	        }
			//ELSE CLOSE!
			return 1;
		}
	 	if(dialogid == Guidedialog)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	            if(listitem == 0)
	            {
	                new string[1000],string2[100];
					format(string2, sizeof(string2), ""cwhite"Server Rules");
					format(string, sizeof(string), ""cwhite"- You've just accessed the Server Rules list, read them carefully and avoid breaking them.\n");
					strcat(string,"\n- 1) Bunny Hoping (BH): As a survivor (Most likely), you are NOT allowed to spam jumping while running in order to gain speed,\nviolating this rule gets you slapped/warned or further punishment.\n");
					strcat(string,"\n- 2) TeamKilling (TK): You aren't allowed as AT ALL ("cgreen"Survivors "cwhite"or "cpurple"Zombies"cwhite") to kill your teammates, it's a Team Deathmatch (TDM) server\nyou team up with your teammates and kill the other team.\nViolating this rule gets you slapped/warned or further punshiment.\n");
					strcat(string,"\n- 3) Spamming the Chat: You aren't allowed AT ALL to spam the chat, whether public chat or team chat. Violating this rule gets you muted from speaking.\n");
					strcat(string,"\n- 4) Discrimination & Bad Conduct: We do not tolerate any offensive words, racist, or sexist or any jokes about religions in our community,\nviolating this rule might get you banned from the whole community.\n");
					strcat(string,"\n- 5) Advertising for another server: Advertising for another server is NOT allowed and is NOT tolerated, violating this will get you perma-ban from the server.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Next Page");

				}
	   			if(listitem == 1)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cpurple"Zombie Team");
					format(string, sizeof(string), ""cwhite"- You've just accessed the "cpurple"Zombies "cwhite"Team assistance list.\n");
					strcat(string,"\n- As a zombie, your objective to win the round is to infect every survivor alive, you'll mostly find them in checkpoints ("cred"Red "cwhite"marks on map).\n");
					strcat(string,"\n- In order to infect a survivor, you need to bite them to death, in order to bite you SPAM the "cplat"RMB"cwhite" / Right-Click / Aim Key,\nwhen you're close enough to a survivor.\n");
					strcat(string,"\n- You gain 12 EXP upon infecting a survivor, 3 EXP for assisting infection, you keep gaining EXP until you rank up.\n");
					strcat(string,"\n- Ranking up grants you new ''PERKS'', Perks allow you to have extra skills and abilities that help you for infections,\nto access the ''PERKS'' list, you press on "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" and then select the perk.\n");
					strcat(string,"\n- Each perk has got a duration of cooldown, you must wait sometime upon activating a perk to use another one.\n\n");
					ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Close");
	            }
	 			if(listitem == 2)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cgreen"Survivor Team");
					format(string, sizeof(string), ""cwhite" - You've just accessed the "cgreen"Survivors "cwhite"Team assistance list.\n");
					strcat(string,"\n- As a survivor, your objective to win the round is to clear all the eight "cred"checkpoints \n"cwhite"(Randomly placed on the map as red marks in various locations).\n");
					strcat(string,"\n- To clear a checkpoint you must stand inside the red mark for a short period of time to clear it\nyou receive health and ammo upon entering the "cred"red mark"cwhite", after clearing you gain +10 EXP.\n");
					strcat(string,"\n- Clearing these "cred"checkpoints "cwhite"won't be a walk in the park, you will have to pass through zombies\nkilling a zombie will make you gain "cplat"EXP,\nassisting on a kill makes you gain 1 EXP. You keep gaining EXP until you rank up.\n");
					strcat(string,"\n- Ranking up grants you extra ''PERKS'', Perks are basically extra skills and abilities that you can use in order to survive\nto access the list of Perk you press "cred"~k~~CONVERSATION_YES~/[Y]"cwhite" and then you select the desired perk.\n\n");
					ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Go Back","Next Page");
	            }
			}
			return 1;
		}///////////////////////////////////////////////////ENLISH///////////////////enlish////////////
	}
	else if(PInfo[playerid][lnaguage] == 2)///////////////////////////////////////////////////RUSSIAN/////////
	{
		if(dialogid == Guidesurvivor)
	    {
	        new string[650];
	        if(response)
	        {
	        	ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"������������ �� ����","�������\n�����\n��������", "���������", "��������");
	        }
	        else//if(PInfo[playerid][lnaguage] == 2)
	        {
				strcat(string,"\n- �� ��������� ����� ������ ������ 5 ������, (���� 5, ���� 10... ���), �� ������ ������� ��������� ������ ����� ������� "cred"/weapons \n"cwhite"� ������ �������� ����������� ��� ��� ������.\n");
				strcat(string,"\n- �������� ����� ��������� "cred"''~k~~CONVERSATION_NO~/[N] "cwhite" KEY\n� ��������� �� ������ �����..�������("cred"+HP"cwhite"),������,����� ���..\n�� ������ �������� ����� �������� � �������� ����� "cred"''~k~~PED_DUCK~ /[C]''"cwhite"\n");
				strcat(string,"\n- ������ ���� ����� �������, �� ������ ������������ ������ ���� ���� ����� �������� ��������.\n\n");
				ShowPlayerDialog(playerid,Guidesurvivor2,DIALOG_STYLE_MSGBOX,"���� �� �������� 2-���",string,"���������� ��������","�������");
			}
			return 1;
		}
		if(dialogid == Guidesurvivor2)
	    {
	        if(response)
	        {
	       		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"��������");
				format(string, sizeof(string), ""cwhite" - ������ �� ������� ���� �� "cgreen"�������� "cwhite".\n");
				strcat(string,"\n- ����� �� �������� ���� ������ ������ 8 "cred"���������� "cwhite"(���������� � ��������� �����, �������� ������� ��������).\n");
				strcat(string,"\n- ����� ������ �������� ����� ����� � ���� � ����� ����� ���������\n�� �������� ��, ����, ������ "cred"red mark"cwhite", ����� ���������� �� �� �������� +10XP.\n");
				strcat(string,"\n- ����������� "cred"���������� "cwhite"�������� ������, ���� �������� ��������� ����� �����, ����� ����� �� �������� 10 EXP,\n������ � �������� - 1XP. ��������� �������� ���� ���� �� ������ �������!\n");
				strcat(string,"\n- ������� ������ �� �������� ''�����'', ����� ������� ���� � ���������\n����� �� "cred"~k~~CONVERSATION_YES~/Y"cwhite" ����� ������� ������ ������, � ������ ���� ����������.\n");
				ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"���������","����. ���");
	        }
	        return 1;
		}
		if(dialogid == Guidezombie)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"������������ �� ����","�������\n�����\n��������", "���������", "��������");
	        }
			//ELSE CLOSE!
	        return 1;
		}
		if(dialogid == Guiderules)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"������������ �� ����","�������\n�����\n��������", "���������", "��������");
	        }
	        else
	        {
				new strin[1000],strin2[100];
				format(strin2, sizeof(strin2), ""cwhite"Server Rules Page 2");
				format(strin, sizeof(strin), " ");
		 		strcat(strin,"\n"cwhite"- 6) ����/����: ������������� ����� ����� ����� \nCLEO ���� � ������ ���. �������� ���������,\n������� ��� ������� �� �������� ���.\n");
				strcat(strin,"\n"cwhite"- 7) ������: ������ � ������ ������� ��������� ������ ���������,\n������� ��� ������� �� ������ ��������� � ������ �������/�������� ���������������.\n");
				strcat(strin,"\n"cwhite"- 8) ����: ������������� ����� � ���������������� \n��������� �����, ���� ����� ��� ������ � ��� �� ������");
				strcat(strin,"\n���� �� ������ ������ �� ������������� ����� �� �������� ��������������� ��� ���.\n");
				strcat(strin,"\n"cwhite"- 9) ��������: �� ������ ������� �������, �� ������ ��������� �������� � �������");
				strcat(strin,"\n�� �����������, ���� � ��� ���� �������, ������ ������\n���������� � ������������� �������� �������� (warn/kick/ban).\n\n");
				ShowPlayerDialog(playerid,Guiderules2,DIALOG_STYLE_MSGBOX,strin2,strin, "��������","�������");
			}
	        return 1;
		}
	 	if(dialogid == Guiderules2)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	                new string[1200],string2[12];
					format(string2, sizeof(string2), ""cwhite"������� �������");
					format(string, sizeof(string), ""cwhite"- �� ������� ������ ������, �������� �� ����������� � �� ������� ��.\n");
					strcat(string,"\n- 1) �������� (BH): �� ��������� ������������� ����� ��� ��������� ��������,\n������� ��� ������� �� �������� ������/����.\n");
					strcat(string,"\n- 2) ������� (TK): ����� ��������� ("cgreen"�������� "cwhite"or "cpurple"�����"cwhite") ������� ���������, ��� ��� ������\n���� ����� ������ � ����.\n������� ��� ������� �� �������� ���� ��� ������.\n");
					strcat(string,"\n- 3) ����: ��������� ������� � ����, ������� � ����� ����. ������� ������� �� �������� ��� ��� ����.\n");
					strcat(string,"\n- 4) ������������� & ������ ���������: � ��� �� ������������� �����������, ������, ��� ����������� ����� � ����� ���������,\n������� ��� ������� �� �������� ���.\n");
					strcat(string,"\n- 5) �������: �������� ��������� �������� ���������, ������� ��� ������� �� �������� ������ ���.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "����.��������","�������");

	        }
			//ELSE CLOSE!
			return 1;
		}
	 	if(dialogid == Guidedialog)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	            if(listitem == 0)
	            {
	                new string[1000],string2[100];
					format(string2, sizeof(string2), ""cwhite"Server Rules");
					format(string, sizeof(string), ""cwhite"- �� ������� ������ ������, �������� �� ����������� � �� ������� ��.\n");
					strcat(string,"\n- 1) �������� (BH): �� ��������� ������������� ����� ��� ��������� ��������,\n������� ��� ������� �� �������� ������/����.\n");
					strcat(string,"\n- 2) ������� (TK): ����� ��������� ("cgreen"�������� "cwhite"or "cpurple"�����"cwhite") ������� ���������, ��� ��� ������\n���� ����� ������ � ����.\n������� ��� ������� �� �������� ���� ��� ������.\n");
					strcat(string,"\n- 3) ����: ��������� ������� � ����, ������� � ����� ����. ������� ������� �� �������� ��� ��� ����.\n");
					strcat(string,"\n- 4) ������������� & ������ ���������: � ��� �� ������������� �����������, ������, ��� ����������� ����� � ����� ���������,\n������� ��� ������� �� �������� ���.\n");
					strcat(string,"\n- 5) �������: �������� ��������� �������� ���������, ������� ��� ������� �� �������� ������ ���.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "���������","����. ���");

				}
	   			if(listitem == 1)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cpurple"�����");
					format(string, sizeof(string), ""cwhite"- ������ �� ������� ���� �� "cpurple"����� "cwhite"\n");
					strcat(string,"\n- ������ ����� - �������� ���� ��������, �� ����� ����� � ���������� ("cred"������� "cwhite"������� �� �����).\n");
					strcat(string,"\n- ����� �������� ��, ����� �������� �� ��������, ������ "cplat"RMB"cwhite" / ��� / Aim Key,\n����� �� ���������� ������ � ���������.\n");
					strcat(string,"\n- �� �������� +12�� �� ��������, 3 XP �� ������, ������� ����� ���� �� �������� ����� ����.\n");
					strcat(string,"\n- ���� ������ �� ��������� ''�����'', ����� ���� ����������, ������� ������� ���� �������� ��������,\n����� �� "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" ���� ������� ������ ������, � ������ ���������� ��� ����.\n");
					strcat(string,"\n- ������ ���� ����� �������, ���� ����� ��������� ��������� ����� ����� ������������ ��� �����.\n\n");
					ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "���������","����. ���");
	            }
	 			if(listitem == 2)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cgreen"��������");
					format(string, sizeof(string), ""cwhite" - ������ �� ������� ���� �� "cgreen"�������� "cwhite"\n");
					strcat(string,"\n- ����� �� �������� ���� ������ ������ 8 "cred"���������� "cwhite"(���������� � ��������� �����, �������� ������� ��������).\n");
					strcat(string,"\n- ����� ������ �������� ����� ����� � ���� � ����� ����� ���������\n�� �������� ��, ����, ������ "cred"red mark"cwhite", ����� ���������� �� �� �������� +10XP.\n");
					strcat(string,"\n- ����������� "cred"���������� "cwhite"�������� ������, ���� �������� ��������� ����� �����, ����� ����� �� �������� 10 EXP,\n������ � �������� - 1XP. ��������� �������� ���� ���� �� ������ �������!\n");
					strcat(string,"\n- ������� ������ �� �������� ''�����'', ����� ������� ���� � ���������\n����� �� "cred"~k~~CONVERSATION_YES~/Y"cwhite" ����� ������� ������ ������, � ������ ���� ����������.\n");
					ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"���������","����. ���");
	            }
			}
			return 1;
		}
	}/////////////////////////////////////////////////////RUSSIAN///////////////////////////////////////////////////////
	else if(PInfo[playerid][lnaguage] == 3)///////////////////////////////////////////////////SPANISH/////////
	{
		if(dialogid == Guidesurvivor)
	    {
	        new string[650];
	        if(response)
	        {
	        	ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
	        else//if(PInfo[playerid][lnaguage] == 2)
	        {
				strcat(string,"\n- You also access a new weapon after 5 ranks up, (Rank 5, Rank 10... etc), you can select the desired weapon by using the following cmd "cred"/weapons \n"cwhite"and then selecting the name of the gun.\n");
				strcat(string,"\n- Survivors also got inventory to open the inventory you should press "cred"''~k~~CONVERSATION_NO~/[N] "cwhite" KEY\nin the inventory you can fined..Medkits("cred"+HP"cwhite"),Fuel,Oil and etc..\nto get more items you should go to cj's or another house to search for items by pressing "cred"''~k~~PED_DUCK~ /[C]''"cwhite"\n");
				strcat(string,"\n- Each perk has got a duration of cooldown, you must wait sometime upon activating a perk to use another one.\n\n");
				ShowPlayerDialog(playerid,Guidesurvivor2,DIALOG_STYLE_MSGBOX,"Survivor Team Guide Page 2",string,"Previous Page","Close");
			}
			return 1;
		}
		if(dialogid == Guidesurvivor2)
	    {
	        if(response)
	        {
	       		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"Survivor Team");
				format(string, sizeof(string), ""cwhite" - You've just accessed the "cgreen"Survivors "cwhite"Team assistance list.\n");
				strcat(string,"\n- As a survivor, your objective to win the round is to clear all the eight "cred"checkpoints "cwhite"(Randomly placed on the map as red marks in various locations).\n");
				strcat(string,"\n- To clear a checkpoint you must stand inside the red mark for a short period of time to clear it\nyou receive health and ammo upon entering the "cred"red mark"cwhite", after clearing you gain +10 EXP.\n");
				strcat(string,"\n- Clearing these "cred"checkpoints "cwhite"won't be a walk in the park, you will have to pass through zombies, killing a zombie will make you gain 10 EXP,\nassisting on a kill makes you gain 1 EXP. You keep gaining EXP until you rank up.\n");
				strcat(string,"\n- Ranking up grants you extra ''PERKS'', Perks are basically extra skills and abilities that you can use in order to survive\nto access the list of Perk you press "cred"~k~~CONVERSATION_YES~/Y"cwhite" and then you select the desired perk.\n");
				ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Go Back","Next Page");
	        }
	        return 1;
		}
		if(dialogid == Guidezombie)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
			//ELSE CLOSE!
	        return 1;
		}
		if(dialogid == Guiderules)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"GameMode Guide","Rules\nZombie Team\nSurvivor Team", "Read", "Close");
	        }
	        else
	        {
				new strin[1000],strin2[100];
				format(strin2, sizeof(strin2), ""cwhite"Server Rules Page 2");
				format(strin, sizeof(strin), " ");
		 		strcat(strin,"\n"cwhite"- 6) Hacking/Cheats/Mods: Using any kind of Hacks or \nCLEO mods or anything that gives you advantages rather than any normal player is NOT allowed,\nviolating this rule will get you banned from the server.\n");
				strcat(strin,"\n"cwhite"- 7) Suiciding: Suiciding in order to avoid being killed by the other team is NOT allowed,\nviolating this will get you set to the other team or further punishment.\n");
				strcat(strin,"\n"cwhite"- 8) Abusing Bugs: Finding any kind of bug in the script or in the map and abusing it is NOT allowed\nand is NOT tolerated at all, if you find a bug you report it on forum");
				strcat(strin,"\nif you ever get caught abusing any bug you will get warned or might get banned from the community.\n");
				strcat(strin,"\n"cwhite"- 9) Respect Administrators: Respecting administrators is a MUST, their duty is to keep your gameplay");
				strcat(strin,"\nfun with no cheaters or hackers, if you ever had a question, do not hesitate and ask it\ndisrespecting admins might result a bad punishment (warn/kick/ban).\n\n");
				ShowPlayerDialog(playerid,Guiderules2,DIALOG_STYLE_MSGBOX,strin2,strin, "Previous Page","Close");
			}
	        return 1;
		}
	 	if(dialogid == Guiderules2)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	                new string[1200],string2[12];
					format(string2, sizeof(string2), ""cwhite"Server Rules");
					format(string, sizeof(string), ""cwhite"- You've just accessed the Server Rules list, read them carefully and avoid breaking them.\n");
					strcat(string,"\n- 1) Bunny Hoping (BH): As a survivor (Most likely), you are NOT allowed to spam jumping while running in order to gain speed,\nviolating this rule gets you slapped/warned or further punishment.\n");
					strcat(string,"\n- 2) TeamKilling (TK): You aren't allowed as AT ALL ("cgreen"Survivors "cwhite"or "cpurple"Zombies"cwhite") to kill your teammates, it's a Team Deathmatch (TDM) server\nyou team up with your teammates and kill the other team.\nViolating this rule gets you slapped/warned or further punshiment.\n");
					strcat(string,"\n- 3) Spamming the Chat: You aren't allowed AT ALL to spam the chat, whether public chat or team chat. Violating this rule gets you muted from speaking.\n");
					strcat(string,"\n- 4) Discrimination & Bad Conduct: We do not tolerate any offensive words, racist, or sexist or any jokes about religions in our community,\nviolating this rule might get you banned from the whole community.\n");
					strcat(string,"\n- 5) Advertising for another server: Advertising for another server is NOT allowed and is NOT tolerated, violating this will get you perma-ban from the server.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Next Page");

	        }
			//ELSE CLOSE!
			return 1;
		}
	 	if(dialogid == Guidedialog)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	            if(listitem == 0)
	            {
	                new string[1000],string2[100];
					format(string2, sizeof(string2), ""cwhite"Server Rules");
					format(string, sizeof(string), ""cwhite"- You've just accessed the Server Rules list, read them carefully and avoid breaking them.\n");
					strcat(string,"\n- 1) Bunny Hoping (BH): As a survivor (Most likely), you are NOT allowed to spam jumping while running in order to gain speed,\nviolating this rule gets you slapped/warned or further punishment.\n");
					strcat(string,"\n- 2) TeamKilling (TK): You aren't allowed as AT ALL ("cgreen"Survivors "cwhite"or "cpurple"Zombies"cwhite") to kill your teammates, it's a Team Deathmatch (TDM) server\nyou team up with your teammates and kill the other team.\nViolating this rule gets you slapped/warned or further punshiment.\n");
					strcat(string,"\n- 3) Spamming the Chat: You aren't allowed AT ALL to spam the chat, whether public chat or team chat. Violating this rule gets you muted from speaking.\n");
					strcat(string,"\n- 4) Discrimination & Bad Conduct: We do not tolerate any offensive words, racist, or sexist or any jokes about religions in our community,\nviolating this rule might get you banned from the whole community.\n");
					strcat(string,"\n- 5) Advertising for another server: Advertising for another server is NOT allowed and is NOT tolerated, violating this will get you perma-ban from the server.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Next Page");

				}
	   			if(listitem == 1)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cpurple"Zombie Team");
					format(string, sizeof(string), ""cwhite"- You've just accessed the "cpurple"Zombies "cwhite"Team assistance list.\n");
					strcat(string,"\n- As a zombie, your objective to win the round is to infect every survivor alive, you'll mostly find them in checkpoints ("cred"Red "cwhite"marks on map).\n");
					strcat(string,"\n- In order to infect a survivor, you need to bite them to death, in order to bite you SPAM the "cplat"RMB"cwhite" / Right-Click / Aim Key,\nwhen you're close enough to a survivor.\n");
					strcat(string,"\n- You gain 12 EXP upon infecting a survivor, 3 EXP for assisting infection, you keep gaining EXP until you rank up.\n");
					strcat(string,"\n- Ranking up grants you new ''PERKS'', Perks allow you to have extra skills and abilities that help you for infections,\nto access the ''PERKS'' list, you press on "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" and then select the perk.\n");
					strcat(string,"\n- Each perk has got a duration of cooldown, you must wait sometime upon activating a perk to use another one.\n\n");
					ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "Go Back","Close");
	            }
	 			if(listitem == 2)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cgreen"Survivor Team");
					format(string, sizeof(string), ""cwhite" - You've just accessed the "cgreen"Survivors "cwhite"Team assistance list.\n");
					strcat(string,"\n- As a survivor, your objective to win the round is to clear all the eight "cred"checkpoints \n"cwhite"(Randomly placed on the map as red marks in various locations).\n");
					strcat(string,"\n- To clear a checkpoint you must stand inside the red mark for a short period of time to clear it\nyou receive health and ammo upon entering the "cred"red mark"cwhite", after clearing you gain +10 EXP.\n");
					strcat(string,"\n- Clearing these "cred"checkpoints "cwhite"won't be a walk in the park, you will have to pass through zombies\nkilling a zombie will make you gain "cplat"EXP,\nassisting on a kill makes you gain 1 EXP. You keep gaining EXP until you rank up.\n");
					strcat(string,"\n- Ranking up grants you extra ''PERKS'', Perks are basically extra skills and abilities that you can use in order to survive\nto access the list of Perk you press "cred"~k~~CONVERSATION_YES~/[Y]"cwhite" and then you select the desired perk.\n\n");
					ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Go Back","Next Page");
	            }
			}
			return 1;
		}
	}///////////////////////////////SPANISH//////////////////////SPANISH/////////////SPANISH///////////
	
	
	
	
	
	
	
/* copy this "(down)vvv" to this (UP)^^^^^^^^^^^^^^^^
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
	
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
//////////vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv////////////////
	/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
//////////////////////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////
/////////////////////////////////////////////////////////////////// RUSSIAN TRASLATE BY ZACKSTER//////////////////////////////

*/
CMD:pomosh(playerid, params[])
{
 	ShowPlayerDialog(playerid,GuidedialogRU,DIALOG_STYLE_LIST,"���� �� ������","������� ����\n����������� ��� �����\n����������� ��� ���������", "������", "�������");
	return 1;
}

	if(dialogid == GuidedialogRU)
    {
        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
        {
            if(listitem == 0)
            {

          		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cwhite"������� �������");
				format(string, sizeof(string), ""cwhite"- �� ������ ��� �������� ������ � ������ ������ �������, ������� ����������� ��������� �� � �� �������� � ����������.\n");
				strcat(string,"\n- 1) Bunny Hopping (BH): ����� �� ��������, ��� �� ����������� ������������ BHOP (��������� / ��������� �������� ������ ������), ���������� ���� ��������, \n ������� ������� ��� ������� �� �������� ������ / �������������� ��� � ������� ������ ���.\n");
				strcat(string,"\n- 2) TeamKilling (TK): ��� �� ��������� ������� ����� ��������� ( "cgreen" �������� "cwhite" ��� "cpurple" ����� "cwhite"), ��� �������� Team Deathmatch (TDM) �������, ���� ������� ������ - �������� ������ � �������� ����������. \n� ������ �������� ������ �������� ��� ���� ������ / �������������� ��� � ������� ������ ���.\n");
				strcat(string,"\n- 3) ���� ��� ����: ��� ��������� ������� � ����, ���� �� ��������� ��� ��� ��� �������. ������� ��� ������� �� �������� ���, ������������ ���� ������� �� �������������.\n");
				strcat(string,"\n- 4) ������������� � ������������ ���������: �� �� �������� ������� �������������� ����, ���������� ��� ����������� ��� ����� ����� � ������� � ����� ���������, \n������� ��� ������� �� �������� ���������� ��� ��� �����������, � ����������� �� ������� ���������.\n");
				strcat(string,"\n- 5) ������� ����� ��������: ������� ������ ��������, ����� � ������ ��������� ��������, �� ����������� � ����� �������, ���������, ������� ��� ������� ��� ���� ������ ���.\n");
				strcat(string,"\n- 6) ���� / �����������: ��������� ������������� ����� ����� �����, ��������� CLEO ������� ��� ��������� �����������, ������� ���� ��� ������������ � ����, \n ������� ��� ������� ��� ����� ����� ���.\n");
				strcat(string,"\n- 7) ������������: ������������ ��������� �.�. ��� ����� �������� �� ��������� � ������� ���������, \n������� �������, �� ������ ���������� � ������� ����������, ��� ����� ��������� ���������, ���� ������ ��������� ��� �����.\n");
				strcat(string,"\n- 8) ������������� �����: ����������� ������ - ���� ����, ������ � ���� ��� �� ����� �������� �� ��� �� ������, ��������������� �����  ������ � �.�. �������� ��������������� \ �����.");
				strcat(string,"\n- 9) �������� �������������: �������� �������������, �� ������� ����������� - ��������� ��� �������� �������, ��� ������� � ������ �������, ���� � ��� ���� �������, �� ����������� � ��������, �� �������� ������������� ����� �������� � ��������� (�������������� / ��� ).\n\n");
				ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "�������","���������");
			}
   			if(listitem == 1)
            {
            	new string[1000],string2[100];
				format(string2, sizeof(string2), ""cpurple"����� �����");
				format(string, sizeof(string), ""cwhite"- �� ������� ������ � "cpurple"����� "cwhite"������ ������.\n");
				strcat(string,"\n- ����� �� ����� ���� ������� ������ �������� ���� ��������, ���� ����� �� ������ �������� �� �� ����������� ������ ("cred"Red "cwhite"������� ������ �� ������).\n");
				strcat(string,"\n- ����� �������� ����� ���� �������� �� �� ������, ����� ������ �������� "cplat"RMB"cwhite" / ������ ������ ���� / ������ ������������,\n������� �������� �����, ����� �� ���������� ����� ������ � ��������.\n");
				strcat(string,"\n- �� ��������� 15 ����� �� ��������� ��������, 4 ����� �� ������, ��������� ���� �� ��� ���, ���� �� �� ���������� � ������ .\n");
				strcat(string,"\n- ������� ������� �� ��������� ��������� ����������� - ''�����'', ����� ����� ������� � ��� � �������: ������� ����, ����, ��� �������� ������� �������� ��������,\nto ����� ����� � ������ ''������'' ������� "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" ����� ��������� ������ ��� ����.\n");
				strcat(string,"\n- � ������� ����� ���� ���� �������, ��� ����� ��������� ��������� ����� ����� ������������ ���� ������.\n\n");
				ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "�������","���������");
            }
 			if(listitem == 2)
            {
            	new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"����� ����");
				format(string, sizeof(string), ""cwhite" - �� ������� ������ � "cgreen"�������� "cwhite"������ ������.\n");
				strcat(string,"\n- ������� ������ �������� - ������ ��� ������ "cred"����������� ����� "cwhite"(��������������� � ��������� ����� �� �����, ���������� ������� �������� �� ������!).\n");
				strcat(string,"\n- ����� ������ ����������� �����, ����� �������� ��� ��������� ���������� �������, ����� � "cred"������� ������"cwhite" �� �������� ��������� � ���. ������, ����� ��������� ����������� ����������� ����� �� �������� +10 �����.\n");
				strcat(string,"\n- ����������� "cred"����������� ����� "cwhite"�� ����� ������ �������, ��� �������� ��������� ����� ���� �����, ������ ����� �� ��������� +8 �����,\n������ � �������� ��� ������ +2 �����. ��������� ���� �� ��� �� ���� �� �� ���������� � ������.\n");
				strcat(string,"\n- ��� � � ����� �� ������ ���������� ������� �� ��������� ����� ����������� ''�����'', ����� � �������� - ��� �������������� ������ � �����������, ����� ����� � ������ ������ ������� "cred"~k~~CONVERSATION_YES~/Y"cwhite" � �������� ������ ����.\n");
				strcat(string,"\n- �� ������ 5-�� �������� ������� ��� ������ ������, ������ �����������, (��. 5, ��. 10... � �.�.), �� ������ ������� ������ ������, ������� "cred"/weapons "cwhite".\n");
				strcat(string,"\n- ����� ���� ����� ���� ����������� ���������, �������"cred"''~k~~CONVERSATION_NO~/N "cwhite" ����� ������� ���, � ��������� ������ ����� ������..�������,������,����� � �.�.,\nto ���� � ��� ���� ��������, �� �� ������ ������ ���������� ����, �������� � ���� CJ'� �� ����� ����� ����� ����� ������ "cred"''~k~~PED_DUCK~ /C''"cwhite", ����� ������ �����\n");
				strcat(string,"\n- � ������� ����� ���� ���� �������, ��� ����� ��������� ��������� ����� ����� ������������ ���� ������.\n\n");
				ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string,"�������","���������");
            }
		}
	}





