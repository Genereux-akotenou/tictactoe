-- -------------------------------------------------------------------- --
-- Author   : Généreux AKOTENOU                                         --
-- from     : Bénin - IFRI                                              --
-- github   : https://github.com/Genereux-akotenou                      --
-- linkedin : https://www.linkedin.com/in/généreux-akotenou-8b00901b4/  --
-- -------------------------------------------------------------------- --
local core = {}
local game = {}
local wait = {}
local data = {}
local free = {}
local network = {}
local winnerManche
local difficulte = -1
local findingNetworkPlayer = false
local playOnce = false
local timeToPlay = -3
local hauteurBlock = 10
local timeToAnim = 0

function love.load()
    --def game icon
    love.window.setIcon(love.image.newImageData("icon.png"))

    --on each loading increase game level
    difficulte = difficulte + 1

    -- library
    Object  = require "modules/classic"
    tick    = require "modules/tick"
    lume    = require "modules/lume"
    require "class/pion"
    require "functions/functions"
    require "functions/win"
    require "ia/core/ia-basic"
    require "ia/core/ia-level1"
    require "ia/core/ia-level2"
    local showRulesBox = false


    -- global
    allboard = {}
    for redfox = 2, 4 do
        table.insert(allboard, love.graphics.newImage("assets/sprites/board" .. redfox ..".png"))
    end
    boardImg    = allboard[love.math.random(#allboard)]

    iaPionsChoice = love.math.random(2)
    pionSmalImgA= love.graphics.newImage("assets/sprites/pion" .. iaPionsChoice .. ".png")
    pionImgA    = love.graphics.newImage("assets/sprites/pion" .. iaPionsChoice .. "-normal.png")
    pionScalImgA= love.graphics.newImage("assets/sprites/pion" .. iaPionsChoice .. "-2x-scale.png")

    playerPionsChoice = love.math.random(3,4)
    pionSmalImgB= love.graphics.newImage("assets/sprites/pion" .. playerPionsChoice .. ".png")
    pionImgB    = love.graphics.newImage("assets/sprites/pion" .. playerPionsChoice .. "-normal.png")
    pionScalImgB= love.graphics.newImage("assets/sprites/pion" .. playerPionsChoice .. "-2x-scale.png")

    if not playOnce then
        windowWidth = love.graphics.getWidth()
        windowHeight = love.graphics.getHeight()
        mouse1Img   = love.graphics.newImage("assets/sprites/cursor-pointer1.png")
        mouse2Img   = love.graphics.newImage("assets/sprites/cursor-hand1.png")
        play1Img    = love.graphics.newImage("assets/sprites/play.png")
        play2Img    = love.graphics.newImage("assets/sprites/play-2x-scale.png")
        playImg    = love.graphics.newImage("assets/sprites/play-short.png")
        pauseImg    = love.graphics.newImage("assets/sprites/pause-short.png")
        sound1Img   = love.graphics.newImage("assets/sprites/sound-yes1.png")
        sound2Img   = love.graphics.newImage("assets/sprites/sound-no1.png")
        hintImg     = love.graphics.newImage("assets/sprites/hint.png")
        iconImg     = love.graphics.newImage("assets/sprites/board-mini.png")
        likeImg     = love.graphics.newImage("assets/sprites/love.png")
        titleImg    = love.graphics.newImage("assets/sprites/titre.png")
        
        music1      = love.audio.newSource("assets/audio/zuma.mp3", "stream")
        playSound   = love.audio.newSource("assets/audio/wing.wav", "static")
        homeSound   = love.audio.newSource("assets/audio/swoosh.wav", "static")
        pionSound   = love.audio.newSource("assets/audio/movePion.mp3", "static")

        playerImgA  = love.graphics.newImage("assets/sprites/playerA.png")
        playerImgB  = love.graphics.newImage("assets/sprites/playerB.png")
        homeImg     = love.graphics.newImage("assets/sprites/home.png")

        goImg       = love.graphics.newImage("assets/sprites/go.png")
        faillImg    = love.graphics.newImage("assets/sprites/gameover.png")
        WinnnImg    = love.graphics.newImage("assets/sprites/gamewon.png")
        NulllImg    = love.graphics.newImage("assets/sprites/gamenull.png")
        restartImg  = love.graphics.newImage("assets/sprites/restart.png")
        quitImg     = love.graphics.newImage("assets/sprites/quit.png")
        continueImg = love.graphics.newImage("assets/sprites/continue.png")
        muteImg     = love.graphics.newImage("assets/sprites/mute.png")
        restart2Img = love.graphics.newImage("assets/sprites/restart-2x-scale.png")
        quit2Img    = love.graphics.newImage("assets/sprites/quit-2x-scale.png")
        continue2Img= love.graphics.newImage("assets/sprites/continue-2x-scale.png")
        mute2Img    = love.graphics.newImage("assets/sprites/mute-2x-scale.png")
        unmuteImg   = love.graphics.newImage("assets/sprites/unmute.png")
        unmute2Img  = love.graphics.newImage("assets/sprites/unmute-2x-scale.png")
        sound1ScalImg=love.graphics.newImage("assets/sprites/sound-yes1-2x-scale.png")
        sound2ScalImg=love.graphics.newImage("assets/sprites/sound-no1-2x-scale.png")
        networkImg   = love.graphics.newImage("assets/sprites/network.png")
        yesImg       = love.graphics.newImage("assets/sprites/yes.png")
        noImg        = love.graphics.newImage("assets/sprites/no.png")
        yesScaleImg       = love.graphics.newImage("assets/sprites/yes-2x-scale.png")
        noScaleImg        = love.graphics.newImage("assets/sprites/no-2x-scale.png")
        rulesImg        = love.graphics.newImage("assets/sprites/rules.png")

        wifiImgTab  = {}
        for i=1,8 do
            table.insert(wifiImgTab, love.graphics.newImage("assets/sprites/wifi-anim" .. i-1 .. ".png"))
        end

        scoreImgTab = {}
        for i=1,10 do
            table.insert(scoreImgTab, love.graphics.newImage("assets/sprites/" .. i-1 .. ".png"))
        end
    end

    -- data
    data["playState"] = "stoped" -- stoped play pause finished
    data["pionsEatenA_position"] = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}}
    data["pionsEatenB_position"] = {{0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}}
    data["pionsEatenA_position"]["leftPos"] = windowWidth / 2 - 110
    data["pionsEatenB_position"]["leftPos"] = windowWidth / 2 - 220
    data["begin"] = {false, false}
    data["score"] = {0, 0}
    data["clock"] = 0
    data["board"] = {}
    data["canPlay"] = true
    data["nbrCoups"] = {12, 12}

    -- conf
    love.mouse.setVisible(false)
    
    -- core
    core["previewBoard"] = iconImg
    core["gameYoyo"] = likeImg
    core["gameTitle"] = titleImg
    core["playButton"] = {}
    core["playButton"]["img"] = play1Img
    core["playButton"]["x"] = windowWidth / 2 - core.playButton.img:getWidth()/2
    core["playButton"]["y"] = windowHeight * 2/3 + 90
    core["music"] = playSound
    core["music"]:setVolume(5)
    core["music1"] = homeSound
    core["music1"]:setVolume(5)
    core["music2"] = pionSound
    core["music2"]:setVolume(5)
    core["continueButton"] = {}
    core["continueButton"]["img"] = continueImg
    core["continueButton"]["x"] = windowWidth / 2 - core.continueButton.img:getWidth()/2
    core["continueButton"]["y"] = windowHeight * 2/3 - 70
    core["restartButton"] = {}
    core["restartButton"]["img"] = restartImg
    core["restartButton"]["x"] = windowWidth / 2 - core.restartButton.img:getWidth()/2 - 170
    core["restartButton"]["y"] = windowHeight * 2/3 - 10
    core["quitButton"] = {}
    core["quitButton"]["img"] = quitImg
    core["quitButton"]["x"] = windowWidth / 2 - core.quitButton.img:getWidth()/2 + 170
    core["quitButton"]["y"] = windowHeight * 2/3 - 10
    core["muteButton"] = {}
    core["muteButton"]["img"] = muteImg
    core["muteButton"]["x"] = windowWidth / 2 - core.muteButton.img:getWidth()/2
    core["muteButton"]["y"] = windowHeight * 2/3 + 50

    -- game
    game["SoundIcon"] = {}
    game["SoundIcon"]["img"] = sound1Img
    game["SoundIcon"]["x"] = windowWidth - game.SoundIcon.img:getWidth() - 10
    game["SoundIcon"]["y"] = 10
    game["hintIcon"] = {}
    game["hintIcon"]["img"] = hintImg
    game["hintIcon"]["x"] = 2
    game["hintIcon"]["y"] = 10
    game["cursor"] = mouse1Img
    game["music"] = music1
    game["music"]:setLooping(true)
    game["music"]:setVolume(5) -- 5
    game["board"] = {}
    game["board"]["img"] = boardImg
    game["board"]["x"] = windowWidth/2 - game.board.img:getWidth()/2
    game["board"]["y"] = windowHeight/2 - game.board.img:getHeight()/2
    game["playerA"] = {}
    game["playerA"]["img"] = playerImgA
    game["playerA"]["name"] = "player A"
    game["playerA"]["x"] = data.pionsEatenA_position.leftPos - 30
    game["playerA"]["y"] = 5
    game["playerB"] = {}
    game["playerB"]["img"] = playerImgB
    game["playerB"]["name"] = "player B"
    game["playerB"]["x"] = data.pionsEatenB_position.leftPos + 320
    game["playerB"]["y"] = 5
    game["playButton"] = {}
    game["playButton"]["img"] = pauseImg
    game["playButton"]["x"] = windowWidth - game.playButton.img:getWidth() - 10
    game["playButton"]["y"] = 75    
    game["home"] = {}
    game["home"]["img"] = homeImg
    game["home"]["x"] = windowWidth - game.playButton.img:getWidth() - 10
    game["home"]["y"] = 135
    game["cellules"] = {}
    game["smallPions"] = {}
    game["wifi"] = {}
    game["wifi"]["img"] = wifiImgTab[1]
    game["wifi"]["x"] = windowWidth - game.wifi.img:getWidth() - 10
    game["wifi"]["y"] = 200
    game["wifi"]["currentFrame"] = 1

    --network
    network["exitButton"] = {}
    network["exitButton"]["img"] = noImg
    network["exitButton"]["x"] = windowWidth/2-noImg:getWidth()/2 - noImg:getWidth()/2 - 50
    network["exitButton"]["y"] = windowHeight-noImg:getWidth()-60
    network["playButton"] = {}
    network["playButton"]["img"] = yesImg
    network["playButton"]["x"] = windowWidth/2-yesImg:getWidth()/2 + yesImg:getWidth()/2 + 50
    network["playButton"]["y"] = windowHeight-yesImg:getWidth()-60

    --end
    onListening = {core.playButton, game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}
    data["board"]["width"] = game.board.img:getWidth()
    data["board"]["height"] = game.board.img:getHeight()
    data["board"]["x"] = game.board.x
    data["board"]["y"] = game.board.y
    data["board"]["state"] = {
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0}
    }
    data["board"]["allPions"] = {}
    for i = 0, 4 do
        for j = 0, 4 do
            cell = {}
            cell.x = data.board.x + j * data.board.width/5
            cell.y = data.board.y + i * data.board.height/5
            cell.width = data.board.width/5
            cell.height = data.board.height/5
            table.insert(game.cellules, cell)
            --print(cell.width .. " -- " .. cell.height)
            -- if modify check update pion:draw() in pion.lua
        end 
    end   
    game.initPions()
    free["stopSound"] = false
    free["iaCanPlay"] = false

    -- ia loading
    if difficulte == 0 then
        ia = Ia("playerA", data.board.state, data.playState, {false, data.canPlay}, data.score)
    elseif difficulte == 1 then
        ia = Ia1("playerA", data.board.state, data.playState, {false, data.canPlay}, data.score)
    elseif difficulte == 2 then
        ia = Ia1("playerA", data.board.state, data.playState, {false, data.canPlay}, data.score)
    elseif difficulte == 3 then
        ia = Ia2("playerA", data.board.state, data.playState, {false, data.canPlay}, data.score)
    end
