require 'net/http'

server = '127.0.0.1'
route = ""
port = 3000
puts Net::HTTP.get("#{server}/#{route}", '/', 3000)
puts"hola"