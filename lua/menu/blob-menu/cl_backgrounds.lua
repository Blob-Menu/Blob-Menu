
menu.backgrounds = {}
for k,v in pairs(select(1, file.Find("menu/blob-menu/backgrounds/*", "LuaMenu"))) do
    menu.backgrounds[string.StripExtension(v)] = file.Read("menu/blob-menu/backgrounds/" .. v, "LuaMenu")
end