/+  *test, *text-processing
|%
++  test-convert-to-date-can-successfully-parse-date
  =/  date-string  "2022-12-17T22:28:43Z" 
  ;:  weld
  %+  expect-eq
    !>  `[[%.y 2.022] 12 [17 22 28 43 ~]]
    !>  (convert-to-date date-string)
  ==
++  test-convert-to-date-returns-null-when-not-proper-date-format
  =/  date-string  "12/17/2022 22:28:43" 
  ;:  weld
  %+  expect-eq
    !>  ~
    !>  (convert-to-date date-string)
  ==
++  test-strip-decimals
  ;:  weld
  %+  expect-eq
    !>  "9876543"
    !>  (remove-decimals "9.876.543")
  ==
++  test-to-tape-without-decimals
  ;:  weld
  %+  expect-eq
    !>  "890123456"
    !>  (to-tape-without-decimals 890.123.456)
  ==
--
