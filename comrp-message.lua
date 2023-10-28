--[[

Script date: 2022-01-22 08:30 PST

]]
messagetocomrp =
[[
Welcome to City of Manila Freeroam!

recently, the Community Directors decided to rename
the server to City of Manila Freeroam.

They admitted that they were lazy to fix the shit 
that made their server a "freeroam" server instead
of a roleplay server.

You might be wondering - who made this script?

well... it's a secret... for now....
]]

script_name('hahahahahahahahahahahaha')
script_author('unknown')
script_description('PUTANGINA MO PO')
script_version_number(1)

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD + font_flag.SHADOW)
local TEST = renderLoadTextureFromFile('config\fuck.png')

ev = require 'lib.samp.events'

require 'lib.sampfuncs'

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand('comfrmessage', checkifcomrp)
	sampfuncsLog('some message script loaded')

	wait(-1)
end

function textdrawtest()
   sampTextdrawCreate(1001,"City", 10.0, 428.0)
   sampTextdrawCreate(1002,"of", 30.0, 428.0)
   sampTextdrawCreate(1003,"Manila", 44.0, 428.0)
   sampTextdrawCreate(1004,"Freeroam", 74.0, 428.0)
   sampTextdrawCreate(1005,"by", 20.0, 437.0)
   sampTextdrawCreate(1006,"Equity", 33.0, 437.0)
   sampTextdrawCreate(1007,"Gayming", 62.0, 437.0)
end

function showcomrpmessage()
    sampShowDialog(6642, 'Welcome to CoM:FR', messagetocomrp, 'Okay', 'Quit', DIALOG_STYLE_MSGBOX)
end

function showcomrpmessage1()
    sampShowDialog(6642, 'Welcome to CoM:FR', messagetocomrp, 'Okay', 'Quit', DIALOG_STYLE_MSGBOX)
	textdrawtest()
--	setCharHealth(playerPed, 0)
end

function checkifcomrp()
    ip, port = sampGetCurrentServerAddress()
    if ip == '51.79.230.96' then showcomrpmessage() else sampAddChatMessage('You\'re not in CoM:FR.', 0xFFFFFF) end
    mngclog1()
end

function ev.onShowTextDraw(id, data)
	if data.text == 'City of Manila Roleplay' then textdrawtest() return false end
	if data.text == 'equitygaming.net' then return false end
end


function mngclog1()
    sampfuncsLog("-------------------------------")
    sampfuncsLog("----     MNGC was here.    ----")
    sampfuncsLog("-------------------------------")
end
function checknick2()
	wait(6000)
	local asslickers = "Adam_W._Dalmore Mike_Banning Carl_T._Fajardo Carl_Fajardo Kayden_Break Lhiana_Morel Luna_Morel Devi_Kim_Blaze Dodong_Walwalito Locco_Mondragon Tommy_G_Mondragon Jeck_La_Blanca Eric_S._Adler Chester_Makarov Dan_V._Eutaveh Sylvester_Hawthorne Kim_V._Eutaveh"
	_, id = sampGetPickupSampIdByHandle(playerPed)
	nickname = sampGetPlayerNickname(id)
	if string.find(asslickers, nickname) then
	wait(0)
		sampAddChatMessage("HELLO COMRP ASSLICKER! -Zulan", 0xCCFFFF)
		wait(100)
		sampProcessChatInput("/q")
	end
end