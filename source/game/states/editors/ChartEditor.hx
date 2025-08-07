package game.states.editors;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.objects.ui.elements.Button;
import game.objects.ui.elements.Dropdown;
import game.objects.ui.elements.Slider;
import game.objects.ui.elements.TopBar;
import game.states.base.FunkinState;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class ChartEditor extends FunkinState
{
	private var topBar:TopBar;
	private var camHud:FlxCamera;

	private var fileDropdown:Dropdown;
	private var editDropdown:Dropdown;

	private var songPosition:Slider;

	private var pauseButton:Button;
	private var advanceButton:Button;
	private var rewindButton:Button;
	private var startButton:Button;
	private var endButton:Button;

	private var infoText:FlxText;

	private var eventGrid:FlxSprite;
	private var playerGrid:FlxSprite;
	private var enemyGrid:FlxSprite;
	private var strumLine:FlxSprite;

	private var _defaultColor:FlxColor = 0xFF151619;
	private var _bgColor:FlxColor = 0xFF1E1F22;

	private var _gridSize:Int = 40;

	override function create()
	{
		super.create();

		Conductor.changeSong("assets/music/freakyMenu.ogg", 102);
		FlxG.sound.music.pause();

		camHud = new FlxCamera();
		camHud.bgColor.alpha = 0;
		FlxG.cameras.add(camHud, false);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, _bgColor);
		bg.scrollFactor.set();
		add(bg);

		playerGrid = new FlxSprite();
		playerGrid.pixels = makeGridBitmapData();
		playerGrid.antialiasing = false;
		playerGrid.scale.set(_gridSize, _gridSize);
		playerGrid.updateHitbox();

		eventGrid = new FlxSprite();
		eventGrid.pixels = makeGridBitmapData(4);
		eventGrid.antialiasing = false;
		eventGrid.scale.set(_gridSize, _gridSize);
		eventGrid.updateHitbox();

		enemyGrid = new FlxSprite();
		enemyGrid.pixels = makeGridBitmapData();
		enemyGrid.antialiasing = false;
		enemyGrid.scale.set(_gridSize, _gridSize);
		enemyGrid.updateHitbox();

		var totalWidth = enemyGrid.width + playerGrid.width + eventGrid.width + 10;
		var startX = (FlxG.width - totalWidth) / 2;

		enemyGrid.x = startX;
		enemyGrid.y = FlxG.height / 3;

		playerGrid.x = enemyGrid.x + enemyGrid.width + 5;
		playerGrid.y = FlxG.height / 3;

		eventGrid.x = playerGrid.x + playerGrid.width + 5;
		eventGrid.y = FlxG.height / 3;

		add(enemyGrid);
		add(playerGrid);
		add(eventGrid);

		strumLine = new FlxSprite(enemyGrid.x - 10, enemyGrid.y).makeGraphic(Std.int(eventGrid.x + eventGrid.width - enemyGrid.x + 20), 10, _defaultColor);
		add(strumLine);

		setupTopbar();
		setupDownBar();

		FlxG.camera.follow(strumLine, LOCKON, 0.2);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
			FlxG.sound.music.playing ? FlxG.sound.music.pause() : FlxG.sound.music.play();

		if (FlxG.mouse.wheel != 0)
			Conductor.setTime(Conductor.time - (FlxG.mouse.wheel * Conductor.stepTime));

		strumLine.y = playerGrid.y + getYByStrum();

		infoText.text = 'Song Position: ${FlxMath.roundDecimal(Conductor.time / 1000, 1)}\nCurrent Step: ${Conductor.currentStep} | Current Beat: ${Conductor.currentBeat}';
		songPosition.value = Conductor.time / Conductor.length;
		pauseButton.setText(FlxG.sound.music.playing ? "||" : ">");
	}

	function setupTopbar()
	{
		fileDropdown = new Dropdown(0, 0, ["New", "Open", "Save", "Save as", "Import", "Exit"], 150, 50, _defaultColor, 50, true);
		fileDropdown.onClick = fileCommands;
		fileDropdown.cameras = [camHud];
		add(fileDropdown);

		editDropdown = new Dropdown(150, 0, ["Undo", "Redo", "Cut", "Copy", "Paste", "Delete", "Select All"], 150, 50, _defaultColor, 50, true);
		editDropdown.onClick = editCommands;
		editDropdown.cameras = [camHud];
		add(editDropdown);

		topBar = new TopBar(_defaultColor, ["File", "Edit", "View", "Test"]);
		topBar.darknessFactor = 0.2;
		topBar.onClick = topBarCommands;
		topBar.cameras = [camHud];
		add(topBar);
	}

	function setupDownBar()
	{
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, 60, _bgColor);
		bg.y = FlxG.height - 60;
		bg.cameras = [camHud];
		add(bg);

		songPosition = new Slider(0, FlxG.height - 50, FlxG.width, 10, _defaultColor);
		songPosition.cameras = [camHud];
		songPosition.onValueChanged = v ->
		{
			Conductor.setTime(Conductor.length * v);
		}
		add(songPosition);

		pauseButton = new Button(0, songPosition.y + 12.5, 25, 25, "||", _defaultColor);
		pauseButton.screenCenter(X);
		pauseButton.cameras = [camHud];
		pauseButton.onClick = () ->
		{
			FlxG.sound.music.playing ? FlxG.sound.music.pause() : FlxG.sound.music.play();
		}
		add(pauseButton);

		advanceButton = new Button(pauseButton.x + pauseButton.width + 2.5, songPosition.y + 12.5, 25, 25, ">", _defaultColor);
		advanceButton.cameras = [camHud];
		advanceButton.onClick = () ->
		{
			Conductor.setTime(Conductor.time + Conductor.beatTime);
		}
		add(advanceButton);

		rewindButton = new Button(pauseButton.x - 25 - 2.5, songPosition.y + 12.5, 25, 25, "<", _defaultColor);
		rewindButton.cameras = [camHud];
		rewindButton.onClick = () ->
		{
			Conductor.setTime(Conductor.time - Conductor.beatTime);
		}
		add(rewindButton);

		startButton = new Button(rewindButton.x - 35 - 2.5, songPosition.y + 12.5, 35, 25, "<<", _defaultColor);
		startButton.cameras = [camHud];
		startButton.onClick = () ->
		{
			FlxG.sound.music.pause();
			Conductor.setTime(0);
		}
		add(startButton);

		endButton = new Button(advanceButton.x + advanceButton.width + 2.5, songPosition.y + 12.5, 35, 25, ">>", _defaultColor);
		endButton.cameras = [camHud];
		endButton.onClick = () ->
		{
			FlxG.sound.music.pause();
			Conductor.setTime(Conductor.length - Conductor.beatTime);
		}
		add(endButton);

		infoText = new FlxText(4, songPosition.y + 14, endButton.x - 2.5, "Song Position: 0\nCurrent Step: 0 | Current Beat: 0", 12);
		infoText.setFormat(Paths.font('GoogleSansCode-VariableFont_wght'), 10, FlxColor.WHITE);
		infoText.updateHitbox();
		infoText.cameras = [camHud];
		add(infoText);
	}

	function fileCommands(b:Button, t:String, id:Int) {}

	function editCommands(b:Button, t:String, id:Int) {}

	function topBarCommands(b:Button, t:String, id:Int)
	{
		if (id == 0)
		{
			fileDropdown.grouped = !fileDropdown.grouped;
		}
		else if (id == 1)
		{
			editDropdown.grouped = !editDropdown.grouped;
		}
	}

	function makeGridBitmapData(?rows:Int = 4):BitmapData
	{
		var bmp:BitmapData = new BitmapData(rows, Conductor.totalSteps, true, FlxColor.TRANSPARENT);
		for (x in 0...rows)
		{
			for (y in 0...Conductor.totalSteps)
			{
				var color:Int = (y % 2 == 0) ? (x % 2 == 0 ? 0xFFB8B8B8 : FlxColor.WHITE) : (x % 2 == 0 ? FlxColor.WHITE : 0xFFB8B8B8);
				bmp.setPixel32(x, y, color);
			}
		}
		return bmp;
	}

	function getYByStrum():Float
	{
		return (Conductor.time / Conductor.stepTime) * _gridSize;
	}
}
