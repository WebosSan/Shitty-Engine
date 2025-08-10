package game.substates;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;
import game.states.base.FunkinSubState;

class LoadingSubstate extends FunkinSubState
{
	public var camGame:FlxCamera;

	override function create()
	{
		super.create();

		camGame = new FlxCamera();
		camGame.bgColor = FlxColor.BLACK;
		FlxG.cameras.add(camGame);
	}
}
