require "rspec"
require "spec_helper"
require_relative '../../lib/command/buch_einpflegen'
require_relative '../../lib/event/buch_wurde_eingepflegt'
require_relative '../../lib/framework/domain_layer'
require_relative '../../lib/framework/in_memory_store'

describe "Ein Buch einpflegen" do

  before :each do
    dl = DomainLayer.instance
    dl.event_store = InMemoryStore.new
    @historical_event_count = DomainLayer.instance.repository.revision
  end

  pending "erzeugt ein BuchWurdeEingepflegt Event" do
    buch_id = "1233"
    given(BuchEinpflegen.new aggregate_id: buch_id, ISBN: "12345", Titel: "CQRS Handbuch", Author: "Greg Young")
    then_expect BuchWurdeEingepflegt.new aggregate_id: buch_id, ISBN: "12345", Titel: "CQRS Handbuch", Author: "Greg Young"
  end

end