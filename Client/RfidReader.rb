require 'gtk3'

class RfidReader < GLib::Object
  type_register
  define_signal("tag", GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize(reader_hardware)
    super()
    case reader_hardware
    when 'PN532'
      require_relative 'readers/pn532' #Nueno
      @rfid = PN532.new
    when 'Mfrc522'
      require_relative 'readers/Mfrc522' #Ignasi
      @rfid = Mfrc522.new
    when 'Rfid_USB'
      require_relative 'readers/Rfid_USB' #Nacho
      @rfid = Rfid_USB.new
    when 'Rfid_Lucas'
      require_relative 'readers/Rfid_Lucas' #Lucas
      readers = NFC::Reader.all
      @rfid  = Rfid_Lucas.new(readers[0])  
    when 'emulator'
      require_relative 'readers/reader_emulator'
      @rfid = ReaderEmulator.new
    end

    thr = Thread.new{
      while(1)
        read_uid(@rfid)
        sleep(0.8)
      end
    }

    def read_uid(rfid)
      uid = rfid.read_uid
      signal_emit('tag', uid)
    end

    def signal_do_tag(str)
    end

  end
end

if __FILE__ == $0
  reader = RfidReader.new('emulator')
  reader.signal_connect("tag") do |sender, uid|
    puts uid
  end
  Gtk.main

end

