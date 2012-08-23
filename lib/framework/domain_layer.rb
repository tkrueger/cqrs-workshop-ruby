require 'singleton'
require File.join(File.dirname(__FILE__), "repository")
require File.join(File.dirname(__FILE__), "command_router")

class DomainLayer

  include Singleton

  attr_accessor :event_store
  attr_reader :repository, :command_router

  def initialize
    @command_router = CommandRouter.new
  end

  def event_store=(implementation)
    @event_store = implementation
    @repository = Repository.new @event_store
  end

  class BuchEinpflegenHandler
    def handle(cmd)
      buch = DomainLayer.repository.load buch.aggregate_id
      buch.einpflegen( cmd.aggregate_id, cmd.ISBN, cmd. Titel, cmd.Author)
      DomainLayer.repository.save buch
    end
  end

end