package game.scripting.events.sprites;

class DanceEvent extends Event{
    public var danced:Bool = false;
    
    public function new() {
        super(DANCE);
    }
}