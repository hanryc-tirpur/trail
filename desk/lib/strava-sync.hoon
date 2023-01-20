/-  *strava
/+  *text-processing

|_  now=@da
++  get-params
  |=  [status=api-sync-status act=strava-action]
  ^-  (list tape)
  |^
  ?-  -.act
    %sync-all  (params-for-sync-all +.act status)
    %save-connection-info  !!
    %sync-activities  !!
  ==
  ::
    ++  params-for-sync-all
    |=  [until=(unit @ud) status=api-sync-status]
    ^-  (list tape)
    =/  until-s  (fall until (unt:chrono:userlib now))
    =/  params=(list tape)  ~
    ?-    -.status
        %syncing  !!
      ::
        %synced
      =.  params  (snoc params "before={(to-tape-without-decimals until-s)}")
        ?-  -.type.status
          %ranged  !!
          %fully
        (snoc params "after={(to-tape-without-decimals from.type.status)}")
        ==
      ::
        %unsynced
      (snoc params "before={(to-tape-without-decimals until-s)}")
    ==
  --
--
