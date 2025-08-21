class CreateMockModels < ActiveRecord::Migration[8.0]
  def change
    create_table :mock_models do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :fields, null: false, default: []
      t.jsonb :associations, null: false, default: []

      t.timestamps
    end
  end
end
