class ApplicationController < ActionController::Base
  include InertiaFlash

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  use_inertia_instance_props

  inertia_config(
    default_render:          true,
    component_path_resolver: ->(path:, action:) { "#{path}/#{action}" }
  )

  inertia_share do
    {
      has_user: -> { current_user.present? },
      user: -> { current_user },
      user_teams: -> { current_user&.teams || [] },
      has_team: -> { current_user&.has_team? || false }
    }
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
