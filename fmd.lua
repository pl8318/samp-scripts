
require 'lib.sampfuncs'
local sampev = require "lib.samp.events"

enablekeys = true
fullName = true
preview = true

function main()
	sampRegisterChatCommand("fmdline", fmd_lines)
	while true do
		wait(0)
		rpkeys()
	end
end

-- not my code hahaha!
function split(line, sep)
	local sep, fields = sep or " ", {}
	local pattern = string.format("([^%s]+)", sep)
	for token in string.gmatch(line, pattern) do
		fields[#fields+1] = token
	end
	return fields
end

function getPlayerName(id)
    if sampIsPlayerConnected(id) then
        local selid = sampGetPlayerNickname(id)
	    if fullName then
	        name = string.gsub(selid, "_", " ")
	     	return name
		else
			name = split(selid, "_")
            return name[1]
	    end
	end
end

function send(a, b, c)
	if preview then
		sampAddChatMessage(string.format(a, b, c), -1)
	else
		sampSendChat(string.format(a, b, c))
	end
end

function rpkeys()
	if isKeyDown(0x12) then
		if wasKeyPressed(0x31) then
			fmd_lines("stopbleed")
		elseif wasKeyPressed(0x33) then
			fmd_lines("brokenbone")
		elseif wasKeyPressed(0x34) then
			fmd_lines("burntwound")
		elseif wasKeyPressed(0x35) then
			fmd_lines("starvation")
		elseif wasKeyPressed(0x36) then
			fmd_lines("bug")
		elseif wasKeyPressed(0x37) then
			fmd_lines("ambulance_coming")
		elseif wasKeyPressed(0x42) then
			fmd_lines("put_badge")
		elseif wasKeyPressed(0x50) then
			fmd_lines("check_pt")
		elseif wasKeyPressed(0x4D) then
			fmd_lines("move_pt")
		elseif wasKeyPressed(0x4C) then
			fmd_lines("move_pt_stretcher")
		end		
	end
end

function fmd_lines(a)
	local arg = split(a, " ")
	local ar = arg[1]
	lua_thread.create(function()
	if ar == "stopbleed" then
		send("/idles 6")
		send("/me places their medical bag beside them, unzipping it until completely open.")
		wait(3000)
		send("/do The wound would stop bleeding.")
		wait(3000)
		send("/me takes out a gauze roll, applies it over the gauze pad, sealing the wound.")
		wait(3000)
	elseif ar == "brokenbone" then
		send("/idles 6")
		wait(3000)
		send("/me assess the injured body part, analyzing the broken bone.")
		wait(3000)
		send("/do You would see me take out a splint from the ambulance.")
		wait(3000)
		send("/me applies the splint carefully to the injured body part of the patient.")
	elseif ar == "burntwound" then
		send("/idles 6")
		send("/me places their medical kit on the ground, taking out a water gel container.")
		wait(3000)
		send("/me applies the water gel to the burnt area, carefully relieving the burnt skin.")
		wait(3000)
		send("/me begins to apply wet sterile dressing on the wound, covering the burnt part")
		wait(3000)
		send("/me brings out bandages, rolling it on the covered body part, sealing the wound completely.")
	elseif ar == "starvation" then
		send("/idles 6")
		send("/me Took the niddle from the medkit bag to poke it slightly in the left arms of the patient.")
		wait(3000)
		send("/do They slowly put the Serum includes all proteins not used in blood clotting; all electrolytes,")
		wait(2500)
		send("/do -antibodies, antigen, hormone.")
	elseif ar == "bug" then
		send("/idles 6")
		send("/me notices the patient is unreponsive.")
		wait(3000)
		send("/do the patient is unresponsive and there are no clear signs of injuries.")
	elseif ar == "ambulance_coming" then
		-- in the original hotkey script it would try to send command /idles 6 
		-- even when inside a vehicle
		send("/m Ambulance coming through! Clear the path, drive to the right side!")
		wait(2000)
		send("/m [Lights and Sirens would flash brightly] FMD, clear the path now!")
	elseif ar == "check_pt" then
		send("/me checking my mfmd patient list using his phone application.")
		send("/do checking...")
		wait(500)
		send("/listpt")
	elseif ar == "put_badge" then
		send("/me takes out his \"Manila Fire and Medic Department\" badge and clips it [ON/Off]")
		wait(500)
		send("/badge")
	elseif ar == "heal_amb" then
		if arg[2] then
			send("/me takes out first aid kit and gives treatment to the patient")
			send("/heal 200 "..arg[2])
		else
			sampAddChatMessage("invalid argument", -1)
		end
	elseif ar == "move_pt" then
		send("/me puts the patient in the stretcher and attempting to move the patient.")
		wait(500)
		send("/movept")
	elseif ar == "move_pt_stretcher" then
		send("/me Transfer the patient on the ground onto the stretcher.")
		wait(2000)
		send("/do the patient is secured and ready to go.")
		wait(2000)
		send("/me the ambulance door and ambulance door and carefully slides in the patient.")
		wait(2000)
		send("/me closes the door -goes back to the seat and begin to drive towards the hospital.")
		wait(500)
		send("/loadpt")
	else
		sampAddChatMessage("invalid option!", -1)
		sampAddChatMessage("available options: stopbleed, brokenbone, burntwound, starvation, bug, ambulance_coming, checkpt,", -1)
		sampAddChatMessage("put_badge, heal_amb, move_pt, move_pt_stretcher", -1)
		sampAddChatMessage("options heal_amb require a playerid", -1)
	end
	end)
end