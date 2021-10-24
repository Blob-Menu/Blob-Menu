-- include("mount/mount.lua")
include("loading.lua")
-- include("mainmenu.lua")
include("video.lua")
include("demo_to_video.lua")
-- include("menu_save.lua")
-- include("menu_demo.lua")
-- include("menu_addon.lua")
-- include("menu_dupe.lua")
include("errors.lua")
-- include("problems/problems.lua")
-- include("motionsensor.lua")
include("util.lua")
-- include("mplugins/menu.lua")


-- Super jank fix to the problem of maps
-- Its really annoying ik
pnlMainMenu = {}
function pnlMainMenu:Call(u)
    if string.StartWith(u, "UpdateMaps(") then
        menu.maplist = util.JSONToTable(u:sub(#"UpdateMaps(" + 1, -2))
    end
end
include("getmaps.lua")

menu = menu or {}
local function loadDirectory(dir)
    local fil, fol = file.Find(dir .. "/*", "LuaMenu")
    print("Attemping dir " .. dir .. " found " .. #fil .. " - " .. #fol)
    for k,v in ipairs(fil) do
        include(dir .. "/" .. v)
        print("loaded " .. dir .. "/" .. v)
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