state("ErebanShadowLegacy")
{
    int Loading: "GameAssembly.dll", 0x03502018, 0xB8, 0x60, 0x290, 0x138;
    int MissionEndScreen: "UnityPlayer.dll", 0x01BD77C0, 0x5E0, 0x6C8, 0xC10, 0x840;
}

startup
{
    vars.CompletedSplits = new List<string>();
    vars.HasSplit = false;
    vars.InMission = false;
}

init
{
    vars.Splits = new List<string> {
        "chapter 1",
        "chapter 2",
        "chapter 3",
        "chapter 4",
        "chapter 5",
        "chapter 6",
        "chapter 7"
    };
}

update
{
    // Determine if the player is in a mission based on the loading screen status
    if (current.Loading == 0 && old.Loading == 1) 
    {
        vars.InMission = true;
        vars.HasSplit = false; // Reset the split flag when entering a new mission
    }
    
    if (current.Loading == 1 && old.Loading == 0) 
    {
        vars.InMission = false;
    }
}

split
{
    // Ensure we only split when we are in a mission
    if (vars.InMission && vars.Splits.Count > 0) 
    {
        // Splits upon mission end screen appearing
        if (current.MissionEndScreen == 1 && old.MissionEndScreen == 0) 
        {
            if (!vars.HasSplit) 
            {
                vars.HasSplit = true;
                
                // Move the first item from vars.Splits to vars.CompletedSplits
                vars.CompletedSplits.Add(vars.Splits[0]);
                vars.Splits.RemoveAt(0);
                
                return true;
            }
        }
        
        // Reset the split flag when the mission end screen is no longer active
        if (current.MissionEndScreen == 0 && old.MissionEndScreen == 1) {
            vars.HasSplit = false;
        }
    }
}

onReset
{
    vars.Splits = new List<string> {
        "chapter 1",
        "chapter 2",
        "chapter 3",
        "chapter 4",
        "chapter 5",
        "chapter 6",
        "chapter 7"
    };
    vars.CompletedSplits.Clear();
    vars.HasSplit = false;
    vars.InMission = false;
}

isLoading
{
    // Pauses during loading screen and unpauses when out of loading screens
    return current.Loading == 1;
}
