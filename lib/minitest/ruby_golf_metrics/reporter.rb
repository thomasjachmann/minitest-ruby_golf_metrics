require "sourcify"
require "minitest/method_parser"

module Minitest

  module RubyGolfMetrics

    class Reporter < ::Minitest::Reporter

      Erg = Struct.new(:method_name, :passed)

      class TestMethod
        def initialize(method_name, previous_method_stack = [])
          method_stack = previous_method_stack + [method_name]
          @method_name = method_name
          source = RubyGolf.method(method_name).to_raw_source(strip_enclosure: true)
          @size = source.strip.gsub(/\s+/, "").size
          parser = MethodParser.new(source)
          @children = (RubyGolf.methods(false) - method_stack).map do |method|
            TestMethod.new(method, method_stack) if parser.is_method_called?(method)
          end.compact
        end

        def cumulative_size
          @size + @children.map(&:cumulative_size).inject(0, &:+)
        end

        def self_contained?
          @children.empty?
        end

        def called_method_sizes
          ["#{@method_name}: #{@size}", @children.map(&:called_method_sizes)].flatten.compact
        end
      end

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
              test_method = TestMethod.new(erg.method_name)
              msg = "  #{colorize(erg.method_name, 32)}: #{test_method.cumulative_size} characters"
              msg << " (#{test_method.called_method_sizes.join(", ")})" if !test_method.self_contained?
              io.puts msg
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
