
local PANEL = {}

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
    if args[1].icon then
        curx = h
        surface.SetMaterial(args[1].icon)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(12, 12, h - 24, h - 24)
    end

    draw.Text({
        text = args[1].name,
        pos = {curx, h / 2},
        yalign = 1,
        font = "Menu:ServerName"
    })

    draw.Text({
        text = args[1].ply_count .. " People on " .. args[1].count .. " servers",
        pos = {w - h / 2, h / 2},
        xalign = 2,
        yalign = 1,
        font = "Menu:ServerInfo"
    })
end

function PANEL.DoClickReal(rs, s, args)
    local tab = rs.tabs:SetTab("servers")
    tab:ClearButtons()
    tab.activegm = args

    for k,v in pairs(args.members) do
        tab:AddButton(v, rs.tabs)
    end
    tab.loading = false

    menu.PushBottomBarTab("back-server")
end

function PANEL.QueryCallback(rs, s, ...)
    if not IsValid(rs) then
        print("[BlobMenu] [Internet] Breaking (" .. tostring(IsValid(s)) .. ", " .. tostring(IsValid(rs)) .. ")")
        return false
    end

    rs.loadamt = rs.loadamt + 1

    local args = serverlist.Args2Table(...)
    rs.gamemodes[args.gm] = rs.gamemodes[args.gm] or {
        name = args.desc,
        count = 0,
        ply_count = 0,
        members = {},
        args = args,
        icon = file.Exists("gamemodes/" .. args.gm .. "/icon24.png", "GAME") and Material("gamemodes/" .. args.gm .. "/icon24.png")
    }
    rs.gamemodes[args.gm].count = rs.gamemodes[args.gm].count + 1
    rs.gamemodes[args.gm].ply_count = rs.gamemodes[args.gm].ply_count + args.players

    table.insert(rs.gamemodes[args.gm].members, args)
    rs.last_updated = SysTime()

    if rs.buttons[args.gm] then
        rs.buttons[args.gm].ply_count = rs.gamemodes[args.gm].ply_count
        rs.buttons[args.gm].count = rs.gamemodes[args.gm].count
    end

    if rs.loadamt % 20 == 0 then
        for k,v in pairs(rs.buttons) do
            v:SetZPos(-((v.ply_count or 0) + 1))
        end
    end
    if rs.buttons[args.gm] or rs.loadamt <= 100 then return end

    rs.loadamt = rs.loadamt + 1
    rs.loading = false
    rs.buttons[args.gm] = rs:AddButton(rs.gamemodes[args.gm])
end

vgui.Register("Menu:Pages:Multiplayer:GamemodesList", PANEL, "Menu:Pages:Multiplayer:GeneralList")