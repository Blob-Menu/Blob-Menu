
menu.themes = menu.themes or {}
menu.themes.watches = {}

function menu.themes.UpdateList()
    menu.themes.list = {}

    for k,v in pairs(select(1, file.Find("menu/blob-menu/themes/*.json", "LuaMenu"))) do
        menu.themes.list[string.StripExtension(v)] = util.JSONToTable(file.Read("menu/blob-menu/themes/" .. v, "LuaMenu") or "{'valid':false}") or {valid=false}
    end
end

function menu.themes.GetTheme()
    return menu.themes.list[menu.options:Get("theme") or "default"] or menu.themes.list["default"]
end

function menu.themes.SetTheme(a)
    menu.options:Set("theme", a)
end

function menu.themes.Update()
    local cur = menu.themes.GetTheme()

    for k,v in pairs(cur.colors) do
        menu.colors[k] = menu.HexToColor(v)
    end

    for k,v in pairs(menu.themes.watches) do
        if IsValid(k) then
            if not k.SetCSSVar then continue end
            for kk, col in pairs(menu.colors) do
                if not IsColor(v) then continue end
                k:SetCSSVar(kk, menu.html.Color(col))
            end

            k:SetCSSVar("accent", menu.html.Color(menu.colors.accent1))
            k:SetCSSVar("transparent", menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .3)))
            k:SetCSSVar("transparent-5", menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .5)))
            k:SetCSSVar("transparent-7", menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .7)))
        end
    end
end

function menu.themes.Watch(pnl, on)
    menu.themes.watches[pnl] = on
end

concommand.Add("settheme", function(_,_,a)
    menu.themes.UpdateList()
    menu.themes.SetTheme(a[1] or "default")
    menu.themes.Update()
end )

menu.themes.UpdateList()
menu.themes.Update()