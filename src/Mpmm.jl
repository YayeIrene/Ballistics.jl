module Mpmm
using ...Utils, ...Types
using DifferentialEquations, LinearAlgebra, Distances
#using aeroCoeff
include("aerodynamic_coeff.jl")
export trajectoryMPMM!, QEfinderMPMM!, iniCond

function mpmm(du,u,p,t)
    Iₓ,w_bar, d, R, g₀,ω_bar, m,target,dist = p

    vx= u[4]
    vy=u[5]
    vz=u[6]
    X₁ = u[1]
    X₂ = u[2]
    X₃ = u[3]
    pₛ = u[7]
   u_bar =[u[4], u[5], u[6]]
   v_bar= u_bar - w_bar
    v = norm(v_bar)
    du_bar = [du[4], du[5],du[6]]
    #println(X₂)
    ρ =  Utils.density(X₂)
    #println("ρ", " ", ρ)
    α = atan(vz/vx)
    β = asin(vy/v)
    #αₜ = asin(sqrt((sin(α)*cos(β))^2+(sin(β))^2))
    #αₜ = asin()
    #println("v", " ", v)
    #println("v", " ", v_bar)
    #println("u", " ", u_bar)
    mach = Utils.machNumber(v,X₂)
    CMα₀ = CM_α0_inter(mach)
    CMα₂ = CM_α2_inter(mach)
    CMα = CMα₀ #+ CMα₂*(sin(αₜ))^2
    #println(du_bar)

   αₑ_bar = yawOfRepose(v_bar, du_bar,pₛ, t, Iₓ, ρ,d,CMα,v)
   #println("αₑ", " ", αₑ_bar)
    αₑ = norm(αₑ_bar)
    αₜ = asin(αₑ)
    #println("αₜ", " ", αₜ )
    #println("αₜ2", " ", sin(αₑ))

    CD₀ = CD0_inter(mach)
    CDα² = CDδ2_inter(mach)
    CDα⁴ = 0.0
    CLα = Cl_α0_inter(mach)
    CLα³ = Cl_α2_inter(mach)
    CLα⁵ = 0.0
    Cmag = CN_pα_inter(mach,(rad2deg(αₜ))^2)
    #println("mach", " ", mach)
    #println("αₜ", " ", αₜ)
    Cₛₚᵢₙ = Cl_p_inter(mach)

    #CD = CD₀ + CDα²*αₑ^2+CDα⁴*αₑ^4
    CD = CD₀ + CDα² * (sin(αₜ))^2
    #CL = CLα + CLα³*αₑ^2+CLα⁵*αₑ^4
    CL = CLα + CLα³ * (sin(αₜ))^2
    #println("CL", " ", CL)
    FDx = - pi*ρ*d^2/(8)*(CD)*v*vx #drag
    FDy = - pi*ρ*d^2/(8)*(CD)*v*vy #drag
    FDz = - pi*ρ*d^2/(8)*(CD)*v*vz #drag
    FLx = pi*ρ*d^2/(8)*(CL)*v^2*αₑ_bar[1] #lift
    FLy = pi*ρ*d^2/(8)*(CL)*v^2*αₑ_bar[2] #lift
    FLz = pi*ρ*d^2/(8)*(CL)*v^2*αₑ_bar[3] #lift
    FMx = -pi*ρ*d^3*pₛ*Cmag/8*cross(αₑ_bar,v_bar)[1]
    FMy = -pi*ρ*d^3*pₛ*Cmag/8*cross(αₑ_bar,v_bar)[2]
    FMz = -pi*ρ*d^3*pₛ*Cmag/8*cross(αₑ_bar,v_bar)[3]
    #println("cmag", " ", Cmag)
    FGx = - g₀*X₁/R*m
    FGy = -g₀*(1-2*X₂/R)*m
    FGz = - g₀*X₃/R*m
    #FGz = 0.0
    FCx = -2*cross(ω_bar,u_bar)[1]*m
    FCy = -2*cross(ω_bar,u_bar)[2]*m
    FCz = -2*cross(ω_bar,u_bar)[3]*m
    #println("FDx", " ", FDx)
    #println("FLx", " ", FLx)
    #println("FMx", " ", FMx)
    #println("FGx", " ", FGx)
    #println("FCx", " ", FCx)
    Fx =  FDx + FLx +FGx +FMx+FCx
    Fy =  FDy + FLy +FGy +FMy+FCy
    Fz =  FDz + FLz +FGz +FMz+FCz
    #println("Fx", " ", Fx)
    #println("FDx", " ", FDx)
    #println("FLx", " ", FLx)
    #println("FMx", " ", FMx)
    #println("FMy", " ", FMy)
    #println("FMz", " ", FMz)
    #println("FGx", " ", FGx)
    #println("FCx", " ", FCx)
    du[1] = u[4] #x
    du[2] = u[5] #y
    du[3] = u[6] #z
    du[4] =Fx/m #ax
    du[5] = Fy/m#ay
    du[6] = Fz/m#az
    du[7] = pi*ρ*d^4*pₛ*v*Cₛₚᵢₙ/(8*Iₓ)#pdot
    global yaw = αₑ_bar

