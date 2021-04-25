require 'gtk3'
require_relative 'readers/reader_emulator'
require_relative 'readers/pn532' #Nueno
require_relative 'readers/Mfrc522' #Ignasi
require_relative 'Rfid_Lucas' #Lucas
require_relative 'readers/Rfid_USB' #Nacho


class RfidReader < GLib::Object
  type_register
  define_signal("tag", GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize(reader_hardware)
    super()
    case reader_hardware
    when 'PN532'
      @rfid = PN532.new
    when 'Mfrc522'
      @rfid = Mfrc522.new
    when 'Rfid_USB'
      @rfid = Rfid_USB.new
    when 'Rfid_Lucas'
      readers = NFC::Reader.all
      @rfid  = Rfid_Lucas.new(readers[0])  
    when 'emulator'
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

