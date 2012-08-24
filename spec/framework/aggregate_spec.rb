

class DemoAggregateCreated
  attr_reader :id, :name
  def initialize uuid
    @id = uuid
  end
end

class DemoAggregate

  attr_reader :id, :revision

  def initialize()
    @id = nil
    @revision = 0
  end

  def create(id)
    apply(DemoAggregateCreated.new id)
  end

  def whenDemoAggregateCreated event
    @id = event.id
  end

  def apply event
    self.send "when#{event.class.name}", event
    @revision += 1
  end
end


describe  "Aggregates" do
  pending
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
  end
end