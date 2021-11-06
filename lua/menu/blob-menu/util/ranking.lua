
local cache
function menu.HideServerRegion(type, ishidden)
    cache = cache or menu.Cache("hidden_regions")
    if ishidden == nil then
        return cache:Get(type) or false
    end

    return cache:Set(type, ishidden)
end

function menu.GetServerRanking(args)
    return args.players
    + (args.isanon and -1000 or 10)
    - (args.ping / 20)
    - (menu.HideServerRegion(args.loc) and 1000000 or 0)
end