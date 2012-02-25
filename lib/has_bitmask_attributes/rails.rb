

module HasBitmaskAttributes
  class Rails < ::Rails::Engine
    config.after_initialize do
      ActiveRecord::Base.send :extend, HasBitmaskAttributes::ActiveRecord
    end
  end
end
