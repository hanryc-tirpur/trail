/+  regex
|%
++  convert-to-date
  |=  maybe-date=tape
  =/  js-date-regex  "^(\\d\{4})-(\\d\{2})-(\\d\{2})T(\\d\{2}):(\\d\{2}):(\\d\{2})Z"
  =/  get-date-part  ~(got by (ran:regex js-date-regex maybe-date))
  =/  year  q:(get-date-part 1)
  =/  month  (get-month-text q:(get-date-part 2))
  =/  day  q:(get-date-part 3)
  =/  hour  q:(get-date-part 4)
  =/  minute  q:(get-date-part 5)
  =/  second  q:(get-date-part 6)
  =/  parsed-date  (stud:chrono:userlib (crip "{day} {month} {year} {hour}:{minute}:{second}"))
  ~&  parsed-date
  parsed-date
++  get-month-text
  |=  month-number=tape
    ?:  =(month-number "01")  "Jan"
    ?:  =(month-number "02")  "Feb"
    ?:  =(month-number "03")  "Mar"
    ?:  =(month-number "04")  "Apr"
    ?:  =(month-number "05")  "May"
    ?:  =(month-number "06")  "Jun"
    ?:  =(month-number "07")  "Jul"
    ?:  =(month-number "08")  "Aug"
    ?:  =(month-number "09")  "Sep"
    ?:  =(month-number "10")  "Oct"
    ?:  =(month-number "11")  "Nov"
    ?:  =(month-number "12")  "Dec"
  !!
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
