-- finissons en beauté ! Oh oui je me suis défoulé

function whoHasWon(board)
    win = {}
    win["score"] = {0, 0}
    sum = 0
    max = 5
    --vertical check
    for j,line in ipairs(board) do
        for i,cell in ipairs(line) do
            if board[i][j] == 0 then
                sum = 0
                break
            else
                sum = sum + board[i][j]
            end
        end
        if sum == 5 then
            win["player"] = "playerA"
            win["status"] = true
            return win
        elseif sum == 10 then
            win["player"] = "playerB"
            win["status"] = true
            return win
        else
            sum = 0
            win["player"] = "???????"
            win["status"] = false
        end
    end
    --horizontal check
    for j,line in ipairs(board) do
        for i,cell in ipairs(line) do
            if board[j][i] == 0 then
                sum = 0
                break
            else
                sum = sum + board[j][i]
            end
        end
        if sum == 5 then
            win["player"] = "playerA"
            win["status"] = true
            return win
        elseif sum == 10 then
            win["player"] = "playerB"
            win["status"] = true
            return win
        else
            sum = 0
            win["player"] = "???????"
            win["status"] = false
        end
    end
    --oblic check [left,bottom] --to--> [right, top]
    for i = 1, 5 do
        if board[max+1-i][i] == 0 then
            sum = 0
            break
        else
            sum = sum + board[max+1-i][i]
        end
    end
    if sum == 5 then
        win["player"] = "playerA"
        win["status"] = true
        return win
    elseif sum == 10 then
        win["player"] = "playerB"
        win["status"] = true
        return win
    else
        sum = 0
        win["player"] = "???????"
        win["status"] = false
    end
    --oblic check [left,top] --to--> [right, bottom]
    for c=1, #board do
        if board[c][c] == 0 then
            sum = 0
            break
        else
            sum = sum + board[c][c]
        end
    end
    if sum == 5 then
        win["player"] = "playerA"
        win["status"] = true
        return win
    elseif sum == 10 then
        win["player"] = "playerB"
        win["status"] = true
        return win
    else
        sum = 0
        win["player"] = "???????"
        win["status"] = false
        return win
    end
end

---------------------------------------------------