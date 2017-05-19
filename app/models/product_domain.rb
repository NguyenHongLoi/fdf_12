class ProductDomain < ApplicationRecord
  belongs_to :product
  belongs_to :domain

  scope :not_in_shop_domain, -> only_shop_domain {where.not domain_id: only_shop_domain}

  scope :api_find_product_domains, -> domain_id_params {where domain_id: domain_id_params}

end
