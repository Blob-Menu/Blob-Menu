
menu = menu or {}
menu.materials = {
    ["left"] = Material("vgui/gradient-l"),
    ["up"] = Material("vgui/gradient-d"),
    ["down"] = Material("vgui/gradient-u"),
}

function menu.Create()
    menu.panel = vgui.Create("Menu:MainPanel")
end

function menu.Refresh(b)
    if not GAMEMODE then return end
    if IsValid(menu.panel) then
        menu.panel:Remove()
    end
    surface.PlaySound("npc/dog/dog_footstep1.wav")
    if not b then
        menu.Create()
    end
end

function menu.send_signal(pnl, signal, ...)
    if not IsValid(pnl) then return end
    for k,v in pairs(pnl:GetChildren()) do
        if not IsValid(v) then continue end
        if v[signal] then
            v[signal](v, ...)
        end

        menu.send_signal(v, signal, ...)
    end
end

if CLIENT_DLL and not MENU_DLL then
    menu.fakeingame = menu.fakeingame or false
    function IsInGame()
        return menu.fakeingame
    end

    concommand.Add("menu_fakeingame", function()
        menu.fakeingame = not menu.fakeingame

    end )
    print("Set Fakegame to " .. tostring(menu.fakeingame))
end


local current = IsInGame()
hook.Add("Think", "Menu:WatchForIngameChanges", function()
    local ig = IsInGame()
    if current != ig then
        current = ig
        menu.send_signal(menu.panel, "InGameChanged", current)
    end
end )

concommand.Add("lua_run_menu", function(_,_,_,a)
    RunString(a, "lua_run_menu")
end )

menu.Refresh(1)
