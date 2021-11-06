
local PANEL = {}

function PANEL:Init()

end

function PANEL:PerformLayout(w, h)
    self:Dock(FILL)
end

vgui.Register("Menu:Options:Servers", PANEL, "DPanel")
