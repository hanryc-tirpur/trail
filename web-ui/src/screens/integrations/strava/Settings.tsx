import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from "yup"

import Grid from '@mui/material/Grid'
import Paper from '@mui/material/Paper'


const schema = yup.object({
  client_id: yup.number().positive().integer().required(),
  client_secret: yup.string().required(),
})

type Inputs = {
  client_id: string,
  client_secret: string,
  redirect_uri: string,
  response_type: string,
  scope: string,
  state: string,
}

export function AuthenticateStrava() {
  const { register, handleSubmit, watch, formState: { errors } } = useForm<Inputs>({
    resolver: yupResolver(schema)
  })
  const onSubmit: SubmitHandler<Inputs> = (data, evt) => {
    data = {
      ... data,
      state: btoa(JSON.stringify({ client_id: data.client_id, client_secret: data.client_secret }))
    }
    const url = new URL(`${evt?.target.action}?${new URLSearchParams(data).toString()}`)
    location.href = url.toString()
    console.log(data, evt?.target.action)
  }

  return (
    <form encType="form/url-encoded" onSubmit={handleSubmit(onSubmit)} action="https://www.strava.com/oauth/authorize">
      <input {...register('client_id')} />
      {errors.client_id && <span>This field is required</span>}
      
      <input {...register('client_secret')} />
      {errors.client_secret && <span>This field is required</span>}

      <input type="submit" />
      
      <input type="hidden" {...register('redirect_uri')} defaultValue={`${location.href}/complete-connection`} />
      <input type="hidden" {...register('response_type')} defaultValue="code" />
      <input type="hidden" {...register('scope')} defaultValue="activity:read_all,activity:write" />
    </form>
  );
}

export default function Settings() {
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
          <AuthenticateStrava />
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