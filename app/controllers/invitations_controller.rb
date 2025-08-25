class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_invitation, only: [ :show, :accept, :decline ]

  def show
    # Show invitation details - can be accessed without login
    if @invitation.expired?
      render inertia: "invitations/expired"
      return
    end

    unless @invitation.pending? || @invitation.pending_user_creation?
      render inertia: "invitations/already_processed"
      return
    end

    # If user is not logged in, check if they need to create an account
    unless user_signed_in?
      if @invitation.user_exists?
        # User exists but not logged in - redirect to login
        session[:invitation_token] = @invitation.token
        redirect_to new_user_session_path, notice: "Please sign in to accept this invitation."
      else
        # User doesn't exist - mark invitation as pending user creation and redirect to registration
        @invitation.mark_pending_user_creation!
        session[:invitation_token] = @invitation.token
        redirect_to new_user_registration_path, notice: "Please create an account to accept this invitation."
      end
      return
    end

    # Check if logged in user's email matches invitation
    if current_user.email != @invitation.email
      render inertia: "invitations/email_mismatch"
      nil
    end
  end

  def accept
    authorize! :accept, @invitation

    if @invitation.accept!(current_user)
      redirect_to dashboard_home_index_path, notice: "Successfully joined the team!"
    else
      redirect_to invitation_path(token: @invitation.token), alert: "Unable to accept invitation."
    end
  end

  def decline
    authorize! :decline, @invitation

    if @invitation.decline!
      redirect_to root_path, notice: "Invitation declined."
    else
      redirect_to invitation_path(token: @invitation.token), alert: "Unable to decline invitation."
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find_by!(token: params[:token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Invitation not found."
  end
end
