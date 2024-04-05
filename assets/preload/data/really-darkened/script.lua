function onCreate()
   makeLuaSprite('street333','street3',-698, -670);
   setScrollFactor('street333',0.9,0.9);
   scaleObject('street333',1.2,1.2);
   setProperty('street333.alpha',0);
   addLuaSprite('street333',false);

   makeLuaSprite('blacking','aBlackFuckBecauseAMakeGraphicdonotwork',0,0)
   setObjectCamera('blacking','camOther')
   addLuaSprite('blacking',true)

   makeLuaSprite('whitefuck','aWhiteFuckBecauseAMakeGraphicdonotwork',0,0);
   setObjectCamera('whitefuck','camOther')
   setProperty('whitefuck.alpha',0);
   addLuaSprite('whitefuck',true)

   makeLuaText('cutsceneTxt','',1000,135,580)
   setTextFont('cutsceneTxt','vcr.ttf')
   setTextSize('cutsceneTxt',30)
   setProperty('cutsceneTxt.alpha',0)
   setObjectCamera('cutsceneTxt','subtitles')
   addLuaText('cutsceneTxt',false)
end

local curSection = 0;
local stepDev = 0;
local shaderYes = true;
local windowShakeBool = true;
local default_window = {
    x = 0,
    y = 0
}
local chromeValue = 0.00175;

function onCreatePost()
   setProperty('introSoundsSuffix','');

   for i = 0, getProperty('unspawnNotes.length')-1 do
      if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
         setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_assets');
         setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'noteSplashes');
      end
      if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Suicide Note' then
         setPropertyFromGroup('unspawnNotes', i, 'texture', 'SUICIDENOTE_assets'); --Change texture
      end
   end

   for i=4,7 do
      setPropertyFromGroup('strumLineNotes', i, 'texture', 'NOTE_assets');
   end

   shaderYes = getPropertyFromClass('ClientPrefs','shaders');

   if windowShakeBool then
      default_window.x = getPropertyFromClass('openfl.Lib','application.window.x');
      default_window.y = getPropertyFromClass('openfl.Lib','application.window.y');
   end

   if shaderYes then
        initLuaShader("chrom")
    
        makeLuaSprite("chromatic")
        makeGraphic("chromatic", screenWidth, screenHeight)
    
        setSpriteShader("chromatic", "chrom")
        addHaxeLibrary("ShaderFilter", "openfl.filters")
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("chromatic").shader)]);
        ]])

        setChrome(0.0);
    end
end

function setChrome(chromeOffset)
    if shaderYes then
        setShaderFloat("chromatic", "rOffset", chromeOffset);
        setShaderFloat("chromatic", "gOffset", 0.0);
        setShaderFloat("chromatic", "bOffset", chromeOffset * -1);
    end
end

function windowShake()
    if windowShakeBool then
        setPropertyFromClass("openfl.Lib", "application.window.x", default_window.x + math.random(-5, 5));
        setPropertyFromClass("openfl.Lib", "application.window.y", default_window.y + math.random(-5, 5));
    end
end

function windowShakeHard()
    if windowShakeBool then
        setPropertyFromClass("openfl.Lib", "application.window.x", default_window.x + math.random(-12, 14));
        setPropertyFromClass("openfl.Lib", "application.window.y", default_window.y + math.random(-12, 14));
    end
end

local shakeNormal = 0;

function windowNormal()
    if windowShakeBool then
        setPropertyFromClass("openfl.Lib", "application.window.x", default_window.x);
        setPropertyFromClass("openfl.Lib", "application.window.y", default_window.y);
    end
end

function onSongStart()
   doTweenAlpha('blackingTween','blacking',0,5);

   doTweenAlpha('errorTween','street333',0.6,2);
end

function onTweenCompleted(t)
   if t == 'errorTween' then
      cancelTween('errorTween');

      doTweenAlpha('returnTween','street333',0,2);
   elseif t == 'returnTween' then
      cancelTween('returnTween');

      doTweenAlpha('errorTween','street333',0.6,2);
   end
end

function onTimerCompleted(t)
   if t == 'chromReturn' then
      setChrome(0.0);
   end

   if t == 'shakeHasEnd' then
        endshake = true;
    end

    for i=0,100 do
        if not endshake then
            if t == 'shakelol'..i..'' then
                windowShakeHard();

                shakeNormal = shakeNormal + 1;

                if shakeNormal > 100 then
                    shakeNormal = 0;
                end

                runTimer('shakelol'..shakeNormal..'',0.01);

                runTimer('shakehasNormal'..shakeNormal..'',0.075);
            end
        end
        if t == 'shakehasNormal'..i..'' then
            windowNormal();
        end
    end
end

local lololol = false;
local screaming = false;

