require "rspec"

require_relative "../../lib/framework/event"
require_relative "../../lib/framework/in_memory_store"
require_relative "../../lib/framework/event_stream"

class TestStream < EventStream
  def initialize
    super InMemoryStore.new
  end
end

describe "EventStreams" do

  describe "appending events" do
    before :each do
      @stream = TestStream.new
      @old_revision = @stream.current_revision
      @stream.append([Event.new])
    end

    it "will raise the stream's revision" do
      @stream.current_revision.should == @old_revision+1
    end

  end

  describe "commiting a stream with uncommitted events" do
    before :each do
      @stream = TestStream.new
      @old_revision = @stream.current_revision
      @stream.append([Event.new, Event.new])
      @stream.commit
    end

    it "will raise the stream's revision" do
      @stream.current_revision.should == @old_revision+2
    end

    it "will not leave any uncommitted events" do
      @stream.uncommitted_events.empty?.should == true
    end

  end

end