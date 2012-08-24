describe "Events" do
  it { Event.new({}).id.should be_a UUID }

  it "assigns attributes and creates readers" do
    Event.new(:some_att => "some value").some_att.should == "some value"
  end
end
