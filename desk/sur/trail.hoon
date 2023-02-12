/-  *geo, *measurement

|%
+$  id  @da
+$  activity-type  ?(%bike %walk %run %ride %crossfit)
+$  settings  [unit=distance-unit]
+$  timestamp  @da
+$  location-reading
  $:  =timestamp
      =location
  ==
+$  strava-activity
  $:  %strava
      =id
      =activity-type
      name=tape
      total-distance=distance
      time-moving=@
      time-elapsed=@
      map-polyline=tape
      strava-activity-id=@ud
  == 
+$  standard-activity
  $:  %standard
      =id
      =activity-type
      segments=(list segment)
      total-distance=distance
      total-elapsed-time=@
  ==
+$  activity
  $%
    standard-activity
    strava-activity
  ==
+$  activity-summary
  $%  [%standard =id total-distance=distance total-elapsed-time=@]
      strava-activity
  ==
+$  segment
  $:  start-time=timestamp
      end-time=timestamp
      path=(list location-reading)
      =distance
      elapsed-time=@
  ==
+$  activities  (map id activity)
+$  action
  $%  [%sync-activity =id =activity-type full-path=(list (list location-reading))]
      [%save-settings unit=distance-unit]
      [%save-outside-activity activity=strava-activity]
  ==
+$  update
  $%  [%activities list=(list activity)]
      [%activity =activity]
  ==
--
