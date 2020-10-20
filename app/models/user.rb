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

  has_many :comments
end
