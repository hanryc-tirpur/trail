|%
++  convert-to-date
  |=  maybe-date=tape
  ^-  (unit date)
  =+  hepdem=;~(pfix hep dem)
  =+  coldem=;~(pfix col dem)
  =/  parser  ;~  plug
    (stag %.y dem)
    hepdem
    hepdem
    ;~(pfix (just 'T') dem)
    coldem
    coldem
    (cold ~ (just 'Z'))
  ==
  =/  result  (rust maybe-date parser)
  `(unit date)`result
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
