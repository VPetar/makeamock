class OnboardingController < AuthorizedController
  skip_before_action :ensure_user_has_team_or_redirect_to_onboarding

  def index
    # If user already has a team, redirect them to dashboard
    if current_user.has_team?
      redirect_to dashboard_home_index_path
      return
    end

    authorize! :access, :onboarding
  end

  def create_team
    authorize! :create, Team

    @team = Team.new(team_params)

    if @team.save
      # Make the current user an admin of the new team
      @team.team_memberships.create!(user: current_user, role: "admin")

      redirect_to dashboard_home_index_path, notice: "Team created successfully!"
    else
      redirect_to onboarding_index_path, inertia: { errors: @team.errors }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
