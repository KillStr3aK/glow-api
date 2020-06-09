#if defined _glow_included
 #endinput
#endif
#define _glow_included

/**
 * Setup a simple glow for the given player that can be customized later. (Not saved, and hided.)
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
 * @param style         Glow style. 1 = Body Glow 0 = Outline
 * @param maxdist       Glow visible distance
 * @param keep          Keep player glow (Recreate it in new rounds, etc. To disable you must use Glow_SetClientKeep(client, false))
 * @param hide          Hide the glow from the player (leave it on false if you don't know what you're doin)
 * @return              True if glow is created, false otherwise.
 */
native bool Glow_SetupEx(int client, int colors[3] = {255, 0, 0}, int style = 1, float maxdist = 10000.0, bool keep = true, bool hide = false);

/**
 * Removes the glow from the player.
 *
 * @param client        Client index.
 * @noreturn
 */
native void Glow_Disable(int client);

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
 * @param client        Entity index.
 * @param state         New state.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetState(int entity, bool state);

/**
 * Change the glow style (0 - Outline, 1 - Body + Pulse, 2 = Outline V2, 3 = Outline V2 + Pulse).
 *
 * @param client        Entity index.
 * @param style         New style.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetStyle(int entity, int style);

/**
 * Change the glow maxdist.
 *
 * @param client        Entity index.
 * @param dist          New maxdist.
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetDist(int entity, float dist);

/**
 * Change the glow color.
 *
 * @param client        Entity index.
 * @param color         New color (RGB).
 * @return              Returns true if set, false if invalid entity.
 */
native bool Glow_SetColor(int entity, int color[3]);

/**
 * Change client keeping.
 *
 * @param client        Client index.
 * @param newvalue         New value. (If changing to false, data will be wiped in the next round.)
 * @noreturn
 */
native void Glow_SetClientKeep(int client, bool newvalue);

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