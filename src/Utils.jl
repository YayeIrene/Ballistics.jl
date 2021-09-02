module Utils
using ..Types, ..scenario
using LinearAlgebra

export rotation, machNumber, temperature, density, gravity, T_MatrixQ, euler2quartenions, T_matrixE


function machNumber(v::Float64)
    ma = v / 340.0
    return ma
end
function machNumber(v::Float64, y::Float64)
    t = temperature(y)
    a = speedOfSound(t)
    ma = v / a
    return ma
end

function temperature(y::Float64;y0 = 0.0, t0 = 288.15, β = -6.5)
    t = (t0+β * (y-y0)*1e-3)#-273.15 #deg Celsius
    return t
end

function speedOfSound(t::Float64; γ = 1.4, R = 287.05287)
    a = sqrt(γ*R*t)
    return a
end
function pressure(y::Float64;p0 = 101325.0, y0 = 0.0, t0 = 288.15, β = -6.5, R = 287.05287)
    p = p0*(1+β/t0*(y-y0)*1e-3)^(-gravity(y)/(β*R))
    return p
end
function density(y::Float64; R = 287.05287)
    t = temperature(y)
    p = pressure(y)
    ρ = p/(R*t)
    return ρ
end

function gravity(y::Float64; g0 = 9.80665, r = 6356766.0)
    g = g0*(r/(r+y))^2
    return g
end

function Δrange(v0::Float64, θ::Float64, target::Target2D, trajectory::Function,proj::Projectile2D)
p= deepcopy(proj)
#println(proj.position)
#println(p.position)
vx = v0*cosd(θ)
vy = v0*sind(θ)
#p = createProjectile(0.03, 0.04,[vx,vy], [0.0,0.0])
p.velocity_m = [vx,vy]
trajectory(p,target)
#println(p.position)
Δrange = target.position[2]-p.position[2]

return Δrange
end

function bissection(target::Target2D, trajectory::Function, p::Projectile2D; θmin = 0.0, θmax = 45.0, ϵ = 0.001 )

#t2D = scenario.createTarget(0.2,[200.0,50.0])

#global θmin = 0.0
#global θmax = 45.0
#v0 = 900.0
#ϵ = 0.001
#global fmin = Δrange(inputs.v0, θmin,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
#global fmax = Δrange(inputs.v0, θmax,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
#global error = min(abs(fmin),abs(fmax))
fmin = Δrange(inputs.v0, θmin,target, trajectory,p)
#println(θmin," ", θmax)
fmax = Δrange(inputs.v0, θmax,target, trajectory,p)
#println(fmin," ", fmax)
error = min(abs(fmin),abs(fmax))
θ = 0.0

if sign(fmin)==sign(fmax)
  println("Bisection method fails.")
else

  while error>ϵ

    #global θmin
    #global θmax
    #global fmin
    #global fmax
    #global error
    #global θ = 1/2*(θmin+θmax)
    θ = 1/2*(θmin+θmax)
    #println(error)

    f = Δrange(inputs.v0, θ,target, trajectory,p)
    error = abs(f)
    if f*fmin < 0
            θmax = θ
        else f*fmax < 0
            θmin = θ
      end
    end


  end
  return θ

end

function rotation(v::Array{Float64,1}, T::Array{Float64,2})
    vrot = T*v
    return vrot
end




function arctangent(A::Float64, B::Float64)
    if B>0
        return atan(A/B)
    elseif B==0 && A>0
        return pi/2
    elseif B==0 && A<0
        return -pi/2
    elseif B<0
        return pi+atan(A/B)
    end
end

