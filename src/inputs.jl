module inputs
export ρ0, dt, g0, tmax, t0, β, y0, p0, R, m,r, calibre, v0

const ρ0 = 1.225 #kg/m3
const g0 = 9.80665 #m/s2
const R = 287.05287
const tmax = 1.0 #s
const dt = 0.01 #s
const t0 = 288.15#K ou 15degC
const β = -6.5 #K/km
const y0 = 0.0 #m
const p0 = 101325#Pa
const m = 0.423#g
const r = 6356766# m
const calibre = 0.03 #m
const v0 = 900.0 #m/s

end
