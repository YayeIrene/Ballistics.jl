module aero30
export coeffAero
function coeffAero(ma::Float64)
    if ma > 4.0
        cd0 = 0.647 * ma^(-0.5337)
    else
        cd0 = 0.0065 * ma^2 - 0.0965 * ma + 0.5901
    end
    return cd0
end
end 
