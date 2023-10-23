class User < ApplicationRecord
	attr_accessor :remember_token
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255},format: { with: VALID_EMAIL_REGEX },uniqueness: true
	has_secure_password
	#list10.13allow_nil追加
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true 

	#渡された文字列のハッシュ値を返す #8.2.61追加
	# def User.digest(string)
	# def self.digest(string) #リスト9.4
	class << self #list 9.5 上記コメント２つと同じ
		def digest(string)#list 9.5
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
														BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		#ランダムなトークンを返す #9.1.1
		# def User.new_token#9.1.1
		# def self.new_token #リスト9.4
		def new_token #リスト9.5 上記コメント２つと同じ
			SecureRandom.urlsafe_base64
		end
	end #リスト9.5

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

end
