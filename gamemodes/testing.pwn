// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <streamer>
#include <colandreas>
#include <projectile>



main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


#define GRENADE_SPEED \
	30.0

#define GRENADE_OBJECT \
    342

#define MAX_PLAYER_GRENADES \
	100

//

// Don't change these

#define MAX_GRENADES \
	(MAX_PLAYERS * MAX_PLAYER_GRENADES)

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//

new grenadesObject[MAX_GRENADES];
new grenadesCount;

new PlayerText:ptxtGrenades[MAX_PLAYERS];
new bool:playerHasM4[MAX_PLAYERS];
new playerGrenadesCount[MAX_PLAYERS];

public OnGameModeInit()
{
	CA_Init();
	return 1;
}

public OnPlayerConnect(playerid)
{
    ptxtGrenades[playerid] = CreatePlayerTextDraw(playerid, 629.000000, 421.000000, "Grenades left: 5");
	PlayerTextDrawAlignment(playerid, ptxtGrenades[playerid], 3);
	PlayerTextDrawBackgroundColor(playerid, ptxtGrenades[playerid], 255);
	PlayerTextDrawFont(playerid, ptxtGrenades[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ptxtGrenades[playerid], 0.400000, 2.000000);
	PlayerTextDrawColor(playerid, ptxtGrenades[playerid], -1);
	PlayerTextDrawSetOutline(playerid, ptxtGrenades[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ptxtGrenades[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ptxtGrenades[playerid], 0);
	return 1;
}

CMD:givegrenade(playerid,params[])
{
    playerGrenadesCount[playerid] += 100;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	GivePlayerWeapon(playerid,31,500);
	return 1;
}
public OnPlayerUpdate(playerid)
{
	if (!playerHasM4[playerid])
	{
	    new w,
	        a;
	    GetPlayerWeaponData(playerid, 5, w, a);
	    if (w == 31)
	    {
	        playerHasM4[playerid] = true;
    		playerGrenadesCount[playerid] = MAX_PLAYER_GRENADES;

    		GameTextForPlayer(playerid, "~y~Press \"~k~~SNEAK_ABOUT~\" to shoot a grenade from launcher", 5000, 3);
	    }
	}

	if (GetPlayerWeapon(playerid) == 31)
	{
	    new string[64];
	    format(string, sizeof(string), "Grenades left: %i", playerGrenadesCount[playerid]);
	    PlayerTextDrawSetString(playerid, ptxtGrenades[playerid], string);
		PlayerTextDrawShow(playerid, ptxtGrenades[playerid]);
	}
	else
	{
		PlayerTextDrawHide(playerid, ptxtGrenades[playerid]);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if (weaponid == 31)
	{
	    if (GetPlayerAmmo(playerid) == 0)
     	{
	    	playerHasM4[playerid] = false;
	    }
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (PRESSED(KEY_WALK) && (newkeys & 128/*KEY_AIM*/))
    {
        if (GetPlayerWeapon(playerid) == 31)
        {
            if (playerGrenadesCount[playerid] == 0)
            {
            	GameTextForPlayer(playerid, "~r~No M4 Grenades left", 3000, 3);
                return 1;
            }

            if (grenadesCount == MAX_GRENADES)
            {
            	GameTextForPlayer(playerid, "~r~Couldn't launch grenade~n~~r~Try again, launcher might be stuck!", 5000, 3);
             	return 1;
			}

			new Float:fPX,
				Float:fPY,
				Float:fPZ;
	        GetPlayerCameraPos(playerid, fPX, fPY, fPZ);

	        new Float:fVX,
				Float:fVY,
				Float:fVZ;
	        GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

         	const Float:fScale = 5.0;
	        new Float:object_x = fPX + floatmul(fVX, fScale);
	        new Float:object_y = fPY + floatmul(fVY, fScale);
	        new Float:object_z = fPZ + floatmul(fVZ, fScale);

			new proj = Projectile(object_x, object_y, object_z, GRENADE_SPEED * fVX, GRENADE_SPEED * fVY, (GRENADE_SPEED * fVZ) + 5.0, .air_resistance = 1.0, .sphere_radius = 0.010, .gravity = 15.0);
            if (proj == -1)
            {
				GameTextForPlayer(playerid, "~r~Couldn't launch grenade~n~~r~Try again, launcher might be stuck!", 5000, 3);
				return 1;
			}

			new obj = CreateDynamicObject(GRENADE_OBJECT, object_x, object_y, object_z + 0.5, 0, 0, 0);
            if (obj == INVALID_OBJECT_ID)
            {
				StopProjectile(proj);
            	GameTextForPlayer(playerid, "~r~Couldn't launch grenade~n~~r~Try again, launcher might be stuck!", 5000, 3);
                return 1;
			}

            grenadesObject[grenadesCount++] = obj;
            Streamer_SetIntData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_EXTRA_ID, proj);
			for (new i, j = GetPlayerPoolSize(); i <= j; i++)
			{
				Streamer_UpdateEx(i, object_x, object_y, object_z, .type = STREAMER_TYPE_OBJECT);
			}
            ApplyAnimation(playerid,"BUDDY","buddy_fire_poor",3,0,1,1,0,0,1);
            playerGrenadesCount[playerid]--;
        }
    }
    return 1;
}

public OnProjectileUpdate(projid)
{
	new Float:x,
		Float:y,
		Float:z;
	for (new i; i < grenadesCount; i++)
	{
	    if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, grenadesObject[i], E_STREAMER_EXTRA_ID) == projid)
	    {
			GetProjectilePos(projid, x, y, z);
			SetDynamicObjectPos(grenadesObject[i], x, y, z);

			GetProjectileRot(projid, x, y, z);
			SetDynamicObjectRot(grenadesObject[i], x, y, z);
	        break;
	    }
	}
	return 1;
}

public OnProjectileCollide(projid, type, Float:x, Float:y, Float:z, extraid)
{
	for (new i; i < grenadesCount; i++)
	{
	    if (Streamer_GetIntData(STREAMER_TYPE_OBJECT, grenadesObject[i], E_STREAMER_EXTRA_ID) == projid)
		{
		    if (type == 4)
		    {
		        GameTextForPlayer(extraid, "~r~You were hit by a grenade launcher!", 3000, 3);
		    }

	        CreateExplosion(x, y, z, 2, 10.0);
			StopProjectile(projid);
			DestroyDynamicObject(grenadesObject[i]);

			for (new a = i, b = --grenadesCount; a < b; a++)
			{
                grenadesObject[a] = grenadesObject[a + 1];
            	Streamer_SetIntData(STREAMER_TYPE_OBJECT, grenadesObject[a], E_STREAMER_EXTRA_ID, Streamer_GetIntData(STREAMER_TYPE_OBJECT, grenadesObject[a + 1], E_STREAMER_EXTRA_ID));
			}
		    break;
		}
	}
	return 1;
}
