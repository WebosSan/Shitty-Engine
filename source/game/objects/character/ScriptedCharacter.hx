package game.objects.character;

import game.scripting.ScriptDefines;
import game.scripting.ScriptUtil;
import rulescript.scriptedClass.RuleScriptedClass;

@:ignoreFields([stringArray, typedFunction])
@:strictScriptedConstructor
class ScriptedCharacter extends Character implements RuleScriptedClass
{
	public static function createCharacter(id:String, ?isPlayer:Bool = false, ?x:Float = 0, ?y:Float = 0):ScriptedCharacter
	{
		var character:ScriptedCharacter;
		var path:String = 'data.characters.$id.CharacterScript';
		if (!Paths.exists(Paths.getPath(path.replace(".", "/") + ".hx")))
		{
			path = 'data.scripts.placeholders.CharacterPlaceholder';
			if (!Paths.exists(Paths.getPath(path.replace(".", "/") + ".hx")))
			{
				return null;
			}
		} else {
			ScriptUtil.changeScriptName(path.replace('.', '/') + ".hx");
		}
		character = new ScriptedCharacter(path, x, y, id, isPlayer);
		ScriptDefines.recover();
		return character;
	}
}
