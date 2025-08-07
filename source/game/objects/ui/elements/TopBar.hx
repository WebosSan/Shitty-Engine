package game.objects.ui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class TopBar extends FlxSpriteGroup
{
	public var onClick:(button:Button, text:String, id:Int) -> Void = (b, t, i) -> {};
	public var darknessFactor(default, set):Float = 0.1;

	var bar:FlxSprite;

	public function new(color:FlxColor, options:Array<String>)
	{
		super();
		bar = new FlxSprite().makeGraphic(FlxG.width, 50, color);
		add(bar);

		var _prevX:Float = 0;

		for (i in 0...options.length)
		{
			var button:Button = new Button(_prevX, 0, 150, 50, options[i], color);
			_prevX = button.x + button.width;
            button.onClick =  () -> {
                onClick(button, options[i], i);
            }
			add(button);
		}
	}

	private function set_darknessFactor(v:Float):Float {
		for (member in members) {
			if (member is Button){
				var b:Button = cast member;
				b.darknessFactor = v;
			}
		}
		return darknessFactor = v;
	}
}
