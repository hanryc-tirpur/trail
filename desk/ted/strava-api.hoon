/-  spider
/+  strandio, *oauth2-json
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=@t] arg)
;<  token-url=tape  bind:m  (scry:strandio tape /gx/strava/urls/access/noun)
;<  ref-res-json=json  bind:m  (post-url-json:strandio token-url)
:: (pure:m !>((dejs-refresh-response ref-res-json)))
:: ;<  ref-res=refresh-response  bind:m  (dejs-refresh-response ref-res-json)
;<  activities-url=tape  bind:m  (scry:strandio tape /gx/strava/urls/activities/noun)
;<  activities-response=json  bind:m  (fetch-json-with-token:strandio access-token:(dejs-refresh-response ref-res-json) activities-url)
(pure:m !>(activities-response))