end

function love.update(dt)
    --print(os.time())
    -- every responsable man have to have time
    timeToAnim = timeToAnim + dt
    if data.playState == "play" then
        timeToPlay = timeToPlay + dt
        --print("game time =" .. timeToPlay)
        min = math.floor(timeToPlay/60)
        sec = math.floor((timeToPlay/60-min)*60)
        if min == 0 then
            data["clock"] =  sec .. " s"
        else
            data["clock"] =  min .. ":" .. sec .. "s"
        end
    end

    if showRulesBox and math.floor(timeToAnim) % 29 % 8 == 0 then
        showRulesBox = false
    end

    tick.update(dt)
    
    if not playOnce then
        print("START PLAYING BACKGROUND MUSIC")
        game["music"]:play()
        playOnce = true
    end

    game.wifi.currentFrame = game.wifi.currentFrame + dt
    if game.wifi.currentFrame >= 9 then
        game["wifi"]["currentFrame"] = 1
    end

    winnerManche = whoHasWon(data.board.state)
    if winnerManche.status == true then
        data.playState = "finished"
    end
    if winnerManche.status == false and data.nbrCoups[1] == 0 then
        data.playState = "finished"
    end

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()
    mouseX, mouseY = love.mouse.getPosition()
    
    if data.playState == "stoped" then
        core.animPlayButton()
        game.animHintButton()
    elseif data.playState == "pause" or data.playState == "finished" then
        wait.captureMouse()
        wait.activatePlayButton()
        core.animContinueButton()
        core.animRestartButton()
        core.animQuitButton()
        core.animMuteButton()
        network.animExitButton()
        network.animPlayButton()
        
    elseif data.playState == "play" or data.playState == "finished" then
        tick.delay( function() data["begin"][1] = true end, 2)
        tick.delay( function() data["begin"][2] = true end, 3)
        
        if not free.iaCanPlay and not data.canPlay then
            tick.delay( function() free["iaCanPlay"] = true end, 1)
        end 
        
        if data.canPlay then
            data.showPion()
        end 

        --ia:update(dt, data.board.state)
        ia:updateBoard(data.board.state)
        data.canPlay = ia:getCanPlay()[2]
    end

    -- if data.playState == "play" then
    --     findingNetworkPlayer = false
    -- end

    ia:setGameSate(data.playState)
    ia:updateScore(data.score)
    game.animSoundButton()
    game.animCursor(onListening)
    --print(ia:getEnemyPions(0)[2][1] .. " -- " .. ia:getEnemyPions(0)[2][2])
