function onCreate()
	makeLuaSprite('blacking','aBlackFuckBecauseAMakeGraphicdonotwork',0,0)
    setObjectCamera('blacking','camOther')
    doTweenAlpha('blackTween','blacking',0,1);
    addLuaSprite('blacking',true)

    makeLuaSprite('whitefuck','aWhiteFuckBecauseAMakeGraphicdonotwork',-200,-200);
    setProperty('whitefuck.alpha',1);
    scaleObject('whitefuck',2,2);
    addLuaSprite('whitefuck',true);

    makeLuaText('cutsceneTxt','',1000,135,520)
    setTextFont('cutsceneTxt','vcr.ttf')
    setTextSize('cutsceneTxt',30)
    setProperty('cutsceneTxt.alpha',1)
    setObjectCamera('cutsceneTxt','subtitles')
    addLuaText('cutsceneTxt',false)

    setObjectOrder('cutsceneTxt',getObjectOrder('healthBarBG')+50)

end

function onCreatePost()
	setProperty('grain.visible',false);

	doTweenColor('whiteColor','whitefuck','0x00F7FF',0.01);

	setScrollFactor('whitefuck', 0, 0);
end

local curSection = 0;

function onStepHit()
	if curStep % 16 == 0 then
		curSection = math.floor(curStep / 16);
	end

	if curStep == 65 then
		doTweenAlpha('whiteTween','whitefuck',1,4.15,'cubeInOut');
	end

	if curSection >= 8 and curSection <= 23 then
		if curStep % 8 == 0 then
			triggerEvent('Add Camera Zoom', '0.023', '0.03');
		end
		setProperty('camZoomingMult',0);
	end

	if curSection == 24 then
		setProperty('camZoomingMult',1);
	end

	if curSection >= 40 and curSection <= 55 then
		if curStep % 8 == 0 then
			triggerEvent('Add Camera Zoom', '0.05', '0.032');
		end
		setProperty('camZoomingMult',0);
	end

	if curSection >= 64 and curSection <= 94 then
		if curStep % 8 == 0 then
			triggerEvent('Add Camera Zoom', '0.075', '0.035');
		end
		triggerEvent('Screen Shake', '1.8, 0.0075', '1.8, 0.0035');
	end

	if curSection >= 80 and curSection <= 95 then
		if curStep % 8 == 0 then
			setProperty('camHUD.angle',-3);
			doTweenAngle('angleTween','camHUD',0,0.25,'cubeOut');
		end
		if curStep % 16 == 0 then
			setProperty('camHUD.angle',3);
			doTweenAngle('angleTween','camHUD',0,0.25,'cubeOut');
		end
	end

	if curStep == 897 then
		doTweenAlpha('blackAlpha','blacking',1,1);
	elseif curStep == 1009 then
		doTweenAlpha('blackAlpha','blacking',0,0.085);
	end
	if curStep == 1021 then
		doTweenAlpha('cma','camHUD',1,0.35);
	end
	if curStep == 1000 then
		setProperty('camHUD.alpha',0);
	end
	if curStep == 1552 then
		doTweenAlpha('blackAlpha','blacking',1,0.65,'circOut');
	end
	if curStep == 1660 then
		setProperty('camHUD.alpha',0);
		setProperty('boyfriendGroup.alpha',0);
		setProperty('gfGroup.visible',false);
	end
	if curStep == 1666 then
		setProperty('blacking.alpha',0.4);
	elseif curStep == 1697 then
		doTweenAlpha('blackAlpha','blacking',1,0.65,'circOut');
	end
end

function onSongStart()
	runTimer('fade',3);
end

function onTweenCompleted(t)
	if t == 'blackAlpha' then
		cancelTween('blackAlpha');
	end

	if t == 'whiteTween' then
		cancelTween('whiteTween');

		doTweenAlpha('whiteLOL','whitefuck',0,1);
	end
end

function onTimerCompleted(t)
	if t == 'fade' then
		doTweenAlpha('cutsceneTxtA','cutsceneTxt',0,1);
	end
end