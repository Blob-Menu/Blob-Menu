surface.CreateFont("Menu:Dashboard:Name", {
    font = "Coolvetica",
    size = 162
})

surface.CreateFont("Menu:Dashboard:Buttons", {
    font = "Poppins",
    size = 50
})


local PANEL = {}

function PANEL:Paint(w,h)
    draw.Text({
        text = self.time_text or "",
        pos = {w - 40, 40},
        xalign = 2,
        yalign = 1,
        color = menu.colors.text,
        font = "Menu:Topbar"
    })
end

function PANEL:Init()
    self.center = vgui.Create("Panel", self)

    self.center.logo = vgui.Create("Panel", self.center)
    self.center.logo:SetTall(100)
    self.center.logo:Dock(TOP)
    function self.center.logo:Paint(w, h)
        local ww, th = draw.Text({
            text = "garry's mod",
            pos = menu.config.moving_garrysmod and {math.cos(CurTime() * 4) * 1, h / 2 + math.sin(CurTime() * 5) * 2} or {0, h / 2},
            xalign = 0,
            yalign = 1,
            font = "Menu:Dashboard:Name"
        })

        th = th + 20
        if self.texth != th then
            self.texth = th
            self:SetSize(ww, th)
        end
    end

    self.center.buttons = vgui.Create("Panel", self.center)
    self.center.buttons:Dock(TOP)
    self.center.buttons:SetTall(0)
    self.center.buttons.resume = vgui.Create("DButton", self.center.buttons)
    self.center.buttons.resume:SetText("")
    self.center.buttons.resume:SetVisible(false)
    self.center.buttons.resume.DoClick = gui.HideGameUI

    function self.center.buttons.resume:Paint(w, h)
        if self:IsHovered() then
            self.olwid = Lerp(FrameTime() * 10, self.olwid or h / 2 + 2, h / 2 + 2)
        else
            self.olwid = Lerp(FrameTime() * 10, self.olwid or 2, 2)
        end

        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawOutlinedRect(0, 0, w, h, self.olwid)

        local tw = draw.Text({
            text = "Resume",
            pos = {w / 2, h / 2 + 2},
            font = "Menu:Dashboard:Buttons",
            xalign = 1,
            yalign = 1,
            color = menu.colors.text
        })

        tw = tw + 20
        if self.textw != tw then
            self.textw = tw
            self:SetWide(self.textw)
        end
    end

    function self.center.buttons:InGameChanged(t)
        self:SetTall(t and 50 or 0)
        self.resume:SetVisible(t)
    end

    function self.center.buttons:PerformLayout(w, h)
        self.resume:SetTall(h)
        self.resume:Dock(LEFT)
    end
end

function PANEL:Think()
    local ot = self.time
    self.time = os.time()

    if ot != self.time then
        self.time_text = os.date("%A, %B %d | %I:%M:%S %p", self.time)
    end
end

function PANEL:PerformLayout(w,h)
    self.center:SetPos(80, h / 2 - self.center:GetTall() / 2)
    self.center:SizeToChildren(true, true)
end

vgui.Register("Menu:Page:Dashboard", PANEL, "Panel")
menu.Refresh()
