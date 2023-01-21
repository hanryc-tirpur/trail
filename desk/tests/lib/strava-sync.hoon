/+  *test, strava-sync
|%
++  test-get-params-for-sync-all-when-unsynced
  =/  now=@da  ~2023.1.12..15.57.23..1cb6       :: 1.673.539.043 s
  =/  ss  ~(. strava-sync now)
  ;:  weld
  %+  expect-eq
    !>  ~["before=1673539043"]
    !>  (get-params:ss [%unsynced ''] [%sync-all ~])
  ==
++  test-get-params-for-sync-all-when-fully-synced
  =/  now=@da  ~2023.1.20..15.57.23..1cb6       :: 1.674.230.243 s
  =/  ss  ~(. strava-sync now)
  ;:  weld
  %+  expect-eq
    !>  ~["before=1674230243" "after=123456"]
    !>  (get-params:ss [%synced %fully 123.456] [%sync-all ~])
  ==
++  test-get-next-status-when-sync-all
  =/  action  [%sync-all `123.456]
  =/  ss  ~(. strava-sync now)
  ;:  weld
  %+  expect-eq
    !>  ~["before=1674230243" "after=123456"]
    !>  (get-next-status:ss [%syncing action] action)
  ==
--
