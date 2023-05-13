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
  const summariesResponse = (await api.scry<ActivitySummariesInitial>(scryAllActivities))
  console.log(summariesResponse)
  return { ...summariesResponse }
}

function HasActivities({ activities }: { activities: ActivitySummary[]}) {
  return (
    <ul>
    {activities.map((s: ActivitySummary) => {
      return (
        <li key={s.id} className="activity-summary-container">
          <ActivitySummaryDisplay {... s} />
        </li>
      )
    })}
    </ul>
  )
}

export default function Dashboard() {
  // @ts-ignore ts is kinda annoying
  const { activities } = useLoaderData()

  console.log(activities)

  return (
    <Grid container spacing={3}>
      { activities && activities.length
        ? <HasActivities activities={activities} />
        : <div>
          You do not currently have any activities.
          
          For now, you can either use the Strava integration or manual pokes in dojo to
          retrieve them.
        </div>
      }
    </Grid>
  )
}
