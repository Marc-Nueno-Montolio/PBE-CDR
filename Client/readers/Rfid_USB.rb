require 'io/console'

class Rfid_USB
	def readUid
		uid = STDIN.noecho(&:gets).chomp.to_i  #Lee el numero introducido mediante el lector de targetas y lo almacena en un string. La funcion chomp se encarga de borrar el salto de línea. to_i pasa el string a un entero
		uid_hex = uid.to_s(16) #Pasa el entero a un string con los numeros en la base puesta entre parentesis (en nuestro caso, hexadecimal)
		if uid_hex.length <= 7 #Añado este condicional para asegurarme de que el uid es de 8 dígitos
			uid_hex = "0" + uid_hex
		end
		return uid_hex		
	end
end
if __FILE__ == $0
	rf = Rfid_USB.new
	puts "Escanea tu targeta"
	uid = rf.readUid
	puts"Tu id es: "
	puts uid.upcase
end