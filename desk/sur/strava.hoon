/-  *trail, oauth2

|%
+$  id  @da
+$  timestamp  @
+$  map-data  [polyline=tape]
+$  connection-args  $:
      client-id=@ud
      client-secret=@t
    ==
+$  sync-params  [after=(unit @da) before=(unit @da) page=@ud]
+$  synced-type
  $%  [%fully until=@da]
      [%ranged after=@da before=@da]
  ==
+$  api-sync-status
  $%  [%unsynced m=@t] :: TODO: Make m(sg) a unit
      [%syncing action=strava-action]
      [%synced type=synced-type]
  ==
+$  api-urls  $:
      base=tape
      api-base=tape
      oauth-base=tape
      token-refresh=tape
    ==
+$  activity-summary
  $:  id=@da
      =activity-type
      name=tape
      total-distance-m=@rd
      time-moving-s=@dr
      time-elapsed-s=@dr
      map-polyline=tape
      strava-activity-id=@ud
  ==
+$  strava-connection-status
  $:  is-connected=?
      sync-status=api-sync-status
  ==
+$  strava-status
  $%  [%strava-connection-status strava-connection-status]
      [%strava-client-info con-args=(unit connection-args)]
  ==
+$  initial-auth-request  [url=tape con-args=connection-args]
+$  refresh-auth-request  [url=tape action=strava-action]
+$  sync-activity-request  [url=tape access-token=@t action=strava-action]
+$  api-query-args
  $:
    after=(unit @da)
    before=(unit @da)
    page=@ud
  ==
+$  strava-action
  $%  [%save-client-info client-id=@ud client-secret=@t]
      [%complete-connection strava-code=@t]
      [%sync-activities sync=sync-params]
      [%sync-all until=(unit @da)]
  ==
+$  strava-update
  $%  [%strava-connected is-connected=?]
      [%strava-synced until=@da]
  ==
+$  thread-response
  $%  [%initial-authorization-response auth=refresh-response:oauth2 client-id=@ud client-secret=@t]
      [%refresh-authorization-response auth=refresh-response:oauth2 action=strava-action]
      [%sync-activity-response activities=(list activity-summary) action=strava-action]
  ==
--
