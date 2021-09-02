#module aeroCoeff
#using Plots
#using DataInterpolations
using Interpolations
#export CM_α0_inter, CM_α2_inter, CD0_inter, CDδ2_inter, Cl_α0_inter, Cl_α2_inter, CN_pα_inter, Cl_p_inter


Mach_1 = [0, 0.875, 0.925, 0.965, 0.990, 1.025, 1.085, 1.19, 1.35, 1.80, 2.0, 2.5]
CD0 = [0.124, 0.124, 0.15, 0.2, 0.35, 0.375, 0.415, 0.415, 0.385, 0.335, 0.318, 0.276]
CD0_inter = LinearInterpolation(Mach_1, CD0, extrapolation_bc=Flat())

Mach_2 = [0, 0.88, 0.97, 0.99, 1.15, 1.25, 1.3, 2.5]
CDδ2 = [3.2, 3.2, 6.3, 4.0, 5.0, 5.4, 5.5, 5.5]
CDδ2_inter = LinearInterpolation(Mach_2, CDδ2, extrapolation_bc=Flat())

Mach_3 = [0, 0.43, 0.70, 0.91, 1.4, 1.75, 2.1, 2.5]
Cl_p = [-0.0178, -0.0149, -0.0135, -0.0126, -0.0110, -0.0101, -0.0094, -0.0087]
Cl_p_inter = LinearInterpolation(Mach_3, Cl_p, extrapolation_bc=Flat())

Mach_4 = [0, 0.4, 0.7, 0.89, 0.99, 1.09, 1.5, 2.0, 2.5]
Cl_α0 = [1.63, 1.63, 1.41, 1.22, 1.73, 1.57, 1.97, 2.25, 2.5]
Cl_α0_inter = LinearInterpolation(Mach_4, Cl_α0, extrapolation_bc=Flat())

Mach_5 = [0, 0.2, 0.6, 0.8, 0.985, 1.09, 1.3, 1.5, 2.0, 2.5]
Cl_α2 = [0.1, 0.1, 3.5, 6.6, 9.2, 8.8, 12.0, 13.7, 16.0, 17.0]
Cl_α2_inter = LinearInterpolation(Mach_5, Cl_α2, extrapolation_bc=Flat())

Mach_6 = [0, 0.46, 0.61, 0.78, 0.87, 0.925, 0.97, 1.09, 1.5, 2.5]
CM_α0 = [3.55, 3.55, 3.76, 3.92, 3.96, 4.85, 4.0, 3.83, 3.75, 3.75]
CM_α0_inter = LinearInterpolation(Mach_6, CM_α0, extrapolation_bc=Flat())

Mach_7 = [0, 0.4, 0.45, 0.65, 0.78, 0.885, 0.98, 1.075, 1.25, 1.5, 2.0, 2.5]
CM_α2 = [-2.9, -2.9, -3.1, -4.4, -3.45, -1.78, -3.0, -2.1, -3.325, -4.45, -4.6, -4.6]
CM_α2_inter = LinearInterpolation(Mach_7, CM_α2, extrapolation_bc=Flat())

Mach_8 = [0, 0.79, 1.15, 1.55]
CM_q_plus_CM_α = [-3.15, -3.15, -9.1, -9.5]
CM_q_plus_CM_α_inter = LinearInterpolation(Mach_8, CM_q_plus_CM_α, extrapolation_bc=Flat())

Mach_9 = [0, 0.22, 0.31, 0.48, 0.999, 1.001, 1.55]
α_t_sq = [0, 21.4, 348.5, 364.5, 632, 638, 706, 908, 1316]
CN_pα_Mach_inter = Vector{}(undef,length(Mach_9))

CN_pα_Mach1 = [-0.34, -0.91, -1.42, -2.63]
α_t_sq_Mach1 = [0, 632, 908, 1316]

CN_pα_Mach_inter[1] = LinearInterpolation(α_t_sq_Mach1, CN_pα_Mach1, extrapolation_bc=Flat())


