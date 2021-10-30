
local PANEL = {}

function PANEL:Init()
    self:GetVBar():SetHideButtons(true)
    self:GetVBar():SetWide(10)
    self:GetVBar():DockMargin(0, 5, 0, 5)

    -- self.placeholder = vgui.Create("Panel", self)
    -- self.placeholder:Dock(TOP)

    -- function self.placeholder.Paint(s, w, h)
    --     if not self.adds then return end
    --     self.viewamt = (self.viewamt or 0) + 1

    --     if self.viewamt <= 20 then return end

    --     self.viewamt = 0
    --     self:LoadMore(amt)
    -- end

    self:GetVBar().Paint = self.BarPaint
    self:GetVBar().btnGrip.Paint = self.GripPaint
end

-- TODO: Fix this
-- function PANEL:OnMouseWheeled(d)
--     self.curscroll = self.curscroll - (d * 30)
-- end

-- function PANEL:Think()
--     self.curscroll = self.curscroll or 0
--     self:GetVBar():SetScroll(Lerp(FrameTime() * 20, self:GetVBar():GetScroll(), self.curscroll))
-- end

function PANEL:AddPadding()
    local pad = vgui.Create("Panel", self)
    pad:Dock(TOP)
    pad:SetTall(84)

    return pad
end

function PANEL:BarPaint(w,h)
    draw.RoundedBox(4, 0, 0, w, h, menu.colors.background)
end

function PANEL:GripPaint(w,h)
    draw.RoundedBox(4, 1, 1, w - 2, h - 2, menu.colors.accent1)
end

function PANEL:AddLater(func)
    self.adds = self.adds or {}
    table.insert(self.adds, func)
end

function PANEL:LoadMore(am)
    for i = 1, am do
        if not self.adds[1] then break end

        self.adds[1](self)
        table.remove(self.adds, 1)
    end
end

vgui.Register("Menu:Scroll", PANEL, "DScrollPanel")

hook.Run("Menu:ScrollDone")