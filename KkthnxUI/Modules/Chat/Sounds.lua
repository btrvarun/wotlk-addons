﻿local K, C, L, _ = select(2, ...):unpack()
if C.Chat.Enable ~= true or C.Chat.WhispSound ~= true then return end

local sub = string.sub
local CreateFrame = CreateFrame
local PlaySoundFile = PlaySoundFile

-- Play sound files system(by Tukz)
local SoundSys = CreateFrame("Frame")
SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
SoundSys:RegisterEvent("CHAT_MSG_BN_WHISPER")
SoundSys:HookScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		PlaySoundFile(C.Media.Whisp_Sound, "Master")
	end
end)