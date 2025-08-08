package game.data;

import json2object.JsonParser;
import json2object.JsonWriter;

class SongData
{
	public var data:SData;
	public var difficulties:Array<DData>;
	public var name:String;

	private var _parser:JsonParser<SData>;

	private var _defaultData:SData = {
		songName: "bopeebo",
		difficulties: [
			{
				name: "normal",
				metadata: {
					speed: 2.0,
					bpm: 100,
					player: 'bf',
					enemy: 'dad',
					girlfriend: 'gf',
					hasPlayerVocals: true,
					hasEnemyVocals: true
				},
				playerNotes: [],
				enemyNotes: [],
				events: []
			}
		]
	};

	public function new(song:String, ?readFile:Bool = true)
	{
		_parser = new JsonParser<SData>();
		if (readFile)
		{
			data = Paths.exists(Paths.getPath('Data.json',
				'data/songs/$song')) ? _parser.fromJson(Paths.getText("Data.json", "data/songs/" + song), song) : _defaultData;
			difficulties = data.difficulties;
			name = data.songName;
		}
	}

	public static function readJson(json:SData) {
		var s:SongData = new SongData("", false);
		s.data = json;
		s.difficulties = s.data.difficulties;
		s.name = s.data.songName;

		return s;
	}

	public function getDifficulty(name:String):DData
	{
		var data:Null<DData> = Lambda.find(difficulties, i -> i.name == name);
		return data ?? Lambda.find(difficulties, i -> i.name == "normal");
	}

	public function toString():String
	{
		var writter:JsonWriter<SData> = new JsonWriter<SData>();
		var str:String = writter.write(data);
		return str.substr(writter.write(data).indexOf("{"));
	}
}

typedef SData =
{
	songName:String,
	difficulties:Array<DData>
}

typedef DData =
{
	name:String,
	metadata:DMetadata,
	enemyNotes:Array<NData>,
	playerNotes:Array<NData>,
	events:Array<EventData>
}

typedef EventData =
{
	name:String,
	time:Float,
	args:Array<String>
}

typedef NData =
{
	time:Float,
	lane:Int,
	?duration:Float
}

typedef DMetadata =
{
	speed:Float,
	bpm:Float,
	player:String,
	enemy:String,
	girlfriend:String,
	?hasEnemyVocals:Bool,
	?hasPlayerVocals:Bool,
	?playerVocalsVolume:Float,
	?enemyVocalsVolume:Float,
	?instVolume:Float,
	?songPrefix:String,
	?songSuffix:String
}
