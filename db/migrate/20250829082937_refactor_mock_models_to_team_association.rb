class RefactorMockModelsToTeamAssociation < ActiveRecord::Migration[8.0]
  def change
    # Add team_id column without null constraint first
    add_reference :mock_models, :team, foreign_key: true

    # For existing mock_models, assign them to the user's first active team
    # This assumes users have at least one team membership
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE mock_models#{' '}
          SET team_id = (
            SELECT tm.team_id#{' '}
            FROM team_memberships tm#{' '}
            WHERE tm.user_id = mock_models.user_id#{' '}
            AND tm.active = true#{' '}
            ORDER BY tm.created_at ASC#{' '}
            LIMIT 1
          )
          WHERE team_id IS NULL
        SQL
      end
    end

    # Make team_id not null after populating data
    change_column_null :mock_models, :team_id, false

    # Update index from user_id to team_id
    remove_index :mock_models, :user_id
    # Note: add_reference already creates the index, so we don't need to add it again
    # add_index :mock_models, :team_id

    # Remove foreign key constraint to users
    remove_foreign_key :mock_models, :users

    # Optional: Remove user_id column if we're completely moving to team-based
    # remove_column :mock_models, :user_id
  end
end
