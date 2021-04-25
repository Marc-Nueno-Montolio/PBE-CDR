require 'ruby-nfc'

class Rfid_Lucas
  def initialize(reader)
    @reader = reader
  end

  def read_uid
    @reader.poll(IsoDep::Tag, Mifare::Classic::Tag, Mifare::Ultralight::Tag) do |tag|
      begin
        tagstr = "#{tag}"[0..8].upcase
        puts "UID:" + tagstr
        return tagstr

      rescue Exception => e
        puts e
      end
    end
  end
end