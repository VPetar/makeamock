# == Schema Information
#
# Table name: mock_models
#
#  id           :bigint           not null, primary key
#  associations :jsonb            not null
#  fields       :jsonb            not null
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_id      :bigint           not null
#
# Indexes
#
#  index_mock_models_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class MockModel < ApplicationRecord
  belongs_to :team
  validates :name, presence: true, uniqueness: { scope: :team_id }

  before_validation :initialize_jsonb

  def generate_from_data(data, id = 1)
    return {} unless fields.is_a?(Hash)

    generated_data = {
      id: id
    }

    fields.each do |field_name, field_type|
      if data[field_name.to_sym]
        generated_data[field_name.to_sym] = data[field_name.to_sym]
      end
    end

    generated_data
  end

  private

  def initialize_jsonb
    self.fields ||= []
    self.associations ||= []
  end
end
