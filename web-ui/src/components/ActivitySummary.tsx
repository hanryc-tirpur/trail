import React, { useEffect, useRef, useState } from 'react'

import { DateTime } from 'luxon'
import mapboxgl, { Map } from 'mapbox-gl'
import polyline from '@mapbox/polyline'

import Avatar from '@mui/material/Avatar'
import Card from '@mui/material/Card'
import CardHeader from '@mui/material/CardHeader'
import CardContent from '@mui/material/CardContent'
import { red } from '@mui/material/colors'
import IconButton from '@mui/material/IconButton'
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'

import MoreVertIcon from '@mui/icons-material/MoreVert'
import PedalBike from '@mui/icons-material/PedalBike'


export type ActivitySummary = {
  id: string,
  mapPolyline: string,
  name: string,
  timeMoving: number,
  totalElapsedTime: number,
  totalDistance: Distance,
}

export type Distance = {
  val: number,
  unit: DistanceUnit,
}

export enum DistanceUnit {
  Mile = 'mi',
  KM = 'km',
}

mapboxgl.accessToken = 'pk.eyJ1IjoiaGFucnljLXRpcnB1ciIsImEiOiJjbGM5ODJpbTQwa3JpM3FwOGg1ZWJxZzFoIn0.aTFy6FZ_UD6Djp3QBZG6aw'

export default function ActivitySummaryComponent({ id, mapPolyline, name, timeMoving, totalElapsedTime, totalDistance }: ActivitySummary) {
  const mapContainer = useRef<HTMLDivElement | null>(null);
  const map = useRef<Map | null>(null);
  const [lng, setLng] = useState(-88.01478);
  const [lat, setLat] = useState(41.97843);
  const [zoom, setZoom] = useState(12);

  useEffect(() => {
    if (map.current) return; // initialize map only once

    if(mapContainer.current !== null) {
      map.current = new mapboxgl.Map({
        container: mapContainer.current,
        style: 'mapbox://styles/mapbox/streets-v12',
        center: [lng, lat],
        zoom: zoom,
      });
    }
  });

  useEffect(() => {
    if (map.current === null) return; // wait for map to initialize

    map.current.on('move', () => {
      if (map.current !== null) {
        setLng(Number(map.current.getCenter().lng.toFixed(4)))
        setLat(Number(map.current.getCenter().lat.toFixed(4)))
        setZoom(Number(map.current.getZoom().toFixed(2)))
      }
    });

    map.current.on('load', () => {
      if (map.current === null) return

      // @ts-ignore Bad types
      map.current.addSource('route', {
        type: 'geojson',
        data: {
          type: 'Feature',
          properties: {},
          geometry: polyline.toGeoJSON(mapPolyline),
        }
      })
      map.current.addLayer({
        'id': 'route',
        'type': 'line',
        'source': 'route',
        'layout': {
          'line-join': 'round',
          'line-cap': 'round'
        },
        'paint': {
          'line-color': '#888',
          'line-width': 8
        }
      });
    })
  })

  const startTime = DateTime.fromMillis(parseInt(id, 10))
  const startTimeDescription = `${startTime.toLocaleString(DateTime.DATE_FULL)} at ${startTime.toLocaleString(DateTime.TIME_SIMPLE)}`

  let remainingTimeMoving = timeMoving
  const hours = Math.floor(remainingTimeMoving / 3600)
  remainingTimeMoving -= (hours * 3600)
  const minutes = Math.floor(remainingTimeMoving / 60)
  const seconds = remainingTimeMoving - (minutes * 60)

  let timeMovingDescription = hours > 0 ? `${hours}h ` : ``
  timeMovingDescription = timeMovingDescription.length > 0 || minutes > 0
    ? `${timeMovingDescription}${minutes}m ` : ``
  timeMovingDescription = `${timeMovingDescription}${seconds}s`

  return (
    <Card>
      <CardHeader
        avatar={
          <Avatar sx={{ bgcolor: red[500] }} aria-label="activity">
            
          </Avatar>
        }
        action={
          <IconButton aria-label="settings">
            <MoreVertIcon />
          </IconButton>
        }
        title={'~hanryc-tirpur'}
        subheader={startTimeDescription}
      />
      <CardContent style={{ width: '550px', paddingTop: '0' }}>
        <Grid container spacing={2}>
          <Grid item textAlign="center" style={{ width: '40px', marginLeft: '8px', marginRight: '8px', }}>
            <PedalBike />
          </Grid>
          <Grid container item xs={10}>
            <Grid item xs={12}>
              <Typography
                component="h3"
                variant="h6"
                color="inherit"
                noWrap
                sx={{ flexGrow: 1 }}
              >
                {name}
              </Typography>
            </Grid>
            <Grid item xs={3}>
              Distance
            </Grid>
            <Grid item xs={3}>
              Elev Gain
            </Grid>
            <Grid item xs={6}>
              Time
            </Grid>
            <Grid item xs={3}>
              {`${totalDistance.val.toFixed(2)} ${totalDistance.unit}`}
            </Grid>
            <Grid item xs={3}>
              {'n/a'}
            </Grid>
            <Grid item xs={6}>
              {timeMovingDescription}
            </Grid>
          </Grid>
        </Grid>
        <div>
          <div ref={mapContainer} className="map-container" />
        </div>
      </CardContent>
    </Card>
  );
}