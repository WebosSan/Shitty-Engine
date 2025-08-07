package game.scripting.events.normal;

class UpdateEvent extends Event{
    public var elapsed:Float;
    public function new() {
        super(UPDATE);
    }
}