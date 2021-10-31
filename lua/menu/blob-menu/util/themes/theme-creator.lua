
menu.theme_creator = menu.theme_creator or {}
local theme = {}
theme.__index = theme
AccessorFunc(theme, "id", "ID")
AccessorFunc(theme, "Author", "Author")
AccessorFunc(theme, "Name", "Name")

function theme:Init()
    self.properties = {}
    for k,v in pairs(menu.original_colors) do
        self.properties[k] = v
    end
end

function theme:SetProperty(prop, val)
    self.properties[prop] = isstring(val) and menu.HexToColor(val) or val

    self:OnPropertyChange(prop, val)
end

function theme:OnPropertyChange(prop, val)
    menu:UpdateHTMLColor(prop, val)
end

function theme:Save()
    local props = {}
    for k,v in pairs(self.properties) do
        props[k] = menu.ToHex(v)
    end

    file.Write("../lua/menu/blob-menu/themes/" .. id .. ".json", util.TableToJSON({
        meta = {
            name = self:GetName(),
            author = self:GetAuthor()
        },
        colors = props
    }))
end

function menu.NewTheme()
    local thm = setmetatable({}, theme)
    thm:SetID("mytheme")
    thm:SetName("My Theme")
    thm:SetAuthor("Not Garry")

    table.insert(menu.theme_creator, thm)

    return thm
end