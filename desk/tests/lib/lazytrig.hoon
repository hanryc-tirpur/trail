/+  *test, *lazytrig
=/  pi        .~3.1415926535897932
=/  half-pi   (div:rd pi .~2)
|%
++  expect-tol-eq
  |=  [a=@rd b=@rd]
  =/  tol  .~0.0005
  ~&  [a b (sub:rd b a)]
  %-  expect
    !>  (lth:rd (absolute (sub:rd b a)) tol)
++  test-acos-negative-out-of-range
  ;:  weld
  %-  expect-fail
    |.  (acos .~-2)
  ==
++  test-acos-negative-one
  ;:  weld
  %+  expect-tol-eq
    pi
    (acos .~-1)
  ==
++  test-acos-close-to-negative-one
  ;:  weld
  %+  expect-tol-eq
    .~2.69056584
    (acos .~-0.9)
  ==
++  test-acos-positive-out-of-range
  ;:  weld
  %-  expect-fail
    |.  (acos .~1.25)
  ==
++  test-acos-one
  ;:  weld
  %+  expect-tol-eq
    .~0
    (acos .~1)
  ==
++  test-acos-close-to-postive-one
  ;:  weld
  %+  expect-tol-eq
    .~0.141539473
    (acos .~0.99)
  ==
++  test-acos-zero
  ;:  weld
  %+  expect-tol-eq
    half-pi
    (acos .~0)
  ==
++  test-acos-in-lower-range
  ;:  weld
  %+  expect-tol-eq
    .~1.31811607
    (acos .~0.25)
  ==
++  test-acos-in-mid-range
  ;:  weld
  %+  expect-tol-eq
    .~1.04719755
    (acos .~0.5)
  ==
++  test-floor-zero
  ;:  weld
  %+  expect-eq
    !>  0
    !>  (floor .~0.0)
  ==
++  test-floor-less-than-one
  ;:  weld
  %+  expect-eq
    !>  0
    !>  (floor .~0.435)
  ==
++  test-floor-greater-than-one
  ;:  weld
  %+  expect-eq
    !>  8
    !>  (floor .~8.175)
  ==
++  test-floor-large-number
  ;:  weld
  %+  expect-eq
    !>  23.458
    !>  (floor .~23458.175)
  ==
++  test-floor-remainder-less-than-one
  ;:  weld
  %+  expect-eq
    !>  .~0.435
    !>  (floor-remainder .~0.435)
  ==
++  test-floor-remainder-greater-than-one
  ;:  weld
  %+  expect-tol-eq
    .~0.175
    (floor-remainder .~8.175)
  ==
++  test-floor-remainder-large-number
  ;:  weld
    %+  expect-tol-eq
    .~0.175
    (floor-remainder .~23458.175)
  ==
++  test-round-zero
  ;:  weld
  %+  expect-eq
    !>  0
    !>  (round .~0)
  ==
++  test-round-single-digit
  ;:  weld
  %+  expect-eq
    !>  3
    !>  (round .~3)
  ==
++  test-round-up
  ;:  weld
  %+  expect-eq
    !>  4
    !>  (round .~3.78)
  ==
++  test-round-down
  ;:  weld
  %+  expect-eq
    !>  4
    !>  (round .~4.43)
  ==
--
