using DifferentialEquations
const g = 9.81
L = 1.0
tspan = (0.0,1.0)
function f(du,u,p,t)
    du[1] = u[3]#vx
    du[2] = u[4]#vy
    du[3] =  0 #ax no forces in this direction
    du[4] = g #ax
end
function bc1!(residual, u, p, t)
    residual[1] = u[end][1] + pi/2 # the solution at the middle of the time span should be -pi/2
    residual[2] = u[end][1] - pi/2 # the solution at the end of the time span should be pi/2
    residual[3] = u[1][2]-1
end
bvp1 = BVProblem(simplependulum!, bc1!, [pi/2,pi/2,0.0], tspan)
sol1 = solve(bvp1, GeneralMIRK4(), dt=0.05)
#plot(sol1)
