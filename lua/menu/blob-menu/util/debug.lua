
-- Lazy functions for myself :)
if not menu.debug_mode then return end

-- Universal Print
function _p(v, ...)
    local t = {...}
    if #t >= 1 then
        for k, vv in ipairs(t) do
            _p(vv)
        end
    end

    if ispanel(v) then
        return print(tostring(v), #v:GetChildren())
    end
    if istable(v) then
        return PrintTable(v)
    end

    print(v)
end

-- Iterate up parents
function _pars(pan, func)
    local par = pan
    for i = 0, 100 do
        if not IsValid(par) then return end
        par = par:GetParent()
        if not IsValid(par) then return end
        func(par)
    end
end

-- Dump
function _d(msg)
    print(os.time(), msg)
    debug.Trace()
end