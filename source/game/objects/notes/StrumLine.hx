package game.objects.notes;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class StrumLine extends FlxTypedSpriteGroup<Strum>
{
	private var _targetWidth:Int;
	private var _targetHeight:Int;
	private var spacing:Int;
	private var startPosX:Float;

	public var left:Strum;
	public var down:Strum;
	public var up:Strum;
	public var right:Strum;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		_targetWidth = Std.int(FlxG.width / 2.5);
		_targetHeight = Std.int(FlxG.height / 10);

		spacing = 10;

		generateStrums();
	}

	function generateStrums()
	{
		for (i in 0...4)
		{
			var strum = new Strum(i);
			@:privateAccess
			strum.x = strum._targetSize * i + (spacing * (i == 0 ? 0 : 1));
			this.add(strum);
			
			switch (i)
			{
				case 0:
					left = strum;
				case 1:
					down = strum;
				case 2:
					up = strum;
				case 3:
					right = strum;
			}
		}
	}
}
