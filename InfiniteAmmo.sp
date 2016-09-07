#include <sdktools>

#pragma newdecls required

//SDKHooks
Handle g_hGiveAmmo;

enum
{
	TF_AMMO_DUMMY = 0,	// Dummy index to make the CAmmoDef indices correct for the other ammo types.
	TF_AMMO_PRIMARY,
	TF_AMMO_SECONDARY,
	TF_AMMO_METAL,
	TF_AMMO_GRENADES1,
	TF_AMMO_GRENADES2,
	TF_AMMO_COUNT
};

public Plugin myinfo = 
{
	name = "[TF2] Infinite Ammo",
	author = "Pelipoika",
	description = "",
	version = "1.0",
	url = "http://www.sourcemod.net/plugins.php?author=Pelipoika&search=1"
};

public void OnPluginStart()
{
	Handle hConf = LoadGameConfigFile("tf2.infiniteammo");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hConf, SDKConf_Virtual, "CTFPlayer::GiveAmmo");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain); //iCount - Amount of ammo to give.
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain); //iAmmoIndex - Index of the ammo into the AmmoInfoArray.
	PrepSDKCall_AddParameter(SDKType_Bool,         SDKPass_Plain); //bSuppressSound - Suppress sound?
	if ((g_hGiveAmmo = EndPrepSDKCall()) == INVALID_HANDLE) SetFailState("Failed to create SDKCall for CTFPlayer::GiveAmmo offset!"); 	
	
	delete hConf;
}

public Action OnPlayerRunCmd(int client, int &iButtons, int &iImpulse, float fVel[3], float fAng[3], int &iWeapon)
{
	if(!IsPlayerAlive(client))
		return Plugin_Continue;
	
	SDKCall(g_hGiveAmmo, client, 100, TF_AMMO_PRIMARY,   true);
	SDKCall(g_hGiveAmmo, client, 100, TF_AMMO_SECONDARY, true);
	SDKCall(g_hGiveAmmo, client, 100, TF_AMMO_METAL,     true);
	SDKCall(g_hGiveAmmo, client, 100, TF_AMMO_GRENADES1, true);
	SDKCall(g_hGiveAmmo, client, 100, TF_AMMO_GRENADES2, true);
	
	return Plugin_Continue;
}
