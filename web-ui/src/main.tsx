import React from 'react';
import ReactDOM from 'react-dom';
import { App } from './app';
import CssBaseline from '@mui/material/CssBaseline'
import { createTheme, ThemeProvider } from '@mui/material/styles'
import './index.css';
import '@fontsource/roboto/300.css'
import '@fontsource/roboto/400.css'
import '@fontsource/roboto/500.css'
import '@fontsource/roboto/700.css'
import 'mapbox-gl/dist/mapbox-gl.css'

const mdTheme = createTheme()

ReactDOM.render(
  <React.StrictMode>
    <ThemeProvider theme={mdTheme}>
      <CssBaseline />
      <App />
    </ThemeProvider>
  </React.StrictMode>,
  document.getElementById('app')
);
