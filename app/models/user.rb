class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.avatar = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  has_one_attached :avatar, dependent: :destroy
  has_many :posts, dependent: :destroy, foreign_key: 'author'
  has_many :comments, dependent: :destroy, foreign_key: 'author'
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :received_friends, through: :received_friendships, source: :user

  def active_friends
    friends.select{ |friend| friend.friends.include?(self) }
  end

  def pending_friends
    friends.select{ |friend| !friend.friends.include?(self) }
  end

  def pending_friendships
    friendships.select{ |friendship| !friendship.is_mutual }
  end

  def pending_received_friendships
    received_friendships.select{ |friendship| !friendship.is_mutual }
  end
end
