require "gtk3"
require 'json'

class Set_Finestra
	def initialize
		#Paràmetres de configuració de finestra:
		@titol_finestra = "Lector RFID - "
		@res_ample = 800
		@res_altura = 550
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

		#Paràmetres de configuració query results (3r escenari)

		@saq_button_message = "Send other query"

		
		#Gestor canvi objecte finestre per recollir sempre botó de sortida
		@first_time = true
		@wsb = nil			#Es crea/modifica a get_window.

		#Creació objectes gràfics permanents
		@finestra = get_window
		@graella = get_grid
		@label_log = get_login_label
		@buttonA = get_logfailed_button  #Variarà entre log again (escenari 1) i go back de escenari 3 a escenari 2
		@buttonB = get_logout_button     #Fixe. No es modificarà.
		@buttonC = get_send_button      #Botó per enviar dades
		@buttonD = get_send_another_query_button #Botó per, mostrant dades de query, es vulgui enviar altre petició.
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

	def buttonD
		return @buttonD
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

	def get_wsb
		return @wsb
	end

	#Primer escenari

	def go_first_escenario
		@finestra.title = "#{@titol_finestra} LOGIN"
		@finestra.set_default_size @res_ample, @res_altura
		#@graella.remove_column(0)
		@uid_logged = nil
		clean_grid
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
		@label_wm = get_logged_label(nom_user, uid)
		@uid_logged = uid
		clean_grid
		#@finestra.set_default_size @res_ample+100, @res_altura
		@graella.attach(@label_wm,0,0,1,1)
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
		clean_grid

		#@graella.set_column_homogeneous(true)
		#@graella.set_row_homogeneous(true)
		results_list = get_new_list(hash_rcv[0].keys.length)
		keys_of_table =  hash_rcv[0].keys #Obtenim títols dels camps del hash de la primera posició.

		#Creem totes les files amb la informació.
		i = 0
		while i < hash_rcv.length
			iter = results_list.append #Crea i retorna fila (objecte Treelter) afegida, s'afegeix a última posició.
			j = 0
			while j < keys_of_table.length 
				iter.set_value(j,string_cleaner(hash_rcv[i].values_at(keys_of_table[j]).to_s))
				j += 1
			end
				i += 1
		end

		treeview = Gtk::TreeView.new(results_list)  
		
		i = 0
		while i < keys_of_table.length
			rndr = Gtk::CellRendererText.new()
			columna = Gtk::TreeViewColumn.new(keys_of_table[i], rndr,:text=>i)
			treeview.append_column(columna)
			i +=1
		end

		#Finestra que permet scroll amb ratolí

		scr_treelist = Gtk::ScrolledWindow.new()
		scr_treelist.set_vexpand(true)

		#Afegim a graella

		if(false)                                     #Primera versió.
			@graella.attach(scr_treelist,0,0,5,8)

			#Afegim botons

			@graella.attach_next_to(@buttonB,scr_treelist,3,1,1)
			#@graella.attach_next_to(@buttonD,scr_treelist,1,1)
			#@graella.attach(@buttonB,0,5,1,1)
			#@graella.attach(@buttonD,1,5,1,1)
			scr_treelist.add(treeview)
			@finestra.show_all		
		else											#Nova versió.
			#attach(OBJECTE, COLUMNA, FILA, WIDTH, HEIGHT) BUTTONB: LOGOUT, BUTTONC: SEND QUERY
			#attach_next_to(OBJECTE, OBJECTE_REF, GTK.POSITIONTYPE, WIDTH, HEIGHT)
			#Gtk.PositionType --> LEFT = 0 , RIGHT = 1, TOP = 2, BOTTOM = 3

			#@graella.attach(@label_wm,0,0,1,1)
			#@graella.attach(@input_box,0,1,1,1)
			#@graella.attach(scr_treelist,0,2,5,8)
			#@graella.attach(@buttonB,1,0,1,1)
			#@graella.attach(@buttonC,1,1,1,1)

			@graella.attach(scr_treelist,0,2,8,20)
			@graella.attach_next_to(@buttonC,scr_treelist,2,1,1)
			@graella.attach_next_to(@input_box,@buttonC,2,1,1)
			@graella.attach_next_to(@label_wm, @input_box,2,1,1)
			gdsref1 = gu_dummy_space
			@graella.attach_next_to(gdsref1, @label_wm,1,1,1)
			@graella.attach_next_to(@buttonB, gdsref1,1,1,1)
			i = 1

			#while (i<5)
			#	@graella.attach(gu_dummy_space,i,0,1,1)
			#	i += 1
			#end
			#@graella.attach(@buttonB,1,0,1,1)
			
			#@graella.attach_next_to(@buttonC,@input_box, 1,1,1)
			#@graella.attach_next_to(scr_treelist,@input_box,3,1,1)
			scr_treelist.add(treeview)
			@finestra.show_all
			
		end
		#C
		#puts hash_rcv.length
		#Not implemented yet.
	end
			
	def string_cleaner(str)
		char_arr = str.chars
		return char_arr[2,str.length-4].join("")
	end

	def true_generator
		return true
	end

	def get_new_list(columns)
		case columns
			when 3
				puts "creating 3 column list"
				return Gtk::ListStore.new(String,String,String)
			when 4
				puts "creating 4 column list"
				return Gtk::ListStore.new(String,String,String,String)
			else
				puts "FATAL ERROR: Unexpected quantity of hashes (" + columns.to_s + ")"
				Gtk.main_quit
				return nil
		end
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
		if(@first_time)
			@wsb = Window_Signal_Bridge.new(window)
			@fist_time = false
		else
			@wsb.set_window(window)
		end
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

	def reset_gw
		clean_grid
		@finestra.unrealize
		@finestra = get_window
		@graella = get_grid
		@finestra.add(@graella)
		#reset_all_graph_resources
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
		#@label_log.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Fons blau
		#@label_log.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Lletra blanca
	end

	def login_label_fail_status(uid)
		#@label_log.override_background_color(0, Gdk::RGBA::new(1,0,0,1))      #VERMELL
		@label_log.text = "#{@missatge_error_1} #{uid} #{@missatge_error_2}" 
	end

	def get_logged_label(nom, uid_nom)
		return Gtk::Label.new(welcome_message(nom,uid_nom))
		label.set_name('loggedlabel')
	end

	def get_eyq_label
		return Gtk::Label.new(@eyq_message)
	end

	def get_logfailed_button
		button = Gtk::Button.new(:label => @mis_boto)
		button.set_name('logfailedbutton')
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

	def get_send_another_query_button 
		return Gtk::Button.new(:label => @saq_button_message)
		button.set_name('sendanotherquerybutton')
	end

	def get_send_button
		button = Gtk::Button.new(:label => @eyq_button_message)
		button.set_name('sendbutton')
		return button
	end

	def get_a_input_text_box
		input_box = Gtk::Entry.new
		input_box.set_name(@eyq_message)
		return input_box
		
	end

end

class Window_Signal_Bridge < GLib::Object
    type_register
    define_signal("destroy_from_wsb", GLib::Signal::RUN_FIRST, nil, nil)


    def initialize(window)
		super()
		@window = window
		@thr = Thread.new{
			#while(1)
				@window.signal_connect("destroy"){
					#signal_emit("destroy_from_wsb")
					Gtk.main_quit
				}
			#end
		}
    end

	def set_window(window)
		Thread.kill(@thr)
		@window = window
		@thr = Thread.new{
			#while(1)
				@window.signal_connect("destroy"){
					#signal_emit("destroy_from_wsb")
					Gtk.main_quit
				}
			#end
		}
	end
end

