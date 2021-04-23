require "gtk3"

class set_finestra
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
		@missatge_error = "ERROR: UID not found"

		#Paràmetres de configuració del botó 
		@mis_boto = "Clear"

		#Definim struct gràfic
		set_finestra = Struct.new(:window, :grid)

	end
		#Paràmetres de configuració login successful
		@missatge_benvinguda = "Welcome "
		def welcome_message(String name)
    		return @missatge_benvinguda + name
		end







def get_set_init
	set_finestra.window = get_window
	set_finestra.grid = get_grid
	go_first_escenario(set_finestra)
	return set_finestra
end

def get_set
	return set_finestra
end

#Primer escenari

def go_first_escenario(Struct estructura)
	estructura.window.title = @titol_finestra += "LOGIN"
	estructura.grid.attach(get_login_label,0,0,1,1)
	estructura.window.add(estructura.label)
end

def login_fail(String uid)
	set_finestra.


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
	label.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Blue
	label.override_color(0 , Gdk::RGBA::new(1.0, 1.0, 1.0, 1.0))#Blanc
	return label
end

def reset_label (label) #Mètode executat quan hi ha ID a pantalla i es vol tornar a llegir 
	label.set_markup(@missatge) #Reestabliment missatge 
	label.override_background_color(0, Gdk::RGBA::new(0,0,1,1)) #Tornem a color blau
end

def get_button #Retorna objecte botó 
	button = Gtk::Button.new(:label => @mis_boto)
	return button
end

def put_a_input_text_box (Struct estructura) #Configura la finestra per a introduir dades
	#set_finestra.
	#return void
end