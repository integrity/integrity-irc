require "test/unit"
require "rr"
require "integrity/notifier/test"

begin
  require "redgreen"
rescue LoadError
end

require File.dirname(__FILE__) + "/../lib/integrity/notifier/irc"

class IntegrityIRCTest < Test::Unit::TestCase
  include RR::Adapters::TestUnit
  include Integrity::Notifier::Test

  def setup
    setup_database
    @options = { "uri" => "irc://irc.freenode.net/integrity" }
  end

  def notifier
    "IRC"
  end

  def test_configuration_form
    assert provides_option?("uri", @options["uri"])
  end

  def test_send_notification
    stub(ShoutBot).shout(@options["uri"]) { nil }
    Integrity::Notifier::IRC.new(Integrity::Commit.gen, @options).deliver!
  end

  def test_short_message
    build = Integrity::Commit.gen(:successful)
    assert Integrity::Notifier::IRC.new(build, @options.dup).short_message.
      include?("successful")

    build = Integrity::Commit.gen(:failed)
    assert Integrity::Notifier::IRC.new(build, @options.dup).short_message.
      include?("failed")
  end
end
