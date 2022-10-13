|%
+$  id  @
+$  timestamp  @
+$  activity-type  ?(%bike %walk %run)
+$  distance-unit  ?(%mile %km)
+$  settings  [unit=distance-unit]
+$  location
  $:  =timestamp
      lattitude=@rs
      longitude=@rs
      altitude=@rs
      heading=@rs
  ==
+$  activity
  $:  =id
      =activity-type
      segments=(list segment)
      total-distance=@rs
      total-elapsed-time=@rs
  ==
+$  activity-summary  [=id total-distance=@rs total-elapsed-time=@rs]
+$  segment
  $:  start-time=timestamp
      end-time=(unit timestamp)
      path=(list location)
      distance=@rs
      elapsed-time=@rs
  ==
+$  activities  ((mop id activity) gth)
+$  action
  $%  [%start-activity =id =activity-type]
      :: [%stop-activity =id path=(list location)]
      :: [%end-activity =id path=(list location)]
      :: [%delete-activity =id]
      [%save-settings unit=distance-unit]
      :: [%save-locations =id path=(list location)]
  ==
+$  update
  $%  [%activities list=(list activity-summary)]
      [%activity =activity]
  ==
--
