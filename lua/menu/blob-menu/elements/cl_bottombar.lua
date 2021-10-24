
surface.CreateFont("Menu:BottomBarButtons", {
    font = "Poppins",
    size = 30
})

local PANEL = {}

function PANEL:Init()
    menu.bottombar = self

    self.exit = vgui.Create("DButton", self)
    self.exit:SetText("")

    function self.exit:DoClick()
        RunGameUICommand("Quit")
    end

    function self.exit:Paint(w,h)
        self.curY = Lerp(FrameTime() * 10, self.curY or h + 2, self:IsHovered() and -2 or h + 2)

        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(0, self.curY, w, h)

        draw.Text({
            text = "EXIT",
            pos = {w / 2, h / 2},
            font = "Menu:BottomBarButtons",
            xalign = 1,
            yalign = 1
        })
    end
end

function PANEL:PerformLayout(w,h)
    surface.SetFont("Menu:BottomBarButtons")

    self.exit:SetSize(select(1, surface.GetTextSize("EXIT")) + 100, h)
end

function PANEL:Paint(w,h)
    local oc = DisableClipping(true)
    surface.SetDrawColor(menu.colors.shadow)
    surface.SetMaterial(menu.materials.up)
    surface.DrawTexturedRect(0, -5, w, 5)
    DisableClipping(oc)

    surface.SetDrawColor(menu.colors.bottom_bg)
    surface.DrawRect(0,0,w,h)
end

vgui.Register("Menu:Bottombar", PANEL, "Panel")
menu.Refresh()