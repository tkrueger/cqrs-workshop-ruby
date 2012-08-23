require_relative '../framework/event'

class BuchWurdeEingepflegt < Event
  attr_accessor :Titel, :ISBN, :Author

  def to_s
    "#{self.class.name}: #{Titel}"
  end


end
