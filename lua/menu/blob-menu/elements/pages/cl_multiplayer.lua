
local PANEL = {}

function PANEL:ShowBackButton(id, t)
    if t == nil then
        t = self.backshow[id]
    end

    self.backshow[id] = t
    self.top:RunJavascript([[
        document.documentElement.style.setProperty("--back-display", "]] .. (t and "all" or "none") .. [[");
    ]])
end

function PANEL:ShowSearch(id, t)
    if t == nil then
        t = self.searchshow[id]
    end

    self.searchshow[id] = t
    self.top:RunJavascript([[
        document.documentElement.style.setProperty("--search-display", "]] .. (t and "all" or "none") .. [[");
    ]])
end

function PANEL:Init()
    menu.multiplayer = self
    self.backshow = {}
    self.searchshow = {}
    self.gms = vgui.Create("Menu:Pages:Multiplayer:Gamemodes", self)

    -- top stuff:
    self.top = vgui.Create("Menu:HTML", self)
    self.top:MakePopup()
    self.top:AddFunction("blob", "ChangeType", function(type)
        self.gms:GenerateTab(type)
    end )
    self.top:AddFunction("blob", "RunBackbuttonFunction", function()
        local tab = self.gms:GetActiveTab()

        if not tab.DoBack then print("Missing DoBack on ", tab, tab.id) return end
        self:ShowBackButton(tab.id, tab:DoBack())
    end)
    self.top:AddFunction("blob", "Refresh", function()
        self.gms:Refresh()
    end )
    self.top:AddFunction("blob", "OnSearch", function(s)
        local tab = self.gms:GetActiveTab()

        if tab.DoSearch then
            tab:DoSearch(s)
        end
    end )
    function self.top:UpdateHTML()
        self:SetHTML(menu.templates.Render([[
            <style>
                :root {
                    --accent:rgb(]] .. menu.colors.accent1.r .. "," .. menu.colors.accent1.g .. "," .. menu.colors.accent1.b .. [[);
                    --accent-transparent:rgba(]] .. menu.colors.accent1.r .. "," .. menu.colors.accent1.g .. "," .. menu.colors.accent1.b .. [[, 0.6);
                    --background:rgb(]] .. menu.colors.background.r .. "," .. menu.colors.background.g .. "," .. menu.colors.background.b .. [[);
                    --back-display:none;
                    --search-display:none;
                }
    
                body {
                    margin:0px;
                  
                    font-family:"Poppins";
                    color:#FFF;
                    display:flex;
                    flex-direction:row-reverse;
                }
                #search {
                    display:var(--search-display);
                    width:220px;
                    height:50px;
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
                    
                    padding:5px 10px 5px 10px;
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
                    background:var(--background);
                    margin-right:auto;
                }
    
                .types > div:first-child {
                    border-left:none;
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
        
                    border-left-style:solid;
                    border-left-width:1px;
                    border-color:rgba(255,255,255,0.1);
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
    
                .button {
                    height:50px;
                    border-radius:10px 10px 5px 5px;
                    margin-top:auto;
                    margin-bottom:auto;
                    background:var(--background);
                    padding-left:20px;
                    padding-right:20px;
                    vertical-align:center;
                    line-height:50px;
                    border-width:2px;
                    border-color:#2e2e2e;
                    border-style:solid;
                    user-select:none;
                    transition:background 0.2s;
                    cursor: pointer;
                    margin-left:10px;
                }
    
                .back-button {
                    display:var(--back-display);
                    margin-right:0px;
                    margin-left:10px;
                }
    
                .button:hover {
                    background:var(--accent);
                }
    
            </style>
    
            <div class="button" onclick="blob.Refresh()">Refresh</div>
            <div class="button back-button" onclick="blob.RunBackbuttonFunction()"> &lt; Back</div>
            <input type="text" id="search" placeholder="Search Servers..." oninput="blob.OnSearch(document.getElementById('search').value)">
    
            <div class="types" id="types">
                <div class="active" id="internet" onclick="ct('internet')">Internet</div>
                <div id="favorite" onclick="ct('favorite')">Favorites</div>
                <div id="history" onclick="ct('history')">History</div>
                <div id="lan" onclick="ct('lan')">LAN</div>
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
        ]], {
            base_style = menu.html.BaseCSS()
        }))
    end

    self.top:UpdateHTML()

    menu.themes.Watch(self.top, self.top.UpdateHTML)
end

function PANEL:PerformLayout(w,h)
    self:DockPadding(200, 84, 200, 80)
    self.top:Dock(TOP)
    self.top:SetTall(70)
    self.gms:Dock(FILL)
end

vgui.Register("Menu:Page:Multiplayer", PANEL, "Panel")