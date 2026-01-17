@wrapMethod(W3LevelManager) function AddPoints(type : ESpendablePointType, amount : int, show : bool) {
    var xpScale : float = GetXPScale(); 
    if (type == EExperiencePoint) {
        amount = RoundF(amount * xpScale);
    }
    
    wrappedMethod(type, amount, show);
}

@addMethod(W3LevelManager) function GetXPScale() : float {
    var XPReduction: float = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'XPScale'), 0.0);
    return 1 - (XPReduction / 100);
}

@wrapMethod(CR4Game) function PopulateMenuQueueMainAlways(out menus: array<name>) 
{
    wrappedMethod(menus);
    if (!theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'XPScale_Init')) {
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPScale_Init', true);
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPScale', 0);
    }
}