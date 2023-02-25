import React, { useEffect, useRef, useState } from 'react'

import { DateTime } from 'luxon'
import mapboxgl, { Map, MapboxOptions } from 'mapbox-gl'
import polyline from '@mapbox/polyline'
import bbox from '@turf/bbox'
import center from '@turf/center'

import Avatar from '@mui/material/Avatar'
import Card from '@mui/material/Card'
import CardHeader from '@mui/material/CardHeader'
import CardContent from '@mui/material/CardContent'
import { red } from '@mui/material/colors'
import IconButton from '@mui/material/IconButton'
import Grid from '@mui/material/Grid'
import Typography from '@mui/material/Typography'

import DirectionsRun from '@mui/icons-material/DirectionsRun'
import DirectionsWalk from '@mui/icons-material/DirectionsWalk'
import MoreVertIcon from '@mui/icons-material/MoreVert'
import PedalBike from '@mui/icons-material/PedalBike'
import QuestionMark from '@mui/icons-material/QuestionMark'


export type ActivitySummary = {
  id: string,
  activityType: string,
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

function getActivityIcon(activityType: string) {
  switch(activityType) {
    case 'bike':
    case 'ride':
      return <PedalBike />
    case 'run':
      return <DirectionsRun />
    case 'walk':
      return <DirectionsWalk />
    default:
      return <QuestionMark />
  }
}

export default function ActivitySummaryComponent({ id, activityType, mapPolyline, name, timeMoving, totalElapsedTime, totalDistance }: ActivitySummary) {
  const mapContainer = useRef<HTMLDivElement | null>(null)
  const map = useRef<Map | null>(null)
  const geo = polyline.toGeoJSON(mapPolyline)
  const box = bbox(geo)
  const cen = center(geo)
  const [lng, setLng] = useState(cen.geometry.coordinates[0])
  const [lat, setLat] = useState(cen.geometry.coordinates[1])
  const [zoom, setZoom] = useState(12)

  useEffect(() => {
    if (map.current) return; // initialize map only once

    if(mapContainer.current !== null) {
      const opts: MapboxOptions = {
        container: mapContainer.current,
        style: 'mapbox://styles/mapbox/streets-v12',
      }
      if(box.length === 4) {
        opts.bounds = box
        opts.fitBoundsOptions = {
          padding: 25
        }
      } else {
        opts.center = [lng, lat]
      }
      map.current = new mapboxgl.Map(opts)
    }
  })

  useEffect(() => {
    if (map.current === null) return; // wait for map to initialize

    map.current.on('move', () => {
      if (map.current !== null) {
        setLng(Number(map.current.getCenter().lng.toFixed(4)))
        setLat(Number(map.current.getCenter().lat.toFixed(4)))
        setZoom(Number(map.current.getZoom().toFixed(2)))
      }
    })

    map.current.on('load', () => {
      if (map.current === null) return

      // @ts-ignore Bad types
      map.current.addSource('route', {
        type: 'geojson',
        data: {
          type: 'Feature',
          properties: {},
          geometry: geo,
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
          'line-color': '#454545',
          'line-width': 3,
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
        title={`~${window.ship}`}
        subheader={startTimeDescription}
      />
      <CardContent style={{ width: '550px', paddingTop: '0' }}>
        <Grid container spacing={2}>
          <Grid item textAlign="center" style={{ width: '40px', marginLeft: '8px', marginRight: '8px', }}>
            {getActivityIcon(activityType)}
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