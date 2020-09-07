class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :destination
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :destination_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }
end
