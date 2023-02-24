#include <a_samp>


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/commandtogetanim", cmdtext) == 0)
	{
        new animlib[32];
        new animname[32];
        new msg[128];
        GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
        format(msg, 128, "Running anim: %s %s", animlib, animname);
        SendClientMessage(playerid, 0xFFFFFFFF, msg);
        SetPVarInt(playerid,"GettingAnim",1);
		return 1;
	}
	if(strcmp("/stopgettinganim",cmdtext) == 0)
	{
        SetPVarInt(playerid,"GettingAnim",0);
		return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(GetPVarInt(playerid,"GettingAnim") == 1)
	{
	    new animlib[32];
	    new animname[32];
	    new msg[128];
	    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
	    format(msg, 128, "Running anim: %s %s", animlib, animname);
	    SendClientMessage(playerid, 0xFFFFFFFF, msg);
 	}
	return 1;
}
