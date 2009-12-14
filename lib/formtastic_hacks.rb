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
      bitmask_attribute_options = @object.class.bitmask_attributes[method.to_sym]
      
      list_item_content = bitmask_attribute_options[:attributes].collect do |attr|
        m = bitmask_attribute_options[:method_format] % attr
        template.content_tag(:li, boolean_input(m, options))
      end
      
      field_set_and_list_wrapping_for_method(method, options, list_item_content)
    end
  end
end