module CQRS

  # An Aggregate deals with applying Events to Entities. It carries the
  # revision information and can reconstitute an Aggregate from an EventStream.
  module Aggregate

    attr_reader :id, :revision, :unsaved_events

    def initialize()
      @id = nil
      @revision = 0
      @unsaved_events = []
    end

    # TODO as with LOKAD's example, this might be better placed in a State constructor
    def reconstitute_from events
      events.each {|evt| apply evt}
      @unsaved_events.clear
      self
    end

    def has_unsaved_events?
      !@unsaved_events.empty?
    end

    def apply event
      # TODO how events are applied should be a concern of the aggregate's state
      self.send "when#{event.class.name.split("::").last}", event
      @revision += 1
      @unsaved_events << event
    end
  end

end