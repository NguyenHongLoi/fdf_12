class ShopsController < ApplicationController
  before_action :load_shop, only: [:show, :update]
  before_action :authenticate_user!

  def index
    @shops = if @domain.present?
      Shop.includes(:tags).shop_in_domain @domain.id
    else
      Shop.all
    end.active.page(params[:page])
      .per(Settings.common.shops_per_page).decorate
  end

  def show
    @products = @shop.products.active.page(params[:page])
      .per Settings.common.products_per_page
    @shop = @shop.decorate
  end

  def update
    user = User.find_by email: params[:email]
    if user
      @all_shop_by_domains = []
      current_user.user_domains.each do |current_user|
        user.user_domains.each do |user|
          if current_user.domain_id != user.domain_id
            next
          else
            @shop.update_attributes owner_id: user.user_id
            @all_shop_by_domains << ShopDomain.select_all_shop_by_domain(user.domain_id, @shop.id)
          end
        end
      end
      @shop.update_attributes owner_id: user.id
      only_shop_domain = []
      @all_shop_by_domains.each do |shop|
        if shop.present?
          only_shop_domain << shop.first.domain_id
        end
      end
      ShopDomain.not_in_shop_domain(only_shop_domain).delete_all(shop_id: @shop.id)
      @shop.products.each do |product|
        ProductDomain.not_in_shop_domain(only_shop_domain).destroy_all(product_id: product.id)
      end
      user_shop_owner = ShopManager.find_by(user_id: current_user.id, shop_id: @shop.id, role: :owner)
      if user_shop_owner.present?
        user_shop_owner.destroy
      end
      user_shop_manager = ShopManager.find_by(user_id: user.id, shop_id: @shop.id, role: :manager)
      if user_shop_manager.present?
        user_shop_manager.destroy
      end
      ShopManager.create(user_id: user.id, shop_id: @shop.id, role: :owner)
      flash[:success] = t "change_shop"
      redirect_to root_path
    else
      flash[:danger] = t "cant_not_find_shop"
      redirect_to :back
    end
  end

  private
  def load_shop
    if Shop.exists? params[:id]
      @shop = Shop.find params[:id]
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to root_path
    end
  end
end
