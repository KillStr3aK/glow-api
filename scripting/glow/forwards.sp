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

	int ents = GetEntityCount();
	for(int i = MaxClients; i < ents; i++)
	{
		RemoveGlowFromEnt(i, eg[i].Index);
		eg[i].Reset();
	}
}

public void OnMapEnd()
{
	OnPluginEnd();
}

public void OnClientDisconnect(int client)
{
	if(!IsValidClient(client)) return;
	if(GlowStatus(client)) DisableGlow(client, pg[client].Index);
}

public void OnClientPostAdminCheck(int client)
{
	pg[client].Reset();
}

public Action OnSetTransmit_All(int entity, int client)
{
	if(pg[client].Index == entity && pg[client].Hide) return Plugin_Handled;
	int owner = GetClientFromSkinIndex(entity);
	if(IsInExcludeList(pg[owner].Exclude, client)) return Plugin_Handled;
	return Plugin_Continue;
}

public Action OnSetTransmit_Entity(int entity, int client)
{
	if(IsInExcludeList(pg[entity].Exclude, client)) return Plugin_Handled;
	return Plugin_Continue;
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

public void Event_RoundStart(Event event, const char[] name, bool dbc)
{
	OnPluginEnd();
}