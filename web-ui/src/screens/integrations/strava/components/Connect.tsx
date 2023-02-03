import React from 'react'
import { redirect, useLoaderData } from 'react-router-dom'

import Urbit from '@urbit/http-api'

import Box from '@mui/material/Box'
import Stepper from '@mui/material/Stepper'
import Step from '@mui/material/Step'
import StepLabel from '@mui/material/StepLabel'
import Button from '@mui/material/Button'
import Typography from '@mui/material/Typography'

import ConnectStrava from './ConnectStrava'
import CreateStravaApp from './CreateStravaApp'
import StravaAuthorization from './StravaAuthorization'
import StravaClientInfo from './StravaClientInfo'


const api = new Urbit('', '', window.desk)
api.ship = window.ship

interface ConnectProcessStatus {
  pageIndex: number,
  state: ClientState | null,
}

interface ClientState {
  client_id: string,
  client_secret: string,
  code: string,
}

export function loader(): ConnectProcessStatus {
  console.log('connect loader')
  // scry for "connection state"?
  const url = new URL(location.href)
  const stateVal = url.searchParams.get('state')
  const code = url.searchParams.get('code')

  if(stateVal && code) {
    const state: ClientState = {
      ... JSON.parse(atob(stateVal)),
      code
    }
    return {
      pageIndex: 3,
      state,
    }
  }

  return { pageIndex: 0, state: null }
}

const steps = ['Create Strava App', 'Enter Strava Client Info', 'Request Strava Authorization', 'Connect']

export default function Connect() {
  // @ts-ignore useLoaderData does not return typed data
  const d: ConnectProcessStatus = useLoaderData()
  console.log('Connect', d)
  const { pageIndex, state } = d
  const [activeStep, setActiveStep] = React.useState(pageIndex)
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
    <Box sx={{ width: '100%' }}>
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
          {activeStep === 3 && state !== null
            ? <ConnectStrava {... state} />
            : activeStep === 2
              ? <StravaAuthorization />
              : activeStep === 1
                ? <StravaClientInfo />
                : <CreateStravaApp />
          }
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
            <Button onClick={handleNext} disabled={activeStep === 2 && state === null}>
              {activeStep === steps.length - 1 ? 'Finish' : 'Next'}
            </Button>
          </Box>
        </React.Fragment>
      )}
    </Box>
  )
}