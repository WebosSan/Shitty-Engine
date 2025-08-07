package game.objects;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import game.backend.Conductor;
import game.scripting.events.EventDispatcher;
import game.scripting.events.IEventListener;
import game.scripting.events.sprites.AnimationEvent;
import game.scripting.events.sprites.DanceEvent;

class FunkinSprite extends FlxSprite implements IEventListener
{
	public var globalPosition:FlxPoint = new FlxPoint();
	public var offsets:Map<String, FlxPoint> = new Map();
	public var shouldDance:Bool = false;

	private var _currentOffset:FlxPoint = new FlxPoint(0, 0);

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		EventDispatcher.dispatchEvent(this, CREATE);
		Conductor.onBeat.add((b) -> EventDispatcher.dispatchEvent(this, BEAT));
		Conductor.onStep.add((b) -> EventDispatcher.dispatchEvent(this, STEP));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		EventDispatcher.dispatchEvent(this, UPDATE);
	}

	public function animationName():String
	{
		if (animation.name != null)
			return animation.name;
		else
			return "";
	}

	public function setAnimationByPrefix(name:String, prefix:String, framerate:Int, ?offset:FlxPoint, ?loop:Bool = false, ?flipX:Bool = false,
			?flipY:Bool = false)
	{
		this.animation.addByPrefix(name, prefix, framerate, loop, flipX, flipY);
		offsets.set(name, offset ?? new FlxPoint());
	}

	public function setAnimationByIndices(name:String, prefix:String, indices:Array<Int>, framerate:Int, ?offset:FlxPoint, ?loop:Bool = false,
			?flipX:Bool = false, ?flipY:Bool = false)
	{
		this.animation.addByIndices(name, prefix, indices, "", framerate, loop, flipX, flipY);
		offsets.set(name, offset ?? new FlxPoint());
	}

	public function playAnimation(name:String, ?force:Bool = false)
	{
		var event:AnimationEvent = new AnimationEvent(name, force);
		onPlayAnimation(event);
	}

	public function hasAnimation(prefix:String)
	{
		return animation.exists(prefix);
	}

	private var _danced:Bool = false;

	public function dance()
	{
		var event:DanceEvent = new DanceEvent();
		event.danced = _danced;
		onDance(event);
	}

	override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
	{
		var position:FlxPoint = super.getScreenPosition(result, camera);
		position.x -= _currentOffset.x * (flipX ? -1 : 1);
		position.y -= _currentOffset.y;
		position += globalPosition;
		return position;
	}

	public function onCreate(ev:CreateEvent) {}

	public function onUpdate(ev:UpdateEvent) {}

	public function onStep(ev:StepEvent) {}

	public function onBeat(ev:BeatEvent)
	{
		if (!ev.cancelled && shouldDance)
			dance();
	}

	public function onDance(ev:DanceEvent)
	{
		if (!ev.cancelled)
		{
			if (hasAnimation("danceLeft"))
			{
				playAnimation(_danced ? "danceLeft" : "danceRight");
				_danced = !_danced;
			}
			else
			{
				playAnimation("idle");
			}
		}
	}

	public function onPlayAnimation(ev:AnimationEvent)
	{
		if (!ev.cancelled)
		{
			this.animation.play(ev.name, ev.force);
			this._currentOffset = offsets.get(ev.name);
		}
	}
}
