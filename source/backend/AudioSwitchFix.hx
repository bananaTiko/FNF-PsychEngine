package backend;

import openfl.media.Sound;
import lime.media.openal.ALC;
import lime.media.AudioManager;

typedef PlayingSound = {
	var sound:FlxSound;
	var path:String;
	var time:Float;
}

/**
 * @see https://github.com/FNF-CNE-Devs/CodenameEngine/blob/main/source/funkin/backend/system/modules/AudioSwitchFix.hx
 * @author TheLeerName
 */
@:access(flixel.sound.FlxSound)
class AudioSwitchFix {
	public static var currentAudioDevice:String;
	public static function checkForDisconnect() {
		// default audio device switch fix!!
		// or the "AL lib: (EE) ALCwasapiPlayback_mixerProc: Failed to get padding: 0x88890004" fix
		// dont ask how i found this i just got it by random 💀 - TheLeerName

		static var prevDevice:String = null;
		currentAudioDevice = ALC.getString(null, 0x1013);
		if (prevDevice != null && prevDevice != currentAudioDevice) {
			reconnect();
			trace('Audio was reconnected: '.toCMD(GREEN_BOLD) + currentAudioDevice.substring(currentAudioDevice.indexOf('(') + 1, currentAudioDevice.lastIndexOf(')')).toCMD(GREEN));
		}
		prevDevice = currentAudioDevice;
	}

	public static function reconnect() {
		// have a bug which i dont know how to fix pls help!!!
		// bug: if you in pause it will break song, but you can just restart song and all be fine!
		var music:PlayingSound = null;
		var playingList:Array<PlayingSound> = [];

		var sideways:Map<Sound, String> = [];
		for (key => sound in Paths.currentTrackedSounds)
			sideways.set(sound, key);
		var l = FlxG.sound.list.members.copy();
		l.push(FlxG.sound.music);
		for(e in l) {
			if (e.playing) {
				playingList.push({
					sound: e,
					path: sideways.get(e._sound),
					time: e.time
				});
				e.stop();
			}
		}

		for (key in Paths.currentTrackedSounds.keys())
			Paths.dumpAsset(key);
		Paths.currentTrackedSounds.clear();

		AudioManager.shutdown();
		AudioManager.init();

		for (sound => key in sideways)
			Paths.soundAbsolute(key);

		for(e in playingList) {
			e.sound.loadEmbedded(Paths.soundAbsolute(e.path));
			e.sound.play(e.time);
		}
	}
}