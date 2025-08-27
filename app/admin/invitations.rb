ActiveAdmin.register Invitation do
  # Specify parameters which should be permitted for assignment
  permit_params :email, :team_id, :invited_by_id, :token, :status, :expires_at

  # or consider:
  #
  # permit_params do
  #   permitted = [:email, :team_id, :invited_by_id, :token, :status, :expires_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  member_action :send_invite, method: :post do
    invitation = Invitation.find(params[:id])
    invitation.send_invitation
    redirect_to admin_invitation_path(invitation), notice: "Invitation sent"
  end

  action_item :send_invite, only: :show do
    link_to "Send Invitation", send_invite_admin_invitation_path(resource), method: :post, class: "action-item-button" if resource.pending?
  end

  # Add or remove filters to toggle their visibility
  filter :id
  filter :email
  filter :team
  filter :invited_by, as: :select, collection: proc { User.all.pluck(:email, :id) }
  filter :token
  filter :status
  filter :expires_at
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :email
    column :team
    column :invited_by
    column :token
    column :status
    column :expires_at
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :email
      row :team
      row :invited_by
      row :token
      row :status
      row :expires_at
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :email
      f.input :team
      f.input :invited_by, as: :select, collection: User.all.pluck(:email, :id)
      f.input :status
      f.input :expires_at
    end
    f.actions
  end
end
