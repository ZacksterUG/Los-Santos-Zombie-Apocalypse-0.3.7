// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

new HUNTER;

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("my filterscript");
	ConnectNPC("SGT_Soap","npc");
	HUNTER = CreateVehicle(425, 1323.0, 500.0, 5.0, 0.0, 0, 0, 0);
}

public OnFilterScriptExit()
{
	return 1;
}
#endif

main(){}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) //Проверяет: существует ли игрок(NPC).
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //Получает имя игрока (NPC).
        if(!strcmp(npcname, "SGT_Soap", true)) //Проверяет если имя MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, HUNTER, 0); //Помещает NPC в транспорт, который мы создали выше.
        }
        return 1;
    }
    //Место функциям для остольных игроков.
    return 1;
}

