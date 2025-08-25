# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # Basic permissions for authenticated users
    can :read, User, id: user.id

    # Onboarding permissions - users without teams can access onboarding
    if !user.has_team?
      can :access, :onboarding
      can :create, Team
    end

    # Team-based permissions
    user.teams.each do |team|
      if user.admin_of?(team)
        # Team admins can manage everything within their team
        can :manage, Team, id: team.id
        can :manage, TeamMembership, team_id: team.id
        can :manage, Invitation, team_id: team.id
        can :invite, team
      else
        # Team members can read team information
        can :read, Team, id: team.id
        can :read, TeamMembership, team_id: team.id
      end
    end

    # Invitation acceptance - users can accept invitations sent to their email
    can :accept, Invitation, email: user.email
    can :decline, Invitation, email: user.email
  end
end
