/-  *strava, oauth2
/+  default-agent, dbug, agentio, *text-processing, *strava-sync
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0
  $:  %0
      is-connected=?
      con-args=(unit connection-args)
      auth=refresh-response:oauth2
      urls=api-urls
      sync-status=api-sync-status
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
  =.  state  state(is-connected %.n, sync-status [%unsynced ''])
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
      %save-client-info
    `this(state state(con-args `+.act))
      %sync-all
    ?:  (gth (from-unix:chrono:userlib expires-at.auth.state) now.bowl)
      (request-activities access-token.auth.state act)
    (refresh-access-token act)
      %complete-connection
    (perform-initial-authorization +.act)
    ::
      %sync-activities
    :: TODO: Do not allow sync if app is not connected
    :: ?>  ()
    ?:  (gth (from-unix:chrono:userlib expires-at.auth.state) now.bowl)
      (request-activities access-token.auth.state act)
    (refresh-access-token act)
  ==
  ::
    :: ++  create-thread-cards
    ::   |=  [thread-name=@tas thread-data=vase]
    ::   ^-  (list card)
    ::   =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
    ::   =/  ta-now  `@ta`(scot %da now.bowl)
    ::   =/  start-args  [~ `tid byk.bowl(r da+now.bowl) thread-name thread-data]
    ::   :~
    ::     [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
    ::     [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
    ::   ==
    ++  perform-initial-authorization
      |=  strava-code=@t
      ^-  (quip card _this)
      =/  name  %strava-initial-authorization
      =/  c-info  (need con-args.state)
      =/  req-args  :*
          (get-initial-auth-url [client-id.c-info client-secret.c-info strava-code])
          client-id.c-info
          client-secret.c-info
        ==
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  start-args  [~ `tid byk.bowl(r da+now.bowl) name !>(req-args)]
      :_  this
      :~
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
      ==
      :: (create-thread-cards %strava-initial-authorization !>(req-args))
    ++  refresh-access-token
      |=  act=strava-action
      ^-  (quip card _this)
      =/  c-info  (need con-args.state)
      =/  req-args  :*
          (get-refresh-auth-url client-id.c-info client-secret.c-info refresh-token.auth.state)
          act
        ==
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  start-args  [~ `tid byk.bowl(r da+now.bowl) %strava-refresh-authorization !>(req-args)]
      :_  this
      :~
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
      ==
    ++  request-activities
      |=  [access-token=@t act=strava-action]
      ^-  (quip card _this)
      =/  normalized-action  (get-populated-action act)
      =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
      =/  ta-now  `@ta`(scot %da now.bowl)
      =/  req-args  :*
          (get-activity-summary-url sync-status.state normalized-action)
          access-token
          normalized-action
        ==
      =/  start-args  [~ `tid byk.bowl(r da+now.bowl) %strava-sync-activity !>(req-args)]
      :_  this(state state(sync-status [%syncing act]))
      :~
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %watch /thread-result/[tid]]
        [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
      ==
    ++  to-query
      |=  query-params=(list tape)
      ^-  tape
      ?~  query-params  ""
      %-  weld  :-  i.query-params
      (roll t.query-params |=([part=tape url=tape] (weld url "&{part}")))
    ++  get-activity-summary-url
      |=  [status=api-sync-status act=strava-action]
      =/  ret-url  (weld api-base.urls.state "athlete/activities")
      "{ret-url}?{(to-query (get-params status act))}"
    ++  get-initial-auth-url
      |=  [client-id=@ud client-secret=@t strava-code=@t]
      =/  c-id  (skip "{<client-id>}" match-period)
      =/  ret-url  oauth-base.urls.state
      =.  ret-url  (weld ret-url "?client_id={c-id}")
      =.  ret-url  (weld ret-url "&client_secret={(trip client-secret)}")
      =.  ret-url  (weld ret-url "&code={(trip strava-code)}")
      =.  ret-url  (weld ret-url "&grant_type=authorization_code")
      ret-url
    ++  get-refresh-auth-url
      |=  [client-id=@ud client-secret=@t refresh-token=@t]
      =/  c-id  (skip "{<client-id>}" match-period)
      =/  ret-url  oauth-base.urls.state
      =.  ret-url  (weld ret-url "?client_id={c-id}")
      =.  ret-url  (weld ret-url "&client_secret={(trip client-secret)}")
      =.  ret-url  (weld ret-url "&refresh_token={(trip refresh-token)}")
      =.  ret-url  (weld ret-url "&grant_type=refresh_token")
      ret-url
  --
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  (team:title our.bowl src.bowl)
  ?+    path  (on-peek:def path)
      [%x %status *]
    ?+    t.t.path  (on-peek:def path)
        [%strava-status ~]
      :^  ~  ~  %strava-status
      !>  ^-  strava-status
      [%strava-connection-status is-connected.state sync-status.state]
        [%strava-client-info ~]
      :^  ~  ~  %strava-status
      !>  ^-  strava-status
      [%strava-client-info con-args.state]
    :: ?+    t.t.path  (on-peek:def path)
    ::   [%access ~]
    ::   =/  base-url  "https://www.strava.com/oauth/token"
    ::   =/  client-id  (skip "{<client-id.con-args.state>}" match-period)
    ::   =/  url-1  (weld base-url "?client_id={client-id}")
    ::   =/  url-2  (weld url-1 "&client_secret={(trip client-secret.con-args.state)}")
    ::   =/  url-3  (weld url-2 "&grant_type=refresh_token")
    ::   =/  url-4  (weld url-3 "&refresh_token={(trip refresh-token.auth.state)}")
    :: ``noun+!>(url-4)
    ::   [%activities ~]
    ::   =/  activities-url  "https://www.strava.com/api/v3/athlete/activities"
    :: ``noun+!>(activities-url)
    :: ==
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
          `this(state state(is-connected %.y, auth auth.res, con-args `[client-id.res client-secret.res]))
        ::
            %refresh-authorization-response
          :_  this(state state(auth auth.res))
          [%pass /strava/self/sync %agent [our.bowl %strava] %poke %strava-action !>(action.res)]~
        ::
            %sync-activity-response
          ?-    -.sync-status.state  
              %unsynced  !!
              %synced    !!
              %syncing 
            =/  cards  (turn activities.res to-card)
              :: [cards this(state state(sync-status [%synced %ranged (need after.sync) (need before.sync)]))]
            :: =/  sync-poke  [%sync-activity sync(page +(page.sync))]
            :: ~&  [%sync-poke sync-poke]
            :_  this(state state(sync-status (get-next-status sync-status.state action.res)))
            :: (snoc cards [%pass /strava/self/sync %agent [our.bowl %strava] %poke %strava-action !>(sync-poke)])
            cards
          ==
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
      %sync-all  !!
      %save-client-info  !!
      %complete-connection
    state
      %sync-activities
    state
  ==
--
