package game.objects.ui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class ColorPicker extends FlxSpriteGroup
{
	var picker:FlxSprite;
	var huePicker:FlxSprite;

	var hueLine:FlxSprite;
    var colorPicker:FlxSprite;

	var currentHue:Float = 360;
	var _size:Int = 0;

    public var currentColor:FlxColor;

	public function new(x:Float, y:Float, size:Int)
	{
		super(x, y);
		_size = size;
		picker = new FlxSprite().makeGraphic(size, size, FlxColor.TRANSPARENT);
		picker.pixels = makePickerBitmap(size);
		picker.updateHitbox();
		add(picker);

		huePicker = new FlxSprite(picker.width + 10, 0).makeGraphic(Std.int(size / 10), size, FlxColor.TRANSPARENT);
		huePicker.pixels = makeHuePicker(size);
		huePicker.updateHitbox();
		add(huePicker);

		hueLine = new FlxSprite();
		hueLine.makeGraphic(Std.int(huePicker.width), 5, FlxColor.BLACK);
		add(hueLine);

        colorPicker = new FlxSprite();
        colorPicker.pixels = makeSelector();
        colorPicker.scale.set(5, 5);
        colorPicker.updateHitbox();
        colorPicker.antialiasing = false;
        add(colorPicker);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var mouse:FlxMouse = FlxG.mouse;
		var mousePos:FlxPoint = mouse.getWorldPosition(camera);
		var mouseX:Float = mousePos.x;
		var mouseY:Float = mousePos.y;

		if (huePicker.overlapsPoint(mousePos) && mouse.pressed)
		{
			var pickerY:Float = huePicker.y;
			var thatY:Float = mouseY - pickerY;

			trace(thatY, _size, thatY / _size);

			currentHue = 360 * thatY / _size;
			picker.pixels = makePickerBitmap(_size);
			picker.updateHitbox();

			hueLine.setPosition(huePicker.x, mouseY);
		}

        if (picker.overlapsPoint(mousePos) && mouse.pressed){
            colorPicker.setPosition(mouseX - colorPicker.width / 2, mouseY - colorPicker.height / 2);
        }

        var pickerX:Float = colorPicker.x - (colorPicker.width / 2) - picker.x;
        var pickerY:Float = colorPicker.y - (colorPicker.height / 2) - picker.y;

        var s:Float = pickerX / _size;
        var b:Float = 1 - pickerY / _size;

        currentColor = FlxColor.fromHSB(currentHue, s, b);
	}

    function makeSelector() {
        var bmp:BitmapData = new BitmapData(3, 3, true, FlxColor.TRANSPARENT);
        bmp.setPixel32(1, 0, FlxColor.BLACK);
        bmp.setPixel32(0, 1, FlxColor.BLACK);
        bmp.setPixel32(2, 1, FlxColor.BLACK);
        bmp.setPixel32(1, 2, FlxColor.BLACK);
        return bmp;
    }

	function makeHuePicker(size:Int)
	{
		var bmd:BitmapData = new BitmapData(Std.int(size / 10), size, false, 0x000000);
		var width:Int = Std.int(size / 10);
		var height:Int = size;
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				var xFactor:Float = x / size;
				var yFactor:Float = y / size;

				var hue:Float = 360 * yFactor;
				bmd.setPixel32(x, y, FlxColor.fromHSB(hue, 1, 1));
			}
		}

		return bmd;
	}

	function makePickerBitmap(size:Int)
	{
		var bmd:BitmapData = new BitmapData(size, size, false, 0x000000);

		for (y in 0...size)
		{
			for (x in 0...size)
			{
				var xFactor:Float = x / size;
				var yFactor:Float = y / size;

				bmd.setPixel32(x, y, FlxColor.fromHSB(currentHue, xFactor, 1 - yFactor));
			}
		}

		return bmd;
	}
}
