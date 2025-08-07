package game.objects.ui.elements;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Button extends FlxSprite
{
	public var text:FlxText;
	public var onClick:Void->Void;
	public var minWidth:Int;

	public var darknessFactor:Float = 0.1;

	public function new(x:Float, y:Float, width:Int = 100, height:Int = 30, text:String = "Button", color:FlxColor = FlxColor.BLUE)
	{
		super(x, y);

		this.text = new FlxText(0, 0, 0, text, 8);
		this.text.setFormat(Paths.font('GoogleSansCode-VariableFont_wght'), 10, FlxColor.WHITE, "center");

		var textWidth:Int = Std.int(this.text.width) + 10;
		minWidth = textWidth;

		var finalWidth:Int = width < minWidth ? minWidth : width;
		makeGraphic(finalWidth, height, color);
		positionText();

		solid = true;
	}

	override function set_camera(v:FlxCamera):FlxCamera {
		this.text.camera = v;
		return super.set_camera(v);
	}

	override function set_cameras(v:Array<FlxCamera>):Array<FlxCamera> {
		this.text.cameras = v;
		return super.set_cameras(v);
	}

	function positionText():Void
	{
		text.updateHitbox();
		text.x = x + (width - text.width) / 2;
		text.y = y + (height - text.height) / 2;
	}

	var _targetColor:FlxColor;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (overlapsPoint(FlxG.mouse.getWorldPosition(camera)))
		{
			_targetColor = FlxColor.WHITE.getDarkened(darknessFactor);
			if (FlxG.mouse.justPressed && onClick != null)
			{
				onClick();
			}
		}
		else
		{
			_targetColor = FlxColor.WHITE;
		}

		if (Math.abs(color.red - _targetColor.red) < 2
			&& Math.abs(color.green - _targetColor.green) < 2
			&& Math.abs(color.blue - _targetColor.blue) < 2)
		{
			color = _targetColor;
		}
		else
		{
			color = FlxColor.interpolate(color, _targetColor, 0.2); 
		}
	}

	override public function draw():Void
	{
		positionText();
		super.draw();
		text.draw();
	}

	override public function setPosition(X:Float = 0, Y:Float = 0):Void
	{
		super.setPosition(X, Y);
		positionText();
	}

	override function destroy() {
		super.destroy();
		text.destroy();
	}

	public function setText(newText:String):Void
	{
		text.text = newText;
		var textWidth:Int = Std.int(text.width) + 10;
		if (textWidth > width)
		{
			makeGraphic(textWidth, frameHeight, FlxColor.TRANSPARENT);
			makeGraphic(textWidth, frameHeight, FlxColor.WHITE);
			color = this.color;
		}
		positionText();
	}
}
