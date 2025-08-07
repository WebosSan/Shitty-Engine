package game.objects.notes;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Strum extends FlxSprite
{
	private var _ogSize:FlxPoint;
    private var _targetSize:Int;

	// Static, Pressed, Confirm
	public static var noteAnimations:Array<Array<String>> = [
		["arrowLEFT", "left press", "left confirm"],
		["arrowDOWN", "down press", "down confirm"],
		["arrowUP", "up press", "up confirm"],
		["arrowRIGHT", "right press", "right confirm"]
	];

	public var isPlayer:Bool = false;
	public var uiElement:Bool = false;

	public function new(lane:Int, ?targetSize:Int, ?x:Float = 0, ?y:Float = 0, ?isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

        frames = Paths.sparrow('ui/notes/NOTE_assets');

		var laneAnimations:Array<String> = noteAnimations[lane];

		this.animation.addByPrefix("static", laneAnimations[0]);
		this.animation.addByPrefix("press", laneAnimations[1]);
		this.animation.addByPrefix("confirm", laneAnimations[2]);

		_targetSize = (targetSize == null ? Std.int(width * 0.5) : targetSize);
        setGraphicSize(Std.int(_targetSize));

		this.animation.play("static");

		_ogSize = new FlxPoint(frameWidth, frameHeight);
	}

	override function getScreenPosition(?result:FlxPoint, ?camera:FlxCamera):FlxPoint
	{
		var position = super.getScreenPosition(result, camera);

		position.x -= (frameWidth * scale.x - _ogSize.x * scale.x) / 2;
		position.y -= (frameHeight * scale.y - _ogSize.y * scale.x) / 2;

		return position;
	}
}
