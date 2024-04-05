function onEvent(n)
	if n == 'Flash White' and flashingLights then
		makeLuaSprite('whiteFlash','aWhiteFuckBecauseAMakeGraphicdonotwork',0,0);
		setObjectCamera('whiteFlash','camOther');
		addLuaSprite('whiteFlash',true);
		doTweenAlpha('whiteFlashing','whiteFlash',0,1);
	end
end