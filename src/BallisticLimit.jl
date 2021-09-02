module BallisticLimit
using ...Types
export v_50
function equivalent_steel_cylinder(mat_p::MaterialPenetrator{WF}, mat_t::MetallicParts{ST})
    if mat_t.material.bhn<=380
        return true
    else
        return false
    end

end

function equivalent_steel_cylinder(mat_p::MaterialPenetrator{WF}, mat_t::MetallicParts{AL})
    return true
end

function equivalent_steel_cylinder(mat_p::MaterialPenetrator{WF}, mat_t::MetallicParts{TI})
    return true
end

function equivalent_steel_cylinder(mat_p::MaterialPenetrator{TA}, mat_t::MetallicParts{ST})
    return true
end

function equivalent_steel_cylinder(mat_p::MaterialPenetrator{DU}, mat_t::MetallicParts{ST})
    return true
end

function equivalent_steel_cylinder(mat_p::MaterialPenetrator{DU}, mat_t::MetallicParts{TI})
    return true
end


function normalised(penetration::Impact, proj::Projectile2D, tar_mat::AbstractMaterial)

    Ap_e = effective_area(proj,tar_mat)
    L,D,Ap_f, Ap_nf = equivalent_cylinder(proj.type, proj)
    X = penetration.los/(4*Ap_e/pi)^(1/2)
    Y = ((X*D/penetration.los)^3*(L/D)*(proj.mat.prop.density/ρ_st))^(1/2)
    flag = false
    #flag = equivalent_steel_cylinder(proj.mat, tar_mat)
    if isa(proj.mat,MaterialPenetrator{WF}) && isa(tar_mat,MetallicParts{ST})
        if proj.mat.type.bhn <= 380
            flag = true
        end
    end

    if isa(proj.mat,MaterialPenetrator{WF}) && isa(tar_mat,MetallicParts{AL})
        flag = true
    end

    if isa(proj.mat,MaterialPenetrator{WF}) && isa(tar_mat,MetallicParts{TI})
        flag = true
    end

    if isa(proj.mat,MaterialPenetrator{TA}) && isa(tar_mat,MetallicParts{ST})
        flag = true
    end

    if isa(proj.mat,MaterialPenetrator{DU}) && isa(tar_mat,MetallicParts{ST})
        flag = true
    end

    if isa(proj.mat,MaterialPenetrator{DU}) && isa(tar_mat,MetallicParts{TI})
        flag = true
    end


    if flag
        Z =Y
    else
        Z = Y*(ρ_st/proj.mat.prop.density)^(1/2)
    end
    return X, Y, Z
end

function coefficient(tar_mat::MetallicParts{ST}, proj::Projectile2D)
    if isa(proj.mat,MaterialPenetrator{ST})||isa(proj.mat,MaterialPenetrator{AL})
        C = 4254
        K = -538
        J = 5064
        b = 0.61
    elseif isa(proj.mat,MaterialPenetrator{WF})||isa(proj.mat,MaterialPenetrator{DU})
        C = 4599
        K = -594
        J = 5343
        b = 0.61
    elseif isa(proj.mat,MaterialPenetrator{TA})
        C = 2695
        K = 136
        J = 2916
        b = 1.24
    end
    return C, K, J, b
end

function coefficient(tar_mat::MetallicParts{AL}, proj::Projectile2D)
    if isa(proj.mat,MaterialPenetrator{WF})
        C = 946
        K = 0
        J = 1300
        b = 0.86
    else
        C = 3.87 * tar_mat.type.bhn + 295
        K = 2.2 * tar_mat.typ.bhn + 715
        J = -21.6 * tar_mat.type.bhn + 7282
        b = 1.75
    end
    return C, K, J, b

end

function coefficient(tar_mat::MetallicParts{TI}, proj::Projectile2D)
    if isa(proj.mat,MaterialPenetrator{WF})||isa(proj.mat,MaterialPenetrator{DU})
        C = 1495
        K = 200
        J = 3490
        b = 1.0
    else
        C = 2440
        K = 410
        J = 6275
        b = 1.05
    end
    return C, K, J, b

end

function coefficient_AP(tar_mat::MetallicParts{AL}, proj::Projectile2D)
    C_s = 1795
    bs = 0.61
    ps=1.0
    return C_s, bs, ps

end

function coefficient_AP(tar_mat::MetallicParts{TI}, proj::Projectile2D)
    C_s = 1437
    bs = 0.75
    ps=1.0
    return C_s, bs, ps

end

function coefficient_AP(tar_mat::MetallicParts{ST}, proj::Projectile2D)
    if isa(proj.mat,MaterialPenetrator{DU}) || isa(proj.mat,MaterialPenetrator{WF}) || isa(proj.mat,MaterialPenetrator{TA})
        C_s = 2763
        bs = 0.66
        ps = 1.0
    else
        C_s = 3143
        bs = 0.60
        ps = 1.0
    end

    return C_s, bs, ps

