
menu.version = 1
menu.information = {}

http.Fetch("https://raw.githubusercontent.com/Blob-Menu/Blob-Menu/main/info.json", function(b, s, h, c)
    if c ~= 200 then
        print("[BlobMenu] [Error] Failed to retrieve info.json", "", b, c)
        return
    end
    menu.information = util.JSONToTable(b)
    menu.CheckVersion()
end, function(...)
    print("[BlobMenu] [Error] Failed to retrieve info.json", "", ...)
end)

function menu.CheckVersion()
    if menu.version == menu.information.version then
        print("[BlobMenu] [Version] Up to date!")
    elseif menu.version <= menu.information.version then
        print("[BlobMenu] [Version] New version detected! please update to v" .. menu.information.version .. " here: https://github.com/Blob-Menu/Blob-Menu/releases/tag/" .. menu.information.version)
    end
end