class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  scope :search_title, ->(search_title) do
    where("title LIKE ?", "%#{search_title}%")
  end

  scope :search_status, ->(status) do
    where(status: status)
  end

  paginates_per 10
end
