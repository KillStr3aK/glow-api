public void OnConfigsExecuted()
{
	FindConVar("sv_force_transmit_players").IntValue = 1;
}

public void OnPluginEnd()
{
	for (int i = 1; i <= MaxClients; ++i)
	{
		OnClientDisconnect(i);
	}
}

public void OnMapEnd()
{
	OnPluginEnd();
}

public void OnClientDisconnect(int client)
{
	if(IsValidClient(client) && GlowStatus(client)) DisableGlow(client, pg[client].Index);
}

public void OnClientPostAdminCheck(int client)
{
	pg[client].Reset();
}

public Action OnSetTransmit_All(int entity, int client)
{
	if(pg[client].Index != entity) return Plugin_Continue;
	return Plugin_Handled;
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dbc)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!IsValidClient(client)) return;
	if(GetClientTeam(client) < 2) return;
	if(GlowStatus(client))
	{
		if(pg[client].Keep) CreateGlow(client, pg[client].Color, pg[client].Style, pg[client].MaxDist, pg[client].Keep, false);
		else DisableGlow(client, pg[client].Index);
	}
}

public void Event_PlayerDeath(Event event, const char[] name, bool dbc)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!IsValidClient(client)) return;
	if(GlowStatus(client))
	{
		DisableGlow(client, pg[client].Index);
	}
}