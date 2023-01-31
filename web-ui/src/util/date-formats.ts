import { DateTime } from 'luxon'


export function dateAndTimeString(ms: number | string) {
  if(typeof ms === 'string') {
    ms = parseInt(ms, 10)
  }
  const startTime = DateTime.fromMillis(ms)
  return `${startTime.toLocaleString(DateTime.DATE_FULL)} at ${startTime.toLocaleString(DateTime.TIME_SIMPLE)}`
}

export function dateAndTimeStringFromSeconds(seconds: number | string) {
  if(typeof seconds === 'string') {
    seconds = parseInt(seconds, 10)
  }
  return dateAndTimeString(seconds * 1000)
}
