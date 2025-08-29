class Api::DynamicController < AuthorizedController
  def index
    path         = params[:endpoint]
    query_params = request.query_parameters.except(:controller, :action, :endpoint).symbolize_keys
    team         = current_user.teams.where(team_memberships: { active: true }).first
    mock_model   = team&.mock_models&.find_by(name: path.camelize)
    data         = []
    if mock_model
      data = MockDataGenerator.new(mock_model, current_user).generate_records(count: query_params[:count].to_i || 1)
    end
    render json: { path: "/#{path}", data: data }
  end

  def show
  end

  def create
    path       = params[:endpoint]
    team       = current_user.teams.where(team_memberships: { active: true }).first
    mock_model = team&.mock_models&.find_by(name: path.camelize)
    if mock_model
      data = mock_model.generate_from_data(params.permit!.to_h)
      render json: { path: "/#{path}", data: data }, status: :created
    else
      render json: { error: "Model not found" }, status: :not_found
    end
  end

  def update
    path       = params[:endpoint]
    team       = current_user.teams.where(team_memberships: { active: true }).first
    mock_model = team&.mock_models&.find_by(name: path.camelize)
    id         = params[:id] || 1
    if mock_model
      if request.patch?
        # Generate new record, but override provided fields
        generated = MockDataGenerator.new(mock_model, current_user).generate_records(count: 1).first
        patched   = generated.merge(params.permit!.to_h.symbolize_keys)
        patched[:id] = id.to_i
        render json: { path: "/#{path}", data: patched }, status: :created
      elsif request.put?
        # Behave like create
        data = mock_model.generate_from_data(params.permit!.to_h)
        data[:id] = id.to_i
        render json: { path: "/#{path}", data: data }, status: :created
      end
    else
      render json: { error: "Model not found" }, status: :not_found
    end
  end

  def destroy
    render json: {}, status: :ok
  end
end
