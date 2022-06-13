local sharedItems = exports['qbr-core']:GetItems()

RegisterServerEvent('qbr-storerobbery:server:takeMoney')
AddEventHandler('qbr-storerobbery:server:takeMoney', function()
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)

    if Config.RewardType == true then
    Player.Functions.AddItem(Config.RewardItem, Config.RewardAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[Config.RewardItem], "add")
    else
    Player.Functions.AddMoney(Config.CurrencyType, Config.CurrencyAmount)
    end
end)

RegisterNetEvent('qbr-storerobbery:server:setRegisterStatus', function(register)
    Config.Registers[register].robbed = true
    Config.Registers[register].time = Config.resetTime
    TriggerClientEvent('qbr-storerobbery:client:setRegisterStatus', -1, register, Config.Registers[register])
end)

CreateThread(function()
    while true do
        local toSend = {}
        for k in ipairs(Config.Registers) do

            if Config.Registers[k].time > 0 and (Config.Registers[k].time - Config.tickInterval) >= 0 then
                Config.Registers[k].time = Config.Registers[k].time - Config.tickInterval
            else
                if Config.Registers[k].robbed then
                    Config.Registers[k].time = 0
                    Config.Registers[k].robbed = false
                    toSend[#toSend+1] = Config.Registers[k]
                end
            end
        end

        if #toSend > 0 then
            TriggerClientEvent('qbr-storerobbery:client:setRegisterStatus', -1, toSend, false)
        end

        Wait(Config.tickInterval)
    end
end)

exports['qbr-core']:CreateUseableItem("lockpick", function(source, item)
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("lockpicks:UseLockpick", src)
	end
end)

exports['qbr-core']:CreateUseableItem("advancedlockpick", function(source, item)
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("lockpicks:UseLockpick", src)
	end
end)
