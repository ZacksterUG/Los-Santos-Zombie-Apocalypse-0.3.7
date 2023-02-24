//Zombies' food
new ZFPC1;
new ZFPC2;
new ZFPC3;
new ZFPC4;
new ZFPC5;
new ZFPC6;
new ZFPC7;
new ZFPC8;
new ZFPC9;
new ZFPC10;
//////////////
///PICKUPS IN HIVE TO TELEPORT TO OTHER PLACES
new TT;
new TT1;
new TT2;
new TT3;
new TT4;
new TT5;
new TT6;
new TT7;
new TT8;
new TT9;
//////////////




public OnPlayerGameModeInit()
{
	ZFPC1 = CreatePickup(1318,3,1400.6544,-1440.6439,1721.7734);
	ZFPC2 = CreatePickup(1318,3,1406.3240,-1450.8529,1721.7734);
	ZFPC3 = CreatePickup(1318,3,1397.7505,-1452.8732,1721.7734);
	ZFPC4 = CreatePickup(1318,3,1410.4015,-1468.5514,1721.7734);
	ZFPC5 = CreatePickup(1318,3,1398.8356,-1463.8278,1721.7734);
	ZFPC6 = CreatePickup(1318,3,1384.9185,-1463.2385,1721.7734);
	ZFPC7 = CreatePickup(1318,3,1371.3898,-1465.1289,1721.7734);
	ZFPC8 = CreatePickup(1318,3,1362.7053,-1445.1117,1721.7734);
	ZFPC9 = CreatePickup(1318,3,1405.1270,-1418.7037,1721.7734);
	ZFPC10 = CreatePickup(1318,3,1401.1051,-1425.9554,1721.7734);

	TT = CreatePickup(1559,2,1458.7074,-1430.6497,1720.4985);
	TT1 = CreatePickup(1559,2,1462.4375,-1467.2135,1721.5599);
	TT2 = CreatePickup(1559,2,1450.9314,-1488.1682,1721.1958);
	TT3 = CreatePickup(1559,2,1399.7649,-1506.8932,1721.1958);
	TT4 = CreatePickup(1559,2,1372.6307,-1512.8657,1721.3232);
	TT5 = CreatePickup(1559,2,1339.1144,-1484.4552,1720.9534);
	TT6 = CreatePickup(1559,2,1327.7731,-1452.2084,1721.5234);
	TT7 = CreatePickup(1559,2,1360.9810,-1405.4237,1722.0536);
	TT8 = CreatePickup(1559,2,1403.0552,-1403.0778,1721.1477);
	TT9 = CreatePickup(1559,2,1438.5690,-1404.2256,1721.1519);
}
	
	
	
public OnPlayerPickUpPickup(playerid,pickupid)
///////ZOMBIES' FOOD
{
	if(pickupid == ZFPC1)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC2)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC3)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC4)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC5)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC6)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC7)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC9)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC8)
	{
	    new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
	if(pickupid == ZFPC10)
	{
		new Float:a;
		GetPlayerHealth(playerid,a);
		SetPlayerHealth(playerid,a+20);
		if(a > 100)
		{
		    SetPlayerHealth(playerid,100);
		}
	}
///////////////////////////////////////

//////PICKUPS IN HIVE TO OTHER PLACES
	if(pickupid == TT)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT1)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}
	if(pickupid == TT2)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT3)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT4)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT5)
	{
       if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT6)
	{
 		if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT7)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT8)
	{
        if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}

	if(pickupid == TT9)
	{
       if(Team[playerid] == HUMAN)
        {
        	return 0;
        }
		else
		{
  			ShowPlayerDialog(playerid,/*WRITE HERE YOUR DIAOGUE*/);
		}
	}
	
///IDK HOW IT IS REALISED IN YOUR MODE, BUT HERE IT IS MORE COORDS IF YOU NEED
////
/////////////WHEN ZOMBIES' TELEPORTS TO HIVE FROM OTHER PLACE:
AddPlayerClass(115,1508.2010,-1472.7240,1727.1667,80.8637,0,0,0,0,0,0); //
AddPlayerClass(115,1457.9417,-1499.1655,1721.0596,33.1503,0,0,0,0,0,0); //
AddPlayerClass(115,1400.8538,-1517.8162,1721.0596,3.8924,0,0,0,0,0,0); //
AddPlayerClass(115,1371.9426,-1514.9948,1721.0596,338.4756,0,0,0,0,0,0); //
AddPlayerClass(115,1306.4485,-1449.0150,1722.3843,257.6923,0,0,0,0,0,0); //
AddPlayerClass(115,1358.9548,-1401.8241,1721.3105,208.4410,0,0,0,0,0,0); //
AddPlayerClass(115,1403.4969,-1396.7778,1720.9956,176.4675,0,0,0,0,0,0); //
AddPlayerClass(115,1439.5398,-1402.2621,1720.9956,152.3902,0,0,0,0,0,0); //
AddPlayerClass(115,1470.0403,-1425.1324,1720.9956,113.4554,0,0,0,0,0,0); //
AddPlayerClass(115,1508.0731,-1472.5002,1727.2379,84.5213,0,0,0,0,0,0); //
AddPlayerClass(115,1457.5570,-1498.3796,1721.1418,34.4605,0,0,0,0,0,0); //

////////////COORD WHERE WILL ZOMBIES SPAWN

AddPlayerClass(115,1401.5406,-1466.9052,1723.5464,172.4881,0,0,0,0,0,0); //
AddPlayerClass(115,1410.3510,-1466.0276,1723.5464,233.9255,0,0,0,0,0,0); //
AddPlayerClass(115,1415.7129,-1452.5636,1723.5464,256.7521,0,0,0,0,0,0); //
AddPlayerClass(115,1412.5336,-1440.9100,1723.5464,10.6421,0,0,0,0,0,0); //
AddPlayerClass(115,1397.1378,-1436.0222,1723.5464,4.9759,0,0,0,0,0,0); //
AddPlayerClass(115,1388.0233,-1438.6526,1723.5464,38.8110,0,0,0,0,0,0); //
AddPlayerClass(115,1381.9015,-1442.5560,1723.5464,75.6411,0,0,0,0,0,0); //
AddPlayerClass(115,1380.9508,-1457.2130,1723.5464,82.6833,0,0,0,0,0,0); //
AddPlayerClass(115,1395.4236,-1457.3495,1723.5464,44.8452,0,0,0,0,0,0); //
AddPlayerClass(115,1399.8475,-1466.8781,1723.5464,221.5487,0,0,0,0,0,0); //
AddPlayerClass(115,1404.1053,-1453.0607,1723.5464,303.4652,0,0,0,0,0,0); //

//MAP ICONS
	SetPlayerMapIcon(playerid,0,1412.8790,-1313.8276,30.0001,38,0);
    SetPlayerMapIcon(playerid,1,1340.7092,-1774.2318,27.1506,38,0);
    SetPlayerMapIcon(playerid,2,2004.3075,-2028.9152,29.5205,38,0);
    SetPlayerMapIcon(playerid,3,2115.5059,-2465.3269,29.5205,38,0);
