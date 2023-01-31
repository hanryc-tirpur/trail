import React, { useEffect } from 'react'
import { Outlet, useLoaderData, useOutletContext } from 'react-router-dom'
import Urbit from '@urbit/http-api'

import Grid from '@mui/material/Grid'
import Paper from '@mui/material/Paper'
import Typography from '@mui/material/Typography'

import Title from './components/Title'

import type { StravaConnectionStatusResponse } from './types/strava-types'

const api = new Urbit('', '', window.desk)
api.ship = window.ship


export async function loader(): Promise<StravaConnectionStatusResponse> {
    const res = await api.scry<StravaConnectionStatusResponse>({
      app: 'strava',
      path: '/status/strava-status'
    })
  console.log(res)
  return { ...res }
}

export function useConnectionStatus() {
  return useOutletContext<StravaConnectionStatusResponse>()
}

export default function Strava() {
  // @ts-ignore useLoaderData does not return typed data
  const connectionStatus: StravaConnectionStatusResponse = useLoaderData()

  return (
    <Grid container spacing={3}>
      {/* Chart */}
      <Grid item xs={12} md={4} lg={3}>
        <Paper
          sx={{
            p: 2,
            display: 'flex',
            flexDirection: 'column',
            height: 240,
          }}
        >
          <Title>Strava Connection</Title>
          <div>
            Status: 
            <Typography fontWeight={'bold'}>
              {connectionStatus.payload.isConnected ? ' Connected' : ' Not Connected'}
            </Typography>
          </div>
        </Paper>
      </Grid>
      {/* Recent Deposits */}
      <Grid item xs={12} md={8} lg={9}>
        <Paper
          sx={{
            p: 2,
            display: 'flex',
            flexDirection: 'column',
            height: 240,
          }}
        >
          <Outlet context={connectionStatus} />
        </Paper>
      </Grid>
    </Grid>
  )
}