gE = {}

function gE.Line(x, y, dx, dy)
    return {
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        vect = nil,
        a = nil,
        b = nil,
        vect1 = nil,
        vect2 = nil,
        l1 = nil,
        l2 = nil,
        L = nil,
        Lb = nil,

        init = function(self)
            self.vect = {dx - x, dy - y}
            if (dx - x) == 0 then
                self.a = ((dy - y) / (dx - x + 0.01))
            else do
                self.a = ((dy - y) / (dx - x))
            end
            end
            self.b = (y - (self.a*x))
        end,

        mathvect = function(self, line)
            self.vect1 = {line.x - x, line.y - y}
            self.vect2 = {line.dx - x, line.dy - y}
        end,

        mathl = function(self)
            self.l1 = (self.vect[1] * self.vect1[2]) - (self.vect1[1] * self.vect[2])
            self.l2 = (self.vect[1] * self.vect2[2]) - (self.vect[2] * self.vect2[1])
        end,

        mathL = function(self)
            self.L = self.l1 * self.l2
            self.Lb = self.L < 0
        end
    }
end

function gE.mathlines(line1, line2)
    line2:mathvect(line1)
    line2:mathl()
    line2:mathL()
    line1:mathvect(line2)
    line1:mathl()
    line1:mathL()
    if line1.Lb and line2.Lb then
        return true
    else do
        return false
    end
    end
end


function gE.peres(line1, line2)
    local x = ((line2.b - line1.b) / (line1.a - line2.a))
    local y = ((line1.a*x) + line1.b)
    print(x .. " " .. y)
end

return gE