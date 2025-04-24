menuSave = {}
menuSave.selection = 1
menuSave.activeMenu = "new_game"
menuSave.confirmMode = false
menuSave.confirmSelection = 1 
menu.selectedFile = nil 


menuSave.options = {
    new_game = {"File 1", "File 2", "File 3", "Back"},
    continue = {"File 1", "File 2", "File 3", "Back"},
    confirm = {"Yes", "No"}
}

menuSave.saveInfo = {
    {exists = false},
    {exists = false},
    {exists = false}
}

menuSave.buttonPositions = {
    new_game = {
        {x = window_Width * 0.50, y = window_Height * 0.32, width = 400, height = 40},
        {x = window_Width * 0.42, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.58, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.50, y = window_Height * 0.78, width = 400, height = 40}
    },
    continue = {
        {x = window_Width * 0.50, y = window_Height * 0.32, width = 400, height = 40},
        {x = window_Width * 0.42, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.58, y = window_Height * 0.57, width = 400, height = 40},
        {x = window_Width * 0.50, y = window_Height * 0.78, width = 400, height = 40}
    },
    confirm = {
        {x = window_Width * 0.45, y = window_Height * 0.50, width = 100 , height = 40},
        {x = window_Width * 0.45, y = window_Height * 0.50, width = 100 , height = 40}
    }
}

function menuSave:load()
    menuSave.background = love.graphics.newImage('sprites/ui/Save-no-text.png')
    menuSave.pulseTimer = 0 
    menuSave:refreshSaveInfo()
end


function menuSave:refreshSaveInfo()
    for i= 1 , 3 do 
        menuSave.saveInfo[i] = getSaveInfo(i)
    end
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

    love.graphics.setFont(fonts.title)
    love.graphics.setColor(1,1,1,1)

    local title = string.upper(menuSave.activeMenu)
    love.graphics.printf(title, 0, window_Height * 0.05, window_Width, "center")

    if menuSave.confirmMode then 
        love.graphics.setFont(fonts.menu)
        love.graphics.setColor(1,1,1,1)

        local message = "This save already exists. Overwrite ?"
        love.graphics.printf(message, 0 , window_Height * 0.40, window_Width, "center")


        for i, option in ipairs(menuSave.options.confirm) do
            local r, g, b, a = 0.8, 0.8, 0.8, 1
            if i == menuSave.confirmSelection then
                local pulse = 0.3 + 0.7 * math.abs(math.sin(menuSave.pulseTimer))
                r, g, b = 1 * pulse, 0.9 * pulse, 0.5 * pulse
            end

            love.graphics.setColor(r, g, b, a)
            local pos = menuSave.buttonPositions.confirm[i]
            love.graphics.printf(option, pos.x - pos.width / 2, pos.y - pos.height / 2, pos.width, "center")
        end
        return
    end

    if not menuSave.options[menuSave.activeMenu] then 
        return
    end

    love.graphics.setFont(fonts.menu)
    for i, option in ipairs(menuSave.options[menuSave.activeMenu]) do 
        local r,g,b,a = 0.8, 0.8, 0.8, 1

        if i == menuSave.selection then
            local pulse = 0.3 + 0.7 * math.abs(math.sin(menuSave.pulseTimer))
            r,g,b = 1 * pulse, 0.9 * pulse , 0.5 * pulse
        end

        love.graphics.setColor(r, g, b, a)
        local pos = menuSave.buttonPositions[menuSave.activeMenu][i]

        --Name
        local displayText = option 
        if i < 4 then 
            if menuSave.saveInfo[i].exists then 
                displayText = option
            else
                displayText = option .. " (No Data)"
            end
        end

        love.graphics.printf(displayText, pos.x - pos.width / 2, pos.y - pos.height / 2, pos.width, "center")


        if i < 4 and menuSave.saveInfo[i].exists then
            love.graphics.setFont(fonts.small)
            love.graphics.setColor(0.9,0.9,0.9,0.8)

            local info = menuSave.saveInfo[i]
            local infoText = string.format("Map: %s - Time: %s", info.map or "Unknown", formatPlaytime(info.playtime or 0))

            love.graphics.printf(infoText, pos.x - pos.width / 2, pos.y + 15, pos.width, "center")
        end
    end
end




function menuSave:select(key)
    if gamestate ~= 0 then return end

    if menuSave.confirmMode then
        if key == "left" or key == "q" then
            menuSave.confirmSelection = 1 --yes
        elseif key == "right" or key == "d" then
            menuSave.confirmSelection = 2 -- no 
        elseif key == "return" or key == "space" then 
            if menuSave.confirmSelection == 1 then 
                startFresh(menuSave.selectedFile)
                gamestate = 1 
                if data and data.map then
                    loadMap(data.map)
                end
            else
                menuSave.confirmMode = false
                menuSave.selectedFile = nil 
            end
        end
        return
    end
    
    if key == "up" or key == "z" then
        menuSave.selection = menuSave.selection - 1
        if menuSave.selection < 1 then menuSave.selection = #menuSave.options[menuSave.activeMenu] end
        elseif key == "s" or key == "down" then
            menuSave.selection = menuSave.selection + 1
            if menuSave.selection > #menuSave.options[menuSave.activeMenu] then menuSave.selection = 1 end
        elseif key == "return" or key == "space" then
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
            if menuSave.saveInfo[menuSave.selection].exists then
                menuSave.confirmMode = true
                menuSave.confirmSelection = 2 
                menuSave.selectedFile = menuSave.selection
            else
                startFresh(menuSave.selection)
                gamestate = 1
                if data and data.map then
                    loadMap(data.map)
                end
            end
        elseif menuSave.activeMenu == "continue" then 
            if menuSave.saveInfo[menuSave.selection].exists then
                if loadGame(menuSave.selection) then 
                    gamestate = 1 
                    if data and data.map then 
                        loadMap(data.map)
                        player:setPosition(data.playerX,data.playerY)
                    end
                end
            else
                --
            end
        end
    end
end

function menuSave:mousepressed(x,y,button)
    if gamestate ~= 0 or button ~= 1 then return end

    if menuSave.confirmMode then
        for i,pos in ipairs(menuSave.buttonPositions.confirm) do
            if x >= pos.x - pos.width / 2 and x <= pos.x + pos.width / 2 and 
            y >= pos.y - pos.height / 2 and y <= pos.y + pos.height / 2 then
                menuSave.confirmSelection = i

                if i == 1 then 
                    startFresh(menuSave.selectedFile)
                    gamestate = 1
                    if data and data.map then 
                        loadMap(data.map)
                    end
                else 
                    menuSave.confirmMode = false
                    menuSave.selectedFile = nil 
                end

                return
            end
        end
        return
    end

    for i, pos in ipairs(menuSave.buttonPositions[menuSave.activeMenu]) do
        if x >= pos.x - pos.width / 2 and x <= pos.x + pos.width / 2 and 
        y >= pos.y - pos.height / 2 and y <= pos.y + pos.height / 2 then
         menuSave.selection = i
         if i == 4 or (menuSave.activeMenu == "continue") then
            self:executeSelection()
         else
            self:executeSelection()
         end
         return
        end
    end
end
menuSave:load()