module Pmm
using ...Types, ...Utils
using DifferentialEquations
export timeOfFlight!
function timeOfFlight!(p::Projectile2D, target::Target2D) #PmmZEroDrag
    #t = 0.0
    range = target.position[1]
    flight_time = 0.0

    function f(du,u,p,t)
        v = sqrt(u[3]^2 + u[4]^2)
        ma = machNumber(v,u[2])
        Cd = coeffAero(ma)
        ρ = density(u[2])
        θ = atan(u[4]/u[3])

        du[1] = u[3]#vx
        du[2] = u[4]#vy
        du[3] =  -1/2*pi*calibre^2/4*Cd*ρ*v^2*cos(θ)/m
        du[4] = gravity(u[2])-1/2*pi*calibre^2/4*Cd*ρ*v^2*sin(θ)/m
    end
    x0 = p.position[1]
    y0 = p.position[2]
    v0x = p.velocity_m[1]
    v0y = p.velocity_m[2]
    u0 = [x0,y0,v0x,v0y]

    tspan = (0.0,tmax)
    prob = ODEProblem(f,u0,tspan)
    #sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
    integrator = init(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
    oldx = integrator.u[1]
    oldy = integrator.u[2]
    oldu = integrator.u[3]
    oldv = integrator.u[4]
    while range > p.position[1]
        oldx = integrator.u[1]
        oldy = integrator.u[2]
        oldu = integrator.u[3]
        oldv = integrator.u[4]
    step!(integrator,dt,true)
    p.position[1]= integrator.u[1]
    #println(integrator.t, " ",p.position[1], " ", range)
    end
    p.position[1] = oldx
    p.position[2] = oldy
    p.velocity_m[1] = oldu
    p.velocity_m[2] = oldv
    flight_time = integrator.t-dt
    p.yaw = atan(p.velocity_m[2]/p.velocity_m[1])

    return flight_time
end

function trajectory!(u0, tspan, p, proj, target)
    global dist = target.x
    prob = ODEProblem(mpmm,u0,tspan, p)
#cb = DiscreteCallback(condition,affect!)
#println(target.x)
    cb = ContinuousCallback(condition,affect!)
    sol = solve(prob,Tsit5(),callback=cb)
#sol = solve(prob,Tsit5(),callback=cb)
#sol = solve(prob,BS5(),callback=cb)
#sol = solve(prob,AutoTsit5(Rosenbrock23()),callback=cb)
 proj.x = sol.u[end][1]
 proj.y = sol.u[end][2]
 proj.z = sol.u[end][3]
 proj.vx = sol.u[end][4]
 proj.vy = sol.u[end][5]
 proj.vz = sol.u[end][6]
 proj.tof = sol.t[end]
end



end
