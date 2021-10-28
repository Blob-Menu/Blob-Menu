
include("mount/mount.lua")
include("loading.lua")
include("video.lua")
include("demo_to_video.lua")
include("errors.lua")
include("motionsensor.lua")
include("util.lua")
include("getmaps.lua")

menu = menu or {}
menu.enabled = cookie.GetNumber("blob_menu_enabled", 1) == 1
menu.debug_mode = cookie.GetNumber("blob_debug_enabled", 0) == 1

concommand.Add("blob_menu_enable", function(_,_,a)
    if tonumber(a[1]) == 1 then
        print("[BlobMenu] Enabled, Please restart!")
    else
        print("[BlobMenu] Disabled, Please restart!")
    end

    cookie.Set("blob_menu_enabled", a[1])
    menu.enabled = tonumber(a[1]) == 1
end, function()
    return {
        "1 to enable",
        "0 to disable",
        "currently " .. (menu.enabled and "enabled" or "disabled")
    }
end )

concommand.Add("blob_menu_total_reload", function(_,_,a)
    if a[1] != "yes" then return print("[BlobMenu] Dont run this unless you know what youre doing! this WILL break things! if youre sure run with the argument \"yes\"") end
    if ispanel(pnlMainMenu) then
        pnlMainMenu:Remove()
    elseif menu.panel then
        menu.panel:Remove()
    end

    pnlMainMenu = nil

    menu.Load()
    gui.ShowConsole()
end )

concommand.Add("blob_menu_debug", function(_, _, a)
    if tonumber(a[1]) == 1 then
        print("[BlobMenu] Enabled debug mode!")
    else
        print("[BlobMenu] Disabled debug mode!")
    end

    cookie.Set("blob_debug_enabled", a[1])
    menu.debug_mode = tonumber(a[1]) == 1
end, function()
    return {
        "1 to enable",
        "0 to disable",
        "currently " .. (menu.debug_mode and "enabled" or "disabled")
    }
end )

function menu.IsOnChrome()
    return jit.arch == "x64"
end

function menu.Load()
    if menu.enabled and menu.IsOnChrome() then
        pnlMainMenu = {}
        function pnlMainMenu:Call(u)
            if string.StartWith(u, "UpdateMaps(") then
                menu.maplist = util.JSONToTable(u:sub(#"UpdateMaps(" + 1, -2))
            end
        end

        local function loadDirectory(dir)
            local fil, fol = file.Find(dir .. "/*", "LuaMenu")
            for k,v in ipairs(fil) do
                include(dir .. "/" .. v)
            end

            for k,v in pairs(fol) do
                loadDirectory(dir .. "/" .. v)
            end
        end

        concommand.Add("blob_menu_refresh", function()
            loadDirectory("menu/blob-menu")
            menu.panel:Remove()
            menu.Create()
            gui.ShowConsole()
        end )

        loadDirectory("menu/blob-menu")
        menu.Create()
    else
        include("mainmenu.lua")
        include("menu_save.lua")
        include("menu_demo.lua")
        include("menu_addon.lua")
        include("menu_dupe.lua")
        include("problems/problems.lua")

        if not menu.IsOnChrome() then
            print("[BlobMenu] [Error] In order to use BlobMenu you must be on the chromium branch of GMod! sorry :(")
        end
    end
end

menu.Load()