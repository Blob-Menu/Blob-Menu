
function serverlist.Args2Table(ping,name,desc,map,ply,max,bots,pass,last,ip,gm,wsid,isanon,ver,loc,gmcat)
    loc = (loc or "us"):lower()
    return {
        ping = ping,
        name = name,
        desc = desc,
        map = map,
        players = ply,
        maxplayers = max,
        bots = bots,
        password_required = pass,
        lastplayed = last,
        ip = ip,
        gm = gm,
        wsid = wsid,
        isanon = isanon,
        ver = ver,
        loc = loc,
        gmcat = gmcat,
    }
end