require "gtk3"
class ReaderTest < Gtk::Widget
  type_register('tag')
  define_signal('tag', GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize ()
    super()
  end

  def read_uid()
    #start reading thread
    Thread.new do
      uid = gets
      signal_emit('tag', uid) #emit 'tag' signal on behalf of main thread
    end
  end

  def signal_do_tag()
  end
end


if __FILE__ == $0
  reader = ReaderTest.new()
  GLib::Idle.add do
    reader.read_uid
  end

  reader.signal_connect('tag') do
    puts uid
  end

  Gtk.main

end