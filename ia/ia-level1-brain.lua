function Ia1:play(placeWhereCanPutPion, board)
    if self.canPlay[1] == true and self.canPlay[2] == false then
        --get enemy last pion position
        lastPion = self.lastPion
        --return  our choice
        enemyCanWin = winable("for_enemy", placeWhereCanPutPion, board, lastPion)
        iaCanWin = winable("for_me", placeWhereCanPutPion, board, lastPion)
        if enemyCanWin["status"] then
            print("enemy can win at : (" .. enemyCanWin["dangerAt"][1] .. ", " .. enemyCanWin["dangerAt"][2] .. ")")
            return enemyCanWin["dangerAt"]
        else
            if iaCanWin["status"] then
                print("ia can win at    : (" .. iaCanWin["dangerAt"][1] .. ", " .. iaCanWin["dangerAt"][2] .. ")")
                return iaCanWin["dangerAt"]
            else
                return tryToWin(placeWhereCanPutPion, board, lastPion)
            end
        end
    else
        return nil
    end
end

function tryToWin(placeWhereCanPutPion, board, lastPion)
    placeEmpty   = 0
    placePlayerA = 0
    placePlayerB = 0

    for i, coords in ipairs(placeWhereCanPutPion) do
        for j=1, 5 do
            if board[i][j] == 0 then
                placeEmpty = placeEmpty + 1
            elseif board[i][j] == 1 then
                placePlayerA = placePlayerA + 1
            else
                placePlayerB = placePlayerB + 1
            end
        end

        if placePlayerA ~= 0 and placePlayerB ~= 0 then
            --pass
        elseif placePlayerA ~= 0 and placePlayerB == 0 then
            playAbleLine = {}
            for k, l in ipairs(placeWhereCanPutPion) do
               table.insert(playAbleLine, l[i][k]) 
            end
            for k, l in ipairs(playAbleLine) do
                if goodCell_onY(l, board) then
                    return {l[1], l[2]}
                end
            end
            return playAbleLine[love.math.random(#playAbleLine)]
            --first return-->
            --on place sur une line contenant au un pion a nous de maniere a ce que la verticale
            --ne contienne que des pions a nous ou soi vide
            --secon return-->
            --la vie ne nous laisse pas le choix, du moins le jeux. Soyons smart
            --on retourne une position aleatoire sur la line contenant que nos pions
        elseif placePlayerA == 0 and placePlayerB ~= 0 then
            playAbleLine = {}
            for k, l in ipairs(placeWhereCanPutPion) do
               table.insert(playAbleLine, l[i][k]) 
            end
            for k, l in ipairs(playAbleLine) do
                if goodCell_onY(l, board) then
                    return {l[1], l[2]}
                end
            end
            return playAbleLine[love.math.random(#playAbleLine)]
            --bref je fais la memechose que precedemant juste que j'emerde mon adversaire
        end
    end
    return placeWhereCanPutPion[love.math.random(#placeWhereCanPutPion)]
end

function goodCell_onY(cell, board)
    res = false
    for i = 1, 5 do
        if board[i][cell[2]] == 0 or board[i][cell[2]] == 1 then
            res = true
        else
            res = false
            break
        end
    end
    return res
end

function goodCell_onX(cell, board)
    res = false
    for i = 1, 5 do
        if board[cell[1]][i] == 0 or board[cell[1]][i] == 1 then
            res = true
        else
            res = false
            break
        end
    end
    return res
end

function winable(target, placeWhereCanPutPion, board, lastPion)
    --setting
    if target == "for_enemy" then
        playerId = 1
        playerSum = 8
    elseif target == "for_me" then
        playerId = 2
        playerSum = 4
    else
        print("args missed on winable function | ia-levelx-brain.lua -> Wrong target")
        love.window.close(0)
    end
    --data
    state = {}
    sum = 0
    temp = nil
    max = 5
    --vertical check
    print("--vertical check")
    for j,line in ipairs(board) do
        for i,cell in ipairs(line) do
            if board[i][j] == playerId then
                sum = 0
                break
            else
                sum = sum + board[i][j]
                if board[i][j] == 0 then
                    temp = {i, j}
                end
            end
        end
        if sum == playerSum then
            state["dangerAt"] = temp
            temp = nil
            state["status"] = true
            return state
        else
            sum = 0
            state["status"] = false
        end
    end
    --horizontal check
    print("--horizontal check")
    for j,line in ipairs(board) do
        for i,cell in ipairs(line) do
            if board[j][i] == playerId then
                sum = 0
                break
            else
                sum = sum + board[j][i]
                if board[j][i] == 0 then
                    temp = {j, i}
                end
            end
        end
        if sum == playerSum then
            state["dangerAt"] = temp
            temp = nil
            state["status"] = true
            return state
        else
            sum = 0
            state["status"] = false
        end
    end
    --oblic check [left,bottom] --to--> [right, top]
    print("--oblic check [left,bottom] --to--> [right, top]")
    for i = 1, 5 do
        if board[max+1-i][i] == playerId then
            sum = 0
            break
        else
            sum = sum + board[max+1-i][i]
            if board[max+1-i][i] == 0 then
                temp = {6-i, i}
            end
        end
    end
    if sum == playerSum then
        state["dangerAt"] = temp
        temp = nil
        state["status"] = true
        return state
    else
        sum = 0
        state["status"] = false
    end
    --oblic check [left,top] --to--> [right, bottom]
    print("--oblic check [left,top] --to--> [right, bottom]")
    for c=1, #board do
        if board[c][c] == playerId then
            sum = 0
            break
        else
            sum = sum + board[c][c]
            if board[c][c] == 0 then
                temp = {c, c}
            end
        end
    end
    if sum == playerSum then
        state["dangerAt"] = temp
        temp = nil
        state["status"] = true
        return state
    else
        sum = 0
        state["status"] = false
        return win
    end
end