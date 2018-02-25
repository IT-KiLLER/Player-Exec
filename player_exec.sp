
/*	Copyright (C) 2018 IT-KiLLER
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include <sourcemod>
#pragma semicolon 1
#pragma newdecls required

int PlayerModeSaved = -1;
ConVar g_Cvar_player_exec;

public Plugin myinfo =
{
	name = "Player Exec",
	author = "IT-KiLLER",
	description = "Various cfg depending on players.",
	version = "1.0 pre-release",
	url = "https://github.com/IT-KiLLER"
}

public void OnPluginStart()
{
	HookEvent("round_start", execConfig, EventHookMode_PostNoCopy);
	g_Cvar_player_exec = CreateConVar("sm_player_exec", "10", "Interval step.", 0, true, 0.00, true, 64.0);
}

public void OnMapStart()
{
	PlayerModeSaved = -1;
}

public void execConfig(Event event, const char[] name, bool dontBroadcast)
{
	int currentPlayers = playerCount();
	char file[PLATFORM_MAX_PATH];

	if(PlayerModeSaved == PlayerMode(currentPlayers) || !g_Cvar_player_exec.BoolValue) return;
	PlayerModeSaved = PlayerMode(currentPlayers);
	
	// Add your custom rules here
	switch(PlayerModeSaved)
	{
		case 0: FormatEx(file, sizeof(file), "player_exec/round_default.cfg");
		default : FormatEx(file, sizeof(file), "player_exec/round_%dp.cfg", PlayerModeSaved);
	}

	ServerCommand("exec %s", file);
	/*
	if(FileExists(file))
	{
		ServerCommand("exec %s", file);
	}
	else
	{
		PrintToChatAll("[Player Exec] The file is missing: %s", file);
		LogMessage("The file is missing: %s", file);
	}*/
}

stock int PlayerMode(int n) 
{
	//return (n + 4) / 5 * 5;
	return (RoundToFloor(n/g_Cvar_player_exec.FloatValue)*g_Cvar_player_exec.IntValue);
}

stock int playerCount()
{
	int players = 0;
	for(int client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client) && IsPlayerAlive(client))
		{
			players++;
		}
	}
	return players;
}