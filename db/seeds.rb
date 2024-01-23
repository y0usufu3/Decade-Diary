#list11.4 有効化
# activated: true
# activated_at: Time.zone.now 

#list10.44
#メインのサンプルユーザーを１人作成する
User.create!(	name:	"Example User",
				email:	"example@railstutorial.org",
				password: 				"foobar",
				password_confirmation:	"foobar",
				admin: true,
				activated: true,
				activated_at: Time.zone.now)
# 追加のユーザーをまとめて生成する
99.times do |n|
	name	= Faker::Name.name
	email	= "example-#{n+1}@railstutorial.org"
	password = "password"
	User.create!(	name:	name,
					email: email,
					password:				password,
					password_confirmation:	password,
					activated: true,
					activated_at: Time.zone.now)
end

#ユーザーの一部を対象にマイクロポストを生成するlist13.26
users = User.order(:created_at).take(6)
50.times do
	content = Faker::Lorem.sentence(word_count: 5)
	users.each { |user| user.microposts.create!(content: content) }
end

#　ユーザーフォローのリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }


#ユーザーの一部を対象に日記を生成するlist13.26の応用
users = User.order(:created_at).take(3)
3600.times do |days| 
	title = Faker::Lorem.sentence(word_count: 2) 
	content = Faker::Lorem.sentence(word_count: 5)
    start_time = Time.now.ago("#{days}".to_i.days)
	users.each { |user| user.diaries.create!(start_time: start_time, title: title, content: content) }
end
	