require "gtk3"
require 'json'
require_relative 'window.rb'
require_relative 'cl_scon.rb'
require_relative 'async_comm'
require_relative 'RfidReader'

#require_relative 'fake_signal_gen.rb' #Dummy dev class


scenario = 0;
#--NON-LOGGED SCENARIO--
#0 Escenari A (log in, esperant lectura UID per enviar)     buttonA=null, buttonB=null
#1 Escenari A (log fail, apareix botó per tornar a log in)  buttonA= Botó reintentar, buttonB=null

#--LOGGED SCENARIOS--
#2 Escenari B (Introducció dades per enviar a servidor. Si rep error, es mostrarà en aquest mateix estat. buttonA=enviar buttonB=logout
#3 Escenari C (Mostra de dades rebudes per servidor. buttonA=Tornar escenari B buttonB=logout


com = AsyncComm.new
sf = Set_Finestra.new()
#reader_hardware allows to choose nfc reader, info in RfidReader.rb
# Implemented: emulator: reads a tag from keyboard, PN532: PN532 reader
reader = RfidReader.new('PN532')

sf.go_first_escenario
sf.finestra.show_all


#GESTIÓ SENYALS
reader.signal_connect("tag") do |sender, uid|
  if(scenario==0)
    @nom, @uid_del_nom = get_user(uid)
    if(@nom==nil && @uid_del_nom==nil)
      scenario = 1
      sf.login_fail(uid)

    else
      puts "Valid UID Inserted. Changing to scenario 2A" #debugging
      scenario = 2
      sf.go_second_scenario(@nom,@uid_del_nom)
    end
  end
end

sf.buttonA.signal_connect("clicked"){
  case scenario
  when 1
    puts "buttonA catched. Changing to scenario 0A" #debugging
    scenario = 0
    sf.go_first_escenario
  when 2
    #Enviar string a funció de contacte amb servidor. No implementat encara.
  when 3
    scenario = 2
    sf.go_second_scenario(@nom, @uid_del_nom)
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

sf.buttonC.signal_connect("clicked"){
  puts "Sending query: " + sf.input_box.text   #DEBUG
  com.sendQuery(sf.uid_logged, sf.input_box.text)
}


com.signal_connect('queryResponse') do |sender, res|
  puts res
end

# comms.signal_connect('queryResponse') do |sender, query|
#   querystr = query.to_s
#   puts "Feedback: " + querystr              #DEBUG
#   if(querystr=="{}")
#     sf.empty_response
#   else
#     scenario = 2
#     sf.go_third_scenario(query)
#   end

end
sf.finestra.signal_connect('destroy') { Gtk.main_quit}

Gtk.main






