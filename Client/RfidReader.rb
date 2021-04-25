require 'gtk3'

require_relative 'readers/pn532' #Nueno

class RfidReader < Glib::Object
    type_register
    define_signal('tag', nil, nil, nil, String)

    def initialize (rfid_hardware, display_hardware)
        super()
        case rfid_hardware
        when 'PN532'
            @rfid = PN352.new()
        when nil
            @rfid = nil
        end
    end

    def read_uid
    #start reading thread
        Thread.new do 
            uid = @rfid.read_uid
            signal_emit('tag', uid) #emit 'tag' signal on behalf of main thread
        end
    end
end


if  __FILE__== $0
  rf = RfidReader.new('PN532',nil)
  def on_tag(_rfid, uid)
      puts uid
  end
  rf.signal_connect('tag', :on_tag)
end


=begin
  rfid1 = RfidReader.new () #falta passar-li per parametre el rfid.new que es vulgui utilitzar
  aquí aniria tot el tema de la finestra relacionada amb rfid
  rfid1.signal_connect('tag', &win.method(:on_tag)) connexió senyal-finestra
=end

