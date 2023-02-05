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

export type StravaClientInfo = {
  client_id: string,
  client_secret: string,
}

export type ConnectionProcessState = {
  pageIndex: number,
  params?: StravaClientInfo & {
    code?: string,
  },
}

export type StravaConnectionStatus = {
  isConnected: boolean,
  syncStatus: StravaSyncStatus,
}

export type StravaClientInfoResponse = {
  hasClientInfo: boolean,
  clientInfo: StravaClientInfo,
}

export type StravaConnectionStatusResponse = {
  type: string,
  payload: StravaConnectionStatus,
}
