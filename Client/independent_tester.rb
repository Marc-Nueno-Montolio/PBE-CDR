require "gtk3"
require_relative 'window.rb'


sf = Set_Finestra.new

window = sf.get_window
window.border_width = 20
window.title = "Hola"
grid = sf.get_grid
button = Gtk::Button.new(:label => "BOTÓN")


window.set_default_size 500, 500
grid.attach(button,0,0,1,1)
window.add(grid)
window.show_all
grid.remove_row(0)
Gtk.main








