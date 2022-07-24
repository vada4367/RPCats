local gE = require("engine")

Gmr = {}

function Gmr.Gamer()
	return {
		x = 100,
		y = 100,
		sx = 100,
		sy = 200,
		line1 = nil,
		line2 = nil,
		line3 = nil,
		line4 = nil,
		lines = nil,
		peres = nil,
		peresx = nil,
		peresy = nil,
		vi = 0,
		vi1 = nil,

		init = function(self)
			self.line1:init()
			self.line2:init()
			self.line3:init()
			self.line4:init()
			self.lines = {self.line1, self.line2, self.line3, self.line4}
		end,

		update = function(self)
			self.line1 = gE.Line(self.x, self.y, (self.x + self.sx), self.y)
			self.line2 = gE.Line(self.x + self.sx, self.y, self.x + self.sx, self.y + self.sy)
			self.line3 = gE.Line(self.x + self.sx, self.y + self.sy, self.x, self.y + self.sy)
			self.line4 = gE.Line(self.x, self.y + self.sy, self.x, self.y)
			self:init()
		end,

		collision = function(self, lines)
			self.peres = {}
			self.peresx = 0
			self.peresy = 0
			for i = 1, #self.lines do
				if gE.mathlines(self.lines[i], lines[1]) then
					x, y = Gmr.peres(self.lines[i], lines[1])
					
					if x ~= nil and y ~= nil then
						self.peres[#self.peres + 1] = {x, y}
					end
				else do
					print("OMG")
				end
				end
			end
		end,

		fall = function(self)
			self.vi1 = (self.vi + 190*(1/60))
			self.y = self.y + (self.vi + self.vi1)/2*(1/60)
			self.vi = self.vi1
		end
	}
end

function Gmr.peres(line1, line2)
    if (line1.a - line2.a) == 0 then
        x = ((line2.b - line1.b) / 0.01)
    else do
        x = ((line2.b - line1.b) / (line1.a - line2.a))
    end
    end
    y = ((line1.a*x) + line1.b)

    return x, y
end

return Gmr