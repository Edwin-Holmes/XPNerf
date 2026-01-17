@wrapMethod(W3LevelManager) function AddPoints(type : ESpendablePointType, amount : int, show : bool) {
    var xpScale         : float; 
    var relativeLevel   : int; 

    if (type == EExperiencePoint) {
        if (FactsQuerySum("NewGamePlus") > 0) {
            relativeLevel= (GetLevel() - theGame.params.GetNewGamePlusLevel()) + 1; // Treat NG+ starting level as 1

            if (relativeLevel <= 10) {
                xpScale = GetXPScale("Low");
            } else if (relativeLevel <= 20) {
                xpScale = GetXPScale("Mid");
            } else {
                xpScale = GetXPScale("High");
            }
        } else {
            if (GetLevel() <= 10) {
                xpScale = GetXPScale("Low");
            } else if (GetLevel() <= 20) {
                xpScale = GetXPScale("Mid");
            } else {
                xpScale = GetXPScale("High");
            }
        }

        amount = RoundF(amount * xpScale);
    }

    wrappedMethod(type, amount, show);
}

function GetXPScale(band : string) : float {
    var val : float = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'XPScale_' + band), 1.0);
    return 1 - (val / 100);
}