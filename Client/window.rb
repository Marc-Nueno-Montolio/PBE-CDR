require "gtk3"
require 'json'

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


		#Paràmetres de configuració login successful (2n escenari)
		@missatge_benvinguda = "Welcome "
		@eyq_message = "Enter your query:"
		@eyq_button_message = "Send"
		@no_matches_message = "No matches found for your query."

		#Creació objectes gràfics permanents
		@finestra = get_window
		@graella = get_grid
		@label_log = get_login_label
		@buttonA = get_logfailed_button  #Variarà entre log again (escenari 1) i go back de escenari 3 a escenari 2
		@buttonB = get_logout_button     #Fixe. No es modificarà.
		@buttonC = get_send_button      #Botó per enviar dades
		@eyq_label = get_eyq_label
		@no_matches_label = get_no_matches_label
		@input_box = get_a_input_text_box
		@finestra.add(@graella)

		#UID logged
		@uid_logged = nil


	end
		
	#"Getters" de botons, per reaccionar a signals des de main
	def buttonA
		return @buttonA
	end

	def buttonB
		return @buttonB
	end

	def buttonC
		return @buttonC
	end

	def input_box
		return @input_box
	end

	#Getter finestra per obtenir signal 'destroy'
	def finestra
		return @finestra
	end

	def uid_logged
		return @uid_logged
	end

	#Primer escenari

	def go_first_escenario
		@finestra.title = "#{@titol_finestra} LOGIN"
		@finestra.set_default_size @res_ample, @res_altura
		#@graella.remove_column(0)
		@uid_logged = nil
		clean_grid
		#@graella.remove_column(0)
		#@graella.remove_row(1)                       #Eliminem botó Go Back si venim de log failed
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
		@uid_logged = uid
		clean_grid
		#@finestra.set_default_size @res_ample+100, @res_altura
		@graella.attach(label_wm,0,0,1,1)
		@graella.attach(gu_dummy_space,1,0,1,1)
		@graella.attach(@buttonB,2,0,1,1)
		@graella.attach(gu_dummy_space,0,1,1,1)
		@graella.attach(@eyq_label,0,2,1,1)
		@graella.attach(@input_box,0,3,1,1)
		@graella.attach(gu_dummy_space,1,3,1,1)
		@graella.attach(@buttonC,2,3,1,1)
		@finestra.show_all
	end


	def empty_response
		puts "empty_response" #DEBUG
		if(@no_matches_label != @graella.get_child_at(0,4)) #Només afegim la primera vegada.
			@graella.attach(@no_matches_label,0,4,1,1)
			@finestra.show_all
		end
	end

	def go_third_scenario(hash_rcv)
		puts "Not-empty hash received" #DEBUG
		#Not implemented yet.
	end
			
	def clean_grid
		i=0
		while i<51 do
			@graella.remove_column(i)
			@graella.remove_row(i)
			i+=1
		end 
	end

	def get_window #Retorna objecte finestre
		window = Gtk::Window.new("") #@titol_finestra
		window.border_width = @marge
		window.set_window_position(:center)
		#window.title = @titol_finestra
		#window.set_default_size @res_ample, @res_altura
		return window
	end

	def get_dummy_space
		label = Gtk::Label.new("")
		label.set_size_request(50,50)
		return label
	end

	def gu_dummy_space
		label = Gtk::Label.new("")
		label.set_size_request(25,25)
		return label
	end

	def get_grid #Retorna objecte graella
		return Gtk::Grid.new
	end

	def get_login_label #Retorna objecte etiqueta
		label = Gtk::Label.new("")
		label.set_name('mainlabel')
		label.set_size_request(@res_ample - @marge, @res_altura - @marge)
		return label
	end

	def get_no_matches_label
		label = Gtk::Label.new(@no_matches_message)
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
		return Gtk::Label.new(welcome_message(nom,uid_nom))
	end

	def get_eyq_label
		return Gtk::Label.new(@eyq_message)
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
		button.set_name('logout_button')
		return button
	end

	def get_send_button
		button = Gtk::Button.new(:label => @eyq_button_message)
		button.set_name('sendbutton')
		return button
	end

	def get_a_input_text_box
		return Gtk::Entry.new
	end
end


