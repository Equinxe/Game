function saveExists(fileNumber)
    local fileName
    if fileNumber == 1 then
     fileName = "file1.lua"
    elseif fileNumber == 2 then 
     fileName = "file2.lua"
    elseif fileNumber == 3 then 
     fileName = "file3.lua"
    end
    
    return love.filesystem.getInfo(fileName) ~= nil 
 end
 
 function getSaveInfo(fileNumber)
     local fileName
     if fileNumber == 1 then 
         fileName = "file1.lua"
     elseif fileNumber == 2 then 
         fileName = "file2.lua"
     elseif fileNumber == 3 then
         fileName = "file3.lua"
     end
 
     if love.filesystem.getInfo(fileName) ~= nil then 
         local savedData = love.filesystem.read(fileName)
         local saveData = stringToTable(savedData)
 
         return {
             exists = true,
             playtime = saveData.playtime or 0,
             steps = saveData.steps or 0,
             level = saveData.progress or 0,
             map = saveData.map or "Unknown",
             saveCount = saveData.saveCount or 0
         }
     else 
         return {
             exists = false
         }
     end
 end
     
     -- Fonction pour créer une nouvelle sauvegarde
 function createNewSave(fileNumber)
     data = {}
     data.saveCount = 0
     data.progress = 0
     data.playerX = 0
     data.playerY = 0
     data.maxHealth = 4
     data.money = 0
     data.keys = 0
     data.map = ""
     data.playtime = 0 
     data.steps = 0 
     data.storyProgress = 0 
 
     if fileNumber == nil then fileNumber = 1 end
     data.fileNumber = fileNumber
 
     data.breakables = {}
     data.chests = {}
 end
 
 -- Fonction pour sauvegarder les données
 function saveGame()
     data.saveCount = data.saveCount + 1
     data.playerX = player:getX()
     data.playerY = player:getY()
     data.map = loadedMap
 
     local serializedData = tableToString(data)
 
     if data.fileNumber == 1 then
         love.filesystem.write("file1.lua", serializedData)
     elseif data.fileNumber == 2 then
         love.filesystem.write("file2.lua", serializedData)
     elseif data.fileNumber == 3 then
         love.filesystem.write("file3.lua", serializedData)
     end
 end
 
 -- Fonction pour charger une sauvegarde
 function loadGame(fileNumber)
     local fileName
     if fileNumber == 1 then
         fileName = "file1.lua"
     elseif fileNumber == 2 then
         fileName = "file2.lua"
     elseif fileNumber == 3 then
         fileName = "file3.lua"
     end
 
     if love.filesystem.getInfo(fileName) ~= nil then
         local savedData = love.filesystem.read(fileName)
         data = stringToTable(savedData)
     else
         return false
     end
 
     player.direction = "down"
 end
 
 -- Fonction pour réinitialiser la sauvegarde en cas de nouvelle partie
 function startFresh(fileNumber)
     createNewSave(fileNumber)
     data.map = "Test01"
     data.playerX = 329
     data.playerY = 239
     player.state = 0
     saveGame()
 end
 
 --Playtime
 function updatePlaytime(dt)
     if gamestate == 1 and data and data.playtime then
         data.playtime = data.playtime + dt 
     end
 end
 
 --time format
 function formatPlaytime(seconds)
     local hours = math.floor(seconds/3600)
     local minutes = math.floor((seconds % 3600) / 60)
     local secs = math.floor(seconds % 60)
 
     return string.format("%02d:%02d:%02d" , hours, minutes, secs)
 end
 
 --increase steps
 function incrementSteps()
     if data and data.steps then
         data.steps = data.steps + 1 
     end
 end