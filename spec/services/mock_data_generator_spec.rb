# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MockDataGenerator do
  let(:user) { create(:user) }
  let(:mock_model) { create(:mock_model, user: user) }
  let(:generator) { described_class.new(mock_model, user) }

  describe '#initialize' do
    it 'sets the mock model and user' do
      expect(generator.instance_variable_get(:@mock_model)).to eq(mock_model)
      expect(generator.instance_variable_get(:@user)).to eq(user)
    end

    it 'extracts fields from mock model' do
      fields = generator.instance_variable_get(:@fields)
      expect(fields).to eq(mock_model.fields)
    end

    it 'extracts associations from mock model' do
      associations = generator.instance_variable_get(:@associations)
      expect(associations).to eq(mock_model.associations)
    end

    it 'handles nil fields gracefully' do
      mock_model.update!(fields: nil)
      generator = described_class.new(mock_model, user)
      expect(generator.instance_variable_get(:@fields)).to eq([])
    end

    it 'handles nil associations gracefully' do
      mock_model.update!(associations: nil)
      generator = described_class.new(mock_model, user)
      expect(generator.instance_variable_get(:@associations)).to eq([])
    end
  end

  describe '#generate_records' do
    it 'generates the specified number of records' do
      records = generator.generate_records(count: 3)
      expect(records).to be_an(Array)
      expect(records.length).to eq(3)
    end

    it 'generates records with sequential IDs' do
      records = generator.generate_records(count: 3)
      expect(records[0][:id]).to eq(1)
      expect(records[1][:id]).to eq(2)
      expect(records[2][:id]).to eq(3)
    end

    it 'generates records with fields from mock model' do
      generated = generator.generate_records(count: 1).first
      mock_model.fields.each_key do |field_name|
        expect(generated).to have_key(field_name.to_sym)
      end
    end

    it 'defaults to generating 1 record when count not specified' do
      records = generator.generate_records
      expect(records.length).to eq(1)
    end

    context 'with associations' do
      let(:related_model) { create(:mock_model, :simple, user: user, name: 'RelatedModel') }
      let(:mock_model_with_associations) do
        create(:mock_model,
               user:         user,
               name:         'MainModel',
               fields:       { name: 'string', description: 'text' },
               associations: [
                               { 'type' => 'has_many', 'target' => 'RelatedModel', 'foreign_key' => 'main_model_id' }
                             ])
      end
      let(:generator_with_associations) { described_class.new(mock_model_with_associations, user) }

      before do
        related_model # Ensure the related model exists
      end

      it 'includes associations when specified' do
        records = generator_with_associations.generate_records(count: 1, includes: [ 'relatedmodels' ])
        expect(records.first).to have_key(:relatedmodels)
      end

      it 'does not include associations when not specified' do
        records = generator_with_associations.generate_records(count: 1)
        expect(records.first).not_to have_key(:relatedmodels)
      end
    end
  end

  describe '#generate_single_record' do
    it 'generates a single record with the specified ID' do
      record = generator.generate_single_record(id: 42)
      expect(record[:id]).to eq(42)
    end

    it 'generates a record with all fields' do
      record = generator.generate_single_record(id: 1)
      mock_model.fields.each_key do |field_name|
        expect(record).to have_key(field_name.to_sym)
      end
    end
  end

  describe 'field value generation' do
    let(:mock_model_with_various_fields) do
      create(:mock_model,
             user:         user,
             fields:       {
               name:   { type: 'string', required: true },
               bio:    { type: 'text', required: true },
               age:    { type: 'integer', required: true },
               email:  { type: 'email', required: true },
               active: { type: 'boolean', required: true }
             },
             associations: [])
    end
    let(:generator_with_fields) { described_class.new(mock_model_with_various_fields, user) }

    it 'generates string values for string fields' do
      record = generator_with_fields.generate_single_record(id: 1)
      expect(record[:name]).to be_a(String)
    end

    it 'generates text values for text fields' do
      record = generator_with_fields.generate_single_record(id: 1)
      expect(record[:bio]).to be_a(String)
      expect(record[:bio].length).to be > record[:name].length
    end

    it 'generates integer values for integer fields' do
      record = generator_with_fields.generate_single_record(id: 1)
      expect(record[:age]).to be_a(Integer)
      expect(record[:age]).to be_between(1, 100)
    end

    it 'generates email values for email fields' do
      record = generator_with_fields.generate_single_record(id: 1)
      expect(record[:email]).to be_a(String)
      expect(record[:email]).to include('@')
    end

    it 'generates boolean values for boolean fields' do
      record = generator_with_fields.generate_single_record(id: 1)
      puts record.inspect
      expect([ true, false ]).to include(record[:active])
    end
  end

  describe 'association handling' do
    let(:user_model) { create(:mock_model, user: user, name: 'User', fields: { 'name' => 'string' }, associations: []) }
    let(:post_model) { create(:mock_model, user: user, name: 'Post', fields: { 'title' => 'string' }, associations: []) }
    let(:comment_model) { create(:mock_model, user: user, name: 'Comment', fields: { 'content' => 'text' }, associations: []) }

    context 'has_many associations' do
      let(:mock_model_with_has_many) do
        create(:mock_model,
               user:         user,
               name:         'User',
               fields:       { 'name' => { type: 'string', reqiored: true } },
               associations: [
                               { 'type' => 'has_many', 'target' => 'Post', 'foreign_key' => 'user_id' }
                             ])
      end
      let(:generator_has_many) { described_class.new(mock_model_with_has_many, user) }

      before { post_model }

      it 'generates has_many associations when included' do
        record = generator_has_many.generate_single_record(id: 1, includes: [ 'posts' ])
        expect(record).to have_key(:posts)
        expect(record[:posts]).to be_an(Array)
        expect(record[:posts].length).to eq(3)
      end

      it 'sets foreign key on related records' do
        record = generator_has_many.generate_single_record(id: 5, includes: [ 'posts' ])
        record[:posts].each do |post|
          expect(post['user_id']).to eq(5)
        end
      end
    end

    context 'belongs_to associations' do
      let(:mock_model_with_belongs_to) do
        create(:mock_model,
               user:         user,
               name:         'Post',
               fields:       { 'title' => 'string' },
               associations: [
                               { 'type' => 'belongs_to', 'target' => 'User', 'foreign_key' => 'user_id' }
                             ])
      end
      let(:generator_belongs_to) { described_class.new(mock_model_with_belongs_to, user) }

      before { user_model }

      it 'generates foreign key for belongs_to associations' do
        generated = generator_belongs_to.generate_single_record(id: 1)
        expect(generated).to be_a(Hash)
        expect(generated).to have_key(:title)
      end

      it 'includes related record when specified' do
        generated = generator_belongs_to.generate_single_record(id: 1, includes: [ 'user' ])
        expect(generated).to have_key(:user)
        expect(generated[:user]).to be_a(Hash)
        expect(generated[:user][:id]).to eq(generated[:user_id])
      end
    end

    context 'has_one associations' do
      let(:mock_model_with_has_one) do
        create(:mock_model,
               user:         user,
               name:         'User',
               fields:       { 'name' => 'string' },
               associations: [
                               { 'type' => 'has_one', 'target' => 'Profile', 'foreign_key' => 'profile_id' }
                             ])
      end
      let(:profile_model) { create(:mock_model, user: user, name: 'Profile', fields: { 'bio' => 'text' }, associations: []) }
      let(:generator_has_one) { described_class.new(mock_model_with_has_one, user) }

      before { profile_model }

      it 'generates foreign key for has_one associations' do
        generated = generator_has_one.generate_single_record(id: 1, includes: [ 'profile' ])

        expect(generated).to have_key(:profile_id)
      end

      it 'includes related record when specified' do
        generated = generator_has_one.generate_single_record(id: 1, includes: [ 'profile' ])
        expect(generated).to have_key(:profile)
        expect(generated[:profile]).to be_a(Hash)
        expect(generated[:profile][:id]).to eq(generated[:profile_id])
      end
    end

    context 'when related model does not exist' do
      let(:mock_model_with_missing_relation) do
        create(:mock_model,
               user:         user,
               name:         'TestModel',
               fields:       { 'name' => 'string' },
               associations: [
                               { 'type' => 'has_many', 'target' => 'NonExistentModel', 'foreign_key' => 'test_id' }
                             ])
      end
      let(:generator_missing) { described_class.new(mock_model_with_missing_relation, user) }

      it 'handles missing related models gracefully' do
        expect {
          record = generator_missing.generate_single_record(id: 1, includes: [ 'nonexistentmodels' ])
          expect(record).not_to have_key(:nonexistentmodels)
        }.not_to raise_error
      end
    end
  end

  describe 'edge cases' do
    it 'handles empty fields hash' do
      mock_model.update!(fields: {})
      generator = described_class.new(mock_model, user)
      record    = generator.generate_single_record(id: 1)
      expect(record[:id]).to eq(1)
      expect(record.keys).to eq([ :id ])
    end

    it 'handles empty associations array' do
      mock_model.update!(associations: [])
      record = generator.generate_single_record(id: 1, includes: [ 'anything' ])
      expect(record[:id]).to eq(1)
    end

    it 'generates consistent data structure across multiple calls' do
      record1 = generator.generate_single_record(id: 1)
      record2 = generator.generate_single_record(id: 2)

      expect(record1.keys).to eq(record2.keys)
      expect(record1[:id]).not_to eq(record2[:id])
    end
  end
end
