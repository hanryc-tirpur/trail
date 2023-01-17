/-  *trail, oauth2

|%
+$  id  @
+$  timestamp  @
+$  map-data  [polyline=tape]
+$  connection-args  $:
      client-id=@ud
      client-secret=@t
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
+$  sync-activity-request  [url=tape access-token=@t]
+$  strava-action
  $%  [%save-connection-info client-id=@ud client-secret=@t strava-code=@t]
      [%sync-activity msg=@t]
  ==
+$  thread-response
  $%  [%initial-authorization-response auth=refresh-response:oauth2 client-id=@ud client-secret=@t]
      [%sync-activity-response activities=(list activity-summary)]
  ==
--
