package game.objects.ui.elements;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Switch extends FlxSprite
{
	var selector:FlxSprite = new FlxSprite();

    public var value:Bool = false;

    private var _offColor:FlxColor;
    private var _onColor:FlxColor;
    
    private var _targetColor:FlxColor;
    private var _targetX:Float;

    private var _width:Int;

	public function new(x:Float, y:Float, width:Int, height:Int, offColor:FlxColor, onColor:FlxColor)
	{
		super(x, y);
        value = false;
        _offColor = offColor;
        _onColor = onColor;
        _width = width;

		this.makeGraphic(width, height, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, 10, 10, FlxColor.WHITE);
        this.color = offColor;

		selector = new FlxSprite(x + 2, x + 2);
		selector.makeGraphic(Std.int(width / 2) - 4, height - 4, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(selector, 0, 0, width / 2 - 4, height - 4, 10, 10, FlxColor.WHITE);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (overlapsPoint(FlxG.mouse.getWorldPosition(camera)) && FlxG.mouse.justPressed){
            value = !value;
        }

        _targetColor = value ? _onColor : _offColor;
        _targetX = value ? x + (_width / 2 + 2) : x + 2;

        selector.y = y + 2;
        selector.x = FlxMath.lerp(selector.x, _targetX, 0.2);

        this.color = FlxColor.interpolate(this.color, _targetColor, 0.2);
	}

	override function draw()
	{
		super.draw();
		selector.draw();
	}

	override function destroy() {
		super.destroy();
		selector.destroy();
	}

	override function set_camera(v:FlxCamera):FlxCamera {
		this.selector.camera = v;
		return super.set_camera(v);
	}

	override function set_cameras(v:Array<FlxCamera>):Array<FlxCamera> {
		this.selector.cameras = v;
		return super.set_cameras(v);
	}
}
