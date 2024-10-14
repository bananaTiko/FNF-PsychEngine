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
			case "GAMEBOY": //These below are for fun
				filter = [
					0.25, 0.25, 0.25, 0, 0,
					0.25, 0.25, 0.25, 0, 0,
					0.25, 0.25, 0.25, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "VIRTUALBOY":
				filter = [
					0.30, 0.00, 0.00, 0, 0,
					0.00, 0.00, 0.00, 0, 0,
					0.00, 0.00, 0.00, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "NES":
				filter = [
					0.20, 0.50, 0.30, 0, 0,
					0.20, 0.50, 0.30, 0, 0,
					0.20, 0.50, 0.30, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "SNES":
				filter = [
					0.40, 0.40, 0.20, 0, 0,
					0.40, 0.40, 0.20, 0, 0,
					0.40, 0.40, 0.20, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "GAMEBOY_COLOR":
				filter = [
					0.50, 0.25, 0.25, 0, 0,
					0.25, 0.50, 0.25, 0, 0,
					0.25, 0.25, 0.50, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "SEGA_GENESIS":
				filter = [
					0.30, 0.59, 0.11, 0, 0,
					0.30, 0.59, 0.11, 0, 0,
					0.30, 0.59, 0.11, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "ATARI_2600":
				filter = [
					0.90, 0.10, 0.00, 0, 0,
					0.00, 0.80, 0.20, 0, 0,
					0.00, 0.20, 0.80, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "COMMODORE_64":
				filter = [
					0.35, 0.55, 0.10, 0, 0,
					0.35, 0.55, 0.10, 0, 0,
					0.35, 0.55, 0.10, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "APPLE_II":
				filter = [
					0.20, 0.60, 0.20, 0, 0,
					0.20, 0.60, 0.20, 0, 0,
					0.20, 0.60, 0.20, 0, 0,
					   0,    0,    0, 1, 0,
				];
			case "ZX_SPECTRUM":
				filter = [
					0.30, 0.59, 0.11, 0, 0,
					0.30, 0.59, 0.11, 0, 0,
					0.30, 0.59, 0.11, 0, 0,
					   0,    0,    0, 1, 0,
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
