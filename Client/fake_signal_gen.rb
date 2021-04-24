require "gtk3"

class Device < Gtk::Widget
    
    def initialize 
        thr = Thread.new{
            str = gets
            this.signal_emit('uid_read', str)
        }
    end

    define_signal{
        'uid_read',
        nil,
        nil,
        String 
    }
end
