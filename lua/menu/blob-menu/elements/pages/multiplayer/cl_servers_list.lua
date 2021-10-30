
surface.CreateFont("Menu:NoneFound", {
    font = "Poppins",
    size = 100,
})

local PANEL = {}

function PANEL:Init()
    self.creation = CurTime()
end

function PANEL:DoClick(args, tabs)
    local active = tabs:SetTab("activeserver")

    active:UpdateServer(args)
end

function PANEL:Sort(b, args)
    for k,v in pairs(self.buttons) do
        if not IsValid(v) then continue end
        v:SetZPos(-(menu.GetServerRanking(v.values[1]) + 1))
    end
end

function PANEL:Paint(w,h)
    if self.loading and (CurTime() - self.creation) >= 5 then
        draw.Text({
            text = "NO SERVERS FOUND",
            pos = {w / 2, h / 2},
            font = "Menu:NoneFound",
            xalign = 1,
            yalign = 1,
            color = ColorAlpha(menu.colors.text2, 150)
        })
    elseif self.loading then
        local size = 20
        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(w / 2 - (size / 2), h / 2 - (size / 2) + (math.sin((CurTime() + 20) * 7) * 50), size, size)
        surface.DrawRect(w / 2 - (size * 2) - size, h / 2 - (size / 2) + (math.sin((CurTime() + 10) * 7) * 50), size, size)
        surface.DrawRect(w / 2 + (size * 2), h / 2 - (size / 2) + (math.sin((CurTime() + 30) * 7) * 50), size, size)
    end
end

function PANEL:PaintButton(w,h,args)
    args = args[1]
    local curx = h / 2

    draw.RoundedBoxEx(4, 0, 0, 12, h, menu.colors.accent1, true, false, true)

    draw.Text({
        text = args.name,
        pos = {curx, h / 2},
        yalign = 1,
        font = "Menu:ServerName",
        color = menu.colors.text2
    })

    draw.Text({
        text = args.players .. " / " .. (args.maxplayers or 27),
        pos = {w - h / 2, h / 2 + 2},
        xalign = 2,
        yalign = 1,
        font = "Menu:ServerInfo",
        color = menu.colors.text2
    })
end

vgui.Register("Menu:Pages:Multiplayer:ServersList", PANEL, "Menu:Pages:Multiplayer:GeneralList")