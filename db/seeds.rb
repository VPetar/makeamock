if Rails.env.development?
  EMAIL = "qwe@qwe.qwe"

  # Create a default user if it doesn't exist
  user = User.find_or_create_by!(email: EMAIL) do |user|
    user.password              = EMAIL
    user.password_confirmation = EMAIL
    user.confirmed_at          = Time.now
  end

  # Create mock models for the user
  MockModel.create_with(
    fields:       {
      name:   { type: 'string', required: true },
      bio:    { type: 'text', required: true },
      age:    { type: 'integer', required: true },
      email:  { type: 'email', required: true },
      active: { type: 'boolean', required: true }
    },
    associations: []
  ).find_or_create_by!(
    user: user,
    name: "Test Mock Model"
  )

  team = Team.find_or_create_by!(name: "Test Team")
  TeamMembership.find_or_create_by!(team: team, user: user, role: "admin")

end
