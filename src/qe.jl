using Ballistics

function Δrange(v0::Float64, θ::Float64, target::Types.Target2D, trajectory::Function)

vx = v0*cosd(θ)
vy = v0*sind(θ)
p = scenario.createProjectile(0.03, 0.04,[vx,vy], [0.0,0.0])
trajectory(p,target)
Δrange = target.position[2]-p.position[2]

return Δrange
end

function bissection(target::Types.Target2D; θmin = 0.0, θmax = 45.0, ϵ = 0.001 )

#t2D = scenario.createTarget(0.2,[200.0,50.0])

#global θmin = 0.0
#global θmax = 45.0
v0 = 900.0
#ϵ = 0.001
#global fmin = Δrange(inputs.v0, θmin,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
#global fmax = Δrange(inputs.v0, θmax,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
#global error = min(abs(fmin),abs(fmax))
fmin = Δrange(inputs.v0, θmin,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
fmax = Δrange(inputs.v0, θmax,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
error = min(abs(fmin),abs(fmax))

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

    f = Δrange(inputs.v0, θ,t2D, ExternalBallistics.PmmZeroDrag.timeOfFlight!)
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
