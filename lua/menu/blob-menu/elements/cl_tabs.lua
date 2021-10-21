
local PANEL = {}
AccessorFunc(PANEL, "current", "ActiveTab")

function PANEL:Init()
    self.tabs = {}
end

function PANEL:AddTab(id, type)
    self.tabs[id] = vgui.Create(type or "Panel", self)
    self.tabs[id]:SetAlpha(0)
    self.tabs[id]:SetVisible(false)
    self.tabs[id].tabs = self
    self.tabs[id].id = id

    if not self:GetActiveTab() then
        self:SetTab(id)
    end

    return self.tabs[id]
end

function PANEL:SetTab(id)
    local act = self:GetActiveTab()
    if (act or {}).id == id then return end
    if act and act:IsVisible() then
        act:AlphaTo(0, 0.2, 0, function()
            act:SetVisible(false)
            self:SetTab(id)
        end )

        return self.tabs[id]
    end

    self:OnChanged()

    local new = self.tabs[id]
    new:SetAlpha(0)
    new:SetVisible(true)
    new:AlphaTo(255, 0.2)

    self:SetActiveTab(new)

    return new
end

function PANEL:PerformLayout(w, h)
    for k,v in pairs(self.tabs) do
        v:SetSize(w, h)
    end
end

function PANEL:OnChanged()

end

vgui.Register("Menu:Tabs", PANEL, "Panel")