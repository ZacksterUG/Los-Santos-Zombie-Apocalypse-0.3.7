#include <a_samp>

#if !defined MAX_MESSAGES
   #define MAX_MESSAGES 50
#endif

enum MessageInfo
{
	textmsg[64],
	colormsg[12]
}
new Messages[MAX_MESSAGES][MessageInfo];
new CurrentMessageID;
new TimerAlreadyActivated;
forward SendAutoMessage();

stock AddRandomMessage(Msgcolor,Msgtext[])
{
	format(Messages[CurrentMessageID][textmsg],64,"%s",Msgtext);
	Messages[CurrentMessageID][colormsg] = Msgcolor;
	CurrentMessageID++;
	if(TimerAlreadyActivated == 0)
	{
		#if defined MESSAGE_DELAY
		SetTimer("SendAutoMessage",MESSAGE_DELAY*1000);
		#else		
		SetTimer("SendAutoMessage",60000,true);
		#endif
		TimerAlreadyActivated = 1;
	}
	return 1;
}

public SendAutoMessage()
{	
	new randmsg = random(CurrentMessageID);
	SendClientMessageToAll(Messages[randmsg][colormsg],Messages[randmsg][textmsg]);
	return 1;
}