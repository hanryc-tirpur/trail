import React from 'react'
import Urbit from '@urbit/http-api'

import Button from '@mui/material/Button'
import Typography from '@mui/material/Typography'

import SyncIcon from '@mui/icons-material/Sync'

import Title from './Title'

import type { StravaConnectionStatus } from '../types/strava-types'

const api = new Urbit('', '', window.desk)
api.ship = window.ship

function Synced() {
  return (
    <div>Synced</div>
  )
}

function Syncing() {
  return (
    <div>Syncing</div>
  )
}

function Unsynced() {
  const syncAll = async () => {
    const pokeResult = await api.poke({
      app: 'strava',
      mark: 'strava-action',
      json: {
        'sync-all': {
          'until': Math.floor(Date.now() / 1000),
        }
      }
    })
  }

  return (
    <div>
      <Typography fontWeight={'bold'}>
        You have connected to Strava, but you have not yet imported any Activies.
      </Typography>

      <Button variant="contained" endIcon={<SyncIcon />} onClick={syncAll}>
        Import Activities
      </Button>
    </div>
  )
}

export default function ActivitySync({ isConnected, syncStatus }: StravaConnectionStatus) {
  return (
    <>
      <Title>Activity Sync</Title>
      { syncStatus.status === 'unsynced'
        ? (<Unsynced />)
        : syncStatus.status === 'synced'
          ? (<Synced />)
          : (<Syncing />)
      }
    </>
  )
}
