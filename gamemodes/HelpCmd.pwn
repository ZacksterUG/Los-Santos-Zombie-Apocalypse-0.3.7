


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
	        	ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Путеводитель по игре","Правила\nЗомби\nВыживший", "Прочитать", "Заакрыть");
	        }
	        else//if(PInfo[playerid][lnaguage] == 2)
	        {
				strcat(string,"\n- Ты получаешь новое оружие каждые 5 рангов, (Ранг 5, Ранг 10... итд), Ты можешь выбрать доступные оружия введя команду "cred"/weapons \n"cwhite"в списке выберите подоходящее для вас оружие.\n");
				strcat(string,"\n- Выжившие имеют инвентарь "cred"''~k~~CONVERSATION_NO~/[N] "cwhite" KEY\nв инвентаре ты можешь найти..Аптечку("cred"+HP"cwhite"),Бензин,Масло итд..\nты можешь поискать новые предметы в открытых домах "cred"''~k~~PED_DUCK~ /[C]''"cwhite"\n");
				strcat(string,"\n- Каждый перк имеет кулдаун, ты можешь использовать другой перк пока ждешь окнчание кулдауна.\n\n");
				ShowPlayerDialog(playerid,Guidesurvivor2,DIALOG_STYLE_MSGBOX,"Гайд по выжившим 2-стр",string,"Предыдущая страница","Закрыть");
			}
			return 1;
		}
		if(dialogid == Guidesurvivor2)
	    {
	        if(response)
	        {
	       		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"Выживший");
				format(string, sizeof(string), ""cwhite" - Сейчас ты читаешь гайд по "cgreen"Выжившим "cwhite".\n");
				strcat(string,"\n- Играя за выживших твоя задача пройти 8 "cred"чекпоинтов "cwhite"(появляются в случайном месте, отмечены красным маркером).\n");
				strcat(string,"\n- Чтобы пройти чекпоинт нужно зайти в него и ждать когда окончится\nты получишь Хп, опыт, оружие "cred"red mark"cwhite", полсе кокончания ЧП ты получишь +10XP.\n");
				strcat(string,"\n- Прохождение "cred"чекпоинтов "cwhite"нелегкая задача, тебе придется проходить через зомби, убива зомби ты получишь 10 EXP,\nпомощь в убийстве - 1XP. Продолжай получать опыт пока не апнешь уровень!\n");
				strcat(string,"\n- Повышая уровни ты получишь ''ПЕРКИ'', Перки помогут тебе в выживании\nнажми на "cred"~k~~CONVERSATION_YES~/Y"cwhite" чтобы открыть список перков, и выбери себе подходящий.\n");
				ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Вернуться","След. стр");
	        }
	        return 1;
		}
		if(dialogid == Guidezombie)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Путеводитель по игре","Правила\nЗомби\nВыживший", "Прочитать", "Заакрыть");
	        }
			//ELSE CLOSE!
	        return 1;
		}
		if(dialogid == Guiderules)
	    {
	        if(response)
	        {
				ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Путеводитель по игре","Правила\nЗомби\nВыживший", "Прочитать", "Заакрыть");
	        }
	        else
	        {
				new strin[1000],strin2[100];
				format(strin2, sizeof(strin2), ""cwhite"Server Rules Page 2");
				format(strin, sizeof(strin), " ");
		 		strcat(strin,"\n"cwhite"- 6) Читы/моды: Использование любых видов читов \nCLEO моды и другие чит. программ запрещены,\nнарушив это правило ты получишь бан.\n");
				strcat(strin,"\n"cwhite"- 7) Суицид: Суицид и другие способы избежания смерти запрещены,\nнарушив это правило ты будешь перенесен в другую команду/получишь предупрежедение.\n");
				strcat(strin,"\n"cwhite"- 8) Баги: использование багов и злоупотребеление \nзапрещены вовсе, если нашел баг напиши о нем на форуме");
				strcat(strin,"\nесли ты будешь пойман на использовании багов ты полусишь предупрежедение или бан.\n");
				strcat(strin,"\n"cwhite"- 9) Уважение: Ты обязан УВАЖАТЬ админов, их задача содержать геймплей в чистоте");
				strcat(strin,"\nот нарушителей, если у вас есть вопросы, просто спроси\nнеуважение к администрации серьезно карается (warn/kick/ban).\n\n");
				ShowPlayerDialog(playerid,Guiderules2,DIALOG_STYLE_MSGBOX,strin2,strin, "Вернутся","Закрыть");
			}
	        return 1;
		}
	 	if(dialogid == Guiderules2)
	    {
	        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
	        {
	                new string[1200],string2[12];
					format(string2, sizeof(string2), ""cwhite"Правила сервера");
					format(string, sizeof(string), ""cwhite"- Ты читаешь список правил, прочитай их внимательно и не нарушай их.\n");
					strcat(string,"\n- 1) Баннихоп (BH): Не разрешено использование Бхопа для ускорения движения,\nнарушив это правило ты получишь шлепок/варн.\n");
					strcat(string,"\n- 2) ТимКилл (TK): Вовсе запрещено ("cgreen"Выживший "cwhite"or "cpurple"Зомби"cwhite") убивать тиммейтов, это ТДМ сервер\nтебе нужно сообща с ними.\nНарушив это правило ты получишь варн или шлепок.\n");
					strcat(string,"\n- 3) Спам: Запрещено спамить в чате, неважно в каком чате. Нарушив правило ты получишь мут или варн.\n");
					strcat(string,"\n- 4) Дискриминация & Плохое поведение: у нас не преветсвуются оскорбления, расизм, или сексистские шутки в нашем комьюнити,\nнарушив это правило ты получишь бан.\n");
					strcat(string,"\n- 5) Реклама: Рекалама сторонних ресурсов ЗАПРЕЩЕНА, нарушив это правило ты получишь вечный бан.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "След.страница","Закрыть");

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
					format(string, sizeof(string), ""cwhite"- Ты читаешь список правил, прочитай их внимательно и не нарушай их.\n");
					strcat(string,"\n- 1) Баннихоп (BH): Не разрешено использование Бхопа для ускорения движения,\nнарушив это правило ты получишь шлепок/варн.\n");
					strcat(string,"\n- 2) ТимКилл (TK): Вовсе запрещено ("cgreen"Выживший "cwhite"or "cpurple"Зомби"cwhite") убивать тиммейтов, это ТДМ сервер\nтебе нужно сообща с ними.\nНарушив это правило ты получишь варн или шлепок.\n");
					strcat(string,"\n- 3) Спам: Запрещено спамить в чате, неважно в каком чате. Нарушив правило ты получишь мут или варн.\n");
					strcat(string,"\n- 4) Дискриминация & Плохое поведение: у нас не преветсвуются оскорбления, расизм, или сексистские шутки в нашем комьюнити,\nнарушив это правило ты получишь бан.\n");
					strcat(string,"\n- 5) Реклама: Рекалама сторонних ресурсов ЗАПРЕЩЕНА, нарушив это правило ты получишь вечный бан.\n");
					ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Вернуться","След. стр");

				}
	   			if(listitem == 1)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cpurple"Зомби");
					format(string, sizeof(string), ""cwhite"- Сейчас ты читаешь гайд по "cpurple"Зомби "cwhite"\n");
					strcat(string,"\n- Задача зомби - заразить всех выживших, их можно найти в чекпоинтах ("cred"Красные "cwhite"маркеры на карте).\n");
					strcat(string,"\n- Чтобы заразить их, нужно искусать их досмерти, кликай "cplat"RMB"cwhite" / ПКМ / Aim Key,\nкогда ты достаточно близок к выжившему.\n");
					strcat(string,"\n- Ты получишь +12ХР за убийство, 3 XP за помощь, заражай людей пока не получишь новый ранг.\n");
					strcat(string,"\n- Апая уроень ты получаешь ''ПЕРКИ'', Перки дают спсобности, которые помогут тебе заразить человека,\nнажми на "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" чтбы открыть список перков, и выбери подходящий для тебя.\n");
					strcat(string,"\n- Каждый перк имеет кулдаун, тебе нужно подождать некоторое время чтобы использовать его сново.\n\n");
					ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "Вернуться","След. стр");
	            }
	 			if(listitem == 2)
	            {
	            	new string[1000],string2[100];
					format(string2, sizeof(string2), ""cgreen"Выживший");
					format(string, sizeof(string), ""cwhite" - Сейчас ты читаешь гайд по "cgreen"Выжившим "cwhite"\n");
					strcat(string,"\n- Играя за выживших твоя задача пройти 8 "cred"чекпоинтов "cwhite"(появляются в случайном месте, отмечены красным маркером).\n");
					strcat(string,"\n- Чтобы пройти чекпоинт нужно зайти в него и ждать когда окончится\nты получишь Хп, опыт, оружие "cred"red mark"cwhite", полсе кокончания ЧП ты получишь +10XP.\n");
					strcat(string,"\n- Прохождение "cred"чекпоинтов "cwhite"нелегкая задача, тебе придется проходить через зомби, убива зомби ты получишь 10 EXP,\nпомощь в убийстве - 1XP. Продолжай получать опыт пока не апнешь уровень!\n");
					strcat(string,"\n- Повышая уровни ты получишь ''ПЕРКИ'', Перки помогут тебе в выживании\nнажми на "cred"~k~~CONVERSATION_YES~/Y"cwhite" чтобы открыть список перков, и выбери себе подходящий.\n");
					ShowPlayerDialog(playerid,Guidesurvivor,DIALOG_STYLE_MSGBOX,string2,string,"Вернуться","След. стр");
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
 	ShowPlayerDialog(playerid,GuidedialogRU,DIALOG_STYLE_LIST,"Гайд по режиму","Правила игры\nРуководство для Зомби\nРуководство для Выжившиех", "Читать", "Закрыть");
	return 1;
}

	if(dialogid == GuidedialogRU)
    {
        if(response)//ShowPlayerDialog(playerid,Guidedialog,DIALOG_STYLE_LIST,"Game Mode Guide","Rulse\nZombie Team\nSurvivor Team", "Read", "Close");
        {
            if(listitem == 0)
            {

          		new string[1000],string2[100];
				format(string2, sizeof(string2), ""cwhite"Правила сервера");
				format(string, sizeof(string), ""cwhite"- Вы только что получили доступ к списку правил сервера, следует внимательно прочитать их и не нарушать в дальнейшем.\n");
				strcat(string,"\n- 1) Bunny Hopping (BH): Играя за выживших, вам не разрешается использовать BHOP (распрыжка / цикличное кликание кнопки прыжка), увиличивая свою скорость, \n Впервые нарушив это правило ты получишь шлепок / предупреждение или в крайнем случае бан.\n");
				strcat(string,"\n- 2) TeamKilling (TK): Вам не разрешено убивать своих тиммейтов ( "cgreen" выживших "cwhite" или "cpurple" зомби "cwhite"), мод является Team Deathmatch (TDM) режимом, ваша главная задача - работать сообща и выйграть соперников. \nВ случае убийства своего товарища вас ждет шлепок / предупреждение или в крайнем случае бан.\n");
				strcat(string,"\n- 3) Флуд или спам: Вам запрещено флудить в чате, будь то публичный чат или чат команды. Нарушив это правило вы получите мут, длительность мута зависит от администрации.\n");
				strcat(string,"\n- 4) Дискриминация и неадыкватное поведение: Мы не потерпим никаких оскорбительных слов, расистские или сексистские или любые шутки о религии в нашем комьюнити, \nнарушив это правило вы получите длительный бан или перманентый, в зависимости от степени нарушения.\n");
				strcat(string,"\n- 5) Реклама чужих проектов: Реклама других серверов, читов и других сторонних ресурсов, не относящиеся к этому серверу, запрещена, нарушив это правило вас ждет вечный бан.\n");
				strcat(string,"\n- 6) Читы / Модификации: Запрещено использование любых видов читов, читерские CLEO скрипты или читерские модификации, которые дают вам преимущество в игре, \n нарушив это правило вас будет ждать бан.\n");
				strcat(string,"\n- 7) Самоубийство: самоубийство запрещено т.к. это будет нечестно по отношение к команде соперника, \nнарушив правило, вы будете перемещены в команду противника, или более серьезное наказание, если будете повторять это часто.\n");
				strcat(string,"\n- 8) Использование багов: Обнаружение какого - либо бага, ошибки в игре или на карте сообщите об это на форуме, злоупотребление багов  ошибок и т.д. карается предупреждением \ баном.");
				strcat(string,"\n- 9) Уважайте Администрацию: Уважайте администрацию, их главная обязанность - сохранить ваш геймплей веселым, без читеров и прочей нечести, если у вас есть вопросы, не стесняйтесь и спросите, не уважение администрации может привести к наказанию (предупреждение / бан ).\n\n");
				ShowPlayerDialog(playerid,Guiderules,DIALOG_STYLE_MSGBOX,string2,string, "Закрыть","Вернуться");
			}
   			if(listitem == 1)
            {
            	new string[1000],string2[100];
				format(string2, sizeof(string2), ""cpurple"Класс Зомби");
				format(string, sizeof(string), ""cwhite"- Вы читаете мануал о "cpurple"Зомби "cwhite"Список помощи.\n");
				strcat(string,"\n- Играя за зомби ваша главная задача заразить всех выживших, чаще всего ты можешь стретить их на Контрольных Точках ("cred"Red "cwhite"красный маркер на радаре).\n");
				strcat(string,"\n- Чтобы заразить людей надо искусать их до смерти, чтобы кусать кликайте "cplat"RMB"cwhite" / Правая кнопка мыши / Кнопка прицеливания,\nКусайте выживших тогда, когда вы находитесь очень близко к человеку.\n");
				strcat(string,"\n- Ты получаешь 15 опыта за заражение человека, 4 опыта за помощь, получайте опыт до тех пор, пока вы не повыситесь в уровне .\n");
				strcat(string,"\n- Повышая уровень вы получаете необычные способности - ''ПЕРКИ'', Перки очень полезны в бою к примеру: сильный укус, крик, они помогают быстрее заразить человека,\nto Чтобы войти в список ''ПЕРКОВ'' нажмите "cplat"~k~~CONVERSATION_YES~ /Y"cwhite" далее выбирайте нужный вам перк.\n");
				strcat(string,"\n- У каждого перка есть свой кулдаун, вам нужно подождать некоторое время чтобы использовать перк заново.\n\n");
				ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string, "Закрыть","Вернуться");
            }
 			if(listitem == 2)
            {
            	new string[1000],string2[100];
				format(string2, sizeof(string2), ""cgreen"Класс Выжи");
				format(string, sizeof(string), ""cwhite" - Вы читаете мануал о "cgreen"Выживших "cwhite"Список помощи.\n");
				strcat(string,"\n- Главная задача выживших - пройти все восемь "cred"Контрольных точек "cwhite"(устанавливаются в случайном месте на карте, обозначена красным маркером на радаре!).\n");
				strcat(string,"\n- Чтобы пройти контрольную точку, нужно постоять там некоторый промежуток времени, войдя в "cred"красный кружок"cwhite" вы получите аммуницию и мед. помощь, после окончания прохождения контрольной точки вы получите +10 опыта.\n");
				strcat(string,"\n- Прохождение "cred"Контрольных точек "cwhite"не будет легкой задачей, вам придется проходить через орды зомби, убивая зомби вы получаете +8 опыта,\nпомощь в убийстве вам дается +2 опыта. Получайте опыт до тех пр пока вы не повыситесь в уровне.\n");
				strcat(string,"\n- Как и у зомби за каждый полученный уровень вы получаете новые способности ''ПЕРКИ'', Перки в основном - это дополнительные навыки и спосообнсти, чтобы войти в список ПЕРКОВ нажмите "cred"~k~~CONVERSATION_YES~/Y"cwhite" и выберите нужный перк.\n");
				strcat(string,"\n- За каждый 5-ый поднятый уровень вам дается оружие, мощнее предыдущего, (ур. 5, ур. 10... и т.д.), вы можете выбрать нужное урожие, написав "cred"/weapons "cwhite".\n");
				strcat(string,"\n- Также люди имеют свой собственный инвентарь, нажмите"cred"''~k~~CONVERSATION_NO~/N "cwhite" чтобы открыть его, в инвентаре всегда будут лежать..Аптечки,Бензин,Масло и т.п.,\nto если у вас мало припасов, то вы всегда можете обыскивать дома, например в доме CJ'я на кухне возле полки можно нажать "cred"''~k~~PED_DUCK~ /C''"cwhite", чтобы начать обыск\n");
				strcat(string,"\n- У каждого перка есть свой кулдаун, вам нужно подождать некоторое время чтобы использовать перк заново.\n\n");
				ShowPlayerDialog(playerid,Guidezombie,DIALOG_STYLE_MSGBOX,string2,string,"Закрыть","Вернуться");
            }
		}
	}





