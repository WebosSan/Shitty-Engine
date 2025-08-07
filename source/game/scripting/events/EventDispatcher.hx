package game.scripting.events;

import flixel.FlxG;
import game.scripting.events.normal.BeatEvent;
import game.scripting.events.normal.CreateEvent;
import game.scripting.events.normal.StepEvent;
import game.scripting.events.normal.UpdateEvent;

class EventDispatcher
{
	public static function dispatchEvent(obj:IEventListener, type:EventType)
	{
		switch (type)
		{
			case CREATE:
				obj.onCreate(new CreateEvent());
			case UPDATE:
				var ev:UpdateEvent = new UpdateEvent();
				ev.elapsed = FlxG.elapsed;
				obj.onUpdate(ev);
			case STEP:
				var ev:StepEvent = new StepEvent();
				ev.step = Conductor.currentStep;
				obj.onStep(ev);
			case BEAT:
				var ev:BeatEvent = new BeatEvent();
				ev.beat = Conductor.currentBeat;
				obj.onBeat(ev);
			default:
				return;
		}
	}
}
