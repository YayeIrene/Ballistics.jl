module OneD
using ...Types, ...Utils

export timeOfFlight!


function trajectory!(p::Projectile1D)
    ma = machNumber(p.velocity_m)
    cd0 = coeffAero(ma)
    drag = -0.125 * ρ0 * pi * p.calibre^2 * cd0 * p.velocity_m^2
    acceleration = drag / p.mass
    p.velocity_m += acceleration * dt
    p.position += p.velocity_m * dt
end

function timeOfFlight!(p::Projectile1D, target::Target1D)
#function flight(p::Projectile, ρ::Float64, dt::Float64)
    t = 0.0
    old_position = p.position
    old_velocity = p.velocity_m
    ρ = target.position

    while ρ > p.position
        old_position = p.position
        old_velocity = p.velocity_m
        t += dt
        #@process trajectory_projectile(sim, p, dt)
        trajectory!(p)
        #println(p.position)
    end
    flight_time = t-dt + dt * (ρ - old_position) / (p.position - old_position)
    p.position = old_position
    p.velocity_m = old_velocity + (p.velocity_m - old_velocity) * (flight_time - t + dt) / dt

    return flight_time


end

end
