require "gtk3"
require_relative 'window.rb'
require_relative 'cl_scon.rb'
require_relative 'RfidReader'
#require_relative 'fake_signal_gen.rb' #Dummy dev class


scenario = 0;
#--NON-LOGGED SCENARIO--
#0 Escenari A (log in, esperant lectura UID per enviar)     buttonA=null, buttonB=null
#1 Escenari A (log fail, apareix botó per tornar a log in)  buttonA= Botó reintentar, buttonB=null

#--LOGGED SCENARIOS--
#2 Escenari B (Introducció dades per enviar a servidor. Si rep error, es mostrarà en aquest mateix estat. buttonA=enviar buttonB=logout
#3 Escenari C (Mostra de dades rebudes per servidor. buttonA=Tornar escenari B buttonB=logout
sf = Set_Finestra.new()
reader = RfidReader.new('PN532')
sf.go_first_escenario
sf.finestra.show_all


#GESTIÓ SENYALS

#Faltaria implementar device per gestionar signal de lector UID. Ús temporal fsg:


reader.signal_connect("tag") do |sender, uid|
  if(scenario==0)
    nom, uid_del_nom = get_user(uid)
    if(nom==nil && uid_del_nom==nil)
      scenario = 1
      sf.login_fail(uid)

    else
      puts "Valid UID Inserted. Changing to scenario 2A" #debugging
      scenario = 2
      sf.go_second_scenario(nom,uid_del_nom)
    end
  end
end

Gtk.main






