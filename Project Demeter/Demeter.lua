--Muss Reworked werden!!!
--Aktuelle Hauptfunktion ist das Loggen von Turtles und deren Namen zuweisung

peripheral.find("modem", rednet.open)



Title = {
    '                                                   ',
    '                                                   ',
    '---------------------------------------------------',
    '                                                   ',
    '  #####   #### ##       ## #### ##### #### #####   ',
    '  #    #  #    # #     # # #      #   #    #    #  ',
    '  #     # #    # #     # # #      #   #    #    #  ',
    '  #     # ###  #  #   #  # ###    #   ###  #####   ',
    '  #     # #    #  #   #  # #      #   #    #    #  ',
    '  #    #  #    #   # #   # #      #   #    #    #  ',
    '  #####   #### #    #    # ####   #   #### #    #  ',
    '                                                   ',
    '---------------------------------------------------',
    '             +                                     ',
    '---------------------------------------------------',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
}

os.setComputerLabel("Demeter")


function PrintTitle()
    term.clear()
    for y_offset, line in pairs(Title) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.brown)
            elseif char == '+' then
                term.write("Harvest, Grow and Nourish")
            elseif char == '/' then
                term.setBackgroundColor(colors.gray)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
    end
    term.setBackgroundColor(colors.black)
end

PrintTitle()


local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

--Drone Iteration und Slave List müssen noch zusammengefügt werden und dann in einer Datei gespeicher, aktuell werden die in zwei unterschiedlichen gespeicher. Außerdem muss ich mir noch anschauen wie man Tables in einer File speichert und dann wieder richtig lädt

function Read_Drone_Iteration()
    if not file_exists("disk/Drone_Iteration.txt") then 
        local f = io.open("disk/Drone_Iteration.txt", "w")
        if f ~= nil then
            f:write("0")
            f:close()
        end
    end

    local lines = {}
    for line in io.lines("disk/Drone_Iteration.txt") do
        lines[#lines + 1] = line
    end
    return lines[0]
end

function Read_Slave_List()
    if not file_exists("disk/Slave_List.txt") then 
        local f = io.open("disk/Slave_List.txt", "w")
        if f ~= nil then
            f:write("0")
            f:close()
        end
    end

    local lines = {}
    for line in io.lines("disk/Slave_List.txt") do
        lines[#lines + 1] = line
    end
    return lines
end

function Check_Turtle_FuelChest()
    --Check ob genug fuel in FuelChest, sollte angeschlossen sein per Kabel
    --Bei zu wenig meldung an Zeus schicken
end

function Build_new_Turtle()
    --Send Command to Hephaestus(Turtle Constructor)
end

function Check_Active_Turtles() 
    --Check wie viele Turtles gerade Aktiv sind
    --Evtl evaluieren ob weitere gestarten werden sollen
end


--Drone_Iteration = Read_Drone_Iteration()
--Slave_List = Read_Slave_List()


--print("waiting for msg")
--local id, message = rednet.receive()
--if (message) then
--    if (message.Projekt == "Demeter") then
--        Slave_List[id] = message
--        local awnser = {}
--        awnser[#awnser] = #Slave_List
--        rednet.send(id, awnser)      
--    end
--end

