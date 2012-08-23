class Aggregate

  @unsaved_events = []

  attr_accessor :id

  def reconstitute_from(events)
    events.each {|e| self.send "apply_#{e}" }
  end
end

Aggregate.new.apply("Piep")