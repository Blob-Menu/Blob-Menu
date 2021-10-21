
local PANEL = {}

function PANEL:Init()
    self.items = {}
    self.loading = true
    self.buttons = {}
end

function PANEL:AddButton(...)
    local b = vgui.Create("DButton", self)
    b:Dock(TOP)
    b:SetTall(60)
    b:DockMargin(8, 2, 8, 2)
    b:SetText("")
    b.values = {...}

    b.DoClick = function(s)
        self.DoClick(b, unpack(b.values))
    end

    b.Paint = function(s,w,h)
        draw.RoundedBox(16, 0, 0, w, h, menu.colors.server_background)
        self.PaintButton(s, w, h, b.values)
    end

    table.insert(self.buttons, b)
    return b
end

function PANEL:Done()
    self.loading = false
    self:AddPadding()
end

function PANEL:DoClick(...)
    print("[BlobMenu] [GeneralList] Called DoClick on a non-doclickified panel!")
end

function PANEL:PaintButton(w, h)

end

function PANEL:Paint(w,h)
    if self.loading then
        local size = 20
        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(w / 2 - (size / 2), h / 2 - (size / 2) + (math.sin((CurTime() + 20) * 7) * 50), size, size)
        surface.DrawRect(w / 2 - (size * 2) - size, h / 2 - (size / 2) + (math.sin((CurTime() + 10) * 7) * 50), size, size)
        surface.DrawRect(w / 2 + (size * 2), h / 2 - (size / 2) + (math.sin((CurTime() + 30) * 7) * 50), size, size)
    end
end

function PANEL:ClearButtons()
    for k,v in pairs(self.buttons) do
        v:Remove()
    end
end

vgui.Register("Menu:Pages:Multiplayer:GeneralList", PANEL, "Menu:Scroll")