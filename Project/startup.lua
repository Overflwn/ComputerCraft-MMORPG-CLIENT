side = "top" -- PLEASE REPLACE WITH YOUR MODEM  SIDE

local function getRunningPath()
  local runningProgram = shell.getRunningProgram()
  local programName = fs.getName(runningProgram)
  return runningProgram:sub( 1, #runningProgram - #programName )
end
root = "/"
root = "/"..getRunningPath()

os.loadAPI(root.."/API/sha")

--[[
Hello and thanks for trying my experimental game :)
My goal is to make a multiplayer RPG (which is really hard to make, to be honest)

]]

--Variablen

rednet.open(side)
_ver = 2.1
_verstr = "2.1"
running = true
oldTerm = term.native()
connected = false
tmppw = ""
tmppw2 = ""
servRunning = false
usrName = ""
servId = 0
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
msgs = {
	"ping",
	"true",
	"username",
	"exists",
	"new",
	"wrong pw",
	"deleteacc",
	"changepw"
}

--Funktionen


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
        local event, p1 = os.pullEvent()
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
        local event, p1 = os.pullEvent()
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

function drawLauncher()
	running = true
	clear(colors.gray, colors.white)
	local _p1 = false
	local _p2 = false
	local _pLogin = false
	local _pRegister = false
	local function page1()
		_p1 = true
		_p2 = false
		grayWindow = window.create(oldTerm, 10, 5, 25, 10)
		grayWindow.setBackgroundColor(colors.lightGray)
		grayWindow.setTextColor(colors.black)
		grayWindow.clear()
		term.redirect(grayWindow)
		term.setCursorPos(2,2)
		term.setTextColor(colors.lime)
		term.write("Enter server ID & connect.")
		idTxtBx = window.create(term.current(), 2, 4, 23, 1)
		idTxtBx.setBackgroundColor(colors.gray)
		idTxtBx.setTextColor(colors.lime)
		idTxtBx.clear()
		idTxtBx.write("Enter server ID...")
		term.setCursorPos(2,6)
		term.setBackgroundColor(colors.gray)
		term.setTextColor(colors.white)
		term.write("Ping")
		term.setBackgroundColor(colors.lime)
		term.setCursorPos(2,8)
		term.write("Next")
	end

	local function page2()
		_p2 = true
		_p1 = false
		grayWindow.setBackgroundColor(colors.lightGray)
		grayWindow.setTextColor(colors.white)
		grayWindow.clear()
		term.setCursorPos(2,2)
		term.setTextColor(colors.lime)
		term.setBackgroundColor(colors.lightGray)
		term.write("Enter Username")
		usrTxtBx = window.create(term.current(), 2, 4, 23, 1)
		usrTxtBx.setBackgroundColor(colors.gray)
		usrTxtBx.setTextColor(colors.lime)
		usrTxtBx.clear()
		usrTxtBx.write("Username...")
	end

	local function pageRegister()
		_p2 = false
		_p1 = false
		_pLogin = false
		_pRegister = true

		grayWindow.setBackgroundColor(colors.lightGray)
		grayWindow.setTextColor(colors.white)
		grayWindow.clear()
		term.setCursorPos(2,2)
		term.setTextColor(colors.lime)
		term.write("Register")
		pwTxtBx = window.create(term.current(), 2, 4, 23, 1)
		pwTxtBx.setBackgroundColor(colors.gray)
		pwTxtBx.setTextColor(colors.lime)
		pwTxtBx.clear()
		pwTxtBx.write("Password...")
		pwTxtBx2 = window.create(term.current(), 2, 6, 23, 1)
		pwTxtBx2.setBackgroundColor(colors.gray)
		pwTxtBx2.setTextColor(colors.lime)
		pwTxtBx2.clear()
		pwTxtBx2.write("Repeat password...")
	end

	local function pageLogin()
		_p2 = false
		_p1 = false
		_pRegister = false
		_pLogin = true
		grayWindow.setBackgroundColor(colors.lightGray)
		grayWindow.setTextColor(colors.white)
		grayWindow.clear()
		term.setCursorPos(2,2)
		term.setTextColor(colors.lime)
		term.write("Login: "..usrName)
		pwTxtBx = window.create(term.current(), 2, 4, 23, 1)
		pwTxtBx.setBackgroundColor(colors.gray)
		pwTxtBx.setTextColor(colors.lime)
		pwTxtBx.clear()
		pwTxtBx.write("Password...")
	end

	page1()
	while running do
		local event, button, x, y = os.pullEventRaw("mouse_click")
		if button == 1 and _p1 and x >= 11 and x <= 33 and y == 8 then
			term.redirect(idTxtBx)
			term.clear()
			term.setCursorPos(1,1)
			servId = limitReadNumber(23)
			term.redirect(grayWindow)
			if #servId > 0 then
				servId = tonumber(servId)
				succ, t = ping(servId)
				if succ then
					term.setCursorPos(2,6)
					term.setBackgroundColor(colors.green)
					term.setTextColor(colors.white)
					term.write("Ping")
					connected = true
				else
					term.setCursorPos(2,6)
					term.setBackgroundColor(colors.red)
					term.setTextColor(colors.white)
					term.write("Ping")
					connected = false
				end

			end
		elseif button == 1 and _p1 and connected and x >= 11 and x <= 14 and y == 12 then
			_p1 = false
			_p2 = true
			page2()
		elseif button == 1 and _p2 and x >= 11 and x <= 33 and y == 8 then
			term.redirect(usrTxtBx)
			term.clear()
			term.setCursorPos(1,1)
			usrName = limitRead(23)
			term.redirect(grayWindow)
			if #usrName > 0 then
				succ, t = checkUsrName(usrName)
				if succ == "exists" then
					pageLogin()
				elseif succ == "new" then
					pageRegister()
				elseif succ == "timeout" then
					_p2 = false
					_p1 = true
					page1()
				else
					_p2 = false
					_p1 = true
					page1()
				end
			end
		elseif button == 1 and _pRegister and x >= 11 and x <= 33 and y == 8 then
			term.redirect(pwTxtBx)
			term.clear()
			term.setCursorPos(1,1)
			tmppw = limitRead(23, "*")
			term.redirect(grayWindow)
		elseif button == 1 and _pRegister and x >= 11 and x <= 33 and y == 10 then
			term.redirect(pwTxtBx2)
			term.clear()
			term.setCursorPos(1,1)
			tmppw2 = limitRead(23, "*")
			term.redirect(grayWindow)
			if #tmppw2 > 0 and #tmppw > 0 then
				if tmppw == tmppw2 then
					succ, t = sendRegister()
					if succ then
						_pRegister = false
						page2()
					else
						_pRegister = false
						page1()
					end
				else
					term.redirect(pwTxtBx2)
					term.setCursorPos(1,1)
					term.clear()
					term.setTextColor(colors.red)
					term.write("Password doesn't match.")
					term.setTextColor(colors.lime)
					term.redirect(grayWindow)
				end
			end
		elseif button == 1 and _pLogin and x >= 11 and x <= 33 and y == 8 then
			term.redirect(pwTxtBx)
			term.clear()
			term.setCursorPos(1,1)
			tmppw = limitRead(23, "*")
			term.redirect(grayWindow)
			if #tmppw > 0 then
				succ, a, b = sendLogin()
				if succ == "success" then
					running = false
					term.redirect(oldTerm)
					clear(colors.black, colors.white)
					shell.run(root.."game/game.lua "..usrName.." "..a.." "..root.." "..tostring(servId))
					break
				elseif succ == "wrong pw" then
					term.redirect(pwTxtBx)
					term.clear()
					term.setCursorPos(1,1)
					term.setTextColor(colors.red)
					term.write("Wrong Password...")
					term.setTextColor(colors.lime)
					term.redirect(grayWindow)
				elseif succ == "timeout" then
					_pLogin = false
					page1()
				end
			end
		end
	end
end

function ping(id)
	rednet.send(id, msgs[1])
	id, msg = rednet.receive(3)
	if msg == msgs[2] then
		return true
	else
		return false
	end
end

function sendLogin()
	local usrData = {
		name = "",
		encpw = "",
	}
	usrData.name = usrName
	usrData.encpw = sha.sha256(tmppw..usrName)
	rednet.send(servId, msgs[4], textutils.serialize(usrData))
	id, msg = rednet.receive(3)
	if msg == msgs[2] then
		return "success", usrData.encpw
	elseif msg == msgs[6] then
		return "wrong pw"
	else
		return "timeout"
	end

end

function sendRegister()
	local usrData = {
		name = "",
		encpw = "",
	}
	usrData.encpw = sha.sha256(tmppw..usrName)
	usrData.name = usrName

	rednet.send(servId, msgs[5], textutils.serialize(usrData))
	id, msg = rednet.receive(3)
	if msg == msgs[2] then
		return true
	else
		return false
	end
end

function checkUsrName(name)
	rednet.send(servId, msgs[3], name)
	id, msg = rednet.receive(3)
	if msg == msgs[4] then
		return "exists"
	elseif msg == msgs[5] then

		return "new"
	else
		return "timeout"
	end
end

--Code

drawLauncher()