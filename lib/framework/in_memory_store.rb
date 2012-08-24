require_relative "record";

class InMemoryStore

  def initialize
    @data = []
    @global_revision = -1
  end

  def load_events(from=0, to = revision)
    return [] if from > revision
    @data[from..Math.max(to, revision)]
  end

  # Retuns the revision of the most current event in the store
  def revision
    @global_revision
  end

  # gives the complete history, i.e. all records
  def historical_records
    @data
  end

  def commit(event_stream)
    event_stream.uncommitted_events.map do |event|
      # TODO make this an envelope
      #event.revision = next_revision
      # TODO serialize event to JSON
      Record.new(event.aggregate_id, next_revision, event)
    end
    append event_stream.uncommitted_events
    event_stream.on_committed
  end

  def append(records)
    @data += records
  end

  def next_revision
    @global_revision += 1
  end

end