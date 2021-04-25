require "net/http"
require "json"
require "gtk3"
@server_url = "http://138.68.152.226:3000"

class AsyncComm < GLib::Object
  type_register
  define_signal('response', GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize
    super
  end

  def sendQuery(uid)
    Thread.new do
      uri = URI(@server_url + "/students?uid=" + uid)
      res = JSON.parse(Net::HTTP.get(uri))
      name = res['name']
      signal_emit('response', name)
    end

  end

  def signal_do_response(name)
    puts 'OK'
  end

end

if __FILE__ == $0

  comms = AsyncComm.new
  comms.sendQuery('A677A214')

  comms.signal_connect('response') do |sender, name|
    puts name
  end
end