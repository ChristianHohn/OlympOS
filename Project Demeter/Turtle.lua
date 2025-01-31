require "Logger"
require "Move"

peripheral.find("modem", rednet.open)

ResourceNameList = {
    "minecraft:coal_ore",
    "minecraft:deepslate_coal_ore", 
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:copper_ore",
    "minecraft:deepslate_copper_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:redstone_ore", 
    "minecraft:deepslate_redstone_ore", 
    "minecraft:emerald_ore",
    "minecraft:deepslate_emerald_ore",
    "minecraft:lapis_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "create_new_age:thorium_ore",
    "create_new_age:magnetite_block",
    "create:zinc_ore",
    "create:deepslate_zinc_ore",
}

HeightForResource = {
    ["minecraft:coal_ore"] = 95,
    ["minecraft:deepslate_coal_ore"] = 95,
    ["minecraft:iron_ore"] = 15,
    ["minecraft:deepslate_iron_ore"] = 15,
    ["minecraft:copper_ore"] = 48,
    ["minecraft:deepslate_copper_ore"] = 48,
    ["minecraft:gold_ore"] = -16,
    ["minecraft:deepslate_gold_ore"] = -16,
    ["minecraft:redstone_ore"] = -59,
    ["minecraft:deepslate_redstone_ore"] = -59,
    ["minecraft:emerald_ore"] = 236,
    ["minecraft:deepslate_emerald_ore"] = 236,
    ["minecraft:lapis_ore"] = -1,
    ["minecraft:deepslate_lapis_ore"] = -1,
    ["minecraft:diamond_ore"] = -59,
    ["minecraft:deepslate_diamond_ore"] = -59,
    ["create_new_age:thorium_ore"] = 25,
    ["create:zinc_ore"] = 48,
    ["create:deepslate_zinc_ore"] = 48,
}

Turtle_State = "IDLE" --IDLE, MOVING, MINING, RETURNING, REFUELING, EMERGENCY
Travel_Distance = 0
Base_Position = {0, 0, 0}
Waypoints = {}
Orientation = 0 -- 0 = NORTH, 1 = EAST, 2 = SOUTH, 3 = WEST
Debug = true

local move = Move.new()
local logger = Logger.new()

function IsResource(value) --Hier wird gecheckt ob der als Variable übergebene Wert eine Resource ist
    for i = 1,#ResourceNameList do
      if (ResourceNameList[i] == value) then
        return true
      end
    end
    return false
end

local function write_mission_file(table) --Hier wird die Mission in eine Datei geschrieben wichtig ist das eine Table als input genommen wird
    local file = io.open("Turtle_mission.txt", "w")
    if file then
        file:write(textutils.serialize(table))
        file:close()
    else
        error("Could not open file for writing")
    end
end

local function read_mission_file()
    local file = io.open("Turtle_mission.txt", "r")
    if file then
        local content = file:read("*a")
        file:close()
        return textutils.unserialize(content)
    else
        logger.log("error", "Could not open file for reading")
        return false
    end
end

local function resourceValid(string)
    for _, resource in ipairs(ResourceNameList) do
        if string.find(resource, string) then
            return resource
        end
        
    end
    return false
end

local function setTurtleState(state)
    Turtle_State = state
end

local function getFuelPercent()
    local fuelLevel = turtle.getFuelLevel()
    local fuelLimit = turtle.getFuelLimit()
    local fuelPercent = (fuelLevel / fuelLimit) * 100
    return fuelPercent
end

local function drawProgressBar()
    local barLength = 28
    local filledLength = math.floor((getFuelPercent() / 100) * barLength)
    local bar = "[" .. string.rep("#", filledLength) .. string.rep(" ", barLength - filledLength) .. "]"
    return bar
end

