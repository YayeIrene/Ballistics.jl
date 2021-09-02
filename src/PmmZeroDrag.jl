module PmmZeroDrag
using DifferentialEquations, ...Types
export timeOfFlight!
function QE(target::Target2D)
    θ = 1/2 *asin(g0*target.position[1]/v0^2)
    return θ
end

function timeOfFlight!(p::Projectile2D, target::Target2D) #PmmZEroDrag
    #t = 0.0
    ρ = target.position[1]
    #θ = QE(target)
    #println(θ)
    #p.velocity_m[1] = v0*cos(θ)
    #p.velocity_m[2] = v0*sin(θ)
    flight_time = 0.0

    function f(du,u,p,t)
        du[1] = u[3]#vx
        du[2] = u[4]#vy
        du[3] =  0 #ax no forces in this direction
        du[4] = g0 #ax
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
    while ρ > p.position[1]
        oldx = integrator.u[1]
        oldy = integrator.u[2]
        oldu = integrator.u[3]
        oldv = integrator.u[4]
    step!(integrator,dt,true)
    p.position[1]= integrator.u[1]


    end
    p.position[1] = oldx
    p.position[2] = oldy
    p.velocity_m[1] = oldu
    p.velocity_m[2] = oldv
    flight_time = integrator.t-dt
    p.yaw = atan(p.velocity_m[2]/p.velocity_m[1])

    return flight_time
end

end
