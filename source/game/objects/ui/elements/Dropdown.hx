package game.objects.ui.elements;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

// supposed to be used with topbar
class Dropdown extends FlxTypedSpriteGroup<Button>
{
	public var offsetX:Float;
	public var offsetY:Float;

	public var grouped:Bool = false;

    public var onClick:(spr:Button, text:String, id:Int) -> Void = (s, t, i) -> {};

    private var _height:Int;

	public function new(x:Float, y:Float, options:Array<String>, width:Int, height:Int, color:FlxColor, ?offsetY:Float = 0, ?grouped:Bool = false)
	{
		super(x, y);

		this.grouped = grouped;

        _height = height;

		this.offsetY = offsetY ?? 0;

		for (i in 0...options.length)
		{
			var button:Button = new Button(0, 0, width, height, options[i], color);
			button.y = (grouped ? 0 : this.offsetY + _height * i);
            button.onClick = () -> {
                onClick(button, options[i], i);
            }
			add(button);
		}
	}

	override function update(elapsed:Float)
	{
		if (!grouped)
		{
			super.update(elapsed);
		}

        for (i in 0...members.length){
            var member:Button = members[i];
            member.y = FlxMath.lerp(member.y, (grouped ? 0 : this.offsetY + _height * i), 0.2);
        }
	}
}
