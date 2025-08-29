class RemoveUserIdFromMockModels < ActiveRecord::Migration[8.0]
  def change
    remove_column :mock_models, :user_id
  end
end
