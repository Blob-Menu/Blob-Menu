
local PANEL = {}

function PANEL:Init()
    self.gms = vgui.Create("Menu:Pages:Multiplayer:Gamemodes", self)

    -- top stuff:
    self.top = vgui.Create("DHTML", self)
    self.top:MakePopup()
    self.top:AddFunction("blob", "ChangeType", function(type)
        self.gms:GenerateTab(type)
    end )
    self.top:SetHTML([[
        <style>
            @import url("https://fonts.googleapis.com/css2?family=Poppins");
            :root {
                --accent:rgb(]] .. menu.colors.accent1.r .. "," .. menu.colors.accent1.g .. "," .. menu.colors.accent1.b .. [[);
                --accent-transparent:rgba(]] .. menu.colors.accent1.r .. "," .. menu.colors.accent1.g .. "," .. menu.colors.accent1.b .. [[, 0.6);
                --background:rgb(]] .. menu.colors.background.r .. "," .. menu.colors.background.g .. "," .. menu.colors.background.b .. [[);
            }

            body {
                margin:0px;
              
                font-family:"Poppins";
                color:#FFF;
                display:flex;
                flex-direction:row-reverse;
            }
            #search {
                width:200px;
                height:40px;
                margin-top:auto;
                margin-bottom:auto;
                background:transparent;
                border-radius:10px 10px 5px 5px;
                border-style:solid;
                border-color:#2e2e2e;
                border-width:2px;

                font-family:"Poppins";
                transition: border-color 0.2s;

                color:#FFF;
                background:var(--background);

                margin-right:5px;
                
                padding:5px;
            }
            #search:focus {
                border-color:var(--accent);
                outline-width:0;
                box-shadow: 0px 0px 5px rgb(5, 5, 5)
            }

            .types {
                display:flex;
                border-width:2px;
                border-color:rgba(255,255,255,0.1);
                border-style:solid;
                border-radius:10px 10px 5px 5px;
                height:50px;
                justify-content:space-evenly;
                overflow:hidden;
                user-select:none;
                margin-top:auto;
                margin-bottom:auto;
                margin-right:auto;
                background:var(--background);
            }

            .types > div {                
                flex-grow:1;
                text-align:center;
                vertical-align:center;
                line-height:50px;

                border-bottom-style:solid;
                border-bottom-width:0px;
                border-bottom-color:var(--accent-transparent);

                cursor:pointer;
                transition:border-bottom-width 0.2s, border-bottom-color 0.2s;
                padding-left:20px;
                padding-right:20px;
            }

            .types > div:hover {
                border-bottom-color:var(--accent-transparent);
                border-bottom-width:4px;
            }

            .types > div.active {
                transition:border-bottom-width 0.4s, border-bottom-color 0.2s;
                border-bottom-color:var(--accent);
                border-bottom-width:50px;
            }
        </style>

        <input type="text" id="search" placeholder="Search Servers...">
    
        <div class="types" id="types">
            <div class="active" id="internet" onclick="ct('internet')">Internet</div>
            <div id="favorite" onclick="ct('favorite')">Favorites</div>
            <div id="history" onclick="ct('history')">History</div>
            <div id="lan" onclick="ct('lan')">LAN</div>
            <div id="blacklisted" onclick="ct('blacklisted')">Blacklisted</div>
        </div>

        <script>
            function ct(type) {
                blob.ChangeType(type);

                var el = document.getElementById("types");

                for(var child = el.firstChild; child!=null; child=child.nextSibling) {
                    child.className = "";
                }

                document.getElementById(type).className = "active";
            }
        </script>
    ]])
end

function PANEL:PerformLayout(w,h)
    self:DockPadding(200, 84, 200, 80)
    self.top:Dock(TOP)
    self.top:SetTall(70)
    self.gms:Dock(FILL)
end

vgui.Register("Menu:Page:Multiplayer", PANEL, "Panel")