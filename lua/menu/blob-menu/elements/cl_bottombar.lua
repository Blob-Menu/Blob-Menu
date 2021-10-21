
surface.CreateFont("Menu:BottomBarButtons", {
    font = "Poppins",
    size = 30
})

local PANEL = {}

function PANEL:Init()
    menu.bottombar = self

    self.tabs = vgui.Create("Menu:Tabs", self)
    self.used_tabs = {}

    menu.AddBottomBarTab("main", {
        {
            name = "EXIT",
            onclick = function()
                RunGameUICommand("quit")
            end
        }
    })
end

function PANEL:PerformLayout(w,h)
    self.tabs:SetSize(w,h)
    self.tabs:SetPos(0,0)
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

function menu.PushBottomBarTab(name)
    table.insert(menu.bottombar.used_tabs, name)
    menu.bottombar.tabs:SetTab(name)
end

function menu.PopBottomBarTab()
    menu.bottombar.tabs:SetTab(menu.bottombar.used_tabs[#menu.bottombar.used_tabs - 1] or "main")
    table.remove(menu.bottombar.used_tabs, 1)
end

function menu.AddBottomBarTab(name, buttons)
    local tab = menu.bottombar.tabs:AddTab(name)

    for k,v in ipairs(buttons) do
        local btn = vgui.Create("DButton", tab)
        btn:SetText("")
        btn.item = v
        btn.DoClick = v.onclick

        function btn:Paint(w,h)
            if self:IsHovered() then
                self.curY = Lerp(FrameTime() * 10, self.curY or -2, -2)
            else
                self.curY = Lerp(FrameTime() * 10, self.curY or h + 2, h + 2)
            end

            surface.SetDrawColor(menu.colors.accent1)
            surface.DrawRect(0, self.curY, w, h)

            draw.Text({
                text = v.name,
                pos = {w / 2, h / 2},
                font = "Menu:BottomBarButtons",
                xalign = 1,
                yalign = 1
            })
        end
    end

    function tab:PerformLayout(w,h)
        surface.SetFont("Menu:BottomBarButtons")
        for k,v in pairs(self:GetChildren()) do
            v:SetSize(select(1, surface.GetTextSize(v.item.name)) + (v.item.pad or 100), h)
        end
    end
end