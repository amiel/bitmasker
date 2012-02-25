
module HasBitmaskAttributes
  # need to document this
  class BitmaskAttributeGenerator
    def initialize(mask_name, base)
      @base_class = base
      @mask_name = mask_name
      @field_name = mask_name.to_s + '_mask'
      
      @bitmask_attributes = {}
      @bitmask_defaults = {}
      @method_format = '%s'
      
      @use_attr_accessible = false
    end
    
    
    attr_writer :method_format
    # makes the config dsl more consistent, allowing config.method_format '%s' instead of config.method_format = '%s'
    alias_method :method_format, :method_format=
    
    
    attr_writer :field_name
    # makes the config dsl more consistent
    alias_method :field_name, :field_name=

    def attribute(name, mask, default = false)
      @bitmask_attributes[name] = mask
      @bitmask_defaults[name] = true if default
    end
    
    def accessible
      @use_attr_accessible = true
    end
    
    def generate
  		@base_class.logger.error("HasBitmaskAttributes: #{@base_class}##{@mask_name} is expecting a field in your database named #{@field_name}") unless @base_class.new.respond_to? @field_name
  	  
      # must be in local scope to work within define_method
      field_name = @field_name
      mask_name = @mask_name
      
      bitmask_attributes = @bitmask_attributes
      bitmask_defaults = @bitmask_defaults

      var_name = :"@#{mask_name}"
      
      # define composed_of like helper, retrieves Bitmask object for field
      @base_class.send :define_method, mask_name do
        instance_variable_get(var_name) || instance_variable_set(var_name, Bitmask.new(bitmask_attributes, self.read_attribute(field_name) || bitmask_defaults))
      end
      
      @base_class.send :define_method, :"#{mask_name}=" do |to_set|
        send(mask_name).set_array to_set.reject(&:blank?).collect(&:to_sym)
        send("write_#{mask_name}!")
        send(mask_name)
      end

  		@base_class.send :define_method, :"reload_with_#{mask_name}" do
  			instance_variable_set(var_name, nil)
  			send :"reload_without_#{mask_name}"
  		end
  		@base_class.send :alias_method_chain, :reload, mask_name
      
      @base_class.send :define_method, "#{mask_name}_was" do
        var_name = "@#{mask_name}".to_sym
        Bitmask.new(bitmask_attributes, self.send("#{field_name}_was") || bitmask_defaults)
      end
      
      @base_class.send :define_method, "write_#{mask_name}!" do
        send(field_name + '_will_change!') if respond_to?(field_name + '_will_change!')
        write_attribute(field_name, send(mask_name).to_i)
      end
      
      @base_class.send :class_variable_set, "@@#{field_name}", bitmask_attributes
      @base_class.send :class_eval, %(class << self; def #{field_name}; @@#{field_name};end;end)
      
      set_bitmask_attributes_class_variable
      
      @bitmask_attributes.each do |attribute, mask|
        
        method_name_base = @method_format % attribute
        
        @base_class.send :attr_accessible, method_name_base if @use_attr_accessible
        
        # define predicate
        @base_class.send :define_method, method_name_base + '?' do
          send(mask_name).get attribute
        end
        
        # define predicate without ? for actionview::formhelper
        @base_class.send :define_method, method_name_base do
          send(mask_name).get attribute
        end
        
        # define setter
        @base_class.send :define_method, method_name_base + '=' do |value|
          bitmask = send(mask_name)
          bitmask.set attribute, self.class.value_to_boolean(value)
          send("write_#{mask_name}!")
          bitmask.get attribute
        end
        
      end
    end
    
    def set_bitmask_attributes_class_variable
      class_reflection = begin
        @base_class.send :class_variable_get, :"@@bitmask_attributes" || {}
      rescue NameError
        {}
      end
      
      class_reflection[@mask_name] = {
        :attributes => @bitmask_attributes.keys,
        :field_name => @field_name,
        :method_format => @method_format,
      }
      @base_class.send :class_variable_set, :"@@bitmask_attributes", class_reflection
      @base_class.send :class_eval, %(class << self; def bitmask_attributes; @@bitmask_attributes;end;end)
      
    end
  end
end
