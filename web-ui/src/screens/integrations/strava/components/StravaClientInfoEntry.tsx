import React from 'react'

import Box from '@mui/material/Box'
import TextField from '@mui/material/TextField'
import Typography from '@mui/material/Typography'


export interface Inputs {
  type: 'StravaClientInfoEntry',
}


export default function StravaClientInfoEntry() {
  return (
    <>
    <Typography component="h2" variant="h6" color="primary" gutterBottom>
      Strava Client Info
    </Typography>
    <Typography gutterBottom>
      Now that the Strava app is created, copy the Client Id and Client Secret
      values into the form below.
    </Typography>
    <Box component="form" noValidate sx={{ mt: 1, margin: '25px 0' }}>
      <TextField
        margin="normal"
        required
        fullWidth
        id="client_id"
        label="Client Id"
        name="client_id"
        autoFocus
      />
      <TextField
        margin="normal"
        required
        fullWidth
        id="client_secret"
        label="Client Secret"
        name="client_secret"
      />
    </Box>
    </>
  )
}
