
surface.CreateFont("Menu:BottomBarButtons", {
    font = "Poppins",
    size = 30
})

local PANEL = {}

function PANEL:Init()
    menu.bottombar = self
    self.buttons = {}

    self:AddButton("exit", function()
        RunGameUICommand("Quit")
    end)

    self:AddButton("report a bug", function()
        gui.OpenURL("https://github.com/Blob-Menu/Blob-Menu/issues/new?assignees=&labels=bug&template=bug_report.md&title=")
    end )
end

function PANEL:AddButton(title, click)
    title = title:upper()
-- 

    local b = vgui.Create("DButton", self)
    b:SetText("")
    b.DoClick = click

    function b:Paint(w,h)
        self.curY = Lerp(FrameTime() * 10, self.curY or h + 2, self:IsHovered() and -2 or h + 2)

        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(0, self.curY, w, h)

        local tw = draw.Text({
            text = title,
            pos = {w / 2, h / 2},
            font = "Menu:BottomBarButtons",
            xalign = 1,
            yalign = 1
        })

        if self.textW != tw then
            self.textW = tw

            self:SetWide(tw + 60)
        end
    end

    self.buttons[title] = b
end

function PANEL:PerformLayout(w,h)
    surface.SetFont("Menu:BottomBarButtons")

    for k,v in pairs(self.buttons) do
        v:Dock(LEFT)
        v:SetTall(h)
    end
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