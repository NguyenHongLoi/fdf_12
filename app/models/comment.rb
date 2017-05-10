class Comment < ApplicationRecord
  strip_attributes only: :content

  acts_as_paranoid
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  delegate :name, to: :user, prefix: :user, allow_nil: true
  delegate :avatar, to: :user, prefix: :user, allow_nil: true

  after_create_commit { create_event }

  scope :newest, ->{order created_at: :desc}

  validates :content,
    length: {in: Settings.min_content_of_comment..Settings.max_content_of_comment}

  private
  def create_event
    Event.create message: "",
      user_id: self.commentable.user.id, eventable_id: commentable.id,
        eventable_type: Product.name,
        eventitem_id: self.id
  end
end