end

function love.draw()
    core.drawSceneBase()
    
    if data.playState == "stoped" then
        core.drawSceneMenu()
    end

    if data.playState == "play" or data.playState == "pause" or data.playState == "finished" then
        game.drawGameBoard()
        data.drawPionOnBoard()

        if data.playState == "pause" then
            wait.drawPauseScene()
        end

        if data.playState == "finished" then
            wait.drawPauseScene()
        end

        ia:draw()
    end
    
    if data.playState == "play" then
        love.graphics.print("Press \"f1\" to save game", 5,  windowHeight - 20)
    end
    core.animHintButton()
    game.drawCursor()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        game.clickSoundButton()
        
        if data.playState == "stoped" then
            core.clickPlayButton()
        elseif data.playState == "play" then
            game.clickHome()
            game.clickWifi()
            if data.begin[1] == true and data.begin[2] == true then
                data.clickPlay("playerB")
            end
        elseif data.playState == "pause" or data.playState == "finished" then
            wait.clickContinueButton()
            core.clickContinueButton()
            core.clickRestartButton()
            core.clickQuitButton()
            core.clickMuteButton()
            network.clickExitButton()
            network.clickPlayButton()
        end

        game.clickPlayButton()
        core.clickHintButton()
    end
end

function love.keypressed(key)
    if key == "f1" then
        saveGame()
    end
end

