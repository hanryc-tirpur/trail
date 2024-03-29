/-  *strava
/+  *text-processing

|_  now=@da
++  get-params
  |=  [status=api-sync-status act=strava-action]
  ^-  (list tape)
  |^
  ?-  -.act
    %sync-all  (params-for-sync-all +.act status)
    %complete-connection  !!
    %sync-activities  !!
    %save-client-info  !!
  ==
  ::
    ++  params-for-sync-all
    |=  [until=(unit @da) status=api-sync-status]
    ^-  (list tape)
    =/  until-s  (unt:chrono:userlib (fall until now))
    =/  params=(list tape)  ~
    ?-    -.status
        %syncing
      (snoc params "before={(to-tape-without-decimals until-s)}")
      ::
        %synced
      =.  params  (snoc params "before={(to-tape-without-decimals until-s)}")
        ?-  -.type.status
          %ranged  !!
          %fully
        (snoc params "after={(to-tape-without-decimals (unt:chrono:userlib until.type.status))}")
        ==
      ::
        %unsynced
      (snoc params "before={(to-tape-without-decimals until-s)}")
    ==
  --
++  get-next-status
  |=  [status=api-sync-status act=strava-action]
  ?+    -.act  !!
      %sync-all
    [%synced %fully (need until.act)]
  ==
++  get-populated-action
  |=  action=strava-action
  ?+    -.action  !!
      %sync-all
    [%sync-all `(fall until.action (unt:chrono:userlib now))]
  ==
--
