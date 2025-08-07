package game.scripting.events.sprites;

class AnimationEvent extends Event {
    public var name:String;
    public var force:Bool = false;

    public function new(name:String, ?force:Bool = false) {
        super(ANIMATION);
        this.name = name;
        this.force = force;
    }
}