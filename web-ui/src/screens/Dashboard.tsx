import React, { useEffect, useState } from 'react'
import { useLoaderData } from 'react-router-dom'
import Urbit from '@urbit/http-api'
import { ChargeUpdateInitial, Scry } from '@urbit/api'

import Grid from '@mui/material/Grid'

import ActivitySummaryDisplay, { DistanceUnit } from '../components/ActivitySummary'

import type { ActivitySummary } from '../components/ActivitySummary'

const api = new Urbit('', '', window.desk)
api.ship = window.ship


export declare type ChargeUpdate = ChargeUpdateInitial | ChargeUpdateAdd | ChargeUpdateDel;
export interface ActivitySummariesInitial {
  activities: ActivitySummary[];
}
export interface ChargeUpdateAdd {
    'add-charge': {
        desk: string;
        charge: ActivitySummary;
    };
}
export interface ChargeUpdateDel {
    'del-charge': string;
}


export async function loader(): Promise<ActivitySummariesInitial> {
  const scryAllActivities: Scry = { app: 'trail', path: '/activities/all', }
  let summariesResponse = (await api.scry<ActivitySummariesInitial>(scryAllActivities));
  summariesResponse = summariesResponse.activities?.length ? summariesResponse : {
    activities: [{
      name: 'Dummy Workout',
      id: '23456',
      totalElapsedTime: 787,
      timeMoving: 787,
      mapPolyline: 'e|e_GjkexOn@Jj@RP^LrMBfA@nAEZAXAlE@PDFJB\\?r@ChIEpADzDEH@HDd@^LDxA@v@ZXE\\QNEjG@RJBN@RAhDIjBqAvMqDja@w@zHyCv_@oA`NoAtKQrAMf@uDf\\a@|Cy@nFoAvHaBdJM^IHM@iG@yHE}IMgHAaTYy@G]Gw@Ws@c@q@o@UYU]cBaDKe@mC}EuAuByA_B_Au@QQiCwAm@Q{@S_C[wAEaG@}bA]iGBMBIFGJEPAzF?NCJIFIBMA]MgA_AWK}@CwAAOE_@[UBGGAQDa@HAJDDt@Qv@SRE@C?CKHDHcB@FAMAB@OFIDB@GXL?HIX@HJRTPLFN@zAAl@F\\Rj@f@^RZHd@CFGDMDg@?eAIyB',
      totalDistance: {
        val: 8.2110,
        unit: DistanceUnit.KM,
      }
    }]
  }
  console.log('All activities', summariesResponse)
  return { ...summariesResponse }
}

export default function Dashboard() {
  // @ts-ignore ts is kinda annoying
  const { activities } = useLoaderData()

  console.log('Dashboard, baby!')

  return (
    <Grid container spacing={3}>
    <ul>
    {activities && activities.map((s: ActivitySummary) => {
      return (
        <li key={s.id} className="activity-summary-container">
          <ActivitySummaryDisplay {... s} />
        </li>
      )
    })}
    </ul>
    </Grid>
  )
}
