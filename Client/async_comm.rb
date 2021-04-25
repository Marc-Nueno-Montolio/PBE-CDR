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
      uri = URI("http://127.0.0.1:8080/#{query}?uid=#{uid}")
      response = JSON.parse(Net::HTTP.get(uri))
    end
    signal_emit(response)
  end

  def signal_do_response(response)
  end

end

if __FILE__ == $0

  comms = AsyncComm.new

  comms.sendQuery('A677A214','tasks')

  comms.signal_connect('response') do |sender, response|
    puts response.to_s
  end
end