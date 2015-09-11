module Bitmasker
  class BitmaskScope
    include ActiveModel::AttributeMethods
    attribute_method_prefix 'with_'
    attribute_method_prefix 'with_any_'
    attribute_method_prefix 'without_'

    class_attribute :model_class
    class_attribute :field_name
    class_attribute :table_name
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
      klass.table_name = model_class.table_name
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
      # TODO: Test lots of databases
      bitmask_query attributes, "#{table_name}.#{field_name} & :mask = :mask"
    end

    def with_any_attribute(_, *attributes)
      # TODO: Test lots of databases
      bitmask_query attributes, "#{table_name}.#{field_name} & :mask <> 0"
    end

    def without_attribute(_, *attributes)
      # TODO: Test lots of databases
      bitmask_query attributes, "#{table_name}.#{field_name} & :mask = 0 OR #{table_name}.#{field_name} IS NULL"
    end

    private

    def bitmask_query(attributes, query)
      mask = bitmask
      mask.set_array(Array.wrap(attributes).flatten.map(&:to_s))

      return null_query if mask.to_i.zero?

      # TODO: Test lots of databases
      model_class.where(query, mask: mask.to_i)
    end

    def null_query
      model_class.where('1 = 0')
    end
  end
end
