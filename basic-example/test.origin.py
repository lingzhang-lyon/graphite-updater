import platform
import socket
import time
import getopt
import sys


CARBON_SERVER = 'localhost'
CARBON_PORT = 2003
DELAY = 15  # secs


def get_loadavgs():
    with open('loadavg') as f:
        return f.read().strip().split()[:3]

def main(argv):
   inputfile = ''
   outputfile = ''
   usage='test.py -t <type> -n <name> -v <value>'
   try:
      opts, args = getopt.getopt(argv,"t:n:v:",["type=","name=","value="])
   except getopt.GetoptError:
      #print 'test.py -t <type> -n <name> -v <value>'
      print usage
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -i <inputfile> -o <outputfile>'
         sys.exit()
      elif opt in ("-t", "--type"):
         types = arg
      elif opt in ("-n", "--name"):
         name = arg
      elif opt in ("-v", "--value"):
         value = arg
   print 'Types "', types
   print 'Name  is "', name
   print 'Value  is "', value
   ret=[]
   ret.append(types)
   ret.append(name)
   ret.append(value)
   return ret

def send_msg(message):
    print 'sending message:\n%s' % message
    sock = socket.socket()
    sock.connect((CARBON_SERVER, CARBON_PORT))
    sock.sendall(message)
    sock.close()

# Message sent:
#system.SDGL121d699e6-local.loadavg_1min 0.00 1433972527
#system.SDGL121d699e6-local.loadavg_5min 0.01 1433972527
#system.SDGL121d699e6-local.loadavg_15min 0.01 1433972527

# Sample output from SBO wily script
#        echo "<metric type=\"IntCounter\" name=\"APPSTATS:`echo $line`-users\" value=\"$rslt\"/>";
#        echo "<metric type=\"StringEvent\" name=\"BUILD-NUMBER:`echo $line`-version\" value=\"$version\"/>";
#echo "<metric type=\"IntCounter\" name=\"APPSTATS:`echo $line`-users\" value=\"$rslt\"/>";
#<metric type="IntCounter" name="APPSTATS:abc-users" value=""/>


if __name__ == '__main__':
    node = platform.node().replace('.', '-')
    result=main(sys.argv[1:])
    #while True:
    timestamp = int(time.time())
    loadavgs = get_loadavgs()
    lines = [
        'system.%s.loadavg_1min %s %d' % (node, loadavgs[0], timestamp),
        'system.%s.loadavg_5min %s %d' % (node, loadavgs[1], timestamp),
        'system.%s.loadavg_15min %s %d' % (node, loadavgs[2], timestamp),
        'app.%s.%s.%s %s %d' % (node, result[0], result[1], result[2], timestamp)
    ]
    message = '\n'.join(lines) + '\n'
    print message
    send_msg(message)
    #time.sleep(DELAY)