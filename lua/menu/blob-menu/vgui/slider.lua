
surface.CreateFont("Menu:SliderValue", {
    font = "Poppins",
    size = 30
})

local PANEL = {}
AccessorFunc(PANEL, "slider_fill", "SliderFill")

function PANEL:Init()
    self:SetMax(0, 255)
    self:SetSliderFill(Color(255, 41, 41))
    self:SetColors(color_white, Color(255, 0, 0))
    self:SetCursor("hand")
end

function PANEL:PerformLayout(w, h)
    self.pad = 10
    self.size = h - (self.pad / 2) * 2
    self.drawx = self.pad / 4 + (w - self.size - self.pad / 2) * self.val
    self.slider_grip = menu.LerpColor(self.val, self.fromcol, self.tocol)
end

function PANEL:SetMax(min, max)
    self.max = max
    self.val = 0
end

function PANEL:SetColors(from, to)
    self.fromcol = from
    self.tocol = to
end

function PANEL:SetValue(v)
    self.val = v / self.max
end

function PANEL:OnChange(val)

end

local rg = Material("vgui/gradient-r")
local lg = Material("vgui/gradient-l")
function PANEL:Paint(w, h)
    local pad = self.pad
    local pad2 = pad / 2
    local size = self.size
    local x = self.drawx

    draw.RoundedBoxEx(6, pad + x, pad, w - pad * 2 - x, h - pad * 2, menu.colors.text, false, true, false, true)
    draw.RoundedBoxEx(6, pad, pad, x, h - pad * 2, self:GetSliderFill(), true, false, true)

    surface.SetDrawColor(0, 0, 0, 50)
    surface.SetMaterial(rg)
    surface.DrawTexturedRect(math.max(x - 5, pad), pad, 5, h - pad * 2)
    surface.SetMaterial(lg)
    surface.DrawTexturedRect(math.min(x + size, w - pad), pad, 5, h - pad * 2)

    draw.RoundedBox(6, x, pad2, size, size, self.slider_grip, true, true)

    if not self.dragging then return end
    local oc = DisableClipping(true)

    local xx,yy = self:LocalCursorPos()
    draw.Text({
        text = math.ceil(self.val * self.max),
        pos = {xx, yy - 20},
        xalign = 1,
        yalign = 1,
        color = menu.colors.text,
        font = "Menu:SliderValue"
    })

    DisableClipping(oc)
end

function PANEL:OnMousePressed(m)
    if m == MOUSE_LEFT then
        self.dragging = true
        self:MouseCapture(true)

        self:OnCursorMoved(self:LocalCursorPos())

        self:SetCursor("sizewe")
    end
end

function PANEL:OnMouseReleased(m)
    if m == MOUSE_LEFT then
        self.dragging = false
        self:MouseCapture(false)
    end

    self:SetCursor("hand")
end

function PANEL:OnCursorMoved(x, y)
    if not self.dragging then return end
    self.val = math.Clamp(x / self:GetWide(), 0, 1)
    self:OnChange(self.max * self.val)
end

function PANEL:Think()
    local w = self:GetWide()
    if not self.x or not self.pad then return end
    self.drawx = Lerp(FrameTime() * 10, self.drawx, self.pad / 4 + (w - self.size - self.pad / 2) * self.val)
    self.slider_grip = menu.LerpColor(FrameTime() * 10, self.slider_grip or self.fromcol, menu.LerpColor(self.val, self.fromcol, self.tocol))
end

vgui.Register("Menu:Slider", PANEL, "Panel")
