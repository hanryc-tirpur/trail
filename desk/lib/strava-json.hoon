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
      (year (need (convert-to-date (sa (props 'start_date')))))
      (extract *activity-type:trail (crip (cass (sa (props 'sport_type')))))
      (sa (props 'name'))
      (ne (props 'distance'))
      (mul ~s1 (ni (props 'moving_time')))
      (mul ~s1 (ni (props 'elapsed_time')))
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
    [%complete-connection (ot ~[code+so])]
    [%save-client-info (ot ~[client-id+ni client-secret+so])]
    [%sync-all (ot ~[until+di:dejs-soft:format])]
  ==
++  enjs-status
  =,  enjs:format
  |=  status=strava-status
  ^-  json
  ?-    -.status
      %strava-connection-status
      %-  pairs
        :~  ['type' s+'stravaConnectionStatus']
          :-  'payload' 
          %-  pairs
          :~  ['isConnected' b+is-connected.status]
              ['syncStatus' (enjs-api-sync-status sync-status.status)]
      ==  ==
      %strava-client-info
      ?~  con-args.status
        %-  pairs
        :~  ['hasClientInfo' b+%.n]
            ['clientInfo' ~]
        ==
      =/  c-args  (need con-args.status)
      %-  pairs
        :~  ['hasClientInfo' b+%.y]
          :-  'clientInfo' 
          %-  pairs
          :~  ['client_id' (numb client-id.c-args)]
              ['client_secret' s+client-secret.c-args]
      ==  ==
  ==
++  enjs-update
  =,  enjs:format
  |=  update=strava-update
  ^-  json
  ?-    -.update
      %strava-connected
      %-  pairs
        :~  ['type' s+'stravaConnected']
          :-  'payload' 
          %-  pairs
          :~  ['isConnected' b+is-connected.update]
      ==  ==
  ==
++  enjs-api-sync-status
  =,  enjs:format
  |=  status=api-sync-status
  ^-  json
  ?-    -.status
      %synced
    =/  fully=synced-type  +.status
    ?-    -.fully
        %ranged  !!
        %fully
      %-  pairs
      :~  ['status' s+-.status]
          ['syncType' s+-.fully]
          ['until' (numb (unt:chrono:userlib until.fully))]
      ==
    ==
      %syncing
    %-  pairs
    :~  ['status' s+-.status]
        ['action' s+'hi']
    ==
    ::
      %unsynced
    %-  pairs
    :~  ['status' s+-.status]
        ['msg' s+m.status]
    ==
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
