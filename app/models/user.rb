class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :destinations, dependent: :destroy
  #follow
  has_many :follow_relationships, class_name: "Relationship", foreign_key: "user_id", dependent: :destroy
  has_many :followings, through: :follow_relationships, source: :follow
  #followed
  has_many :followed_relationships, class_name: "Relationship", foreign_key: "follow_id",dependent: :destroy
  has_many :followers, through: :followed_relationships, source: :user
  #favorite
  has_many :favorites, dependent: :destroy
  has_many :added_favorites, through: :favorites, source: :destination
  #comment
  has_many :comments, dependent: :destroy
  #notification
  has_many :notifications, dependent: :destroy
  
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    def new_token
      SecureRandom.urlsafe_base64
    end
    
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def feed_destination
    Destination.where(user_id: self.following_ids + [self.id])
  end
  
  def follow(other_user)
    unless self == other_user
      self.follow_relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.follow_relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def followed_by?(other_user)
    self.followers.include?(other_user)
  end
  
  def favorite(destination)
    self.favorites.find_or_create_by(destination_id: destination.id)
  end
  
  def unfavorite(destination)
    favorite = self.favorites.find_by(destination_id: destination.id)
    favorite.destroy if favorite
  end
  
  def favorite?(destination)
    self.added_favorites.include?(destination)
  end
  
end
