require "uuid"

require_relative "../../lib/framework/event"

# these have to be declared mostly to have some point where the attributes can
# be looked up without using reflection on the Event instance
class DemoAggregateCreated < Event
  def initialize  entity_id
    super :entity_id => entity_id
  end
end

class DemoAggregateNameChanged < Event
  def initialize demo_aggregate, name
    super :demo_aggregate => demo_aggregate, :name => name
  end
end

module Aggregate

  attr_reader :id, :revision, :unsaved_events

  def initialize()
    @id = nil
    @revision = 0
    @unsaved_events = []
  end

  def reconstitute_from events
    events.each {|evt| apply evt}
    @unsaved_events.clear
    self
  end

  def has_unsaved_events?
    !@unsaved_events.empty?
  end

  def apply event
    self.send "when#{event.class.name}", event
    @revision += 1
    @unsaved_events << event
  end
end

module DemoAggregateState
  attr_reader :name

  def whenDemoAggregateCreated event
    @id = event.entity_id
  end

  def whenDemoAggregateNameChanged event
    @name = event.name
  end

end

class DemoAggregate

  include Aggregate
  include DemoAggregateState

  def create(id)
    apply(DemoAggregateCreated.new id)
  end

end


describe  "Aggregates" do
  describe "creation" do
    describe "will not be created if initialized without state" do
      it "will carry no id" do
        DemoAggregate.new().id.should be_nil
      end

      it "will be in revision 0" do
        DemoAggregate.new.revision.should == 0
      end

      it "will carry an id once one it is created" do
        agg = DemoAggregate.new
        agg.create(123)
        agg.id.should == 123
      end
    end

  end

  describe "changing state" do
    it "will raise the aggregate's version" do
      agg = DemoAggregate.new
      agg.revision.should == 0
      agg.create(123)
      agg.revision.should == 1
    end

    it "will produce an unsaved event" do
      agg = DemoAggregate.new
      agg.create 123
      agg.should have(1).unsaved_events
    end
  end

  describe "State" do
    describe "reconstituing from events" do
      before :each do
        @events = [DemoAggregateCreated.new(123), DemoAggregateNameChanged.new(123, "Demo aggregate's name")]
        @agg = DemoAggregate.new.reconstitute_from @events
      end

      it "will apply the state" do
        @agg.id.should == 123
        @agg.name.should == "Demo aggregate's name"
      end

      it "will apply the revision" do
        @agg.revision.should == 2
      end

      it "will leave no unsaved events" do
        @agg.should_not have_unsaved_events
      end
    end
  end

  describe "Events" do
    it { Event.new({}).id.should be_a UUID }

    it "assigns attributes and creates readers" do
      Event.new(:some_att => "some value").some_att.should == "some value"
    end
  end
end