require "i2c/drivers/ss1602"
require "gtk3"

class LcdDisplayer 

#creating LCD class for our 20x4 LCD

    def initialize
        super()
        @lcd = I2C::Drivers::SS1602::Display.new("/dev/i2c-1", 0x27)
        @m = @lcd.rows()  #number of rows of the display that has been set up on the display.rb file
        @n = []   #array
    end

    def first_stage
        
            @lcd.clear()
            @lcd.text("Please, login with",1)
            @lcd.text("your university card", 2)
        
    end

    def login(user)
        
            @lcd.clear()
            @lcd.text("Welcome user: ", 1)
            @lcd.text(user, 2)
        
    end

    def error_login
        
            @lcd.clear()
            @lcd.text("Error.User not found", 1)
            @lcd.text("Please try again!", 2)
        
    end

    def lect_teclat
        for i in (0..(@m - 1)) #we run from row 0..3 of the LCD Display
            begin
                text = gets.chomp  #text variable saves each line we write (gets method) until it finds a '\n'. Finally we don't store "\n" (chomp function)
                #if text exists then we store each character inside the array 
                if text           
                    @n.push(text)
                end
                rescue EOFError
                break
            end
            @lcd.clear
            for i in (0..@n.length() - 1) #we run @n array to place on our display each character that we have written on the shell 
                @lcd.text(@n[i], i)
            end
            sleep(5)
        end
    end


    
end


