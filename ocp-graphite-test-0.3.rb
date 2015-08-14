require 'json'
require 'sinatra'
require "sinatra/config_file"
config_file 'config/graphite.yml'

require_relative './graphite-updater-0.3'
gu = GraphiteUpdater.new(settings) 

###### test for GraphiteUpdater
get '/test/fps' do  
    gu.update("intuit.FPS.check1.responsetime", rand(8..15))
end

get '/test/fps/1' do  
    result = Array.new    	
	result.push gu.update("intuit.FPS.check1.responsetime", rand(8..15))
	result.push gu.update("intuit.FPS.check1.status", 0)
	result = result.to_json
	result
end

get '/test/fps/2' do 
    metrics_data = { 
		"intuit.FPS.check1.responsetime" => rand(1..5), "intuit.FPS.check1.status" =>1,
		"intuit.FPS.check2.responsetime" => rand(8..15), "intuit.FPS.check2.status" =>0
	} 
    result = Array.new  
    metrics_data.each { |key, value|
    	result.push gu.update(key, value)

    }  	
	result = result.to_json
	result
end
    

get '/test/qbo' do
	metrics_data2 = { 
		"intuit.QBO.check1.responsetime" => rand(1..5), "intuit.QBO.check1.status" =>1,
		"intuit.QBO.check2.responsetime" => rand(8..15), "intuit.QBO.check2.status" =>0
	}  
	gu.update_with_hash(metrics_data2)
end


########## test for status check update

require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'ocp.db')
class AppOfferings < ActiveRecord::Base
end 
class UrlChecks < ActiveRecord::Base
end


put '/status/api/v1/checks/id/update' do
	# back-end validatoin of key and values
	puts params
	if !params.key? 'id' 
		result = "{ 'error' : 'Please provide check ID.'}"
	elsif !params.key? 'status'  
		result = "{ 'error' : 'Please provide check's status.'}"
	else
		check_id = params['id']
		check = UrlChecks.find_by check_id: check_id
		app_sys_id = check.app_sys_id
	    app = AppOfferings.find_by app_sys_id: app_sys_id
        app_name = app.app_name

		metrics_data2 = { 
			"intuit.#{app_name}.check-#{check_id}.response" => params['response'],
			"intuit.#{app_name}.check-#{check_id}.status" => params['status']
		}  
		gu.update_with_hash(metrics_data2)
	end
end

# before the test, need to run following SQL in sqlite3 first
# $ sqlite3 ocp.db < ocp-test-sql.sql
# then can test with curl or postman with put api
# with id=c001, response=10, status=1



