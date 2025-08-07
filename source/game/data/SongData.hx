package game.data;

import json2object.JsonParser;

class SongData {
    public var data:SData;
    public var difficulties:Array<DData>;
    public var name:String;

    public function new(song:String) {
        var parser:JsonParser<SData> = new JsonParser<SData>();
        data = parser.fromJson(Paths.getText("Data.json", "data/songs/" + song));
        difficulties = data.difficulties;
        name = data.songName;
    }

    public function getDifficulty(name:String):DData {
        var data:Null<DData> = Lambda.find(difficulties, i -> i.name == name);
        return data ?? Lambda.find(difficulties, i -> i.name == "normal");
    }
}

typedef SData = {
    songName:String,
    difficulties:Array<DData>
}

typedef DData = {
    name:String,
    metadata:DMetadata,
    enemyNotes:Array<NData>,
    playerNotes:Array<NData>,
    events:Array<EventData>
}

typedef EventData = {
    name:String,
    time:Float,
    args:Array<String>
}

typedef NData = {
    time:Float,
    lane:Int,
    ?duration:Float
}

typedef DMetadata = {
    speed:Float,
    bpm:Float,
    player:String,
    enemy:String,
    girlfriend:String,
    ?songPrefix:String,
    ?songSuffix:String
}