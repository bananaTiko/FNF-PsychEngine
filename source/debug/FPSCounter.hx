package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

#if flash
import openfl.Lib;
#end

/**
    The FPS class provides an easy-to-use monitor to display
    the current frame rate of an OpenFL project.
**/
class FPSCounter extends TextField
{
    public var currentFPS(default, null):Float;
    public var maxFPS(default, null):Float;
    public var currentMemory(default, null):Float;
    public var maxMemory(default, null):Float;
    @:noCompletion private var times:Array<Float>;
    private var lastUpdateTime:Float;
    private var lastFPSUpdate:Float;
    private var fpsInterval:Float = 1.0; // Update FPS every second
    private var totalTime:Float = 0; // Track total time elapsed for FPS calculation
    private var totalFrames:Int = 0; // Track total frames processed

    public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
    {
        super();

        this.x = x;
        this.y = y;

        currentFPS = 0;
        maxFPS = FlxG.drawFramerate; // Default max FPS to draw framerate
        currentMemory = 0;
        maxMemory = getMaxMemory(); // Set max memory at start
        lastUpdateTime = haxe.Timer.stamp();
        lastFPSUpdate = lastUpdateTime;
        selectable = false;
        mouseEnabled = false;
        defaultTextFormat = new TextFormat("_sans", 14, color);
        autoSize = LEFT;
        multiline = true;
        text = "FPS: ";
        times = [];
    }

    // Event Handlers
    private override function __enterFrame(deltaTime:Float):Void
    {
        var now:Float = haxe.Timer.stamp();
        times.push(now);
        while (times[0] < now - 1000) times.shift();

        // Calculate FPS based on precise time and frame count
        totalFrames++;
        totalTime += deltaTime;

        // Only update FPS every second
        if (totalTime >= fpsInterval)
        {
            currentFPS = totalFrames / totalTime;  // FPS is frames divided by time (in seconds)
            totalTime = 0;  // Reset the time counter
            totalFrames = 0;  // Reset the frame counter
            lastFPSUpdate = now;

            // Update the text display with FPS and memory
            updateText();
        }

        // Memory update (can also be optimized similarly)
        if (now - lastUpdateTime >= 2) // Update memory every 2 seconds
        {
            currentMemory = getMemoryUsage();
            lastUpdateTime = now;
        }
    }

    public dynamic function updateText():Void
    {
        // Only round FPS when necessary (e.g., when FPS is less than 30)
        var displayFPS:Float = currentFPS;
        if (currentFPS < 30)
        {
            // Round FPS to one decimal place only when FPS is low (e.g., below 30)
            displayFPS = Math.round(currentFPS * 10) / 10; // Round to 1 decimal place
        }

        // Format the text to display current FPS/max FPS and current memory/max memory
        text = 'FPS: ' + displayFPS + ' / ' + maxFPS
            + '\nMemory: ' + formatMemory(currentMemory) + ' / ' + formatMemory(maxMemory);
        
        // Update text color based on FPS
        textColor = 0xFFFFFFFF;
        if (currentFPS < FlxG.drawFramerate * 0.5)
            textColor = 0xFFFF0000;  // Red if FPS is too low
    }

    inline function getMemoryUsage():Float
    {
        return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
    }

    /**
     * Retrieves the max memory usage for the system (in MB or similar units).
     * This value is platform dependent and can be based on the system's total available memory.
     */
    inline function getMaxMemory():Float
    {
        // Get maximum available memory (this is just an example, adjust it as necessary)
        return 4096; // Default to 4GB of available memory as a placeholder
    }

    /**
     * Formats the memory usage value into a human-readable string (B, KB, MB, etc.)
     */
    public static function formatMemory(Bytes:Float, Precision:Int = 2):String
    {
        var units:Array<String> = ["B", "KB", "MB", "GB", "TB", "PB"];
        var divisor:Int = 1024; // Using 1024 as the base for memory measurement
        var curUnit = 0;
        while (Bytes >= divisor && curUnit < units.length - 1)
        {
            Bytes /= divisor;
            curUnit++;
        }
        return FlxMath.roundDecimal(Bytes, Precision) + ' ' + units[curUnit];
    }
}
