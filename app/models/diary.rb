class Diary < ApplicationRecord
	belongs_to :user
	has_one_attached :image do |attachable|
		attachable.variant :display, resize_to_limit: [500, 500]
	end
	default_scope -> { order(start_time: :desc) }
	validates :user_id, presence: true
	validates :title,	presence: true, length: { maximum: 20 }
	validates :content, presence: true, length: { maximum: 255 }
	validates :start_time, presence: true
	validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
		message: "must be a valid image format" },
size:         { less_than: 5.megabytes,
		message:   "should be less than 5MB" }
end
