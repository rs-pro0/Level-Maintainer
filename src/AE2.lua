local component = require("component")
local ME = component.me_interface

local AE2 = {}

function AE2.updateSystemInfo()
    AE2.craftables = ME.getCraftables()
    AE2.items_in_network = ME.getItemsInNetwork()
end

function AE2.getFirstCraftable(name)
    for _, craftable in ipairs(AE2.craftables) do
        local item = craftable.getItemStack()
        if item.label == name then
            return craftable
        end
    end
    return nil
end

function AE2.getFirstItemInNetwork(name)
    for _, item in ipairs(AE2.items_in_network) do
        if item.label == name then
            return item
        end
    end
    return nil
end

function AE2.requestItem(name, threshold, count)
    logInfo("request start")
    local craftable = AE2.getFirstCraftable(name)
    logInfo("got craftable")
    if craftable ~= nil then
        local item = craftable.getItemStack()
        logInfo("got item stack")
        if threshold ~= nil then
            local item_in_network = AE2.getFirstItemInNetwork(name)
            if (item_in_network ~= nil and item_in_network["size"] > threshold) then
                return table.unpack({ false, "The amount of " ..
                name .. " exceeds threshold! Aborting request." })
            end
        end
        if item.label == name then
            local craft = craftable.request(count)

            while false do
                os.sleep(1)
            end
            if craft.hasFailed() then
                return table.unpack({ false, "Failed to request " .. name .. " x " .. count })
            else
                return table.unpack({ true, "Requested " .. name .. " x " .. count })
            end
        end
    end
    return table.unpack({ false, name .. " is not craftable!" })
end

function AE2.checkIfCrafting()
    local cpus = ME.getCpus()
    local items = {}
    for k, v in pairs(cpus) do
        local finaloutput = v.cpu.finalOutput()
        if finaloutput ~= nil then
            items[finaloutput.label] = true
        end
    end

    return items
end

return AE2
