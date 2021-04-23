require "gtk3"
require_relative 'window.rb'


int scenario;
    #--NON-LOGGED SCENARIO--
    #0 Escenari A (log in, esperant lectura UID per enviar) 
    #1 Escenari A (log fail, apareix botó per tornar a log in)

    #--LOGGED SCENARIOS--
    #2 Escenari B (Espera rebre dades i ordre per enviar a servidor. Si rep error, es mostrarà en aquest mateix estat. Botó logout disponible
    #3 Escenari C (Mostra de dades rebudes per servidor. Botó logout disponible
Set_Finestra sf = Set_Finestra.new()
finestra = sf.finestra;

sf.get_set_init 
scenario = 0;







#GESTIÓ SENYALS

finestra.signal_connect('destroy') { Gtk.main_quit}








