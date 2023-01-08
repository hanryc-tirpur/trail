|%
++  remove-commas
  |=  num=@ud
  ~&  [%removing-commas num ~(r at num)]
  (skip ~(r at num) match-comma)
++  match-comma
  |=  c=@tD
  =(c ',')
++  match-period
  |=  c=@tD
  =(c '.')
--
