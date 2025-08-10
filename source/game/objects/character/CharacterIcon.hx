package game.objects.character;

import flixel.FlxSprite;

class CharacterIcon extends FlxSprite
{
	public var lastIconID:String = ""; // useful if theres a script that does stuff

	public function new(x:Float, y:Float, id:String)
	{
		super(x, y);
		changeIcon(id);
	}

	public function changeIcon(newID:String = 'dad')
	{
		if (!Paths.exists(Paths.getPath('icon.png', 'data/characters/$newID'))) // checking if the icon exists or not
			newID = 'dad'; // set icon to dad if it doesnt exist

		loadGraphic(Paths.image('icon', 'data/characters/$newID'), false); // inital loadgraphic to get the sheet width and height

		loadGraphic(Paths.image('icon', 'data/characters/$newID'), true, Math.floor(width / 2), Math.floor(height)); // width / 2 to split the sheet into two frames
		animation.add('alive', [0], 1, true);
		animation.add('dead', [1], 1, true);
		animation.play('alive');
	}
}
