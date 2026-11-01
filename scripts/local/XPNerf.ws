@wrapMethod(W3LevelManager) function AddPoints(type : ESpendablePointType, amount : int, show : bool) {
    var menu            : CInGameConfigWrapper = theGame.GetInGameConfigWrapper();
    var xpScale         : float; 
    var relativeLevel   : int; 
    var limitLow        : int = StringToInt(menu.GetVarValue('NerfXP', 'BandLimitLow'), 10);
    var limitMid        : int = StringToInt(menu.GetVarValue('NerfXP', 'BandLimitMid'), 20);
    var roundUp         : bool = menu.GetVarValue('NerfXP', 'RoundUp');
    var xpFloor         : bool = menu.GetVarValue('NerfXP', 'XpFloor');

    if (type == EExperiencePoint) {
        if (FactsQuerySum("NewGamePlus") > 0) {
            relativeLevel = (GetLevel() - theGame.params.GetNewGamePlusLevel()) + 1; // Treat NG+ starting level as 1

            if (relativeLevel <= limitLow) {
                xpScale = GetXPScale('XPScaleLow');
            } else if (relativeLevel <= limitMid) {
                xpScale = GetXPScale('XPScaleMid');
            } else {
                xpScale = GetXPScale('XPScaleHigh');
            }
        } else {
            if (GetLevel() <= limitLow) {
                xpScale = GetXPScale('XPScaleLow');
            } else if (GetLevel() <= limitMid) {
                xpScale = GetXPScale('XPScaleMid');
            } else {
                xpScale = GetXPScale('XPScaleHigh');
            }
        }

        if (roundUp) {
            amount = CeilF(amount * xpScale);
        }
        else {
            amount = RoundF(amount * xpScale);
        }

        if (xpFloor) {
            if (amount == 0) amount = 1;
        }
    }

    wrappedMethod(type, amount, show);
}

@wrapMethod(CR4IngameMenu) function OnClosingMenu() {
    var limitLow : int = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'BandLimitLow'), 10);
    var limitMid : int = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'BandLimitMid'), 20);

    if (limitMid < limitLow) {
        limitMid = limitLow;
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'BandLimitMid', IntToString(limitMid));
    }

    wrappedMethod();
}

function GetXPScale(varName : name) : float {
    var val : float = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', varName), 0.0);
    return 1 - (val / 100);
}

@wrapMethod(CR4Game) function PopulateMenuQueueMainAlways(out menus: array<name>) {
    wrappedMethod(menus);
    XPNerfInit();
}

function XPNerfInit() {
    if (theGame.GetInGameConfigWrapper().GetVarValue('NerfXP', 'XPNerfInit') != "true") {
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPScaleLow', "0");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPScaleMid', "0");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPScaleHigh', "0");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'BandLimitLow', "10");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'BandLimitMid', "20");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'RoundUp', "false");
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XpFloor', "false");
        
        theGame.GetInGameConfigWrapper().SetVarValue('NerfXP', 'XPNerfInit', "true");
    }
}