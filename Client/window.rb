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
		@buttonA = get_logfailed_button
		@buttonB = get_logout_button
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
		@finestra.title = @titol_finestra += "LOGIN"
		@graella.remove_column(0)
		@graella.attach(get_login_label,0,0,1,1)
		@finestra.show_all
	end

	def login_fail(uid)
		@graella.remove_column(0)
		@graella.attach(get_log_fail_label(uid),0,0,1,1)
		@buttonA = get_logfailed_button
		@graella.attach(@buttonA,0,1,1,1)
		@finestra.show_all
	end

	#Segon escenari

	def welcome_message(name, uid)
		return @missatge_benvinguda + name +", UID: " + uid
	end

	def go_second_scenario(nom_user, uid)
		@finestra.title = @titol_finestra += "LOGGED"
		label_wm = get_logged_label(nom_user, uid)
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

	def get_login_label #Retorna objecte etiqueta
		label = Gtk::Label.new(@missatge)
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		label.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Fons blau
		label.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Lletra blanca
		return label
	end

	def get_logged_label(nom, uid_nom)
		return Gtk::Label.new(welcome_message(nom,uid_nom))
	end

	def get_log_fail_label(uid)
		label = Gtk::Label.new(@missatge_error_1 + uid + @missatge_error_2)
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		label.override_background_color(0, Gdk::RGBA::new(1,0,0,1)) #Fons vermell
		label.override_background_color(0, Gdk::RGBA::new(1,0,0,1)) #Lletra blanca
		return label
	end

	def get_logfailed_button
		button = Gtk::Button.new(:label => @mis_boto)
		return button
	end

	def get_logout_button
		button = Gtk::Button.new(:label => @mis_logout_button)
		return button
	end

	def put_a_input_text_box
		#set_finestra.
		#return void
		return void
	end
end


