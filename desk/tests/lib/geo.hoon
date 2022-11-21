/-  *geo, *measurement
/+  *test, geo
|%
++  test-km-distance-with-simple-locations
  =/  to-km  ~(calculate-distance geo %km)
  =/  castle=location  [[.~28.419411 %deg] [.~-81.581200 %deg]]  :: Cinderella's Castle
  =/  spaceship=location  [[.~28.3753 %deg] [.~-81.5494 %deg]]  :: Epcot Spaceship Earth
  :: =/  sagrada=location  [[.~41.40369 %deg] [.~2.17433 %deg]]  :: La Sagrada Familia
  ;:  weld
  %+  expect-eq
    :: Approximate expected value
    :: !>  [.~5.8142840448732445 %km]
    ::  Value with poorly estimated acos implementation
    !>  [.~0.08540981738462007 %km]
    !>  (to-km castle spaceship)
  ==
--
