export type StravaSyncStatus =
    StravaUnsynced
  | StravaSynced


export type StravaUnsynced = {
  status: 'unsynced',
  msg: string,
}

export type StravaSynced = {
  status: 'synced',
  until: number,
}

export type StravaConnectionStatus = {
  isConnected: boolean,
  syncStatus: StravaSyncStatus,
}

export type StravaConnectionStatusResponse = {
  type: string,
  payload: StravaConnectionStatus,
}
