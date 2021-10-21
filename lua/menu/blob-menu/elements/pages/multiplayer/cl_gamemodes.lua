
surface.CreateFont("Menu:ServerInfo", {
    font = "Poppins",
    size = 25,
})

surface.CreateFont("Menu:ServerName", {
    font = "Poppins",
    size = 35,
})

surface.CreateFont("Menu:CurrentlyUnimpl", {
    font = "Poppins",
    size = 100,
})

local PANEL = {}

function PANEL:Init()
    self.created = {}

    self:GenerateTab("internet")
end

function PANEL:GenerateTab(type)
    if self.created[type] then
        self:SetTab(type)
        return
    end

    local tab = self:AddTab(type)
    if self["Generate_" .. type] then
        self["Generate_" .. type](tab)
        self.created[type] = true
    else
        tab.Paint = function(s,w,h)
            surface.SetDrawColor(menu.colors.accent2)
            surface.DrawRect(0,0,w,h)
            draw.Text({
                text = "CURRENTLY UNIMPLEMENTED, SORRY",
                pos = {w / 2, h / 2},
                font = "Menu:CurrentlyUnimpl",
                xalign = 1,
                yalign = 1,
                color = ColorAlpha(menu.colors.background, 150)
            })
        end
    end
    self:SetTab(type)
end

-- Generations
function PANEL:Generate_internet(tab)
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local gms = self.tabs:AddTab("gamemodes", "Menu:Pages:Multiplayer:GamemodesList")
    self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    serverlist.Query({
        Type = "internet",
        Callback = function(...)
            if not IsValid(gms) then return false end
            gms.QueryCallback(gms, self, ...)
        end
    })

    menu.AddBottomBarTab("back-server", {
        {
            name = "BACK",
            onclick = function()
                self.tabs:SetTab("gamemodes")
                menu.PopBottomBarTab()
            end
        }
    })
    menu.AddBottomBarTab("back-server-list", {
        {
            name = "BACK",
            onclick = function()
                self.tabs:SetTab("servers")
                menu.PopBottomBarTab()
            end
        }
    })
end

vgui.Register("Menu:Pages:Multiplayer:Gamemodes", PANEL, "Menu:Tabs")