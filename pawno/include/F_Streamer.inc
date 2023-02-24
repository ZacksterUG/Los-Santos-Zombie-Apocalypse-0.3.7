
                                                                                  ///////////////////////
                                                                                  ////Object Streamer////
                                                                                  //////Created by://////
                                                                                  ////////Fallout////////
                                                                                  /////////////////v1.1//


#include <a_samp>

//Natives/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*

Functions:
----------
native F_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:vdist=300.0, bool:InstantUpdate=true);                 //creates an object, returns the objectid or -1 if not successful. (viewdistance and InstantUpdate parameter  are optional)
native F_CreatePlayerObject(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:vdist=0.0, bool:InstantUpdate=false); //creates a player-specific object, returns the objectid or -1 if not successful. (viewdistance and InstantUpdate parameter  are optional)
native F_DestroyObject(objectid);                                                                                                                   //destroys an object.
native F_PlayerObjectUpdate(playerid, Float:x, Float:y, Float:z);                                                                                   //update objects for a player in a certain position.
native F_MoveObject(objectid, Float:x, Float:y, Float:z, Float:speed, Float:rx=0.0, Float:ry=0.0, Float:rz=0.0);                                    //moves an object. (rotation parameters rx ry and rz are optional)
native F_StopObject(objectid);                                                                                                                      //stops an object from moving, returns 1 on success and 0 if the object is invalid.
native F_IsObjectMoving(objectid);                                                                                                                  //returns 1 if the object is moving, returns 0 if the object is not moving, returns -1 if the object is invalid.
native F_AttachObjectToPlayer(objectid, playerid, Float:x, Float:y, Float;z, Float:rx, Float:ry, Float:rz);                                         //attaches an object to a player.
native F_IsObjectCreated(objectid);                                                                                                                 //returns 1 if the object is created, returns 0 if it's not.
native F_IsObjectCreatedForPlayer(playerid, objectid);                                                                                              //returns 1 if the object is created for a certain player, returns 0 if it's not.
native F_SetObjectPos(objectid, Float:x, Float:y, Float:z);                                                                                         //sets the position of an object.
native F_GetObjectPos(objectid, &Float:x, &Float:y, &Float:z);                                                                                      //gets the position of an object in x, y and z.
native F_SetObjectRot(objectid, Float:rx, Float:ry, Float:rz);                                                                                      //sets the rotation of an object.
native F_GetObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz);                                                                                   //gets the rotation of an object in rx, ry and rz.
native F_CountObjects();                                                                                                                            //returns the amount of created objects.
native F_RefreshObjects(playerid);                                                                                                                  //recreates (refreshes) a certain player's objects. (useful to recreate broken objects like glass, boxes, barrels, ...)
native F_ObjectUpdateForAll();                                                                                                                      //instantly updates the objects for all players.

Callbacks:
----------
native F_OnObjectMoved(objectid);                                                                                                                   //callback which is called when an object has finished moving.

*/
//Configuration///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define F_MAX_OBJECTS           10000    //maximum amount of objects the streamer will create; PLEASE change this to the amount of objects you are using.
#define UpdateTime              1000    //update time in ms (milliseconds). A lower value means faster updating.
#define ObjectsToStream         800     //maximum number of objects that will be streamed for one player (maximum = 1000 objects in 0.3d).
#define StreamRange             300.0   //the player's object view range, doesn't need to be changed because objects already fade at 350 distance.
#define DistanceBeforeUpdate    5.0     //the distance a player must travel before objects get updated. (also matters a lot for CPU usage)
#pragma dynamic                 30000   //increase this value if you have problems with stach/heap size.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enum OInfo
{
	ModelID,
	ObjectID[MAX_PLAYERS],
	Float:ox, Float:oy, Float:oz,
	Float:orx, Float:ory, Float:orz,
	Float:ovdist,
	PlayerID,
	ObjectAttachedID,
	bool:ObjectMoving,
	bool:ObjectCreated[MAX_PLAYERS],
}

