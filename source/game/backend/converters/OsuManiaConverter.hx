package game.backend.converters;

import game.data.SongData;
import moonchart.formats.BasicFormat.BasicMetaData;
import moonchart.formats.BasicFormat.BasicNote;
import moonchart.parsers.OsuParser;

class OsuManiaConverter {
    public static function parse(string:String):SongData {
        var songData:SData = {
            songName: "xdd",
            difficulties: [
                {
                    name: "normal",
                    enemyNotes: [],
                    playerNotes: [],
                    events: [],
                    metadata: {
                        speed: 2.0,
                        bpm: 130,
                        player: "bf",
                        enemy: "dad",
                        girlfriend: "gf"
                    }
                }
            ]
        };

        var s:SongData = SongData.readJson(songData);
        var diff:DData = s.getDifficulty("normal");

        var parser:OsuParser = new OsuParser();
        var data:OsuFormat = parser.parse(string);
        var mania:moonchart.formats.OsuMania = new moonchart.formats.OsuMania(data);

        var notes:Array<BasicNote> = mania.getNotes();
        var metadata:BasicMetaData = mania.getChartMeta();

        for (note in notes){
            diff.playerNotes.push({
                lane: note.lane,
                time: note.time,
				duration: note.length / 0.65
            });
        }

        diff.metadata.bpm = metadata.bpmChanges[0].bpm;
        s.data.songName = metadata.title;

        s.name = s.data.songName;

        return s;
    }
}