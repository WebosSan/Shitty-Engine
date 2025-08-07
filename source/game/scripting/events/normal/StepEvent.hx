package game.scripting.events.normal;

class StepEvent extends Event {
    public var step:Int;

    public function new() {
        super(STEP);
    }
}