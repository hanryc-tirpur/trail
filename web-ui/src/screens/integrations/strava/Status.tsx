import React, { useEffect } from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from "yup"

import ActivitySync from './components/ActivitySync'
import StartConnection from './components/StartConnection'
import { useConnectionStatus } from './Strava'


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


export default function Status() {
  const { payload } = useConnectionStatus()
  
  return payload.isConnected
    ? (<ActivitySync {... payload} />)
    : (<StartConnection />)
}
