/-  *trail

|%
+$  id  @
+$  timestamp  @
+$  map-data  [polyline=tape]
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
+$  action
  $%  [%save-api-values client-id=@ud client-secret=@t refresh-token=@t]
  ==
--
