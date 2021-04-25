require 'net/http'
require 'json'
require 'gtk3'

@server_url = "http://138.68.152.226:3000"
#retorna el resulat del query
def get_query(query,uid)
    uri = URI("http://138.68.152.226:3000/students?uid=#{uid}")
    return JSON.parse(Net::HTTP.get(uri))
end
# Retorna el resultat del query
def get_query_async(query, uid, handler)
    Thread.new {
        uri = URI(@server_url + "/students?uid=" + uid+'/'+query)
        res_hash = JSON.parse(Net::HTTP.get(uri))
        return res_hash
    }
end

#Retorna el nom i uid si la uid esta mal retorna null
def get_user(uid)
    uri = URI(@server_url + "/students?uid=" + uid)
    res_hash = JSON.parse(Net::HTTP.get(uri))
    if res_hash.key?("name")
        puts("ESTUDIANT: " +res_hash["name"] +", UID:" + res_hash["uid"])  #debugging
        return res_hash["name"], res_hash["uid"]

    else
        puts("No existeix l'estudiant")                                    #debugging
        return nil, nil

    end
end

