package game.debug;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.debug.test.TestPlayground;
import game.debug.test.UITest;
import game.states.editors.ChartEditor;

// it should work
class DebugState extends FlxState
{
	private var _options:Array<String> = [
		"Test Playground",
		"Ui Test",
		"Freeplay Test",
		"Charting State",
		"Character Test",
		"Stage Test",
		"Init Game as Normal"
	];

	private var _textGroup:FlxTypedGroup<FlxText>;
	private var _cameraFollow:FlxObject;
	private var _selected:Bool = false;

	private var curSelected(default, set):Int;

	override function create()
	{
		super.create();

		_textGroup = new FlxTypedGroup();

		for (i in 0..._options.length)
		{
			var option = _options[i];
			var text:FlxText = new FlxText(0, 100 + 100 * i, 0, option, 32);
			text.screenCenter(X);
			_textGroup.add(text);
		}

		add(_textGroup);

		curSelected = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!_selected)
		{
			if (FlxG.keys.justPressed.UP)
			{
				curSelected--;
			}
			else if (FlxG.keys.justPressed.DOWN)
			{
				curSelected++;
			}

			if (FlxG.keys.justPressed.ENTER)
				onSelect();
		}

		FlxG.camera.follow(_cameraFollow, LOCKON, 0.2);
	}

	function onSelect()
	{
		_selected = true;

		var selectedText:FlxText = _textGroup.members[curSelected];
		var selectedOption:String = _options[curSelected];

		FlxFlicker.flicker(selectedText, 0.5, 0.04, true, true, f ->
		{
			switch (selectedOption)
			{
				case "Init Game as Normal":
					// TODO: Init TitleState.hx
				case "Freeplay Test":
					// TODO: Init FreeplayState.hx
				case "Character Test":
					// Im doing this now, but first i need the Conductor Class
				case "Charting State":
					FlxG.switchState(ChartEditor.new.bind({
						songToLoad: "bopeebo",
						difficultyToLoad: "normal"
					}));
				case "Test Playground":
					FlxG.switchState(TestPlayground.new);
				case "Ui Test":
					FlxG.switchState(UITest.new);
			}
		});
	}

	function set_curSelected(v:Int):Int
	{
		curSelected = v;

		if (curSelected < 0)
		{
			curSelected = _options.length - 1;
		}
		else if (curSelected >= _options.length)
		{
			curSelected = 0;
		}

		var selectedText:FlxText = _textGroup.members[curSelected];
		var followPoint:FlxPoint = selectedText.getGraphicMidpoint();

		if (_cameraFollow == null)
		{
			_cameraFollow = new FlxObject(followPoint.x, followPoint.y);
		}
		else
		{
			_cameraFollow.setPosition(followPoint.x, followPoint.y);
		}

		_textGroup.forEachExists(t ->
		{
			t.color = (t == selectedText ? FlxColor.YELLOW : FlxColor.WHITE);
		});

		return curSelected;
	}
}
