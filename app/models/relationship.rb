class Relationship < ApplicationRecord
# list14.3	
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	# list14.5
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end

