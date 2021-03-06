#include <sourcemod>
#include <sdktools>
#include <glow>

#define PLUGIN_NEV	"Glow API Test"
#define PLUGIN_LERIAS	"Natives test"
#define PLUGIN_AUTHOR	"Nexd"
#define PLUGIN_VERSION	"1.0"
#define PLUGIN_URL	"https://github.com/KillStr3aK"
#pragma tabsize 0;
#pragma newdecls required;
#pragma semicolon 1;

int rr[3] = { 0, ... };
int selent;

public Plugin myinfo = 
{
	name = PLUGIN_NEV,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_LERIAS,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

ArrayList al;

public void OnPluginStart()
{
	RegConsoleCmd("sm_selent", Command_Selent);

	RegConsoleCmd("sm_setupglowent", Command_SetupGlowEnt);
	RegConsoleCmd("sm_setupglowentex", Command_SetupGlowEntEx);
	RegConsoleCmd("sm_removefroment", Command_RemoveFromEnt);

	RegConsoleCmd("sm_setupglow", Command_SetupGlow);
	RegConsoleCmd("sm_setupglowex", Command_SetupGlowEx);
	RegConsoleCmd("sm_disableglow", Command_DisableGlow);

	RegConsoleCmd("sm_setglowcolor", Command_SetGlowColor);
	RegConsoleCmd("sm_setglowdist", Command_SetGlowDist);
	RegConsoleCmd("sm_setglowstyle", Command_SetGlowStyle);

	RegConsoleCmd("sm_toggleglow", Command_ToggleGlow);

	RegConsoleCmd("sm_addtolist", Command_AddToList); //In these commands, We assume that the owner already has a glow.
	RegConsoleCmd("sm_removefromlist", Command_RemoveFromList);
	RegConsoleCmd("sm_clearlist", Command_ClearList);
	RegConsoleCmd("sm_isinlist", Command_IsInList);
	RegConsoleCmd("sm_updatelist", Command_UpdateList);

	RegConsoleCmd("sm_rainbowglow", Command_RainbowGlow);
	RegConsoleCmd("sm_rainbowglowall", Command_RainbowGlowAll);

	al = new ArrayList();
}

public Action Command_Selent(int client, int args)
{
	selent = GetClientAimTarget(client, false);
	if(!IsValidEntity(selent) || selent == 0) selent = client;
	PrintToChat(client, " \x04|%i|-> \x07[%i]", client, selent);
	return Plugin_Handled;
}

public Action Command_SetupGlowEnt(int client, int args)
{
	Glow_SetupEnt(selent);
	return Plugin_Handled;
}

public Action Command_SetupGlowEntEx(int client, int args)
{
	Glow_SetupEntEx(selent);
	return Plugin_Handled;
}

public Action Command_RemoveFromEnt(int client, int args)
{
	Glow_RemoveFromEnt(selent);
	return Plugin_Handled;
}

//Test commands, with only the necessary checks. Atm we don't really care if some1 pass a wrong arg, but make sure you check everything before calling a native!
public Action Command_UpdateList(int client, int args)
{
	al.Clear();
	for(int i = 1; i <= MaxClients; i++) //As an example, we add everyone on the server to the ->client's exclude list, so noone will be able to see the glow
	{
		if(!IsValidClient(i)) continue;
		al.Push(i);
	}

	Glow_UpdateExcludeList(client, al);
	return Plugin_Handled;
}

public Action Command_IsInList(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !removefromlist owner target");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1], szOwner[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szOwner, sizeof(szOwner));
	int owner = FindTarget(client, szOwner);

	if(!IsValidClient(owner))
	{
		PrintToChat(client, "Invalid owner");
		return Plugin_Handled;
	}

	GetCmdArg(2, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	PrintToChat(client, "%N is %s %N's exclude list", target, Glow_IsInExcludeList(target, owner)?"in":"not in", owner);
	return Plugin_Handled;
}

public Action Command_ClearList(int client, int args)
{
	if(args != 1)
	{
		PrintToChat(client, "Usage: !clearlist target");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	Glow_ClearExcludeList(target);
	return Plugin_Handled;
}

public Action Command_RemoveFromList(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !removefromlist owner target");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1], szOwner[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szOwner, sizeof(szOwner));
	int owner = FindTarget(client, szOwner);

	if(!IsValidClient(owner))
	{
		PrintToChat(client, "Invalid owner");
		return Plugin_Handled;
	}

	GetCmdArg(2, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	Glow_RemoveFromExcludeList(owner, target);
	return Plugin_Handled;
}

public Action Command_AddToList(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !addtolist owner target");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1], szOwner[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szOwner, sizeof(szOwner));
	int owner = FindTarget(client, szOwner);

	if(!IsValidClient(owner))
	{
		PrintToChat(client, "Invalid owner");
		return Plugin_Handled;
	}

	GetCmdArg(2, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	Glow_AddToExcludeList(owner, target);
	return Plugin_Handled;
}

public Action Command_DisableGlow(int client, int args)
{
	if(Glow_GetStatus(client)) Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_SetupGlow(int client, int args)
{
	if(!Glow_GetStatus(client)) Glow_Setup(client);
	else Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_SetupGlowEx(int client, int args)
{
	if(!Glow_GetStatus(client)) {
		al.Clear();
		al.Push(client); //We add ourselves to the list, so we can't see our own glow
		Glow_SetupEx(client, _, 0, _, false, al); //If you pass false you'll be able to see the glow in thirdperson, otherwise only other players could see it, which is the normal case.
	} else Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_ToggleGlow(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !toggleglow targetname status (must be set first)");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	int entity = Glow_GetClientReference(target); //You don't have to check for IsValidEntity, the next native will return false if the passed entity is invalid.
	char state[3];
	GetCmdArg(2, state, sizeof(state));
	if(!Glow_SetState(entity, !!StringToInt(state)))
	{
		PrintToChat(client, "Invalid entity");
	}

	return Plugin_Handled;
}

public Action Command_SetGlowColor(int client, int args)
{
	if(args != 4)
	{
		PrintToChat(client, "Usage: !setglowcolor targetname r g b (must be set first)");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	int entity = Glow_GetClientReference(target); //You don't have to check for IsValidEntity, the next native will return false if the passed entity is invalid.

	int color[3];
	char sArgs[3][4];
	for(int i = 2; i < 5; i++) //I was toooooooooooooo lazy so hehe
	{
		GetCmdArg(i, sArgs[i-2], sizeof(sArgs[]));
	}

	for(int i = 0; i < 3; i++)
	{
		color[i] = StringToInt(sArgs[i]);
	}

	if(!Glow_SetColor(entity, color))
	{
		PrintToChat(client, "Invalid entity");
	}

	return Plugin_Handled;
}

public Action Command_SetGlowDist(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !setglowdist targetname dist (must be set first)");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	int entity = Glow_GetClientReference(target); //You don't have to check for IsValidEntity, the next native will return false if the passed entity is invalid.
	char dist[10];
	GetCmdArg(2, dist, sizeof(dist));
	if(!Glow_SetDist(entity, StringToFloat(dist)))
	{
		PrintToChat(client, "Invalid entity");
	}

	return Plugin_Handled;
}

public Action Command_SetGlowStyle(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !setglowstyle targetname style (must be set first)");
		return Plugin_Handled;
	}

	char szTarget[MAX_NAME_LENGTH+1];
	GetCmdArg(1, szTarget, sizeof(szTarget));
	int target = FindTarget(client, szTarget);

	if(!IsValidClient(target))
	{
		PrintToChat(client, "Invalid target");
		return Plugin_Handled;
	}

	int entity = Glow_GetClientReference(target); //You don't have to check for IsValidEntity, the next native will return false if the passed entity is invalid.
	char style[3];
	GetCmdArg(2, style, sizeof(style));
	if(!Glow_SetStyle(entity, StringToInt(style)))
	{
		PrintToChat(client, "Invalid entity");
	}

	return Plugin_Handled;
}

public Action Command_RainbowGlow(int client, int args)
{
	if(!Glow_GetStatus(client)) {
		Glow_SetupEx(client, _, 0);
		CreateTimer(0.1, ManageGlowColor, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	} else Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_RainbowGlowAll(int client, int args)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(!IsValidClient(i)) continue;
		Glow_SetupEx(i, _, 0);
		CreateTimer(0.1, ManageGlowColor, GetClientUserId(i), TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
	}

	return Plugin_Handled;
}

public void Glow_OnSetup(int entity, int client, int colors[3], int style, float maxdist)
{
	PrintToChatAll("%N (%i) glow has been set: Color: %i-%i-%i Style: %i MaxDist: %.1f", client, entity, colors[0], colors[1], colors[2], style, maxdist);
}

public void Glow_OnDisable(int client)
{
	PrintToChatAll("%N's glow has been removed", client);
}

public Action ManageGlowColor(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if(!IsValidClient(client)) return Plugin_Stop;
	if(!IsPlayerAlive(client)) return Plugin_Stop;
	int entity = Glow_GetClientReference(client); //You don't have to check for IsValidEntity, the next native will return false if the passed entity is invalid.

	for(int i = 0; i < 3; i++) rr[i] = GetRandomInt(0, 255);

	if(!Glow_SetColor(entity, rr))
		return Plugin_Stop;

	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	if(client <= 0) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	//if(IsFakeClient(client)) return false;
	if(IsClientSourceTV(client)) return false;
	return IsClientInGame(client);
}