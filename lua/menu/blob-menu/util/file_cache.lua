
file.CreateDir("blobmenu")
file.CreateDir("blobmenu/cache")
menu.caches = {}
menu.file_caches = {}

concommand.Add("blob_menu_clearcaches", function()
    for k,v in pairs(menu.caches) do
        file.Delete(v.filename)
    end
    print("[BlobMenu] Caches Cleared! Please restart")
end )

concommand.Add("blob_menu_dumpcaches", function()
    for k,v in pairs(menu.caches) do
        print(k, ":")
        PrintTable(v.stored, 2)
        print("\n")
    end
end )


function menu.StripURL(url)
    url = url:gsub("[^a-zA-Z0-9]", "")
    return url
end

function menu.GetExtension(url)
    local splt = string.Split(url, ".")
    return splt[#splt]
end

function menu.FormatURLFile(url)
    local strip = menu.StripURL(url)
    local ext = menu.GetExtension(url)

    return strip:sub(1, #strip - #ext) .. "." .. ext
end

-- Data Caches
-- Encoded JSON
local cache = {}

function cache:Init()
    self.filename = "blobmenu/cache/" .. self.id .. ".dat"

    self.raw_text = "e30="
    self.decoded = "{}"
    self.stored = {}

    self:UpdateLocal()
end

function cache:UpdateLocal()
    if not file.Exists(self.filename, "DATA") then return end
    self.raw_text = file.Read(self.filename, "DATA")
    self.decoded = util.Base64Decode(self.raw_text)
    self.stored = util.JSONToTable(self.decoded)
end

function cache:UpdateFile()
    file.Write(self.filename, util.Base64Encode(util.TableToJSON(self.stored, false), true))
end

function cache:Get(id, fallback)
    return self.stored[id] or fallback
end

function cache:Set(id, val)
    self.stored[id] = val

    self:UpdateFile()
end

function menu.Cache(id)
    if menu.caches[id] then
        return menu.caches[id]
    end

    local ch = setmetatable({}, {
        __index = cache,
        __tostring = function(s)
            return "<cache: " .. s.id .. " " .. s.decoded .. ">"
        end
    })
    ch.id = id
    ch:Init()

    menu.caches[id] = ch
    return ch
end

-- File Caches
-- Handled Folders
local fcache = {}

function fcache:Init()
    self.location = "blobmenu/cache/" .. self.folder
    file.CreateDir(self.location)

    local files, folders = file.Find(self.location .. "/*", "DATA")
    self.files = {}
    self.folders = {}

    for k,v in pairs(files) do
        self.files[v] = true
    end

    for k,v in pairs(folders) do
        self.folders[v] = true
    end
end

function fcache:Write(ff, content)
    self.files[ff] = content

    file.Write(self.location .. "/" .. menu.FormatURLFile(ff), content)
end

function fcache:Read(ff)
    return self.files[menu.FormatURLFile(ff)]
end

function menu.FileCache(fol)
    if menu.file_caches[fol] then
        return menu.file_caches[fol]
    end

    local f = setmetatable({}, {
        __index = fcache
    })
    f.folder = fol
    f:Init()

    menu.file_caches[fol] = f
    return fcache
end