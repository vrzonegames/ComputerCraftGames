-- Get the terminal size. Helpful for displaying text
local w, h = term.getSize() 

-- Paint title
paintutils.drawFilledBox(0, 0, w, h, colors.gray)
paintutils.drawFilledBox(0, 0, w, 2, colors.cyan)	

-- Add in the close button
term.setCursorPos(w - 1,1)
term.setBackgroundColor(colors.red)
term.write(" X")

-- Load in the username from the load game screen
local args = {...}

-- If the username was passed along, set it to a variable
local username = ""
if args[1] then
    username = args[1]
else
    username = ""
end

-- This function will calculate a new upgrade price based on the base price and the amount owned
function calculateNewPrice(basePrice, owned)
    local newPrice = math.floor((basePrice * math.pow(1.1, owned)) + 0.5)
    return newPrice
end

-- This function saves all of the variables to the users save file to be read when the game loads
local function save()
   local hWrite = fs.open("saves/" .. username .. "_save_file", "w")
   hWrite.writeLine(cps)
   hWrite.writeLine(diamonds)
   hWrite.writeLine(diamondsGiven)
   hWrite.writeLine(store)
   hWrite.writeLine(woodPickPrice)
   hWrite.writeLine(woodPicksOwned)
   hWrite.writeLine(woodPickCPS)
   hWrite.writeLine(stonePickPrice)
   hWrite.writeLine(stonePicksOwned)
   hWrite.writeLine(stonePickCPS)
   hWrite.writeLine(ironPickPrice)
   hWrite.writeLine(ironPicksOwned)
   hWrite.writeLine(ironPickCPS)
   hWrite.writeLine(diamondPickPrice)
   hWrite.writeLine(diamondPicksOwned)
   hWrite.writeLine(diamondPickCPS)
   hWrite.writeLine(woodPickUpgradePrice)
   hWrite.writeLine(woodPickUpgradesOwned)
   hWrite.writeLine(woodPickMultiplier)
   hWrite.writeLine(stonePickUpgradePrice)
   hWrite.writeLine(stonePickUpgradesOwned)
   hWrite.writeLine(stonePickMultiplier)
   hWrite.writeLine(ironPickUpgradePrice)
   hWrite.writeLine(ironPickUpgradesOwned)
   hWrite.writeLine(ironPickMultiplier)
   hWrite.writeLine(diamondPickUpgradePrice)
   hWrite.writeLine(diamondPickUpgradesOwned)
   hWrite.writeLine(diamondPickMultiplier)
   hWrite.close()
end

-- This function will load all of the variables saved to the users save file
local function load()
    local hRead = fs.open("saves/" .. username .. "_save_file", "r")
    if hRead then
        cps = tonumber(hRead.readLine())
        diamonds = tonumber(hRead.readLine())
        diamondsGiven = tonumber(hRead.readLine())
        store = hRead.readLine()
        if store == "true" then
            store = true
        else 
            store = false
        end
        woodPickPrice = tonumber(hRead.readLine())
        woodPicksOwned = tonumber(hRead.readLine())
        woodPickCPS = tonumber(hRead.readLine())
        stonePickPrice = tonumber(hRead.readLine())
        stonePicksOwned = tonumber(hRead.readLine())
        stonePickCPS = tonumber(hRead.readLine())
        ironPickPrice = tonumber(hRead.readLine())
        ironPicksOwned = tonumber(hRead.readLine())
        ironPickCPS = tonumber(hRead.readLine())
        diamondPickPrice = tonumber(hRead.readLine())
        diamondPicksOwned = tonumber(hRead.readLine())
        diamondPickCPS = tonumber(hRead.readLine())
        woodPickUpgradePrice = tonumber(hRead.readLine())
        woodPickUpgradesOwned = tonumber(hRead.readLine())
        woodPickMultiplier = tonumber(hRead.readLine())
        stonePickUpgradePrice = tonumber(hRead.readLine())
        stonePickUpgradesOwned = tonumber(hRead.readLine())
        stonePickMultiplier = tonumber(hRead.readLine())
        ironPickUpgradePrice = tonumber(hRead.readLine())
        ironPickUpgradesOwned = tonumber(hRead.readLine())
        ironPickMultiplier = tonumber(hRead.readLine())
        diamondPickUpgradePrice = tonumber(hRead.readLine())
        diamondPickUpgradesOwned = tonumber(hRead.readLine())
        diamondPickMultiplier = tonumber(hRead.readLine())
        hRead.close()
       
        return true
   else
        return false
   end