CN_pα_Mach2 = [-0.34, -0.91, -1.42, -2.63]
α_t_sq_Mach2 = [0, 632, 908, 1316]

CN_pα_Mach_inter[2] = LinearInterpolation(α_t_sq_Mach2, CN_pα_Mach2, extrapolation_bc=Flat())


CN_pα_Mach3 = [-0.125, -0.465, -0.503, -1.015, -2.92]
α_t_sq_Mach3 = [0, 21.4, 364.5, 638, 1316]

CN_pα_Mach_inter[3] = LinearInterpolation(α_t_sq_Mach3, CN_pα_Mach3, extrapolation_bc=Flat())


CN_pα_Mach4 = [-0.34, -0.591, -2.45]
α_t_sq_Mach4 = [0, 348.5, 1316]

CN_pα_Mach_inter[4] = LinearInterpolation(α_t_sq_Mach4, CN_pα_Mach4, extrapolation_bc=Flat())

CN_pα_Mach5 = [-0.34, -0.591, -2.45]
α_t_sq_Mach5 = [0, 348.5, 1316]

CN_pα_Mach_inter[5] = LinearInterpolation(α_t_sq_Mach5, CN_pα_Mach5, extrapolation_bc=Flat())

CN_pα_Mach6 = [-0.36, -1.68]
α_t_sq_Mach6 = [0, 706]

CN_pα_Mach_inter[6] = LinearInterpolation(α_t_sq_Mach6, CN_pα_Mach6, extrapolation_bc=Flat())

CN_pα_Mach7 = [-0.36, -1.68]
α_t_sq_Mach7 = [0, 706]

CN_pα_Mach_inter[7] = LinearInterpolation(α_t_sq_Mach7, CN_pα_Mach7, extrapolation_bc=Flat())

CN_pα = Array{Float64,2}(undef, length(Mach_9), length(α_t_sq))
for i=1:length(Mach_9)

    for j=1:length(α_t_sq)
    CN_pα[i,j] = CN_pα_Mach_inter[i](α_t_sq[j])

    #println(CN_pα[i,j])
end
end

CN_pα_inter = LinearInterpolation((Mach_9,α_t_sq), CN_pα, extrapolation_bc=Flat())

Mach_10 = [0, 0.22, 0.31, 0.48, 0.81, 0.87, 0.92, 0.96, 0.995, 1.02, 1.1, 1.21, 1.28, 1.46, 1.55]
α_t_sq_10 = [0, 27.5, 315.3, 322.2, 375.2, 403.6, 410.8, 630.2, 637.7, 705.7, 743.9, 915.9, 1316]
CM_pα_Mach_inter = Vector{}(undef,length(Mach_10))

CM_pα_Mach1 = [0.10, 0.173, 0.345, 2.35]
α_t_sq_10_Mach1 = [0, 403.6, 630.2, 1316]

CM_pα_Mach_inter[1] = LinearInterpolation(α_t_sq_10_Mach1, CM_pα_Mach1, extrapolation_bc=Flat())


CM_pα_Mach2 = [0.10, 0.173, 0.345, 2.35]
α_t_sq_10_Mach2 = [0, 403.6, 630.2, 1316]

CM_pα_Mach_inter[2] = LinearInterpolation(α_t_sq_10_Mach2, CM_pα_Mach2, extrapolation_bc=Flat())


CM_pα_Mach3 = [0.10, 0.133, 0.471, 1.276, 2.35]
α_t_sq_10_Mach3 = [0, 410.8, 637.7, 915.9, 1316]

CM_pα_Mach_inter[3] = LinearInterpolation(α_t_sq_10_Mach3, CM_pα_Mach3, extrapolation_bc=Flat())


CM_pα_Mach4 = [-0.46, 0.08, 0.022, 0.94]
α_t_sq_10_Mach4 = [0, 27.5, 375.2, 1316]

