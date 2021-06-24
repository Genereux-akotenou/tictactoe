function hover(obj, mouseX, mouseY)
    if mouseX >= obj.x and mouseX <= obj.x + obj.img:getWidth() and mouseY >= obj.y and mouseY <= obj.y + obj.img:getHeight() then
        return true
    else
        return false
    end
end

function hoverBox(obj, mouseX, mouseY)
    if mouseX >= obj.x and mouseX <= obj.x + obj.width and mouseY >= obj.y and mouseY <= obj.y + obj.height then
        return true
    else
        return false
    end
end

function mouseContain(obj,  mouseX, mouseY)
    -- data
    marginRB = 15
    marginLT = 0
    mouse_X1 = mouseX + marginRB
    mouse_Y1 = mouseY + marginRB
    mouse_X2 = mouseX + marginLT
    mouse_Y2 = mouseY + marginLT
    
    -- right side
    if mouse_X1 > obj.x + obj.width and mouse_Y1 >= obj.y and mouse_Y1 <= obj.y + obj.width then
        love.mouse.setPosition(obj.x + obj.width - marginRB, love.mouse.getY())
    end
    -- bottom side
    if mouse_Y1 > obj.y + obj.height and mouse_X1 >= obj.x and mouse_X1 <= obj.x + obj.width then
        love.mouse.setPosition(love.mouse.getX(), obj.y + obj.height - marginRB)
    end
    -- left side
    if mouse_X2 < obj.x and mouse_Y2 >= obj.y and mouse_Y2 <= obj.y + obj.width then
        love.mouse.setPosition(obj.y , love.mouse.getY())
    end
    -- top side
    if mouse_Y2 < obj.y and mouse_X2 >= obj.x and mouse_X2 <= obj.x + obj.width then
        love.mouse.setPosition(love.mouse.getX(), obj.y)
    end

    -- corner top-right
    if mouseX > obj.x + obj.width and mouseY < obj.y then
        love.mouse.setPosition(obj.x + obj.width - marginRB, obj.y + marginRB)
    end
    -- corner top-left
    if mouseX < obj.x and mouseY < obj.y then
        love.mouse.setPosition(obj.x + marginRB, obj.y + marginRB)
    end
    -- corner bottom-left
    if mouseX < obj.x and mouseY > obj.y + obj.height then
        love.mouse.setPosition(obj.x + marginRB, obj.y + obj.height + marginRB)
    end
    -- corner bottom-right
    if mouseX > obj.x + obj.width and mouseY > obj.y + obj.height then
        love.mouse.setPosition(obj.x + obj.width + marginRB, obj.y + obj.height + marginRB)
    end
end

function switch(n, ...)
    for i, v in ipairs { ... } do
       if v[1] == n or v[1] == nil then
            return v[2]()
       end
    end
end

function case(n, funct) 
    return {n, funct}
end

function default(funct)
    return {nil, funct}
end

-- echec fonction non terminé, !!! bug !!!

-- function mapping(pos)
--     print("switch")
--     switch(pos,
--         case(1,  function() return 1, 1 end ),
--         case(2,  function() return 2, 1 end ),
--         case(3,  function() return 3, 1 end ),
--         case(4,  function() return 4, 1 end ),
--         case(5,  function() return 5, 1 end ),

--         case(6,  function() return 1, 2 end ),
--         case(7,  function() return 2, 2 end ),
--         case(8,  function() return 3, 2 end ),
--         case(9,  function() return 4, 2 end ),
--         case(10, function() return 5, 2 end ),

--         case(11,  function() return 1, 3 end ),
--         case(12,  function() return 2, 3 end ),
--         case(13,  function() return 3, 3 end ),
--         case(14,  function() return 4, 3 end ),
--         case(15,  function() return 5, 3 end ),

--         case(16,  function() return 1, 4 end ),
--         case(17,  function() return 2, 4 end ),
--         case(18,  function() return 3, 4 end ),
--         case(19,  function() return 4, 4 end ),
--         case(20,  function() return 5, 4 end ),

--         case(21,  function() return 1, 5 end ),
--         case(22,  function() return 2, 5 end ),
--         case(23,  function() return 3, 5 end ),
--         case(24,  function() return 4, 5 end ),
--         case(25,  function() return 5, 5 end ),

--         default(function() return 0, 0 end )  
--     )
-- end

function mapping(pos)
    if pos == 1 then 
        return 1, 1
    elseif pos ==  2 then 
        return 2, 1
    elseif pos ==  3 then 
        return 3, 1
    elseif pos ==  4 then 
        return 4, 1
    elseif pos ==  5 then 
        return 5, 1
    elseif pos ==  6 then 
        return 1, 2
    elseif pos ==  7 then 
        return 2, 2
    elseif pos ==  8 then 
        return 3, 2
    elseif pos ==  9 then 
        return 4, 2
    elseif pos == 10 then
        return 5, 2
    elseif pos == 11 then 
        return 1, 3
    elseif pos == 12 then 
        return 2, 3
    elseif pos == 13 then 
        return 3, 3
    elseif pos == 14 then 
        return 4, 3
    elseif pos == 15 then 
        return 5, 3
    elseif pos == 16 then 
        return 1, 4
    elseif pos == 17 then 
        return 2, 4
    elseif pos == 18 then 
        return 3, 4
    elseif pos == 19 then 
        return 4, 4
    elseif pos == 20 then 
        return 5, 4
    elseif pos == 21 then 
        return 1, 5
    elseif pos == 22 then 
        return 2, 5
    elseif pos == 23 then 
        return 3, 5
    elseif pos == 24 then 
        return 4, 5
    elseif pos == 25 then 
        return 5, 5
    else
        return nil, nil
    end
end

function mappingReverse(pos1, pos2)
    if pos1 == 1 and pos2 == 1 then 
        return 1
    elseif pos1 == 2 and pos2 == 1 then 
        return 2
    elseif pos1 == 3 and pos2 == 1 then 
        return 3
    elseif pos1 == 4 and pos2 == 1 then 
        return 4
    elseif pos1 == 5 and pos2 == 1 then 
        return 5
    elseif pos1 == 1 and pos2 == 2 then 
        return 6
    elseif pos1 == 2 and pos2 == 2 then 
        return 7
    elseif pos1 == 3 and pos2 == 2 then 
        return 8
    elseif pos1 == 4 and pos2 == 2 then 
        return 9
    elseif pos1 == 5 and pos2 == 2 then
        return 10
    elseif pos1 == 1 and pos2 == 3 then 
        return 11
    elseif pos1 == 2 and pos2 == 3 then 
        return 12
    elseif pos1 == 3 and pos2 == 3 then 
        return 13
    elseif pos1 == 4 and pos2 == 3 then 
        return 14
    elseif pos1 == 5 and pos2 == 3 then 
        return 15
    elseif pos1 == 1 and pos2 == 4 then 
        return 16
    elseif pos1 == 2 and pos2 == 4 then 
        return 17
    elseif pos1 == 3 and pos2 == 4 then 
        return 18
    elseif pos1 == 4 and pos2 == 4 then 
        return 19
    elseif pos1 == 5 and pos2 == 4 then 
        return 20
    elseif pos1 == 1 and pos2 == 5 then 
        return 21
    elseif pos1 == 2 and pos2 == 5 then 
        return 22
    elseif pos1 == 3 and pos2 == 5 then 
        return 23
    elseif pos1 == 4 and pos2 == 5 then 
        return 24
    elseif pos1 == 5 and pos2 == 5 then 
        return 25
    else
        return nil
    end
end

-- dodo 20210622 - 0605 phase2