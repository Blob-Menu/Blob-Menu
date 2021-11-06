
local PANEL = {}
AccessorFunc(PANEL, "stc", "SizeToChildren")

function PANEL:Init()
    self.r = vgui.Create("Menu:Slider", self)
    self.g = vgui.Create("Menu:Slider", self)
    self.b = vgui.Create("Menu:Slider", self)

    self.g:SetSliderFill(Color(41, 255, 41))
    self.b:SetSliderFill(Color(41, 41, 255))

    self.g:SetColors(color_white, Color(0, 255, 0))
    self.b:SetColors(color_white, Color(0, 0, 255))

    self.display = vgui.Create("Panel", self)
    function self.display.Paint(s, w, h)
        draw.RoundedBox(4, 10, 0, w - 20, h, s.color)
    end

    self:SetColor(menu.colors.accent1)

    self.r.OnChange = function(s, v) self:SliderChange(s, "r", v) end
    self.g.OnChange = function(s, v) self:SliderChange(s, "g", v) end
    self.b.OnChange = function(s, v) self:SliderChange(s, "b", v) end
end

function PANEL:SliderChange(slider, key, val)
    self.display.color[key] = val
end

function PANEL:PerformLayout(w, h)
    for k,v in pairs(self:GetChildren()) do
        v:DockMargin(0, 0, 0, 10)
        v:Dock(TOP)
        v:SetTall(40)
    end

    self.display:Dock(RIGHT)
    self.display:SetZPos(-10)
    self.display:SetWide(40)
    self.display:DockMargin(0,0,0,0)

    if self.stc and self.oh != h then
        self:SizeToChildren(false, true)
        self.oh = h
    end
end

function PANEL:SetColor(col)
    col = table.Copy(col)

    self.r:SetValue(col.r)
    self.g:SetValue(col.g)
    self.b:SetValue(col.b)

    self:OnChangeInternal(col)
end

function PANEL:OnChangeInternal(col)
    self.display.color = col
end

function PANEL:OnChange(col)

end

vgui.Register("Menu:ColorPicker", PANEL, "Panel")

-- menu.TestPanel(function(p)
--     local f = vgui.Create("Menu:ColorPicker", p)
--     f:SetSize(400, 400)
--     f:Center()
--     f:SetSizeToChildren(true)
-- end )