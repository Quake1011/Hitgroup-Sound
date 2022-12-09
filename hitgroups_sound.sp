#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{ 
	name = "Hitgroup Sound", 
	author = "Palonez", 
	description = "Hitgroup sound", 
	version = "1.0", 
	url = "https://github.com/Quake1011/" 
};

char sSounds[8][PLATFORM_MAX_PATH];

public void OnPluginStart()
{
	HookEvent("player_hurt", PlayerHurt);

	char sPath[PLATFORM_MAX_PATH];
	KeyValues kv = CreateKeyValues("HGSound");
	BuildPath(Path_SM, sPath, sizeof(sPath), "configs/hgSound.ini");
	if(kv.ImportFromFile(sPath) && kv.GotoFirstSubKey())
	{
		kv.Rewind();
		kv.GetString("head", sSounds[0], sizeof(sSounds[]));
		kv.GetString("chest", sSounds[1], sizeof(sSounds[]));
		kv.GetString("belly", sSounds[2], sizeof(sSounds[]));
		kv.GetString("leftarm", sSounds[3], sizeof(sSounds[]));
		kv.GetString("rightarm", sSounds[4], sizeof(sSounds[]));
		kv.GetString("leftleg", sSounds[5], sizeof(sSounds[]));
		kv.GetString("rightleg", sSounds[6], sizeof(sSounds[]));
		kv.GetString("neck", sSounds[7], sizeof(sSounds[]));
	}
	delete kv;
}

public void OnMapStart()
{
	for(int i = 0; i < sizeof(sSounds); i++)
	{
		AddFileToDownloadsTable(sSounds[i]);
		PrecacheSound(sSounds[i], true);
		ReplaceStringEx(sSounds[i], sizeof(sSounds[]), "sound/", "*", true);
	}
}

public void PlayerHurt(Event hEvent, const char[] sEvent, bool bdb)
{
	int iUserID = GetClientOfUserId(hEvent.GetInt("userid"));
	if(0 < iUserID <= MaxClients && !IsFakeClient(iUserID) && IsClientInGame(iUserID))
	{
		int group = hEvent.GetInt("hitgroup");
		if(0 < group < 9)
		{
			switch(group)
			{
				case 1: ClientCommand(iUserID, "playgamesound %s", sSounds[0]);	//голова
				case 2:	ClientCommand(iUserID, "playgamesound %s", sSounds[1]);	//грудь
				case 3:	ClientCommand(iUserID, "playgamesound %s", sSounds[2]);	//живот
				case 4:	ClientCommand(iUserID, "playgamesound %s", sSounds[3]);	//левая рука
				case 5: ClientCommand(iUserID, "playgamesound %s", sSounds[4]); //правая рука
				case 6:	ClientCommand(iUserID, "playgamesound %s", sSounds[5]);	//левая нога
				case 7:	ClientCommand(iUserID, "playgamesound %s", sSounds[6]);	//правая нога
				case 8:	ClientCommand(iUserID, "playgamesound %s", sSounds[7]);	//шея
			}
		}
	}
}