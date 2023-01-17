/-  *strava, oauth2
/+  default-agent, dbug, agentio, *text-processing
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0
  $:  %0
      is-connected=?
      con-args=connection-args
      auth=refresh-response:oauth2
      urls=api-urls
  ==
+$  card  card:agent:gall
--
=|  state-0
=*  state  -
=<
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def           ~(. (default-agent this %|) bowl)
    io            ~(. agentio bowl)
    strava-core   +>
    sc            ~(. strava-core bowl)
++  on-init
  ^-  (quip card _this)
  =/  base  "https://www.strava.com"
  =/  oauth-base  (weld base "/oauth/token")
  =.  urls.state  :*
      base
      (weld base "/api/v3/")
      oauth-base
      ~
    ==
  =.  state  state(is-connected %.n)
  `this
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  `this(state !<(versioned-state old-vase))
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?>  (team:title our.bowl src.bowl)
  ?.  ?=(%strava-action mark)  (on-poke:def mark vase)
  =/  act  !<(strava-action vase)
  ?-    -.act
      %save-connection-info
    =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
    =/  ta-now  `@ta`(scot %da now.bowl)
    =/  req-args  :*
        (get-initial-auth-url +.act)
        client-id.act
        client-secret.act
      ==
    =/  start-args  [~ `tid byk.bowl(r da+now.bowl) %strava-initial-authorization !>(req-args)]
    :_  this
    :~
      [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
      [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
    ==
    ::
      %sync-activity
    =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
    =/  ta-now  `@ta`(scot %da now.bowl)
    =/  req-args  :*
        (get-activity-summary-url 'wut')
        access-token.auth.state
      ==
    =/  start-args  [~ `tid byk.bowl(r da+now.bowl) %strava-sync-activity !>(req-args)]
    :_  this
    :~
      [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
      [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
    ==
  ==
  :: ~&  act
  :: =.  state  (poke-action act)
  :: `this
  ::
    ++  poke-action
      |=  act=strava-action
      ^-  _state
      ?-    -.act
          %save-connection-info
        state
          %sync-activity
        state
      ==
    ++  get-initial-auth-url
      |=  [client-id=@ud client-secret=@t strava-code=@t]
      =/  c-id  (skip "{<client-id>}" match-period)
      =/  ret-url  oauth-base.urls.state
      =.  ret-url  (weld ret-url "?client_id={c-id}")
      =.  ret-url  (weld ret-url "&client_secret={(trip client-secret)}")
      =.  ret-url  (weld ret-url "&code={(trip strava-code)}")
      =.  ret-url  (weld ret-url "&grant_type=authorization_code")
      ret-url
    ++  get-activity-summary-url
      |=  wut=@t
      =/  ret-url  (weld api-base.urls.state "athlete/activities")
      =.  ret-url  (weld ret-url "?per_page=10")
      ret-url
  --
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  (team:title our.bowl src.bowl)
  ?+    path  (on-peek:def path)
      [%x %urls *]
    ?+    t.t.path  (on-peek:def path)
      [%access ~]
      =/  base-url  "https://www.strava.com/oauth/token"
      =/  client-id  (skip "{<client-id.con-args.state>}" match-period)
      =/  url-1  (weld base-url "?client_id={client-id}")
      =/  url-2  (weld url-1 "&client_secret={(trip client-secret.con-args.state)}")
      =/  url-3  (weld url-2 "&grant_type=refresh_token")
      =/  url-4  (weld url-3 "&refresh_token={(trip refresh-token.auth.state)}")
    ``noun+!>(url-4)
      [%activities ~]
      =/  activities-url  "https://www.strava.com/api/v3/athlete/activities"
    ``noun+!>(activities-url)
    ==
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  |^
  ?+    -.wire  (on-agent:def wire sign)
      %thread
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign
        %-  (slog leaf+"Thread started successfully" ~)
        `this
      %-  (slog leaf+"Thread failed to start" u.p.sign)
      `this
    ::
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %thread-fail
        =/  err  !<  (pair term tang)  q.cage.sign
        %-  (slog leaf+"Thread failed: {(trip p.err)}" q.err)
        `this
          %thread-done
        %-  (slog leaf+"Result successful." ~)
        =/  res  !<(thread-response q.cage.sign)
        ?-    -.res
            %initial-authorization-response
          `this(state state(is-connected %.y, auth auth.res, con-args [client-id.res client-secret.res]))
            %sync-activity-response
          =/  cards  (turn activities.res to-card)
          :_  this
          cards
        ==
      ==
    ==
  ==
    ++  to-card
      |=  act=activity-summary
      ^-  card
      =/  hmm  :*
        %save-outside-activity
        :*
          %strava
          `@`id.act
          activity-type.act
          name.act
          [(div:rd total-distance-m.act .~1000) %km]
          `@`time-moving-s.act
          `@`time-elapsed-s.act
          map-polyline.act
          strava-activity-id.act
        ==  ==
      [%pass /strava/add/activity %agent [our.bowl %trail] %poke %trail-action !>(hmm)]
  --
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--

|_  hid=bowl:gall
++  sc
  |=  a=@ud
  a
::
++  poke-strava-action
  |=  act=strava-action
  ^-  _state
  ?-    -.act
      %save-connection-info
    state
      %sync-activity
    state
  ==
--
