
menu.html_panels = {}
local PANEL = {}

function PANEL:Init()
    table.insert(menu.html_panels, self)

    self:AddFunction("blob", "injectcss", function(...)
        self:InjectCss(...)
    end )

    self:AddFunction("blob", "setcssvar", function(...)
        self:SetCSSVar(...)
    end )

    self.oldAlpha = self.SetAlpha

end

function PANEL:OnDocumentReady()
    self.ready = true
end

function PANEL:Think()
    if not self.ready then return end
    self.oldalpha = self.oldalpha or self:GetParent():GetAlpha()
    local a = self:GetParent():GetAlpha()

    if self.oldalpha == a then return end
    self.oldalpha = a

    self:SetCSSVar("global-alpha", a / 255)
end

function PANEL:InjectCSS(css)
    self:RunJavascript([[
        var ss = document.createElement("style")
        ss.type = "text/css"
        ss.innerText = `]] .. css .. [[`
        document.head.appendChild(ss)
    ]])
end

function PANEL:SetCSSVar(name, val)
    self:RunJavascript([[
        document.documentElement.style.setProperty("--]] .. name .. [[", "]] .. val .. [[");
    ]])
end


vgui.Register("Menu:HTML", PANEL, "DHTML")

function menu:UpdateHTMLColor(name, val)
    if name == "accent1" then
        for k,v in pairs(self.html_panels) do
            v:SetCSSVar(name, menu.html.Color(val))

            v:SetCSSVar("accent", menu.html.Color(val))
            v:SetCSSVar("transparent", menu.html.Color(ColorAlpha(val, 255 * .3)))
            v:SetCSSVar("transparent-5", menu.html.Color(ColorAlpha(val, 255 * .5)))
            v:SetCSSVar("transparent-7", menu.html.Color(ColorAlpha(val, 255 * .7)))
        end
    else
        for k,v in pairs(self.html_panels) do
            v:SetCSSVar(name, menu.html.Color(val))
        end
    end
end