public OnPlayerStateChange(playerid,newstate,oldstate)
{
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
	
	
	
	
	
	
	
	
	
 ////////////////////////////COMMANDS
 
 
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
