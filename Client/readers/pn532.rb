require 'ruby-nfc'
class PN352
  # get all readers available with ruby-nfc gem
  @@readers = NFC::Reader.all
  @@debug = false

  def get_readers
    return @@readers
  end
  # returns UID in hex format
  def read_uid(reader=0)
    if @@debug
      puts "Available readers: #{@@readers}"
    end

    @@readers[reader].poll(Mifare::Classic::Tag) do |tag|
      begin
        uid = tag.to_s.split()[0].upcase
        if @@debug
          puts "#{uid}"
        end
        return uid
      rescue Exception => e
        puts e
      end
    end
  end
end


if __FILE__ == $0
  rf = PN352. new
  puts "Please login with your university card"
  uid = rf.read_uid
  puts uid
end