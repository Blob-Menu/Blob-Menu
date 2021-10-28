
menu.serverinfo_mega_default = {
    ["description"] = "No Server Description",
    ["image"] = "",
    ["tags"] = {},
    ["features"] = {}
}

local info_cache
function menu.GetServerInfo(ip, done)
    info_cache = info_cache or menu.Cache("serverinfo")

    if info_cache:Get(ip, false) then
        return done(info_cache:Get(ip))
    end

    local url = menu.serverinfo_distributor .. ip

    http.Fetch(url, function(b, s, h, c)
        if c ~= 200 then return done(info_cache:Get("backup", menu.serverinfo_mega_default)) end
        local dat = util.JSONToTable(b)
        done(dat)

        info_cache:Set(ip, dat)
    end, function()
        done(menu.serverinfo_default)
    end )
end

menu.GetServerInfo("backup", function()
    print("[BlobMenu] Backup data successfully retrieved!")
end, function()
    print("[BlobMenu] Failed to retrieve backup data, falling back to ultra backup!")
end )