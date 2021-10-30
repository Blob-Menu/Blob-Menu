
--[[ 
    countries to add:

    kp
    bi
    cl
    se
    es
    br
    un
    eu
    gb
    ru
    de
    tr
    uk
    ch
    pl
    no
    cz
    dk
    ua
    fi
    ly
    cn
    tw
    kr
    ar
    au
    nz
    th
]]

-- this is for servers to show what country their from, brief representation of their flags

menu.country_flags = {}

-- YEAA BABY LETS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
-- AMERICA WOOOOOOOOOO YEAAAAAAAAAAAAAAAAAAHHHHHHHHHHH LETS GOOOO
menu.country_flags.us = function(w, h)
    draw.NoTexture()
    surface.SetDrawColor(255, 255, 255)

    local amt = 4
    local hh = h / amt
    for i = 0, amt do
        if i % 2 == 0 then
            surface.SetDrawColor(255, 57, 57)
        else
            surface.SetDrawColor(255,255,255)
        end

        local y = hh * i
        surface.DrawPoly({
            {x = 0, y = y},
            {x = 0, y = y - hh},
            {x = w, y = y},
            {x = w, y = y + hh}
        })
    end

    surface.SetDrawColor(74, 74, 255)
    surface.DrawPoly({
        {x = 0, y = h},
        {x = 0, y = 0},
        {x = w, y = 0}
    })
end

menu.country_flags.ca = function(w, h)
    draw.NoTexture()
    surface.SetDrawColor(255, 57, 57)
    surface.DrawRect(0, 0, w, h / 4)

    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(0, h / 4, w, h / 2)

    surface.SetDrawColor(255, 57, 57)
    surface.DrawRect(0, h - h / 4, w, h / 4)
end

menu.country_flags.ru = function(w, h)
    draw.NoTexture()
    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(0, 0, w, h / 3)

    surface.SetDrawColor(74, 74, 255)
    surface.DrawRect(0, h / 3, w, h / 3)

    surface.SetDrawColor(255, 57, 57)
    surface.DrawRect(0, h - h / 3, w, h / 3)
end

menu.country_flags.fr = function(w, h)
    draw.NoTexture()
    surface.SetDrawColor(74, 74, 255)
    surface.DrawRect(0, 0, w / 3, h)

    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(w / 3, 0, w / 3, h)

    surface.SetDrawColor(255, 57, 57)
    surface.DrawRect(w / 3 * 2, 0, w / 3, h)
end
