/-  spider
/+  strandio, *strava-json, *oauth2-json
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<(sync-activity-request arg)
~&  [access-token url]
;<  activities-response=json  bind:m  (fetch-json-with-token:strandio access-token url)
(pure:m !>([%sync-activity-response (dejs-activities activities-response)]))
