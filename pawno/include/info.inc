#include <a_samp>
new Text:info;


info = TextDrawCreate(10.000000, 120.000000, " ");
TextDrawBackgroundColor(info, 255);
TextDrawFont(info, 1);
TextDrawLetterSize(info, 0.500000, 1.700000);
TextDrawColor(info, -1);
TextDrawSetOutline(info, 0);
TextDrawSetProportional(info, 1);
TextDrawSetShadow(info, 1);
TextDrawUseBox(info, 1);
TextDrawBoxColor(info, 255);
TextDrawTextSize(info, 253.000000, 0.000000);


stock ShowInfo(playerid, text[])
{
TextDrawHideForPlayer(playerid, info);
new string[155];
format(string, sizeof(string), "%s", text);
TextDrawSetString(Text:info, string);
TextDrawShowForPlayer(playerid, info);
SetTimerEx("HM", 5000, 0, "i, i", playerid, _:info);

return 1;
}
forward HM(playerid, Text:TextIdent);
public HM(playerid, Text:TextIdent)
{
TextDrawHideForPlayer(playerid, TextIdent);
return 1;
}
