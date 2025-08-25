class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :guid, null: false

      t.timestamps
    end
    add_index :teams, :guid, unique: true
  end
end
