function setWhite()
    love.graphics.setColor(1, 1, 1, 1)
end




string.startswith = function(self, str) 
    return self:find('^' .. str) ~= nil
end


function tableToString(tbl)
    local result = "return {"

    for k, v in pairs(tbl) do 
        if type(k) == "string" then 
            result = result .. "[\"" .. k .. "\"]="
        else
            result = result .. "[" .. k .. "]="
        end

        if type(v) == "table" then 
            result = result .. tableToString(v) .. ","
        elseif type(v) == "string" then 
            result = result .. "\"" .. v .. "\","
        elseif type(v) == "number" or type(v) == "boolean" then 
            result = result ..tostring(v) .. ","
        end
    end

    result = result .. "}"
    return result
end


function stringToTable(str)
    local func = load(str)

    if func then 
        return func()
    else 
        return {}
    end
end