CM_pα_Mach_inter[4] = LinearInterpolation(α_t_sq_10_Mach4, CM_pα_Mach4, extrapolation_bc=Flat())

CM_pα_Mach5 = [-0.46, 0.08, 0.22, 0.94]
α_t_sq_10_Mach5 = [0, 27.5, 375.2, 1316]

CM_pα_Mach_inter[5] = LinearInterpolation(α_t_sq_10_Mach5, CM_pα_Mach5, extrapolation_bc=Flat())

CM_pα_Mach6 = [0.4175, 0.053, 0.285]
α_t_sq_10_Mach6 = [0, 315.3, 743.9]

CM_pα_Mach_inter[6] = LinearInterpolation(α_t_sq_10_Mach6, CM_pα_Mach6, extrapolation_bc=Flat())

CM_pα_Mach7 = [0.4175, 0.053, 0.285]
α_t_sq_10_Mach7 = [0, 315.3, 743.9]

CM_pα_Mach_inter[7] = LinearInterpolation(α_t_sq_10_Mach7, CM_pα_Mach7, extrapolation_bc=Flat())

CM_pα_Mach8 = [0.3747, 0.05, 0.665]
α_t_sq_10_Mach8 = [0, 322.2, 1316]

CM_pα_Mach_inter[8] = LinearInterpolation(α_t_sq_10_Mach8, CM_pα_Mach8, extrapolation_bc=Flat())

CM_pα_Mach9 = [0.3747, 0.05, 0.665]
α_t_sq_10_Mach9 = [0, 322.2, 1316]

CM_pα_Mach_inter[9] = LinearInterpolation(α_t_sq_10_Mach9, CM_pα_Mach9, extrapolation_bc=Flat())

CM_pα_Mach10 = [0.2, 0.301]
α_t_sq_10_Mach10 = [0, 375.2]

CM_pα_Mach_inter[10] = LinearInterpolation(α_t_sq_10_Mach10, CM_pα_Mach10, extrapolation_bc=Flat())

CM_pα_Mach11 = [0.2, 0.301]
α_t_sq_10_Mach11 = [0, 375.2]

CM_pα_Mach_inter[11] = LinearInterpolation(α_t_sq_10_Mach11, CM_pα_Mach11, extrapolation_bc=Flat())

CM_pα_Mach12 = [0.193, 0.5, 0.445]
α_t_sq_10_Mach12 = [0, 403.6, 705.7]

CM_pα_Mach_inter[12] = LinearInterpolation(α_t_sq_10_Mach12, CM_pα_Mach12, extrapolation_bc=Flat())

CM_pα_Mach13 = [0.193, 0.5, 0.445]
α_t_sq_10_Mach13 = [0, 403.6, 705.7]

CM_pα_Mach_inter[13] = LinearInterpolation(α_t_sq_10_Mach13, CM_pα_Mach13, extrapolation_bc=Flat())

CM_pα_Mach14 = [0.215, 0.495]
α_t_sq_10_Mach14 = [0, 410.8]

CM_pα_Mach_inter[14] = LinearInterpolation(α_t_sq_10_Mach14, CM_pα_Mach14, extrapolation_bc=Flat())

CM_pα_Mach15 = [0.215, 0.495]
α_t_sq_10_Mach15 = [0, 410.8]

CM_pα_Mach_inter[15] = LinearInterpolation(α_t_sq_10_Mach15, CM_pα_Mach15, extrapolation_bc=Flat())


CM_pα = Array{Float64,2}(undef, length(Mach_10), length(α_t_sq_10))
for i=1:length(Mach_10)

    for j=1:length(α_t_sq_10)
    CM_pα[i,j] = CM_pα_Mach_inter[i](α_t_sq_10[j])

    #println(CM_pα[i,j])
end
end

CM_pα_inter = LinearInterpolation((Mach_10,α_t_sq_10), CM_pα, extrapolation_bc=Flat())
#end
