

require 'graphite-api'

client = GraphiteAPI.new( graphite: 'localhost:2003' )

client.metrics "webServer.web01.loadAvg" => 10.7
# => webServer.web01.loadAvg 10.7 time.now.to_i

client.metrics(
  "webServer.web01.loadAvg"  => 10.7,
  "webServer.web01.memUsage" => 40
)

# client.metrics(
#   "intuit.ocp.app1.status"  => 1,
#   "intuit.ocp.app1.responsetime" => 10
# )




