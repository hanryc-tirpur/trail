import React, { useState } from 'react'
import Urbit from '@urbit/http-api'

import Button from '@mui/material/Button'
import Stack from '@mui/material/Stack'
import Typography from '@mui/material/Typography'

import SyncIcon from '@mui/icons-material/Sync'

import Title from './Title'

import type { StravaSynced, StravaUnsynced } from '../types/strava-types'
import { dateAndTimeStringFromSeconds } from '../../../../util/date-formats'
import { useConnectionStatus } from '../Strava'

const api = new Urbit('', '', window.desk)
api.ship = window.ship

function Synced({ until, isSyncing, syncAll }: StravaSynced & { isSyncing: boolean, syncAll: any }) {
  
  return (
    <Stack
      direction="column"
      height="100%"
      spacing={3}
    >
      <div style={{ flex: 1 }}>
        <Typography> 
          You are connected to Strava, and have already imported Activities.
        </Typography>

        <Typography display={'inline-block'}> 
          Latest import:
        </Typography>

        <Typography fontWeight={'bold'} display={'inline-block'}> 
          {` ${dateAndTimeStringFromSeconds(until)}`}
        </Typography>
      </div>

      <div>
        <Button variant="contained" endIcon={<SyncIcon />} onClick={syncAll} disabled={isSyncing}>
          Import Latest
        </Button>
      </div>
    </Stack>
  )
}

function Syncing() {
  return (
    <div>Syncing</div>
  )
}

function Unsynced({ isSyncing, syncAll }: StravaUnsynced & { isSyncing: boolean, syncAll: any }) {
  return (
    <Stack
      direction="column"
      height="100%"
      spacing={3}
    >
      <div style={{ flex: 1 }}>
        <Typography> 
          You have connected to Strava, but you have not yet imported any Activies.
        </Typography>
      </div>

      <div>
      <Button variant="contained" endIcon={<SyncIcon />} onClick={syncAll} disabled={isSyncing}>
        Import Activities
      </Button>
      </div>
    </Stack>
  )
}

export default function ActivitySync() {
  const { syncStatus: ss } = useConnectionStatus()
  const [ syncStatus, setSyncStatus ] = useState(ss)
  const [ isSyncing, setIsSyncing ] = useState(false)


  const syncAll = async () => {
    setIsSyncing(true)

    api.subscribe({
      app: 'strava',
      path: '/updates',
      event: evt => {
        if(evt.type !== 'stravaSynced') return

        setIsSyncing(false)
        setSyncStatus({
          status: 'synced',
          until: evt.payload.until,
        })
      },
      err: () => console.log('Could not subscribe to strava app updates'),
    })
    api.poke({
      app: 'strava',
      mark: 'strava-action',
      json: {
        'sync-all': {
          'until': Math.floor(Date.now()),
        }
      }
    })
  }

  const args = { isSyncing, syncAll, }
  return (
    <>
      <Title>Activity Sync</Title>
      { syncStatus.status === 'unsynced'
        ? (<Unsynced {... syncStatus} {... args} />)
        : syncStatus.status === 'synced'
          ? (<Synced {... syncStatus} {... args} />)
          : (<Syncing />)
      }
    </>
  )
}
