package game.substates;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import game.data.SongData;
import game.objects.game.PlayField;
import game.objects.notes.StrumLine;
import game.states.base.FunkinSubState;

class TestSubstate extends FunkinSubState
{
	private var _song:SongData;
	private var _difficulty:DData;

	public var field:PlayField;
	
	public var camGame:FlxCamera;

	public function new(song:SongData, difficulty:DData)
	{
		super();
		_song = song;
		_difficulty = difficulty;
	}

	override function create()
	{
		super.create();

		camGame = new FlxCamera();
		camGame.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camGame);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menuDesat'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.cameras = [camGame];
		add(bg);

		field = new PlayField(_song, _difficulty);
		field.cameras = [camGame];
		add(field);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE){
			close();
		}
	}

	override function close() {
		super.close();
		clear();
		FlxG.cameras.remove(camGame);
	}
}
