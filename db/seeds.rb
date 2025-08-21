if Rails.env.development?
  EMAIL = "qwe@qwe.qwe"

  # Create a default user if it doesn't exist
  User.find_or_create_by!(email: EMAIL) do |user|
    user.password              = EMAIL
    user.password_confirmation = EMAIL
    user.confirmed_at          = Time.now
  end
end
