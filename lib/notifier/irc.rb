require 'rubygems'
require 'integrity' unless defined?(Integrity)
require 'shout-bot'

module Integrity
  class Notifier
    class IRC < Notifier::Base
      attr_reader :uri
      
      def self.to_haml
        <<-HAML
%p.normal
  %label{ :for => 'irc_notifier_uri' } Send to
  %input.text#irc_notifier_uri{ :name => 'notifiers[IRC][uri]', :type => 'text', :value => config['uri'] || 'irc://irc.freenode.net:6667/test' }
        HAML
      end

      def initialize(build, config={})
        @uri = config.delete("uri")
        super
      end

      def deliver!
        ShoutBot.shout(uri, :as => "IntegrityBot") do |channel|
          channel.say "#{build.project.name}: #{short_message}"
          channel.say build_url
        end
      end
    end
  end
end
