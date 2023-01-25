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


import Dashboard, { loader as dashboardLoader } from './screens/Dashboard';
// @ts-ignore Is .jsx page
import ErrorPage from './screens/ErrorPage'
import StravaSettings from './screens/integrations/strava/Settings'
import StravaCompleteConnection from './screens/integrations/strava/CompleteConnection'

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
      element: <StravaSettings />,
    }, {
      path: 'integrations/strava/complete-connection',
      element: <StravaCompleteConnection />,
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
