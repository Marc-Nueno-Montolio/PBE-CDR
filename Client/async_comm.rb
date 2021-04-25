require "net/http"
require "json"
require "gtk3"
@server_url = "http://138.68.152.226:3000"

class AsyncComm < GLib::Object
  type_register
  define_signal('response', GLib::Signal::RUN_FIRST, nil, nil, Hash)

  def initialize
    super

  end

  def sendQuery(uid, query)
    GLib::Idle.add do
      uri = URI("http://138.68.152.226:3000/#{query}?uid=" + uid)
      res = JSON.parse(Net::HTTP.get(uri))
      signal_emit('response', res)
    end
  end

  def signal_do_response(res)
  end

end

if __FILE__ == $0

  comms = AsyncComm.new
  comms.sendQuery('A677A214','tasks')

  comms.signal_connect('response') do |sender, res|
    puts res
  end

  Gtk.main
end