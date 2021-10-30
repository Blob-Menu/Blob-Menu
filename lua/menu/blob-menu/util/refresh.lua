
menu.towatch = menu.towatch or {}
local towatch = menu.towatch

function menu.WatchFile(f)
    if file.Exists(f, "LuaMenu") then
        if towatch[f] then
            return
        end

        print("[BlobMenu] [Watch] Started Watching " .. f)

        towatch[f] = file.Read(f, "LuaMenu")
    else
        print("[BlobMenu] [Watch] Couldnt find file " .. f)
    end
end

concommand.Add("blob_watch", function(_,_,a)
    if #a == 0 then
        _p(towatch)
        return
    end
    if a[1] == "reset" then
        print("[BlobMenu] [Watch] Stopped Watching all")
        for k,v in pairs(towatch) do
            towatch[k] = nil
        end
    end
    for k,v in pairs(a) do
        v = "menu/blob-menu/" .. v
        if towatch[v] then
            print("[BlobMenu] [Watch] Stopped Watching " .. v)
            towatch[v] = nil
            continue
        end
        menu.WatchFile(v)
    end
end )

local t = 0
hook.Add("DrawOverlay", "Menu:Watch", function()
    if t <= CurTime() then
        t = CurTime() + 3

        for k,v in pairs(towatch) do
            local r = file.Read(k, "LuaMenu")
            if r ~= v then
                towatch[k] = r
                print("[BlobMenu] [Watch] Detected File Change, Refreshing!")
                RunConsoleCommand("blob_menu_refresh")
            end
        end
    end
end )