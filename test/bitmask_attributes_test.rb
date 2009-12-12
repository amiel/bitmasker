require 'test/unit'


require 'rubygems'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../lib/bitmask'
require File.dirname(__FILE__) + '/../lib/bitmask_attributes'
require File.dirname(__FILE__) + '/../init'

class MockModel
  
  attr_accessor :dummy_mask
  attr_accessor :another_dummy_mask
  extend ::BitmaskAttributes
  
  def write_attribute(sym, value)
    send "#{sym}=", value
  end
  
  def read_attribute(sym)
    send sym
  end
  
  def reload
    
  end

  cattr_reader :accessible_attrs
  def self.attr_accessible(*args)
    @@accessible_attrs ||= []
    @@accessible_attrs += args
  end

  
  has_bitmask_attributes :dummy do |config|
    config.attribute :does_stuff, 0b0001
    config.attribute :with_default, 0b0010, true
  end
  
  has_bitmask_attributes :another_dummy do |config|
    config.method_format 'this_%s_format'
    config.attribute :attribute_has, 0b001
    config.accessible
  end
  

end


class BitmaskAttributesTest < Test::Unit::TestCase
    
  def test_does_stuff_attribute
    mock = MockModel.new
    assert mock.dummy
    assert !mock.does_stuff?
    mock.does_stuff = true
    assert mock.does_stuff?
  end
  
  def test_default
    mock = MockModel.new
    assert mock.with_default?, "should have a default: mock.dummy_mask is #{mock.dummy_mask.inspect} mock.dummy is #{mock.dummy.inspect}"
    mock.with_default = false
    assert !mock.with_default?, 'setting method after default failed'
  end
  
  def test_method_format
    mock = MockModel.new
    assert !mock.this_attribute_has_format?
    mock.this_attribute_has_format = true
    assert mock.this_attribute_has_format?
  end
  
  def test_predicate_without_?
    mock = MockModel.new
    mock.does_stuff = true
    assert mock.does_stuff
  end
  
  def test_accessible
    mock = MockModel.new
    assert_equal ['this_attribute_has_format'], mock.accessible_attrs
  end
  
  def test_can_access_mask
    assert_equal MockModel.dummy_mask, {:does_stuff => 1, :with_default => 2}
    assert_equal MockModel.another_dummy_mask, {:attribute_has => 1}
  end
  
  def test_array_assignment
    mock = MockModel.new
    mock.dummy = [ 'does_stuff' ]
    assert mock.does_stuff
    assert !mock.with_default
    mock.dummy = [ 'does_stuff', 'with_default' ] # should accept strings
    assert mock.does_stuff
    assert mock.with_default
  end
  
  def test_empty_array_assignment
    mock = MockModel.new
    mock.dummy = []
    assert !mock.does_stuff
    assert !mock.with_default
  end
  
  def test_array_assignment_with_method_format
    mock = MockModel.new
    mock.another_dummy = [ 'attribute_has' ]
    assert mock.this_attribute_has_format
  end
  
  def test_array_assignment_with_empty_strings
    mock = MockModel.new
    mock.dummy = [ '', 'does_stuff' ]
    assert mock.does_stuff
    assert !mock.with_default
  end
  
  # not throwing exception because you can't run migrations when it does
  # def test_raises_without_field
  #   assert_raise ArgumentError do
  #     eval '
  #     class MockModel
  #       extend ::BitmaskAttributes
  #       
  #       has_bitmask_attributes :without_field do |config|
  #         config.attribute :none, 0b001
  #       end
  #     end
  #     '
  #   end
  # end
end