function saveGame()
    -- serialized = lume.serialize(game.board.state)
    -- print(serialized)
    -- love.filesystem.write("save/boardState.txt", serialized)
end
----------------------------------------core functions----------------------------------------
function core.drawSceneBase()
    love.graphics.setColor(0.44, 0.145, 0.192, 1)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(game.hintIcon.img, game.hintIcon.x, game.hintIcon.y)
    love.graphics.draw(game.SoundIcon.img, game.SoundIcon.x, game.SoundIcon.y)
end

function core.drawSceneMenu()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(core.gameYoyo, windowWidth/2 + core.gameTitle:getWidth()/2 - 100, windowHeight/4 - 80)
    love.graphics.draw(core.gameTitle, windowWidth/2 - core.gameTitle:getWidth()/2, windowHeight* 1/3 - 75)
    love.graphics.draw(core.previewBoard, windowWidth/2 - core.previewBoard:getWidth()/2,  windowHeight/2 - core.previewBoard:getHeight()/2 + 60)
    love.graphics.draw(core.playButton.img, core.playButton.x, core.playButton.y)
    -- game.drawGameBoard()
end

-- hint -->
function core.clickHintButton()
    if hover(game.hintIcon , mouseX, mouseY) then
        showRulesBox = true
    end
end

function core.animHintButton()
    if showRulesBox then
        -- love.graphics.setColor(0, 0, 0, 0.7)
        -- love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
        
        love.graphics.setColor(0.61, 0.107, 0.113, 1)
        love.graphics.rectangle("fill", 65, 8, windowWidth - 145, 110, 20, 20)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setLineWidth(10)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", 60, 13, windowWidth - 135, 110, 20, 20)
        love.graphics.draw(rulesImg, windowWidth/2-rulesImg:getWidth()/2, -4)
        love.graphics.print("Pour gagner a tic-tac-toe vous devez aligner 5 de vos pions", 170, 48, 0, 1.3, 1.3)
        love.graphics.print("sur la vertical ou sur l'horizontal ou a l'oblique", 215, 70, 0, 1.3, 1.3)
        love.graphics.print("Good luck", 350, 92, 0, 1.4, 1.4)
    end
end


-- play -->
function core.animPlayButton()
    if hover(core.playButton, mouseX, mouseY) then
        core["playButton"]["img"] = play2Img
        core["playButton"]["x"] = love.graphics.getWidth()/2 - core.playButton.img:getWidth()/2
        core["playButton"]["y"] = love.graphics.getHeight() * 2/3 + 90
    else
        core["playButton"]["img"] = play1Img
        core["playButton"]["x"] = love.graphics.getWidth()/2 - core.playButton.img:getWidth()/2
        core["playButton"]["y"] = love.graphics.getHeight() * 2/3 + 90
    end
end

function core.clickPlayButton()
    if hover(core.playButton, mouseX, mouseY) then
        data["playState"] = "play"
        core.music:play()
        if onListening[1] == core.playButton then
            table.remove(onListening, 1)
            print("======= GAME STARTED   ========")
        end
    end
end

-- continue -->
function core.animContinueButton()
    if hover(core.continueButton, mouseX, mouseY) then
        core["continueButton"]["img"] = continue2Img
        core["continueButton"]["x"] = windowWidth / 2 - core.continueButton.img:getWidth()/2
        core["continueButton"]["y"] = windowHeight * 2/3 - 70
    else
        core["continueButton"]["img"] = continueImg
        core["continueButton"]["x"] = windowWidth / 2 - core.continueButton.img:getWidth()/2
        core["continueButton"]["y"] = windowHeight * 2/3 - 70
    end
end

function core.clickContinueButton()
    if hover(core.continueButton, mouseX, mouseY) and not findingNetworkPlayer then
        core.music1:play()
        data["playState"] = "play"
        if onListening[1] == core.continueButton then
            table.remove(onListening, 1)
            print("======= GAME CONTINUED ========")
        end
    end
end

-- restart -->
function core.animRestartButton()
    if hover(core.restartButton, mouseX, mouseY) then
        core["restartButton"]["img"] = restart2Img
        core["restartButton"]["x"] = windowWidth / 2 - core.restartButton.img:getWidth()/2 - 170
        core["restartButton"]["y"] = windowHeight * 2/3 - 10
    else
        core["restartButton"]["img"] = restartImg
        core["restartButton"]["x"] = windowWidth / 2 - core.restartButton.img:getWidth()/2 - 170
        core["restartButton"]["y"] = windowHeight * 2/3 - 10
    end
end

function core.clickRestartButton()
    if hover(core.restartButton, mouseX, mouseY) and not findingNetworkPlayer then
        -- love.load()
        -- data["playState"] = "play"
        love.event.quit("restart")
        core.music1:play()
        if onListening[1] == core.restartButton then
            table.remove(onListening, 1)
            print("======= GAME RESTARTED ========")
        end
    end
end

-- quit -->
function core.animQuitButton()
    if hover(core.quitButton, mouseX, mouseY) then
        core["quitButton"]["img"] = quit2Img
        core["quitButton"]["x"] = windowWidth / 2 - core.quitButton.img:getWidth()/2 + 170
        core["quitButton"]["y"] = windowHeight * 2/3 - 10
    else
        core["quitButton"]["img"] = quitImg
        core["quitButton"]["x"] = windowWidth / 2 - core.quitButton.img:getWidth()/2 + 170
        core["quitButton"]["y"] = windowHeight * 2/3 - 10
    end
end

