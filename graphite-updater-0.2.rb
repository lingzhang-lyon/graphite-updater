require 'graphite-api'
require 'redis'

class GraphiteUpdater

    def initialize(settings)
        @graphite_server = settings.graphite_server
        @graphite_port = settings.graphite_port
        @client = GraphiteAPI.new( graphite: "#{@graphite_server}:#{@graphite_port}")
    end
 
    def update_graphite(metrics_data) # not working
        # metrics_data is a hash         
        metrics_data.each { |metrics_name, metrics_value|
            @client.metrics metrics_name => metrics_value
        }
        
    end

    def update_graphite_test  # not working
        # metrics_data is a hash 
        metrics_data = Hash.new 
        metrics_data = { "intuit.FPS.responsetime" => 11.3, "intuit.FPS.status" =>0 }       
        metrics_data.each_pair { |metrics_name, metrics_value|
            @client.metrics "#{metrics_name} => #{metrics_value}"
        }
        
    end

    def update_graphite_test2  # working     
        @client.metrics "intuit.FPS.responsetime" => 11.3
        
    end




end





