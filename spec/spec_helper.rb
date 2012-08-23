
  def given(command)
     DomainLayer.instance.command_router.route(command)
  end

  def then_expect(events = [])
    events = events.instance_of?(Array) ? events : [events]
    generate_events = DomainLayer.instance.repository.load_events(@historical_event_count, 1000)
    generate_events.current_revision.should == @historical_event_count + events.length

    missing = events.reject! {|evt| generate_events.include? evt}
    missing.length.should == 0
  end