function core.clickQuitButton()
    if hover(core.quitButton, mouseX, mouseY) and not findingNetworkPlayer then
        core.music1:play()
        love.event.quit(exitstatus)
        if onListening[1] == core.quitButton then
            table.remove(onListening, 1)
            print("======= GAME CLOSED ========")
        end
    end
end

-- mute -->
function core.animMuteButton()
    if hover(core.muteButton, mouseX, mouseY) then
        if game.music:getVolume() ~= 0 then
            core["muteButton"]["img"] = mute2Img
        else
            core["muteButton"]["img"] = unmute2Img
        end
        core["muteButton"]["x"] = windowWidth / 2 - core.muteButton.img:getWidth()/2
        core["muteButton"]["y"] = windowHeight * 2/3 + 50
    else
        if game.music:getVolume() ~= 0 then
            core["muteButton"]["img"] = muteImg
        else
            core["muteButton"]["img"] = unmuteImg
        end
        core["muteButton"]["x"] = windowWidth / 2 - core.muteButton.img:getWidth()/2
        core["muteButton"]["y"] = windowHeight * 2/3 + 50
    end
end

function core.clickMuteButton()
    if hover(core.muteButton, mouseX, mouseY) and not findingNetworkPlayer then
        if game.music:getVolume() ~= 0 then
            game["music"]:setVolume(0)
            game["SoundIcon"]["img"] = sound2Img
            game["SoundIcon"]["x"] = love.graphics.getWidth() - game.SoundIcon.img:getWidth() - 10
            game["SoundIcon"]["y"] = 10


            -- core["muteButton"]["img"] = unmuteImg
            -- mute2Img = play1Img
            -- print("okookokokok")
        else
            game["music"]:setVolume(5)
            game["SoundIcon"]["img"] = sound1Img
            game["SoundIcon"]["x"] = love.graphics.getWidth() - game.SoundIcon.img:getWidth() - 10
            game["SoundIcon"]["y"] = 10
        end
        
        core.music1:play()
        if onListening[1] == core.muteButton then
            table.remove(onListening, 1)
            print("======= SOUND MUTED ========")
        end
    end
end

----------------------------------------game functions----------------------------------------
function game.animSoundButton()
    game["SoundIcon"]["x"] = windowWidth - game.SoundIcon.img:getWidth() - 10
    game["SoundIcon"]["y"] = 10
    if hover(game.SoundIcon, mouseX, mouseY) then
        if game.music:getVolume() ~= 0 then
            game["SoundIcon"]["img"] = sound1ScalImg
        else
            game["SoundIcon"]["img"] = sound2ScalImg
        end
    else
        if game.music:getVolume() ~= 0 then
            game["SoundIcon"]["img"] = sound1Img
        else
            game["SoundIcon"]["img"] = sound2Img
        end
    end
    game["SoundIcon"]["x"] = windowWidth - game.SoundIcon.img:getWidth() - 10
    game["SoundIcon"]["y"] = 10
end

function game.animPlayButton()
    game["playButton"]["x"] = windowWidth - game.playButton.img:getWidth() - 15
    game["playButton"]["y"] = 75
end

function game.clickSoundButton()
    if hover(game.SoundIcon, mouseX, mouseY) then
        if game.music:getVolume() ~= 0 then
            game["SoundIcon"]["img"] = sound2Img
            game["SoundIcon"]["x"] = love.graphics.getWidth() - game.SoundIcon.img:getWidth() - 10
            game["SoundIcon"]["y"] = 10
            game["music"]:setVolume(0)
            --game["music"]:pause()
        else
            game["SoundIcon"]["img"] = sound1Img
            game["SoundIcon"]["x"] = love.graphics.getWidth() - game.SoundIcon.img:getWidth() - 10
            game["SoundIcon"]["y"] = 10
            game["music"]:setVolume(5)
            --game["music"]:play()
        end
    end
end

function game.clickPlayButton()
    if hover(game.playButton, mouseX, mouseY) then
        if game["playButton"]["img"] == playImg then
            game["playButton"]["img"] = pauseImg
            game["playButton"]["x"] = windowWidth - game.playButton.img:getWidth() - 10
            game["playButton"]["y"] = 75
            core.music1:play()
        else
            game["playButton"]["img"] = playImg
            game["playButton"]["x"] = windowWidth - game.playButton.img:getWidth() - 10
            game["playButton"]["y"] = 75
            core.music1:play()
        end
        print("======= GAME ON PAUSE  ========")
        data["playState"] = "pause"
    end
    onListening = {game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}    
end

function game.clickHome()
    if hover(game.home, mouseX, mouseY) then
        love.load()
        data["playState"] = "stoped"
        onListening = {core.playButton, game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}
        core.music:play()
    end
end

function game.clickWifi()
    if hover(game.wifi, mouseX, mouseY) then
        data["playState"] = "pause"
        findingNetworkPlayer = true
        core.music:play()
    end
end

function game.animHintButton()
    -- make icon rotate
end

function game.animCursor(listOfObject)
    for i, obj in ipairs(listOfObject) do
        if hover(obj, mouseX, mouseY) then
            game["cursor"] = love.graphics.newImage("assets/sprites/cursor-hand1.png")
            break
        else
            game["cursor"] = love.graphics.newImage("assets/sprites/cursor-pointer1.png")
        end
    end
end

function game.drawCursor()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(game.cursor, mouseX, mouseY)
end