function quaternions(λ::String, T)
    if λ == "λ0"
        λ0 = 1/2*(1+tr(T))^(1/2)
        λ1 = 1/λ0*1/4*(T[3,2]-T[2,3])
        λ2 = 1/λ0*1/4*(T[1,3]-T[3,1])
        λ3 = 1/λ0*1/4*(T[2,1]-T[1,2])
    elseif λ =="λ1"
        λ1 = 1/2*(1+2*T[1,1]-tr(T))^(1/2)
        λ0 = 1/λ1*1/4*(T[3,2]-T[2,3])
        λ2 = 1/λ1*1/4*(T[1,2]+T[2,1])
        λ3 = 1/λ1*1/4*(T[1,3]+T[3,1])
    elseif λ == "λ2"
        λ2 = 1/2*(1+2*T[2,2]-tr(T))^(1/2)
        λ0 = 1/λ2*1/4*(T[1,3]-T[3,1])
        λ1 = 1/λ2*1/4*(T[1,2]+T[2,1])
        λ3 = 1/λ2*1/4*(T[2,3]+T[3,2])
    elseif λ == "λ3"
        λ3 = 1/2*(1+2*T[3,3]-tr(T))^(1/2)
        λ0 = 1/λ3*1/4*(T[2,1]-T[1,2])
        λ1 = 1/λ3*1/4*(T[1,3]+T[3,1])
        λ2 = 1/λ3*1/4*(T[2,3]-T[3,2])
    end
    if sign(λ0)==-1
        λ0 = -1* λ0
        λ1 = -1* λ1
        λ2 = -1* λ2
        λ3 = -1* λ3
    end

    return λ0, λ1, λ2, λ3


end


function quaternions2euler(λ0::Float64, λ1::Float64, λ2::Float64, λ3::Float64)
θ = asin(2*(λ0*λ2-λ1*λ3))
ψ_num = 2*(λ1*λ2+λ0*λ3)
ψ_denom = (λ0^2+λ1^2-λ2^2-λ3^2)
ψ = arctangent(ψ_num,ψ_denom)
Φ_num = 2*(λ2*λ3+λ0*λ1)
Φ_denom = (λ0^2-λ1^2-λ2^2+λ3^2)
Φ = arctangent(Φ_num,Φ_denom)
return θ, ψ, Φ
end
function T_matrixE(θ::Float64, ψ::Float64, Φ::Float64)
    T = Array{Float64}(undef, 3,3)
    T[1,1] = cos(θ)*cos(ψ)
    T[1,2] = -cos(Φ)*sin(ψ) + sin(Φ)*sin(θ)*cos(ψ)
    T[1,3] = sin(Φ)*sin(ψ) + cos(Φ)*sin(θ)*cos(ψ)
    T[2,1] = cos(θ)*sin(ψ)
    T[2,2] = cos(Φ)*cos(ψ) + sin(Φ)*sin(θ)*sin(ψ)
    T[2,3] = -sin(Φ)*cos(ψ) + cos(Φ)*sin(θ)*sin(ψ)
    T[3,1] = -sin(θ)
    T[3,2] = sin(Φ)*cos(θ)
    T[3,3] = cos(Φ)*cos(θ)
    return T
end

function dominant(T)
    T00 = tr(T)
    trace = Dict("λ0"=>T00,"λ1"=>T[1,1],"λ2"=>T[2,2],"λ3"=>T[3,3])
    max_trace = maximum(values(trace))
    quater = "none"
    for (k,v) in trace
        if v == max_trace
            quater = k
        end
    end
    return quater
end

function euler2quartenions(θ::Float64, ψ::Float64, Φ::Float64)

    T = T_matrixE(θ, ψ, Φ)
    dominant_quater = dominant(T)

    λ0, λ1, λ2, λ3 = quaternions(dominant_quater, T)

    return λ0, λ1, λ2, λ3


end

function T_MatrixQ(λ0::Float64, λ1::Float64, λ2::Float64, λ3::Float64)
    T = Array{Float64}(undef, 3,3)
    T[1,1] = (λ0^2+λ1^2-λ2^2-λ3^2)
    T[1,2] = 2*(λ1*λ2-λ0*λ3)
    T[1,3] = 2*(λ1*λ3+λ0*λ2)
    T[2,1] = 2*(λ1*λ2+λ0*λ3)
    T[2,2] = (λ0^2-λ1^2+λ2^2-λ3^2)
    T[2,3] = 2*(λ2*λ3-λ0*λ1)
    T[3,1] = 2*(λ1*λ3-λ0*λ2)
    T[3,2] = 2*(λ2*λ3+λ0*λ1)
    T[3,3] = (λ0^2-λ1^2-λ2^2+λ3^2)

    return T

end




end
