require "gtk3"
require_relative 'window.rb'

int scenario = 0  
    #--NON-LOGGED SCENARIO--
    #0 Escenari A (log in, esperant lectura UID per enviar) 
    #1 Escenari A (log fail, apareix botó per tornar a log in)

    #--LOGGED SCENARIOS--
    #2 Escenari B (Espera rebre dades i ordre per enviar a servidor. Si rep error, es mostrarà en aquest mateix estat. Botó logout disponible
    #3 Escenari C (Mostra de dades rebudes per servidor. Botó logout disponible
Set_Finestra sf = Set_Finestra.new()





