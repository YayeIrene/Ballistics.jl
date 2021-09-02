function coeffAero(f::Fragment, m::Float64)
    if m<0.1
        cd = f.cd_sub
    elseif m<0.75
        cd = 0.2/0.65*(m-0.75)+(f.cd_sub+0.2)
    elseif m<1.5
        cd = 0.45/(1.5-0.75)*(m-1.5)+(f.cd_sub+0.65)
    elseif m<3.0
        cd = -0.15/1.5*(m-3.0)+(f.cd_sub+0.5)
    else
        cd = f.cd_sub+0.5
    end
    return cd


end
