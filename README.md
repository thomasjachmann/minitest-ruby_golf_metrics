# Minitest::RubyGolfMetrics

This is a [Minitest](https://github.com/seattlerb/minitest) plugin that can be
used to play [Ruby Golf](http://www.sitepoint.com/ruby-golf/).

It makes some assumptions which make it unusable for you if you don't play the
game by its rules:

* your tasks are tested in the minitest class ```RubyGolfTest```
* the contestants implement their solutions as module methods in the module
  ```RubyGolf```
* the test methods are called test_hole_<x>_<method_name>[_<numeric_suffix>]

That's it.

## Installation

Add this line to your application's Gemfile:

    gem 'minitest-ruby_golf_metrics'

And then execute:

    $ bundle

## Usage

Run your minitests and check your results.

You can provide the parameter --nocolor to prevent the metrics output from being
colorized.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
