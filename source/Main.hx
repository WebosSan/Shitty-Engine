package;

import flixel.util.typeLimit.NextState.InitialState;
import game.backend.Settings;
import game.objects.Game;
import game.scripting.ScriptDefines;
import openfl.display.Sprite;
import openfl.events.Event;

// today i dont sleep
class Main extends Sprite
{
	private static var targetWidth:Int = 1280;
	private static var targetHeight:Int = 720;
	private static var targetFps:Int = 60;
	private static var targetState:InitialState;

	public function new()
	{
		super();
		ScriptDefines.recover();
		Settings.init();
		addEventListener(Event.ADDED_TO_STAGE, onInit);
	}

	public function onInit(_)
	{
		Game.initGame();
	}
}
