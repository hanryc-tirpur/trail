import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import * as yup from "yup"
import { yupResolver } from '@hookform/resolvers/yup'
import Urbit from '@urbit/http-api'

import Box from '@mui/material/Box'
import TextField from '@mui/material/TextField'
import Typography from '@mui/material/Typography'
import { StravaClientInfo } from '../types/strava-types'


export interface Inputs {
  type: 'StravaClientInfoEntry',
}

const schema = yup.object({
  client_id: yup.number().positive().integer().required(),
  client_secret: yup.string().required(),
})

const api = new Urbit('', '', window.desk)
api.ship = window.ship

export default function StravaClientInfoEntry({ onNext }: any) {
  const { getValues, register, trigger, formState: { errors } } = useForm<StravaClientInfo>({
    resolver: yupResolver(schema)
  })

  onNext(async () => {
    const isValid = await trigger()
    if(!isValid) return { isSuccessful: false }
    const data = getValues()
    const pokeResult = await api.poke({
      app: 'strava',
      mark: 'strava-action',
      json: {
        'save-client-info': {
          'client-id': parseInt(data.client_id, 10),
          'client-secret': data.client_secret,
        }
      }
    })
  })

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
        autoFocus
        {... register('client_id', { required: 'Client Id is required.'})}
        error={!!errors.client_id}
        helperText={errors.client_id?.message}
      />
      <TextField
        margin="normal"
        required
        fullWidth
        id="client_secret"
        label="Client Secret"
        {... register('client_secret', { required: 'Client Secret is required.'})}
        error={!!errors.client_secret}
        helperText={errors.client_secret?.message}
      />
    </Box>
    </>
  )
}
