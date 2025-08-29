export type SharedProps = {
  has_flash: boolean
  flash: Flash
  has_user: boolean
  user: User
  user_teams: UserTeam[]
  has_team: boolean
  current_user: CurrentUser
}

export interface Flash {
  notice: string
}

export interface User {
  id: number
  email: string
  created_at: string
  updated_at: string
}

export interface UserTeam {
  id: number
  active: boolean
  role: string
  name: string
  guid: string
  created_at: string
  updated_at: string
}

export interface CurrentUser {
  id: number
  email: string
  created_at: string
  updated_at: string
}