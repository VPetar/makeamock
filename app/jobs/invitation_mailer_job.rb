class InvitationMailerJob < ApplicationJob
  queue_as :default

  def perform(invitation)
    InvitationMailer.invitation_email(invitation).deliver_now
  end
end
