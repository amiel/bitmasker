module HasBitmaskAttributes
  class Generator
    def initialize(mask_name, model)
      @bitmask_attributes = {}
      @bitmask_defaults = {}

      @model = model
      @mask_name = mask_name
      @field_name = mask_name.to_s + '_mask'

      @use_attr_accessible = false
    end


    attr_writer :method_format
    # makes the config dsl more consistent, allowing `config.method_format '%s'`
    # instead of `config.method_format = '%s'`
    alias_method :method_format, :method_format=


    attr_writer :field_name
    # makes the config dsl more consistent
    alias_method :field_name, :field_name=

    def attribute(name, mask, default = false)
      @bitmask_attributes[name] = mask
      @bitmask_defaults[name] = default
    end

    def accessible
      @use_attr_accessible = true
    end

    def generate
      klass = BitmaskAttributes.make(@model, @field_name, @bitmask_attributes, @bitmask_defaults)

      @model.send :define_method, @mask_name do
        klass.new(self)
      end

      @bitmask_attributes.each do |attribute, mask|
        @model.delegate attribute, "#{attribute}?", "#{attribute}=",
          "#{attribute}_was",
          to: @mask_name

        @model.attr_accessible attribute if @use_attr_accessible
      end
    end

  end
end
