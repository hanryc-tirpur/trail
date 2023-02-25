import React from 'react'
import Urbit from '@urbit/http-api'

import Button from '@mui/material/Button'
import Stack from '@mui/material/Stack'
import Typography from '@mui/material/Typography'

import SyncIcon from '@mui/icons-material/Sync'

import Title from './Title'

import type { StravaSynced } from '../types/strava-types'
import { dateAndTimeStringFromSeconds } from '../../../../util/date-formats'
import { useConnectionStatus } from '../Strava'

const api = new Urbit('', '', window.desk)
api.ship = window.ship


const syncAll = async () => {
  const pokeResult = await api.poke({
    app: 'strava',
    mark: 'strava-action',
    json: {
      'sync-all': {
        'until': Math.floor(Date.now()),
      }
    }
  })
}

function Synced({ until }: StravaSynced) {
  
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
        <Button variant="contained" endIcon={<SyncIcon />} onClick={syncAll}>
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

function Unsynced() {
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
      <Button variant="contained" endIcon={<SyncIcon />} onClick={syncAll}>
        Import Activities
      </Button>
      </div>
    </Stack>
  )
}

export default function ActivitySync() {
  const { syncStatus } = useConnectionStatus()

  return (
    <>
      <Title>Activity Sync</Title>
      { syncStatus.status === 'unsynced'
        ? (<Unsynced />)
        : syncStatus.status === 'synced'
          ? (<Synced {... syncStatus} />)
          : (<Syncing />)
      }
    </>
  )
}
