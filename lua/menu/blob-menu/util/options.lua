
menu.options = {}
menu.options.cache = false

function menu.options:Get(id)
    self.Cache = self.Cache or menu.Cache("options")

    local got = self.Cache:Get(id)
    return menu.HexToColor(got) or tonumber(got) or got
end

function menu.options:Set(id, val)
    self.Cache = self.Cache or menu.Cache("options")

    if IsColor(val) then
        self.Cache:Set(id, menu.ToHex(val))
    else
        self.Cache:Set(id, val)
    end
end
