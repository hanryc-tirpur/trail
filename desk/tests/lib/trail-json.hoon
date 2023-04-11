/+  *test, *trail-json
|%
++  remove-whitespace
  |=  c=@tD
  =/  newline  '\0a'
  ?:  =(c ' ')  %.y
    ?:  =(c newline)  %.y
  %.n
:: ++  test-activity-summary-to-json
::   =/  expected-json
::   '''
::   {
::     "activities": [
::       {
::         "totalElapsedTime": 3600,
::         "id": 1676159502000,
::         "totalDistance": {
::           "val": 4.9455646421625,
::           "unit": "mile"
::         }
::       }
::     ]
::   }
::   '''
::   =/  summary-1=activity  [%standard ~2023.2.11..23.51.42 %walk ~ [.~4.945564642162535 %mile] ~h1]
::   ;:  weld
::   %+  expect-eq
::     !>  (skip (trip expected-json) remove-whitespace)
::     !>  (en-json:html (enjs-update [%activities `(list activity)`~[summary-1]]))
::   ==
++  test-enjs-activity-for-tracked-activity-with-polyline
  =/  expected-json
  '''
  {
    "activityType": "run",
    "name": "Morningrun",
    "timeActive": 945,
    "segments": [{
      "distance": {
        "val": 4.9455646421625,
        "unit": "mile"
      },
      "path": "thisshouldbeapolyline",
      "timeElapsed": 945,
      "startTime": 1680861222000,
      "endTime": 1680861222000
    }],
    "id": 1680861222000,
    "totalDistance": {
      "val": 4.9455646421625,
      "unit": "mile"
    },
    "timeElapsed": 1107
  }
  '''
  =/  segment-to-enjs  :*
    %polyline
    ~2023.4.7..9.53.42 
    ~2023.4.7..9.53.42 
    "thisshouldbeapolyline"
    [.~4.945564642162535 %mile]
    (mul ~s1 945)
  ==
  =/  activity-to-enjs  :*
    %tracked
    ~2023.4.7..9.53.42 
    %run
    "Morningrun"
    (mul ~s1 945)
    (mul ~s1 1.107)
    [.~4.945564642162535 %mile]
    ~[segment-to-enjs]
  ==
  ;:  weld
  %+  expect-eq
    !>  (skip (trip expected-json) remove-whitespace)
    !>  (en-json:html (enjs-activity activity-to-enjs))
  ==
++  test-dejs-activity-for-tracked-activity-with-polyline
  =/  activity-json  %-  need  %-  de-json:html
  '''
  {
    "tracked": {
      "activityType": "run",
      "name": "Morningrun",
      "timeActive": 945,
      "segments": [{
        "polyline": {
          "distance": {
            "val": 4.9455646421625,
            "unit": "mile"
          },
          "path": "thisshouldbeapolyline",
          "timeElapsed": 945,
          "startTime": 1680861222000,
          "endTime": 1680861222000
        }
      }],
      "id": 1680861222000,
      "totalDistance": {
        "val": 4.9455646421625,
        "unit": "mile"
      },
      "timeElapsed": 1107
    }
  }
  '''
  =/  expected-segment  :*
    %polyline
    ~2023.4.7..9.53.42 
    ~2023.4.7..9.53.42 
    "thisshouldbeapolyline"
    [.~4.9455646421625 %mile]
    `@dr`(mul ~s1 945)
  ==
  =/  expected-activity  :*
    %tracked
    ~2023.4.7..9.53.42
    %run
    "Morningrun"
    `@dr`(mul ~s1 945)
    `@dr`(mul ~s1 1.107)
    [.~4.9455646421625 %mile]
    `(lest segment)`~[expected-segment]
  ==
  ;:  weld
  %+  expect-eq
    !>  expected-activity
    !>  (dejs-activity activity-json)
  ==
:: ++  test-dejs-activity-for-tracked-activity
::   =/  activity-json  %-  need  %-  de-json:html
::   '''
::   {
::     "tracked": {
::       "activityType": "run",
::       "name": "Morningrun",
::       "timeActive": 945,
::       "segments": [{
::         "location": {
::           "distance": {
::             "val": 4.9455646421625,
::             "unit": "mile"
::           },
::           "path": [
::             "thisshouldbeapolyline"
::           ],
::           "timeElapsed": 945,
::           "startTime": 1680861222000,
::           "endTime": 1680861222000
::         }
::       }],
::       "id": 1680861222000,
::       "totalDistance": {
::         "val": 4.9455646421625,
::         "unit": "mile"
::       },
::       "timeElapsed": 1107
::     }
::   }
::   '''
::   =/  expected-segment  :*
::     %polyline
::     ~2023.4.7..9.53.42 
::     ~2023.4.7..9.53.42 
::     "thisshouldbeapolyline"
::     [.~4.9455646421625 %mile]
::     `@dr`(mul ~s1 945)
::   ==
::   =/  expected-activity  :*
::     %tracked
::     ~2023.4.7..9.53.42
::     %run
::     "Morningrun"
::     `@dr`(mul ~s1 945)
::     `@dr`(mul ~s1 1.107)
::     [.~4.9455646421625 %mile]
::     `(lest segment)`~[expected-segment]
::   ==
::   ;:  weld
::   %+  expect-eq
::     !>  expected-activity
::     !>  (dejs-activity activity-json)
::   ==
++  test-u-to-tape
  ;:  weld
  %+  expect-eq
    !>  "1234567"
    !>  (u-to-tape 1.234.567)
  ==
--
