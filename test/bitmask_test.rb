require 'test/unit'
# require '../lib/bitmask'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../lib/bitmask'

class BitmaskTest < Test::Unit::TestCase
  TEST_MASKS = {
    :phone    => 0b0000001,
    :name     => 0b0000010,
    :gender   => 0b0000100,
    :email    => 0b0001000,
    :birthday => 0b0100000,
    :location => 0b1000000,
  }
  # Replace this with your real tests.
  def test_get
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert bitmask.get(:phone)
    assert bitmask.get(:name)
    assert bitmask.get(:email)
    assert !bitmask.get(:gender)
    assert !bitmask.get(:birthday)
    assert !bitmask.get(:location)
  end
  
  def test_set
    bitmask = Bitmask.new TEST_MASKS, 0
    assert !bitmask.get(:phone)
    bitmask.set(:phone, true)
    assert bitmask.get(:phone)
    assert !bitmask.get(:email)
    bitmask.set(:email, true)
    assert bitmask.get(:email)
  end
  
  def test_to_h
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert_equal({:phone => true, :name => true, :email => true, :gender => false, :birthday => false, :location => false}, bitmask.to_h)
  end
  
  def test_to_a
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    assert_equal([
      [:phone,     true ],
      [:name,      true ],
      [:gender,    false],
      [:email,     true ],
      [:birthday,  false],
      [:location,  false]
    ], bitmask.to_a)
  end
  
  def test_defaults
    bitmask = Bitmask.new(TEST_MASKS, nil || {:phone => true, :email => true})
    assert  bitmask.get(:phone)
    assert !bitmask.get(:name)
    assert  bitmask.get(:email)
    assert !bitmask.get(:gender)
    assert !bitmask.get(:birthday)
    assert !bitmask.get(:location)
  end
  
  def test_to_i_and_create_from_integer
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_two = Bitmask.new(TEST_MASKS, bitmask.to_i)
    assert_equal(bitmask_two.to_h, {:phone => true, :name => true, :email => true, :gender => false, :birthday => false, :location => false})
  end
  
  def test_equality
    bitmask_one   = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_two   = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => true
    bitmask_three = Bitmask.new TEST_MASKS, :phone => true, :name => true, :email => false
    assert bitmask_one == bitmask_two
    assert bitmask_two != bitmask_three
  end
  
  def test_set_array
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true
    bitmask.set_array [:phone, :email]
    assert_equal(bitmask.to_h, {:phone => true, :name => false, :email => true, :gender => false, :birthday => false, :location => false})
  end
  
  def test_set_raises
    bitmask = Bitmask.new TEST_MASKS, 0
    assert_raises ArgumentError do
      bitmask.set :foo, true
    end
  end
  
  def test_set_array_doesnt_raise
    bitmask = Bitmask.new TEST_MASKS, :phone => true, :name => true
    assert_nothing_raised do
      bitmask.set_array [:phone, :email, :foodebar]
    end
    assert_equal(bitmask.to_h, {:phone => true, :name => false, :email => true, :gender => false, :birthday => false, :location => false})
  end
end
