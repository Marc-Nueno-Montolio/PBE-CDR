require 'net/http'
require'json'

file = File.read('./prova.json')
head = 'http://'
serverip = '138.68.152.226'
route = "students?"
port =':' + '3000'
uid = 'uid=' + 'A677As214'

data_hash = JSON.parse(file)
data_hash['books']['1'] = 'I, Robot'
data_hash['books']['2'] = 'The Caves of Steel'
File.write('./prova.json', JSON.dump(data_hash))

url=head+serverip+port+'/'+route+uid

uri = URI(url)
res_hash = JSON.parse(Net::HTTP.get(uri))
if res_hash.key?('name')
    puts res_hash['name']
    puts res_hash['uid']
    
else
    puts("No existeix l'estudiant")

end
