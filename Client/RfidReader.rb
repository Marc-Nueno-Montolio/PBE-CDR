require 'gtk3'
require_relative 'readers/pn532' #Nueno

class RfidReader < GLib::Object
  type_register
  define_signal('tag', GLib::Signal::RUN_FIRST, nil, nil, String)
end



if __FILE__ == $0
  reader = RfidReader.new()

  GLib::Idle.add do
    thr = Thread.new{
      while(1)
        uid = gets
        if(uid == '1')
          reader.signal_emit('tag')
        end
      end
    }

  end

  reader.signal_connect('tag')  do |sender|
    puts 'OK'
  end


  Gtk.main


end

=begin
  rfid1 = RfidReader.new () #falta passar-li per parametre el rfid.new que es vulgui utilitzar
  aquí aniria tot el tema de la finestra relacionada amb rfid
  rfid1.signal_connect('tag', &win.method(:on_tag)) connexió senyal-finestra
=end

