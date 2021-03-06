local Shadows = ...

CircleShadow = {}
CircleShadow.__index = CircleShadow

local insert = table.insert

local halfPi = math.pi * 0.5
local atan = math.atan
local atan2 = math.atan2
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos

function CircleShadow:new(Body, x, y, Radius)
	
	local self = setmetatable({}, CircleShadow)
	
	if Body and x and y and Radius then
	
		self.Transform = Shadows.Transform:new()
		self.Transform:SetParent(Body.Transform)
		self.Transform:SetLocalPosition(x, y)
		
		self.Body = Body
		self.Radius = Radius
		
		Body:AddShape(self)
		
	end
	
	return self
	
end

function CircleShadow:Remove()
	
	self.Body.Shapes[self.ID] = nil
	self.Body.World.Changed = true
	
	self.Transform:SetParent(nil)
	
end

function CircleShadow:SetRadius(Radius)
	
	if self.Radius ~= Radius then
		
		self.Radius = Radius
		self.Body.World.Changed = true
		
	end
	
end

function CircleShadow:GetRadius()
	
	return self.Radius
	
end

function CircleShadow:Draw()
	
	local x, y = self.Transform:GetPosition()
	
	return love.graphics.circle("fill", x, y, self.Radius)
	
end

function CircleShadow:SetPosition(x, y)
	
	if self.Transform:SetLocalPosition(x, y) then
		
		self.Body.World.Changed = true
		
	end
	
end

function CircleShadow:GetPosition()
	
	return self.Transform:GetPosition()
	
end

function CircleShadow:GenerateShadows(Shapes, Body, DeltaX, DeltaY, Light)
	
	local x, y = self:GetPosition()
	local Radius = self:GetRadius()
	
	local Lx, Ly, Lz = Light:GetPosition()
	local Bx, By, Bz = Body:GetPosition()
	
	Lx = Lx + DeltaX
	Ly = Ly + DeltaY
	
	local dx = x - Lx
	local dy = y - Ly

	local Distance = sqrt( dx * dx + dy * dy )
	
	if Distance > Radius then
		
		local Heading = atan2(Lx - x, y - Ly) + halfPi
		local Offset = atan(Radius / Distance)
		local BorderDistance = Distance * cos(Offset)
		
		local Length = Light.Radius
		
		if Bz < Lz then
			
			Length = Bz / atan2(Lz, BorderDistance)
			
		end
		
		local Polygon = {type = "polygon"}
		insert(Polygon, Lx + cos(Heading + Offset) * BorderDistance)
		insert(Polygon, Ly + sin(Heading + Offset) * BorderDistance)
		insert(Polygon, Lx + cos(Heading - Offset) * BorderDistance)
		insert(Polygon, Ly + sin(Heading - Offset) * BorderDistance)

		insert(Polygon, Polygon[3] + cos(Heading - Offset) * Length)
		insert(Polygon, Polygon[4] + sin(Heading - Offset) * Length)
		insert(Polygon, Polygon[1] + cos(Heading + Offset) * Length)
		insert(Polygon, Polygon[2] + sin(Heading + Offset) * Length)
		insert(Shapes, Polygon)
		
		if Lz > Bz then
			
			local Circle = {type = "circle"}
			
			Circle[1] = Lx + cos(Heading) * (Length + Distance)
			Circle[2] = Ly + sin(Heading) * (Length + Distance)
			
			local dx = Polygon[5] - Circle[1]
			local dy = Polygon[6] - Circle[2]
			
			Circle[3] = sqrt( dx * dx + dy * dy )
			
			insert(Shapes, Circle)
			
		end
		
	end
	
end

return CircleShadow