
local meta = FindMetaTable("Panel")

function meta:RecursivePos()
    local current = self
    local x = 0
    local y = 0
    for i = 0, 100 do
        if (not IsValid(current)) or (current == vgui.GetWorldPanel()) or (current == menu.panel) then
            return x, y
        end
        x = x + current:GetX()
        y = y + current:GetY()

        current = current:GetParent()
    end

    return x, y
end

menu.PanelPrepareEx = menu.PanelPrepareEx or meta.Prepare

function meta:Prepare()
    menu.PanelPrepareEx(self)

    self.debug_info = debug.getinfo(3)
end