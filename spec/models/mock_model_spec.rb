# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MockModel, type: :model do
  context 'fails validity' do
    let(:model) { MockModel.new }

    it 'fails validations' do
      expect(model).not_to be_valid

      expect(model.errors).to include(:name)
      expect(model.errors).to include(:user)
      expect(model.errors).to include(:associations)
      expect(model.errors).to include(:fields)
    end
  end

  context 'makes a valid model' do
    let(:model) { create(:mock_model) }

    it 'succeeds validations' do
      expect(model).to be_valid
    end
  end
end
