# encoding: utf-8
require "logstash/codecs/base"
require "logfmt"
# Add any asciidoc formatted documentation here
class LogStash::Codecs::Logfmt < LogStash::Codecs::Base

  # This example codec will append a string to the message field
  # of an event, either in the decoding or encoding methods
  #
  # This is only intended to be used as an example.
  #
  # input {
  #   stdin { codec => example }
  # }
  #
  # or
  #
  # output {
  #   stdout { codec => example }
  # }
  config_name "logfmt"

  # Append a string to the message
  #config :append, :validate => :string, :default => ', Hello World!'

  public
  def register
  end

  public
  def decode(data)
    parsed = Logfmt.parse(data)
    yield LogStash::Event.new(parsed)
  end # def decode


end # class LogStash::Codecs::Logfmt
