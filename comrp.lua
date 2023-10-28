script_name("COMRP.Lua")

local a = require 'base64'
local cfg = require 'inicfg'
local filename = "comrplua-config.ini"
local ini = cfg.load({ 
	main = {
		mainscr = true,
		auto_login = true, 
		auto_rp = true, 
		auto_miner = true, 
		auto_shipment = true, 
		auto_drugs = true, 
		auto_pizza = true,
		auto_materials = true
	},
	auto_shipment = {
		shipmentType = 1,
		shipmentItem = 7
	},
	auto_login = {
		username = '',
		password = ''
	},
	auto_drugs = {
		amount = 5,
		dtype = "crack"
	},
}, filename)

function auto_login()
	print("AutoLogin loaded")
	local auto_login = {}
	auto_login.username = ini.auto_login.username
	auto_login.password = a.decode(ini.auto_login.password)
	if auto_login.username == '' then sampAddChatMessage("[comrp autologin] username not set, /setname to set", -1) end
	if auto_login.password == '' then sampAddChatMessage("[comrp autologin] password not set, /setpass to set", -1) end
	sampRegisterChatCommand("setname", function(arg)
		if arg == '' or arg == nil then
			sampAddChatMessage('usage: /setname [name]', -1)
		else
			sampAddChatMessage('name set!', -1)
			auto_login.username = arg
			ini.auto_login.username = auto_login.username
			cfg.save(ini, filename)
		end
	end)
	sampRegisterChatCommand("setpass", function(arg)
		if arg == '' or arg == nil then
			sampAddChatMessage('usage: /setpass [password]', -1)
		else
			sampAddChatMessage('password set!', -1)
			ini.auto_login.password = a.encode(arg)
			cfg.save(ini, filename)
		end
	end)
	while true do
		wait(500)
		print("running")
		if auto_login.password ~= '' and auto_login.username ~= '' then
			if sampGetCurrentDialogId() == 967 then
				sampSendDialogResponse(967, 1, 1, -1)
			end
			if sampGetCurrentDialogId() == 968 then
				-- username
				sampSendDialogResponse(968, 1, 1, -1)
				sampSendDialogResponse(972, 1, -1, auto_login.username)
				wait(500)
				sampSendDialogResponse(968, 1, 2, -1)
				sampSendDialogResponse(973, 1, -1, auto_login.password)
				wait(500)
				sampSendDialogResponse(968, 1, 5, -1)
				wait(500)
				sampCloseCurrentDialogWithButton(0)
				break
	--			sampSendDialogResponse(968, 1, 0, -1)
			end
		end
	end
end

