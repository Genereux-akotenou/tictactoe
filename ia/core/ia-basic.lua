-- Author @Redfox
-- If want to make this ia more smart just write play() function container by using methodes provide
-- by this class
-- Author @Redfox

Ia = Object:extend()

function Ia:new(name, board, state, canPlay, score)
    self.player = name
    self.board  = board
    self.gameState  = state
    self.canPlay= canPlay 
    self.score  = score
    self.lastPion = nil
end

function Ia:update(dt, board)
    if self.canPlay[1] == true and self.canPlay[2] == false then
        --self.play()
    end
    self.updateBoard(board)
end

function Ia:draw()
    
end

-- brain function
function Ia:play(placeWhereCanPutPion, board)
    if self.canPlay[1] == true and self.canPlay[2] == false then
        --random choice done
        choice = love.math.random(#placeWhereCanPutPion)
        --return  our choice
        return placeWhereCanPutPion[choice]
    else
        return nil
    end
end

function Ia:ia()
    -- canPlacePion = self.getEnemyPions(0)
    -- choice = love.math.random(#canPlacePion)
    -- self.swithPlayerTo("playerB")
    -- return canPlacePion[choice]
end

-- getter
function Ia:getName()
    return self.name
end

function Ia:getBoard()
    return self.board
end

function Ia:getGameSate()
    return self.gameState
end

function Ia:getCanPlay()
    return self.canPlay
end

function Ia:getScore()
    return self.score
end

function Ia:getLastPion()
    return self.lastPion
end


-- setter
function Ia:setName(data)
    self.name = data
end

function Ia:setGameSate(data)
    self.gameState = data
end

function Ia:setCanPlay(data1, data2)
    self.canPlay[1] = data1
    self.canPlay[2] = data2
end

function Ia:setScore(data)
    self.score[1] = data
end

-- other
function Ia:swithPlayerTo(data)
    if data == "playerB" then
        self.canPlay[1] = false
        self.canPlay[2] = true
    elseif data == "playerA" then
        self.canPlay[1] = true
        self.canPlay[2] = false
    else
        print("\n------------------------------------------------------------------------------------")
        print("Alert : Bad args for  Ia:switchPlayerTo(args) | args = (String) {playerA | playerB}")
        love.quit()
    end
end

function Ia:getEnemyPions(pionRef)
    pions = {}
    for j,v in ipairs(self.board) do
        for i=1, #v do
            if self.board[j][i] == pionRef then
                table.insert(pions, {j, i})
            end
        end
    end
    return pions
end

function Ia:updateScore(data)
    self.score[1] = data[1]
    self.score[2] = data[2]
end

function Ia:updateBoard(data)
    self.board = data
end

function Ia:updateLastPion(data)
    self.lastPion = data
end

-- by Généreux AKOTENOU | @Redfox | 
-- my github       https://github.com/Genereux-akotenou
-- my linkedin     https://www.linkedin.com/in/généreux-akotenou-8b00901b4/