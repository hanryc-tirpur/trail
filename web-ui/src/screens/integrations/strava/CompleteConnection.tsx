import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import * as yup from "yup"

import { yupResolver } from '@hookform/resolvers/yup'
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
    <form onSubmit={handleSubmit(onSubmit)}>
      <input type="submit" />
      {errors.client_id && <span>{errors.client_id.message}</span>}
      {errors.client_secret && <span>{errors.client_secret.message}</span>}
      {errors.code && <span>{errors.code.message}</span>}
      
      <input type="hidden" {...register('client_id')} defaultValue={clientState.client_id} />
      <input type="hidden" {...register('client_secret')} defaultValue={clientState.client_secret} />
      <input type="hidden" {...register('code')} defaultValue={url.searchParams.get('code') || ''} />
    </form>
  )
}