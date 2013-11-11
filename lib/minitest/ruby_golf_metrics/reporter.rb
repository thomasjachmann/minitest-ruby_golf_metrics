require "sourcify"

module Minitest

  module RubyGolfMetrics

    class Reporter < ::Minitest::Reporter

      Erg = Struct.new(:method_name, :passed)

      def start
        @ergs = []
      end

      def record(erg)
        @ergs << Erg.new(erg.location.gsub("RubyGolfTest#test_", "").gsub(/ .*/, ""), erg.passed?)
      end

      def report
        io.puts "RubyGolf metrics (only non whitespace characters are counted)"
        @ergs.sort_by(&:method_name).each do |erg|
          if erg.passed
            begin
              source = RubyGolf.method(erg.method_name).to_raw_source(strip_enclosure: true)
              size = source.strip.gsub(/\s+/, "").size
              io.puts "  #{colorize(erg.method_name, 32)}: #{size} characters"
            rescue NoMethodError
              io.puts "  #{colorize(erg.method_name, 31)}: UNDEFINED"
            end
          else
            io.puts "  #{colorize(erg.method_name, 31)}: FAILED"
          end
        end
        io.puts
      end

      private

      def colorize(text, color)
        options[:nocolor] ? text : "\e[#{color}m#{text}\e[0m"
      end

    end

  end

end
