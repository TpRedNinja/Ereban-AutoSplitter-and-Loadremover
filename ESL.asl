state("ErebanShadowLegacy")
{
    int Loading: "GameAssembly.dll", 0x03502018, 0xB8, 0x60, 0x290, 0x138; // 0 and 1 for loading and not loading respectively
    int MissionNumber: "GameAssembly.dll", 0x34F6828, 0xB8, 0x18, 0x38; // 0 when first loading up the game, 1 for mission 1 etc etc. -1 when in menu after being in a mission and leaving
    int MissionEndScreen: "UnityPlayer.dll", 0x01BD77C0, 0x5E0, 0x6C8, 0xC10, 0x840; // 0 when in a mission, 1 when on the mission end screen
}

startup
{
    vars.CompletedSplits = new List<string>();
    vars.Splits = new List<string>();
}

init
{
    vars.Splits = new List<string> 
    {
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
}

split
{
    if (current.MissionNumber > old.MissionNumber)
    {
        vars.CompletedSplits.Add(vars.Splits[0]);
        vars.Splits.RemoveAt(0);
        return true;
    }
}

onReset
{
    vars.Splits.Clear();
    vars.Splits = new List<string> 
    {
        "chapter 1",
        "chapter 2",
        "chapter 3",
        "chapter 4",
        "chapter 5",
        "chapter 6",
        "chapter 7"
    };
    vars.CompletedSplits.Clear();
}

isLoading
{
    // Pauses during loading screen and unpauses when out of loading screens
    return current.Loading == 1 || current.MissionEndScreen == 1;
}
