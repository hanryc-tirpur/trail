import React, { useEffect } from 'react'
import { LoaderFunctionArgs, Outlet, matchPath, redirect, useLoaderData, useOutletContext } from 'react-router-dom'
import Urbit from '@urbit/http-api'

import Grid from '@mui/material/Grid'
import Paper from '@mui/material/Paper'
import Typography from '@mui/material/Typography'

import Title from './components/Title'

import type { StravaConnectionStatus, StravaConnectionStatusResponse,  } from './types/strava-types'

const api = new Urbit('', '', window.desk)
api.ship = window.ship

// @ts-ignore useLoaderData does not return typed data
window.matchPath = matchPath

export async function loader({ request }: LoaderFunctionArgs): Promise<Response | StravaConnectionStatus> {
  const { payload } = await api.scry<StravaConnectionStatusResponse>({
    app: 'strava',
    path: '/status/strava-status'
  })
  
  if(payload.isConnected && !matchPath('/apps/trail/integrations/strava', new URL(request.url).pathname)) {
    return redirect('/apps/trail/integrations/strava')
  } else if(!payload.isConnected && !matchPath('/apps/trail/integrations/strava/connect', new URL(request.url).pathname)) {
    return redirect('connect')
  }

  return {... payload}
}

export function useConnectionStatus() {
  return useOutletContext<StravaConnectionStatus>()
}

export default function Strava() {
  // @ts-ignore useLoaderData does not return typed data
  const connectionStatus: StravaConnectionStatus = useLoaderData()

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
              {connectionStatus.isConnected ? ' Connected' : ' Not Connected'}
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