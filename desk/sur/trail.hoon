/-  *geo, *measurement

|%
+$  id  @da
+$  activity-type  ?(%bike %walk %run %ride %crossfit)
+$  settings  [unit=distance-unit]
+$  timestamp  @da
+$  booyah  @da
+$  location-reading
  $:  =timestamp
      =location
  ==
+$  strava-activity
  $:  =id
      =activity-type
      name=tape
      total-distance=distance
      time-moving=@dr
      time-elapsed=@dr
      map-polyline=tape
      strava-activity-id=@ud
  == 
+$  standard-activity
  $:  =id
      =activity-type
      segments=(list segment)
      total-distance=distance
      total-elapsed-time=@dr
  ==
+$  activity
  $%
    [%standard standard-activity]
    [%strava strava-activity]
  ==
+$  activity-summary
  $%  [%standard =id total-distance=distance total-elapsed-time=@dr]
      [%strava strava-activity]
  ==
+$  segment
  $:  start-time=timestamp
      end-time=timestamp
      path=(list location-reading)
      =distance
      elapsed-time=@dr
  ==
+$  activities  (map id activity)
+$  action
  $%  [%sync-activity =id =activity-type full-path=(list (list location-reading))]
      [%save-settings unit=distance-unit]
      [%save-outside-activity activity=[%strava strava-activity]]
  ==
+$  update
  $%  [%activities list=(list activity)]
      [%activity =activity]
  ==
--
