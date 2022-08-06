local gE = require("engine")
local wf = require ('windfield')

Gmr = {}

function Gmr.Gamer()
	return {
		x = 50,
		y = 300,
		sx = 70,
		sy = 120,
		line1 = nil,
		line2 = nil,
		line3 = nil,
		line4 = nil,
		lines = nil,
		peres = nil,
		peresx = nil,
		peresy = nil,
		center = nil,
		vi = 0,
		vx = 0,
		vi1 = nil,
		line5 = nil,
		collider = world:newBSGRectangleCollider(50, 300, 70, 120, 5),

		init = function(self)
			self.line1:init()
			self.line2:init()
			self.line3:init()
			self.line4:init()
			self.lines = {self.line1, self.line2, self.line3, self.line4}
			self.center = {self.x + self.sx / 2, self.y + self.sy / 2}
		end,

		update = function(self)
			self.x = self.collider:getX() - self.sx / 2
			self.y = self.collider:getY() - self.sy / 2
			self.line1 = gE.Line(self.x, self.y, (self.x + self.sx), self.y)
			self.line2 = gE.Line(self.x + self.sx, self.y, self.x + self.sx, self.y + self.sy)
			self.line3 = gE.Line(self.x + self.sx, self.y + self.sy, self.x, self.y + self.sy)
			self.line4 = gE.Line(self.x, self.y + self.sy, self.x, self.y)
			self:init()
		end,

		collision = function(self, lines)
			self.peres = {nil, nil, nil, nil}
			self.peresx = 0
			self.peresy = 0
			for i = 1, #self.lines do
				for u = 1, #lines do
					if gE.mathlines(self.lines[i], lines[u]) then
						x, y = Gmr.peres(self.lines[i], lines[u])

						if x ~= nil and y ~= nil and self.peres[i] == nil then
							self.peres[i] = {{x, y}}
						elseif  x ~= nil and y ~= nil then
							self.peres[i][#self.peres[i] + 1] = {x, y}
						end
					end
				end
			end
		end,

		onecoll = function(self, lines)
			local a = 0
			local b = -7543
			for i = 1, #self.lines do
				if self.peres[i] ~= nil then
					a = a + 1
				end
			end
			if a == 1 then
				for i = 1, #self.lines do
					if self.lines[i].Pb then
						for u = 1, #self.peres[i] do
							if b < ((self.center[1] - self.peres[i][u][1]) ^ 2 + (self.center[2] - self.peres[i][u][2]) ^ 2) ^ 0.5 then
								self.line5 = gE.Line(self.center[1], self.center[2], self.peres[i][u][1], self.peres[i][u][2])
								self.line5:init()
								b = ((self.center[1] - self.peres[i][u][1]) ^ 2 + (self.center[2] - self.peres[i][u][2]) ^ 2) ^ 0.5
							end
						end
						for u = 1, #lines do
							if gE.mathlines(self.line5, lines[u]) then
								local x, y = Gmr.peres(self.line5, lines[u])
								if i == 1 then
									self.y = y
								end
								if i == 2 then
									self.x = x - self.sx - 1
									print("You've been trolled")
								end
								if i == 3 then
									self.y = y - self.sy
								end
								if i == 4 then
									self.x = x + 1
								end
							end
						end
					end
				end
			end
			self:update()
		end,

		fall = function(self)

			if (self.lines[3].Pb and not self.lines[1].Pb and not self.lines[2].Pb and not self.lines[4].Pb) then
				self.vi = 0
			end
			if (self.lines[1].Pb and not self.lines[3].Pb and not self.lines[2].Pb and not self.lines[4].Pb) then
				self.vi = 0
			end
			if (self.lines[3].Pb and not self.lines[1].Pb and not self.lines[2].Pb and not self.lines[4].Pb) then
				self.vi = 0
			end
			if (self.lines[2].Pb and self.lines[4].Pb) then
				self.vi = 0
			end
			self.vi1 = (self.vi + 190*(1/60))
			self.y = self.y + (self.vi + self.vi1)/2*(1/60)
			self.vi = self.vi1

		end,

		move = function(self)
			self.vi1 = (self.vi + 190*(1/60))
			self.vi = self.vi1
			if self.vi > 230 then
				self.vi = 0
			end
			self.collider:setLinearVelocity(self.vx, self.vi)
		end,

		jcoll = function(self, lines)
			if self.lines[1].Pb and self.lines[2].Pb then
				self.line5 = gE.Line(self.center[1], self.center[2], self.x + self.sx, self.y)
				self.line5:init()
				for i = 1, #lines do
					if gE.mathlines(self.line5, lines[i]) then
						if lines[i].x - lines[i].dx == 0 then
							self.x = lines[i].x - self.sx
						else
							self.y = lines[i].y
						end
						self.lines[1].Pb, self.peres[1], self.lines[2].Pb, self.peres[2] = false, nil, false, nil
					end
				end
			end
			if self.lines[1].Pb and self.lines[4].Pb then
				self.line5 = gE.Line(self.center[1], self.center[2], self.x, self.y)
				self.line5:init()
				for i = 1, #lines do
					if gE.mathlines(self.line5, lines[i]) then
						if lines[i].x - lines[i].dx == 0 then
							self.x = lines[i].x
						else
							self.y = lines[i].y
						end
						self.lines[1].Pb, self.peres[1], self.lines[4].Pb, self.peres[4] = false, nil, false, nil
					end
				end
			end
			if self.lines[3].Pb and self.lines[2].Pb then
				self.line5 = gE.Line(self.center[1], self.center[2], self.x + self.sx, self.y + self.sy)
				self.line5:init()
				for i = 1, #lines do
					if gE.mathlines(self.line5, lines[i]) then
						if lines[i].x - lines[i].dx == 0 then
							self.x = lines[i].x - self.sx
						else
							self.vi = 0
							self.y = lines[i].y - self.sy
						end
						--self.lines[3].Pb, self.peres[3], self.lines[2].Pb, self.peres[2] = false, nil, false, nil
					end
				end
			end
			if self.lines[3].Pb and self.lines[4].Pb then
				self.line5 = gE.Line(self.center[1], self.center[2], self.x, self.y + self.sy)
				self.line5:init()
				for i = 1, #lines do
					if gE.mathlines(self.line5, lines[i]) then
						if lines[i].x - lines[i].dx == 0 then
							self.x = lines[i].x
						else
							self.vi = 0
							self.y = lines[i].y - self.sy
						end
						self.lines[3].Pb, self.peres[3], self.lines[4].Pb, self.peres[4] = false, nil, false, nil
					end
				end
			end
		end,

		plantcoll = function(self)
			if (self.lines[2].Pb and self.lines[4].Pb) and not (self.lines[1].Pb) then
				if self.lines[2].Pb and self.peres[2][1][2] >= (self.y + self.sy / 2) then
					--if (self.peres[2][2] + self.peres[4][2]) / 2 >= (self.y + self.sy / 2) then
					self.y = self.peres[2][1][2] - self.sy
					--self.peres[2] = nil
					--self.lines[2].Pb = false
				elseif self.lines[2].Pb then
					self.y = self.peres[2][1][2]
					--self.peres[2] = nil
					--self.lines[2].Pb = false
				end
				if self.lines[4].Pb and self.peres[4][1][2] >= (self.y + self.sy / 2) then
					self.y = self.peres[4][1][2] - self.sy
					--self.peres[4] = nil
					--self.lines[4].Pb = false
				elseif self.lines[4].Pb then
					self.y = self.peres[4][1][2]
					--self.peres[4] = nil
					--self.lines[4].Pb = false
				end
				self:update()
			end
		end
	}
end

function Gmr.peres(line1, line2)
    if (line1.a - line2.a) == 0 then
        x = ((line2.b - line1.b) / 0.01)
    else
        x = ((line2.b - line1.b) / (line1.a - line2.a))
    end
    y = ((line1.a*x) + line1.b)

    return x, y
end

return Gmr
