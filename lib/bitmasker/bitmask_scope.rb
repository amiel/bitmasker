module Bitmasker
  class BitmaskScope
    include ActiveModel::AttributeMethods
    attribute_method_prefix 'with_'
    attribute_method_prefix 'with_any_'
    attribute_method_prefix 'without_'

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

    def bitmask
      Bitmask.new(bitmask_attributes, 0)
    end

    # REVIEW: This (the unused _ attribute) tells me I have the design wrong
    def with_attribute(_, *attributes)
      mask = bitmask
      mask.set_array(Array.wrap(attributes).flatten.map(&:to_s))

      # TODO: Test lots of databases
      model_class.where("#{field_name} & :mask = :mask", mask: mask.to_i)
    end

    def with_any_attribute(_, *attributes)
      mask = bitmask
      mask.set_array(Array.wrap(attributes).flatten.map(&:to_s))

      model_class.where("#{field_name} & :mask <> 0", mask: mask.to_i)
    end

    def without_attribute(_, *attributes)
      mask = bitmask
      mask.set_array(Array.wrap(attributes).flatten.map(&:to_s))

      # TODO: Test lots of databases
      model_class.where("#{field_name} & :mask = 0 OR #{field_name} IS NULL", mask: mask.to_i)
    end

  end
end
