new MyFirstNPCVehicle;

public OnFilterScriptInit()
{
	print("my filterscript");
	ConnectNPC("MyFirstNPC","mynpc");
	MyFirstNPCVehicle = CreateVehicle(425, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) //Проверяет: существует ли игрок(NPC).
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //Получает имя игрока (NPC).
        if(!strcmp(npcname, "MyFirstNPC", true)) //Проверяет если имя MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 0); //Помещает NPC в транспорт, который мы создали выше.
        }
        return 1;
    }
    //Место функциям для остольных игроков.
    return 1;
}
