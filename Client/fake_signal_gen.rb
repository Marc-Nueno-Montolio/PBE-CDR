require "gtk3"

class Device 

    def initialize 
        @gs = Gen_Signal.new()
        thr = Thread.new{
            while(1)
                str = gets
                @gs.senyal(str)
            end
        }
    end

    def get_gs
        return @gs
    end
end

class Gen_Signal < Gtk::Widget
    type_register("Gen_Signal")
    define_signal(
        "uid_read",
        GLib::Signal::RUN_FIRST,
        nil,
        nil,
        String 
    )
    def initialize
        super
    end

    def senyal(str)
        signal_emit('uid_read', str)
    end

    def signal_do_uid_read(str)
        return str
    end

end
