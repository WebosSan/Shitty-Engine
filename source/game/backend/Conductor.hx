package game.backend;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxSignal.FlxTypedSignal;

class Conductor
{
	public static var bpm(default, set):Float = 0;
	public static var stepTime:Float = 0;
	public static var beatTime:Float = 0;
	public static var stepsPerBeat:Float = 4;

	public static var currentStep:Int = 0;
	public static var currentBeat:Int = 0;

	public static var time(default, set):Float = 0;
	public static var length:Float = 0;
	public static var totalSteps:Int = 0;
	public static var totalBeats:Int = 0;

	public static var onBeat:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public static var onStep:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	public static var onGlobalBeat:FlxTypedSignal<Int->Void> = new FlxTypedSignal();
	public static var onGlobalStep:FlxTypedSignal<Int->Void> = new FlxTypedSignal();

	public static function changeSong(path:FlxSoundAsset, bpm:Float)
	{
		Conductor.bpm = bpm;
		FlxG.sound.playMusic(path);
		length = FlxG.sound.music.length;
		totalSteps = Math.ceil(length / stepTime);
		totalBeats = Math.ceil(length / beatTime);
	}

	private static var _currentBeat:Float = 0;
	private static var _currentStep:Float = 0;

	public static function update(dt:Float)
	{
		if (FlxG.sound.music == null)
			return;

		_currentStep = time / stepTime;
		_currentBeat = time / beatTime;

		// i wanna test this
		if (currentStep != Math.floor(_currentStep))
		{
			onGlobalStep.dispatch(Math.floor(_currentStep));
			onStep.dispatch(Math.floor(_currentStep));
		}

		if (currentBeat != Math.floor(_currentBeat))
		{
			onGlobalBeat.dispatch(Math.floor(_currentBeat));
			onBeat.dispatch(Math.floor(_currentBeat));
		}

		currentStep = Math.floor(_currentStep);
		currentBeat = Math.floor(_currentBeat);
	}

	// it works i guess
	public static function calculateTime()
	{
		var rawTime:Float = 0;

		if (FlxG.sound.music != null)
		{
			rawTime = FlxG.sound.music.time;
		}

		if (FunkinGame.paused)
			time = time;
		else
			time = time + (rawTime - time) * 0.1;
	}

	private static function set_bpm(value:Float):Float
	{
		if (value == 0)
		{
			beatTime = 0;
			stepTime = 0;
		}
		else
		{
			beatTime = (60000 / value);
			stepTime = beatTime / stepsPerBeat;
		}
		return bpm = value;
	}

	private static function set_time(v:Float) {
		return time = v;
	}

	public static function setTime(value:Float) {
		FlxG.sound.music.time = FlxMath.bound(value, 0, length);
		time = FlxMath.bound(value, 0, length);
	}
}
