
function menu.GetServerRanking(args)
    return args.players
    + (args.isanon and -1000 or 10)
    - (args.ping / 20)
end