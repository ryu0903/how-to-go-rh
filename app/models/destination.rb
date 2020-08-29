class Destination < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :to, presence: true, length: { maximum: 30 }
  validates :from, presence: true, length: { maximum: 30 }
  validates :time, presence: true
  validates :date, presence: true
  validates :detail, presence: true
  validate :picture_size
  
  private
    
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "Picture must be less than 5 megabytes.")
    end
  end
  
end
