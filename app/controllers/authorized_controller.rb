class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_team_or_redirect_to_onboarding

  inertia_share user: -> { current_user }

  private

  def ensure_user_has_team_or_redirect_to_onboarding
    return if current_user.has_team?
    return if request.path.start_with?("/onboarding") || request.path.start_with?("/invitations")

    redirect_to onboarding_index_path
  end
end
