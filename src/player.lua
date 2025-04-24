 -- Player movement-----
 player = world:newBSGRectangleCollider(234, 184, 12, 12, 3)
 player.x = 0
 player.y = 0
 player.dir = "down"
 player.dirX = 1
 player.dirY = 1
 player.prevDirX = 1
 player.prevDirY = 1
 player.scaleX = 1
 player.speed = 90
 player.animSpeed = 0.14
 player.walking = false
 player.animTimer = 0
 player.health = 4
 player.stunTimer = 0
 player.damagedTimer = 0
 player.damagedBool = 1
 player.damagedFlashTime = 0.05
 player.invincible = 0 -- timer
 player.bowRecoveryTime = 0.25
 --player.holdSprite = sprites.items.heart
 player.attackDir = vector(1, 0)
 player.comboCount = 0
 player.aiming = false
 player.arrowOffX = 0
 player.arrowOffY = 0
 player.bowVec = vector(1, 0)
 player.baseDamping = 12
 player.dustTimer = 0
 player.rollDelayTimer = 0
 player.rotateMargin = 0.25
 player.state = 0 

    player:setCollisionClass("Player")
    player:setFixedRotation(true)
    player:setLinearDamping(player.baseDamping)


    player.grid = anim8.newGrid(19, 21, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), player.animSpeed)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 2), player.animSpeed)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 3), player.animSpeed)
    player.animations.left = anim8.newAnimation(player.grid('1-4',4), player.animSpeed)

    player.anim = player.animations.down

    --player.buffer = {}

 function player:update(dt)
    if player.state == -1 then return end 

    player.prevDirX = player.dirX
    player.prevDirY = player.dirY

    local dirX = 0 
    local dirY = 0
    local wasWalking = player.walking

    if love.keyboard.isDown("z") or love.keyboard.isDown("up") then
        dirY = -1
        player.dirY = -1
    end

    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dirX = 1
        player.dirX = 1
    end
    
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dirY = 1
        player.dirY = 1
    end

    if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
        dirX = -1
        player.dirX = -1
    end
    

    if dirY == 0  and dirX ~= 0 then
        player.dirY = 1
    end

   if dirX == 0 and dirY == 0 then
        if player.walking then
            player.walking = false
            -- player:justStop()
        end
    else
        player.walking = true
    end
    
    
    if player.walking and not wasWalking and gamestate == 1 then
        incrementSteps()
    end
    
    
    if player.walking then
        if player.dirX == 1 then
            if player.dirY == 1 then
                player.anim = player.animations.right
            else
                player.anim = player.animations.up
            end
        else
            if player.dirY == 1 then
                player.anim = player.animations.left
            else
                player.anim = player.animations.down
            end
        end
    end
    

    local vec = vector(dirX, dirY):normalized() * player.speed
    if vec.x ~= 0 or vec.y ~= 0 then
        player:setLinearVelocity(vec.x, vec.y)
    end
   -- if dirX == 0 and dirY == 0 then
       -- if player.walking then
          --  player.walking = false
           -- player:justStop()
       -- end
   -- else player.walking = true
    --end 

    player.anim:update(dt)

    --player:processBuffer(dt)
end

function player:draw()

    if player.stunTimer > 0 then
        love.graphics.setColor(223/255, 106/255, 106/255, 1)
    elseif player.damagedTimer > 0 then
        local alpha = 0.8
        if player.damagedBool < 0 then 
            alpha =  0.55
        end
        love.graphics.setColor(1,1,1,alpha)
    else
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.draw(sprites.playerShadow, player:getX(), player:getY()+5, nil ,nil, nil , sprites.playerShadow:getWidth()/2, sprites.playerShadow:getHeight()/2)

    player.anim:draw(sprites.playerSheet, player:getX(), player:getY()-2, nil, player.dirX, 1, 9.5, 10.5)
end