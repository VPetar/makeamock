class ApplicationController < ActionController::Base
  include InertiaFlash

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  use_inertia_instance_props

  inertia_config(
    default_render: true,
    component_path_resolver: ->(path:, action:) { "#{path}/#{action}" }
  )
end
