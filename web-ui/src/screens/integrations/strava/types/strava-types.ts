export type StravaSyncStatus =
    StravaUnsynced
  | StravaSynced


export type StravaUnsynced = {
  status: 'unsynced',
  msg: string,
}

export type StravaSynced = {
  status: 'synced',
}

export type StravaConnectionStatus = {
  isConnected: boolean,
  syncStatus: StravaSyncStatus,
}

export type StravaConnectionStatusResponse = {
  type: string,
  payload: StravaConnectionStatus,
}
