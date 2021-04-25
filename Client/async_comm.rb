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

  def sendQuery(uid)
    GLib::Idle.add do
      uri = URI("http://138.68.152.226:3000/students?uid=" + uid)
      res = JSON.parse(Net::HTTP.get(uri))
      signal_emit('response', res)
    end

  end

  def signal_do_response(name)
    puts 'Catched response'
  end

end

if __FILE__ == $0

  comms = AsyncComm.new
  comms.sendQuery('A677A214')

  comms.signal_connect('response') do |sender, name|
    puts name
  end

  Gtk.main
end