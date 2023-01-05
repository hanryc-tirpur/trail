import React, { useEffect, useRef, useState } from 'react';
import Urbit from '@urbit/http-api';
import { Charges, ChargeUpdateInitial, scryCharges, Scry } from '@urbit/api'
import mapboxgl, { Map } from 'mapbox-gl'
import { AppTile } from './components/AppTile';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardMedia from '@mui/material/CardMedia';
import CardContent from '@mui/material/CardContent';
import Avatar from '@mui/material/Avatar';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import { red } from '@mui/material/colors';
import MoreVertIcon from '@mui/icons-material/MoreVert';

const api = new Urbit('', '', window.desk);
api.ship = window.ship;

mapboxgl.accessToken = 'pk.eyJ1IjoiaGFucnljLXRpcnB1ciIsImEiOiJjbGM5ODJpbTQwa3JpM3FwOGg1ZWJxZzFoIn0.aTFy6FZ_UD6Djp3QBZG6aw'

function RecipeReviewCard({ id, totalElapsedTime, totalDistance }: ActivitySummary) {
  const mapContainer = useRef<HTMLDivElement | null>(null);
  const map = useRef<Map | null>(null);
  const [lng, setLng] = useState(-70.9);
  const [lat, setLat] = useState(42.35);
  const [zoom, setZoom] = useState(9);

  useEffect(() => {
    if (map.current) return; // initialize map only once

    if(mapContainer.current !== null) {
      map.current = new mapboxgl.Map({
        container: mapContainer.current,
        style: 'mapbox://styles/mapbox/streets-v12',
        center: [lng, lat],
        zoom: zoom
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
  })

  return (
    <Card>
      <CardHeader
        avatar={
          <Avatar sx={{ bgcolor: red[500] }} aria-label="recipe">
            
          </Avatar>
        }
        action={
          <IconButton aria-label="settings">
            <MoreVertIcon />
          </IconButton>
        }
        title={totalElapsedTime}
        subheader="September 14, 2016"
      />
      <div>
        <div ref={mapContainer} className="map-container" />
      </div>
      <CardContent>
        <Typography variant="body2" color="text.secondary">
          This impressive paella is a perfect party dish and a fun meal to cook
          together with your guests. Add 1 cup of frozen peas along with the mussels,
          if you like.
        </Typography>
      </CardContent>
    </Card>
  );
}

export declare type ChargeUpdate = ChargeUpdateInitial | ChargeUpdateAdd | ChargeUpdateDel;
export interface ActivitySummariesInitial {
  activities: ActivitySummary[];
}
export interface ChargeUpdateAdd {
    'add-charge': {
        desk: string;
        charge: ActivitySummary;
    };
}
export interface ChargeUpdateDel {
    'del-charge': string;
}

enum DistanceUnit {
  Mile = 'mile',
  KM = 'km',
}

type Distance = {
  val: number,
  unit: DistanceUnit,
}

type ActivitySummary = {
  id: string,
  totalElapsedTime: number,
  totalDistance: Distance,
}

export function App() {
  const scryAllActivities: Scry = { app: 'trail', path: '/activities/all', }
  const [summaries, setSummaries] = useState<ActivitySummary[]>();

  useEffect(() => {
    async function init() {
      const summariesResponse = (await api.scry<ActivitySummariesInitial>(scryAllActivities));
      console.log('All activities', summariesResponse)
      setSummaries(summariesResponse.activities);
    }

    init();
  }, []);

  return (
    <main className="flex items-center justify-center min-h-screen">
      <div className="max-w-md space-y-6 py-20">
        <h1 className="text-3xl font-bold">Welcome to trail</h1>
        <ul className="space-y-4">
          {summaries && summaries.map(s => {
            return (
              <li key={s.id} className="flex items-center space-x-3 text-sm leading-tight">
                <RecipeReviewCard {... s} />
              </li>
            )
          })}
        </ul>
      </div>
    </main>
  );
}
