function onCreate()
   makeLuaSprite('street333','street3',-698, -670);
   setScrollFactor('street333',0.9,0.9);
   scaleObject('street333',1.2,1.2);
   setProperty('street333.alpha',0);
   addLuaSprite('street333',false);

   makeLuaSprite('blackBG','aBlackFuckBecauseAMakeGraphicdonotwork',0,0);
   setScrollFactor('blackBG',0,0);
   scaleObject('blackBG',2,2)
   setProperty('blackBG.alpha',0);
   screenCenter('blackBG');
   addLuaSprite('blackBG',false);

   makeLuaSprite('blackfuck','aBlackFuckBecauseAMakeGraphicdonotwork',0,0);
   setObjectCamera('blackfuck','camOther');
   addLuaSprite('blackfuck',true);
end

function onUpdate()
   shakin = getPropertyFromClass('ClientPrefs','shaking')

   if shakin then
      cameraShake('camGame', 0.0008, 999999)
      cameraShake('camHUD', 0.0008, 999999)
   end
end

function onSongStart()
   doTweenAlpha('blackfuckAlpha','blackfuck',0,1);
end

local curSection = 0;
local stepDev = 0;

function onCreatePost()
   setProperty('introSoundsSuffix','');
end

function onStepHit()
   if curStep % 16 == 0 then
      curSection = math.floor(curStep / 16);
   end

   stepDev = math.floor(curStep % 16) + 1; --896

   if curStep == 879 then
      for i=0,getProperty('unspawnNotes.length')-1 do
         if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'suicideUI/NOTE_assets');
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'suicideUI/noteSplashes');
         elseif getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'suicideUI/NOTE_assets');
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'suicideUI/noteSplashes');
         end
      end
   end

   if curStep == 896 then
      for i=0,7 do
         setPropertyFromGroup('strumLineNotes', i, 'texture', 'suicideUI/NOTE_assets');
      end
      runHaxeCode([[
         game.timeBar.createFilledBar(0xFF000000, 0xFF333333);
      ]])
   end

   if curStep == 377 then
      doTweenAlpha('blackBGTween','blackBG',0.4,5);
   end
   if curStep == 513 then
      cancelTween('blackBGTween');
      cancelTween('blackBGTween2');
      setProperty('blackBG.alpha',0);
      setProperty('blackfuck.alpha',1);
   end
   if curStep == 632 then
      doTweenAlpha('blackfuckAlpha','blackfuck',0,1)
   end
   if curStep == 888 then
      doTweenAlpha('streetBGTween','street333',1,1);
   end
   if curStep == 1153 then
      cancelTween('blackBGTween');
      cancelTween('blackBGTween2');
      setProperty('blackBG.alpha',0);
      setProperty('blackfuck.alpha',1);
      itemFade(0, 0, 1);
      fadeBfStrum(0, 1);
      fadeDadStrum(0, 1);
   end
   if curStep == 1216 then
      setProperty('gfGroup.visible',false);
      setProperty('boyfriendGroup.visible',false);
   end
   if curStep == 1281 then
      setProperty('blackfuck.alpha',0)
   end
end

function onTweenCompleted(t)
   if t == 'blackBGTween' then
      doTweenAlpha('blackBGTween2','blackBG',0,4);
   elseif t == 'blackBGTween2' then
      doTweenAlpha('blackBGTween','blackBG',0.4,5);
   end
   if t == 'blackfuckAlpha' then
      cancelTween('blackfuckAlpha')
   end
   if t == 'streetBGTween' then
      cancelTween('streetBGTween')
   end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
   if getProperty('dad.curCharacter') == 'mouse-happy' then
      triggerEvent("Screen Shake", "0.2,0.015", "0.2,0.015")
   elseif getProperty('dad.curCharacter') == 'suicide-mouse' or getProperty('dad.curCharacter') == 'mouse-reanimated' then
      triggerEvent("Screen Shake", "0.2,0.015", "0.2,0.015")
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