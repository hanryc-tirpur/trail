/-  *measurement

=/  mile-to-km  .~1.609344
=/  km-to-mile  .~0.6213712
|_  to-unit=distance-unit
++  convert
  |=  d=distance
  ^-  distance
  :_  to-unit
  (get-val d)
++  get-val
  |=  d=distance
  ^-  @rd
  ?:  =(unit.d to-unit)  val.d
    ?-  unit.d
      %km     (mul:rd km-to-mile val.d)
      %mile   (mul:rd mile-to-km val.d)
    ==
++  add-distance
  |=  [a=distance b=distance]
  ^-  distance
  :_  to-unit
  (add:rd (get-val a) (get-val b))
++  mul
  |=  [a=@rd b=distance]
  ^-  distance
  :_  unit.b
  (mul:rd a val.b)
--
