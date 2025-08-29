class Dashboard::ModelsController < AuthorizedController
  def index
    @models = current_user.active_team.mock_models
  end
  def show; end
  def create; end
end
