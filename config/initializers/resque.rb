if Rails.env.production?
  require 'resque'
  redis_url = "redis://redistogo:1a997ec7ce05b6dcafcd7929bbd46c9e@chubb.redistogo.com:9405"
  uri = URI.parse(redis_url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = REDIS
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
elsif Rails.env.development?
  require 'resque'
  redis_url = 'localhost:6379'
  uri = URI.parse(redis_url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  Resque.redis = REDIS
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end