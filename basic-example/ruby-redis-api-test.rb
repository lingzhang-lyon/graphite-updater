# some testing for ruby redis api
require 'redis'

$redis = Redis.new

$redis.hmset('user:007', :name, 'Antonio', :busy, 'maybe', :ping, 'pong')
puts $redis.hgetall('user:007')

$redis.hmset("hash", "f1", "v1", "f2", "v2")
puts $redis.hgetall('hash')

$redis.hset('id_app','1', 'testapp')
puts $redis.hgetall('id_app')
puts $redis.hget('id_app', '1')