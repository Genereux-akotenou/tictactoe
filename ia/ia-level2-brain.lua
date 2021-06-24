function Ia2:play(placeWhereCanPutPion, board)
    if self.canPlay[1] == true and self.canPlay[2] == false then
        --get enemy last pion position
        lastPion = self.lastPion
        --return  our choice
        GAME = danger(placeWhereCanPutPion, board, lastPion)
        if GAME["status"] then
            print("Danger case : (" .. GAME["dangerAt"][1] .. ", " .. GAME["dangerAt"][2] .. ")")
            return GAME["dangerAt"]
        else
            return tryToWin(placeWhereCanPutPion, board, lastPion)
        end
    else
        return nil
    end
end

function tryToWin(placeWhereCanPutPion, board, lastPion)
    print("enemy play at : (" .. lastPion[1] .. ", " .. lastPion[2] .. ")")
    line = {}
    row  = {}
    for i, coords in ipairs(placeWhereCanPutPion) do
        if coords[1] == lastPion[1] then
            if goodCell_onY(coords, board) then
                table.insert(line, coords)
            end
        end
        if coords[2] == lastPion[2] then
            if goodCell_onX(coords, board) then
                table.insert(row, coords)
            end
        end
    end
    if #line == 0 and #row == 0 then
        randChoice1 = 0
    elseif #line ~= 0 and #row ~= 0 then
        randChoice1 = love.math.random(2)
    elseif #line == 0 and #row ~= 0 then
        randChoice1 = 2
    elseif #line ~= 0 and #row == 0 then
        randChoice1 = 1
    end

    print("Action toward -->" .. randChoice1)
    if randChoice1 == 0 then
        return placeWhereCanPutPion[love.math.random(#placeWhereCanPutPion)]
    elseif randChoice1 == 1 then
        randChoice2 = love.math.random(#line)
        print("tab tall = " .. #line .. " | index = " .. randChoice2)
        print("----------------> (" .. line[randChoice2][1] .. ", " .. line[randChoice2][2] .. ")")
        return line[randChoice2]
    else
        randChoice2 = love.math.random(#row)
        print("tab tall = " .. #row .. " | index = " .. randChoice2)
        print("----------------> (" .. row[randChoice2][1] .. ", " .. row[randChoice2][2] .. ")")
        return row[randChoice2]
    end
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

function danger(placeWhereCanPutPion, board, lastPion)
    state = {}
    sum = 0
    temp = nil
    max = 5
    --vertical check
    print("--vertical check")
    for j,line in ipairs(board) do
        for i,cell in ipairs(line) do
            if board[i][j] == 1 then
                sum = 0
                break
            else
                sum = sum + board[i][j]
                if board[i][j] == 0 then
                    temp = {i, j}
                end
            end
        end
        if sum == 8 then
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
            if board[j][i] == 1 then
                sum = 0
                break
            else
                sum = sum + board[j][i]
                if board[j][i] == 0 then
                    temp = {j, i}
                end
            end
        end
        if sum == 8 then
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
        if board[max+1-i][i] == 1 then
            sum = 0
            break
        else
            sum = sum + board[max+1-i][i]
            if board[max+1-i][i] == 0 then
                temp = {6-i, i}
            end
        end
    end
    if sum == 8 then
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
        if board[c][c] == 1 then
            sum = 0
            break
        else
            sum = sum + board[c][c]
            if board[c][c] == 0 then
                temp = {c, c}
            end
        end
    end
    if sum == 8 then
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