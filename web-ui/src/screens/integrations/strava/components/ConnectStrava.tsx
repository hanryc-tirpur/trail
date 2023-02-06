import React from 'react'
import { useForm, SubmitHandler } from "react-hook-form"
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


export default function ConnectStrava({ code }: Inputs) {
  const { register, handleSubmit, watch, formState: { errors } } = useForm<Inputs>({
    resolver: yupResolver(schema)
  })

  const onSubmit: SubmitHandler<Inputs> = async (data, evt) => {
    const pokeResult = await api.poke({
      app: 'strava',
      mark: 'strava-action',
      json: {
        'complete-connection': {
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
        <input type="hidden" {...register('code')} defaultValue={code} />
      </form>
    </div>
  )
}
