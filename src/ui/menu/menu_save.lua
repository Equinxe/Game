menuSave = {}
menuSave.selection = 1
menuSave.activeMenu = "new_game"
menuSave.options = {
    new_game = {"File 1", "File 2", "File 3", "Back"},
    continue = {"File 1", "File 2", "File 3", "Back"}
}

menuSave.buttonPositions = {
    new_game = {
        {x = window_Width * 0.50, y = window_Height * 0.32, width = 400, height = 40},
        {x = window_Width * 0.42, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.58, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.50, y = window_Height * 0.78, width = 400, height = 40}
    },
    continue = {
        {x = window_Width * 0.85, y = window_Height * 0.35, width = 400, height = 40},
        {x = window_Width * 0.85, y = window_Height * 0.45, width = 400, height = 40},
        {x = window_Width * 0.85, y = window_Height * 0.55, width = 400, height = 40},
        {x = window_Width * 0.85, y = window_Height * 0.65, width = 400, height = 40}
    }
}

function menuSave:load()
    menuSave.background = love.graphics.newImage('sprites/ui/Save-no-text.png')
    menuSave.pulseTimer = 0 

end

function menuSave:update(dt)
    if gamestate == 0 then 
        menuSave.pulseTimer = menuSave.pulseTimer + dt * 3 
    end
end

function menuSave:draw()

    love.graphics.setColor(1,1,1,1)
    
    local bgW = menuSave.background:getWidth()
    local bgH = menuSave.background:getHeight()
    local scaleX = window_Width / bgW
    local scaleY = window_Height / bgH
    local bgScale = math.min(scaleX,scaleY) * 0.9 

    love.graphics.draw(menuSave.background, window_Width / 2, window_Height / 2, 0, bgScale, bgScale, bgW / 2, bgH / 2)

    if not menuSave.options[menuSave.activeMenu] then
        return
    end

    love.graphics.setFont(fonts.title)
    love.graphics.setColor(1,1,1,1)

    local title = string.upper(menuSave.activeMenu)
    love.graphics.printf(title, 0, window_Height * 0.1, window_Width, "center")


    love.graphics.setFont(fonts.menu)
    for i, option in ipairs(menuSave.options[menuSave.activeMenu]) do
        local r, g, b, a = 0.8, 0.8, 0.8, 1
        if i == menuSave.selection then
            local pulse = 0.3 + 0.7 * math.abs(math.sin(menuSave.pulseTimer))
            r, g, b = 1 * pulse, 0.9 * pulse, 0.5 * pulse
        end

        love.graphics.setColor(r, g, b, a)
        local pos = menuSave.buttonPositions[menuSave.activeMenu][i]
        love.graphics.printf(option, pos.x - pos.width / 2, pos.y - pos.height / 2, pos.width, "center")
    end
end

function menuSave:select(key)
    if gamestate ~= 0 then return end

    if key == "up" or key == "z" then
        menuSave.selection = menuSave.selection - 1
        if menuSave.selection < 1 then menuSave.selection = #menuSave.options[menuSave.activeMenu] end
    elseif key == "s" or key == "down" then
        menuSave.selection = menuSave.selection + 1
        if menuSave.selection > #menuSave.options[menuSave.activeMenu] then menuSave.selection = 1 end
    elseif key == "return" or key == "space" then
        print("selection:" .. menuSave.selection)
        self:executeSelection()
    end
end

function menuSave:executeSelection()
    if menuSave.selection == 4 then
        gamestate = 0 
        menu.activeMenu = "main"
        menuSave.selection = 1
    else 
        if menuSave.activeMenu == "new_game" then
            startFresh(menuSave.selection)
        elseif menuSave.activeMenu == "continue" then
            loadGame(menuSave.selection)
        end
        gamestate = 1

        if data and data.map then
            loadMap(data.map)
        end
    end
end

function menuSave:mousepressed(x,y,button)
    if gamestate ~= 0 or button ~= 1 then return end

    for i,pos in ipairs(menuSave.buttonPositions[menuSave.activeMenu]) do
        if x >= pos.x - pos.width / 2 and x <= pos.x + pos.width / 2 and 
        y >= pos.y - pos.height / 2 and y <= pos.y + pos.height / 2 then
            menuSave.selection = i 
            self:executeSelection()
            return
        end
    end
end


menuSave:load()