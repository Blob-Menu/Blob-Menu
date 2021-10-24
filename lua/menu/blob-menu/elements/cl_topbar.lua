
surface.CreateFont("Menu:Topbar", {
    font = "Poppins",
    size = 32
})

surface.CreateFont("Menu:Logo", {
    font = "Coolvetica",
    size = 72
})

local PANEL = {}

function PANEL:Init()
    self.buttons = {}
    self.buttons_by_name = {}
    -- self:AddButton("singleplayer", print)
    -- self:AddButton("multiplayer", print)
    -- self:AddButton("options", print)
end

function PANEL:PaintOver(w, h)
    local t = self:GetParent():GetActivePage()
    if not IsValid(t) then return end
    local b = self.buttons_by_name[self:GetParent().moveto or t.name]

    self.barx = Lerp(FrameTime() * 10, self.barx or b:GetX(), b:GetX())
    self.barw = Lerp(FrameTime() * 10, self.barw or b:GetWide(), b:GetWide())

    surface.SetDrawColor(menu.colors.active_underline)
    surface.DrawRect(self.barx + 2, h - 6, self.barw - 4, 4)
end

function PANEL:PerformLayout(w, h)
    local curw = h
    self:DockPadding(h, 0, 0, 0)
    surface.SetFont("Menu:Topbar")
    for k,v in ipairs(self.buttons) do
        local tw = surface.GetTextSize(v.text)
        v:Dock(LEFT)
        v:SetWide(math.max(tw + 40, 110))
        curw = curw + v:GetWide()
    end

    self.btnw = curw
end

function PANEL:AddButton(name, doclk)
    local btn = vgui.Create("DButton", self)
    btn.DoClick = doclk
    btn.text = name:upper()
    btn:SetFont("Menu:Topbar")
    btn:SetText("")

    table.insert(self.buttons, btn)
    self.buttons_by_name[name] = btn

    function btn:Paint(w,h)
        -- if self.active then
        --     surface.SetDrawColor(menu.colors.topbar_active)
        --     surface.DrawRect(2,h - 6,w - 4,4)
        -- end
        draw.Text({
            text = self.text,
            pos = {w / 2, h / 2 + 2},
            font = "Menu:Topbar",
            color = menu.colors.text,
            xalign = 1,
            yalign = 1
        })
    end
end

function PANEL:Paint(w,h)
    draw.NoTexture()

    surface.SetDrawColor(menu.colors.accent1)
    surface.DrawRect(0, 0, self.btnw, h)

    surface.DrawPoly({
        {x = self.btnw, y = h},
        {x = self.btnw, y = 0},
        {x = self.btnw + h * 2, y = 0}
    })

    draw.Text({
        text = "g",
        font = "Menu:Logo",
        pos = {
            h / 2,
            h / 2 - 4
        },
        xalign = 1,
        yalign = 1,
        color = menu.colors.text
    })
end

vgui.Register("Menu:Topbar", PANEL, "Panel")

menu.Refresh()
