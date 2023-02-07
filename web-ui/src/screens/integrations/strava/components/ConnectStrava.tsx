import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
import { redirect } from 'react-router-dom'
import { yupResolver } from '@hookform/resolvers/yup'
import Urbit from '@urbit/http-api'
import * as yup from "yup"

import Typography from '@mui/material/Typography'


export interface Inputs {
  type: 'ConnectStrava'
  code: string,
}

const api = new Urbit('', '', window.desk)
api.ship = window.ship

const schema = yup.object({
  code: yup.string().required(),
})


export default function ConnectStrava({ code, onNext }: Inputs & { onNext: any }) {
  const { getValues, register, trigger, formState: { errors } } = useForm<Inputs>({
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
        'complete-connection': {
          code: data.code,
        }
      }
    })

    const url = new URL(window.location.href)
    return {
      isSuccessful: true,
      navigate: `${url.origin}/apps/trail/integrations/strava`,
    }
  })

  return (
    <>
    <Typography component="h2" variant="h6" color="primary" gutterBottom>
      Connect
    </Typography>
    <Typography gutterBottom>
      Click Finish to connect to Strava and beging importing your activities.
    </Typography>
    <form>
      <input type="hidden" {...register('code')} defaultValue={code} />
    </form>
    </>
  )
}
