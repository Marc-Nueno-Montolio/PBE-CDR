require "gtk3"

class Set_Finestra
	def initialize
		#Paràmetres de configuració de finestra:
		@titol_finestra = "Lector RFID - "
		@res_ample = 400
		@res_altura = 125
		@marge = 21

		#Paràmetres primer escenari (login)
			#Paràmetres de configuració de 'label' (etiqueta de color)
			@missatge = "Please, login with your university card" 
			#Paràmetres de configuració de login failed
			@missatge_error_1 = "ERROR: UID "
			@missatge_error_2 = " not found."

		#Paràmetres de configuració de botons
		@mis_boto = "Go back" #Botó finestra log-in failed

		#Definim struct gràfic
		@set_finestra = Struct.new(:window, :grid, :buttonA, :buttonB)
		#Paràmetres de configuració login successful
		@missatge_benvinguda = "Welcome "
	end
		
	#"Getters" de botons, per reaccionar a signals des de main
	def buttonA
		return @set_finestra.buttonA
	end

	def buttonB
		return @set_finestra.buttonB
	end

	#Getter finestra per obtenir signal 'destroy'
	def finestra
		return @set_finestra.window
	end

	def get_set_init
		@set_finestra.window = get_window
		@set_finestra.grid = get_grid
		go_first_escenario(set_finestra)
	end

	def get_set
		return set_finestra
	end

	#Primer escenari
	def welcome_message(String name)
		return @missatge_benvinguda + name
	end

	def go_first_escenario(Struct estructura)
		@set_finestra.window.title = @titol_finestra += "LOGIN"
		@set_finestra.grid.remove(0)
		@set_finestra.grid.attach(get_login_label,0,0,1,1)
	end

	def login_fail(String uid)
		@set_finestra.grid.remove(0)
		@set_finestra.grid.attach(get_log_fail_label(uid),0,0,1,1)
		@set_finestra.buttonA = get_button_logfailed
		@set_finestra.grid.attach(@set_finestra.buttonA,0,1,1,1)
	end

	def get_window #Retorna objecte finestre
		window = Gtk::Window.new(@titol_finestra)
		window.border_width = @marge
		window.title = @titol_finestra
		window.set_default_size @res_ample, @res_altura
		return window
	end


	def get_grid #Retorna objecte graella
		grid = Gtk::Grid.new
		return grid
	end

	def get_login_label #Retorna objecte etiqueta
		label = Gtk::Label.new(@missatge)
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		label.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Fons blau
		label.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Lletra blanca
		return label
	end

	def get_log_fail_label(String uid)
		label = Gtk::Label.new(@missatge_error_1 + uid + @missatge_error_2)
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		label.override_background_color(0, Gdk::RGBA::new(1,0,0,1)) #Fons vermell
		label.override_background_color(0, Gdk::RGBA::new(1,0,0,1)) #Lletra blanca
		return label
	end

	def get_button_logfailed #Retorna objecte botó 
		button = Gtk::Button.new(:label => @mis_boto)
		return button
	end

	def put_a_input_text_box (Struct estructura) #Configura la finestra per a introduir dades
		#set_finestra.
		#return void
	end
end


require 'gtk3'
require_relative 'device.rb'
require_relative 'widget_options.rb'



window = get_window		#Finestra. Objecte gràfic que encapsula tots els objectes gràfics
grid = get_grid			#Graella. Utilitat per organitzar objectes a la finestra
info_label = get_label		#Etiqueta. Canvia de color i text segons estat de l'aplicació 
clear_button = get_button	#Botó 'clear' (per tornar a llegir RFID)

clear_button.signal_connect("clicked") do #Actuació en cas de accionar botó
    reset_label(info_label)                 #Reestabliment blau i missatge
    scan_tag(rf, info_label)                
  end

  
window.signal_connect('destroy') { Gtk.main_quit } 


