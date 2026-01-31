class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks
  has_one_attached :avatar

  validate :acceptable_avatar

  def acceptable_avatar
    unless avatar.byte_size <= 1.megabyte # Limit avatar image file size
      errors.add(:avatar, "is too big; Image must be 1MB or less.")
    end

    acceptable_formats = ["image/jpg", "image/png", "image/wbp"]

    unless acceptable_formats.include?(avatar.content_type)
      errors.add(:avatar, "must be .JPG, .PNG, or .WEBP")
    end
  end

end
