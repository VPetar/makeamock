# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe MockModel, type: :model do
  context 'fails validity' do
    let(:model) { MockModel.new }

    it 'fails validations' do
      expect(model).not_to be_valid

      expect(model.errors).to include(:name)
      expect(model.errors).to include(:team)
    end
  end

  context 'makes a valid model' do
    let(:model) { create(:mock_model) }

    it 'succeeds validations' do
      expect(model).to be_valid
    end
  end
end
