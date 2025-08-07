package game.scripting;

import game.backend.Paths;
import hscript.Expr.ModuleDecl;
import rulescript.RuleScript.IInterp;
import rulescript.RuleScript;
import rulescript.interps.BytecodeInterp;
import rulescript.interps.RuleScriptInterp;
import rulescript.parsers.HxParser;
import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.types.ScriptedTypeUtil;

class ScriptDefines
{
	public static function recover()
	{
		RuleScript.createInterp = defaultInterp;
		ScriptedTypeUtil.resolveModule = resolveModule;
	}

	@:noCompletion
	public static function defaultInterp():IInterp
	{
		var interp:RuleScriptInterp = new RuleScriptInterp();

		interp.variables.set('String', String);
		interp.variables.set('Int', Int);
		interp.variables.set('Float', Float);
		interp.variables.set('Bool', Bool);
		interp.variables.set('Dynamic', Dynamic);

		interp.variables.set('Array', Array);
		interp.variables.set('List', List);

		interp.variables.set('Math', Math);
		interp.variables.set('Std', Std);
		interp.variables.set('Type', Type);
		interp.variables.set('Reflect', Reflect);

		interp.variables.set('Date', Date);
		interp.variables.set('DateTools', DateTools);

		#if sys
		interp.variables.set('Sys', Sys);
		#end

		return interp;
	}

	@:noCompletion
	public static function resolveModule(name:String):Array<ModuleDecl>
	{
		var path:Array<String> = name.split('.');

		var pack:Array<String> = [];

		while (path[0].charAt(0) == path[0].charAt(0).toLowerCase())
			pack.push(path.shift());

		var moduleName:String = null;

		if (path.length > 1)
			moduleName = path.shift();

		var filePath = '${(pack.length >= 1 ? pack.join('.') + '.' + (moduleName ?? path[0]) : path[0]).replace('.', '/')}.hx';

		if (!Paths.exists(Paths.getPath(filePath)))
			return null;

		var parser = new HxParser();
		parser.allowAll();
		parser.mode = MODULE;

		var content:String = Paths.getText(filePath, "");

		return parser.parseModule(content);
	}
}
