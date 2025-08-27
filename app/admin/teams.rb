ActiveAdmin.register Team do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :guid

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :guid]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :guid
  filter :created_at
  filter :updated_at

  member_action :lock do
    puts "LOCKEEEEEEEED ACTYIOOOOOOOOOON?"
    puts resource.inspect
    redirect_to new_user_session_path, notice: "Locked!"
  end

  action_item :view, only: :show do
    link_to 'View on site', lock_admin_team_path(resource), class: "action-item-button"
  end

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :guid
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :guid
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :guid
    end
    f.actions
  end
end
