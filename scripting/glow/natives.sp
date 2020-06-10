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

	CreateNative("Glow_AddToExcludeList", Native_AddToExcludeList);
	CreateNative("Glow_RemoveFromExcludeList", Native_RemoveFromExcludeList);
	CreateNative("Glow_UpdateExcludeList", Native_UpdateExcludeList);
	CreateNative("Glow_ClearExcludeList", Native_ClearExcludeList);
	CreateNative("Glow_IsInExcludeList", Native_IsInExcludeList);

    gfOnSetup = new GlobalForward("Glow_OnSetup", ET_Ignore, Param_Cell, Param_Cell, Param_Array, Param_Cell, Param_Float);
    gfOnDisable = new GlobalForward("Glow_OnDisable", ET_Ignore, Param_Cell);

	return APLRes_Success;
}

public int Native_IsInExcludeList(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	int owner = GetNativeCell(1);
	if(!IsValidClient(owner)) ThrowNativeError(false, "Invalid client index (owner)");
	if(!GlowStatus(owner)) ThrowNativeError(false, "A glow must be set first!");
	return IsInExcludeList(pg[owner].Exclude, client);
}

public int Native_ClearExcludeList(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	if(!GlowStatus(client)) ThrowNativeError(false, "A glow must be set first!");
	if(pg[client].Exclude != null)
	{
		pg[client].Exclude.Clear();
	}
}

public int Native_RemoveFromExcludeList(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	int target = GetNativeCell(1);
	if(!IsValidClient(target)) ThrowNativeError(false, "Invalid client index (target)");
	if(!GlowStatus(client)) ThrowNativeError(false, "A glow must be set first!");
	if(pg[client].Exclude != null) {
		int idx = pg[client].Exclude.FindValue(target);
		if(idx != -1)
		{
			pg[client].Exclude.Erase(idx);
			return true;
		}
	}

	return false;
}

public int Native_AddToExcludeList(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	int target = GetNativeCell(2);
	if(!IsValidClient(target)) ThrowNativeError(false, "Invalid client index (target)");
	if(!GlowStatus(client)) ThrowNativeError(false, "A glow must be set first!");
	if(pg[client].Exclude == null) {
		pg[client].Exclude = new ArrayList();
	}
	if(!IsInExcludeList(pg[client].Exclude, client)) pg[client].Exclude.Push(target);
	return IsInExcludeList(pg[client].Exclude, target);
}

public int Native_UpdateExcludeList(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	if(!GlowStatus(client)) ThrowNativeError(false, "A glow must be set first!");
	pg[client].Exclude = GetNativeCell(2);
	return true;
}

public int Native_GlowStatus(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) return ThrowNativeError(false, "Invalid client index");
	return GlowStatus(client);
}

public int Native_SetGlowStatus(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) ThrowNativeError(false, "Invalid client index");
	if(GlowStatus(client)) DisableGlow(client, pg[client].Index);
}

public int Native_SetupGlow(Handle plugin, int args)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) return ThrowNativeError(false, "Invalid client index");
	pg[client].Exclude = view_as<ArrayList>(INVALID_HANDLE);
	return CreateGlow(client, {255, 255, 255}, 0, 100.0, true);
}

public int Native_SetupGlowEx(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) return ThrowNativeError(false, "Invalid client index");
	int arr[3];
	GetNativeArray(2, arr, sizeof(arr));
	pg[client].Exclude = GetNativeCell(6);
	return CreateGlow(client, arr, GetNativeCell(3), GetNativeCell(4), GetNativeCell(5));
}

public int Native_GetIndex(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) return ThrowNativeError(false, "Invalid client index");
	return GetClientGlowIndex(client);
}

public int Native_GetReference(Handle plugin, int params)
{
	int client = GetNativeCell(1);
	if(!IsValidClient(client)) return ThrowNativeError(false, "Invalid client index");
	return GetClientGlowReference(client);
}

public int Native_SetState(Handle plugin, int params)
{
	int entity = GetNativeCell(1);
	if(!IsValidEntity(entity)) return ThrowNativeError(false, "Invalid entity index");
	return SetGlowState(entity, GetNativeCell(2));
}

public int Native_SetStyle(Handle plugin, int params)
{
	int entity = GetNativeCell(1);
	if(!IsValidEntity(entity)) return ThrowNativeError(false, "Invalid entity index");
	int style = GetNativeCell(2);
	if(style < 0 || style > 3) return ThrowNativeError(false, "Invalid style");
	return SetGlowStyle(entity, style);
}

public int Native_SetDist(Handle plugin, int params)
{
	int entity = GetNativeCell(1);
	if(!IsValidEntity(entity)) return ThrowNativeError(false, "Invalid entity index");
	return SetGlowDist(entity, GetNativeCell(2));
}

public int Native_SetColor(Handle plugin, int params)
{
	int entity = GetNativeCell(1);
	if(!IsValidEntity(entity)) ThrowNativeError(false, "Invalid entity index");
	int arr[3];
	GetNativeArray(2, arr, sizeof(arr));
	return SetGlowColor(entity, arr);
}