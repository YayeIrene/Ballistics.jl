module SixDof

using LinearAlgebra, DifferentialEquations, Distances
using ...Utils, ...Types
include("aerodynamic_coeff.jl")
export trajectorySixDof!, QEfinderSixDof!, iniCondSixDof

function sixdof(du,u,p,t)
    calibre,m,Ixx,It, ω_bar, g₀, Rz, target,dist = p

    λ0 = u[1]
    λ1 = u[2]
    λ2 = u[3]
    λ3 = u[4]

    U = u[5]
    V = u[6]
    W = u[7]

    P = u[8]
    Q = u[9]
    R = u[10]

    X₁ = u[11]
    X₂ = u[12]
    X₃ = u[13]

    V_bar = [U, V, W]
    X_bar = [X₁, X₂, X₃]

    α = atan(W/U)
    β = asin(V/norm(V_bar))
    αt = asin(sqrt((sin(α)*cos(β))^2+(sin(β))^2))
    δ = sqrt((sin(α)*cos(β))^2+(sin(β))^2)

    mach = Utils.machNumber(norm(V_bar),-u[13])
    CD0 = CD0_inter(mach)
    CDδ2 = CDδ2_inter(mach)
    CD = CD0 + CDδ2 * δ^2
    CLα0 = Cl_α0_inter(mach)
    CLα2 = Cl_α2_inter(mach)
    CLα = CLα0 + CLα2 * δ^2
    Cx0 = CD0
    Cx2 = CDδ2
    Cna = CLα#CD + cos(αt)*CLα
    Cypa = CN_pα_inter(mach,(rad2deg(αt))^2)
    Cldd = 0.0
    Clp = Cl_p_inter(mach)
    CMα0 = CM_α0_inter(mach)
    CMα2 = CM_α2_inter(mach)
    Cma = CMα0 +CMα2 * δ^2
    Cmq = CM_q_plus_CM_α_inter(mach)
    Cnpa =  CM_pα_inter(mach,(rad2deg(αt))^2)

    Ωx = 2*R*(λ1*λ3-λ0*λ2)/(λ0^2-λ1^2-λ2^2+λ3^2)

    ρ = Utils.density(-u[13])
    S = pi*(calibre^2)/4

    g = Utils.gravity(-u[13])

    gx = 2*(λ1*λ3-λ0*λ2)*g
    gy = 0.0
    gz = (λ0^2-λ1^2-λ2^2+λ3^2)*g

    FGx = - g₀*X₁/Rz
    FGy = - g₀*X₂/Rz
    FGz = g₀*(1+2*X₃/Rz)

    FG = [gx, gy, gz]


    FAx = -1/2*ρ*(norm(V_bar))^2*S*(Cx0 + Cx2*(V^2+W^2)/(norm(V_bar))^2)#Cx
    FAy = -1/2*ρ*(norm(V_bar))^2*S*(CLα*V/norm(V_bar))#(Cna * V/norm(V_bar)
    FAz = -1/2*ρ*(norm(V_bar))^2*S*(CLα*W/norm(V_bar))#(Cna * W/norm(V_bar) #Cz

    FMx =0.0
    FMy = 1/2*ρ*(norm(V_bar))^2*S* (P*calibre/(2*norm(V_bar))*Cypa*W/(norm(V_bar)))#Cy
    FMz = -1/2*ρ*(norm(V_bar))^2*S* (P*calibre/(2*norm(V_bar))*Cypa*V/(norm(V_bar)))

    T = T_MatrixQ(λ0, λ1, λ2, λ3)

    v_bar = T*V_bar
    FC = -2*cross(ω_bar,v_bar)

    FCp = transpose(T)*FC
    FGp = transpose(T)*FG
    FGp[2] = 0.0
    FCx = FCp[1]
    FCy = FCp[2]
    FCz = FCp[3]

    Fx = FAx +FMx + FCx
    Fy = FAy + FMy + FCy
    Fz = FAz + FMz + FCz

    L = 1/2*ρ*(norm(V_bar))^2* S *calibre*(Cldd + P*calibre/(2*norm(V_bar))*Clp)#Cl
    M = 1/2*ρ*(norm(V_bar))^2* S *calibre*( Cma*W/norm(V_bar)+Q*calibre/(2*norm(V_bar))*Cmq+P*calibre/(2*norm(V_bar))*Cnpa*V/norm(V_bar))#Cm
    N = 1/2*ρ*(norm(V_bar))^2* S *calibre*(-Cma*V/norm(V_bar)+R*calibre/(2*norm(V_bar))*Cmq+P*calibre/(2*norm(V_bar))*Cnpa*W/norm(V_bar))#Cq

    ϵw = norm([λ0,λ1,λ2,λ3])-1

    du[1] = -1/2*(Q*λ2+R*λ3/(λ0^2-λ1^2-λ2^2+λ3^2))-ϵw*λ0 #λ0p
    du[2] = -1/2*(Q*λ3+R*λ2/(λ0^2-λ1^2-λ2^2+λ3^2))-ϵw*λ1  #λ1p
    du[3] = 1/2*(Q*λ0+R*λ1/(λ0^2-λ1^2-λ2^2+λ3^2))-ϵw*λ2  #λ2p
    du[4] = 1/2*(Q*λ1+R*λ0/(λ0^2-λ1^2-λ2^2+λ3^2))-ϵw*λ3  #λ3p

    du[5] = FG[1]+Fx/m-Q*W+R*V #Up
    du[6] = FG[2]+Fy/m-R*U+Ωx*W  # Vp
    du[7] = FG[3]+Fz/m-Ωx*V+Q*U  # Wp

    du[8] = L/Ixx #Pp
    du[9] = 1/It * (M-Ixx*R*P+It*R*Ωx)#Qp
    du[10] = 1/It * (N+Ixx*Q*P-It*Q*Ωx)#Rp

    du[11] = v_bar[1] #x
    du[12] = v_bar[2] #y
    du[13] = v_bar[3] #z



