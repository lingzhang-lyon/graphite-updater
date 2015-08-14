require 'sinatra'
require "sinatra/config_file"
require 'redis'
require 'active_record'
require_relative './graphite-updater-0.2'
config_file 'config/graphite.yml'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'ocp.db')
class AppOfferings < ActiveRecord::Base
end 


get '/test/sqlite' do
    metrics_data = { "intuit.FPS.responsetime"=>11.3 }
    gu = GraphiteUpdater.new(settings)
    gu.update_graphite(metrics_data)
end

get '/test/sqlite/1' do
    gu = GraphiteUpdater.new(settings)
    gu.update_graphite_test
end

get '/test/sqlite/2' do
    gu = GraphiteUpdater.new(settings)
    gu.update_graphite_test2
end
