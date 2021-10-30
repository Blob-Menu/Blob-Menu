
menu.search = {}

function menu.search.Match(str, need)
    if string.find(str:lower(), need:lower(), 1, true) then
        return 1
    end
    return 0

    -- local tbl = string.ToTable(str:lower())
    -- local match_score = 0

    -- for i = 1, #tbl do
    --     local char = tbl[i]
    --     local f = {
    --         [need[i - 1]    or false] = 0.5,
    --         [need[i]        or false] = 1,
    --         [need[i + 1]    or false] = 0.5
    --     }

    --     match_score = match_score + (f[char] or 0)
    -- end

    -- return match_score / #need
end

function menu.search.Search(tbl, ndl, get)
    get = (isfunction(get) and get) or function(s)
        return s[get]
    end

    -- ndl = istable(ndl) and ndl or string.ToTable(ndl)
    local toret = {}
    for k,v in pairs(tbl) do
        local retr = get(v)
        toret[k] = {
            target = v,
            tomatch = retr,
            match = menu.search.Match(retr, ndl)
        }
    end
    return toret
end