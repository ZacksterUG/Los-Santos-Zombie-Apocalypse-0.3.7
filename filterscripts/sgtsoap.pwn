// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
new MyFirstNPCVehicle;
#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
	print("my filterscript");
	ConnectNPC("sgt_soap","mynpc");
	MyFirstNPCVehicle = CreateVehicle(425, 0.0, 0.0, 5.0, 0.0, 3, 3, 5000);
	return 1;
}
#endif


public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid)) //���������: ���������� �� �����(NPC).
    {
        new npcname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, npcname, sizeof(npcname)); //�������� ��� ������ (NPC).
        if(!strcmp(npcname, "sgt_soap", true)) //��������� ���� ��� MyFirstNPC.
        {
            PutPlayerInVehicle(playerid, MyFirstNPCVehicle, 0); //�������� NPC � ���������, ������� �� ������� ����.
        }
        return 1;
    }
    //����� �������� ��� ��������� �������.
    return 1;
}
