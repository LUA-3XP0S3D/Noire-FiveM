function DrawTxt(text, x, y, scale, size, r, g, b, a)
    SetTextFont(0)
    SetTextColour(r or 255, g or 255, b or 255, a or 255)
    SetTextProportional(1)
    SetTextScale(scale, size)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local allweapons = {
    "WEAPON_UNARMED",
    --Melee
    "WEAPON_KNIFE",
    "WEAPON_KNUCKLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_DAGGER",
    "WEAPON_HATCHET",
    "WEAPON_MACHETE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_SWITCHBLADE",
    "WEAPON_POOLCUE",
    "WEAPON_PIPEWRENCH",
    --Thrown
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_BZGAS",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_SNOWBALL",
    "WEAPON_FLARE",
    "WEAPON_BALL",
    --Pistols
    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_RAYPISTOL",
    -- SMGs / MGs
    "WEAPON_MICROSMG",
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_GUSENBERG",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_RAYCARBINE",
    -- Assault Rifles
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_COMPACTRIFLE",
    --Shotguns
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    --Sniper Rifles
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_MARKSMANRIFLE_MK2",
    --Heavy Weapons
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHER_SMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_FIREWORK",
    "WEAPON_RAILGUN",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_COMPACTLAUNCHER",
    "WEAPON_RAYMINIGUN",
    "WEAPON_NR_MP5",
    "WEAPON_M9",
    "WEAPON_P226",
    "WEAPON_1911",
    "WEAPON_SAUER101",
    "WEAPON_G17",
    "WEAPON_WALTHER",
    "WEAPON_MPX",
    "WEAPON_MK18",
    "WEAPON_MAC10",
    "WEAPON_FNFAL",
    "WEAPON_USP",
    "WEAPON_METALDETECTOR",
    "WEAPON_TACTICALRIFLE"
}

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(playerData)
        TriggerServerEvent("9f6c0e6fc6876e7f8293f125d14144a6")
    end
)

RegisterNetEvent("9f6c0e6fc6876e7f8293f125d14144a6")
AddEventHandler(
    "9f6c0e6fc6876e7f8293f125d14144a6",
    function()
        TriggerServerEvent("fa7c7d8664cab7e3a61de5e07f7ba3b4")

        Citizen.Wait(5000)

        Citizen.CreateThread(
            function()
                while true do
                    local players = GetActivePlayers()
                    local myPed = PlayerPedId()

                    local camera = GetGameplayCamCoord()

                    local closestPed = nil
                    local closestDist = 1000.0
                    local aimPos = nil

                    for i = 1, #players do
                        local ped = GetPlayerPed(players[i])
                        local worldPos = GetEntityCoords(ped)

                        local dist = #(GetEntityCoords(myPed) - worldPos)

                        local output =
                            string.format("[%d] %s [%.0f m] %d", GetPlayerServerId(players[i]), GetPlayerName(players[i]), dist, GetEntityHealth(ped))

                        local retVal, screenX, screenY = GetScreenCoordFromWorldCoord(worldPos.x, worldPos.y, worldPos.z)

                        if screenX > 0.01 and screenY > 0.01 and screenX < 0.99 and screenY < 0.99 and ped ~= myPed then
                            if not IsPedDeadOrDying(ped, 1) then
                                local vehicleDisplay = nil
                                if IsPedInAnyVehicle(ped, false) and GetVehicleClass(GetVehiclePedIsIn(ped)) ~= 18 then
                                    vehicleDisplay = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(ped)))
                                end

                                local weaponHash = GetSelectedPedWeapon(ped)
                                local weaponOutput = nil
                                for j = 1, #allweapons do
                                    if GetHashKey(allweapons[j]) == weaponHash then
                                        weaponOutput = allweapons[j]
                                        break
                                    end
                                end

                                local bonePos = GetPedBoneCoords(ped, 31086, 0.1, 0, 0)
                                local _, boneX, boneY = GetScreenCoordFromWorldCoord(bonePos.x, bonePos.y, bonePos.z)
                                DrawTxt("^", boneX, boneY, 0.0, 0.1)

                                local result, hit, endCoords, surfaceNormal, entityHit = 0, 0, 0, 0, 0

                                if not IsPedInAnyVehicle(ped, false) and dist < 150.0 then
                                    local shapetest = StartShapeTestCapsule(camera.x, camera.y, camera.z, bonePos.x, bonePos.y, bonePos.z, 0.05, 31, myPed, 7)

                                    result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapetest)
                                    if result ~= 2 then
                                        repeat
                                            result, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapetest)
                                        until result == 2
                                    end
                                end

                                if entityHit == ped then
                                    DrawTxt(output, screenX, screenY, 0.0, 0.15, 0, 255, 0, 255)
                                else
                                    DrawTxt(output, screenX, screenY, 0.0, 0.15, 255, 0, 0, 255)
                                end

                                if weaponOutput then
                                    DrawTxt(weaponOutput, screenX, screenY + 0.01, 0.0, 0.1)
                                end

                                if vehicleDisplay then
                                    DrawTxt(vehicleDisplay, screenX, screenY + 0.02, 0.0, 0.1, 153, 51, 255)
                                end

                                local screenDist = #(vector2(boneX, boneY) - vector2(0.5, 0.5))
                                if screenDist < closestDist and screenDist < 0.03 and (entityHit == ped) then
                                    closestDist = screenDist
                                    closestPed = ped
                                    aimPos = bonePos
                                end
                            else
                                DrawTxt(output, screenX, screenY, 0.0, 0.1, 0, 255, 255, 255)
                            end
                        end
                    end

                    if (IsControlPressed(0, 27) or IsDisabledControlPressed(0, 27)) and closestPed and not IsPedInAnyVehicle(myPed, false) then
                        local hasTarget, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
                        if hasTarget and IsEntityAPed(target) then
                            SetPedShootsAtCoord(myPed, aimPos.x, aimPos.y, aimPos.z, true)
                        end
                    end

                    Citizen.Wait(0)
                end
            end
        )
    end
)