new ObjectInfo[F_MAX_OBJECTS][OInfo];
new bool:ObjectUpdatetRunning;
new bool:CantCreateMore;
new bool:RefreshObjects[MAX_PLAYERS];
new bool:DontUpdate[MAX_PLAYERS];
new bool:ObjectDestroyed;
new Float:OldX[MAX_PLAYERS], Float:OldY[MAX_PLAYERS], Float:OldZ[MAX_PLAYERS];
new ObjectCount;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_CreateObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:vdist=0.0, bool:InstantUpdate=false, playerid=-1)
{
	if(modelid < 1)
	{
		printf("Invalid modelid for object: F_CreateObject(%i, %f, %f, %f, %f, %f, %f);\a\a\a\n", modelid, x, y, z, rx, ry, rz);
		return -1;
	}

	new objectid;

	if(CantCreateMore == false)
	{
		if(ObjectDestroyed == false) //if no object has been destroyed yet, the objectid's can be assigned in a simple way (really fast)
		{
		    if(ObjectInfo[ObjectCount][ModelID] == 0)
			{
			    objectid = ObjectCount;
			    ObjectCount ++;
			}
		}
		else //if an object was destroyed already once, this loop will search for a free space in the objectid list (slow)
		{
			for(new i; i<F_MAX_OBJECTS; i++)
			{

			    if(ObjectInfo[i][ModelID] == 0)
				{
					objectid = i;
					break;
				}
			}
		}
	}
	else return -1;

	ObjectInfo[objectid][ModelID] = modelid;
	ObjectInfo[objectid][ox] = x; ObjectInfo[objectid][oy] = y; ObjectInfo[objectid][oz] = z;
	ObjectInfo[objectid][orx] = rx; ObjectInfo[objectid][ory] = ry; ObjectInfo[objectid][orz] = rz;
	ObjectInfo[objectid][ovdist] = vdist;
	ObjectInfo[objectid][PlayerID] = playerid;
	ObjectInfo[objectid][ObjectAttachedID] = -1;

	if(InstantUpdate) F_ObjectUpdateForAll();

	return objectid;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_CreatePlayerObject(playerid, modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:vdist=0.0, bool:InstantUpdate=false)
{
	return F_CreateObject(modelid, x, y, z, rx, ry, rz, vdist, InstantUpdate, playerid);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_IsObjectCreated(objectid)
{
	if(ObjectInfo[objectid][ModelID] == 0) return 0;
	return 1;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_IsObjectCreatedForPlayer(playerid, objectid)
{
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && ObjectInfo[objectid][ObjectCreated][playerid] == true) return 1;
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_CountObjects()
{
	new count;
	for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
	{
	    if(F_IsObjectCreated(objectid)) count++;
	}
	return count;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_AttachObjectToPlayer(objectid, playerid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(F_IsObjectCreated(objectid) && IsPlayerConnected(playerid))
	{
		for(new playerid2; playerid2<MAX_PLAYERS; playerid2++)
		{
			if(F_IsObjectCreatedForPlayer(playerid2, objectid))
			{
				AttachPlayerObjectToPlayer(playerid2, ObjectInfo[objectid][ObjectID][playerid2], playerid, x, y, z, rx, ry, rz);
			}
		}
		ObjectInfo[objectid][ObjectAttachedID] = playerid;
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_DestroyObject(objectid)
{
	if(F_IsObjectCreated(objectid))
	{
		for(new playerid; playerid<MAX_PLAYERS; playerid++)
		{
			if(F_IsObjectCreatedForPlayer(playerid, objectid))
			{
				DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
				ObjectInfo[objectid][ObjectCreated][playerid] = false;
			}
		}
		ObjectInfo[objectid][ModelID] = 0;
		
		if(ObjectDestroyed == false) ObjectDestroyed = true;
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_MoveObject(objectid, Float:x, Float:y, Float:z, Float:speed, Float:rx=999999999.99, Float:ry=999999999.99, Float:rz=999999999.99)
{
	if(F_IsObjectCreated(objectid))
	{
	    F_StopObject(objectid); //fixes problems with moving objects which were already moving

		if(rx == 999999999.99) rx = ObjectInfo[objectid][orx];
		if(ry == 999999999.99) ry = ObjectInfo[objectid][ory];
		if(rz == 999999999.99) rz = ObjectInfo[objectid][orz];

		new time;
		for(new playerid; playerid<MAX_PLAYERS; playerid++)
		{
			if(F_IsObjectCreatedForPlayer(playerid, objectid))
			{
				time = MovePlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid], x, y, z, speed, rx, ry, rz);
			}
		}

		ObjectInfo[objectid][ObjectMoving] = true;
		ObjectInfo[objectid][ox] = x; ObjectInfo[objectid][oy] = y; ObjectInfo[objectid][oz] = z;
		return time;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

forward F_OnObjectMoved(objectid); public OnPlayerObjectMoved(playerid, objectid)
{
	for(new objectid2; objectid2<F_MAX_OBJECTS; objectid2++)
	{
		if(F_IsObjectCreated(objectid2))
		{
			if(ObjectInfo[objectid2][ObjectID][playerid] == objectid && ObjectInfo[objectid2][ObjectMoving] == true)
			{
				CallLocalFunction("F_OnObjectMoved", "i", objectid2);
				ObjectInfo[objectid][ObjectMoving] = false;
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_StopObject(objectid)
{
	if(F_IsObjectCreated(objectid))
	{
		for(new playerid; playerid<MAX_PLAYERS; playerid++)
		{
			if(F_IsObjectCreatedForPlayer(playerid, objectid))
			{
				StopPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
			}
		}
		ObjectInfo[objectid][ObjectMoving] = false;
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_IsObjectMoving(objectid)
{
	if(F_IsObjectCreated(objectid))
	{
	    if(ObjectInfo[objectid][ObjectMoving]) return 1;
		return 0;
	}
	return -1;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_SetObjectPos(objectid, Float:x, Float:y, Float:z)
{
	if(F_IsObjectCreated(objectid))
	{
		ObjectInfo[objectid][ox] = x; ObjectInfo[objectid][oy] = y; ObjectInfo[objectid][oz] = z;
		for(new playerid; playerid<MAX_PLAYERS; playerid++)
		{
			if(F_IsObjectCreatedForPlayer(playerid, objectid))
			{
				SetPlayerObjectPos(playerid, ObjectInfo[objectid][ObjectID][playerid], x, y, z);
			}
		}
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_GetObjectPos(objectid, &Float:x, &Float:y, &Float:z)
{
	if(F_IsObjectCreated(objectid))
	{
		x = ObjectInfo[objectid][ox]; y = ObjectInfo[objectid][oy]; z = ObjectInfo[objectid][oz];
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_SetObjectRot(objectid, Float:rx, Float:ry, Float:rz)
{
	if(F_IsObjectCreated(objectid))
	{
		ObjectInfo[objectid][orx] = rx; ObjectInfo[objectid][ory] = ry; ObjectInfo[objectid][orz] = rz;

		for(new playerid; playerid<MAX_PLAYERS; playerid++)
		{
			if(F_IsObjectCreatedForPlayer(playerid, objectid))
			{
				SetPlayerObjectRot(playerid, ObjectInfo[objectid][ObjectID][playerid], rx, ry, rz);
			}
		}
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_GetObjectRot(objectid, &Float:rx, &Float:ry, &Float:rz)
{
	if(F_IsObjectCreated(objectid))
	{
		rx = ObjectInfo[objectid][orx]; ry = ObjectInfo[objectid][ory]; rz = ObjectInfo[objectid][orz];
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_RefreshObjects(playerid)
{
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
		RefreshObjects[playerid] = true;

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		F_PlayerObjectUpdate(playerid, x, y, z);
		return 1;
	}
	return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnPlayerConnect(playerid)
{
	if(ObjectUpdatetRunning == false)
	{
		SetTimer("F_ObjectUpdate", UpdateTime, 1);
		ObjectUpdatetRunning = true;
	}

	for(new objectid; objectid<F_MAX_OBJECTS; objectid++) ObjectInfo[objectid][ObjectCreated][playerid] = false;

	OldX[playerid] = 999999999.99; OldY[playerid] = 999999999.99; OldZ[playerid] = 999999999.99;
	RefreshObjects[playerid] = false;

	if(funcidx("F_OnPlayerConnect") != -1) CallLocalFunction("F_OnPlayerConnect", "i", playerid);
	return 1;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

forward F_ObjectUpdate(bool:DontCheckDistance); public F_ObjectUpdate(bool:DontCheckDistance)
{
	new Closest[ObjectsToStream], bool:Firstloop, nr, AmountToStream, Float:fX, Float:fY, Float:fZ;
	new Float:ObjDistance[F_MAX_OBJECTS], ObjectArr[F_MAX_OBJECTS], bool:DontDestroy[F_MAX_OBJECTS], bool:PosUpdated[F_MAX_OBJECTS];

	for(new playerid; playerid<MAX_PLAYERS; playerid++)
	{
		if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid) && DontUpdate[playerid] == false)
		{
			if(!IsPlayerInRangeOfPoint(playerid, DistanceBeforeUpdate, OldX[playerid], OldY[playerid], OldZ[playerid]) || DontCheckDistance)
			{
       			GetPlayerPos(playerid, OldX[playerid], OldY[playerid], OldZ[playerid]);

				nr = 0;
				for(new objectid; objectid<F_MAX_OBJECTS; objectid++) //check the distances from each object to the player
				{
					if(F_IsObjectCreated(objectid) && ObjectInfo[objectid][PlayerID] == playerid || ObjectInfo[objectid][PlayerID] == -1)
					{
						if(!PosUpdated[objectid])
						{
							if(ObjectInfo[objectid][ObjectAttachedID] != -1)
							{
								GetPlayerPos(ObjectInfo[objectid][ObjectAttachedID], ObjectInfo[objectid][ox], ObjectInfo[objectid][oy], ObjectInfo[objectid][oz]);
							}
							PosUpdated[objectid] = true;
						}

						fX = ObjectInfo[objectid][ox] - OldX[playerid]; //distance from the object to the player
						fY = ObjectInfo[objectid][oy] - OldY[playerid];
						fZ = ObjectInfo[objectid][oz] - OldZ[playerid];

						ObjDistance[objectid] = floatsqroot(fX*fX + fY*fY + fZ*fZ);

						if(floatcmp(ObjDistance[objectid], StreamRange) == -1)
						{
							ObjectArr[nr] = objectid;
							nr++;
						}
					}
				}

				if(nr > ObjectsToStream) //sort objects on distance
				{
				    AmountToStream = ObjectsToStream;
					for(new loop; loop<ObjectsToStream; loop++)
					{
						Firstloop = true;
						for(new objectid; objectid<nr; objectid++)
						{
							if((ObjDistance[ObjectArr[objectid]] != 999999999.99) && ((floatcmp(ObjDistance[ObjectArr[objectid]], ObjDistance[Closest[loop]]) == -1) || Firstloop))
							{
								Firstloop = false;
								Closest[loop] = ObjectArr[objectid];
							}
						}
						ObjDistance[Closest[loop]] = 999999999.99;
					}
				}
				else
				{
				    AmountToStream = nr;
					for(new objectid; objectid<nr; objectid++) Closest[objectid] = ObjectArr[objectid];
				}

				for(new objectid; objectid<F_MAX_OBJECTS; objectid++) DontDestroy[objectid] = false;
				for(new objectid; objectid<AmountToStream; objectid++) DontDestroy[Closest[objectid]] = true;

				for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
				{
					if(ObjectInfo[objectid][ObjectCreated][playerid] == true && DontDestroy[objectid] == false)
					{
						DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
						ObjectInfo[objectid][ObjectCreated][playerid] = false;
					}
				}

				for(new loop; loop<AmountToStream; loop++)
				{
					if(ObjectInfo[Closest[loop]][ObjectCreated][playerid] == false)
					{
						ObjectInfo[Closest[loop]][ObjectID][playerid] = CreatePlayerObject(playerid, ObjectInfo[Closest[loop]][ModelID], ObjectInfo[Closest[loop]][ox], ObjectInfo[Closest[loop]][oy],
						ObjectInfo[Closest[loop]][oz], ObjectInfo[Closest[loop]][orx], ObjectInfo[Closest[loop]][ory], ObjectInfo[Closest[loop]][orz], ObjectInfo[Closest[loop]][ovdist]);
						ObjectInfo[Closest[loop]][ObjectCreated][playerid] = true;
					}
				}
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_ObjectUpdateForAll() { F_ObjectUpdate(true); }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_PlayerObjectUpdate(playerid, Float:x, Float:y, Float:z) //placed in a different function as F_ObjectUpdate to run faster.
{
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
    {
		OldX[playerid] = x; OldY[playerid] = y; OldZ[playerid] = z;

		new nr;
		new Float:ObjDistance[F_MAX_OBJECTS];
		new ObjectArr[F_MAX_OBJECTS];
		new Float:fX, Float:fY, Float:fZ;

		for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
		{
			if(F_IsObjectCreated(objectid) && ObjectInfo[objectid][PlayerID] == playerid || ObjectInfo[objectid][PlayerID] == -1)
			{
				if(ObjectInfo[objectid][ObjectAttachedID] != -1) GetPlayerPos(ObjectInfo[objectid][ObjectAttachedID], ObjectInfo[objectid][ox], ObjectInfo[objectid][oy], ObjectInfo[objectid][oz]);

				fX = ObjectInfo[objectid][ox] - x;
				fY = ObjectInfo[objectid][oy] - y;
				fZ = ObjectInfo[objectid][oz] - z;

				ObjDistance[objectid] = floatsqroot(fX*fX + fY*fY + fZ*fZ);

				if(floatcmp(ObjDistance[objectid], StreamRange) == -1)
				{
					ObjectArr[nr] = objectid;
					nr++;
				}
			}
		}

		new Closest[ObjectsToStream];
		new AmountToStream;

		if(nr > ObjectsToStream)
		{
			AmountToStream = ObjectsToStream;
			for(new loop; loop<ObjectsToStream; loop++)
			{
				new bool:Firstloop = true;
				for(new objectid; objectid<nr; objectid++) if((ObjDistance[ObjectArr[objectid]] != 999999999.99) && ((floatcmp(ObjDistance[ObjectArr[objectid]], ObjDistance[Closest[loop]]) == -1) || Firstloop))
				{
					Firstloop = false;
					Closest[loop] = ObjectArr[objectid];
				}
				ObjDistance[Closest[loop]] = 999999999.99;
			}
		}
		else
		{
			AmountToStream = nr;
			for(new objectid; objectid<nr; objectid++) Closest[objectid] = ObjectArr[objectid];
		}

		new bool:DontDestroy[F_MAX_OBJECTS];
		for(new objectid; objectid<AmountToStream; objectid++) DontDestroy[Closest[objectid]] = true;

		for(new objectid; objectid<F_MAX_OBJECTS; objectid++)
		{
			if(ObjectInfo[objectid][ObjectCreated][playerid] == true && (DontDestroy[objectid] == false || RefreshObjects[playerid] == true))
			{
				DestroyPlayerObject(playerid, ObjectInfo[objectid][ObjectID][playerid]);
				ObjectInfo[objectid][ObjectCreated][playerid] = false;
			}
		}
		RefreshObjects[playerid] = false;

		for(new loop; loop<AmountToStream; loop++)
		{
			if(ObjectInfo[Closest[loop]][ObjectCreated][playerid] == false)
			{
				ObjectInfo[Closest[loop]][ObjectID][playerid] = CreatePlayerObject(playerid, ObjectInfo[Closest[loop]][ModelID], ObjectInfo[Closest[loop]][ox], ObjectInfo[Closest[loop]][oy],
				ObjectInfo[Closest[loop]][oz], ObjectInfo[Closest[loop]][orx], ObjectInfo[Closest[loop]][ory], ObjectInfo[Closest[loop]][orz], ObjectInfo[Closest[loop]][ovdist]);
				ObjectInfo[Closest[loop]][ObjectCreated][playerid] = true;
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

stock F_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
	DontUpdate[playerid] = true;
	SetPlayerPos(playerid, x, y, z);
	F_PlayerObjectUpdate(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z);
	DontUpdate[playerid] = false;
}

#define SetPlayerPos F_SetPlayerPos

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect F_OnPlayerConnect
forward F_OnPlayerConnect(playerid);

//EOF/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Add F_CountObjects
