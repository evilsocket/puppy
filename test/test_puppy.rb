require 'test/unit'
require_relative '../lib/puppy'

class DummyStream
  attr_reader :data

  def initialize
    @data = ''
  end

  def << ( s )
    @data << s.to_s
  end
end

class TestPuppy < Test::Unit::TestCase
  def setup
    @stream = DummyStream.new
  end

  def test_respond_to_trace
    o = Object.new

    assert o.respond_to? :trace
  end

  def test_single_call
    a = 1.trace :stream => @stream, :caller => false, :indent => false
    a.to_s

    assert_equal "# Fixnum.to_s()\n", @stream.data
  end
  
  def test_trace_as
    a = 1.trace :as => 'a', :stream => @stream, :caller => false, :indent => false
    a.to_s

    assert_equal "# a.to_s()\n", @stream.data
  end  

  def test_conditional_tracing
    a = 1.trace( :stream => @stream, :caller => false, :indent => false ) { |object,method,*args| args.size > 0 }
    a.size
    a.to_s(2)

    assert_equal "# Fixnum.to_s(2)\n", @stream.data
  end

  def test_untrace
    a = 1.trace :stream => @stream, :caller => false, :indent => false
    a.untrace
    a.size
    a.trace

    assert_equal "", @stream.data
  end
end

