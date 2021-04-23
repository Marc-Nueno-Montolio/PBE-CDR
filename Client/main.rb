require "gtk3"
require_relative 'window.rb'


scenario = 0;
    #--NON-LOGGED SCENARIO--
    #0 Escenari A (log in, esperant lectura UID per enviar)     buttonA=null, buttonB=null
    #1 Escenari A (log fail, apareix botó per tornar a log in)  buttonA= Botó reintentar, buttonB=null

    #--LOGGED SCENARIOS--
    #2 Escenari B (Introducció dades per enviar a servidor. Si rep error, es mostrarà en aquest mateix estat. buttonA=enviar buttonB=logout
    #3 Escenari C (Mostra de dades rebudes per servidor. buttonA=Tornar escenari B buttonB=logout
sf = Set_Finestra.new()

sf.go_first_escenario








#GESTIÓ SENYALS
sf.buttonA.signal_connect("clicked"){
    case scenario
        when 1
            scenario = 0
            sf.go_first_escenario
        when 2
            #Enviar string a funció de contacte amb servidor. No implementat encara.
        when 3 
            scenario = 2
            sf.go_second_scenario
        else
            Gtk.main_quit #No hauria d'entrar mai aquí. FATAL ERROR
    end
}

sf.buttonB.signal_connect("clicked"){
    case scenario
        when 2..3
            #Caldria enviar ordre a funció de contacte amb servidor de logout
            scenario = 0
            sf.go_first_escenario
        else
            Gtk.main_quit #No hauria d'entrar mai aquí. FATAL ERROR
    end
}

sf.finestra.signal_connect('destroy') { Gtk.main_quit}









