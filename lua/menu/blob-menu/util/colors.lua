
function menu.LerpColor(amt, from, to)
    return Color(
        Lerp(amt, from.r, to.r),
        Lerp(amt, from.g, to.g),
        Lerp(amt, from.b, to.b),
        Lerp(amt, from.a, to.a)
    )
end

-- If a hex value is F this will make it 0F
local function fill(str)
    if #str == 2 then return str end

    return "0" .. str
end

function menu.ToHex(clr)
    local r = fill(string.format("%x", clr.r or 255))
    local g = fill(string.format("%x", clr.g or 255))
    local b = fill(string.format("%x", clr.b or 255))
    local a = fill(string.format("%x", clr.a or 255))

    return r .. g .. b .. a
end

function menu.HexToColor(hex)

    if not menu.IsValidHex(hex) then return false end
    hex = string.gsub(hex, "#", "")

    return Color(
        tonumber("0x" .. (hex:sub(1, 2) or "FF")),
        tonumber("0x" .. (hex:sub(3, 4) or "FF")),
        tonumber("0x" .. (hex:sub(5, 6) or "FF")),
        tonumber("0x" .. (hex:sub(7, 8) or "FF"))
    )
end

function menu.IsValidHex(hex)
    if not hex then return false end
    hex = string.gsub(hex, "#", ""):lower()

    if #hex < 6 or #hex > 8 or #hex == 7 then
        return false, "Bad Length"
    end

    if #string.gsub(hex, "[a-f0-9]", "") > 0 then
        return false, "Invalid Character(s)"
    end

    return true
end