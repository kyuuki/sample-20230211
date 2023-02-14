class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: true
  before_validation { email.downcase! }
  before_destroy :must_not_destroy_last_admin

  has_secure_password
  validates :password, length: { minimum: 6 }

  def admin?
    admin == true
  end

  def must_not_destroy_last_admin
    if admin? && User.where(admin: true).size == 1
      throw(:abort)
    end
  end
end
