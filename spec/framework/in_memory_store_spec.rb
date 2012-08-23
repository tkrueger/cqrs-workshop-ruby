require "rspec"

require File.join(File.dirname(__FILE__), "../../lib/framework/in_memory_store" )
require File.join(File.dirname(__FILE__), "../../lib/framework/record" )

describe InMemoryStore do

  describe "enumerating history " do
    describe "on an empty store" do
      before :each do
        @store = InMemoryStore.new
      end

      it "will give empty collection" do
        @store.should have_exactly(0).historical_records
      end
    end
  end

  describe "appending history" do
    before :each do
      @store = InMemoryStore.new
      @records = [Record.new(1, 1, 3), Record.new( 1,2,3)]
      @store.append(@records)
    end

    it "will save the records" do
      @store.should have_exactly(2).historical_records
    end
  end

end
