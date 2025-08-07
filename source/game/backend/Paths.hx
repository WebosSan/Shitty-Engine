package game.backend;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Assets;
import openfl.filesystem.File;

class Paths
{
	public static var cacheImages:Map<String, FlxGraphic> = new Map();

	public static function font(path:String, ?directory:String = "fonts") {
		return getPath(path + '.ttf', directory);	
	}

	public static function image(path:String, ?directory:String = "images"):FlxGraphic
	{
		var p:String = getPath(path + ".png", directory);
		if (cacheImages.exists(p))
		{
			return cacheImages.get(p);
		}
		if (exists(p) && !cacheImages.exists(p))
		{
			var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(p), false, false);
			graphic.persist = true;
			graphic.destroyOnNoUse = false;
			cacheImages.set(p, graphic);
			return graphic;
		}
		return null;
	}

	public static function sparrow(path:String, ?directory:String = "images"):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(image(path, directory), getText(path + ".xml", directory));
	}

	public static function getText(path:String, ?directory:String = "data"):String
	{
		var p:String = getPath(path, directory);
		if (exists(p))
		{
			return Assets.getText(p);
		}
		return null;
	}

	public static function getPath(path:String, ?directory:String)
	{
		var modPath:String = 'mods/${Settings.currentMod}/$path';
		if (directory != null && directory != "")
			modPath = 'mods/${Settings.currentMod}/$directory/$path';
		if (exists(modPath))
			return modPath;

		var assetsPath:String = 'assets/$path';
		if (directory != null && directory != "")
			assetsPath = 'assets/$directory/$path';
		return assetsPath;
	}

	public static inline function exists(path:String):Bool
	{
		return new File(path).exists;
	}

	public static function clear()
	{
		for (key => graphic in cacheImages)
		{
			graphic.destroy();
			cacheImages.remove(key);
		}

		cacheImages.clear();
	}
}