function game.drawGameBoard()
    -- print(data.board.width)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(3)
    love.graphics.draw(game.playButton.img, game.playButton.x, game.playButton.y)
    love.graphics.draw(game.home.img, game.home.x, game.home.y)
    love.graphics.draw(wifiImgTab[math.floor(game.wifi.currentFrame)], game.wifi.x, game.wifi.y)
    love.graphics.draw(game.board.img, game.board.x, game.board.y)
    love.graphics.rectangle("line", data.board.x, data.board.y, data.board.width, data.board.height)

    -- player A
    for i, row in ipairs(data.pionsEatenA_position) do
        for j, tile in ipairs(row) do
            if i == 1 then
                love.graphics.rectangle("line", data.pionsEatenA_position.leftPos + j * 40, i * 0, 40, 30)
            end
            if i == 2 then
                love.graphics.rectangle("line", data.pionsEatenA_position.leftPos + j * 40, i * 15, 40, 30)
            end
        end
    end
    love.graphics.rectangle("line", data.pionsEatenA_position.leftPos - 70, 0, 110, 60)
    love.graphics.draw(game.playerA.img, game.playerA.x, game.playerA.y)
    love.graphics.print(game.playerA.name,  game.playerA.x - 10, game.playerA.y + game.playerA.img:getHeight() + 10 )

    -- player B
    for i, row in ipairs(data.pionsEatenB_position) do
        for j, tile in ipairs(row) do
            if i == 1 then
                love.graphics.rectangle("line", data.pionsEatenB_position.leftPos + j * 40, windowHeight - 60, 40, 30)
            end
            if i == 2 then
                love.graphics.rectangle("line", data.pionsEatenB_position.leftPos + j * 40, windowHeight - 30, 40, 30)
            end
        end
    end
    love.graphics.rectangle("line", data.pionsEatenB_position.leftPos + 280, windowHeight - 60, 110, 60)
    love.graphics.draw(game.playerB.img, game.playerB.x, game.playerB.y + windowHeight - 60)
    love.graphics.print(game.playerB.name,  game.playerB.x - 10, game.playerB.y + game.playerB.img:getHeight() + windowHeight - 50)

    -- scorePannel
    love.graphics.rectangle("line", 05, windowHeight/2 - 70, 60, 70)
    love.graphics.rectangle("line", 05, windowHeight/2, 60, 70)
    love.graphics.draw(scoreImgTab[data.score[1] + 1], 25, windowHeight/2 - 50)
    love.graphics.draw(scoreImgTab[data.score[2] + 1], 25, windowHeight/2 + 18)
    if data.begin[1] == true and data.begin[2] == true then
        love.graphics.print(data.clock, 15, windowHeight/2 + 80, 0, 1.5)
    end

    -- id pion user
    if data.begin[1] == true then
        love.graphics.draw(pionImgA, data.pionsEatenA_position.leftPos - 110, 15)
        love.graphics.draw(pionImgB, data.pionsEatenB_position.leftPos + 405, windowHeight - 45)
        if data.begin[2] == false then
            love.graphics.draw(goImg, windowWidth/2-goImg:getWidth()/2, windowHeight/2-goImg:getHeight()/2)
        end
        if data.begin[2] == true and not free.stopSound then
            core.music1:play()
            free.stopSound = true
        end
    end

    data.showPion()
    data.showCellule()
    game.drawPions()
end

function game.initPions()
    game["smallPions"]["playerA"] = {}
    game["smallPions"]["playerB"] = {}
    for i = 1, 2 do
        for j = 1, 6 do
             
            if i == 1 then
                table.insert(game.smallPions.playerA, Pion(pionSmalImgA, data.pionsEatenA_position.leftPos + j * 40 + 20 - pionSmalImgA:getWidth()/2, i * 0 + 15 - pionSmalImgA:getHeight()/2))
            end
            if i == 2 then
                table.insert(game.smallPions.playerA, Pion(pionSmalImgA, data.pionsEatenA_position.leftPos + j * 40 + 20 - pionSmalImgA:getWidth()/2, i * 15 + 15 - pionSmalImgA:getHeight()/2))
            end
        end
    end
    for i = 1, 2 do
        for j = 1, 6 do
             
            if i == 1 then
                table.insert(game.smallPions.playerB, Pion(pionSmalImgB, data.pionsEatenB_position.leftPos + j * 40 + 20 - pionSmalImgB:getWidth()/2, windowHeight - 60 + 15 - pionSmalImgB:getHeight()/2))
            end
            if i == 2 then
                table.insert(game.smallPions.playerB, Pion(pionSmalImgB, data.pionsEatenB_position.leftPos + j * 40 + 20 - pionSmalImgA:getWidth()/2, windowHeight - 30 + 15 - pionSmalImgA:getHeight()/2))
            end
        end
    end
end

function game.drawPions()
    if data.begin[1] == true and data.begin[2] == true then
        for i, pion in ipairs(game.smallPions.playerA) do
            love.graphics.draw(pion:getImg(), pion:getX(), pion:getY())
        end
        love.graphics.setColor(1, 1, 1, 1)
        for i, pion in ipairs(game.smallPions.playerB) do
            love.graphics.draw(pion:getImg(), pion:getX(), pion:getY())
        end
    end
end

