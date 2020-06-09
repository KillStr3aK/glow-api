enum struct PlayerGlow {
	int Reference;
	int Index;

	int Style;
	bool State;
	bool Keep;
	float MaxDist;
	int Color[3];

	void Reset(bool all = true)
	{
		this.Reference = INVALID_ENT_REFERENCE;
		this.Index = -1;
		if(all)
		{
			this.Style = 0;
			this.State = false;
			this.MaxDist = 100.0;
			for(int i = 0; i < 3; i++) this.Color[i] = 0;
		}
	}
}

PlayerGlow pg[MAXPLAYERS+1];
GlobalForward gfOnSetup;
GlobalForward gfOnDisable;