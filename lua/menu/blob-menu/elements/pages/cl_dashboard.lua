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
    self.center.buttons:SetTall(IsInGame() and 50 or 0)

    function self.center.buttons:AddButton(text, on, show_ingame)
        local b = vgui.Create("DButton", s)
        b:SetText("")
        b:SetVisible(IsInGame())
        b.DoClick = on
        b.ShowIngame = show_ingame

        function b:Paint(w, h)
            local hov = self:IsHovered()
            self.olwid = Lerp(FrameTime() * 10, self.olwid or 0, hov and h or 0)
            self.textcol = menu.LerpColor(FrameTime() * 10, self.textcol or menu.colors.text, hov and menu.colors.text or menu.colors.accent2)

            surface.SetDrawColor(menu.colors.accent1)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            surface.SetDrawColor(menu.colors.accent2)
            surface.DrawRect(0, h - self.olwid, w, h)

            local tw = draw.Text({
                text = text,
                pos = {w / 2, h / 2 + 2},
                font = "Menu:Dashboard:Buttons",
                xalign = 1,
                yalign = 1,
                color = self.textcol
            })

            tw = tw + 20
            if self.textw != tw then
                self.textw = tw
                self:SetWide(self.textw)
            end
        end

        return b
    end

    self.center.buttons:AddButton("Disconnect", function()
        RunGameUICommand("disconnect")
    end, true)
    self.center.buttons:AddButton("Resume", gui.HideGameUI, true)

    function self.center.buttons:InGameChanged(t)
        self:SetTall(t and 50 or 0)

        for k,v in pairs(self:GetChildren()) do
            v:SetVisible((v.show_ingame and t) or false)
        end
    end

    function self.center.buttons:PerformLayout(w, h)
        for k,v in pairs(self:GetChildren()) do
            v:Dock(LEFT)
        end
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