end

function yawOfRepose(v_bar::Array{Float64,1}, du_bar::Array{Float64,1},pₛ::Float64, t::Float64, Iₓ::Float64, ρ::Float64,d::Float64,CMα::Float64,v::Float64)
    if t==0
        return [0.0,0.0,0.0]
    else
       αₑ_bar = -8*Iₓ*pₛ*cross(v_bar,du_bar)/(pi*ρ*d^3*(CMα)*v^4)

        return αₑ_bar
    end
end



#u₀ = norm()




#canon = gun(0.0,0.0,0.0)

#sol = solve(prob, Tsit5(), reltol=1e-6, abstol=1e-6)
#sol = solve(prob, AutoTsit5(Rosenbrock23()))
#sol = solve(prob)
function condition(u,t,integrator) # Event when event_f(u,t) == 0
  #u[2]
  #target.x-u[1]
  #dist-u[1]
  #delta = sqrt((u[1]-integrator.p[8][1])^2+(u[2]-integrator.p[8][2])^2+(u[3]-integrator.p[8][3])^2)-integrator.p[9]
  #println(delta)
  #return delta
  #toto = (euclidean([u[1],u[2],u[3]],integrator.p[8])-integrator.p[9])
  #println(toto)
  integrator.p[8][1]-u[1]
  #integrator.p[8][1]>u[1]
end

function timeFuze(u,t,integrator)
    #euclidean([u[1],u[2],u[3]],integrator.p[8])-integrator.p[9]

    #close=(euclidean([u[1],u[2],u[3]],integrator.p[8])-integrator.p[9])<0.0
    close=(euclidean([u[1],u[2],u[3]],integrator.p[8])-integrator.p[9])-1e-6
    #println((euclidean([u[1],u[2],u[3]],integrator.p[8])-integrator.p[9]))
    #println(close)
    return close
end

affect!(integrator) = terminate!(integrator)
affect_tf!(integrator) = terminate!(integrator)

function trajectoryMPMM!(u0::Array{Float64,1}, tspan::Tuple{Float64,Float64}, p, proj::AbstractPenetrator, target::Target2D)
    #global dist = target.position[1]
    #append!(p,dist)
    prob = ODEProblem(mpmm,u0,tspan, p)
    #cb = DiscreteCallback(condition,affect!)
#println(target.x)
    cb = ContinuousCallback(condition,affect!)
    cb_tf = ContinuousCallback(timeFuze,affect!)
    #cb_tf=DiscreteCallback(timeFuze,affect_tf!)
    cbs = CallbackSet(cb,cb_tf)
    sol = solve(prob,Tsit5(),callback=cbs, reltol=1e-8, abstol=1e-8)
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
 proj.spin = sol.u[end][7]
 return yaw
