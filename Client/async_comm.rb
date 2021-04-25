require "net/http"
require "json"
require "gtk3"
@server_url = "http://138.68.152.226:3000"

class AsyncComm < GLib::Object
  type_register
  define_signal('queryResponse', GLib::Signal::RUN_FIRST, nil, nil, Hash)
  define_signal('studentResponse', GLib::Signal::RUN_FIRST, nil, nil, String, String)

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

  def get_student(uid)
    GLib::Idle.add do
      uri = URI(@server_url + "/students?uid=" + uid)
      res_hash = JSON.parse(Net::HTTP.get(uri))
      if res_hash.key?("name")
        puts("ESTUDIANT: " +res_hash["name"] +", UID:" + res_hash["uid"])  #debugging
        signal_emit_('studentResponse', res_hash["name"], res_hash["uid"])
      else
        puts("No existeix l'estudiant")                                    #debugging
        signal_emit_('studentResponse', nil, nil)
      end
    end

  end

  def signal_do_studentResponse(res)
  end

  def signal_do_queryResponse(res)
  end

end

if __FILE__ == $0

  comms = AsyncComm.new
  comms.sendQuery('A677A214','tasks')

  comms.signal_connect('queryResponse') do |sender, res|
    puts res
  end

  Gtk.main
end