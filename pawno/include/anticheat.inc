#define ResetMoneyBar ResetPlayerMoney
#define UpdateMoneyBar GivePlayerMoney

new Cash[MAX_PLAYERS];

stock GivePlayerCash(playerid, money)
{
    Cash[playerid] += money;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock SetPlayerCash(playerid, money)
{
    Cash[playerid] = money;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock ResetPlayerCash(playerid)
{
    Cash[playerid] = 0;
    ResetMoneyBar(playerid);//Resets the money in the original moneybar, Do not remove!
    UpdateMoneyBar(playerid,Cash[playerid]);//Sets the money in the moneybar to the serverside cash, Do not remove!
    return Cash[playerid];
}
stock GetPlayerCash(playerid)
{
    return Cash[playerid];
}

