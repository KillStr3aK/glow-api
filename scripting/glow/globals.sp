enum struct PlayerGlow {
	int Reference;
	int Index;

	int Style;
	bool State;
	bool Hide;
	float MaxDist;
	int Color[3];

	ArrayList Exclude;

	void Reset()
	{
		this.Reference = INVALID_ENT_REFERENCE;
		this.Index = -1;
		this.Style = 0;
		this.State = false;
		this.MaxDist = 100.0;
		for(int i = 0; i < 3; i++) { this.Color[i] = 0; }
		this.Hide = false;
		delete this.Exclude;
	}
}

enum struct EntityGlow {
	int Reference;
	int Index;

	char Style[3];
	char Color[12];
	char MaxDist[12];

	ArrayList Exclude;

	void Reset()
	{
		this.Reference = INVALID_ENT_REFERENCE;
		this.Index = -1;
		this.Style = NULL_STRING;
		this.Color = NULL_STRING;
		this.MaxDist = NULL_STRING;
		delete this.Exclude;
	}
}

PlayerGlow pg[MAXPLAYERS+1];
EntityGlow eg[2048];
GlobalForward gfOnSetup;
GlobalForward gfOnDisable;