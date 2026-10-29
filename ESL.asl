state("ErebanShadowLegacy")
{
    //bools
    int Loading: "GameAssembly.dll", 0x03502018, 0xB8, 0x60, 0x290, 0x138; // 0 and 1 for loading and not loading respectively
    int MissionNumber: "GameAssembly.dll", 0x34F6828, 0xB8, 0x18, 0x38; // 0 when first loading up the game, 1 for mission 1 etc etc. -1 when in menu after being in a mission and leaving
    int MissionEndScreen: "UnityPlayer.dll", 0x01BD77C0, 0x5E0, 0x6C8, 0xC10, 0x840; // 0 when in a mission, 1 when on the mission end screen
    int Cutscene: "UnityPlayer.dll", 0x01CD7320, 0x298, 0x428, 0x210, 0x0, 0x40, 0x380; // 0 when not in a cutscene, 1 when in a cutscene & dialogue
    //totals
    //int ShadowOrb: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x10; //tracks total number of shadow orbs available
    //int TechCard: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x14; //tracks total number of tech cards available
    //int Catalyzer: "GameAssembly.dll", 0x350C810, 0xB8, 0x30, 0x28, 0x18; //tracks total number of catalyzers available
    int SymsKilled: "GameAssembly.dll", 0x034FAC30, 0x760, 0x28, 0xAC; //tracks total number of syms killed in each level
}

startup
{
    vars.CompletedSplits = new List<string>();
    vars.Splits = new List<string>();
    settings.Add("100%", false, "100%");
    settings.SetToolTip("100%", "Splits on gaining a shadow orb, tech card, & catalyzer.");
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

    //asl help & uhara
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
    vars.Helper.GameName = "Ereban: Shadow Legacy";

}

init
{
    vars.Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    vars.Instance.Watch<int>("ShadowOrb", "REFS", "PlayerController", "cPlayerCollectableInventory", "_gameplayCollectablesAvailables", "shadowOrbsAvailables");
    vars.Instance.Watch<int>("TechCard", "REFS", "PlayerController", "cPlayerCollectableInventory", "_gameplayCollectablesAvailables", "techCardsAvailables");
    vars.Instance.Watch<int>("Catalyzer", "REFS", "PlayerController", "cPlayerCollectableInventory", "_gameplayCollectablesAvailables", "catalyzersAvailables");
    vars.Instance.Watch<int>("FinalChoice", "EndingCutsceneController", "_choiceSelected");
    vars.Instance.Watch<bool>("IsGameEnding", "GameSFXController", "_isGameEndingRunning");
    //Sequel ending cutscenes
    vars.Instance.Watch<bool>("SequelEnding1", "EndingCutsceneController", "sequelNonLethalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("SequelEnding2", "EndingCutsceneController", "sequelSomeLethalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("SequelEnding3", "EndingCutsceneController", "sequelFinalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("SequelEnding4", "EndingCutsceneController", "sequelNonLethal2DEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("SequelEnding5", "EndingCutsceneController", "sequelSomeLethal2DEndingCinematic;", "isPlayingCutscene");
    //Ereban ending cutscenes
    vars.Instance.Watch<bool>("ErebanEnding1", "EndingCutsceneController", "erebanNonLethalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("ErebanEnding2", "EndingCutsceneController", "erebanSomeLethalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("ErebanEnding3", "EndingCutsceneController", "erebanFinalEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("ErebanEnding4", "EndingCutsceneController", "erebanNonLethal2DEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("ErebanEnding5", "EndingCutsceneController", "erebanSomeLethal2DEndingCinematic", "isPlayingCutscene");
    //Helios ending cutscene
    vars.Instance.Watch<bool>("HeliosEnding", "EndingCutsceneController", "heliosEndingCinematic", "isPlayingCutscene");
    //Blood ending cutscenes
    vars.Instance.Watch<bool>("BloodEnding1", "EndingCutsceneController", "bloodEndingCinematic", "isPlayingCutscene");
    vars.Instance.Watch<bool>("BloodEnding2", "EndingCutsceneController", "blood2DEndingCinematic", "isPlayingCutscene");
    
    
    vars.HasMadeChoice = false;
    vars.FinalCinematicRunning = false;
    vars.Splits = new List<string> 
    {
        "chapter 1",
        "chapter 2",
        "chapter 3",
        "chapter 4",
        "chapter 5",
        "chapter 6",
        "chapter 7",
        "FinalChoice",
    };



}

update
{
    vars.Uhara.Update();
    vars.Helper.MapPointers();
    vars.SequelEnding =  current.SequelEnding1 || current.SequelEnding2 || current.SequelEnding3 || current.SequelEnding4 || current.SequelEnding5;
    vars.ErebanEnding = current.ErebanEnding1 || current.ErebanEnding2 || current.ErebanEnding3 || current.ErebanEnding4 || current.ErebanEnding5;
    vars.BloodEnding = current.BloodEnding1 || current.BloodEnding2;
    vars.FinalCinematicRunning = vars.SequelEnding || vars.ErebanEnding || current.HeliosEnding || vars.BloodEnding;
    if (current.FinalChoice >= 0 && current.FinalChoice <= 2 && !vars.HasMadeChoice && vars.FinalCinematicRunning && current.IsGameEnding)
    {
        vars.HasMadeChoice = true;
    }

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

    if (vars.HasMadeChoice && current.MissionNumber == 8)
    {
        vars.CompletedSplits.Add(vars.Splits[0]);
        vars.Splits.RemoveAt(0);
        return true;
    }

    if (settings["100%"] && (current.ShadowOrb > old.ShadowOrb || current.TechCard > old.TechCard || current.Catalyzer > old.Catalyzer))
    {
        return true;
    }

    if (settings["orb splits"] && current.ShadowOrb > old.ShadowOrb)
    {
        return true;
    }

    if (settings["tech splits"] && current.TechCard > old.TechCard)
    {
        return true;
    }

    if (settings["catalyzer splits"] && current.Catalyzer > old.Catalyzer)
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
        "FinalChoice",
    };
    vars.CompletedSplits.Clear();
}

isLoading
{
    // Pauses during loading screen and unpauses when out of loading screens
    return current.Loading == 1 || current.MissionEndScreen == 1 || current.Cutscene == 1;
}
