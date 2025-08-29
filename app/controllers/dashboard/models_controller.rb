class Dashboard::ModelsController < AuthorizedController
  def index
    @models = current_user.active_team.mock_models
    @schema = current_user.active_team.mock_schema || { nodes: [], edges: [] }
  end

  def create
    nodes = mock_model_params[:nodes] || []
    edges = mock_model_params[:edges] || []

    ActiveRecord::Base.transaction do
      nodes.each do |node|
        if node[:data]
          mock_model = current_user.active_team.mock_models.find_by(id: node[:data][:mock_model_id])

          if mock_model.nil? && node[:data][:name].present?
            # we will create a new one
          end

          if mock_model
            fields = {}
            if node[:data][:fields].is_a?(Array)
              node[:data][:fields].each do |field|
                fields[field[:name]] = {
                  type: field[:type],
                  required: field[:required] || false
                }
              end
            end
            mock_model.update!(name: node[:data][:name], fields: fields)
          end
        end
      end
    end

    current_user.active_team&.update!(mock_schema: { nodes: nodes, edges: edges })
  end

  private

  def mock_model_params
    params.require(:model).permit!
  end
end
