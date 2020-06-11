public bool CreateEntityGlow(int entity, const char[] color, const char[] style, const char[] maxdist)
{
	char model[PLATFORM_MAX_PATH];
	GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));

	int glowprop = CreatePropGlow(entity, model, color, style, maxdist);
	if(glowprop > MaxClients) return SDKHookEx(glowprop, SDKHook_SetTransmit, OnSetTransmit_Entity);
	return false;
}

public bool CreatePropGlow(int entity, const char[] model, const char[] color, const char[] style, const char[] maxdist)
{
	int glowprop = CreateEntityByName("prop_dynamic_glow");
	if(IsValidEntity(glowprop))
	{
		DispatchKeyValue(glowprop, "model", model);
		DispatchKeyValue(glowprop, "solid", "6");

		DispatchKeyValue(glowprop, "glowstyle", style);
		DispatchKeyValue(glowprop, "glowdist", maxdist);
		DispatchKeyValue(glowprop, "glowcolor", color);
		DispatchKeyValue(glowprop, "glowenabled", "1");

		DispatchSpawn(glowprop);

		SetEntityRenderMode(glowprop, RENDER_GLOW);
		SetEntityRenderColor(glowprop, 0, 0, 0, 0);

		int enteffects = GetEntProp(glowprop, Prop_Send, "m_fEffects");
		enteffects |= 1;
		enteffects |= 16;
		enteffects |= 64;
		enteffects |= 128;
		enteffects |= 512;
		SetEntProp(glowprop, Prop_Send, "m_fEffects", enteffects);

		SetVariantString("!activator");
		AcceptEntityInput(glowprop, "SetParent", entity, glowprop);

		SetVariantString("primary");
		AcceptEntityInput(glowprop, "SetParentAttachment", glowprop, glowprop, 0);

		SetVariantString("OnUser1 !self:Kill::0.1:-1");
		AcceptEntityInput(glowprop, "AddOutput");

		eg[entity].Reference = EntIndexToEntRef(glowprop);
		eg[entity].Index = glowprop;
		return true;
	}

	return false;
}

public void RemoveGlowFromEnt(int entity, int glowprop)
{
	if(!IsValidEntity(entity) || glowprop <= 0) return;
	if(glowprop != INVALID_ENT_REFERENCE)
	{
		SDKUnhook(glowprop, SDKHook_SetTransmit, OnSetTransmit_Entity);
		AcceptEntityInput(eg[entity].Reference, "Kill");
		eg[entity].Reset();
	}
}