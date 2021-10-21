

surface.CreateFont("Menu:MapText", {
    font = "Poppins",
    size = 30
})

local incompat = Material("../html/img/incompatible.png")
local amtperline = 8
local PANEL = {}

function PANEL:Init()
    self.list = vgui.Create("Menu:List", self)
    self.tabs = vgui.Create("Menu:Tabs", self)

    self:GenerateTabs()

    self.list:AddButton("Step 1: Choose Map", function()
        self:SetTab(1)
    end )
    self.list:AddButton("Step 2: Pick Gamemode", function()
        self:SetTab(2)
    end )
    self.list:AddButton("Step 3: Change Options", function()
        self:SetTab(3)
    end )
    self.list:AddButton("Step 4: Create", function()
        self:SetTab(4)
    end )

    self.selected_map = cookie.GetString("blob_menu_selected_map",  "gm_flatgrass")
    self.selected_gamemode = engine.GetGamemodes()[2]
end

function PANEL:SetTab(i)
    self.tabs:SetTab(i)
end

function PANEL:PerformLayout()
    self:DockPadding(0, 80, 300, 80)
    self.list:Dock(LEFT)
    self.list:SetWide(300)
    self.tabs:Dock(FILL)
    self.tabs:DockMargin(4,4,4,4)

    function self.tabs.PerformLayout(s, w, h)
        for k,v in pairs(s.tabs) do
            v:SetSize(w, h)
        end

        for k,v in pairs(self.maps.scroll:GetCanvas():GetChildren()) do
            v:SetTall(w / amtperline)

            for _,_ in pairs(v:GetChildren()) do
                v:SetWide(w / amtperline)
            end
        end
    end
end

function PANEL:GenerateTabs()
    -- Step 1: Choose Map
    local maps = self.tabs:AddTab(1)
    maps.scroll = vgui.Create("Menu:Scroll", maps)
    maps.scroll:Dock(FILL)
    self.maps = maps

    local cur
    for cat, mapss in pairs(menu.maplist or {}) do
        surface.SetFont("Menu:MapText")
        local tw, th = surface.GetTextSize(cat)
        for _,map in ipairs(mapss) do
            if not cur or cur.amt >= amtperline then
                cur = vgui.Create("Panel", maps.scroll)
                cur:Dock(TOP)
                cur.amt = 0
            end

            local p = vgui.Create("DButton", cur)
            p:Dock(LEFT)
            p:SetText("")
            p.map = map

            function p.DoClick()
                self.selected_map = map
                cookie.Set("blob_menu_selected_map", map)
            end

            function p.Paint(s,w,h)
                if self.selected_map == s.map then
                    surface.SetDrawColor(menu.colors.accent1)
                    surface.DrawRect(0,0,w,h)
                end

                surface.SetDrawColor(color_white)
                surface.SetMaterial(incompat)
                surface.DrawTexturedRect(4, 4, w - 8, h - 8)

                draw.RoundedBoxEx(6, w - tw - 14, h - th - 14, tw + 10, th + 10, menu.colors.accent2, true)

                draw.Text({
                    text = cat,
                    pos = {w - 8, h - 8},
                    xalign = 2,
                    yalign = 4,
                    font = "Menu:MapText",
                    color = menu.colors.text
                })

                draw.RoundedBoxEx(6, 0, 0, w, th, menu.colors.accent2, false, false, true, true)
            end

            cur.amt = cur.amt + 1
        end
    end

    local gm = self.tabs:AddTab(2)
    gm.select = vgui.Create("Menu:List", gm)
    gm.select:SetWide(300)
    gm.select:Dock(LEFT)

    for k,v in pairs(engine.GetGamemodes()) do
        if k == 1 then continue end
        gm.select:AddButton(v.title, function()
            self.selected_gamemode = v
        end )
    end

    self.tabs:AddTab(3)
    self.tabs:AddTab(4)
end

vgui.Register("Menu:Page:Singleplayer", PANEL, "Panel")

menu.Refresh(1)
