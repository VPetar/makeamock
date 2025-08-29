class AddActiveBooleanToTeamMembershipsTable < ActiveRecord::Migration[8.0]
  def change
    add_column :team_memberships, :active, :boolean, default: true, null: false
  end
end
