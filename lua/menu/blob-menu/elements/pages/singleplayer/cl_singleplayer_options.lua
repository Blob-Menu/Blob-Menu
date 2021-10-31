
local PANEL = {}

function PANEL:Init()
    self:AddFunction("blob", "Create", function()
        hook.Run("StartGame")

        RunConsoleCommand("progress_enable")
        RunConsoleCommand("disconnect")
        RunConsoleCommand("maxplayers", 120)
        RunConsoleCommand("sv_cheats", 0)
        RunConsoleCommand("commentary", 0)

        timer.Simple(0.4, function()
            RunConsoleCommand("hostname", "Server Name : BlobMenu")
            RunConsoleCommand("p2p_enabled", 0)
            RunConsoleCommand("p2p_friendsonly", 0)
            RunConsoleCommand("sv_lan", 1)
            RunConsoleCommand("maxplayers", "120")
            RunConsoleCommand("map", self:GetParent().activemap)
        end )
    end )

    self:GenerateHTML()

    menu.themes.Watch(self, self.GenerateHTML)
end

function PANEL:GenerateHTML()
    self:SetHTML(menu.templates.Render([[
        <style>
            {{base_style}}

            body {
                display:flex;
                flex-direction:column-reverse;
                font-family:"Poppins";
                color:#FFF;
            }

            .start {
                display:flex;
                flex-shrink: 0;
                height:7%;
   
                margin:10px;
                
                background:linear-gradient(45deg, var(--accent1) 0%, var(--accent_dark) 100%);
    
                text-align:center;
                font-size:30px;
                border-radius:15px;
    
                user-select:none;
                cursor:pointer;
    
                transition: text-shadow 0.2s;
            }

                
            .start > .inner {
                margin:auto;
            }

            .start:hover {
                text-shadow: 2px 2px 5px #000;
            }
        </style>

        <div class="start" onclick="blob.Create()">
            <div class="inner">
                Start Game
            </div>
        </div>
    ]], {
        base_style = menu.html.BaseCSS()
    }))
end

vgui.Register("Menu:Singleplayer:Options", PANEL, "Menu:HTML")