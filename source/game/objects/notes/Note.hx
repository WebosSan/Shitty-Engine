package game.objects.notes;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import game.backend.Conductor;
import game.backend.Paths;
import game.backend.Settings;

class Note extends FlxSpriteGroup
{
	// Head, Body, Tail
	public static var noteAnimations:Array<Array<String>> = [
		["purple0", "purple hold piece", "pruple end hold"],
		["blue0", "blue hold piece", "blue hold end"],
		["green0", "green hold piece", "green hold end"],
		["red0", "red hold piece", "red hold end"]
	];

	public var head:FlxSprite;
	public var body:Trail;
	public var tail:FlxSprite;

	public var lane:Int;
	public var duration:Float;
	public var strum:Float;

	private var _ogDuration:Float;

	private var _targetSize:Float;

	public var target:FlxSprite;

	public function new(lane:Int, strum:Float, ?duration:Float = 0, ?targetSize:Int)
	{
		super();

		this.strum = strum;
		this.duration = duration;
		this.lane = lane;
		_ogDuration = this.duration;

		head = new FlxSprite();
		head.frames = Paths.sparrow('ui/notes/NOTE_assets');
		head.animation.addByPrefix("idle", noteAnimations[lane][0]);
		targetSize = (targetSize == null ? Std.int(head.width * 0.7) : targetSize);
		_targetSize = targetSize;
		head.setGraphicSize(Std.int(targetSize));
		head.animation.play("idle");
		head.updateHitbox();

		body = new Trail(0, head.width);
		body.frames = head.frames;
		body.animation.addByPrefix("idle", noteAnimations[lane][1]);
		body.setGraphicSize(Std.int(targetSize));
		body.animation.play("idle");
		body.updateHitbox();

		tail = new FlxSprite(0, body.y + body.width);
		tail.frames = head.frames;
		tail.animation.addByPrefix("idle", noteAnimations[lane][2]);
		tail.setGraphicSize(Std.int(targetSize));
		tail.animation.play("idle");
		tail.updateHitbox();
		add(body);
		add(tail);
		add(head);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		body.visible = duration > 0;
		tail.visible = duration > 0;

		if (duration > 0)
		{
			tail.setPosition(body.x, head.y + duration * (0.45 * Settings.currentSpeed));

			body.setGraphicSize(body.width, tail.y - head.y);
			body.updateHitbox();
			body.setPosition(head.x + (head.width / 2 - body.width / 2), head.y);
		}
		if (target != null)
		{
			this.x = target.x;
			this.y = target.y + (this.strum - Conductor.time) * (0.45 * Settings.currentSpeed);
		}
	}
}

class Trail extends FlxSprite
{
	override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
	{
		var pos:FlxPoint = super.getScreenPosition(result, camera);
		pos.y += 5;
		return pos;
	}
}
