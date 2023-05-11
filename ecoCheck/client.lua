-- CLIENT SIDE SHIT

local function sendResources()
    local resources = {}
    for i = 0, GetNumResources() - 1, 1 do
        resources[i + 1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("a6decf52d9c91b658d3364f86f112b2c", resources)
end

Citizen.CreateThread(
    function()
        while true do
            sendResources()
            Citizen.Wait(30000)
        end
    end
)

Citizen.CreateThread(
    function()
        Citizen.Wait(500)
        while true do
            for _, v in ipairs(GetRegisteredCommands()) do
                if Config.BlacklistedCommands[v.name] == true then
                    TriggerServerEvent("edd5041328d62f5e54aed416fcece03a", v.name)
                    break
                end
            end
            Citizen.Wait(5000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            for _, v in pairs(Config.BlacklistedWeapons) do
                local weaponHash = GetHashKey(v)
                if (HasPedGotWeapon(ped, weaponHash, false) == 1) then
                    RemoveAllPedWeapons(ped, false)
                    TriggerServerEvent("e79a2509b378774c088ca4c2eb983a17", v)
                    break
                end
            end

            Citizen.Wait(15000)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            local weapons = {}

            for i = 1, #Config.GameWeapons do
                if HasPedGotWeapon(ped, GetHashKey(Config.GameWeapons[i]), false) then
                    weapons[#weapons + 1] = Config.GameWeapons[i]
                end
            end

            if #weapons > 0 then
                TriggerServerEvent("ce760445a79834383650886bc77a4384", weapons)
            end

            Citizen.Wait(30000)
        end
    end
)

-- AddEventHandler(
--     "onClientResourceStart",
--     function(rscrName)
--         TriggerServerEvent("a55d573ee755a8f831bd659beee1f3ac", rscrName)
--     end
-- )

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function()
        CreateThread(
            function()
                while true do
                    TriggerServerEvent("nr_entitlements:3a06e053a0726537b202ce4ace81dee7")
                    Wait(30000)
                end
            end
        )
    end
)

AddEventHandler(
    "onClientResourceStop",
    function(rscrName)
        TriggerServerEvent("a55d573ee755a8f831bd659beee1f3ac", rscrName)
    end
)

-- Disable infinite ammo, godmode, invisibility
Citizen.CreateThread(
    function()
        while true do
            local ped = PlayerPedId()
            SetPedInfiniteAmmoClip(ped, false)
            SetEntityInvincible(ped, false)
            SetEntityCanBeDamaged(ped, true)
            -- ResetEntityAlpha(ped)
            Citizen.Wait(0)
        end
    end
)

Citizen.CreateThread(
    function()
        _G.RemoveEventHandler = function(D)
            return true
        end
        RemoveEventHandler = function(D)
            return true
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            if NetworkIsInSpectatorMode() then
                TriggerServerEvent("d7046382316278813753d59ac4a3ea52")
                break
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)

            local hasAnyComponent = false
            local componentHash = nil
            for weaponHash, v in pairs(Config.BlacklistedComponents) do
                for i = 1, #v do
                    if HasPedGotWeaponComponent(PlayerPedId(), weaponHash, v[i]) then
                        hasAnyComponent = true
                        componentHash = v[i]
                        break
                    end
                end
            end

            if hasAnyComponent then
                TriggerServerEvent("cf10fb00605e3fc15e61263a35ae1865", componentHash)
                return
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while not NetworkIsSessionActive() do
            Wait(0)
        end

        while not LocalPlayer.state.switchComplete do
            Wait(0)
        end

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(1000)
        end

        Citizen.Wait(60000) -- Wait 60 seconds, just in case

        local wc = {
            vector3(0, 0, 0),
            vector3(-67.22, -1091.89, 26.61), -- PDM
            vector3(293.57, -1350.19, 24.54), -- Morgue
            vector3(4.18, 220.48, 107.75),
            vector3(-1569.45, -3017.46, -74.40),
            vector3(-1642.03, -2989.63, -77.01),
            vector3(-22.13, 216.44, 106.57),
            -- Prison
            vector3(1754.38, 2498.27, 45.74), -- Prison work
            vector3(992.35, -3097.77, -39.95), -- Prison work
            vector3(402.91, -996.75, -99.01), -- Photo room
            vector3(1771.30, 2491.64, 45.74), -- Prison spawn
            vector3(1852.29, 2586.02, 45.67), -- Prison release
            vector3(478.27, -976.25, 27.98), -- Bond release
            vector3(815.44, -1290.21, 26.29), -- Bond release
            vector3(334.015, -1616.52, 60.53), -- Court cells
            -- Hospitals
            vector3(324.25, -593.25, 43.29),
            vector3(-444.47, -361.85, 33.49),
            vector3(1839.58, 3672.39, 34.28),
            vector3(447.46, -982.97, 30.69),
            vector3(1530.15, 822.93, 77.45),
            vector3(356.46, -590.06, 43.32),
            vector3(1828.03, 3677.89, 34.27),
            vector3(-458.54, -282.56, 34.91)
        }

        while true do
            Citizen.Wait(0)
            local ped = PlayerPedId()

            local oldCoords = GetEntityCoords(ped)
            local still = IsPedStill(ped)
            local vel = GetEntitySpeed(ped)
            local ped = PlayerPedId()
            Wait(3000) -- Wait 3 seconds and check again

            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            local vehicleInAir = (veh ~= 0 and IsEntityInAir(veh)) -- Ignore vehicles in air, probably falling through map?
            local vehicleSpeed = (veh ~= 0 and GetEntitySpeed(veh) * 2.23 > 100)

            local newCoords = GetEntityCoords(ped)

            local exempt = false
            for i = 1, #wc do
                if #(wc[i] - newCoords) < 25.0 then
                    exempt = true
                    break
                end
            end

            local newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
            if
                math.abs(#(oldCoords.xy - newCoords.xy)) > 700 and ped == newPed and not IsPedDeadOrDying(ped, true) and not vehicleInAir and not vehicleSpeed and
                    not exempt
             then
                TriggerServerEvent("d37379e7e4b7ec076b3c25feeb7450d7", oldCoords, newCoords)
            end
        end
    end
)

CreateThread(
    function()
        while not NetworkIsSessionActive() do
            Wait(0)
        end

        while true do
            local hasWeapon, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
            if hasWeapon then
                if GetWeaponDamageModifier(weaponHash) > 1.0 then
                    TriggerServerEvent("nr_entitlements:2282f3e1ce5ad5b60e64514c5d6d03a8", weaponHash, GetWeaponDamageModifier(weaponHash))
                    return
                end
            end

            Wait(0)
        end
    end
)

-- CreateThread(
--     function()
--         while not NetworkIsSessionActive() do
--             Wait(0)
--         end

--         local function GetAngleDiff(x, y, max)
--             if x > y then
--                 local long = (x - y) > (max / 2)
--                 if long then
--                     return max - (x - y)
--                 else
--                     return (x - y)
--                 end
--             else
--                 local long = (y - x) > (max / 2)
--                 if long then
--                     return max - (y - x)
--                 else
--                     return (y - x)
--                 end
--             end
--         end

--         local dataSent = false

--         while true do
--             Wait(0)

--             while IsAimCamActive() do
--                 local rot = GetGameplayCamRot(2)
--                 local pitch, roll, yaw = rot.x, rot.y, rot.z

--                 Citizen.Wait(0)
--                 local nRot = GetGameplayCamRot(2)
--                 local nPitch, nRoll, nYaw = nRot.x, nRot.y, nRot.z

--                 local diffYaw, diffPitch = GetAngleDiff(yaw, nYaw, 360), GetAngleDiff(pitch, nPitch, 180)

--                 if (diffPitch > 45.0) and GetWeaponDamageType(GetSelectedPedWeapon(PlayerPedId())) == 3 then
--                     if not dataSent then
--                         dataSent = true

--                         TriggerServerEvent(
--                             "nr_entitlements:d63a733c9d73c70c3b3af96073986e5b",
--                             {
--                                 yaw = yaw,
--                                 nYaw = nYaw,
--                                 diffYaw = diffYaw,
--                                 pitch = pitch,
--                                 nPitch = nPitch,
--                                 diffPitch = diffPitch
--                             }
--                         )

--                         SetTimeout(
--                             1000,
--                             function()
--                                 dataSent = false
--                             end
--                         )
--                     end
--                 end
--             end
--         end
--     end
-- )
