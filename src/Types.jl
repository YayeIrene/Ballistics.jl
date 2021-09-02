module Types

export  AbstractProjectile, AP, AbstractMaterial, Impact, AbstractPenetrator, ShapeFactor, FragShapes, Fragment, Zone, Canon,Target1D,Target2D, dummyproj, Unkown, Properties, Projectile1D, Projectile2D, MaterialPenetrator, ST, AL, WF, DU, TA, TI, AT, MetallicParts, FH, MG, CI, CU, PB, TU, DO, PH, GE, UN, BN, LX,CP, SP, BG, PN, OK, NonMetallicParts, MaterialUnkown, MaterialHuman, Body
"""
AbstractPenetrator is the super type which contains the different types of penetrators
"""
abstract type AbstractPenetrator end
"""
AbstractTarget is the super type which contains all the different types of targets
"""
abstract type AbstractTarget end

"""
AbstractMaterial is the super type which contains all the different types of materials
"""
abstract type AbstractMaterial end

"""
AbstractProjectile is a subtype of AbstractPenetrator and contains all types of bullet
"""
abstract type AbstractProjectile <: AbstractPenetrator end
abstract type AbstractFragment <: AbstractPenetrator end


abstract type AbstractCritical <: AbstractTarget end




struct Properties
    bhn
    density
    bulk
    youngs
    hugoniot
    dynamic_yield
    static_ultimate
    plastic_strain
    plastic_stress
    static__yield
    static_shear
    dynamic_shear
    plastic_shear
    fracture
end

struct MetallicParts{x} <:AbstractMaterial
prop
end

struct NonMetallicParts{x} <:AbstractMaterial
prop
end

#struct MetallicPerson{x} <:AbstractMaterial
#nude::Bool
#end

struct MaterialPenetrator{x} <:AbstractMaterial
prop
end

struct MaterialUnkown{x} <:AbstractMaterial

end

struct MaterialHuman{x} <:AbstractMaterial

end

struct NonCriticalParts{x} <:AbstractTarget
    mat
end

mutable struct FirePower{x}  <: AbstractCritical
mat
hit
end
mutable struct Mobility{x} <: AbstractCritical
mat
hit
end
mutable struct Crew{x} <: AbstractCritical
#bodypart
mat
nude::Bool
hit
end
mutable struct Communication{x} <: AbstractCritical
mat
hit
end
mutable struct CatastrophicKill{x} <: AbstractCritical
mat
hit
end



struct ST end

struct WF end

struct DU end

struct AL end

struct TA end

struct TI end

struct AT end

struct FH end

struct MG end

struct DO end

struct PH end

struct CI end

struct CU end

struct PB end

struct TU end

struct UN end

struct BN end

struct LX end

struct CP end

struct SP end

struct BG end

struct GE end

struct PN end

struct OK end



mutable struct Parallelepiped <: AbstractFragment
    length
    width
    thickness
    end

mutable struct Cylinder <: AbstractFragment
    length
    diameter
    end

mutable struct Sphere <: AbstractFragment
    diameter
    end

mutable struct Round_nose <: AbstractFragment
    diameter
    length
    end

mutable struct Tapered <: AbstractFragment
    nose_diameter
    base_diameter
    nose_length
    base_length
    weight #this is used to compute the volume based on material data
end

mutable struct AP <: AbstractProjectile
    weight #this is used to compute the volume based on material data
    bhn
    nose_diameter
    base_diameter
    nose_length
    base_length
end

struct dummyproj <: AbstractPenetrator end



mutable struct Projectile1D{T<: Union{AbstractPenetrator,Nothing}, R<:Union{AbstractMaterial,Nothing}} <: AbstractPenetrator
    calibre::Float64
    type::T
    mat::R
    mass::Float64
    velocity_m::Float64 #magnitude
    e_v::Union{Array{Float64,1},Nothing} #velocity_vec #direction cosines of the unit vector directed along the initial shotline
    position::Float64
    spin::Union{Float64,Nothing}
    yaw::Union{Float64,Nothing}
    b_f::Union{Array{Float64,1},Nothing} #body_vec#b_1f, b_2f, b_3f
end
mutable struct Projectile2D{T<: Union{AbstractPenetrator,Nothing}, R<:Union{AbstractMaterial,Nothing}} <: AbstractPenetrator
    calibre::Float64
    type::T
    mat::R
    mass::Float64
    velocity::Array{Float64,1} #magnitude
    e_v::Union{Array{Float64,1},Nothing} #velocity_vec #direction cosines of the unit vector directed along the initial shotline
    position::Array{Float64,1}
    spin::Union{Float64,Nothing}
    yaw::Union{Float64,Nothing}
    b_f::Union{Array{Float64,1},Nothing} #body_vec#b_1f, b_2f, b_3f
    inertia::Union{Array{Float64,1},Nothing}
    tof::Union{Float64,Nothing}
end

mutable struct Target1D <:AbstractTarget
    size::Float64
    position::Float64
end

mutable struct Target2D <:AbstractTarget
    size::Float64
    position::Array{Float64,1}
    velocity::Array{Float64,1}
    #mass::Float64
    #density::Float64
end

mutable struct Canon
    tc::Float64
    lw::Float64
    X2w::Float64
end
#mutable struct component <: AbstractTarget
#    mat
#    critical::Bool
#end

#critical parts




 struct Ammo #<: AbstractFirePower
 end

 struct Tires #<: AbstractMobility
 end

 struct Diesel #<: AbstractCatastrophicKill
 end

 struct V8 #<: AbstractMobility
 end

 struct Radio #<: AbstractCommunication
 end

 #mutable struct target <: AbstractMaterial
#     type #::material
# end

struct Head #<: AbstractCrew
  # nude::Bool
end


struct Thorax #<: AbstractCrew
 #  nude::Bool
end

struct Abdomen #<: AbstractCrew
  # nude::Bool
end

struct Pelvis #<: AbstractCrew
    #nude::Bool
end

struct Arms #<: AbstractCrew
    #nude::Bool
end

struct Legs #<: AbstractCrew
    #nude::Bool
end

#non-critical parts
struct Hull end

struct Turret end
struct Unkown end
struct Body end

mutable struct Impact
    id::Int64
    x_position::Float64
    los::Float64
    obl::Float64
end

mutable struct Shotline
    id::Int64
    y_position::Float64
    z_position::Float64
    elements::Vector{Impact}
end

struct Zone
    angleBegin::Float64
    angleEnd::Float64
    μ_number::Float64
    σ_number::Float64
    μ_mass::Float64
    σ_mass::Float64
    μ_velocity::Float64
    σ_velocity::Float64
    density::Float64
end

mutable struct Fragment <:AbstractPenetrator
    rad::Float64
    ax::Float64
    mass::Float64
    density::Float64
    cd_sub::Float64
    Aₚ::Float64
    position::Array{Float64,1}
    velocity::Array{Float64,1}
    tof::Union{Float64,Nothing}

end

mutable struct FragShapes
    μ_cd::Float64
    σ_cd::Float64

end

mutable struct ShapeFactor
    μ::Float64
    σ::Float64
end




end
