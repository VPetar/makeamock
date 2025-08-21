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
#  user_id      :bigint           not null
#
# Indexes
#
#  index_mock_models_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MockModel < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :fields, presence: true
  validates :associations, presence: true

  before_validation :initialize_jsonb

  private

  def initialize_jsonb
    self.fields ||= {}
    self.associations ||= []
  end
end
