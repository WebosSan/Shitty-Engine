package game.scripting;

import rulescript.RuleScript;
import rulescript.RuleScriptAccess;
import rulescript.interps.RuleScriptInterp;
import rulescript.scriptedClass.RuleScriptedClass;
import rulescript.types.ScriptedType;
import rulescript.types.ScriptedTypeUtil;

class ScriptUtil {
    public static function changeScriptName(name:String) {
        RuleScript.createInterp = () -> {
            var interp:RuleScriptInterp = new RuleScriptInterp();
            interp.scriptName = name;
            return interp;
        }
    }
}