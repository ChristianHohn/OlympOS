require "functions.NodeChecker"
require "functions.Logger"
require "functions.WayPoints"

Move = {}
Move.new = function ()
    local self = {}

    local logger = Logger.new()
    local nodeChecker = NodeChecker.new()

    local waypoints = WayPoints.new()
    

    local function down()
        waypoints.add_waypoint("down")
        turtle.digDown()
        
        a1, a2 = turtle.down()
        if a1 == false then
            logger.log("error", a2)
            return false
        end

        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
    end

    local function up()
        waypoints.add_waypoint("up")
        turtle.digUp()
        
        a1, a2 = turtle.up()
        if a1 == false then
            logger.log("error", a2)
            return false
        end
        
        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
    end
    
    local function forward()
        waypoints.add_waypoint("forward")
        turtle.dig()
        self.move()
    end

    local function back()
        waypoints.add_waypoint("back")
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()
        
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()
    end

    local function left()
        waypoints.add_waypoint("left")
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
        nodeChecker.check()
    end

    local function right()
        waypoints.add_waypoint("right")
        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()
    end

    function move()
        local success, reason = turtle.forward()
        if not success then
            logger.log("error", reason)

            -- If the reason he cant move is because it is obstructed, check the obstruction.
            -- If the obstruction is gravel or sand, dig it and try to move again.
            -- Loop this until the turtle can move again.
            while reason == "Movement obstructed" do
                local success, data = turtle.inspect()
                if success then
                    if data.name == "minecraft:gravel" or data.name == "minecraft:sand" then
                        turtle.dig()
                        success, reason = turtle.forward()
                        if success then
                            break
                        end
                    end
                end
            end
        end
        
        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
        nodeChecker.check()
    end

    -- Public Methods
    self.down = down
    self.up = up
    self.forward = forward
    self.back = back
    self.left = left
    self.right = right

    -- Private Methods
    self.move = move

    return self
end