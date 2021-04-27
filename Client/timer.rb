require "gtk3"
class Timer < GLib::Object
    type_register
    define_signal("timeout", GLib::Signal::RUN_FIRST, nil, nil)


    def initialize(time_ref)
        super()
        @time_ref = time_ref
        @thr = nil
    end

    def start
        @thr = Thread.new{
            t_init = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            while(Process.clock_gettime(Process::CLOCK_MONOTONIC) - t_init <= @time_ref )
                #Esperem...
            end
            #TIMEOUT ASSOLIT. 
            signal_emit("timeout")
        }
    end

    def stop
        Thread.kill(@thr)
    end

    def signal_do_timeout
        puts "TIMEOUT. Log-out."
    end
end