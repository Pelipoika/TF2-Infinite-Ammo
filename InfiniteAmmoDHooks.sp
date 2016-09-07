#include <dhooks>

#pragma newdecls required

//DHooks
Handle g_hRemoveAmmo;

public Plugin myinfo = 
{
	name = "[TF2] Infinite Ammo DHooks",
	author = "Pelipoika",
	description = "",
	version = "1.0",
	url = "http://www.sourcemod.net/plugins.php?author=Pelipoika&search=1"
};

public void OnPluginStart()
{
	Handle hConf = LoadGameConfigFile("tf2.infiniteammo");
	
	int iOffset = GameConfGetOffset(hConf, "CTFPlayer::RemoveAmmo");
	if ((g_hRemoveAmmo = DHookCreate(iOffset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity, CTFPlayer_RemoveAmmo)) == INVALID_HANDLE) SetFailState("Failed to create DHook for CTFPlayer::RemoveAmmo offset!"); 
	DHookAddParam(g_hRemoveAmmo, HookParamType_Int);	//iCount
	DHookAddParam(g_hRemoveAmmo, HookParamType_Int);	//iAmmoIndex
	
	delete hConf;
	
	for(int client = 1; client <= MaxClients; client++)
		if(IsClientInGame(client))
			OnClientPutInServer(client);
}

public void OnClientPutInServer(int client)
{
	DHookEntity(g_hRemoveAmmo, false, client);
}

public MRESReturn CTFPlayer_RemoveAmmo(int pThis, Handle hReturn, Handle hParams)
{
	DHookSetParam(hParams, 1, 0);	//Set ammo to deplete to 0
	DHookSetReturn(hReturn, DHookGetReturn(hReturn));
	
	return MRES_Supercede;
}