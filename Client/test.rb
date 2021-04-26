require 'net/http'
require 'json'

@server_url = "http://138.68.152.226:3000"

def sendQuery(uid)

    uri = URI("http://138.68.152.226:3000/students?uid=" + uid)
    res = JSON.parse(Net::HTTP.get(uri))



  end


if __FILE__ == $0

  sendQuery('A677A214')
end
