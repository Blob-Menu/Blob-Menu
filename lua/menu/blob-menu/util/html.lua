
menu.html = menu.html or {}

function menu.html.Color(col)
    if isstring(col) then
        return col
    end
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
        * {
            transition:background-color 0.2s, color 0.2s, fill 0.2s;
        }

        *::-webkit-scrollbar {
            width:7px;
            border-radius:4px;
            background:var(--background);
        }

        *::-webkit-scrollbar-thumb {
            width:5px;
            margin:1px;
            border-radius:4px;
            background:var(--accent);
        }
        
        .button {
            display:flex;
            flex-shrink: 0;

            height:7%;
            background:var(--accent);

            text-align:center;
            font-size:30px;
            border-radius:15px;

            user-select:none;
            cursor:pointer;

            transition: text-shadow 0.2s;
        }

        .button > .inner {
            margin:auto;
        }

        .button:hover {
            text-shadow: 2px 2px 5px #000;
        }

        :root{
            --global-alpha:1;
            --accent:]] .. menu.html.Color(menu.colors.accent1) .. [[;
            --accent-transparent:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .3)) .. [[;
            --accent-transparent-5:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .5)) .. [[;
            --accent-transparent-7:]] .. menu.html.Color(ColorAlpha(menu.colors.accent1, 255 * .7)) .. [[;
            --background-light:]] .. menu.html.Color(Color(math.max(menu.colors.background.r - 20, 0), math.max(menu.colors.background.g - 20, 0), math.max(menu.colors.background.b - 20, 0))) .. [[;
            ]] .. css .. [[
        }
        body {
            padding:0;
            margin:0;

            opacity:var(--global-alpha);
        }
    ]]
end