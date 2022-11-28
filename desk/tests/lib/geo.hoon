/-  *geo, *measurement
/+  *test, geo
=/  castle=location  [[.~28.419411 %deg] [.~-81.581200 %deg]]  :: Cinderella's Castle
=/  spaceship=location  [[.~28.3753 %deg] [.~-81.5494 %deg]]  :: Epcot Spaceship Earth
=/  sagrada=location  [[.~41.40369 %deg] [.~2.17433 %deg]]  :: La Sagrada Familia
|%
++  to-km  ~(calculate-distance geo %km)
++  to-miles  ~(calculate-distance geo %mile)
++  expect-tol-eq
  |=  [a=distance b=distance]
  =/  tol  .~0.000005
  =/  abs  ?:  (gth:rd val.a val.b)
    (sub:rd val.a val.b)
  (sub:rd val.b val.a)
  %-  expect
    !>  (lth:rd abs tol)
++  test-km-distance-with-simple-locations
  ;:  weld
  %+  expect-tol-eq
    :: Approximate expected value
    :: !>  [.~5.8142840448732445 %km]
    ::  Value with poorly estimated acos implementation
    [.~0.08540981738462007 %km]
    (to-km castle spaceship)
  ==
++  test-mile-distance-with-simple-locations
  ;:  weld
  %+  expect-tol-eq
    :: Approximate expected value
    :: !>  [.~3.612828608969396 %mile]
    ::  Value with poorly estimated acos implementation
    [.~0.053071200057054346289 %mile]
    (to-miles castle spaceship)
  ==
--
