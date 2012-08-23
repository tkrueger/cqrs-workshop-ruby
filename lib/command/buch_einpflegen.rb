require_relative '../framework/command.rb'

class BuchEinpflegen < Command
  attr_accessor :Titel, :ISBN, :Author

  def to_s
    "#{self.class.name}: #{@Titel}"
  end


end
