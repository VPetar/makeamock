class Dashboard::ModelsController < AuthorizedController
  def index
    @models = current_user.models
  end
  def show; end
  def create; end
end
