module penetrators

#projectiles
lb = 0.00014286
nato_7p62 = AP(55*lb, 700, 0, 0.244, 0.281, 0.500)
us_7p62 = AP(81*lb, 700, 0, 0.244, 0.281, 0.781)
us_p50 = AP(404*lb, 700, 0, 0.429, 0.493, 1.2464)

#fragments

frag_p5 = Sphere(0.5)
frag_cyl = Cylinder(1.25, 0.5)

end
