#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.*;
import flixel.FlxSprite;
import flixel.text.FlxText;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
#if sys
import sys.FileSystem;
#end
import flixel.addons.ui.FlxInputText;

class BiosMenuState extends MusicBeatState {
	
	var bg:FlxSprite;
	var background:FlxSprite;
    var imageSprite:FlxSprite;
	
    var imagePath:Array<String>;
    var charDesc:Array<String>;
    var charName:Array<String>;
	var bgColors:Array<String>;

	var curSelected:Int = -1;
    var currentIndex:Int = 0;

    var descriptionText:FlxText;
    var characterName:FlxText;

	override function create() {
		
		FlxG.mouse.visible = false;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Reading character Bios", null);
		#end

		
		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        background.setGraphicSize(Std.int(background.width * 1.2));
		background.color = 0xFF683FFD;
        background.screenCenter();
        add(background);

		// i took this from psych's engine code lol
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33000000, 0x0));
		grid.velocity.set(30, 30);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		// EDIT YOU IMAGES HERE / DONT FORGET TO CREATE A FOLDER IN images CALLED bios IT SHOULD LOOK LIKE THIS 'images/bios'
		// REMINDER!!! THE IMAGES MUST BE 518x544, IF NOT, THEY WONT FIT ON THE SCREEN!!
		imagePath = ["Bios/boyfriend", "Bios/girlfriend", "Bios/dad", "Bios/mom", "Bios/spooky", "Bios/pico", "Bios/nene", "Bios/darnell", "Bios/tankman"];

		// DESCRIPTION HERE
        charDesc = [
            "Hey! It's Boyfriend! Our spiky-haired hero is out to prove he's worthy of Girlfriend—by singing his heart out!",
            "Girlfriend is the love of Boyfriend's life, and he's determined to spend forever with her. The catch? Her father won’t allow it!",
            "Daddy Dearest, Girlfriend's intimidating ex-rockstar father, disapproves of her new partner. Boyfriend will need to give it his all to earn his approval!",
            "If you thought Girlfriend's dad was tough, wait until you meet her mom! Mommy Mearest is fierce in a sing-off, and Boyfriend will need to stay sharp to win her approval!",
            "Skid and Pump, the stars of Sr Pelo's Spooky Month series, bring excitement wherever they go. Despite their cute looks, they're tough opponents—so don't let your guard down!",
            "Pico, the fiery redhead from Tom Fulp's Pico's School, faced a canceled sequel and fading popularity. But now he's back—and ready to rap!",
            "Nene, the suicidal star of Nene Interactive Suicide, is obsessed with sharp weapons and revenge. After Pico's mistake costs them their payday, she's out for blood. Stay sharp and keep the rhythm—Nene always has her knives ready!",
            "Darnell, the fire-loving protagonist of Darnell Plays With Fire, is back! He and Nene are out to kill Pico for messing up their job of taking out Boyfriend. After rap battling, get ready for a rhythm-fueled fist fight!",
            "Tankman, the creation of JohnnyUtah's cynical mind and driver of the iconic Newgrounds tank, is bored enough to agree to a singing match—right in the middle of a war! With Girlfriend held at gunpoint, Boyfriend has no choice but to make the most of it!"
        ];

		// NAME HERE
        charName = ["Boyfriend", "Girlfriend", "Daddy Dearest", "Mommy Mearest", "Skid & Pump", "Pico", "Nene", "Darnell", "Tankman"];

		// SET UP THE FIRST IMAGE YOU WANT TO SEE WHEN ENTERING THE MENU
		imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image("Bios/boyfriend"));
        add(imageSprite);

		characterName = new FlxText(630, 94, charName[currentIndex]);
        characterName.setFormat(Paths.font("vcr.ttf"), 96, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterName.antialiasing = true;
		characterName.borderSize = 4;
        add(characterName);

		descriptionText = new FlxText(630, 247, charDesc[currentIndex]);
        descriptionText.setFormat(Paths.font("vcr.ttf"), 34, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.antialiasing = true;
		descriptionText.borderSize = 2.5;
        add(descriptionText);

		var arrows = new FlxSprite(218, 26).loadGraphic(Paths.image('Bios/assets/biosThing'));
		add(arrows);

		super.create();
	}

	override function update(elapsed:Float) {
		
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) 
			{
				currentIndex--;
				if (currentIndex < 0)
				{
					currentIndex = imagePath.length - 1;
				}
				remove(imageSprite);
				imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
				add(imageSprite);
				descriptionText.text = charDesc[currentIndex];
				characterName.text = charName[currentIndex];
				FlxG.sound.play(Paths.sound('scrollMenu'));  
	
			}
			else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
			{
				currentIndex++;
				if (currentIndex >= imagePath.length)
				{
					currentIndex = 0;
				}
				remove(imageSprite);
				imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
				add(imageSprite);
				descriptionText.text = charDesc[currentIndex];
				characterName.text = charName[currentIndex];  
				FlxG.sound.play(Paths.sound('scrollMenu'));    
		
			}
			if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new MainMenuState());
					FlxG.mouse.visible = true;
				}
		
		super.update(elapsed);
	}
}
