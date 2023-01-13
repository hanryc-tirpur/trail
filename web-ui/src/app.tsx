import React, { useEffect, useState } from 'react'
import Urbit from '@urbit/http-api';
import { Charges, ChargeUpdateInitial, scryCharges, Scry } from '@urbit/api'


import Box from '@mui/material/Box'
import Container from '@mui/material/Container'
import Grid from '@mui/material/Grid'

import Toolbar from '@mui/material/Toolbar'
import Typography from '@mui/material/Typography'
import Grid2 from '@mui/material/Unstable_Grid2'

import AppBar from './components/AppBar'
import ActivitySummaryDisplay, { DistanceUnit } from './components/ActivitySummary'

import type { ActivitySummary } from './components/ActivitySummary'

const api = new Urbit('', '', window.desk);
api.ship = window.ship;


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


export function App() {
  const scryAllActivities: Scry = { app: 'trail', path: '/activities/all', }
  const [summaries, setSummaries] = useState<ActivitySummary[]>();

  useEffect(() => {
    async function init() {
      let summariesResponse = (await api.scry<ActivitySummariesInitial>(scryAllActivities));
      summariesResponse = summariesResponse.activities?.length ? summariesResponse : {
        activities: [{
          name: 'Dummy Workout',
          id: '23456',
          totalElapsedTime: 787,
          timeMoving: 787,
          totalDistance: {
            val: 8.2110,
            unit: DistanceUnit.KM,
          }
        }]
      }
      console.log('All activities', summariesResponse)
      setSummaries(summariesResponse.activities);
    }

    init();
  }, []);

  return (
    <Box sx={{ display: 'flex' }}>
      <AppBar position="absolute" open={false}>
        <Typography
          component="h1"
          variant="h6"
          color="inherit"
          noWrap
          sx={{ flexGrow: 1 }}
        >
          Trail
        </Typography>
      </AppBar>
      <Box
        component="main"
        sx={{
          backgroundColor: (theme) =>
            theme.palette.mode === 'light'
              ? theme.palette.grey[100]
              : theme.palette.grey[900],
          flexGrow: 1,
          height: '100vh',
          overflow: 'auto',
        }}
      >
        <Toolbar />
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
          <Grid container spacing={3}>
          <ul>
          {summaries && summaries.map(s => {
            return (
              <li key={s.id}>
                <ActivitySummaryDisplay {... s} />
              </li>
            )
          })}
          </ul>
          </Grid>
        </Container>
      </Box>
    </Box>
  )
}
