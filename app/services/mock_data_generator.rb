class MockDataGenerator
  def initialize(mock_model, user)
    @mock_model   = mock_model
    @user         = user
    @fields       = mock_model.fields || {}
    @associations = mock_model.associations || []
  end

  def generate_records(count: 1, includes: [])
    Array.new(count) { |i| build_record(i + 1, includes) }
  end

  def generate_single_record(id:, includes: [])
    build_record(id, includes)
  end

  private

  def build_record(id, includes)
    record = { id: id }

    # Generate field data
    @fields.each do |field_name, field_type|
      record[field_name.to_sym] = generate_field_value(field_type["type"])
    end unless @fields.empty?

    # Generate associations
    unless @associations.empty?
      @associations.each do |assoc|
        next unless includes.include?(assoc["target"].downcase) || includes.include?(assoc["target"].downcase.pluralize)

        if assoc["type"] == "has_many"
          related_model = @mock_model.team.mock_models.find_by(name: assoc["target"])
          if related_model
            related_generator = MockDataGenerator.new(related_model, @user)
            related_records   = related_generator.generate_records(count: 3)
            related_records.each { |r| r[assoc["foreign_key"]] = id }
            record[assoc["target"].downcase.pluralize.to_sym] = related_records
          end
        elsif assoc["type"] == "belongs_to"
          record[assoc["foreign_key"].to_sym] = Faker::Number.between(from: 1, to: 100)
          if includes.include?(assoc["target"].downcase)
            related_model = @mock_model.team.mock_models.find_by(name: assoc["target"])
            if related_model
              related_generator                       = MockDataGenerator.new(related_model, @user)
              record[assoc["target"].downcase.to_sym] = related_generator.generate_single_record(id: record[assoc["foreign_key"].to_sym], includes: [])
            end
          end
        elsif assoc["type"] == "has_one"
          record[assoc["foreign_key"].to_sym] = Faker::Number.between(from: 1, to: 100)
          if includes.include?(assoc["target"].downcase)
            related_model = @mock_model.team.mock_models.find_by(name: assoc["target"])
            if related_model
              related_generator                       = MockDataGenerator.new(related_model, @user)
              record[assoc["target"].downcase.to_sym] = related_generator.generate_single_record(id: record[assoc["foreign_key"].to_sym], includes: [])
            end
          end
        elsif assoc["type"] == "has_and_belongs_to_many"
          related_model = @mock_model.team.mock_models.find_by(name: assoc["target"])
          if related_model
            related_generator                                 = MockDataGenerator.new(related_model, @user)
            record[assoc["target"].downcase.pluralize.to_sym] = related_generator.generate_records(count: 3)
          end
        end
      end
    end

    record
  end

  def generate_field_value(field_type)
    case field_type
    when "string" then Faker::Lorem.paragraph
    when "text" then Faker::Lorem.paragraphs(number: 4).join("\n")
    when "integer" then Faker::Number.between(from: 1, to: 100)
    when "email" then Faker::Internet.email
    when "boolean" then Faker::Boolean.boolean
    else Faker::Lorem.sentence
    end
  end
end
