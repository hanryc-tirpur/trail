/-  spider, *strava
/+  strandio, *oauth2-json
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<(initial-auth-request args)
;<  ref-res-json=json  bind:m  (post-url-json:strandio url)
=/  ref-res  (dejs-refresh-response ref-res-json)
(pure:m !>([%initial-authorization-response ref-res client-id.con-args client-secret.con-args]))
