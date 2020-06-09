#include <sourcemod>
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

public Plugin myinfo = 
{
	name = PLUGIN_NEV,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_LERIAS,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_setupglow", Command_SetupGlow);
	RegConsoleCmd("sm_setupglowex", Command_SetupGlowEx);
	RegConsoleCmd("sm_setclientkeep", Command_SetClientKeep);
	RegConsoleCmd("sm_toggleglow", Command_ToggleGlow);
	RegConsoleCmd("sm_setglowcolor", Command_SetGlowColor);
	RegConsoleCmd("sm_setglowdist", Command_SetGlowDist);
	RegConsoleCmd("sm_setglowstyle", Command_SetGlowStyle);

	RegConsoleCmd("sm_rainbowglow", Command_RainbowGlow);
}
//Test commands, with only the necessary checks. Atm we don't really care if some1 pass a wrong arg, but make sure you check everything before passing a variable!
public Action Command_SetupGlow(int client, int args)
{
	if(!Glow_GetStatus(client)) Glow_Setup(client);
	else Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_SetupGlowEx(int client, int args)
{
	if(!Glow_GetStatus(client)) Glow_SetupEx(client, _, 0, _, _, false); //If you pass false you'll be able to see the glow in thirdperson, otherwise only other players could see it, which is the normal case.
	else Glow_Disable(client);
	return Plugin_Handled;
}

public Action Command_SetClientKeep(int client, int args)
{
	if(args != 2)
	{
		PrintToChat(client, "Usage: !sm_setclientkeep targetname status");
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

	char state[3];
	GetCmdArg(2, state, sizeof(state));
	Glow_SetClientKeep(target, !!StringToInt(state));
	PrintToChat(client, "Changed %N's keep value to: %s", target, state);
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
		PrintToChat(client, "Usage: !sm_setglowdist targetname dist (must be set first)");
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
	if(IsFakeClient(client)) return false;
	if(IsClientSourceTV(client)) return false;
	return IsClientInGame(client);
}