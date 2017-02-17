class ShopDomain < ApplicationRecord
  include ChatworkHelper
  belongs_to :domain
  belongs_to :shop

  enum status: {pending: 0, approved: 1, rejected: 2}

  scope :by_domain, ->domain {where domain_id: domain.id}
  def create_event_request_shop user_id, shop_domain
    if shop_domain.pending?
      event = Event.create message: :pending,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
      send_message_chatwork event.load_message, user_id
    elsif shop_domain.approved?
      event = Event.create message: :approved,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
      send_message_chatwork event.load_message, user_id
    else
      event = Event.create message: :rejected,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
      send_message_chatwork event.load_message, user_id
    end
  end
end
