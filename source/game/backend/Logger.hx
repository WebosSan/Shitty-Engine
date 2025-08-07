package game.backend;

import flixel.util.FlxColor;
import haxe.PosInfos;
import lime.app.Application;

class Logger {
    private static var logFormat:String = "[{0}] ({1}) {2}:({3}:{4}): {5}";

	public static function log(msg:Dynamic, ?infos:PosInfos)
	{
		print(msg, LOG, infos);
    }

	public static function warn(msg:Dynamic, ?infos:PosInfos)
	{
		print(msg, WARN, infos);
    }

	public static function error(msg:Dynamic, ?infos:PosInfos)
	{
		print(msg, ERROR, infos);
    }

	public static function print(text:Dynamic, logLevel:LogLevel, infos:PosInfos)
	{
        var head:String;
        var colorCode:String;

        switch (logLevel) {
            case LOG:
                colorCode = AnsiiCodes.GRAY;
                head = 'LOG';
            case WARN:
                colorCode = AnsiiCodes.YELLOW;
                head = 'WARN';
            case ERROR:
                colorCode = AnsiiCodes.RED;
                head = 'ERROR';
        }

		var msg = StringTools.replace(logFormat, "[", colorCode + "[" + colorCode);
		msg = StringTools.replace(msg, "]", colorCode + "]" + colorCode);
        msg = StringTools.replace(msg, "(", AnsiiCodes.GRAY + "(" + AnsiiCodes.RESET);
        msg = StringTools.replace(msg, ")", AnsiiCodes.GRAY + ")" + AnsiiCodes.RESET);
        msg = StringTools.replace(msg, "{0}", colorCode + head + AnsiiCodes.RESET);
        msg = StringTools.replace(msg, "{1}", getTime());
		msg = StringTools.replace(msg, "{2}", infos.fileName);
		msg = StringTools.replace(msg, "{3}", infos.methodName);
		msg = StringTools.replace(msg, "{4}", Std.string(infos.lineNumber));
        msg = StringTools.replace(msg, "{5}", Std.string(text));

        Sys.println(msg + AnsiiCodes.RESET);
    }

    private static function getTime():String {
        var time:Date = Date.now();
        return '${formatTwoDigits(time.getHours())}:${formatTwoDigits(time.getMinutes())}:${formatTwoDigits(time.getSeconds())}';
    }

    private static function formatTwoDigits(value:Int):String {
        return value < 10 ? '0$value' : '$value';
    }
}

enum LogLevel {
    LOG;
    WARN;
    ERROR;
}

abstract AnsiiCodes(String) to String {
    // Formatting
    public static var RESET:String = "\033[0m";
    public static var BOLD:String = "\033[1m";
    public static var UNDERLINE:String = "\033[4m";
    public static var REVERSED:String = "\033[7m";
    
    // Regular colors
    public static var BLACK:String = "\033[0;30m";
    public static var RED:String = "\033[0;31m";
    public static var GREEN:String = "\033[0;32m";
    public static var YELLOW:String = "\033[0;33m";
    public static var BLUE:String = "\033[0;34m";
    public static var MAGENTA:String = "\033[0;35m";
    public static var CYAN:String = "\033[0;36m";
    public static var WHITE:String = "\033[0;37m";
    
    // Gray colors (from the 256-color palette)
    public static var GRAY:String = "\033[38;5;244m";
    public static var DARK_GRAY:String = "\033[38;5;238m";
    public static var LIGHT_GRAY:String = "\033[38;5;250m";
    
    // Bright colors
    public static var BRIGHT_BLACK:String = "\033[0;90m";
    public static var BRIGHT_RED:String = "\033[0;91m";
    public static var BRIGHT_GREEN:String = "\033[0;92m";
    public static var BRIGHT_YELLOW:String = "\033[0;93m";
    public static var BRIGHT_BLUE:String = "\033[0;94m";
    public static var BRIGHT_MAGENTA:String = "\033[0;95m";
    public static var BRIGHT_CYAN:String = "\033[0;96m";
    public static var BRIGHT_WHITE:String = "\033[0;97m";
    
    // Background colors
    public static var BG_BLACK:String = "\033[40m";
    public static var BG_RED:String = "\033[41m";
    public static var BG_GREEN:String = "\033[42m";
    public static var BG_YELLOW:String = "\033[43m";
    public static var BG_BLUE:String = "\033[44m";
    public static var BG_MAGENTA:String = "\033[45m";
    public static var BG_CYAN:String = "\033[46m";
    public static var BG_WHITE:String = "\033[47m";
    public static var BG_GRAY:String = "\033[48;5;244m";
    public static var BG_DARK_GRAY:String = "\033[48;5;238m";
    public static var BG_LIGHT_GRAY:String = "\033[48;5;250m";

    public function new(color:FlxColor, ?bgColor:FlxColor = null) {
        // Convert foreground color
        var r:Int = Math.round(color.red * 5 / 255);
        var g:Int = Math.round(color.green * 5 / 255);
        var b:Int = Math.round(color.blue * 5 / 255);
        var ansiCode:Int = 16 + (36 * r) + (6 * g) + b;
        var result = '\033[38;5;${ansiCode}m';
        
        // Convert background color if provided
        if (bgColor != null) {
            var bgR:Int = Math.round(bgColor.red * 5 / 255);
            var bgG:Int = Math.round(bgColor.green * 5 / 255);
            var bgB:Int = Math.round(bgColor.blue * 5 / 255);
            var bgAnsiCode:Int = 16 + (36 * bgR) + (6 * bgG) + bgB;
            result += '\033[48;5;${bgAnsiCode}m';
        }
        
        this = result;
    }

    // Helper function to create with both foreground and background
    public static function withBackground(fgColor:FlxColor, bgColor:FlxColor):AnsiiCodes {
        return new AnsiiCodes(fgColor, bgColor);
    }
    
    // Helper function to create gray colors easily
    public static function gray(level:Int):AnsiiCodes {
        level = Std.int(Math.max(0, Math.min(23, level))); // Clamp to 0-23
        var ansiCode = 232 + level; // Grayscale starts at 232
        return new AnsiiCodes(FlxColor.fromRGB(level * 11, level * 11, level * 11));
    }
}