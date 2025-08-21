# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  inertia_config(
    default_render:          true,
    component_path_resolver: ->(path:, action:) { "#{path}/#{action}" }
  )

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # super
  end

  # POST /resource/sign_in
  def create
    self.resource = User.find_for_database_authentication(email: user_params[:email])

    unless resource.present?
      set_flash_message(:alert, :not_found_in_database, {
        scope: [ :devise, :failure ],
        authentication_keys: User.human_attribute_name(:email).downcase
      }) if is_navigational_format?
      expire_data_after_sign_in!
      redirect_to new_user_session_path
      return
    end

    if resource.confirmed?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      set_flash_message(:alert, :unconfirmed, {
        scope: [ :devise, :failure ]
      }) if is_navigational_format?
      expire_data_after_sign_in!
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    dashboard_home_index_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :password)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
