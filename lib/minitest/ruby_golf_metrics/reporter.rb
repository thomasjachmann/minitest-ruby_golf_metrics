require "minitest/ruby_golf_metrics/character_counter"

module Minitest

  module RubyGolfMetrics

    class Reporter < ::Minitest::Reporter

      def start
        @ergs = {}
      end

      def record(erg)
        method_definition = erg.location.
          gsub("RubyGolfTest#test_", "").
          gsub(/ .*$/, "").
          gsub(/_[0-9]$/, "").
          gsub(/hole_([0-9]+)_/, "\\2#")
        @ergs[method_definition] ||= []
        @ergs[method_definition] << erg.passed?
      end

      def report
        io.puts "\nRuby Golf Metrics"
        @ergs.sort.each do |method_definition, ergs|
          (hole, method_name) = method_definition.split("#")
          begin
            if ergs.all?
              begin
                counter = CharacterCounter.new(method_name)
                msg = "  #{colorize(hole, method_name, 32)}: #{counter.cumulative_size} character(s)"
                msg << " (#{counter.called_method_sizes.join(", ")})" if !counter.self_contained?
                io.puts msg
              rescue NoMethodError
                io.puts "  #{colorize(hole, method_name, 31)}: UNDEFINED"
              end
            else
              io.puts "  #{colorize(hole, method_name, 31)}: FAILED"
            end
          rescue
            io.puts "  #{colorize(hole, method_name, 31)}: there was an error counting your characters"
          end
        end
      end

      private

      def colorize(hole, method_name, color)
        text = "Hole #{hole} (#{method_name})"
        options[:nocolor] ? text : "\e[#{color}m#{text}\e[0m"
      end

    end

  end

end
