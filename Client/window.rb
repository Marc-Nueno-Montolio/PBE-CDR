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
		@mis_send = "Send" #Botó finestra query per a enviar string
		@mis_logout_button = "Log-out" #Missatge botó logout

		#Definim struct gràfic
		@set_finestra = Struct.new(:window, :grid, :buttonA, :buttonB)
		#Paràmetres de configuració login successful
		@missatge_benvinguda = "Welcome "

		#Creació objectes gràfics permanents
		@finestra = get_window
		@graella = get_grid
		@label_log = get_login_label
		@buttonA = get_logfailed_button  #Variarà entre log again (escenari 1) i go back de escenari 3 a escenari 2
		@buttonB = get_logout_button     #Fixe. No es modificarà.
		@finestra.add(@graella)


	end
		
	#"Getters" de botons, per reaccionar a signals des de main
	def buttonA
		return @buttonA
	end

	def buttonB
		return @buttonB
	end

	#Getter finestra per obtenir signal 'destroy'
	def finestra
		return @finestra
	end

	#Primer escenari

	def go_first_escenario
		@finestra.title = "#{@titol_finestra} LOGIN"
		#@graella.remove_column(0)
		@graella.remove_column(0)
		@graella.remove_row(1)                       #Eliminem botó Go Back si venim de log failed
		login_label_reading_status
		@graella.attach(@label_log,0,0,1,1)
		@finestra.show_all
	end

	def login_fail(uid)
		login_label_fail_status(uid)
		@graella.attach(@buttonA,0,1,1,1)
		@finestra.show_all
	end

	#Segon escenari

	def welcome_message(name, uid)
		return @missatge_benvinguda + name +", UID: " + uid
	end

	def go_second_scenario(nom_user, uid)
		@finestra.title = "#{@titol_finestra} LOGGED"
		label_wm = get_logged_label(nom_user, uid)
		@graella.remove_column(0)
		box = get_a_input_text_box
		@finestra.set_default_size @res_ample+100, @res_altura
		@graella.attach(label_wm,0,0,1,1)
		@graella.attach(@buttonB,10,0,1,1)
		@graella.attach(box,0,1,1,1)
		@finestra.show_all
	end
			

	def get_window #Retorna objecte finestre
		window = Gtk::Window.new("") #@titol_finestra
		window.border_width = @marge
		#window.title = @titol_finestra
		window.set_default_size @res_ample, @res_altura
		return window
	end


	def get_grid #Retorna objecte graella
		return Gtk::Grid.new
	end

	#def get_login_label #Retorna objecte etiqueta
	#	label = Gtk::Label.new(@missatge)
	#	label.set_size_request(@res_ample - @marge, @res_altura - @marge)
	#	label.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Fons blau
	#	label.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Lletra blanca
	#	return label
	#end

	def get_login_label #Retorna objecte etiqueta
		label = Gtk::Label.new("")
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		return label
	end

	def login_label_reading_status
		@label_log.text = @missatge
		@label_log.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Fons blau
		@label_log.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Lletra blanca
	end

	def login_label_fail_status(uid)
		@label_log.override_background_color(0, Gdk::RGBA::new(1,0,0,1))      #VERMELL
		@label_log.text = "#{@missatge_error_1} #{uid} #{@missatge_error_2}" 
	end

	def get_logged_label(nom, uid_nom)
		return Gtk::Label.new(welcome_message(nom,uid_nom) + "\n Enter your query:")
	end

	def get_logfailed_button
		button = Gtk::Button.new(:label => @mis_boto)
		return button
	end

	def set_logfailed_button
		@buttonA.text = @mis_boto
	end
	
	def get_logout_button
		button = Gtk::Button.new(:label => @mis_logout_button)
		return button
	end

	def get_a_input_text_box
		return Gtk::Entry.new
	end
end


