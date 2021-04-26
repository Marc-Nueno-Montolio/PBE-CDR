require "net/http"
require "json"
require "gtk3"

class AsyncComm < GLib::Object
  type_register
  define_signal('queryResponse', GLib::Signal::RUN_FIRST, nil, nil, Hash)
  define_signal('studentResponse', GLib::Signal::RUN_FIRST, nil, nil, String, String)

  def initialize
    super

  end

  def sendQuery(uid, query)
    GLib::Idle.add do
      if query.include? '?'
        uri = URI("http://138.68.152.226:3000/#{query}&uid=#{uid}")
      else
        uri = URI("http://138.68.152.226:3000/#{query}?uid=#{uid}")
      end
      res = JSON.parse(Net::HTTP.get(uri))
      signal_emit('queryResponse', res)
    end
  end

  def get_student(uid)
    GLib::Idle.add do
      uri = URI("http://138.68.152.226:3000/students?uid=#{uid}")
      res = JSON.parse(Net::HTTP.get(uri))
      if res.key?("name")
        signal_emit('studentResponse', res["name"], res["uid"])
      else
        puts("No existeix l'estudiant") #debugging
        signal_emit('studentResponse', nil, nil)
      end
    end
  end

  def signal_do_studentResponse(name, uid) end

  def signal_do_queryResponse(res) end

end

if __FILE__ == $0

  comms = AsyncComm.new

  comms.sendQuery('A677A214','tasks')
  #comms.get_student('A677A214')

  comms.signal_connect('queryResponse') do |sender, res|
    puts res
  end

  Gtk.main
end