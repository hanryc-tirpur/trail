/+  *test, *text-processing
|%
++  test-activity-summary-to-json
  =/  date-string  "2022-12-17T22:28:43Z" 
  ;:  weld
  %+  expect-eq
    !>  `[[%.y 2.022] 12 [17 22 28 43 ~]]
    !>  (convert-to-date date-string)
  ==
--
