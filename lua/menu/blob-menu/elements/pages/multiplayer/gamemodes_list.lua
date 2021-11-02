
surface.CreateFont("Menu:GamemodeTag", {
    font = "Poppins",
    size = 25
})

local PANEL = {}
local errmat = Material("gamemodes/base/icon24.png")

function PANEL:Init()
    self.gamemodes = {}
    self.buttons = {}
    self.tabs = false
    self.loadamt = 0

    function self.DoClick(s, args)
        PANEL.DoClickReal(self, s, args)
    end
end

function PANEL:PaintButton(w,h,args)
    local curx = h / 4
    curx = h
    surface.SetMaterial(args[1].icon or errmat)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(h / 2 - (32 / 2), h / 2 - (32 / 2), 32, 32)

    local textw = draw.Text({
        text = args[1].name,
        pos = {curx, h / 2},
        yalign = 1,
        font = "Menu:ServerName",
        color = menu.colors.text
    })

    draw.Text({
        text = args[1].ply_count .. " People on " .. args[1].count .. " servers",
        pos = {w - h / 2, h / 2},
        xalign = 2,
        yalign = 1,
        font = "Menu:ServerInfo",
        color = menu.colors.text2
    })

    local tag = args[2]
    if tag then
        local tagw,tagh = surface.GetTextSize(tag)
        surface.SetFont("Menu:GamemodeTag")
        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(h + textw + 5, h / 2 - tagh / 2, tagw + 20, tagh)

        draw.Text({
            text = tag,
            pos = {h + textw + 15, h / 2 + 1},
            yalign = 1,
            font = "Menu:GamemodeTag",
            color = menu.colors.text2
        })
    end
end

function PANEL.GetGamemodeTag(gm)
    return menu.gamemode_tags[gm] or ((string.find(gm:lower(), "rp") or string.find(gm:lower(), "roleplay")) and "Roleplay")
end

function PANEL.DoClickReal(rs, s, args)
    local tab = rs.tabs:SetTab("servers")
    tab:ClearButtons()
    tab.activegm = args

    for k,v in pairs(args.members) do
        tab:AddButton(v, rs.tabs)
    end

    tab:Sort()
    tab.loading = false
    tab.args = args

    rs.active_thing = tab
end

function PANEL.QueryCallback(rs, s, ...)
    if not IsValid(rs) then
        print("[BlobMenu] [Internet] Breaking (" .. tostring(IsValid(s)) .. ", " .. tostring(IsValid(rs)) .. ")")
        return false
    end

    rs.loadamt = rs.loadamt + 1

    local args = serverlist.Args2Table(...)
    rs.gamemodes[args.desc] = rs.gamemodes[args.desc] or {
        name = args.desc,
        count = 0,
        ply_count = 0,
        members = {},
        args = args,
        icon = file.Exists("gamemodes/" .. args.desc .. "/icon24.png", "GAME") and Material("gamemodes/" .. args.desc .. "/icon24.png")
    }
    rs.gamemodes[args.desc].count = rs.gamemodes[args.desc].count + 1
    rs.gamemodes[args.desc].ply_count = rs.gamemodes[args.desc].ply_count + args.players

    table.insert(rs.gamemodes[args.desc].members, args)
    if rs.active_thing and (rs.active_thing.args.name == args.desc) and (not rs.searching) then
        rs.active_thing:AddButton(args, rs.tabs)
        rs.active_thing:Sort()

        if rs.toadd then
            for k,v in pairs(rs.toadd) do
                rs.active_thing:AddButton(v, rs.tabs)
                rs.toadd[k] = nil
            end
            rs.active_thing:Sort()
        end
    elseif rs.searching then
        if menu.search.Match(args.name, rs.searching) >= 0.3 then
            rs.active_thing:AddButton(args, rs.tabs)
            rs.active_thing:Sort()
        end

        rs.toadd = rs.toadd or {}
        table.insert(rs.toadd, args)
    end

    rs.last_updated = SysTime()

    if rs.buttons[args.desc] then
        rs.buttons[args.desc].ply_count = rs.gamemodes[args.desc].ply_count
        rs.buttons[args.desc].count = rs.gamemodes[args.desc].count
    end

    if rs.loadamt % 20 == 0 then
        for k,v in pairs(rs.buttons) do
            v:SetZPos(-((v.ply_count or 0) + 1))
        end
    end
    if rs.buttons[args.desc] or rs.loadamt <= 100 then return end

    rs.loadamt = rs.loadamt + 1
    rs.loading = false
    rs.buttons[args.desc] = rs:AddButton(rs.gamemodes[args.desc], PANEL.GetGamemodeTag(args.desc))
end

vgui.Register("Menu:Pages:Multiplayer:GamemodesList", PANEL, "Menu:Pages:Multiplayer:GeneralList")