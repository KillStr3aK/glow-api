public bool CreateGlow(int client, int colors[3], int style, float maxdist, bool keep, bool hide) 
{	
	if(GlowStatus(client)) DisableGlow(client, pg[client].Index);

	char model[PLATFORM_MAX_PATH];
	int skin = -1;
	GetClientModel(client, model, sizeof(model));
	skin = CreatePlayerModelProp(client, model);
	if(skin > MaxClients)
	{
		if(hide && !SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit_All))
			return false;

		return SetupGlow(skin, client, colors, style, maxdist, keep);
	}

	return false;
}

public bool SetupGlow(int entity, int client, int colors[3], int style, float maxdist, bool keep)
{
	int m_clrGlow = CanGlow(entity);
	if((m_clrGlow = CanGlow(entity)) == -1) return false;

	SetEntProp(entity, Prop_Send, "m_bShouldGlow", true, true);
	SetEntProp(entity, Prop_Send, "m_nGlowStyle", style);
	SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", maxdist);

	for(int i = 0; i < 3 ; i++)
	{
		SetEntData(entity, m_clrGlow + i, colors[i], _, true);
	}

	if(keep)
	{
		pg[client].State = pg[client].Keep = keep;
		pg[client].Style = style;
		pg[client].MaxDist = maxdist;
		pg[client].Color = colors;
	}

	Call_StartForward(gfOnSetup);
	Call_PushCell(entity);
	Call_PushCell(client);
	Call_PushArray(colors, sizeof(colors));
	Call_PushCell(style);
	Call_PushFloat(maxdist);
	Call_Finish();
	return true;
}

public int CreatePlayerModelProp(int client, const char[] model)
{
	int skin = CreateEntityByName("prop_dynamic_override");
	if(IsValidEntity(skin)){
		DispatchKeyValue(skin, "model", model);
		DispatchKeyValue(skin, "solid", "0");

		DispatchKeyValue(skin, "fademindist", "1");
		DispatchKeyValue(skin, "fademaxdist", "1");
		DispatchKeyValue(skin, "fadescale", "2.0");

		SetEntProp(skin, Prop_Send, "m_CollisionGroup", 0);
		DispatchSpawn(skin);

		SetEntityRenderMode(skin, RENDER_GLOW);
		SetEntityRenderColor(skin, 0, 0, 0, 0);

		int enteffects = GetEntProp(skin, Prop_Send, "m_fEffects");
		enteffects |= 1;
		enteffects |= 16;
		enteffects |= 64;
		enteffects |= 128;
		enteffects |= 512;
		SetEntProp(skin, Prop_Send, "m_fEffects", enteffects);

		SetVariantString("!activator");
		AcceptEntityInput(skin, "SetParent", client, skin);

		SetVariantString("primary");
		AcceptEntityInput(skin, "SetParentAttachment", skin, skin, 0);
		
		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(skin, "AddOutput");

		pg[client].Reference = EntIndexToEntRef(skin);
		pg[client].Index = skin;
		return skin;
	}

	return client;
}

public void DisableGlow(int client, int skin)
{
	if(!IsValidClient(client) || skin <= 0) return;
	if(skin != INVALID_ENT_REFERENCE)
	{
		if(IsValidEntity(skin)) SetEntProp(skin, Prop_Send, "m_bShouldGlow", false, true);
		SDKUnhook(skin, SDKHook_SetTransmit, OnSetTransmit_All);
		if(IsValidClient(client)){
			RemoveSkin(client);
		}
	}
}

public void RemoveSkin(int client)
{
	if(IsValidEntity(pg[client].Reference)) AcceptEntityInput(pg[client].Reference, "Kill");
	pg[client].Reset(!pg[client].Keep);

	Call_StartForward(gfOnDisable);
	Call_PushCell(client);
	Call_Finish();
}

public bool GlowStatus(int client)
{
	if(pg[client].Index == -1 && !pg[client].State) return false;
	return true;
}

public bool SetGlowState(int entity, bool newstate)
{
	if(!IsValidEntity(entity)) return false;
	SetEntProp(entity, Prop_Send, "m_bShouldGlow", newstate, true);
	return true;
}

public bool SetGlowStyle(int entity, bool newstyle)
{
	if(!IsValidEntity(entity)) return false;
	SetEntProp(entity, Prop_Send, "m_nGlowStyle", newstyle);
	return true;
}

public bool SetGlowDist(int entity, float newdist)
{
	if(!IsValidEntity(entity)) return false;
	SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", newdist);
	return true;
}

public bool SetGlowColor(int entity, int colors[3])
{
	if(!IsValidEntity(entity)) return false;
	int m_clrGlow = -1;
	if((m_clrGlow = CanGlow(entity)) == -1) return false;

	for(int i = 0; i < 3 ; i++)
	{
		SetEntData(entity, m_clrGlow + i, colors[i], _, true);
	}

	return true;
}

public int GetClientGlowIndex(int client)
{
	return pg[client].Index;
}

public int GetClientGlowReference(int client)
{
	return pg[client].Reference;
}