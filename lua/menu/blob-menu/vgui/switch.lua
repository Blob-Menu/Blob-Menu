
local PANEL = {}

function PANEL:Init()
    self.on = false
    self:SetText('')

    self.onbg = Color(77, 212, 77)
    self.offbg = Color(255, 70, 70)

    self.onbtn = Color(255, 255, 255)
    self.offbtn = Color(255, 255, 255)
end

function PANEL:SetValue(val)
    self.on = val
end

function PANEL:GetValue()
    return self.on
end

function PANEL:DoClick()
    self:SetValue(!self:GetValue())
    self:OnChange(self:GetValue())
end

function PANEL:OnChange(val)

end

function PANEL:Paint(w,h)
    local ft = FrameTime() * 10
    if self.on then
        self.btnx = Lerp(ft, self.btnx or w - h, w - h)
        self.bg = menu.LerpColor(ft, self.bg or self.onbg, self.onbg)
        self.btn = menu.LerpColor(ft, self.btn or self.onbtn, self.onbtn)
    else
        self.btnx = Lerp(ft, self.btnx or 2, 2)
        self.bg = menu.LerpColor(ft, self.bg or self.offbg, self.offbg)
        self.btn = menu.LerpColor(ft, self.btn or self.offbtn, self.offbtn)
    end

    draw.RoundedBox(6, 0, 0, w, h, self.bg)
    draw.RoundedBox(6, self.btnx, 2, h - 4, h - 4, self.btn)
end

vgui.Register("Menu:Switch", PANEL, "DButton")

-- menu.TestPanel(function(p)
--     local f = vgui.Create("Menu:Switch", p)
--     f:SetSize(70, 30)
--     f:Center()
-- end )