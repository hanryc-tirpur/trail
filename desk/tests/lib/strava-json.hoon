/+  *test, *strava-json, *text-processing
|%
++  test-activity-summary-to-json
  =/  strava-activity-json  %-  need  %-  de-json:html
  '''
  {
    "resource_state": 2,
    "athlete": {
      "id": 111626791,
      "resource_state": 1
    },
    "name": "Afternoon Ride",
    "distance": 8211.0,
    "moving_time": 787,
    "elapsed_time": 2867,
    "total_elevation_gain": 39.6,
    "type": "Ride",
    "sport_type": "Ride",
    "workout_type": 0,
    "id": 8260738902,
    "start_date": "2022-12-17T22:28:43Z",
    "start_date_local": "2022-12-17T16:28:43Z",
    "timezone": "(GMT-06:00) America/Chicago",
    "utc_offset": -21600.0,
    "location_city": null,
    "location_state": null,
    "location_country": "United States",
    "achievement_count": 0,
    "kudos_count": 0,
    "comment_count": 0,
    "athlete_count": 1,
    "photo_count": 0,
    "map": {
      "id": "a8260738902",
      "summary_polyline": "e|e_GjkexOn@Jj@RP^LrMBfA@nAEZAXAlE@PDFJB\\?r@ChIEpADzDEH@HDd@^LDxA@v@ZXE\\QNEjG@RJBN@RAhDIjBqAvMqDja@w@zHyCv_@oA`NoAtKQrAMf@uDf\\a@|Cy@nFoAvHaBdJM^IHM@iG@yHE}IMgHAaTYy@G]Gw@Ws@c@q@o@UYU]cBaDKe@mC}EuAuByA_B_Au@QQiCwAm@Q{@S_C[wAEaG@}bA]iGBMBIFGJEPAzF?NCJIFIBMA]MgA_AWK}@CwAAOE_@[UBGGAQDa@HAJDDt@Qv@SRE@C?CKHDHcB@FAMAB@OFIDB@GXL?HIX@HJRTPLFN@zAAl@F\\Rj@f@^RZHd@CFGDMDg@?eAIyB",
      "resource_state": 2
    },
    "trainer": false,
    "commute": false,
    "manual": false,
    "private": true,
    "visibility": "only_me",
    "flagged": false,
    "gear_id": null,
    "start_latlng": [
      41.97843303903937,
      -88.01477087661624
    ],
    "end_latlng": [
      42.00658952817321,
      -88.04630946367979
    ],
    "average_speed": 10.433,
    "max_speed": 19.082,
    "has_heartrate": false,
    "heartrate_opt_out": false,
    "display_hide_heartrate_option": false,
    "elev_high": 229.0,
    "elev_low": 210.3,
    "upload_id": 8853699403,
    "upload_id_str": "8853699403",
    "external_id": "EA8EADBC-F71B-4B85-8173-BA440329BF08-activity.fit",
    "from_accepted_tag": false,
    "pr_count": 0,
    "total_photo_count": 0,
    "has_kudoed": false
  }
  '''
  ~&  (dejs-activity-2 strava-activity-json)
  ;:  weld
  %+  expect-eq
    !>  :*
          1.671.316.123.000
          %ride
          "Afternoon Ride"
          .~8211.0
          787
          2.867
          (trip 'e|e_GjkexOn@Jj@RP^LrMBfA@nAEZAXAlE@PDFJB\\?r@ChIEpADzDEH@HDd@^LDxA@v@ZXE\\QNEjG@RJBN@RAhDIjBqAvMqDja@w@zHyCv_@oA`NoAtKQrAMf@uDf\\a@|Cy@nFoAvHaBdJM^IHM@iG@yHE}IMgHAaTYy@G]Gw@Ws@c@q@o@UYU]cBaDKe@mC}EuAuByA_B_Au@QQiCwAm@Q{@S_C[wAEaG@}bA]iGBMBIFGJEPAzF?NCJIFIBMA]MgA_AWK}@CwAAOE_@[UBGGAQDa@HAJDDt@Qv@SRE@C?CKHDHcB@FAMAB@OFIDB@GXL?HIX@HJRTPLFN@zAAl@F\\Rj@f@^RZHd@CFGDMDg@?eAIyB')
          8.260.738.902
        ==
    !>  (dejs-activity strava-activity-json)
  ==
++  test-dejs-complete-connection
  =/  strava-action-json  %-  need  %-  de-json:html
  '''
  {
    "complete-connection": {
      "client-id": 8675309,
      "client-secret": "f0dc76c22139ab22618ddfb498be1283254612b1",
      "code": "0x7348dedce172a44a47921f3ca8e3b2607e1177ee29e8c4fdf045638bb2097af6"
    }
  }
  '''
  ;:  weld
  %+  expect-eq
    !>  :*
          %complete-connection
          8.675.309
          'f0dc76c22139ab22618ddfb498be1283254612b1'
          '0x7348dedce172a44a47921f3ca8e3b2607e1177ee29e8c4fdf045638bb2097af6'
        ==
    !>  (dejs-action strava-action-json)
  ==
++  remove-whitespace
  |=  c=@tD
  =/  newline  '\0a'
  ?:  =(c ' ')  %.y
    ?:  =(c newline)  %.y
  %.n
++  test-enjs-status-strava-connection-status-unsynced-to-json
  =/  expected-json
  '''
  {
    "type": "stravaConnectionStatus",
    "payload": {
      "syncStatus": {
        "status": "synced",
        "syncType": "fully",
        "until": 987654
      },
      "isConnected": true
    }
  }
  '''
  ;:  weld
  %+  expect-eq
    !>  (skip (trip expected-json) remove-whitespace)
    !>  (en-json:html (enjs-status [%strava-connection-status %.y %synced %fully 987.654]))
  ==
  ::
  ++  test-enjs-status-strava-connection-status-fully-synced-to-json
  =/  expected-json
  '''
  {
    "type": "stravaConnectionStatus",
    "payload": {
      "syncStatus": {
        "status": "unsynced",
        "msg": ""
      },
      "isConnected": true
    }
  }
  '''
  ;:  weld
  %+  expect-eq
    !>  (skip (trip expected-json) remove-whitespace)
    !>  (en-json:html (enjs-status [%strava-connection-status %.y %unsynced '']))
  ==
--
