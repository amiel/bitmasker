# need to document this
class BitmaskAttributeGenerator
  def initialize(mask_name, base)
    @base_class = base
    @mask_name = mask_name
    @field_name = mask_name.to_s + '_mask'
    # need to make this check, but it doesn't work here
    # raise ArgumentError, "please add a field in your database named #{@field_name}" unless @base_class.new.respond_to? @field_name
    
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
    
    # must be in local scope to work within define_method
    field_name = @field_name
    mask_name = @mask_name
    
    bitmask_attributes = @bitmask_attributes
    bitmask_defaults = @bitmask_defaults
    
    # define composed_of like helper, retrieves Bitmask object for field
    @base_class.send :define_method, mask_name do
      var_name = "@#{mask_name}".to_sym
      instance_variable_get(var_name) || instance_variable_set(var_name, Bitmask.new(bitmask_attributes, self.read_attribute(field_name) || bitmask_defaults))
    end
    
    @base_class.send :define_method, "#{mask_name}_was" do
      var_name = "@#{mask_name}".to_sym
      Bitmask.new(bitmask_attributes, self.send("#{field_name}_was") || bitmask_defaults)
    end
    
    @base_class.send :class_variable_set, "@@#{field_name}", bitmask_attributes
    @base_class.send :class_eval, %(class << self; def #{field_name}; @@#{field_name};end;end)
    
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
        bitmask.set attribute, ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
        send(field_name + '_will_change!') unless send(field_name + '_changed?')
        self.write_attribute(field_name, bitmask.to_i)
        bitmask.get attribute
      end
      
    end
  end
end

