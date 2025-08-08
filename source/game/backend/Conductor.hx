package game.backend;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxSignal.FlxTypedSignal;

class Conductor
{
	public static var offset:Float = 0;

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

		__computeTime(dt);

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
	public static var rawTime(get, never):Float;

	public static function get_rawTime()
		return FlxG.sound.music.time;

	private static var __lastRawTime:Float = -1;
	private static var __lastTime:Float = -1;

	private static var __lastLatency:Float = -1;

	// Using theodevelops time interpolation https://github.com/TheoDevelops/VSRG-Flixel/blob/main/source/vsrg/core/audio/Playback.hx#L101
	private static function __computeTime(elapsed:Float)
	{
		if (FunkinGame.paused || !FlxG.sound.music.playing)
		{
			time = FlxG.sound.music.time;
			return;
		}

		if (__lastRawTime != rawTime)
		{
			__lastLatency = rawTime - __lastRawTime;

			time = rawTime + offset;
		}
		else
		{
			var latency = __lastRawTime - rawTime;
			time += elapsed * 1000 * (20 / __lastLatency);
		}

		__lastRawTime = rawTime;
		__lastTime = time;
	}
}