end
function condition(u,t,integrator) # Event when event_f(u,t) == 0

  integrator.p[8][1]-u[11]

end

function timeFuze(u,t,integrator)

    close=(euclidean([u[11],u[12],u[13]],integrator.p[8])-integrator.p[9])-1e-6

    return close
end

miss(u,t,integrator) = u[13]
affect_miss!(integrator) = terminate!(integrator)


affect!(integrator) = terminate!(integrator)
affect_tf!(integrator) = terminate!(integrator)

function iniCondSixDof(θ::Float64, ψ::Float64, u₀::Float64, gun::Canon, calibre::Float64)
    p₀ = 2*pi*u₀/(gun.tc*calibre)
    Φ = 0.0
    λ0, λ1, λ2, λ3 = euler2quartenions(θ, ψ, Φ)
    Q = 0.0
    R = 0.0
    u₀_bar = [u₀*cos(θ)*cos(ψ), u₀*cos(θ)*sin(ψ), -u₀*sin(θ) ]
    T_euler = T_matrixE(θ,ψ,Φ)
    u₀_bar_m = transpose(T_euler)*u₀_bar
    X₀_bar = [gun.lw*cos(θ)*cos(ψ),  gun.lw*cos(θ)*sin(ψ),- (gun.X2w + gun.lw *sin(θ))]

    u0 = [λ0, λ1, λ2, λ3, u₀_bar_m[1], u₀_bar_m[2], u₀_bar_m[3], p₀,Q, R, X₀_bar[1], X₀_bar[2], X₀_bar[3]]
    return u0
end

function QEfinderSixDof!(drone::Target2D, proj::Projectile2D, u₀::Float64, g₀::Float64, gun::Canon, w_bar::Array{Float64,1},lat::Float64)

    epsilonAz = 1e6
    epsilonQE = 1e6
    precisie = 0.001
    ddoel = euclidean(proj.position, drone.position)
    tdoel = sqrt(drone.position[1]^2+drone.position[2]^2)/u₀
    #QE = asind(((-drone.position[3]) - (-proj.position[3]) + g₀ /2 *tdoel^2)*tdoel/u₀)
    QE = (((-drone.position[3]) - (-proj.position[3]) + g₀ /2 *tdoel^2)*tdoel/u₀)
    AZ = 0.0
    tspan = (0.0,1000.0)
    Rz = 6.356766*1e6 #m
    Ω = 7.292115*1e-5 #rad/s
    ω_bar = [Ω*cosd(lat)*cosd(AZ), Ω*sind(lat), -Ω*cosd(lat)*sind(AZ)]
    p = [proj.calibre,proj.mass,proj.inertia[1],proj.inertia[2], ω_bar,g₀, Rz,drone.position,0.0]

    while abs(epsilonAz)>precisie || abs(epsilonQE)>precisie
        u0 = iniCondSixDof(deg2rad(QE), deg2rad(AZ), u₀, gun, proj.calibre)
        #global proj = projectile(u0[1],u0[2],u0[3],u0[4],u0[5],u0[6],0.0)
        #proj = projectile(u0[1],u0[2],u0[3],u0[4],u0[5],u0[6],0.0)
        proj.position = [u0[11],u0[12],u0[13]]
        proj.velocity = [u0[5],u0[6],u0[7]]
        proj.tof = 0.0
        trajectorySixDof!(u0, tspan, p, proj, drone)

        #global epsilonQE = proj.y - drone.y
        epsilonQE = (-proj.position[3]) - (-drone.position[3])
        #println("epsilonQE", " ", epsilonQE)
        #QE = QE0 + (accuracy)/(range_/QE0)
        #global epsilonAz = (sqrt((proj.z-drone.z)^2+(proj.x-drone.x)^2)*sign(atan(proj.z)/proj.x)-atan(drone.z/drone.x))
        epsilonAz = (sqrt((proj.position[2]-drone.position[2])^2+(proj.position[1]-drone.position[1])^2)*sign(atan(proj.position[2])/proj.position[1])-atan(drone.position[2]/drone.position[1]))
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

function trajectorySixDof!(u0::Array{Float64,1}, tspan::Tuple{Float64,Float64}, p, proj::AbstractPenetrator, target::Target2D)

    prob = ODEProblem(sixdof,u0,tspan, p)

    cb = ContinuousCallback(condition,affect!)
    cb_tf = ContinuousCallback(timeFuze,affect!)
    cb_miss = ContinuousCallback(miss,affect!)
    #cb_tf=DiscreteCallback(timeFuze,affect_tf!)
    cbs = CallbackSet(cb,cb_tf,cb_miss)
    sol = solve(prob,Tsit5(),callback=cbs, reltol=1e-8, abstol=1e-8)
    proj.position[1] = sol.u[end][11]
    proj.position[2] = sol.u[end][12]
    proj.position[3] = sol.u[end][13]
    proj.velocity[1] = sol.u[end][5]
    proj.velocity[2] = sol.u[end][6]
    proj.velocity[3] = sol.u[end][7]
    proj.tof = sol.t[end]
    proj.spin = sol.u[end][8]


end


end
