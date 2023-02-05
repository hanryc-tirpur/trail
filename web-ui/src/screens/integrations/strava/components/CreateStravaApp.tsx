import React from 'react'

import Grid from '@mui/material/Grid'
import Link from '@mui/material/Link'
import Typography from '@mui/material/Typography'


export interface Inputs {
  type: 'CreateStravaApp',
}


export default function CreateStravaApp() {
  const url = new URL(window.location.href)

  return (
    <>
    <Typography component="h2" variant="h6" color="primary" gutterBottom>
      Create Strava App
    </Typography>
    <Typography gutterBottom>
      To connect your Urbit, you will first need to { ' ' }
      <a href="https://www.strava.com/settings/api">create an app in Strava</a>
      {' '} using the values below.
    </Typography>
    <Grid container sx={{ margin: '25px 0' }}>
      <Grid item xs={4}>
        <Typography fontWeight={'bold'}>Website</Typography>
      </Grid>
      <Grid item xs={8}>
        {url.origin}
      </Grid>
      <Grid item xs={4}>
        <Typography fontWeight={'bold'}>Authorization Callback Domain</Typography>
      </Grid>
      <Grid item xs={8}>
        {url.hostname}
      </Grid>
    </Grid>
    <Typography>
      You can find additional Strava documentation for this process {' '}
      <Link href="https://developers.strava.com/docs/getting-started/#account" variant="body2">
        here
      </Link>.
    </Typography>
    </>
  )
}
