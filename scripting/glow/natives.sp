public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("Glow_Setup", Native_SetupGlow);
	CreateNative("Glow_SetupEx", Native_SetupGlowEx);
	CreateNative("Glow_Disable", Native_SetGlowStatus);

	CreateNative("Glow_GetStatus", Native_GlowStatus);
	CreateNative("Glow_GetClientIndex", Native_GetIndex);
	CreateNative("Glow_GetClientReference", Native_GetReference);

	CreateNative("Glow_SetState", Native_SetState);
	CreateNative("Glow_SetStyle", Native_SetStyle);
	CreateNative("Glow_SetDist", Native_SetDist);
	CreateNative("Glow_SetColor", Native_SetColor);

	CreateNative("Glow_SetClientKeep", Native_SetClientKeep);

    gfOnSetup = new GlobalForward("Glow_OnSetup", ET_Ignore, Param_Cell, Param_Cell, Param_Array, Param_Cell, Param_Float);
    gfOnDisable = new GlobalForward("Glow_OnDisable", ET_Ignore, Param_Cell);

	return APLRes_Success;
}

public int Native_GlowStatus(Handle plugin, int params)
{
	return GlowStatus(GetNativeCell(1));
}

public int Native_SetGlowStatus(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(IsValidClient(client) && GlowStatus(client)) DisableGlow(client, pg[client].Index);
}

public int Native_SetupGlow(Handle plugin, int args)
{
	return CreateGlow(GetNativeCell(1), {255, 255, 255}, 0, 100.0, false, true);
}

public int Native_SetupGlowEx(Handle plugin, int params)
{
	int arr[3];
	GetNativeArray(2, arr, sizeof(arr));
	return CreateGlow(GetNativeCell(1), arr, GetNativeCell(3), GetNativeCell(4), GetNativeCell(5), GetNativeCell(6));
}

public int Native_GetIndex(Handle plugin, int params)
{
	return GetClientGlowIndex(GetNativeCell(1));
}

public int Native_GetReference(Handle plugin, int params)
{
	return GetClientGlowReference(GetNativeCell(1));
}

public int Native_SetState(Handle plugin, int params)
{
	return SetGlowState(GetNativeCell(1), GetNativeCell(2));
}

public int Native_SetStyle(Handle plugin, int params)
{
	return SetGlowStyle(GetNativeCell(1), GetNativeCell(2));
}

public int Native_SetDist(Handle plugin, int params)
{
	return SetGlowDist(GetNativeCell(1), GetNativeCell(2));
}

public int Native_SetColor(Handle plugin, int params)
{
	int arr[3];
	GetNativeArray(2, arr, sizeof(arr));
	return SetGlowColor(GetNativeCell(1), arr);
}

public int Native_SetClientKeep(Handle plugin, int params)
{
	pg[GetNativeCell(1)].Keep = GetNativeCell(2);
}