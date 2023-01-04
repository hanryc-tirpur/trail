import React from 'react';
import ReactDOM from 'react-dom';
import { App } from './app';
import CssBaseline from '@mui/material/CssBaseline'
import './index.css';
import '@fontsource/roboto/300.css'
import '@fontsource/roboto/400.css'
import '@fontsource/roboto/500.css'
import '@fontsource/roboto/700.css'
import 'mapbox-gl/dist/mapbox-gl.css'


ReactDOM.render(
  <React.StrictMode>
    <CssBaseline />
    <App />
  </React.StrictMode>,
  document.getElementById('app')
);
