import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from "yup"

import Grid from '@mui/material/Grid'
import Paper from '@mui/material/Paper'

import Urbit from '@urbit/http-api'

const api = new Urbit('', '', window.desk)
api.ship = window.ship

const schema = yup.object({
  client_id: yup.number().positive().integer().required(),
  client_secret: yup.string().required(),
  code: yup.string().required(),
})

interface Inputs extends ClientState {
  code: string,
}

interface ClientState {
  client_id: string,
  client_secret: string,
}

export default function CompleteConnection() {
  const url = new URL(location.href)
  const stateVal = url.searchParams.get('state')
  if(stateVal === null) throw new Error('Cannot continue without state')
  const clientState: ClientState = JSON.parse(atob(stateVal))
  console.log(clientState)
  const { register, handleSubmit, watch, formState: { errors } } = useForm<Inputs>({
    resolver: yupResolver(schema)
  })

  const onSubmit: SubmitHandler<Inputs> = async (data, evt) => {
    const pokeResult = await api.poke({
      app: 'strava',
      mark: 'strava-action',
      json: {
        'complete-connection': {
          'client-id': data.client_id,
          'client-secret': data.client_secret,
          code: data.code,
        }
      }
    })
  }

  return (
    <Grid container spacing={3}>
      {/* Chart */}
      <Grid item xs={12} md={8} lg={9}>
        <Paper
          sx={{
            p: 2,
            display: 'flex',
            flexDirection: 'column',
            height: 240,
          }}
        >
          <div>Connect to Strava</div>
          <form onSubmit={handleSubmit(onSubmit)}>
            <input type="submit" />
            {errors.client_id && <span>{errors.client_id.message}</span>}
            {errors.client_secret && <span>{errors.client_secret.message}</span>}
            {errors.code && <span>{errors.code.message}</span>}
            
            <input type="hidden" {...register('client_id')} defaultValue={clientState.client_id} />
            <input type="hidden" {...register('client_secret')} defaultValue={clientState.client_secret} />
            <input type="hidden" {...register('code')} defaultValue={url.searchParams.get('code') || ''} />
          </form>
        </Paper>
      </Grid>
      {/* Recent Deposits */}
      <Grid item xs={12} md={4} lg={3}>
        <Paper
          sx={{
            p: 2,
            display: 'flex',
            flexDirection: 'column',
            height: 240,
          }}
        >
          <div>Deposits</div>
        </Paper>
      </Grid>
      {/* Recent Orders */}
      <Grid item xs={12}>
        <Paper sx={{ p: 2, display: 'flex', flexDirection: 'column' }}>
          <div>Orders</div>
        </Paper>
      </Grid>
    </Grid>
  )
}