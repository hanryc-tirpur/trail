/-  *trail
/+  default-agent, dbug, agentio, geo, measurement
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0  [%0 =settings =activities]
+$  card  card:agent:gall
++  activities-accessor  ((on id activity) gth)
++  add-km  ~(add-distance measurement %km)
++  to-km  ~(calculate-distance geo %km)
++  to-miles  ~(calculate-distance geo %mile)
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
      ?<  (has:activities-accessor activities id.act)
      ?~  full-path.act  !!
      ~&  (to-segment i.full-path.act)
      =/  segments=(list segment)  (turn full-path.act to-segment)
      =/  to-add  :*
        id.act
        activity-type.act
        segments
        (reel segments |=([s=segment sum=distance] (add-km sum distance.s)))
        (reel segments |=([s=segment sum=@] (add sum elapsed-time.s)))
      ==
      ~&  to-add
      :: state(activities (put:activities-accessor activities id.act `activity`to-add))
      state
    ==
    ++  to-segment
      |=  readings=(list location-reading)
      ^-  segment
      ?~  readings  !!
      =/  prev  i.readings
      =/  remaining  t.readings
      =/  seg=segment  :*
        timestamp.prev
        timestamp.prev
        `(list location-reading)`~[prev]
        [.~0 %km]
        0
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
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
