class Destination < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :to, presence: true, length: { maximum: 30 }
  validates :from, presence: true, length: { maximum: 30 }
  validates :time, presence: true
  validates :date, presence: true
  validates :detail, presence: true
end
