|%
++  convert-to-date
  |=  maybe-date=tape
  ^-  (unit date)
  =/  parser  ;~  plug
    dem
    hep
    dem
    hep
    dem
    (just 'T')
    dem
    col
    dem
    col
    dem
    (just 'Z')
  ==
  =/  result  (scan maybe-date parser)
  =/  parsed  `date`[[%.y -.result] +>-.result +>+>-.result +>+>+>-.result +>+>+>+>-.result +>+>+>+>+>-.result ~]
  `parsed
++  to-tape-without-decimals
  |=  num=@u
  (remove-decimals "{<num>}")
++  match-comma
  |=  c=@tD
  =(c ',')
++  match-period
  |=  c=@tD
  =(c '.')
++  match-whitespace
  |=  c=@tD
  =/  newline  '\0a'
  ?:  =(c ' ')  %.y
    ?:  =(c newline)  %.y
  %.n
++  remove-commas
  |=  num=@ud
  ~&  [%removing-commas num ~(r at num)]
  (skip ~(r at num) match-comma)
++  remove-decimals
  |=  str=tape
  (skip str match-period)
++  remove-whitespace
  |=  c=@tD
  (skip (trip c) match-whitespace)
--
