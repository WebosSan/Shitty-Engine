package game.backend;

import flixel.FlxSprite;

class Settings {
    public static var currentMod:String = "Friday Night Funkin'";
    public static var antialiasing:Bool = true;

    public static var currentSpeed:Float = 1;

    public static function init() {
        FlxSprite.defaultAntialiasing = antialiasing;
    }
}