
local PANEL = {}

function PANEL:Init()
    self.serverinfo = {}
    self.serverdata = {}
    self.html = vgui.Create("DHTML", self)
    self.html:AddFunction("blob", "Join", function()
        JoinServer(self.serverdata.ip)
    end )

    self.loading = true
end

function PANEL:PerformLayout(w,h)
    self.html:SetSize(w, h - 8)
    self.html:SetPos(0, 0)
end

function PANEL:FormatPlayers(plys)
    local toret = ""

    if #plys == 0 then
        return "<div class=\"none\">No Players</div>"
    end

    for k,v in pairs(plys) do
        toret = toret .. [[<div class="player">]] .. v.name .. [[</div>]]
    end

    -- toret = string.rep("<div class=\"player\">This is a players name blah blah blah</div>", 100)

    return toret
end

function PANEL:UpdateServer(args, svinfo)
    if (self.args and self.args.ip) == args.ip then
        return
    end

    self.args = args

    self.serverdata = args
    self.serverinfo = svinfo
    self.playerhtml = "<div class=\"none\">Loading...</div>"
    self.loading = true

    self:UpdateHTML({
        description = "Loading...",
        image = "",
        tags = {},
        features = {}
    }, args, "<div class=\"none\">Loading...</div>")

    if not svinfo then
        menu.GetServerInfo(args.ip, function(d)
            self.serverinfo = d
            if self.playerhtml then
                self:UpdateHTML(self.serverinfo, args, self.playerhtml)
            end
        end )
    end

    if args.players <= 1 then
        self.playerhtml = "<div class=\"none\">No Players</div>"
        self:UpdateHTML(self.serverinfo, args, self.playerhtml)
        return
    end

    serverlist.PlayerList(args.ip, function(plys)
        self.playerhtml = self:FormatPlayers(plys)

        if self.serverinfo then
            self:UpdateHTML(self.serverinfo, args, self.playerhtml)
        end
    end )
end

function PANEL:UpdateHTML(server, args, plyhtml)
    if not server then
        print("[BlobMenu] [Error] Attemping to set ActiveServer HTML with nil server ", "", server, args, plyhtml)
        return
    end

    self.loading = false
    self.html:SetHTML(menu.templates.Render([[
        <style>
        @import url("https://fonts.googleapis.com/css2?family=Poppins");
        {{basecss}}
    
        body {
            display: flex;
            flex-direction: row;
            color:var(--text);
            font-family:"Poppins";
            overflow:hidden;
        }
    
        .mid {
            margin:5px;
            padding:15px;
            flex-grow:2;
            overflow: hidden;
            border-radius:15px;
            background:{{background_col}};
        }

        .mid > .title {
            text-align:center;
            font-size:30px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width:100%;
        }

        .mid > .title:after {
            content: "";
            display:block;
            width:100%;
            height:1px;
            background-color:var(--text2);
            margin-top:5px;
            margin-bottom:10px;
        }

        .mid > .description {
            font-size:20px;
        }
   
        .left {
            min-width:20%;
            max-width:20%;
            color:var(--text);
            margin:5px;
            padding:15px;
            flex-grow:1;
            border-radius:15px;
            background:{{background_col}};
            max-height:95%;
            display:flex;
            flex-direction:column;
        }

        .left > .header {
            height:20%;
            background: url({{server.image}});
            background-size:cover;
            background-position: center center;
            border-radius:15px;
            flex-shrink: 0;
        }

        .left > .players {
            flex-grow:1;
            max-height:73%;
            overflow-y:auto;
            margin:0px;
            margin-top:10px;
            margin-bottom:10px;
        }

        .left > .players::-webkit-scrollbar {
            width:7px;
            border-radius:4px;
            background:var(--background);
        }

        .left > .players::-webkit-scrollbar-thumb {
            width:5px;
            margin:1px;
            border-radius:4px;
            background:var(--accent1);
        }

        .left > .players > .player {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin:5px;
            color:#FFF;
        }

        .left > .players > .none {
            text-align:center;
            font-size:30px;
            color:#AAA;
            margin-top:auto;
            margin-bottom:auto;
        }

        .left > .join {
            display:flex;
            flex-shrink: 0;

            height:7%;
            background:linear-gradient(45deg, var(--accent1) 0%, var(--accent_dark) 100%);

            text-align:center;
            font-size:30px;
            border-radius:15px;

            user-select:none;
            cursor:pointer;

            transition: text-shadow 0.2s;
        }

        .left > .join > .inner {
            margin:auto;
        }

        .left > .join:hover {
            text-shadow: 2px 2px 5px #000;
        }
    </style>
    
    <div class="left">
        <div class="header"></div>
        <div class="players">
            {{players}}
        </div>
        <div class="join" onclick="blob.Join()">
            <div class="inner">Join</div>
        </div>
    </div>
    
    <div class="mid">
        <div class="title">{{args.name}}</div>
        <div class="description">{{server.description}}</div>
    </div>
    
    ]], {
        colors = menu.colors,
        basecss = menu.html.BaseCSS(),
        server = server or {},
        args = args,
        background_col = menu.html.Color(menu.colors.server_background),
        players = plyhtml
    }))
end

function PANEL:PaintOver(w,h)
    if self.loading then
        local size = 20
        surface.SetDrawColor(menu.colors.accent1)
        surface.DrawRect(w / 2 - (size / 2), h / 2 - (size / 2) + (math.sin((CurTime() + 20) * 7) * 50), size, size)
        surface.DrawRect(w / 2 - (size * 2) - size, h / 2 - (size / 2) + (math.sin((CurTime() + 10) * 7) * 50), size, size)
        surface.DrawRect(w / 2 + (size * 2), h / 2 - (size / 2) + (math.sin((CurTime() + 30) * 7) * 50), size, size)
    end
end

vgui.Register("Menu:Pages:Multiplayer:ActiveServer", PANEL, "Panel")