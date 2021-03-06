local Shadows = ...

CircleRoom = Room:new()
CircleRoom.__index = CircleRoom

CircleRoom.Radius = 0

function CircleRoom:new(World, x, y, Radius)
	
	local self = setmetatable({}, CircleRoom)
	
	if World and x and y and Radius then
		
		self.Transform = Shadows.Transform:new()
		self.Transform:SetLocalPosition(x, y)
		
		self.Radius = Radius
		
		World:AddRoom(self)
		
	end
	
	return self
	
end

function CircleRoom:Draw()
	
	local x, y = self.Transform:GetPosition()
	
	love.graphics.setColor(self.R, self.G, self.B, self.A)
	love.graphics.circle("fill", x, y, self.Radius)
	
end

function CircleRoom:SetRadius(Radius)
	
	if Radius ~= self.Radius then
		
		self.Radius = Radius
		self.World.UpdateCanvas = true
		
	end
	
end

function CircleRoom:GetRadius()
	
	return self.Radius
	
end

return CircleRoom