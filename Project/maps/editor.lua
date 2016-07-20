--[[
Map maker for my MMORPG
Intended to be used by gameserver-owners!
]]

--Variablen

objects = {
	["door"] = true,
	["ladder"] = true,
	["wall"] = true,
	["remove"] = true
}

mapData = {
	blocksX = {

	},
	blocksY = {

	},
	laddersX = {

	},
	laddersY = {

	},
	ladderDestination = {

	},
	doorsX = {

	},
	doorsY = {

	},
	spawnX = 1,
	spawnY = 1,
}

selectedObj = ""

--Funktionen

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

function clear(bg, fg)
	term.setCursorPos(1,1)
	term.setBackgroundColor(bg)
	term.setTextColor(colors.white)
	term.clear()
end

function editor()
	clear(colors.black, colors.white)
	editing = true
	oldTerm = term.native()
	paintutils.drawImage(_layout, 1, 1)
	mapWindow = window.create(oldTerm, 1, 1, 25, 9)
	term.redirect(mapWindow)
	paintutils.drawImage(_map, 1, 1)
	maxX = 25
	maxY = 9
	term.redirect(oldTerm)
	searchBox = window.create(oldTerm, 2, 12, 23, 1)
	searchBox.setBackgroundColor(colors.gray)
	searchBox.setTextColor(colors.lime)
	searchBox.clear()
	searchBox.write("Enter function...")
	while true do
		local event, button, x, y = os.pullEventRaw()

		if event == "mouse_click" and button == 1 and x >= 2 and x <= 24 and y == 12 then
			term.redirect(searchBox)
			term.setCursorPos(1,1)
			term.clear()
			local eingabe = limitRead(23)
			if #eingabe > 0 then
				for key, a in pairs(objects) do
					if eingabe == key then
						selectedObj = eingabe
						term.setCursorPos(1,1)
						term.clear()
						term.write(selectedObj)
						break
					else
						term.setCursorPos(1,1)
						term.clear()
						term.write("Object not found.")
					end
				end
			end
			term.redirect(oldTerm)
		elseif event == "mouse_click" and button == 1 and x >= 1 and x <= 25 and y >= 1 and y <= 9 then
			if selectedObj ~= "" then
				if selectedObj == "wall" then
					term.setCursorPos(x, y)
					term.setBackgroundColor(colors.brown)
					term.setTextColor(colors.white)
					term.write("W")
					table.insert(mapData.blocksX, x)
					table.insert(mapData.blocksY, y)
					redrawBlocks()
				elseif selectedObj == "remove" then
					for _, a in ipairs(mapData.blocksX) do
						if a == x and y == mapData.blocksY[_] then
							table.remove(mapData.blocksX, _)
							table.remove(mapData.blocksY, _)
							paintutils.drawImage(_map, 1, 1)
							redrawBlocks()
						end
					end
					for _, a in ipairs(mapData.laddersX) do
						if a == x and y == mapData.laddersY[_] then
							table.remove(mapData.laddersX, _)
							table.remove(mapData.laddersY, _)
							paintutils.drawImage(_map, 1, 1)
							redrawBlocks()
						end
					end
				elseif selectedObj == "ladder" then
					term.setCursorPos(x, y)
					term.setBackgroundColor(colors.brown)
					term.setTextColor(colors.white)
					term.write("H")
					term.redirect(searchBox)
					term.setCursorPos(1,1)
					term.clear()
					term.write("Please write destination")
					sleep(2)
					term.setCursorPos(1,1)
					term.clear()
					repeat
						local eingabe = limitRead(23)
						term.setCursorPos(1,1)
						term.clear()
					until #eingabe > 0
					term.redirect(oldTerm)
					table.insert(mapData.laddersX, x)
					table.insert(mapData.laddersY, y)
					table.insert(mapData.ladderDestination, eingabe)
					redrawBlocks()
				end
			end
		elseif event == "key" and button == keys.delete then
			local file = fs.open(fldr.."data.lvlDat","w")
			file.write(textutils.serialize(mapData))
			file.close()

			break
		end
	end
end

function redrawBlocks()
	for _, x in ipairs(mapData.blocksX) do
		term.setCursorPos(x, mapData.blocksY[_])
		term.setBackgroundColor(colors.brown)
		term.setTextColor(colors.white)
		term.write("W")
	end
	for _, x in ipairs(mapData.laddersX) do
		term.setCursorPos(x, mapData.laddersY[_])
		term.setBackgroundColor(colors.black)
		term.setTextColor(colors.white)
		term.write("L")
	end
end


--Code

local args = {...}

if #args ~= 2 then
	print("Usage: <thisfile> <pathToMapPicture> <editorLayoutDirectory>")
else
	if fs.exists(args[1]) then
		fldr = args[1]
		_map = paintutils.loadImage(args[1].."data.lvl")
		_layout = paintutils.loadImage(args[2])
		editor()
	end
	--do stuff
end