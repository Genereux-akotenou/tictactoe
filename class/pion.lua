Pion = Object:extend()

function Pion:new(img, x, y)
    self.image = img
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    
end

function Pion:update(dt)
    
end

function Pion:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x + 47.5 - self.width/2, self.y + 37.8 - self.height/2)
end

function Pion:getImg()
    return self.image
end

function Pion:getX()
    return self.x
end

function Pion:getY()
    return self.y
end