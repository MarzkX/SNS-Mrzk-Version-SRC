package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import openfl.display.BlendMode;
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import WindowsData;
#if cpp import CppAPI; #end

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	
	var titleTextColors:Array<FlxColor> = [0xFFDFDFDF, 0xFF303030];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	var staticGroup:FlxTypedGroup<FlxSprite>;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		Lib.application.window.title = Main.appTitle + " - " + "Title";

        #if cpp
		CppAPI.darkMode();
		#end

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		swagShader = new ColorSwap();
		super.create();

		staticGroup = new FlxTypedGroup<FlxSprite>();
		add(staticGroup);

		var daStat:FlxSprite = new FlxSprite(0,0);
		daStat.frames = Paths.getSparrowAtlas('daSTAT');
		daStat.animation.addByPrefix('static','staticFLASH',24,true);
		daStat.animation.play('static');
        daStat.blend = BlendMode.SHADER;
		daStat.scrollFactor.set(0, 0);
		daStat.alpha = 0.0;
		staticGroup.add(daStat);

		var daStat2:FlxSprite = new FlxSprite(401,0);
		daStat2.frames = Paths.getSparrowAtlas('daSTAT');
		daStat2.animation.addByPrefix('static','staticFLASH',24,true);
		daStat2.animation.play('static');
		daStat2.scrollFactor.set(0, 0);
        daStat2.blend = BlendMode.SHADER;
		daStat2.alpha = 0.0;
		staticGroup.add(daStat2);

		var daStat3:FlxSprite = new FlxSprite(802,0);
		daStat3.frames = Paths.getSparrowAtlas('daSTAT');
		daStat3.animation.addByPrefix('static','staticFLASH',24,true);
		daStat3.animation.play('static');
		daStat3.scrollFactor.set(0, 0);
		daStat3.alpha = 0.0;
        daStat3.blend = BlendMode.SHADER;
		staticGroup.add(daStat3);

		var daStat4:FlxSprite = new FlxSprite(1203,0);
		daStat4.frames = Paths.getSparrowAtlas('daSTAT');
		daStat4.animation.addByPrefix('static','staticFLASH',24,true);
		daStat4.animation.play('static');
        daStat4.blend = BlendMode.SHADER;
		daStat4.scrollFactor.set(0, 0);
		daStat4.alpha = 0.0;
		staticGroup.add(daStat4);

		var daStat5:FlxSprite = new FlxSprite(0,299);
		daStat5.frames = Paths.getSparrowAtlas('daSTAT');
		daStat5.animation.addByPrefix('static','staticFLASH',24,true);
		daStat5.animation.play('static');
		daStat5.scrollFactor.set(0, 0);
        daStat5.blend = BlendMode.SHADER;
		daStat5.alpha = 0.0;
		staticGroup.add(daStat5);

		var daStat6:FlxSprite = new FlxSprite(401,299);
		daStat6.frames = Paths.getSparrowAtlas('daSTAT');
		daStat6.animation.addByPrefix('static','staticFLASH',24,true);
		daStat6.animation.play('static');
		daStat6.scrollFactor.set(0, 0);
        daStat6.blend = BlendMode.SHADER;
		daStat6.alpha = 0.0;
		staticGroup.add(daStat6);

		var daStat7:FlxSprite = new FlxSprite(802,299);
		daStat7.frames = Paths.getSparrowAtlas('daSTAT');
		daStat7.animation.addByPrefix('static','staticFLASH',24,true);
		daStat7.animation.play('static');
		daStat7.scrollFactor.set(0, 0);
        daStat7.blend = BlendMode.SHADER;
		daStat7.alpha = 0.0;
		staticGroup.add(daStat7);

		var daStat8:FlxSprite = new FlxSprite(1203,299);
		daStat8.frames = Paths.getSparrowAtlas('daSTAT');
		daStat8.animation.addByPrefix('static','staticFLASH',24,true);
		daStat8.animation.play('static');
		daStat8.scrollFactor.set(0, 0);
        daStat8.blend = BlendMode.SHADER;
		daStat8.alpha = 0.0;
		staticGroup.add(daStat8);

		var daStat9:FlxSprite = new FlxSprite(0,598);
		daStat9.frames = Paths.getSparrowAtlas('daSTAT');
		daStat9.animation.addByPrefix('static','staticFLASH',24,true);
		daStat9.animation.play('static');
        daStat9.blend = BlendMode.SHADER;
		daStat9.scrollFactor.set(0, 0);
		daStat9.alpha = 0.0;
		staticGroup.add(daStat9);

		var daStat10:FlxSprite = new FlxSprite(401,598);
		daStat10.frames = Paths.getSparrowAtlas('daSTAT');
		daStat10.animation.addByPrefix('static','staticFLASH',24,true);
		daStat10.animation.play('static');
        daStat10.blend = BlendMode.SHADER;
		daStat10.scrollFactor.set(0, 0);
		daStat10.alpha = 0;
		daStat10.alpha = 0.0;
		staticGroup.add(daStat10);

		var daStat11:FlxSprite = new FlxSprite(802,598);
		daStat11.frames = Paths.getSparrowAtlas('daSTAT');
		daStat11.animation.addByPrefix('static','staticFLASH',24,true);
		daStat11.animation.play('static');
		daStat11.scrollFactor.set(0, 0);
		daStat11.alpha = 0;
        daStat11.blend = BlendMode.SHADER;
		daStat11.alpha = 0.0;
		staticGroup.add(daStat11);

		var daStat12:FlxSprite = new FlxSprite(1203,598);
		daStat12.frames = Paths.getSparrowAtlas('daSTAT');
		daStat12.animation.addByPrefix('static','staticFLASH',24,true);
		daStat12.animation.play('static');
		daStat12.scrollFactor.set(0, 0);
		daStat12.alpha = 0;
        daStat12.blend = BlendMode.SHADER;
		daStat12.alpha = 0.0;
		staticGroup.add(daStat12);

		if(!ClientPrefs.globalAntialiasing)
		{
			staticGroup.visible = false;
		}

		grain = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('grainfix', 'mouse');
		grain.animation.addByPrefix('grain', 'grain', 12, true);
		grain.setGraphicSize(Std.int(grain.width * 1.25));
		grain.screenCenter();
		grain.alpha = 0;
		grain.antialiasing = ClientPrefs.globalAntialiasing;
        grain.scrollFactor.set(0, 0);
		grain.animation.play('grain');
		if(!ClientPrefs.lowQuality)
			add(grain);

		FlxTween.tween(grain, {alpha: 1}, 1);

		//THE BIG ASS TWEENS
		FlxTween.tween(daStat, {alpha: 0.075}, 1);
		FlxTween.tween(daStat2, {alpha: 0.075}, 1);
		FlxTween.tween(daStat3, {alpha: 0.075}, 1);
		FlxTween.tween(daStat4, {alpha: 0.075}, 1);
		FlxTween.tween(daStat5, {alpha: 0.075}, 1);
		FlxTween.tween(daStat6, {alpha: 0.075}, 1);
		FlxTween.tween(daStat7, {alpha: 0.075}, 1);
		FlxTween.tween(daStat8, {alpha: 0.075}, 1);
		FlxTween.tween(daStat9, {alpha: 0.075}, 1);
		FlxTween.tween(daStat10, {alpha: 0.075}, 1);
		FlxTween.tween(daStat11, {alpha: 0.075}, 1);
		FlxTween.tween(daStat12, {alpha: 0.075}, 1);

		FlxG.save.bind('funkin', 'ninjamuffin99');

		ClientPrefs.loadPrefs();

		if(ClientPrefs.timeBarType != "Time Elapsed")
			ClientPrefs.timeBarType = "Time Elapsed";

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			if (!DiscordClient.isInitialized)
			{
				DiscordClient.initialize();
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				});
			}
			#end

			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					staticGroup.visible = false;
					grain.visible = false;

					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var newLogo:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;
	var logoTween:FlxTween;
	var grain:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();

		if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.length > 0 && titleJSON.backgroundSprite != "none"){
			bg.loadGraphic(Paths.image(titleJSON.backgroundSprite));
		}else{
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		}

		// bg.antialiasing = ClientPrefs.globalAntialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(titleJSON.titlex, titleJSON.titley);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
        logoBl.blend = BlendMode.ADD;
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		newLogo = new FlxSprite(titleJSON.titlex, titleJSON.titley).loadGraphic(Paths.image('logo'));
		newLogo.updateHitbox();
		newLogo.antialiasing = ClientPrefs.globalAntialiasing;
		newLogo.blend = BlendMode.SHADER;
		newLogo.scale.set(1.0, 1.0);

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(titleJSON.gfx, titleJSON.gfy);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
        gfDance.blend = BlendMode.ADD;
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfDance);
		//gfDance.shader = swagShader.shader;

		//add(logoBl);
		add(newLogo);
		//logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(titleJSON.startx, titleJSON.starty);
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/titleEnter.png";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "mods/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)){
			path = "assets/images/titleEnter.png";
		}
		//trace(path, FileSystem.exists(path));
		titleText.frames = FlxAtlasFrames.fromSparrow(BitmapData.fromFile(path),File.getContent(StringTools.replace(path,".png",".xml")));
		#else

		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		#end
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			newTitle = false;
			
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		
		titleText.blend = BlendMode.ADD;
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		var daStatc1:FlxSprite = new FlxSprite(0,0);
		daStatc1.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc1.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc1.animation.play('static');
		daStatc1.scrollFactor.set(0, 0);
		daStatc1.alpha = 0.075;
		add(daStatc1);

		var daStatc2:FlxSprite = new FlxSprite(401,0);
		daStatc2.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc2.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc2.animation.play('static');
		daStatc2.scrollFactor.set(0, 0);
		daStatc2.alpha = 0.075;
		add(daStatc2);

		var daStatc3:FlxSprite = new FlxSprite(802,0);
		daStatc3.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc3.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc3.animation.play('static');
		daStatc3.scrollFactor.set(0, 0);
		daStatc3.alpha = 0.075;
		add(daStatc3);

		var daStatc4:FlxSprite = new FlxSprite(1203,0);
		daStatc4.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc4.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc4.animation.play('static');
		daStatc4.scrollFactor.set(0, 0);
		daStatc4.alpha = 0.075;
		add(daStatc4);

		var daStatc5:FlxSprite = new FlxSprite(0,299);
		daStatc5.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc5.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc5.animation.play('static');
		daStatc5.scrollFactor.set(0, 0);
		daStatc5.alpha = 0.075;
		add(daStatc5);

		var daStatc6:FlxSprite = new FlxSprite(401,299);
		daStatc6.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc6.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc6.animation.play('static');
		daStatc6.scrollFactor.set(0, 0);
		daStatc6.alpha = 0.075;
		add(daStatc6);

		var daStatc7:FlxSprite = new FlxSprite(802,299);
		daStatc7.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc7.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc7.animation.play('static');
		daStatc7.scrollFactor.set(0, 0);
		daStatc7.alpha = 0.075;
		add(daStatc7);

		var daStatc8:FlxSprite = new FlxSprite(1203,299);
		daStatc8.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc8.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc8.animation.play('static');
		daStatc8.scrollFactor.set(0, 0);
		daStatc8.alpha = 0.075;
		add(daStatc8);

		var daStatc9:FlxSprite = new FlxSprite(0,598);
		daStatc9.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc9.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc9.animation.play('static');
		daStatc9.scrollFactor.set(0, 0);
		daStatc9.alpha = 0.075;
		add(daStatc9);

		var daStatc10:FlxSprite = new FlxSprite(401,598);
		daStatc10.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc10.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc10.animation.play('static');
		daStatc10.scrollFactor.set(0, 0);
		daStatc10.alpha = 0.075;
		add(daStatc10);

		var daStatc11:FlxSprite = new FlxSprite(802,598);
		daStatc11.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc11.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc11.animation.play('static');
		daStatc11.scrollFactor.set(0, 0);
		daStatc11.alpha = 0.075;
		add(daStatc11);

		var daStatc12:FlxSprite = new FlxSprite(1203,598);
		daStatc12.frames = Paths.getSparrowAtlas('daSTAT');
		daStatc12.animation.addByPrefix('static','staticFLASH',24,true);
		daStatc12.animation.play('static');
		daStatc12.scrollFactor.set(0, 0);
		daStatc12.alpha = 0.075;
		add(daStatc12);

		var grain1 = new FlxSprite();
		grain1.frames = Paths.getSparrowAtlas('grainfix', 'mouse');
		grain1.animation.addByPrefix('grain', 'grain', 12, true);
		grain1.setGraphicSize(Std.int(grain1.width * 1.25));
		grain1.screenCenter();
		grain1.antialiasing = ClientPrefs.globalAntialiasing;
        grain1.scrollFactor.set(0, 0);
		grain1.animation.play('grain');
		if(!ClientPrefs.lowQuality)
			add(grain1);
		
		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		#if cpp
        CppAPI.darkMode();
		#end

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
				    Lib.application.window.title = Main.appTitle;
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0;
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoTween != null) {
		    logoTween.cancel();
		}
		newLogo.scale.x = 1.075;
		newLogo.scale.y = 1.075;
		logoTween = FlxTween.tween(newLogo.scale, {x: 1, y: 1}, 0.2, {
		    onComplete: function(twn:FlxTween)
		    {
		        logoTween = null;
		    }
		});

		if(gfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
				case 4:
					addMoreText('present');
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['In association', 'with'], -40);
				case 8:
					addMoreText('newgrounds', -40);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
				case 12:
					addMoreText(curWacky[1]);
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('Sunday');
				case 15:
					addMoreText('Night');
				case 16:
					addMoreText('Suicide');
				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			if (playJingle) //Ignore deez
			{
				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();

				var sound:FlxSound = null;
				switch(easteregg)
				{
					case 'RIVER':
						sound = FlxG.sound.play(Paths.sound('JingleRiver'));
					case 'SHUBS':
						sound = FlxG.sound.play(Paths.sound('JingleShubs'));
					case 'SHADOW':
						FlxG.sound.play(Paths.sound('JingleShadow'));
					case 'BBPANZU':
						sound = FlxG.sound.play(Paths.sound('JingleBB'));

					default:
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.BLACK, 2);
						skippedIntro = true;
						playJingle = false;

						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						return;
				}

				transitioning = true;
				if(easteregg == 'SHADOW')
				{
					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.BLACK, 0.6);
						transitioning = false;
					});
				}
				else
				{
					remove(ngSpr);
					remove(credGroup);
					FlxG.camera.flash(FlxColor.BLACK, 3);
					sound.onComplete = function() {
						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						transitioning = false;
					};
				}
				playJingle = false;
			}
			else //Default! Edit this one!!
			{
				staticGroup.visible = false;
				grain.visible = false;
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.BLACK, 4);
			}
			skippedIntro = true;
		}
	}
}
