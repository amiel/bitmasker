

$: << File.join(File.expand_path('..', __FILE__), 'has_bitmask_attributes')
require 'bitmask'
require 'bitmask_attribute_generator'
require 'model'

require File.expand_path('../has_bitmask_attributes/rails', __FILE__) if defined? ::Rails

