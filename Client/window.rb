require 'gtk3'
require_relative 'device.rb'
require_relative 'widget_options.rb'


set_finestra = Struct.new(:window, :grid, )
window = get_window		#Finestra. Objecte gràfic que encapsula tots els objectes gràfics
grid = get_grid			#Graella. Utilitat per organitzar objectes a la finestra
info_label = get_label		#Etiqueta. Canvia de color i text segons estat de l'aplicació 
clear_button = get_button	#Botó 'clear' (per tornar a llegir RFID)

clear_button.signal_connect("clicked") do #Actuació en cas de accionar botó
    reset_label(info_label)                 #Reestabliment blau i missatge
    scan_tag(rf, info_label)                
  end

  
window.signal_connect('destroy') { Gtk.main_quit } 

