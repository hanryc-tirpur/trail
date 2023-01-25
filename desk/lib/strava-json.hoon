/-  *strava, trail
/+  *text-processing
|%
++  dejs-activities
  =,  dejs:format
  |=  jon=json
  ^-  (list activity-summary)
  ((ar dejs-activity) jon)
++  dejs-activity
  =,  dejs:format
  |=  jon=json
  ^-  activity-summary
  =/  props  ~(got by ((om |=(j=json j)) jon))
  =/  map-props  ~(got by ((om |=(j=json j)) (props 'map')))
  :*  
      (unm:chrono:userlib (year (need (convert-to-date (sa (props 'start_date'))))))
      (extract *activity-type:trail (crip (cass (sa (props 'sport_type')))))
      (sa (props 'name'))
      (ne (props 'distance'))
      (ni (props 'moving_time'))
      (ni (props 'elapsed_time'))
      (sa (map-props 'summary_polyline'))
      (ni (props 'id'))
  ==
++  dejs-activity-2
  =,  dejs:format
  %-  ot
  :~  
    'elapsed_time'^ni
  ==
++  dejs-action
  =,  dejs:format
  |=  jon=json
  ^-  strava-action
  %.  jon
  %-  of
  :~  
    [%complete-connection (ot ~[client-id+ni client-secret+so code+so])]
  ==
++  extract
  |*  [a=* b=@t]
  !<(_a [-:!>(a) b])
++  sd
  |=  jon=json 
  ^-  @da
  ?>  ?=(%s -.jon)
  `@da`(rash p.jon dem:ag)
--
