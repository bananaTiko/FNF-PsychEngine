package backend;

import backend.ClientPrefs;
import openfl.filters.ColorMatrixFilter;

@:access(flixel.FlxGame)
class ColorBlindness extends ColorMatrixFilter
{
	public var filterEnabled:Bool = true;

	public function new(type:String)
	{
		filterEnabled = type.toUpperCase() != "NONE";

		if (!filterEnabled)
			return;

		var filter:Array<Float> = [];
		switch (type.toUpperCase())
		{
			// Color Blindness Types
			case "DEUTERANOPIA":
				filter = [
					0.43, 0.72, -.15, 0, 0,
					0.34, 0.57, 0.09, 0, 0,
					-.02, 0.03,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "PROTANOPIA":
				filter = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "TRITANOPIA":
				filter = [
					0.97, 0.11, -.08, 0, 0,
					0.02, 0.82, 0.16, 0, 0,
					0.06, 0.88, 0.18, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "PROTANOMALY":
				filter = [
					0.817, 0.183, 0, 0, 0,
					0.333, 0.667, 0, 0, 0,
					0, 0.125, 0.875, 0, 0,
					   0, 0, 0, 1, 0,
				];
			case "TRITANOMALY":
				filter = [
					0.967, 0.033, 0, 0, 0,
					0, 0.733, 0.267, 0, 0,
					0, 0.183, 0.817, 0, 0,
					   0, 0, 0, 1, 0,
				];
			case "ACHROMATOPSIA":
				filter = [
					0.299, 0.587, 0.114, 0, 0,
					0.299, 0.587, 0.114, 0, 0,
					0.299, 0.587, 0.114, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "MONOCHROMACY":
				filter = [
					0.333, 0.333, 0.333, 0, 0,
					0.333, 0.333, 0.333, 0, 0,
					0.333, 0.333, 0.333, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "VIVID":
				filter = [
					0.90, 0.10, 0.00, 0, 0,
					0.00, 0.80, 0.20, 0, 0,
					0.00, 0.20, 0.80, 0, 0,
					   0,    0,    0, 1, 0,
				];
	            	case "DOG_VISION":
		                filter = [
		                    	0.5, 0.2, 0.2, 0, 0, // Reduced red, more green
		                    	0.2, 0.5, 0.2, 0, 0, // More yellow and green
		                   	 0.1, 0.1, 0.8, 0, 0, // Increased blue
					   0,    0,    0, 1, 0, // No change in alpha
		                ];
	            	case "GRAYSCALE":
		                filter = [
		                    	0.299, 0.299, 0.299, 0, 0, // Red channel converted to grayscale
		                    	0.587, 0.587, 0.587, 0, 0, // Green channel converted to grayscale
		                    	0.114, 0.114, 0.114, 0, 0, // Blue channel converted to grayscale
					   0,     0,     0, 1, 0      // Alpha remains unchanged
		                ];
	            	case "GRAYSCALE INVERTED":
		                filter = [
		                    	0.701, 0.701, 0.701, 0, 0, // Red channel converted to grayscale
		                    	0.413, 0.413, 0.413, 0, 0, // Green channel converted to grayscale
		                    	0.886, 0.886, 0.886, 0, 0, // Blue channel converted to grayscale
					   0,     0,     0, 1, 0      // Alpha remains unchanged
		                ];
	            	case "INVERTED":
		                filter = [
 					0,  1,  1,  0, 0, // Red to Cyan
					1,  0,  1,  0, 0, // Green to Magenta
					1,  1,  0,  0, 0, // Blue to Yellow
					1,  1,  1,  1, 0, // White to Black
				       -1, -1, -1,  1, 0, // Black to White
					0,  0,  0,  1, 0, // Light Blue to Orange
					0,  0,  0,  1, 0, // Orange to Light Blue
					0,  1,  0,  0, 0, // Pink to Green
					0,  1,  0,  0, 0, // Yellow to Blue
					0,  0,  1,  0, 0, // Purple to Lime Green
 					0,  0,  1,  0, 0  // Lime Green to Purple
		                ];

			default:
		}

		super(filter);
	}

	public static function setFilter()
	{
		if (FlxG.game._filters == null)
			FlxG.game._filters = [];

		if (FlxG.game._filters.contains(Main.colorFilter))
			FlxG.game._filters.remove(Main.colorFilter);

		Main.colorFilter = new ColorBlindness(ClientPrefs.data.colorFilter);
		if (ClientPrefs.data.colorFilter != "NONE")
		{
			FlxG.game._filters.push(Main.colorFilter);
		}
		/*else
		{
			FlxG.game.setFilters([]);
		}*/
	}
}
