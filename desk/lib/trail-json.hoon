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
  ~&  upd
  |^
  ?-    -.upd
      %activities
    %-  pairs
    :~  ['activities' a+(turn list.upd entry)]
    ==
  ::
      %activity
    %-  pairs
    :~  ['time' s+'bye']
        ['logs' s+'hi']
    ==
  ==
  ++  entry
    |=  a=activity
    ^-  json
    ?-    -.a
        %standard
      %-  pairs
      :~  ['id' (numb id.a)]
          ['totalElapsedTime' (numb total-elapsed-time.a)]
          :-  'totalDistance'
          %-  pairs
          :~  ['val' (numb-rd val.total-distance.a)]
              ['unit' s+unit.total-distance.a]
      ==  ==
        %strava
      %-  pairs
      :~  ['id' (numb id.a)]
          ['activityType' s+activity-type.a]
          ['name' (tape name.a)]
          ['timeMoving' (numb time-moving.a)]
          ['timeElapsed' (numb time-elapsed.a)]
          ['mapPolyline' (tape map-polyline.a)]
          ['strava-activity-id' (numb strava-activity-id.a)]
          :-  'totalDistance'
          %-  pairs
          :~  ['val' (numb-rd val.total-distance.a)]
              ['unit' s+unit.total-distance.a]
      ==  ==
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
--
