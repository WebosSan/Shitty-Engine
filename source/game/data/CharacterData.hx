package game.data;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.typeLimit.OneOfThree;

typedef CharData =
{
	renderType:String,
	position:
	{
		global:FlxPoint, camera:FlxPoint
	},
	healthBarColor:Array<Int>,
	animations:Array<AnimationData>
}

typedef AnimationData =
{
	offsets:FlxPoint,
	prefix:String,
	name:String,
	framerate:Int,
	?indices:Array<Int>,
	?loop:Bool,
	?flipX:Bool,
	?flipY:Bool
}

class CharacterData
{
	public var renderType:String;
	public var position:
		{
			global:FlxPoint,
			camera:FlxPoint
		};
	public var healthBarColor:FlxColor;
	public var animations:Array<AnimationData>;

	public function new(data:CharData) {
        this.renderType = data.renderType;
        this.position = data.position;

        healthBarColor = FlxColor.fromRGB(data.healthBarColor[0], data.healthBarColor[1], data.healthBarColor[2]);

        animations = [];

        for (anim in data.animations){
            anim.loop = anim.loop ?? false;
            anim.flipX = anim.flipX ?? false;
            anim.flipY = anim.flipY ?? false;
			anim.indices = anim.indices ?? [];
            animations.push(anim);
        }
    }
}
