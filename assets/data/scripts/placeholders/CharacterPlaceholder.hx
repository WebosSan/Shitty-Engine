package data.scripts.placeholders;

import game.objects.character.Character;
import game.scripting.events.normal.CreateEvent;

class CharacterPlaceholder extends Character{
	public function new(x:Float, y:Float, id:String, ?isPlayer:Bool){
        super(x, y, id, isPlayer);
    }
}