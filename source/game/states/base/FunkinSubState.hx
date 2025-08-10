package game.states.base;

import flixel.FlxSubState;
import game.backend.Conductor;

class FunkinSubState extends FlxSubState
{
	private var currentStep:Int = 0;
	private var currentBeat:Int = 0;

	public function new()
	{
		super();
	}

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
