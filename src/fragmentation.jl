module Fragmentation
using ..scenario, ..Utils, ..Types, ..ExternalBallistics
using LinearAlgebra
export frag, fragFly!
function frag(proj::Projectile2D, zones::Array{Zone,1}, shapes::Array{FragShapes,1},cf::ShapeFactor, αₑ_bar::Array{Float64,1})
    θ  = asin(-proj.velocity[3]/norm(proj.velocity))
    Ψ = atan(proj.velocity[2]/proj.velocity[1])
    T = [cos(θ)*cos(Ψ) -sin(Ψ) sin(θ)*cos(Ψ); cos(θ)*sin(Ψ) cos(Ψ) sin(θ)*sin(Ψ); -sin(θ) 0.0 cos(θ)]
    frags = []
    for z in zones
        f = createFragment(z,shapes,cf, proj, αₑ_bar)

    #=    for i in f

            v = i.velocity#[i.vx, i.vy, i.vz]
            vrot = rotation(v, T)
            i.velocity = vrot
            #i.vy = vrot[2]
            #i.vz = vrot[3]
        end
        =#
        push!(frags,f)
    end
    return frags
end

function fragFly!(fragments, proj::Projectile2D, w_bar::Array{Float64,1}, target::Target2D, g₀::Float64, ω_bar::Array{Float64,1}, coeffAero;R=6.356766*1e6, tspan=(0.0,1000.0))
    for i=1:length(fragments)
        for j=1:length(fragments[i])

            u0=[proj.position[1], proj.position[2], proj.position[3],fragments[i][j].velocity[1], fragments[i][j].velocity[2], fragments[i][j].velocity[3]]

            p= [w_bar, fragments[i][j].Aₚ, R, g₀,ω_bar, fragments[i][j].mass,target.position,coeffAero,fragments[i][j]]
            ExternalBallistics.Pmm.trajectoryPMM!(u0, tspan, p, fragments[i][j])
        end

    end

end


end
