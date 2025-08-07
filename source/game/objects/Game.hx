package game.objects;

import flixel.FlxG;
import flixel.util.typeLimit.NextState.InitialState;
import game.backend.FunkinGame;
import game.backend.Settings;
import game.debug.DebugState;
import game.objects.script.ScriptedGame;
import game.objects.ui.Memory;
import game.scripting.ScriptDefines;
import game.scripting.events.EventDispatcher;
import game.scripting.events.IEventListener;
import game.scripting.events.normal.BeatEvent;
import game.scripting.events.normal.CreateEvent;
import game.scripting.events.normal.StepEvent;
import game.scripting.events.normal.UpdateEvent;
import game.states.editors.ChartEditor;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Game implements IEventListener
{
	private static var targetWidth:Int = 1280;
	private static var targetHeight:Int = 720;
	private static var targetFps:Int = 60;
	private static var targetState:InitialState;

	private var fps:FPS;
	private var game:FunkinGame;
	private var memory:Memory;

	private var stage(get, default):Stage;

	public static var instance:Game;

	public function new()
	{
		init();
	}

	@:noCompletion
	private function init()
	{
		this.stage = Lib.application.window.stage;
		instance = this;

		// Limpiar event listeners anteriores
		clearEventListeners();

		EventDispatcher.dispatchEvent(this, CREATE);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		Conductor.onGlobalBeat.add((b) -> EventDispatcher.dispatchEvent(this, BEAT));
		Conductor.onGlobalStep.add((b) -> EventDispatcher.dispatchEvent(this, STEP));
	}

	private function clearEventListeners()
	{
		if (stage != null)
		{
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		Conductor.onGlobalBeat.removeAll();
		Conductor.onGlobalStep.removeAll();
	}

	private function onEnterFrame(_:Event)
	{
		EventDispatcher.dispatchEvent(this, UPDATE);
	}

	public function onCreate(ev:CreateEvent)
	{
		if (stage != null)
		{
			if (game != null && stage.contains(game))
				stage.removeChild(game);
			if (fps != null && game.contains(fps))
				game.removeChild(fps);
			if (memory != null && game.contains(memory))
				game.removeChild(memory);
		}
		if (!ev.cancelled)
		{
			if (game != null)
			{
				FlxG.resetGame();
			}

			#if debug
			targetState = ChartEditor;
			#else
			targetState = ChartEditor;
			#end

			if (game == null)
				game = new FunkinGame(targetWidth, targetHeight, targetState, targetFps, targetFps, true, false);
			fps = new FPS(10, 10, 0xFFFFFFFF);
			memory = new Memory(10, 22.5, 0xFFFFFFFF);

			stage.addChild(game);
			/*
			game.addChild(fps);
			game.addChild(memory);
			*/
		}
	}

	public function onUpdate(ev:UpdateEvent) {}

	public function onStep(ev:StepEvent) {}

	public function onBeat(ev:BeatEvent) {}

	public function reload()
	{
		init();
	}

	public static function initGame()
	{
		var path:String = 'Global.hx';
		if (!Paths.exists(Paths.getPath(path)))
		{
			new ScriptedGame('data.scripts.placeholders.GlobalPlaceholder');
			return;
		}
		new ScriptedGame('Global');
	}

	private function get_stage():Stage
	{
		return Lib.application.window.stage;
	}
}
