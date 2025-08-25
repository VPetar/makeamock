class Teams::InvitationsController < AuthorizedController
  before_action :set_team
  before_action :authorize_team_admin

  def index
    @invitations = @team.invitations.includes(:invited_by).order(created_at: :desc)
  end

  def create
    begin
      @invitation = Invitation.create_and_send!(
        email: invitation_params[:email],
        team: @team,
        invited_by: current_user
      )

      redirect_to teams_team_invitations_path(@team), notice: "Invitation sent successfully!"
    rescue ActiveRecord::RecordInvalid => e
      @invitations = @team.invitations.includes(:invited_by).order(created_at: :desc)
      redirect_to teams_team_invitations_path(@team), inertia: { errors: e.record.errors }
    end
  end

  def destroy
    @invitation = @team.invitations.find(params[:id])
    authorize! :manage, @invitation

    @invitation.destroy
    redirect_to teams_team_invitations_path(@team), notice: "Invitation cancelled."
  end

  private

  def set_team
    @team = current_user.teams.find_by(guid: params[:team_guid]) ||
            current_user.teams.find(params[:team_id])
    redirect_to dashboard_home_index_path, alert: "Team not found." unless @team
  end

  def authorize_team_admin
    authorize! :invite, @team
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
