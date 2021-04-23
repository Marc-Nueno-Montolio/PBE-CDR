require 'net/http'
require'json'





def get_user(uid) #Retorna el nom i uid si la uid esta mal retorna null
    url="http://138.68.152.226:3000/students?uid="+uid
	uri = URI(url)
    res_hash = JSON.parse(Net::HTTP.get(uri))
    if res_hash.key?("name")
        return res_hash["name"],res_hash["uid"]

    else
        puts("No existeix l'estudiant")
        return null, null

    end

end

puts(get_user("A677A214"))