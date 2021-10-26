
menu = menu or {}
menu.templates = menu.templates or {}

function menu.templates.EvalIf(toeval, vals)
    local split = string.Split(toeval:Trim(), "\n")
    local exprs = {}
    local built = {}

    for k,v in ipairs(split) do
        local tr = v:Trim()
        if tr:StartWith("if") then
            exprs.open = "if"
            exprs.lines = {}
            exprs.defline = v
        elseif tr:StartWith("else:") then
            built[exprs.open] = {
                exprs.defline,
                exprs.lines
            }
            exprs.defline = v
            exprs.open = "else"
            exprs.lines = {}
        else
            table.insert(exprs.lines, v)
        end

        if exprs.open then
            built[exprs.open] = {
                exprs.defline,
                exprs.lines
            }
        end
    end

    local iff = built["if"][1]
    iff = iff:sub(4, #iff - 1)
    if menu.templates.EvalValue(iff, vals) then
        return table.concat(built["if"][2], "\n")
    else
        return table.concat(built["else"][2], "\n")
    end

    return "ifhere"
end

function menu.templates.EvalValue(toeval, vals)
    local split = string.Split(toeval, ".")

    if #split == 1 then
        return tostring(vals[split[1]])
    end

    local down = vals[tonumber(split[1]) or split[1]]
    for i = 2, #split do
        down = down[tonumber(split[i]) or split[i]]
    end

    return down
end

function menu.templates.Eval(toeval, vals)
    if toeval:Trim():StartWith("if") then
        return menu.templates.EvalIf(toeval, vals)
    end

    return tostring(menu.templates.EvalValue(toeval, vals))
end

function menu.templates.Render(str, values)
    local x = string.gsub(str, "{{(.-)}}", function(toeval)
        return menu.templates.Eval(toeval, values)
    end )
    return x
end

-- print(menu.templates.Render([[
-- whatever.value {{whatever.value}}
-- whatever {{whatever}}
-- whatever.nested {{whatever.nested}}
-- whatever.nested.1 {{whatever.nested.1}}
-- whatever.nested.baLLs {{whatever.nested.baLLs}}

-- {{
-- if whatever.nested.1:
--     this is yes
-- else:
--     this is no
-- }}

-- ]], {
--     whatever = {
--         value = 123,
--         nested = {
--             true,
--             baLLs = false
--         }
--     }
-- }))