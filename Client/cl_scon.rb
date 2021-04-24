require 'net/http'
require 'json'
require "gtk3"

@@server_url = "http://138.68.152.226:3000"

# Retorna el resultat del query
def get_query_async(query, handler)
    #TODO: retornar el resultat del query amb un handler
end

#Retorna el nom i uid si la uid esta mal retorna null
def get_user(uid)
    uri = URI(@@server_url + "/students?uid=" + uid)
    res_hash = JSON.parse(Net::HTTP.get(uri))
    if res_hash.key?("name")
        return res_hash["name"], res_hash["uid"]

    else
        puts("No existeix l'estudiant")
<<<<<<< HEAD
        return nil, nil

=======
        return null, null
>>>>>>> a220e8d90a8b3871ef7df440827f66c179dfde40
    end
end

# Retorna el nom i uid asíncronament mitjançant un handler
def get_user_async(uid, handler)
    Thread.new {
      uri = URI(@@server_url + "/students?uid=" + uid)
      res_hash = JSON.parse(Net::HTTP.get(uri))
      if res_hash.key?("name")
          GLib::Idle.add { handler(res_hash["name"], res_hash["uid"]) }
          return res_hash["name"], res_hash["uid"]
      else
          puts("No existeix l'estudiant")
          handler(null)
          return false
      end
    }
end


puts(get_user("A677A214"))