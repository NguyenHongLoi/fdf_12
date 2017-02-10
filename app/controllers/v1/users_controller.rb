class V1::UsersController < V1::BaseController
  def index
    users = User.all
    render json: users
  end
end
