class Repository

  Global = -1
  # TODO make this Integer.max_value
  All = 1000

  def initialize(event_store)
    @event_store = event_store
  end

  def revision
    @event_store.revision
  end

  # returns the event stream as specified by the arguments
  def load_events(aggregate_id = Global, from_revision = 0, to_revision = @event_store.revision)
    EventStream.new(self, @event_store.load_events(from_revision, to_revision))
  end

end