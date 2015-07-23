require 'test_helper'

class MockModel

  attr_accessor :dummy_mask
  attr_accessor :another_dummy_mask
  extend Bitmasker::Model

  def self.table_name
    "mock_models"
  end

  def []=(sym, value)
    send "#{ sym }=", value
  end

  def [](sym)
    send sym
  end

  def self.accessible_attrs
    @@accessible_attrs
  end

  def accessible_attrs
    @@accessible_attrs
  end

  def self.attr_accessible(*args)
    @@accessible_attrs ||= []
    @@accessible_attrs += args
  end


  has_bitmask_attributes :dummy do |config|
    config.attribute :does_stuff, 0b0001
    config.attribute :with_default, 0b0010, true
  end

  has_bitmask_attributes :another_dummy do |config|
    config.attribute :an_accessible_attribute, 0b001
    config.accessible
  end

end


class BitmaskAttributesTest < MiniTest::Unit::TestCase

  def test_does_stuff_attribute
    mock = MockModel.new
    assert mock.dummy
    assert !mock.does_stuff?
    mock.does_stuff = true
    assert mock.does_stuff?
  end

  def test_default
    mock = MockModel.new
    assert mock.with_default?, "should have a default: mock.dummy_mask is #{ mock.dummy_mask.inspect } mock.dummy is #{ mock.dummy.inspect }"
    mock.with_default = false
    assert !mock.with_default?, 'setting method after default failed'
  end

  def test_predicate_without_?
    mock = MockModel.new
    mock.does_stuff = true
    assert mock.does_stuff
  end

  def test_accessible
    mock = MockModel.new
    assert_equal [:an_accessible_attribute], mock.accessible_attrs
  end


#  def test_array_assignment
#    mock = MockModel.new
#    mock.dummy = ['does_stuff']
#    assert mock.does_stuff
#    assert !mock.with_default
#    mock.dummy = ['does_stuff', 'with_default'] # should accept strings
#    assert mock.does_stuff
#    assert mock.with_default
#  end

#  def test_empty_array_assignment
#    mock = MockModel.new
#    mock.dummy = []
#    assert !mock.does_stuff
#    assert !mock.with_default
#  end

#  def test_array_assignment_with_empty_strings
#    mock = MockModel.new
#    mock.dummy = ['', 'does_stuff']
#    assert mock.does_stuff
#    assert !mock.with_default
#  end

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
