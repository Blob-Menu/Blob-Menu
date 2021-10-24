
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

function PANEL:OnChanged(id)
    if not IsValid(menu.multiplayer.top) then return end
    menu.multiplayer:ShowBackButton(id)
end

-- Generations
function PANEL:Generate_internet()
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local gms = self.tabs:AddTab("gamemodes", "Menu:Pages:Multiplayer:GamemodesList")
    local svs = self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    local act = self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    serverlist.Query({
        Type = "internet",
        Callback = function(...)
            if not IsValid(gms) then return false end
            gms.QueryCallback(gms, self, ...)
        end
    })

    function self.tabs.OnChanged(s, t)
        menu.multiplayer:ShowBackButton("internet", self:TestBack(t))
    end

    function self:TestBack(t)
        return (t == "gamemodes" and false) or (t == "servers" and true) or (t == "activeserver")
    end

    function self:DoBack(t)
        local tab = (t or self.tabs:GetActiveTab().id)
        local back = self:TestBack(t)

        if tab == "gamemodes" then return back end
        if tab == "servers" then self.tabs:SetTab("gamemodes", true) return back end
        if tab == "activeserver" then self.tabs:SetTab("servers", true) return back end
    end
end

function PANEL:Generate_lan()
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local svs = self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    local act = self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    function self.tabs:OnChanged()
        menu.multiplayer:ShowBackButton("lan", true)
    end

    serverlist.Query({
        Type = "lan",
        Callback = function(...)
            print(...)
            local args = serverlist.Args2Table(...)
            svs:AddButton(args)

            self.loading = false
        end
    })
end

-- function PANEL:Generate_history(tab)
--     self.tabs = vgui.Create("Menu:Tabs", self)
--     self.tabs:Dock(FILL)

--     self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
--     self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

--     serverlist.Query({
--         Type = "history",
--         Callback = function(...)
--             local args = serverlist.Args2Table(...)
--             print(args)
--         end
--     })
-- end

vgui.Register("Menu:Pages:Multiplayer:Gamemodes", PANEL, "Menu:Tabs")