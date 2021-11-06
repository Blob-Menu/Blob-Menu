
local PANEL = {}

function PANEL:Init()
    self.maps = vgui.Create("Menu:HTML", self)
    self.options = vgui.Create("Menu:Singleplayer:Options", self)

    self.maps:AddFunction("blob", "SetMap", function(s)
        self.activemap = s

        self.maps:RunJavascript([[
            var x = document.getElementsByClassName("map")
            for (var i = 0; i < x.length; i++) {
                x[i].classList.remove("active")

                if (x[i].id == "]] .. s .. [[") {
                    x[i].classList.add("active")
                }
            }
        ]])
    end )

    self:MapHTML()

    menu.themes.Watch(self.maps, true)
end

function PANEL:PerformLayout(w, h)
    h = h - 160
    self.maps:SetSize(w - w / 6, h)
    self.maps:SetPos(0, 80)

    self.options:SetSize(w / 6, h)
    self.options:SetPos(self.maps:GetWide(), 80)
end

function PANEL:GenerateMapsHTML()
    local toret = ""
    for k,v in pairs(GetMapList()) do
        toret = toret .. "<div class='header'>"
        toret = toret .. "<div class='name'>" .. k .. "</div>"
        toret = toret .. "<div class='maps'>"

        for kk,vv in pairs(v) do
            self.activemap = self.activemap or vv
            local img = "asset://mapimage/" .. vv

            if k == "INFRA" then
                img = "img/incompatible.png"
            end

            toret = toret .. "<div onclick='blob.SetMap(\"" .. vv .. "\")' id='" .. vv .. "' class='map " .. (self.activemap == vv and "active" or "") ..  "' style='background-image:url(" .. img .. ")'><div>" .. vv .. "</div></div>"
        end

        toret = toret .. "</div></div>"
    end

    return toret
end

function PANEL:MapHTML()
    self.maps:SetHTML(menu.templates.Render([[
    <style>
        {{base_style}}

        body {
            padding:20px;
        }

        .map_root {
            display:flex;
            flex-direction:column;
            flex-wrap:wrap;

            overflow-x:hidden; 

            overflow-y:auto;
        }

        .header {
            margin-bottom:20px;
        }

        .header > .name {
            font-family: "Poppins";
            color:#FFF;
            font-size:70px;
        }

        .header > .maps {
            display:flex;
            flex-direction:row;
            flex-wrap:wrap;
        }

        .header > .maps > .map {
            background-position: center center;
            background-size:cover;
            width:150px;
            height:150px;
            border-radius:15px;
            margin:6px;
            display:flex;
            flex-direction:column-reverse;
            overflow:hidden;

            cursor:pointer;
            user-select:none;
            color:var(--inactive_map);

            transition: color 0.1s;
        }

        .header > .maps > .map.active {
            width:146px; 
            height:146px;
            border:solid var(--accent) 2px;
            box-shadow: 0px 0px 6px var(--accent);
            color:var(--active_map);
        }

        .header > .maps > .map > div {
            height:20px;
            font-family: "Poppins";
            font-size:14px;
            text-align:center;
            background:var(--accent-transparent-7);
            padding:5px;

            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
    <div class="map_root">
        {{maplist}}
    </div>

    ]], {
        base_style = menu.html.BaseCSS(),
        maplist = self:GenerateMapsHTML()
    }))
end

vgui.Register("Menu:Page:Singleplayer", PANEL, "Panel")