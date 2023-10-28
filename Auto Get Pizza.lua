--[[
Script date: 2022-01-08 08:06 PST
(partially) merged into comrp.lua
]]

require "moonloader"
require "sampfuncs"
local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local inisave2 = inicfg.load({config = {
mode = 2,
enabled = 1 }})	


script_author("MNGC")

toggle = 1

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	sampRegisterChatCommand("pizzamode", switchmodes)
	sampRegisterChatCommand("togautopizza", togautogetpizza)
	sampRegisterChatCommand("agphelp", autopizzahelp)
	while not isSampAvailable() do wait(50) end
	while true do
	wait(500)
	inicfg.save(inisave2)
	        if inisave2.config.enabled == true then
				if inisave2.config.mode == 1 then
				if isCharInModel(playerPed, 448) and isCharInArea2d(playerPed, 2094.8313,-1797.5392, 2092.0740,-1794.4833, false) then
                    sampSendChat("/getpizza")
                    wait(2000)
             end
end
                if inisave2.config.mode == 2 then
				if isCharInModel(playerPed, 448) and isCharInArea2d(playerPed, 2106.1599,-1785.8787, 2100.1829,-1790.1743, false) then
				sampSendChat("/getpizza")
				wait(2000)
               end
           end
       end
    end
end

function switchmodes(mode)

    if #mode == 0 then
	 	 sampAddChatMessage("{FFFFFF}/pizzamode [mode]", -1)
		 sampAddChatMessage(" ", -1)
	 	 sampAddChatMessage("Available modes:", -1)
		 sampAddChatMessage("1 = AZRP mode", -1)
		 sampAddChatMessage("2 = CoMRP mode", -1)
		 sampAddChatMessage(" ", -1)
		 sampAddChatMessage(string.format("{FFFFFF}Current mode: %s", inisave2.config.mode), 0xFFFFFF)
	end
	if (mode == '1') then
		    inisave2.config.mode = 1
				sampAddChatMessage("{FFFFFF}AutoGetPizza: Now in AZRP mode.", -1)
			inicfg.save(inisave2)
			end
	if (mode == '2') then
		    inisave2.config.mode = 2
				sampAddChatMessage("{FFFFFF}AutoGetPizza: Now in CoM:RP mode.", -1)
			inicfg.save(inisave2)
			end
		end

function togautogetpizza()

     if inisave2.config.enabled == true then
	 inisave2.config.enabled = false
	 sampAddChatMessage("AutoGetPizza disabled", -1)
	 inicfg.save(inisave2)
     else
	 inisave2.config.enabled = true
	 sampAddChatMessage("AutoGetPizza enabled", -1)
	 inicfg.save(inisave2)
	 end
	 end
	 
function autopizzahelp()
     sampAddChatMessage("AutoGetPizza help", -1)
	 sampAddChatMessage("/pizzamode - change pickup modes", -1)
	 sampAddChatMessage("current options: 1 - AZRP mode, 2 - CoMRP Mode", -1)
	 sampAddChatMessage(" ", -1)
	 sampAddChatMessage("/togautopizza - Toggle AutoGetPizza", -1)
	 end
