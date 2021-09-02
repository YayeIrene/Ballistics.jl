using Ballistics

drone = scenario.createTarget(1.0,[800.0,0.0,-1000.0],[0.0,0.0,0.0])
lat = 45.0
lw = 0.0
X2w = 0.0

ΔAZ = 0.0

u₀ = 205.0
g₀ = 9.80665*(1-0.0026*cosd(2*lat))
#QE0 = 1/2*asin(g₀*range_/u₀^2)

lw = 0.0
X2w = 0.0
ΔAZ = 0.0
tc = 18.0 #calibers/turn
d = 0.1048 #m

w_bar = [0.0, 0.0, 0.0]

m = 14.97 #kg
yaw = 0.0
Ixx = 0.02326
It = 0.23118

projectile = scenario.createProjectile(d, m, [0.0, 0.0, 0.0],[0.0,0.0,0.0])
projectile.inertia = [Ixx, It]

gun = scenario.createCanon(tc, lw, X2w)

QE, AZ = ExternalBallistics.SixDof.QEfinderSixDof!(drone, projectile, u₀, g₀, gun, w_bar,lat)


#QE = 45.0
#AZ = 0.0
u0 = ExternalBallistics.SixDof.iniCondSixDof(deg2rad(QE), deg2rad(AZ), u₀, gun, d)

projectile = scenario.createProjectile(d,m,[u0[5],u0[6],u0[7]],[u0[11],u0[12],u0[13]],inertia=[Ixx,It])

tspan  = (0.0,1000.0)
Rz = 6.356766*1e6 #m
Ω = 7.292115*1e-5 #rad/s
ω_bar = [Ω*cosd(lat)*cosd(AZ), Ω*sind(lat), -Ω*cosd(lat)*sind(AZ)]
#αₑ_bar = [0.0,0.0,0.0]
#p = [projectile.inertia[1],w_bar, projectile.calibre, R, g₀, ω_bar, projectile.mass,drone.position,5.0]
p = [projectile.calibre, projectile.mass, projectile.inertia[1], projectile.inertia[2], ω_bar,g₀, Rz,drone.position,0.0]
#αₑ_bar  = ExternalBallistics.Mpmm.trajectoryMPMM!(u0, tspan, p, projectile, drone)
ExternalBallistics.SixDof.trajectorySixDof!(u0, tspan, p, projectile, drone)
