package game.scripting.events.normal;

class BeatEvent extends Event {
    public var beat:Int;

    public function new() {
        super(BEAT);
    }
}