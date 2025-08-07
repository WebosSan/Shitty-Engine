package game.objects.notes;

import flixel.group.FlxGroup.FlxTypedGroup;
import game.backend.Conductor;
import game.backend.Settings;

class NotesBuffer extends FlxTypedGroup<Note>{
    public function new(?targetSize:Int) {
        super();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        forEachAlive(n -> {
            n.y = n.strum - Conductor.time * (0.45 * Settings.currentSpeed);
        });
    }

    public function createNote(lane:Int, strum:Int, ?duration:Float = 0, ?targetSize:Int) {
        var note:Note = this.recycle(Note.new.bind(lane, strum, duration, targetSize));
        add(note);
    }
}