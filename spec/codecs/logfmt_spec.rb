require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/logfmt"
require "logstash/event"
require "logstash/json"
require "insist"

describe LogStash::Codecs::Logfmt do
  subject do
    next LogStash::Codecs::Logfmt.new
  end

  context "#decode" do
    it "should decode valid logfmt data" do
      data = "foo=bar message=baz duration=3.01"
      subject.decode(data) do |event|
        insist { event.is_a? LogStash::Event }
        insist { event["foo"] } == "bar"
        insist { event["message"] } == "baz"
        insist { event["duration"] } == 3.01
      end
    end
    it "should be fast", :performance => true do
      data = "message=foo level=info duration=3.01"
      iterations = 500000
      count = 0
          # Warmup
      10000.times { subject.decode(data) { } }
          start = Time.now
      iterations.times do
        subject.decode(data) do |event|
          count += 1
        end
      end
      duration = Time.now - start
      insist { count } == iterations
      puts "codecs/logfmt rate: #{"%02.0f/sec" % (iterations / duration)}, elapsed: #{duration}s"
    end
    it "falls back to plain text and doesn't crash (LOGSTASH-1595)" do
      blob = (128..255).to_a.pack("C*").force_encoding("ASCII-8BIT")
      subject.decode(blob) do |event|
        puts event
      end
    end
  end
end
