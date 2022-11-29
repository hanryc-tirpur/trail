/-  *geo, *measurement
/+  *test, *lazytrig, geo
=/  castle=location  [[.~28.419411 %deg] [.~-81.581200 %deg]]  :: Cinderella's Castle
=/  spaceship=location  [[.~28.3753 %deg] [.~-81.5494 %deg]]  :: Epcot Spaceship Earth
=/  sagrada=location  [[.~41.40369 %deg] [.~2.17433 %deg]]  :: La Sagrada Familia
|%
++  to-km  ~(calculate-distance geo %km)
++  to-miles  ~(calculate-distance geo %mile)
++  expect-tol-eq
  |=  [a=distance b=distance]
  =/  tol  .~0.000005
  ~&  [a b (sub:rd val.b val.a)]
  %-  expect
    !>  (lth:rd (absolute (sub:rd val.b val.a)) tol)
++  test-km-distance-with-simple-locations
  ;:  weld
  %+  expect-tol-eq
    [.~5.8142840448732445 %km]
    (to-km castle spaceship)
  ==
++  test-mile-distance-with-simple-locations
  ;:  weld
  %+  expect-tol-eq
    [.~3.612828608969396 %mile]
    (to-miles castle spaceship)
  ==
--
