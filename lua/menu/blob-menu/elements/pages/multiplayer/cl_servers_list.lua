
local PANEL = {}

function PANEL:DoClick(args, tabs)
    local active = tabs:SetTab("activeserver")

    menu.PushBottomBarTab("back-server-list")
    active:UpdateServer(active)
end

function PANEL:PaintButton(w,h,args)
    args = args[1]
    local curx = h / 4

    draw.Text({
        text = args.name,
        pos = {curx, h / 2},
        yalign = 1,
        font = "Menu:ServerName"
    })

    draw.Text({
        text = args.players .. " / " .. (args.maxplayers or 27),
        pos = {w - h / 2, h / 2},
        xalign = 2,
        yalign = 1,
        font = "Menu:ServerInfo"
    })
end

vgui.Register("Menu:Pages:Multiplayer:ServersList", PANEL, "Menu:Pages:Multiplayer:GeneralList")