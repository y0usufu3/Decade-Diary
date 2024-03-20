class User < ApplicationRecord
	has_many :microposts,	dependent: :destroy #list12.12,12.20　関連オブジェクト削除を追加
	has_many :diaries,		dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent: :destroy
	#list14.12
	has_many :passive_relationships, 	class_name: "Relationship",
										foreign_key: "followed_id",
										dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	#list14.12
	has_many :followers, through: :passive_relationships, source: :follower
	attr_accessor :remember_token, :activation_token, :reset_token 	#list11.3,list12.6追加reset_token
	before_save 	:downcase_email						#list11.3
	before_create	:create_activation_digest			#list11.3
	# before_save { self.email = email.downcase }		#list11.3
	validates :name, presence: true, length: { maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255},format: { with: VALID_EMAIL_REGEX },uniqueness: true
	has_secure_password
	#list10.13allow_nil追加
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true 

	#渡された文字列のハッシュ値を返す #8.2.61追加
	# def User.digest(string)
	# def self.digest(string) #リスト9.4
	# class << self #list 9.5 上記コメント２つと同じ
	
	def User.digest(string)#list 9.5
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
														BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

		#ランダムなトークンを返す #9.1.1
		# def User.new_token#9.1.1
		# def self.new_token #リスト9.4
	def User.new_token #リスト9.5 上記コメント２つと同じ
		SecureRandom.urlsafe_base64
	end


	#永続的セッションのためにユーザーをデータベースに記憶する
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
		remember_digest#list9.37 演習のセッションリプライ攻撃のための変更
	end

	# セッションハイジャック防止のためにセッショントークンを返す
	# この記憶ダイジェストを再利用しているのは単に利便性のため  list9.37 演習
	def session_token
		remember_digest || remember
	end

	#渡されたトークンがダイジェストと一致したらtrueを返す list9.20追記
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	#ユーザーのログイン情報を破棄する list9.11
	def forget
		update_attribute(:remember_digest, nil)
	end

	# 渡されたトークンがダイジェストと一致したらtrueを返す list11.26
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	#アカウントを有効にする list11.36
	def activate
		update_attribute(:activated,	true)
		update_attribute(:activated_at,	Time.zone.now)
		# update_columns(activated: true ,activated_at:Time.zone.now) #11.3.3演習１の回答

	end

	# 有効化用のメールを送信する
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# パスワード再設定 list12.6
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# パスワード再設定のメールを送信するlist12.6
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	#パスワード再設定の期限が切れている場合はtrueを返すlist12.17
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	# list14.41,43,44,46
	# ユーザーのステータスフィードを返す
	def feed 
		following_ids = 	"SELECT followed_id FROM relationships 
							WHERE	follower_id = :user_id"
		Micropost.where("user_id IN (#{following_ids})
						OR user_id = :user_id", user_id: id)
						.includes(:user, image_attachment: :blob)
	end

	#ユーザーをフォローするlist14.10
	def follow(other_user)
		following << other_user unless self == other_user
	end

	# ユーザーをフォロー解除する
	def unfollow(other_user)
		following.delete(other_user)
	end

	# 現在のユーザーが他のユーザーをフォローしていればtrueを返す
	def following?(other_user)
		following.include?(other_user)
	end
		
	private

	# メールアドレスをすべて小文字にする list11.3
	def downcase_email
		self.email = email.downcase
	end

	#有効化トークンとダイジェストを作成および代入する list11.3
	def create_activation_digest
		self.activation_token	= User.new_token
		self.activation_digest	= User.digest(activation_token)
	end

end
