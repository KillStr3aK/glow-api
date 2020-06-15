#if defined _glow_included
 #endinput
#endif
#define _glow_included

/**
 * Setup a simple glow for the given player that can be customized later. (Not hided.)
 *
 * @param client        Client index.
 * @return              True if glow is created, false otherwise.
 */
native bool Glow_Setup(int client);

/**
 * Setup a pre configured glow for the given player. (Can be customized later.)
 *
 * @param client        Client index.
 * @param colors        Desired glow color in RGB.
 * @param style         Glow style. 3 = Outline V2 + Pulse, 2 = Outline V2, 1 = Body + Pulse, 0 = Outline (! Style 0 CAN BE SEEN THROUGH WALLS!)
 * @param maxdist       Glow visible distance
 * @param hide          Hide the glow from the player (leave it on false if you don't know what you're doin)
 * @return              True if glow is created, false otherwise.
 */
native bool Glow_SetupEx(int client, int colors[3] = {255, 0, 0}, int style = 1, float maxdist = 10000.0, bool hide = false, ArrayList exclude = view_as<ArrayList>(INVALID_HANDLE));

/**
 * Removes the glow from the player.
 *
 * @param client        Client index.
 * @noreturn
 */
native void Glow_Disable(int client);

/**
 * Setup a simple glow for the given entity that can be customized later. (Not hided.)
 *
 * @param entity        Client index.
 * @return              True if glow is created, false otherwise.
 */
native bool Glow_SetupEnt(int entity);

/**
 * Setup a simple glow for the given entity that can be customized later. (Not hided.)
 *
 * @param entity        Client index.
 * @param color			Color in RGB.
 * @param style        	Glow Style
 * @param maxdist		MaxDist.
 * @param exclude		List of entity indexes that should not see the glow.
 * @return              True if glow is created, false otherwise.
 */
native bool Glow_SetupEntEx(int entity, const char[] color = "255 0 0", const char[] style = "0", const char[] maxdist = "10000.0", ArrayList exclude = view_as<ArrayList>(INVALID_HANDLE));

/**
 * Removes the glow from the entity.
 *
 * @param entity        Entity index.
 * @noreturn
 */
native void Glow_RemoveFromEnt(int entity);

/**
 * Returns glow status.
 *
 * @param client        Client index.
 * @return              True if the player has glow, false otherwise.
 */
native bool Glow_GetStatus(int client);

/**
 * Returns the glow entity index.
 *
 * @param client        Client index.
 * @return              Entity index.
 */
native int Glow_GetClientIndex(int client);

/**
 * Returns the glow entity reference.
 *
 * @param client        Client index.
 * @return              Entity reference.
 */
native int Glow_GetClientReference(int client);

/**
 * Change the glow status (On/Off).
 *
 * @param client        Client index.
 * @param state         New state.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetState(int client, bool state);

/**
 * Change the glow style (0 - Outline, 1 - Body + Pulse, 2 = Outline V2, 3 = Outline V2 + Pulse).
 *
 * @param client        Client index.
 * @param style         New style.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetStyle(int client, int style);

/**
 * Change the glow maxdist.
 *
 * @param client        Client index.
 * @param dist          New maxdist.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetDist(int client, float dist);

/**
 * Change the glow color.
 *
 * @param client        Client index.
 * @param color         New color (RGB).
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetColor(int client, int color[3]);

/**
 * Add the target to the owner's exclude list. (The glow isn't drawn for list members)
 *
 * @param owner			Client index of the glow onwer.
 * @param target		Target client index.
 * @return				True if added OR if the target was already in the list, false if glow was not set, or invalid client index.
 */
native bool Glow_AddToExcludeList(int owner, int target);

/**
 * Remove the target from the owner's exclude list
 *
 * @param owner			Client index of the glow onwer.
 * @param target		Target client index.
 * @return				True if removed, false if glow was not set, or invalid client index.
 */
native bool Glow_RemoveFromExcludeList(int owner, int target);

/**
 * Update the player's glow excludelist.
 *
 * @param client        Client index.
 * @param newlist       A completely new excludelist.
 * @return              Returns true if set, false if glow was not set, or invalid client index.
 */
native bool Glow_UpdateExcludeList(int client, ArrayList newlist);

/**
 * Check whether the given client is in the exclude list.
 *
 * @param client		Client index.
 * @param owner			Glow owner index.
 * @return				True if the client is in the list, false if not or glow was not set, or invalid index.
 */
native bool Glow_IsInExcludeList(int client, int owner);

/**
 * Clear the excludelist.
 *
 * @param client        Client index.
 * @noreturn
 */
native void Glow_ClearExcludeList(int client);

/**
* Called when a glow has been set on a player.
 * @param entity        Glow entity index.
 * @param client        Client index.
 * @param colors        Desired glow color in RGB.
 * @param style         Glow style. 1 = Body Glow 0 = Outline
 * @param maxdist       Glow visible distance
 * @noreturn
**/
forward void Glow_OnSetup(int entity, int client, int colors[3], int style, float maxdist);

/**
* Called when a glow has been removed from a player.
 * @param client        Client index.
 * @noreturn
**/
forward void Glow_OnDisable(int client);

// ** Unused **
methodmap Glow < StringMap {
	public Glow(bool status, int style, float maxdist, int colors[3]) {
		StringMap temp = new StringMap();
		temp.SetValue("m_bShouldGlow", status);
		temp.SetValue("m_nGlowStyle", style);
		temp.SetValue("m_flGlowMaxDist", maxdist);
		temp.SetValue("m_clrGlow", colors);
		return view_as<Glow>(temp);
	}

	property bool Status {
		public get() {
			bool status;
			GetTrieValue(this, "m_bShouldGlow", status);
			return status;
		}

		public set(bool newstatus) {
			SetTrieValue(this, "m_bShouldGlow", newstatus);
		}
	}

	property int Style {
		public get() {
			int style;
			GetTrieValue(this, "m_nGlowStyle", style);
			return style;
		}

		public set(int newstyle) {
			SetTrieValue(this, "m_nGlowStyle", newstyle);
		}
	}

	property float MaxDist {
		public get() {
			float dist;
			GetTrieValue(this, "m_flGlowMaxDist", dist);
			return dist;
		}

		public set(float newmaxdist) {
			SetTrieValue(this, "m_flGlowMaxDist", newmaxdist);
		}
	}

	public void SetColor(int newcolor[3])
	{
		SetTrieArray(this, "m_clrGlow", newcolor, sizeof(newcolor));
	}

	public void GetColor(int buffer[3])
	{
		GetTrieArray(this, "m_clrGlow", buffer, sizeof(buffer));
	}

	public bool ApplyToEntity(int entity) // !Must pre check offset!
	{
		SetEntProp(entity, Prop_Send, "m_bShouldGlow", this.Status, true);
		SetEntProp(entity, Prop_Send, "m_nGlowStyle", this.Style);
		SetEntPropFloat(entity, Prop_Send, "m_flGlowMaxDist", this.MaxDist);

		int colors[3];
		this.GetColor(colors);
		for(int i = 0; i < 3 ; i++)
		{
			SetEntData(entity, GetEntSendPropOffs(entity, "m_clrGlow") + i, colors[i], _, true);
		}

		return true;
	}
}