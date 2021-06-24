-- Author @Redfox
-- If want to make this ia more smart just write play() function container by using methodes provide
-- by this class
-- Author @Redfox

Ia1 = Object:extend()

function Ia1:new(name, board, state, canPlay, score)
    self.player = name
    self.board  = board
    self.gameState  = state
    self.canPlay= canPlay 
    self.score  = score
    self.lastPion = {0, 0}
end

function Ia1:update(dt, board)
    self.updateBoard(board)
end

function Ia1:draw()
    
end

-- brain function
-- it contain IA strategy
-- -------------------------
-- -------------------------
-- -------------------------
require "ia/ia-level1-brain"
-- -------------------------
-- -------------------------
-- -------------------------

-- getter
function Ia1:getName()
    return self.name
end

function Ia1:getBoard()
    return self.board
end

function Ia1:getGameSate()
    return self.gameState
end

function Ia1:getCanPlay()
    return self.canPlay
end

function Ia1:getScore()
    return self.score
end

function Ia1:getLastPion()
    return self.lastPion
end


-- setter
function Ia1:setName(data)
    self.name = data
end

function Ia1:setGameSate(data)
    self.gameState = data
end

function Ia1:setCanPlay(data1, data2)
    self.canPlay[1] = data1
    self.canPlay[2] = data2
end

function Ia1:setScore(data)
    self.score[1] = data
end

-- other
function Ia1:swithPlayerTo(data)
    if data == "playerB" then
        self.canPlay[1] = false
        self.canPlay[2] = true
    elseif data == "playerA" then
        self.canPlay[1] = true
        self.canPlay[2] = false
    else
        print("\n------------------------------------------------------------------------------------")
        print("Alert : Bad args for  Ia1:switchPlayerTo(args) | args = (String) {playerA | playerB}")
        love.quit()
    end
end

function Ia1:getEnemyPions(pionRef)
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

function Ia1:updateScore(data)
    self.score[1] = data[1]
    self.score[2] = data[2]
end

function Ia1:updateBoard(data)
    self.board = data
end

function Ia1:updateLastPion(data)
    self.lastPion = data
end

-- by Généreux AKOTENOU | @Redfox | 
-- my github       https://github.com/Genereux-akotenou
-- my linkedin     https://www.linkedin.com/in/généreux-akotenou-8b00901b4/