end
function Vfactor(proj::Projectile2D, tar_mat::AbstractMaterial, penetration::Impact)
    Ap_e = effective_area(proj,tar_mat)
    γ_θ = tar_mat.prop.density*penetration.los*Ap_e/(proj.mass*cosd(penetration.obl))
    γ_θr =  tar_mat.prop.density*penetration.los*Ap_e/(proj.mass*cosd(θ_ref))
    V_factor = (cosd(θ_ref)/cosd(penetration.obl))*sqrt((exp(γ_θ)-1)/(exp(γ_θr)-1))
    return V_factor
end

function ballistic_limit(penetration::Impact, proj::Projectile2D, tar_mat::MetallicParts)

    θ_l = penetration.obl
    if penetration.obl > θ_ref
        θ_l = θ_ref
    end
    X, Y, Z = normalised(penetration, proj, tar_mat)
    C, K, J, b = coefficient(tar_mat, proj)
    if X>0.1
        V_50n = (C*X^b+K)/Y
    else
        V_50n = J*X/Y
    end
    if isa(tar_mat,MetallicParts{ST})
        C_st = -6.37*10^-6*tar_mat.prop.bhn^2+0.00373*tar_mat.prop.bhn+0.456
        #println(V_50n)
        V_50n = C_st*V_50n
        #println(V_50n)
    end
    #if typeof(tar_mat)==GE
    #    V_50 = (0.985*θ_l^2-0.74*θ_l+1.0)*V_50n
    #elseif X<=2
    #    V_50 = (1-((0.197-0.0486*X^2.45)*θ_l^2+(0.0745*X^2-0.135*X)*θ_l))*(V_50n/cosd(θ_l))
    #else
        #println(V_50n)
        V_50 = V_50n/cosd(θ_l)
    #end
    if penetration.obl > θ_ref
        V_factor = Vfactor(proj, tar_mat, penetration)
        #println(V_50)
        V_50 = V_50*V_factor
    end
    #println(V_50)
    return V_50
end



function nose_type(AP::AP)
    if (AP.nose_diameter/AP.base_diameter<=0.5)&&(AP.nose_length/(AP.base_diameter-AP.nose_diameter)>=1.0)
        NSHP = false
    else
        NSHP = true
    end
    return NSHP
end

function attack_type(proj::Projectile2D, tar_mat::AbstractMaterial)
    NSHP = nose_type(proj.type)
    if NSHP || (proj.yaw>10)||(isa(tar_mat,MetallicParts{ST}) && proj.mat.prop.bhn<560)
        ATK = false #blunt attack
    else
        ATK = true #sharp attack
    end
    return ATK
end

function ballistic_limit_sharp(penetration::Impact, proj::Projectile2D, tar_mat::MetallicParts, proj_type::AbstractProjectile)
    X, Y, Z = normalised(penetration, proj, tar_mat)
    L,D,Ap_f, Ap_nf = equivalent_cylinder(proj.type, proj)
    C_s, bs, ps = coefficient_AP(tar_mat, proj)
    V_50n = C_s*((ρ_st/proj.mat.prop.density)*(X/(L/D)))^bs*(1-exp(-3.2*sqrt(X)))
    θ = penetration.obl
    if isa(tar_mat,MetallicParts{GE})
        V_50 = V_50n*(1.640*(deg2rad(θ))^2-0.72*deg2rad(θ)+1.0)
    else
        V_50 = V_50n/(cosd(θ))^ps
    end
    if θ > θ_ref
        V_factor = Vfactor(proj, tar_mat, penetration)
        V_50 = V_50 * V_factor
    end

    return V_50

end

function ballistic_limit_sharp(penetration::Impact, proj::Projectile2D, tar_mat::MaterialUnkown, proj_type::AbstractProjectile)
    return 0
end
function ballistic_limit(penetration::Impact, proj::Projectile2D, tar_mat::MaterialUnkown, proj_type::AbstractProjectile)
    return 0
end

#function ballistic_limit_sharp(penetration::Impact, proj::Projectile, tar_mat::Crew, proj_type::AbstractProjectile)
#    return 0
#end
#function ballistic_limit(penetration::Impact, proj::Projectile, tar_mat::Crew, proj_type::AbstractProjectile)
#    return 0
#end

function v_50(proj::AbstractPenetrator, tar_mat::AbstractMaterial, penetration::Impact)
    if typeof(proj.type) <: AbstractFragment
        v50 = ballistic_limit(penetration, proj, tar_mat)
        #println(v50)
    elseif typeof(proj.type) <: AbstractProjectile
        sharp = attack_type(proj, tar_mat)
        if sharp
            v50 = ballistic_limit_sharp(penetration, proj, tar_mat, proj.type)
        else
            v50 = ballistic_limit(penetration, proj, tar_mat)
        end
    end
    #println(v50)
    v50 = v50*0.3048  #in m/s
    return v50
end
end
