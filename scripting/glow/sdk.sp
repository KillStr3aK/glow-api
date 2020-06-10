#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <glow>

#define PLUGIN_NEV	"Glow API"
#define PLUGIN_LERIAS	"Easy to use Glow API"
#define PLUGIN_AUTHOR	"Nexd"
#define PLUGIN_VERSION	"1.0"
#define PLUGIN_URL	"https://github.com/KillStr3aK"

#pragma tabsize 0;
#pragma newdecls required;
#pragma semicolon 1;

public Plugin myinfo = 
{
	name = PLUGIN_NEV,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_LERIAS,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

#include "glow/globals.sp"
#include "glow/stock.sp"
#include "glow/natives.sp"
#include "glow/forwards.sp"
#include "glow/main.sp"

void Initialize() {
	if(GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This API only supports CS:GO");
	}

	ResetPlayers();
}

static stock void ResetPlayers()
{
	for (int i = 1; i <= MaxClients; ++i)
	{
		OnClientPostAdminCheck(i);
	}
}