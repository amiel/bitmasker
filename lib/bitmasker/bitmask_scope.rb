module Bitmasker
  class BitmaskScope

    class_attribute :bitmask_attributes
    class_attribute :model_class
    class_attribute :field_name


    def self.make(model_class, field_name, bitmask_attributes, defaults = {})
      klass = Class.new(self) do
      end

      klass.model_class = model_class
      klass.bitmask_attributes = bitmask_attributes.stringify_keys
      klass.field_name = field_name

      def klass.to_s
        "#{superclass}(#{model_class}##{field_name})"
      end

      klass
    end


  end
end
