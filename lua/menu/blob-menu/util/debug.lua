
-- Lazy functions for myself :)
if not menu.debug_mode then return end

-- Universal Print
function _p(...)
    _p2({...})
end

function _p2(t, i)
    i = i or 0
    d = d or {}
    local istr = string.rep("\t", i)
    local types = {
        ["boolean"] = function(v) return Color(86, 156, 214), (v and "true") or "false" end,
        ["string"] = function(v) return Color(228, 134, 13), "\"" .. v .. "\"" end,
        ["number"] = function(v) return Color(174, 129, 255), tostring(v) end,
        ["panel"] = function(v) return Color(230, 219, 116), {tostring(v), #v:GetChildren()} end,
        ["function"] = function(v)
            local inf = debug.getinfo(v)
            local _e = ""

            if inf.linedefined then
                _e = "\t" .. debug.getinfo(v).linedefined .. ":" .. debug.getinfo(v).lastlinedefined
            end

            return Color(233, 86, 120), tostring(v) .. "\t" .. debug.getinfo(v).short_src .. _e
        end,
        ["default"] = function(v) return Color(177, 177, 177), tostring(v) end,
    }

    for k,v in pairs(t) do
        local ty = type(v)
        local prefix = tostring(k) .. ":\t"

        if types[ty] then
            local col, msg = types[ty](v)
            MsgC(istr, prefix, col, istable(msg) and unpack(msg) or msg)
            print()
        elseif ty == "table" then
            MsgC(istr, Color(102, 217, 239), tostring(v), ":\n")
            _p2(v, i + 1, d)
        else
            local col, msg = types["default"](v)
            MsgC(istr, prefix, col, msg, "\n")
        end
    end
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
function _d(...)
    print(os.time(), ...)
    debug.Trace()
end