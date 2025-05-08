state("ErebanShadowLegacy")
{
    //bools
    int Loading: "GameAssembly.dll", 0x03502018, 0xB8, 0x60, 0x290, 0x138; // 0 and 1 for loading and not loading respectively
    int MissionNumber: "GameAssembly.dll", 0x34F6828, 0xB8, 0x18, 0x38; // 0 when first loading up the game, 1 for mission 1 etc etc. -1 when in menu after being in a mission and leaving
    int MissionEndScreen: "UnityPlayer.dll", 0x01BD77C0, 0x5E0, 0x6C8, 0xC10, 0x840; // 0 when in a mission, 1 when on the mission end screen
    int Cutscene: "UnityPlayer.dll", 0x01CD7320, 0x298, 0x428, 0x210, 0x0, 0x40, 0x380; // 0 when not in a cutscene, 1 when in a cutscene & dialogue
    int Destroy: "GameAssembly.dll", 0x03523648, 0xB8, 0x0, 0x70, 0x48; //0 when not the destroy echo option is chosen and 1 when it is chosen
    //totals
    int shadoworb: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x10; //tracks total number of shadow orbs available
    int techcard: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x14; //tracks total number of tech cards available
    int catalyzer: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x18; //tracks total number of catalyzers available
    int SymsKilled: "GameAssembly.dll", 0x034FAC30, 0x760, 0x28, 0xAC; //tracks total number of syms killed in each level
    //Todo:
    // find pointers for save ending and join ending
    //int Save:; // 0 when not the save echo option is chosen and 1 when it is chosen
    //int Join:; // 0 when not the join helios option is chosen and 1 when it is chosen

}

startup
{
    vars.CompletedSplits = new List<string>();
    vars.Splits = new List<string>();
    settings.Add("100%", false, "100%");
    settings.SetToolTip("100%", "Splits on gainning a shadow orb, tech card, & catalyzer.");
    settings.Add("orb splits", false);
    settings.SetToolTip("orb splits", "Splits on gaining a shadow orb.");
    settings.Add("tech splits", false);
    settings.SetToolTip("tech splits", "Splits on gaining a tech card.");
    settings.Add("catalyzer splits", false);
    settings.SetToolTip("catalyzer splits", "Splits on gaining a catalyzer.");
    settings.Add("Split 1", false, "Split 1");
    settings.SetToolTip("Split 1", "Splits on level end screen.");
    settings.Add("Split 2", false, "Split 2");
    settings.SetToolTip("Split 2", "Splits during loading screen to next level.");

    //asl help
    //Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    //vars.Helper.GameName = "Ereban: Shadow Legacy";

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
        "chapter 7",
        "Destroy Echo",
    };

    //vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    //{
    //    return true;
    //});
}

start
{
    if (current.Cutscene == 0 && old.Cutscene == 1)
    {
        return true;
    }
}

split
{
    if (current.MissionNumber > old.MissionNumber && settings["Split 1"])
    {
        vars.CompletedSplits.Add(vars.Splits[0]);
        vars.Splits.RemoveAt(0);
        return true;
    }

    if (current.MissionEndScreen == 1 && old.MissionEndScreen == 0 && settings["Split 2"])
    {
        vars.CompletedSplits.Add(vars.Splits[0]);
        vars.Splits.RemoveAt(0);
        return true;
    }

    if (current.Destroy == 1 && old.Destroy == 0 && current.MissionNumber == 8 && current.Cutscene == 1)
    {
        vars.CompletedSplits.Add(vars.Splits[0]);
        vars.Splits.RemoveAt(0);
        return true;
    }

    if (settings["100%"] && (current.shadoworb > old.shadoworb || current.techcard > old.techcard || current.catalyzer > old.catalyzer) && current.Loading == 0)
    {
        return true;
    }

    if (settings["orb splits"] && current.shadoworb > old.shadoworb && current.Loading == 0)
    {
        return true;
    }

    if (settings["tech splits"] && current.techcard > old.techcard && current.Loading == 0)
    {
        return true;
    }

    if (settings["catalyzer splits"] && current.catalyzer > old.catalyzer && current.Loading == 0)
    {
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
        "chapter 7",
        "Destroy Echo",
    };
    vars.CompletedSplits.Clear();
}

isLoading
{
    // Pauses during loading screen and unpauses when out of loading screens
    return current.Loading == 1 || current.MissionEndScreen == 1 || current.Cutscene == 1;
}
