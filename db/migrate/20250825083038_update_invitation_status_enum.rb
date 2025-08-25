class UpdateInvitationStatusEnum < ActiveRecord::Migration[8.0]
  def up
    # No need to change the database schema since we're using string type
    # The new status 'pending_user_creation' is already supported
    # This migration exists for documentation purposes
  end

  def down
    # Nothing to rollback
  end
end
