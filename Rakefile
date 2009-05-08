task :default => :test

task :test do
  ruby "test/integrity_irc_test.rb"
end

begin
  require "mg"
  MG.new("integrity-irc.gemspec")
rescue LoadError
end
