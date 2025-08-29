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
require "test_helper"

class MockModelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
