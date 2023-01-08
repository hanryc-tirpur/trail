/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ arg=@t] arg)
=/  base-url  "https://pokeapi.co/api/v2/pokemon/"
=/  url  (weld base-url (trip arg))
;<  token-url=tape  bind:m  (scry:strandio tape /gx/strava/urls/access/noun)
;<  pokeinfo=json  bind:m  (fetch-json:strandio url)
::  Modified to return the character name as well as the character data.
(pure:m !>([token-url]))
