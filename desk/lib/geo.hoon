/-  *geo, *measurement
/+  *lazytrig

|_  to-unit=distance-unit
++  calculate-distance
  |=  [a=location b=location]
  ^-  distance
  =/  avg-earth-radius-km  .~6377.830272
  =/  lat-a-rad  (to-rad val.lat.a)
  =/  lat-b-rad  (to-rad val.lat.b)
  =/  long-a-rad  (to-rad val.long.a)
  =/  long-b-rad  (to-rad val.long.b)
  =/  before-radius  %-  acos  %-  add:rd  :-
    (mul:rd (sin lat-a-rad) (sin lat-b-rad))
  (mul:rd (mul:rd (cos lat-a-rad) (cos lat-b-rad)) (cos (sub:rd long-b-rad long-a-rad)))
  :_  to-unit
  (mul:rd before-radius avg-earth-radius-km)
--