end

-- Use this function to print text centered on the screen
local function printCentered(sText)
  local x, y = term.getCursorPos()
  x = math.max(math.floor((w / 2) - (#sText / 2)), 0)
  term.setCursorPos(x,y)
  print(sText)
end

-- Initialize variables that don't need to be saved
woodPickBasePrice = 15
woodPickStartingCPS = .2

stonePickBasePrice = 100
stonePickStartingCPS = .8

ironPickBasePrice = 500
ironPickStartingCPS = 4

diamondPickBasePrice = 2000
diamondPickStartingCPS = 10

-- Load the variables on launch, if this is the first time playing, create the variables
if load() then
    load()
else 
    diamonds = 0
    cps = 0
    diamondsGiven = 0
    store = false
    
    -- Wooden Pick Data
    woodPickPrice = 15
    woodPicksOwned = 0
    woodPickCPS = 0

    -- Stone Pick Data
    stonePickPrice = 100
    stonePicksOwned = 0
    stonePickCPS = 0

    -- Iron Pick Data
    ironPickPrice = 500
    ironPicksOwned = 0
    ironPickCPS = 0

    -- Diamond Pick Data
    diamondPickPrice = 2000
    diamondPicksOwned = 0
    diamondPickCPS = 0

    -- Wooden Pick Upgrade Data
    woodPickUpgradePrice = 100
    woodPickUpgradesOwned = 0
    woodPickMultiplier = 1

    -- Stone Pick Store Data
    stonePickUpgradePrice = 1000
    stonePickUpgradesOwned = 0
    stonePickMultiplier = 1

    -- Iron Pick Store Data
    ironPickUpgradePrice = 10000
    ironPickUpgradesOwned = 0
    ironPickMultiplier = 1

    -- Diamond Pick Store Data
    diamondPickUpgradePrice = 100000
    diamondPickUpgradesOwned = 0
    diamondPickMultiplier = 1
    
end

-- Use this function to correctly display a number. 
-- num is the number to format, if isInt is true, it will round to the nearest int
local function displayNumber(num, isInt)

    local num = num or 0
    local newNum = 0
    local isInt = isInt or false
    
    if num >= 1000000 then
        newNum = num / 1000000
        newNum = math.floor(newNum * 100)/100
        newNum = tostring(newNum)
        if isInt == false then
            newNum = string.format("%.1f", newNum) .. "M"
        end
    elseif num >= 1000 then
        newNum = num / 1000
        newNum = math.floor(newNum * 100)/100
        newNum = tostring(newNum)
        if isInt == false then
            newNum = string.format("%.1f", newNum) .. "K"
        end
    else
        newNum = tostring(num)
        if isInt == false then
            newNum = string.format("%.1f", newNum)
        end
    end
    
    return newNum
end

-- Write the title text
term.setCursorPos(0,1)
term.setBackgroundColour(colours.cyan)
term.setTextColour(colours.white)
printCentered("Diamond Digger")
print(string.rep("-", w))

-- Draw diamond
paintutils.drawPixel(7, 7, colors.black)
paintutils.drawPixel(8, 7, colors.black)
paintutils.drawPixel(9, 7, colors.black)
paintutils.drawPixel(10, 8, colors.black)
paintutils.drawPixel(11, 9, colors.black)
paintutils.drawPixel(12, 10, colors.black)
paintutils.drawPixel(12, 11, colors.black)
paintutils.drawPixel(11, 12, colors.black)
paintutils.drawPixel(10, 13, colors.black)
paintutils.drawPixel(9, 13, colors.black)
paintutils.drawPixel(8, 13, colors.black)
paintutils.drawPixel(7, 13, colors.black)
paintutils.drawPixel(6, 13, colors.black)
paintutils.drawPixel(5, 12, colors.black)
paintutils.drawPixel(4, 11, colors.black)
paintutils.drawPixel(4, 10, colors.black)
paintutils.drawPixel(5, 9, colors.black)
paintutils.drawPixel(6, 8, colors.black)
paintutils.drawPixel(7, 8, colors.white)
paintutils.drawPixel(8, 8, colors.white)
paintutils.drawPixel(9, 8, colors.white)
paintutils.drawPixel(6, 9, colors.white)
paintutils.drawPixel(7, 9, colors.cyan)
paintutils.drawPixel(8, 9, colors.cyan)
paintutils.drawPixel(9, 9, colors.cyan)
paintutils.drawPixel(10, 9, colors.cyan)
paintutils.drawPixel(5, 10, colors.cyan)
paintutils.drawPixel(6, 10, colors.blue)
paintutils.drawPixel(7, 10, colors.cyan)
paintutils.drawPixel(8, 10, colors.cyan)
paintutils.drawPixel(9, 10, colors.cyan)
paintutils.drawPixel(10, 10, colors.blue)
paintutils.drawPixel(11, 10, colors.cyan)
paintutils.drawPixel(5, 11, colors.cyan)
paintutils.drawPixel(6, 11, colors.blue)
paintutils.drawPixel(7, 11, colors.blue)
paintutils.drawPixel(8, 11, colors.blue)
paintutils.drawPixel(9, 11, colors.blue)
paintutils.drawPixel(10, 11, colors.blue)
paintutils.drawPixel(11, 11, colors.cyan)
paintutils.drawLine(6, 12, 10, 12, colors.cyan)

-- A function used to control the logic of the white outline around the diamond on click
function updateDiamondOutline()
    drawDiamondOutline(colors.white)
    sleep(.2)
    drawDiamondOutline(colors.gray)
end

-- The function that draws the diamond outline to the screen
function drawDiamondOutline(color)

    color = color or colors.gray
    
    paintutils.drawLine(7, 6, 9, 6, color)
    paintutils.drawPixel(10, 7, color)
    paintutils.drawPixel(11, 8, color)
    paintutils.drawPixel(12, 9, color)
    paintutils.drawLine(13, 10, 13, 11, color)
    paintutils.drawPixel(12, 12, color)
    paintutils.drawPixel(11, 13, color)
    paintutils.drawLine(10, 14, 6, 14, color)
    paintutils.drawPixel(5, 13, color)
    paintutils.drawPixel(4, 12, color)
    paintutils.drawLine(3, 11, 3, 10, color)
    paintutils.drawPixel(4, 9, color)
    paintutils.drawPixel(5, 8, color)
    paintutils.drawPixel(6, 7, color) 
   
end

-- Draw shop button
term.setTextColour(colours.white)
term.setBackgroundColor(colors.cyan)
term.setCursorPos(5, 16)
term.write("       ")
term.setCursorPos(5, 17)
term.write(" Store ")
term.setCursorPos(5, 18)
term.write("       ")

-- A function used to set the score
function setDiamonds()
    
    while true do
        os.sleep(0)
        
        -- If the game is being run on a command computer, give the player diamonds for certain milestones
        if commands then
            if diamonds >= 100 and diamondsGiven == 0 then
                diamondsGiven = 1
                commands.say("@p has earned a diamond by playing Diamond Digger!")
                commands.exec("give @p diamond 1")
            elseif diamonds >= 1000 and diamondsGiven == 1 then
                diamondsGiven = 2
                commands.say("@p has earned a diamond by playing Diamond Digger!")
                commands.exec("give @p diamond 1")
            elseif diamonds >= 10000 and diamondsGiven == 2 then
                diamondsGiven = 3
                commands.say("@p has earned a diamond by playing Diamond Digger!")
                commands.exec("give @p diamond 1")
            elseif diamonds >= 100000 and diamondsGiven == 3 then
                diamondsGiven = 4
                commands.say("@p has earned a diamond by playing Diamond Digger!")
                commands.exec("give @p diamond 1")
            elseif diamonds >= 1000000 and diamondsGiven == 3 then
                diamondsGiven = 5
                commands.say("@p has earned a diamond by playing Diamond Digger!")
                commands.exec("give @p diamond 1")
            end
        end
        
        -- If we are on the store page, draw the store, else, draw the upgrades page
        if store == false then
        	drawUpgrades(0,0)
        else 
            drawStore(0,0)
        end
        
        -- Calculate the clicks per second based on the upgrades and their multipliers
        cps = (woodPickCPS * woodPickMultiplier) + (stonePickCPS * stonePickMultiplier) + (ironPickCPS * ironPickMultiplier) + (diamondPickCPS * diamondPickMultiplier)
        
        -- Calculate the new score based on the current diamonds, and the clicks per second
        -- The .05 is used to convert it from ticks to seconds
        diamonds = diamonds + (cps * .05)
        term.setBackgroundColor(colors.gray)
        term.setTextColor(colors.white)
        term.setCursorPos(2,4)
        
        -- I'm not all that familiar with Lua:CC so this is the dumb code I came up with instead of clearing the whole line
        local diamondString = tostring(displayNumber(diamonds)) .. " diamonds"
        
        while string.len(diamondString) < 15 do
            diamondString = diamondString .. " "
        end
        
        term.write(diamondString)
        term.setCursorPos(2,5)
        
        local cpsString = tostring(displayNumber(cps)) ..  " CPS"
   
        while string.len(cpsString) < 11 do
            cpsString = cpsString .. " "
        end
        
        term.write(cpsString)
    end
end    

-- Get the touch inputs and redirect accordingly
function handleTouchInputs()
    while true do
        save()
        local event, side, x, y = os.pullEvent()
  
        if event == "monitor_touch" or event == "mouse_click" then
            if ((x>=4 and x<=12) and (y>= 7 and y<= 13)) then
                updateDiamondOutline()
                term.setCursorPos(2,4)
                term.clearLine()
                diamonds = diamonds + 1
            elseif ((x>=5 and x<= 11) and (y>=16 and y<=18)) then
                sleep(.2)
            	if store == false then
                    store = true
                else 
                    store = false
                end
            elseif ((x == w or x == w - 1) and y == 1) then
            	os.reboot()
            end
                
        end
    	
        term.setTextColour(colours.white)
        term.setBackgroundColor(colors.cyan)
        term.setCursorPos(5, 17)
        if store == false then
            term.write(" Store ")
        	drawUpgrades(x, y)
        else 
            term.write(" Picks ")
            drawStore(x, y)
        end
        
    end
end

-- This function draws all of the upgrades onto the screen
function drawUpgrades(x,y)
    
    local x = x or 0
    local y = y or 0
    
    -- Draw upgrades outline
    paintutils.drawFilledBox(18, 5, 48, 18, colors.black)
    paintutils.drawFilledBox(32, 6, 34, 17, colors.black)
    paintutils.drawFilledBox(19, 11, 47, 12, colors.black)
    
        -- Wooden Pick
        if diamonds >= woodPickPrice then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(19, 6, 31, 10, colors.green)
            if ((x>=19 and x<=31) and (y>=6 and y<=10)) then
                diamonds = diamonds - woodPickPrice
                woodPicksOwned = woodPicksOwned + 1
                woodPickPrice = calculateNewPrice(woodPickBasePrice, woodPicksOwned)
                woodPickCPS = woodPickCPS + woodPickStartingCPS
            end
        elseif diamonds < woodPickPrice then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(19, 6, 31, 10, colors.red)
        end  
    
        term.setCursorPos(20,6)
        term.write("Wooden")
        term.setCursorPos(20,7)
        term.write("Pickaxe")
        term.setCursorPos(20,8)
        term.write("Price:" .. displayNumber(woodPickPrice))
        term.setCursorPos(20,9)
        term.write("Owned:" .. displayNumber(woodPicksOwned, true))
        term.setCursorPos(20,10)
        term.write("CPS:" .. (displayNumber(woodPickCPS * woodPickMultiplier)))
    
        -- Stone Pick
        if diamonds >= stonePickPrice then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(35, 6, 47, 10, colors.green)
            if ((x>=35 and x<=47) and (y>=6 and y<=10)) then
                diamonds = diamonds - stonePickPrice
                stonePicksOwned = stonePicksOwned + 1
                stonePickPrice = calculateNewPrice(stonePickBasePrice, stonePicksOwned)
                stonePickCPS = stonePickCPS + stonePickStartingCPS
            end
        elseif diamonds < stonePickPrice then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(35, 6, 47, 10, colors.red)
        end  
    
        term.setCursorPos(36,6)
        term.write("Stone")
        term.setCursorPos(36,7)
        term.write("Pickaxe")
        term.setCursorPos(36,8)
        term.write("Price:" .. displayNumber(stonePickPrice))
        term.setCursorPos(36,9)
        term.write("Owned:" .. displayNumber(stonePicksOwned, true))
        term.setCursorPos(36,10)
        term.write("CPS:" .. (displayNumber(stonePickCPS * stonePickMultiplier)))
    
        -- Iron Pick
        if diamonds >= ironPickPrice then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(19, 13, 31, 17, colors.green)
            if ((x>=19 and x<=31) and (y>=13 and y<=17)) then
                diamonds = diamonds - ironPickPrice
                ironPicksOwned = ironPicksOwned + 1
                ironPickPrice = calculateNewPrice(ironPickBasePrice, ironPicksOwned)
                ironPickCPS = ironPickCPS + ironPickStartingCPS
            end
        elseif diamonds < ironPickPrice then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(19, 13, 31, 17, colors.red)
        end  
    
        term.setCursorPos(20,13)
        term.write("Iron")
        term.setCursorPos(20,14)
        term.write("Pickaxe")
        term.setCursorPos(20,15)
        term.write("Price:" .. displayNumber(ironPickPrice))
        term.setCursorPos(20,16)
        term.write("Owned:" .. displayNumber(ironPicksOwned, true))
        term.setCursorPos(20,17)
        term.write("CPS:" .. (displayNumber(ironPickCPS * ironPickMultiplier)))
                      
        -- Diamond Pick
        if diamonds >= diamondPickPrice then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(35, 13, 47, 17, colors.green)
            if ((x>=35 and x<=47) and (y>=13 and y<=17)) then
                diamonds = diamonds - diamondPickPrice
                diamondPicksOwned = diamondPicksOwned + 1
                diamondPickPrice = calculateNewPrice(diamondPickBasePrice, diamondPicksOwned)
                diamondPickCPS = diamondPickCPS + diamondPickStartingCPS
            end
        elseif diamonds < diamondPickPrice then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(35, 13, 47, 17, colors.red)
        end  
    
        term.setCursorPos(36,13)
        term.write("Diamond")
        term.setCursorPos(36,14)
        term.write("Pickaxe")
        term.setCursorPos(36,15)
        term.write("Price:" .. displayNumber(diamondPickPrice))
        term.setCursorPos(36,16)
        term.write("Owned:" .. displayNumber(diamondPicksOwned, true))
        term.setCursorPos(36,17)
        term.write("CPS:" .. (displayNumber(diamondPickCPS * diamondPickMultiplier)))
end

-- This function is used to draw the store on the screen
function drawStore(x,y)
    
    local x = x or 0
    local y = y or 0
    
    -- Draw Store Outline
    
    paintutils.drawFilledBox(18, 5, 48, 18, colors.orange)
    paintutils.drawFilledBox(32, 6, 34, 17, colors.orange)
    paintutils.drawFilledBox(19, 11, 47, 12, colors.orange)
    
        -- Wooden Pick
        if diamonds >= woodPickUpgradePrice and woodPicksOwned >= 1 then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(19, 6, 31, 10, colors.green)
            if ((x>=19 and x<=31) and (y>=6 and y<=10)) then
                diamonds = diamonds - woodPickUpgradePrice
                woodPickUpgradesOwned = woodPickUpgradesOwned + 1
                woodPickUpgradePrice = math.floor((woodPickUpgradePrice * 4) + 0.25)
            	if woodPickMultiplier == 1 then
                	woodPickMultiplier = woodPickMultiplier +1
				else
            		woodPickMultiplier = woodPickMultiplier * 2
                end
            end
        elseif diamonds < woodPickUpgradePrice or woodPicksOwned < 1 then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(19, 6, 31, 10, colors.red)
        end  
    
        term.setCursorPos(20,6)
        term.write("Wooden")
        term.setCursorPos(20,7)
        term.write("Multiplier")
        term.setCursorPos(20,8)
        term.write("Price:" .. displayNumber(woodPickUpgradePrice))
        term.setCursorPos(20,9)
        term.write("Owned:" .. displayNumber(woodPickUpgradesOwned, true))
        term.setCursorPos(20,10)
        term.write("Multi:" .. (displayNumber(woodPickMultiplier, true)))
    
        -- Stone Pick
        if diamonds >= stonePickUpgradePrice and stonePicksOwned >= 1 then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(35, 6, 47, 10, colors.green)
            if ((x>=35 and x<=47) and (y>=6 and y<=10)) then
                diamonds = diamonds - stonePickUpgradePrice
                stonePickUpgradesOwned = stonePickUpgradesOwned + 1
                stonePickUpgradePrice = math.floor((stonePickUpgradePrice * 4) + 0.25)
            	if stonePickMultiplier == 1 then
                	stonePickMultiplier = stonePickMultiplier +1
				else
            		stonePickMultiplier = stonePickMultiplier * 2
                end            
        	end
        elseif diamonds < stonePickUpgradePrice or stonePicksOwned < 1 then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(35, 6, 47, 10, colors.red)
        end  
    
        term.setCursorPos(36,6)
        term.write("Stone")
        term.setCursorPos(36,7)
        term.write("Multiplier")
        term.setCursorPos(36,8)
        term.write("Price:" .. displayNumber(stonePickUpgradePrice))
        term.setCursorPos(36,9)
        term.write("Owned:" .. displayNumber(stonePickUpgradesOwned, true))
        term.setCursorPos(36,10)
        term.write("Multi:" .. (displayNumber(stonePickMultiplier, true)))
    
        -- Iron Pick
        if diamonds >= ironPickUpgradePrice and ironPicksOwned >= 1 then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(19, 13, 31, 17, colors.green)
            if ((x>=19 and x<=31) and (y>=13 and y<=17)) then
                diamonds = diamonds - ironPickUpgradePrice
                ironPickUpgradesOwned = ironPickUpgradesOwned + 1
                ironPickUpgradePrice = math.floor((ironPickUpgradePrice * 4) + 0.25)
            	if ironPickMultiplier == 1 then
                	ironPickMultiplier = ironPickMultiplier +1
				else
            		ironPickMultiplier = ironPickMultiplier * 2
                end            
        	end
        elseif diamonds < ironPickUpgradePrice or ironPicksOwned < 1 then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(19, 13, 31, 17, colors.red)
        end  
    
        term.setCursorPos(20,13)
        term.write("Iron")
        term.setCursorPos(20,14)
        term.write("Multiplier")
        term.setCursorPos(20,15)
        term.write("Price:" .. displayNumber(ironPickUpgradePrice))
        term.setCursorPos(20,16)
        term.write("Owned:" .. displayNumber(ironPickUpgradesOwned, true))
        term.setCursorPos(20,17)
        term.write("Multi:" .. (displayNumber(ironPickMultiplier, true)))
                      
        -- Diamond Pick
        if diamonds >= diamondPickUpgradePrice and diamondPicksOwned >= 1 then
            term.setBackgroundColor(colors.green)
            paintutils.drawFilledBox(35, 13, 47, 17, colors.green)
            if ((x>=35 and x<=47) and (y>=13 and y<=17)) then
                diamonds = diamonds - diamondPickUpgradePrice
                diamondPickUpgradesOwned = diamondPickUpgradesOwned + 1
                diamondPickUpgradePrice = math.floor((diamondPickUpgradePrice * 4) + 0.25)
            	if diamondPickMultiplier == 1 then
                	diamondPickMultiplier = diamondPickMultiplier +1
				else
            		diamondPickMultiplier = diamondPickMultiplier * 2
                end            
        	end
        elseif diamonds < diamondPickUpgradePrice or diamondPicksOwned < 1 then
            term.setBackgroundColor(colors.red)
            paintutils.drawFilledBox(35, 13, 47, 17, colors.red)
        end  
    
        term.setCursorPos(36,13)
        term.write("Diamond")
        term.setCursorPos(36,14)
        term.write("Multiplier")
        term.setCursorPos(36,15)
        term.write("Price:" .. displayNumber(diamondPickUpgradePrice))
        term.setCursorPos(36,16)
        term.write("Owned:" .. displayNumber(diamondPickUpgradesOwned, true))
        term.setCursorPos(36,17)
        term.write("Multi:" .. (displayNumber(diamondPickMultiplier, true)))
end

-- This is what allows the program to wait for inputs as well as keep the score going at the same time
parallel.waitForAny(setDiamonds, handleTouchInputs)
