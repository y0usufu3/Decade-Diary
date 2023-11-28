class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end 
  #list13.75

  default_scope -> { order(created_at: :desc)}#list13.18 降順
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: {   in: %w[image/jpeg image/gif image/png],
                                        message: "must be a valid image format" },
                      size:         {   less_than: 5.megabytes,
                                        message:   "should be less than 5MB" }
end