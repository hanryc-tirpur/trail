import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { yupResolver } from '@hookform/resolvers/yup'
import * as yup from "yup"

import { Typography } from '@mui/material'

import Title from './Title'
import { StravaClientInfo } from '../types/strava-types'

export interface Inputs extends StravaClientInfo {
  type: 'StravaAuthorization',
}

const schema = yup.object({
  client_id: yup.number().positive().integer().required(),
  client_secret: yup.string().required(),
})

interface AuthorizationValues extends Record<string, string>, StravaClientInfo {
  redirect_uri: string,
  response_type: string,
  scope: string,
}

export default function StravaAuthorization({ client_id, client_secret, onNext }: Inputs & { onNext: any }) {
  const { getValues, register, trigger, formState: { errors } } = useForm<AuthorizationValues>({
    resolver: yupResolver(schema)
  })

  onNext(async () => {
    const isValid = await trigger()
    if(!isValid) return { isSuccessful: false }
    const data = getValues()
    const action = 'https://www.strava.com/oauth/authorize'
    const url = new URL(`${action}?${new URLSearchParams(data).toString()}`)
    
    return {
      isSuccessful: true,
      navigate: url.toString(),
    }
  })

  return (
    <>
      <Title>Authorize %trail</Title>
      <Typography>
        After clicking the Next button, you will be taken to the Strava website, and will be asked to 
        authorize the %trail app to read your activity data. After %trail is authorized, you will be
        brought back to the app to complete the connection process.
      </Typography>
      <form encType="form/url-encoded" action="https://www.strava.com/oauth/authorize">
        <input type="hidden" {...register('client_id')} defaultValue={`${client_id}`} />
        <input type="hidden" {...register('client_secret')} defaultValue={`${client_secret}`} />
        <input type="hidden" {...register('redirect_uri')} defaultValue={`${location.href}`} />
        <input type="hidden" {...register('response_type')} defaultValue="code" />
        <input type="hidden" {...register('scope')} defaultValue="activity:read_all,activity:write" />
      </form>
    </>
  )
}
