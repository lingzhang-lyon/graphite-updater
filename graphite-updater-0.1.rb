require 'graphite-api'
require 'redis'
# require 'active_record'

class GraphiteUpdater

    def initialize(settings)
        @graphite_server = settings.graphite_server
        @graphite_port = settings.graphite_port
        @local_store = settings.local_store
    end
 
    def update_graphite(id, status, responsetime)

        client = GraphiteAPI.new( graphite: "#{@graphite_server}:#{@graphite_port}")

        if(@local_store == 'redis')
            # get app name by id for the name space for metrics
            appName = get_app_name_from_redis(id);
        else
            appName = get_app_name_from_sqlite(id);
        end

        client.metrics(
          appName+".status"  => status,
          appName+".responsetime" => responsetime
        )
    end


    def update_graphite(id, status, responsetime, store)

        client = GraphiteAPI.new( graphite: "#{@graphite_server}:#{@graphite_port}")

        if(store == 'redis')
            # get app name by id for the name space for metrics
            appName = get_app_name_from_redis(id);
        else
            appName = get_app_name_from_sqlite(id);
        end

        client.metrics(
          appName+".status"  => status,
          appName+".responsetime" => responsetime
        )
    end

    def get_app_name_from_redis(id)
        # get from redis
        @r = Redis.new        
        app_name = @r.hget('id_app',id)
        return app_name
        
    end


    def get_app_name_from_sqlite(id)
        # get from sqlite     
        app = AppOfferings.find_by app_sys_id: id
        return app.app_name
        
    end

end





