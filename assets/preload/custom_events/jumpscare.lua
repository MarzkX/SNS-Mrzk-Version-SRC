function onEvent(n)
   if n == 'jumpscare' then
      doTweenZoom('theTween', 'camGame', getProperty('defaultCamZoom') + 0.3, 1)
      doTweenAlpha('bfFade', 'boyfriendGroup', 0, 1)
      runTimer('screenShake', 1.7)
      runTimer('gameFade', 1.75)
   end
end

function onTimerCompleted(t)
   if t == 'gameFade' then
      setProperty('camGame.alpha', 1)
   end
   if t == 'screenShake' then
      if songName == 'Really Happy New' then
         cameraShake('camGame', 0.75, 7)
      elseif songName == 'Really Happy' then
         cameraShake('camGame', 0.75, 6)
         runTimer('camFadeIn',5.9)
      end
   end
   if t == 'camFadeIn' then
      doTweenAlpha('camTween','camGame',0,0.15)
   end
end

function onTweenCompleted(t)
   if t == 'theTween' then
      setProperty('defaultCamZoom', 1.0)
   end
end