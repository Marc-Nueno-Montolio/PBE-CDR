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
      uri = URI(@server_url + "#{query}?uid=" + uid)
      res = JSON.parse(Net::HTTP.get(uri))
      signal_emit('queryResponse', res)
    end
  end

  def get_student(uid)
    GLib::Idle.add do
      uri = URI(@server_url + "/students?uid=" + uid)
      res_hash = JSON.parse(Net::HTTP.get(uri))
      if res_hash.key?("name")
        name = res_hash["name"]
        uid = res_hash["uid"]
        signal_emit('studentResponse', name, uid)
      else
        puts("No existeix l'estudiant")
      end
    end

  end

  def signal_do_studentResponse(name, uid) end

  def signal_do_queryResponse(res) end

end

if __FILE__ == $0

  comms = AsyncComm.new
  #comms.sendQuery('A677A214','tasks')
  comms.get_student('A677A214')

  comms.signal_connect('queryResponse') do |sender, res|
    puts res
  end

  comms.signal_connect('studentResponse') do |sender, name, uid|
    puts "Student: " + name + " uid: " + uid
  end

  Gtk.main
end