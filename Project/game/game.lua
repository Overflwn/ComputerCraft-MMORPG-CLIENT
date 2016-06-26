side = "top" --PLEASE CHANGE TO YOUR MODEM SIDE
os.loadAPI(root.."API/sha")




--[[
MAIN GAME
PLEASE EXECUTE LAUNCHER FIRST
]]

--Variablen
rednet.open(side)
_ver = 0.5
_verstr = "0.5"
running = true
menu = false
servId = 0

msgs = {
	"ping",
	"true",
	"username",
	"exists",
	"new",
	"wrong pw",
	"deleteacc",
	"changepw",
	"getplayerdata",
	"spawnplayer",
	"getworlddata",
	"uploadplayerdata"
}

numbrs = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
}

usrData = {
	name = "Sir",
	encpw = "Nobody",
}

playerData = {
	users = {

	},
	inventory = {

	},
	worlds = {

	},
	posX = {

	},
	posY = {

	}
}

mapData = {
	
}

--Hauptfunktionen
function clear(bg, txt)
	term.setCursorPos(1,1)
	term.setBackgroundColor(bg)
	term.setTextColor(txt)
	term.clear()
end

function limitRead(nLimit, replaceChar)
    term.setCursorBlink(true)
    local cX, cY = term.getCursorPos()
    local rString = ""
    if replaceChar == "" then replaceChar = nil end
    repeat
        local event, p1 = os.pullEventRaw()
        if event == "char" then
            -- Character event
            if #rString + 1 <= nLimit then
                rString = rString .. p1
                write(replaceChar or p1)
            end
        elseif event == "key" and p1 == keys.backspace and #rString >= 1 then
            -- Backspace
            rString = string.sub(rString, 1, #rString-1)
            xPos, yPos = term.getCursorPos()
            term.setCursorPos(xPos-1, yPos)
            write(" ")
            term.setCursorPos(xPos-1, yPos)
        end
    until event == "key" and p1 == keys.enter
    term.setCursorBlink(false)
    --print() -- Skip to the next line after clicking enter.
    return rString
end

function limitReadNumber(nLimit, replaceChar)
    term.setCursorBlink(true)
    local cX, cY = term.getCursorPos()
    local rString = ""
    if replaceChar == "" then replaceChar = nil end
    repeat
        local event, p1 = os.pullEventRaw()
        if event == "char" then
            -- Character event only numbers
            for _, numbr in ipairs(numbrs) do
            	if p1 == numbrs[_] then
           		 	if #rString + 1 <= nLimit then
           		     rString = rString .. p1
          	 	     write(replaceChar or p1)
         		   end
         		end
        	end
        elseif event == "key" and p1 == keys.backspace and #rString >= 1 then
            -- Backspace
            rString = string.sub(rString, 1, #rString-1)
            xPos, yPos = term.getCursorPos()
            term.setCursorPos(xPos-1, yPos)
            write(" ")
            term.setCursorPos(xPos-1, yPos)
        end
    until event == "key" and p1 == keys.enter
    term.setCursorBlink(false)
    --print() -- Skip to the next line after clicking enter.
    return rString
end

--Funktionen

function drawIntro(col)
	clear(colors.black, colors.white)
	term.setTextColor(col)
	term.setCursorPos(1,8)
	term.write("O~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~O")
	term.setCursorPos(1,9)
	term.write("|               A multiplayer RPG                 |")
	term.setCursorPos(1,10)
	term.write("|                  By Piorjade                    |")
	term.setCursorPos(1,11)
	term.write("|                                        @2016    |")
	term.setCursorPos(1,12)
	term.write("O~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~O")
end

function redrawMainMenu(c)
	if c == 1 then
		clear(colors.black, colors.white)
		term.setCursorPos(2, 2)
		term.write("Hello, "..usrData.name)
		term.setCursorPos(2, 4)
		print("> Play")
		print("   Change Password")
		print("   Delete User")
		print("   Exit")
	elseif c == 2 then
		clear(colors.black, colors.white)
		term.setCursorPos(2, 2)
		term.write("Hello, "..usrData.name)
		term.setCursorPos(2, 4)
		print("  Play")
		print(" > Change Password")
		print("   Delete User")
		print("   Exit")
	elseif c == 3 then
		clear(colors.black, colors.white)
		term.setCursorPos(2, 2)
		term.write("Hello, "..usrData.name)
		term.setCursorPos(2, 4)
		print("  Play")
		print("   Change Password")
		print(" > Delete User")
		print("   Exit")
	elseif c == 4 then
		clear(colors.black, colors.white)
		term.setCursorPos(2, 2)
		term.write("Hello, "..usrData.name)
		term.setCursorPos(2, 4)
		print("  Play")
		print("   Change Password")
		print("   Delete User")
		print(" > Exit")
	end
end

function deleteAccount()
	rednet.send(servId, msgs[7], textutils.serialize(usrData))
	id, msg = rednet.receive(3)
	if msg == msgs[2] then
		return "success"
	elseif msg == msgs[6] then
		return "wrong pw"
	else
		return "timeout"
	end
end

function changePassword(pw)
	local changed = {
		oldData = {
			name = "",
			encpw = "",

		},
		newData = {
			name = "",
			encpw = "",
		},
	}

	changed.oldData = usrData
	changed.newData.name = usrData.name
	changed.newData.encpw = sha.sha256(pw)
	rednet.send(servId, msgs[8], textutils.serialize(changed))
	id, msg = rednet.receive(3)
	if msg == msgs[2] then
		usrData = changed.newData
		return "success"
	elseif msg == msgs[6] then
		return "wrong pw"
	else
		return "timeout"
	end

end

function drawMainMenu()
	local timer = 0.08
	drawIntro(colors.black)
	sleep(timer)
	drawIntro(colors.gray)
	sleep(timer)
	drawIntro(colors.lightGray)
	sleep(timer)
	drawIntro(colors.white)
	sleep(2.25)
	drawIntro(colors.lightGray)
	sleep(timer)
	drawIntro(colors.gray)
	sleep(timer)
	drawIntro(colors.black)

	redrawMainMenu(1)
	local _mm = 1
	menu = true

	while menu do
		local event, a, b, c = os.pullEventRaw("key")
		if a == keys.down and _mm < 4 then
			redrawMainMenu(_mm+1)
			_mm = _mm+1
		elseif a == keys.up and _mm > 1 then
			redrawMainMenu(_mm-1)
			_mm = _mm-1
		elseif a == keys.enter and _mm == 1 then
			menu = false
			drawGame()
			--do stuff

		elseif a == keys.enter and _mm == 2 then
			term.setCursorPos(20, 5)
			local tmppw = limitRead(23, "*")
			if #tmppw > 0 then
				succ = changePassword(tmppw)
				if succ == "success" then
					term.setCursorPos(20, 6)
					term.write("Success.")
					sleep(1.5)
					shell.run(root.."game/game.lua "..usrData.name.." "..usrData.encpw.." "..root.." 1")
				elseif succ == "wrong pw" then
					menu = false
					clear(colors.black, colors.white)
					print("Error: wrong password!")
					sleep(1.5)
					clear(colors.black, colors.white)
					break
				elseif succ == "timeout" then
					menu = false
					clear(colors.black, colors.white)
					print("Error: Server timed out.")
					sleep(1.5)
					clear(colors.black, colors.white)
					break
				end
			end

		elseif a == keys.enter and _mm == 3 then
			succ = deleteAccount()
			if succ == "success" then
				menu = false
				clear(colors.black, colors.white)
				print("Successfully deleted your account, thanks for playing.")
				sleep(1.5)
				clear(colors.black, colors.white)
				break
			elseif succ == "wrong pw" then
				menu = false
				clear(colors.black, colors.white)
				print("Error: wrong password!")
				sleep(1.5)
				clear(colors.black, colors.white)
				break
			elseif succ == "timeout" then
				menu = false
				clear(colors.black, colors.white)
				print("Error: Server timed out.")
				sleep(1.5)
				clear(colors.black, colors.white)
				break
			end

		elseif a == keys.enter and _mm == 4 then
			clear(colors.black, colors.white)
			print("Thank you for playing.")
			break
		end
	end
end

function sendspawn()
	rednet.send(servId, msgs[10], usrData.name)
	local id, msg, msg2 = rednet.receive(3)
	if msg == msgs[2] then
		playerData = textutils.unserialize(msg2)
		term.setCursorPos(31,8)
		return true
	end
end

function getworld()
	local usrnmbr = "bob"
	local found = false
	--[[for _, usr in ipairs(playerData.users) do
		if usr == usrData.name then
			usrnmbr = _
			found = true
			break
		end
	end
	if found == false then print("player not found") else print("found") end]]

	rednet.send(servId, msgs[11], playerData.worlds[usrData.name])

	id, msg, msg2 = rednet.receive(3)
	if msg == msgs[2] then
		local map = textutils.unserialize(msg2)
		local file = fs.open("/tmp","w")
		file.write(map.layout)
		file.close()
		mapData = map.data
		_map = paintutils.loadImage("/tmp")
		fs.delete("/tmp")
		paintutils.drawImage(_map, 1, 1)
		local file = fs.open("/tmp","w")
		file.write(textutils.serialize(mapData))
		file.close()
		redrawEntitites()
	end
end

function redrawMap()
	paintutils.drawImage(_map, 1, 1)
end

function redrawEntitites()
	local counter = 0
	local myworld = "house1"
	for _, player in pairs(playerData.users) do
		if player == usrData.name then
			myworld = playerData.worlds[player]
		end
		
	end
	for _, player in pairs(playerData.users) do
		if playerData.worlds[player] == myworld then
			local x = playerData.posX[_]
			local y = playerData.posY[_]
			term.setCursorPos(tonumber(x), tonumber(y))
			term.setTextColor(colors.white)
			term.setBackgroundColor(colors.black)
			term.write("P")
			term.setCursorPos(1,13+counter)
			term.write(player)
			counter = counter+1
		end
	end
end

function getEntities()
	while true do
		sleep(0.1)
		rednet.send(servId, msgs[9])
		id, msg, msg2 = rednet.receive()
		if msg == msgs[2] then
			playerData = textutils.unserialize(msg2)
			local counter = 0
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)
			term.setCursorPos(31,1)
			term.write("HELLO")
			for _, usr in pairs(playerData.users) do
				term.setCursorPos(31,2+counter)
				term.write(usr)
				counter = counter+1
			end
			redrawMap()
			redrawEntitites()
		--[[else
			clear(colors.black, colors.white)
			print("Timeout.")
			sleep(1.5)
			os.reboot()]]
		end
	end
end	

function uploadEntities()
	local changed = {
		playerData = {

		},
		changer = {
			name = "",
		}
	}

	changed.playerData = playerData
	changed.changer.name = usrData.name

	rednet.send(servId, msgs[12], textutils.serialize(changed))

	id, msg = rednet.receive(0.1)

	if msg ~=msgs[2] then
		clear(colors.black, colors.white)
		print("Timeout.")
	end
end

function move()
	local lagfaktor = 0.2
	while true do
		local event, key = os.pullEvent("key_up")
		local usrnmbr = 0
		if key == keys.right then
			--[[for _, usr in pairs(playerData.users) do
				if usr == usrData.name then
					usrnmbr = _
				end
			end]]
			oldX = tonumber(playerData.posX[usrData.name])
			oldY = tonumber(playerData.posY[usrData.name])
			local block = false
			for _, bY in ipairs(mapData.blocksY) do
					if oldX+1 == mapData.blocksX[_] and oldY == bY then
						term.setCursorPos(27, 3)
						term.setTextColor(colors.white)
						term.write("BLOCK")
						block = true
						break
					else
						block = false
					end
			end
			if block ~= true then
				term.setCursorPos(27, 3)
				term.setTextColor(colors.white)
				term.write("BLECK")
				playerData.posX[usrData.name] = playerData.posX[usrData.name]+1
				uploadEntities()
				redrawMap()
				redrawEntitites()
			end	
			sleep(lagfaktor)
		elseif key == keys.left then
			--[[for _, usr in ipairs(playerData.users) do
				if usr == usrData.name then
					usrnmbr = _
				end
			end]]
			oldX = tonumber(playerData.posX[usrData.name])
			oldY = tonumber(playerData.posY[usrData.name])
			local block = false
			for _, bY in ipairs(mapData.blocksY) do
					if oldX-1 == mapData.blocksX[_] and oldY == bY then
						term.setCursorPos(27, 3)
						term.setTextColor(colors.white)
						term.write("BLOCK")
						block = true
						break
					else
						block = false
					end
			end
			if block ~= true then
				term.setCursorPos(27, 3)
				term.setTextColor(colors.white)
				term.write("BLECK")
				playerData.posX[usrData.name] = playerData.posX[usrData.name]-1
				uploadEntities()
				redrawMap()
				redrawEntitites()
			end	
			sleep(lagfaktor)
		elseif key == keys.down then
			oldY = tonumber(playerData.posY[usrData.name])
			oldX = tonumber(playerData.posX[usrData.name])
			local block = false
			for _, bY in ipairs(mapData.blocksY) do
					if oldY+1 == bY and oldX == mapData.blocksX[_] then
						term.setCursorPos(27, 3)
						term.setTextColor(colors.white)
						term.write("BLOCK")
						block = true
						break
					else
						
						block = false
					end
			end
			if block ~= true then
				term.setCursorPos(27, 3)
				term.setTextColor(colors.white)
				term.write("BLECK")

				playerData.posY[usrData.name] = playerData.posY[usrData.name]+1
				uploadEntities()
				redrawMap()
				redrawEntitites()
			end
			sleep(lagfaktor)
		elseif key == keys.up then
			oldY = tonumber(playerData.posY[usrData.name])
			oldX = tonumber(playerData.posX[usrData.name])
			local block = false
			for _, bY in ipairs(mapData.blocksY) do
					if oldY-1 == bY and oldX == mapData.blocksX[_] then
						term.setCursorPos(27, 3)
						term.setTextColor(colors.white)
						term.write("BLOCK")
						block = true
						break
					else
						
						block = false
					end
			end
			if block ~= true then
				term.setCursorPos(27, 3)
				term.setTextColor(colors.white)
				term.write("BLECK")

				playerData.posY[usrData.name] = playerData.posY[usrData.name]-1
				uploadEntities()
				redrawMap()
				redrawEntitites()
			end
			sleep(lagfaktor)
		end

	end
end

function drawGame()
	clear(colors.black, colors.white)
	game = true
	a = sendspawn()
	if a == false then
		print("Error: Unknown.")
		game= false
	end

	getworld()

	local c1 = coroutine.create(getEntities)
	local c2 = coroutine.create(move)

	local evt = {}

	while true do
		coroutine.resume(c1, unpack(evt))
		coroutine.resume(c2, unpack(evt))
		evt = {os.pullEvent()}

		if evt[1] == key and evt[2] == keys.delete then
			clear(colors.black, colors.white)
			break
		end
	end
end

--Code


local args = {...}

if #args == 4 then
	root = args[3]
	servId = tonumber(args[4])
	os.loadAPI(root.."/API/sha")
	usrData.name = args[1]
	usrData.encpw = args[2]
	--do stuff
else
	clear(colors.black, colors.white)
	print("Please execute the launcher...")
end

drawMainMenu()