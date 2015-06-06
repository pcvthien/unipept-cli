require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'minitest'
require 'minitest/autorun'

module Unipept
  class TestCase < Minitest::Test
    def setup
      @orig_io = capture_io
    end

    def teardown
      uncapture_io(*@orig_io)
    end

    def capture_io_with_input(input, &block)
      capture_io_while do
        input = input.join("\n") if input.is_a? Array
        $stdin.write(input)
        $stdin.rewind
        block.call
      end
    end

    def capture_io_while(&block)
      orig_io = capture_io
      block.call
      [$stdout.string, $stderr.string]
    ensure
      uncapture_io(*orig_io)
    end

    def lines(string)
      string.scan(/^.*\n/).map(&:chomp)
    end

    private

    def capture_io
      orig_stdout = $stdout
      orig_stderr = $stderr
      orig_stdin = $stdin

      $stdout = StringIO.new
      $stderr = StringIO.new
      $stdin = StringIO.new

      [orig_stdout, orig_stderr, orig_stdin]
    end

    def uncapture_io(orig_stdout, orig_stderr, orig_stdin)
      $stdout = orig_stdout
      $stderr = orig_stderr
      $stdin = orig_stdin
    end
  end
end

# Unexpected system exit is unexpected
::MiniTest::Unit::TestCase::PASSTHROUGH_EXCEPTIONS.delete(SystemExit)
