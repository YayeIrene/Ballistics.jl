module Pmm
using ...Types, ...Utils
using DifferentialEquations, LinearAlgebra
#include("aerodynamic_coeff_fragment.jl")
export timeOfFlight!, trajectoryPMM!

    function pmm(du,u,p,t)
        w_bar, A, R, g₀,ω_bar, m,target,coeffAero,proj  = p

        vx= u[4]
        vy=u[5]
        vz=u[6]
        X₁ = u[1]
        X₂ = u[2]
        X₃ = u[3]

       u_bar =[u[4], u[5], u[6]]
       v_bar= u_bar - w_bar
        v = norm(v_bar)
        du_bar = [du[4], du[5],du[6]]
        #println(X₂)
        ρ =  Utils.density(X₂)
        #println("ρ", " ", ρ)
        α = atan(vz/vx)
        β = asin(vy/v)

        mach = Utils.machNumber(v,X₂)

        CD₀ = coeffAero(proj,mach)

        CD = CD₀

        FDx = - ρ*A/2*(CD)*v*vx #drag
        FDy = - ρ*A/2*(CD)*v*vy #drag
        FDz = - ρ*A/2*(CD)*v*vz #drag


        FGx = - g₀*X₁/R*m
        FGy = -g₀*(1-2*X₂/R)*m
        FGz = - g₀*X₃/R*m

        FCx = -2*cross(ω_bar,u_bar)[1]*m
        FCy = -2*cross(ω_bar,u_bar)[2]*m
        FCz = -2*cross(ω_bar,u_bar)[3]*m

        Fx =  FDx  +FGx +FCx
        Fy =  FDy  +FGy +FCy
        Fz =  FDz  +FGz +FCz

        du[1] = u[4] #x
        du[2] = u[5] #y
        du[3] = u[6] #z
        du[4] =Fx/m #ax
        du[5] = Fy/m#ay
        du[6] = Fz/m#az

    end

    function timeOfFlight!(p::Projectile2D, target::Target2D) #PmmZEroDrag
        #t = 0.0
        range = target.position[1]
        flight_time = 0.0

    x0 = p.position[1]
    y0 = p.position[2]
    v0x = p.velocity_m[1]
    v0y = p.velocity_m[2]
    u0 = [x0,y0,v0x,v0y]

    tspan = (0.0,tmax)
    prob = ODEProblem(pmm,u0,tspan)
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

function condition(u,t,integrator) # Event when event_f(u,t) == 0
  #u[2]
  #target.x-u[1]
  #dist-u[1]
  integrator.p[7][1]-u[1]
end


affect!(integrator) = terminate!(integrator)

function trajectoryPMM!(u0, tspan, p, proj::AbstractPenetrator)
    #global dist = target.position[1]
    prob = ODEProblem(pmm,u0,tspan, p)
#cb = DiscreteCallback(condition,affect!)
#println(target.x)
    cb = ContinuousCallback(condition,affect!)
    sol = solve(prob,Tsit5(),callback=cb)
#sol = solve(prob,Tsit5(),callback=cb)
#sol = solve(prob,BS5(),callback=cb)
#sol = solve(prob,AutoTsit5(Rosenbrock23()),callback=cb)
 proj.position[1] = sol.u[end][1]
 proj.position[2] = sol.u[end][2]
 proj.position[3] = sol.u[end][3]

 proj.velocity[1] = sol.u[end][4]
 proj.velocity[2] = sol.u[end][5]
 proj.velocity[3] = sol.u[end][6]


 proj.tof = sol.t[end]
end



end
