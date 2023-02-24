#include <a_samp>
#include <zcmd>
#include <sscanf2>

#define COLOR_GREY 	0xAFAFAFAA
#define COLOR_RCON          0x3399FFAA
#define ANIM_LIMIT          1200

CMD:anim(playerid,params[])
{
	new string[128];
	new lib[36],name[36];
	if(sscanf(params,"s[36]S()[36]",lib,name))
	{
	    SendClientMessage(playerid,COLOR_GREY,"USAGE: /anim library[] name[]");
	    SendClientMessage(playerid,COLOR_GREY,"USAGE: /anim index ");
       	    return 1;
	}
	if(IsNumeric(lib))
	{
	    new num = strval(lib);
	    new check = GetAnimationName(num,lib,sizeof(lib),name,sizeof(name));
	    if(!check)
	    {
	        SendClientMessage(playerid,COLOR_RCON,"Invalid animation index");
	        return 1;
	    }
	    format(string,sizeof(string),"[ %d ] %s %s",num,lib,name);
	    SendClientMessage(playerid,COLOR_RCON,string);
	    ApplyAnimation(playerid,lib,name,4.1,0,0,0,0,0,1);
	    format(string,sizeof(string),"~r~anim %d",num);
	    GameTextForPlayer(playerid,string,2000,1);
	    return 1;
	}
	new len = strlen(lib);
	new library[36],animname[36];
	new count,check,repeat[36] = "null";
	for(new i = 0; i < ANIM_LIMIT;i++)
	{
	    check = GetAnimationName(i,library,sizeof(library),animname,sizeof(animname));
	    if(!check) continue;
	    if(!strcmp(lib,library,true,len))
	    {
		if(strcmp(repeat,library,true) != 0)
		{
		     format(string,sizeof(string),"[ %d ] %s",i,library);
		     if(isnull(name))
		     {
		        	SendClientMessage(playerid,COLOR_GREY,string);
		     }
		     strmid(repeat,library,0,strlen(library),sizeof(repeat));
		     count++;
		}
	     }
	}
	if(count > 1)
	{
	     format(string,sizeof(string),"%d library matches found",count);
	     SendClientMessage(playerid,COLOR_RCON,string);
	     return 1;
	}
	if(isnull(name))
	{
	     count = 0;
	     for(new i = 0; i < ANIM_LIMIT;i++)
	     {
		GetAnimationName(i,library,sizeof(library),animname,sizeof(animname));
		if(!strcmp(repeat,library,true))
		{
	            format(string,sizeof(string),"[ %d ] %s %s",i,library,animname);
	            SendClientMessage(playerid,COLOR_GREY,string);
	            count++;
		}
	     }
	     format(string,sizeof(string),"%d animation name matches for %s",count,repeat);
	     SendClientMessage(playerid,COLOR_RCON,string);
	     return 1;
	}
	len = strlen(name);
	count = 0;
	new final = -1;
	for(new i = 0; i < ANIM_LIMIT;i++)
	{
	    GetAnimationName(i,library,sizeof(library),animname,sizeof(animname));
	    if(!strcmp(repeat,library,true))
	    {
	        if(!strcmp(name,animname,true,len))
	        {
	            format(string,sizeof(string),"[ %d ] %s %s",i,library,animname);
	            SendClientMessage(playerid,COLOR_GREY,string);
	            final = i;
	            count++;
		}
	     }
	}
	if(count > 1 && final >= 0)
	{
		format(string,sizeof(string),"%d animation name matches found for %s %s",count,repeat,name);
		SendClientMessage(playerid,COLOR_RCON,string);
		return 1;
	}
	GetAnimationName(final,library,sizeof(library),animname,sizeof(animname));
	ApplyAnimation(playerid,library,animname,4.1,0,0,0,0,0,1);
	format(string,sizeof(string),"~r~anim %d",final);
	GameTextForPlayer(playerid,string,2000,1);

	return 1;
}

stock IsNumeric(const string[])
{
	for(new i = 0, j = strlen(string); i < j; i++)
	{
		if(string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}
