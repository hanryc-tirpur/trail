/-  *geo, *measurement

|%
+$  id  @da
+$  activity-type  ?(%walk %run %ride)
+$  settings  [unit=distance-unit]
+$  timestamp  @da
+$  location-reading
  $:  =timestamp
      =location
  ==
+$  tracked-activity
  $:  =id
      =activity-type
      name=tape
      time-active=@dr
      time-elapsed=@dr
      total-distance=distance
      segments=(lest segment)
  == 
:: +$  tracked-external-activity
::   $:  =id
::       =activity-type
::       name=tape
::       source=@tas
::       time-active=@dr
::       time-elapsed=@dr
::       total-distance=distance
::       segments=(lest segment)
::       source-data=(unit (cask))
::   == 
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
      segments=(lest location-segment)
      total-distance=distance
      total-elapsed-time=@dr
  ==
+$  activity
  $%
    [%standard standard-activity]
    [%strava strava-activity]
    [%tracked tracked-activity]
  ==
+$  activity-summary
  $%  [%standard =id =activity-type total-distance=distance total-elapsed-time=@dr]
      [%strava strava-activity]
  ==
+$  segment
  $%  [%location location-segment]
      [%polyline polyline-segment]
  ==
+$  location-segment
  $:  start-time=timestamp
      end-time=timestamp
      path=(lest location-reading)
      =distance
      time-elapsed=@dr
  ==
+$  polyline-segment
  $:  start-time=timestamp
      end-time=timestamp
      path=tape
      =distance
      time-elapsed=@dr
  ==
+$  activities  (map id activity)
+$  action
  $%  
  :: [%sync-activity =id =activity-type full-path=(lest (lest location-reading))]
      [%save-settings unit=distance-unit]
      [%save-outside-activity activity=[%strava strava-activity]]
      [%save-activity =activity]
  ==
+$  update
  $%  [%activities list=(list activity)]
      [%activity =activity]
  ==
--
