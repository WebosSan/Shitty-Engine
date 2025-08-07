package game.debug.test;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import game.objects.ui.elements.Button;
import game.objects.ui.elements.ColorPicker;
import game.objects.ui.elements.Dropdown;
import game.objects.ui.elements.Modal;
import game.objects.ui.elements.Slider;
import game.objects.ui.elements.Switch;
import game.objects.ui.elements.TopBar;
import game.states.base.FunkinState;
import openfl.Lib;

class UITest extends FunkinState
{
	private var modal:Modal;
	private var dropdown:Dropdown;

	var c:ColorPicker;

	override function create()
	{
		super.create();
		bgColor = 0xFF3A2946;

		trace(Paths.font('GoogleSansCode-VariableFont_wght'));

		dropdown = new Dropdown(0, 0, ["Open Modal", "Exit"], 150, 50, 0xFF32213D, 50, true);
		dropdown.onClick = (button, text, id) -> {
			if (id == 0){
				modal.visible = !modal.visible;
			} else {
				Lib.application.window.close();
			}
		}
		add(dropdown);

		var topBar:TopBar = new TopBar(0xFF32213D, ["TEST 1", "TEST 2", "TEST 3", "TEST 4"]);
		topBar.onClick =  (button, text, id) -> {
			if (id == 0){
				dropdown.grouped = !dropdown.grouped;
			}
		};
		add(topBar);

		modal = new Modal(0, 0, 400, 300, 0xFF32213D, "Test Modal");
		modal.screenCenter();
		add(modal);

		var modalText:FlxText = new FlxText(10, 40, 390,
			"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean quis interdum odio, non condimentum diam. Praesent aliquet sem eget scelerisque molestie. Phasellus id aliquet lacus. Nulla vitae mollis enim. Nunc imperdiet ex ac libero fringilla pulvinar. Proin sed ligula quis augue semper aliquet nec sed purus. Nam nec risus sit amet sem luctus vehicula. ");
		modal.add(modalText);

		var modalButton:Button = new Button(10, 0, 100, 30, "Close Modal", 0xFF473356);
		modalButton.x = modal.width / 2 - modalButton.width / 2;
		modalButton.y = modal.height - 40;
		modalButton.onClick = () -> modal.visible = false;
		modal.add(modalButton);

		var slider:Slider = new Slider(0, 0, 380, 10, 0xFF473356);
		slider.x = 10;
		slider.y = 40 + modalText.height + 10;

		var sliderText:FlxText = new FlxText(10, slider.y + 20, 380, "Slider Value: " + slider.value, 12);

		slider.onValueChanged = (v:Float) ->
		{
			sliderText.text = 'Slider Value: $v';
			return;
		}

		modal.add(slider);

		modal.add(sliderText);

		c = new ColorPicker(100, 100, 150);
		add(c);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		bgColor = c.currentColor;
		if (FlxG.keys.justPressed.SPACE) dropdown.grouped = !dropdown.grouped;
	}
}
