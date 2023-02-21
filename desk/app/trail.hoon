/-  *trail
/+  default-agent, dbug, agentio, geo, measurement
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0  [%0 =settings =activities]
+$  card  card:agent:gall
++  add-km  ~(add-distance measurement %km)
++  to-km  ~(calculate-distance geo %km)
++  to-miles  ~(calculate-distance geo %mile)
--
%-  agent:dbug
=|  versioned-state
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
  =/  loaded  !<(versioned-state old-vase)
  `this(state loaded)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?>  (team:title our.bowl src.bowl)
  ?.  ?=(%trail-action mark)  (on-poke:def mark vase)
  =/  act  !<(action vase)
  ~&  act
  =.  state  (poke-action act)
  `this
  ::
  ++  poke-action
    |=  act=action
    ^-  _state
    ?-    -.act
        %save-settings
      state(settings [unit.act])
        %sync-activity
      ?<  (~(has by activities.state) id.act)
      ?~  full-path.act  !!
      :: ~&  (to-segment i.full-path.act)
      =/  segments=(list segment)  (turn full-path.act to-segment)
      =/  to-add  :*
        %standard
        id.act
        activity-type.act
        segments
        (reel segments |=([s=segment sum=distance] (add-km sum distance.s)))
        (reel segments |=([s=segment sum=@] (add sum elapsed-time.s)))
      ==
      ~&  to-add
      state(activities (~(put by activities) id.act `activity`to-add))
      ::
        %save-outside-activity
      =/  strava  activity.act
      ?<  (~(has by activities.state) id.activity.act)
      ?~  map-polyline.strava  !!
      state(activities (~(put by activities.state) id.strava strava))
    ==
    ++  to-segment
      |=  readings=(lest location-reading)
      ^-  segment
      =/  prev  i.readings
      =/  remaining  t.readings
      =/  seg=segment  :*
        timestamp.prev
        timestamp.prev
        `(list location-reading)`~[prev]
        [.~0 %km]
        (mul 0 ~s1)
      ==
      |-
      ?~  remaining  seg
      =/  current  i.remaining
      =/  updated=segment  :*
        start-time.seg
        timestamp.current
        (snoc path.seg current)
        (add-km distance.seg (to-km location.prev location.current))
        (sub timestamp.current start-time.seg)
      ==
      %=  $
        seg  updated
        remaining  t.remaining
        prev  current
      ==
  --
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?>  (team:title our.bowl src.bowl)
  =/  now=@  (unm:chrono:userlib now.bowl)
  ?+    path  (on-peek:def path)
      [%x %activities *]
    ?+    t.t.path  (on-peek:def path)
        [%all ~]
      =/  matches=(list [@ activity])  ~(tap by activities)
      :^  ~  ~  %trail-update
      !>  ^-  update
      :: [%activities (turn matches |=(a=[@ activity] [id.a total-distance.a total-elapsed-time.a]))]
      [%activities (sort ~(val by activities) |=([a=activity b=activity] (gth id.a id.b)))]
    ::
        [%before @ @ ~]
      =/  before=@  (rash i.t.t.t.path dem)
      =/  max=@  (rash i.t.t.t.t.path dem)
      =/  matches=(list [@ activity])  ~(tap by activities)
      :^  ~  ~  %trail-update
      !>  ^-  update
      :: [%activities (turn matches |=(a=[@ activity] [id.a total-distance.a total-elapsed-time.a]))]
      [%activities (turn matches |=(a=[@ activity] +.a))]
    ::
        [%between @ @ ~]
      =/  start=@
        =+  (rash i.t.t.t.path dem)
        ?:(=(0 -) - (sub - 1))
      =/  end=@  (add 1 (rash i.t.t.t.t.path dem))
      =/  matches=(list [@ activity])  ~(tap by activities)
      :^  ~  ~  %trail-update
      !>  ^-  update
      :: [%activities (turn matches |=(a=[@ activity] [id.a total-distance.a total-elapsed-time.a]))]
      [%activities (turn matches |=(a=[@ activity] +.a))]
    ==
  ==
::
++  on-watch  on-watch:def

  :: |=  =path
  :: ^-  (quip card _this)
  :: ?>  =(src.bowl our.bowl)
  :: ?+  path  (on-watch:def path)
    :: `this
  :: ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
