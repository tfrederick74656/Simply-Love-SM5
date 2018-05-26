local args = ...
local row = args[1]
local col = args[2]

local af = Def.ActorFrame{}

af[#af+1] = Def.Quad{
	Name="SongWheelBackground",
	InitCommand=cmd(zoomto, _screen.w, _screen.h/(row.how_many-2); diffuse, Color.Black; diffusealpha,1; cropbottom,1),
	OnCommand=cmd(xy, _screen.cx, math.ceil((row.how_many-2)/2) * row.h + 10; finishtweening; accelerate, 0.2; cropbottom,0),
	SwitchFocusToGroupsMessageCommand=cmd(smooth,0.3; cropright,1),
	SwitchFocusToSongsMessageCommand=cmd(smooth,0.3; cropright,0),
	SwitchFocusToSingleSongMessageCommand=cmd(smooth,0.3; cropright,1),
}

-- glowing border top
af[#af+1] = Def.Quad{
	InitCommand=cmd(zoomto, _screen.w, 1; diffuse, Color.White; diffusealpha,0; xy, _screen.cx, _screen.cy+30 + _screen.h/(row.how_many-2)*-0.5; faderight, 10),
	OnCommand=cmd(sleep,0.3; diffusealpha, 0.65; queuecommand, "FadeMe"),
	FadeMeCommand=cmd(accelerate,1.5; faderight, 0; accelerate, 1.5; fadeleft, 10; sleep,0; diffusealpha,0; fadeleft,0; sleep,3; faderight, 10; diffusealpha,0.65; queuecommand, "FadeMe"),
	SwitchFocusToGroupsMessageCommand=cmd(visible, false),
	SwitchFocusToSingleSongMessageCommand=cmd(visible, false),
	SwitchFocusToSongsMessageCommand=cmd(visible,true)
}

-- glowing border bottom
af[#af+1] = Def.Quad{
	InitCommand=cmd(zoomto, _screen.w, 1; diffuse, Color.White; diffusealpha,0; xy, _screen.cx, _screen.cy+30 + _screen.h/(row.how_many-2) * 0.5; faderight, 10),
	OnCommand=cmd(sleep,0.3; diffusealpha, 0.65; queuecommand, "FadeMe"),
	FadeMeCommand=cmd(accelerate,1.5; faderight, 0; accelerate, 1.5; fadeleft, 10; sleep,0; diffusealpha,0; fadeleft,0; sleep,3; faderight, 10; diffusealpha,0.65; queuecommand, "FadeMe"),
	SwitchFocusToGroupsMessageCommand=cmd(visible, false),
	SwitchFocusToSingleSongMessageCommand=cmd(visible, false),
	SwitchFocusToSongsMessageCommand=cmd(visible,true)
}


af[#af+1] = Def.ActorFrame{
	Name="CurrentSongInfoAF",
	InitCommand=function(self) self:y( row.h * 2 + 10 ):x( col.w + 80):diffusealpha(0) end,
	OnCommand=function(self) self:sleep(0.15):linear(0.15):diffusealpha(1) end,
	SwitchFocusToGroupsMessageCommand=function(self) self:visible(false) end,
	SwitchFocusToSongsMessageCommand=function(self) self:visible(true):linear(0.12):zoom(1):y(row.h*2+10):x(col.w+80) end,
	SwitchFocusToSingleSongMessageCommand=function(self) self:linear(0.12):zoom(1):xy(col.w+WideScale(20,65), row.h+30) end,

	-- title
	Def.BitmapText{
		Font="_miso",
		Name="Title",
		InitCommand=function(self)
			self:zoom(1.2):diffuse(Color.White):horizalign(left):y(-40)
		end,
		CurrentSongChangedMessageCommand=function(self, params)
			if params.song then
				self:settext( params.song:GetDisplayFullTitle() )
			end
		end,
		SwitchFocusToGroupsMessageCommand=function(self) self:settext("") end,
		CloseThisFolderHasFocusMessageCommand=function(self) self:settext("") end,
		SwitchFocusToSingleSongMessageCommand=cmd(diffuse, Color.Black),
		SwitchFocusToSongsMessageCommand=cmd(diffuse, Color.White)
	},

	-- artist
	Def.BitmapText{
		Font="_miso",
		Name="Artist",
		InitCommand=function(self)
			self:zoom(0.8):diffuse(Color.White)
				:y(-20):horizalign(left)
		end,
		CurrentSongChangedMessageCommand=function(self, params)
			if params.song then
				self:settext( THEME:GetString("ScreenSelectMusic", "Artist") .. ": " .. params.song:GetDisplayArtist() )
			end
		end,
		SwitchFocusToGroupsMessageCommand=function(self) self:settext("") end,
		CloseThisFolderHasFocusMessageCommand=function(self) self:settext("") end,
		SwitchFocusToSingleSongMessageCommand=cmd(diffuse, Color.Black),
		SwitchFocusToSongsMessageCommand=cmd(diffuse,Color.White)
	},

	-- BPM
	Def.BitmapText{
		Font="_miso",
		Name="BPM",
		InitCommand=function(self)
			self:zoom(0.65):diffuse(Color.White):y(18):horizalign(left)
		end,
		CurrentSongChangedMessageCommand=function(self, params)
			if params.song then
				self:settext( THEME:GetString("ScreenSelectMusic", "BPM") .. ": " .. GetDisplayBPMs() )
			end
		end,
		SwitchFocusToGroupsMessageCommand=function(self) self:settext("") end,
		CloseThisFolderHasFocusMessageCommand=function(self) self:settext("") end,
		SwitchFocusToSingleSongMessageCommand=cmd(diffuse,Color.Black),
		SwitchFocusToSongsMessageCommand=cmd(diffuse,Color.White)
	},
	-- length
	Def.BitmapText{
		Font="_miso",
		Name="Length",
		InitCommand=function(self)
			self:zoom(0.65):diffuse(Color.White):y(32):horizalign(left)
		end,
 		CurrentSongChangedMessageCommand=function(self, params)
			if params.song then
	 			self:settext( THEME:GetString("ScreenSelectMusic", "Length") .. ": " .. SecondsToMMSS(params.song:MusicLengthSeconds()):gsub("^0*","") )
			end
 		end,
		SwitchFocusToGroupsMessageCommand=function(self) self:settext("") end,
 		CloseThisFolderHasFocusMessageCommand=function(self) self:settext("") end,
		SwitchFocusToSingleSongMessageCommand=cmd(diffuse, Color.Black),
		SwitchFocusToSongsMessageCommand=cmd(diffuse,Color.White)
	},
	-- genre
	Def.BitmapText{
		Font="_miso",
		Name="Genre",
		InitCommand=function(self)
			self:zoom(0.65):diffuse(Color.White)
				:y(46):horizalign(left)
		end,
		CurrentSongChangedMessageCommand=function(self, params)
			if params.song then
				self:settext( THEME:GetString("ScreenSelectMusic", "Genre") .. ": " .. params.song:GetGenre() )
			end
		end,
		SwitchFocusToGroupsMessageCommand=function(self) self:settext("") end,
		CloseThisFolderHasFocusMessageCommand=function(self) self:settext("") end,
		SwitchFocusToSingleSongMessageCommand=cmd(diffuse, Color.Black),
		SwitchFocusToSongsMessageCommand=cmd(diffuse,Color.White)
	},
}


return af