end

function iniCond(QE::Float64, ΔAZ::Float64, u₀::Float64, gun::Canon, calibre::Float64)
    p₀ = 2*pi*u₀/(gun.tc*calibre)
    u₀_bar = [u₀*cosd(QE)*cosd(ΔAZ), u₀*sind(QE), u₀*cosd(QE)*sind(ΔAZ)]
    X₀_bar = [gun.lw*cosd(QE)*cosd(ΔAZ), gun.X2w + gun.lw *sind(QE), gun.lw*cosd(QE)*sind(ΔAZ)]
    u0 = [X₀_bar[1], X₀_bar[2], X₀_bar[3], u₀_bar[1], u₀_bar[2], u₀_bar[3],p₀]
    return u0
end

function QEfinderMPMM!(drone::Target2D, proj::Projectile2D, u₀::Float64, g₀::Float64, gun::Canon, w_bar::Array{Float64,1},lat::Float64)

    epsilonAz = 1e6
    epsilonQE = 1e6
    precisie = 0.001
    ddoel = euclidean(proj.position, drone.position)
    tdoel = sqrt(drone.position[1]^2+drone.position[3]^2)/u₀
    QE = (drone.position[2] - proj.position[2] + g₀ /2 *tdoel^2)*tdoel/u₀
    AZ = 0.0
    tspan = (0.0,1000.0)
    R = 6.356766*1e6 #m
    Ω = 7.292115*1e-5 #rad/s
    ω_bar = [Ω*cosd(lat)*cosd(AZ), Ω*sind(lat), -Ω*cosd(lat)*sind(AZ)]
    #p = [proj.inertia[1],w_bar, proj.calibre, R, g₀, ω_bar, proj.mass,drone]
    #αₑ_bar = [0.0,0.0,0.0]
    p = [proj.inertia[1],w_bar, proj.calibre, R, g₀, ω_bar, proj.mass,drone.position,0.0]

    while abs(epsilonAz)>precisie || abs(epsilonQE)>precisie
        u0 = iniCond(QE, AZ, u₀, gun, proj.calibre)
        #global proj = projectile(u0[1],u0[2],u0[3],u0[4],u0[5],u0[6],0.0)
        #proj = projectile(u0[1],u0[2],u0[3],u0[4],u0[5],u0[6],0.0)
        proj.position = [u0[1],u0[2],u0[3]]
        proj.velocity = [u0[4],u0[5],u0[6]]
        proj.tof = 0.0
        trajectoryMPMM!(u0, tspan, p, proj, drone)

        #global epsilonQE = proj.y - drone.y
        epsilonQE = proj.position[2] - drone.position[2]
        #println("epsilonQE", " ", epsilonQE)
        #QE = QE0 + (accuracy)/(range_/QE0)
        #global epsilonAz = (sqrt((proj.z-drone.z)^2+(proj.x-drone.x)^2)*sign(atan(proj.z)/proj.x)-atan(drone.z/drone.x))
        epsilonAz = (sqrt((proj.position[3]-drone.position[3])^2+(proj.position[1]-drone.position[1])^2)*sign(atan(proj.position[3])/proj.position[1])-atan(drone.position[3]/drone.position[1]))
        #println("epsilonAz", " ", epsilonAz)
        #global AZ = AZ - epsilonAz/ddoel
        AZ = AZ - epsilonAz/ddoel
        #global QE = QE - epsilonQE/ddoel
        QE = QE - epsilonQE/ddoel

        #trajectory!(u0, tspan, p, proj, drone)
        #calcRange = euclidean([0.0,0.0,0.0], [proj.x,proj.y, proj.z])
        #global accuracy = range_  - calcRange
        #println("AZ", " ", AZ)
        #println("QE", " ", QE)


    end

return QE,AZ
end

end
