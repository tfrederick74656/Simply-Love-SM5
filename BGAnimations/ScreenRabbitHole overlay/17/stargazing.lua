local max_stars = 60
local bgm_volume = 10

local af = Def.ActorFrame{
	InputEventCommand=function(self, event)
		if event.type == "InputEventType_FirstPress" and (event.GameButton=="Start" or event.GameButton=="Back") then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end
	end
}

af[#af+1] = Def.Sound{
	File=THEME:GetPathB("ScreenRabbitHole", "overlay/17/since.ogg"),
	OnCommand=function(self) self:play() end,
	FadeOutAudioCommand=function(self)
		if bgm_volume >= 0 then
			local ragesound = self:get()
			bgm_volume = bgm_volume-1
			ragesound:volume(bgm_volume*0.1)
			self:sleep(0.1):queuecommand("FadeOutAudio")
		end
	end
}

for i=1, max_stars do
	local x = math.random(1, _screen.w)
	local y = math.random(1, _screen.h)
	local w = math.random(1,3)

	af[#af+1]=Def.Sprite{
		Texture=THEME:GetPathB("ScreenRabbitHole", "overlay/14/circle.png"),
		InitCommand=function(self) self:xy(x,y):zoomto(w,w):diffusealpha(0):visible(false) end,
		OnCommand=function(self) self:sleep(i*1.25):visible(true):smooth(1):diffusealpha(1):queuecommand("Pulse") end,
		PulseCommand=function(self) self:pulse():effectmagnitude(1.75,1,1):effectperiod(3) end
	}
end

af[#af+1]=Def.Sprite{
	Texture=THEME:GetPathB("ScreenRabbitHole", "overlay/17/ben.png"),
	InitCommand=function(self) self:align(1,1):xy(_screen.w, _screen.h):zoom(0.6) end,
}

af[#af+1]=Def.Sprite{
	Texture=THEME:GetPathB("ScreenRabbitHole", "overlay/17/glow.png"),
	InitCommand=function(self) self:align(1,1):xy(_screen.w, _screen.h):zoom(0.6) end,
	OnCommand=function(self) self:diffuseshift():effectcolor1(1,1,1,0.1):effectcolor2(1,1,1,1):effectperiod(4) end
}

return af