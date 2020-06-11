stock bool IsValidClient(int client)
{
	if(client <= 0) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	//if(IsFakeClient(client)) return false;
	if(IsClientSourceTV(client)) return false;
	return IsClientInGame(client);
}

stock int CanGlow(int entity)
{
	int offset = -1;
	return (offset = GetEntSendPropOffs(entity, "m_clrGlow"));
}