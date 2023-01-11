/-  *trail

|%
+$  id  @
+$  timestamp  @
+$  map-data  [polyline=tape]
+$  activity-summary
  $:  id=@ud
      strava-activity-id=@ud
      name=tape
      total-distance-m=@rd
      time-moving-s=@ud
      time-elapsed-s=@ud
      =activity-type
      map-polyline=tape
  ==
+$  action
  $%  [%save-api-values client-id=@ud client-secret=@t refresh-token=@t]
  ==
--