function auto_rp()
	print("AutoRP loaded")
	local autorp = {} 
	autorp.enablekeys = true
	autorp.fullName = true
	autorp.preview = false
	local rp = {
		frisk = { "/me pats down %s's body from his head to toe, looking for any valuable goods and pennies.",
				  "/do Would I be able to?", },
		cuff = "/me reaches for his handcuffs on his duty belt, and cuffs %s.",
		finish_gun = { "/me aims his gun on %s then holds the trigger, ending his/her pathetic life.", 
					   "/me aligns the muzzle of his weapon on %s, then clicks the trigger sending his/her soul to the afterlife.",
					   "/me points his gun on %s then squeezes the trigger, putting him/her on the end of his line.",
					   "/me raises his gun on his victim, pressing the trigger, ravages the fuck outta %s with bullets." },
		piss = "/me unzips his pants, and starts to piss on %s.",
		slide_eye = "/me slides eye %s.",
		pull_gun = { "/do Weapon securely and firm on my hand index finger is on the trigger", 
					 "/me takes out his weapon while he switches its safety mode [OFF] "},
		carjack = "/me Force to open the vehicle door, Take %s out of the vehicle"
	}
	-- from CleopatraAutoRp.lua, by 'Cleopatra'
	local cp = {
		modkey = 0x42,
		finish_gun_1 = { "/me grabs his weapon from his weapon holster - flicks the safety[OFF].",
						 "/me reloads his gun, aims it to %s, placing his right index finger on the trigger" },
		finish_gun_2 = { "/me aims his weapon towards %s'body, shooting him an array of bullets.",
						 "/me as he pulls the trigger and finishes %s's life.", 
						 "/me unhesitatingly finishes %s's injured body without showing him mercy.",
						 "/me streching his hand as he flicks off his weapon to finsih %s Life's",
						 "/me put his gun on %s mouth, as he pulls the trigger until the magazine is empty."}, 
		attempt_cuff = { "/me takes out his handcuffs from his Belt, as he attempts to cuff %s tightly.",
						"/do am I able to?"},
		grab_arms = { "/me grabs %s's both arms, as he attempts to hold %s.",
					  "/do would %s resist?", },
		frisk = { "/me taps %s from head to toe, as he attempts to frisk His whole body.",
				  "/do am I able to?" },
		tazer = "/me aims his tazer towards %s, ready to shoot anytime...",
		cig = { "/me smokes cigarette in front of %s's presence.",
				"/me offers %s a cigarette.",
				"/do Would %s take it? " },
		gesture = {	"/me gestures his hand as he places it on his eyebrow giving a salute to, %s",
					"/do saluted to %s "},
		beer = { "/me opens a canned beer in front of %s's presence",
				 "/me offers %s a canned beer",
				 "/do would %s take it?" },
		radio = "/me grabs ahold of his radio as he presses the button firmly, speaking unto it"
	}
	-- from Bertogsss_Autorp.lua by Bertogs Jabar
	local bt = {
		modkey = 0x10,
		finish_gun = { "/me grab his gun and points his gun into the person infront of him pulling the trigger finishing %s.",
					   "/do you will see lights coming from the sky and you will be unconscious and having worst nightmare.",
						"/l  tangina mo dapa. " }
	}
	local function split(line, sep)
		local sep, fields = sep or " ", {}
		local pattern = string.format("([^%s]+)", sep)
		for token in string.gmatch(line, pattern) do
			fields[#fields+1] = token
		end
		return fields
	end
	local function getPlayerName(id)
		if sampIsPlayerConnected(id) then
			local selid = sampGetPlayerNickname(id)
			if autorp.fullName then
				name = string.gsub(selid, "_", " ")
				return name
			else
				name = split(selid, "_")
				return name[1]
			end
		end
	end
	local function send(a, b, c)
		if autorp.preview then
			sampAddChatMessage(string.format(a, b, c), -1)
		else
			sampSendChat(string.format(a, b, c))
		end
	end
	sampRegisterChatCommand("rp", function(a)
		local arg = split(a, " ")
		-- workaround
		local name = getPlayerName(arg[2])
		local r1, r2 = math.random(#rp.finish_gun), math.random(#cp.finish_gun_1)
		if not arg[1] then
			sampAddChatMessage("Usage: /rp (option) (playerid)", -1)
			sampAddChatMessage("Options: fngn[1-6], frisk[1-2], piss, grabarms, tazer, attemptcuff, cuff, cig, gesture, beer, radio, slideeye, pullgun", -1)
			sampAddChatMessage("Options: carjack", -1)
			sampAddChatMessage("NOTE: no need to put playerid in option 'radio', 'pullgun'.", -1)
		end
		if arg[1] == "radio" then
			send(cp.radio)
		elseif arg[1] == "pullgun" then
			send(rp.pull_gun[1])
			send(rp.pull_gun[2])
		end
		if arg[2] then
			if arg[1] == "fngn1" then
				send(rp.finish_gun[r1], name)
			elseif arg[1] == "fngn2" then
				send(cp.finish_gun_1[r2], name)
				send(cp.finish_gun_2[r2], name)
			elseif arg[1] == "fngn3" then
				send(cp.finish_gun_2[3], name)
			elseif arg[1] == "fngn4" then
				send(bt.finish_gun[1], name)
				send(bt.finish_gun[2])
				send(bt.finish_gun[3])
			elseif arg[1] == "fngn5" then
				send(cp.finish_gun_2[4], name)
			elseif arg[1] == "fngn6" then
				send(cp.finish_gun_2[5], name)
			elseif arg[1] == "frisk1" then
				send(rp.frisk[1], name)
				send(rp.frisk[2])
			elseif arg[1] == "frisk2" then
				send(cp.frisk[1], name)
				send(cp.frisk[2], name)
			elseif arg[1] == "cuff" then
				send(rp.cuff, name)
				send("/cuff %s", arg[2])
			elseif arg[1] == "piss" then
				send(rp.piss, name)
				send("/piss")
			elseif arg[1] == "grabarms" then
				send(cp.grab_arms[1], name, name)
				send(cp.grab_arms[2], name)
			elseif arg[1] == "tazer" then
				send(cp.tazer, name)
			elseif arg[1] == "attemptcuff" then
				send(cp.attempt_cuff[1], name)
				send(cp.attempt_cuff[2], name)
			elseif arg[1] == "cig" then
				send(cp.cig[1], name)
				send(cp.cig[2], name)
				send(cp.cig[3], name)
			elseif arg[1] == "gesture" then
				send(cp.gesture[1], name)
				send(cp.gesture[2], name)
				send("/gesture 11")
			elseif arg[1] == "beer" then
				send(cp.beer[1], name)
				send(cp.beer[2], name)
				send(cp.beer[3], name)
			elseif arg[1] == "slideeye" then
				send(rp.slide_eye, name)
			elseif arg[1] == "carjack" then
				send(rp.carjack, name)
			end
		end
	end)
	sampRegisterChatCommand("rptog", function(arg)
		if arg == "prev" or arg == "preview" then 
		autorp.preview = not autorp.preview
			if autorp.preview then
				sampAddChatMessage("[comrp auto rp] Preview enabled.", -1)
			else
				sampAddChatMessage("[comrp auto rp] Preview disabled.", -1)
			end
		elseif arg == "keys" or arg == "keybinds" then
			autorp.enablekeys = not autorp.enablekeys
			if autorp.enablekeys then
				sampAddChatMessage("[comrp auto rp] Keybinds enabled.", -1)
			else
				sampAddChatMessage("[comrp auto rp] Keybinds disabled.", -1)
			end
		else
			sampAddChatMessage("Invalid option!", -1)
		end
	end)
	while true do
		wait(10)
		local result, target = getCharPlayerIsTargeting(playerHandle)
		result, playerid = sampGetPlayerIdByCharHandle(target)		
		if result and autorp.enablekeys then
			local name = getPlayerName(playerid)
			local r1, r2 = math.random(#rp.finish_gun), math.random(#cp.finish_gun_1)
			if not isKeyDown(cp.modkey) and not isKeyDown(bt.modkey) then
				if wasKeyPressed(0x31) then
					send(rp.finish_gun[r1], name)
				elseif wasKeyPressed(0x32) then
					send(rp.frisk[1], name)
					send(rp.frisk[2], name)
				elseif wasKeyPressed(0x33) then
					send(rp.cuff, name)
					send("/cuff %s", a)
				elseif wasKeyPressed(0x34) then
					send(rp.piss, name)
					send("/piss")
				end	
			end
			-- Cleopatra
			if isKeyDown(cp.modkey) then
				if wasKeyPressed(0x30) then
					send(cp.grab_arms[1], name, name)
					send(cp.grab_arms[2], name)
				elseif wasKeyPressed(0x32) then
					send(cp.finish_gun_1[r2], name)
					send(cp.finish_gun_2[r2], name)
				elseif wasKeyPressed(0x33) then
					send(cp.tazer, name)
				elseif wasKeyPressed(0x34) then
					send(cp.attempt_cuff[1], name)
					send(cp.attempt_cuff[2], name)
				elseif wasKeyPressed(0x35) then
					send(cp.frisk[1], name)
					send(cp.frisk[2], name)
				elseif wasKeyPressed(0x36) then
					send(cp.cig[1], name)
					send(cp.cig[2], name)
					send(cp.cig[3], name)
				elseif wasKeyPressed(0x37) then
					send("/gesture 11")
					send(cp.gesture[1], name)
					send(cp.gesture[2], name)
				elseif wasKeyPressed(0x38) then
					send(cp.beer[1], name)
					send(cp.beer[2], name)
					send(cp.beer[3], name)
				elseif wasKeyPressed(0x5A) then
					send(cp.finish_gun_2[3], name)
				end
			end
			if isKeyDown(bt.modkey) then
				if wasKeyPressed(0x31) then
					send(bt.finish_gun[1], name)
					send(bt.finish_gun[2])
					send(bt.finish_gun[3])
				end
			end
		end
	end
end

function auto_miner()
	print("AutoMiner loaded")
	while true do
		wait(10)
		if isCharInArea2d(playerPed, 2662.3037,-802.4965,2669.4824,-800.7549, false) then
			if isKeyDown(0xA0) then
				setGameKeyState(17, 255)
				wait(10)
				setGameKeyState(17, 0)
			end
		end
	end
end

function auto_shipment()
	print("AutoShipment(WIP) loaded")
	-- WIP
	-- vehicle id detection from checkdasound @ perfect-soft.net (https://web.archive.org/web/20170706142310/https://perfect-soft.net/)
	local shipment = {}
	shipment.vehs = {[456] = true, [414] = true}
	while true do
		wait(10)
	--	print("shipment running")
		-- TODO: priority shipment dialog
		-- TODO: find out why dialogs close randomly - fixed, now needs testing
		if sampGetCurrentDialogId() == 68 and sampIsDialogActive(68) then
			if isCharInAnyCar(playerPed) then
				if shipment.vehs[getCarModel(storeCarCharIsInNoSave(playerPed))] then
					sampSendDialogResponse(68, 0, 1, -1)
					wait(1000)
					if sampGetCurrentDialogId() == 69 and sampIsDialogActive(69) then
						sampSendDialogResponse(69, 1, ini.auto_shipment.shipmentItem, -1)
						PlayerOnShipment = false
		--				sampCloseCurrentDialogWithButton(0)
					end
				elseif 514 then -- gasoline shipment only on tanker vehicle.
					sampSendDialogResponse(68, 1, 0, -1)
					wait(1000)
					if sampGetCurrentDialogId() == 69 and sampIsDialogActive(69) then
						sampSendDialogResponse(69, 1, 0, -1)
						PlayerOnShipment = false
						sampCloseCurrentDialogWithButton(0)
					end
				end	
			end
		end
	end
end

function auto_drugs()
	print("AutoDrugDealerSmuggler loaded")
	sampRegisterChatCommand("drugtype", function(arg)
		if arg == "pot" or arg == "Pot" or arg == "POT" then
			sampAddChatMessage("changed drug type to pot", -1)
			ini.auto_drugs.dtype = arg
			cfg.save(ini, filename)
		elseif arg == "crack" or arg == "Crack" or arg == "CRACK" then
			sampAddChatMessage("changed drug type to crack", -1)
			ini.auto_drugs.dtype = arg
			cfg.save(ini, filename)
		else
			sampAddChatMessage("Invalid option!", -1)
		end
	end)
	sampRegisterChatCommand("drugamount", function(arg)
		if not arg then
			sampAddChatMessage("Invalid value", -1)
		else
			sampAddChatMessage("Drug amount changed to "..arg)
			ini.auto_drugs.amount = arg
			cfg.save(ini, filename)
		end
	end)
	while true do
		wait(10)
		if isCharInArea2d(playerPed, 69.0425,-293.7464,61.8631,-291.9752, false) then
			sampSendChat("/getcrate")
			wait(500)
			sampSendChat(ini.auto_drugs.dtype)
			wait(5000)
		elseif isCharInArea2d(playerPed, 2143.7629,-1679.5071, 2146.3132,-1681.1292, false) then
			sampSendChat("/getpot "..ini.auto_drugs.amount)
			wait(5000)
		elseif isCharInArea2d(playerPed, 2336.6560,-1195.2983, 2334.4011,-1197.2493, false) then 
			sampSendChat("/getcrack "..ini.auto_drugs.amount)
			wait(5000)
		end
	end
end

function auto_pizza()
	print("AutoPizza loaded")
	while true do
		wait(10)
		if isCharInModel(playerPed, 448) and isCharInArea2d(playerPed, 2105.7817,-1786.2694, 2102.6816,-1789.4761, false) then
			sampSendChat("/getpizza")
			wait(500)
		end
	end
end

function auto_materials()
	print("AutoGetMats loaded")
	-- by Adib (Adib23704#8947)
	-- TODO: Materials Pickup 3
	while true do
		wait(10)
--		print("mats running")
		if isCharInArea2d(playerPed, 1424.9801025391, -1322.8343505859, 1421.2481689453, -1319.0093994141, false) then
			sampSendChat("/getmats")
			wait(1000)
		elseif isCharInArea2d(playerPed, 2392.9506835938, -2006.8590087891, 2388.6696777344, -2009.8463134766, false) then
			sampSendChat("/getmats")
			wait(1000)
		end
	end
end


function main()
	while not isSampAvailable() do wait(100) end
	-- load the script in COMRP only.
	ip, port = sampGetCurrentServerAddress()
	-----------------------------------------------
	if ip == "139.99.26.47" or ip == "samp.equitygaming.net" then
	-----------------------------------------------
		print(a.decode("aHR0cHM6Ly9naWZmdC5tZS9wIzV2TGR2NXJYVGVsRXgzZkxKQ1VW"))
		if not doesFileExist(getWorkingDirectory()..'/config/'..filename) then cfg.save(ini, filename) end
		if ini.main.mainscr then
			if ini.main.auto_rp then lua_thread.create(auto_rp) end
			if ini.main.auto_login then lua_thread.create(auto_login) end
			if ini.main.auto_miner then lua_thread.create(auto_miner) end
			if ini.main.auto_shipment then lua_thread.create(auto_shipment) end
			if ini.main.auto_drugs then lua_thread.create(auto_drugs) end
			if ini.main.auto_pizza then lua_thread.create(auto_pizza) end
			if ini.main.auto_materials then lua_thread.create(auto_materials) end
		end
		----------------------------------------------
		local function togscr(a)
			sampAddChatMessage("Toggled "..a, -1)
			cfg.save(ini, filename)
			thisScript():reload()
		end 
		-----------------------------------------------
		local function togscript(arg)
			if arg == "main" or arg == "MAIN" or arg == "Main" then
				ini.main.mainscr = not ini.main.mainscr
				togscr(arg)
			elseif arg == "autorp" or arg == "AUTORP" or arg == "Autorp" then
				ini.main.auto_rp = not ini.main.auto_rp
				togscr(arg)
			elseif arg == "autologin" or arg == "AUTOLOGIN" or arg == "Autologin" then
				ini.main.auto_login = not ini.main.auto_login
				togscr(arg)
			elseif arg == "autominer" or arg == "AUTOMINER" or arg == "Autominer" then
				ini.main.auto_miner = not ini.main.auto_miner
				togscr(arg)
			elseif arg == "autoshipment" or arg == "AUTOSHIPMENT" or arg == "Autoshipment" then
				ini.main.auto_shipment = not ini.main.auto_shipment
				togscr(arg)
			elseif arg == "autodrugs" or arg == "AUTODRUGS" or arg == "Autodrugs" then
				ini.main.auto_drugs = not ini.main.auto_drugs
				togscr(arg)
			elseif arg == "autopizza" or arg == "AUTOPIZZA" or arg == "Autopizza" then
				ini.main.auto_pizza = not ini.main.auto_pizza
				togscr(arg)
			elseif arg == "automats" or arg == "AUTOMATS" or arg == "Automats" then
				ini.main.auto_materials = not ini.main.auto_materials
				togscr(arg)
			else
				sampAddChatMessage("Invalid option", -1)
			end
		end
		-----------------------------------------------
		sampRegisterChatCommand("togscript", togscript)
		sampRegisterChatCommand("togscr", togscript)
		-----------------------------------------------
		while not ini.main.mainscr do wait(500) end
	end
 end