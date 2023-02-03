import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { yupResolver } from '@hookform/resolvers/yup'
import Urbit from '@urbit/http-api'
import * as yup from "yup"

import Typography from '@mui/material/Typography'

interface Inputs extends ClientState {
  code: string,
}

interface ClientState {
  client_id: string,
  client_secret: string,
}

const api = new Urbit('', '', window.desk)
api.ship = window.ship

const schema = yup.object({
  client_id: yup.number().positive().integer().required(),
  client_secret: yup.string().required(),
  code: yup.string().required(),
})


export default function ConnectStrava({ client_id, client_secret, code }: Inputs) {
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
    <div>
      <Typography component="h2" variant="h6" color="primary" gutterBottom>
        Connect
      </Typography>
      <form onSubmit={handleSubmit(onSubmit)}>
        <input type="submit" />
        {errors.client_id && <span>{errors.client_id.message}</span>}
        {errors.client_secret && <span>{errors.client_secret.message}</span>}
        {errors.code && <span>{errors.code.message}</span>}
        
        <input type="hidden" {...register('client_id')} defaultValue={client_id} />
        <input type="hidden" {...register('client_secret')} defaultValue={client_secret} />
        <input type="hidden" {...register('code')} defaultValue={code} />
      </form>
    </div>
  )
}
