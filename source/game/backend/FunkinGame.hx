package game.backend;

import flixel.FlxG;
import flixel.FlxGame;
import haxe.Timer;
import openfl.events.Event;

class FunkinGame extends FlxGame
{
	public static var paused:Bool = false;

	private var timeTimer:Timer;
	override function create(_:Event)
	{
		super.create(_);
		timeTimer = new Timer(10);
		timeTimer.run = Conductor.calculateTime;
		timeTimer.run();

		FlxG.signals.focusGained.add(() -> paused = false);
		FlxG.signals.focusLost.add(() -> paused = true);
	}

	override function switchState()
	{
		Settings.currentSpeed = 1;
        Conductor.onBeat.removeAll();
        Conductor.onStep.removeAll();
		super.switchState();
	}

	override function update()
	{
		super.update();
		Conductor.update(FlxG.elapsed);
	}
}