function onStepHit()
   if curStep % 16 == 0 then
      curSection = math.floor(curStep / 16);
   end

   stepDev = math.floor(curStep % 16) + 1;

   if curSection >= 16 and curSection <= 23 then
      if curStep % 8 == 0 then
         addCamZoom(0.075, 0.035);
      end
   end

   if curSection >= 24 and curSection <= 31 then
      if curStep % 4 == 0 then
         addCamZoom(0.15, 0.032);
      end
   end

   if curStep == 640 then
      itemFade(0,0,0.5);
      fadeDadStrum(0, 0.5);
      fadeBfStrum(0, 0.5);
   elseif curStep == 752 then
      itemFade(0,1,1.15);
      fadeDadStrum(1, 1.15);
      fadeBfStrum(1, 1.15);
   end

   if curStep == 1152 or curStep == 1174 then
      screaming = true;
   elseif curStep == 1172 or curStep == 1178 then
      screaming = false;
   end

   if curStep == 1024 then
      setProperty('blacking.alpha',1);
      itemFade(0, 0, 0.1);
      fadeDadStrum(0, 0.1);
      fadeBfStrum(0, 0.1);
      triggerEvent('Camera Follow Pos', '445', '320');
      setProperty('boyfriendGroup.visible',false)
      setProperty('gfGroup.visible',false);
      lololol = true;
      setProperty('whitefuck.alpha',1);
      doTweenAlpha('whitefuckTween','whitefuck',0,2.5);
   end
end

function onUpdate()
   shakin = getPropertyFromClass('ClientPrefs','shaking')

   if shakin then
      cameraShake('camGame', 0.0008, 999999)
      cameraShake('camHUD', 0.0008, 999999)
   end

   if screaming then
      if getProperty('defaultCamZoom') >= 0.9 and getProperty('defaultCamZoom') <= 1.15 then
         addCamZoom(0.055, 0.03);
      end

      if lololol then
         setProperty('blacking.alpha',0);
      end

      if not endshake and windowShakeBool then
         windowShakeHard();

         shakeNormal = shakeNormal + 1;

         if shakeNormal > 100 then
            shakeNormal = 0;
         end

         runTimer('shakelol'..shakeNormal..'',0.01);

         runTimer('shakehasNormal'..shakeNormal..'',0.075);

         runTimer('shakeHasEnd',0.1);
      end

      setChrome(0.0045);
   else
      setChrome(0.0);

      if lololol then
         setProperty('blacking.alpha',1);
      end

      setProperty('defaultCamZoom',0.9);
   end
end

function fadeDadStrum(alph, time)
   runHaxeCode([[
      game.opponentStrums.forEach(function(spr)
      {
         FlxTween.tween(spr, {alpha: ]]..alph..[[}, ]]..time..[[);
      })
   ]])
end

function fadeBfStrum(alph, time)
   runHaxeCode([[
      game.playerStrums.forEach(function(spr)
      {
         FlxTween.tween(spr, {alpha: ]]..alph..[[}, ]]..time..[[);
      })
   ]])
end

function opponentNoteHit(id, duration, noteType, isSus)
   if getPropertyFromClass('ClientPrefs', 'shaking') then
      triggerEvent("Screen Shake", "0.2,0.015", "0.2,0.015")
   end

   if shaderYes then
      chromeValue = chromeValue + 0.000425;

      if chromeValue > 0.00306 then
         chromeValue = 0.00305;
      end

      setChrome(chromeValue);
      runTimer('chromReturn',0.1);
   end

   if getProperty('health') > 0.2 then
      runHaxeCode([[
         var healthTween = FlxTween.tween(game, {health: game.health - 0.023}, 0.15, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween)
            {
               healthTween = null;
            }
         });

         if(healthTween != null)
         {
               healthTween.cancel;
         }
      ]])
   end
end

function addCamZoom(game, hud)
   triggerEvent('Add Camera Zoom', ""..game.."", ""..hud.."")
end

function itemFade(num, alph, duration)
   if num == 0 then
      doTweenAlpha('itm1','timeBarBG',alph,duration,'linear')
      doTweenAlpha('itm2','timeBar',alph,duration,'linear')
      doTweenAlpha('itm3','timeTxt',alph,duration,'linear')
      doTweenAlpha('itm4','botplayTxt',alph,duration,'linear')
      doTweenAlpha('itm5','healthBarBG',alph,duration,'linear')
      doTweenAlpha('itm55','healthBarBG2',alph,duration,'linear')
      doTweenAlpha('itm6','healthBar',alph,duration,'linear')
      doTweenAlpha('itm7','iconP1',alph,duration,'linear')
      doTweenAlpha('itm8','iconP2',alph,duration,'linear')
      doTweenAlpha('itm9','scoreTxt',alph,duration,'linear')
   elseif num == 1 then
      doTweenAlpha('itm1','timeBarBG',alph,duration,'linear')
      doTweenAlpha('itm2','timeBar',alph,duration,'linear')
      doTweenAlpha('itm3','timeTxt',alph,duration,'linear')
      doTweenAlpha('itm4','botplayTxt',alph,duration,'linear')
      doTweenAlpha('itm9','scoreTxt',alph,duration,'linear')
   elseif num == 2 then
      doTweenAlpha('itm1','timeBarBG',alph,duration,'linear')
      doTweenAlpha('itm2','timeBar',alph,duration,'linear')
      doTweenAlpha('itm3','timeTxt',alph,duration,'linear')
   end
end