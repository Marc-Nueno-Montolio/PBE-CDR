require 'gtk3'
require_relative 'readers/pn532' #Nueno

class RfidReader < GLib::Object
  type_register
  define_signal("tag", GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize(reader_hardware)
    super()
    case reader_hardware
    when 'PN532'
      @rfid = PN532.new
    end

    GLib::Idle.add do
      while(1)
        read_uid(@rfid)
      end

    end

    def read_uid(rfid)
      uid = rfid.read_uid
      signal_emit('tag', uid)
    end

    def signal_do_tag(str) end

  end
end

if __FILE__ == $0
  reader = RfidReader.new('PN532')

  reader.signal_connect("tag") do |sender, str|
    puts str
  end

  Gtk.main

end

