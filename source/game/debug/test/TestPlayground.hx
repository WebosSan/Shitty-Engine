package game.debug.test;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import game.backend.Conductor;
import game.objects.character.Character;
import game.objects.character.ScriptedCharacter;
import game.objects.notes.Note;
import game.objects.notes.StrumLine;
import game.states.base.FunkinState;

class TestPlayground extends FunkinState {
    var dad:ScriptedCharacter;
    var bf:ScriptedCharacter;
    var gf:ScriptedCharacter;

	var camHud:FlxCamera;
    
    var cpuStrum:StrumLine = new StrumLine();
    var playerStrum:StrumLine = new StrumLine();

    override function create() {
        super.create();

        camHud = new FlxCamera();
        camHud.bgColor.alpha = 0; 
        FlxG.cameras.add(camHud, false);

        Conductor.changeSong("assets/music/freakyMenu.ogg", 102);

        gf = ScriptedCharacter.createCharacter('gf');
        gf.screenCenter();
        add(gf);

        dad = ScriptedCharacter.createCharacter('dad');
        dad.screenCenter();
        dad.x -= 400;
        add(dad);

        bf = ScriptedCharacter.createCharacter('bf', true);
        bf.screenCenter();
        bf.x += 400;
        bf.y = (dad.y + dad.height) - bf.height;
        add(bf);

		createStrums();

		FlxG.camera.zoom = 0.6;
	}

	function createStrums()
	{
        cpuStrum = new StrumLine(0, 0);
        cpuStrum.cameras = [camHud];
		cpuStrum.x = FlxG.width / 4 - cpuStrum.width / 2;
        add(cpuStrum);

        playerStrum = new StrumLine(0, 0);
        playerStrum.cameras = [camHud];
		playerStrum.x = (FlxG.width / 4 + FlxG.width / 2) - cpuStrum.width / 2;
		add(playerStrum);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.W) dad.playAnimation('singUP');
        else if (FlxG.keys.justPressed.S) dad.playAnimation('singDOWN');

        if (FlxG.keys.justPressed.A) dad.playAnimation('singLEFT');
        else if (FlxG.keys.justPressed.D) dad.playAnimation('singRIGHT');

        if (FlxG.keys.justPressed.UP) bf.playAnimation('singUP');
        else if (FlxG.keys.justPressed.DOWN) bf.playAnimation('singDOWN');

        if (FlxG.keys.justPressed.LEFT) bf.playAnimation('singLEFT');
        else if (FlxG.keys.justPressed.RIGHT) bf.playAnimation('singRIGHT');

        if (FlxG.keys.pressed.ESCAPE) FlxG.switchState(DebugState.new);
    }

    override function onBeat(beat:Int) {
        super.onBeat(beat);
    }
}