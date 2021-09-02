module scenario
using  ..Types, ..materials
using Distributions, LinearAlgebra
#import generic functions
#import .Ballistics: InternalBallistics!, ExternalBallistics!, Vulnerability!

export createProjectile, createFragment

function createProjectile(calibre::Float64,mass::Float64, velocity::Float64,  position::Float64 ;ev = nothing, spin = nothing, bf = nothing, type=nothing, mat = nothing, yaw=nothing )
            Projectile1D(calibre, type, mat, mass, velocity, ev, position, spin, yaw, bf)
end

function createProjectile(calibre::Float64, mass::Float64, velocity::Array{Float64,1},  position::Array{Float64,1} ;ev = nothing, spin = nothing, bf = nothing, type=nothing, mat = nothing, yaw=nothing, inertia=nothing, tof=nothing )
            Projectile2D(calibre, type, mat, mass, velocity, ev, position, spin, yaw, bf, inertia, tof)
end

function createTarget(size::Float64, position::Float64)
    Target1D(size,position)
end

function createTarget(size::Float64, position::Array{Float64,1}, velocity::Array{Float64,1})
    Target2D(size,position,velocity)
end

function createCanon(tc::Float64, lw::Float64, X2w::Float64)
    Canon(tc, lw, X2w)
end

function createFragment(z::Zone, s::Array{FragShapes,1}, cf::ShapeFactor,proj::Projectile2D,αₑ_bar::Array{Float64,1})
    number = Int64(rand(Normal(z.μ_number,z.σ_number)))
    rads = rand(Uniform(0,360), number)
    axs = rand(Uniform(z.angleBegin, z.angleEnd), number)
    f = Array{Fragment}(undef,number)
    c_bar = proj.velocity/norm(proj.velocity)*cos(norm(αₑ_bar))+αₑ_bar
    y_bar = [0.0, 1.0, 0.0]
    e_bar = cross(c_bar,y_bar)/norm(cross(c_bar,y_bar))
    d_bar = cross(e_bar,c_bar)
    for i=1:number
        velocity = rand(Normal(z.μ_velocity,z.σ_velocity))
        mass = abs(rand(Normal(z.μ_mass,z.σ_mass)))
        shape = rand(s)
        cd = rand(Normal(shape.μ_cd,shape.σ_cd))
        γ = rand(LogNormal(cf.μ, cf.σ))
        Aₚ = γ*(mass/z.density)^(2/3)
        #vx = velocity*cosd(axs[i])*cosd(rads[i])
        #vy = velocity*sind(axs[i])
        #vz = velocity*cosd(axs[i])*sind(rads[i])
        f_velocity = proj.velocity + velocity*c_bar + proj.spin * proj.calibre/2*(-d_bar*sind(rads[i])+e_bar*cosd(rads[i]))
        f_position = proj.position*1
        f[i] = Fragment(rads[i], axs[i], mass, z.density,cd, Aₚ, f_position,f_velocity,0.0)
    end
    return f
end


end
