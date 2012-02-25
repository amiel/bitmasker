

module HasBitmaskAttributes
  module Model
    def has_bitmask_attributes(name)
      raise ArgumentError, "You must pass has_bitmask_attributes a block and define attributes." unless block_given?
      config = BitmaskAttributeGenerator.new(name, self)
      yield config
      config.generate
    end

    def value_to_boolean(value)
      if defined? ::ActiveRecord::ConnectionAdapters::Column
        ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
      else
        ['1', 1, 't', 'true', true].include? value
      end
    end
  end
end