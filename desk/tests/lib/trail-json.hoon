/+  *test, *trail-json
|%
++  remove-whitespace
  |=  c=@tD
  =/  newline  '\0a'
  ?:  =(c ' ')  %.y
    ?:  =(c newline)  %.y
  %.n
++  test-activity-summary-to-json
  =/  expected-json
  '''
  {
    "activities": [
      {
        "totalElapsedTime": 45678,
        "id": 1676159502000,
        "totalDistance": {
          "val": 4.9455646421625,
          "unit": "mile"
        }
      }
    ]
  }
  '''
  =/  summary-1=activity  [%standard ~2023.2.11..23.51.42 %walk ~ [.~4.945564642162535 %mile] 45.678]
  ;:  weld
  %+  expect-eq
    !>  (skip (trip expected-json) remove-whitespace)
    !>  (en-json:html (enjs-update [%activities `(list activity)`~[summary-1]]))
  ==
++  test-u-to-tape
  ;:  weld
  %+  expect-eq
    !>  "1234567"
    !>  (u-to-tape 1.234.567)
  ==
--
