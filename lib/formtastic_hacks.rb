module BitmaskAttributes
  module FormtasticHacks
    # def self.included(base)
    #   base.alias_method_chain :default_input_type, :bitmask_attributes
    # end
    # 
    # def default_input_type_with_bitmask_attributes(column)
    #   Bitmask === @object.send(column) ? :bitmask_attributes : default_input_type_without_bitmask_attribute(column)
    # end
    
    def bitmask_attributes_input(method, options)
      methods = @object.send(method).masks.keys
      check_boxes_input(method, options.merge(:collection => methods.collect{|m| [ localized_attribute_string(m, nil, :label) || m.to_s.titleize, m ]}))
    end
  end
end