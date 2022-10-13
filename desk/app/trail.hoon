/-  *trail
/+  default-agent, dbug, agentio
|%
+$  versioned-state
    $%  state-0
    ==
+$  state-0  [%0 =settings =activities]
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
        %start-activity
      =/  new-activity  :*
        id.act
        activity-type.act
        :~  :*
          id.act
          *(unit timestamp)
          *(list location)
          .0
          .0
        ==  ==
        .0
        .0
      ==
      =/  updated  (~(put by activities) id.act `activity`new-activity)
      state(activities updated)
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
