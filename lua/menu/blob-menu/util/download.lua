
file.CreateDir("blobmenu")

function menu.Download(url, dir, done, err)
    err = err or print
    cache = menu.FileCache(dir)

    if cache:Read(url) then
        done(cache:Read(url))
    end

    http.Fetch(url, function(bod, size, hed, code)
        if code ~= 200 or size <= 10 then return err(code) end
        cache:Write(url, bod)
        done()
    end, err)
end

local imgcache = {}
local imgcache_file
function menu.Image(url, done)
    if imgcache[url] ~= nil then
        return imgcache[url]
    end

    imgcache_file = imgcache_file or menu.FileCache("images")

    local fmt = menu.FormatURLFile(url)
    local r = imgcache_file:Read(fmt)
    if r then
        imgcache[url] = Material("../data/blobmenu/images/" .. fmt)
        return imgcache[url]
    end

    imgcache[url] = true

    menu.Download(url, "images", function()
        imgcache[url] = Material("../data/blobmenu/images/" .. fmt)
    end, err)
end