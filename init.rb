ActiveRecord::Base.send :extend, BitmaskAttributes

if defined? Formtastic then
	require File.join(Rails.root, *%w(vendor plugins bitmask_attributes lib formtastic_hacks))
	class Formtastic::SemanticFormBuilder
		include BitmaskAttributes::FormtasticHacks
	end
end