/-  *oauth2
|%
++  dejs-refresh-response
  =,  dejs:format
  |=  jon=json
  ^-  refresh-response
  =/  props  ~(got by ((om |=(j=json j)) jon))
  :*  (so (props 'token_type'))
      (ni (props 'expires_at'))
      (so (props 'access_token'))
      (ni (props 'expires_in'))
      (so (props 'refresh_token'))
  ==
--
