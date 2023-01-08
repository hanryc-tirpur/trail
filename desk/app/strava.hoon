/-  *strava
/+  default-agent, dbug, agentio, *text-processing
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0  [%0 client-id=@ud client-secret=@t refresh-token=@t]
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    io    ~(. agentio bowl)
++  on-init  on-init:def
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
  =/  act  !<(action vase)
  ~&  act
  =.  state  (poke-action act)
  `this
  ::
  ++  poke-action
    |=  act=action
    ^-  _state
    ?-    -.act
        %save-api-values
      state(client-id client-id.act, client-secret client-secret.act, refresh-token refresh-token.act)
    ==
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
      =/  client-id  (skip "{<client-id.state>}" match-period)
      =/  url-1  (weld base-url "?client_id={client-id}")
      =/  url-2  (weld url-1 "&client_secret={(trip client-secret.state)}")
      =/  url-3  (weld url-2 "&grant_type=refresh_token")
      =/  url-4  (weld url-3 "&refresh_token={(trip refresh-token.state)}")
    ``noun+!>(url-4)
      [%activities ~]
      =/  activities-url  "https://www.strava.com/api/v3/athlete/activities"
    ``noun+!>(activities-url)
    ==
  ==
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
