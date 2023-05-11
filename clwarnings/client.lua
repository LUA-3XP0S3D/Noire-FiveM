Citizen.CreateThread(
    function()
        while not NetworkIsSessionActive() do
            Citizen.Wait(0)
        end

        Citizen.Wait(1000)

        function DrawTxt(text, x, y, scale, size)
            SetTextFont(4)
            SetTextCentre(true)
            SetTextScale(scale, size)
            SetTextDropshadow(1, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(x, y)
        end

        while not LocalPlayer.state.switchComplete do
            Wait(0)
        end

        while true do
            local waitInterval = 500
            -- local model = GetEntityModel(PlayerPedId())
            -- if model == `a_m_y_hipster_01` then
            --     waitInterval = 0
            --     DrawTxt("You are using the default ped model.", 0.5, 0.25, 0.5, 0.5)
            --     DrawTxt("Go to a ~o~clothing store~s~ and change your ~y~ped~s~ to ~b~Male~s~ or ~b~Female~s~.", 0.5, 0.3, 0.5, 0.5)
            -- end

            if GetSelectedPedWeapon(PlayerPedId()) ~= `WEAPON_UNARMED` then
                if LocalPlayer.state.blist then
                    if not Config_Warnings.ExemptJobs[PlayerData.job.name] then
                        waitInterval = 0
                        DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
                        DisableControlAction(0, 70, true) -- INPUT_VEH_ATTACK2
                        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
                        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
                        DisableControlAction(0, 106, true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
                        DisablePlayerFiring(PlayerPedId(), true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
                        DrawTxt("Combat Disabled - Your account been flagged by our automated system for integrity violations.", 0.5, 0.35, 0.5, 0.5)
                    end
                end

                if GetProfileSetting(226) == 1 then
                    waitInterval = 0
                    DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
                    DisableControlAction(0, 70, true) -- INPUT_VEH_ATTACK2
                    DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
                    DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
                    DisableControlAction(0, 106, true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
                    DisablePlayerFiring(PlayerPedId(), true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
                    DrawTxt("Disable ~b~Screen Kill Effects~s~ in ESC->Settings->Display to enable combat.", 0.5, 0.4, 0.5, 0.5)
                end
            end

            if GetProfileSetting(720) == 0 then
                waitInterval = 0
                DrawTxt("~r~WARNING~s~: Voice Chat Disabled. Set ~b~Voice Chat Enabled~s~ to hide this message.", 0.5, 0.45, 0.5, 0.5)
            end

            if GetProfileSetting(723) == 0 then
                waitInterval = 0
                DrawTxt("~r~WARNING~s~: Microphone Disabled. Set ~b~Enable Microphone~s~ to hide this message.", 0.5, 0.50, 0.5, 0.5)
            end

            -- if GetProfileSetting(725) == 0 then
            --     waitInterval = 0
            --     DrawTxt("~r~WARNING~s~: Enable ~y~Push to Talk~s~ in Settings->Voice Chat->~b~Voice Chat Mode~s~ to hide.", 0.5, 0.55, 0.5, 0.5)
            -- end

            Citizen.Wait(0)
        end
    end
)
