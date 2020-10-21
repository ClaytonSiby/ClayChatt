class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  # validates the size of an uploaded picture
  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy

  # friendship associations

  has_many :friend_sent, class_name: :friendship,
                         foreign_key: :sent_by_id,
                         inverse_of: :sent_by,
                         dependent: :destroy

  has_many :friend_request, class_name: :friendship,
                            foreign_key: :sent_to_id,
                            inverse_of: :sent_to,
                            dependent: :destroy

  has_many :friends, -> { merge(Friendship.friends) },
           through: :friend_sent, source: :sent_to

  has_many :pending_requests, -> { merge(Friendship.non_friends) },
           through: :friend_sent, source: :sent_to

  has_many :received_requests, -> { merge(Friendship.non_friends) },
           through: :friend_request, source: :sent_by

  # notification associations

  has_many :notifications, dependent: :destroy

  # for image uploads
  mount_uploader :image, PictureUploader
  validate :picture_size

  # returns a string containing this user's first name & last name

  def full_name
    "#{firstname} #{lastname}"
  end

  # returns all posts from this user's friends and self

  def friends_own_posts
    myfriends = friends
    our_posts = []

    # add this user's friends' posts to our_posts array
    myfriends.each do |friend|
      friend.posts.each do |post|
        our_posts << post
      end
    end

    # add this user's posts to our_posts array
    posts.each do |post|
      our_posts << post
    end

    # return our_posts array.
    our_posts
  end
end
