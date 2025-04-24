function updateAll(dt)
    menu:update(dt)

    if menuSave then 
        menuSave:update(dt)
    end
    
    updateGame(dt)

    if gameMap then 
        gameMap:update(dt)
    end

    updatePlaytime(dt)
    checkWindowSize()
end 


function updateGame(dt)
    miscUpdate(dt)
    if globalStun > 0 then return end 

    flux.update(dt)

    player:update(dt)
    world:update(dt)
    walls:update(dt)
    waters:update(dt)

    cam:update(dt)

    checkAutoSave(dt)
end


local autoSaveTimer = 0 
local autoSaveInterval = 300 

function checkAutoSave(dt)
    if gamestate == 1 then
        autoSaveTimer = autoSaveTimer + dt
        if autoSaveTimer >= autoSaveInterval then
            autoSaveTimer = 0 
            saveGame()
        end
    end
end
