
menu.options = {}
menu.options.cache = false

function menu.options.CookieName(id)
    return "blob_menu_option_" .. id
end

function menu.options:Get(id)
    local got = cookie.GetString(self.CookieName(id))
    return menu.HexToColor(got) or tonumber(got) or got
end

function menu.options:Set(id, val)
    if IsColor(val) then
        cookie.Set(self.CookieName(id), menu.ToHex(val))
    else
        cookie.Set(self.CookieName(id), val)
    end
end
