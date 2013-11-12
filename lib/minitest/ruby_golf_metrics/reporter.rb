require "minitest/ruby_golf_metrics/character_counter"

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
        io.puts "\nRuby Golf Metrics"
        @ergs.sort_by(&:method_name).each do |erg|
          if erg.passed
            begin
              counter = CharacterCounter.new(erg.method_name)
              msg = "  #{colorize(erg.method_name, 32)}: #{counter.cumulative_size} characters"
              msg << " (#{counter.called_method_sizes.join(", ")})" if !counter.self_contained?
              io.puts msg
            rescue NoMethodError
              io.puts "  #{colorize(erg.method_name, 31)}: UNDEFINED"
            end
          else
            io.puts "  #{colorize(erg.method_name, 31)}: FAILED"
          end
        end
      end

      private

      def colorize(text, color)
        options[:nocolor] ? text : "\e[#{color}m#{text}\e[0m"
      end

    end

  end

end
