package game.scripting.events;

import game.scripting.events.normal.BeatEvent;
import game.scripting.events.normal.CreateEvent;
import game.scripting.events.normal.StepEvent;
import game.scripting.events.normal.UpdateEvent;

interface IEventListener {
    public function onCreate(ev:CreateEvent):Void;
    public function onUpdate(ev:UpdateEvent):Void;
    public function onStep(ev:StepEvent):Void;
    public function onBeat(ev:BeatEvent):Void;
}