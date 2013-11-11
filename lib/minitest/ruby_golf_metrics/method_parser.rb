# taken from http://stackoverflow.com/questions/16917902/parsing-ruby-code-for-certain-function-calls
require "ripper"

module Minitest

  module RubyGolfMetrics

    class MethodParser

      def initialize(source)
        @ast = Ripper.sexp(source)
      end

      def is_method_called?(method_name)
        search_ast_for_method(@ast, method_name)
      end

      private

      def is_top_level_method_call(ast, method_name)
        # firstly check if possible command block
        unless ast.is_a?(Array) && ast.length > 1 && ast[1].is_a?(Array)
          return false
        end
        # now check if it is a function call or command, and check the method name
        if [:command, :fcall].include? ast[0]
          ast[1].include?(method_name.to_s)
        else
          false
        end
      end

      def search_ast_for_method(ast, method_name)
        return true if is_top_level_method_call(ast, method_name)
        return false unless ast.is_a? Array
        ast.any? { |e| search_ast_for_method(e, method_name) }
      end

    end

  end

end
