function HealthHUD()
    if (init == nil) or (init == false) then
        init = true
        relation = 0
        hp_init = LocalPlayer():Health()
        alpha_value = 0
    end

    if (alpha_value <= 100) and (alpha_value > 0) then
        alpha_value = alpha_value - 5
    end

    if hp_init ~= LocalPlayer():Health() and LocalPlayer():Health() <= hp_init then
        hp_init = LocalPlayer():Health()
        alpha_value = 100
    elseif hp_init ~= LocalPlayer():Health() and LocalPlayer():Health() >= hp_init then
        hp_init = LocalPlayer():Health()
        alpha_value = 0
    end

    if LocalPlayer():Health() >= 100 then
        intensity = 100 - 100
        relation = 0
    else
        if LocalPlayer():Health() < 40 then
            relation = math.Clamp((40 - LocalPlayer():Health()) / 40, 0, 1)
        elseif LocalPlayer():Health() >= 41 then
            relation = 0
        end

        intensity = 100 - LocalPlayer():Health()
    end

    local tab = {}
    tab["$pp_colour_addr"] = 0
    tab["$pp_colour_addg"] = 0
    tab["$pp_colour_addb"] = 0
    tab["$pp_colour_brightness"] = (intensity * 0.001)
    tab["$pp_colour_contrast"] = 1 - (intensity * 0.003)
    tab["$pp_colour_colour"] = 1
    tab["$pp_colour_contrast"] = 1 - (relation / 3)
    tab["$pp_colour_addr"] = (relation * 0.2)
    tab["$pp_colour_addg"] = (relation * (-0.35))
    tab["$pp_colour_addb"] = (relation * (-0.6))
    --tab[ "$pp_colour_mulr" ] = ((relation)*())
    --tab[ "$pp_colour_mulg" ] = ((relation)*(-0))
    --tab[ "$pp_colour_mulb" ] = ((relation)*(-0))
    DrawColorModify(tab)
    DrawToyTown(intensity * 0.2, intensity * 1)
end

hook.Add("RenderScreenspaceEffects", "HealthHUD", HealthHUD)