----------------------------------------wait functions----------------------------------------
function wait.drawPauseScene()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
    
    love.graphics.setColor(0.44, 0.145, 0.192, 1)
    love.graphics.rectangle("fill", 65, 65, windowWidth - 130, windowHeight - 130, 20, 20)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(10)
    love.graphics.rectangle("line", 60, 60, windowWidth - 120, windowHeight - 120, 20, 20)

    if not findingNetworkPlayer then
        love.graphics.setColor(1, 1, 1, 1)
        if data.playState ~= "finished" then
            love.graphics.draw(core.previewBoard, windowWidth/2 - core.previewBoard:getWidth()/2 + 150,  windowHeight/2 - core.previewBoard:getHeight()/2 - 100, 1.14, 1)
        end
        if data.playState == "finished" then
            if winnerManche.player == "playerB" then
                --won
                love.graphics.draw(WinnnImg, windowWidth/2 - WinnnImg:getWidth()/2,  windowHeight/2 - WinnnImg:getHeight()/2 - 50) --150 50
            elseif winnerManche.player == "playerA" then
                --fail
                love.graphics.draw(faillImg, windowWidth/2 - faillImg:getWidth()/2,  windowHeight/2 - faillImg:getHeight()/2 -50 )
            else
                --null
                love.graphics.draw(NulllImg, windowWidth/2 - NulllImg:getWidth()/2,  windowHeight/2 - NulllImg:getHeight()/2 - 50)
            end
        end
        love.graphics.draw(core.gameTitle, windowWidth/2 - core.gameTitle:getWidth()/2, windowHeight* 1/3 - 75 - 50)
        love.graphics.draw(core.continueButton.img, core.continueButton.x, core.continueButton.y)
        love.graphics.draw(core.restartButton.img, core.restartButton.x, core.restartButton.y)
        love.graphics.draw(core.quitButton.img, core.quitButton.x, core.quitButton.y)
        love.graphics.draw(core.muteButton.img, core.muteButton.x, core.muteButton.y)
        --love.graphics.draw(core.playButton.img, core.playButton.x, core.playButton.y)
    else
        -- ???
        onListening = {core.playButton, game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(networkImg, windowWidth/2-networkImg:getWidth()/2,  windowHeight/4 - 30)
        love.graphics.print("Jouer à Tia-Tac-Toe avec vos amis", windowWidth/3 - 70,  windowHeight/3 - 125, 0, 2, 2)
        
        love.graphics.setColor(0.33, 0.28, 0.48, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("fill", windowWidth/2-networkImg:getWidth()/2 - 150 - 4, windowHeight/4 - 30 + networkImg:getWidth() + 30 - 4, windowWidth * (2/3) + 8, 50 + 8)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineWidth(9)
        love.graphics.rectangle("line", windowWidth/2-networkImg:getWidth()/2 - 150, windowHeight/4 - 30 + networkImg:getWidth() + 30, windowWidth * (2/3), 50)
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("IP :  !!! EN COUR DE DEVELOPPEMENT !!!", windowWidth/2-networkImg:getWidth()/2 - 150 + 10, windowHeight/4 - 30 + networkImg:getWidth() + 40, 0, 2, 2)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(network.exitButton.img, network.exitButton.x, network.exitButton.y)
        love.graphics.draw(network.playButton.img, network.playButton.x, network.playButton.y)
    end
end

function wait.captureMouse()
    pausePage = {}
    pausePage["x"] = 55
    pausePage["y"] = 55
    pausePage["width"] = windowWidth - 110
    pausePage["height"] = windowHeight - 110
    mouseContain(pausePage,  mouseX, mouseY)
end

function wait.activatePlayButton()
    if findingNetworkPlayer then
        onListening = {network.exitButton, network.playButton, game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}
    else
        onListening = {core.continueButton, core.restartButton, core.quitButton, core.muteButton, game.hintIcon, game.SoundIcon, game.playButton, game.home, game.wifi}
    end
    -- alreadyInserted = false
    -- --listOfButton = {core.continueButton, core.restartButton, core.quitButton, core.muteButton}
    -- for i, btn in ipairs(listOfButton) do
    --     for j, btnInserted in ipairs(listOfButton) do
    --         if btnInserted == btn then
    --             alreadyInserted = true
    --             print("alreadyInserted = true")
    --             break
    --         end
    --     end
    --     if not alreadyInserted then
    --         table.insert(onListening, btn)
    --     end
    --     -- if onListening[1] ~= btn then
    --     --     --core["playButton"]["y"] = core["playButton"]["y"] - 80
    --     --     onListening[1] = btn
    --     --     --print("btn re-inserted")
    --     -- end
    -- end
    

    -- if hover(core.playButton, mouseX, mouseY) then
    --     core["playButton"]["img"] = play2Img
    --     core["playButton"]["x"] = love.graphics.getWidth()/2 - core.playButton.img:getWidth()/2
    --     core["playButton"]["y"] = love.graphics.getHeight() * 2/3 - 8
    -- else
    --     core["playButton"]["img"] = play1Img
    --     core["playButton"]["x"] = love.graphics.getWidth()/2 - core.playButton.img:getWidth()/2
    --     core["playButton"]["y"] = love.graphics.getHeight() * 2/3 - 8
    -- end
end

function wait.clickContinueButton()
    if hover(core.continueButton, mouseX, mouseY) and not findingNetworkPlayer then
        core.music1:play()
        if data.playState == "finished" then
            winnerManche["score"] = data["score"]
            love.load()
            if winnerManche.player == "playerA" then
                data["score"][1] = data["score"][1] + winnerManche["score"][1] + 1 
                data["score"][2] = data["score"][2] + winnerManche["score"][2]
            elseif winnerManche.player == "playerB" then
                data["score"][1] = data["score"][1] + winnerManche["score"][1]
                data["score"][2] = data["score"][2] + winnerManche["score"][2] + 1
            else
                data["score"][1] = data["score"][1] + winnerManche["score"][1]
                data["score"][2] = data["score"][2] + winnerManche["score"][2]
            end
            winnerManche = nil
        end
        
        data["playState"] = "play"

        game["playButton"]["img"] = pauseImg
        game["playButton"]["x"] = windowWidth - game.playButton.img:getWidth() - 10
        game["playButton"]["y"] = 75
    end
end

----------------------------------------data functions----------------------------------------
function data.showPion()
    if data.playState == "play" and data.begin[1] and data.begin[2] and data.canPlay then
        if hoverBox(data.board, mouseX, mouseY) then
            love.graphics.draw(pionScalImgB, mouseX - 17, mouseY - 20)
        end
    end
end

function data.showCellule()
    if data.playState == "play" and data.begin[1] and data.begin[2] and data.canPlay then
        for i, cellule in ipairs(game.cellules) do
            if hoverBox(cellule, mouseX, mouseY) then
                x_i, x_j = mapping(i)
                if data.board.state[x_j][x_i] == 0 then
                    love.graphics.setColor(0.25, 1.34, 0.04, 1)
                else
                    love.graphics.setColor(1.68, 0.11, 0.11, 1)
                end
                love.graphics.setLineWidth(7)
                love.graphics.rectangle("line", cellule.x + 7, cellule.y + 7, cellule.width - 12, cellule.height - 12)
            end
        end
    end
end

function data.clickPlay(player, x_i, x_j)
    if player == "playerA" then
        if data.board.state[x_j][x_i] == 0 and data.nbrCoups[1] ~= 0 and not data.canPlay then
            pos = mappingReverse(x_i, x_j)
            data.board.state[x_j][x_i] = 1
            table.insert(data.board.allPions, Pion(pionScalImgA, game.cellules[pos].x, game.cellules[pos].y))
            core.music2:play()
            table.remove(game.smallPions.playerA, 1)
            data.nbrCoups[1] = data.nbrCoups[1] - 1
            data.canPlay = true
            print("playerA(i-a) --> (".. x_j .. ", " .. x_i ..")")
        end
    elseif player == "playerB" then
        if data.nbrCoups[2] ~= 0 and data.canPlay then
            for i, cellule in ipairs(game.cellules) do
                if hoverBox(cellule, mouseX, mouseY) then
                    x_i, x_j = mapping(i)
                    if data.board.state[x_j][x_i] == 0 then
                        data.board.state[x_j][x_i] = 2
                        table.insert(data.board.allPions, Pion(pionScalImgB, cellule.x, cellule.y))
                        core.music2:play()
                        table.remove(game.smallPions.playerB, 1)
                        data.nbrCoups[2] = data.nbrCoups[2] - 1
                        data.canPlay = false
                        print("playerB(you) --> (".. x_j .. ", " .. x_i ..")")
                        -- ------------------------------------- --
                        ia:updateLastPion({x_j, x_i})
                        ia:setCanPlay(true, false)
                        --ia:update(dt, data.board.state)
                        allCoords = ia:getEnemyPions(0)
                        coords = ia:play(allCoords, data.board.state)
                        ia:swithPlayerTo("playerB")
                        -- ------------------------------------- --
                        if coords ~= nil then
                            data.clickPlay("playerA", coords[2], coords[1])
                        end
                    end
                end
            end
        end
    end
end

function data.drawPionOnBoard()
    for i,pion in ipairs(data.board.allPions) do
        pion:draw()
    end
end

--------------------------------------------- network function ---------------------------------

-- exit -->
function network.animExitButton()
    if hover(network.exitButton, mouseX, mouseY) then
        network["exitButton"]["img"] = noScaleImg
        network["exitButton"]["x"] = windowWidth/2-noImg:getWidth()/2 - noImg:getWidth()/2 - 50
        network["exitButton"]["y"] = windowHeight-noImg:getWidth()-60
    else
        network["exitButton"]["img"] = noImg
        network["exitButton"]["x"] = windowWidth/2-noImg:getWidth()/2 - noImg:getWidth()/2 - 50
        network["exitButton"]["y"] = windowHeight-noImg:getWidth()-60
    end
end

function network.clickExitButton()
    if hover(network.exitButton, mouseX, mouseY) and findingNetworkPlayer then
        core.music1:play()
        data["playState"] = "play"
        findingNetworkPlayer = false
    end
end

-- searchUserOnline -->
function network.animPlayButton()
    if hover(network.playButton, mouseX, mouseY) then
        network["playButton"]["img"] = yesScaleImg
        network["playButton"]["x"] = windowWidth/2-yesImg:getWidth()/2 + yesImg:getWidth()/2 + 50
        network["playButton"]["y"] = windowHeight-yesImg:getWidth()-60
    else
        network["playButton"]["img"] = yesImg
        network["playButton"]["x"] = windowWidth/2-yesImg:getWidth()/2 + yesImg:getWidth()/2 + 50
        network["playButton"]["y"] = windowHeight-yesImg:getWidth()-60
    end
end

function network.clickPlayButton()
    if hover(network.playButton, mouseX, mouseY) and findingNetworkPlayer then
        core.music1:play()
        data["playState"] = "play"
        findingNetworkPlayer = false
        -- function reseau de recherche non encore implementé
    end
end