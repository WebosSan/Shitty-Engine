package game.objects.game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.group.FlxSpriteGroup;
import flixel.sound.FlxSound;
import game.data.SongData;
import game.objects.notes.Note;
import game.objects.notes.StrumLine;

class PlayField extends FlxSpriteGroup
{
	private var _song:SongData;
	private var _difficulty:DData;

	private var playerStrums:StrumLine;
	private var cpuStrums:StrumLine;
    private var notes:NoteContainer;

    private var enemyVocals:FlxSound;
	private var playerVocals:FlxSound;
    
	public function new(song:SongData, difficulty:DData)
	{
		super();
		Settings.currentSpeed = 3.0;
		_song = song;
		_difficulty = difficulty;

        for (sound in FlxG.sound.list){
            sound.pause();
        }

        Conductor.changeSong(Paths.inst(_song.name, _difficulty.metadata.songPrefix, _difficulty.metadata.songSuffix), _difficulty.metadata.bpm);

		if (_difficulty.metadata.hasEnemyVocals)
		{
			enemyVocals = FlxG.sound.play(Paths.vocals(_song.name, false, _difficulty.metadata.songPrefix, _difficulty.metadata.songSuffix), 1, true);
		}

		if (_difficulty.metadata.hasPlayerVocals)
		{
			playerVocals = FlxG.sound.play(Paths.vocals(_song.name, true, _difficulty.metadata.songPrefix, _difficulty.metadata.songSuffix), 1, true);
		}

        notes = new NoteContainer();
        add(notes);

		createStrums();
	}

	function createStrums()
	{
		cpuStrums = new StrumLine(0, 0);
		cpuStrums.y = 50;
		cpuStrums.x = FlxG.width / 4 - cpuStrums.width / 2;
		add(cpuStrums);

		playerStrums = new StrumLine(0, 0);
		playerStrums.y = 50;
		playerStrums.x = (FlxG.width / 4 + FlxG.width / 2) - playerStrums.width / 2;
		add(playerStrums);

        notes.opponentsTargets = [cpuStrums.left, cpuStrums.down, cpuStrums.up, cpuStrums.right];
        notes.playerTargets = [playerStrums.left, playerStrums.down, playerStrums.up, playerStrums.right];

        notes.createNotes(_difficulty);
	}
}

class NoteContainer extends FlxTypedSpriteContainer<Note>
{
	public var opponentsTargets:Array<FlxSprite> = [];
	public var playerTargets:Array<FlxSprite> = [];

	public function new()
	{
		super();
	}

	public function createNotes(diff:DData)
	{
		for (note in diff.enemyNotes)
		{
			@:privateAccess
			var note:Note = new Note(note.lane, note.time, note.duration);
			note.target = opponentsTargets[note.lane];
			add(note);
		}

		for (note in diff.playerNotes)
		{
			var note:Note = new Note(note.lane, note.time, note.duration);
			note.target = playerTargets[note.lane];
			add(note);
		}
	}

	override function update(elapsed:Float)
	{
		for (basic in members)
		{
			if (basic != null && basic.exists && basic.active)
			{
				basic.update(elapsed);
			}
		}
	}

	override function draw()
	{
		@:privateAccess
		final oldDefaultCameras = FlxCamera._defaultCameras;
		if (_cameras != null)
		{
			@:privateAccess
			FlxCamera._defaultCameras = _cameras;
		}

		for (basic in members)
		{
			if (basic != null && basic.exists && basic.visible && basic.isOnScreen())
				basic.draw();
		}
		@:privateAccess
		FlxCamera._defaultCameras = oldDefaultCameras;
	}
}
