module post
using ..Types
Base.show(io::IO, w::Types.AbstractProjectile) = print(io, "projectile", " at ", w.position, " with velocity ", w.velocity_m)
end