local function saveProgress()
    local saveData = { -- <- Hier bitte noch weiter Daten hinzufügen die nach einem Neustart wieder benötigt werden
        ["MineForResource"] = MineForResource,
        ["Travel_Distance"] = Travel_Distance,
        ["Base_Position"] = Base_Position,
        ["Turtle_State"] = Turtle_State,
        ["Fuel_Percent"] = getFuelPercent(),
        ["Current_Position"] = gps.locate(),
        ["DemeterID"] = DemeterID
    }
    write_mission_file(saveData)
end

local function stripmine()
    setTurtleState("MINING")
    logger.log("info", "Starting strip mining")
    os.setComputerLabel("Stripmining for " .. MineForResource)

    while true do
        -- Check if the turtle has enough fuel
        if Travel_Distance < 25 then
            logger.log("warning", "Low fuel. Returning to base")
            returnToBase()
        end

        -- Check if the turtle has enough space
        if turtle.getItemCount(16) > 0 then
            logger.log("warning", "Inventory is full. Returning to base")
            returnToBase()
        end

        move.forward()
        move.forward()

        for i = 1, 5 do
            move.left()
        end

        for i = 1, 10 do
            move.right()
        end

        for i = 1, 5 do
            move.left()
        end
    end
end

local function setup()
    local fuelLevel = turtle.getFuelLevel()

    -- Danke Chris ^^
    if fuelLevel == 0 then
        write("DENNIS MACH FUEL REIN \n")
        write("> ")
        read()
    end
    -- Calculate the maximum travel distance
    Travel_Distance = turtle.getFuelLimit() / 2
    
    -- Define the resource to mine
    term.clear()

    write("Please enter the ID of the Demter Serer: \n")
    write("> ")
    DemeterID = read()

    while true do
        write("What resource should the turtle mine? \n")
        write("> ")
        local mineForResource_input = read()
        MineForResource = resourceValid(mineForResource_input)

        -- Check if the resource is in the list
        if MineForResource ~= false then
            term.clear()
            logger.log("info", "Start mining for " .. MineForResource)
            break
        else
            term.clear()
            logger.log("warning", "Invalid resource. Please try again.")
        end
    end

    -- Check the Orientation
    local x, y, z = gps.locate()
    move.forward()
    local x2, y2, z2 = gps.locate()

    if x2 > x then
        Orientation = 1
    elseif x2 < x then
        Orientation = 3
    elseif z2 > z then
        Orientation = 2
    elseif z2 < z then
        Orientation = 0
    end

    move.back()

    logger.log("info", "Orientation is " .. Orientation)

    -- Save the base position
    local x, y, z = gps.locate()
    Base_Position = {x, y, z}
    logger.log("info", "Base position saved at " .. x .. ", " .. y .. ", " .. z)

    -- After the resource is defined, the turtle should move to the correct height
    setTurtleState("MOVING")
    local goalHeight = HeightForResource[MineForResource]
    logger.log("info", "Moving to height " .. goalHeight)

    local x, y, z = gps.locate()
    local downSteps = y - goalHeight

    if downSteps > 0 then
        for i = 1, downSteps do
            move.down()
        end
    elseif downSteps < 0 then
        for i = 1, math.abs(downSteps) do
            move.up()
        end
    end
    logger.log("info", "Arrived at height " .. goalHeight)


    -- Start strip mining
    stripmine()
end

--Hier wird gecheckt ob die Turtle gerade neu gestartet wurde oder ob die bereits am Minen war,
--müssen nur dafür sorgen das wenn die Turtle Base ist entweder die File gelöscht wird oder wir sonst wie fest stellen die soll von vorne anfangen
if read_mission_file() ~= false then 
    local mission = read_mission_file() 
    MineForResource = mission["MineForResource"]
    Travel_Distance = mission["Travel_Distance"]
    Base_Position = mission["Base_Position"]
    Turtle_State = mission["Turtle_State"]
    if Turtle_State ~= nil then
        logger.log("info", "Session detected! Resuming mission")
        if Turtle_State == "MINING" then
            stripmine()
        end
    else
        setup()
    end
else
    setup()
end