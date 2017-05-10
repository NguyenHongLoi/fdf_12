class User < ApplicationRecord
  strip_attributes only: [:description, :name, :chatwork_id]

  acts_as_token_authenticatable
  ratyrate_rater

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged]

  def slug_candidates
    [:name, [:name, :id]]
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :shop_managers, dependent: :destroy
  has_many :shops, dependent: :destroy, through: :shop_managers
  has_many :own_shops, class_name: "Shop", foreign_key: :owner_id
  has_many :comments, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_products
  has_many :coupons, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :user_domains, dependent: :destroy
  has_many :domains, through: :user_domains, dependent: :destroy

  enum status: {wait: 0, active: 1, blocked: 2}
  mount_uploader :avatar, UserAvatarUploader

  VALID_NAME_REGEX = /\A^[\p{L}\s'.-]+\z/

  validates :name, presence: true, format: {with: VALID_NAME_REGEX},
    length: {maximum: Settings.user.max_name}
  validates :chatwork_id, length: {maximum: Settings.user.max_chatwork_id}
  validates :description, length: {maximum: Settings.user.max_description}
  validate :image_size

  after_create :create_default_domain

  scope :by_date_newest, ->{order created_at: :desc}
  scope :by_active, ->{where status: active}
  scope :of_ids, -> ids {where id: ids}
  scope :list_all_users, -> ids {where id: ids}
  scope :user_of_list_id, -> list {where id: list}

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.provider = auth.provider
        user.uid = auth.uid
      end
    end
  end

  def is_user? user_id
    id == user_id
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || super
  end

  def add_device_id device_id
    if device_id.present? && self.device_id != device_id
      self.update_attributes device_id: device_id
    end
  end

  def add_authentication_token
    self.update_attributes authentication_token: generate_authentication_token
  end

  private
  def image_size
    max_size = Settings.pictures.max_size
    if avatar.size > max_size.megabytes
      errors.add :avatar, I18n.t("pictures.error_message", max_size: max_size)
    end
  end

  def create_default_domain
    CreateDomainService.new(self).create
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token if User.where(authentication_token: token).count.zero?
    end
  end
end
