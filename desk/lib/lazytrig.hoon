::  Transcendental functions library for Hoon, compatible with @rd
=/  tau  .~6.28318530717
=/  pi   .~3.14159265358
=/  e    .~2.718281828
=/  rtol  .~1e-5
|%
++  factorial
  |=  x=@rd  ^-  @rd
  =/  t=@rd  .~1
  |-  ^-  @rd
  ?:  =(x .~1)
    t
  $(x (sub:rd x .~1), t (mul:rd t x))
++  absolute
  |=  x=@rd  ^-  @rd
  ?:  (gth:rd x .~0)
    x
  (sub:rd .~0 x)
++  acos
  ::  https://stackoverflow.com/questions/3380628/fast-arc-cos-algorithm
  ::  a = -0.939115566365855
  ::  b =  0.9217841528914573
  ::  c = -1.2845906244690837
  ::  d =  0.295624144969963174
  ::  acos(x) ≈ π/2 + (ax + bx³) / (1 + cx² + dx⁴)
  ::
  ::  https://opensource.apple.com/source/Libm/Libm-315/Source/Intel/acos.c
  ::
  |=  x=@rd  ^-  @rd
  =/  a  .~-0.939115566365855
  =/  b  .~0.9217841528914573
  =/  c  .~-1.2845906244690837
  =/  d  .~0.295624144969963174
  %-  add:rd  :-
    (div:rd pi .~2)
  %-  div:rd  :-  
    (add:rd (mul:rd a x) (mul:rd b (pow-n x .~3)))
  (add:rd .~1 (add:rd (mul:rd c (pow-n x .~2)) (mul:rd d (pow-n x .~4))))

++  exp
  |=  x=@rd  ^-  @rd
  =/  rtol  .~1e-5
  =/  p   .~1
  =/  po  .~-1
  =/  i   .~1
  |-  ^-  @rd
  ?:  (lth:rd (absolute (sub:rd po p)) rtol)
    p
  $(i (add:rd i .~1), p (add:rd p (div:rd (pow-n x i) (factorial i))), po p)
++  pow-n
  ::  restricted pow, based on integers only
  |=  [x=@rd n=@rd]  ^-  @rd
  ?:  =(n .~0)  .~1
  =/  p  x
  |-  ^-  @rd
  ?:  (lth:rd n .~2)
    p
  ::~&  [n p]
  $(n (sub:rd n .~1), p (mul:rd p x))
++  sin
  ::  sin x = x - x^3/3! + x^5/5! - x^7/7! + x^9/9! - ...
  |=  x=@rd  ^-  @rd
  =/  rtol  .~1e-5
  =/  p   .~0
  =/  po  .~-1
  =/  i   .~0
  |-  ^-  @rd
  ?:  (lth:rd (absolute (sub:rd po p)) rtol)
    p
  =/  ii  (add:rd (mul:rd .~2 i) .~1)
  =/  term  (mul:rd (pow-n .~-1 i) (div:rd (pow-n x ii) (factorial ii)))
  ::~&  [i ii term p]
  $(i (add:rd i .~1), p (add:rd p term), po p)
++  cos
  ::  cos x = 1 - x^2/2! + x^4/4! - x^6/6! + x^8/8! - ...
  |=  x=@rd  ^-  @rd
  =/  rtol  .~1e-5
  =/  p   .~1
  =/  po  .~-1
  =/  i   .~1
  |-  ^-  @rd
  ?:  (lth:rd (absolute (sub:rd po p)) rtol)
    p
  =/  ii  (mul:rd .~2 i)
  =/  term  (mul:rd (pow-n .~-1 i) (div:rd (pow-n x ii) (factorial ii)))
  ::~&  [i ii term p]
  $(i (add:rd i .~1), p (add:rd p term), po p)
++  tan
  ::  tan x = sin x / cos x
  |=  x=@rd  ^-  @rd
  (div:rd (sin x) (cos x))
  ::  don't worry about domain errors right now, this is lazy trig
++  log-e-2
  ::  natural logarithm, only converges for z < 2
  |=  z=@rd  ^-  @rd
  =/  rtol  .~1e-5
  =/  p   .~0
  =/  po  .~-1
  =/  i   .~1
  |-  ^-  @rd
  ?:  (lth:rd (absolute (sub:rd po p)) rtol)
    p
  =/  ii  (add:rd .~1 i)
  =/  term  (mul:rd (pow-n .~-1 (add:rd .~1 i)) (div:rd (pow-n (sub:rd z .~1) i) i))
  ::~&  [i ii term p]
  $(i (add:rd i .~1), p (add:rd p term), po p)
++  log-e
  ::  natural logarithm, z > 0
  |=  z=@rd  ^-  @rd
  =/  rtol  .~1e-5
  =/  p   .~0
  =/  po  .~-1
  =/  i   .~0
  |-  ^-  @rd
  ?:  (lth:rd (absolute (sub:rd po p)) rtol)
    (mul:rd (div:rd (mul:rd .~2 (sub:rd z .~1)) (add:rd z .~1)) p)
  =/  term1  (div:rd .~1 (add:rd .~1 (mul:rd .~2 i)))
  =/  term2  (mul:rd (sub:rd z .~1) (sub:rd z .~1))
  =/  term3  (mul:rd (add:rd z .~1) (add:rd z .~1))
  =/  term  (mul:rd term1 (pow-n (div:rd term2 term3) i))
  ::~&  [i term p]
  $(i (add:rd i .~1), p (add:rd p term), po p)
++  pow
  ::  general power, based on logarithms
  ::  x^n = exp(n ln x)
  |=  [x=@rd n=@rd]  ^-  @rd
  (exp (mul:rd n (log-e x)))
++  to-rad
  |=  deg=@rd  ^-  @rd
  (mul:rd (div:rd deg .~180.00) pi)
--
