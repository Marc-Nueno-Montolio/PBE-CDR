# For development purposes, when no reader is connected.
class ReaderEmulator
  def read_uid(reader=0)
    return gets
  end
end
