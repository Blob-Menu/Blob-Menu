
local PANEL = {}
AccessorFunc(PANEL, "current", "ActiveTab")

function PANEL:Init()
    self.tabs = {}
end

function PANEL:AddTab(id, type)
    self.tabs[id] = vgui.Create(type or "Panel", self)
    self.tabs[id]:SetAlpha(0)
    self.tabs[id]:SetSize(self:GetSize())
    self.tabs[id]:SetVisible(false)
    self.tabs[id].tabs = self
    self.tabs[id].id = id

    if not self:GetActiveTab() then
        self:SetTab(id)
    end

    return self.tabs[id]
end

function PANEL:SetTab(id, skipbs)
    local act = self:GetActiveTab()
    if skipbs then
        if act then
            act:SetAlpha(0)
            act:SetVisible(false)
        end
        self.tabs[id]:SetAlpha(255)
        self.tabs[id]:SetVisible(true)
        self.tabs[id].id = id
        self:SetActiveTab(self.tabs[id])
        return
    end

    if (act or {}).id == id then return end
    if act and act:IsVisible() then
        act:AlphaTo(0, 0.2, 0, function()
            act:SetVisible(false)
            self:SetTab(id)
        end )

        return self.tabs[id]
    end

    local new = self.tabs[id]
    new:SetAlpha(0)
    new:SetVisible(true)
    new:AlphaTo(255, 0.2)
    new.id = id

    self:OnChanged(id)
    self:SetActiveTab(new)

    return new
end

function PANEL:PerformLayout(w, h)
    for k,v in pairs(self.tabs) do
        if IsValid(v) then
            v:SetSize(w, h)
        else
            self.tabs[k] = nil
        end
    end
end

function PANEL:OnChanged()

end

vgui.Register("Menu:Tabs", PANEL, "Panel")