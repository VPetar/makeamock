class InvitationMailer < ApplicationMailer
  def invitation_email(invitation)
    @invitation = invitation
    @team = invitation.team
    @invited_by = invitation.invited_by
    @invitation_url = invitation_url(token: invitation.token)
    @user_exists = invitation.user_exists?

    mail(
      to: invitation.email,
      subject: "You've been invited to join #{@team.name}"
    )
  end
end
