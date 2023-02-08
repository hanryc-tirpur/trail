import React, { useState } from 'react'
import { LoaderFunctionArgs, redirect, useLoaderData, useNavigate } from 'react-router-dom'

import Urbit from '@urbit/http-api'

import Box from '@mui/material/Box'
import Stepper from '@mui/material/Stepper'
import Step from '@mui/material/Step'
import StepLabel from '@mui/material/StepLabel'
import Button from '@mui/material/Button'
import Typography from '@mui/material/Typography'

import ConnectStrava from './components/ConnectStrava'
import CreateStravaApp from './components/CreateStravaApp'
import StravaAuthorization from './components/StravaAuthorization'
import StravaClientInfoEntry from './components/StravaClientInfoEntry'

import { Inputs as ConnectStravaInputs } from './components/ConnectStrava'
import { Inputs as CreateStravaAppInputs } from './components/CreateStravaApp'
import { Inputs as StravaAuthorizationInputs } from './components/StravaAuthorization'
import { Inputs as StravaClientInfoEntryInputs } from './components/StravaClientInfoEntry'

import type {
  ConnectionProcessState,
  StravaClientInfo,
  StravaClientInfoResponse,
  StravaConnectionStatus,
  StravaConnectionStatusResponse,
} from './types/strava-types'

type Step<T> = T & {
  type: string,
  index: number,
}

type StepFactory<T, K> = {
  description: string,
  create: ({}: K) => Step<T>,
}

type Steps = Step<CreateStravaAppInputs> & { index: 0 }
  | Step<StravaClientInfoEntryInputs> & { index: 1 }
  | Step<StravaAuthorizationInputs> & { index: 2 }
  | Step<ConnectStravaInputs> & { index: 3 }

type DataResult = {
  isSuccessful: boolean,
  data?: any,
  navigate?: string,
}


const api = new Urbit('', '', window.desk)
api.ship = window.ship

const createStravaAppFactory: StepFactory<CreateStravaAppInputs & { index: 0 }, void> = {
  description: 'Create Strava App', 
  create: () => ({
    index: 0,
    type: 'CreateStravaApp',
    getData: () => Promise.resolve(),
  })
}

const enterClientInfoFactory: StepFactory<StravaClientInfoEntryInputs & { index: 1 }, void>  = {
  description: 'Enter Strava Client Info', 
  create: () => ({
    index: 1,
    type: 'StravaClientInfoEntry',
  })
}

const requestAuthorizationFactory: StepFactory<StravaAuthorizationInputs & { index: 2 }, StravaClientInfo>  = {
  description: 'Request Strava Authorization',
  create: (clientInfo: StravaClientInfo) => ({
    index: 2,
    type: 'StravaAuthorization',
    getData: () => Promise.resolve(),
    ... clientInfo,
  })
}

const connectFactory: StepFactory<ConnectStravaInputs & { index: 3 }, StravaClientInfo & { code: string}>  = {
  description: 'Connect',
  create: ({ client_id, client_secret, code }) => ({
    index: 3,
    type: 'ConnectStrava',
    client_id,
    client_secret,
    code,
  })
}

const stepFactories = [
  createStravaAppFactory,
  enterClientInfoFactory,
  requestAuthorizationFactory,
  connectFactory,
]

export async function loader({ request }: LoaderFunctionArgs): Promise<Response | Steps> {
  const { payload } = await api.scry<StravaConnectionStatusResponse>({
    app: 'strava',
    path: '/status/strava-status'
  })
  
  console.log('payload', payload)
  if(payload.isConnected) {
    return redirect('/apps/trail/integrations/strava')
  }

  const { hasClientInfo, clientInfo } = await api.scry<StravaClientInfoResponse>({
    app: 'strava',
    path: '/status/strava-client-info'
  })

  if(!hasClientInfo) {
    return createStravaAppFactory.create()
  }
  
  const url = new URL(request.url)
  const code = url.searchParams.get('code')

  return !code
    ? requestAuthorizationFactory.create(clientInfo)
    : connectFactory.create({... clientInfo, code})
}

export default function Connect() {
  // @ts-ignore useLoaderData does not return typed data
  const initialStep: Steps = useLoaderData()
  const [activeStep, setActiveStep] = React.useState(initialStep)
  const [nextIsLoading, setNextIsLoading] = useState(false)
  const navigate = useNavigate()

  let getNextData = (): Promise<DataResult> => Promise.resolve({ isSuccessful: true })
  // @ts-ignore useLoaderData does not return typed data
  const onNext = (fn) => {
    getNextData = fn
  }

  let getPreviousData = () => null
  // @ts-ignore useLoaderData does not return typed data
  const onPrev = (fn) => {
    getPreviousData = fn
  }

  const handleNext = async () => {
    setNextIsLoading(true)
    const dataResult = await getNextData()
    setNextIsLoading(false)

    if(dataResult.navigate) {
      return window.location.href = dataResult.navigate
    }

    if(dataResult.isSuccessful) {
      setActiveStep(prev => {
        const f = stepFactories[prev.index + 1]
        // @ts-ignore useLoaderData does not return typed data
        const nextStep = f.create(dataResult.data)
        return nextStep
      })
    }
  }

  const handleBack = () => {
    // @ts-ignore useLoaderData does not return typed data
    setActiveStep((currentActiveStep) => stepFactories[currentActiveStep.index - 1].create(getPreviousData()))
  }

  const handleReset = () => {
    setActiveStep(createStravaAppFactory.create())
  }


  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', width: '100%' }}>
      <Stepper activeStep={activeStep.index}>
        {stepFactories.map(f => f.description).map((label, index) => {
          const stepProps: { completed?: boolean } = {}
          const labelProps: {
            optional?: React.ReactNode
          } = {}
          return (
            <Step key={label} {...stepProps}>
              <StepLabel {...labelProps}>{label}</StepLabel>
            </Step>
          )
        })}
      </Stepper>
      {activeStep.index === stepFactories.length ? (
        <React.Fragment>
          <Typography sx={{ mt: 2, mb: 1 }}>
            All steps completed - you&aposre finished
          </Typography>
          <Box sx={{ display: 'flex', flexDirection: 'row', pt: 2 }}>
            <Box sx={{ flex: '1 1 auto' }} />
            <Button onClick={handleReset}>Reset</Button>
          </Box>
        </React.Fragment>
      ) : (
        <React.Fragment>
          <Box sx={{ flexGrow: 1, padding: '25px' }}>
          {activeStep.index === 3 
            ? <ConnectStrava {... activeStep} onNext={onNext} onPrev={onPrev} />
            : activeStep.index === 2
              ? <StravaAuthorization {... activeStep } onNext={onNext} />
              : activeStep.index === 1
                ? <StravaClientInfoEntry onNext={onNext} />
                : <CreateStravaApp />
          }
          </Box>
          <Box sx={{ display: 'flex', flexDirection: 'row', pt: 2 }}>
            <Button
              color="inherit"
              disabled={activeStep.index === 0}
              onClick={handleBack}
              sx={{ mr: 1 }}
            >
              Back
            </Button>
            <Box sx={{ flex: '1 1 auto' }} />
            <Button onClick={handleNext} disabled={nextIsLoading}>
              {activeStep.index === stepFactories.length - 1 ? 'Finish' : 'Next'}
            </Button>
          </Box>
        </React.Fragment>
      )}
    </Box>
  )
}