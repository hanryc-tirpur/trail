/-  *geo, *measurement

|%
+$  id  @
+$  activity-type  ?(%bike %walk %run)
+$  settings  [unit=distance-unit]
+$  timestamp  @
+$  location-reading
  $:  =timestamp
      =location
  ==
+$  activity
  $:  =id
      =activity-type
      segments=(list segment)
      total-distance=@rd
      total-elapsed-time=@rd
  ==
+$  activity-summary  [=id total-distance=@rd total-elapsed-time=@rd]
+$  segment
  $:  start-time=timestamp
      end-time=timestamp
      path=(list location-reading)
      =distance
      elapsed-time=@
  ==
+$  activities  ((mop id activity) gth)
+$  action
  $%  [%sync-activity =id =activity-type full-path=(list (list location-reading))]
      :: [%stop-activity =id path=(list location-reading)]
      :: [%end-activity =id path=(list location-reading)]
      :: [%delete-activity =id]
      [%save-settings unit=distance-unit]
      :: [%save-locations =id path=(list location-reading)]
  ==
+$  update
  $%  [%activities list=(list activity-summary)]
      [%activity =activity]
  ==
--
