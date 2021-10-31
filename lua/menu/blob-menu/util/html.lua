
menu.html = menu.html or {}

function menu.html.Color(col)
    return "rgba(" .. col.r .. ", " .. col.g .. ", " .. col.b .. ", " .. (col.a or 255) / 255 .. ")"
end

function menu.html.Image(url, class)
    return [[<img class="]] .. (class or "image") .. [[" src="]] .. url .. [[" style="object-fit:cover;">]]
end

function menu.html.BaseCSS()
    local css = ""

    for k,v in pairs(menu.colors) do
        if not IsColor(v) then continue end
        css = css .. "--" .. k .. ": " .. menu.html.Color(v) .. ";"
    end

    return [[
        @import url("https://fonts.googleapis.com/css2?family=Poppins");
        *::-webkit-scrollbar {
            width:7px;
            border-radius:4px;
            background:var(--background);
        }

        *::-webkit-scrollbar-thumb {
            width:5px;
            margin:1px;
            border-radius:4px;
            background:var(--accent1);
        }

        :root{
            --accent:]] .. menu.html.Color(menu.colors.accent1) .. [[;
            --accent-transparent:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .3)) .. [[;
            --accent-transparent-5:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .5)) .. [[;
            --accent-transparent-7:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .7)) .. [[;
            ]] .. css .. [[
        }
        body {
            padding:0;
            margin:0;
        }

    ]]
end