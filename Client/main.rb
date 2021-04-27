require "gtk3"
require 'json'
require_relative 'window.rb'
require_relative 'async_comm'
require_relative 'RfidReader'
require_relative 'timer'
#require_relative 'LcdDisplayer'

cssProvider = Gtk::CssProvider.new
cssProvider.load_from_path('./styles.css')
Gtk::StyleContext.add_provider_for_screen(Gdk::Screen.default, cssProvider, Gtk::StyleProvider::PRIORITY_USER)
scenario = 0;
#@lcd = LcdDisplayer.new

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
reader = RfidReader.new("emulator")

sf.go_first_escenario

wsb = sf.get_wsb
sf.finestra.show_all

#timer = Timer.new(100)
#@lcd.first_stage

#GESTIÓ SENYALS
reader.signal_connect("tag") do |sender, uid|
  if (scenario == 0)
    com.get_student(uid)
    
  end
end

com.signal_connect('studentResponse') do |sender, name, uid|
  @nom = name
  @uid_del_nom = uid
  if (@nom == nil && @uid_del_nom == nil)
    scenario = 1
    sf.login_fail(uid)
    #@lcd.error_login
  else
    puts "Valid UID Inserted. Changing to scenario 2A" #debugging
    scenario = 2
    sf.go_second_scenario(@nom, @uid_del_nom)
  #  timer.start
    #@lcd.login(@nom)
  end

end

#timer.signal_connect('timeout'){
 # if(scenario==2)
  #  scenario = 0
  #  sf.go_first_escenario
 # end
#}

sf.buttonA.signal_connect("clicked") {
  case scenario
  when 1
    puts "buttonA catched. Changing to scenario 0A" #debugging
    scenario = 0
    sf.go_first_escenario
    #@lcd.first_stage
  when 2
    #Enviar string a funció de contacte amb servidor. No implementat encara.
  when 3
    scenario = 2
    sf.go_second_scenario(@nom, @uid_del_nom)
  else
    Gtk.main_quit #No hauria d'entrar mai aquí. FATAL ERROR
  end
}

sf.buttonB.signal_connect("clicked") {
  case scenario
  when 2
    #Caldria enviar ordre a funció de contacte amb servidor de logout
    scenario = 0
    sf.go_first_escenario
    #@lcd.first_stage
  when 3
    scenario = 0
    sf.reset_gw
    sf.go_first_escenario
    #@lcd.first_stage
  else
    Gtk.main_quit #No hauria d'entrar mai aquí. FATAL ERROR
  end
}

sf.buttonC.signal_connect("clicked") {
  puts sf.uid_logged + ": Sending query: " + sf.input_box.text
  com.sendQuery(sf.uid_logged, sf.input_box.text)
}

com.signal_connect('queryResponse') do |sender, query|
  querystr = query.to_s
  puts "Feedback: " + querystr

  if(scenario==3)
    puts "Go Third Scenario"
    if(querystr == "{}") 
      sf.empty_response(scenario)
    else
      sf.reset_gw
      
      sf.go_third_scenario(query)
    end
  end

    if(scenario==2)
    #timer.stop
    if (querystr == "{}")
      sf.empty_response(scenario)
      #timer.start
    else
      puts "Go Third Scenario"
      sf.reset_gw
      scenario = 3
      sf.go_third_scenario(query)
    end
  end
end


wsb.signal_connect("destroy_from_wsb") { Gtk.main_quit}     #Closing button from windows managed by Windows Signal Bridge.

Gtk.main






