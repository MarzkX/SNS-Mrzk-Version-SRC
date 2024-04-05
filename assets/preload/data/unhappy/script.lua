function onStartCountdown()
   makeLuaSprite('blacking','aBlackFuckBecauseAMakeGraphicdonotwork',0,0)
   setObjectCamera('blacking','camOther')
   addLuaSprite('blacking',true)

   doTweenAlpha('blackfuck','blacking',0,1)
end
function onCreatePost()
   setProperty('introSoundsSuffix','');
   setProperty('isMouseStage',false);
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

   if curSection >= 0 and curSection <= 7 or curSection >= 24 and curSection <= 27 then
      if curStep % 4 == 0 then
         addCamZoom(0.065, 0.03)
      end
   end

   if curSection >= 8 and curSection <= 15 then
      if curStep % 8 == 0 then
         addCamZoom(0.067, 0.032)
      end
   end

   if curSection >= 16 and curSection <= 23 then
      if curStep % 4 == 0 then
         addCamZoom(0.085, 0.037)
      end
   end

   if curStep == 448 then
      fadeDadStrum(0, 1)
      fadeBfStrum(0, 1)
      itemFade(0, 0, 1)
      doTweenAlpha('cameraFade','camGame',0,1)
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