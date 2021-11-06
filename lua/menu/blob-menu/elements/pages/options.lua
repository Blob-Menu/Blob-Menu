
local tabs = {}
local PANEL = {}

function PANEL:Init()
    menu.options_panel = self
    self.list = vgui.Create("Menu:List", self)
    self.tabs = vgui.Create("Menu:Tabs", self)

    for k,v in pairs(tabs) do
        self:AddOptionTab(k, v)
    end

    menu.RegisterOptionTab("Servers", "Menu:Options:Servers")
end

function PANEL:PerformLayout(w,h)
    self:DockPadding(0, 80, 0, 80)

    self.list:Dock(LEFT)
    self.tabs:Dock(FILL)
    self.list:SetWide(300)
end

function PANEL:AddOptionTab(name, panel)
    self.list:AddButton(name, function()
        self.tabs:SetTab(name)
    end )

    self.tabs:AddTab(name, panel)
end

vgui.Register("Menu:Pages:Options", PANEL, "Panel")

-- Currently not functional outside of the init function, unsure why pls fix 4 me
function menu.RegisterOptionTab(name, panel)
    if not menu.options_panel then
        tabs[name] = panel
        return
    end

    menu.options_panel:AddOptionTab(name, panel)
end