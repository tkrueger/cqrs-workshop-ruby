require "uuid"

class Event

  attr_reader :id, :aggregate_id

  # @param args
  # creates an attribute with the given name and value and make it accesible via an attribute reader
  # for each entry
  def initialize(args = {})
    @id = UUID.new
    args.each { |key, val|
      self.instance_variable_set "@#{key}".to_sym, val
      (class << self;self;end).send(:attr_reader, key.to_sym)
    }
  end
end
