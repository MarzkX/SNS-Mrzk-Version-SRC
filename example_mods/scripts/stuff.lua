function onCreate()
    local laneAlpha = getPropertyFromClass('ClientPrefs','laneAlpha');

    makeLuaSprite('oppoBlackLane','aBlackFuckBecauseAMakeGraphicdonotwork',92.5,-100)
    setObjectCamera('oppoBlackLane','camHUD')
    setObjectOrder('oppoBlackLane',getObjectOrder('healthBarBG')+10);
    setProperty('oppoBlackLane.alpha',laneAlpha);
    scaleObject('oppoBlackLane',0.35,2);
    addLuaSprite('oppoBlackLane',true)

    makeLuaSprite('playerBlackLane','aBlackFuckBecauseAMakeGraphicdonotwork',732.5,-100)
    setObjectCamera('playerBlackLane','camHUD')
    setObjectOrder('playerBlackLane',getObjectOrder('healthBarBG')+10);
    setProperty('playerBlackLane.alpha',laneAlpha);
    scaleObject('playerBlackLane',0.35,2);
    addLuaSprite('playerBlackLane',true)
end

local theLaneX = -300;

function onSongStart()
    makeLuaSprite('songLane','songStartBar',0 + theLaneX,100);
    setObjectCamera('songLane','camOther');
    setObjectOrder('songLane',getObjectOrder('healthBarBG')+100)
    scaleObject('songLane',0.21,0.115);
    setProperty('songLane.alpha',1);
    addLuaSprite('songLane',true);

    doTweenX('songLTween1','songLane',0,1,'cubeOut');

    runTimer('fadeOut',3);

    if songName == 'A Fate Worse than Death' then
        --song name, -, Opponent.
        makeLuaText('songTxt','"'..songName..'"\n-\nHappy Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);

        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Really Happy Legacy' then
        makeLuaText('songTxt','"'..songName..'"\n-\nSuicide Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);

        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Unhappy' then
        makeLuaText('songTxt','"'..songName..'"\n-\nUnHappy Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);

        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Happy' then
        makeLuaText('songTxt','"'..songName..'"\n-\nHappy Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);
        
        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Really Happy' then
        makeLuaText('songTxt','"'..songName..'"\n-\nSuicide Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);
        
        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Smile' then
        makeLuaText('songTxt','"'..songName..'"\n-\n...',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);
        
        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    elseif songName == 'Happy-Neo' then
        makeLuaText('songTxt','"'..songName..'"\n-\nNeo Mouse',1000,-365 + theLaneX,115);
        setTextFont('songTxt','vcr.ttf');
        setObjectCamera('songTxt','camOther');
        addLuaText('songTxt',true);

        setProperty('songLane.color',getColorFromHex('0x991C7A'));
        setProperty('songTxt.color',getColorFromHex('0x00F7FF'));
        
        doTweenX('songTTween','songTxt',-365,1,'cubeOut');
    end
    setObjectOrder('songTxt',getObjectOrder('healthBarBG')+100)
end

function onTimerCompleted(t)
    if t == 'fadeOut' then
        doTweenX('songLTween1','songLane',0+theLaneX,1,'cubeInOut');
        doTweenX('songTTween','songTxt',-365+theLaneX,1,'cubeInOut');
    end
end

function onTweenCompleted(t)
    if t == 'songLTween1' then
        cancelTween('songLTween1');
    end
    if t == 'songLTween2' then
        cancelTween('songLTween2');
    end
    if t == 'songTTween' then
        cancelTween('songTTween');
    end
end