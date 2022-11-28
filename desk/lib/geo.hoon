/-  *geo, *measurement
/+  *lazytrig, measurement

=/  avg-earth-radius=distance  [.~6377.830272 %km]
|_  to-unit=distance-unit
++  to-miles  ~(convert measurement %mile)
++  calculate-distance
  |=  [a=location b=location]
  ^-  distance
  =/  lat-a-rad  (to-rad val.lat.a)
  =/  lat-b-rad  (to-rad val.lat.b)
  =/  long-a-rad  (to-rad val.long.a)
  =/  long-b-rad  (to-rad val.long.b)
  =/  arc-length  %-  acos  %-  add:rd  :-
    (mul:rd (sin lat-a-rad) (sin lat-b-rad))
  (mul:rd (mul:rd (cos lat-a-rad) (cos lat-b-rad)) (cos (sub:rd long-b-rad long-a-rad)))
  =/  km-distance=distance  (mul:measurement arc-length avg-earth-radius)
  ?:  =(%km to-unit)  km-distance
  (to-miles km-distance)
--
