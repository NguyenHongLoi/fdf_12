class V1::DomainsController < V1::BaseController
  def show
    if user_signed_in?
      @user_id = current_user.id
      current_domains = Domain.all.select {
        |domain| @user_id.to_i == domain.owner
      }
      render json: current_domains
    else
      render json: Settings.user_error_login_json
    end
  end
end
