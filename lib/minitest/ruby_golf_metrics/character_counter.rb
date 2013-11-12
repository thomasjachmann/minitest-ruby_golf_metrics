require "sourcify"
require "minitest/ruby_golf_metrics/method_parser"

module Minitest

  module RubyGolfMetrics

    class CharacterCounter

      def initialize(method_name, previous_method_stack = [])
        @method_name = method_name.to_sym
        method_stack = previous_method_stack + [@method_name]
        source = RubyGolf.method(method_name).to_raw_source(strip_enclosure: true)
        @size = source.strip.gsub(/\s+/, "").size
        parser = MethodParser.new(source)
        @children = (RubyGolf.methods(false) - method_stack).map do |method|
          CharacterCounter.new(method, method_stack) if parser.is_method_called?(method)
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

  end

end
