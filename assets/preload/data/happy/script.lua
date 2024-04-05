local allowCountdown = true;
local isStart = false;

function onStartCountdown()
   if not allowCountdown then
      doTweenAlpha('warnFade','warn',1,1);
      doTweenAlpha('pressFadeIn','pressTxt',1,2);
      return Function_Stop;
   end
   return Function_Continue;
end

function onCreate()
   makeLuaSprite('blacking','aBlackFuckBecauseAMakeGraphicdonotwork',0,0)
   setObjectCamera('blacking','camOther')
   addLuaSprite('blacking',true)

   makeLuaSprite('warn','suicideUI/warning',0,0)
   screenCenter('warn')
   setProperty('warn.alpha',0);
   setObjectCamera('warn','camOther')
   addLuaSprite('warn',true)

   makeLuaText('pressTxt','Press Enter to Begin',1000,485,655)
   setTextFont('pressTxt','vcr.ttf')
   setTextSize('pressTxt',27.5)
   setProperty('pressTxt.alpha',0)
   setObjectCamera('pressTxt','camOther')
   addLuaText('pressTxt',false)
end

function onCreatePost()
   setProperty('introSoundsSuffix','');
   setProperty('isMouseStage',false);

   if not isStoryMode then
      isStart = false;
      allowCountdown = true;
   else
      isStart = true;
      allowCountdown = false;
   end
end

function onSongStart()
   doTweenAlpha('blackingFade','blacking',0,1);
end

function onTimerCompleted(t)
   if t == 'camAngle' then
      runTimer('camlol',1.3)
      doTweenAngle('cam1Angle','camHUD',3,2,'cubeout')
   elseif t == 'camlol' then
      runTimer('camAngle',1.3)
      doTweenAngle('cam2Angle','camHUD',-3,2,'cubeout')
   end
   if t == 'songStart' then
      startCountdown();
      allowCountdown = true;
   end
   if t == 'pressed' then
      setProperty('pressTxt.alpha',1);
      runTimer('pressedW',0.1);
   end
   if t == 'pressedW' then
      setProperty('pressTxt.alpha',0);
      runTimer('pressed',0.1);
   end
end

function onTweenCompleted(t)
   if t == 'pressFadeIn' then
      cancelTween('pressFadeIn');
      doTweenAlpha('pressFadeOut','pressTxt',0,2);
   end
   if t == 'pressFadeOut' then
      cancelTween('pressFadeOut');
      doTweenAlpha('pressFadeIn','pressTxt',1,2);
   end
   if t == 'warnFadeOut' then
      cancelTimer('pressed');
      cancelTimer('pressedW');
      setProperty('pressTxt.visible',false);
   end
end

function onUpdate()
   local shakin = getPropertyFromClass('ClientPrefs','shaking')

   if getPropertyFromClass('flixel.FlxG','keys.justPressed.ENTER') and isStart then
      runTimer('songStart',0.02);
      allowCountdown = true;
      cancelTween('pressFadeIn');
      cancelTween('pressFadeOut');
      setProperty('pressTxt.alpha',0);
      playSound('click',0.95);
      runTimer('pressed',0.1);
      doTweenAlpha('warnFadeOut','warn',0,1);
      cancelTween('warnFade')
      isStart = false;
   end

   if shakin then
      cameraShake('camGame', 0.0008, 999999)
      cameraShake('camHUD', 0.0008, 999999)
   end
end

function happyMouse()
   runTimer('camAngle',1.3)
   doTweenAngle('cam2Angle','camHUD',-3,2,'cubeout')
end

local curSection = 0;
local stepDev = 0;

function onStepHit()
   if curStep % 16 == 0 then
      curSection = math.floor(curStep / 16);
   end

   stepDev = math.floor(curStep % 16) + 1;

   if curSection >= 4 and curSection <= 11 or curSection >= 20 and curSection <= 26 then
      if curStep % 4 == 0 then
         addCamZoom(0.1, 0.04)
      end
   end

   if curSection >= 12 and curSection <= 19 then
      if curStep % 8 == 0 then
         addCamZoom(0.08, 0.035)
      end
   end

   if curSection >= 28 and curSection <= 43 then
      if curStep % 4 == 0 then
         addCamZoom(0.2, 0.08)
      end
   end

   if curStep == 440 then
      itemFade(0, 0, 0.15)
      fadeBfStrum(0, 0.15)
      fadeDadStrum(0, 0.15)
   end
   if curStep == 448 then
      itemFade(0, 1, 0.1)
      fadeBfStrum(1, 0.1)
      fadeDadStrum(1, 0.1)
      setProperty('isMouseStage',true);
      happyMouse()
   end
   if curStep == 832 then
      itemFade(0, 0, 2)
      fadeBfStrum(0, 2)
      fadeDadStrum(0, 2)
      doTweenAlpha('cameraFade','camGame',0,2)
   end
end

function opponentNoteHit()
   local shakin = getPropertyFromClass('ClientPrefs','shaking')

   if getProperty('dad.curCharacter') == 'mouse-happy' then
      if shakin then
         triggerEvent('Screen Shake', '0.2, 0.035', '0.2, 0.035')
      end
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