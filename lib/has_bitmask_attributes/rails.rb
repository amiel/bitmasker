
module HasBitmaskAttributes
  class Railtie < ::Rails::Railtie
    initializer 'has_bitmask_attribtes.activerecord_extensions' do |app|
      ActiveRecord::Base.send :extend, HasBitmaskAttributes::Model
    end
  end
end
