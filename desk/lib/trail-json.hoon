/-  *trail, *measurement
/+  *lazytrig
|%
++  u-to-tape
  |=  a=@u
  ?:  =(0 a)  "0"
  %-  flop
  |-  ^-  ^tape
  ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
++  enjs-update
  =,  enjs:format
  |=  upd=update
  ^-  json
  ?-    -.upd
      %activities
    %-  pairs
    :~  ['activities' a+(turn list.upd enjs-activity)]
    ==
  ::
      %activity
    %-  pairs
    :~  ['time' s+'bye']
        ['logs' s+'hi']
    ==
  ==
  ++  enjs-activity
    =,  enjs:format
    |=  a=activity
    ^-  json
    ?-    -.a
        %standard
      %-  pairs
      :~  ['id' (numb (unm:chrono:userlib id.a))]
          ['totalElapsedTime' (numb (div total-elapsed-time.a ~s1))]
          :-  'totalDistance'
          %-  pairs
          :~  ['val' (numb-rd val.total-distance.a)]
              ['unit' s+unit.total-distance.a]
      ==  ==
        %strava
      %-  pairs
      :~  ['id' (numb (unm:chrono:userlib id.a))]
          ['activityType' s+activity-type.a]
          ['name' (tape name.a)]
          ['timeMoving' (numb (div time-moving.a ~s1))]
          ['timeElapsed' (numb (div time-elapsed.a ~s1))]
          ['mapPolyline' (tape map-polyline.a)]
          ['strava-activity-id' (numb strava-activity-id.a)]
          :-  'totalDistance'
          %-  pairs
          :~  ['val' (numb-rd val.total-distance.a)]
              ['unit' s+unit.total-distance.a]
      ==  ==
      ::       =activity-type
      :: name=tape
      :: time-active=@dr
      :: time-elapsed=@dr
      :: total-distance=distance
      :: segments=(lest segment)
        %tracked
      %-  pairs
      :~  ['id' (numb (unm:chrono:userlib id.a))]
          ['activityType' s+activity-type.a]
          ['name' (tape name.a)]
          ['timeActive' (numb (div time-active.a ~s1))]
          ['timeElapsed' (numb (div time-elapsed.a ~s1))]
          ['segments' a+(turn segments.a enjs-segment)]
          ['totalDistance' (enjs-distance total-distance.a)]
      ==
        :: $:  start-time=timestamp
    ::   end-time=timestamp
    ::   path=(lest tape)
    ::   =distance
    ::   elapsed-time=@dr
    ==
  ++  enjs-segment
    =,  enjs:format
    |=  seg=segment
    ^-  json
    ?-  -.seg
        %location  !!
        %polyline
      %-  pairs
      :~  ['startTime' (numb (unm:chrono:userlib start-time.seg))]
          ['endTime' (numb (unm:chrono:userlib end-time.seg))]
          ['timeElapsed' (numb (div time-elapsed.seg ~s1))]
          ['distance' (enjs-distance distance.seg)]
          ['path' a+(turn path.seg tape)]
    ==  ==
  ++  enjs-distance
    =,  enjs:format
    |=  d=distance
    ^-  json
    %-  pairs
    :~  ['val' (numb-rd val.d)]
        ['unit' s+unit.d]
    ==
  ++  numb-rd
    |=  a=@rd
    ^-  json
    :-  %n
    (rd-to-cord a)
  ++  rd-to-cord
    |=  a=@rd
    ^-  @ta
    =/  integer-part  (u-to-cord (floor a))
    =/  decimal-part  (floor-remainder a)
    ?:  (is-float-garbage decimal-part)  integer-part
    =/  full-number  (snoc (trip integer-part) '.')
    =/  new-num  (mul:rd decimal-part .~10)
    =/  depth=@ud  1
    |-  
    =/  new-num-decimal  (floor-remainder new-num)
    ?:  ?|((is-float-garbage new-num-decimal) (gth depth 12))
      (crip (snoc full-number (u-to-cord (round new-num))))
    %=  $
      full-number  (snoc full-number (u-to-cord (floor new-num)))
      new-num  (mul:rd new-num-decimal .~10)
      depth  +(depth)
    ==
  ++  is-float-garbage
    |=  a=@rd
    =/  tol  .~0.0000000000005
    (lte:rd (absolute (sub:rd .~1 a)) tol)
  ++  u-to-cord
    |=  a=@u
    (crip (u-to-tape a))

--
