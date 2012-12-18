module Bitmasker
  class BitmaskScope
    include ActiveModel::AttributeMethods
    attribute_method_prefix 'with_'

    class_attribute :model_class
    class_attribute :field_name
    class_attribute :mask_name
    class_attribute :bitmask_attributes

    def self.make(model_class, field_name, mask_name, bitmask_attributes)
      klass = Class.new(self) do
        define_attribute_methods [mask_name]

        def self.to_s
          "#{superclass}(#{model_class}##{field_name})"
        end
      end

      klass.model_class = model_class
      klass.field_name = field_name
      klass.mask_name = mask_name
      klass.bitmask_attributes = bitmask_attributes.stringify_keys

      klass
    end

    def initialize
      @bitmask = Bitmask.new(bitmask_attributes, 0)
    end

    # TODO: This (the unused _ attribute) tells me I have the design wrong
    def with_attribute(_, attributes)
      @bitmask.set_array(Array.wrap(attributes).map(&:to_s))
      model_class.where("#{field_name} = #{field_name} & #{@bitmask.to_i}")
    end

  end
end
