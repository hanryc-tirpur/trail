/-  *trail, oauth2

|%
+$  id  @
+$  timestamp  @
+$  map-data  [polyline=tape]
+$  connection-args  $:
      client-id=@ud
      client-secret=@t
    ==
+$  sync-params  [after=(unit @ud) before=(unit @ud) page=@ud]
+$  synced-type
  $%  [%fully until=@ud]
      [%ranged after=@ud before=@ud]
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
  $:  id=@ud
      =activity-type
      name=tape
      total-distance-m=@rd
      time-moving-s=@ud
      time-elapsed-s=@ud
      map-polyline=tape
      strava-activity-id=@ud
  ==
+$  initial-auth-request  [url=tape con-args=connection-args]
+$  refresh-auth-request  [url=tape action=strava-action]
+$  sync-activity-request  [url=tape access-token=@t action=strava-action]
+$  api-query-args
  $:
    after=(unit @ud)
    before=(unit @ud)
    page=@ud
  ==
+$  strava-action
  $%  [%save-connection-info client-id=@ud client-secret=@t strava-code=@t]
      [%sync-activities sync=sync-params]
      [%sync-all until=(unit @ud)]
  ==
+$  thread-response
  $%  [%initial-authorization-response auth=refresh-response:oauth2 client-id=@ud client-secret=@t]
      [%refresh-authorization-response auth=refresh-response:oauth2 action=strava-action]
      [%sync-activity-response activities=(list activity-summary) action=strava-action]
  ==
--
