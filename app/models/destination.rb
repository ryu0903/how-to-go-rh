class Destination < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :schedules, dependent: :destroy
  accepts_nested_attributes_for :schedules, reject_if: :all_blank, allow_destroy: true
  
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :to, presence: true, length: { maximum: 30 }
  validates :from, presence: true, length: { maximum: 30 }
  validates :date, presence: true
  validate :picture_size
  
  private
    
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "5MBより大きい画像はアップロードできません。")
    end
  end
  
end
