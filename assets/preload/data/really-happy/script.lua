function onStartCountdown()
   makeLuaSprite('blacking','aBlackFuckBecauseAMakeGraphicdonotwork',0,0)
   setObjectCamera('blacking','camOther')
   addLuaSprite('blacking',true)

   doTweenAlpha('blackfuck','blacking',0,1)
end

function onTimerCompleted(t)
   if t == 'warnFadeOut' then
      doTweenAlpha('warnFade','warn',0,1)
   end
end

function onUpdate()
   shakin = getPropertyFromClass('ClientPrefs','shaking')

   if shakin then
      cameraShake('camGame', 0.0008, 999999)
      cameraShake('camHUD', 0.0008, 999999)
   end
end

local curSection = 0;
local stepDev = 0;

function onStepHit()
   if curStep % 16 == 0 then
      curSection = math.floor(curStep / 16);
   end

   stepDev = math.floor(curStep % 16) + 1;

   if curSection >= 8 and curSection <= 23 or curSection >= 32 and curSection <= 39 then
      if curStep % 8 == 0 then
         addCamZoom(0.075, 0.032)
      end
   end

   if curSection >= 24 and curSection <= 31 or curSection >= 40 and curSection <= 55 then
      if curStep % 4 == 0 then
         addCamZoom(0.12,0.04)
      end
   end

   if curStep == 384 then
      fadeItem(1, 0, 1)
   elseif curStep == 512 then
      fadeItem(1, 1, 1)
   end
   if curStep == 640 then
      fadeItem(1, 0, 1)
   end
   if curStep == 896 then
      setProperty('camGame.visible',false)
   end
   if curStep == 904 then
      fadeDadStrum(0, 0.75)
      fadeBfStrum(0, 0.75)
      fadeItem(0, 0, 0.5)
      setProperty('boyfriendGroup.alpha',0)
      setProperty('gfGroup.alpha',0)
   end
   if curStep == 960 then
      setProperty('camGame.visible',true)
   end
   if curSection >= 60 and curSection <= 63 then
      if curStep % 1 == 0 then
         triggerEvent('Add Camera Zoom', '0.075', '0')
         triggerEvent('Screen Shake',"1, 0.16","1, 0.16")
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

function fadeItem(num, alph, duration)
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