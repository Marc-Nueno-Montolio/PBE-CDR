require 'mfrc522' 
require 'securerandom'

#r variable declared as class variable to solve problems at segon_puzzle. Thank you, Marc Nueno. https://github.com/Marc-Nueno-Montolio ;)

class Mfrc522
	@@r = MFRC522.new
	def read_uid
		quedat = 1;
		puts "Si us plau, introdueixi la seva targeta sobre el lector"
		$stdout.flush
		while(quedat==1) 
			begin
				@@r.picc_request(MFRC522::PICC_REQA) #Establiment de perifèric
				uid_dec, que = @@r.picc_select           #Intent de lectura (pot llençar CommunicationError degut a timeout)
			rescue CommunicationError => e             #Capturem raising (si entra aquí s'està assolint timeout)...				           
			else					   #Ha capturat uid. Sortim
				quedat = 0			   
			end
		end
		uid = Array.new				           #Vector hexadecimal
		uid_dec.length.times do |i|
			uid[i]=uid_dec[i].to_s(16)
		end
		
		return uid.join().upcase			   #Retornem uid capturat en forma de string concatenat, en majúscules
	end
end

if __FILE__ == $0
	rf = Mfrc522.new()					
	uid = rf.read_uid
	puts uid
end