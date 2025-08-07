package game.states.base;

import flixel.FlxState;
import game.backend.Conductor;

class FunkinState extends FlxState
{
	private var currentStep:Int = 0;
	private var currentBeat:Int = 0;

	override function create()
	{
		super.create();
        Conductor.onBeat.add(onBeat);
        Conductor.onBeat.add(onStep);
	}

	override function update(elapsed:Float)
	{
		currentBeat = Conductor.currentBeat;
		currentStep = Conductor.currentStep;
		super.update(elapsed);
	}

	function onBeat(beat:Int) {}

	function onStep(step:Int) {}
}
