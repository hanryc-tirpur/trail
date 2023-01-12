/-  *trail

|=  a=activity
^-  activities
=/  acts=activities  *activities
=/  acc  ((on id activity) gth)
?-    -.a
    %strava
  ~&  [%strava (has:acc acts id.a)]
  (put:acc acts id.a a)
    %standard
  ~&  [%standard (has:acc acts id.a)]
  (put:acc acts id.a a)
