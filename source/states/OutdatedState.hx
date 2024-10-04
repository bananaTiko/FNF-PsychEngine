package states;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 10, FlxG.width,
			"HEY! Your Version of Untitled Psych Fork is outdated!\n"
			+ 'v' + MainMenuState.untiledpsychForkVersion + ' < v' + TitleState.updateVersion + '\n'
			,32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.screenCenter(X);
		add(warnText);

		updateText = new FlxText(0, 10, FlxG.width,
			"Press ENTER to update or ESCAPE to ignore this!"
			,24);
		updateText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			updateText.y = 710 - updateText.height;
			updateText.x = 10;
		add(updateText);
	}
	}

	function update(elapsed:Float)
		{
			if(!leftState) {
				if (FlxG.keys.justPressed.ENTER) {
					leftState = true;
					#if windows FlxG.switchState(states.UpdateState.new);
					#else
					CoolUtil.browserLoad("https://github.com/bananaTiko/FNF-PsychEngine/releases/latest");
					#end
				}
				if (FlxG.keys.justPressed.SPACE) {
					CoolUtil.browserLoad("https://github.com/bananaTiko/FNF-PsychEngine/releases/latest");
				}
				else if(controls.BACK) {
					leftState = true;
				}
	
			if(leftState)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
			super.update(elapsed);
		}
	}
}
