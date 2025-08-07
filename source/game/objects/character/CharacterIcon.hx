package game.objects.character;

import flixel.FlxSprite;

class CharacterIcon extends FlxSprite {
    public function new(x:Float, y:Float, id:String) {
        super(x, y);
        loadGraphic(Paths.image('icon', 'data/characters/$id'), true, 150, 150);
        animation.add('alive', [0], 1, true);
        animation.add('dead', [1], 1, true);
        animation.play('alive');
    }
}