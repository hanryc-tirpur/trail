import React from 'react'
import { LoaderFunctionArgs, redirect, useLoaderData } from 'react-router-dom'

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
  index: number,
}

type Steps = Step<CreateStravaAppInputs> & { index: 0 }
  | Step<StravaClientInfoEntryInputs> & { index: 1 }
  | Step<StravaAuthorizationInputs> & { index: 2 }
  | Step<ConnectStravaInputs> & { index: 3 }

const api = new Urbit('', '', window.desk)
api.ship = window.ship


export async function loader({ request }: LoaderFunctionArgs): Promise<Response | Steps> {
  const { payload } = await api.scry<StravaConnectionStatusResponse>({
    app: 'strava',
    path: '/status/strava-status'
  })
  
  if(payload.isConnected) {
    return redirect('/apps/trail/integrations/strava')
  }

  const { hasClientInfo, clientInfo } = await api.scry<StravaClientInfoResponse>({
    app: 'strava',
    path: '/status/strava-client-info'
  })

  if(!hasClientInfo) {
    return {
      index: 0,
      type: 'CreateStravaApp',
    }
  }
  
  const url = new URL(request.url)
  const code = url.searchParams.get('code')

  if(!code) {
    return {
      index: 2,
      type: 'StravaAuthorization',
      ... clientInfo,
    }
  }

  return {
    index: 3,
    type: 'ConnectStrava',
    ... clientInfo,
    code,
  }
}

const steps = ['Create Strava App', 'Enter Strava Client Info', 'Request Strava Authorization', 'Connect']

export default function Connect() {
  // @ts-ignore useLoaderData does not return typed data
  const activeStepItem: Steps = useLoaderData()
  const [activeStep, setActiveStep] = React.useState<number>(activeStepItem.index)
  const [skipped, setSkipped] = React.useState(new Set<number>())

  const isStepOptional = (step: number) => {
    return false
    // return step === 1
  }

  const isStepSkipped = (step: number) => {
    return skipped.has(step)
  }

  const handleNext = () => {
    let newSkipped = skipped
    if (isStepSkipped(activeStep)) {
      newSkipped = new Set(newSkipped.values())
      newSkipped.delete(activeStep)
    }

    setActiveStep((prevActiveStep) => prevActiveStep + 1)
    setSkipped(newSkipped)
  }

  const handleBack = () => {
    setActiveStep((prevActiveStep) => prevActiveStep - 1)
  }

  const handleSkip = () => {
    if (!isStepOptional(activeStep)) {
      // You probably want to guard against something like this,
      // it should never occur unless someone's actively trying to break something.
      throw new Error("You can't skip a step that isn't optional.")
    }

    setActiveStep((prevActiveStep) => prevActiveStep + 1)
    setSkipped((prevSkipped) => {
      const newSkipped = new Set(prevSkipped.values())
      newSkipped.add(activeStep)
      return newSkipped
    })
  }

  const handleReset = () => {
    setActiveStep(0)
  }


  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', width: '100%' }}>
      <Stepper activeStep={activeStep}>
        {steps.map((label, index) => {
          const stepProps: { completed?: boolean } = {}
          const labelProps: {
            optional?: React.ReactNode
          } = {}
          if (isStepOptional(index)) {
            labelProps.optional = (
              <Typography variant="caption">Optional</Typography>
            )
          }
          if (isStepSkipped(index)) {
            stepProps.completed = false
          }
          return (
            <Step key={label} {...stepProps}>
              <StepLabel {...labelProps}>{label}</StepLabel>
            </Step>
          )
        })}
      </Stepper>
      {activeStep === steps.length ? (
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
          {activeStepItem.index === 3 
            ? <ConnectStrava {... activeStepItem} />
            : activeStepItem.index === 2
              ? <StravaAuthorization {... activeStepItem} />
              : activeStepItem.index === 1
                ? <StravaClientInfoEntry />
                : <CreateStravaApp />
          }
          </Box>
          <Box sx={{ display: 'flex', flexDirection: 'row', pt: 2 }}>
            <Button
              color="inherit"
              disabled={activeStep === 0}
              onClick={handleBack}
              sx={{ mr: 1 }}
            >
              Back
            </Button>
            <Box sx={{ flex: '1 1 auto' }} />
            {isStepOptional(activeStep) && (
              <Button color="inherit" onClick={handleSkip} sx={{ mr: 1 }}>
                Skip
              </Button>
            )}
            <Button onClick={handleNext} disabled={activeStep === 2}>
              {activeStep === steps.length - 1 ? 'Finish' : 'Next'}
            </Button>
          </Box>
        </React.Fragment>
      )}
    </Box>
  )
}