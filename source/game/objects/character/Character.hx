package game.objects.character;

import flixel.math.FlxPoint;
import game.backend.Conductor;
import game.backend.Paths;
import game.data.CharacterData;
import json2object.JsonParser;

using StringTools;

class Character extends FunkinSprite
{
	public var data:CharacterData;
	public var id:String;
	public var isPlayer:Bool;
	public var cameraPosition:FlxPoint;

	public function new(x:Float, y:Float, id:String, ?isPlayer:Bool = false)
	{
		this.id = id;
		this.isPlayer = isPlayer;
		data = getCharacterData(id);
		this.globalPosition = data.position.global;
		this.cameraPosition = data.position.camera;

		super(x, y);

		shouldDance = true;

		dance();
	}

	override function onCreate(ev:CreateEvent)
	{
		super.onCreate(ev);
		if (!ev.cancelled)
		{
			render(data.renderType);
			for (animation in data.animations)
			{
				if (animation.indices.length > 0)
				{
					setAnimationByIndices(animation.name, animation.prefix, animation.indices, animation.framerate, animation.offsets, animation.loop,
						animation.flipX, animation.flipY);
				}
				else
				{
					setAnimationByPrefix(animation.name, animation.prefix, animation.framerate, animation.offsets, animation.loop, animation.flipX,
						animation.flipY);
				}
			}

			flipX = isPlayer;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private var _lastSingTime:Float = 0;

	override function dance()
	{
		if (animationName().startsWith('sing'))
		{
			if (Conductor.time >= _lastSingTime + Conductor.stepTime)
			{
				super.dance();
			}
		}
		else
		{
			super.dance();
		}
	}

	override function playAnimation(name:String, ?force:Bool = false)
	{
		super.playAnimation(name, force);
		if (name.startsWith('sing'))
		{
			_lastSingTime = Conductor.time;
		}
	}

	private function render(type:String)
	{
		type = type.toLowerCase();
		switch (type)
		{
			default:
				frames = Paths.sparrow("spritesheet", 'data/characters/$id');
		}
	}

	public static function getCharacterData(id:String)
	{
		var parser:JsonParser<CharData> = new JsonParser<CharData>();
		var data:CharData = parser.fromJson(Paths.getText("Character.json", "data/characters/" + id));

		var characterData:CharacterData = new CharacterData(data);
		return characterData;
	}
}
