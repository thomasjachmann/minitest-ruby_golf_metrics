require "minitest/ruby_golf_metrics"

module Minitest

  def self.plugin_ruby_golf_metrics_options(opts, options)
    opts.on "--nocolor", "Report metrics without color" do
      options[:nocolor] = true
    end
  end

  def self.plugin_ruby_golf_metrics_init(options)
    self.reporter << RubyGolfMetrics::Reporter.new(options[:io], options)
  end

end
