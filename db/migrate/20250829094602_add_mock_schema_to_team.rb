class AddMockSchemaToTeam < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :mock_schema, :jsonb, default: { nodes: [], edges: [] }, null: false
  end
end
