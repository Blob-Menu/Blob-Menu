
-- Lazy functions for myself :)
if not menu.debug_mode then return end

-- Quick refresh
concommand.Add("qrf", function()
    RunConsoleCommand("blob_menu_refresh")
end )

-- Quick Lua
concommand.Add("qlu", function(_, _, _, a)
    local x = CompileString("return " .. a, "[qlu]", false)()
    if x then
        print("Returned ", x)
    end
end )

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
            MsgC(istr, Color(102, 217, 239), k, ":\n")
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

-- Inspection
surface.CreateFont("Menu:DebugInspect", {
    font = "Poppins",
    size = 30,
})

local inspect_info = {
    pos = function(pnl)
        return pnl:GetX() .. ", " .. pnl:GetY()
    end,
    size = function(pnl)
        return pnl:GetWide() .. ", " .. pnl:GetTall()
    end,
    from = function(pnl)
        if not pnl.debug_info then return end

        return pnl.debug_info.short_src .. "@" .. pnl.debug_info.linedefined .. ":" .. pnl.debug_info.lastlinedefined
    end
}

local inspecting = false
hook.Add("DrawOverlay", "Menu:DrawInspectTools", function()
    if not inspecting then return end

    local hov = vgui.GetHoveredPanel()
    if not IsValid(hov) then return end
    local x, y = hov:RecursivePos()
    local w, h = hov:GetSize()

    surface.SetDrawColor(255, 255, 0, 100)
    surface.DrawOutlinedRect(x, y, w, h, 1)

    surface.DrawLine(x, y, x + w, y + h)
    surface.DrawLine(x + w, y, x, y + h)

    local info = {}
    surface.SetFont("Menu:DebugInspect")
    local wide = 0
    local high = 0
    local lines = 0
    for k,v in pairs(inspect_info) do
        local i = v(hov)
        if not i then
            continue
        end
        lines = lines + 1
        info[k] = i

        local _w,_h = surface.GetTextSize(i .. "  " .. k)

        wide = math.max(wide, _w + 40)
        high = high + _h + 10
    end

    surface.SetDrawColor(menu.colors.background)
    surface.DrawRect(ScrW() - 30 - wide, 15, wide + 20, high)
    surface.SetDrawColor(menu.colors.accent1)
    surface.DrawOutlinedRect(ScrW() - 30 - wide, 15, wide + 20, high, 2)

    local curh = 20
    for k,v in pairs(info) do
        local _w, _h = draw.Text({
            text = k,
            pos = {
                ScrW() - 20 - wide,
                curh
            },
            font = "Menu:DebugInspect"
        })
        draw.Text({
            text = v,
            pos = {
                ScrW() - 20,
                curh
            },
            xalign = 2,
            font = "Menu:DebugInspect"
        })

        lines = lines - 1
        if lines != 0 then
            surface.DrawRect(ScrW() - 20 - wide, curh + _h, wide, 1)
        end

        curh = curh + _h + 10
    end
end )

concommand.Add("vgui_menu_inspect", function(_,_,a)
    if a == "1" or a == "true" then
        inspecting = true
        return
    end

    inspecting = false
end )

-- Read Cookies
concommand.Add("blob_menu_dumpcookies", function()
    _p(sql.Query("select * from cookies"))
end )

-- Test Panel
menu.TestPanel_p = menu.TestPanel_p or false

function menu.TestPanel(f)
    if menu.TestPanel_p then
        menu.TestPanel_p:Remove()
    end

    local p = vgui.Create("DFrame")
    p:SetSize(600, 600)
    p:Center()
    p:MakePopup()
    p:SetTitle("BlobMenu Test Panel - " .. debug.getinfo(2).short_src)

    f(p)

    menu.TestPanel_p = p
end