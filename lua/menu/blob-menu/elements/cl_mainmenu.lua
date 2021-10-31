
local PANEL = {}
AccessorFunc(PANEL, "activepg", "ActivePage")

function PANEL:Init()
    self.pages = {}

    self.html = vgui.Create("DHTML", self)
    self.html:SetHTML([[
        <style>
        ]] .. menu.html.BaseCSS() .. [[

        svg {
            position:absolute;
            width:100%;
            height:100%;
            object-fit:cover;
            z-index:-10;
        }

        .bottom {
            position:absolute;
            background:rgba(15,15,15,.3);
            width:100%;
            height:80px;
            z-index:100;
            bottom:0;
            backdrop-filter:blur(20px) saturate(125%);
        }
        </style>
        
        <div class="bottom"></div>
        ]] .. menu.svgs[menu.config.background_svg] or menu.svgs["blob"] .. [[
    ]])

    self.canvas = vgui.Create("Panel", self)
    self.topbar = vgui.Create("Menu:Topbar", self)
    self.bottom = vgui.Create("Menu:Bottombar", self)

    self:AddPage("dashboard", "Menu:Page:Dashboard")
    self:AddPage("singleplayer", "Menu:Page:Singleplayer")
    self:AddPage("multiplayer", "Menu:Page:Multiplayer")
    self:AddPage("options", "Panel")

    self:SetSize(ScrW(), ScrH())

    self:SetKeyboardInputEnabled(true)
end

function PANEL:OnScreenSizeChanged(w,h)
    self:SetSize(ScrW(), ScrH())
end

function PANEL:AddPage(name, type)
    self.topbar:AddButton(name, function()
        self:SetPage(name)
    end )

    self.pages[name] = type

    if not self:GetActivePage() then
        self:SetPage(name)
    end
end

function PANEL:SetPage(name)
    local pg = self:GetActivePage()

    if IsValid(pg) and pg.name == name then
        return
    end

    if IsValid(pg) and pg:IsVisible() then
        self.moveto = name
        self.topbar.buttons_by_name[pg.name].active = false
        pg:AlphaTo(0, 0.2, 0, function()
            pg:SetVisible(false)
            self:SetPage(name)
        end )
        return
    end

    if isstring(self.pages[name]) then
        local p = vgui.Create(self.pages[name], self.canvas)
        p:SetSize(self.canvas:GetSize())
        p:SetPos(0, 0)
        p:SetAlpha(0)
        p.name = name

        self.pages[name] = p
    end

    self.pages[name]:AlphaTo(255, 0.2)
    self:SetActivePage(self.pages[name])
    self.pages[name]:SetVisible(true)
    self.topbar.buttons_by_name[name].active = true
end

function PANEL:Paint(w,h)
    surface.SetDrawColor(menu.colors.background)
    surface.DrawRect(0,0,w,h)
end

function PANEL:PerformLayout(w, h)
    self.html:SetSize(w, h)
    self.topbar:SetSize(w, 80)
    self.canvas:SetSize(w, h)
    self.canvas:SetPos(0, 0)
    self.bottom:SetSize(w, 80)
    self.bottom:SetPos(0, h - 80)

    for k,v in pairs(self.pages) do
        if not isstring(v) then v:SetSize(self.canvas:GetSize()) end
    end
end

vgui.Register("Menu:MainPanel", PANEL, "Panel")
menu.Refresh()
