class Command
  attr_accessor :aggregate_id

  def AggregateId
    @aggregate_id
  end

  def initialize(args)
    args.each { |key, val| self.send "#{key}=", val }
  end

end
