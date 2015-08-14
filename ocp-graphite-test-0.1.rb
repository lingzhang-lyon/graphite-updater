require 'sinatra'
require "sinatra/config_file"
require 'redis'
require 'active_record'
require_relative './graphite-updater-0.1'
config_file 'config/graphite.yml'

###### for testing with redis
def test_update_from_redis
    $redis = Redis.new
    $redis.hset('id_app','1', 'intuit.FPS')
    puts $redis.hgetall('id_app')
    puts $redis.hget('id_app', '1')

    gu = GraphiteUpdater.new(settings)
    gu.update_graphite('1','1','8', 'redis')
end

get '/test/redis' do   
    test_update_from_redis
end
######

### for testing with sqlite

# before the test, need to run following SQL in sqlite3 first
# $ sqlite3 ocp.db
#> CREATE TABLE "app_offerings" ("app_sys_id" TEXT NOT NULL, "app_name" TEXT, PRIMARY KEY("app_sys_id"));
#> insert into app_offerings values ("1", "intuit.FPS");
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'ocp.db')
class AppOfferings < ActiveRecord::Base
end 

def test_update_from_sqlite
    gu = GraphiteUpdater.new(settings)
    gu.update_graphite('1','1','9', 'sqlite')
end

get '/test/sqlite' do
    test_update_from_sqlite  
end



# put '/test/status/api/v1/checks/id/update' do
#     puts params
#     if !params.key? 'id' 
#         result = "{ 'error' : 'Please provide check ID.'}"
#     elsif !params.key? 'status'  
#         result = "{ 'error' : 'Please provide check's status.'}"
#     else
#        test_update_from_sqlite 
#     end
# end