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
            tag.signal_emit('tag')
            #emit 'tag' signal on behalf of main thread
        end
    end
end


#if  __FILE__== $0
#    rfid1 = RfidReader.new () #falta passar-li per parametre el rfid.new que es vulgui utilitzar
#    aquí aniria tot el tema de la finestra relacionada amb rfid
#    rfid1.signal_connect('tag', &win.method(:on_tag)) connexió senyal-finestra
#    ... etc
#end