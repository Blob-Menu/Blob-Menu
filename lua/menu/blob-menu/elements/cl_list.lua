
surface.CreateFont("Menu:ListButton", {
    font = "Poppins",
    size = 32
})

local PANEL = {}
AccessorFunc(PANEL, "active", "Active")

function PANEL:Init()
    self.btns = {}

    self:DockPadding(0, 50, 0, 0)
end

function PANEL:Paint(w,h)
    -- surface.SetDrawColor(menu.colors.accent2)
    -- surface.DrawRect(w - 1, 0, 1, h)

    local oc = DisableClipping(true)
    surface.SetDrawColor(menu.colors.shadow)
    surface.SetMaterial(menu.materials.left)
    surface.DrawTexturedRect(w, 0, 5, h)
    DisableClipping(oc)
end

function PANEL:PaintOver(w,h)
    surface.SetMaterial(menu.materials.down)
    surface.SetDrawColor(menu.colors.shadow)
    surface.DrawTexturedRect(0, 0, w, 5)
end

function PANEL:AddButton(name, on)
    local pnl = vgui.Create("DButton", self)
    pnl:Dock(TOP)
    pnl:SetTall(50)
    pnl:SetText("")
    pnl.DoClick = function(s)
        on(s)
        self:SetActive(s)
    end

    self.first = self.first or pnl
    self:SetActive(self.first)

    function pnl:Paint(w, h)
        local hov = self:IsHovered()
        local par = self:GetParent():GetParent()
        if par:GetActive() == self then
            self.olw = Lerp(FrameTime() * 12, self.olw or w + 2, w + 2)
        elseif hov then
            self.olw = Lerp(FrameTime() * 12, self.olw or 8, 8)
        else
            self.olw = Lerp(FrameTime() * 12, self.olw or 0, 0)
        end

        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(0, 0, self.olw, h)

        if (par.first != self) then
            surface.SetDrawColor(menu.colors.accent2)
            surface.DrawRect(0, 0, w, 1)
        end

        draw.Text({
            text = name,
            pos = {w / 2, h / 2},
            xalign = 1,
            yalign = 1,
            color = par:GetActive() == self and menu.colors.text or menu.colors.accent1,
            font = "Menu:ListButton"
        })
    end
end

if menu.ScrollCreated then
    vgui.Register("Menu:List", PANEL, "Menu:Scroll")
else
    hook.Add("Menu:ScrollDone", "1", function()
        vgui.Register("Menu:List", PANEL, "Menu:Scroll")
    end )
end