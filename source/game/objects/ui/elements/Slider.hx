package game.objects.ui.elements;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Slider extends FlxSprite {
    public var value(default, set):Float = 0; 
    public var vertical(default, null):Bool; 
    public var handle:FlxSprite; 
    public var dragging:Bool = false; 
    public var onValueChanged:Float->Void = null;
    
    public function new(x:Float, y:Float, width:Int, height:Int, color:FlxColor) {
        super(x, y);
        
        vertical = height > width;
        
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRoundRect(this, 0, 0, width, height, 10, 10, color);
        
        var handleSize = vertical ? Math.min(width * 1.5, height * 0.2) : Math.min(height * 1.5, width * 0.2);
        handle = new FlxSprite(0, 0);
        handle.makeGraphic(Std.int(handleSize), Std.int(handleSize), FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawCircle(handle, handle.width/2, handle.height/2, handleSize/2, FlxColor.WHITE);
        
        updateHandlePosition();
        
        solid = true;
    }
    
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        
        checkMouseInteraction();
    }
    
    private function checkMouseInteraction():Void {
        var mouse = FlxG.mouse;
        var mouseX = mouse.getWorldPosition(camera).x;
        var mouseY = mouse.getWorldPosition(camera).y;
        
        var overHandle = mouseX >= handle.x && mouseX <= handle.x + handle.width &&
                        mouseY >= handle.y && mouseY <= handle.y + handle.height;
        
        var overSlider = mouseX >= x && mouseX <= x + width &&
                        mouseY >= y && mouseY <= y + height;
        
        if (mouse.justPressed && (overHandle || overSlider)) {
            dragging = true;
            
            if (!overHandle && overSlider) {
                updateValueFromMouse();
            }
        }
        
        if (dragging && mouse.pressed) {
            updateValueFromMouse();
        }
        
        if (mouse.justReleased) {
            dragging = false;
        }
    }
    
    private function updateValueFromMouse():Void {
        if (vertical) {
            var localY = FlxG.mouse.y - y;
            value = 1 - FlxMath.bound(localY / height, 0, 1);
        } else {
            var localX = FlxG.mouse.x - x;
            value = FlxMath.bound(localX / width, 0, 1);
        }
        if (onValueChanged != null) onValueChanged(value);
    }
    
    private function set_value(newValue:Float):Float {
        value = FlxMath.bound(newValue, 0, 1);
        return value;
    }
    
    private function updateHandlePosition():Void {
        if (vertical) {
            handle.x = x + (width - handle.width) / 2;
            handle.y = y + (height - handle.height) * (1 - value);
        } else {
            handle.x = x + (width - handle.width) * value;
            handle.y = y + (height - handle.height) / 2;
        }
    }
    
    override public function draw():Void {
        updateHandlePosition();
        super.draw();
        handle.draw();
    }
    
    override public function destroy():Void {
        handle.destroy();
        super.destroy();
    }

    override function set_camera(v:FlxCamera):FlxCamera {
		this.handle.camera = v;
		return super.set_camera(v);
	}

	override function set_cameras(v:Array<FlxCamera>):Array<FlxCamera> {
		this.handle.cameras = v;
		return super.set_cameras(v);
	}
}