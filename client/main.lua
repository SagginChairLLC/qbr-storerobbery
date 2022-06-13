PlayerJob = exports['qbr-core']:GetPlayerData().job
local sharedItems = exports['qbr-core']:GetItems()
local currentRegister   = 0
local usingAdvanced = false

CreateThread(function()
    Wait(1000)
    if exports['qbr-core'].GetPlayerData().job ~= nil and next(exports['qbr-core'].GetPlayerData().job) then
        PlayerJob = exports['qbr-core'].GetPlayerData().job
    end
end)

CreateThread(function()
    Wait(1000)
    setupRegister()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        for k in pairs(Config.Registers) do
            local dist = #(pos - Config.Registers[k][1].xyz)
        end
        if not inRange then
            Wait(2000)
        end
        Wait(3)
    end
end)

RegisterNetEvent('lockpicks:UseLockpick', function(isAdvanced)
    usingAdvanced = isAdvanced
    for k in pairs(Config.Registers) do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - Config.Registers[k][1].xyz)
        if dist <= 1 and not Config.Registers[k].robbed then
                if usingAdvanced then
                    lockpick(true)
                    currentRegister = k
                else
                    lockpick(true)
                    currentRegister = k

                end
        end
    end
end)

function setupRegister()
    exports['qbr-core']:TriggerCallback('qbr-storerobbery:server:getRegisterStatus', function(Registers)
        for k in pairs(Registers) do
            Config.Registers[k].robbed = Registers[k].robbed
        end
    end)
end

function lockpick(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool,
    })
    SetCursorLocation(0.5, 0.2)
end

local openingDoor = false

-- if success
RegisterNUICallback('success', function(_, cb)
    if currentRegister ~= 0 then
        lockpick(false)
        TriggerServerEvent('qbr-storerobbery:server:setRegisterStatus', currentRegister)
        local lockpickTime = 10000
            exports['qbr-core']:Progressbar("search_register", "Stealing Cash", lockpickTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "script_ca@cachr@ig@ig4_vaultloot",
                anim = "ig13_14_grab_money_front01_player_zero",
                flags = 1,
            }, {}, {}, function() -- Done
                openingDoor = false
                ClearPedTasks(PlayerPedId())     
                print("Success")
                TriggerServerEvent('qbr-storerobbery:server:takeMoney')
            end, function() -- Cancel
                openingDoor = false
                ClearPedTasks(PlayerPedId())
                exports['qbr-core']:Notify(8, 'Lockpick Cancelled', 5000, '', 'itemtype_textures', 'itemtype_player_deadeye', 'COLOR_GREEN')
                currentRegister = 0
            end)
        CreateThread(function()
            while openingDoor do
                TriggerServerEvent('hud:server:GainStress', math.random(1, 3))
                Wait(10000)
            end
        end)
    else
        SendNUIMessage({
            action = "kekw",
        })
    end
    cb('ok')
end)

--if fail
RegisterNUICallback('fail', function(_ ,cb)
    if usingAdvanced then
        if math.random(1, 100) < Config.AdvLockpickBreak  then
            TriggerServerEvent('QBCore:Server:RemoveItem', "advancedlockpick", 1)
            TriggerEvent("inventory:client:ItemBox", sharedItems["advancedlockpick"], "remove")
        end
    else
        if math.random(1, 100) < Config.LockpickBreak then
            TriggerServerEvent('QBCore:Server:RemoveItem', "lockpick", 1)
            TriggerEvent("inventory:client:ItemBox", sharedItems["lockpick"], "remove")
        end
    end
    lockpick(false)
    cb('ok')
end)

RegisterNUICallback('exit', function(_, cb)
    lockpick(false)
    cb('ok')
end)

RegisterNetEvent('qbr-storerobbery:client:setRegisterStatus', function(batch, val)
    -- Has to be a better way maybe like adding a unique id to identify the register
    if(type(batch) ~= "table") then
        Config.Registers[batch] = val
    else
        for k in pairs(batch) do
            Config.Registers[k] = batch[k]
        end
    end
end)
