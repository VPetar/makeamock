interface DashboardModelsIndexProps {
  models: Model[]
}

interface Model {
  id: number
  name: string
  fields: Fields
  associations: any[]
  created_at: string
  updated_at: string
  team_id: number
}

interface Fields {
  age: Field
  bio: Field
  name: Field
  email: Field
  active: Field
}

interface Field {
  type: string
  required: boolean
}

export default function DashboardModelsIndex(props: DashboardModelsIndexProps) {
    console.log('props', props);
    return <div>Dashboard Models Index</div>;
}