module materials
using ..Types
export dummyMat
#penetrator
steel_4140 = MaterialPenetrator{ST}(Properties(293, 0.283, 24.0e6, 30.0e6, 17117, 166717, 146500, 15079, 2023, 125958, 77201, 96254, 1168, 1.0))
steel_1018 = MaterialPenetrator{ST}(Properties(200, 0.283, 24.0e6, 30.0e6, 17117, 113800, 100000, 15079, 1672, 79524, 54693, 65702, 965, 1.0))
steel_4130 = MaterialPenetrator{ST}(Properties(300, 0.283, 24.0e6, 30.0e6, 17117, 170700, 150000, 15079, 2047, 129154, 78828, 98554, 1182, 1.0))
aluminium_2024 = MaterialPenetrator{AL}(Properties(120, 0.100, 10.0e6, 10.0e6, 18024, 68280, 60000, 16374, 2178, 53288, 40572, 39421, 1258, 1.0))
tungsten_alloy_GTE = MaterialPenetrator{WF}(Properties(285, 0.639, 41.667e6, 52.5e6, 15804, 162165, 142500,13222, 1328, 85.0e3, 49075, 93626, 767, 1.0))
tungsten_alloy_WHA_1597 = MaterialPenetrator{WF}(Properties(264, 0.625, 39.68e6, 50.0e6, 15700, 150216, 132000, 13047, 1292, 86.0e3, 49652,86727, 746, 1.0))
tungsten_alloy_WHA_1598 = MaterialPenetrator{WF}(Properties(280, 0.620, 39.68e6, 50.0e6, 15664, 159320, 140000, 13099, 1263, 119.0e3, 68705, 91983, 439, 1.2))
depleted_uranium = MaterialPenetrator{DU}(Properties(231, 0.671, 14.5e6, 24.0e6, 10500, 131439, 115500, 7612, 1167, 140.0e3, 80829, 75886, 674, 1.0))
tantalum = MaterialPenetrator{TA}(Properties(255, 0.602, 30.0e6, 27.0e6, 12500, 145095, 127500, 11559, 1294, 40.0e3, 23094, 83770, 747, 1.0))
titanium_6AI = MaterialPenetrator{TI}(Properties(285, 0.163, 19.2e6, 16.0e6, 19002, 162165, 142500, 17771, 2629, 120.0e3, 69282, 93626, 1518, 1.0))
Aluminium_teflon = MaterialPenetrator{AT}(Properties(6, 0.082, 2.69e6, 2.69e6, 13127, 3414, 3000, 9378, 538, 1500, 866, 1971, 311, 1.0))

#target
steel = MetallicParts{ST}(Properties(150, 0.283, 24.0e6, 30.0e6, 17117, 85350, 75000, 15079, 1448, 51507, 41911, 49277, 836, 1.0))
face_hardened_steel = MetallicParts{FH}(Properties(530, 0.283, 24.0e6, 30.0e6, 17117, 301570, 265000, 15079, 2721, 210894, 127105, 174112, 1571, 1.0))
aluminium = MetallicParts{AL}(Properties(120, 0.100, 10.0e6, 10.6e6, 18024, 68280, 60000, 16374, 2178, 53288, 40572, 39421, 1258, 1.0))
titanium = MetallicParts{TI}(Properties(285, 0.163, 19.2e6, 16.0e6, 19002, 162165, 142500, 17771, 2629, 120.0e3, 69282, 93626, 1518, 1.0))
magnesium = MetallicParts{MG}(Properties(55, 0.064, 4.2e6, 6.5e6, 15847, 31295, 27500, 13265, 1843, 29.0e3, 22.0e3, 18068, 1064, 1.0))
cast_iron = MetallicParts{CI}(Properties(185, 0.257, 15.4e6, 23.0e6, 15435, 105265, 92500, 12675, 1687, 61190, 43645, 60775, 974, 1.0))
copper = MetallicParts{CU}(Properties(85, 0.320, 19.0e6, 17.0e6, 15394, 48365, 42500, 12617, 1025, 45965, 28565, 27924, 592, 1.0))
lead = NonMetallicParts{PB}(Properties(8, 0.394, 2.0e6, 2.4e6, 9144, 4552, 4000, 3689, 283, 2189.5, 870.0, 2628, 164, 1.0))
tuballoy = MetallicParts{TU}(Properties(240, 0.674, 20.7e6, 45.0e6, 12914, 136560, 120000, 9074, 1187, 140.0e3, 80829, 78843, 685, 1.0))
doron = NonMetallicParts{DO}(Properties(100, 0.073, 2.3e6, 2.3e6, 12996, 56900, 50000, 9191, 2327, 34.0e3, 19630, 32851, 1344, 1.0))
phenolic = NonMetallicParts{PH}(Properties(120, 0.069, 1.48e6, 4.0e6, 12472, 21622, 19000, 7583, 1476, 19.0e3, 12.0e3, 12483, 852, 1.0))
graphite_epoxy =MetallicParts{GE}(Properties(70, 0.057, 1.6e6, 1.6e6, 12635, 39830, 35000, 8675, 2204, 2000, 17500, 22996, 1272, 1.0))
unbonded_nylon = NonMetallicParts{UN}(Properties(20, 0.027, 0.9e6, 1.07e6, 13180, 11380, 10000, 9454, 1711, 9178.5, 29145, 6570, 988, 1.0))
bonded_nylon = NonMetallicParts{BN}(Properties(38, 0.034, 0.1e6, 87.0e3, 8528, 21622, 19000, 2808, 2102, 19430, 29145, 12483, 1214, 1.0))
lexan = NonMetallicParts{LX}(Properties(20, 0.046, 0.5e6, 0.3e6, 10341, 11380, 10000, 5398, 1311, 10.0e3, 9.0e3, 6570, 757, 1.0))
cast_plexiglas = NonMetallicParts{CP}(Properties(18, 0.042, 0.76e6, 0.4e6, 11438, 10242, 9000, 6965, 1302, 10.0e3, 11.0e3, 5913, 752, 1.0))
stretched_plexiglas = NonMetallicParts{SP}(Properties(23, 0.044, 0.76e6, 0.4e6, 11326, 13087, 11500, 6805, 1438, 10.0e3, 11.0e3, 7.556, 830, 1.0))
bullet_resistant_plexiglas = MetallicParts{BG}(Properties(1000, 0.089, 6.45e6, 10.0e6, 19320, 11380, 10000, 13939, 943, 8000, 70.0e3, 6570, 544, 1.0))
pine = NonMetallicParts{PN}(Properties(1, 0.013, 0.28e6, 1.3e6, 11881, 569, 500, 7599, 552, 310.0, 900.0, 329, 318, 1.0))
oak = NonMetallicParts{OK}(Properties(2, 0.025, 1.04e6, 1.8e6, 13955, 1138, 1000, 10561, 562, 800.0, 1780.0, 657, 325, 1.0))


rubber = MaterialUnkown{Unkown}()
#flesh = MaterialUnkown{Unkown}()
flesh = MaterialHuman{Body}()

dummyMat = MaterialUnkown{Unkown}()

end
