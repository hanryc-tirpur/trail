/-  *trail, *measurement
|%
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
    |=  a=activity-summary
    ^-  json
    %-  pairs
    :~  ['id' (numb id.a)]
        ['totalElapsedTime' (numb total-elapsed-time.a)]
        :-  'totalDistance'
        %-  pairs
        :~  ['val' (numb 14)] :: val.total-distance.a)]
            ['unit' s+unit.total-distance.a]
    ==  ==
  ++  numb-rs
    |=  a=@rd
    ^-  json
    :-  %n
    ?:  =(0 a)  '0'
    %-  crip
    %-  flop
    |-  ^-  ^tape
    ~&  a
    ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])
  --
--
