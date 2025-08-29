class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_user_has_team_or_redirect_to_onboarding

    inertia_share do
    {
      user_teams: -> { current_user&.teams || [] },
      has_team: -> { current_user&.has_team? || false }
    }
  end

  private

  def ensure_user_has_team_or_redirect_to_onboarding
    return if current_user.has_team?
    return if request.path.start_with?("/onboarding") || request.path.start_with?("/invitations")

    redirect_to onboarding_index_path
  end
end
