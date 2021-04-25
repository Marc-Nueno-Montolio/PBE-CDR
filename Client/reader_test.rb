require "gtk3"
class ReaderTest
  type_register
  define_signal('tag', GLib::Signal::RUN_FIRST, nil, nil, String)

  def initialize (rfid)
    super()
    @rfid = rfid
  end

  def read_uid()
    #start reading thread
    Thread.new do
      uid = gets
      self.signal_emit('tag', uid) #emit 'tag' signal on behalf of main thread
    end
  end
end
