/-  spider, *strava
/+  strandio, *oauth2-json
=,  strand=strand:spider
^-  thread:spider
|=  args=vase
=/  m  (strand ,vase)
^-  form:m
=/  req  !<(refresh-auth-request args)
;<  ref-res-json=json  bind:m  (post-url-json:strandio url.req)
=/  ref-res  (dejs-refresh-response ref-res-json)
(pure:m !>([%refresh-authorization-response ref-res sync.req]))
