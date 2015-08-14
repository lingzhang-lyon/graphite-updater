require 'graphite-api'

class GraphiteUpdater

    def initialize(settings)
        @graphite_server = settings.graphite_server
        @graphite_port = settings.graphite_port
        @client = GraphiteAPI.new( graphite: "#{@graphite_server}:#{@graphite_port}")
        GraphiteAPI::Logger.init(
          :level => :debug,
          :std   => 'logger.out' # or STDOUT | STDERR
        )
    end
 
    def update(key, value)
        #@client.metrics "#{key} => #{value}"
        @client.metrics key => value
    end

    def update_with_hash(metrics_data)
        @client.metrics metrics_data
    end


end





