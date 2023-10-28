--[[
Script date: 2022-01-22 09:20 PST
merged into comrp.lua

original header:

Auto Get Crates - a /getcrate version of the AutoGetMats.lua.

Credits: Adib - original AutoGetMats.lua script

]]


require "moonloader"
require "sampfuncs"
local sampev = require "lib.samp.events"
local inicfg = require "inicfg"

dir = getWorkingDirectory() .. "\\config\\MNGC\\"
config = dir .. "AutoGetCrates.ini"

if not doesDirectoryExist(dir) then createDirectory(dir) end
if not doesFileExist(config) then
	print("Script is un-loading.")
	thisScript():unload()
end

directIni = config
mainIni = inicfg.load(nil, directIni)

script_author("MNGC")

toggle = 1
toggle2 = 1
constr1 = 1

function main()
	while not isSampAvailable() do wait(50) end
	sampAddChatMessage("{00FF00}AutoGetCrates {FFFFFF}loaded. /gchelp for help. ", -1)
	sampRegisterChatCommand("gc", cmd_togglegc)
	sampRegisterChatCommand("togcrate", cmd_togcrate)
	sampRegisterChatCommand("gchelp", cmd_help)
	sampRegisterChatCommand("togdrug", togautodrugs)
	while true do
--		   renderFontDrawText(my_font, 'Official CoM:FR PC', 1150, 700, 0xFFFFFFFF)
--           renderFontDrawText(my_font, 'Official CoM:FR PC', 30, 420, 0xFFFFFFFF)
		if mainIni.Options.toggleall then
			if (toggle == 1) then
				if mainIni.Options.pot and isCharInArea2d(playerPed, 69.0425,-293.7464,61.8631,-291.9752, false) then -- mp1
                    sampSendChat("/getcrate")
					wait(500)
					sampSendChat("pot")
                    wait(1000)
                end
                if mainIni.Options.crack and isCharInArea2d(playerPed,69.0425,-293.7464,61.8631,-291.9752, false) then -- airmatrun
                    sampSendChat("/getcrate")
					wait(500)
					sampSendChat("crack")
                    wait(1000)
                end
			end
		if mainIni.Options.toggleautodrugs then
			if(toggle2 == 1) then
				if isCharInArea2d(playerPed, 2143.7629,-1679.5071, 2146.3132,-1681.1292, false) then
					sampSendChat(string.format("/getpot %s", mainIni.Options.amount))
					wait(500)
				end
			end
		end
	    if constr1 == 1 then
	    	if isCharInArea2d(playerPed, 319.7165,-779.9881, 317.5295,-776.5376, false) then
	    		sampSendChat("/startwork")
	    		wait(1000)
	    	end
	end
end
		wait(0)
	end
end

function sampev.onServerMessage(color, text)
	local kcp, msg = string.find(text, "All current checkpoints")
	if kcp then
		toggle = 1
	end
	local drug1, drug2 = string.find(text, "You're not a drug dealer")
	if drug1 then
		mainIni.Options.toggleautodrugs = false
		sampAddChatMessage("{00FF00}AutoGetCrates: {FFFFFF}To avoid spam, the Auto Get Drugs has been disabled. /togdrug to re-enable it.", -1)
	end
	local smug1, smug2 = string.find(text, "You're not a Drug Smuggler")
	if smug1 then
		mainIni.Options.toggleall = false
		sampAddChatMessage("{00FF00}AutoGetCrates: {FFFFFF}To avoid spam, the Auto Get Crates has been disabled. /gc to re-enable it.", -1)
	end
	local lawyer1, lawyer2 = string.find(text, "has offered to defend your wanted level for")
	if lawyer1 then
		sampSendChat("/accept lawyer")
	end
end

function cmd_help()
	sampAddChatMessage("{FFFFFF} ---> {00FF00}AutoGetCrates {FFFFFF}<---", -1)
	sampAddChatMessage("{FFFF00}/togcrate {FFFFFF} - To turn off a specific drug run", -1)
	sampAddChatMessage("{FFFF00}/gc {FFFFFF} - To turn off/on every drug run", -1)
	sampAddChatMessage("{FFFF00}/togdrug {FFFFFF} - enable / disable auto get drugs, can be useful for drugruns", -1)
	sampAddChatMessage(" ", -1)
	sampAddChatMessage("{FFFFFF} Credits: {FF0000}Adib23704#8947 {FFFFFF}and {FF0000}Hr1doy#6038", -1)
end

function cmd_togcrate(args)
	if #args == 0 then
		sampAddChatMessage("{FF0000}Invalid Usage: {FFFFFF}/togcrate [Name]")
		sampAddChatMessage("{9E9E9E}Available names: Pot, Crack", -1)
	end
	if (args == "pot" or args == "POT" or args == "Pot") then
		if mainIni.Options.pot then
		    mainIni.Options.pot = false
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage("{00FF00}AutoGetCrates: {FF0000}Disabled {FFFFFF}Pot.", -1)
			end
		else
			mainIni.Options.pot = true
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage("{00FF00}AutoGetCrates: {0000FF}Enabled {FFFFFF}Pot.", -1)
				mainIni.Options.crack = false
			end
		end
	end
	if (args == "crack" or args == "CRACK" or args == "Crack") then
		if mainIni.Options.crack then
			mainIni.Options.crack = false
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage("{00FF00}AutoGetCrates: {FF0000}Disabled {FFFFFF}Crack.", -1)
			end
		else
			mainIni.Options.crack = true
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage("{00FF00}AutoGetCrates: {0000FF}Enabled {FFFFFF}Crack.", -1)
				mainIni.Options.pot = false
			end
		end
	end
end

function cmd_togglegc()
	if mainIni.Options.toggleall then
		mainIni.Options.toggleall = false
		if inicfg.save(mainIni, directIni) then
			sampAddChatMessage("{00FF00}AutoGetCrates{ffffff}: {ff0000}Disabled", -1)
		end
	else
		mainIni.Options.toggleall = true
		if inicfg.save(mainIni, directIni) then
			sampAddChatMessage("{00FF00}AutoGetCrates{ffffff}: {0000ff}Enabled", -1)
		end
	end
end


function togautodrugs()
	if mainIni.Options.toggleautodrugs then
	   mainIni.Options.toggleautodrugs = false
	   if inicfg.save(mainIni, directIni) then
	   sampAddChatMessage("{00FF00}AutoGetCrates: {FFFFFF}Auto Get Drugs disabled.", -1)
	end
else
	mainIni.Options.toggleautodrugs = true
	if inicfg.save(mainIni, directIni) then
		sampAddChatMessage("{00FF00}AutoGetCrates: {ffffff}Auto Get Drugs enabled.", -1)
	end
end
end
