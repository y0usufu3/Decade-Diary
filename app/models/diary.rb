class Diary < ApplicationRecord
	belongs_to :user
	default_scope -> { order(start_time: :desc) }
	validates :user_id, presence: true
	validates :title,	presence: true, length: { maximum: 20 }
	validates :content, presence: true, length: { maximum: 255 }
end
