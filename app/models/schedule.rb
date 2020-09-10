class Schedule < ApplicationRecord
  belongs_to :destination
  mount_uploader :picture, PictureUploader
  
  validate :picture_size
  
  private
    
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "5MBより大きい画像はアップロードできません。")
    end
  end
  
end
