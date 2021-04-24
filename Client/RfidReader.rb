require 'gtk3'

require_relative 'rfid.rb' #Nueno
require_relative 'primer_puzzle.rb' #Ignasi
require_relative 'main.rb' #Lucas (millor canviar-li el nom, portara confusió)
require_relative 'Rfid_USB.rb' #Nacho



class RfidReader < Glib::Object
    type_register

    define_signal('tag', nil, nil, nil, String)

    def initialize (rfid)
        super ()
        @rfid = rfid
        #store rfid
    end


    def read_uid
    #start reading thread
        Thread.new do 
            uid = @rfid.read_uid
            tag.signal_emit('On_tag')
            #emit 'tag' signal on behalf of main thread
        end
    end
end

rfid1 = RfidReader.new () #falta passar-li per parametre el rfid que es vulgui utilitzar
rfid1.read_uid