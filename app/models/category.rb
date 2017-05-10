class Category < ApplicationRecord
  strip_attributes only: :name

  acts_as_paranoid

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:name, [:name, :id]]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed? || super
  end

  has_many :products

  scope :asc_by_name, ->{order :name}

  validates :name, presence: true, uniqueness: true

  class << self
    def  number_category_by_domain category, domain
      domain.products.by_category(category).size
    end
  end
end
