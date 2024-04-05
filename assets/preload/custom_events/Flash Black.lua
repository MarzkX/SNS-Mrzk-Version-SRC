function onEvent(n)
	if n == 'Flash Black' and flashingLights then
		makeLuaSprite('blackFlash','aBlackFuckBecauseAMakeGraphicdonotwork',0,0);
		setObjectCamera('blackFlash','camOther');
		addLuaSprite('blackFlash',true);
		doTweenAlpha('blackFlashing','blackFlash',0,1);
	end
end