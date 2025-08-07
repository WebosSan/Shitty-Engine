package game.objects.ui.elements;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Modal extends FlxSpriteGroup
{
	private var dragOffsetX:Float = 0;
	private var dragOffsetY:Float = 0;
	private var isDragging:Bool = false;

	public var draggable:Bool = true;

	public function new(x:Float = 0, y:Float = 0, width:Int, height:Int, color:FlxColor, ?title:String)
	{
		super(x, y);
		var body:FlxSprite = new FlxSprite(0, 0).makeGraphic(width, height, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(body, 0, 0, width, height, 15, 15, color);
		add(body);

		if (title != null)
		{
			var text:FlxText = new FlxText(0, 5, 0, title, 10);
			text.font = Paths.font('GoogleSansCode-VariableFont_wght');
			text.x = body.width / 2 - text.width / 2;
			add(text);
		}

		add(new FlxSprite(0, 20).makeGraphic(width, 5, color.getDarkened(0.1)));
	}

	override function update(elapsed:Float)
	{
		if (visible)
		{
			super.update(elapsed);

			if (draggable)
			{
				var modalX:Float = this.x;
				var modalY:Float = this.y;
				var titleWidth:Float = this.width;
				var titleHeight:Float = 25;

				var overlappingTitle:Bool = FlxG.mouse.getWorldPosition(camera).x >= modalX && FlxG.mouse.getWorldPosition(camera).x <= modalX + titleWidth && FlxG.mouse.getWorldPosition(camera).y >= modalY
					&& FlxG.mouse.getWorldPosition(camera).y <= modalY + titleHeight;

				if (overlappingTitle && FlxG.mouse.justPressed)
				{
					isDragging = true;
					dragOffsetX = FlxG.mouse.getWorldPosition(camera).x - modalX;
					dragOffsetY = FlxG.mouse.getWorldPosition(camera).y - modalY;
				}

				if (isDragging && FlxG.mouse.pressed)
				{
					this.x = FlxG.mouse.getWorldPosition(camera).x - dragOffsetX;
					this.y = FlxG.mouse.getWorldPosition(camera).y - dragOffsetY;
				}

				if (FlxG.mouse.justReleased)
				{
					isDragging = false;
				}
			}
		}
	}
}
