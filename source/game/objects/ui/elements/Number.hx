package game.objects.ui.elements;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Number extends FlxTypedSpriteGroup<FlxSprite> {
    public var minus:Button;
    public var plus:Button;
    public var numberBg:FlxSprite;
    public var numberTxt:FlxText;

    public var value:Float;

    private var _change:Float;

    public function new(x:Float, y:Float, width:Int, height:Int, color:FlxColor, ?defaultValue:Float = 1, ?valueDifference:Float = 0.1) {
        super(x, y);
        _change = valueDifference;
        value = defaultValue;

        minus = new Button(0, 0, Std.int(width / 10), height, "-", color);

        numberBg = new FlxSprite(minus.width, 0).makeGraphic(width, height, color);

        numberTxt = new FlxText(0, 0, numberBg.width, Std.string(value), 12);
        numberTxt.font = Paths.font('GoogleSansCode-VariableFont_wght');
        numberTxt.alignment = CENTER; 
        numberTxt.updateHitbox();
        
        numberTxt.x = numberBg.x + (numberBg.width / 2 - numberTxt.width / 2);
        numberTxt.y = numberBg.y + (numberBg.height / 2 - numberTxt.height / 2);

        plus = new Button(numberBg.x + numberBg.width, 0, Std.int(width / 10), height, "+", color);

        minus.onClick = () -> value -= _change;
        plus.onClick = () -> value += _change;

        add(numberBg);
        add(numberTxt);
        add(minus);
        add(plus);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        numberTxt.text = Std.string(value);
        numberTxt.updateHitbox();
        numberTxt.x = numberBg.x + (numberBg.width / 2 - numberTxt.width / 2);
        numberTxt.y = numberBg.y + (numberBg.height / 2 - numberTxt.height / 2);
    }
}