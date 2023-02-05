import React from 'react'
import { createRoot } from 'react-dom/client'
import { App } from './app'
import CssBaseline from '@mui/material/CssBaseline'
import { createTheme, ThemeProvider } from '@mui/material/styles'
import {
  createBrowserRouter,
  RouterProvider,
} from 'react-router-dom'
import './index.css';
import '@fontsource/roboto/300.css'
import '@fontsource/roboto/400.css'
import '@fontsource/roboto/500.css'
import '@fontsource/roboto/700.css'
import 'mapbox-gl/dist/mapbox-gl.css'


import Dashboard, { loader as dashboardLoader } from './screens/Dashboard'
import Strava, { loader as stravaStatusLoader } from './screens/integrations/strava/Strava'
// @ts-ignore Is .jsx page
import ErrorPage from './screens/ErrorPage'
import ActivitySync from './screens/integrations/strava/components/ActivitySync'
import StravaConnect, { loader as connectLoader } from './screens/integrations/strava/Connect'

const mdTheme = createTheme()

const router = createBrowserRouter([
  {
    path: "/apps/trail/",
    element: <App />,
    errorElement: <ErrorPage />,
    children: [{
      index: true,
      loader: dashboardLoader,
      element: <Dashboard />,
    }, {
      path: 'integrations/strava',
      element: <Strava />,
      loader: stravaStatusLoader,
      children: [{
        index: true,
        element: <ActivitySync />,
      }],
    }, {
      path: 'integrations/strava/connect',
      element: <StravaConnect />,
      loader: connectLoader,
    }],
  },
])

const container = document.getElementById('app')
const root = createRoot(container!) // createRoot(container!) if you use TypeScript

root.render(
  <React.StrictMode>
    <ThemeProvider theme={mdTheme}>
      <CssBaseline />
      <RouterProvider router={router} />
    </ThemeProvider>
  </React.StrictMode>
)
