class V1::UsersController < V1::BaseController
  def show
    user_email = params[:email]
    current_users = User.all.select {
      |user| user_email == user.email
    }
    render json: current_users
  end
end
