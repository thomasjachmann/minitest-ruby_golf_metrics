require "method_source"

module Minitest

  class RubyGolfMetricsReporter < Reporter
    Erg = Struct.new(:method_name, :passed)

    def start
      @ergs = []
    end

    def record(erg)
      @ergs << Erg.new(erg.location.gsub("RubyGolfTest#test_", "").gsub(/ .*/, ""), erg.passed?)
    end

    def report
      io.puts "\nRubyGolf metrics (only non whitespace characters are counted)"
      @ergs.sort_by(&:method_name).each do |erg|
        if erg.passed
          begin
            source = RubyGolf.method(erg.method_name).source
            size = source.strip.gsub(" ", "").size
            io.puts "  #{erg.method_name}: #{size} characters"
          rescue NoMethodError
            io.puts "  #{erg.method_name}: UNDEFINED"
          end
        else
          io.puts "  #{erg.method_name}: FAILED"
        end
      end
      io.puts
    end
  end

  def self.plugin_ruby_golf_metrics_init(options)
    self.reporter << RubyGolfMetricsReporter.new(options[:io], options)
  end

end
