# represents a set of boolean values as an Integer
#
# Examples:
#   masks = {
#           :cat  => 0b001,
#           :dog  => 0b010,
#           :fish => 0b100
#         }
#
#   bitmask = Bitmask.new(masks, {:cat => true})
#   bitmask.to_i            # => 1
#   bitmask.get :cat        # => true
#   bitmask.get :dog        # => false
#   bitmask.set :dog, true
#   bitmask.get :dog        # => true
#   bitmask.to_i            # => 3
#   bitmask.to_h            # => { :cat => true, :dog => true, :fish => false }
#
#   bitmask = Bitmask.new(masks, 0b101)
#   bitmask.to_h            # => { :cat => true, :dog => false, :fish => true }
#   bitmask.to_i            # => 5
#   bitmask.to_i.to_s(2)    # => "101"
#
#   Bitmask.new(masks, 5) == Bitmask.new(masks, { :cat => true, :dog => false, :fish => true }) # => true
class Bitmask

	def ==(other)
		other.masks == @masks && other.to_i == self.to_i
	end

	# create an object with which to manipulate an integer as a set of boolean values
	# 
	# arguments
	# masks::  a Hash where the key is the boolean attribute and the value is the bitmask.
	#             { :some_attribute => 0b0001, :another_attribute => 0b0010 }
	# arg::    can be a Hash or Integer
	def initialize(masks, arg)
		@masks = masks
		case arg
		when Hash
			@data = 0
			arg.each do |attr, value|
				set attr, value
			end
		else
			@data = arg.to_i
		end
	end

	attr_reader :masks

	def to_i; @data end
	
	def to_a
		@masks.keys.sort{|a,b| @masks[a] <=> @masks[b] }.collect{|k| [k, get(k)] }
	end
	
	def to_h
		@masks.keys.inject({}){|h,k| h[k] = get k; h }
	end

	# returns boolean value
	def get(attr)
		(@data & @masks[attr]) == @masks[attr]
	end

	# expects a boolean value
	def set(attr, value)
	  raise ArgumentError, 'unknown attribute' unless @masks[attr]
		case value
		when true
			@data |=  @masks[attr]
		when false
			@data &= ~@masks[attr]
		end
	end
	
	def set_array(array)
    @masks.each do |attr, value|
      set attr, array.include?(attr)
    end
	end
end