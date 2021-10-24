
local PANEL = {}

function PANEL:Init()
    self.left = vgui.Create("DPanel", self)
    self.mid = vgui.Create("DPanel", self)
    self.right = vgui.Create("DPanel", self)
end

function PANEL:PerformLayout(w,h)
    self.left:SetSize(w / 5, h)

    self.right:SetSize(w / 5, h)
    self.right:SetPos(w - self.right:GetWide(), 0)

    self.mid:SetPos(w / 5, 0)
    self.mid:SetSize(w - (w / 5 * 2), h)
end

function PANEL:UpdateServer(args)
    menu.GetServerInfo("1.1.1.1:69696"--[[ args.ip ]], function(d)
        _p(d)
        print("Completely done with updating server")
    end )
end

vgui.Register("Menu:Pages:Multiplayer:ActiveServer", PANEL, "Panel")