package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import openfl.display.BlendMode;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import openfl.filters.BitmapFilter;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxRuntimeShader;
import openfl.Lib;
import openfl.filters.ShaderFilter;
import options.OptionsState;
import Shaders;
import WindowsData;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var mustPress:Bool = false;

	//var bgMocky:FlxBackdrop;
	var mockybg:FlxSprite;
	var char:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var chromStuffTween:FlxTween;
	var chromTween:FlxTween;

	var show:String = "";
	var reRoll:Bool = true;
	var lastRoll:String = 'mouse';

    var chromeValue:Float = 0;
	var shaders:Array<ShaderEffect> = [];
	var chrom:ChromaticAberrationEffect;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		Lib.application.window.title = Main.appTitle + ' - ' + "Main Menu";

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		if(FlxG.sound.music != null)
		{
			if(!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				FlxG.sound.music.volume = 0;
				FlxG.sound.music.fadeIn();
			}
		}

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		//add(bg);

		//add(bgMocky = new FlxBackdrop(Paths.image('menuBG')));
		//bgMocky.scrollFactor.set();
		//bgMocky.velocity.set(-40, 0);

		mockybg = new FlxSprite(0, 0);
		mockybg.scrollFactor.set(0, 0);
		mockybg.updateHitbox();
        mockybg.blend = BlendMode.OVERLAY;
		mockybg.antialiasing = ClientPrefs.globalAntialiasing;
		add(mockybg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		char = new FlxSprite(-500, 0);
		char.scrollFactor.set(0, 0);
		char.alpha = 0;
		char.updateHitbox();
		char.antialiasing = ClientPrefs.globalAntialiasing;
		add(char);

		if (reRoll)
		{
			var random = FlxG.random.float(0,10000);
			show = 'mouse';
			if (random >= 1000 && random <= 1999)
				show = 'bf';
			if (random >= 2000 && random <= 2999)
				show = 'oswald';
			if (random >= 3000 && random <= 3999)
				show = 'suicide';
			if (random >= 4000 && random <= 4999)
				show = 'neo';
			if (random >= 5000 && random <= 5999)
				show = 'alt';
			if (random >= 6000 && random <= 6999)
				show = 'pibby';
			lastRoll = show;
			trace('random ' + random + ' im showin ' + show);
		}
		else
			show = lastRoll;

		switch(show)
		{
			case 'mouse':
				char.loadGraphic(Paths.image('mainmenu/char/mouse'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/default'));
			case 'bf':
				char.loadGraphic(Paths.image('mainmenu/char/bf'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/default'));
			case 'oswald':
				char.loadGraphic(Paths.image('mainmenu/char/oswald'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/oswald'));
			case 'suicide':
				char.loadGraphic(Paths.image('mainmenu/char/suicide'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/suicide'));
			case 'neo':
				char.loadGraphic(Paths.image('mainmenu/char/neomouse'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/neo'));
			case 'alt':
				char.loadGraphic(Paths.image('mainmenu/char/altmouse'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/alt'));
			case 'pibby':
				char.loadGraphic(Paths.image('mainmenu/char/pibbified'));
				mockybg.loadGraphic(Paths.image('mainmenu/bg/pibby'));
		}

		FlxTween.tween(char, {x: 0, alpha: 1}, 1, {ease: FlxEase.circInOut});

		var blackSide:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/side'));
		blackSide.scrollFactor.set(0, 0);
		blackSide.updateHitbox();
		blackSide.screenCenter();
		blackSide.antialiasing = ClientPrefs.globalAntialiasing;
		add(blackSide);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		//add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.9;

		var itemXFloat:Float = -400;
		
		var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;

		//Story
		var menuItem:FlxSprite = new FlxSprite(itemXFloat, (0 * 140) + offset - 50);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.blend = BlendMode.HARDLIGHT;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');
		menuItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.alpha = 0;
		menuItem.ID = 0;
		FlxTween.tween(menuItem, {x: 60, alpha: 1}, 1, {ease: FlxEase.quartOut});
		menuItems.add(menuItem);
		menuItem.scrollFactor.set(0, 0);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();

		//freeplay
		var menuItem:FlxSprite = new FlxSprite(itemXFloat, (1 * 140)  + offset - 35);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.blend = BlendMode.HARDLIGHT;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');
		menuItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.alpha = 0;
		menuItem.ID = 1;
		FlxTween.tween(menuItem, {x: 75, alpha: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.3});
		menuItems.add(menuItem);
		menuItem.scrollFactor.set(0, 0);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();

		//credits
		var menuItem:FlxSprite = new FlxSprite(itemXFloat, (2 * 140)  + offset - 15);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.blend = BlendMode.HARDLIGHT;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');
		menuItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.alpha = 0;
		menuItem.ID = 2;
		FlxTween.tween(menuItem, {x: 85, alpha: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.6});
		menuItems.add(menuItem);
		menuItem.scrollFactor.set(0, 0);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();

		//options
		var menuItem:FlxSprite = new FlxSprite(itemXFloat, (3 * 140)  + offset);
		menuItem.scale.x = scale;
		menuItem.scale.y = scale;
		menuItem.blend = BlendMode.HARDLIGHT;
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/FNF_main_menu_assets');
		menuItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
		menuItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
		menuItem.animation.play('idle');
		menuItem.alpha = 0;
		menuItem.ID = 3;
		FlxTween.tween(menuItem, {x: 95, alpha: 1}, 1, {ease: FlxEase.quartOut, startDelay: 0.9});
		menuItems.add(menuItem);
		menuItem.scrollFactor.set(0, 0);
		menuItem.antialiasing = ClientPrefs.globalAntialiasing;
		menuItem.updateHitbox();

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			mustPress = true;
		});

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Suicide v" + Lib.application.meta["version"], 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if(ClientPrefs.shaders)
		{
			chrom = new ChromaticAberrationEffect();

		    addShader(chrom);
		}

		var daStat1:FlxSprite = new FlxSprite(0,0);
		daStat1.frames = Paths.getSparrowAtlas('daSTAT');
		daStat1.animation.addByPrefix('static','staticFLASH',24,true);
		daStat1.animation.play('static');
        daStat1.blend = BlendMode.SHADER;
		daStat1.scrollFactor.set(0, 0);
		daStat1.alpha = 0.075;
		add(daStat1);

		var daStat2:FlxSprite = new FlxSprite(401,0);
		daStat2.frames = Paths.getSparrowAtlas('daSTAT');
		daStat2.animation.addByPrefix('static','staticFLASH',24,true);
		daStat2.animation.play('static');
		daStat2.scrollFactor.set(0, 0);
        daStat2.blend = BlendMode.SHADER;
		daStat2.alpha = 0.075;
		add(daStat2);

		var daStat3:FlxSprite = new FlxSprite(802,0);
		daStat3.frames = Paths.getSparrowAtlas('daSTAT');
		daStat3.animation.addByPrefix('static','staticFLASH',24,true);
		daStat3.animation.play('static');
		daStat3.scrollFactor.set(0, 0);
		daStat3.alpha = 0.075;
        daStat3.blend = BlendMode.SHADER;
		add(daStat3);

		var daStat4:FlxSprite = new FlxSprite(1203,0);
		daStat4.frames = Paths.getSparrowAtlas('daSTAT');
		daStat4.animation.addByPrefix('static','staticFLASH',24,true);
		daStat4.animation.play('static');
        daStat4.blend = BlendMode.SHADER;
		daStat4.scrollFactor.set(0, 0);
		daStat4.alpha = 0.075;
		add(daStat4);

		var daStat5:FlxSprite = new FlxSprite(0,299);
		daStat5.frames = Paths.getSparrowAtlas('daSTAT');
		daStat5.animation.addByPrefix('static','staticFLASH',24,true);
		daStat5.animation.play('static');
		daStat5.scrollFactor.set(0, 0);
        daStat5.blend = BlendMode.SHADER;
		daStat5.alpha = 0.075;
		add(daStat5);

		var daStat6:FlxSprite = new FlxSprite(401,299);
		daStat6.frames = Paths.getSparrowAtlas('daSTAT');
		daStat6.animation.addByPrefix('static','staticFLASH',24,true);
		daStat6.animation.play('static');
		daStat6.scrollFactor.set(0, 0);
        daStat6.blend = BlendMode.SHADER;
		daStat6.alpha = 0.075;
		add(daStat6);

		var daStat7:FlxSprite = new FlxSprite(802,299);
		daStat7.frames = Paths.getSparrowAtlas('daSTAT');
		daStat7.animation.addByPrefix('static','staticFLASH',24,true);
		daStat7.animation.play('static');
		daStat7.scrollFactor.set(0, 0);
        daStat7.blend = BlendMode.SHADER;
		daStat7.alpha = 0.075;
		add(daStat7);

		var daStat8:FlxSprite = new FlxSprite(1203,299);
		daStat8.frames = Paths.getSparrowAtlas('daSTAT');
		daStat8.animation.addByPrefix('static','staticFLASH',24,true);
		daStat8.animation.play('static');
		daStat8.scrollFactor.set(0, 0);
        daStat8.blend = BlendMode.SHADER;
		daStat8.alpha = 0.075;
		add(daStat8);

		var daStat9:FlxSprite = new FlxSprite(0,598);
		daStat9.frames = Paths.getSparrowAtlas('daSTAT');
		daStat9.animation.addByPrefix('static','staticFLASH',24,true);
		daStat9.animation.play('static');
        daStat9.blend = BlendMode.SHADER;
		daStat9.scrollFactor.set(0, 0);
		daStat9.alpha = 0.075;
		add(daStat9);

		var daStat10:FlxSprite = new FlxSprite(401,598);
		daStat10.frames = Paths.getSparrowAtlas('daSTAT');
		daStat10.animation.addByPrefix('static','staticFLASH',24,true);
		daStat10.animation.play('static');
        daStat10.blend = BlendMode.SHADER;
		daStat10.scrollFactor.set(0, 0);
		daStat10.alpha = 0.075;
		add(daStat10);

		var daStat11:FlxSprite = new FlxSprite(802,598);
		daStat11.frames = Paths.getSparrowAtlas('daSTAT');
		daStat11.animation.addByPrefix('static','staticFLASH',24,true);
		daStat11.animation.play('static');
		daStat11.scrollFactor.set(0, 0);
        daStat11.blend = BlendMode.SHADER;
		daStat11.alpha = 0.075;
		add(daStat11);

		var daStat12:FlxSprite = new FlxSprite(1203,598);
		daStat12.frames = Paths.getSparrowAtlas('daSTAT');
		daStat12.animation.addByPrefix('static','staticFLASH',24,true);
		daStat12.animation.play('static');
		daStat12.scrollFactor.set(0, 0);
        daStat12.blend = BlendMode.SHADER;
		daStat12.alpha = 0.075;
		add(daStat12);

		if(!ClientPrefs.globalAntialiasing || show == 'neo')
		{
			daStat1.visible = false;
			daStat2.visible = false;
			daStat3.visible = false;
			daStat4.visible = false;
			daStat5.visible = false;
			daStat6.visible = false;
			daStat7.visible = false;
			daStat8.visible = false;
			daStat9.visible = false;
			daStat10.visible = false;
			daStat11.visible = false;
			daStat12.visible = false;
		}

		var grain:FlxSprite = new FlxSprite();
		grain.frames = Paths.getSparrowAtlas('grainfix', 'mouse');
		grain.animation.addByPrefix('grain', 'grain', 12, true);
		grain.setGraphicSize(Std.int(grain.width * 1.25));
		grain.screenCenter();
		grain.antialiasing = ClientPrefs.globalAntialiasing;
        grain.scrollFactor.set(0, 0);
		grain.animation.play('grain');
		if(!ClientPrefs.lowQuality)
			add(grain);

		if(show == 'neo')
		{
			grain.visible = false;
		}
		else
		{
			grain.visible = true;
		}

		if (ClientPrefs.shaking)
			FlxG.camera.shake(0.001, 99999999999);

		doChrome(null, false);

		// NG.core.calls.event.logEvent('swag').send();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if(mustPress)
			changeItem();

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if(mustPress)
			{
				if (controls.UI_UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
	
				if (controls.UI_DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

			    if (controls.ACCEPT)
				{
					if (ClientPrefs.shaking)
						FlxG.camera.shake(0.008, 0.15);
		
					if (ClientPrefs.flashing)
						FlxG.camera.flash(FlxColor.fromString('0xFFFFFF'), 1, null, true);
		
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
	
					if(curSelected == 1)
						FlxG.sound.music.fadeOut(0.85, 0);
		
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
							    var daChoice:String = optionShit[curSelected];
	
								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										FlxG.sound.music.stop();
										MusicBeatState.switchState(new FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										OptionsState.isPause = false;
										LoadingState.loadAndSwitchState(new OptionsState());
								}
							});
						}
					});
				}
				#if desktop
				else if (FlxG.keys.anyJustPressed(debugKeys))
				{
					selectedSomethin = true;
					MusicBeatState.switchState(new MasterEditorMenu());
				}
				#end
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
		}

		super.update(elapsed);
	}

	function addShader(effect:ShaderEffect)
	{
		if (!ClientPrefs.shaders)
			return;

		shaders.push(effect);

		var newCamEffects:Array<BitmapFilter> = [];

		for (i in shaders)
		{
			newCamEffects.push(new ShaderFilter(i.shader));
		}

		FlxG.camera.setFilters(newCamEffects);
	}

	function doChrome(T:FlxTimer, ?setChrom:Bool = true)
	{
		if (!ClientPrefs.shaders)
			return;

		if (T != null)
			T.cancel();

		if (chrom != null && setChrom)
			chrom.setChrome(FlxG.random.float(0.0, 0.002));

		new FlxTimer().start(FlxG.random.float(0.08, 0.12), function(tmr:FlxTimer)
		{
			new FlxTimer().start(FlxG.random.float(0.7, 1.6), function(tmr:FlxTimer)
			{
				doChrome(tmr, true);
			});
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
