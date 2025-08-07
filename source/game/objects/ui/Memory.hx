package game.objects.ui;

import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Memory extends TextField
{
	private var memoryUsed:Float = 0;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "MEMORY: 000000000 MB";

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(_) {
		memoryUsed = System.totalMemory / (1024 * 1024);
		text = "MEMORY: " + memoryUsed + "MB";
	}
}
