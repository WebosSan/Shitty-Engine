package assets.data.characters.bf;

import flixel.FlxG;
import game.objects.character.Character;
import game.scripting.events.normal.CreateEvent;
import game.scripting.events.normal.UpdateEvent;

class CharacterScript extends Character
{
	override function onCreate(ev:CreateEvent)
	{
		super.onCreate(ev);
		flipX = !isPlayer;
	}

	override function onUpdate(ev:UpdateEvent) {
		super.onUpdate(ev);
	}
}
