package game.scripting.events;

class Event {
    public var type:EventType;
    public var cancelled:Bool = false;
    public function new(type:EventType) {
        this.type = type;
        this.cancelled = false;
    }

    public function cancel() {
        cancelled = true;
    }
}