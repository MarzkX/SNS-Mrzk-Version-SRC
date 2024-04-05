
function onCreatePost()
	makeLuaSprite('UpperBar', 'aBlackBar', -110, -350)
	setObjectCamera('UpperBar', 'hudother')
	addLuaSprite('UpperBar', false)

	makeLuaSprite('LowerBar', 'aBlackBar', -110, 720)
	setObjectCamera('LowerBar', 'hudother')
	addLuaSprite('LowerBar', false)

	UpperBar = getProperty('UpperBar.y')
	LowerBar = getProperty('LowerBar.y')
end


function onEvent(name, value1, value2)
	if name == 'Black Bars' then
	   Speed = tonumber(value1)
	   Distance = tonumber(value2)
	end

	if Speed and Distance > 0 then	
	   doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
	   doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')
	end

	if downscroll and Speed and Distance > 0 then	
	   doTweenY('Cinematics1', 'UpperBar', UpperBar + Distance, Speed, 'QuadOut')
	   doTweenY('Cinematics2', 'LowerBar', LowerBar - Distance, Speed, 'QuadOut')
	end

	if Distance <= 0 then		
	   doTweenY('Cinematics1', 'UpperBar', UpperBar, Speed, 'QuadIn')
	   doTweenY('Cinematics2', 'LowerBar', LowerBar, Speed, 'QuadIn')		
	end	
end

