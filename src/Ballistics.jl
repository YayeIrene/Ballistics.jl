module Ballistics

# Write your package code here.
#1. Exports/imports
export Fragmentation,Types, ExternalBallistics, Vulnerability, scenario, materials, Utils, inputs
#include("inputs.jl")
#using .inputs
include("Types.jl")
using .Types
include("materials.jl")
using .materials
include("scenario.jl")
using .scenario
include("Utils.jl")
using .Utils
#include("aerodynamic_coeff30.jl")
#using .aero30
#include("aerodynamic_coeff105.jl")
#using .aero105
include("InternalBallistics.jl")
using .InternalBallistics
include("ExternalBallistics.jl")
using .ExternalBallistics
include("fragmentation.jl")
using .Fragmentation
include("Vulnerability.jl")
using .Vulnerability
include("post.jl")
using .post

#2. Interface documentation
# in ballistics computation we have a projectile and a target
# a projectile accelerate with the
# InternalBallistcs!(p) function and flies with the
# ExternalBallistics!(p) function  and perfom penetration with
# Vulnerability!(p) function

#3. Generic definition for the interface
#Hard contracts
"""
InternalBallistics to get muzzle velocity. Optional
"""
function InternalBallistics!(args...)
nothing
end
"""
ExternalBallistics to get impact conditions. Optional
"""
function ExternalBallistics!(args...)
nothing
end
"""
Vulnerability to get damage assessment.
"""
function Vulnerability! end


#4. Game logic

function ballisticsComp!(p::Projectile1D, t::Target1D)
    InternalBallistics!(p)
    ExteralBallistics!(p)
    Vulnerability!(p,t)
    nothing
end
end
