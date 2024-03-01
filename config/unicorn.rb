#　デプロイ対応
# Rails のルートパスを求める
app_path = File.expand_path('../../', __FILE__)

# Unicorn は複数のワーカーで起動するのでワーカー数を定義
worker_processes 1

# Unicorn の起動コマンドを実行するディレクトリを指定します
working_directory app_path

# プロセスの停止などに必要なPIDファイルの保存先を指定
pid "#{app_path}/tmp/pids/unicorn.pid"

# ポートを設定
listen "#{app_path}/tmp/sockets/unicorn.sock"

# Unicorn のエラーログと通常ログの位置を指定
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

# 接続タイムアウト時間
timeout 60

# Unicorn の再起動時にダウンタイムなしで再起動を行う
preload_app true

check_client_connection false

run_once = true

# USR2 シグナルを受けると古いプロセスを止める
before_fork do |server, worker|
defined?(ActiveRecord::Base) &&
	ActiveRecord::Base.connection.disconnect!

if run_once
	run_once = false
end

old_pid = "#{server.config[:pid]}.oldbin"
if File.exist?(old_pid) && server.pid != old_pid
	begin
	sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
	Process.kill(sig, File.read(old_pid).to_i)
	rescue Errno::ENOENT, Errno::ESRCH => e
	logger.error e
	end
end

end

after_fork do |_server, _worker|
	defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end