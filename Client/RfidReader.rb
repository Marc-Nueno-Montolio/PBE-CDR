require 'gtk3'
require_relative 'readers/pn532' #Nueno

class RfidReader < GLib::Object
  type_register
  define_signal("tag", GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize
    super
    thr = Thread.new {
      while (1)
        str = gets
        signal_emit('tag', str)
      end
    }

    def signal_do_tag(str)
    end

  end
end

if __FILE__ == $0
  reader = RfidReader.new()

  reader.signal_connect("tag") do |sender, str|
    puts str
  end

  Gtk.main

end

=begin
  rfid1 = RfidReader.new () #falta passar-li per parametre el rfid.new que es vulgui utilitzar
  aquí aniria tot el tema de la finestra relacionada amb rfid
  rfid1.signal_connect('tag', &win.method(:on_tag)) connexió senyal-finestra
=end

