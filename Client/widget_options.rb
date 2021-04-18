require "gtk3"

#Paràmetres de configuració de finestra:
@titol_finestra = "Lector RFID"
@res_ample = 400
@res_altura = 125
@marge = 20

#Paràmetres de configuració de 'label' (etiqueta de color)
@missatge = "Please, login with your university card" 

#Paràmetres de configuració del botó 
@mis_boto = "Clear"

#Paràmetres de configuració de login failed
@missatge_error = "ERROR: UID not found"

#Paràmetres de configuració login successful
@missatge_benvinguda = "Welcome "

def welcome_message(String name)
    return @missatge_benvinguda + name
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

def get_label #Retorna objecte etiqueta
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