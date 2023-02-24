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
    if(IsPlayerNPC(playerid)) //���������: ���������� �� �����(NPC).
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //�������� ��� ������ (NPC).
        if(!strcmp(npcname, "MyFirstNPC", true)) //��������� ���� ��� MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 0); //�������� NPC � ���������, ������� �� ������� ����.
        }
        return 1;
    }
    //����� �������� ��� ��������� �������.
    return 1;
}
