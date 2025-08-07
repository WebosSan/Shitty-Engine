package game.objects.notes;

import flixel.FlxCamera;
import flixel.FlxSprite;
import game.backend.Conductor;
import game.backend.Paths;
import game.backend.Settings;

class Note extends FlxSprite
{
	// Head, Body, Tail
	public static var noteAnimations:Array<Array<String>> = [
		["purple0", "purple hold piece", "pruple end hold"],
		["blue0", "blue hold piece", "blue hold end"],
		["green0", "green hold piece", "green hold end"],
		["red0", "red hold piece", "red hold end"]
	];

	public var body:FlxSprite;
	public var tail:FlxSprite;

	public var duration:Float;
	public var strum:Int;

	public function new(lane:Int, strum:Int, ?duration:Float = 0, ?targetSize:Int)
	{
		super();
		this.strum = strum;
		this.duration = duration;
		frames = Paths.sparrow('ui/notes/NOTE_assets');
		animation.addByPrefix("idle", noteAnimations[lane][0]);
		targetSize = (targetSize == null ? Std.int(width * 0.5) : targetSize);
		setGraphicSize(Std.int(targetSize));
		animation.play("idle");
		updateHitbox();

		body = new FlxSprite(x, y + this.width);
		body.frames = frames;
		body.animation.addByPrefix("idle", noteAnimations[lane][1]);
		body.setGraphicSize(Std.int(targetSize));
		body.animation.play("idle");
		body.updateHitbox();

		tail = new FlxSprite(body.x, body.y + body.width);
		tail.frames = frames;
		tail.animation.addByPrefix("idle", noteAnimations[lane][2]);
		tail.setGraphicSize(Std.int(targetSize));
		tail.animation.play("idle");
		tail.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		body.update(elapsed);
		tail.update(elapsed);

		body.visible = Math.abs(duration) == 0;
		body.scale.y = (duration / Conductor.stepTime) * Settings.currentSpeed;
		body.updateHitbox();
		body.setPosition(x + (width / 2 - body.width / 2), getGraphicMidpoint().y);

		tail.setPosition(body.x, body.getGraphicBounds().bottom - 10);
	}

	override function draw()
	{
		tail.draw();
		body.draw();
		super.draw();
	}

	override function set_cameras(Value:Array<FlxCamera>):Array<FlxCamera>
	{
        body.cameras = Value;
        tail.cameras = Value;
		return _cameras = Value;
	}
}
