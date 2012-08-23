class Event

  attr_accessor :aggregate_id

  # The Event's revision, i.e. the index that this Event has in the global event stream.
  # This will be set by the Repository/EventStore upon saving the Event.
  attr_accessor :revision

  def initialize(args = {})
    args.each { |key, val| self.send "#{key}=", val }
  end
end
