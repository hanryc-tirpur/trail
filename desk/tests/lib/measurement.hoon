/-  *measurement
/+  *test, measurement
|%
++  to-km  ~(add-distance measurement %km)
++  to-miles  ~(add-distance measurement %mile)
++  expect-tol-eq
  |=  [a=distance b=distance]
  =/  tol  .~0.000005
  =/  abs  ?:  (gth:rd val.a val.b)
    (sub:rd val.a val.b)
  (sub:rd val.b val.a)
  %-  expect
    !>  (lth:rd abs tol)
++  test-adding-two-distances-with-same-units
  ;:  weld
  %+  expect-tol-eq
    [.~1.57 %km]
    (to-km [.~1 %km] [.~0.57 %km])
  ==
++  test-adding-two-distances-with-different-units
  ;:  weld
  %+  expect-tol-eq
    [.~5.431213 %km]
    (to-km [.~1.2 %mile] [.~3.5 %km])
  ==
++  test-adding-two-distances-with-same-units-but-different-target-unit
  ;:  weld
  %+  expect-tol-eq
    [.~0.975552784 %mile]
    (to-miles [.~1 %km] [.~0.57 %km])
  ==
--
