
#
# An EventStream is resonsible for isolating a stream of specific events from the whole of the
# events inside an EventStore.
# EventStreams are written to by Aggregates, creating uncommitted events. Upon committing the entity,
# the events will be considered part of this stream and no longer be reported as uncommitted.
#
class EventStream

  def initialize(event_store, events = [])
    @events = events
    @event_store = event_store
    @uncommitted_events = []
  end

  def current_revision
    # TODO revision should not be in the events, but in the envelope
    highest = @events.empty? ? -1 : @events.last.revision
    return highest + @uncommitted_events.size
  end

  # Appends events to this stream. These will be marked as uncommitted.
  def append(events)
    @uncommitted_events = @uncommitted_events + events
  end

  # Gives all Events that have not yet been commited to the event store. These are all that have been
  # appended since this stream has been loaded
  def uncommitted_events
    @uncommitted_events
  end

  # commits unsaved events to the stream. This will advance the stream's revision.
  def commit
    @event_store.commit self
  end

  def on_committed
    @events = @events + @uncommitted_events
    @uncommitted_events.clear
  end
end