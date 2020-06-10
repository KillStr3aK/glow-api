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
	if(pg[client].Index == entity && pg[client].Hide) return Plugin_Handled;
	int owner = GetClientFromSkinIndex(entity);
	if(IsInExcludeList(pg[owner].Exclude, client)) return Plugin_Handled;
	return Plugin_Continue;
}