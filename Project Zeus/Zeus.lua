Screen = {
    '                                                   ',
    '                                                   ',
    '---------------------------------------------------',
    '                                                   ',
    '          ######   ######  #     #   ######        ',
    '              ##  ##       #     #  ##             ',
    '             ##   #        #     #  ##             ',
    '            ##    #####    #     #   #####         ',
    '           ##     #        #     #       ##        ',
    '          ##      ##       ##   ##       ##        ',
    '          ######   ######   #####    #####         ',
    '                                                   ',
    '---------------------------------------------------',
    '                +                                  ',
    '---------------------------------------------------',
    '                                                   ',
    '                        /                          ',
    '                        /                          ',
    '                        /                          ',
    '                                                   ',
}

os.setComputerLabel("Zeus")


function Show_FuelScreen()
    term.clear()
    term.setBackgroundColor(colors.black)
    for y_offset, line in pairs(Screen) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.brown)
            elseif char == '+' then
                term.write("Upholder of Order")
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

Show_FuelScreen()

