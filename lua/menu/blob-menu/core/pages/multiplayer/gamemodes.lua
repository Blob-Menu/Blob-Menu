
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

function PANEL:Refresh()
    local act = self:GetActiveTab()
    local id = act.id
    if not id then
        print("No ID")
        print(act, self)
        return
    end
    act:Remove()
    self.created[id] = false

    self:GenerateTab(id)
    self:SetTab(id, true)

    menu.multiplayer:ShowBackButton(id, false)
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
    self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    serverlist.Query({
        Type = "internet",
        Callback = function(...)
            if not IsValid(gms) then return false end
            gms.QueryCallback(gms, self, ...)
        end
    })

    function self.tabs.OnChanged(s, t)
        local ss = self:TestBack(t)
        menu.multiplayer:ShowBackButton("internet", ss)
        menu.multiplayer:ShowSearch("internet", t == "servers")
    end

    function self:TestBack(t)
        return (t == "gamemodes" and false) or (t == "servers" and true) or (t == "activeserver")
    end

    function self:DoBack(t)
        local tab = (t or self.tabs:GetActiveTab().id)
        local back = self:TestBack(tab)

        menu.multiplayer:ShowBackButton("internet", back)

        if tab == "servers" then self.tabs:SetTab("gamemodes") end
        if tab == "activeserver" then self.tabs:SetTab("servers") end
    end

    function self:DoSearch(txt)
        if txt == "" then
            for k,v in pairs(svs.buttons) do
                if not IsValid(v) then continue end
                v:SetVisible(true)
            end
            gms.searching = false
            return
        end

        gms.searching = txt
        local names = {}
        for k,v in pairs(svs.buttons) do
            if not IsValid(v) then continue end
            table.insert(names, {v.values[1].name, v})
            v:SetVisible(false)
        end

        local sear = menu.search.Search(names, txt, function(s)
            return s[1]
        end )
        for k,v in pairs(sear) do
            if v.match >= 0.3 then
                v.target[2]:SetVisible(true)
            end
        end
    end
end

function PANEL:Generate_lan()
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local svs = self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    local act = self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    function self.tabs:OnChanged(t)
        menu.multiplayer:ShowBackButton("lan", t == "activeserver")
        menu.multiplayer:ShowSearch("lan", false)
    end

    function svs.DoClick(s, args)
        act:UpdateServer(args, menu.serverinfo_lan_default)
        self.tabs:SetTab("activeserver")
    end

    serverlist.Query({
        Type = "lan",
        Callback = function(...)
            local args = serverlist.Args2Table(...)
            svs:AddButton(args)

            svs.loading = false
        end
    })

    function self:DoBack(t)
        menu.multiplayer:ShowBackButton("lan", false)
        self.tabs:SetTab("servers")
        return false
    end
end

function PANEL:Generate_history(tab)
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local svs = self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    local act = self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    function self.tabs:OnChanged(t)
        menu.multiplayer:ShowBackButton("history", t == "activeserver")
        menu.multiplayer:ShowSearch("history", false)
    end

    function svs.DoClick(s, args)
        act:UpdateServer(args)
        self.tabs:SetTab("activeserver")
    end

    serverlist.Query({
        Type = "history",
        Callback = function(...)
            local args = serverlist.Args2Table(...)
            svs:AddButton(args)

            svs.loading = false
        end
    })

    function self:DoBack(t)
        menu.multiplayer:ShowBackButton("history", false)
        self.tabs:SetTab("servers")
        return false
    end
end

function PANEL:Generate_favorite(tab)
    self.tabs = vgui.Create("Menu:Tabs", self)
    self.tabs:Dock(FILL)

    local svs = self.tabs:AddTab("servers", "Menu:Pages:Multiplayer:ServersList")
    local act = self.tabs:AddTab("activeserver", "Menu:Pages:Multiplayer:ActiveServer")

    function self.tabs:OnChanged(t)
        menu.multiplayer:ShowBackButton("favorite", t == "activeserver")
        menu.multiplayer:ShowSearch("favorite", false)
    end

    function svs.DoClick(s, args)
        act:UpdateServer(args)
        self.tabs:SetTab("activeserver")
    end

    serverlist.Query({
        Type = "favorite",
        Callback = function(...)
            local args = serverlist.Args2Table(...)
            svs:AddButton(args)

            svs.loading = false
        end
    })

    function self:DoBack(t)
        menu.multiplayer:ShowBackButton("favorite", false)
        self.tabs:SetTab("servers")
        return false
    end
end

vgui.Register("Menu:Pages:Multiplayer:Gamemodes", PANEL, "Menu:Tabs")